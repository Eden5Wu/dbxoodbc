# DBX4 Remastered — Data Explorer 整合

[English](README.md)

本套件提供共用的 Runtime Package 工程與 INI 設定片段，讓 Delphi IDE 載入
DbxOpenOdbc。[主 README 第 3 節](../../README_TW.md)的應用程式直接執行時期用法不需要此安裝。

## 目錄內容

```text
packages/DataExplorer/
├── DbxOpenOdbcDataExplorer.dproj
├── DbxOpenOdbcDataExplorer.dpk
├── DbxOpenOdbcDataExplorer.res
├── ini/
│   ├── dbxdrivers.ini
│   └── dbxconnections.ini
├── tests/DataExplorerLoaderTest.dpr
├── Install.ps1
├── Build.ps1
├── README.md
└── README_TW.md
```

套件引用既有 `source/` 單元，依賴同一份 Delphi 安裝的 `rtl`、`dbrtl` 與 `dbexpress`。
各資料庫共用此驅動 BPL，由 `ConnectionString` 選擇已安裝的 ODBC 驅動。

目錄與工程採通用設計；**目前已驗證 Delphi 11／Win32 與 Win64 的編譯及動態載入**，
實際 IDE 連線與瀏覽須另行驗證。下方版本表是
套件檔名識別對照，不代表已保證所有版本的原始碼與 IDE 相容性；其他編譯器可能需要
調整原始碼、轉換工程並另行驗證。

## 依 Delphi 版本設定 LIB suffix

開啟 [`DbxOpenOdbcDataExplorer.dproj`](DbxOpenOdbcDataExplorer.dproj)，
在 **Project → Options → Description → LIB suffix** 設定：

| Delphi 版本 | LIB suffix | 產品／目錄版本號 |
| --- | --- | --- |
| D10 Seattle（10.0） | `230` | `17.0` |
| D10.1 Berlin | `240` | `18.0` |
| D10.2 Tokyo | `250` | `19.0` |
| D10.3 Rio | `260` | `20.0` |
| D10.4 Sydney | `270` | `21.0` |
| D11 Alexandria | `280` | `22.0` |
| D12 Athens | `290` | `23.0` |
| D13 Florence | `370` | `37.0` |

來源：[Embarcadero 官方版本對照表](https://docwiki.embarcadero.com/RADStudio/Florence/en/Compiler_Versions_Table)。
之後新版請查官方 **Package Version**，不要固定加 10 推算；D13 已改為 `370`。

工程預設為 `280`。修改選項並儲存後，請確認兩處一致：

- `.dproj`：`<DllSuffix>280</DllSuffix>`，改為目標版本的值。
- `.dpk`：`{$LIBSUFFIX '280'}`，使用相同的值。

IDE 預期檔名必須與編譯產出一致。例如 D11 產出 `DbxOpenOdbcDataExplorer280.bpl`，
D12 應產出 `DbxOpenOdbcDataExplorer290.bpl`。直接重新命名 BPL 無法取得跨版本相容性。

平台須配合 **IDE 程序的位元數**，ODBC 驅動也要相同。Delphi 11 IDE 必須選 **Win32**，
即使應用程式使用 Win64 也一樣。若使用 Win64 IDE，須建置 Win64 並另行驗證其 DBX 支援。

## 一鍵安裝與建置（推薦正式流程）

直接執行 `Install.bat`（或 `Install.ps1`），腳本會自動從登錄檔偵測已安裝的 RAD Studio 版本、自動同步專案 DllSuffix、自動編譯對應位元數的 BPL，並自動備份及寫入 `dbxdrivers.ini`（含正確的 BPL 絕對路徑）：

```cmd
:: 一鍵執行（免手動解除 PowerShell 執行原則限制）：
Install.bat

:: 含載入器自動驗證：
Install.bat -Verify

:: 一鍵乾淨解除安裝（從 dbxdrivers.ini 移除註冊）：
Install.bat -Uninstall
```

亦可直接在 PowerShell 執行：

```powershell
# 一鍵自動偵測、編譯、驗證並安裝至 Data Explorer
.\Install.ps1 -Verify

# 若需指定特定 Delphi 路徑
.\Install.ps1 -BdsPath 'D:\RADStudio\22.0' -Verify

# 一鍵乾淨解除安裝（從 dbxdrivers.ini 移除註冊）
.\Install.ps1 -Uninstall
```

## RAD Studio CLI (radstudio.exe) — 第三方編譯輔助工具

`Install.ps1` 整合了開源社群工具 [Delphier/radstudio](https://github.com/Delphier/radstudio)（`radstudio.exe`），作為自動化環境偵測與套件建置輔助程式。

> [!IMPORTANT]
> **工具身分聲明**：`radstudio.exe` 是由社群開發者 Delphier 維護之第三方開源命令列工具，**並非** Embarcadero 官方 RAD Studio IDE（`bds.exe`），亦非 Embarcadero 的官方安裝器。

### 為什麼 dbxoodbc 使用此工具？
- **Delphi 社群版（Community Edition / CE）支援**：免費社群版在直接執行命令列編譯器（`dcc32` / `dcc64`）時，官方常有限制（報出 *This version of the product does not support command line compiling*）。`radstudio.exe` 能自動回退並驅動背景 `bds.exe` 執行自動化建置，免去手動打開 IDE 編譯之繁瑣步驟。
- **動態版本與 Suffix 解析**：能自動精確查詢已安裝之 BDS 版本、自訂磁碟機路徑（如 `D:\`）、編譯器版本與對應之套件後綴，徹底擺脫手動維護靜態映射表之負擔。

### 鎖定版本與安全校驗（SHA256）
為確保建置確定性並防止供應鏈安全風險，`Install.ps1` 嚴格鎖定上游版本：
- **上游專案**：https://github.com/Delphier/radstudio
- **鎖定版本**：`v1.0.4`
- **官方下載連結**：`https://github.com/Delphier/radstudio/releases/download/v1.0.4/radstudio-cli-1.0.4-x64.zip`
- **壓縮檔 SHA256 雜湊值**：`4a5b165516b7f04b49f4570fa423458a224d941ce3fdb52fbd5cde7c36c09523`

### 快取機制與離線支援
1. **本機使用者快取**：初次執行時，腳本下載鎖定 ZIP 檔，於**解壓前嚴格比對 SHA256 雜湊**，校驗無誤後快取於 `%LOCALAPPDATA%\dbxoodbc\tools\radstudio-1.0.4\`。
2. **後續離線複用**：第二次執行起直接使用快取之 `radstudio.exe`，不發送任何網路請求。
3. **明確覆寫（Override）**：可透過參數指定自訂路徑（如 `-CliPath "C:\Tools\radstudio.exe"`）或預先加入系統 `PATH`。
4. **原生編譯器回退**：若身處封閉內網或 GitHub 無法連線，可加上 `-SkipCli` 參數，或由腳本自動回退至原生 `Build.ps1`（DCC / MSBuild）編譯路徑。
5. **手動安裝指引**：可自行下載 v1.0.4 ZIP，校驗雜湊後將 `radstudio.exe` 解壓放置於 `%LOCALAPPDATA%\dbxoodbc\tools\radstudio-1.0.4\` 目錄即可。

### 智慧編譯分流機制（商業版 vs 社群版 CE）
- **商業版本（Professional、Enterprise、Architect）**：`Install.ps1` 偵測到支援獨立命令列編譯時，**優先走原生 `Build.ps1`（`dcc32.exe` / `dcc64.exe`）**。建置僅需 0.3 秒極速完成、純命令列背景執行、零 GUI 介面跳動、完全無視窗存檔干擾。
- **社群版本（Community Edition / CE）與 Trial**：因 Embarcadero 官方授權限制 CE 直接執行命令列編譯器，`Install.ps1` 自動分流至 `radstudio.exe bds`，透過背景驅動 `bds.exe` 批次建置。

### 社群版（CE）「是否儲存專案變更」提示說明
- **發生原因**：Embarcadero 官方的 `bds.exe` 並未提供任何關閉時不存檔的命令列旗標（如 `-nosave` 或 `/silent`）。當 `bds.exe` 批次開啟格式版本（`<ProjectVersion>`）早於當前 IDE 的專案時（例如在 D12 CE 開啟 D11 格式專案），IDE 會在記憶體中自動升級專案結構並標記為「已修改」，導致退出時彈出是否存檔的確認框。
- **一勞永逸消除方式**：彈出確認時點選「是（Yes）」儲存，或在 Delphi IDE 中開啟 `DbxOpenOdbcDataExplorer.dproj` 並點擊 **File → Save All**（全部儲存）一次。更新至當前 IDE 的格式版本後，未來所有背景批次建置皆會自動靜默退出，不再彈出提示。

### 僅建置與驗證（不修改 IDE 設定）

Delphi 11 亦可在 IDE 選 **Release／Win32** 後執行 **Build**；或僅呼叫 `Build.ps1`：

```powershell
.\Build.ps1 -BdsPath 'D:\RADStudio\22.0' -Platform Win32 -Verify
```

請換成自己的 Delphi 安裝路徑，並先設定 LIB suffix。腳本會檢查 `.dproj` 與 `.dpk`
後綴是否一致，以及安裝環境是否具備對應 RTL。`-Platform Win64` 可選用 64 位元編譯器
與執行時期套件。

輸出依套件版本與平台分開：

```text
bin/<Platform>/<Configuration>/
build/<Platform>/<Configuration>/
```

預設 D11 Release 產出為：

```text
bin/Win32/Release/DbxOpenOdbcDataExplorer<Suffix>.bpl
```

DCU/DCP 放在 `build/`，產出檔不納入 Git。請使用自己的 Delphi 安裝從原始碼建置。

`-Verify` 使用僅連結 `rtl`、`dbrtl`、`dbexpress` 的獨立主程式，透過私有 INI 測試檔
載入 BPL，不編入自訂驅動單元。`DbxOpenOdbc` 與 `OpenOdbc` 都必須進入 ODBC，並針對
刻意不存在的驅動回報正常錯誤。此測試不連線伺服器、不使用帳密、不修改 IDE 設定；
驗證範圍為套件載入與連線物件建立，資料庫連線及 Data Explorer 中繼資料瀏覽須另外測試。

## IDE 設定

1. 替換 BPL 或修改 INI 前，先關閉 IDE。
2. 備份 IDE 使用的 `dbxdrivers.ini` 與 `dbxconnections.ini`。D11 預設目錄為：

   ```text
   C:\Users\Public\Documents\Embarcadero\Studio\dbExpress\22.0\
   ```

   此處使用產品／目錄版本號，與 LIB suffix 不同。自訂安裝請以 IDE 實際設定為準。
3. 將 BPL 放在固定位置，把 [`ini/dbxdrivers.ini`](ini/dbxdrivers.ini) 合併至 IDE 設定檔。
   保留其他驅動；已有 `DbxOpenOdbc`／`OpenOdbc` 時更新原區段，不建立重複區段；
   `[Installed Drivers]` 也應合併至既有清單。
4. 每個實際使用的驅動區段，只保留一行 `DriverPackageLoader`。以 D11 為例：

   ```ini
   DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative,<DbxOpenOdbcDataExplorer280.bpl 的絕對路徑>
   ```

   將整段 `<...>` 換成實際路徑與檔名，不加引號或角括號。範本中的 `280` 是 D11 範例，
   其他版本須換成自己的產出檔名。僅填檔名須以其目錄已在 IDE 套件／DLL 搜尋路徑為前提；
   使用絕對路徑可避免變更全域 PATH。
5. 可選擇合併 [`ini/dbxconnections.ini`](ini/dbxconnections.ini)，修改伺服器、資料庫與
   ODBC 驅動，或直接在 Data Explorer 建立連線。範例使用 Windows 驗證。
6. 重新啟動 IDE，先測連線，再分別測資料表／欄位瀏覽。`TSQLConnection` 設計模式的
   `Connected = True` 使用同一個已載入的驅動，也應另行驗證。完整中繼資料支援仍受
   驅動實作與目標資料庫影響。

此套件由 DBX 動態載入，不需透過 **Component → Install Packages** 安裝為元件設計套件。
BPL 必須保留在指定路徑；能建立連線項目不代表驅動已能載入或成功連線。

## 中繼資料行為

- catalog、schema 與物件名稱分開處理，不再把 schema 篩選條件截成最後的物件名稱。
- `TableScope` 支援 `tsTable`、`tsView`、`tsSysTable`、`tsSynonym` 的組合。Delphi
  一般預設為 `[tsTable, tsView]`；空的 DBX 類型篩選代表所有類型，不是空結果。
- SQL Server 透過 ODBC 執行唯讀原生 catalog 查詢，依 `sys.objects` 與 `is_ms_shipped`
  分類。SQL Server ODBC（包含 Driver 17）也可能把系統表回報成 `TABLE`，或把程序
  回報成函式；此行為並非只出現在舊版驅動。
- 其他資料庫使用標準 ODBC catalog API，保留其支援的命名空間篩選。不支援的
  synonym／alias 類型不會產生對應物件。
- Tables、Views、Synonyms 與 Procedures 依 DBX collection 格式提供欄位。查詢未提供的
  View 定義及 Synonym 目標保留 NULL；這不代表整套功能已等同 FireDAC。

回歸測試與選用的唯讀 SQL Server 比對，請參考 [`tests/metadata_test`](../../tests/metadata_test/README.md)。

## 問題排查

- **IDE 尋找沒有後綴的 BPL：**檢查 `.dproj` 與 `.dpk` 的 LIB suffix，儲存後關閉、
  重新開啟 `.dproj` 並 Build。不要直接改名來掩蓋預期檔名與產出不一致的問題。
- **僅填 Loader 類別名稱造成 AV：**`DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative`
  須以主程式已註冊此 Loader 為前提。在尚未載入驅動的 D11 主程式中，可能退回載入
  不含此 Loader 的 `DBXCommonDriver280.bpl`，並於連線前觸發已重現的 `rtl280.bpl`
  Read `FFFFFFF4` 錯誤。應指定自訂 BPL 路徑；錯誤指令位址會隨程序環境而變。
- **套件無法載入：**檢查路徑、Delphi 版本、平台、執行時期套件依賴及是否仍載入舊版本。
  若 BPL 存在但錯誤訊息只有檔名，請在 `[DbxOpenOdbc]` 或 `[OpenOdbc]` 區段設定其
  絕對路徑。保留官方 `[Odbc]` 區段，該區段使用不同的驅動與 Loader。
- **正常 ODBC 錯誤：**檢查驅動位元數、連線參數與伺服器存取。套件載入、連線與中繼資料
  瀏覽應分別驗證。

## 移除或更新

關閉 IDE，還原備份 INI，或僅移除此範例新增的連線、驅動及 `[Installed Drivers]` 項目。
原本已存在的驅動區段應還原其先前設定。關閉所有使用 BPL 的主程式，並移除／更新相關
參照後，才刪除或替換 BPL，再重新啟動 IDE。

官方 dbExpress 棄用與未來相容性風險請參考[主 README 第 5 節](../../README_TW.md)。
