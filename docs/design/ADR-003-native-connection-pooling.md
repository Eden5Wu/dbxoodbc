# ADR-003: Native Connection Pooling with Multi-DBMS Dialect Session Isolation

- **Status**: Accepted
- **Date**: 2026-11-11
- **Decision**: Implement native connection pooling inside `dbx4odbc` with multi-DBMS dialect session reset hooks, rather than relying on Delphi's `Data.DBXPool.pas` or generic OS-level ODBC pooling.
- **Related Issue**: [Issue #29: Native Connection Pooling](https://github.com/Eden5Wu/dbx4odbc/issues/29)
- **Branch**: `feat/native-connection-pooling`
- **Traditional Chinese Version**: [繁體中文版](ADR-003-native-connection-pooling_TW.md)

---

## Context & Problem Statement

In enterprise systems (such as DataSnap, SOAP WebServices, and high-throughput microservices), applications frequently create and destroy database connections per request. Establishing a physical database connection over TCP/TLS requires 15~70ms of latency per call.

Delphi provides an optional delegate driver, `Data.DBXPool.pas`, but an in-depth source inspection revealed several critical defects:
1. **Partitioning Key Bug**: `IsEqual` only compares `ConnectionName` and `UserName`. In multi-catalog / multi-tenant environments, connections targeting different databases are erroneously reused, resulting in cross-database data pollution.
2. **Premature Physical Disconnection**: `TDBXPoolConnection` does not intercept `Close`, causing `SQLDisconnect` to be invoked when application code calls `Connected := False`.
3. **Absence of Dead Connection Probing**: Does not verify whether the underlying socket was severed by firewalls during idle periods.
4. **No Multi-DBMS Session Cleansing**: Incapable of invoking DBMS-specific session reset procedures (such as MSSQL `sp_reset_connection`, Oracle `DBMS_SESSION.RESET_PACKAGE`, or MySQL autocommit restoration).

---

## Architectural Decision

We decide to build a first-class, native connection pooling engine inside `dbx4odbc`:

1. **Normalized Pool Partitioning**:
   Connections are partitioned strictly by their normalized ODBC connection string. Any difference in Server, Database, Catalog, User, or Port creates an entirely isolated pool partition.
2. **Dialect-Driven Session Reset**:
   `TOdbcDialect` is augmented with `procedure ResetSession(Connection: TOdbcConnectionHandle)`. When returning connections to the pool, the active dialect performs a clean session reset:
   - `TSqlServerDialect`: `exec sp_reset_connection;`
   - `TOracleDialect`: `BEGIN DBMS_SESSION.RESET_PACKAGE; END;`
   - `TMySqlDialect`: `SET autocommit=1;`
3. **Zero Round-Trip Socket Probing**:
   Leverages ODBC 3.x API `SQLGetConnectAttr(FHDbc, SQL_ATTR_CONNECTION_DEAD, ...)` to perform instant local socket health checks prior to lending a pooled connection.
4. **Seamless Ergonomics**:
   Controlled by a single standard parameter `Pooling=True` in `TSQLConnection.Params`, maintaining full backward compatibility (`Default: False`).
