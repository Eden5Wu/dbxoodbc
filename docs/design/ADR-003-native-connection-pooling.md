# ADR-003: Windows ODBC Driver Manager Native Connection Pooling Strategy

- **Status**: Accepted (Supersedes initial custom `DbxOpenOdbcPool.pas` prototype)
- **Date**: 2026-11-11
- **Decision**: Delegate physical connection pooling to the Windows ODBC Driver Manager (`odbc32.dll`) via `SQL_ATTR_CONNECTION_POOLING = SQL_CP_ONE_PER_HENV` and `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH` on a dedicated pooled `SQLHENV`, removing the custom application-level pool (`DbxOpenOdbcPool.pas`).
- **Related Issue**: [Issue #29: Native Connection Pooling](https://github.com/Eden5Wu/dbx4odbc/issues/29)
- **Integration Branch**: `feat/odbc-dm-pooling` (Historical branches preserved: `feat/native-connection-pooling`, `exp/odbc-dm-pooling`)
- **Traditional Chinese Version**: [繁體中文版](ADR-003-native-connection-pooling_TW.md)

---

## 1. Context & Problem Statement

In stateless, high-concurrency architectures (such as DataSnap, SOAP WebServices, and microservices), requests follow a short-lived `Connect -> Query -> Disconnect` lifecycle. Without connection pooling, each cycle incurs 15–70 ms of TCP/TLS handshake and database authentication overhead.

### 1.1 Source-Code Audit of Embarcadero RTL `Data.DBXPool.pas`

A direct audit of Embarcadero's RTL source files (`Data.DBXPool.pas`, `Data.DBXDelegate.pas`, and `Data.DBXCommon.pas` in RAD Studio 11.3) established why Delphi's built-in `DBXPool` delegate driver is unsuitable:

1. **Connection Partitioning Defect — Confirmed Source-Code Defect & Data Integrity Risk (`Data.DBXPool.pas`, lines 407–435)**:
   - `TDBXPool.IsEqual` partitions pooled connections using two branches:
     - When `ConnectionName <> ''`, it compares **only** `ConnectionName` and `UserName`, ignoring runtime changes to `Database` or `ConnectionString`.
     - When `ConnectionName = ''` (dynamic code-configured `TSQLConnection`), it checks **only** `ConnectionProperties[TDBXPropertyNames.Database]`, completely ignoring `ConnectionProperties['ConnectionString']`, `Custom String`, and `HostName`.
   - In multi-database ERP applications that dynamically assign `Params.Values['ConnectionString']` for different databases (e.g., `ERP_MASTER`, `ERP_ARCHIVE`, `ERP_BRANCH`) while leaving `ConnectionName` and `Database` empty (or sharing the same `ConnectionName` template and `User_Name`), `TDBXPool.IsEqual` evaluates to `True` across distinct databases and returns a connection bound to the wrong catalog. **Incorrect database connection reuse is a correctness failure and data integrity risk, not merely a performance problem.**
2. **Connection Close Behavior — Pooling Effectiveness & Overhead Problem (`Data.DBXDelegate.pas` lines 375–378; `Data.DBXCommon.pas` lines 8626–8634; `Data.DBXPool.pas` lines 505–522)**:
   - When an application closes a `TSQLConnection` configured with `DelegateConnection=DBXPool`, the call chain executes:
     `TDBXDelegateConnection.Close` -> `FConnection.Close` -> `TDBXConnection.Close` -> `DerivedClose` (which invokes `SQLDisconnect` in the underlying driver).
   - Subsequently, `TDBXPoolConnection.Destroy` returns the already-closed `FConnection` object to `FAvailableConnectionList`.
   - On the next checkout, `TDBXPoolConnection.Open` checks `if not FConnection.IsOpen then FConnection.Open`, which re-executes `DerivedOpen` (`SQLDriverConnectW`).
   - Consequently, closing a connection before returning it to `DBXPool` does **not** crash or make the connection unusable, because `TDBXPoolConnection.Open` reopens it; however, it **defeats physical connection reuse** at the DBX layer and re-incurs full physical connection establishment overhead on every checkout unless OS-level ODBC pooling is active underneath.
3. **Architectural Limitations of a Generic DBX Object Pool**:
   - Because `Data.DBXPool.pas` is a generic high-level wrapper around `TDBXConnection`, it has no visibility into ODBC connection attributes (`SQL_ATTR_CONNECTION_DEAD`) or wire-protocol session reset mechanisms (such as TDS `fResetConnection` / `sp_reset_connection`).
4. **Relationship to `dbx4odbc` and Windows ODBC Driver Manager Pooling**:
   - Windows ODBC Driver Manager (`odbc32.dll`) pooling operates below `dbx4odbc` at the `SQLHENV` / `SQLHDBC` layer, completely independent of `Data.DBXPool.pas`.
   - **Important Warning**: Applications using `dbx4odbc` must **not** enable `DelegateConnection=DBXPool`. Because `DBXPool` sits above `dbx4odbc` in the DBX delegate chain, enabling `DelegateConnection=DBXPool` would still expose the application to `TDBXPool.IsEqual` cross-database misrouting before `dbx4odbc` is even reached.

---

## 2. Experimental Comparison: Custom Application Pool vs. Windows ODBC Driver Manager Pool

In phase 1 (`feat/native-connection-pooling`), we built a custom 385-line connection pool (`source/DbxOpenOdbcPool.pas`). In phase 2 (`exp/odbc-dm-pooling`), we audited the custom pool against Windows ODBC Driver Manager native pooling (`odbc32.dll`) on live SQL Server instances (`127.0.0.1/ERP_MASTER`, `127.0.0.1/ERP_ARCHIVE`, `127.0.0.1/ERP_BRANCH`):

### 2.1 Performance Comparison (100 Sequential Cycles + 8T / 16T Concurrency)

| Configuration | Avg Acquire | Avg Query | Avg Release | Avg Total Cycle | Median (p50) | p95 | p99 | 8-Thread QPS | 16-Thread QPS |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. No Pooling (`Pooling=False`)** | 14.077 ms | 3.654 ms | 0.237 ms | **17.967 ms** | 16.567 ms | 32.197 ms | 37.367 ms | 53.2 ops/s | 56.1 ops/s |
| **B. Windows ODBC DM Pooling (`Pooling=True`)** | **0.230 ms** | 2.959 ms | **0.032 ms** | **3.221 ms** | **2.657 ms** | **8.578 ms** | **13.048 ms** | **305.5 ops/s** | **572.3 ops/s** |
| **C1. Custom Pool (`ValidateOnBorrow=True`)** | 1.863 ms | 4.028 ms | 1.766 ms | **7.657 ms** | 5.879 ms | 15.810 ms | 26.574 ms | 265.6 ops/s | 385.3 ops/s |
| **C2. Custom Pool (`ValidateOnBorrow=False`)** | 0.168 ms | 2.553 ms | 1.259 ms | **3.980 ms** | 3.297 ms | 8.125 ms | 15.191 ms | 245.4 ops/s | 322.5 ops/s |

### 2.2 Why Windows ODBC DM Pooling Outperformed Custom Pooling
1. **Zero Extra Network Round-Trips**:
   - The custom pool executed `SELECT 1` while holding `FLock` on checkout (~3.56 ms) and `exec sp_reset_connection` on release (~2.46 ms) — adding **two extra synchronous network round-trips** per cycle.
   - Windows ODBC DM (`odbc32.dll`) + `msodbcsql17.dll` piggybacks the TDS `fResetConnection` bit onto the **first SQL command packet** of the next consumer (`0` extra network round-trips, `0.012 ms` release latency).
2. **Superior Session Isolation & Correctness (8/8 PASS vs. 6/8 PASS)**:
   - Calling `exec sp_reset_connection` as a user T-SQL batch in `DbxOpenOdbcPool.pas` failed to clear `CONTEXT_INFO` (`0xDEADBEEF` leaked across sessions) because SQL Server restores batch-scoped state when an explicit batch call returns. By contrast, the TDS protocol-level `fResetConnection` bit triggered by `odbc32.dll` + `msodbcsql17.dll` cleanly reset `CONTEXT_INFO` to `NULL`.
   - Furthermore, the custom pool previously ignored `SQLExecDirectW` return values during `ResetSession` and held `FLock` across network `Ping` operations.

---

## 3. Architectural Decision

We adopt **Windows ODBC Driver Manager Native Connection Pooling** as the sole production pooling architecture in `dbx4odbc` (`feat/odbc-dm-pooling`):

1. **Dual Isolated `SQLHENV` Architecture (`TOdbcEnvHandle`)**:
   - `TDBXOdbcDriver` maintains two environment handles:
     - `FOdbcEnv`: Unpooled environment (`Pooling=False`, default).
     - `FOdbcPooledEnv`: Lazily allocated pooled environment (`Pooling=True` or `Pooling=Odbc`), initialized under a module-level critical section (`GOdbcEnvInitLock`) with `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)` before `SQLAllocHandle(SQL_HANDLE_ENV)` and immediately resetting the process attribute back to `SQL_CP_OFF`.
   - `FOdbcPooledEnv` is configured with `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH` to enforce exact connection-attribute matching across server, database, user, credentials, and driver options.
2. **Deterministic Transaction Rollback on Disconnect (`TOdbcConnectionHandle.Disconnect`)**:
   - Before calling `SQLDisconnect(FHDbc)`, `TOdbcConnectionHandle.Disconnect` rolls back any active DBX transaction (`Rollback`). On SQL Server (`msodbcsql17.dll`), TDS `fResetConnection` automatically restores the default transaction isolation level (`READ COMMITTED`) during connection reuse without requiring an extra `SQLSetConnectAttrW(SQL_ATTR_TXN_ISOLATION)` call on disconnect.
3. **Removal of `DbxOpenOdbcPool.pas`**:
   - Eliminates 530+ lines of custom pool management, locking, connection-string normalization, and dialect `ResetSession`/`GetPingSql` code, preserving the 4-file pure-Pascal footprint (`OdbcApi.pas`, `DbxOpenOdbcDialects.pas`, `DbxOpenOdbcCore.pas`, `DbxOpenOdbcDriver.pas`).
4. **Backward-Compatible Parameter Handling**:
   - `Pooling=True` (and `Pooling=Odbc`) enables Windows ODBC Driver Manager pooling.
   - `Pooling=False` (or omitted) uses unpooled connections.
   - Legacy custom pool parameters (`Pooling`, `OdbcPooling`, `Pool.*`) are automatically stripped from the ODBC connection string before `SQLDriverConnectW` so existing configuration files continue to work without driver warnings.

---

## 4. Multi-DBMS Compatibility & Operational Requirements

1. **Windows `ODBCINST.INI` `CPTimeout` Requirement**:
   - Per Microsoft ODBC specification, `odbc32.dll` only pools an ODBC driver if its registry entry under `HKLM\SOFTWARE\ODBC\ODBCINST.INI\<DriverName>` defines `CPTimeout > 0`.
   - Microsoft's SQL Server drivers (`ODBC Driver 17/18 for SQL Server`, `SQL Server Native Client`, `SQL Server`) register `CPTimeout=60` out of the box.
   - Third-party drivers (PostgreSQL `psqlodbc`, MariaDB/MySQL `myodbc8w`, Firebird `FirebirdODBC`) must be installed in `HKLM\...\ODBCINST.INI` with a positive `CPTimeout` value (configurable via Windows ODBC Data Source Administrator -> *Connection Pooling* tab) for `odbc32.dll` to pool them. If a driver is used as an unregistered portable DLL or has no `CPTimeout`, `odbc32.dll` safely and transparently falls back to unpooled connections.
2. **Driver-Specific Session Reset Behavior Across DBMSs (Verified)**:
   - **SQL Server (`msodbcsql17.dll`) — Full Support (PASS)**: Piggybacks the TDS `fResetConnection` bit on reuse, automatically rolling back uncommitted DBX and raw `BEGIN TRAN` transactions, dropping `#TempTable`s, clearing `CONTEXT_INFO`, and restoring `READ COMMITTED` isolation.
   - **MariaDB / MySQL (`myodbc8w.dll` 8.0.36) — Full Support (PASS)**: Issues wire-protocol `COM_RESET_CONNECTION` on pool reuse, automatically rolling back uncommitted DBX and raw `START TRANSACTION` transactions, dropping `TEMPORARY TABLE`s, clearing `@user_var` variables, and restoring `@@autocommit=1` and `REPEATABLE-READ` isolation.
   - **PostgreSQL (`psqlodbc35w.dll` 17.00) & Firebird (`FirebirdODBC.dll` 3.0/3.5) — Physical Reuse & DBX Transaction Safety Only; No Automatic Session Reset (PARTIAL / FAIL on Session Cleanup)**: Both pass physical connection reuse, database isolation, uncommitted DBX `BeginTransaction` rollback, and transaction isolation level restoration, but neither driver automatically issues `DISCARD ALL` (PostgreSQL) or `ALTER SESSION RESET` (Firebird) on pool reuse. Applications pooling PostgreSQL or Firebird that create session-scoped temporary tables (`CREATE TEMP TABLE` / `ON COMMIT PRESERVE ROWS` GTT), mutate session variables (`SET statement_timeout` / `RDB$SET_CONTEXT('USER_SESSION', ...)`), or open raw SQL `BEGIN;` transactions outside DBX transaction APIs must clean them up explicitly before closing the connection.
