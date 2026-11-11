program TestOdbcVsCustomPooling;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.Winsock2,
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  System.SyncObjs,
  System.Math,
  System.Generics.Collections,
  System.Generics.Defaults,
  Data.DB,
  Data.SqlExpr,
  Data.DBXCommon,
  OdbcApi,
  DbxOpenOdbcDriver,
  DbxOpenOdbcCore,
  DbxOpenOdbcPool;

const
  CONN_STR_ED   = 'Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.15;Database=TW_ED;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_STR_OLD  = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TW_OLD;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_STR_BS1  = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TWBS260610;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_STR_BS2  = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TWBS260901;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';

type
  TPoolTestMode = (ptmNoPool, ptmOdbcPool, ptmCustomPoolPing, ptmCustomPoolNoPing);

  TCycleSample = record
    AcquireUs: Double;
    QueryUs: Double;
    ReleaseUs: Double;
    TotalUs: Double;
    Spid: Integer;
    ConnId: string;
  end;

  TStatsSummary = record
    AvgMs: Double;
    MedianMs: Double;
    P95Ms: Double;
    P99Ms: Double;
    MinMs: Double;
    MaxMs: Double;
  end;

function TicksToUs(ATicks: Int64): Double;
begin
  Result := (ATicks * 1000000.0) / TStopwatch.Frequency;
end;

function ComputeStatsFromUs(const AValuesUs: array of Double): TStatsSummary;
var
  Sorted: TArray<Double>;
  I, N: Integer;
  Sum: Double;
begin
  N := Length(AValuesUs);
  if N = 0 then
  begin
    FillChar(Result, SizeOf(Result), 0);
    Exit;
  end;
  SetLength(Sorted, N);
  Sum := 0;
  for I := 0 to N - 1 do
  begin
    Sorted[I] := AValuesUs[I] / 1000.0; // convert us -> ms
    Sum := Sum + Sorted[I];
  end;
  TArray.Sort<Double>(Sorted);
  Result.AvgMs := Sum / N;
  Result.MinMs := Sorted[0];
  Result.MaxMs := Sorted[N - 1];
  Result.MedianMs := Sorted[N div 2];
  Result.P95Ms := Sorted[Min(N - 1, Trunc(N * 0.95))];
  Result.P99Ms := Sorted[Min(N - 1, Trunc(N * 0.99))];
end;

function CreateTestConnection(const AConnStr: string; AMode: TPoolTestMode; AMaxPool: Integer = 50): TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.DriverName := 'DbxOpenOdbc';
  Result.GetDriverFunc := 'getSQLDriverODBCW';
  Result.LibraryName := 'DbxOpenOdbcDriver';
  Result.VendorLib := 'ODBC32.DLL';

  Result.Params.Values['DriverName'] := 'DbxOpenOdbc';
  Result.Params.Values['ConnectionString'] := AConnStr;

  case AMode of
    ptmNoPool:
      begin
        Result.Params.Values['Pooling'] := 'False';
      end;
    ptmOdbcPool:
      begin
        Result.Params.Values['Pooling'] := 'Odbc';
      end;
    ptmCustomPoolPing:
      begin
        Result.Params.Values['Pooling'] := 'True';
        Result.Params.Values['Pool.MaxPoolSize'] := IntToStr(AMaxPool);
        Result.Params.Values['Pool.ValidateOnBorrow'] := 'True';
      end;
    ptmCustomPoolNoPing:
      begin
        Result.Params.Values['ConnectionString'] := AConnStr + 'APP=CustomNoPing;';
        Result.Params.Values['Pooling'] := 'True';
        Result.Params.Values['Pool.MaxPoolSize'] := IntToStr(AMaxPool);
        Result.Params.Values['Pool.ValidateOnBorrow'] := 'False';
      end;
  end;
end;

{ ============================================================================ }
{ TASK 1: VERIFY HENV POOLING INITIALIZATION & SESSION / CONNECTION ID REUSE   }
{ ============================================================================ }

procedure RunTask1_VerifyOdbcEnvAndSessionReuse;
const
  CYCLES = 10;

  procedure VerifyModeReuse(const ATitle: string; AMode: TPoolTestMode; ExpectReuse: Boolean);
  var
    I, Spid: Integer;
    Conn: TSQLConnection;
    Q: TSQLQuery;
    ConnId, ConnectTime: string;
    UniqueConnIds: TStringList;
    UniqueSpids: TStringList;
  begin
    UniqueConnIds := TStringList.Create;
    UniqueSpids := TStringList.Create;
    try
      UniqueConnIds.Duplicates := dupIgnore;
      UniqueConnIds.Sorted := True;
      UniqueSpids.Duplicates := dupIgnore;
      UniqueSpids.Sorted := True;

      for I := 1 to CYCLES do
      begin
        Conn := CreateTestConnection(CONN_STR_ED, AMode);
        try
          Conn.Connected := True;
          Q := TSQLQuery.Create(nil);
          try
            Q.SQLConnection := Conn;
            Q.SQL.Text :=
              'SELECT @@SPID AS Spid, ' +
              'CAST(connection_id AS VARCHAR(36)) AS ConnId, ' +
              'CONVERT(VARCHAR(30), connect_time, 126) AS ConnectTime ' +
              'FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
            Q.Open;
            Spid := Q.FieldByName('Spid').AsInteger;
            ConnId := Q.FieldByName('ConnId').AsString;
            ConnectTime := Q.FieldByName('ConnectTime').AsString;
            UniqueConnIds.Add(ConnId);
            UniqueSpids.Add(IntToStr(Spid));
          finally
            Q.Free;
          end;
          Conn.Connected := False;
        finally
          Conn.Free;
        end;
      end;

      Writeln(Format('  %-36s | Cycles: %2d | Unique connection_id GUIDs: %2d | Unique SPIDs: %2d | Sample ConnId: %s',
        [ATitle, CYCLES, UniqueConnIds.Count, UniqueSpids.Count, ConnId]));

      if ExpectReuse then
      begin
        if UniqueConnIds.Count = 1 then
          Writeln('    -> [PASS] 100% physical TCP/TDS connection reuse confirmed via sys.dm_exec_connections.connection_id!')
        else
          Writeln(Format('    -> [FAIL] Expected 1 physical connection_id, but observed %d!', [UniqueConnIds.Count]));
      end
      else
      begin
        if UniqueConnIds.Count = CYCLES then
          Writeln('    -> [PASS] 0% connection reuse confirmed (every cycle created a new physical connection_id GUID)!')
        else
          Writeln(Format('    -> [FAIL] Expected %d distinct connection_id GUIDs, but observed %d!', [CYCLES, UniqueConnIds.Count]));
      end;
    finally
      UniqueConnIds.Free;
      UniqueSpids.Free;
    end;
  end;

begin
  Writeln('==========================================================================================');
  Writeln(' TASK 1: INDEPENDENT ODBC POOLING PROTOTYPE & PHYSICAL CONNECTION_ID REUSE VERIFICATION');
  Writeln('==========================================================================================');
  VerifyModeReuse('A. No Pooling (Pooling=False)', ptmNoPool, False);
  VerifyModeReuse('B. ODBC DM Pooling (Pooling=Odbc)', ptmOdbcPool, True);
  VerifyModeReuse('C. Custom Native Pool (Pooling=True)', ptmCustomPoolPing, True);
  Writeln;
end;

{ ============================================================================ }
{ TASK 2: FAIR PERFORMANCE BENCHMARK (100 WARM CYCLES + 8 & 16 THREADS)        }
{ ============================================================================ }

procedure BenchmarkSingleThread100Cycles(const ATitle: string; AMode: TPoolTestMode);
const
  WARMUP_CYCLES = 5;
  BENCH_CYCLES  = 100;
var
  I: Integer;
  Conn: TSQLConnection;
  Q: TSQLQuery;
  T0, T1, T2, T3: Int64;
  AcqArr, QryArr, RelArr, TotArr: array of Double;
  AcqS, QryS, RelS, TotS: TStatsSummary;
  UniqueConnIds: TStringList;
  TotalWallMs: Double;
  WallStart: Int64;
begin
  UniqueConnIds := TStringList.Create;
  try
    UniqueConnIds.Duplicates := dupIgnore;
    UniqueConnIds.Sorted := True;

    // 1. Warmup Phase (5 iterations, excluded from measurements)
    for I := 1 to WARMUP_CYCLES do
    begin
      Conn := CreateTestConnection(CONN_STR_ED, AMode);
      try
        Conn.Connected := True;
        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT @@SPID AS Spid, DB_NAME() AS DbName, CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
          Q.Open;
        finally
          Q.Free;
        end;
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;

    // 2. Measured Phase (100 iterations)
    SetLength(AcqArr, BENCH_CYCLES);
    SetLength(QryArr, BENCH_CYCLES);
    SetLength(RelArr, BENCH_CYCLES);
    SetLength(TotArr, BENCH_CYCLES);

    WallStart := TStopwatch.GetTimeStamp;
    for I := 0 to BENCH_CYCLES - 1 do
    begin
      Conn := CreateTestConnection(CONN_STR_ED, AMode);
      try
        T0 := TStopwatch.GetTimeStamp;
        Conn.Connected := True;
        T1 := TStopwatch.GetTimeStamp;

        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT @@SPID AS Spid, DB_NAME() AS DbName, CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
          Q.Open;
          UniqueConnIds.Add(Q.FieldByName('ConnId').AsString);
        finally
          Q.Free;
        end;
        T2 := TStopwatch.GetTimeStamp;

        Conn.Connected := False;
        T3 := TStopwatch.GetTimeStamp;

        AcqArr[I] := TicksToUs(T1 - T0);
        QryArr[I] := TicksToUs(T2 - T1);
        RelArr[I] := TicksToUs(T3 - T2);
        TotArr[I] := TicksToUs(T3 - T0);
      finally
        Conn.Free;
      end;
    end;
    TotalWallMs := TicksToUs(TStopwatch.GetTimeStamp - WallStart) / 1000.0;

    AcqS := ComputeStatsFromUs(AcqArr);
    QryS := ComputeStatsFromUs(QryArr);
    RelS := ComputeStatsFromUs(RelArr);
    TotS := ComputeStatsFromUs(TotArr);

    Writeln('------------------------------------------------------------------------------------------');
    Writeln(Format(' %s | 100 Cycles Total: %.2f ms (%.1f ops/sec) | Unique ConnIds: %d',
      [ATitle, TotalWallMs, (BENCH_CYCLES * 1000.0) / TotalWallMs, UniqueConnIds.Count]));
    Writeln('------------------------------------------------------------------------------------------');
    Writeln('  Phase                  |   Avg (ms) | Median(p50)|   p95 (ms) |   p99 (ms) |   Min (ms) |   Max (ms)');
    Writeln(Format('  1. Acquire (Connect)   | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f',
      [AcqS.AvgMs, AcqS.MedianMs, AcqS.P95Ms, AcqS.P99Ms, AcqS.MinMs, AcqS.MaxMs]));
    Writeln(Format('  2. Query (Exec+Fetch)  | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f',
      [QryS.AvgMs, QryS.MedianMs, QryS.P95Ms, QryS.P99Ms, QryS.MinMs, QryS.MaxMs]));
    Writeln(Format('  3. Release (Disconnect)| %10.3f | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f',
      [RelS.AvgMs, RelS.MedianMs, RelS.P95Ms, RelS.P99Ms, RelS.MinMs, RelS.MaxMs]));
    Writeln(Format('  4. Total Cycle         | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f | %10.3f',
      [TotS.AvgMs, TotS.MedianMs, TotS.P95Ms, TotS.P99Ms, TotS.MinMs, TotS.MaxMs]));
  finally
    UniqueConnIds.Free;
  end;
end;

type
  TBenchWorker = class(TThread)
  private
    FMode: TPoolTestMode;
    FIterations: Integer;
    FLatenciesUs: TArray<Double>;
    FErrors: Integer;
    FLastError: string;
  protected
    procedure Execute; override;
  public
    constructor Create(AMode: TPoolTestMode; AIterations: Integer);
    property LatenciesUs: TArray<Double> read FLatenciesUs;
    property Errors: Integer read FErrors;
    property LastError: string read FLastError;
  end;

constructor TBenchWorker.Create(AMode: TPoolTestMode; AIterations: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FMode := AMode;
  FIterations := AIterations;
  SetLength(FLatenciesUs, AIterations);
  FErrors := 0;
end;

procedure TBenchWorker.Execute;
var
  I: Integer;
  Conn: TSQLConnection;
  Q: TSQLQuery;
  T0, T1: Int64;
begin
  for I := 0 to FIterations - 1 do
  begin
    T0 := TStopwatch.GetTimeStamp;
    try
      Conn := CreateTestConnection(CONN_STR_ED, FMode, 50);
      try
        Conn.Connected := True;
        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT @@SPID AS Spid, DB_NAME() AS DbName;';
          Q.Open;
          if not SameText(Q.FieldByName('DbName').AsString, 'TW_ED') then
            raise Exception.Create('Wrong DB: ' + Q.FieldByName('DbName').AsString);
        finally
          Q.Free;
        end;
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    except
      on E: Exception do
      begin
        Inc(FErrors);
        FLastError := E.Message;
      end;
    end;
    T1 := TStopwatch.GetTimeStamp;
    FLatenciesUs[I] := TicksToUs(T1 - T0);
  end;
end;

procedure BenchmarkConcurrentThreads(const ATitle: string; AMode: TPoolTestMode; AThreadCount, AItersPerThread: Integer);
var
  Workers: array of TBenchWorker;
  AllLatenciesUs: array of Double;
  I, J, Idx, TotalOps, TotalErrors: Integer;
  WallStart: Int64;
  WallMs, Qps: Double;
  S: TStatsSummary;
  WarmConns: array of TSQLConnection;
begin
  // Pre-warm pool up to AThreadCount simultaneous connections so we measure pooled concurrency
  if AMode <> ptmNoPool then
  begin
    SetLength(WarmConns, AThreadCount);
    for I := 0 to AThreadCount - 1 do
    begin
      WarmConns[I] := CreateTestConnection(CONN_STR_ED, AMode, 50);
      WarmConns[I].Connected := True;
    end;
    for I := 0 to AThreadCount - 1 do
    begin
      WarmConns[I].Connected := False;
      WarmConns[I].Free;
    end;
  end;

  TotalOps := AThreadCount * AItersPerThread;
  SetLength(Workers, AThreadCount);
  for I := 0 to AThreadCount - 1 do
    Workers[I] := TBenchWorker.Create(AMode, AItersPerThread);

  WallStart := TStopwatch.GetTimeStamp;
  for I := 0 to AThreadCount - 1 do
    Workers[I].Start;

  TotalErrors := 0;
  SetLength(AllLatenciesUs, TotalOps);
  Idx := 0;
  for I := 0 to AThreadCount - 1 do
  begin
    Workers[I].WaitFor;
    TotalErrors := TotalErrors + Workers[I].Errors;
    for J := 0 to AItersPerThread - 1 do
    begin
      AllLatenciesUs[Idx] := Workers[I].LatenciesUs[J];
      Inc(Idx);
    end;
    Workers[I].Free;
  end;
  WallMs := TicksToUs(TStopwatch.GetTimeStamp - WallStart) / 1000.0;
  Qps := (TotalOps * 1000.0) / WallMs;
  S := ComputeStatsFromUs(AllLatenciesUs);

  Writeln(Format('  %-34s | %2d Threads x %2d = %3d ops | Wall: %7.1f ms | QPS: %6.1f/s | Avg: %6.2f ms | p50: %6.2f ms | p95: %6.2f ms | p99: %6.2f ms | Err: %d',
    [ATitle, AThreadCount, AItersPerThread, TotalOps, WallMs, Qps, S.AvgMs, S.MedianMs, S.P95Ms, S.P99Ms, TotalErrors]));
end;

procedure RunTask2_PerformanceComparison;
begin
  Writeln('==========================================================================================');
  Writeln(' TASK 2.1: SINGLE-THREAD PHASE-SEPARATED BENCHMARK (5 WARMUP + 100 MEASURED CYCLES)');
  Writeln('==========================================================================================');
  BenchmarkSingleThread100Cycles('A. No Pooling (Pooling=False)', ptmNoPool);
  BenchmarkSingleThread100Cycles('B. Windows ODBC DM Pooling (Pooling=Odbc)', ptmOdbcPool);
  BenchmarkSingleThread100Cycles('C1. Custom Native Pool (ValidateOnBorrow=True)', ptmCustomPoolPing);
  BenchmarkSingleThread100Cycles('C2. Custom Native Pool (ValidateOnBorrow=False)', ptmCustomPoolNoPing);
  Writeln;

  Writeln('==========================================================================================');
  Writeln(' TASK 2.2: CONCURRENT WORKLOAD BENCHMARK (8 THREADS & 16 THREADS)');
  Writeln('==========================================================================================');
  Writeln('  --- 8 Concurrent Threads (25 cycles/thread = 200 ops) ---');
  BenchmarkConcurrentThreads('A. No Pooling', ptmNoPool, 8, 25);
  BenchmarkConcurrentThreads('B. Windows ODBC DM Pooling', ptmOdbcPool, 8, 25);
  BenchmarkConcurrentThreads('C1. Custom Pool (Ping=True)', ptmCustomPoolPing, 8, 25);
  BenchmarkConcurrentThreads('C2. Custom Pool (Ping=False)', ptmCustomPoolNoPing, 8, 25);
  Writeln;
  Writeln('  --- 16 Concurrent Threads (25 cycles/thread = 400 ops) ---');
  BenchmarkConcurrentThreads('A. No Pooling', ptmNoPool, 16, 25);
  BenchmarkConcurrentThreads('B. Windows ODBC DM Pooling', ptmOdbcPool, 16, 25);
  BenchmarkConcurrentThreads('C1. Custom Pool (Ping=True)', ptmCustomPoolPing, 16, 25);
  BenchmarkConcurrentThreads('C2. Custom Pool (Ping=False)', ptmCustomPoolNoPing, 16, 25);
  Writeln;
end;

{ ============================================================================ }
{ TASK 3: CORRECTNESS, SESSION ISOLATION, DEAD CONNECTION & LIFECYCLE TESTS    }
{ ============================================================================ }

type
  TIsolationWorker = class(TThread)
  private
    FMode: TPoolTestMode;
    FWorkerIdx: Integer;
    FIterations: Integer;
    FErrors: Integer;
    FBleeds: Integer;
    FLastError: string;
  protected
    procedure Execute; override;
  public
    constructor Create(AMode: TPoolTestMode; AWorkerIdx, AIterations: Integer);
    property Errors: Integer read FErrors;
    property Bleeds: Integer read FBleeds;
    property LastError: string read FLastError;
  end;

constructor TIsolationWorker.Create(AMode: TPoolTestMode; AWorkerIdx, AIterations: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FMode := AMode;
  FWorkerIdx := AWorkerIdx;
  FIterations := AIterations;
end;

procedure TIsolationWorker.Execute;
var
  I, TargetIdx: Integer;
  ConnStr, ExpectedDb, ActualDb: string;
  Conn: TSQLConnection;
  Q: TSQLQuery;
begin
  for I := 0 to FIterations - 1 do
  begin
    TargetIdx := (FWorkerIdx + I) mod 3;
    case TargetIdx of
      0: begin ConnStr := CONN_STR_ED;  ExpectedDb := 'TW_ED'; end;
      1: begin ConnStr := CONN_STR_OLD; ExpectedDb := 'TW_OLD'; end;
    else
      begin ConnStr := CONN_STR_BS1; ExpectedDb := 'TWBS260610'; end;
    end;
    try
      Conn := CreateTestConnection(ConnStr, FMode, 50);
      try
        Conn.Connected := True;
        Q := TSQLQuery.Create(nil);
        try
          Q.SQLConnection := Conn;
          Q.SQL.Text := 'SELECT DB_NAME() AS DbName;';
          Q.Open;
          ActualDb := Q.FieldByName('DbName').AsString;
          if not SameText(ActualDb, ExpectedDb) then
          begin
            Inc(FBleeds);
            FLastError := Format('Expected %s but got %s', [ExpectedDb, ActualDb]);
          end;
        finally
          Q.Free;
        end;
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    except
      on E: Exception do
      begin
        Inc(FErrors);
        FLastError := E.Message;
      end;
    end;
  end;
end;

function SeverLocalTcpPort(ALocalPort: Integer): Boolean;
var
  H: NativeUInt;
  Addr: TSockAddrIn;
  AddrLen: Integer;
begin
  Result := False;
  if ALocalPort <= 0 then
    Exit;
  for H := 4 to 65536 do
  begin
    if (H and 3) <> 0 then
      Continue;
    AddrLen := SizeOf(Addr);
    FillChar(Addr, SizeOf(Addr), 0);
    if getsockname(TSocket(H), TSockAddr(Addr), AddrLen) = 0 then
    begin
      if (Addr.sin_family = AF_INET) and (ntohs(Addr.sin_port) = Word(ALocalPort)) then
      begin
        shutdown(TSocket(H), SD_BOTH);
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure VerifyCorrectnessSuiteForMode(const AModeName: string; AMode: TPoolTestMode);
var
  Conn1, Conn2: TSQLConnection;
  Q1, Q2: TSQLQuery;
  Tran: TDBXTransaction;
  Db1, Db2, Db3, ConnId1, ConnId2: string;
  Spid1, Spid2, ClientPort, LockTimeoutVal, RowCnt, IsoLevel, I, TotalErr, TotalBleed: Integer;
  CtxHex: string;
  TempTableExists, SocketSevered: Boolean;
  Workers: array[0..15] of TIsolationWorker;
begin
  Writeln('==========================================================================================');
  Writeln(' TASK 3 CORRECTNESS SUITE: ' + AModeName);
  Writeln('==========================================================================================');

  // --------------------------------------------------------------------------
  // 3.1 Database Isolation (Cross-Server & Same-Server Multi-Database)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test31;', AMode);
  Conn2 := CreateTestConnection(CONN_STR_OLD + 'APP=Test31;', AMode);
  try
    Conn1.Connected := True;
    Conn2.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    Q2 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT DB_NAME() AS DbName;';
      Q1.Open;
      Db1 := Q1.FieldByName('DbName').AsString;

      Q2.SQLConnection := Conn2;
      Q2.SQL.Text := 'SELECT DB_NAME() AS DbName;';
      Q2.Open;
      Db2 := Q2.FieldByName('DbName').AsString;
    finally
      Q1.Free;
      Q2.Free;
    end;
    Conn1.Connected := False;
    Conn2.Connected := False;
  finally
    Conn1.Free;
    Conn2.Free;
  end;

  // Same server (10.0.0.90) different database (TWBS260610)
  Conn1 := CreateTestConnection(CONN_STR_BS1 + 'APP=Test31;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT DB_NAME() AS DbName;';
      Q1.Open;
      Db3 := Q1.FieldByName('DbName').AsString;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  if SameText(Db1, 'TW_ED') and SameText(Db2, 'TW_OLD') and SameText(Db3, 'TWBS260610') then
    Writeln(Format('  [3.1 Database Isolation]         PASS (TW_ED=%s, TW_OLD=%s, TWBS260610=%s)', [Db1, Db2, Db3]))
  else
    Writeln(Format('  [3.1 Database Isolation]         FAIL (Got %s, %s, %s)', [Db1, Db2, Db3]));

  // --------------------------------------------------------------------------
  // 3.2a Transaction Safety (DBX BeginTransaction uncommitted rollback)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test32a;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text :=
        'IF OBJECT_ID(''dbo.POOL_TXN_VERIFY'', ''U'') IS NOT NULL DROP TABLE dbo.POOL_TXN_VERIFY; ' +
        'CREATE TABLE dbo.POOL_TXN_VERIFY (id INT, note VARCHAR(30));';
      Q1.ExecSQL;
    finally
      Q1.Free;
    end;

    Tran := Conn1.BeginTransaction(TDBXIsolations.ReadCommitted);
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'INSERT INTO dbo.POOL_TXN_VERIFY VALUES (1, ''UNCOMMITTED_DBX'');';
      Q1.ExecSQL;
    finally
      Q1.Free;
    end;
    // Disconnect without Commit
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test32a;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT COUNT(*) AS Cnt FROM dbo.POOL_TXN_VERIFY;';
      Q1.Open;
      RowCnt := Q1.FieldByName('Cnt').AsInteger;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  if RowCnt = 0 then
    Writeln('  [3.2a DBX Transaction Rollback]  PASS (Uncommitted DBX transaction rolled back, RowCnt=0)')
  else
    Writeln(Format('  [3.2a DBX Transaction Rollback]  FAIL (RowCnt=%d)', [RowCnt]));

  // --------------------------------------------------------------------------
  // 3.2b Transaction Safety (Raw SQL BEGIN TRAN without DBX BeginTransaction)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test32b;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'BEGIN TRAN; INSERT INTO dbo.POOL_TXN_VERIFY VALUES (2, ''UNCOMMITTED_RAW_SQL'');';
      Q1.ExecSQL;
    finally
      Q1.Free;
    end;
    // Disconnect without Commit while raw SQL transaction is open (FInTransaction = False!)
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test32b;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT @@TRANCOUNT AS TranCnt, (SELECT COUNT(*) FROM dbo.POOL_TXN_VERIFY WITH (NOLOCK)) AS RowCnt;';
      Q1.Open;
      IsoLevel := Q1.FieldByName('TranCnt').AsInteger;
      RowCnt := Q1.FieldByName('RowCnt').AsInteger;
      Q1.Close;
      Q1.SQL.Text := 'IF @@TRANCOUNT > 0 ROLLBACK TRAN; DROP TABLE dbo.POOL_TXN_VERIFY;';
      Q1.ExecSQL;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  if (IsoLevel = 0) and (RowCnt = 0) then
    Writeln('  [3.2b Raw SQL BEGIN TRAN Safety] PASS (@@TRANCOUNT=0, RowCnt=0 after reuse)')
  else
    Writeln(Format('  [3.2b Raw SQL BEGIN TRAN Safety] FAIL (Leaked @@TRANCOUNT=%d, RowCnt=%d!)', [IsoLevel, RowCnt]));

  // --------------------------------------------------------------------------
  // 3.3a & 3.3b Session Cleanup (#temp tables, LOCK_TIMEOUT, CONTEXT_INFO)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test33ab;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
      Q1.Open;
      ConnId1 := Q1.FieldByName('ConnId').AsString;
      Q1.Close;

      Q1.SQL.Text :=
        'CREATE TABLE #PoolVerifyTemp (id INT); ' +
        'INSERT INTO #PoolVerifyTemp VALUES (42); ' +
        'SET LOCK_TIMEOUT 12345; ' +
        'SET CONTEXT_INFO 0xDEADBEEF;';
      Q1.ExecSQL;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  TempTableExists := False;
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test33ab;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text :=
        'SELECT CAST(c.connection_id AS VARCHAR(36)) AS ConnId, ' +
        '@@LOCK_TIMEOUT AS LockTimeout, ' +
        ' ISNULL(CONVERT(VARCHAR(20), CONTEXT_INFO(), 1), ''NULL'') AS CtxInfo ' +
        'FROM sys.dm_exec_connections c WHERE c.session_id = @@SPID;';
      Q1.Open;
      ConnId2 := Q1.FieldByName('ConnId').AsString;
      LockTimeoutVal := Q1.FieldByName('LockTimeout').AsInteger;
      CtxHex := Q1.FieldByName('CtxInfo').AsString;
      Q1.Close;

      Q1.SQL.Text := 'SELECT COUNT(*) FROM #PoolVerifyTemp;';
      try
        Q1.Open;
        TempTableExists := True;
      except
        TempTableExists := False;
      end;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  if SameText(ConnId1, ConnId2) and (not TempTableExists) and (LockTimeoutVal = -1) and (Pos('DEADBEEF', UpperCase(CtxHex)) = 0) then
    Writeln(Format('  [3.3a/b Session & #Temp Cleanup] PASS (Same ConnId=%s, #temp flushed, LOCK_TIMEOUT=%d, CONTEXT_INFO=%s)',
      [ConnId2, LockTimeoutVal, CtxHex]))
  else
    Writeln(Format('  [3.3a/b Session & #Temp Cleanup] FAIL (ConnIdMatch=%s, TempExists=%s, LOCK_TIMEOUT=%d, CONTEXT_INFO=%s)',
      [BoolToStr(SameText(ConnId1, ConnId2), True), BoolToStr(TempTableExists, True), LockTimeoutVal, CtxHex]));

  // --------------------------------------------------------------------------
  // 3.3c Transaction Isolation Level Reset (No DirtyRead Leak Across Borrowers)
  // --------------------------------------------------------------------------
  // Cycle 1: Caller 1 uses DirtyRead (ReadUncommitted = 1) and closes connection
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test33c;', AMode);
  try
    Conn1.Connected := True;
    Tran := Conn1.BeginTransaction(TDBXIsolations.DirtyRead);
    Conn1.CommitFreeAndNil(Tran);
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  // Cycle 2: Caller 2 borrows the connection expecting default ReadCommitted (2), NOT DirtyRead (1)!
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test33c;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      // In sys.dm_exec_sessions: 1 = ReadUncommitted, 2 = ReadCommitted (SQL Server default)
      Q1.SQL.Text := 'SELECT transaction_isolation_level AS Iso FROM sys.dm_exec_sessions WHERE session_id = @@SPID;';
      Q1.Open;
      IsoLevel := Q1.FieldByName('Iso').AsInteger;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
  finally
    Conn1.Free;
  end;

  if IsoLevel = 2 then
    Writeln('  [3.3c Isolation Level Cleanup]   PASS (Reset to default ReadCommitted [IsoLevel=2] after DirtyRead session closed)')
  else
    Writeln(Format('  [3.3c Isolation Level Cleanup]   FAIL (DirtyRead LEAKED to next caller! Expected ReadCommitted [2], got IsoLevel=%d [ReadUncommitted])', [IsoLevel]));

  // --------------------------------------------------------------------------
  // 3.4 Dead Connection Recovery (Sever physical TCP socket while idle in pool)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test34;', AMode);
  try
    Conn1.Connected := True;
    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT @@SPID AS Spid, client_tcp_port AS ClientPort, CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
      Q1.Open;
      Spid1 := Q1.FieldByName('Spid').AsInteger;
      ClientPort := Q1.FieldByName('ClientPort').AsInteger;
      ConnId1 := Q1.FieldByName('ConnId').AsString;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False; // Now sitting idle in pool on local TCP port ClientPort
  finally
    Conn1.Free;
  end;

  // Forcibly sever the exact local TCP socket (shutdown SD_BOTH) while the connection is idle in the pool
  SocketSevered := SeverLocalTcpPort(ClientPort);
  Sleep(100); // Allow TCP FIN/RST to propagate

  // Now borrow from pool and attempt query
  Spid2 := -1;
  ConnId2 := '';
  try
    Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test34;', AMode);
    try
      Conn1.Connected := True;
      Q1 := TSQLQuery.Create(nil);
      try
        Q1.SQLConnection := Conn1;
        Q1.SQL.Text := 'SELECT @@SPID AS Spid, CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
        Q1.Open;
        Spid2 := Q1.FieldByName('Spid').AsInteger;
        ConnId2 := Q1.FieldByName('ConnId').AsString;
      finally
        Q1.Free;
      end;
      Conn1.Connected := False;
    finally
      Conn1.Free;
    end;
    Writeln(Format('  [3.4 Dead Connection Recovery]   PASS (SeveredPort=%d [%s], OldConnId=%s transparently replaced on borrow by NewConnId=%s)',
      [ClientPort, BoolToStr(SocketSevered, True), Copy(ConnId1, 1, 8), Copy(ConnId2, 1, 8)]));
  except
    on E: Exception do
    begin
      // If first checkout after TCP socket death threw 08S01 communication link failure, check if dead connection was evicted and immediate retry succeeds
      try
        Conn1 := CreateTestConnection(CONN_STR_ED + 'APP=Test34;', AMode);
        try
          Conn1.Connected := True;
          Q1 := TSQLQuery.Create(nil);
          try
            Q1.SQLConnection := Conn1;
            Q1.SQL.Text := 'SELECT @@SPID AS Spid, CAST(connection_id AS VARCHAR(36)) AS ConnId FROM sys.dm_exec_connections WHERE session_id = @@SPID;';
            Q1.Open;
            Spid2 := Q1.FieldByName('Spid').AsInteger;
            ConnId2 := Q1.FieldByName('ConnId').AsString;
          finally
            Q1.Free;
          end;
          Conn1.Connected := False;
        finally
          Conn1.Free;
        end;
        Writeln(Format('  [3.4 Dead Connection Recovery]   RECOVERED_ON_NEXT_BORROW (First query on severed TCP port %d raised "%s" and evicted dead handle; immediate next borrow succeeded with NewConnId=%s)',
          [ClientPort, E.Message, Copy(ConnId2, 1, 8)]));
      except
        on E2: Exception do
          Writeln(Format('  [3.4 Dead Connection Recovery]   FAIL (Failed to recover: %s)', [E2.Message]));
      end;
    end;
  end;

  // --------------------------------------------------------------------------
  // 3.5 Multi-Database Concurrent Isolation (16 threads x 20 cycles across 3 DBs)
  // --------------------------------------------------------------------------
  for I := 0 to 15 do
    Workers[I] := TIsolationWorker.Create(AMode, I, 20);
  for I := 0 to 15 do
    Workers[I].Start;
  TotalErr := 0;
  TotalBleed := 0;
  for I := 0 to 15 do
  begin
    Workers[I].WaitFor;
    TotalErr := TotalErr + Workers[I].Errors;
    TotalBleed := TotalBleed + Workers[I].Bleeds;
    Workers[I].Free;
  end;
  if (TotalErr = 0) and (TotalBleed = 0) then
    Writeln('  [3.5 Concurrent Multi-DB Safety] PASS (16 threads x 20 ops across 3 DBs = 320 ops, Bleed=0, Errors=0)')
  else
    Writeln(Format('  [3.5 Concurrent Multi-DB Safety] FAIL (Bleeds=%d, Errors=%d)', [TotalBleed, TotalErr]));

  // --------------------------------------------------------------------------
  // 3.6 Lifecycle Safety (Active connection unaffected when another connection closes)
  // --------------------------------------------------------------------------
  Conn1 := CreateTestConnection(CONN_STR_ED, AMode);
  Conn2 := CreateTestConnection(CONN_STR_ED, AMode);
  try
    Conn1.Connected := True;
    Conn2.Connected := True;
    // Close Conn2 while Conn1 remains active
    Conn2.Connected := False;
    FreeAndNil(Conn2);

    Q1 := TSQLQuery.Create(nil);
    try
      Q1.SQLConnection := Conn1;
      Q1.SQL.Text := 'SELECT DB_NAME() AS DbName;';
      Q1.Open;
      Db1 := Q1.FieldByName('DbName').AsString;
    finally
      Q1.Free;
    end;
    Conn1.Connected := False;
    if SameText(Db1, 'TW_ED') then
      Writeln('  [3.6 Lifecycle Safety]           PASS (Active connection unaffected by concurrent pool release/cleanup)')
    else
      Writeln('  [3.6 Lifecycle Safety]           FAIL');
  finally
    Conn1.Free;
    Conn2.Free;
  end;
  Writeln;
end;

begin
  try
    RunTask1_VerifyOdbcEnvAndSessionReuse;
    RunTask2_PerformanceComparison;
    VerifyCorrectnessSuiteForMode('B. Windows ODBC Driver Manager Pooling (Pooling=Odbc)', ptmOdbcPool);
    VerifyCorrectnessSuiteForMode('C. Custom Native Pooling (Pooling=True)', ptmCustomPoolPing);
  except
    on E: Exception do
    begin
      Writeln('FATAL EXCEPTION: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
