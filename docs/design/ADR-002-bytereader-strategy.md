# ADR-002: Field Value Transfer & Specialized ByteReader Strategy

- **Status**: Decided
- **Date**: 2026-11-10
- **Decision**: Retain Delphi's default `TDBXReaderByteReader` in `master` without overriding a specialized ByteReader.
- **Related Evaluation**: Architecture Evaluation: Native ByteReader Zero-Copy Field Blit (`feat/native-byte-reader`)
- **Prototype Branch**: `feat/native-byte-reader`
- **Traditional Chinese Version**: [繁體中文版](ADR-002-bytereader-strategy_TW.md)

---

## Context & Problem Statement

In Delphi's dbExpress (DBX4) architecture, when data is transferred from the driver layer (`TDBXReader`) to the upper dataset (`TCustomSQLDataSet.GetFieldData`) or DataSnap packets (`TDataSetProvider`), it utilizes a `TDBXByteReader` obtained via `TDBXReader.GetByteReader` for binary field filling.

Analysis of Delphi's default RTL implementation (`Data.DBXCommon.pas`, line 15147, `TDBXReaderByteReader.GetWideString`) revealed that Embarcadero utilizes a character-by-character `while` loop (`while Count > 0 do`) to copy UTF-16 code units into the destination buffer:

```pascal
while Count > 0 do
begin
  Ch := WideStringValue.Chars[Index div 2];
  Value[Index] := Byte(Ch);
  Inc(Index);
  Value[Index] := Byte(Integer(Ch) shr 8);
  Inc(Index);
  Dec(Count);
end;
```

A hypothesis was formulated: Could implementing a dedicated `TDBXOpenOdbcByteReader` that overrides `GetWideString` with a single block copy (`System.Move`) alongside robust capacity and boundary validation yield significant throughput improvements for string-heavy workloads and `ClientDataSet.Open`?

---

## Prototype Design & Defensive Boundaries

On the prototype evaluation branch `feat/native-byte-reader`, driver modifications were strictly confined to `DbxOpenOdbcDriver.pas` (a net change of only 71 lines compared to `master`), leaving the underlying connection and ODBC protocol untouched:

1. **Inheritance & Focused Override**:
   `TDBXOpenOdbcByteReader` inherited from Delphi's `TDBXReaderByteReader`, overriding **only `GetWideString`**. ANSI, integers, floating-point, BCD, date/time, and large BLOB streams remained 100% on Delphi's default code paths.
2. **Single Block Move**:
   After resolving string length and UTF-16 byte size, data was copied via `System.Move(Pointer(WideStringValue)^, Value[Offset], StrBytes)`, followed by appending the UTF-16 null terminator (`#0#0`).
3. **Strict Boundary Defense**:
   * Validated destination offset (`Offset < 0` or `Offset > BufLen`).
   * Validated remaining capacity, throwing explicit `ERangeError` to prevent buffer overruns, silent truncation, or writing partial UTF-16 code units.

---

## Correctness & Sanitized Verification Results

To guarantee zero regressions, an automated full-data digest comparison and cross-system validation suite was executed. All test datasets were de-identified and sanitized:

| Verification Item | Target & Methodology | Result | Description |
| :--- | :--- | :---: | :--- |
| **Boundary Defenses** | Odd capacity, exact capacity, 0/1 byte capacity, negative offset, NULL, empty string | **PASS** | Buffer overruns strictly rejected with standard `ERangeError` |
| **BLOB Sensitivity Proof** | Two equal-length (1024 bytes) streams differing by 1 bit at offset 512 | **PASS** | Verified SHA-256 sensitivity to micro-content differences |
| **Full Data Field Digest** | Synthetic scalars, system settings table, report templates, media document table | **PASS** | **33,398 digest rows 100% identical bit-for-bit** (Digest file SHA-256 matched) |
| **Media Image Integrity** | 341 high-resolution images (total 319.5 MB) in media document table | **PASS** | Image byte sizes and SHA-256 matched 100% between `TSQLQuery` and `ClientDataSet` |
| **Database Cross-Check** | Sample first 8,000 bytes compared against SQL Server 2014 native `HASHBYTES` | **PASS** | Delphi SHA-256 matched SQL Server native calculation 100% |

All executed data and boundary tests passed successfully, confirming logical equivalence and zero memory safety violations.

---

## Empirical Benchmark Performance

Under a live Microsoft SQL Server environment with RAD Studio Delphi 11/12 (Win32) client, alternating paired benchmarks (Base-first vs Uni-first) were conducted across 4 rounds to eliminate server cache bias:

### 1. System Parameters Table `ClientDataSet.Open` (3,000 rows)
* **Baseline (`master` default RTL)**:
  * Raw samples: `160.0 ms`, `168.0 ms`, `183.0 ms`, `162.0 ms`
  * **Median: 165.0 ms** (Range: 160.0 ~ 183.0 ms, Jitter: 23.0 ms)
* **Unicode Optimized (`feat/native-byte-reader`)**:
  * Raw samples: `193.0 ms`, `177.0 ms`, `178.0 ms`, `191.0 ms`
  * **Median: 184.5 ms** (Range: 177.0 ~ 193.0 ms, Jitter: 16.0 ms)
* **Difference**: Median was slower by **19.5 ms (+11.8%)**.

### 2. Media Document Table `ClientDataSet.Open` (342 rows, loading 319.5 MB images)
* **Baseline (`master` default RTL)**:
  * Raw samples: `14,882.0 ms`, `15,906.0 ms`, `15,666.0 ms`, `15,677.0 ms`
  * **Median: 15,671.5 ms** (Range: 14,882.0 ~ 15,906.0 ms, Jitter: 1,024.0 ms)
* **Unicode Optimized (`feat/native-byte-reader`)**:
  * Raw samples: `15,475.0 ms`, `14,200.0 ms`, `17,857.0 ms`, `16,625.0 ms`
  * **Median: 16,050.0 ms** (Range: 14,200.0 ~ 17,857.0 ms, Jitter: 3,657.0 ms)
* **Difference**: Median was slower by **378.5 ms (+2.4%)**.

---

## Mechanism Analysis & Decision Rationale

1. **Microarchitectural Overhead of Short Strings**:
   * In typical enterprise database schemas, the vast majority of string columns (codes, IDs, names, status, dates) fall within **5 to 30 characters**.
   * For short strings, Delphi's CPU-register `while` loop is highly optimized by branch predictors and L1 instruction cache.
   * A custom implementation invoking `System.Move` must compute array length, perform offset arithmetic, execute defensive branch checks, and bear the call and alignment setup overhead of `System.Move`. On short strings, this overhead negates any memory block transfer benefits, resulting in minor regressions.
2. **Overall Latency Bottleneck Lies Outside Field Copying**:
   * `ClientDataSet.Open` is a composite pipeline consisting of database execution, TDS network transmission, `TDataSetProvider` serialization, and `midas.dll` in-memory C++ tree node allocation and B-Tree indexing.
   * Field string binary transfer constitutes an insignificant fraction of total elapsed time; micro-optimizations here cannot noticeably move macro application throughput.
3. **Failure to Reproduce Performance Gains**:
   * The latest paired measurements consistently registered slower timings, and earlier runs exhibited high variance without reproducible gains.
   * An optimization whose intended performance benefit cannot be reliably reproduced should not be merged into core.

---

## Consequences & Final Decision

- **`master` Decision**: Retain Delphi's default `TDBXReaderByteReader`. Zero wrapper overhead, zero maintenance cost, and optimal performance under normal access patterns.
- **Branch Disposition**: The `feat/native-byte-reader` branch is permanently preserved as a reference prototype, benchmark suite archive (`benchmarks/`), and empirical evidence base for this architectural decision.
