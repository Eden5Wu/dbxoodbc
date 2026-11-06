# DBX4 Remastered (dbxoodbc)

純原生 Delphi dbExpress (DBX4) ODBC 驅動程式 (支援 Win32 & Win64)

[English Documentation](README.md)

---

## 專案資訊

- **驅動名稱 (Driver Name)**：`DbxOpenOdbc`（或 `OpenOdbc`）
- **版本 (Version)**：`4.2026.11.06` (DBX4 Remastered)
- **架構**：100% 純 Pascal 原生 DBX4 (`Data.DBXCommon`)
- **支援平台**：Windows 32 位元 (Win32) 與 64 位元 (Win64)
- **支援 Delphi 版本**：RAD Studio XE2 至 12 Athens、13+
- **原始專案與作者**：[Open DbExpress (SourceForge)](http://sourceforge.net/projects/open-dbexpress/) by Edward Benson, Vadim V. Lopushansky (2001-2012)
- **重構與現代化**：Eden Wu (2019-2026) — Native DBX4 純 Pascal 架構重構
- **授權協議**：GNU Lesser General Public License (LGPL) 2.1 or later
- **專案原始庫**：[https://github.com/Eden5Wu/dbxoodbc](https://github.com/Eden5Wu/dbxoodbc)

---

## 1. 初次使用工程師導讀 (Getting Started Guide)

**DBX4 Remastered** 是一套專為現代 Delphi 設計的輕量、極速、純原生 dbExpress (DBX4) ODBC 驅動程式。

如果您正在開發、維護或現代化升級 Delphi 資料庫系統（例如 ERP、MES、POS、金融交易軟體），本驅動程式能為您提供**最無負擔、開箱即用**的連線體驗：

### 為什麼選擇 DBX4 Remastered？
- **零外部 DLL 部署 (Zero-DLL Deployment)**：徹底擺脫舊版歷史包袱，不需要隨程式部署 `dbxoodbc.dll`、`dbxadapter30.dll` 或任何第三方 DLL。底層直接對接 Windows 作業系統內建的標準 ODBC 管理員 (`odbc32.dll`)。
- **免安裝 BPL 套件 (Zero-BPL Requirement)**：程式編譯與執行**完全不需要**在 IDE 安裝任何設計期套件 (`.bpl`)。只要將 3 個原始碼檔案放進專案，編譯後便是一體成型的原生二進位執行檔。
- **全方位多資料庫支援 (Universal Multi-DBMS)**：標準通用 ODBC 規格，無縫連線 Microsoft SQL Server、PostgreSQL、MySQL / MariaDB、SQLite、Oracle、Microsoft Access 等任意資料庫。
- **Win32 & Win64 雙平台原生支援**：一套共用程式碼，完美支援 32 位元與 64 位元編譯。
- **無縫相容 ADO/OLE DB 連線字串**：若您正著手將舊版 ADO (`TADOConnection`) 程式遷移至 dbExpress，您可以直接傳入現有的 ADO 連線字串，驅動程式內建的智慧轉譯器會自動轉換，完全免改字串。
- **驅動世代自動偵測與現代安全性**：自動偵測並綁定客戶端電腦上已安裝的最新版 SQL Server 驅動（ODBC Driver 18, 17, 13, 11 或 SQL Native Client），內建 SSL 憑證防呆機制（`TrustServerCertificate=yes`）與高速 TCP/IP 連線。

---

## 2. 快速上手（30 秒完成連線）

### 步驟 1：將原始碼加入專案
將 `source/` 目錄加入專案的 **Search Path**（或直接把以下 3 個原始碼檔案拉進專案）：
- `source/OdbcApi.pas`
- `source/DbxOpenOdbcCore.pas`
- `source/DbxOpenOdbcDriver.pas`

### 步驟 2：引用驅動單元
在您的 Form 或 DataModule 程式碼中加入 `DbxOpenOdbcDriver`：

```delphi
uses
  Data.DB, Data.SqlExpr, DbxOpenOdbcDriver;
```

### 步驟 3：建立 TSQLConnection 並開啟連線

```delphi
procedure TForm1.ConnectDatabase;
var
  SQLConn: TSQLConnection;
  Query: TSQLQuery;
begin
  SQLConn := TSQLConnection.Create(nil);
  try
    SQLConn.DriverName := 'DbxOpenOdbc';
    SQLConn.GetDriverFunc := 'getSQLDriverODBCW';
    SQLConn.LibraryName := 'DbxOpenOdbcDriver';
    SQLConn.VendorLib := 'ODBC32.DLL';
    SQLConn.LoginPrompt := False;

    // 寫法 A：Microsoft SQL Server（支援具名執行個體如 .\SQLEXPRESS 與 Shared Memory）
    SQLConn.Params.Values['ConnectionString'] :=
      'Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=DBDEMOS;Uid=sa;Pwd=secret;';

    // 寫法 B：PostgreSQL
    // SQLConn.Params.Values['ConnectionString'] :=
    //   'Driver={PostgreSQL Unicode};Server=localhost;Port=5432;Database=mydb;Uid=postgres;Pwd=secret;';

    // 寫法 C：MySQL / MariaDB
    // SQLConn.Params.Values['ConnectionString'] :=
    //   'Driver={MySQL ODBC 8.0 Unicode Driver};Server=localhost;Port=3306;Database=mydb;Uid=root;Pwd=secret;';

    // 寫法 D：SQLite
    // SQLConn.Params.Values['ConnectionString'] :=
    //   'Driver={SQLite3 ODBC Driver};Database=C:\Data\app.db;';

    // 寫法 E：直接傳入現有 ADO / OLE DB 連線字串（智慧自動轉譯！）
    // SQLConn.Params.Values['Database'] :=
    //   'Provider=SQLOLEDB;Data Source=127.0.0.1;Initial Catalog=ADBDEMOS;User ID=sa;Password=secret;';

    SQLConn.Open;

    // 使用標準 TSQLQuery 執行查詢
    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := SQLConn;
      Query.SQL.Text := 'SELECT TOP 10 CustNo, Company FROM Customer';
      Query.Open;
      while not Query.Eof do
      begin
        Writeln(Query.FieldByName('Company').AsString);
        Query.Next;
      end;
    finally
      Query.Free;
    end;
  finally
    SQLConn.Free;
  end;
end;
```

---

## 3. 連線字串與智慧轉譯引擎 (Connection Strings & Smart Translation)

### 3.1 參數讀取入口（依優先順序）
驅動程式會依序自 `TSQLConnection.Params` 讀取連線字串：
1. `SQLConnection.Params.Values['ConnectionString']` *(最推薦的現代標準入口)*
2. `SQLConnection.Params.Values['Database']` *(標準 DBX 相容屬性；亦可直接塞入整串連線字串)*
3. `SQLConnection.Params.Values['Custom String']` *(舊版 3.x 歷史相容屬性)*

> **相容性提醒**：若 `Database` 或 `Custom String` 含有完整連線字串（如開頭為 `Provider=` 或 `Driver=`），驅動會自動優先採納，避免空範本覆蓋設定。

### 3.2 ADO / OLE DB 參數自動映射表
直接傳入 ADO 連線字串時，智慧轉譯引擎會自動對應至原生 ODBC 參數：

| ADO / OLE DB 參數名稱 | 自動轉譯後之原生 ODBC 參數 | 說明與用途 |
| :--- | :--- | :--- |
| `Provider=SQLOLEDB / MSOLEDBSQL / SQLNCLI...` | `Driver={系統安裝之最佳 SQL 驅動}` | 自動由新到舊匹配最佳現代驅動 |
| `Data Source=...` / `Address=...` | `Server=...` | 伺服器主機名或 IP 與 Port |
| `Initial Catalog=...` | `Database=...` | 資料庫名稱 |
| `User ID=...` | `Uid=...` | 登入帳號 |
| `Password=...` | `Pwd=...` | 登入密碼 |
| `Integrated Security=SSPI` | `Trusted_Connection=yes` | Windows 整合身分驗證 |
| `Application Name=...` / `Application_Name=...` | `APP=...` | 於 SQL Server Profiler 之 `ApplicationName` 即時顯示 |
| `Workstation ID=...` | `WSID=...` | 於 SQL Server Profiler 之 `HostName` 顯示機台名稱 |

### 3.3 主流資料庫連線字串速查 (DBMS Quick Reference)
本驅動程式為通用標準 ODBC 規範，可連線至任何支援 ODBC 的關聯式資料庫。專案於 `demos/connections/` 內提供各主流資料庫的連線範例單元：

| 資料庫系統 (DBMS) | 建議 ODBC 驅動程式 | 連線字串 (ConnectionString) 範例 | 範例單元 |
| :--- | :--- | :--- | :--- |
| **Microsoft SQL Server** | ODBC Driver 18/17 for SQL Server | `Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=mydb;Uid=sa;Pwd=secret;` | [`dbx_mssql_connect.pas`](demos/connections/dbx_mssql_connect.pas) |
| **PostgreSQL** | PostgreSQL Unicode / ANSI | `Driver={PostgreSQL Unicode};Server=localhost;Port=5432;Database=mydb;Uid=postgres;Pwd=secret;` | [`dbx_postgresql_connect.pas`](demos/connections/dbx_postgresql_connect.pas) |
| **MySQL / MariaDB** | MySQL ODBC 8.0/9.0 Unicode Driver | `Driver={MySQL ODBC 8.0 Unicode Driver};Server=localhost;Port=3306;Database=mydb;Uid=root;Pwd=secret;` | [`demos/connections/`](demos/connections/) |
| **SQLite** | SQLite3 ODBC Driver | `Driver={SQLite3 ODBC Driver};Database=C:\Data\app.db;` | [`dbx_sqlite_connect.pas`](demos/connections/dbx_sqlite_connect.pas) |
| **Oracle Database** | Oracle in OraClient / Instant Client | `Driver={Oracle in OraClient19Home1};Dbq=ORCL;Uid=scott;Pwd=tiger;` | [`dbx_ora_connect.pas`](demos/connections/dbx_ora_connect.pas) |
| **Microsoft Access** | Microsoft Access Driver (*.mdb, *.accdb) | `Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=C:\Data\mydb.accdb;` | [`dbx_access_connect.pas`](demos/connections/dbx_access_connect.pas) |
| **SAP Sybase ASE** | Adaptive Server Enterprise | `Driver={Adaptive Server Enterprise};Server=127.0.0.1;Port=5000;Database=mydb;Uid=sa;Pwd=secret;` | [`dbx_sybase_connect.pas`](demos/connections/dbx_sybase_connect.pas) |

---

## 4. 擴充功能與連線參數 (Extended Features & Options)

擴充參數可透過 **`SQLConnection.Params` 獨立設定**，亦可直接**包在連線字串中**。

### 4.1 `TrimFixedChar`（自動修剪定長字串尾隨空白）
- **功能描述**：自動移除定長字元欄位（`CHAR`、`NCHAR`、`ftFixedChar`）結尾的補滿空白。
- **預設值**：`True`（預設開啟）
- **解決的痛點**：SQL Server 對於 `CHAR(10)` 未滿長度時會強制補空白（例如存入 `'ABC'` 實際為 `'ABC       '`）。若未修剪，Delphi 字串比對 `Field.AsString = 'ABC'` 會失敗判定為不相等。開啟此選項後自動消除尾隨空白，免去全專案手動寫 `Trim()` 的痛苦。
- **相容別名**：`Trim Char`、`TrimChar`、`Trim Fixed Char`
- **設定範例**：
  ```delphi
  SQLConnection1.Params.Values['TrimFixedChar'] := 'True'; // 或設為 'False' 保留原樣空白
  ```

### 4.2 `TrimVarChar`（修剪變長字串尾隨空白）
- **功能描述**：選用功能，移除可變長度字元欄位（`VARCHAR`、`NVARCHAR`）結尾的空白。
- **預設值**：`False`（預設關閉）
- **使用建議**：變長字串本身不會被資料庫自動補空白，只有在使用者特意輸入或舊資料轉檔時才會有尾端空白。為避免破壞特定排版格式，預設關閉；若資料庫存在髒資料需強制過濾時可設為 `True`。
- **相容別名**：`Trim Var Char`
- **設定範例**：
  ```delphi
  SQLConnection1.Params.Values['TrimVarChar'] := 'True';
  ```

### 4.3 `UseUnicode`
- **功能描述**：啟用或停用字元欄位（`NCHAR`、`NVARCHAR`、`NTEXT`）的 Unicode 欄位映射。
- **預設值**：`True`
- **設定選項**：
  - `UseUnicode=True`：
    - `nchar` / `nvarchar` 映射為 `ftWideString` (`TWideStringField`)。
    - `ntext` / `nvarchar(max)` 映射為 `ftWideMemo` (`TWideMemoField`)。
  - `UseUnicode=False`：
    - `nchar` 映射為 `ftFixedChar` (`TStringField`)。
    - `nvarchar` 映射為 `ftString` (`TStringField`)。
    - `ntext` / `nvarchar(max)` 映射為 `ftMemo` (`TMemoField`)。
    - 避免既有 `.dfm` 靜態宣告的 `TStringField` 或 `TMemoField` 欄位發生 `Type mismatch: expecting String actual WideString` 錯誤。

- **設定範例**：
  ```delphi
  SQLConnection1.Params.Values['UseUnicode'] := 'True';  // 或 'False'
  ```

### 4.4 `MARS_Connection`（多重作用中結果集）
- **功能描述**：啟用 SQL Server 多重結果集並行查詢技術。
- **預設值**：自動為 SQL Server 連線啟用 (`MARS_Connection=yes`)
- **解決的痛點**：標準 ODBC 在單一連線上若有尚未 Fetch 完的 Query，會鎖死連線並拋出 `[HY000] Connection is busy with results for another command`。啟用 MARS 後，單一連線可同時開啟多個 Dataset 自由操作。

### 4.5 SQL Server Profiler 即時監控追蹤
- **`APP` / `Application Name`**：在 SQL Server Profiler（`ApplicationName` 欄位）及 `sys.dm_exec_sessions` 即時顯示您的系統名稱。
- **`WSID` / `Workstation ID`**：在 SQL Server Profiler（`HostName` 欄位）顯示用戶端的電腦名稱。
- **設定範例**：
  ```delphi
  SQLConnection1.Params.Values['ConnectionString'] := 
    'Driver={ODBC Driver 17 for SQL Server};Server=...;Database=...;APP=ERP_人資系統;WSID=PC_HR01;';
  ```


### 4.6 `SchemaOverride`（預設結構描述覆寫與中繼資料加速）
- **功能描述**：定義結構描述（Schema）的萬用對應規則，在查詢未帶 Schema 前綴的資料表時，自動指定預設 Schema（如 `dbo`）。
- **預設值**：無（隨附之 MSSQL 連線設定檔已預設配置為 `%.dbo`）。
- **設定語法**：`[CatalogPattern.]ReplacementSchema`
  - `SchemaOverride=%.dbo`：比對任意 Catalog（`%`），並將中繼資料解析導向 `dbo` Schema。
- **工程師必知核心效益**：
  - **確保正確抓取主鍵與索引（`pfInKey`）**：當 `TSQLQuery.GetMetadata = True` 或 `TSQLDataSet` 查詢表格架構時，dbExpress 會執行 `GetIndexColumns`。若未設定 `SchemaOverride`，驅動程式或 IDE 設計期可能會全庫跨 Schema 搜尋或比對失敗，導致 `IndexDefs` 為空、欄位無法取得 **`pfInKey`**。
  - **大幅加速中繼資料查詢**：明確限縮在指定 Schema（如 `dbo`），避免大型資料庫在跨多個 Schema 時反覆掃描系統型錄造成的延遲。
  - **確保 DataSnap / Provider 正確回寫**：避免 `TDataSetProvider.ApplyUpdates` 因同名表格跨 Schema 造成 SQL 解析歧義。
- **設定範例**：
  - 在 Delphi 程式碼中：
    ```delphi
    SQLConnection1.Params.Values['SchemaOverride'] := '%.dbo';
    ```
  - 在 `dbxdrivers.ini` / `dbxconnections.ini` 設定檔中：
    ```ini
    [MSSQL_Native_ODBC]
    SchemaOverride=%.dbo
    ```

#### 主流資料庫 `SchemaOverride` 支援與適用性一覽表

| 資料庫系統 | 支援度 | 典型設定範例 | 說明 |
| :--- | :---: | :--- | :--- |
| **Microsoft SQL Server** | **必須 / 強烈推薦** | `SchemaOverride=%.dbo` | 確保預設 `dbo` 與自訂結構描述正確解析，使主鍵 `pfInKey` 正常取得。 |
| **Oracle** | **支援 / 推薦** | `SchemaOverride=%.LOGIN_ID` | 當登入帳號與資料表擁有者不同時必用（**名稱須大寫**）。 |
| **PostgreSQL** | **支援 / 推薦** | `SchemaOverride=%.public` | 支援多 Schema 架構，預設覆寫為 `public`。 |
| **MySQL / MariaDB** | **不適用 (禁用)** | *(留空，不設定)* | 僅具備 Database (Catalog) 概念而無獨立 Schema 分層，設定反而會導致查詢失效。 |
| **SQLite / MS Access** | **不適用 (無此概念)** | *(留空，不設定)* | 單一檔案結構，不具備 Schema 分層。 |
---

## 5. 通用資料型別映射規範 (Data Type Mapping Reference)

本驅動程式遵循標準 ODBC SQL 資料型別（`SQL_CHAR`, `SQL_VARCHAR`, `SQL_WVARCHAR`, `SQL_INTEGER`, `SQL_TYPE_TIMESTAMP` 等）進行通用映射。以下以型別豐富的 Microsoft SQL Server 作為具體型別對照參照表（其他資料庫之對應型別如 PostgreSQL `VARCHAR`/`BYTEA`、MySQL `DATETIME`/`BLOB`、SQLite `TEXT`/`INTEGER` 均自動對應至相同標準 DBX4 欄位型別）：



| SQL Server 類型 | Delphi 欄位型態 (`TFieldType`) | VCL 欄位類別 (`TField`) | 說明與備註 |
| :--- | :--- | :--- | :--- |
| **int** | `ftInteger` | `TIntegerField` | 32 位元整數 |
| **bigint** | `ftLargeint` | `TLargeIntField` | 原生 64 位元長整數 |
| **smallint** | `ftInteger` | `TIntegerField` | 提升至 32 位元整數 |
| **tinyint** | `ftSmallint` | `TSmallIntField` | 16 位元短整數 |
| **bit** | `ftBoolean` | `TBooleanField` | 布林值 |
| **decimal / numeric** | `ftFMTBcd` | `TFMTBCDField` | 高精度 BCD 浮點數，無截斷風險 |
| **money / smallmoney** | `ftFMTBcd` | `TFMTBCDField` | 貨幣精確度 BCD |
| **float** | `ftFloat` | `TFloatField` | 64 位元雙倍精度浮點數 |
| **real** | `ftSingle` | `TSingleField` | 32 位元單倍精度浮點數 |
| **datetime / smalldatetime** | `ftTimeStamp` | `TSQLTimeStampField` | 完整毫秒時間戳記 |
| **date** | `ftDate` | `TDateField` | 純日期 |
| **time** | `ftTime` | `TTimeField` | 純時間 |
| **datetimeoffset** | `ftTimeStampOffset` | `TSQLTimeStampOffsetField` | 帶時區位移之時間戳記 |
| **char** | `ftString` | `TStringField` | `FixedChar=True`；啟動 `TrimFixedChar` 時自動除空白 |
| **varchar** | `ftString` | `TStringField` | 標準變長字串 |
| **text** | `ftMemo` | `TMemoField` | ANSI 大文字串流 |
| **nchar** | `ftWideString` / `ftString` | `TWideStringField` / `TStringField` | 受 `UseUnicode` 參數控制 |
| **nvarchar** | `ftWideString` / `ftString` | `TWideStringField` / `TStringField` | 受 `UseUnicode` 參數控制 |
| **ntext** | `ftWideMemo` / `ftMemo` | `TWideMemoField` / `TMemoField` | 受 `UseUnicode` 參數控制 |
| **nvarchar(max)** | `ftWideMemo` | `TWideMemoField` | 串流式 Unicode 大文字 |
| **binary** | `ftBytes` | `TBytesField` | 定長二進位資料 |
| **varbinary** | `ftVarBytes` | `TVarBytesField` | 變長二進位資料（長度 <= 8000） |
| **varbinary(max) / image** | `ftBlob` | `TBlobField` | 二進位大型物件串流 (BLOB) |
| **timestamp / rowversion** | `ftBytes` | `TBytesField` (Size = 8) | 8 位元組版本控制旗標 |
| **uniqueidentifier** | `ftString` | `TStringField` (Size = 38) | GUID 字串表現形式 |
| **sql_variant** | `ftString` | `TStringField` | 泛用型別字串 |

---

## 6. 進階開發技巧

### 6.1 底層 TDBXCommand 參數化查詢
若需要最高執行效能，可直接使用原生 `TDBXCommand` 搭配標準問號 `?` 佔位符：

```delphi
var
  Cmd: TDBXCommand;
  Reader: TDBXReader;
begin
  Cmd := SQLConn.DBXConnection.CreateCommand;
  try
    Cmd.CommandType := TDBXCommandTypes.DbxSQL;
    Cmd.Text := 'SELECT CustNo, Company FROM Customer WHERE Country = ? AND City = ?';

    // 呼叫 Prepare 自動偵測參數元數據
    Cmd.Prepare;
    Cmd.Parameters[0].Value.AsString := 'TW';
    Cmd.Parameters[1].Value.AsString := 'Taipei';

    Reader := Cmd.ExecuteQuery;
    try
      while Reader.Next do
        Writeln(Format('%s: %s', [Reader.Values[0].AsString, Reader.Values[1].AsString]));
    finally
      Reader.Free;
    end;
  finally
    Cmd.Free;
  end;
end;
```

### 6.2 多重結果集 (MRS) 批次讀取
執行批次 SQL 或預存程序一次回傳多個資料集：

```delphi
var
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  SetIndex: Integer;
begin
  Cmd := SQLConn.DBXConnection.CreateCommand;
  try
    Cmd.Text := 'SELECT 1 AS n; SELECT 2 AS n; SELECT 3 AS n;';
    Reader := Cmd.ExecuteQuery;
    SetIndex := 1;

    while Reader <> nil do
    begin
      try
        while Reader.Next do
          Writeln(Format('第 %d 個結果集: value = %s', [SetIndex, Reader.Values[0].AsString]));
      finally
        Reader.Free;
      end;
      Reader := Cmd.GetNextReader; // 前進至下一個結果集
      Inc(SetIndex);
    end;
  finally
    Cmd.Free;
  end;
end;
```

### 6.3 交易管理與最佳實踐 (Transaction Management)

#### 1. 單一扁平交易架構 (不支援巢狀交易)
- **架構原則**：本驅動宣告 SupportsNestedTransactions := False。一條實體連線在同一時間**僅允許一個有效交易**。在交易未結束前重複呼叫 BeginTransaction 會被 VCL 直接攔截並拋出 sActiveTrans（交易已在使用中）。
- **底層原因**：ODBC 標準 API SQLEndTran(SQL_HANDLE_DBC, ...) 是以「連線代碼」為單位執行 Commit 或 Rollback，沒有交易序號或分層提交機制。
- **SQL Server 限制**：在 SQL Server 中重複下達 BEGIN TRAN 只會遞增 @@TRANCOUNT 計數器；內層 Commit 僅扣減計數、並未真正落盤，但只要內層呼叫一次 Rollback，**整個外層交易所有變更將被一併撤銷**。真正的分層隔離必須依賴 SAVE TRANSACTION（儲存點），而標準 ODBC API 並無儲存點的統一抽象層。
- **實務建議**：若有多個業務函數需共同納入交易，請在**最外層呼叫者統一管理**，或在啟動前以 if not SQLConnection.InTransaction then 進行防禦。

#### 2. Commit / Rollback 前務必關閉未讀完之查詢游標
- **AutoCommit 恢復機制**：呼叫 BeginTransaction 時連線切換為手動提交（SQL_AUTOCOMMIT_OFF），呼叫 Commit 或 Rollback 結束交易後，驅動程式會嘗試恢復為自動提交（SQL_AUTOCOMMIT_ON）。
- **游標卡住風險**：若連線上尚有 TSQLQuery 或 TDBXReader 未讀完全部資料列（保持 Active Cursor），SQL Server 會拒絕切回 AutoCommit（回傳 SQLSTATE 25000 Invalid transaction state）。
- **最佳實踐**：在執行 SQLConnection.CommitFreeAndNil 之前，務必確保所有查詢資料皆已讀取完畢或顯式呼叫 Query.Close。

#### 3. MARS (MARS_Connection=yes) 注意事項
- **並行查詢共用交易**：MARS 允許同一連線交錯執行多個查詢，但在交易區塊內，所有活躍語句共用同一個交易空間與鎖定資源。
- **Rollback 強制作廢**：在 MARS 連線上執行 Rollback 時，SQL Server 會依規範強制作廢該交易內所有尚未讀取完畢的結果集，後續對該 Reader 呼叫 .Next 將會收到游標失效警告。

---

## 7. 常見問題與疑難排解 (FAQ)

#### Q1：為什麼查詢出來的 `CHAR` 欄位帶有許多尾隨空白？
- **解答**：本驅動預設已開啟 `TrimFixedChar=True`。若連線字串不小心覆蓋成 `TrimFixedChar=False`，定長空白會被保留。請確認設定 `SQLConn.Params.Values['TrimFixedChar'] := 'True';`。

#### Q2：既有舊系統畫面報錯 `Type mismatch: expecting String actual WideString`！
- **解答**：這是因為您的 `.dfm` 檔案建立了靜態 `TStringField` 欄位定義。只要在連線參數加入 `SQLConn.Params.Values['UseUnicode'] := 'False';`，驅動便會將 `nchar`/`nvarchar` 映射為 `TStringField`，`ntext` 映射為 `TMemoField`。

#### Q3：連線至 `ODBC Driver 18 for SQL Server` 時出現 SSL 憑證驗證失敗？
- **解答**：微軟在 Driver 18+ 起預設強制開啟 SSL 憑證驗證。本驅動程式已內建智慧防呆，若您未特別配置 SSL 憑證，連線時會自動補上 `TrustServerCertificate=yes;`，避免連線失敗。

#### Q4：我需要安裝或部署任何 BPL 套件嗎？
- **解答**：**完全不需要。** 在專案中直接引用 `source/` 的 3 個檔案即可完成 100% 執行期連線。目錄下的 `packages/DataExplorer/` 僅供希望在 IDE 視窗的 Data Explorer 直接檢視資料表結構的開發者選用。

---

## 8. 目錄結構一覽 (Directory Layout)

```text
dbxoodbc/
├── source/               # 純 Pascal DBX4 核心驅動原始碼 (零外部 DLL 依賴)
│   ├── DbxOpenOdbcDriver.pas  # 驅動註冊單元與 TDBXDriver / TDBXConnection 實作
│   ├── DbxOpenOdbcCore.pas    # 指令、結構描述、游標、參數與修剪引擎
│   └── OdbcApi.pas            # 原生 Windows ODBC 3.x API 綁定單元 (odbc32.dll)
├── ini/                  # IDE 連線設定範本 (選用)
│   ├── dbxdrivers.ini         # 驅動註冊設定範本
│   └── dbxconnections.ini     # 各 DBMS 連線設定範本
├── packages/             # IDE 整合套件 (選用)
│   └── DataExplorer/          # Data Explorer 整合套件工程與說明
├── demos/                # 各資料庫連線範例
│   └── connections/           # 各 DBMS 預製連線設定範例單元
├── tests/                # 自動化回歸測試套件
│   ├── mvp_test/              # CLI / IDE 驗證套件 (免連線真實 DB 即可驗證核心架構)
│   └── runtime_test/          # 針對真實 SQL Server 的全套回歸測試
├── ChangesLog.Txt        # 歷史版本異動紀錄 (英文)
├── README.md             # 英文版說明文檔
└── README_TW.md          # 繁體中文版說明文檔
```
