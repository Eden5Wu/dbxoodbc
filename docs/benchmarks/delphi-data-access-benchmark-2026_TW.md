# Delphi 資料庫存取架構基準評測報告（2026 年度版）
## 五大引擎全方位深度橫評：DBXOODBC、FireDAC、ADO、EMBT DBX SNC 與 EMBT DBX ODBC

- **評測日期**：2026 年 11 月
- **測試環境**：
  - 編譯器：Embarcadero Delphi 11.3 (Alexandria) Win32 Release（`dcc32`，最佳化開啟）
  - 目標資料庫：Microsoft SQL Server 企業級伺服器實體節點
  - 網路環境：專屬 Gigabit 企業區域網路
  - 作業系統：Windows 10 Enterprise x64 / Windows Server

---

## 摘要與背景說明

在過去二十餘年間，Delphi 開發者社群見證了資料庫存取技術的多次重大典範轉移。2002 年 Borland 推出 **dbExpress (DBX)**，旨在以極致輕量、單向唯讀的快取游標取代架構厚重且狀態複雜的 BDE 與 Windows COM/OLE DB (ADO)。然而，在長年的維護演進中，官方舊版驅動積累了沉重的歷史技術債——包括 Memo/BLOB 欄位的非同步延遲來回查詢、底層動態庫相依性過期（微軟已宣告廢棄的 `sqlncli11.dll`），以及通用 ODBC 驅動在複雜寬表上的穩定性缺陷。

本評測報告針對連接 Microsoft SQL Server 的五大主流 Delphi 資料庫存取方案進行嚴謹、完全去識別化的實體驗證與多維度對比：
1. **DBXOODBC**（DbxOpenOdbc v4.2026，純原生 DBX4 架構）
2. **FireDAC**（`FireDAC.Phys.MSSQL`，微軟官方 ODBC Driver 17）
3. **ADO / dbGo**（`Data.Win.ADODB`，微軟 OLE DB 提供者 `SQLOLEDB`）
4. **EMBT DBX SNC**（Embarcadero 原廠 DBX MSSQL 驅動，基於 SQL Native Client 11 `sqlncli11.dll`）
5. **EMBT DBX ODBC**（Embarcadero 官方內建通用 DBX ODBC 驅動，`Data.DBXOdbc`）

---

## 綜合評比總表（Master Evaluation Matrix）

本總表彙整各引擎在客觀效能實測數據、底層架構設計、實務維運、移轉成本與平台相容性等維度的全面對照：

| 評估維度與指標 | DBXOODBC (DBX4 原生) | FireDAC (PhysMSSQL) | ADO (dbGo / OLEDB) | EMBT DBX (MSSQL / SNC) | EMBT DBX (ODBC 通用) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **核心技術架構** | 純 Pascal DBX4 原生驅動 | 現代 Phys 陣列引擎 | Windows COM / OLE DB | 舊版 DBX3/4 DLL 封裝 | 原廠 DBX4 內建 ODBC 驅動 |
| **純量資料讀取吞吐量** | 良好 (150.7 ms, 3.3萬列/秒) | **頂尖** (85.3 ms, 5.8萬列/秒) | 低落 (551.3 ms, 9千列/秒) | **極速** (28.0 ms, 17.8萬列/秒) | 普通 (269.0 ms, 1.8萬列/秒) |
| **多 Memo 寬表抗壓性** | **極穩** (155.7 ms, 行內直讀) | **極快** (87.0 ms, 行內直讀) | 尚可 (335.7 ms, 行內直讀) | ❌ **雪崩** (4,182.7 ms, 萬次封包來回) | 尚可 (245.3 ms, 行內直讀) |
| **超寬表支援 (>200 欄)** | 穩定 (82.3 ms) | **最快** (40.7 ms) | 偏慢 (201.3 ms) | 快速 (70.7 ms) | ❌ **崩潰** (`Invalid cursor position`) |
| **大型 BLOB 二進位串流** | 穩定 (39.3 ms) | 快速 (36.7 ms) | **最快** (16.7 ms) | **最快** (14.7 ms) | ❌ **崩潰** (`Invalid cursor position`) |
| **DataSnap 實戰封包封裝** | **實質戰平** (141.7 ms) | **最快** (87.7 ms) | 緩慢 (316.7 ms) | ❌ **無法使用** (4,837.7 ms, 嚴重停頓) | 偏慢 (226.3 ms) |
| **實體記憶體佔用 (Working Set)** | 🥇 **全場最低** (15.9 ~ 29.1 MB) | 低 (18.1 ~ 27.8 MB) | 偏高 (23.0 ~ 27.9 MB, COM負擔) | 中等 (25.7 ~ 27.5 MB) | 中等 (26.0 ~ 28.9 MB) |
| **既有 DBX 系統無痛移轉度** | 🥇 **零修改** (原位直接替換) | ❌ **極度困難** (全部重寫為 TFD*) | ❌ **極度困難** (全部重寫為 TADO*) | 原狀基準 (既有老專案) | 困難 (連線參數與驅動需調整) |
| **系統部屬複雜度** | 🥇 **零外部 DLL** (3 個 Pascal 源碼直編) | 嵌入 Delphi 單元 (免額外 DLL) | 依賴 Windows 系統 COM 函式庫 | 需部屬 `dbxmss.dll` + `sqlncli11.msi` | 需部屬 `dbxoodbc.dll` 或 package |
| **最新協定相容性 (TLS 1.3 / 新型態)** | 🥇 **完整相容** (微軟 ODBC 17/18 直通) | 🥇 **完整相容** (微軟 ODBC 17/18 直通) | ⚠️ **受限** (SQLOLEDB 已遭微軟廢棄) | ❌ **過期淘汰** (sqlncli11 終止支援) | ⚠️ **不穩定** (寬表與 BLOB 游標錯位) |
| **跨平台支援性（如實剖析）** | ⚠️ **深度綁定 Windows** (以 odbc32.dll 為核心) | 🥇 **完整跨平台** (Win/Linux/macOS/行動端) | ❌ **僅限 Windows** (深陷 COM 體系) | ❌ **僅限 Windows** (依賴 Win32 DLL) | ⚠️ **理論可行** (POSIX unixODBC 極脆弱) |
| **軟體取得與授權成本** | 🥇 **開源免費 (LGPL)** | 需 Delphi 企業版或旗艦版 | 隨 Windows / Delphi 內建 | 隨 Delphi 內建（已停止維護） | 隨 Delphi 內建 |
| **生產環境落地結論** | **強烈推薦**：既有大型 DBX 專案救星 | **強烈推薦**：全新專案與跨平台首選 | **不建議**：僅供維持陳舊系統 | ❌ **高危定時炸彈**：強烈建議淘汰 | ❌ **無法上線**：寬表與串流存在致命當機 |

---

## 實測方法學與各情境去識別化數據

為確保基準測試的客觀、公正與工程可重複性：
- 測試涉及之所有資料庫名稱、架構（Schema）名稱、資料表名稱及連線帳號密碼皆已**完全去識別化**，轉化為通用工程情境。
- 每個情境皆先執行一次熱身查詢（Warm-up），隨後連續採樣 3 次並取其算術平均值。
- 記憶體消耗透過 Windows 核心 API `GetProcessMemoryInfo` 擷取該行程的實體工作集（Working Set Size）。

> [!IMPORTANT]
> **重要架構註記：本評測採用「持久長連線 (Long-Lived Connection)」基準**
> 1. **計時範圍界定**：本基準測試（`BenchDataEngines.dpr`）旨在評測各引擎在「已連通物理通道」下的純資料提取、欄位轉換與記憶體吞吐極限。Stopwatch 碼錶僅量測 `DS.Open` 至 `DS.Eof` 完整遍歷資料之時間，**完全排除了 TCP 三向握手、TLS 加密交握與 SQL 帳密登入協議等物理連線耗時**。
> 2. **連線生命週期**：所有五大受測引擎（包括 FireDAC 與 DBXOODBC）均在測試初始化時連線一次並全程保持 `Connected := True`，未在測試循環中反覆 Connect / Disconnect。
> 3. **無狀態服務端適用性提醒**：若應用於 WebService / SOAP / DataSnap 等「短連線請求（Connect -> Query -> Disconnect）」架構，由於每次連線需額外承擔 20~50 ms 的物理握手開銷，必須搭配連線池技術。請特別注意：**FireDAC 預設同樣未啟用連線池（`Pooled=False`）**，需顯式配置方有池化效果；而在 DBX 架構下則可透過 `dbx4odbc` 內建原生連線池（詳見 ADR-003）達到同等的微秒級複用。

---

### 情境一：純量欄位極速讀取（5,000 列 $\times$ 10 個數值與日期欄位）

- **工作負載特徵**：高吞吐量純量數據讀取，完全不含大型文字與 LOB 欄位。欄位型態包含 `INTEGER`、`BIGINT`、`FLOAT`、`MONEY`、`DATETIME`、`CHAR(1)`、`VARCHAR(50)`、`BIT` 與 `SMALLINT`。
- **資料規模**：5,000 列合成正規化數據。

#### 實測結果：
| 引擎 | 總耗時 (ms) | 每秒讀取列數 (Rows/s) | 每列耗時 ($\mu$s) | 記憶體佔用 (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 原生)** | 150.7 ms | 33,186 | 30.13 $\mu$s | **15.9 MB** (全場最低) |
| **FireDAC (PhysMSSQL)** | 85.3 ms | 58,594 | 17.07 $\mu$s | 18.1 MB |
| **ADO (dbGo / OLEDB)** | 551.3 ms | 9,069 | 110.27 $\mu$s | 23.0 MB |
| **EMBT DBX (MSSQL / SNC)** | **28.0 ms** | 178,571 | 5.60 $\mu$s | 25.7 MB |
| **EMBT DBX (ODBC 通用)** | 269.0 ms | 18,587 | 53.80 $\mu$s | 26.0 MB |

#### 架構解析：
- **EMBT SNC** 在純量場景中跑出 28 ms 的極速，主因其底層專用動態庫 `sqlncli11.dll` 透過預配置的 C-Buffer 直通 SQL Server TDS 封包。
- **FireDAC** 憑藉 Block Cursor 陣列批次提取（`RowsetSize` 游標）展現通用現代引擎的最強實力（85.3 ms）。
- **DBXOODBC** 耗時 150.7 ms，但實體記憶體佔用僅 **15.9 MB**（比 EMBT SNC 節省近 40%）。
- **EMBT DBX ODBC**（269.0 ms）效能顯著偏弱，落後 DBXOODBC 達 78%。
- **ADO** 受到 COM 分派機制與 `Variant` 型別轉換的沉重拖累，耗時高達 551.3 ms。

---

### 情境二：含多個 Memo 寬表讀取（3,000 列 $\times$ 76 欄，含 16 個 Memo 欄位）

- **工作負載特徵**：標準企業級核心主檔，擁有 76 個混合欄位，其中包含 16 個可變長度之文字/Memo 備註欄位。
- **資料規模**：3,000 筆實體記錄。

#### 實測結果：
| 引擎 | 總耗時 (ms) | 每秒讀取列數 (Rows/s) | 每列耗時 ($\mu$s) | 記憶體佔用 (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 原生)** | 155.7 ms | 19,272 | 51.89 $\mu$s | **26.2 MB** |
| **FireDAC (PhysMSSQL)** | **87.0 ms** | 34,483 | 29.00 $\mu$s | 26.8 MB |
| **ADO (dbGo / OLEDB)** | 335.7 ms | 8,937 | 111.89 $\mu$s | 26.5 MB |
| **EMBT DBX (MSSQL / SNC)** | ❌ **4,182.7 ms** | 717 | 1,394.22 $\mu$s | 26.5 MB |
| **EMBT DBX (ODBC 通用)** | 245.3 ms | 12,228 | 81.78 $\mu$s | 26.6 MB |

#### 架構解析：
- **EMBT DBX SNC 的災難性雪崩**：當面對多個 Memo 欄位時，EMBT SNC 的讀取時間由 28 ms 暴衝至 **4,182.7 ms**（效能衰退 **27 倍**）。其原因在於歷史遺留的「隨選延遲讀取機制」：驅動層不會在抓取資料列時同步取得 Memo，而是針對每個記錄的每個 Memo 發動一次獨立的 `TEXTPTR` 網路查詢，在 3,000 列下引發了 $3,000 \times 16 = 48,000$ 次網路來回封包（Round-trip）。
- **DBXOODBC 的架構防禦**：透過 Microsoft ODBC Driver 17 的行內流式讀取，DBXOODBC 在 **155.7 ms** 內順暢完成，**速度為 EMBT 原廠驅動的 26 倍**。
- **EMBT DBX ODBC** 耗時 245.3 ms，雖然避開了 Memo 來回地獄，但仍落後 DBXOODBC 約 57%。

---

### 情境三：超寬表讀取（610 列 $\times$ 210 個純量欄位）

- **工作負載特徵**：參數與設定專用超寬實體表，單列包含 210 個純量欄位。
- **資料規模**：610 筆記錄。

#### 實測結果：
| 引擎 | 總耗時 (ms) | 每秒讀取列數 (Rows/s) | 每列耗時 ($\mu$s) | 記憶體佔用 (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 原生)** | 82.3 ms | 7,409 | 134.97 $\mu$s | **26.6 MB** |
| **FireDAC (PhysMSSQL)** | **40.7 ms** | 15,000 | 66.67 $\mu$s | 27.4 MB |
| **ADO (dbGo / OLEDB)** | 201.3 ms | 3,030 | 330.05 $\mu$s | 27.7 MB |
| **EMBT DBX (MSSQL / SNC)** | 70.7 ms | 8,632 | 115.85 $\mu$s | 27.2 MB |
| **EMBT DBX (ODBC 通用)** | ❌ **崩潰報錯** | — | — | **ODBC Driver 17: Invalid cursor position** |

#### 架構解析：
- **EMBT DBX ODBC 嚴重缺陷**：直接拋出執行期例外 `[Microsoft][ODBC Driver 17 for SQL Server] Invalid cursor position`。檢視 `Data.DBXOdbc.pas` 原始碼可知，其內部靜態區塊緩衝偏移量（`FOffsets`）在處理超大欄位數量（210 欄）時發生偏移溢位或游標同步失步，導致 ODBC 游標狀態損毀。
- **DBXOODBC 穩定性**：採用動態列緩衝適配，在 82.3 ms 內無損完成，毫無記憶體洩漏或游標異常。

---

### 情境四：大型二進位 BLOB 報表串流（57 列，共 1.6 MB 二進位封包）

- **工作負載特徵**：系統報表範本與二進位文件封裝表，57 筆記錄包含約 1.6 MB 之大型 BLOB 流。

#### 實測結果：
| 引擎 | 總耗時 (ms) | 每秒讀取列數 (Rows/s) | 每列耗時 ($\mu$s) | 記憶體佔用 (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 原生)** | 39.3 ms | 1,449 | 690.06 $\mu$s | **27.2 MB** |
| **FireDAC (PhysMSSQL)** | 36.7 ms | 1,555 | 643.27 $\mu$s | 27.2 MB |
| **ADO (dbGo / OLEDB)** | 16.7 ms | 3,420 | 292.40 $\mu$s | 27.3 MB |
| **EMBT DBX (MSSQL / SNC)** | **14.7 ms** | 3,886 | 257.31 $\mu$s | 27.4 MB |
| **EMBT DBX (ODBC 通用)** | ❌ **崩潰報錯** | — | — | **ODBC Driver 17: Invalid cursor position** |

#### 架構解析：
- **EMBT DBX ODBC 再度崩潰**：同樣拋出 `Invalid cursor position`。官方 `Data.DBXOdbc` 中的 `TDBXOdbcByteReader` 在面對 `SQLGetData` 分段串流讀取時，無法正確維護 ODBC 語句游標的狀態機。
- **二進位串流表現**：ADO（16.7 ms）與 EMBT SNC（14.7 ms）因底層具備專屬的 TDS 串流通道而相當快速。DBXOODBC（39.3 ms）與 FireDAC（36.7 ms）在此場景旗鼓相當，差距僅 2.6 ms。

---

### 情境五：DataSnap 中介層端到端封包序列化（`DSP` $\rightarrow$ `ClientDataSet.Open`，3,000 列）

- **工作負載特徵**：標準多層架構（N-Tier）日常作業。資料集交由 `TDataSetProvider` 序列化為 Midas 二進位封包，並在客戶端透過 `ClientDataSet.Open` 解包載入記憶體。
- **測試表結構**：3,000 筆包含 76 個欄位（含 16 個 Memo）的業務主檔。

#### 實測結果：
| 引擎 | 總耗時 (ms) | 處理速率 (Rows/s) | 單列耗時 ($\mu$s) | 記憶體佔用 (MB) |
| :--- | :---: | :---: | :---: | :---: |
| **DBXOODBC (DBX4 原生)** | **141.7 ms** | 21,176 | 47.22 $\mu$s | 29.1 MB |
| **FireDAC (PhysMSSQL)** | **87.7 ms** | 34,221 | 29.22 $\mu$s | 27.8 MB |
| **ADO (dbGo / OLEDB)** | 316.7 ms | 9,474 | 105.56 $\mu$s | 27.9 MB |
| **EMBT DBX (MSSQL / SNC)** | ❌ **4,837.7 ms** | 620 | 1,612.56 $\mu$s | 27.5 MB |
| **EMBT DBX (ODBC 通用)** | 226.3 ms | 13,255 | 75.44 $\mu$s | 28.9 MB |

#### 架構解析與使用者體感（Human Perception）：
- **人體工學反應時間閾值**：
  - 在企業軟體互動中，人類視覺與大腦感知「瞬間即時反應」的生理臨界值通常在 **100 ms 至 200 ms** 之間。
  - **FireDAC**（87.7 ms）與 **DBXOODBC**（141.7 ms）完全處於 200 ms 以內的即時反應區間，在終端使用者進行畫面載入或報表開啟時，**體感完全一致（皆為瞬間反饋）**。
  - 相較之下，**EMBT DBX SNC 耗時接近 5 秒（4,837.7 ms）**，造成畫面凍結，是導致現場使用者投訴「系統卡頓」的真正元兇。
  - **ADO** 耗時逾 300 ms，使用者能明顯感受到等待延遲。

---

## 評測對象客觀畫像與限制剖析

### 1. DBXOODBC（DbxOpenOdbc v4.2026，DBX4 原生）
* **定位**：**現有大規模 DBX / DataSnap 企業系統無痛升級的最佳首選**。
* **主要優勢**：
  * **完全零改寫成本**：現有專案的 `TSQLConnection`、`TSQLQuery`、`TSQLStoredProc` 及所有 DFM 表單元件 **100% 原位保留**，免換元件。
  * **純 Pascal 零外部 DLL**：僅 3 個源碼檔案直接編譯進專案，不再有 `dbxoodbc.dll` 或版本遺失問題。
  * **現代規格相容**：直接走微軟官方最新 ODBC Driver 17/18，完整支援 TLS 1.3、雲端 Azure SQL、Always Encrypted 與 `DATETIME2` 等新資料型態。
  * **徹底解決 Memo 致命傷**：將 EMBT 原廠 4.8 秒的卡頓壓縮至 141 ms。
* **跨平台限制（如實陳述，絕不粉飾）**：
  * **深度鎖定 Windows 生態**：DBXOODBC 的底層 API 單元（`OdbcApi.pas`）核心連結至微軟 Windows 的 `odbc32.dll`。
  * 雖然程式碼理論上保留了 POSIX / unixODBC 的型別定義，但在 Linux、macOS 或行動端（iOS/Android）**未曾經過企業級長期生產環境驗證**。
  * 若您的系統架構目標是 Linux 容器化、跨平台微服務或多端行動 App，**切勿將 DBXOODBC 視為通用跨平台抽象層**。

---

### 2. FireDAC（`FireDAC.Phys.MSSQL`）
* **定位**：**現代 Delphi 官方旗艦資料庫存取框架**。
* **主要優勢**：
  * **極限吞吐量**：Block Cursor 陣列讀取機制在純量與超寬表展現最強極限。
  * **跨平台霸主**：官方一級認證支援 Windows、Linux、macOS、iOS 與 Android。
  * **完整生態系**：提供 Local SQL、批次 DML 陣列寫入與全套監控工具。
* **主要代價**：
  * **移轉代價極其高昂**：無法原位替換舊 DBX；大型 ERP 若有數百張表單與查詢元件，全面重構至 `TFDQuery` 需要巨大的工程人力與驗證風險。
  * **授權門檻**：必須購買 Delphi 企業版或旗艦版。

---

### 3. ADO / dbGo（`Data.Win.ADODB`）
* **定位**：**二十世紀末延續至今的歷史基準線（Baseline）**。
* **技術特質**：
  * 受困於 Windows COM 自動化介面、`BSTR` 字串複製與 `Variant` 封箱解箱，效能全面落後現代引擎 2~4 倍。
  * 預設的 `SQLOLEDB` 早已被微軟廢棄；新專案若從 DBX 改投 ADO 屬於技術架構的倒退。

---

### 4. EMBT DBX (MSSQL / SNC，`Data.DBXMSSQL`)
* **定位**：**必須盡快除役的過期原廠驅動**。
* **核心危機**：
  * 面對多 Memo 欄位時發動高達數萬次的 `TEXTPTR` 網路封包來回，效能暴跌 27 倍。
  * 相依的 `sqlncli11.dll` 已遭微軟終止支援，無法順應現代資安稽核要求。

---

### 5. EMBT DBX ODBC（`Data.DBXOdbc`）
* **定位**：**存在重大瑕疵的官方通用 ODBC 驅動**。
* **核心危機**：
  * 內部狀態機有嚴重缺陷，在面對 **超寬表（210 欄）** 與 **二進位 BLOB 串流** 時百分之百拋出 `Invalid cursor position` 崩潰。
  * 效能普遍偏弱，**完全不適合投入生產環境**。

---

## 結論與技術選型建議

1. **現有大型 DBX 專案維護與升級**：  
   **DBXOODBC** 是目前市場上技術成效最高、遷移成本最低的方案。它消除了 EMBT 原廠驅動的 Memo 暴跌詛咒，記憶體全場最低，DataSnap 體感與 FireDAC 打平，且無需修改既有 DFM 畫面與程式碼。
2. **全新跨平台系統開發**：  
   **FireDAC** 依然是新專案的第一首選，特別是當專案有跨平台（Linux / 行動端）需求或需要極限大量資料寫入陣列時。
3. **老舊驅動除役計畫**：  
   現有系統中若仍在使用 **EMBT DBX SNC** 或 **EMBT DBX ODBC**，應視為高風險技術債，儘速規劃汰換。

