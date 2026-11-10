# GitHub Issue #29: [Feature] Native Connection Pooling with Multi-DBMS Dialect Session Isolation

- **Status**: `[OPEN]`
- **Labels**: `enhancement`, `performance`, `architecture`, `multi-dbms`
- **Milestone**: `4.2026.11`
- **Branch**: `feat/native-connection-pooling`
- **Traditional Chinese Version**: [繁體中文版](ISSUE-29-native-connection-pooling_TW.md)

---

## 1. Background & Problem Statement

In stateless, high-concurrency environments such as WebServices, DataSnap, SOAP backends, and modern microservices, incoming requests follow a short lifecycle: "Establish connection -> Execute query/mutation -> Close and release connection".

Without connection pooling, every single request incurs:
1. **TCP Handshake & TLS/SSL Negotiation** (5~20ms).
2. **Database Authentication & Login Protocol** (10~50ms).
3. **Database Session Allocation & Internal Memory Initialization**.

Under heavy workloads, this leads to significant database CPU spikes and throughput bottlenecks (limited QPS).

### Why Delphi's RTL `Data.DBXPool.pas` is Insufficient
Source code auditing of Delphi's default `Data.DBXPool.pas` reveals critical design flaws:
1. **Flawed Partitioning Key (Cross-Database Bleeding)**: The RTL `IsEqual` checks only `ConnectionName` and `UserName`. In multi-database or multi-tenant setups, connections belonging to different databases are cross-borrowed, causing catastrophic data corruption.
2. **Premature Physical Disconnection**: It fails to override `Close`. Invoking `Connected := False` immediately terminates the physical TCP socket via `SQLDisconnect`, leaving broken/dead handles in the pool.
3. **Absence of Dead Connection Probing**: Idle connections dropped by firewalls trigger immediate socket errors upon being borrowed.
4. **No Multi-DBMS Dialect Awareness**: Incapable of resetting session states (SQL Server temp tables, Oracle package variables, MySQL connection variables).

---

## 2. Proposed Architecture: Native Pooling in `dbx4odbc`

Implement native connection pooling directly within `dbx4odbc`, leveraging the existing `DbxOpenOdbcDialects.pas` architecture to provide universal, thread-safe pooling across SQL Server, Oracle, MySQL, and PostgreSQL.

### Core Capabilities:
1. **Thread-Safe Connection Pool (`TOdbcConnectionPool`)**:
   - Resides in `DbxOpenOdbcCore.pas` / `DbxOpenOdbcDriver.pas`.
   - Protected by `TCriticalSection` for low-latency thread safety.
   - Partitioned by normalized ODBC connection strings to guarantee 100% database/catalog/user isolation.
2. **Multi-DBMS Dialect Session Reset Hook**:
   - Extended via `TOdbcDialect.ResetSession(Connection: TOdbcConnectionHandle)`.
   - **`TSqlServerDialect`**: Executes `exec sp_reset_connection;` (flushes `#temp` tables, user cursors, resets `SET` options and isolation levels).
   - **`TOracleDialect`**: Executes `BEGIN DBMS_SESSION.RESET_PACKAGE; END;` (cleanses package states).
   - **`TMySqlDialect`**: Executes `SET autocommit=1;` and cleanses session-level variables.
3. **Zero Round-Trip Dead Connection Check**:
   - Calls ODBC C-API `SQLGetConnectAttr(FHDbc, SQL_ATTR_CONNECTION_DEAD, ...)` before lending a connection.
   - Automatically reclaims and re-establishes broken sockets without surfacing exceptions to the caller.
4. **Lifecycle Interception (`DerivedClose`)**:
   - When `Pooling=True`, `DerivedClose` suppresses `SQLDisconnect`, triggers transaction rollback and dialect session reset, and returns the handle to the idle queue.

---

## 3. Configuration Parameters

Configurable via `TSQLConnection.Params` or standard connection strings:

```ini
DriverName=DbxOpenOdbc
Database=ERP_MASTER
User_Name=sa
Password=***
; Master switch (default: False for 100% backward compatibility)
Pooling=True
; Maximum connections per pool partition (default: 50)
Pool.MaxPoolSize=50
; Minimum reserved connections (default: 0)
Pool.MinPoolSize=0
; Checkout wait timeout in seconds (default: 30)
Pool.ConnectionTimeout=30
; Maximum idle lifetime in seconds (default: 300)
Pool.ConnectionLifetime=300
; Probing on checkout (default: True)
Pool.ValidateOnBorrow=True
```

---

## 4. Acceptance Criteria

- [ ] Single-threaded acquire/release lifecycle verification (zero redundant TCP handshakes).
- [ ] 10-thread concurrent stress test (thread safety and deadlock freedom).
- [ ] Multi-database isolation verification (distinct databases must never share connection pools).
- [ ] MSSQL `sp_reset_connection` validation (temporary tables and uncommitted transactions are cleanly wiped).
- [ ] Dead connection recovery test (silently recycles terminated sockets upon checkout).
