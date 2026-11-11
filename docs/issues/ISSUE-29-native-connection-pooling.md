# GitHub Issue #29: [Feature] Native Connection Pooling via Windows ODBC Driver Manager

- **Status**: `[OPEN — Ready for Final Review on feat/odbc-dm-pooling]`
- **Labels**: `enhancement`, `performance`, `architecture`, `multi-dbms`
- **Milestone**: `4.2026.11`
- **Integration Branch**: `feat/odbc-dm-pooling` (Historical branches preserved: `feat/native-connection-pooling`, `exp/odbc-dm-pooling`)
- **Related ADR**: [ADR-003: Windows ODBC Driver Manager Native Connection Pooling Strategy](../design/ADR-003-native-connection-pooling.md)
- **Traditional Chinese Version**: [繁體中文版](ISSUE-29-native-connection-pooling_TW.md)

---

## 1. Background & Problem Statement

In stateless, high-concurrency environments such as WebServices, DataSnap, SOAP backends, and microservices, requests follow a short lifecycle: `Connect -> Query/Mutate -> Disconnect`. Without connection pooling, each request incurs 15–70 ms of TCP/TLS handshake and database login latency.

### 1.1 Technical Audit of Embarcadero RTL `Data.DBXPool.pas`

A direct inspection of Embarcadero's RTL source files (`Data.DBXPool.pas`, `Data.DBXDelegate.pas`, and `Data.DBXCommon.pas`) establishes why Delphi's built-in `DBXPool` delegate driver is unsuitable:

1. **Connection Partitioning Defect — Data Integrity Risk (`Data.DBXPool.pas`, lines 407–435)**:
   - `TDBXPool.IsEqual` compares only `ConnectionName` and `UserName` when `ConnectionName <> ''`, and only `ConnectionProperties[TDBXPropertyNames.Database]` when `ConnectionName = ''` (ignoring `ConnectionString`, `Custom String`, and `HostName`).
   - In multi-database ERP applications that dynamically assign `Params.Values['ConnectionString']` across multiple databases (e.g., `TW_ED`, `TW_OLD`, `TWBS260610`) while sharing a blank or template `ConnectionName`, `TDBXPool.IsEqual` falsely matches connections targeting different databases. **Incorrect database connection reuse is a correctness failure and data integrity risk, not merely a performance problem.**
2. **Connection Close Behavior — Pooling Effectiveness & Overhead Problem (`Data.DBXDelegate.pas` lines 375–378; `Data.DBXCommon.pas` lines 8626–8634; `Data.DBXPool.pas` lines 505–522)**:
   - `TDBXDelegateConnection.Close` forwards directly to `FConnection.Close` -> `TDBXConnection.Close` -> `DerivedClose` (`SQLDisconnect`).
   - `TDBXPoolConnection.Destroy` subsequently returns the closed `FConnection` object to `FAvailableConnectionList`, and `TDBXPoolConnection.Open` reopens `FConnection` on the next checkout.
   - This behavior does **not** render the connection unusable, but it **defeats physical connection reuse** at the DBX layer and re-incurs physical connection establishment overhead on every checkout unless OS-level ODBC pooling is active below.
3. **Architectural Limitations of a Generic DBX Wrapper**:
   - As a generic high-level object pool above `TDBXConnection`, `Data.DBXPool.pas` has no access to ODBC socket liveness attributes (`SQL_ATTR_CONNECTION_DEAD`) or wire-protocol session reset flags (`fResetConnection`).
4. **Warning — Do Not Combine with `DelegateConnection=DBXPool`**:
   - Windows ODBC Driver Manager (`odbc32.dll`) pooling operates below `dbx4odbc`. Applications using `dbx4odbc` must **not** configure `DelegateConnection=DBXPool`, because `DBXPool` sits above `dbx4odbc` and would still suffer from `TDBXPool.IsEqual` cross-database misrouting.

---

## 2. Approved Architecture: Windows ODBC Driver Manager Native Pooling

Following a side-by-side architecture audit and benchmark evaluation (`exp/odbc-dm-pooling`) comparing custom application pooling (`DbxOpenOdbcPool.pas`, `7.657 ms/cycle`, `385.3 QPS` @ 16T) against Windows ODBC Driver Manager pooling (`odbc32.dll`, `3.221 ms/cycle`, `572.3 QPS` @ 16T), `dbx4odbc` delegates physical connection pooling directly to `odbc32.dll`:

1. **Isolated Pooled Environment Handle (`FOdbcPooledEnv`)**:
   - `TDBXOdbcDriver` lazily allocates `FOdbcEnv` (unpooled, default) and `FOdbcPooledEnv` (pooled).
   - `TOdbcEnvHandle.Create(True)` sets `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)` immediately before `SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, FHEnv)` and immediately resets `SQL_ATTR_CONNECTION_POOLING` back to `SQL_CP_OFF` afterwards, ensuring third-party ODBC components in the same process are unaffected.
   - `FOdbcPooledEnv` configures `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH` for strict connection-string partitioning.
2. **Transaction Rollback on Disconnect (`TOdbcConnectionHandle.Disconnect`)**:
   - Before calling `SQLDisconnect(FHDbc)`, `Disconnect` rolls back any uncommitted DBX transaction (`Rollback`). Protocol-capable ODBC drivers (`msodbcsql17.dll` via TDS `fResetConnection`, `myodbc8w.dll` via `COM_RESET_CONNECTION`) automatically restore default session state and isolation levels on pool reuse without requiring extra round-trips on disconnect.
3. **Zero Extra Network Round-Trips on SQL Server**:
   - On SQL Server (`msodbcsql17.dll`), `odbc32.dll` + TDS 7.1+ piggybacks the `fResetConnection` bit onto the first command packet of the next borrower, resetting `#temp` tables, `CONTEXT_INFO`, and session settings with zero extra network round-trips.
4. **Removal of `DbxOpenOdbcPool.pas`**:
   - Custom application-level pooling (`source/DbxOpenOdbcPool.pas`) is removed from the runtime architecture, preserving the 4-unit pure-Pascal driver structure.

---

## 3. Configuration Parameters

Configurable via `TSQLConnection.Params` or inside `ConnectionString`:

```ini
DriverName=DbxOpenOdbc
ConnectionString=Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.15;Database=ERP_MASTER;Uid=sa;Pwd=***;
; Enable Windows ODBC Driver Manager connection pooling (default: False)
Pooling=True
```

- `Pooling=True` (or `Pooling=Odbc`): Routes the connection through `FOdbcPooledEnv` (`SQL_CP_ONE_PER_HENV` + `SQL_CP_STRICT_MATCH`).
- `Pooling=False` (or omitted): Routes the connection through unpooled `FOdbcEnv`.
- Any `Pooling`, `OdbcPooling`, or legacy `Pool.*` keywords embedded in `ConnectionString` are automatically stripped before `SQLDriverConnectW`.

---

## 4. Acceptance Criteria & Verification Status

- [x] **SQL Server Benchmark (100 cycles + 8T/16T concurrency)**: `Pooling=True` achieves `3.221 ms` avg cycle (`5.6x` faster than `Pooling=False` at `17.967 ms`, and `2.4x` faster than custom pooling at `7.657 ms`), reaching `305.5 QPS` (8T) and `572.3 QPS` (16T) vs unpooled `53.2 QPS` (8T) and `56.1 QPS` (16T).
- [x] **SQL Server Session Isolation (8/8 PASS)**: Verified physical reuse (`1` `connection_id` across 100 cycles), multi-database isolation (`TW_ED` vs `TW_OLD` vs `TWBS260610`), DBX and raw SQL transaction rollback, `#TempTable` and `CONTEXT_INFO` reset via TDS `fResetConnection`, `DirtyRead -> ReadCommitted` isolation level restoration, and dead socket recovery.
- [x] **Process-Wide HENV Isolation**: Verified that third-party `SQLHENV` handles allocated before or after `dbx4odbc` remain unpooled, and runtime toggling of `Pooling=False` / `Pooling=True` on the same `TSQLConnection` switches cleanly.
- [x] **Multi-DBMS Pooling Verification (with `CPTimeout=60` in `HKLM\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI`)**:
  - **SQL Server (`msodbcsql17.dll`)**: **PASS** (Physical Reuse `1 ConnID / 10 cycles`, DB Isolation, Transaction Safety, Session Cleanup via TDS `fResetConnection`).
  - **MariaDB 10.6.17 (`myodbc8w.dll` 8.0.36)**: **PASS** (Physical Reuse `1 ConnID / 10 cycles`, DB Isolation, Transaction Safety, Session Cleanup via `COM_RESET_CONNECTION`).
  - **PostgreSQL 17.6 (`psqlodbc35w.dll` 17.00)**: **PARTIAL / FAIL on Session Cleanup** (Physical Reuse `1 PID / 10 cycles` = **PASS**, DB Isolation = **PASS**, DBX Transaction Rollback & Isolation Restoration = **PASS**, but raw SQL `BEGIN;`, `CREATE TEMP TABLE`, and `SET statement_timeout` persist across pooled sessions because `psqlodbc` does not automatically execute `DISCARD ALL`).
  - **Firebird 5.0.4 (`FirebirdODBC.dll` 3.0/3.5)**: **PARTIAL / FAIL on Session Cleanup** (Physical Reuse `1 AttachmentID / 10 cycles` = **PASS**, DB Isolation = **PASS**, DBX Transaction Rollback & Isolation Restoration = **PASS**, but `ON COMMIT PRESERVE ROWS` GTT rows and `RDB$SET_CONTEXT('USER_SESSION', ...)` persist across pooled sessions because `FirebirdODBC` does not automatically execute `ALTER SESSION RESET`).
  - **Oracle**: **NOT VERIFIED** (No Oracle instance in test environment).
- [x] **Full Regression Suite (Win32 & Win64)**: Verified clean compilation on both `dcc32` and `dcc64`, plus full regression pass on `Dbx4MvpTester`, `RuntimeRegressionTester`, `Dbx4MetadataTester`, and DataSnap `TDataSetProvider -> TClientDataSet`.
