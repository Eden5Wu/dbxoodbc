# Delphi Data Access Benchmark (2026 Edition)
## Comparative Evaluation of Five Engines: DBXOODBC, FireDAC, ADO, EMBT DBX SNC, and EMBT DBX ODBC

- **Date**: November 2026
- **Test Environment**:
  - Compiler: Embarcadero Delphi 11.3 (Alexandria) Win32 Release (`dcc32`, Optimization On)
  - Target Database Engine: Microsoft SQL Server (Enterprise Production Node)
  - Network Fabric: Dedicated Gigabit Enterprise Local Area Network
  - Operating System: Windows 10 Enterprise x64 / Windows Server

---

## Executive Summary

For over two decades, the evolution of Delphi data access technology has been shaped by shifts in database drivers, architectural paradigms, and operational requirements. In 2002, Borland introduced **dbExpress (DBX)** with the vision of replacing heavy, stateful, COM-based OLE DB/ADO drivers with ultra-lightweight, unidirectional cursors. Over subsequent releases, original driver implementations accumulated significant architectural debt—ranging from deferred LOB network round-trips to deprecated client library dependencies (`sqlncli11.dll`).

This benchmark provides a rigorous, anonymized empirical evaluation of five prominent Delphi data access engines connecting to Microsoft SQL Server:
1. **DBXOODBC** (DbxOpenOdbc v4.2026, DBX4 Native Architecture)
2. **FireDAC** (`FireDAC.Phys.MSSQL`, Microsoft ODBC Driver 17)
3. **ADO / dbGo** (`Data.Win.ADODB`, Microsoft OLE DB Provider `SQLOLEDB`)
4. **EMBT DBX SNC** (Embarcadero Native DBX MSSQL via SQL Native Client 11, `sqlncli11.dll`)
5. **EMBT DBX ODBC** (Embarcadero Official Generic DBX ODBC, `Data.DBXOdbc`)

---

## Master Comparison Matrix (Overall Evaluation)

The following master matrix synthesizes empirical performance metrics, architectural traits, operational trade-offs, and deployment requirements across all five engines:

| Dimension / Criterion | DBXOODBC (DBX4 Native) | FireDAC (PhysMSSQL) | ADO (dbGo / OLEDB) | EMBT DBX (MSSQL / SNC) | EMBT DBX (ODBC Generic) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Core Architecture** | Pure Pascal DBX4 Driver | Modern Phys Array Engine | Windows COM / OLE DB | Legacy DBX3/4 DLL Wrapper | Stock DBX4 ODBC Driver |
| **Scalar Read Throughput** | Good (150.7 ms, 33k rows/s) | **Best** (85.3 ms, 58k rows/s) | Poor (551.3 ms, 9k rows/s) | **Fastest** (28.0 ms, 178k rows/s) | Moderate (269.0 ms, 18k rows/s) |
| **Multi-Memo / LOB Resilience** | **Resilient** (155.7 ms, inline) | **Fast** (87.0 ms, inline) | Moderate (335.7 ms, inline) | ❌ **Collapsed** (4,182.7 ms, N+1 round-trips) | Moderate (245.3 ms, inline) |
| **Ultra-Wide Table (>200 cols)** | Stable (82.3 ms) | **Fastest** (40.7 ms) | Slow (201.3 ms) | Fast (70.7 ms) | ❌ **Crashed** (`Invalid cursor position`) |
| **BLOB Binary Streaming** | Stable (39.3 ms) | Fast (36.7 ms) | **Fastest** (16.7 ms) | **Fastest** (14.7 ms) | ❌ **Crashed** (`Invalid cursor position`) |
| **DataSnap Serialization (DSP $\rightarrow$ CDS)** | **Near-Parity** (141.7 ms) | **Fastest** (87.7 ms) | Slow (316.7 ms) | ❌ **Unusable** (4,837.7 ms, severe stall) | Moderate (226.3 ms) |
| **Working Set Memory Footprint** | 🥇 **Lowest** (15.9 ~ 29.1 MB) | Low (18.1 ~ 27.8 MB) | Heavy (23.0 ~ 27.9 MB, COM overhead) | Moderate (25.7 ~ 27.5 MB) | Moderate (26.0 ~ 28.9 MB) |
| **Legacy DBX Drop-in Migration** | 🥇 **Zero Cost** (100% in-place replacement) | ❌ **Extremely High** (Full project rewrite to TFD*) | ❌ **Extremely High** (Full project rewrite to TADO*) | Baseline (Existing codebase state) | High (Requires connection rework) |
| **Deployment Footprint** | 🥇 **Zero External DLLs** (3 Pascal source units) | Embedded Delphi units (No DLLs) | Windows system COM libraries | Requires `dbxmss.dll` + `sqlncli11.msi` | Requires `dbxoodbc.dll` / package loader |
| **Modern Protocol Support (TLS 1.3 / Modern SQL)** | 🥇 **Full** (Direct Microsoft ODBC 17/18) | 🥇 **Full** (Direct Microsoft ODBC 17/18) | ⚠️ **Restricted** (SQLOLEDB is deprecated) | ❌ **Obsolete** (sqlncli11 unsupported by Microsoft) | ⚠️ **Unstable** (ODBC 17 bindings break on wide tables) |
| **Cross-Platform Portability** | ⚠️ **Windows-Centric** (odbc32.dll; POSIX unverified) | 🥇 **Full Tier-1** (Win, Linux, macOS, iOS, Android) | ❌ **Windows-Only** (Bound to Windows COM) | ❌ **Windows-Only** (Bound to Win32 DLLs) | ⚠️ **Theoretical** (POSIX unixODBC fragile in DBX) |
| **Licensing & Acquisition Cost** | 🥇 **Open Source (LGPL)** | Requires Delphi Enterprise / Architect | Included with Delphi / Windows | Included with Delphi (Deprecated) | Included with Delphi |
| **Production Readiness Verdict** | **Highly Recommended** for legacy DBX modernization | **Highly Recommended** for greenfield projects | **Not Recommended** (Legacy maintenance only) | ❌ **Dangerous** (LOB trap & deprecated vendor DLL) | ❌ **Unfit for Production** (Cursor crash on wide/blob tables) |

---

## Detailed Benchmark Methodology & Test Scenarios

To ensure fairness, repeatability, and real-world applicability:
- All database names, schema identifiers, table names, and user credentials have been completely **anonymized**.
- Each test scenario was executed with a warm-up pass followed by 3 consecutive recorded iterations. Reported execution times represent the arithmetic mean across recorded iterations.
- Process working set memory was captured at the end of each test cycle using the Win32 `GetProcessMemoryInfo` API.

> [!IMPORTANT]
> **Methodology Note: Long-Lived Connection Baseline**
> 1. **Timing Scope**: This benchmark (`BenchDataEngines.dpr`) measures pure data extraction, type conversion, and memory throughput over an established connection. The stopwatch measures exclusively from `DS.Open` until all rows are traversed via `DS.Next` (`DS.Eof`), **strictly excluding physical connection setup costs (TCP 3-way handshake, TLS/SSL negotiation, and SQL authentication)**.
> 2. **Connection Lifecycle**: All five evaluated engines (including FireDAC and DBXOODBC) established their physical connection once during test harness initialization and remained `Connected := True` throughout all test iterations.
> 3. **Stateless Service Architecture Considerations**: In stateless WebService, SOAP, or DataSnap architectures where each HTTP request follows a "Connect -> Query -> Disconnect" lifecycle, each request without connection pooling incurs a 20–50 ms physical handshake penalty. Note that **FireDAC does NOT enable connection pooling by default (`Pooled=False`)**; application-level pooling must be explicitly configured. In the DBX architecture, `dbx4odbc` provides native connection pooling (see ADR-003) to achieve equivalent microsecond-level handle reuse.

---

### Scenario 1: Synthetic Scalar Benchmark (5,000 Rows $\times$ 10 Scalar Columns)

- **Workload Profile**: High-throughput numeric and temporal column reads without LOB data. Columns include `INTEGER`, `BIGINT`, `FLOAT`, `MONEY`, `DATETIME`, `CHAR(1)`, `VARCHAR(50)`, `BIT`, and `SMALLINT`.
- **Query Structure**: Synthetic Cartesian query generating 5,000 normalized scalar rows.

#### Results:
| Engine | Execution Time (ms) | Throughput (Rows/sec) | Latency per Row ($\mu$s) | Peak Memory (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 Native)** | 150.7 ms | 33,186 | 30.13 $\mu$s | **15.9 MB** (Lowest) |
| **FireDAC (PhysMSSQL)** | 85.3 ms | 58,594 | 17.07 $\mu$s | 18.1 MB |
| **ADO (dbGo / OLEDB)** | 551.3 ms | 9,069 | 110.27 $\mu$s | 23.0 MB |
| **EMBT DBX (MSSQL / SNC)** | **28.0 ms** | 178,571 | 5.60 $\mu$s | 25.7 MB |
| **EMBT DBX (ODBC Generic)** | 269.0 ms | 18,587 | 53.80 $\mu$s | 26.0 MB |

#### Architectural Analysis:
- **EMBT SNC** achieved exceptional throughput (28 ms) on pure scalar data because the vendor library (`sqlncli11.dll`) interacts directly with SQL Server's TDS stream via pre-allocated buffers.
- **FireDAC** demonstrated superior performance among general-purpose engines (85.3 ms) through its block cursor row array fetching (`RowsetSize`).
- **DBXOODBC** clocked at 150.7 ms with an exceptionally light memory footprint (**15.9 MB**, 38% lower than EMBT SNC).
- **EMBT DBX ODBC** exhibited significant overhead (269.0 ms), trailing DBXOODBC by 78%.
- **ADO** suffered heavy COM dispatch and Variant allocation penalties (551.3 ms, 3.6x slower than DBXOODBC).

---

### Scenario 2: Wide Master Table with Multiple LOB Columns (3,000 Rows $\times$ 76 Columns, 16 Memo Fields)

- **Workload Profile**: Standard enterprise master transaction table containing 76 mixed columns, of which 16 columns are variable-length text/memo fields.
- **Volume**: 3,000 records.

#### Results:
| Engine | Execution Time (ms) | Throughput (Rows/sec) | Latency per Row ($\mu$s) | Peak Memory (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 Native)** | 155.7 ms | 19,272 | 51.89 $\mu$s | **26.2 MB** |
| **FireDAC (PhysMSSQL)** | **87.0 ms** | 34,483 | 29.00 $\mu$s | 26.8 MB |
| **ADO (dbGo / OLEDB)** | 335.7 ms | 8,937 | 111.89 $\mu$s | 26.5 MB |
| **EMBT DBX (MSSQL / SNC)** | ❌ **4,182.7 ms** | 717 | 1,394.22 $\mu$s | 26.5 MB |
| **EMBT DBX (ODBC Generic)** | 245.3 ms | 12,228 | 81.78 $\mu$s | 26.6 MB |

#### Architectural Analysis:
- **The EMBT DBX SNC Disaster**: When encountering multiple Memo columns, EMBT SNC collapsed from 28 ms to **4,182.7 ms** (a **27x performance degradation**). The root cause is its legacy architecture: instead of streaming LOB data inline, it defers memo retrieval using `TEXTPTR` queries, generating $3,000 \times 16 = 48,000$ individual round-trips across the network.
- **DBXOODBC Immunity**: By leveraging Microsoft ODBC Driver 17 with inline column reads, DBXOODBC completed all 3,000 rows in **155.7 ms**—**26 times faster than EMBT SNC**.
- **EMBT DBX ODBC**: Completed in 245.3 ms, avoiding the LOB deferred fetching trap, but still 57% slower than DBXOODBC.

---

### Scenario 3: Ultra-Wide Scalar Table (610 Rows $\times$ 210 Scalar Columns)

- **Workload Profile**: Highly normalized wide audit/parameter table with 210 distinct scalar columns across 610 rows.

#### Results:
| Engine | Execution Time (ms) | Throughput (Rows/sec) | Latency per Row ($\mu$s) | Peak Memory (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 Native)** | 82.3 ms | 7,409 | 134.97 $\mu$s | **26.6 MB** |
| **FireDAC (PhysMSSQL)** | **40.7 ms** | 15,000 | 66.67 $\mu$s | 27.4 MB |
| **ADO (dbGo / OLEDB)** | 201.3 ms | 3,030 | 330.05 $\mu$s | 27.7 MB |
| **EMBT DBX (MSSQL / SNC)** | 70.7 ms | 8,632 | 115.85 $\mu$s | 27.2 MB |
| **EMBT DBX (ODBC Generic)** | ❌ **EXCEPTION** | — | — | **ODBC Driver 17: Invalid cursor position** |

#### Architectural Analysis:
- **EMBT DBX ODBC Failure**: Threw runtime exception `[Microsoft][ODBC Driver 17 for SQL Server] Invalid cursor position`. Examination of `Data.DBXOdbc.pas` reveals that its internal row-binding block calculation (`FOffsets`) overflows or miscalculates offsets on wide column sets, corrupting driver cursor state.
- **DBXOODBC Stability**: Dynamically adapts column buffers per record, finishing cleanly in 82.3 ms without memory leaks or cursor corruption.

---

### Scenario 4: Heavy Binary BLOB Streaming (57 Records, 1.6 MB Payload)

- **Workload Profile**: Document/Report archive table storing binary payloads (PDF, images, report templates). 57 records totaling ~1.6 MB of binary data.

#### Results:
| Engine | Execution Time (ms) | Throughput (Rows/sec) | Latency per Row ($\mu$s) | Peak Memory (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 Native)** | 39.3 ms | 1,449 | 690.06 $\mu$s | **27.2 MB** |
| **FireDAC (PhysMSSQL)** | 36.7 ms | 1,555 | 643.27 $\mu$s | 27.2 MB |
| **ADO (dbGo / OLEDB)** | 16.7 ms | 3,420 | 292.40 $\mu$s | 27.3 MB |
| **EMBT DBX (MSSQL / SNC)** | **14.7 ms** | 3,886 | 257.31 $\mu$s | 27.4 MB |
| **EMBT DBX (ODBC Generic)** | ❌ **EXCEPTION** | — | — | **ODBC Driver 17: Invalid cursor position** |

#### Architectural Analysis:
- **EMBT DBX ODBC Failure**: Failed with the identical cursor error (`Invalid cursor position`). The official `Data.DBXOdbc` driver's `TDBXOdbcByteReader` cannot safely transition between row-bound values and chunked `SQLGetData` stream calls.
- **Binary Streaming Engines**: ADO (16.7 ms) and EMBT SNC (14.7 ms) were rapid here because OLE DB and native SNC utilize dedicated TDS stream chunks. DBXOODBC (39.3 ms) and FireDAC (36.7 ms) performed nearly identically within 2.6 ms of each other.

---

### Scenario 5: End-to-End DataSnap Serialization (DataSetProvider $\rightarrow$ ClientDataSet.Open, 3,000 Rows $\times$ 76 Columns)

- **Workload Profile**: Standard enterprise n-tier architecture workflow. The database dataset feeds into a `TDataSetProvider`, serialized into a Midas binary datapacket, and loaded into an in-memory `TClientDataSet` via `CDS.Open`.
- **Target Table**: 3,000 rows containing 76 mixed columns (including 16 memo fields).

#### Results:
| Engine | Execution Time (ms) | Processing Rate (Rows/sec) | Time per Record ($\mu$s) | Peak Memory (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 Native)** | **141.7 ms** | 21,176 | 47.22 $\mu$s | 29.1 MB |
| **FireDAC (PhysMSSQL)** | **87.7 ms** | 34,221 | 29.22 $\mu$s | 27.8 MB |
| **ADO (dbGo / OLEDB)** | 316.7 ms | 9,474 | 105.56 $\mu$s | 27.9 MB |
| **EMBT DBX (MSSQL / SNC)** | ❌ **4,837.7 ms** | 620 | 1,612.56 $\mu$s | 27.5 MB |
| **EMBT DBX (ODBC Generic)** | 226.3 ms | 13,255 | 75.44 $\mu$s | 28.9 MB |

#### Architectural Analysis:
- **Real-World User Perception**:
  - In a standard enterprise ERP application, human perceptual latency thresholds range between **100 ms and 200 ms**.
  - **FireDAC** (87.7 ms) and **DBXOODBC** (141.7 ms) both fall entirely within the sub-200 ms instantaneous interaction envelope. End users cannot distinguish between 87 ms and 141 ms during interactive screen loading.
  - In stark contrast, **EMBT DBX SNC** takes nearly **5 seconds** (4,837.7 ms) to populate the same screen, which users perceive as a frozen UI.
  - **ADO** takes over 300 ms, noticeable as a micro-pause.

---

## Detailed Profile of Evaluated Engines

### 1. DBXOODBC (DbxOpenOdbc v4.2026, DBX4 Native)
- **Role**: **Modernization engine for existing DBX enterprise systems**.
- **Key Strengths**:
  - **Zero Migration Cost**: Functions as a true in-place replacement for `TSQLConnection`. No DFM forms, query components, or application code need alteration.
  - **Zero External DLL Deployment**: Composed of pure Pascal source units directly compiled into the application executable.
  - **Full Modern SQL Server Support**: Seamlessly connects via Microsoft ODBC Driver 17/18, providing out-of-the-box support for TLS 1.3, Azure SQL, Always Encrypted, and modern date/time datatypes (`DATETIME2`, `DATE`, `TIME`).
  - **Memory Efficiency**: Demonstrates the lowest working set footprint across all scalar scenarios.
  - **LOB Safety**: Completely avoids the N+1 network round-trip vulnerability present in EMBT's native driver.
- **Cross-Platform Limitations (Unvarnished Truth)**:
  - **Windows-Centric Implementation**: DBXOODBC's API layer (`OdbcApi.pas`) directly targets Microsoft Windows ODBC runtime libraries (`odbc32.dll`).
  - While POSIX/unixODBC definitions exist theoretically, they have not undergone enterprise-grade production verification on Linux, macOS, or mobile targets.
  - Teams developing non-Windows enterprise services or cross-platform mobile apps should not treat DBXOODBC as a multi-platform abstraction layer.

---

### 2. FireDAC (`FireDAC.Phys.MSSQL`)
- **Role**: **Modern flagship data access framework for Delphi**.
- **Key Strengths**:
  - **Raw Throughput**: Block cursor array fetching delivers the highest raw read performance in scalar and wide-table scenarios.
  - **Multi-Platform Leadership**: Full, certified Tier-1 support across Windows, Linux, macOS, iOS, and Android.
  - **Feature Completeness**: Comprehensive suite of local SQL, array DML, offline caching, and tracing tools.
- **Key Trade-Offs**:
  - **Migration Cost**: Incompatible with legacy DBX component trees. Migrating an enterprise system with hundreds of DFMs from `TSQLQuery` to `TFDQuery` requires extensive manual refactoring or risky AST migration scripts.
  - **Commercial Licensing**: Requires Delphi Enterprise or Architect editions; unavailable in Community or Professional tiers without add-on packs.

---

### 3. ADO / dbGo (`Data.Win.ADODB`)
- **Role**: **Historical baseline framework**.
- **Key Characteristics**:
  - **Industrial Baseline**: Widely used since Delphi 5, but fundamentally constrained by COM infrastructure.
  - **Performance Lag**: High overhead stemming from `IDispatch` invocation, `BSTR` string allocations, and frequent `Variant` boxing/unboxing.
  - **Deprecated Driver**: The default `SQLOLEDB` provider has been deprecated by Microsoft; modern connectivity requires configuring the standalone `MSOLEDBSQL` provider.
  - **Verdict**: Unsuitable for performance-sensitive modern server applications; retained strictly for maintaining legacy COM codebases.

---

### 4. EMBT DBX (MSSQL / SNC, `Data.DBXMSSQL`)
- **Role**: **Deprecated official vendor driver**.
- **Critical Liabilities**:
  - **The LOB Trap**: Catastrophic performance degradation in tables containing multiple memo columns due to non-buffered, deferred `TEXTPTR` fetch round-trips.
  - **Vendor Library Deprecation**: Relies on `sqlncli11.dll` (SQL Server Native Client 11), officially retired and unsupported by Microsoft.
  - **Verdict**: A critical technical liability in production enterprise systems. Must be prioritized for replacement.

---

### 5. EMBT DBX ODBC (`Data.DBXOdbc`)
- **Role**: **Embarcadero stock generic ODBC driver**.
- **Critical Liabilities**:
  - **Cursor Instability**: Throws fatal runtime exceptions (`Invalid cursor position`) when querying wide tables (>200 columns) or streaming binary BLOBs.
  - **Sub-Par Throughput**: Significantly slower than both FireDAC and DBXOODBC in all functional scenarios.
  - **Verdict**: Unfit for enterprise production deployment due to architectural defects in its offset and cursor management state machine.

---

## Conclusion & Strategic Recommendations

1. **For Existing DBX / DataSnap Systems**:  
   **DBXOODBC** represents the optimal upgrade path. It eliminates the 4-second memo latency disaster of EMBT SNC, provides modern security and TLS 1.3 compatibility, maintains full DataSnap interactive parity with FireDAC, and requires zero modifications to existing form DFM layouts or codebase components.
2. **For Greenfield Multi-Platform Projects**:  
   **FireDAC** remains the undisputed standard for brand-new Delphi projects requiring cross-platform deployment (Windows, Linux, mobile) and extreme raw batch array insertion throughput.
3. **For Maintenance Pipelines**:  
   Both **EMBT DBX SNC** and **EMBT DBX ODBC** should be systematically retired from production due to fatal stability issues and deprecated vendor dependencies.

