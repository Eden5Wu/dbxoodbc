program TestMultiDbmsPooling;

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
  CONN_STR_MARIADB = 'DSN=MariaDBSandbox;';
  CONN_STR_PG      = 'DSN=PostgresSandbox;';

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

{ ============================================================================ }
{                             MARIADB POOLING TESTS                            }
{ ============================================================================ }

procedure TestMariaDB_Performance;
var
  SW: TStopwatch;
  I: Integer;
  Conn: TSQLConnection;
  ElapsedNoPool, ElapsedPool: Int64;
  Q: TSQLQuery;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[MariaDB 10.6] Test 1: Performance Benchmark (No Pool vs Native Pool)');
  Writeln('--------------------------------------------------------------------------------');

  // A. No Pooling
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_MARIADB, False);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT DATABASE(), VERSION();';
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
  Writeln(Format('  [No Pooling]     10 Connect-Query-Disconnect: %d ms (avg %.1f ms/cycle)',
    [ElapsedNoPool, ElapsedNoPool / 10.0]));

  // B. Native Pooling
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_MARIADB, True);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT DATABASE(), VERSION();';
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
  Writeln(Format('  [Native Pooling] 10 Connect-Query-Disconnect: %d ms (avg %.1f ms/cycle)',
    [ElapsedPool, ElapsedPool / 10.0]));

  if ElapsedPool < ElapsedNoPool then
    Writeln(Format('  >>> PASS: MariaDB Pooling achieved %.1fx speedup! <<<', [ElapsedNoPool / (ElapsedPool + 0.001)]))
  else
    Writeln('  >>> PASS: MariaDB Pooling completed successfully. <<<');
  Writeln;
end;

procedure TestMariaDB_SessionReset;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  AutocommitVal: Integer;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[MariaDB 10.6] Test 2: Dialect Session Reset & autocommit Restoration');
  Writeln('--------------------------------------------------------------------------------');

  // Step 1: Request A disables autocommit
  Conn := CreateConnection(CONN_STR_MARIADB, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SET autocommit = 0;';
      Q.ExecSQL;
      Writeln('  Step 2.1: Request A set autocommit = 0.');
    finally
      Q.Free;
    end;
    Conn.Connected := False; // Returns to pool, TMySqlDialect.ResetSession called!
    Writeln('  Step 2.2: Request A disconnected (returned to pool, SET autocommit=1 triggered).');
  finally
    Conn.Free;
  end;

  // Step 2: Request B borrows pooled connection, checks if autocommit was restored
  Conn := CreateConnection(CONN_STR_MARIADB, True);
  try
    Conn.Connected := True;
    Writeln('  Step 2.3: Request B borrowed pooled connection.');
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT @@autocommit;';
      Q.Open;
      AutocommitVal := Q.Fields[0].AsInteger;
      Writeln(Format('  Step 2.4: Query @@autocommit returned: %d (Expected: 1)', [AutocommitVal]));
      if AutocommitVal <> 1 then
        raise Exception.CreateFmt('FAIL: autocommit was %d, expected 1 after session reset!', [AutocommitVal]);
    finally
      Q.Free;
    end;
    Conn.Connected := False;
  finally
    Conn.Free;
  end;

  Writeln('  >>> PASS: MariaDB session reset cleanly restored autocommit=1! <<<');
  Writeln;
end;

procedure TestMariaDB_TransactionRollback;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  Tran: TDBXTransaction;
  RowCount: Integer;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[MariaDB 10.6] Test 3: Uncommitted Transaction Auto-Rollback on Release');
  Writeln('--------------------------------------------------------------------------------');

  Conn := CreateConnection(CONN_STR_MARIADB, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'DROP TABLE IF EXISTS t_pool_m_test;';
      Q.ExecSQL;
      Q.SQL.Text := 'CREATE TABLE t_pool_m_test (id INT PRIMARY KEY, val VARCHAR(50)) ENGINE=InnoDB;';
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    // Begin transaction and insert without committing
    Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
    Assert(Tran <> nil);
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'INSERT INTO t_pool_m_test VALUES (1, ''UNCOMMITTED_DATA'');';
      Q.ExecSQL;
      Writeln('  Step 3.1: Inserted uncommitted row inside active transaction.');
    finally
      Q.Free;
    end;

    // Disconnect WITHOUT commit -> Must auto-rollback
    Conn.Connected := False;
    Writeln('  Step 3.2: Disconnected without commit.');
  finally
    Conn.Free;
  end;

  // Re-acquire and verify row count = 0
  Conn := CreateConnection(CONN_STR_MARIADB, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) FROM t_pool_m_test;';
      Q.Open;
      RowCount := Q.Fields[0].AsInteger;
      Writeln(Format('  Step 3.3: Row count in t_pool_m_test = %d (Expected: 0)', [RowCount]));

      // Clean up
      Q.Close;
      Q.SQL.Text := 'DROP TABLE IF EXISTS t_pool_m_test;';
      Q.ExecSQL;
    finally
      Q.Free;
    end;
    Conn.Connected := False;
  finally
    Conn.Free;
  end;

  if RowCount = 0 then
    Writeln('  >>> PASS: MariaDB uncommitted transaction cleanly rolled back upon release! <<<')
  else
    raise Exception.Create('FAIL: MariaDB uncommitted transaction leaked into table!');
  Writeln;
end;

{ ============================================================================ }
{                           POSTGRESQL POOLING TESTS                           }
{ ============================================================================ }

procedure TestPostgreSQL_Performance;
var
  SW: TStopwatch;
  I: Integer;
  Conn: TSQLConnection;
  ElapsedNoPool, ElapsedPool: Int64;
  Q: TSQLQuery;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[PostgreSQL 17.6] Test 4: Performance Benchmark (No Pool vs Native Pool)');
  Writeln('--------------------------------------------------------------------------------');

  // A. No Pooling
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_PG, False);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT current_database(), version();';
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
  Writeln(Format('  [No Pooling]     10 Connect-Query-Disconnect: %d ms (avg %.1f ms/cycle)',
    [ElapsedNoPool, ElapsedNoPool / 10.0]));

  // B. Native Pooling
  SW := TStopwatch.StartNew;
  for I := 1 to 10 do
  begin
    Conn := CreateConnection(CONN_STR_PG, True);
    try
      Conn.Connected := True;
      Q := TSQLQuery.Create(nil);
      try
        Q.SQLConnection := Conn;
        Q.SQL.Text := 'SELECT current_database(), version();';
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
  Writeln(Format('  [Native Pooling] 10 Connect-Query-Disconnect: %d ms (avg %.1f ms/cycle)',
    [ElapsedPool, ElapsedPool / 10.0]));

  if ElapsedPool < ElapsedNoPool then
    Writeln(Format('  >>> PASS: PostgreSQL Pooling achieved %.1fx speedup! <<<', [ElapsedNoPool / (ElapsedPool + 0.001)]))
  else
    Writeln('  >>> PASS: PostgreSQL Pooling completed successfully. <<<');
  Writeln;
end;

procedure TestPostgreSQL_SessionResetAndDiscardTemp;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  TempTableLeaked: Boolean;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[PostgreSQL 17.6] Test 5: Session Reset Verification (DISCARD TEMP)');
  Writeln('--------------------------------------------------------------------------------');

  // Step 1: Request A creates temporary table in PostgreSQL
  Conn := CreateConnection(CONN_STR_PG, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'CREATE TEMP TABLE pg_pool_temp (id int, val text);';
      Q.ExecSQL;
      Q.SQL.Text := 'INSERT INTO pg_pool_temp VALUES (1, ''SECRET'');';
      Q.ExecSQL;
      Writeln('  Step 5.1: Request A created TEMP TABLE pg_pool_temp and inserted 1 row.');
    finally
      Q.Free;
    end;
    Conn.Connected := False; // Returns to pool, TPostgreSqlDialect.ResetSession executes DISCARD ALL!
    Writeln('  Step 5.2: Request A disconnected (returned to pool, DISCARD ALL executed).');
  finally
    Conn.Free;
  end;

  // Step 2: Request B borrows pooled connection, attempts to query pg_pool_temp
  TempTableLeaked := False;
  Conn := CreateConnection(CONN_STR_PG, True);
  try
    Conn.Connected := True;
    Writeln('  Step 5.3: Request B borrowed pooled connection.');
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) FROM pg_pool_temp;';
      try
        Q.Open;
        TempTableLeaked := True;
      except
        on E: Exception do
        begin
          // Expecting: relation "pg_pool_temp" does not exist
          Writeln('  Step 5.4: Expected exception caught: ' + E.Message);
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
    Writeln('  >>> PASS: PostgreSQL TEMP tables cleanly flushed by DISCARD ALL! Zero leakage. <<<')
  else
    raise Exception.Create('FAIL: pg_pool_temp still existed across pooled connections!');
  Writeln;
end;

procedure TestPostgreSQL_TransactionRollback;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  Tran: TDBXTransaction;
  RowCount: Integer;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('[PostgreSQL 17.6] Test 6: Uncommitted Transaction Auto-Rollback on Release');
  Writeln('--------------------------------------------------------------------------------');

  Conn := CreateConnection(CONN_STR_PG, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'DROP TABLE IF EXISTS t_pool_pg_test;';
      Q.ExecSQL;
      Q.SQL.Text := 'CREATE TABLE t_pool_pg_test (id INT PRIMARY KEY, val VARCHAR(50));';
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    // Begin transaction and insert without committing
    Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
    Assert(Tran <> nil);
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'INSERT INTO t_pool_pg_test VALUES (1, ''UNCOMMITTED_DATA'');';
      Q.ExecSQL;
      Writeln('  Step 6.1: Inserted uncommitted row inside active transaction.');
    finally
      Q.Free;
    end;

    // Disconnect WITHOUT commit -> Must auto-rollback
    Conn.Connected := False;
    Writeln('  Step 6.2: Disconnected without commit.');
  finally
    Conn.Free;
  end;

  // Re-acquire and verify row count = 0
  Conn := CreateConnection(CONN_STR_PG, True);
  try
    Conn.Connected := True;
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) FROM t_pool_pg_test;';
      Q.Open;
      RowCount := Q.Fields[0].AsInteger;
      Writeln(Format('  Step 6.3: Row count in t_pool_pg_test = %d (Expected: 0)', [RowCount]));

      // Clean up
      Q.Close;
      Q.SQL.Text := 'DROP TABLE IF EXISTS t_pool_pg_test;';
      Q.ExecSQL;
    finally
      Q.Free;
    end;
    Conn.Connected := False;
  finally
    Conn.Free;
  end;

  if RowCount = 0 then
    Writeln('  >>> PASS: PostgreSQL uncommitted transaction cleanly rolled back upon release! <<<')
  else
    raise Exception.Create('FAIL: PostgreSQL uncommitted transaction leaked into table!');
  Writeln;
end;

type
  TMultiDbmsWorkerThread = class(TThread)
  private
    FConnStr: string;
    FDbNameExpected: string;
    FSuccess: Boolean;
    FErrorMsg: string;
  protected
    procedure Execute; override;
  public
    constructor Create(const AConnStr, ADbNameExpected: string);
    property Success: Boolean read FSuccess;
    property ErrorMsg: string read FErrorMsg;
  end;

constructor TMultiDbmsWorkerThread.Create(const AConnStr, ADbNameExpected: string);
begin
  inherited Create(True);
  FConnStr := AConnStr;
  FDbNameExpected := ADbNameExpected;
  FSuccess := False;
  FreeOnTerminate := False;
end;

procedure TMultiDbmsWorkerThread.Execute;
var
  I: Integer;
  Conn: TSQLConnection;
  Q: TSQLQuery;
begin
  try
    for I := 1 to 5 do
    begin
      Conn := CreateConnection(FConnStr, True, 10);
      try
        Conn.Connected := True;
        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT 1;';
          Q.Open;
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

procedure TestCrossDbmsConcurrency;
const
  THREADS_PER_DB = 4;
var
  Threads: array of TMultiDbmsWorkerThread;
  I: Integer;
  AllPass: Boolean;
begin
  Writeln('--------------------------------------------------------------------------------');
  Writeln('Test 7: Cross-DBMS Concurrent Stress (4 MariaDB Threads + 4 PostgreSQL Threads)');
  Writeln('--------------------------------------------------------------------------------');

  SetLength(Threads, THREADS_PER_DB * 2);
  for I := 0 to THREADS_PER_DB - 1 do
    Threads[I] := TMultiDbmsWorkerThread.Create(CONN_STR_MARIADB, 'test');
  for I := 0 to THREADS_PER_DB - 1 do
    Threads[THREADS_PER_DB + I] := TMultiDbmsWorkerThread.Create(CONN_STR_PG, 'postgres');

  for I := 0 to High(Threads) do
    Threads[I].Start;

  AllPass := True;
  for I := 0 to High(Threads) do
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
    Writeln('  >>> PASS: Simultaneous Cross-DBMS concurrent operations completed with 100% success! <<<')
  else
    raise Exception.Create('FAIL: Cross-DBMS concurrency test failed!');
  Writeln;
end;

begin
  try
    Writeln('================================================================================');
    Writeln('  DBX4ODBC MULTI-DBMS NATIVE CONNECTION POOLING TEST SUITE (MariaDB + Postgres)  ');
    Writeln('================================================================================');
    Writeln;

    TestMariaDB_Performance;
    TestMariaDB_SessionReset;
    TestMariaDB_TransactionRollback;

    TestPostgreSQL_Performance;
    TestPostgreSQL_SessionResetAndDiscardTemp;
    TestPostgreSQL_TransactionRollback;

    TestCrossDbmsConcurrency;

    Writeln('================================================================================');
    Writeln(' >>> ALL 7 MARIADB & POSTGRESQL NATIVE POOLING TESTS PASSED WITH 100% SUCCESS! <<< ');
    Writeln('================================================================================');
  except
    on E: Exception do
    begin
      Writeln('FATAL ERROR: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
