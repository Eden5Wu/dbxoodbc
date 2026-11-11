# GitHub Issue #29: [Feature] 採用 Windows ODBC Driver Manager 原生連線池架構 (Native Connection Pooling via Windows ODBC Driver Manager)

- **狀態**：`[OPEN — 已於 feat/odbc-dm-pooling 完成實作與驗證，待最終審核合併]`
- **標籤**：`enhancement`, `performance`, `architecture`, `multi-dbms`
- **里程碑**：`4.2026.11`
- **目標整合分支**：`feat/odbc-dm-pooling`（保留歷史對照分支：`feat/native-connection-pooling`、`exp/odbc-dm-pooling`）
- **關聯 ADR**：[ADR-003: 採用 Windows ODBC Driver Manager 原生連線池架構決策](../design/ADR-003-native-connection-pooling_TW.md)
- **英文版**：[English Version](ISSUE-29-native-connection-pooling.md)

---

## 1. 背景與問題陳述 (Background & Problem Statement)

在 WebService、DataSnap、SOAP 與微服務等無狀態（Stateless）高並發架構中，每個請求皆遵循「建立連線 -> 查詢/更新 -> 關閉並釋放連線」之短連線生命週期。若未啟用連線池，每次請求均需耗費 15~70 ms 之 TCP/TLS 握手與資料庫登入驗證開銷。

### 1.1 Embarcadero 原廠 `Data.DBXPool.pas` 源碼稽核與技術說明修正

經直接檢視 RAD Studio 11.3 原廠 RTL 原始碼（`Data.DBXPool.pas`、`Data.DBXDelegate.pas`、`Data.DBXCommon.pas`），確立原廠 `DBXPool` 不適用於本專案之精確技術原因：

1. **連線分區比對缺陷 — 跨庫資料污染風險 (`Data.DBXPool.pas` 第 407–435 行)**：
   - `TDBXPool.IsEqual` 在 `ConnectionName <> ''` 時僅比對 `ConnectionName` 與 `UserName`；在 `ConnectionName = ''` 時僅比對 `ConnectionProperties[TDBXPropertyNames.Database]`，完全忽略 `ConnectionString`、`Custom String` 與 `HostName`。
   - 在多資料庫 ERP 應用中，當程式透過 `Params.Values['ConnectionString']` 動態連往不同資料庫（如 `TW_ED`、`TW_OLD`、`TWBS260610`）且未填寫 `ConnectionName`/`Database`（或共用相同 `ConnectionName` 範本）時，`TDBXPool.IsEqual` 會誤判為同一分區並錯借其他資料庫之連線。**跨資料庫連線錯用屬於嚴重的資料正確性與完整性故障（Correctness & Data Integrity Failure），而非單純效能問題。**
2. **Close 呼叫鏈行為 — 池化失效與重連開銷問題 (`Data.DBXDelegate.pas` 第 375–378 行；`Data.DBXCommon.pas` 第 8626–8634 行；`Data.DBXPool.pas` 第 505–522 行)**：
   - 原廠呼叫鏈為：`TDBXDelegateConnection.Close` -> `FConnection.Close` -> `TDBXConnection.Close` -> `DerivedClose`（呼叫 `SQLDisconnect` 斷開實體連線）；隨後 `TDBXPoolConnection.Destroy` 將已關閉的 `FConnection` 物件歸還池中，下次借出時由 `TDBXPoolConnection.Open` 重新執行 `FConnection.Open`。
   - **技術定性修正**：此行為**不會**導致連線物件無法使用，但會**使 DBX 層級的實體連線複用失效**，每次借出仍須重新建立底層連線。
3. **通用高階物件池之架構限制**：
   - `Data.DBXPool.pas` 位於 DBX 抽象層之上，無法感知底層 ODBC `SQL_ATTR_CONNECTION_DEAD` 狀態或觸發 TDS 協定層之 `fResetConnection`。
4. **重要警告 — 切勿同時設定 `DelegateConnection=DBXPool`**：
   - Windows ODBC Driver Manager (`odbc32.dll`) 連線池運作於 `dbx4odbc` 下層。應用程式使用 `dbx4odbc` 時**切勿設定 `DelegateConnection=DBXPool`**，否則上層 `TDBXPool.IsEqual` 仍會在進入 `dbx4odbc` 前發生跨庫錯位。

---

## 2. 核准架構：Windows ODBC Driver Manager 原生連線池

經由實驗分支 (`exp/odbc-dm-pooling`) 對自建連線池 (`DbxOpenOdbcPool.pas`, `7.657 ms/次`, 16T `385.3 QPS`) 與 Windows ODBC Driver Manager 原生連線池 (`odbc32.dll`, `3.221 ms/次`, 16T `572.3 QPS`) 進行同基準實測對比後，正式核准由 `odbc32.dll` 負責實體連線池管理：

1. **雙環境控制代碼隔離架構 (`FOdbcEnv` / `FOdbcPooledEnv`)**：
   - `TDBXOdbcDriver` 按需延遲建立 `FOdbcEnv`（無池化，預設）與 `FOdbcPooledEnv`（池化）。
   - `TOdbcEnvHandle.Create(True)` 在 `SQLAllocHandle(SQL_HANDLE_ENV)` 前設定 `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)`，分配完成後立即將進程級屬性重置為 `SQL_CP_OFF`，確保同進程內其他 ODBC 元件不受影響。
   - `FOdbcPooledEnv` 設定 `SQL_ATTR_CP_MATCH = SQL_CP_STRICT_MATCH`，強制比對完整連線屬性。
2. **斷線自動回滾 (`TOdbcConnectionHandle.Disconnect`)**：
   - 呼叫 `SQLDisconnect(FHDbc)` 前，自動回滾未提交之 DBX 交易 (`Rollback`)。具備底層重置協定之驅動（SQL Server `msodbcsql17.dll` 透過 TDS `fResetConnection`、MariaDB/MySQL `myodbc8w.dll` 透過 `COM_RESET_CONNECTION`）於連線池複用時會自動還原預設隔離層級與會話狀態，無須在 `Disconnect` 中發送額外網路命令。
3. **SQL Server 零額外網路往返會話重置**：
   - 在 SQL Server (`msodbcsql17.dll`) 下，`odbc32.dll` 直接將 TDS `fResetConnection` 旗標夾帶於下次借出後的第一個 SQL 封包中，零額外 RTT 即完成 `#temp` 暫存表与 `CONTEXT_INFO` 清空。
4. **移除 `DbxOpenOdbcPool.pas`**：
   - 從最終架構移除 `source/DbxOpenOdbcPool.pas`，維持 4 個純 Pascal 單元的極簡架構。

---

## 3. 參數開關配置規範 (Configuration Parameters)

可於 `TSQLConnection.Params` 或 `ConnectionString` 中設定：

```ini
DriverName=DbxOpenOdbc
ConnectionString=Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.15;Database=ERP_MASTER;Uid=sa;Pwd=***;
; 啟用 Windows ODBC Driver Manager 原生連線池（預設為 False，保持 100% 向後相容）
Pooling=True
```

- `Pooling=True`（或 `Pooling=Odbc`）：路由至 `FOdbcPooledEnv`（啟用 `SQL_CP_ONE_PER_HENV` + `SQL_CP_STRICT_MATCH`）。
- `Pooling=False`（或省略）：路由至無池化 `FOdbcEnv`。
- 連線字串中若帶有 `Pooling`、`OdbcPooling` 或舊版 `Pool.*` 關鍵字，驅動會在呼叫 `SQLDriverConnectW` 前自動剝離。

---

## 4. 驗收標準與實測狀態 (Acceptance Criteria)

- [x] **SQL Server 效能基準測試（100 次循序 + 8T/16T 並發）**：`Pooling=True` 單次平均延遲僅 `3.221 ms`（較無池化 `17.967 ms` 提速 **5.6 倍**，較自建池 `7.657 ms` 快 **2.4 倍**），8 執行緒達 `305.5 QPS`、16 執行緒達 `572.3 QPS`（無池化為 `53.2 QPS` 與 `56.1 QPS`）。
- [x] **SQL Server 會話隔離與正確性（8/8 全數通過）**：驗證實體連線複用（100 次循環複用單一 `connection_id`）、多資料庫嚴格隔離（`TW_ED` / `TW_OLD` / `TWBS260610`）、DBX 與原生 SQL 未提交交易自動回滾、`#TempTable` 與 `CONTEXT_INFO` 自動重置、`DirtyRead -> ReadCommitted` 隔離層級自動還原、以及斷線重連恢復。
- [x] **進程級 `SQLHENV` 隔離性驗證**：驗證在 `dbx4odbc` 初始化前與後分配的第三方 `SQLHENV` 均保持無池化，且同一 `TSQLConnection` 可於執行期動態切換 `Pooling=False` / `Pooling=True`。
- [x] **多資料庫實體池化與會話隔離實測狀態（已於 `HKLM\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI` 設定 `CPTimeout=60`）**：
  - **SQL Server (`msodbcsql17.dll`)**：**PASS**（實體連線複用 `1 ConnID / 10 次`、跨庫隔離、交易回滾、TDS `fResetConnection` 會話清理全數通過）。
  - **MariaDB 10.6.17 (`myodbc8w.dll` 8.0.36)**：**PASS**（實體連線複用 `1 ConnID / 10 次`、跨庫隔離、DBX 與原生交易回滾、`COM_RESET_CONNECTION` 自動清理暫存表/`@var`/`@@autocommit=1`/隔離層級全數通過）。
  - **PostgreSQL 17.6 (`psqlodbc35w.dll` 17.00)**：**PARTIAL / FAIL (Session Cleanup)**（實體連線複用 `1 PID / 10 次` = **PASS**、跨庫隔離 = **PASS**、DBX 交易回滾與隔離層級還原 = **PASS**；但因 `psqlodbc` 不會自動發送 `DISCARD ALL`，未經 DBX API 之原生 `BEGIN;`、`CREATE TEMP TABLE` 與 `SET statement_timeout` 會殘留至下一借用者）。
  - **Firebird 5.0.4 (`FirebirdODBC.dll` 3.0/3.5)**：**PARTIAL / FAIL (Session Cleanup)**（實體連線複用 `1 AttachmentID / 10 次` = **PASS**、跨庫隔離 = **PASS**、DBX 交易回滾與隔離層級還原 = **PASS**；但因 `FirebirdODBC` 不會自動發送 `ALTER SESSION RESET`，`ON COMMIT PRESERVE ROWS` 暫存表資料列與 `RDB$SET_CONTEXT('USER_SESSION', ...)` 會殘留至下一借用者）。
  - **Oracle**：**NOT VERIFIED**（測試環境無 Oracle 實例）。
- [x] **Win32 與 Win64 完整回歸測試**：通過 `dcc32` 與 `dcc64` 雙平台編譯，以及 `Dbx4MvpTester`、`RuntimeRegressionTester`、`Dbx4MetadataTester`、DataSnap `TDataSetProvider -> TClientDataSet` 全套回歸驗證。
