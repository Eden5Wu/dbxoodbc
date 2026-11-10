# GitHub Issue #29: [功能建議 / Feature] 內建驅動級多資料庫連線池與方言工作階段隔離機制 (Native Connection Pooling with Multi-DBMS Dialect Session Isolation)

- **狀態**：`[OPEN]`
- **標籤**：`enhancement`, `performance`, `architecture`, `multi-dbms`
- **里程碑**：`4.2026.11`
- **對應分支**：`feat/native-connection-pooling`

---

## 1. 背景與問題陳述 (Background & Problem Statement)

在 WebService、DataSnap、SOAP 與現代微服務等無狀態（Stateless）高並發架構中，每個請求通常具有「建立連線 -> 查詢/更新 -> 關閉並釋放連線」的生命週期特性。

若未啟用連線池（Connection Pooling），每次請求均需經歷：
1. **TCP 握手與 TLS/SSL 加密交握**（5~20ms）。
2. **資料庫身份驗證與登入協議交涉**（10~50ms）。
3. **資料庫內部工作階段配置與記憶體初始化**。
在大並發下，這會導致極高的資料庫 CPU 負載與系統吞吐量瓶頸（QPS 受限）。

### 為何不能依賴 Delphi 原廠 `Data.DBXPool.pas`？
經過深度源碼稽核，Delphi 官方的 `Data.DBXPool.pas` 存在數項致命缺陷：
1. **連線分區鍵缺陷（串庫風險）**：原廠 `IsEqual` 僅比對 `ConnectionName` 與 `UserName`，在多資料庫、多租戶環境下會將不同 Database 的連線互相借出，造成災難性的跨庫污染。
2. **連線生命週期混亂**：未覆寫 `Close` 方法，呼叫 `Connected := False` 時直接切斷底層實體 TCP 連線，使池內留存大量死連線。
3. **缺乏死連線檢測（Dead Connection Detection）**：閒置超時被防火牆切斷的半開連線借出時直接拋出 Socket 錯誤。
4. **無多資料庫方言感知（No Dialect Session Reset）**：無法在歸還/借出時重置 SQL Server 臨時表、Oracle Package 狀態或 MySQL 連線變數。

---

## 2. 解決方案：在 `dbx4odbc` 內建原生連線池 (Proposed Architecture)

將連線池作為 `dbx4odbc` 的原生核心能力，結合已有的 `DbxOpenOdbcDialects.pas` 方言架構，提供跨 SQL Server、Oracle、MySQL、PostgreSQL 等多資料庫的通用安全連線池。

### 核心功能規格：
1. **執行緒安全連線池 (`TOdbcConnectionPool`)**：
   - 位於 `DbxOpenOdbcCore.pas` / `DbxOpenOdbcDriver.pas`。
   - 採 `TCriticalSection` 線程安全鎖保護。
   - 以規範化的連線字串（Normalized Connection String）作為分區 Key，確保主機、資料庫、帳號 100% 嚴格隔離。
2. **多資料庫工作階段重設（Dialect Session Reset Hook）**：
   - 在 `TOdbcDialect` 擴充 `procedure ResetSession(Connection: TOdbcConnectionHandle); virtual;`。
   - **`TSqlServerDialect`**：執行 `exec sp_reset_connection;`（清空臨時表、清除使用者定義游標、還原 `SET` 選項與隔離層級）。
   - **`TOracleDialect`**：執行 `BEGIN DBMS_SESSION.RESET_PACKAGE; END;`（重設 Package 狀態）。
   - **`TMySqlDialect`**：執行 `SET autocommit=1;` 並還原連線狀態。
3. **零網路成本死連線檢測 (Zero Round-Trip Dead Check)**：
   - 借出連線前，直接呼叫 ODBC C-API `SQLGetConnectAttr(FHDbc, SQL_ATTR_CONNECTION_DEAD, ...)` 檢查本機 Socket 狀態。
   - 若連線已被網路端切斷，連線池自動銷毀死連線並重建新連線，應用層零感知。
4. **連線遮蔽與生命週期閉環 (DerivedClose Interception)**：
   - 當 `Pooling=True` 時，`DerivedClose` 攔截 `SQLDisconnect`，自動執行事務 Rollback、方言 Session Reset，並將句柄歸還至閒置池。

---

## 3. 參數開關配置規範 (Configuration Parameters)

支援在 `TSQLConnection.Params` 或連線字串中進行標準化宣告：

```ini
DriverName=DbxOpenOdbc
Database=ERP_MASTER
User_Name=sa
Password=***
; 連線池開關（預設為 False，保持 100% 向後相容）
Pooling=True
; 最大連線數（預設 50）
Pool.MaxPoolSize=50
; 最小保留連線數（預設 0）
Pool.MinPoolSize=0
; 借出連線等待逾時（秒，預設 30）
Pool.ConnectionTimeout=30
; 連線最大閒置存活秒數（預設 300）
Pool.ConnectionLifetime=300
; 借出時是否執行活性探測（預設 True）
Pool.ValidateOnBorrow=True
```

---

## 4. 驗收標準 (Acceptance Criteria)

- [ ] 單執行緒連線循環借還驗證（確認連線複用，無重複 TCP 握手）。
- [ ] 10 執行緒多工並發壓測（驗證 Thread-safety 與無 Deadlock）。
- [ ] 多資料庫切庫隔離性驗證（不同 Database 不得共用連線池）。
- [ ] MSSQL `sp_reset_connection` 驗證（確認臨時表與 Transaction 歸還後自動清空）。
- [ ] 斷線重連驗證（模擬中斷連線，借出時自動汰換死連線）。
