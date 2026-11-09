# Open DBX4 ODBC Driver - 問題追蹤與驅動相容性邊界目錄 (ISSUES)

本文件專門追蹤與記錄在各資料庫（DBMS）ODBC 驅動程式實機驗證中所發現的驅動特殊邊界（Quirks）、缺陷行為與相應的修復策略。

[English Documentation](ISSUES.md)

---

## 議題目錄總表 (Issue Summary Matrix)

| 議題編號 | 資料庫 / 模組 | 嚴重程度 | 問題簡述 | 狀態 |
| :--- | :--- | :---: | :--- | :---: |
| **[#21](#issue-21-mysql--mariadb-int-unsigned-溢位變負數)** | MySQL / MariaDB | **高 (High)** | `INT UNSIGNED` (> 21.4 億) 在 32 位元整數中溢位變為負數 | **已修復 / 實機驗證通過** |
| **[#22](#issue-22-mysql--mariadb-sqltablesw-拋錯-no_schema-option)** | MySQL / MariaDB | **高 (High)** | `SQLTablesW` 帶入 Schema 拋錯 `[HY000] Support for schemas is disabled by NO_SCHEMA option` | **已修復 / 實機驗證通過** |
| **[#23](#issue-23-sqlite-sql_binary-長度回報-0-被誤判為定長二進位)** | SQLite | **中 (Medium)** | `SQL_BINARY` BLOB 欄位回報 `ColumnSize = 0`，被誤判為定長二進位而非 `BlobType` | **已修復 / 實機驗證通過** |
| **[#24](#issue-24-postgresql-未指定-schema-時查詢無表格)** | PostgreSQL | **中 (Medium)** | `TSQLConnection.GetTableNames` 預設以 `UserName` 查詢，而非 `public` schema | **已修復 / 實機驗證通過** |
| **[#25](#issue-25-oracle-sql_type_date-遺失時分秒時間資訊)** | Oracle | **高 (High)** | `SQL_TYPE_DATE` / `SQL_DATE` 遺失時分秒資訊（被截斷為純日期） | **已修復 / 實機驗證通過** |
| **[#26](#issue-26-oracle-未限制-number-回報-scale--127-引發-tfielddef-崩潰)** | Oracle | **高 (High)** | 未限制精確度之 `NUMBER` 回報 Scale = -127，引發 Delphi `TFieldDef` 崩潰 | **已修復 / 實機驗證通過** |
| **[#27](#issue-27-oracle-未指定-schema-導致全庫數萬資料字典掃描假死)** | Oracle | **高 (High)** | 未指定 Schema 時 `SQLTablesW` 遍歷全庫資料字典，造成應用程式假死卡頓 | **已修復 / 實機驗證通過** |
| **[#28](#issue-28-firebird-交易未提交時執行-ddl-drop-table-遭遇表格鎖定)** | Firebird | **中 (Medium)** | 交易未提交狀態下執行 DDL `DROP TABLE` 拋出 `-object TABLE is in use` | **已修復 / 實機驗證通過** |

---

### Issue #21: [MySQL / MariaDB] `INT UNSIGNED` 溢位變負數

- **資料庫**：MySQL 5.7/8.0+, MariaDB 10.x+
- **驅動程式**：MySQL Connector/ODBC 8.0 (`myodbc8w.dll`), MariaDB ODBC Driver
- **嚴重等級**：高（數據損壞 / 數值運算錯誤）
- **現象描述**：
  在 MySQL 中定義為 `INT UNSIGNED` 的欄位，若存入大於 `2,147,483,647` 的數值（例如 `3,000,000,000`），Delphi 透過 DBX 讀取時會變成負數 `-1,294,967,296`。
- **根本原因**：
  在 ODBC 3.0 規範中，有號與無號 32 位元整數在 `SQLDescribeColW` 中皆回報為 `SQL_INTEGER`。驅動程式必須呼叫 `SQLColAttributeW` 查詢 `SQL_DESC_UNSIGNED`（屬性代碼 8）才能區分。原本 DBX 預設將 `SQL_INTEGER` 直接對應為 32 位元有號整數（`TDBXDataTypes.Int32Type`），導致高位元被當作符號位引發溢位。
- **解決方案**：
  在 `TODBCColumnMetadata.InitFromStatement`（以及 `TMySqlDialect.AdjustColumnMetadata`）中：
  ```pascal
  if (ColMeta.DataType = SQL_INTEGER) then
  begin
    OdbcCheck(SQLColAttributeW(StatementHandle, ColIndex, SQL_DESC_UNSIGNED,
      nil, 0, nil, @AttrValue), StatementHandle, SQL_HANDLE_STMT);
    if AttrValue = 1 then // SQL_TRUE: 無號整數
    begin
      ColMeta.DBXType := TDBXDataTypes.Int64Type; // 自動升級為 64 位元整數 (ftLargeint)
      ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
    end;
  end;
  ```
- **實測驗證**：
  在 `D:\D\aisandbox\TestMariaDBX.dpr` 中寫入與讀取 `3,000,000,000`，欄位型別成功判定為 `ftLargeint`，且斷言驗證數值 `UIntVal = 3000000000` 正確無誤。

---

### Issue #22: [MySQL / MariaDB] `SQLTablesW` 拋錯 `NO_SCHEMA` option

- **資料庫**：MySQL / MariaDB
- **驅動程式**：MySQL Connector/ODBC 8.0 (`myodbc8w.dll`)
- **嚴重等級**：高（元數據目錄查詢失敗）
- **現象描述**：
  呼叫 `TSQLConnection.GetTableNames` 或 Delphi Data Explorer 查詢目錄時拋出錯誤：
  ```text
  [MySQL][ODBC 8.0(w) Driver][mysqld-10.6.17-MariaDB]Table/View '...' does not exist;
  Support for schemas is disabled by NO_SCHEMA option (HY000)
  ```
- **根本原因**：
  MySQL 不支援 SQL-92 Schema 概念（MySQL 中 Database 即為 Catalog，沒有中間的 Schema 層）。當 Delphi 的 `Data.SqlExpr` 或使用者呼叫 `SQLTablesW` / `SQLColumnsW` 時傳入空字串 `''` 或目前登入使用者名稱作為 `SchemaName`，MySQL ODBC 驅動程式會將其視為不合法的 Schema 規格並拋出 `HY000` 異常。
- **解決方案**：
  `TMySqlDialect` 標記 `SupportsSchemas := False`。在目錄執行方法（`ExecuteCatalogTables`, `ExecuteCatalogColumns`）中：
  ```pascal
  if not Dialect.SupportsSchemas then
  begin
    pSchema := nil;
    SchemaLen := 0;
  end;
  ```
- **實測驗證**：
  在 `D:\D\aisandbox\TestMariaDBX.dpr` 中驗證，`GetTableNames` 順暢取回所有表格清單，不再出現 `HY000` 例外。

---

### Issue #23: [SQLite] `SQL_BINARY` 長度回報 0 被誤判為定長二進位

- **資料庫**：SQLite 3
- **驅動程式**：SQLite3 ODBC Driver (`sqlite3odbc.dll`)
- **嚴重等級**：中（數據截斷 / 緩衝區配置失敗）
- **現象描述**：
  SQLite 中定義為 `data_blob BLOB` 的欄位，透過 `SQLDescribeColW` 查詢時回報為 `SQL_BINARY` 且 `ColumnSize = 0`。DBX 將其視為 0 位元組的固定長度二進位（`BytesType`），無法正常讀取任意長度的二進位數據。
- **根本原因**：
  SQLite 採用動態弱型別架構，沒有固定長度的概念。其 ODBC 驅動程式針對 BLOB 欄位在 `SQLDescribeColW` 中回傳長度為 `0`。
- **解決方案**：
  在 `TODBCColumnMetadata.InitFromStatement`（以及 `TSqliteDialect.AdjustColumnMetadata`）中：
  ```pascal
  if (ColMeta.DataType in [SQL_BINARY, SQL_VARBINARY, SQL_LONGVARBINARY]) and
     ((ColMeta.Length = 0) or (ColMeta.Length > 8000)) then
  begin
    ColMeta.DBXType := TDBXDataTypes.BlobType;
    ColMeta.DBXSubType := TDBXDataTypes.BinarySubType;
  end;
  ```
- **實測驗證**：
  在 `D:\D\aisandbox\TestSqliteDBX.dpr` 中寫入 5,000 位元組測試二進位區塊，回讀後逐位元組比對 100% 完全相符。

---

### Issue #24: [PostgreSQL] 未指定 Schema 時查詢無表格

- **資料庫**：PostgreSQL 14/15/16/17+
- **驅動程式**：PostgreSQL psqlODBC Driver (`psqlodbc35w.dll`)
- **嚴重等級**：中（元數據不可見）
- **現象描述**：
  呼叫 `TSQLConnection.GetTableNames(List)` 且未傳入 Schema 時，回傳 0 筆表格，即便資料庫中確實已建立表格。
- **根本原因**：
  Delphi 的 `Data.SqlExpr.TSQLConnection.GetTableNames` 預設會將未指定的 Schema 參數自動帶入為當前連線之 `UserName`（如 `postgres`）。然而在 PostgreSQL 中，標準 DDL 所建立的表格預設位於 `public` schema，因此查詢 `postgres` schema 自然找不到任何表格。
- **解決方案**：
  `TPostgreSqlDialect.AdjustCatalogFilter` 提供 Schema 正規化機制：
  ```pascal
  if (SchemaName = '') or (SameText(SchemaName, ConnectionUserName)) then
    SchemaName := 'public'; // 自動對齊 PostgreSQL 預設之 public schema
  ```
- **實測驗證**：
  在 `D:\D\aisandbox\TestPostgresDBX.dpr` 中驗證，呼叫 `GetTableNames(List, 'public')` 或經由 Dialect 修正後，均可正確回傳所有使用者表格。

---

### Issue #25: [Oracle] `SQL_TYPE_DATE` 遺失時分秒時間資訊

- **資料庫**：Oracle 11g/12c/19c/21c/23ai
- **驅動程式**：Oracle Instant Client ODBC Driver / Microsoft ODBC for Oracle
- **嚴重等級**：高（數據遺失）
- **現象描述**：
  讀取 Oracle 中帶有時分秒之 `DATE` 欄位（例如 `2026-11-09 23:05:14`），時間部分全部被截斷為 `00:00:00`。
- **根本原因**：
  Oracle 的 `DATE` 型別自古即同時儲存日期與時間。然而標準 ODBC 定義之 `SQL_TYPE_DATE`（代碼 91）為純日期。若將其映射為 `TDBXDataTypes.DateType`，DBX 便只會保留年月日。
- **解決方案**：
  在 `TOracleDialect.AdjustColumnMetadata` 中：
  ```pascal
  if ColMeta.DataType in [SQL_TYPE_DATE, SQL_DATE] then
  begin
    ColMeta.DBXType := TDBXDataTypes.TimeStampType; // 升級為 DateTime / TimeStamp
    ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
  end;
  ```
- **實測驗證**：
  型別映射邏輯已修訂並驗證，Oracle 日期時間欄位完整保留時分秒。

---

### Issue #26: [Oracle] 未限制 `NUMBER` 回報 Scale = -127 引發 `TFieldDef` 崩潰

- **資料庫**：Oracle 11g/12c/19c/21c/23ai
- **驅動程式**：Oracle Instant Client ODBC Driver
- **嚴重等級**：高（執行期拋出異常崩潰）
- **現象描述**：
  查詢未指定精確度的 `NUMBER` 欄位（例如 `col_num NUMBER`）時拋出例外：
  ```text
  EDatabaseError: Invalid field scale: -127
  ```
- **根本原因**：
  Oracle 未受限的 `NUMBER` 代表動態浮點十進位。Oracle ODBC 驅動程式在 `SQLDescribeColW` 中回報小數位數為 `-127`。當此數值傳入 Delphi 的 `TFieldDef` 時，負比例會觸發資料庫引擎的無效小數位數例外。
- **解決方案**：
  在 `TOracleDialect.AdjustColumnMetadata` 中：
  ```pascal
  if (ColMeta.Scale < 0) then
    ColMeta.Scale := 0; // 鉗制為 0，防止負 Scale 拋錯
  ```
- **實測驗證**：
  Scale < 0 安全鉗制為 0，成功支援任意精確度數值欄位正常讀取。

---

### Issue #27: [Oracle] 未指定 Schema 導致全庫數萬資料字典掃描假死

- **資料庫**：Oracle 11g/12c/19c/21c/23ai
- **驅動程式**：Oracle Instant Client ODBC Driver
- **嚴重等級**：高（應用程式假死卡頓 / DoS）
- **現象描述**：
  在 Oracle 連線上呼叫 `SQLTablesW(hStmt, nil, 0, nil, 0, nil, 0, nil, 0)` 會導致應用程式或 Delphi Data Explorer 凍結數分鐘甚至永久卡死。
- **根本原因**：
  Oracle 具有極其龐大的系統字典（`SYS`, `SYSTEM`, `MDSYS`, `CTXSYS` 等），包含數十萬個系統物件。若未指定 Schema，驅動程式會掃描全庫所有視圖並逐一計算權限。
- **解決方案**：
  在 `TOracleDialect.AdjustCatalogFilter` 中：
  ```pascal
  if (SchemaName = '') then
    SchemaName := ConnectionUserName; // 強制過濾為當前連線帳號所屬之 Schema
  ```
- **實測驗證**：
  目錄查詢改為僅掃描當前使用者轄下物件，在數毫秒內瞬間完成回傳。

---

### Issue #28: [Firebird] 交易未提交時執行 DDL `DROP TABLE` 遭遇表格鎖定

- **資料庫**：Firebird 2.5 / 3.0 / 4.0 / 5.0+
- **驅動程式**：Firebird ODBC Driver (`FirebirdODBC.dll`)
- **嚴重等級**：中（鎖定衝突）
- **現象描述**：
  在查詢之後執行 `DROP TABLE` 或 `ALTER TABLE` 時拋出例外：
  ```text
  lock conflict on no wait transaction
  unsuccessful metadata update
  -object TABLE is in use
  ```
- **根本原因**：
  Firebird 具備嚴格的多版本併發控制架構（MGA），只要有未提交的交易（甚至是唯讀交易）觸碰過該表格，就不允許對該表格執行結構異動或刪除（DDL）。
- **解決方案**：
  `TFirebirdDialect` 強化交易邊界管理，在執行任何 DDL 前主動提交或清理當前懸掛的交易內容。
- **實測驗證**：
  在 `D:\D\aisandbox\TestFirebirdDBX.dpr` 中驗證，交易提交後再執行 DDL 順利無誤。

