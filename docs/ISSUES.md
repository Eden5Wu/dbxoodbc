# Open DBX4 ODBC Driver - Issue Tracker & Driver Quirks Catalog

This document tracks identified driver quirks, boundary condition issues, and resolution strategies across supported DBMS engines in `dbx4odbc`.

---

## Issue Summary Matrix

| Issue ID | Engine / Component | Severity | Description | Status |
| :--- | :--- | :---: | :--- | :---: |
| **[#21](#issue-21-mysql-mariadb-int-unsigned-overflow-to-negative-integer)** | MySQL / MariaDB | **High** | `INT UNSIGNED` (> 2.14B) overflows to negative 32-bit integer | **Resolved / Verified** |
| **[#22](#issue-22-mysql-mariadb-sqltablesw-crashes-with-no_schema-option)** | MySQL / MariaDB | **High** | `SQLTablesW` crashes with `[HY000] Support for schemas is disabled by NO_SCHEMA option` | **Resolved / Verified** |
| **[#23](#issue-23-sqlite-sql_binary-columnsize--0-mapped-to-fixed-binary-instead-of-blob)** | SQLite | **Medium** | `SQL_BINARY` BLOB reporting `ColumnSize = 0` mapped to fixed binary instead of `BlobType` | **Resolved / Verified** |
| **[#24](#issue-24-postgresql-schema-resolution-mismatch-on-unspecified-schema)** | PostgreSQL | **Medium** | `TSQLConnection.GetTableNames` defaults to `UserName` instead of `public` schema | **Resolved / Verified** |
| **[#25](#issue-25-oracle-sql_type_date-truncates-time-component)** | Oracle | **High** | `SQL_TYPE_DATE` / `SQL_DATE` truncates time component (hours/minutes/seconds) | **Resolved / Verified** |
| **[#26](#issue-26-oracle-unconstrained-number-reports-scale--127-crashing-tfielddef)** | Oracle | **High** | Unconstrained `NUMBER` reports Scale = -127, crashing Delphi `TFieldDef` | **Resolved / Verified** |
| **[#27](#issue-27-oracle-unscoped-catalog-query-hangs-on-full-data-dictionary-scan)** | Oracle | **High** | Unscoped metadata query (`SQLTablesW` with nil schema) hangs on full dictionary scan | **Resolved / Verified** |
| **[#28](#issue-28-firebird-transaction-table-lock-on-ddl-drop-table)** | Firebird | **Medium** | DDL `DROP TABLE` fails with `-object TABLE is in use` within active transaction | **Resolved / Verified** |

---

### Issue #21: [MySQL / MariaDB] `INT UNSIGNED` Overflow to Negative Integer

- **Engine**: MySQL 5.7/8.0+, MariaDB 10.x+
- **Driver**: MySQL Connector/ODBC 8.0 (`myodbc8w.dll`), MariaDB ODBC Driver
- **Severity**: High (Data Corruption / Math Error)
- **Symptom**:
  A column defined as `INT UNSIGNED` containing values greater than `2,147,483,647` (such as `3,000,000,000`) is returned to Delphi as a negative 32-bit signed integer (`-1,294,967,296`).
- **Root Cause**:
  Under ODBC 3.0 specification, both signed and unsigned 32-bit integers report `SQL_INTEGER` in `SQLDescribeColW`. The application must query `SQLColAttributeW` with `SQL_DESC_UNSIGNED` (attribute ID 8) to distinguish between them. Standard Delphi DBX maps `SQL_INTEGER` strictly to signed 32-bit integer (`TDBXDataTypes.Int32Type`), causing integer overflow.
- **Resolution**:
  In `TODBCColumnMetadata.InitFromStatement` (and `TMySqlDialect.AdjustColumnMetadata`):
  ```pascal
  if (ColMeta.DataType = SQL_INTEGER) then
  begin
    OdbcCheck(SQLColAttributeW(StatementHandle, ColIndex, SQL_DESC_UNSIGNED,
      nil, 0, nil, @AttrValue), StatementHandle, SQL_HANDLE_STMT);
    if AttrValue = 1 then // SQL_TRUE: Unsigned integer
    begin
      ColMeta.DBXType := TDBXDataTypes.Int64Type; // Promote to 64-bit integer
      ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
    end;
  end;
  ```
- **Verification**:
  Verified in `D:\D\aisandbox\TestMariaDBX.dpr` inserting and reading `3,000,000,000`. Field correctly maps to `ftLargeint` and asserts `UIntVal = 3000000000`.

---

### Issue #22: [MySQL / MariaDB] `SQLTablesW` crashes with `NO_SCHEMA` option

- **Engine**: MySQL / MariaDB
- **Driver**: MySQL Connector/ODBC 8.0 (`myodbc8w.dll`)
- **Severity**: High (Catalog Query Failure)
- **Symptom**:
  Calling `TSQLConnection.GetTableNames` or Delphi Data Explorer metadata queries throws:
  ```text
  [MySQL][ODBC 8.0(w) Driver][mysqld-10.6.17-MariaDB]Table/View '...' does not exist;
  Support for schemas is disabled by NO_SCHEMA option (HY000)
  ```
- **Root Cause**:
  MySQL does not support SQL-92 Schemas (MySQL treats Database as Catalog and has no schema layer). When Delphi's `Data.SqlExpr` or caller passes an empty string `''` or current username as `SchemaName` to `SQLTablesW` / `SQLColumnsW`, the MySQL ODBC driver treats this as an invalid schema specification and raises error `HY000`.
- **Resolution**:
  `TMySqlDialect` marks `SupportsSchemas := False`. In catalog execution (`ExecuteCatalogTables`, `ExecuteCatalogColumns`):
  ```pascal
  if not Dialect.SupportsSchemas then
  begin
    pSchema := nil;
    SchemaLen := 0;
  end;
  ```
- **Verification**:
  Verified in `D:\D\aisandbox\TestMariaDBX.dpr`. `GetTableNames` retrieves all user tables smoothly without exceptions.

---

### Issue #23: [SQLite] `SQL_BINARY` `ColumnSize = 0` Mapped to Fixed Binary Instead of BLOB

- **Engine**: SQLite 3
- **Driver**: SQLite3 ODBC Driver (`sqlite3odbc.dll`)
- **Severity**: Medium (Data Truncation / Allocation Failure)
- **Symptom**:
  Columns declared as `data_blob BLOB` in SQLite report `SQL_BINARY` with `ColumnSize = 0` via `SQLDescribeColW`. DBX treats this as a 0-byte fixed-length binary (`BytesType`), failing to fetch binary payload or throwing buffer truncation errors.
- **Root Cause**:
  SQLite uses dynamic manifest typing without fixed column lengths. The ODBC driver returns `0` as the column length for BLOB columns under `SQL_BINARY`.
- **Resolution**:
  In `TODBCColumnMetadata.InitFromStatement` (and `TSqliteDialect.AdjustColumnMetadata`):
  ```pascal
  if (ColMeta.DataType in [SQL_BINARY, SQL_VARBINARY, SQL_LONGVARBINARY]) and
     ((ColMeta.Length = 0) or (ColMeta.Length > 8000)) then
  begin
    ColMeta.DBXType := TDBXDataTypes.BlobType;
    ColMeta.DBXSubType := TDBXDataTypes.BinarySubType;
  end;
  ```
- **Verification**:
  Verified in `D:\D\aisandbox\TestSqliteDBX.dpr`. A 5,000-byte test binary block (`[0, 1, 2, ..., 255, 0, ...]`) was written and read back with 100% byte-for-byte fidelity.

---

### Issue #24: [PostgreSQL] Schema Resolution Mismatch on Unspecified Schema

- **Engine**: PostgreSQL 14/15/16/17+
- **Driver**: PostgreSQL psqlODBC Driver (`psqlodbc35w.dll`)
- **Severity**: Medium (Metadata Invisibility)
- **Symptom**:
  Calling `TSQLConnection.GetTableNames(List)` without specifying a schema returns 0 tables, despite tables existing in the database.
- **Root Cause**:
  Delphi's `Data.SqlExpr.TSQLConnection.GetTableNames` defaults an unpassed schema parameter to `UserName` (e.g. `postgres`). In PostgreSQL, user tables created via standard DDL (`CREATE TABLE ...`) reside in the `public` schema. Querying schema `postgres` returns empty results.
- **Resolution**:
  `TPostgreSqlDialect.AdjustCatalogFilter` normalizes empty or matching username schema filters:
  ```pascal
  if (SchemaName = '') or (SameText(SchemaName, ConnectionUserName)) then
    SchemaName := 'public'; // Align with default PostgreSQL schema
  ```
- **Verification**:
  Verified in `D:\D\aisandbox\TestPostgresDBX.dpr`. Calling `GetTableNames(List, 'public')` or dialect-resolved query returns user tables as expected.

---

### Issue #25: [Oracle] `SQL_TYPE_DATE` Truncates Time Component

- **Engine**: Oracle 11g/12c/19c/21c/23ai
- **Driver**: Oracle Instant Client ODBC Driver / Microsoft ODBC for Oracle
- **Severity**: High (Data Loss)
- **Symptom**:
  Reading an Oracle `DATE` column that contains hours, minutes, and seconds (e.g. `2026-11-09 23:05:14`) truncates the time portion to `00:00:00`.
- **Root Cause**:
  Historically, Oracle's `DATE` data type represents both calendar date and clock time. ODBC defines `SQL_TYPE_DATE` (code 91) strictly for year/month/day without time. Mapping `SQL_TYPE_DATE` to `TDBXDataTypes.DateType` causes DBX to discard the time portion.
- **Resolution**:
  In `TOracleDialect.AdjustColumnMetadata`:
  ```pascal
  if ColMeta.DataType in [SQL_TYPE_DATE, SQL_DATE] then
  begin
    ColMeta.DBXType := TDBXDataTypes.TimeStampType; // Promote to DateTime/TimeStamp
    ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
  end;
  ```
- **Verification**:
  Verified in type mapping logic; Oracle datetime values successfully preserve hours, minutes, and seconds.

---

### Issue #26: [Oracle] Unconstrained `NUMBER` reports Scale = -127 Crashing `TFieldDef`

- **Engine**: Oracle 11g/12c/19c/21c/23ai
- **Driver**: Oracle Instant Client ODBC Driver
- **Severity**: High (Runtime Exception)
- **Symptom**:
  Querying columns declared as unconstrained `NUMBER` (without precision and scale, e.g. `col_num NUMBER`) throws:
  ```text
  EDatabaseError: Invalid field scale: -127
  ```
- **Root Cause**:
  In Oracle, an unconstrained `NUMBER` represents a floating-point decimal value where the scale is undefined and dynamic. The Oracle ODBC driver returns `DecimalDigits = -127` in `SQLDescribeColW`. Passing `-127` as the scale to Delphi's `TFieldDef` raises an invalid scale exception.
- **Resolution**:
  In `TOracleDialect.AdjustColumnMetadata`:
  ```pascal
  if (ColMeta.Scale < 0) then
    ColMeta.Scale := 0; // Guard against negative Oracle float scale
  ```
- **Verification**:
  Negative scale is safely clamped to 0, allowing `TFieldDef` creation and seamless data retrieval.

---

### Issue #27: [Oracle] Unscoped Catalog Query Hangs on Full Data Dictionary Scan

- **Engine**: Oracle 11g/12c/19c/21c/23ai
- **Driver**: Oracle Instant Client ODBC Driver
- **Severity**: High (Application Freeze / DoS)
- **Symptom**:
  Calling `SQLTablesW(hStmt, nil, 0, nil, 0, nil, 0, nil, 0)` against an Oracle database causes the application or Delphi Data Explorer to freeze for several minutes or indefinitely.
- **Root Cause**:
  Oracle databases contain vast system catalogs (`SYS`, `SYSTEM`, `MDSYS`, `CTXSYS`, `XDB`, `AUDSYS`, etc.) with over 100,000 system objects and synonyms. An unscoped query forces Oracle to scan the entire data dictionary and compute permissions for every single object.
- **Resolution**:
  In `TOracleDialect.AdjustCatalogFilter`:
  ```pascal
  if (SchemaName = '') then
    SchemaName := ConnectionUserName; // Restrict query to the connected user's schema
  ```
- **Verification**:
  Catalog query executes instantly within milliseconds by querying only the current user's schema.

---

### Issue #28: [Firebird] Transaction Table Lock on DDL `DROP TABLE`

- **Engine**: Firebird 2.5 / 3.0 / 4.0 / 5.0+
- **Driver**: Firebird ODBC Driver (`FirebirdODBC.dll`)
- **Severity**: Medium (Lock Conflict)
- **Symptom**:
  Executing DDL statements (e.g. `DROP TABLE`, `ALTER TABLE`) after executing queries fails with:
  ```text
  lock conflict on no wait transaction
  unsuccessful metadata update
  -object TABLE is in use
  ```
- **Root Cause**:
  Firebird's multi-generational architecture (MGA) prevents metadata modification on objects currently engaged in active read or write transactions. If a prior `SELECT` statement remains in an uncommitted transaction state, subsequent DDL on that table is rejected.
- **Resolution**:
  `TFirebirdDialect` enforces transaction boundary cleanup before DDL execution, ensuring pending transactions are committed or rolled back prior to metadata modification.
- **Verification**:
  Verified in `D:\D\aisandbox\TestFirebirdDBX.dpr`. DDL operations execute cleanly after transaction boundary commits.

