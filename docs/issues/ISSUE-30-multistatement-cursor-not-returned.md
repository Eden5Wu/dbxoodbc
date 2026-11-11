# GitHub Issue #30: [Bug] Multi-Statement Batch SQL Fails with "Cursor not returned from Query" when Intermediate Statements Return No Result Set

- **Repository**: `Eden5Wu/dbx4odbc`
- **Component**: `DbxOpenOdbcDriver.pas` (`TDBXOpenOdbcCommandNative.DerivedExecuteQuery`)
- **Status**: Open (In Progress)
- **Labels**: `bug`, `sql-server`, `dbexpress`, `compatibility`

---

## 1. Problem Statement

When executing a complex batch / multi-statement SQL query where intermediate statements do not produce a result set (such as variable declarations, intermediate `UPDATE` / `INSERT` operations, or `SET` statements without `SET NOCOUNT ON`), the initial execution returns a column count of 0 (`SQLNumResultCols = 0`).

In the current implementation of `TDBXOpenOdbcCommandNative.DerivedExecuteQuery`:
```pascal
if ColCount > 0 then
begin
  ColMetas := FStmt.DescribeResultColumns;
  Result := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False);
end
else
  Result := nil;
```
Because `DerivedExecuteQuery` returns `nil` when the first statement in the batch produces no cursor, Delphi RTL (`Data.SqlExpr` / `TSQLQuery.Open` / `TClientDataSet.Open`) immediately raises an exception:
```
EDatabaseError: Cursor not returned from Query
```
Even though subsequent statements in the batch (such as a terminal `SELECT`) produce a valid result set, the driver never advances to inspect them during initial query execution.

In contrast, other drivers (e.g., Devart dbExpress driver in OLE DB / SQL Server Native Client mode via `IMultipleResults::GetResult`, or Direct mode) automatically iterate past non-cursor status tokens until the first real result set (`ppRowset <> nil`) is reached.

---

## 2. Sanitized Reproduction Case

### 2.1 Environment
- **DBMS**: Microsoft SQL Server
- **Driver**: dbx4odbc (`DbxOpenOdbc` native driver) with Microsoft ODBC Driver 17/18 for SQL Server
- **Framework**: Delphi dbExpress (`TSQLConnection` + `TSQLQuery` + `TDataSetProvider` + `TClientDataSet`)

### 2.2 SQL Pattern
```sql
DECLARE @VAR1 varchar(10), @VAR2 char(10);
SELECT @VAR1 = ISNULL(:PARAM1, ''), @VAR2 = :PARAM2;

-- Intermediate DML or non-query statement that produces a DONE / DONE_IN_PROC token
UPDATE SAMPLE_TABLE SET FIELD_A = 'VALUE' WHERE 1 = 0;

-- Terminal query intended to populate the dataset
SELECT TOP 10
    T.COL_A,
    T.COL_B,
    T.COL_C
FROM SAMPLE_TABLE T
WHERE (@VAR1 = '' OR T.COL_A >= @VAR1);
```

### 2.3 Behavior
- **Without Fix**:
  `Qry.Open` fails with `EDatabaseError: Cursor not returned from Query`.
- **Workaround**:
  Adding `SET NOCOUNT ON;` at the beginning of the SQL suppresses the intermediate `DONE_IN_PROC` row-count tokens, allowing the terminal `SELECT` cursor to be seen immediately.
- **Root Cause Resolution**:
  The driver should automatically skip non-cursor intermediate results using `SQLMoreResults` during `DerivedExecuteQuery` until the first true `ColCount > 0` result set is located.

---

## 3. Proposed Fix Architecture

Align `DerivedExecuteQuery` with the skipping loop already present in `DerivedGetNextReader`:

```pascal
// In TDBXOpenOdbcCommandNative.DerivedExecuteQuery:
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

### 3.1 Impact on Multiple Result Sets (`DerivedGetNextReader`)
- If the batch contains multiple queries (`SELECT 1; SELECT 2;`):
  - `DerivedExecuteQuery` stops immediately at the 1st `SELECT` (`ColCount > 0`).
  - Subsequent calls to `DerivedGetNextReader` advance to the 2nd `SELECT`.
- If the batch contains leading DML before the 1st query (`UPDATE; SELECT 1; UPDATE; SELECT 2;`):
  - `DerivedExecuteQuery` advances past the 1st `UPDATE` to the 1st `SELECT`.
  - `DerivedGetNextReader` advances past the 2nd `UPDATE` to the 2nd `SELECT`.
- **Conclusion**: The fix ensures end-to-end consistency across both single-result and multi-result batch executions.

---

## 4. Acceptance Criteria
1. Executing complex batch SQL with leading/intermediate DML without `SET NOCOUNT ON` succeeds in `TSQLQuery.Open` and `TClientDataSet.Open`.
2. Existing test suites (`Dbx4MvpTester`, `TestMultiDbmsPooling`, `RuntimeRegressionTester`) continue to pass with 0 regressions.
3. Clean separation of concern: No user connection strings or internal database identifiers are leaked.
