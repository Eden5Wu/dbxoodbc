program RuntimeRegressionTester;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, Data.DB, Data.DBXCommon, Data.SqlExpr,
  Data.SqlTimSt, Data.FmtBcd, Data.DBXPlatform,
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas';

procedure Check(OK: Boolean; const Msg: string);
begin
  if not OK then raise Exception.Create(Msg);
end;

procedure AddParam(C: TDBXCommand; Kind: TDBXType; Direction: Integer;
  Size: Integer = 0);
var P: TDBXParameter;
begin
  P := C.CreateParameter;
  P.Name := 'P' + IntToStr(C.Parameters.Count);
  P.DataType := Kind;
  P.ParameterDirection := Direction;
  P.Size := Size;
  C.Parameters.AddParameter(P);
end;

procedure Exec(C: TDBXConnection; const SQL: string);
var Cmd: TDBXCommand;
begin
  Cmd := C.CreateCommand;
  try Cmd.Text := SQL; Cmd.ExecuteUpdate; finally Cmd.Free; end;
end;

procedure TestParameters(C: TDBXConnection);
var Cmd: TDBXCommand; R: TDBXReader; TS, Actual: TSQLTimeStamp;
  Day: TDBXDate; Clock: TDBXTime; B: TBcd; TSO: TSQLTimeStampOffset; S: string;
begin
  Day := DateTimeToTimeStamp(EncodeDate(2026,11,4)).Date;
  Clock := 12*3600000+34*60000+56*1000+789;
  TS := DateTimeToSQLTimeStamp(EncodeDate(2026,11,4)+EncodeTime(12,34,56,789));
  B := StrToBcd('1234.5678', TFormatSettings.Invariant);
  Cmd := C.CreateCommand;
  try
    Cmd.Text := 'SELECT CAST(? AS date), CAST(? AS time(3)), CAST(? AS datetime2(3)), ' +
      'CAST(? AS decimal(18,4)), CAST(? AS nvarchar(100)), CAST(? AS int), ' +
      'CONVERT(nvarchar(50),CAST(? AS datetimeoffset(3)),121)';
    AddParam(Cmd,TDBXDataTypes.DateType,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.TimeType,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.TimeStampType,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.BcdType,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.WideStringType,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.Int32Type,TDBXParameterDirections.InParameter);
    AddParam(Cmd,TDBXDataTypes.TimeStampOffsetType,TDBXParameterDirections.InParameter);
    Cmd.Parameters[0].Value.SetDate(Day);
    Cmd.Parameters[1].Value.SetTime(Clock);
    Cmd.Parameters[2].Value.SetTimeStamp(TS);
    Cmd.Parameters[3].Value.SetBcd(B);
    Cmd.Parameters[4].Value.SetWideString('');
    Cmd.Parameters[5].Value.SetNull;
    TSO := DateTimeToSQLTimeStampOffset(EncodeDate(2026,11,4)+EncodeTime(12,34,56,789),-3,-30);
    Cmd.Parameters[6].Value.SetTimeStampOffset(TSO);
    R := Cmd.ExecuteQuery;
    try
      Check((R<>nil) and R.Next,'Missing parameter row');
      Check(R.Value[0].GetDate=Day,'Date parameter changed');
      Check(R.Value[1].GetTime=Clock,'Time parameter lost milliseconds');
      Actual := R.Value[2].GetTimeStamp;
      Check((Actual.Year=2026) and (Actual.Month=11) and (Actual.Day=4) and
        (Actual.Hour=12) and (Actual.Minute=34) and (Actual.Second=56) and
        (Actual.Fractions=789),'Timestamp parameter changed');
      Check(BcdCompare(R.Value[3].GetBcd,B)=0,'BCD parameter changed');
      Check(not R.Value[4].IsNull and (R.Value[4].AsString=''),'Empty string became NULL');
      Check(R.Value[5].IsNull,'NULL parameter changed');
      S := R.Value[6].AsString;
      Check((Pos('.789',S)>0) and S.EndsWith('-03:30'),Format('Timestamp offset changed: %s (input fractions=%d zone=%d:%d)',
        [S,TSO.Fractions,TSO.TimeZoneHour,TSO.TimeZoneMinute]));
    finally R.Free; end;
  finally Cmd.Free; end;
  Writeln('[PASS] Date, time, timestamp milliseconds, BCD, empty string and NULL inputs');
end;

procedure TestOutputReaders(C: TDBXConnection);
var Cmd: TDBXCommand; R: TDBXReader; Offset: TSQLTimeStampOffset;
begin
  Exec(C,'CREATE PROCEDURE #DbxRuntimeReaders @v int OUTPUT, @o datetimeoffset(3) OUTPUT AS ' +
    'SET NOCOUNT ON; SELECT 7 AS value; SELECT 8 AS value; SET @v=9; ' +
    'SET @o=CAST(''2026-11-04T12:34:56.789-03:30'' AS datetimeoffset(3));');
  Cmd := C.CreateCommand;
  try
    Cmd.Text := '{call #DbxRuntimeReaders(?,?)}';
    AddParam(Cmd,TDBXDataTypes.Int32Type,TDBXParameterDirections.OutParameter);
    AddParam(Cmd,TDBXDataTypes.TimeStampOffsetType,TDBXParameterDirections.OutParameter,64);
    R := Cmd.ExecuteQuery;
    try
      Check((R<>nil) and R.Next and (R.Value[0].AsInt32=7),'First output result missing');
      Check(not R.Next,'Unexpected first result row');
    finally R.Free; end;
    R := Cmd.GetNextReader;
    try
      Check((R<>nil) and R.Next and (R.Value[0].AsInt32=8),'Second output result missing');
      Check(not R.Next,'Unexpected second result row');
    finally R.Free; end;
    R := Cmd.GetNextReader;
    try Check(R=nil,'Unexpected third result'); finally R.Free; end;
    Check(Cmd.Parameters[0].Value.AsInt32=9,'Output after readers missing');
    Offset := Cmd.Parameters[1].Value.GetTimeStampOffset;
    Check((Offset.Year=2026) and (Offset.Fractions=789) and
      (Offset.TimeZoneHour=-3) and (Abs(Offset.TimeZoneMinute)=30),'Timestamp offset output changed');
  finally Cmd.Free; Exec(C,'DROP PROCEDURE #DbxRuntimeReaders'); end;
  Writeln('[PASS] Output after result readers, including timestamp offset');
end;

procedure TestHighLevel(const ConnStr: string);
var C: TSQLConnection; Q: TSQLQuery; Tran: TDBXTransaction;
  S: string; B: TBcd; Data: TBytes; TS: TSQLTimeStamp;
begin
  C := TSQLConnection.Create(nil);
  try
    C.DriverName := 'DbxOpenOdbc'; C.LoginPrompt := False;
    C.Params.Clear; C.Params.Values['DriverName'] := 'DbxOpenOdbc';
    C.Params.Values['ConnectionString'] := ConnStr;
    C.Open;
    Exec(C.DBXConnection,'CREATE TABLE #DbxRuntimeCrud (n int,d date,t time(3),ts datetime2(3),' +
      'amount decimal(18,4),s nvarchar(max),b varbinary(max),z int NULL)');
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := C;
      S := StringOfChar(WideChar($6F22),12000);
      B := StrToBcd('1234.5678',TFormatSettings.Invariant);
      Data := TBytes.Create($01,$23,$45,$67);
      TS := DateTimeToSQLTimeStamp(EncodeDate(2026,11,4)+EncodeTime(12,34,56,789));
      Tran := C.BeginTransaction;
      try
        Q.SQL.Text := 'INSERT INTO #DbxRuntimeCrud VALUES(:n,:d,:t,:ts,:amount,:s,:b,:z)';
        Q.ParamByName('n').AsInteger := 1;
        Q.ParamByName('d').AsDate := EncodeDate(2026,11,4);
        Q.ParamByName('t').AsTime := EncodeTime(12,34,56,789);
        Q.ParamByName('ts').AsSQLTimeStamp := TS;
        Q.ParamByName('amount').AsFMTBCD := B;
        Q.ParamByName('s').AsWideString := S;
        Q.ParamByName('b').AsBytes := Data;
        Q.ParamByName('z').DataType := ftInteger; Q.ParamByName('z').Clear;
        Check(Q.ExecSQL=1,'Unexpected inserted row count');
        C.CommitFreeAndNil(Tran);
      finally if Tran<>nil then C.RollbackFreeAndNil(Tran); end;
      Q.SQL.Text := 'SELECT n,d,t,ts,amount,s,b,z FROM #DbxRuntimeCrud';
      Q.Open;
      Check(not Q.Eof and (Q.FieldByName('n').AsInteger=1),'Committed row missing');
      Check(Q.FieldByName('d').AsDateTime=EncodeDate(2026,11,4),'Dataset date changed');
      Check(Abs(Q.FieldByName('t').AsDateTime-EncodeTime(12,34,56,789))<1E-9,'Dataset time changed');
      Check(Abs(Q.FieldByName('ts').AsDateTime-SQLTimeStampToDateTime(TS))<1E-9,'Dataset timestamp changed');
      Check(BcdCompare(TFMTBCDField(Q.FieldByName('amount')).AsBCD,B)=0,'Dataset BCD changed');
      Check(Q.FieldByName('s').AsString=S,'Dataset Unicode memo changed');
      Data := Q.FieldByName('b').AsBytes;
      Check((Length(Data)=4) and (Data[0]=$01) and (Data[3]=$67),'Dataset BLOB changed');
      Check(Q.FieldByName('z').IsNull,'Dataset NULL changed');
      Q.Close;
      Tran := C.BeginTransaction;
      try
        Q.SQL.Text := 'UPDATE #DbxRuntimeCrud SET n=2';
        Check(Q.ExecSQL=1,'Unexpected updated row count');
        C.RollbackFreeAndNil(Tran);
      finally if Tran<>nil then C.RollbackFreeAndNil(Tran); end;
      Q.SQL.Text := 'SELECT n FROM #DbxRuntimeCrud'; Q.Open;
      Check(Q.Fields[0].AsInteger=1,'Rollback did not restore data');
      Q.Close;
      Exec(C.DBXConnection,'DROP TABLE #DbxRuntimeCrud');
    finally Q.Free; end;
  finally C.Free; end;
  Writeln('[PASS] TSQLQuery parameterized INSERT/readback, affected rows, commit and rollback');
end;

procedure TestLongData(C: TDBXConnection; const ConnStr: string);
var Cmd: TDBXCommand; R: TDBXReader; Env: TOdbcEnvHandle;
  Conn: TOdbcConnectionHandle; Stmt: TOdbcStatementHandle;
  Data: TBytes; IsNull: LongBool; N, Total: Int64; Offset,I: Integer; S: string;
begin
  Cmd := C.CreateCommand;
  try
    Cmd.Text := 'SELECT CAST(REPLICATE(''a'',8000) AS varchar(8000)), ' +
      'REPLICATE(CAST(NCHAR(28450) AS nvarchar(max)),12000), CAST(NCHAR(1046) AS nvarchar(10))';
    R := Cmd.ExecuteQuery;
    try
      Check((R<>nil) and R.Next,'Missing long text row');
      Check(R.Value[0].AsString=StringOfChar('a',8000),'ANSI string truncated');
      S := R.Value[1].AsString;
      Check(S=StringOfChar(WideChar($6F22),12000),Format('Unicode memo mismatch: length=%d, type=%d, subtype=%d',
        [Length(S),R.ValueType[1].DataType,R.ValueType[1].SubType]));
      Check(R.Value[2].AsString=string(WideChar($0416)),'Unicode short string lost characters');
    finally R.Free; end;
  finally Cmd.Free; end;
  Env := TOdbcEnvHandle.Create;
  try
    Conn := TOdbcConnectionHandle.Create(Env);
    try
      Conn.Connect(ConnStr);
      Stmt := TOdbcStatementHandle.Create(Conn);
      try
        Stmt.ExecuteDirect('SELECT CONVERT(varbinary(max),REPLICATE(CAST(''0123456789ABCDEF'' AS varchar(max)),2048)) ' +
          'UNION ALL SELECT CAST(0xAABB AS varbinary(max))');
        Check(Stmt.FetchNext,'Missing binary row');
        Stmt.GetByteLength(1,Total,IsNull);
        Check(not IsNull and (Total=32768),'Wrong BLOB byte length');
        SetLength(Data,997);
        Offset := 0;
        while Offset < Total do
        begin
          Stmt.GetBytes(1,Offset,Data,0,Length(Data),N,IsNull);
          Check(not IsNull and (N>0),'BLOB chunk missing');
          for I := 0 to N-1 do
            Check(Data[I]=Ord('0123456789ABCDEF'[(Offset+I) mod 16+1]),'BLOB chunk corrupted');
          Inc(Offset,N);
        end;
        Stmt.GetBytes(1,17,Data,5,16,N,IsNull);
        Check((N=16) and (Data[5]=Ord('1')),'BLOB backward offset failed');
        Stmt.GetByteLength(1,Total,IsNull);
        Check(Total=32768,'Repeated BLOB length changed');
        Check(Stmt.FetchNext,'Missing second binary row');
        Stmt.GetByteLength(1,Total,IsNull);
        Check(Total=2,'Previous-row BLOB cache reused');
        Stmt.GetBytes(1,0,Data,0,2,N,IsNull);
        Check((N=2) and (Data[0]=$AA) and (Data[1]=$BB),'Second BLOB row changed');
      finally Stmt.Free; end;
    finally Conn.Free; end;
  finally Env.Free; end;
  Writeln('[PASS] Long ANSI/Unicode text; BLOB length, chunks, random offsets and row reset');
end;

function SQLGetStmtAttrW(StatementHandle: SqlHStmt; Attribute: SqlInteger;
  ValuePtr: Pointer; BufferLength: SqlInteger; StringLengthPtr: Pointer): SqlReturn;
  stdcall; external 'odbc32.dll';

function SQLBindCol(StatementHandle: SqlHStmt; ColumnNumber: SqlUSmallint;
  TargetType: SqlSmallint; TargetValuePtr: Pointer; BufferLength: NativeInt;
  IndicatorPtr: Pointer): SqlReturn; stdcall; external 'odbc32.dll';

procedure TestAdaptiveFetch(const ConnStr: string);
const
  RowArraySizeAttr = 27;
  RowCount = 513;
  Digits = 'digits(n) AS (SELECT n FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS d(n))';
var
  Env: TOdbcEnvHandle;
  Conn: TOdbcConnectionHandle;
  Stmt: TOdbcStatementHandle;
  RowArraySize: NativeUInt;
  Row: Integer;
  Ordinal: TInt32;
  IsNull: LongBool;
  AnsiValue: AnsiString;
  WideValue: string;

  procedure CheckRowset(Batched: Boolean);
  begin
    RowArraySize := 0;
    Check(OdbcSucceeded(SQLGetStmtAttrW(Stmt.HStmt, RowArraySizeAttr,
      @RowArraySize, SizeOf(RowArraySize), nil)), 'Cannot read the ODBC row array size');
    if Batched then
      Check((RowArraySize > 1) and (RowArraySize < RowCount), 'Bound test must span multiple rowsets')
    else
      Check(RowArraySize = 1, 'LOB result must restore single-row fetch');
  end;

  procedure CheckRejectedBinding(const SQL: string; TargetType: SqlSmallint;
    BufferSize: Integer; const ExpectedState: string);
  var
    Buffer: TBytes;
    Indicators: TArray<NativeInt>;
    Rejected: Boolean;
  begin
    Stmt.ExecuteDirect(SQL);
    Stmt.DescribeResultColumns;
    try
      CheckRowset(True);
      SetLength(Buffer, Integer(RowArraySize) * BufferSize);
      SetLength(Indicators, Integer(RowArraySize));
      Check(OdbcSucceeded(SQLBindCol(Stmt.HStmt, 1, TargetType,
        @Buffer[0], BufferSize, @Indicators[0])), 'Cannot bind the error-test buffer');
      Rejected := False;
      try
        Stmt.FetchNext;
      except
        on E: EOdbcError do
        begin
          Check(Pos(ExpectedState, E.Message) > 0, 'Unexpected block diagnostic: ' + E.Message);
          Rejected := True;
        end;
      end;
      Check(Rejected, 'Failed rowset was returned to the reader');
      Check(not Stmt.FetchNext, 'Failed rowset was exposed after the error');
    finally
      Stmt.CloseCursor;
    end;
  end;

begin
  Env := TOdbcEnvHandle.Create;
  try
    Conn := TOdbcConnectionHandle.Create(Env);
    try
      Conn.Connect(ConnStr);
      Stmt := TOdbcStatementHandle.Create(Conn);
      try
        Stmt.ExecuteDirect('WITH ' + Digits + ', numbered(n) AS (' +
          'SELECT a.n+10*b.n+100*c.n+1 FROM digits a CROSS JOIN digits b CROSS JOIN digits c) ' +
          'SELECT n, CAST(CASE WHEN n%3=0 THEN NULL WHEN n%3=1 THEN '''' ELSE ''text'' END AS varchar(12)), ' +
          'CAST(NCHAR(28450)+CONVERT(nvarchar(4),n) AS nvarchar(12)) ' +
          'FROM numbered WHERE n<=513 ORDER BY n');
        for Row := 1 to RowCount do
        begin
          Check(Stmt.FetchNext, Format('Missing bound row %d', [Row]));
          if Row = 1 then
            CheckRowset(True);
          Stmt.GetWideString(3, WideValue, IsNull);
          Check(not IsNull and (WideValue = WideChar($6F22) + IntToStr(Row)), 'Bound Unicode value changed');
          Stmt.GetInt32(1, Ordinal, IsNull);
          Check(not IsNull and (Ordinal = Row), 'Bound row sequence changed');
          Stmt.GetAnsiString(2, AnsiValue, IsNull);
          case Row mod 3 of
            0: Check(IsNull, 'Bound NULL became a string');
            1: Check(not IsNull and (AnsiValue = ''), 'Bound empty string changed');
            2: Check(not IsNull and (AnsiValue = 'text'), 'Bound ANSI text changed');
          end;
        end;
        Check(not Stmt.FetchNext, 'Unexpected extra bound row');
        Stmt.CloseCursor;
        Stmt.ExecuteDirect('SELECT 1, CAST(0x0102 AS varbinary(max))');
        Check(Stmt.FetchNext, 'Missing row after switching to a LOB result');
        CheckRowset(False);
        Check(not Stmt.FetchNext, 'Unexpected extra LOB row');
        Stmt.CloseCursor;
        CheckRejectedBinding('SELECT CAST(''payload'' AS varchar(12))', SQL_C_CHAR, 2, '01004');
        CheckRejectedBinding('SELECT CAST(''12'' AS varchar(12)) UNION ALL ' +
          'SELECT CAST(''invalid'' AS varchar(12))', SQL_C_SLONG, SizeOf(TInt32), '22018');
      finally Stmt.Free; end;
    finally Conn.Free; end;
  finally Env.Free; end;
  Writeln('[PASS] Adaptive block rowsets, text, NULL/empty values, LOB fallback and rejected rowsets');
end;

procedure TestOutputs(C: TDBXConnection);
var Cmd: TDBXCommand; TS: TSQLTimeStamp; B: TBcd; Buf: TBytes; N: Int64;
  Rejected: Boolean;
begin
  // SQL Server session-local procedure: no persistent database object is created.
  Exec(C,'CREATE PROCEDURE #DbxRuntimeOutput @i int OUTPUT, @s nvarchar(100) OUTPUT, ' +
    '@b varbinary(100) OUTPUT, @d date OUTPUT, @ts datetime2(3) OUTPUT, ' +
    '@t time(3) OUTPUT, @n decimal(18,4) OUTPUT, @e nvarchar(100) OUTPUT, @z int OUTPUT AS ' +
    'SET NOCOUNT ON; SET @i=ISNULL(@i,0)+7; SET @s=N''output-value''; SET @b=0x01234567; ' +
    'SET @d=''2026-11-04''; SET @ts=''2026-11-04T12:34:56.789''; SET @t=''12:34:56.789''; ' +
    'SET @n=1234.5678; SET @e=N''''; SET @z=NULL; RETURN 42;');
  Cmd := C.CreateCommand;
  try
    Cmd.Text := '{?=call #DbxRuntimeOutput(?,?,?,?,?,?,?,?,?)}';
    AddParam(Cmd,TDBXDataTypes.Int32Type,TDBXParameterDirections.ReturnParameter);
    AddParam(Cmd,TDBXDataTypes.Int32Type,TDBXParameterDirections.InOutParameter);
    AddParam(Cmd,TDBXDataTypes.WideStringType,TDBXParameterDirections.OutParameter,100);
    AddParam(Cmd,TDBXDataTypes.VarBytesType,TDBXParameterDirections.OutParameter,100);
    AddParam(Cmd,TDBXDataTypes.DateType,TDBXParameterDirections.OutParameter);
    AddParam(Cmd,TDBXDataTypes.TimeStampType,TDBXParameterDirections.OutParameter);
    AddParam(Cmd,TDBXDataTypes.TimeType,TDBXParameterDirections.OutParameter,32);
    AddParam(Cmd,TDBXDataTypes.BcdType,TDBXParameterDirections.OutParameter,64);
    AddParam(Cmd,TDBXDataTypes.WideStringType,TDBXParameterDirections.OutParameter,100);
    AddParam(Cmd,TDBXDataTypes.Int32Type,TDBXParameterDirections.OutParameter);
    Cmd.Parameters[1].Value.SetInt32(5);
    Cmd.ExecuteUpdate;
    Check(Cmd.Parameters[0].Value.GetInt32=42,'Return value missing');
    Check(Cmd.Parameters[1].Value.GetInt32=12,'INOUT value missing');
    Check(Cmd.Parameters[2].Value.AsString='output-value','String output missing');
    SetLength(Buf,4);
    N := Cmd.Parameters[3].Value.GetBytes(0,Buf,0,4);
    Check((N=4) and (Buf[0]=$01) and (Buf[3]=$67),'Binary output missing');
    Check(Cmd.Parameters[4].Value.GetDate=DateTimeToTimeStamp(EncodeDate(2026,11,4)).Date,'Date output missing');
    TS := Cmd.Parameters[5].Value.GetTimeStamp;
    Check((TS.Year=2026) and (TS.Fractions=789),'Timestamp output changed');
    Check(Cmd.Parameters[6].Value.GetTime=45296789,'Time output changed');
    B := StrToBcd('1234.5678',TFormatSettings.Invariant);
    Check(BcdCompare(Cmd.Parameters[7].Value.GetBcd,B)=0,'BCD output changed');
    Check(not Cmd.Parameters[8].Value.IsNull and (Cmd.Parameters[8].Value.AsString=''),'Empty output became NULL');
    Check(Cmd.Parameters[9].Value.IsNull,'NULL output changed');
    // Reuse the prepared command and feed the prior INOUT value back as input.
    Cmd.ExecuteUpdate;
    Check(Cmd.Parameters[1].Value.GetInt32=19,'Repeated INOUT value missing');
    Cmd.Parameters[2].Size := 2;
    Rejected := False;
    try
      Cmd.ExecuteUpdate;
    except
      on E: EOdbcError do
      begin
        if E.SqlState <> '22001' then raise;
        Rejected := True;
      end;
    end;
    Check(Rejected,Format('Truncated output must raise an error (Size=%d Precision=%d returned=%s)',
      [Cmd.Parameters[2].Size,Cmd.Parameters[2].Precision,Cmd.Parameters[2].Value.AsString]));
  finally Cmd.Free; Exec(C,'DROP PROCEDURE #DbxRuntimeOutput'); end;
  Writeln('[PASS] OUTPUT, INOUT, return values, dates, BCD, bytes, empty/NULL outputs and reuse');
end;

var Props: TDBXProperties; C: TDBXConnection; ConnStr: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    ConnStr := GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION');
    Check(ConnStr<>'','Set DBXOODBC_TEST_CONNECTION to a SQL Server connection string');
    Writeln('[START] SQL Server runtime regression'); Flush(Output);
    Props := TDBXProperties.Create;
    try
      Props['DriverName'] := 'DbxOpenOdbc';
      Props['ConnectionString'] := ConnStr;
      C := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
      try
        Writeln('[PASS] Connected'); Flush(Output);
        TestParameters(C);
        Flush(Output);
        TestAdaptiveFetch(ConnStr);
        Flush(Output);
        TestLongData(C,ConnStr);
        Flush(Output);
        TestOutputs(C);
        Flush(Output);
        TestOutputReaders(C);
        Flush(Output);
        TestHighLevel(ConnStr);
        Flush(Output);
      finally C.Free; end;
    finally Props.Free; end;
  except
    on E: Exception do begin Writeln('[FAIL] ',E.ClassName,': ',E.Message); ExitCode:=1; end;
  end;
end.
