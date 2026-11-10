# ADR-003: 內建原生資料庫連線池與多資料庫方言隔離架構決策 (Native Connection Pooling Strategy)

- **狀態**：已接受 (Accepted)
- **決策日期**：2026-11-11
- **決策結論**：直接於 `dbx4odbc` 核心驅動內建原生連線池引擎，搭配多資料庫方言（Dialects）工作階段重設協議，而非依賴 Delphi 原廠之 `Data.DBXPool.pas` 或作業系統層通用 ODBC 連線池。
- **關聯 Issue**：[Issue #29: 內建驅動級多資料庫連線池](https://github.com/Eden5Wu/dbx4odbc/issues/29)
- **目標分支**：`feat/native-connection-pooling`
- **英文版**：[English Version](ADR-003-native-connection-pooling.md)

---

## 背景與問題陳述

在企業級高並發無狀態系統（如 DataSnap、SOAP WebServices、微服務）中，每個請求均經歷「建立連線 -> 查詢/更新 -> 釋放連線」之生命週期。每次實體連線之建立均需耗費 15~70ms 之網路握手與身分驗證延遲。

Delphi 官方雖提供委託驅動 `Data.DBXPool.pas`，但源碼稽核發現其存在四大嚴重問題：
1. **連線分區鍵缺陷（串庫風險）**：`IsEqual` 僅比對 `ConnectionName` 與 `UserName`，在多資料庫、多租戶環境下會將不同 Database 的連線互相借出，造成災難性的跨庫污染。
2. **連線生命週期混亂**：未覆寫 `Close` 方法，呼叫 `Connected := False` 時直接切斷底層實體 TCP 連線，使池內留存大量死連線。
3. **缺乏死連線檢測（Dead Connection Detection）**：閒置超時被防火牆切斷的半開連線借出時直接拋出 Socket 錯誤。
4. **無多資料庫方言感知（No Dialect Session Reset）**：無法在歸還/借出時重置 SQL Server 臨時表、Oracle Package 狀態或 MySQL 連線變數。

---

## 架構決策與設計原則

我們決定在 `dbx4odbc` 內建一級連線池管理引擎：

1. **連線分區嚴格隔離 (Normalized Pool Partitioning)**：
   以經過轉譯與規範化之完整 ODBC 連線字串作為 Key。主機、資料庫（Catalog/Database/Schema）、帳號或連線選項不同者，各自獨立劃分至不同子池，100% 杜絕跨庫錯位。
2. **方言導向之工作階段重設 (Dialect-Driven Session Reset)**：
   於 `TOdbcDialect` 擴充 `procedure ResetSession(Connection: TOdbcConnectionHandle)`。連線歸還時由方言執行重設：
   - `TSqlServerDialect`：執行 `exec sp_reset_connection;`。
   - `TOracleDialect`：執行 `BEGIN DBMS_SESSION.RESET_PACKAGE; END;`。
   - `TMySqlDialect`：執行 `SET autocommit=1;`。
3. **零網路往返死連線檢測 (Zero Round-Trip Socket Probing)**：
   藉由 ODBC 3.x API `SQLGetConnectAttr(FHDbc, SQL_ATTR_CONNECTION_DEAD, ...)` 於連線借出前進行本機 Socket 狀態快速檢查，確保借出連線 100% 有效。
4. **無縫開發者體驗 (Seamless Ergonomics)**：
   由 `Pooling=True` 單一參數控制，預設為 `False` 確保 100% 向後相容。

