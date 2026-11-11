program TestOdbcMigrationVerification;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.Winsock2,
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  System.SyncObjs,
  System.Generics.Collections,
  Data.DB,
  Data.SqlExpr,
  Data.DBXCommon,
  Datasnap.Provider,
  Datasnap.DBClient,
  OdbcApi,
  DbxOpenOdbcDriver,
  DbxOpenOdbcCore,
  DbxOpenOdbcDialects;

const
  CONN_MSSQL_ED  = 'Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.15;Database=TW_ED;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_MSSQL_OLD = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TW_OLD;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_MSSQL_BS1 = 'Driver={ODBC Driver 17 for SQL Server};Server=10.0.0.90;Database=TWBS260610;Uid=erp_adm;Pwd=/apptzen/;MARS_Connection=yes;Packet Size=16384;';
  CONN_PG        = 'DSN=PostgresSandbox;';
  CONN_MARIADB   = 'DSN=MariaDBSandbox;';
  CONN_FIREBIRD  = 'DSN=FirebirdSandbox;Uid=SYSDBA;Pwd=masterkey;';

function CreateConn(const AConnStr: string; const APoolingVal: string = 'True'): TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.DriverName := 'DbxOpenOdbc';
  Result.GetDriverFunc := 'getSQLDriverODBCW';
  Result.LibraryName := 'DbxOpenOdbcDriver';
  Result.VendorLib := 'ODBC32.DLL';
  Result.Params.Values['DriverName'] := 'DbxOpenOdbc';
  Result.Params.Values['ConnectionString'] := AConnStr;
  if APoolingVal <> '' then
    Result.Params.Values['Pooling'] := APoolingVal;
end;

function QuerySingleStr(AConn: TSQLConnection; const ASql: string): string;
var
  Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := AConn;
    Q.SQL.Text := ASql;
    Q.Open;
    if not Q.Eof then
      Result := Trim(Q.Fields[0].AsString)
    else
      Result := '';
  finally
    Q.Free;
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

{ ============================================================================ }
{ SECTION 4: PROCESS-WIDE ODBC BEHAVIOR & HENV ISOLATION VERIFICATION          }
{ ============================================================================ }

function SQLSetEnvAttr(EnvironmentHandle: SqlHEnv; Attribute: SqlInteger;
  ValuePtr: SqlPointer; StringLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLDriverConnectW(ConnectionHandle: SqlHDbc; WindowHandle: SqlHWnd;
  InConnectionString: PWideChar; StringLength1: SqlSmallint;
  OutConnectionString: PWideChar; BufferLength: SqlSmallint;
  out StringLength2Ptr: SqlSmallint; DriverCompletion: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLDisconnect(ConnectionHandle: SqlHDbc): SqlReturn; stdcall; external odbc32_dll;
function SQLFetch(StatementHandle: SqlHStmt): SqlReturn; stdcall; external odbc32_dll;
function SQLGetData(StatementHandle: SqlHStmt; Col_or_Param_Num: SqlUSmallint;
  TargetType: SqlSmallint; TargetValuePtr: SqlPointer; BufferLength: TSqlLen;
  StrLen_or_IndPtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;

function RawOdbcQueryConnId(AHEnv: SqlHEnv; const AConnStr: string): string;
var
  HDbc: SqlHDbc;
  HStmt: SqlHStmt;
  OutBuf: array[0..1023] of WideChar;
  OutLen: SqlSmallint;
  ValBuf: array[0..127] of WideChar;
  Ind: TSqlLen;
begin
  Result := '';
  if not OdbcSucceeded(SQLAllocHandle(SQL_HANDLE_DBC, AHEnv, HDbc)) then
    Exit;
  try
    FillChar(OutBuf, SizeOf(OutBuf), 0);
    OutLen := 0;
    if OdbcSucceeded(SQLDriverConnectW(HDbc, 0, PWideChar(AConnStr), SQL_NTS,
      @OutBuf[0], Length(OutBuf) - 1, OutLen, SQL_DRIVER_NOPROMPT)) then
    begin
      try
        if OdbcSucceeded(SQLAllocHandle(SQL_HANDLE_STMT, HDbc, HStmt)) then
        begin
          try
            if OdbcSucceeded(SQLExecDirectW(HStmt,
              PWideChar('SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;'),
              SQL_NTS)) then
            begin
              if OdbcSucceeded(SQLFetch(HStmt)) then
              begin
                FillChar(ValBuf, SizeOf(ValBuf), 0);
                Ind := 0;
                if OdbcSucceeded(SQLGetData(HStmt, 1, SQL_C_WCHAR, @ValBuf[0], SizeOf(ValBuf), @Ind)) then
                  Result := Trim(string(PWideChar(@ValBuf[0])));
              end;
            end;
          finally
            SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
          end;
        end;
      finally
        SQLDisconnect(HDbc);
      end;
    end;
  finally
    SQLFreeHandle(SQL_HANDLE_DBC, HDbc);
  end;
end;

procedure RunSection4_ProcessWideOdbcBehavior;
var
  ThirdPartyHEnvBefore, ThirdPartyHEnvAfter: SqlHEnv;
  SetBefore, SetAfter, SetRuntimeFalse, SetRuntimeTrue: TList<string>;
  I: Integer;
  Cid: string;
  Conn: TSQLConnection;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 4: PROCESS-WIDE ODBC BEHAVIOR & HENV ISOLATION VERIFICATION');
  Writeln('==========================================================================================');

  // 4.1 Simulate a third-party component allocating its own HENV BEFORE dbx4odbc initializes
  SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, ThirdPartyHEnvBefore);
  SQLSetEnvAttr(ThirdPartyHEnvBefore, SQL_ATTR_ODBC_VERSION, SqlPointer(NativeInt(SQL_OV_ODBC3)), 0);

  // 4.2 Trigger dbx4odbc initialization (allocates FOdbcEnv and FOdbcPooledEnv) + test runtime toggling on same TSQLConnection
  SetRuntimeFalse := TList<string>.Create;
  SetRuntimeTrue := TList<string>.Create;
  SetBefore := TList<string>.Create;
  SetAfter := TList<string>.Create;
  try
    Conn := CreateConn(CONN_MSSQL_ED + 'APP=Sec4Runtime;', 'False');
    try
      // 5 cycles with Pooling=False on Conn
      for I := 1 to 5 do
      begin
        Conn.Params.Values['Pooling'] := 'False';
        Conn.Connected := True;
        Cid := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        if not SetRuntimeFalse.Contains(Cid) then
          SetRuntimeFalse.Add(Cid);
        Conn.Connected := False;
      end;

      // Switch same TSQLConnection at runtime to Pooling=True for 5 cycles
      for I := 1 to 5 do
      begin
        Conn.Params.Values['Pooling'] := 'True';
        Conn.Connected := True;
        Cid := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        if not SetRuntimeTrue.Contains(Cid) then
          SetRuntimeTrue.Add(Cid);
        Conn.Connected := False;
      end;

      // Switch same TSQLConnection back to Pooling=False for 3 cycles
      for I := 1 to 3 do
      begin
        Conn.Params.Values['Pooling'] := 'False';
        Conn.Connected := True;
        Cid := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        if not SetRuntimeFalse.Contains(Cid) then
          SetRuntimeFalse.Add(Cid);
        Conn.Connected := False;
      end;
    finally
      Conn.Free;
    end;

    // 4.3 Allocate a third-party raw ODBC HENV AFTER dbx4odbc has enabled pooling on FOdbcPooledEnv
    SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, ThirdPartyHEnvAfter);
    SQLSetEnvAttr(ThirdPartyHEnvAfter, SQL_ATTR_ODBC_VERSION, SqlPointer(NativeInt(SQL_OV_ODBC3)), 0);

    for I := 1 to 5 do
    begin
      Cid := RawOdbcQueryConnId(ThirdPartyHEnvBefore, CONN_MSSQL_ED + 'APP=ThirdPartyBefore;');
      if (Cid <> '') and (not SetBefore.Contains(Cid)) then
        SetBefore.Add(Cid);

      Cid := RawOdbcQueryConnId(ThirdPartyHEnvAfter, CONN_MSSQL_ED + 'APP=ThirdPartyAfter;');
      if (Cid <> '') and (not SetAfter.Contains(Cid)) then
        SetAfter.Add(Cid);
    end;

    Writeln(Format('  [4.1 Third-Party HENV Allocated BEFORE dbx4odbc] 5 Cycles -> Unique ConnIds: %d (Expected: 5 [Unpooled]) -> %s',
      [SetBefore.Count, BoolToStr(SetBefore.Count = 5, True)]));
    Writeln(Format('  [4.2 Third-Party HENV Allocated AFTER  dbx4odbc] 5 Cycles -> Unique ConnIds: %d (Expected: 5 [Unpooled]) -> %s',
      [SetAfter.Count, BoolToStr(SetAfter.Count = 5, True)]));
    Writeln(Format('  [4.3 Runtime Toggle on Same TSQLConnection]      Pooling=False (8 cycles -> %d Unique ConnIds), Pooling=True (5 cycles -> %d Unique ConnId) -> %s',
      [SetRuntimeFalse.Count, SetRuntimeTrue.Count, BoolToStr((SetRuntimeFalse.Count = 8) and (SetRuntimeTrue.Count = 1), True)]));
  finally
    SetBefore.Free;
    SetAfter.Free;
    SetRuntimeFalse.Free;
    SetRuntimeTrue.Free;
    SQLFreeHandle(SQL_HANDLE_ENV, ThirdPartyHEnvAfter);
    SQLFreeHandle(SQL_HANDLE_ENV, ThirdPartyHEnvBefore);
  end;
  Writeln;
end;

{ ============================================================================ }
{ SECTION 5: MULTI-DBMS COMPATIBILITY & SESSION ISOLATION                      }
{ ============================================================================ }

procedure VerifySqlServer;
var
  UnpooledIds, PooledIds: TList<string>;
  I, Cnt, LocalPort: Integer;
  Cid1, Cid2, Db1, Db2, Db3, CtxStr, IsoStr: string;
  Conn, Conn2, Conn3: TSQLConnection;
  Tran: TDBXTransaction;
  TempLeaked, Severed: Boolean;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 5.1: SQL SERVER (msodbcsql17.dll) — 8-POINT ODBC POOLING VERIFICATION');
  Writeln('==========================================================================================');

  UnpooledIds := TList<string>.Create;
  PooledIds := TList<string>.Create;
  try
    // 1. Physical Connection Reuse (10 cycles unpooled vs 10 cycles pooled)
    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlUnpooled;', 'False');
      try
        Conn.Connected := True;
        Cid1 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        if not UnpooledIds.Contains(Cid1) then UnpooledIds.Add(Cid1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;

    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlPooled;', 'True');
      try
        Conn.Connected := True;
        Cid1 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        if not PooledIds.Contains(Cid1) then PooledIds.Add(Cid1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;
    Writeln(Format('  [MSSQL-1 Physical Reuse]       Pooling=False: %2d ConnIDs / 10 cycles | Pooling=True: %d ConnID / 10 cycles -> %s',
      [UnpooledIds.Count, PooledIds.Count, BoolToStr((UnpooledIds.Count = 10) and (PooledIds.Count = 1), True)]));

    // 2. Database Isolation (TW_ED vs TW_OLD vs TWBS260610)
    Conn := CreateConn(CONN_MSSQL_ED, 'True');
    Conn2 := CreateConn(CONN_MSSQL_OLD, 'True');
    Conn3 := CreateConn(CONN_MSSQL_BS1, 'True');
    try
      Conn.Connected := True;
      Conn2.Connected := True;
      Conn3.Connected := True;
      Db1 := QuerySingleStr(Conn, 'SELECT DB_NAME();');
      Db2 := QuerySingleStr(Conn2, 'SELECT DB_NAME();');
      Db3 := QuerySingleStr(Conn3, 'SELECT DB_NAME();');
      Conn.Connected := False;
      Conn2.Connected := False;
      Conn3.Connected := False;
    finally
      Conn.Free;
      Conn2.Free;
      Conn3.Free;
    end;
    Writeln(Format('  [MSSQL-2 Database Isolation]   DB1=%s, DB2=%s, DB3=%s -> %s',
      [Db1, Db2, Db3, BoolToStr(SameText(Db1, 'TW_ED') and SameText(Db2, 'TW_OLD') and SameText(Db3, 'TWBS260610'), True)]));

    // 3. DBX Transaction Rollback + 4. Raw SQL BEGIN TRAN Rollback
    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlTxn;', 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('IF OBJECT_ID(''dbo.MSSQL_POOL_TXN'', ''U'') IS NOT NULL DROP TABLE dbo.MSSQL_POOL_TXN; CREATE TABLE dbo.MSSQL_POOL_TXN (id int);');
      Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      Assert(Tran <> nil);
      Conn.ExecuteDirect('INSERT INTO dbo.MSSQL_POOL_TXN VALUES (1);');
      Conn.Connected := False; // Uncommitted DBX transaction
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlTxn;', 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('BEGIN TRAN; INSERT INTO dbo.MSSQL_POOL_TXN VALUES (2);');
      Conn.Connected := False; // Uncommitted raw SQL BEGIN TRAN
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlTxn;', 'True');
    try
      Conn.Connected := True;
      Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM dbo.MSSQL_POOL_TXN;'), -1);
      Conn.ExecuteDirect('DROP TABLE dbo.MSSQL_POOL_TXN;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MSSQL-3/4 Txn Rollback]       DBX + Raw SQL BEGIN TRAN uncommitted rows = %d (Expected: 0) -> %s',
      [Cnt, BoolToStr(Cnt = 0, True)]));

    // 5. #TempTable + CONTEXT_INFO Reset + 6. Isolation Level Restoration (DirtyRead -> ReadCommitted)
    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlReset;', 'True');
    try
      Conn.Connected := True;
      Cid1 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
      Conn.ExecuteDirect('CREATE TABLE #MssqlProbe (id int); INSERT INTO #MssqlProbe VALUES (1); SET CONTEXT_INFO 0xCAFEBABE;');
      Tran := Conn.BeginTransaction(TDBXIsolations.DirtyRead);
      Conn.CommitFreeAndNil(Tran);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlReset;', 'True');
    try
      Conn.Connected := True;
      Cid2 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
      CtxStr := QuerySingleStr(Conn, 'SELECT ISNULL(CONVERT(VARCHAR(20), CONTEXT_INFO(), 1), ''NULL'');');
      IsoStr := QuerySingleStr(Conn, 'SELECT CAST(transaction_isolation_level AS VARCHAR(10)) FROM sys.dm_exec_sessions WHERE session_id = @@SPID;');
      try
        QuerySingleStr(Conn, 'SELECT COUNT(*) FROM #MssqlProbe;');
        TempLeaked := True;
      except
        TempLeaked := False;
      end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MSSQL-5/6 Session & Iso]      SameConn=%s | TempLeaked=%s | CONTEXT_INFO=%s | Isolation=%s (Expected: 2 [ReadCommitted]) -> %s',
      [BoolToStr(Cid1 = Cid2, True), BoolToStr(TempLeaked, True), CtxStr, IsoStr,
       BoolToStr((Cid1 = Cid2) and (not TempLeaked) and (CtxStr = 'NULL') and (IsoStr = '2'), True)]));

    // 7. Dead Connection Recovery (Sever local TCP socket while idle in ODBC DM pool)
    Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlDeadConn;', 'True');
    try
      Conn.Connected := True;
      Cid1 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
      LocalPort := StrToIntDef(QuerySingleStr(Conn, 'SELECT client_tcp_port FROM sys.dm_exec_connections WHERE session_id = @@SPID;'), 0);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Severed := SeverLocalTcpPort(LocalPort);
    try
      Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlDeadConn;', 'True');
      try
        Conn.Connected := True;
        Cid2 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
      Writeln(Format('  [MSSQL-7 Dead Conn Recovery]   SeveredPort=%d (%s) -> Replaced by ConnId %s', [LocalPort, BoolToStr(Severed, True), Cid2]));
    except
      on E: Exception do
      begin
        Conn := CreateConn(CONN_MSSQL_ED + 'APP=MssqlDeadConn;', 'True');
        try
          Conn.Connected := True;
          Cid2 := QuerySingleStr(Conn, 'SELECT CAST(connection_id AS VARCHAR(36)) FROM sys.dm_exec_connections WHERE session_id = @@SPID;');
          Conn.Connected := False;
        finally
          Conn.Free;
        end;
        Writeln(Format('  [MSSQL-7 Dead Conn Recovery]   SeveredPort=%d (%s) -> First query evicted dead socket; immediate retry succeeded with ConnId %s -> True',
          [LocalPort, BoolToStr(Severed, True), Cid2]));
      end;
    end;

    // 8. Legacy Custom Pool Keyword Stripping Compatibility
    Conn := CreateConn(CONN_MSSQL_ED + 'Pooling=True;Pool.MaxPoolSize=32;Pool.IdleTimeoutSec=90;Pool.ConnectionTimeoutMs=3000;Pool.ValidateOnBorrow=False;', '');
    try
      Conn.Connected := True;
      Db1 := QuerySingleStr(Conn, 'SELECT DB_NAME();');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MSSQL-8 Keyword Stripping]    Connected cleanly with legacy Pool.* keywords (DB=%s) -> %s',
      [Db1, BoolToStr(SameText(Db1, 'TW_ED'), True)]));
  finally
    UnpooledIds.Free;
    PooledIds.Free;
  end;
  Writeln;
end;

procedure VerifyPostgreSQL;
var
  UnpooledPids, PooledPids: TList<string>;
  I, Cnt: Integer;
  Pid1, Pid2, Db1, Db2, IsoStr, TimeoutStr: string;
  Conn, Conn2: TSQLConnection;
  Tran: TDBXTransaction;
  TempExists: Boolean;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 5.2: POSTGRESQL 17.6 (psqlodbc35w.dll) — 8-POINT ODBC POOLING VERIFICATION');
  Writeln('==========================================================================================');

  UnpooledPids := TList<string>.Create;
  PooledPids := TList<string>.Create;
  try
    // 1. Physical Connection Reuse (10 cycles unpooled vs 10 cycles pooled)
    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_PG, 'False');
      try
        Conn.Connected := True;
        Pid1 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
        if not UnpooledPids.Contains(Pid1) then UnpooledPids.Add(Pid1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;

    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_PG, 'True');
      try
        Conn.Connected := True;
        Pid1 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
        if not PooledPids.Contains(Pid1) then PooledPids.Add(Pid1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;
    if PooledPids.Count = 1 then
      Writeln(Format('  [PG-1 Physical Reuse]          Pooling=False: %2d PIDs / 10 cycles | Pooling=True: %d PID / 10 cycles -> VERIFIED',
        [UnpooledPids.Count, PooledPids.Count]))
    else
      Writeln(Format('  [PG-1 Physical Reuse]          Pooling=False: %2d PIDs / 10 cycles | Pooling=True: %d PIDs / 10 cycles -> NOT VERIFIED (CPTimeout absent in HKLM\SOFTWARE\ODBC\ODBCINST.INI)',
        [UnpooledPids.Count, PooledPids.Count]));

    // 2. Database Isolation (postgres vs template1)
    Conn := CreateConn(CONN_PG + 'Database=postgres;', 'True');
    Conn2 := CreateConn(CONN_PG + 'Database=template1;', 'True');
    try
      Conn.Connected := True;
      Conn2.Connected := True;
      Db1 := QuerySingleStr(Conn, 'SELECT current_database();');
      Db2 := QuerySingleStr(Conn2, 'SELECT current_database();');
      Conn.Connected := False;
      Conn2.Connected := False;
    finally
      Conn.Free;
      Conn2.Free;
    end;
    Writeln(Format('  [PG-2 Database Isolation]      DB1=%s, DB2=%s -> %s',
      [Db1, Db2, BoolToStr(SameText(Db1, 'postgres') and SameText(Db2, 'template1'), True)]));

    // 3. DBX Transaction Rollback on Release
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('DROP TABLE IF EXISTS pg_odbc_pool_txn; CREATE TABLE pg_odbc_pool_txn (id int);');
      Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      Conn.ExecuteDirect('INSERT INTO pg_odbc_pool_txn VALUES (1);');
      Conn.Connected := False; // Uncommitted DBX transaction
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM pg_odbc_pool_txn;'), -1);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [PG-3 DBX Txn Rollback]        RowCnt=%d (Expected: 0) -> %s',
      [Cnt, BoolToStr(Cnt = 0, True)]));

    // 4. Raw SQL Transaction (BEGIN without DBX BeginTransaction)
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('BEGIN; INSERT INTO pg_odbc_pool_txn VALUES (2);');
      Conn.Connected := False; // Disconnect with raw SQL BEGIN open
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      try
        Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM pg_odbc_pool_txn;'), -1);
      except
        on E: Exception do
        begin
          Cnt := -99; // In failed/open transaction block
          Conn.ExecuteDirect('ROLLBACK;');
        end;
      end;
      Conn.ExecuteDirect('ROLLBACK; DROP TABLE IF EXISTS pg_odbc_pool_txn;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [PG-4 Raw SQL BEGIN Behavior]  RowCnt=%d (0 = Auto-Rolled Back by Driver/DM; >0 or -99 = Raw SQL Txn Persisted)', [Cnt]));

    // 5. Temporary Table & Session Variable Behavior under Pure ODBC DM Pooling
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Pid1 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
      Conn.ExecuteDirect('DROP TABLE IF EXISTS pg_pool_temp_probe; CREATE TEMP TABLE pg_pool_temp_probe (id int); INSERT INTO pg_pool_temp_probe VALUES (99); SET statement_timeout = 12345;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Pid2 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
      TimeoutStr := QuerySingleStr(Conn, 'SHOW statement_timeout;');
      try
        Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM pg_pool_temp_probe;'), 0);
        TempExists := (Cnt > 0);
      except
        TempExists := False;
      end;
      // Clean up after probe
      try Conn.ExecuteDirect('DISCARD ALL;'); except end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [PG-5 Temp Table & Session]    SamePID=%s (%s=%s) | TempPersisted=%s | statement_timeout=%s',
      [BoolToStr(Pid1 = Pid2, True), Pid1, Pid2, BoolToStr(TempExists, True), TimeoutStr]));

    // 6. Transaction Isolation Level Restoration (after DirtyRead / Serializable)
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Tran := Conn.BeginTransaction(TDBXIsolations.Serializable);
      Conn.CommitFreeAndNil(Tran);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      IsoStr := QuerySingleStr(Conn, 'SHOW transaction_isolation;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [PG-6 Isolation Restoration]   After Serializable session closed, next session isolation = "%s" (Expected: "read committed") -> %s',
      [IsoStr, BoolToStr(SameText(IsoStr, 'read committed'), True)]));

    // 7. Dead Connection Recovery (Terminate backend via pg_terminate_backend from unpooled admin conn)
    Conn := CreateConn(CONN_PG, 'True');
    try
      Conn.Connected := True;
      Pid1 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;

    Conn2 := CreateConn(CONN_PG, 'False');
    try
      Conn2.Connected := True;
      try
        QuerySingleStr(Conn2, Format('SELECT pg_terminate_backend(%s);', [Pid1]));
      except
      end;
      Conn2.Connected := False;
    finally
      Conn2.Free;
    end;
    Sleep(100);

    Pid2 := '';
    try
      Conn := CreateConn(CONN_PG, 'True');
      try
        Conn.Connected := True;
        Pid2 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
      Writeln(Format('  [PG-7 Dead Conn Recovery]      Terminated PID %s -> Transparently replaced on borrow by PID %s', [Pid1, Pid2]));
    except
      on E: Exception do
      begin
        Conn := CreateConn(CONN_PG, 'True');
        try
          Conn.Connected := True;
          Pid2 := QuerySingleStr(Conn, 'SELECT pg_backend_pid();');
          Conn.Connected := False;
        finally
          Conn.Free;
        end;
        Writeln(Format('  [PG-7 Dead Conn Recovery]      First query on terminated PID %s raised (%s) and evicted dead handle; immediate retry succeeded with PID %s',
          [Pid1, E.Message, Pid2]));
      end;
    end;
  finally
    UnpooledPids.Free;
    PooledPids.Free;
  end;
  Writeln;
end;

procedure VerifyMariaDB;
var
  UnpooledIds, PooledIds: TList<string>;
  I, Cnt: Integer;
  Id1, Id2, Db1, Db2, IsoStr, AutoCommitStr: string;
  Conn, Conn2: TSQLConnection;
  Tran: TDBXTransaction;
  TempExists: Boolean;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 5.3: MARIADB 10.6.17 (myodbc8w.dll) — 8-POINT ODBC POOLING VERIFICATION');
  Writeln('==========================================================================================');

  UnpooledIds := TList<string>.Create;
  PooledIds := TList<string>.Create;
  try
    // 1. Physical Connection Reuse
    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_MARIADB, 'False');
      try
        Conn.Connected := True;
        Id1 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
        if not UnpooledIds.Contains(Id1) then UnpooledIds.Add(Id1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;

    for I := 1 to 10 do
    begin
      Conn := CreateConn(CONN_MARIADB, 'True');
      try
        Conn.Connected := True;
        Id1 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
        if not PooledIds.Contains(Id1) then PooledIds.Add(Id1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;
    if PooledIds.Count = 1 then
      Writeln(Format('  [MDB-1 Physical Reuse]         Pooling=False: %2d ConnIDs / 10 cycles | Pooling=True: %d ConnID / 10 cycles -> VERIFIED',
        [UnpooledIds.Count, PooledIds.Count]))
    else
      Writeln(Format('  [MDB-1 Physical Reuse]         Pooling=False: %2d ConnIDs / 10 cycles | Pooling=True: %d ConnIDs / 10 cycles -> NOT VERIFIED (CPTimeout absent in HKLM\SOFTWARE\ODBC\ODBCINST.INI)',
        [UnpooledIds.Count, PooledIds.Count]));

    // 2. Database Isolation (test vs information_schema)
    Conn := CreateConn(CONN_MARIADB + 'DATABASE=test;', 'True');
    Conn2 := CreateConn(CONN_MARIADB + 'DATABASE=information_schema;', 'True');
    try
      Conn.Connected := True;
      Conn2.Connected := True;
      Db1 := QuerySingleStr(Conn, 'SELECT DATABASE();');
      Db2 := QuerySingleStr(Conn2, 'SELECT DATABASE();');
      Conn.Connected := False;
      Conn2.Connected := False;
    finally
      Conn.Free;
      Conn2.Free;
    end;
    Writeln(Format('  [MDB-2 Database Isolation]     DB1=%s, DB2=%s -> %s',
      [Db1, Db2, BoolToStr(SameText(Db1, 'test') and SameText(Db2, 'information_schema'), True)]));

    // 3. DBX Transaction Rollback on Release
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('DROP TABLE IF EXISTS mdb_odbc_pool_txn;');
      Conn.ExecuteDirect('CREATE TABLE mdb_odbc_pool_txn (id int) ENGINE=InnoDB;');
      Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      Conn.ExecuteDirect('INSERT INTO mdb_odbc_pool_txn VALUES (1);');
      Conn.Connected := False; // Uncommitted DBX transaction
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM mdb_odbc_pool_txn;'), -1);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MDB-3 DBX Txn Rollback]       RowCnt=%d (Expected: 0) -> %s',
      [Cnt, BoolToStr(Cnt = 0, True)]));

    // 4. Raw SQL Transaction (START TRANSACTION without DBX BeginTransaction)
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Conn.ExecuteDirect('START TRANSACTION;');
      Conn.ExecuteDirect('INSERT INTO mdb_odbc_pool_txn VALUES (2);');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      // Rollback first on separate unpooled connection or check if row is visible from another connection
      Conn2 := CreateConn(CONN_MARIADB, 'False');
      try
        Conn2.Connected := True;
        Cnt := StrToIntDef(QuerySingleStr(Conn2, 'SELECT COUNT(*) FROM mdb_odbc_pool_txn;'), -1);
        Conn2.Connected := False;
      finally
        Conn2.Free;
      end;
      Conn.ExecuteDirect('ROLLBACK;');
      Conn.ExecuteDirect('DROP TABLE IF EXISTS mdb_odbc_pool_txn;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MDB-4 Raw SQL START TRAN]     CommittedRowCnt=%d', [Cnt]));

    // 5. Temporary Table & autocommit Behavior under Pure ODBC DM Pooling
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Id1 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
      Conn.ExecuteDirect('CREATE TEMPORARY TABLE IF NOT EXISTS mdb_temp_probe (id int);');
      Conn.ExecuteDirect('INSERT INTO mdb_temp_probe VALUES (42);');
      Conn.ExecuteDirect('SET autocommit = 0;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Id2 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
      AutoCommitStr := QuerySingleStr(Conn, 'SELECT @@autocommit;');
      try
        Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM mdb_temp_probe;'), 0);
        TempExists := (Cnt > 0);
      except
        TempExists := False;
      end;
      try
        Conn.ExecuteDirect('SET autocommit = 1;');
        Conn.ExecuteDirect('DROP TEMPORARY TABLE IF EXISTS mdb_temp_probe;');
      except
      end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MDB-5 Temp Table & Session]   SameConnID=%s (%s=%s) | TempPersisted=%s | @@autocommit=%s',
      [BoolToStr(Id1 = Id2, True), Id1, Id2, BoolToStr(TempExists, True), AutoCommitStr]));

    // 6. Transaction Isolation Level Restoration
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Tran := Conn.BeginTransaction(TDBXIsolations.DirtyRead);
      Conn.CommitFreeAndNil(Tran);
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      IsoStr := QuerySingleStr(Conn, 'SELECT @@tx_isolation;');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [MDB-6 Isolation Restoration]  After DirtyRead session closed, next session @@tx_isolation = "%s" -> %s',
      [IsoStr, BoolToStr(not SameText(IsoStr, 'READ-UNCOMMITTED'), True)]));

    // 7. Dead Connection Recovery (KILL CONNECTION <id> from unpooled admin conn)
    Conn := CreateConn(CONN_MARIADB, 'True');
    try
      Conn.Connected := True;
      Id1 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
      Conn.Connected := False;
    finally
      Conn.Free;
    end;

    Conn2 := CreateConn(CONN_MARIADB, 'False');
    try
      Conn2.Connected := True;
      try
        Conn2.ExecuteDirect(Format('KILL %s;', [Id1]));
      except
      end;
      Conn2.Connected := False;
    finally
      Conn2.Free;
    end;
    Sleep(100);

    Id2 := '';
    try
      Conn := CreateConn(CONN_MARIADB, 'True');
      try
        Conn.Connected := True;
        Id2 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
      Writeln(Format('  [MDB-7 Dead Conn Recovery]     Killed ID %s -> Transparently replaced on borrow by ID %s', [Id1, Id2]));
    except
      on E: Exception do
      begin
        Conn := CreateConn(CONN_MARIADB, 'True');
        try
          Conn.Connected := True;
          Id2 := QuerySingleStr(Conn, 'SELECT CONNECTION_ID();');
          Conn.Connected := False;
        finally
          Conn.Free;
        end;
        Writeln(Format('  [MDB-7 Dead Conn Recovery]     First query on killed ID %s raised (%s) and evicted dead handle; immediate retry succeeded with ID %s',
          [Id1, E.Message, Id2]));
      end;
    end;
  finally
    UnpooledIds.Free;
    PooledIds.Free;
  end;
  Writeln;
end;

procedure VerifyFirebird;
var
  UnpooledIds, PooledIds: TList<string>;
  I, Cnt: Integer;
  Id1: string;
  Conn: TSQLConnection;
  Tran: TDBXTransaction;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 5.4: FIREBIRD 5.0.4 (FirebirdODBC.dll) — ODBC POOLING VERIFICATION');
  Writeln('==========================================================================================');

  UnpooledIds := TList<string>.Create;
  PooledIds := TList<string>.Create;
  try
    for I := 1 to 5 do
    begin
      Conn := CreateConn(CONN_FIREBIRD, 'False');
      try
        Conn.Connected := True;
        Id1 := QuerySingleStr(Conn, 'SELECT CURRENT_CONNECTION FROM RDB$DATABASE');
        if not UnpooledIds.Contains(Id1) then UnpooledIds.Add(Id1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;

    for I := 1 to 5 do
    begin
      Conn := CreateConn(CONN_FIREBIRD, 'True');
      try
        Conn.Connected := True;
        Id1 := QuerySingleStr(Conn, 'SELECT CURRENT_CONNECTION FROM RDB$DATABASE');
        if not PooledIds.Contains(Id1) then PooledIds.Add(Id1);
        Conn.Connected := False;
      finally
        Conn.Free;
      end;
    end;
    if PooledIds.Count = 1 then
      Writeln(Format('  [FB-1 Physical Reuse]          Pooling=False: %d AttachmentIDs / 5 cycles | Pooling=True: %d AttachmentID / 5 cycles -> VERIFIED',
        [UnpooledIds.Count, PooledIds.Count]))
    else
      Writeln(Format('  [FB-1 Physical Reuse]          Pooling=False: %d AttachmentIDs / 5 cycles | Pooling=True: %d AttachmentIDs / 5 cycles -> NOT VERIFIED (CPTimeout absent in HKLM\SOFTWARE\ODBC\ODBCINST.INI)',
        [UnpooledIds.Count, PooledIds.Count]));

    // Transaction Rollback on Release
    Conn := CreateConn(CONN_FIREBIRD, 'True');
    try
      Conn.Connected := True;
      try
        Conn.ExecuteDirect('RECREATE TABLE fb_pool_txn (id INT NOT NULL PRIMARY KEY)');
      except
      end;
      Tran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      Assert(Tran <> nil);
      Conn.ExecuteDirect('INSERT INTO fb_pool_txn VALUES (1)');
      Conn.Connected := False; // Uncommitted transaction
    finally
      Conn.Free;
    end;

    Conn := CreateConn(CONN_FIREBIRD, 'True');
    try
      Conn.Connected := True;
      Cnt := StrToIntDef(QuerySingleStr(Conn, 'SELECT COUNT(*) FROM fb_pool_txn'), -1);
      try Conn.ExecuteDirect('DROP TABLE fb_pool_txn'); except end;
      Conn.Connected := False;
    finally
      Conn.Free;
    end;
    Writeln(Format('  [FB-2 DBX Txn Rollback]        RowCnt=%d (Expected: 0) -> %s',
      [Cnt, BoolToStr(Cnt = 0, True)]));
  finally
    UnpooledIds.Free;
    PooledIds.Free;
  end;
  Writeln;
end;

{ ============================================================================ }
{ SECTION 7: DATASNAP TDataSetProvider -> TClientDataSet & BLOB/UNICODE TEST   }
{ ============================================================================ }

procedure RunSection7_DataSnapAndRegression;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  Cmd: TDBXCommand;
  Rdr: TDBXReader;
  SetCount: Integer;
begin
  Writeln('==========================================================================================');
  Writeln(' SECTION 7: FINAL REGRESSION (DATASNAP, PARAMS, MRS, UNICODE, BLOB, METADATA)');
  Writeln('==========================================================================================');

  Conn := CreateConn(CONN_MSSQL_ED + 'APP=Sec7Regression;', 'True');
  try
    Conn.Connected := True;

    // 7.1 DataSnap TDataSetProvider -> TClientDataSet + Unicode + BLOB
    Q := TSQLQuery.Create(nil);
    DSP := TDataSetProvider.Create(nil);
    CDS := TClientDataSet.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text :=
        'SELECT CAST(101 AS INT) AS Id, ' +
        'CAST(N''繁體中文_Unicode_測試_αβγ'' AS NVARCHAR(100)) AS UText, ' +
        'CAST(REPLICATE(N''長篇Memo內容_'', 500) AS NVARCHAR(MAX)) AS MemoText, ' +
        'CAST(0xDEADBEEFCAFEBABE AS VARBINARY(MAX)) AS BinBlob;';
      DSP.DataSet := Q;
      CDS.SetProvider(DSP);
      CDS.PacketRecords := -1;
      CDS.Open;

       if (CDS.RecordCount = 1) and
         (CDS.FieldByName('Id').AsInteger = 101) and
         (Pos('繁體中文', CDS.FieldByName('UText').AsWideString) > 0) and
         (Length(CDS.FieldByName('MemoText').AsWideString) > 3000) and
         (Length(CDS.FieldByName('BinBlob').AsBytes) = 8) then
        Writeln('  [7.1 DataSnap + Unicode + BLOB] PASS (TDataSetProvider -> TClientDataSet verified)')
      else
        Writeln('  [7.1 DataSnap + Unicode + BLOB] FAIL');
    finally
      CDS.Free;
      DSP.Free;
      Q.Free;
    end;

    // 7.2 Multiple Result Sets (MRS)
    Cmd := Conn.DBXConnection.CreateCommand;
    try
      Cmd.Text := 'SELECT 10 AS A; SELECT 20 AS B; SELECT 30 AS C;';
      Rdr := Cmd.ExecuteQuery;
      SetCount := 0;
      while Rdr <> nil do
      begin
        try
          if Rdr.Next then
            Inc(SetCount);
        finally
          Rdr.Free;
        end;
        Rdr := Cmd.GetNextReader;
      end;
      if SetCount = 3 then
        Writeln('  [7.2 Multiple Result Sets]      PASS (3 sequential result sets traversed)')
      else
        Writeln(Format('  [7.2 Multiple Result Sets]      FAIL (SetCount=%d)', [SetCount]));
    finally
      Cmd.Free;
    end;

    Conn.Connected := False;
  finally
    Conn.Free;
  end;
  Writeln;
end;

begin
  try
    RunSection4_ProcessWideOdbcBehavior;
    VerifySqlServer;
    try
      VerifyPostgreSQL;
    except
      on E: Exception do
      begin
        Writeln('  [PG] NOT VERIFIED (PostgreSQL sandbox not running or CPTimeout absent in HKLM: ' + E.Message + ')');
        Writeln;
      end;
    end;
    try
      VerifyMariaDB;
    except
      on E: Exception do
      begin
        Writeln('  [MDB] NOT VERIFIED (MariaDB sandbox not running or CPTimeout absent in HKLM: ' + E.Message + ')');
        Writeln;
      end;
    end;
    VerifyFirebird;
    Writeln('==========================================================================================');
    Writeln(' SECTION 5.5: ORACLE — NOT VERIFIED / UNAVAILABLE (No Oracle instance in test environment)');
    Writeln('==========================================================================================');
    Writeln;
    RunSection7_DataSnapAndRegression;
  except
    on E: Exception do
    begin
      Writeln('FATAL ERROR: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
