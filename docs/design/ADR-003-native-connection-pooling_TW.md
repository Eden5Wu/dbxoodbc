# ADR-003: 採用 Windows ODBC Driver Manager 原生連線池架構決策 (Native Connection Pooling Strategy)

- **狀態**：已接受 (Accepted — 取代初期自建 `DbxOpenOdbcPool.pas` 原型)
- **決策日期**：2026-11-11
- **決策結論**：將實體連線池委派予微軟 Windows ODBC Driver Manager (`odbc32.dll`) 原生管理，透過獨立環境控制代碼 (`FOdbcPooledEnv`) 啟用 `SQL_ATTR_CONNECTION_POOLING = SQL_CP_ONE_PER_HENV` 與 `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH`，並自最終執行期架構移除自建應用層連線池 (`DbxOpenOdbcPool.pas`)。
- **關聯 Issue**：[Issue #29: 原生連線池架構設計與驗證](https://github.com/Eden5Wu/dbx4odbc/issues/29)
- **目標整合分支**：`feat/odbc-dm-pooling`（保留歷史對照分支：`feat/native-connection-pooling`、`exp/odbc-dm-pooling`）
- **英文版**：[English Version](ADR-003-native-connection-pooling.md)

---

## 1. 背景與問題陳述

在企業級無狀態高並發系統（如 DataSnap、SOAP WebServices、微服務）中，每個請求均經歷「建立連線 -> 查詢/更新 -> 釋放連線」之短連線生命週期。若無連線池複用，每次請求均需耗費 15~70 ms 之 TCP/TLS 握手與資料庫身分驗證延遲。

### 1.1 Embarcadero 原廠 `Data.DBXPool.pas` 原始碼深度稽核與技術修正

經直接檢視 RAD Studio 11.3 原廠 RTL 原始碼（`Data.DBXPool.pas`、`Data.DBXDelegate.pas`、`Data.DBXCommon.pas`），確立原廠 `DBXPool` 無法滿足企業級多資料庫需求的精確技術原因：

1. **連線分區比對缺陷 — 源碼級缺陷與跨庫資料污染風險 (`Data.DBXPool.pas` 第 407–435 行)**：
   - `TDBXPool.IsEqual` 僅包含兩個簡陋分支：
     - 當 `ConnectionName <> ''` 時，**僅比對 `ConnectionName` 與 `UserName`**，完全忽略執行期動態修改的 `Database` 或 `ConnectionString`。
     - 當 `ConnectionName = ''`（以程式碼動態建立 `TSQLConnection`）時，**僅比對 `ConnectionProperties[TDBXPropertyNames.Database]`**，完全忽略 `ConnectionProperties['ConnectionString']`、`Custom String` 與 `HostName`。
   - 在多資料庫 ERP 架構中，若應用程式透過 `Params.Values['ConnectionString']` 動態切換不同資料庫（如 `ERP_MASTER`、`ERP_ARCHIVE`、`ERP_BRANCH`），而 `ConnectionName` 與 `Database` 屬性保持空白（或共用相同 `ConnectionName` 範本與 `User_Name`），`TDBXPool.IsEqual` 會誤判為相同連線池分區，將連往 A 資料庫的實體連線借給 B 資料庫請求。**跨資料庫錯位屬於嚴重的資料正確性與完整性故障（Data Integrity Failure），而非單純的效能問題。**
2. **Close 呼叫鏈行為 — 池化失效與重連開銷問題 (`Data.DBXDelegate.pas` 第 375–378 行；`Data.DBXCommon.pas` 第 8626–8634 行；`Data.DBXPool.pas` 第 505–522 行)**：
   - 依原廠 RTL 實際呼叫鏈：當應用程式對掛載 `DelegateConnection=DBXPool` 的連線執行 `Close` 時：
     - `TDBXDelegateConnection.Close` 直接轉發呼叫 `FConnection.Close`。
     - `TDBXConnection.Close` 觸發底層驅動的 `DerivedClose`（執行 `SQLDisconnect` 切斷實體連線）。
     - 隨後 `TDBXPoolConnection.Destroy` 將已關閉的 `FConnection` 物件歸還至 `FAvailableConnectionList`。
     - 下一次借出時，`TDBXPoolConnection.Open` 檢查 `if not FConnection.IsOpen then FConnection.Open`，重新呼叫 `DerivedOpen`（`SQLDriverConnectW`）。
   - **技術定性修正**：此行為**不會**導致連線損壞或無法使用（因為 `TDBXPoolConnection.Open` 會自動重開連線），但它會**導致 DBX 層級的實體連線複用完全失效**，每次借出仍須重新承受實體連線建立開銷。
3. **通用高階物件池之架構限制 (Architectural Limitations)**：
   - `Data.DBXPool.pas` 為包裹在 `TDBXConnection` 外層的通用委託層，無法存取底層 ODBC 連線屬性（如 `SQL_ATTR_CONNECTION_DEAD`），亦無法觸發資料庫通訊協定層的會話重置機制（如 TDS 協定之 `fResetConnection`）。
4. **與 `dbx4odbc` 及 Windows ODBC Driver Manager 連線池之關係**：
   - Windows ODBC Driver Manager (`odbc32.dll`) 連線池運作於 `dbx4odbc` 底層之 `SQLHENV` / `SQLHDBC` 層級，完全不經過 `Data.DBXPool.pas`。
   - **重要工程規範**：使用 `dbx4odbc` 時，**切勿設定 `DelegateConnection=DBXPool`**。因為 `DBXPool` 位於 `dbx4odbc` 上層，若啟用 `DelegateConnection=DBXPool`，請求在進入 `dbx4odbc` 前仍會先經過 `TDBXPool.IsEqual` 而引發跨庫錯位風險。

---

## 2. 實證基準對比：自建應用層連線池 vs. Windows ODBC Driver Manager 原生連線池

我們在第一階段 (`feat/native-connection-pooling`) 實作了 385 行的自建連線池 (`source/DbxOpenOdbcPool.pas`)，並在第二階段 (`exp/odbc-dm-pooling`) 於真實 SQL Server 環境 (`127.0.0.1/ERP_MASTER`, `127.0.0.1/ERP_ARCHIVE`, `127.0.0.1/ERP_BRANCH`) 進行嚴格同基準對比測試：

### 2.1 效能基準實測數據（100 次循序循環 + 8 執行緒 / 16 執行緒高並發）

| 測試組態 | 平均借出 (Acquire) | 平均查詢 (Query) | 平均歸還 (Release) | 單次總延遲 (Avg Total) | 中位數 (p50) | p95 延遲 | p99 延遲 | 8 執行緒吞吐量 | 16 執行緒吞吐量 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. 無連線池 (`Pooling=False`)** | 14.077 ms | 3.654 ms | 0.237 ms | **17.967 ms** | 16.567 ms | 32.197 ms | 37.367 ms | 53.2 ops/s | 56.1 ops/s |
| **B. Windows ODBC DM 原生池 (`Pooling=True`)** | **0.230 ms** | 2.959 ms | **0.032 ms** | **3.221 ms** | **2.657 ms** | **8.578 ms** | **13.048 ms** | **305.5 ops/s** | **572.3 ops/s** |
| **C1. 自建連線池 (`ValidateOnBorrow=True`)** | 1.863 ms | 4.028 ms | 1.766 ms | **7.657 ms** | 5.879 ms | 15.810 ms | 26.574 ms | 265.6 ops/s | 385.3 ops/s |
| **C2. 自建連線池 (`ValidateOnBorrow=False`)** | 0.168 ms | 2.553 ms | 1.259 ms | **3.980 ms** | 3.297 ms | 8.125 ms | 15.191 ms | 245.4 ops/s | 322.5 ops/s |

### 2.2 為何 Windows ODBC DM 原生連線池全面勝出？
1. **零額外網路往返 (Zero Extra Network Round-Trips)**：
   - 自建連線池在借出時於鎖內執行 `SELECT 1` (~3.56 ms)，並在歸還時執行 `exec sp_reset_connection` (~2.46 ms)，每次借還多出 **2 次同步網路往返**。
   - Windows ODBC DM (`odbc32.dll`) 搭配 `msodbcsql17.dll` 則是將 TDS 協定層的 `fResetConnection` 旗標直接夾帶在**下一個請求的第一個 SQL 封包標頭中**（`0` 次額外網路往返，歸還僅需 `0.012 ms`）。
2. **更完整的會話隔離與正確性 (8/8 全數通過 vs. 自建池 6/8 通過)**：
   - 自建池以一般 T-SQL 批次呼叫 `exec sp_reset_connection` 時，無法清除 `CONTEXT_INFO`（`0xDEADBEEF` 跨會話殘留），因為 SQL Server 在子批次返回時會還原呼叫端批次作用域狀態；而 `odbc32.dll` + `msodbcsql17.dll` 觸發的 TDS 封包級 `fResetConnection` 能完整將 `CONTEXT_INFO` 清為 `NULL`。
   - 此外，移除自建池也徹底消除了 `ResetSession` 未檢查回傳值、鎖內執行網路 `Ping` 阻塞其他執行緒等風險。

---

## 3. 最終架構決策

我們正式核准將 `dbx4odbc` (`feat/odbc-dm-pooling`) 遷移至 **Windows ODBC Driver Manager 原生連線池架構**：

1. **雙環境控制代碼隔離架構 (`TOdbcEnvHandle`)**：
   - `TDBXOdbcDriver` 維護兩個 ODBC 環境控制代碼：
     - `FOdbcEnv`：無池化環境（`Pooling=False`，預設值）。
     - `FOdbcPooledEnv`：按需延遲初始化之池化環境（`Pooling=True` 或 `Pooling=Odbc`），透過模組級臨界區 (`GOdbcEnvInitLock`) 保護，在呼叫 `SQLAllocHandle(SQL_HANDLE_ENV)` 前設定 `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)`，分配完成後**立即將進程級屬性重置回 `SQL_CP_OFF`**。
   - `FOdbcPooledEnv` 強制設定 `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH`，確保主機、資料庫、帳號、密碼與連線參數嚴格一致才予以複用。
2. **斷線時自動回滾未提交交易 (`TOdbcConnectionHandle.Disconnect`)**：
   - 在呼叫 `SQLDisconnect(FHDbc)` 前，`TOdbcConnectionHandle.Disconnect` 會自動回滾未提交之 DBX 交易 (`Rollback`)。在 SQL Server (`msodbcsql17.dll`) 下，TDS `fResetConnection` 旗標於連線複用時已自動將交易隔離層級還原為預設之 `READ COMMITTED`，無須在 `Disconnect` 中額外呼叫 `SQLSetConnectAttrW(SQL_ATTR_TXN_ISOLATION)`（避免將 SQL Server 的預設隔離層級強加於 MariaDB 等預設為 `REPEATABLE READ` 的資料庫）。
3. **移除自建連線池 (`DbxOpenOdbcPool.pas`)**：
   - 刪除 `source/DbxOpenOdbcPool.pas` 及 `DbxOpenOdbcDialects.pas` 中的 `ResetSession`/`GetPingSql`，維持 4 個純 Pascal 核心單元的極簡架構 (`OdbcApi.pas`, `DbxOpenOdbcDialects.pas`, `DbxOpenOdbcCore.pas`, `DbxOpenOdbcDriver.pas`)。
4. **參數向後相容與自動剝離**：
   - `Pooling=True`（或 `Pooling=Odbc`）啟用 Windows ODBC Driver Manager 原生連線池；`Pooling=False`（或省略）維持無池化連線。
   - 連線字串中若包含舊版 `Pooling`、`OdbcPooling`、`Pool.*` 等自訂參數，驅動會在呼叫 `SQLDriverConnectW` 前自動剝離，確保既有設定檔 100% 相容且不觸發 ODBC 驅動警告。

---

## 4. 多資料庫相容性與系統配置規範

1. **Windows 系統登錄檔 `ODBCINST.INI` 之 `CPTimeout` 必要條件**：
   - 依據微軟 ODBC Driver Manager 規範，`odbc32.dll` **僅針對在系統登錄檔 `HKLM\SOFTWARE\ODBC\ODBCINST.INI\<DriverName>` 中設有 `CPTimeout > 0` 的驅動程式啟用連線池**。
   - 微軟官方 SQL Server 驅動（`ODBC Driver 17/18 for SQL Server`、`SQL Server Native Client`、`SQL Server`）安裝時已預設寫入 `CPTimeout=60`，開箱即享 100% 池化加速。
   - 第三方資料庫驅動（如 PostgreSQL `psqlodbc`、MariaDB/MySQL `myodbc8w`、Firebird `FirebirdODBC`）必須由系統管理員正式安裝於 `HKLM\...\ODBCINST.INI` 並設定 `CPTimeout`（可透過 Windows「ODBC 資料來源管理員」->「Connection Pooling」頁籤設定），`odbc32.dll` 方會對其實施池化；若使用免安裝 Portable DLL 或未設定 `CPTimeout`，`odbc32.dll` 會安全且透明地退回一般無池化連線，不會拋出錯誤。
2. **各資料庫 ODBC 驅動之會話狀態重置 (Session Reset) 實測差異**：
   - **SQL Server (`msodbcsql17.dll`) — 完整支援 (PASS)**：透過 TDS `fResetConnection` 旗標，自動回滾未提交之 DBX 與原生 `BEGIN TRAN` 交易、清空 `#TempTable` 與 `CONTEXT_INFO`，並還原 `READ COMMITTED` 隔離層級。
   - **MariaDB / MySQL (`myodbc8w.dll` 8.0.36) — 完整支援 (PASS)**：於 `odbc32.dll` 池化複用時自動發送協定層 `COM_RESET_CONNECTION`，實測自動回滾未提交之 DBX 與原生 `START TRANSACTION` 交易、自動刪除 `TEMPORARY TABLE`、自動清空 `@user_var` 自訂變數，並還原 `@@autocommit=1` 與預設 `REPEATABLE-READ` 隔離層級。
   - **PostgreSQL (`psqlodbc35w.dll` 17.00) 與 Firebird (`FirebirdODBC.dll` 3.0/3.5) — 支援實體複用與 DBX 交易回滾，無自動會話重置 (PARTIAL / FAIL on Session Cleanup)**：兩者於 `odbc32.dll` 池化複用時均能正確執行實體連線複用、多資料庫切庫隔離、DBX `BeginTransaction` 未提交回滾與交易隔離層級還原；但驅動本身不會自動發送 `DISCARD ALL`（PostgreSQL）或 `ALTER SESSION RESET`（Firebird）。若應用程式在啟用 `CPTimeout` 池化的 PostgreSQL 或 Firebird 上建立暫存表（`CREATE TEMP TABLE` / `ON COMMIT PRESERVE ROWS` GTT）、修改會話變數（`SET statement_timeout` / `RDB$SET_CONTEXT('USER_SESSION', ...)`）或直接執行未經 DBX API 的原生 `BEGIN;`，必須在關閉連線前由應用程式顯式清理（如執行 `DISCARD ALL`）。
