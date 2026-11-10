program BenchByteReaderCompare;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  System.Diagnostics,
  Data.DB,
  Data.SqlExpr,
  Data.DBXCommon,
  Datasnap.DBClient,
  Datasnap.Provider,
  MidasLib,
  DbxOpenOdbcDriver in '..\source\DbxOpenOdbcDriver.pas';

var
  G_Server: string;
  G_Database: string;
  G_User: string;
  G_Password: string;
  G_OdbcDriver: string;
  G_ScalarRowCount: Integer;
  G_MultiMemoTable: string;
  G_WideTable: string;
  G_BlobTable: string;

function LoadConfig: Boolean;
var
  IniPath: string;
  Ini: TIniFile;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'bench_config.ini';
  if not FileExists(IniPath) then
  begin
    Writeln('ERROR: bench_config.ini not found!');
    Exit(False);
  end;

  Ini := TIniFile.Create(IniPath);
  try
    G_Server        := Ini.ReadString('Database', 'Server', '127.0.0.1');
    G_Database      := Ini.ReadString('Database', 'Database', 'TestDB');
    G_User          := Ini.ReadString('Database', 'User', 'sa');
    G_Password      := Ini.ReadString('Database', 'Password', '');
    G_OdbcDriver    := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');

    G_ScalarRowCount := Ini.ReadInteger('Scenarios', 'ScalarRowCount', 5000);
    G_MultiMemoTable := Ini.ReadString('Scenarios', 'MultiMemoTable', '');
    G_WideTable      := Ini.ReadString('Scenarios', 'WideTable', '');
    G_BlobTable      := Ini.ReadString('Scenarios', 'BlobTable', '');
    Result := True;
  finally
    Ini.Free;
  end;
end;

function CreateConnection: TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.DriverName := 'DbxOpenOdbc';
  Result.LoginPrompt := False;
  Result.Params.Values['ConnectionString'] := Format(
    'Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;MARS_Connection=yes;Packet Size=16384;',
    [G_OdbcDriver, G_Server, G_Database, G_User, G_Password]);
  Result.Open;
end;

procedure RunQueryScan(Conn: TSQLConnection; const SQL: string; ReadBlobs: Boolean;
  out ElapsedMs: Double; out TotalRows, TotalCols: Integer; out Checksum: UInt64);
var
  Q: TSQLQuery;
  SW: TStopwatch;
  ColCount, I: Integer;
  F: TField;
  Stream: TMemoryStream;
  V: Variant;
  StrVal: string;
begin
  TotalRows := 0;
  TotalCols := 0;
  Checksum := 0;
  Stream := TMemoryStream.Create;
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := SQL;
    SW := TStopwatch.StartNew;
    Q.Open;
    ColCount := Q.FieldCount;
    TotalCols := ColCount;
    while not Q.Eof do
    begin
      Inc(TotalRows);
      for I := 0 to ColCount - 1 do
      begin
        F := Q.Fields[I];
        if not F.IsNull then
        begin
          if F.IsBlob and ReadBlobs then
          begin
            Stream.Clear;
            TBlobField(F).SaveToStream(Stream);
            Inc(Checksum, Stream.Size);
          end
          else
          begin
            V := F.Value;
            StrVal := VarToStr(V);
            Inc(Checksum, Length(StrVal));
          end;
        end;
      end;
      Q.Next;
    end;
    SW.Stop;
    ElapsedMs := SW.ElapsedMilliseconds;
  finally
    Q.Free;
    Stream.Free;
  end;
end;

procedure RunCdsScan(Conn: TSQLConnection; const SQL: string;
  out ElapsedMs: Double; out TotalRows, TotalCols: Integer; out Checksum: UInt64);
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
  ColCount, I: Integer;
  F: TField;
  StrVal: string;
begin
  TotalRows := 0;
  TotalCols := 0;
  Checksum := 0;
  Q := TSQLQuery.Create(nil);
  DSP := TDataSetProvider.Create(nil);
  CDS := TClientDataSet.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := SQL;
    DSP.DataSet := Q;
    DSP.ResolveToDataSet := False;
    CDS.SetProvider(DSP);
    CDS.PacketRecords := -1;

    SW := TStopwatch.StartNew;
    CDS.Open;
    SW.Stop;
    ElapsedMs := SW.ElapsedMilliseconds;

    TotalRows := CDS.RecordCount;
    TotalCols := CDS.FieldCount;
    ColCount := TotalCols;
    CDS.First;
    while not CDS.Eof do
    begin
      for I := 0 to ColCount - 1 do
      begin
        F := CDS.Fields[I];
        if not F.IsNull then
        begin
          StrVal := F.AsString;
          Inc(Checksum, Length(StrVal));
        end;
      end;
      CDS.Next;
    end;
  finally
    CDS.Free;
    DSP.Free;
    Q.Free;
  end;
end;

procedure RunSingleScenario(Conn: TSQLConnection; const Title, SQL: string;
  IsCds: Boolean; ReadBlobs: Boolean; IterCount: Integer);
var
  Iter: Integer;
  Ms: Double;
  Rows, Cols: Integer;
  Chk: UInt64;
  WarmRows, WarmCols: Integer;
  WarmChk: UInt64;
  Samples: array of Double;
  Sum, MinMs, MaxMs, AvgMs, Jitter: Double;
begin
  Writeln('=== ' + Title + ' ===');
  SetLength(Samples, IterCount);

  // Warmup run
  if IsCds then
    RunCdsScan(Conn, SQL, Ms, WarmRows, WarmCols, WarmChk)
  else
    RunQueryScan(Conn, SQL, ReadBlobs, Ms, WarmRows, WarmCols, WarmChk);

  Writeln(Format('  [Consistency] Rows=%d, Cols=%d, Checksum=%u', [WarmRows, WarmCols, WarmChk]));

  Sum := 0;
  MinMs := 1e9;
  MaxMs := 0;
  for Iter := 0 to IterCount - 1 do
  begin
    if IsCds then
      RunCdsScan(Conn, SQL, Ms, Rows, Cols, Chk)
    else
      RunQueryScan(Conn, SQL, ReadBlobs, Ms, Rows, Cols, Chk);

    if (Rows <> WarmRows) or (Chk <> WarmChk) then
      Writeln(Format('  [WARNING] Output mismatch at iter %d: Rows=%d, Chk=%u', [Iter + 1, Rows, Chk]));

    Samples[Iter] := Ms;
    Sum := Sum + Ms;
    if Ms < MinMs then MinMs := Ms;
    if Ms > MaxMs then MaxMs := Ms;
    Writeln(Format('  Sample %d: %6.1f ms', [Iter + 1, Ms]));
  end;

  AvgMs := Sum / IterCount;
  Jitter := MaxMs - MinMs;
  Writeln(Format('  [Summary] Avg: %6.1f ms | Min: %6.1f ms | Max: %6.1f ms | Jitter: %6.1f ms',
    [AvgMs, MinMs, MaxMs, Jitter]));
  Writeln;
end;

var
  Conn: TSQLConnection;
  SqlScalar: string;
  IterCount: Integer;
begin
  CoInitialize(nil);
  try
    if not LoadConfig then Exit;

    IterCount := 5;
    if ParamCount > 0 then
      IterCount := StrToIntDef(ParamStr(1), 5);

    Writeln('================================================================================');
    Writeln(' DBXOODBC Dedicated ByteReader Benchmark Suite');
    Writeln(Format(' Target: %s / %s | Iterations: %d', [G_Server, G_Database, IterCount]));
    Writeln('================================================================================');
    Writeln;

    Conn := CreateConnection;
    try
      // 1. TSQLQuery Scalar scan
      SqlScalar := Format(
        'SELECT TOP %d ' +
        '  CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS INT) AS C_INT, ' +
        '  CAST(123456789012345 AS BIGINT) AS C_BIGINT, ' +
        '  CAST(123.456 AS FLOAT) AS C_FLOAT, ' +
        '  CAST(987.6543 AS MONEY) AS C_MONEY, ' +
        '  CAST(''2026-11-09 00:00:00'' AS DATETIME) AS C_DATE, ' +
        '  CAST(''2026-11-09 10:00:00'' AS DATETIME) AS C_DATETIME, ' +
        '  CAST(''T'' AS CHAR(1)) AS C_CHAR1, ' +
        '  CAST(''BENCH_SCALAR_STRING_1234567890'' AS VARCHAR(50)) AS C_VARCHAR, ' +
        '  CAST(1 AS BIT) AS C_BIT, ' +
        '  CAST(32767 AS SMALLINT) AS C_SMALLINT ' +
        'FROM sys.all_columns a CROSS JOIN sys.all_columns b', [G_ScalarRowCount]);

      RunSingleScenario(Conn, Format('Scenario 1: TSQLQuery Scalar Scan (%d rows x 10 cols)', [G_ScalarRowCount]),
        SqlScalar, False, False, IterCount);

      // 2. TSQLQuery Memo Scan
      if G_MultiMemoTable <> '' then
        RunSingleScenario(Conn, 'Scenario 2: TSQLQuery Multi-Memo Scan (' + G_MultiMemoTable + ' - 3000 rows)',
          'SELECT TOP 3000 * FROM ' + G_MultiMemoTable + ' WITH (NOLOCK)', False, False, IterCount);

      // 3. TSQLQuery Wide Table Scan
      if G_WideTable <> '' then
        RunSingleScenario(Conn, 'Scenario 3: TSQLQuery Wide Table Scan (' + G_WideTable + ' - 142 cols)',
          'SELECT * FROM ' + G_WideTable + ' WITH (NOLOCK)', False, False, IterCount);

      // 4. BLOB Streaming
      if G_BlobTable <> '' then
        RunSingleScenario(Conn, 'Scenario 4: BLOB Streaming (' + G_BlobTable + ')',
          'SELECT * FROM ' + G_BlobTable + ' WITH (NOLOCK)', False, True, IterCount);

      // 5. DataSnap DSP -> ClientDataSet.Open
      if G_MultiMemoTable <> '' then
        RunSingleScenario(Conn, 'Scenario 5: DSP -> ClientDataSet.Open (' + G_MultiMemoTable + ' - 3000 rows)',
          'SELECT TOP 3000 * FROM ' + G_MultiMemoTable + ' WITH (NOLOCK)', True, False, IterCount);

    finally
      Conn.Free;
    end;
  finally
    CoUninitialize;
  end;
end.
