# ADR-002: 欄位值轉移與專用 ByteReader 優化策略

- **狀態**：已定案 (Decided)
- **日期**：2026-11-10
- **決策**：在 `master` 主分支維持 Delphi 原生通用 `TDBXReaderByteReader` 作為預設實作，不覆寫自訂專用 ByteReader。
- **關聯議題**：架構評估: 原生 ByteReader 零複製欄位轉移 (`feat/native-byte-reader`)
- **原型驗證分支**：`feat/native-byte-reader`
- **對應英文版**：[English Version](ADR-002-bytereader-strategy.md)

---

## 背景與問題陳述

在 Delphi dbExpress (DBX4) 架構中，資料自驅動層（`TDBXReader`）轉移至上層資料集（`TCustomSQLDataSet.GetFieldData`）或 DataSnap 封包（`TDataSetProvider`）時，會透過 `TDBXReader.GetByteReader` 取得 `TDBXByteReader` 實例進行欄位二進位填充。

在分析 Delphi 原廠 RTL 實作（`Data.DBXCommon.pas` 第 15147 行 `TDBXReaderByteReader.GetWideString`）時發現，原廠採用逐字元迴圈（`while Count > 0 do`）複製 UTF-16 碼元至目的緩衝區：

```pascal
while Count > 0 do
begin
  Ch := WideStringValue.Chars[Index div 2];
  Value[Index] := Byte(Ch);
  Inc(Index);
  Value[Index] := Byte(Integer(Ch) shr 8);
  Inc(Index);
  Dec(Count);
end;
```

工程團隊提出假設：若能在驅動層實作專屬的 `TDBXOpenOdbcByteReader`，僅覆寫 `GetWideString`，以單次記憶體區塊複製（`System.Move`）取代逐字元迴圈，並加入完整的緩衝區容量與邊界保護，是否能為字串密集的讀取與 `ClientDataSet.Open` 帶來顯著效能突破？

---

## 原型設計與安全防禦實作

在原型驗證分支 `feat/native-byte-reader` 上，我們嚴格限縮修改範圍於 `DbxOpenOdbcDriver.pas`（相較於 `master` 淨增僅 71 行），不觸動任何底層連線或 ODBC 核心協定：

1. **繼承與封閉覆寫**：
   實作 `TDBXOpenOdbcByteReader` 繼承 Delphi 原生 `TDBXReaderByteReader`，**僅覆寫 `GetWideString`**；ANSI、整數、浮點、BCD、日期時間與巨量 BLOB 串流 100% 沿用 Delphi 原生路徑。
2. **單次區塊複製**：
   取得字串長度與 UTF-16 位元組數後，使用 `System.Move(Pointer(WideStringValue)^, Value[Offset], StrBytes)` 一次性搬移，並補上結尾雙零字元（#0#0）。
3. **嚴格邊界保護**：
   * 驗證目的位移（`Offset < 0` 或 `Offset > BufLen`）。
   * 驗證剩餘容量，不足時明確拋出 `ERangeError`，徹底防禦越界、靜默截斷或寫入半個 UTF-16 碼元。

---

## 正確性與去識別化驗證結果

為確保改動零副作用，建置了自動化全量摘要對照工具與跨系統檢驗，所有測試資料均完成去識別化處理：

| 驗證項目 | 實測標的與方法 | 驗證結果 | 說明 |
| :--- | :--- | :---: | :--- |
| **邊界例外防禦** | 奇數容量、剛好容量、0/1 byte 容量、負位移、NULL、空字串 | **PASS** | 嚴格阻斷越界，拋出標準 `ERangeError` |
| **BLOB 敏感度實證** | 兩份等長（1024 bytes）、僅在第 512 位元組翻轉 1 bit 的資料流 | **PASS** | 成功驗證 SHA-256 對內容微小差異之敏感度 |
| **全量資料逐欄對齊** | 合成純量表、企業系統設定表、報表樣板表、多媒體單據表 | **PASS** | **33,398 行資料摘要 100% 逐字元完全相符**（兩版摘要 SHA-256 吻合） |
| **多媒體圖檔完整性** | 多媒體單據表之 341 筆高解析圖檔（合計 319.5 MB） | **PASS** | `TSQLQuery` 與 `ClientDataSet` 讀出之圖片大小與 SHA-256 完全吻合 |
| **資料庫跨系統核對** | 抽測樣本首 8,000 bytes 與 SQL Server 原生 `HASHBYTES` 核對 | **PASS** | Delphi 計算之 SHA-256 與 SQL Server 2014 原生計算 100% 吻合 |

已執行的資料與邊界驗證全數通過，證實邏輯行為等價且無記憶體違規。

---

## 實測基準效能數據

測試環境配置為微軟 SQL Server 伺服器，客戶端採用 RAD Studio Delphi 11/12 (Win32)，執行嚴格的「兩版交替先跑」成對量測（Alternating Paired Benchmarks），以排除伺服器快取先後偏誤：

### 1. 企業系統設定表 `ClientDataSet.Open`（3,000 列）
* **Baseline (`master` 原生實作)**：
  * 樣本數據：`160.0 ms`, `168.0 ms`, `183.0 ms`, `162.0 ms`
  * **中位數：165.0 ms**（範圍：160.0 ~ 183.0 ms，抖動 23.0 ms）
* **Unicode 優化版 (`feat/native-byte-reader`)**：
  * 樣本數據：`193.0 ms`, `177.0 ms`, `178.0 ms`, `191.0 ms`
  * **中位數：184.5 ms**（範圍：177.0 ~ 193.0 ms，抖動 16.0 ms）
* **實測差異**：中位數慢 **19.5 ms (+11.8%)**。

### 2. 多媒體單據表 `ClientDataSet.Open`（342 列，載入 319.5 MB 圖檔）
* **Baseline (`master` 原生實作)**：
  * 樣本數據：`14,882.0 ms`, `15,906.0 ms`, `15,666.0 ms`, `15,677.0 ms`
  * **中位數：15,671.5 ms**（範圍：14,882.0 ~ 15,906.0 ms，抖動 1,024.0 ms）
* **Unicode 優化版 (`feat/native-byte-reader`)**：
  * 樣本數據：`15,475.0 ms`, `14,200.0 ms`, `17,857.0 ms`, `16,625.0 ms`
  * **中位數：16,050.0 ms**（範圍：14,200.0 ~ 17,857.0 ms，抖動 3,657.0 ms）
* **實測差異**：中位數慢 **378.5 ms (+2.4%)**。

---

## 機制分析與決策理由

1. **短字串微架構開銷反噬**：
   * 在典型企業資料庫中，絕大多數文字欄位（如代碼、編號、名稱、狀態、日期）字元長度分佈在 **5～30 字元**。
   * 對於極短字串，Delphi 原廠的 CPU 暫存器簡單 `while` 迴圈極短且受分支預測最佳化。
   * 自訂實作在呼叫 `System.Move` 前，必須先執行陣列長度查詢、位移算術、容量條件式防禦檢查，最後再加上 `System.Move` 內部的記憶體對齊判斷與跳轉開銷。這些額外指令開銷直接抵銷了區塊搬移的理論優勢，反而產生微幅效能耗損。
2. **總耗時瓶頸不在欄位字串複製**：
   * `ClientDataSet.Open` 是一段複合管線，包含資料庫端執行、網路 TDS 傳輸、`TDataSetProvider` 封包轉換，以及 `midas.dll` 內部 C++ 樹狀結構節點建立與 B-Tree 索引建置。
   * 欄位字串二進位填充在整體端到端耗時中佔比極微，微觀記憶體優化無法對巨觀效能產生實質槓桿效應。
3. **效能收益未能重現**：
   * 最新一批嚴格成對量測明確顯示較慢，前幾批交替採樣中亦受環境波動影響未能重現穩定收益。
   * 一項以「效能優化」為目標的改動，若無法在嚴格基準測試中穩定重現正向收益，便不應併入核心。

---

## 決策後續影響

- **`master` 主分支決策**：維持現有的 Delphi 原生通用 `TDBXReaderByteReader`。零額外封裝、零維護成本，在常態資料存取下具備最高穩定度與最佳執行效率。
- **分支處置**：`feat/native-byte-reader` 分支永久保留作為原型探索、基準量測工具（`benchmarks/`）與本架構決策紀錄的驗證存檔。
