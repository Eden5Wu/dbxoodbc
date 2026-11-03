{
  Delphi Open Source Native DBX4 Driver for ODBC (DBX4 Remastered)
  Version: 4.2026.11.02

  Copyright (c) 2001-2012 Edward Benson, Vadim V. Lopushansky
  Copyright (c) 2019-2026 Eden Wu (Native DBX4 Remastered Architecture)

  Project Repository:
    https://github.com/Eden5Wu/dbxoodbc

  Windows ODBC 驅動程式註冊表路徑:
    32-bit: HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI
    64-bit: HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI
}

================================================================================
 DBX4 Remastered (dbxoodbc v4.2026.11.02)
 純原生 Delphi dbExpress (DBX4) ODBC 驅動程式 (支援 Win32 & Win64)
================================================================================

1. 專案簡介
-----------
DBX4 Remastered 是針對現代 Delphi (RAD Studio 10.x, 11, 12, 13+) 全面重製的
純原生 DBX4 (Data.DBXCommon) 架構 ODBC 驅動程式。

核心特色：
  * 100% 純 Pascal 原生 DBX4 架構：
    直接繼承自 Data.DBXCommon (TDBXDriver, TDBXConnection, TDBXCommand,
    TDBXReader, TDBXRow)，支援自動參數綁定、結構描述 (Metadata) 與交易控制。
  * 零外部 DLL 依賴 (Zero-DLL Deployment)：
    徹底擺脫歷史 3.x 的 "dbxoodbc.dll"、"dbxadapter30.dll" 與脆弱的記憶體
    API Hook，底層直通 Windows 原生 "odbc32.dll"。
  * 完整支援 Win32 與 Win64 雙平台：
    整個核心僅由 "source/" 目錄下的 3 個純淨單元組成：
      - source/OdbcApi.pas
      - source/DbxOpenOdbcCore.pas
      - source/DbxOpenOdbcDriver.pas
  * 歷史包袱清零：
    舊版 DBX 3.x 已透過 Git Release Tag 封存歸檔；4.x 主幹專注於純血 DBX4。


2. 目錄架構導覽 (Project Directory Structure)
---------------------------------------------
dbxoodbc/
├── source/               # 純 Pascal DBX4 核心驅動原始碼 (零外掛 DLL 依賴)
│   ├── DbxOpenOdbcDriver.pas  # 驅動註冊單元與 TDBXDriver / TDBXConnection 實作
│   ├── DbxOpenOdbcCore.pas    # 指令、資料表結構描述、游標與雙別名映射核心引擎
│   └── OdbcApi.pas            # 原生 ODBC 3.x API 綁定單元 (直通 odbc32.dll)
├── ini/                  # IDE 連線設定範本
│   ├── dbxdrivers.ini         # 驅動註冊設定範本
│   └── dbxconnections.ini     # 各 DBMS 連線設定範本 (MSSQL, Oracle, PG 等)
├── demos/                # 各資料庫連線範例
│   └── connections/           # 各 DBMS 預製連線設定範例單元
├── tests/                # 自動化測試套件
│   └── mvp_test/              # CLI / IDE 驗證套件 (免連線真實 DB 即可驗證核心架構)
├── clean.cmd             # 清理編譯臨時產生物 (*.dcu, *.~*, *.identcache 等)
├── ChangesLog.Txt        # 歷史版本異動紀錄
├── ReadMe.Txt            # 英文版說明文檔
└── ReadMe_TW.Txt         # 正體中文版說明文檔


3. 快速上手（免安裝 BPL、免部署 DLL）
-------------------------------------
您完全不需要在 IDE 安裝任何設計期 BPL 套件，也不必隨程式發佈任何額外 DLL！

步驟 1：將 "source/" 加入專案的 Search Path（或直接將 OdbcApi.pas、
        DbxOpenOdbcCore.pas、DbxOpenOdbcDriver.pas 加入專案）。

步驟 2：在您的主程式或 DataModule 中引用單元：
        uses
          Data.DB, Data.SqlExpr, DbxOpenOdbcDriver;

步驟 3：設定 TSQLConnection 並開啟連線：
        SQLConnection1.DriverName := 'DbxOpenOdbc'; // 或 'OpenOdbc'
        SQLConnection1.LoginPrompt := False;
        SQLConnection1.Params.Values['ConnectionString'] :=
          'DRIVER={SQL Server};Server=127.0.0.1;Database=master;Trusted_Connection=yes;';
        SQLConnection1.Open;


4. 連線字串與擴充參數指南 (Connection String & Extended Parameters)
-------------------------------------------------------------------
4.1 設定入口（依優先順序讀取）
驅動程式會依序從 TSQLConnection.Params 的以下屬性讀取連線字串（擇一設定即可）：
  1) SQLConnection.Params.Values['ConnectionString']  (現代標準，最推薦)
  2) SQLConnection.Params.Values['Database']          (標準 DBX 相容屬性)
  3) SQLConnection.Params.Values['Custom String']     (舊版 3.x 歷史相容屬性)

4.2 雙模解析引擎：支援「原生 ODBC 格式」與「ADO/OLEDB 格式自動轉譯」
本專案底層 100% 走 Windows 原生 ODBC C API (odbc32.dll)，完全不經過 COM/OLEDB，
零額外效能損耗。但為了方便既有專案遷移，內建了智慧轉譯器，可直接傳入 ADO 連線字串：

  +-----------------------------------+----------------------------------------+
  | ADO / OLEDB 參數名稱              | 自動轉譯後的原生 ODBC 參數             |
  +-----------------------------------+----------------------------------------+
  | Provider=MSOLEDBSQL / SQLNCLI11.. | Driver={自動偵測系統最佳 SQL 驅動}     |
  | Provider=SQLOLEDB                 | Driver={SQL Server}                    |
  | Data Source=... / Address=...     | Server=...                             |
  | Initial Catalog=...               | Database=...                           |
  | User ID=...                       | Uid=...                                |
  | Password=...                      | Pwd=...                                |
  | Integrated Security=SSPI          | Trusted_Connection=yes                 |
  | Application Name=...              | APP=... (於 SQL Profiler 即時顯示程式) |
  | Application_Name=...              | APP=... (於 SQL Profiler 即時顯示程式) |
  | Workstation ID=...                | WSID=... (於 SQL Profiler 顯示機台名)  |
  +-----------------------------------+----------------------------------------+

  * 舊版 3.x 專屬的 "co*" 參數（如 coConnectionString=、coLockMode=、
    coCatPrefix=、coEnableUnicode= 等）會被自動剝離過濾，不會干擾原生 ODBC 驅動。

4.3 動態偵測系統已安裝驅動與智慧 Fallback (SQLDriversW)
針對新世代 SQL Server 驅動（Native Client / MSOLEDBSQL / ODBC Driver 17/18）的
版本碎片化問題，本驅動會在執行期透過 SQLDriversW 自動掃描當前系統已安裝的驅動：
  1. 優先匹配連線字串所指定的世代版本。
  2. 若客戶端電腦未安裝該指定版本（即使在純 ODBC 字串寫死 Driver={ODBC Driver 17...}），
      也會自動由新到舊尋找系統已安裝的最佳版本替換：
     - ODBC Driver 18 for SQL Server
     - ODBC Driver 17 for SQL Server
     - ODBC Driver 13.1 / 13 / 11 for SQL Server
     - SQL Server Native Client 11.0 / 10.0 / SQL Native Client
     - SQL Server (Windows 100% 內建保底驅動 sqlsrv32.dll)
  * ODBC Driver 18+ 憑證防呆：若解析使用 Driver 18/19 且未指定
    "TrustServerCertificate="，會自動補上 "TrustServerCertificate=yes;"，避免
    因預設強制 SSL 憑證檢查而無法連線。

4.4 擴充參數原生直通 (Pass-Through) 與 MSSQL 專屬加速
  * 任何附加在連線字串後方的其他 "Key=Value;" 參數，都會原封不動直接傳遞給底層
    Windows ODBC 驅動程式。
  * 常用 MSSQL 擴充參數範例：
    - Application Name=人資系統; (或 Application_Name=... / APP=...)
      設定後可在 SQL Server Profiler 的 ApplicationName 欄位與
      sys.dm_exec_sessions 即時看到應用程式名稱。
    - Workstation ID=POS_01; (或 WSID=POS_01;)
      設定後可在 SQL Server Profiler 的 HostName 欄位即時看到機台名稱。
    - TrustServerCertificate=yes;
      信任伺服器自簽 SSL 憑證。
    - ApplicationIntent=ReadOnly;
      搭配 SQL Server AlwaysOn 自動路由至唯讀次要節點。
    - LoginTimeout=5;
      設定連線登入逾時秒數。
  * 內建自動啟用的 MSSQL 加速參數：
    - MARS_Connection=yes (自動啟用多重結果集，單一連線可同時開啟多個 Dataset)
    - Network=dbmssocn    (強制直走高速 TCP/IP，避開緩慢的 Named Pipes 逾時)


5. IDE Data Explorer 設定檔範本 (ini/)
--------------------------------------
若您希望在 RAD Studio IDE 的 Data Explorer 註冊或管理連線，請參考 "ini/" 目錄下
提供的設定檔範本：
  - ini/dbxdrivers.ini
  - ini/dbxconnections.ini

