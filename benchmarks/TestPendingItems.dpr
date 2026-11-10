program TestPendingItems;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  System.Diagnostics,
  System.Hash,
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

// =============================================================================
// CONFIRMATION ITEM 3: BLOB Digest Verification (Equal Length, Different Content)
// =============================================================================
procedure VerifyBlobDigestSensitivity;
var
  StreamA, StreamB: TMemoryStream;
  BufA, BufB: TArray<Byte>;
  HashA_Buggy, HashB_Buggy: string;
  HashA_Fixed, HashB_Fixed: string;
  I: Integer;
begin
  Writeln('=== [CONFIRMATION ITEM 3] BLOB Digest Sensitivity (Equal Length, Diff Content) ===');
  StreamA := TMemoryStream.Create;
  StreamB := TMemoryStream.Create;
  try
    SetLength(BufA, 1024);
    SetLength(BufB, 1024);
    for I := 0 to 1023 do
    begin
      BufA[I] := Byte(I and $FF);
      BufB[I] := Byte(I and $FF);
    end;
    // Exactly equal length (1024 bytes), but flip bits at offset 512
    BufB[512] := BufB[512] xor $FF;

    StreamA.WriteBuffer(BufA[0], 1024);
    StreamB.WriteBuffer(BufB[0], 1024);

    // Case 1: Without Position := 0 (reproducing the bug where Stream.Position = Stream.Size)
    HashA_Buggy := THashSHA2.GetHashString(StreamA);
    HashB_Buggy := THashSHA2.GetHashString(StreamB);
    Writeln('  [Buggy Case - Position at End]');
    Writeln('    HashA_Buggy: ', HashA_Buggy);
    Writeln('    HashB_Buggy: ', HashB_Buggy);
    if HashA_Buggy <> HashB_Buggy then
      raise Exception.Create('Buggy case unexpectedly produced different hashes');
    Writeln('    [Confirmed] Both returned empty-stream hash (e3b0c442...) due to Position at EOF!');

    // Case 2: With Position := 0 (fixed behavior)
    StreamA.Position := 0;
    StreamB.Position := 0;
    HashA_Fixed := THashSHA2.GetHashString(StreamA);
    HashB_Fixed := THashSHA2.GetHashString(StreamB);
    Writeln('  [Fixed Case - Position := 0]');
    Writeln('    HashA_Fixed: ', HashA_Fixed);
    Writeln('    HashB_Fixed: ', HashB_Fixed);
    if HashA_Fixed = HashB_Fixed then
      raise Exception.Create('FAIL: Hashes matched despite different content!');
    if (HashA_Fixed = HashA_Buggy) or (HashB_Fixed = HashB_Buggy) then
      raise Exception.Create('FAIL: Fixed hash matched empty hash!');
    Writeln('    [PASS] Hashes are distinct and properly detect content difference!');
  finally
    StreamA.Free;
    StreamB.Free;
  end;
  Writeln;
end;

// =============================================================================
// CONFIRMATION ITEM 4: Cross-check M_OILAPP BLOB against SQL Server HASHBYTES
// =============================================================================
procedure VerifyOilAppBlobWithSqlServer(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  StreamQ, StreamCDS, StreamHead: TMemoryStream;
  FullHashQ, FullHashCDS, HeadHashQ, SqlHash: string;
  TotalSize: Int64;
begin
  Writeln('=== [CONFIRMATION ITEM 4] Cross-check M_OILAPP BLOB (TSQLQuery vs CDS vs SQL Server) ===');
  StreamQ := TMemoryStream.Create;
  StreamCDS := TMemoryStream.Create;
  StreamHead := TMemoryStream.Create;
  try
    // 1. Fetch via TSQLQuery
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT SERNUM, INVIMG FROM dbo.M_OILAPP WHERE SERNUM = ''OI25030005''';
      Q.Open;
      if Q.IsEmpty or Q.FieldByName('INVIMG').IsNull then
        raise Exception.Create('Target row OI25030005 not found or INVIMG is NULL');

      TBlobField(Q.FieldByName('INVIMG')).SaveToStream(StreamQ);
      TotalSize := StreamQ.Size;
      StreamQ.Position := 0;
      FullHashQ := THashSHA2.GetHashString(StreamQ);
      Writeln(Format('  TSQLQuery  : Size = %d bytes, Full SHA-256 = %s', [TotalSize, FullHashQ]));

      // Extract first 8000 bytes for SQL Server 2014 HASHBYTES limit
      StreamQ.Position := 0;
      StreamHead.CopyFrom(StreamQ, 8000);
      StreamHead.Position := 0;
      HeadHashQ := UpperCase(THashSHA2.GetHashString(StreamHead));
      Writeln(Format('  TSQLQuery  : First 8000 bytes SHA-256 = %s', [HeadHashQ]));
    finally
      Q.Free;
    end;

    // 2. Fetch via ClientDataSet
    Q := TSQLQuery.Create(nil);
    DSP := TDataSetProvider.Create(nil);
    CDS := TClientDataSet.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT SERNUM, INVIMG FROM dbo.M_OILAPP WHERE SERNUM = ''OI25030005''';
      DSP.DataSet := Q;
      DSP.ResolveToDataSet := False;
      CDS.SetProvider(DSP);
      CDS.PacketRecords := -1;
      CDS.Open;
      if CDS.IsEmpty or CDS.FieldByName('INVIMG').IsNull then
        raise Exception.Create('CDS target row OI25030005 not found or INVIMG is NULL');

      TBlobField(CDS.FieldByName('INVIMG')).SaveToStream(StreamCDS);
      StreamCDS.Position := 0;
      FullHashCDS := THashSHA2.GetHashString(StreamCDS);
      Writeln(Format('  ClientDS   : Size = %d bytes, Full SHA-256 = %s', [StreamCDS.Size, FullHashCDS]));

      if (StreamCDS.Size <> TotalSize) or (FullHashCDS <> FullHashQ) then
        raise Exception.Create('FAIL: Mismatch between TSQLQuery and ClientDataSet BLOB content!');
      Writeln('  [PASS] TSQLQuery and ClientDataSet BLOB size and SHA-256 match exactly!');
    finally
      CDS.Free;
      DSP.Free;
      Q.Free;
    end;

    // 3. Query SQL Server HASHBYTES for first 8000 bytes
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT CONVERT(VARCHAR(66), HASHBYTES(''SHA2_256'', CAST(SUBSTRING(INVIMG, 1, 8000) AS VARBINARY(8000))), 1) AS SqlHash ' +
                    'FROM dbo.M_OILAPP WHERE SERNUM = ''OI25030005''';
      Q.Open;
      SqlHash := Q.FieldByName('SqlHash').AsString;
      if StartsText('0x', SqlHash) then
        SqlHash := Copy(SqlHash, 3, Length(SqlHash));
      SqlHash := UpperCase(SqlHash);
      Writeln(Format('  SQL Server : First 8000 bytes HASHBYTES = %s', [SqlHash]));

      if HeadHashQ <> SqlHash then
        raise Exception.CreateFmt('FAIL: Delphi SHA-256 (%s) <> SQL Server HASHBYTES (%s)', [HeadHashQ, SqlHash]);
      Writeln('  [PASS] Delphi SHA-256 matches SQL Server HASHBYTES 100%!');
    finally
      Q.Free;
    end;
  finally
    StreamHead.Free;
    StreamCDS.Free;
    StreamQ.Free;
  end;
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
      VerifyBlobDigestSensitivity;
      VerifyAnsiStringBehavior(Conn);
      VerifyOilAppBlobWithSqlServer(Conn);
      ProfileCdsOpenVariance(Conn, 10);
    finally
      Conn.Free;
    end;
  finally
    CoUninitialize;
  end;
end.
