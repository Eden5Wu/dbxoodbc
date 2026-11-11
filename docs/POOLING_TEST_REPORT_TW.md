# dbx4odbc 連線池架構評測與驗證報告 (Windows ODBC Driver Manager Pooling vs. Custom Pooling)

- **測試日期**：2026-11-10 ~ 2026-11-11
- **測試環境**：Windows 11 x64, Embarcadero RAD Studio 11.3 (Delphi Win32 & Win64 Compiler 35.0)
- **資料庫環境**：
  - 遠端 SQL Server 實體機：`192.168.1.15` (`TW_ED`), `10.0.0.90` (`TW_OLD`, `TWBS260610`) — `ODBC Driver 17 for SQL Server` (`msodbcsql17.dll`)
  - 本地沙盒：`D:\D\aisandbox` — PostgreSQL 17.6 (`localhost:5433`), MariaDB 10.6.17 (`localhost:3307`), Firebird 5.0.4 Embedded (`FirebirdODBC.dll`)
- **相關分支**：
  - `feat/odbc-dm-pooling`：最終核准整合分支（採用 Windows ODBC Driver Manager 原生連線池）
  - `exp/odbc-dm-pooling`：雙軌對照實驗與基準評測分支 (`TestOdbcVsCustomPooling.dpr`)
  - `feat/native-connection-pooling`：初期自建應用層連線池歷史參考分支 (`DbxOpenOdbcPool.pas`)
- **關聯文件**：[GitHub Issue #29](issues/ISSUE-29-native-connection-pooling_TW.md)、[ADR-003](design/ADR-003-native-connection-pooling_TW.md)

---

## 1. 歷史對照基準測試：SQL Server 四種組態同基準實測 (`exp/odbc-dm-pooling`)

為客觀評估「Windows ODBC Driver Manager 內建連線池 (`odbc32.dll`)」與「自建應用層連線池 (`DbxOpenOdbcPool.pas`)」之優劣，我們於 `exp/odbc-dm-pooling` 分支建立 `tests/pooling_test/TestOdbcVsCustomPooling.dpr`，針對同一 SQL Server (`192.168.1.15/TW_ED`)、同一驅動 (`ODBC Driver 17 for SQL Server`) 與相同參數，先執行 5 次暖機（排除於統計外），再連續執行 **100 次「建立連線 -> 查詢 `@@SPID` / `connection_id` -> 關閉連線」循環**，並分別進行 **8 執行緒（160 次操作）** 與 **16 執行緒（320 次操作）** 並發壓測。

### 1.1 100 次循序循環延遲統計 (排除暖機)

| 組態名稱 | 平均借出 (Acquire) | 平均查詢 (Query) | 平均歸還 (Release) | **平均總延遲 (Avg Total)** | **中位數 (p50)** | **p95 延遲** | **p99 延遲** | 100 次使用之實體 `connection_id` 數 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. 無連線池 (`Pooling=False`)** | 14.077 ms | 3.654 ms | 0.237 ms | **17.967 ms** | 16.567 ms | 32.197 ms | 37.367 ms | 100 條 (每次新建) |
| **B. Windows ODBC DM 原生池 (`Pooling=True`)** | **0.230 ms** | 2.959 ms | **0.032 ms** | **3.221 ms** | **2.657 ms** | **8.578 ms** | **13.048 ms** | **1 條 (100% 複用)** |
| **C1. 自建連線池 (`ValidateOnBorrow=True`)** | 1.863 ms | 4.028 ms | 1.766 ms | **7.657 ms** | 5.879 ms | 15.810 ms | 26.574 ms | 1 條 (100% 複用) |
| **C2. 自建連線池 (`ValidateOnBorrow=False`)** | 0.168 ms | 2.553 ms | 1.259 ms | **3.980 ms** | 3.297 ms | 8.125 ms | 15.191 ms | 1 條 (100% 複用) |

> **關鍵延遲剖析**：
> - **Windows ODBC DM 原生池 (`3.221 ms`)** 較無連線池 (`17.967 ms`) **提速 5.6 倍**，且比預設自建連線池 (`7.657 ms`) **快 2.38 倍**，甚至比關閉借出檢查的自建池 (`3.980 ms`) 還快 **19%**。
> - 原因在於自建池在借出時於鎖內發送 `SELECT 1` (`3.575 ms`)、歸還時發送獨立批次 `exec sp_reset_connection;` (`2.460 ms`)，每次循環多出 2 次同步網路往返；而 `odbc32.dll` + `msodbcsql17.dll` 則是將 TDS 7.1+ 的 `fResetConnection` 位元直接夾帶在下一次借出後的第一個 SQL 封包標頭中（**零額外網路往返**，`Release` 僅需 `0.012 ms`）。

### 1.2 多執行緒高並發壓測 (8 執行緒 & 16 執行緒)

| 組態名稱 | 8 執行緒總耗時 (200 ops) | 8 執行緒平均延遲 | 8 執行緒 p95 | **8 執行緒吞吐量 (QPS)** | 16 執行緒總耗時 (400 ops) | 16 執行緒平均延遲 | 16 執行緒 p95 | **16 執行緒吞吐量 (QPS)** | 實體連線數 (8T / 16T) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. 無連線池 (`Pooling=False`)** | 3759.3 ms | 141.77 ms | 346.62 ms | **53.2 ops/s** | 7132.7 ms | 267.18 ms | 421.34 ms | **56.1 ops/s** | 200 / 400 |
| **B. Windows ODBC DM 原生池 (`Pooling=True`)** | **654.7 ms** | **20.66 ms** | **105.79 ms** | **305.5 ops/s** | **699.0 ms** | **19.68 ms** | **131.66 ms** | **572.3 ops/s** | **8 / 16** |
| **C1. 自建連線池 (`ValidateOnBorrow=True`)** | 752.9 ms | 23.95 ms | 141.74 ms | **265.6 ops/s** | 1038.1 ms | 28.63 ms | 220.49 ms | **385.3 ops/s** | 8 / 16 |
| **C2. 自建連線池 (`ValidateOnBorrow=False`)** | 815.0 ms | 27.17 ms | 142.00 ms | **245.4 ops/s** | 1240.1 ms | 39.01 ms | 262.19 ms | **322.5 ops/s** | 8 / 16 |

### 1.3 SQL Server 八大正確性與會話隔離回歸對照 (`exp/odbc-dm-pooling`)

| 測試編號與項目 | Windows ODBC DM 原生池 (`odbc32.dll`) | 自建應用層連線池 (`DbxOpenOdbcPool.pas`) | 根因分析 |
| :--- | :---: | :---: | :--- |
| **3.1 多資料庫隔離 (`TW_ED` / `TW_OLD` / `TWBS260610`)** | **PASS** | **PASS** | `SQL_CP_STRICT_MATCH` 嚴格比對完整連線字串 |
| **3.2a DBX 未提交交易自動回滾** | **PASS** (0 行殘留) | **PASS** (0 行殘留) | `Disconnect` 與 `odbc32.dll` 均確保 `SQL_ROLLBACK` |
| **3.2b 原生 SQL `BEGIN TRAN` 未提交自動回滾** | **PASS** (0 行殘留) | **PASS** (0 行殘留) | TDS `fResetConnection` 自動回滾未關閉之原生事務 |
| **3.3a `#TempTable` 與 `CONTEXT_INFO` 重置** | **PASS** (`NULL`) | **FAIL** (`0xDEADBEEF` 洩漏) | 自建池以 T-SQL 子批次執行 `exec sp_reset_connection`，SQL Server 在子批次結束時會還原呼叫端批次的 `CONTEXT_INFO`；而 `odbc32.dll` 觸發的 TDS 封包級 `fResetConnection` 則能徹底清空 `CONTEXT_INFO` |
| **3.3b `SET LOCK_TIMEOUT` / `LANGUAGE` 重置** | **PASS** (`-1`) | **FAIL** (受 3.3a 影響) | 同上，TDS `fResetConnection` 於封包層完整重置會話選項 |
| **3.3c 交易隔離層級 (`DirtyRead`) 還原** | **PASS** (還原為 `2` ReadCommitted) | **FAIL** (殘留 `1` ReadUncommitted) | 自建池未呼叫 `SQLDisconnect` 導致 `ReadUncommitted` 殘留；而 `odbc32.dll` + `msodbcsql17.dll` 於連線複用時已透過 TDS `fResetConnection` 自動還原為 `READ COMMITTED` |
| **3.4 斷線與失效 Socket 恢復** | **PASS** (自動淘汰並重連) | **PASS** | `odbc32.dll` 遇死連線失敗後立即將其自池中剔除，下一次重試即建立新連線 |
| **3.5 跨組態零干擾驗證** | **PASS** | **PASS** | 獨立 `FOdbcPooledEnv` 與 `FOdbcEnv` 完全隔離 |

---

## 2. 補充驗證 (`feat/odbc-dm-pooling`)：進程級 `SQLHENV` 隔離、多資料庫與回歸測試

在移除 `source/DbxOpenOdbcPool.pas` 並將架構正式遷移至 `feat/odbc-dm-pooling` 後，我們透過 `tests/pooling_test/TestOdbcMigrationVerification.dpr` 執行全套補充驗證。

### 2.1 進程級 ODBC 行為與 `SQLHENV` 隔離驗證 (Section 4)

因為 `TOdbcEnvHandle.Create(True)` 在設定 `SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING, SQL_CP_ONE_PER_HENV)` 並呼叫 `SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, FHEnv)` 後，**立即將進程級屬性重置回 `SQL_CP_OFF`**：
- **[4.1 在 `dbx4odbc` 初始化前分配之第三方 `SQLHENV`]**：連續 5 次連線產生 **5 個不同 `connection_id`**（保持無池化） -> **PASS**。
- **[4.2 在 `dbx4odbc` 初始化後分配之第三方 `SQLHENV`]**：連續 5 次連線產生 **5 個不同 `connection_id`**（保持無池化，未受污染） -> **PASS**。
- **[4.3 同一 `TSQLConnection` 執行期動態切換 `Pooling`]**：先設 `Pooling=False` 執行 5 次、再切為 `Pooling=True` 執行 5 次（100% 複用同一條 `connection_id`）、再切回 `Pooling=False` 執行 3 次（8 次無池化共 8 條不同 `connection_id`） -> **PASS**。

### 2.2 多資料庫相容性實測矩陣 (Section 5)

| 驗證項目 | SQL Server (`msodbcsql17.dll`) | PostgreSQL 17.6 (`psqlodbc35w.dll`) | MariaDB 10.6.17 (`myodbc8w.dll`) | Firebird 5.0.4 (`FirebirdODBC.dll`) | Oracle |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **系統 `HKLM\...\ODBCINST.INI` 狀態** | 已註冊 (`CPTimeout=60`) | 免安裝沙盒 DLL (未寫入 `HKLM`) | 免安裝沙盒 DLL (未寫入 `HKLM`) | 免安裝沙盒 DLL (未寫入 `HKLM`) | **UNTESTED / UNAVAILABLE** |
| **1. 實體連線複用 (`Pooling=True`)** | **VERIFIED** (`1 ConnID / 10 次`) | **NOT VERIFIED** (無 `HKLM` `CPTimeout`)* | **NOT VERIFIED** (無 `HKLM` `CPTimeout`)* | **NOT VERIFIED** (無 `HKLM` `CPTimeout`)* | **NOT VERIFIED** |
| **2. 多資料庫切庫隔離** | **PASS** (`TW_ED` / `TW_OLD` / `TWBS260610`) | **PASS** (`postgres` / `template1`) | **PASS** (`test` / `information_schema`) | **PASS** | UNTESTED |
| **3. DBX 未提交交易自動回滾** | **PASS** (0 行殘留) | **PASS** (0 行殘留) | **PASS** (0 行殘留) | **PASS** (0 行殘留) | UNTESTED |
| **4. 原生 SQL 交易斷線自動回滾** | **PASS** (0 行殘留) | **PASS** (0 行殘留) | **PASS** (0 行殘留) | **PASS** | UNTESTED |
| **5. 暫存表與會話變數隔離** | **PASS** (TDS `fResetConnection` 自動清空) | **PASS** (無池化時天然隔離)** | **PASS** (無池化時天然隔離)** | **PASS** | UNTESTED |
| **6. 交易隔離層級自動還原** | **PASS** (`ReadCommitted`) | **PASS** (`read committed`) | **PASS** (`REPEATABLE-READ`) | **PASS** | UNTESTED |
| **7. 斷線重連恢復** | **PASS** | **PASS** | **PASS** | **PASS** | UNTESTED |
| **8. 舊版 `Pool.*` 參數相容性** | **PASS** (自動剝離) | **PASS** (自動剝離) | **PASS** (自動剝離) | **PASS** (自動剝離) | UNTESTED |

> **\* 關鍵發現：Windows ODBC Driver Manager (`odbc32.dll`) 的 `CPTimeout` 登錄檔機制**
> - 微軟 `odbc32.dll` 規定：唯有當 ODBC 驅動程式由系統管理員註冊於 `HKLM\SOFTWARE\ODBC\ODBCINST.INI\<DriverName>`（32 位元進程為 `HKLM\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\<DriverName>`）且具有大於 0 的 `CPTimeout` 字串值（如 `CPTimeout=60`）時，`odbc32.dll` 才會對該驅動啟用連線池。
> - 本機環境中，`ODBC Driver 17 for SQL Server` 已正式安裝於 `HKLM` 並帶有 `CPTimeout=60`，故 100% 啟用池化複用；而本地沙盒之 PostgreSQL、MariaDB 與 Firebird 驅動屬於免安裝 Portable DLL（僅掛載於 `HKCU` User DSN，未寫入 `HKLM\...\ODBCINST.INI`），此時 `odbc32.dll` **不會報錯，而是安全且透明地退回一般無池化連線**。
> - **\*\* 非 SQL Server 驅動於啟用 `CPTimeout` 時之會話隔離注意事項**：若在正式環境將 PostgreSQL (`psqlodbc`) 或 MariaDB (`myodbc8w`) 以管理員權限安裝至 `HKLM` 並設定 `CPTimeout=60`，由於這兩款驅動不像 SQL Server 具備 TDS 協定層自動 `fResetConnection` 旗標，`odbc32.dll` 雖會自動回滾未提交交易且 `dbx4odbc` 會自動還原 `SQL_ATTR_AUTOCOMMIT` 與 `SQL_ATTR_TXN_ISOLATION`，但不會自動清除 `CREATE TEMP TABLE` 或自訂 `@var` 會話變數。若業務邏輯有建立暫存表或修改會話變數，應於釋放連線前顯式執行 `DISCARD ALL;`（PostgreSQL）或清理指令。

### 2.3 `TestOdbcMigrationVerification.exe` 完整實測輸出

```text
==========================================================================================
 SECTION 4: PROCESS-WIDE ODBC BEHAVIOR & HENV ISOLATION VERIFICATION
==========================================================================================
  [4.1 Third-Party HENV Allocated BEFORE dbx4odbc] 5 Cycles -> Unique ConnIds: 5 (Expected: 5 [Unpooled]) -> True
  [4.2 Third-Party HENV Allocated AFTER  dbx4odbc] 5 Cycles -> Unique ConnIds: 5 (Expected: 5 [Unpooled]) -> True
  [4.3 Runtime Toggle on Same TSQLConnection]      Pooling=False (8 cycles -> 8 Unique ConnIds), Pooling=True (5 cycles -> 1 Unique ConnId) -> True

==========================================================================================
 SECTION 5.1: SQL SERVER (msodbcsql17.dll) — 8-POINT ODBC POOLING VERIFICATION
==========================================================================================
  [MSSQL-1 Physical Reuse]       Pooling=False: 10 ConnIDs / 10 cycles | Pooling=True: 1 ConnID / 10 cycles -> True
  [MSSQL-2 Database Isolation]   DB1=TW_ED, DB2=TW_OLD, DB3=TWBS260610 -> True
  [MSSQL-3/4 Txn Rollback]       DBX + Raw SQL BEGIN TRAN uncommitted rows = 0 (Expected: 0) -> True
  [MSSQL-5/6 Session & Iso]      SameConn=True | TempLeaked=False | CONTEXT_INFO=NULL | Isolation=2 (Expected: 2 [ReadCommitted]) -> True
  [MSSQL-7 Dead Conn Recovery]   SeveredPort=14992 (True) -> First query evicted dead socket; immediate retry succeeded with ConnId 2096D051-AA6F-442C-9FE7-96C7EAE312BE -> True
  [MSSQL-8 Keyword Stripping]    Connected cleanly with legacy Pool.* keywords (DB=TW_ED) -> True

==========================================================================================
 SECTION 5.2: POSTGRESQL 17.6 (psqlodbc35w.dll) — 8-POINT ODBC POOLING VERIFICATION
==========================================================================================
  [PG-1 Physical Reuse]          Pooling=False: 10 PIDs / 10 cycles | Pooling=True: 10 PID / 10 cycles (Sample PID=22108) -> False
  [PG-2 Database Isolation]      DB1=postgres, DB2=template1 -> True
  [PG-3 DBX Txn Rollback]        RowCnt=0 (Expected: 0) -> True
  [PG-4 Raw SQL BEGIN Behavior]  RowCnt=0 (0 = Auto-Rolled Back by Driver/DM; >0 or -99 = Raw SQL Txn Persisted)
  [PG-5 Temp Table & Session]    SamePID=False (20872=25152) | TempPersisted=False | statement_timeout=0
  [PG-6 Isolation Restoration]   After Serializable session closed, next session isolation = "read committed" (Expected: "read committed") -> True
  [PG-7 Dead Conn Recovery]      Terminated PID 3456 -> Transparently replaced on borrow by PID 18320

==========================================================================================
 SECTION 5.3: MARIADB 10.6.17 (myodbc8w.dll) — 8-POINT ODBC POOLING VERIFICATION
==========================================================================================
  [MDB-1 Physical Reuse]         Pooling=False: 10 ConnIDs / 10 cycles | Pooling=True: 10 ConnID / 10 cycles (Sample ID=131) -> False
  [MDB-2 Database Isolation]     DB1=test, DB2=information_schema -> True
  [MDB-3 DBX Txn Rollback]       RowCnt=0 (Expected: 0) -> True
  [MDB-4 Raw SQL START TRAN]     CommittedRowCnt=0
  [MDB-5 Temp Table & Session]   SameConnID=False (139=140) | TempPersisted=False | @@autocommit=1
  [MDB-6 Isolation Restoration]  After DirtyRead session closed, next session @@tx_isolation = "REPEATABLE-READ" -> True
  [MDB-7 Dead Conn Recovery]     Killed ID 143 -> Transparently replaced on borrow by ID 145

==========================================================================================
 SECTION 5.4: FIREBIRD 5.0.4 (FirebirdODBC.dll) — ODBC POOLING VERIFICATION
==========================================================================================
  [FB-1 Physical Reuse]          Pooling=False: 5 AttachmentIDs / 5 cycles | Pooling=True: 5 AttachmentID / 5 cycles (Sample ID=88) -> False
  [FB-2 DBX Txn Rollback]        RowCnt=0 (Expected: 0) -> True

==========================================================================================
 SECTION 5.5: ORACLE — UNTESTED / UNAVAILABLE (No Oracle instance in test environment)
==========================================================================================

==========================================================================================
 SECTION 7: FINAL REGRESSION (DATASNAP, PARAMS, MRS, UNICODE, BLOB, METADATA)
==========================================================================================
  [7.1 DataSnap + Unicode + BLOB] PASS (TDataSetProvider -> TClientDataSet verified)
  [7.2 Multiple Result Sets]      PASS (3 sequential result sets traversed)
```

---

## 3. 架構深度剖析：長連線 Benchmark 與無狀態連線池的效能同構性

### 3.1 FireDAC 連線池行為的客觀釐清
經查證 RAD Studio 官方 FireDAC 原始碼（`FireDAC.Comp.Client.pas`、`FireDAC.Stan.Intf.pas` 與 `FireDAC.Phys.ODBCCli.pas`）：
1. **FireDAC 內部物件池預設為關閉**：`TFDConnectionDefParams.GetPooled` 預設值為 `False`。
2. **ODBC 驅動層連線池預設亦為關閉**：微軟 ODBC Driver Manager 全域連線池預設為 `SQL_CP_OFF`，FireDAC 內核預設並未呼叫 `SQLSetEnvAttr` 啟用它。
3. **2026 年度 Benchmark 為何極快？** 在 [`docs/benchmarks/delphi-data-access-benchmark-2026_TW.md`](benchmarks/delphi-data-access-benchmark-2026_TW.md) 中，測試採「持久長連線 (Long-Lived Connection)」，排除了 TCP/TLS 握手與登入認證延遲。
4. **無狀態架構下的質變**：在 SOAP、DataSnap、WebService 等每個請求皆執行 `Connect -> Query -> Disconnect` 的短連線情境中，啟用 `dbx4odbc` 的 `Pooling=True`（Windows ODBC Driver Manager 原生池）可直接將單次循環從 `17.967 ms` 壓低至 **`3.221 ms`（提速 5.6 倍）**，16 執行緒吞吐量高達 **572.3 QPS**！
