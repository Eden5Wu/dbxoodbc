# DBX4 Remastered (dbxoodbc)

純原生 Delphi dbExpress (DBX4) ODBC 驅動程式 (支援 Win32 & Win64)

[English Documentation](README.md)

---

## 專案資訊

- **驅動名稱 (Driver Name)**：`DbxOpenOdbc`（或 `OpenOdbc`）
- **版本 (Version)**：`4.2026.11.04` (DBX4 Remastered)
- **架構**：100% 純 Pascal 原生 DBX4 (`Data.DBXCommon`)
- **支援平台**：Windows 32 位元 (Win32) 與 64 位元 (Win64)
- **支援 Delphi 版本**：RAD Studio 2010、XE 至 12 Athens、13+
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

    // 寫法 A：標準 ODBC 連線字串
    SQLConn.Params.Values['ConnectionString'] :=
      'Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=ADBDEMOS;Uid=sa;Pwd=secret;';

    // 寫法 B：直接傳入 ADO / OLE DB 連線字串（自動轉譯！）
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

### 4.3 `UseUnicode`（Unicode 與舊版 DFM 欄位映射控制）
- **功能描述**：控制國家字元欄位（`NCHAR`、`NVARCHAR`、`NTEXT`）映射為現代 `TWideStringField` / `TWideMemoField` 或是經典 `TStringField` / `TMemoField`。
- **預設值**：`True`（現代 Delphi 推薦預設值）
- **模式解析**：
  - `UseUnicode=True` *(現代標準)*：`nchar`/`nvarchar` 映射為 `ftWideString` (`TWideStringField`)；`ntext`/`nvarchar(max)` 映射為 `ftWideMemo` (`TWideMemoField`)。
  - `UseUnicode=False` *(舊專案 DFM 完美相容模式)*：`nchar`/`nvarchar` 映射為 `ftString` (`TStringField`)；`ntext` 映射為 `ftMemo` (`TMemoField`)。
  > **給舊專案維護工程師的貼心提示**：自 Delphi 2009 起，Delphi 原生的 `TStringField` 與 `TMemoField` 本身即已包裝 `UnicodeString`！若您的舊專案 `.dfm` 存在許多靜態宣告的 `TStringField`，只要設定 `UseUnicode=False`，即可徹底解決 `Type mismatch: expecting String actual WideString` 錯誤，且中文與特殊字元依然能正常顯示！
- **設定範例**：
  ```delphi
  SQLConnection1.Params.Values['UseUnicode'] := 'False'; // 100% 相容舊專案 DFM 靜態欄位
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

---

## 5. SQL Server 資料型別映射參照表 (Data Type Mapping Reference)

本驅動程式將 SQL Server 欄位對應至 Delphi DBX4 型態 (`TDBXDataTypes`) 與 VCL `TField` 欄位類別之完整規範：

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

---

## 7. 常見問題與疑難排解 (FAQ)

#### Q1：為什麼查詢出來的 `CHAR` 欄位帶有許多尾隨空白？
- **解答**：本驅動預設已開啟 `TrimFixedChar=True`。若連線字串不小心覆蓋成 `TrimFixedChar=False`，定長空白會被保留。請確認設定 `SQLConn.Params.Values['TrimFixedChar'] := 'True';`。

#### Q2：既有舊系統畫面報錯 `Type mismatch: expecting String actual WideString`！
- **解答**：這是因為您的舊 `.dfm` 檔案在早期 Delphi 時代建立了持久化 `TStringField` 欄位。只要在連線參數加入 `SQLConn.Params.Values['UseUnicode'] := 'False';`，驅動便會產出 `TStringField`，完美相容舊 DFM 且在現代 Delphi 下依舊支援萬國碼。

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
