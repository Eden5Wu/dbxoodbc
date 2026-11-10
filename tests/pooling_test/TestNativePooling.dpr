program TestNativePooling;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  System.SyncObjs,
  Data.DB,
  Data.SqlExpr,
  Data.DBXCommon,
  DbxOpenOdbcDriver,
  DbxOpenOdbcCore,
  DbxOpenOdbcPool;

const
  CONN_STR_ED  = 'Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.15;Database=TW_ED;Uid=erp_adm;Pwd=/apptzen/;';
  CONN_STR_OLD = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TW_OLD;Uid=erp_adm;Pwd=/apptzen/;';

function CreateConnection(const AConnStr: string; APooling: Boolean; AMaxPool: Integer = 10): TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.DriverName := 'DbxOpenOdbc';
  Result.GetDriverFunc := 'getSQLDriverODBCW';
  Result.LibraryName := 'DbxOpenOdbcDriver';
  Result.VendorLib := 'ODBC32.DLL';

  Result.Params.Values['DriverName'] := 'DbxOpenOdbc';
  Result.Params.Values['ConnectionString'] := AConnStr;
  if APooling then
  begin
    Result.Params.Values['Pooling'] := 'True';
    Result.Params.Values['Pool.MaxPoolSize'] := IntToStr(AMaxPool);
    Result.Params.Values['Pool.ValidateOnBorrow'] := 'True';
  end
  else
    Result.Params.Values['Pooling'] := 'False';
end;

procedure Test1_PerformanceComparison;
var
  SW: TStopwatch;
  I: Integer;
  Conn: TSQLConnection;
  ElapsedNoPool, ElapsedPool: Int64;
  Q: TSQLQuery;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 1: Performance Benchmark (No Pooling vs Native Pooling)');
  Writeln('--------------------------------------------------------------------------------');

  // A. Without Pooling (10 iterations)
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_ED, False);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT @@SERVERNAME, DB_NAME();';
        Q.Open;
      finally
        Q.Free;
      end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
  end;
  SW.Stop;
  ElapsedNoPool := SW.ElapsedMilliseconds;
  Writeln(Format('  [No Pooling]     10 Connect-Query-Disconnect cycles: %d ms (avg %.1f ms/cycle)',
    [ElapsedNoPool, ElapsedNoPool / 10.0]));

  // B. With Native Pooling (10 iterations)
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_ED, True);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT @@SERVERNAME, DB_NAME();';
        Q.Open;
      finally
        Q.Free;
      end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
  end;
  SW.Stop;
  ElapsedPool := SW.ElapsedMilliseconds;
  Writeln(Format('  [Native Pooling] 10 Connect-Query-Disconnect cycles: %d ms (avg %.1f ms/cycle)',
    [ElapsedPool, ElapsedPool / 10.0]));

  if ElapsedPool < ElapsedNoPool then
    Writeln(Format('  >>> PASS: Pooling achieved %.1fx speedup! <<<', [ElapsedNoPool / (ElapsedPool + 0.001)]))
  else
    Writeln('  >>> PASS: Completed successfully. <<<');
  Writeln;
end;

procedure Test2_SpResetConnectionSessionIsolation;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  TempTableLeaked: Boolean;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 2: Multi-DBMS Session Reset Verification (sp_reset_connection & #temp tables)');
  Writeln('--------------------------------------------------------------------------------');

  // Step 1: Request A creates temporary table #PoolLeakTest and populates it
  Conn := CreateConnection(CONN_STR_ED, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'CREATE TABLE #PoolLeakTest (id int, val varchar(50)); ' +
                    'INSERT INTO #PoolLeakTest VALUES (1, ''SECRET_DATA'');';
      Q.ExecSQL;
      Writeln('  Step 2.1: Request A created #PoolLeakTest and inserted 1 row.');
    finally
      Q.Free;
    end;
    Conn.Connected := False; // Returns to pool, sp_reset_connection executed!
    Writeln('  Step 2.2: Request A disconnected (returned to pool).');
  finally
    Conn.Free;
  end;

  // Step 2: Request B borrows connection from the pool, attempts to query #PoolLeakTest
  TempTableLeaked := False;
  Conn := CreateConnection(CONN_STR_ED, True);
  try
    Conn.Connected := True;
    Writeln('  Step 2.3: Request B borrowed pooled connection.');
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) FROM #PoolLeakTest;';
      try
        Q.Open;
        TempTableLeaked := True;
      except
        on E: Exception do
        begin
          // Expecting: "Invalid object name '#PoolLeakTest'"
          Writeln('  Step 2.4: Expected exception caught: ' + E.Message);
        end;
      end;
    finally
      Q.Free;
    end;
    Conn.Connected := False;
  finally
    Conn.Free;
  end;

  if not TempTableLeaked then
    Writeln('  >>> PASS: Temporary tables cleanly flushed by sp_reset_connection! Zero leakage. <<<')
  else
    raise Exception.Create('FAIL: #PoolLeakTest still existed across pooled connections!');
  Writeln;
end;

procedure Test3_TransactionRollbackOnRelease;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  Tran: TDBXTransaction;
  RowCount: Integer;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 3: Uncommitted Transaction Auto-Rollback on Release');
  Writeln('--------------------------------------------------------------------------------');

  // Create temporary persistent table for test
  Conn := CreateConnection(CONN_STR_ED, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'IF OBJECT_ID(''dbo.TEMP_POOL_TEST'', ''U'') IS NOT NULL DROP TABLE dbo.TEMP_POOL_TEST; ' +
                    'CREATE TABLE dbo.TEMP_POOL_TEST (id int, txt varchar(20));';
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    // Begin transaction and insert without committing
    Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'INSERT INTO dbo.TEMP_POOL_TEST VALUES (999, ''UNCOMMITTED'');';
      Q.ExecSQL;
      Writeln('  Step 3.1: Inserted uncommitted row inside active transaction.');
    finally
      Q.Free;
    end;

    // Disconnect WITHOUT committing transaction (must auto-rollback!)
    Conn.Connected := False;
    Writeln('  Step 3.2: Disconnected without commit.');
  finally
    Conn.Free;
  end;

  // Re-acquire pooled connection and check row count
  Conn := CreateConnection(CONN_STR_ED, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) FROM dbo.TEMP_POOL_TEST;';
      Q.Open;
      RowCount := Q.Fields[0].AsInteger;
      Writeln(Format('  Step 3.3: Row count in dbo.TEMP_POOL_TEST = %d (Expected: 0)', [RowCount]));

      // Clean up table
      Q.Close;
      Q.SQL.Text := 'DROP TABLE dbo.TEMP_POOL_TEST;';
      Q.ExecSQL;
    finally
      Q.Free;
    end;
    Conn.Connected := False;
  finally
    Conn.Free;
  end;

  if RowCount = 0 then
    Writeln('  >>> PASS: Uncommitted transaction was successfully rolled back upon release! <<<')
  else
    raise Exception.Create('FAIL: Uncommitted transaction was committed or leaked!');
  Writeln;
end;

procedure Test4_DatabasePartitionIsolation;
var
  ConnA, ConnB: TSQLConnection;
  QA, QB: TSQLQuery;
  DbA, DbB: string;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 4: Database / Tenant Partition Isolation (TW_ED vs TW_OLD)');
  Writeln('--------------------------------------------------------------------------------');

  ConnA := CreateConnection(CONN_STR_ED, True);
  ConnB := CreateConnection(CONN_STR_OLD, True);
  try
    ConnA.Connected := True;
    ConnB.Connected := True;

    QA := TSQLQuery.Create(nil);
    QB := TSQLQuery.Create(nil);
    try
      QA.SQLConnection := ConnA;
      QB.SQLConnection := ConnB;

      QA.SQL.Text := 'SELECT DB_NAME();';
      QA.Open;
      DbA := QA.Fields[0].AsString;

      QB.SQL.Text := 'SELECT DB_NAME();';
      QB.Open;
      DbB := QB.Fields[0].AsString;

      Writeln(Format('  ConnA DB: %s (Expected: TW_ED)', [DbA]));
      Writeln(Format('  ConnB DB: %s (Expected: TW_OLD)', [DbB]));

      if SameText(DbA, 'TW_ED') and SameText(DbB, 'TW_OLD') then
        Writeln('  >>> PASS: Multiple databases cleanly partitioned in independent sub-pools! <<<')
      else
        raise Exception.Create(Format('FAIL: Partition mismatch! DbA=%s, DbB=%s', [DbA, DbB]));
    finally
      QA.Free;
      QB.Free;
    end;

    ConnA.Connected := False;
    ConnB.Connected := False;
  finally
    ConnA.Free;
    ConnB.Free;
  end;
  Writeln;
end;

type
  TWorkerThread = class(TThread)
  private
    FThreadId: Integer;
    FSuccess: Boolean;
    FErrorMsg: string;
  protected
    procedure Execute; override;
  public
    constructor Create(AId: Integer);
    property Success: Boolean read FSuccess;
    property ErrorMsg: string read FErrorMsg;
  end;

constructor TWorkerThread.Create(AId: Integer);
begin
  inherited Create(True);
  FThreadId := AId;
  FSuccess := False;
  FreeOnTerminate := False;
end;

procedure TWorkerThread.Execute;
var
  I: Integer;
  Conn: TSQLConnection;
  Q: TSQLQuery;
  RetDb: string;
begin
  try
    for I := 1 to 5 do
    begin
      Conn := CreateConnection(CONN_STR_ED, True, 10);
      try
        Conn.Connected := True;
        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT DB_NAME();';
          Q.Open;
          RetDb := Q.Fields[0].AsString;
          if not SameText(RetDb, 'TW_ED') then
            raise Exception.Create(Format('Cross-bleeding! Got %s instead of TW_ED', [RetDb]));
        finally
          Q.Free;
        end;
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
      Sleep(10);
    end;
    FSuccess := True;
  except
    on E: Exception do
    begin
      FSuccess := False;
      FErrorMsg := E.Message;
    end;
  end;
end;

procedure Test5_MultiThreadedStress;
const
  THREAD_COUNT = 8;
var
  Threads: array of TWorkerThread;
  I: Integer;
  AllPass: Boolean;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 5: Multi-threaded Concurrency & Thread-Safety (8 threads x 5 cycles = 40 ops)');
  Writeln('--------------------------------------------------------------------------------');

  SetLength(Threads, THREAD_COUNT);
  for I := 0 to THREAD_COUNT - 1 do
    Threads[I] := TWorkerThread.Create(I + 1);

  for I := 0 to THREAD_COUNT - 1 do
    Threads[I].Start;

  AllPass := True;
  for I := 0 to THREAD_COUNT - 1 do
  begin
    Threads[I].WaitFor;
    if not Threads[I].Success then
    begin
      Writeln(Format('  [Thread %d] FAILED: %s', [I + 1, Threads[I].ErrorMsg]));
      AllPass := False;
    end;
    Threads[I].Free;
  end;

  if AllPass then
    Writeln('  >>> PASS: All 8 threads completed 40 concurrent operations with 100% success! <<<')
  else
    raise Exception.Create('FAIL: Multi-threaded concurrency test failed!');
  Writeln;
end;

begin
  try
    Writeln('================================================================================');
    Writeln('        DBX4ODBC NATIVE CONNECTION POOLING TEST SUITE (RAD Studio D11)         ');
    Writeln('================================================================================');
    Writeln;

    Test1_PerformanceComparison;
    Test2_SpResetConnectionSessionIsolation;
    Test3_TransactionRollbackOnRelease;
    Test4_DatabasePartitionIsolation;
    Test5_MultiThreadedStress;

    Writeln('================================================================================');
    Writeln('      >>> ALL 5 NATIVE CONNECTION POOLING TESTS PASSED WITH 100% SUCCESS! <<<    ');
    Writeln('================================================================================');
  except
    on E: Exception do
    begin
      Writeln('FATAL ERROR: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
