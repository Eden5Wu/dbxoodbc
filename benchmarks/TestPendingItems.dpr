program TestPendingItems;

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
  G_Server, G_Database, G_User, G_Password, G_OdbcDriver: string;

function LoadConfig: Boolean;
var
  IniPath: string;
  Ini: TIniFile;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'bench_config.ini';
  if not FileExists(IniPath) then Exit(False);
  Ini := TIniFile.Create(IniPath);
  try
    G_Server     := Ini.ReadString('Database', 'Server', '127.0.0.1');
    G_Database   := Ini.ReadString('Database', 'Database', 'TestDB');
    G_User       := Ini.ReadString('Database', 'User', 'sa');
    G_Password   := Ini.ReadString('Database', 'Password', '');
    G_OdbcDriver := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');
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

// =============================================================================
// CONFIRMATION ITEM 1: ANSI String Verification (GetAnsiString)
// =============================================================================
procedure VerifyAnsiStringBehavior(Conn: TSQLConnection);
var
  Props: TDBXProperties;
  DbxConn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  BR: TDBXByteReader;
  Buf: TArray<Byte>;
  IsNull: LongBool;
  AnsiStr: AnsiString;
begin
  Writeln('=== [CONFIRMATION ITEM 1] ANSI / VARCHAR ByteReader Verification ===');
  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := 'DbxOpenOdbc';
    Props[TDBXOpenOdbcProperties.StrConnectionString] := Format(
      'Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;MARS_Connection=yes;Packet Size=16384;',
      [G_OdbcDriver, G_Server, G_Database, G_User, G_Password]);
    DbxConn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Cmd := DbxConn.CreateCommand;
      try
        Cmd.Text :=
          'SELECT ' +
          '  CAST(''ANSI_TEST_STRING_12345'' AS VARCHAR(50)) AS ColVarcharAscii, ' +
          '  CAST(N''' + #$4E2D#$6587 + 'ANSI' + #$6E2C#$8A66 + ''' AS VARCHAR(50)) AS ColVarcharChinese, ' +
          '  CAST('''' AS VARCHAR(50)) AS ColVarcharEmpty, ' +
          '  CAST(NULL AS VARCHAR(50)) AS ColVarcharNull';
        Reader := Cmd.ExecuteQuery;
        try
          if not Reader.Next then
            raise Exception.Create('Failed to query ANSI test row');

          BR := Reader.ByteReader;
          Writeln('  Reader.ByteReader Class: ', BR.ClassName);

          // 1. ColVarcharAscii
          SetLength(Buf, 64);
          BR.GetAnsiString(0, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColVarcharAscii returned IsNull=True');
          AnsiStr := PAnsiChar(@Buf[0]);
          Writeln('  [+] ColVarcharAscii: ', string(AnsiStr));
          if AnsiStr <> 'ANSI_TEST_STRING_12345' then
            raise Exception.Create('ColVarcharAscii content mismatch');

          // 2. ColVarcharChinese (MBCS / Big5)
          SetLength(Buf, 64);
          BR.GetAnsiString(1, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColVarcharChinese returned IsNull=True');
          AnsiStr := PAnsiChar(@Buf[0]);
          Writeln('  [+] ColVarcharChinese: ', string(AnsiStr));
          if AnsiStr <> AnsiString(#$4E2D#$6587 + 'ANSI' + #$6E2C#$8A66) then
            raise Exception.Create('ColVarcharChinese content mismatch');

          // 3. ColVarcharEmpty
          SetLength(Buf, 16);
          BR.GetAnsiString(2, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColVarcharEmpty returned IsNull=True');
          AnsiStr := PAnsiChar(@Buf[0]);
          Writeln('  [+] ColVarcharEmpty: Length=', Length(AnsiStr), ', IsNull=False');
          if Length(AnsiStr) <> 0 then
            raise Exception.Create('ColVarcharEmpty expected 0 length');

          // 4. ColVarcharNull
          for var i := 0 to 15 do Buf[i] := $AA;
          BR.GetAnsiString(3, Buf, 0, IsNull);
          if not IsNull then raise Exception.Create('ColVarcharNull expected IsNull=True');
          for var i := 0 to 15 do
            if Buf[i] <> $AA then raise Exception.Create('ColVarcharNull modified buffer');
          Writeln('  [+] ColVarcharNull: IsNull=True, Buffer untouched');

          Writeln('  [CONFIRMED] ANSI String paths (ASCII, Big5/MBCS, Empty, NULL) 100% verified!');
          Writeln;
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;
    finally
      DbxConn.Free;
    end;
  finally
    Props.Free;
  end;
end;

// =============================================================================
// CONFIRMATION ITEM 2: 10-Run Repeated Variance Profile on M_SYSFIL CDS.Open
// =============================================================================
procedure ProfileCdsOpenVariance(Conn: TSQLConnection; RepCount: Integer);
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
  RunIdx: Integer;
  Ms: Double;
  Times: array of Double;
  Sum, MinMs, MaxMs, AvgMs, Jitter: Double;
begin
  Writeln(Format('=== [CONFIRMATION ITEM 2] %d-Run Repeated Variance Profile: M_SYSFIL ClientDataSet.Open ===', [RepCount]));
  SetLength(Times, RepCount);
  Sum := 0;
  MinMs := 1e9;
  MaxMs := 0;

  // Warmup
  Q := TSQLQuery.Create(nil);
  DSP := TDataSetProvider.Create(nil);
  CDS := TClientDataSet.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := 'SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)';
    DSP.DataSet := Q;
    DSP.ResolveToDataSet := False;
    CDS.SetProvider(DSP);
    CDS.PacketRecords := -1;
    CDS.Open;
  finally
    CDS.Free;
    DSP.Free;
    Q.Free;
  end;

  for RunIdx := 0 to RepCount - 1 do
  begin
    Q := TSQLQuery.Create(nil);
    DSP := TDataSetProvider.Create(nil);
    CDS := TClientDataSet.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)';
      DSP.DataSet := Q;
      DSP.ResolveToDataSet := False;
      CDS.SetProvider(DSP);
      CDS.PacketRecords := -1;

      SW := TStopwatch.StartNew;
      CDS.Open;
      SW.Stop;
      Ms := SW.ElapsedMilliseconds;

      Times[RunIdx] := Ms;
      Sum := Sum + Ms;
      if Ms < MinMs then MinMs := Ms;
      if Ms > MaxMs then MaxMs := Ms;

      Write(Format('%6.1f ms ', [Ms]));
      if ((RunIdx + 1) mod 5) = 0 then Writeln;
    finally
      CDS.Free;
      DSP.Free;
      Q.Free;
    end;
    Sleep(100);
  end;

  AvgMs := Sum / RepCount;
  Jitter := MaxMs - MinMs;
  Writeln(Format('  --> Avg: %6.1f ms | Min: %6.1f ms | Max: %6.1f ms | Jitter (Range): %6.1f ms',
    [AvgMs, MinMs, MaxMs, Jitter]));
  Writeln;
end;

var
  Conn: TSQLConnection;
begin
  CoInitialize(nil);
  try
    if not LoadConfig then Exit;
    Conn := CreateConnection;
    try
      VerifyAnsiStringBehavior(Conn);
      ProfileCdsOpenVariance(Conn, 10);
    finally
      Conn.Free;
    end;
  finally
    CoUninitialize;
  end;
end.
