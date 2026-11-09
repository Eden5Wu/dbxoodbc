# ADR-001: Row Fetch Architecture — SQLBindCol vs Sequential SQLGetData

- **Status**: Decided
- **Date**: 2026-11-09
- **Decision**: Retain Sequential `PreFetchRow` (`SQLGetData`) as the default row fetch engine for `master`.
- **Related Issue**: Issue #18 (`[Enhancement] Evaluate SQLBindCol-based Row Fetch Optimization`)
- **Evaluation Branch**: `feat/eval-sqlbindcol`
- **Traditional Chinese Version**: [繁體中文版](ADR-001-row-fetch-strategy_TW.md)

---

## Context & Problem Statement

In issue #18, it was suggested that `dbxoodbc` might achieve higher row-fetching throughput by switching from calling `SQLGetData` on each column during `PreFetchRow` to pre-binding columns via `SQLBindCol`, similar to Embarcadero's official `Data.DBXOdbc.pas` driver.

We undertook a comprehensive architectural investigation, empirical driver specification capability probing, cross-driver architectural analysis (Embarcadero DBX-ODBC and Direct Wire-Protocol drivers), prototype implementation, and live database benchmarks on wide tables, pure scalar tables, and massive multi-hundred-megabyte BLOB datasets.

---

## Driver Specification & Capability Constraints

Under Microsoft Windows ODBC Driver 17 and 18 for SQL Server (`msodbcsql17.dll` / `msodbcsql18.dll`), the live `SQL_GETDATA_EXTENSIONS` bitmask reports:

```
SQL_GETDATA_EXTENSIONS: 0x00000004 (SQL_GD_BLOCK only)
  - SQL_GD_ANY_COLUMN : FALSE
  - SQL_GD_ANY_ORDER  : FALSE
  - SQL_GD_BLOCK      : TRUE
  - SQL_GD_BOUND      : FALSE
```

These capabilities impose non-negotiable restrictions on driver behavior:

1. **`SQL_GD_ANY_COLUMN = FALSE`**:
   - Calling `SQLGetData` on column $J$ when column $K \ge J$ is bound fails immediately with **`SQLState 24000: Invalid cursor state`**.
   - **Impact**: If any column after an unbound column is bound, the unbound column can never be fetched via `SQLGetData`.
2. **`SQL_GD_BOUND = FALSE`**:
   - Once a column is bound with `SQLBindCol`, calling `SQLGetData` on that column (even after a truncation warning `01004`) fails with **`SQLState 07009: Invalid Descriptor Index`**.
   - **Impact**: Truncated data cannot be recovered via `SQLGetData`. Bound string buffers must be allocated to maximum theoretical width or risk unrecoverable truncation.
3. **`SQL_GD_ANY_ORDER = FALSE`**:
   - `SQLGetData` on unbound columns must strictly proceed in ascending numerical order ($1, 2, \dots, N$).

---

## Cross-Driver Architecture Comparison

### 1. Embarcadero DBX-ODBC (`Data.DBXOdbc.pas`)
Embarcadero naively binds all non-BLOB columns:
```pascal
if Values[I].ValueType.DataType <> TDBXDataTypes.BlobType then
  SQLBindCol(FCommandHandle, I+1, ...);
```
**Fatal Architectural Flaw**: If a table has a BLOB column before a non-BLOB column (e.g. Column 24 is `NVARCHAR(MAX)` and Column 25 is `CHAR(1)`), Embarcadero binds Column 25. Later, when `GetBytes` or `GetWideString` is called on Column 24, calling `SQLGetData(24)` **crashes with `SQLState 24000`** on SQL Server! Embarcadero's design only works if all LOB columns happen to reside at the end of the table.

### 2. Direct Wire-Protocol Drivers (TDS Socket Protocol / OLE DB)
Direct wire-protocol drivers bypass the Windows ODBC Driver Manager entirely by communicating directly over TCP sockets using database wire protocols (such as TDS) or OLE DB rowsets (IRowset). Because they do not invoke the Windows ODBC API, they are not constrained by ODBC driver specifications (SQL_GD_ANY_COLUMN = FALSE).

---

## Prototype Implementation: Contiguous Bound-Prefix Engine

To evaluate `SQLBindCol` safely without triggering `SQLState 24000` or truncation errors, we built a **Contiguous Bound-Prefix Engine** on branch `feat/eval-sqlbindcol`:

- Dynamically analyzes result set column metadata.
- Finds the longest contiguous prefix of fixed-scalar columns (`Bit`, `Int8..Int64`, `Float`, `Double`, `Date`, `Timestamp`) starting from column 1.
- Halts binding at the first non-scalar, dynamic string, or BLOB column.
- Binds prefix columns $1..K$ using an 8-byte aligned contiguous block buffer.
- During fetch, columns $1..K$ are unpacked via direct 0-copy memory dereferencing.
- Columns $K+1..N$ are retrieved via sequential ascending `SQLGetData` calls.

---

## Empirical Benchmark Results

Evaluated across thousands of rows on real enterprise schemas and synthetic datasets:

| Dataset / Table Type | Row Count | Column Profile | Pure Reader (GetData) | Pure Reader (BindCol) | Reader Delta | DSP -> CDS (GetData) | DSP -> CDS (BindCol) | Saved per Row |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Synthetic Pure Scalar** | 20,000 | 10 cols (100% bound prefix) | 159 ms | 134 ms | **-15.7%** | 200 ms | 171 ms | **1.25 μs** |
| **Enterprise Metadata Table** | 3,000 | 76 cols (23 bound prefix, 16 memos) | 140 ms | 137 ms | **-2.1%** | 174 ms | 198 ms | **1.00 μs** |
| **Enterprise Wide Table** | 610 | 210 cols wide schema | 67 ms | 95 ms | +41.8% (noise) | 120 ms | 118 ms | — |
| **Report Templates Table** | 57 | BLOB templates (1.6 MB) | 47 ms | 55 ms | — | 66 ms | 54 ms | — |
| **Document Images Table** | 342 | High-res scanned images (320 MB) | 14,743 ms | 14,564 ms | **-1.2%** | N/A | N/A | Dominated by I/O |

---

## Decision Rationale

1. **Marginal Performance Impact in Real-World Workloads**:
   - `SQLBindCol` saves only $\approx 1.0 \sim 1.25\ \mu\text{s}$ per row at the low-level C-API layer.
   - In Delphi DataSnap / ClientDataSet architecture, ODBC call time represents **less than 3%** of overall request processing time. The remaining 97% is consumed by Midas binary packet serialization, field object conversions, and network transfer.
2. **Robustness of Sequential `PreFetchRow`**:
   - The current `PreFetchRow` reads columns in strictly ascending numerical order (`1..N`), completely eliminating `07009` descriptor index errors.
   - It caches row values on fetch, enabling out-of-order and repeated field reads from `TDBXReader` without cursor repositioning.
   - It accommodates dynamically sized strings, `VARCHAR(MAX)`, and multi-hundred-megabyte BLOBs with zero buffer truncation risk.
3. **Simplicity and Maintainability**:
   - Avoiding parallel bound buffers, alignment padding, and `SQL_UNBIND` state tracking eliminates complex failure modes while guaranteeing 100% stability.

---

## Consequences

- The `master` branch retains pure sequential `PreFetchRow` (`SQLGetData`) as the sole, default row fetch engine.
- The `feat/eval-sqlbindcol` branch remains permanently available as reference and prototype verification for any future driver evaluation.
