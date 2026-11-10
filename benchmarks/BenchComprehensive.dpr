program BenchComprehensive;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.SysUtils,
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
  G_ScalarRowCount: Integer;
  G_MultiMemoTable, G_WideTable, G_BlobTable: string;

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
    G_Server         := Ini.ReadString('Database', 'Server', '127.0.0.1');
    G_Database       := Ini.ReadString('Database', 'Database', 'TestDB');
    G_User           := Ini.ReadString('Database', 'User', 'sa');
    G_Password       := Ini.ReadString('Database', 'Password', '');
    G_OdbcDriver     := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');
    G_ScalarRowCount := Ini.ReadInteger('Scenarios', 'ScalarRowCount', 5000);
    G_MultiMemoTable := Ini.ReadString('Scenarios', 'MultiMemoTable', 'dbo.M_SYSFIL');
    G_WideTable      := Ini.ReadString('Scenarios', 'WideTable', 'dbo.M_SYSFI2');
    G_BlobTable      := Ini.ReadString('Scenarios', 'BlobTable', 'dbo.S_Reports');
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

function BytesToHex(const B: TBytes): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(B) do
    Result := Result + IntToHex(B[I], 2);
end;

function StringToHex(const S: string): string;
var
  Bytes: TBytes;
begin
  Bytes := TEncoding.Unicode.GetBytes(S);
  Result := BytesToHex(Bytes);
end;

// Dumps field-by-field digest for exact baseline-vs-unicode verification
procedure DumpDataSetDigest(DS: TDataSet; const ScenarioName, PkFieldName: string; OutLines: TStrings);
var
  RowIdx, ColIdx, PkColIdx: Integer;
  F: TField;
  PkVal, LineStr, Sha256Hash: string;
  Stream: TMemoryStream;
begin
  OutLines.Add(Format('=== SCENARIO: %s (Fields: %d) ===', [ScenarioName, DS.FieldCount]));
  PkColIdx := -1;
  if PkFieldName <> '' then
  begin
    for ColIdx := 0 to DS.FieldCount - 1 do
      if SameText(DS.Fields[ColIdx].FieldName, PkFieldName) then
      begin
        PkColIdx := ColIdx;
        Break;
      end;
  end;

  Stream := TMemoryStream.Create;
  try
    RowIdx := 0;
    while not DS.Eof do
    begin
      Inc(RowIdx);
      if PkColIdx >= 0 then
        PkVal := DS.Fields[PkColIdx].AsString
      else
        PkVal := IntToStr(RowIdx);

      for ColIdx := 0 to DS.FieldCount - 1 do
      begin
        F := DS.Fields[ColIdx];
        if F.IsNull then
          LineStr := Format('[%s] %d:%s:%d:NULL', [PkVal, ColIdx, F.FieldName, Ord(F.DataType)])
        else if F.IsBlob then
        begin
          Stream.Clear;
          TBlobField(F).SaveToStream(Stream);
          if Stream.Size = 0 then
            LineStr := Format('[%s] %d:%s:%d:EMPTY_BLOB:0', [PkVal, ColIdx, F.FieldName, Ord(F.DataType)])
          else
          begin
            Sha256Hash := THashSHA2.GetHashString(Stream);
            LineStr := Format('[%s] %d:%s:%d:BLOB:%d:%s', [PkVal, ColIdx, F.FieldName, Ord(F.DataType), Stream.Size, Sha256Hash]);
          end;
        end
        else
        begin
          var StrV := F.AsWideString;
          if StrV = '' then
            LineStr := Format('[%s] %d:%s:%d:EMPTY_STR:0', [PkVal, ColIdx, F.FieldName, Ord(F.DataType)])
          else
            LineStr := Format('[%s] %d:%s:%d:STR:%d:%s', [PkVal, ColIdx, F.FieldName, Ord(F.DataType), Length(StrV), StringToHex(StrV)]);
        end;
        OutLines.Add(LineStr);
      end;
      DS.Next;
    end;
  finally
    Stream.Free;
  end;
  OutLines.Add(Format('=== END SCENARIO: %s (TotalRows: %d) ===', [ScenarioName, RowIdx]));
end;

procedure RunDigestDump(const OutputFile: string);
var
  Conn: TSQLConnection;
  OutLines: TStringList;
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  Sql: string;
begin
  Writeln('Generating full data digest to: ', OutputFile);
  Conn := CreateConnection;
  OutLines := TStringList.Create;
  try
    // 1. Synthetic Scalar
    Sql := Format(
      'SELECT TOP 500 ' +
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
      'FROM sys.all_columns a CROSS JOIN sys.all_columns b', []);
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := Sql;
      Q.Open;
      DumpDataSetDigest(Q, 'Scalar500', 'C_INT', OutLines);
    finally
      Q.Free;
    end;

    // 2. M_OILAPP Scenario A (TSQLQuery without INVIMG)
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT SERNUM, LICPLT, FUElTY, INVDATE, INVNUM, QUANTI, ACAMT, INVAM, EMPID, PAYDAT, ' +
                    'CARTYP, GRCOS, TAXAM, USRID, ENTDT, ACCON01, ACUSRID, ACENTDT, TAXCODE, CONFM ' +
                    'FROM dbo.M_OILAPP ORDER BY SERNUM';
      Q.Open;
      DumpDataSetDigest(Q, 'M_OILAPP_A_NoImg', 'SERNUM', OutLines);
    finally
      Q.Free;
    end;

    // 3. M_OILAPP Scenario B (TSQLQuery with INVIMG in full column order)
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT * FROM dbo.M_OILAPP ORDER BY SERNUM';
      Q.Open;
      DumpDataSetDigest(Q, 'M_OILAPP_B_WithImg', 'SERNUM', OutLines);
    finally
      Q.Free;
    end;

    // 4. M_OILAPP Scenario C1 (CDS without INVIMG)
    Q := TSQLQuery.Create(nil);
    DSP := TDataSetProvider.Create(nil);
    CDS := TClientDataSet.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT SERNUM, LICPLT, FUElTY, INVDATE, INVNUM, QUANTI, ACAMT, INVAM, EMPID, PAYDAT, ' +
                    'CARTYP, GRCOS, TAXAM, USRID, ENTDT, ACCON01, ACUSRID, ACENTDT, TAXCODE, CONFM ' +
                    'FROM dbo.M_OILAPP ORDER BY SERNUM';
      DSP.DataSet := Q;
      DSP.ResolveToDataSet := False;
      CDS.SetProvider(DSP);
      CDS.PacketRecords := -1;
      CDS.Open;
      DumpDataSetDigest(CDS, 'M_OILAPP_C1_CdsNoImg', 'SERNUM', OutLines);
    finally
      CDS.Free;
      DSP.Free;
      Q.Free;
    end;

    // 5. M_OILAPP Scenario C2 (CDS with INVIMG)
    Q := TSQLQuery.Create(nil);
    DSP := TDataSetProvider.Create(nil);
    CDS := TClientDataSet.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT * FROM dbo.M_OILAPP ORDER BY SERNUM';
      DSP.DataSet := Q;
      DSP.ResolveToDataSet := False;
      CDS.SetProvider(DSP);
      CDS.PacketRecords := -1;
      CDS.Open;
      DumpDataSetDigest(CDS, 'M_OILAPP_C2_CdsWithImg', 'SERNUM', OutLines);
    finally
      CDS.Free;
      DSP.Free;
      Q.Free;
    end;

    // 6. S_Reports BLOB Streaming
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT * FROM dbo.S_Reports';
      Q.Open;
      DumpDataSetDigest(Q, 'S_Reports', '', OutLines);
    finally
      Q.Free;
    end;

    OutLines.SaveToFile(OutputFile, TEncoding.UTF8);
    Writeln('Digest written successfully: ', OutLines.Count, ' lines');
  finally
    OutLines.Free;
    Conn.Free;
  end;
end;

// Timed Execution Functions
function MeasureQueryScan(Conn: TSQLConnection; const Sql: string; ReadBlobs: Boolean): Double;
var
  Q: TSQLQuery;
  SW: TStopwatch;
  ColCount, I: Integer;
  F: TField;
  Stream: TMemoryStream;
  V: Variant;
begin
  Stream := TMemoryStream.Create;
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := Sql;
    SW := TStopwatch.StartNew;
    Q.Open;
    ColCount := Q.FieldCount;
    while not Q.Eof do
    begin
      for I := 0 to ColCount - 1 do
      begin
        F := Q.Fields[I];
        if not F.IsNull then
        begin
          if F.IsBlob and ReadBlobs then
          begin
            Stream.Clear;
            TBlobField(F).SaveToStream(Stream);
          end
          else
            V := F.Value;
        end;
      end;
      Q.Next;
    end;
    SW.Stop;
    Result := SW.ElapsedMilliseconds;
  finally
    Q.Free;
    Stream.Free;
  end;
end;

function MeasureCdsOpen(Conn: TSQLConnection; const Sql: string): Double;
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
begin
  Q := TSQLQuery.Create(nil);
  DSP := TDataSetProvider.Create(nil);
  CDS := TClientDataSet.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := Sql;
    DSP.DataSet := Q;
    DSP.ResolveToDataSet := False;
    CDS.SetProvider(DSP);
    CDS.PacketRecords := -1;

    SW := TStopwatch.StartNew;
    CDS.Open;
    SW.Stop;
    Result := SW.ElapsedMilliseconds;
  finally
    CDS.Free;
    DSP.Free;
    Q.Free;
  end;
end;

procedure RunSingleTimedScenario(const ScenarioCode: string);
var
  Conn: TSQLConnection;
  ElapsedMs: Double;
  Sql: string;
begin
  Conn := CreateConnection;
  try
    if ScenarioCode = 'SCALAR' then
    begin
      Sql := Format(
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
      ElapsedMs := MeasureQueryScan(Conn, Sql, False);
    end
    else if ScenarioCode = 'MEMO' then
    begin
      Sql := 'SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)';
      ElapsedMs := MeasureQueryScan(Conn, Sql, False);
    end
    else if ScenarioCode = 'WIDE' then
    begin
      Sql := 'SELECT * FROM dbo.M_SYSFI2 WITH (NOLOCK)';
      ElapsedMs := MeasureQueryScan(Conn, Sql, False);
    end
    else if ScenarioCode = 'S_REPORTS' then
    begin
      Sql := 'SELECT * FROM dbo.S_Reports WITH (NOLOCK)';
      ElapsedMs := MeasureQueryScan(Conn, Sql, True);
    end
    else if ScenarioCode = 'CDS_MEMO' then
    begin
      Sql := 'SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)';
      ElapsedMs := MeasureCdsOpen(Conn, Sql);
    end
    else if ScenarioCode = 'OILAPP_A' then
    begin
      Sql := 'SELECT SERNUM, LICPLT, FUElTY, INVDATE, INVNUM, QUANTI, ACAMT, INVAM, EMPID, PAYDAT, ' +
             'CARTYP, GRCOS, TAXAM, USRID, ENTDT, ACCON01, ACUSRID, ACENTDT, TAXCODE, CONFM ' +
             'FROM dbo.M_OILAPP WITH (NOLOCK) ORDER BY SERNUM';
      ElapsedMs := MeasureQueryScan(Conn, Sql, False);
    end
    else if ScenarioCode = 'OILAPP_B' then
    begin
      Sql := 'SELECT * FROM dbo.M_OILAPP WITH (NOLOCK) ORDER BY SERNUM';
      ElapsedMs := MeasureQueryScan(Conn, Sql, True);
    end
    else if ScenarioCode = 'OILAPP_C1' then
    begin
      Sql := 'SELECT SERNUM, LICPLT, FUElTY, INVDATE, INVNUM, QUANTI, ACAMT, INVAM, EMPID, PAYDAT, ' +
             'CARTYP, GRCOS, TAXAM, USRID, ENTDT, ACCON01, ACUSRID, ACENTDT, TAXCODE, CONFM ' +
             'FROM dbo.M_OILAPP WITH (NOLOCK) ORDER BY SERNUM';
      ElapsedMs := MeasureCdsOpen(Conn, Sql);
    end
    else if ScenarioCode = 'OILAPP_C2' then
    begin
      Sql := 'SELECT * FROM dbo.M_OILAPP WITH (NOLOCK) ORDER BY SERNUM';
      ElapsedMs := MeasureCdsOpen(Conn, Sql);
    end
    else
      raise Exception.Create('Unknown scenario: ' + ScenarioCode);

    Writeln(Format('TIME_MS:%.1f', [ElapsedMs]));
  finally
    Conn.Free;
  end;
end;

procedure ProbeOilApp;
var
  Conn: TSQLConnection;
  Q: TSQLQuery;
  TotalRows, NonNullImgs, ColCount: Integer;
  TotalImgBytes: Int64;
begin
  Conn := CreateConnection;
  try
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) AS TotalRows, COUNT(INVIMG) AS NonNullImages, ' +
                    'SUM(CAST(DATALENGTH(INVIMG) AS BIGINT)) AS TotalImageBytes FROM dbo.M_OILAPP';
      Q.Open;
      TotalRows := Q.FieldByName('TotalRows').AsInteger;
      NonNullImgs := Q.FieldByName('NonNullImages').AsInteger;
      TotalImgBytes := Q.FieldByName('TotalImageBytes').AsLargeInt;
      Q.Close;

      Q.SQL.Text := 'SELECT TOP 1 * FROM dbo.M_OILAPP';
      Q.Open;
      ColCount := Q.FieldCount;

      Writeln(Format('PROBE:TotalRows=%d,ColumnCount=%d,NonNullImages=%d,TotalImageBytes=%d',
        [TotalRows, ColCount, NonNullImgs, TotalImgBytes]));
    finally
      Q.Free;
    end;
  finally
    Conn.Free;
  end;
end;

begin
  CoInitialize(nil);
  try
    if not LoadConfig then Exit;

    if (ParamCount >= 2) and (ParamStr(1) = '--dump-digest') then
      RunDigestDump(ParamStr(2))
    else if (ParamCount >= 2) and (ParamStr(1) = '--bench') then
      RunSingleTimedScenario(ParamStr(2))
    else if (ParamCount >= 1) and (ParamStr(1) = '--probe-oilapp') then
      ProbeOilApp
    else
    begin
      Writeln('Usage:');
      Writeln('  BenchComprehensive --dump-digest <output_file>');
      Writeln('  BenchComprehensive --bench <SCENARIO_CODE>');
      Writeln('  BenchComprehensive --probe-oilapp');
    end;
  finally
    CoUninitialize;
  end;
end.

