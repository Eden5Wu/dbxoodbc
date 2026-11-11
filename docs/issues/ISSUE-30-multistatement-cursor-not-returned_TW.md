# GitHub Issue #30: [Bug] 複合批次 SQL 包含中間無結果集陳述式時拋出 "Cursor not returned from Query" 錯誤

- **儲存庫**: `Eden5Wu/dbx4odbc`
- **核心單元**: `DbxOpenOdbcDriver.pas` (`TDBXOpenOdbcCommandNative.DerivedExecuteQuery`)
- **狀態**: 進行中 (In Progress)
- **標籤**: `bug`, `sql-server`, `dbexpress`, `compatibility`

---

## 1. 問題描述 (Problem Statement)

當在 Delphi dbExpress 架構下執行包含多陳述式（Multi-statement / Batch）的複合式 SQL，且前段或中段陳述式不產生資料游標（例如變數宣告 `DECLARE`、變數賦值 `SELECT @V=...`、中間更新 `UPDATE`、插入 `INSERT`，且未加上 `SET NOCOUNT ON`）時，ODBC Driver 第一次回傳的結果集欄位數為 0（`SQLNumResultCols = 0`，代表僅回傳受影響列數或執行狀態）。

在現行 `DbxOpenOdbcDriver.pas` 的 `TDBXOpenOdbcCommandNative.DerivedExecuteQuery` 實作中：
```pascal
if ColCount > 0 then
begin
  ColMetas := FStmt.DescribeResultColumns;
  Result := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False);
end
else
  Result := nil;
```
當初始執行的陳述式沒有產生游標時，驅動層直接回傳 `nil` 給 Delphi RTL，導致 Delphi `Data.SqlExpr` 的 `TSQLQuery.Open` 或 `TClientDataSet.Open` 立刻拋出經典例外：
```
EDatabaseError: Cursor not returned from Query
```
儘管後續的 `SELECT` 語句其實已經準備好資料游標，但因前置的非游標 Token 阻擋，驅動層未主動推進跳過，導致查詢中斷。

相較之下，Devart dbExpress 驅動（在非 Direct 模式 / OLE DB / SQL Native Client 路線下，透過 `IMultipleResults::GetResult` 迴圈快轉；或在 Direct 模式下）會自動吞掉前面的無資料結果集，直到抵達第一個真正的資料游標才回傳。

---

## 2. 去識別化測試案例 (Sanitized Reproduction Case)

### 2.1 測試環境
- **資料庫管理系統**: Microsoft SQL Server
- **驅動程式**: dbx4odbc (`DbxOpenOdbc` 原生驅動) + Microsoft ODBC Driver 17/18 for SQL Server
- **開發框架**: Delphi dbExpress (`TSQLConnection` + `TSQLQuery` + `TDataSetProvider` + `TClientDataSet`)

### 2.2 典型 SQL 模式
```sql
DECLARE @VAR1 varchar(10), @VAR2 char(10);
SELECT @VAR1 = ISNULL(:PARAM1, ''), @VAR2 = :PARAM2;

-- 中間 DML 陳述式，會產生 DONE_IN_PROC 受影響列數封包
UPDATE SAMPLE_TABLE SET FIELD_A = 'VALUE' WHERE 1 = 0;

-- 終端主查詢，預期要回傳給資料集
SELECT TOP 10
    T.COL_A,
    T.COL_B,
    T.COL_C
FROM SAMPLE_TABLE T
WHERE (@VAR1 = '' OR T.COL_A >= @VAR1);
```

### 2.3 行為對比
- **未修復前**：`Qry.Open` 或 `Cds.Open` 拋出 `Cursor not returned from Query`。
- **既有臨時解法**：在 SQL 最前端強制加上 `SET NOCOUNT ON;` 以抑制受影響列數 Token。
- **驅動層終極解法**：驅動層應在 `DerivedExecuteQuery` 自動調用 `SQLMoreResults` 跳過非游標結果，自動定位至第一個 `ColCount > 0` 的真正結果集。

---

## 3. 修復架構設計 (Proposed Fix Architecture)

將 `DerivedExecuteQuery` 與 `DerivedGetNextReader` 現有的結果集推進迴圈機制統一：

```pascal
// 在 TDBXOpenOdbcCommandNative.DerivedExecuteQuery 中：
if (ColCount = 0) and (FStmt <> nil) then
begin
  while (ColCount = 0) and FStmt.MoreResults(ColCount) do;
end;

if ColCount > 0 then
begin
  ColMetas := FStmt.DescribeResultColumns;
  Result := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False);
end
else
  Result := nil;
```

### 3.1 對多結果集 (`DerivedGetNextReader`) 的相容性評估
1. **多個純 SELECT**（如 `SELECT 1; SELECT 2;`）：
   - `DerivedExecuteQuery` 在第 1 個 SELECT 立即命中（`ColCount > 0`），直接回傳。
   - 後續調用 `DerivedGetNextReader` 推進至第 2 個 SELECT。完全不受影響。
2. **交錯 DML 的多結果集**（如 `UPDATE; SELECT 1; UPDATE; SELECT 2;`）：
   - `DerivedExecuteQuery` 跳過第 1 個 UPDATE，精確停在第 1 個 SELECT。
   - `DerivedGetNextReader` 內部原有的 `while MoreResults do if ColCount > 0` 迴圈自動跳過第 2 個 UPDATE，精確停在第 2 個 SELECT。
   - **結論**：整條結果集鏈條實現端到端的完全一致與無縫相容。

---

## 4. 驗收標準 (Acceptance Criteria)
1. 包含前置/中置 DML 且未加 `SET NOCOUNT ON` 的複合式批次 SQL，能順利以 `TSQLQuery.Open` 與 `TClientDataSet.Open` 讀取資料。
2. 既有回歸測試套件（`Dbx4MvpTester`、`TestMultiDbmsPooling` 等）全部通過，零迴歸。
3. 嚴格去識別化：文檔與測試案例中不洩漏任何內部伺服器 IP、真實帳密或業務資料表。
