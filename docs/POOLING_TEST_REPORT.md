# dbx4odbc Connection Pooling Architecture Benchmark & Verification Report
*(Windows ODBC Driver Manager Pooling vs. Custom Application Pooling)*

- **Test Date**: 2026-11-10 ~ 2026-11-11
- **Environment**: Windows 11 x64, Embarcadero RAD Studio 11.3 (Delphi Win32 & Win64 Compiler 35.0)
- **Database Environments**:
  - Remote SQL Server instances: `192.168.1.15` (`TW_ED`), `10.0.0.90` (`TW_OLD`, `TWBS260610`) — `ODBC Driver 17 for SQL Server` (`msodbcsql17.dll`)
  - Local Sandbox (`D:\D\aisandbox`): PostgreSQL 17.6 (`localhost:5433`), MariaDB 10.6.17 (`localhost:3307`), Firebird 5.0.4 Embedded (`FirebirdODBC.dll`)
- **Branches**:
  - `feat/odbc-dm-pooling`: Approved integration branch (Windows ODBC Driver Manager native pooling)
  - `exp/odbc-dm-pooling`: Side-by-side experimental prototype & benchmark branch (`TestOdbcVsCustomPooling.dpr`)
  - `feat/native-connection-pooling`: Historical custom application-level pooling reference branch (`DbxOpenOdbcPool.pas`)
- **Related Documents**: [GitHub Issue #29](issues/ISSUE-29-native-connection-pooling.md), [ADR-003](design/ADR-003-native-connection-pooling.md), [繁體中文版](POOLING_TEST_REPORT_TW.md)

---

## 1. Historical Side-by-Side Benchmark: SQL Server Four-Configuration Evaluation (`exp/odbc-dm-pooling`)

To objectively evaluate whether Windows ODBC Driver Manager's built-in connection pooling (`odbc32.dll`) can replace our custom application-level pool (`DbxOpenOdbcPool.pas`), we executed `tests/pooling_test/TestOdbcVsCustomPooling.dpr` against the same SQL Server (`192.168.1.15/TW_ED`), driver (`ODBC Driver 17 for SQL Server`), and parameters across 5 warmup cycles (excluded) followed by **100 measured `Connect -> Query -> Disconnect` cycles**, plus **8-thread (160 ops)** and **16-thread (320 ops)** concurrent stress tests.

### 1.1 100 Sequential Cycles Latency Breakdown (Warmup Excluded)

| Configuration | Avg Acquire | Avg Query | Avg Release | **Avg Total Cycle** | **Median (p50)** | **p95** | **p99** | Unique Physical `connection_id`s (100 cycles) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. No Pooling (`Pooling=False`)** | 14.077 ms | 3.654 ms | 0.237 ms | **17.967 ms** | 16.567 ms | 32.197 ms | 37.367 ms | 100 (new socket each cycle) |
| **B. Windows ODBC DM Pooling (`Pooling=True`)** | **0.230 ms** | 2.959 ms | **0.032 ms** | **3.221 ms** | **2.657 ms** | **8.578 ms** | **13.048 ms** | **1 (100% reused)** |
| **C1. Custom Pool (`ValidateOnBorrow=True`)** | 1.863 ms | 4.028 ms | 1.766 ms | **7.657 ms** | 5.879 ms | 15.810 ms | 26.574 ms | 1 (100% reused) |
| **C2. Custom Pool (`ValidateOnBorrow=False`)** | 0.168 ms | 2.553 ms | 1.259 ms | **3.980 ms** | 3.297 ms | 8.125 ms | 15.191 ms | 1 (100% reused) |

> **Latency Analysis**:
> - **Windows ODBC DM Pooling (`3.221 ms`)** is **5.6x faster** than No Pooling (`17.967 ms`), **2.38x faster** than Custom Pooling with `ValidateOnBorrow=True` (`7.657 ms`), and **19% faster** than Custom Pooling even with `Ping` disabled (`3.980 ms`).
> - Custom Pooling incurred two extra synchronous network round-trips per cycle (`SELECT 1` on borrow under lock = `3.575 ms`, and `exec sp_reset_connection` on release = `2.460 ms`), whereas `odbc32.dll` + `msodbcsql17.dll` piggybacks the TDS 7.1+ `fResetConnection` bit onto the **first SQL command packet** of the next consumer (`0` extra network round-trips, `0.012 ms` release latency).

### 1.2 Multi-Threaded Concurrency (8 Threads & 16 Threads)

| Configuration | 8T Wall Time (200 ops) | 8T Avg Latency | 8T p95 | **8T Throughput (QPS)** | 16T Wall Time (400 ops) | 16T Avg Latency | 16T p95 | **16T Throughput (QPS)** | Unique Physical `connection_id`s (8T / 16T) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. No Pooling (`Pooling=False`)** | 3759.3 ms | 141.77 ms | 346.62 ms | **53.2 ops/s** | 7132.7 ms | 267.18 ms | 421.34 ms | **56.1 ops/s** | 200 / 400 |
| **B. Windows ODBC DM Pooling (`Pooling=True`)** | **654.7 ms** | **20.66 ms** | **105.79 ms** | **305.5 ops/s** | **699.0 ms** | **19.68 ms** | **131.66 ms** | **572.3 ops/s** | **8 / 16** |
| **C1. Custom Pool (`ValidateOnBorrow=True`)** | 752.9 ms | 23.95 ms | 141.74 ms | **265.6 ops/s** | 1038.1 ms | 28.63 ms | 220.49 ms | **385.3 ops/s** | 8 / 16 |
| **C2. Custom Pool (`ValidateOnBorrow=False`)** | 815.0 ms | 27.17 ms | 142.00 ms | **245.4 ops/s** | 1240.1 ms | 39.01 ms | 262.19 ms | **322.5 ops/s** | 8 / 16 |

### 1.3 SQL Server 8-Point Correctness & Session Isolation Comparison (`exp/odbc-dm-pooling`)

| Test Case | Windows ODBC DM Pooling (`odbc32.dll`) | Custom Pool (`DbxOpenOdbcPool.pas`) | Root-Cause Analysis |
| :--- | :---: | :---: | :--- |
| **3.1 Multi-Database Isolation (`TW_ED` / `TW_OLD` / `TWBS260610`)** | **PASS** | **PASS** | `SQL_CP_STRICT_MATCH` enforces exact connection-string matching |
| **3.2a Uncommitted DBX Transaction Rollback** | **PASS** (0 rows) | **PASS** (0 rows) | Both `Disconnect` and `odbc32.dll` guarantee `SQL_ROLLBACK` |
| **3.2b Uncommitted Raw SQL `BEGIN TRAN` Rollback** | **PASS** (0 rows) | **PASS** (0 rows) | TDS `fResetConnection` rolls back open raw SQL transactions |
| **3.3a `#TempTable` & `CONTEXT_INFO` Reset** | **PASS** (`NULL`) | **FAIL** (`0xDEADBEEF` leaked) | Executing `exec sp_reset_connection` as a user T-SQL sub-batch in `DbxOpenOdbcPool.pas` restores caller-batch `CONTEXT_INFO` on return, whereas the TDS packet-level `fResetConnection` bit triggered by `odbc32.dll` resets `CONTEXT_INFO` to `NULL` |
| **3.3b `SET LOCK_TIMEOUT` / `LANGUAGE` Reset** | **PASS** (`-1`) | **FAIL** (Cascaded from 3.3a) | Packet-level `fResetConnection` resets all session options cleanly |
| **3.3c Transaction Isolation (`DirtyRead`) Restoration** | **PASS** (`2` ReadCommitted) | **FAIL** (`1` ReadUncommitted leaked) | Custom pooling kept `HDBC` open without calling `SQLDisconnect`, leaving `ReadUncommitted` active; Windows ODBC DM pooling + `msodbcsql17.dll` automatically resets isolation to `READ COMMITTED` via TDS `fResetConnection` |
| **3.4 Dead Connection / Severed Socket Recovery** | **PASS** | **PASS** | `odbc32.dll` evicts broken sockets on failure and establishes a fresh connection on immediate retry |
| **3.5 Zero Cross-Interference Across Modes** | **PASS** | **PASS** | Separate `FOdbcPooledEnv` and `FOdbcEnv` handles |

---

## 2. Supplementary Verification (`feat/odbc-dm-pooling`): Process-Wide `SQLHENV` Isolation, Multi-DBMS & Regression

After removing `source/DbxOpenOdbcPool.pas` on `feat/odbc-dm-pooling`, we verified the final integration architecture using `tests/pooling_test/TestOdbcMigrationVerification.dpr`.

### 2.1 Process-Wide ODBC Behavior & `SQLHENV` Isolation (Section 4)

Because `TOdbcEnvHandle.Create(True)` sets `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)` immediately prior to `SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, FHEnv)` and **immediately resets the process attribute back to `SQL_CP_OFF`**:
- **[4.1 Third-Party `SQLHENV` Allocated BEFORE `dbx4odbc`]** -> 5 cycles produced **5 distinct `connection_id`s** (unpooled) -> **PASS**.
- **[4.2 Third-Party `SQLHENV` Allocated AFTER `dbx4odbc`]** -> 5 cycles produced **5 distinct `connection_id`s** (unpooled) -> **PASS**.
- **[4.3 Runtime Toggle on the Same `TSQLConnection`]** -> `Pooling=False` (8 cycles -> 8 distinct `connection_id`s) and `Pooling=True` (5 cycles -> 1 reused `connection_id`) -> **PASS**.

### 2.2 Multi-DBMS Compatibility Matrix (Section 5 — Registered with `CPTimeout=60` in `HKLM\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI`)

| Verification Dimension | SQL Server (`msodbcsql17.dll`) | MariaDB 10.6.17 (`myodbc8w.dll`) | PostgreSQL 17.6 (`psqlodbc35w.dll`) | Firebird 5.0.4 (`FirebirdODBC.dll`) | Oracle |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **`HKLM\...\ODBCINST.INI` Registration** | Installed (`CPTimeout=60`) | Registered (`CPTimeout=60`) | Registered (`CPTimeout=60`) | Registered (`CPTimeout=60`) | **NOT VERIFIED** |
| **1. Physical Connection Reuse (`Pooling=True`)** | **PASS** (`1 ConnID / 10 cycles`) | **PASS** (`1 ConnID / 10 cycles`) | **PASS** (`1 PID / 10 cycles`) | **PASS** (`1 AttachmentID / 10 cycles`) | **NOT VERIFIED** |
| **2. Multi-Database Isolation** | **PASS** (`TW_ED` / `TW_OLD` / `TWBS260610`) | **PASS** (`test` / `information_schema`) | **PASS** (`postgres` / `template1`) | **PASS** (`TESTDB.FDB` / `TESTDB2.FDB`) | **NOT VERIFIED** |
| **3. DBX Uncommitted Transaction Rollback** | **PASS** (0 rows) | **PASS** (0 rows) | **PASS** (0 rows) | **PASS** (0 rows) | **NOT VERIFIED** |
| **4. Raw SQL Transaction Rollback on Disconnect** | **PASS** (0 rows) | **PASS** (`COM_RESET_CONNECTION` rolled back to 0 rows) | **FAIL** (Raw `BEGIN;` persisted: 1 row) | **PASS** (ODBC transaction layer) | **NOT VERIFIED** |
| **5. Temp Table & Session Variable Isolation** | **PASS** (TDS `fResetConnection`) | **PASS** (`COM_RESET_CONNECTION` dropped temp table, `@var`, restored `@@autocommit=1`) | **FAIL** (`TEMP TABLE` & `statement_timeout=12345ms` leaked) | **FAIL** (`ON COMMIT PRESERVE ROWS` GTT & `USER_SESSION` leaked) | **NOT VERIFIED** |
| **6. Transaction Isolation Level Restoration** | **PASS** (`ReadCommitted`) | **PASS** (`REPEATABLE-READ`) | **PASS** (`read committed`) | **PASS** (`MON$ISOLATION_MODE=4`) | **NOT VERIFIED** |
| **7. Dead Connection Recovery** | **PASS** | **PASS** | **PASS** | **PASS** | **NOT VERIFIED** |
| **8. Legacy `Pool.*` Keyword Stripping** | **PASS** | **PASS** | **PASS** | **PASS** | **NOT VERIFIED** |
| **Overall Pooling Verification** | **PASS** | **PASS** | **PARTIAL / FAIL (Session Cleanup)** | **PARTIAL / FAIL (Session Cleanup)** | **NOT VERIFIED** |

> **Key Empirical Findings on Underlying ODBC Driver Session Reset Behavior**:
> 1. **SQL Server (`msodbcsql17.dll`) — Full Support (PASS)**: Piggybacks the TDS 7.1+ `fResetConnection` bit on reuse, automatically rolling back open transactions, dropping `#TempTable`s, clearing `CONTEXT_INFO` and session settings, and restoring `READ COMMITTED` isolation.
> 2. **MariaDB / MySQL (`myodbc8w.dll` 8.0.36) — Full Support (PASS)**: MySQL Connector/ODBC 8.0 issues the wire-protocol `COM_RESET_CONNECTION` (`mysql_reset_connection()`) when `odbc32.dll` reuses a pooled connection. Verified on the same reused physical connection (`CONNECTION_ID() = 45`): raw SQL `START TRANSACTION` is rolled back (`0` rows), `TEMPORARY TABLE` is dropped, `@user_var` is reset to `NULL`, `@@autocommit` is restored to `1`, and `@@tx_isolation` is restored to `REPEATABLE-READ`.
> 3. **PostgreSQL (`psqlodbc35w.dll` 17.00) — Physical Reuse & DBX Txn Only; No Automatic Session Reset (PARTIAL / FAIL)**: `psqlodbc35w.dll` does **not** issue `DISCARD ALL` when `odbc32.dll` reuses a pooled connection (`pg_backend_pid() = 16088`). While `TSQLConnection.BeginTransaction` rollback and transaction isolation restoration (`read committed`) pass, raw SQL `BEGIN;` transactions (opened outside DBX transaction APIs), `CREATE TEMP TABLE`, and `SET statement_timeout` persist across pooled sessions.
> 4. **Firebird (`FirebirdODBC.dll` 3.0/3.5) — Physical Reuse & DBX Txn Only; No Automatic Session Reset (PARTIAL / FAIL)**: `FirebirdODBC.dll` does **not** issue `ALTER SESSION RESET` when `odbc32.dll` reuses a pooled attachment (`CURRENT_CONNECTION = 220`). While DBX uncommitted transaction rollback and transaction isolation (`MON$ISOLATION_MODE = 4`) pass, attachment-scoped GTT rows (`ON COMMIT PRESERVE ROWS`) and `RDB$SET_CONTEXT('USER_SESSION', ...)` variables persist across pooled sessions.
