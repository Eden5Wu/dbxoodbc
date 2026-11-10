program TestOilApp;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.SysUtils,
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
  if not FileExists(IniPath) then
  begin
    Writeln('ERROR: bench_config.ini not found!');
    Exit(False);
  end;
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

procedure TestOilAppProbe(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  TotalRows, NonNullImgs: Integer;
  TotalImgBytes: Int64;
begin
  Writeln('=== Probing dbo.M_OILAPP Metadata & Counts ===');
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

    // Get column count
    Q.SQL.Text := 'SELECT TOP 1 * FROM dbo.M_OILAPP';
    Q.Open;
    var ColCount := Q.FieldCount;
    Q.Close;

    Writeln(Format('  TotalRows        : %d', [TotalRows]));
    Writeln(Format('  ColumnCount      : %d', [ColCount]));
    Writeln(Format('  NonNull INVIMG   : %d', [NonNullImgs]));
    Writeln(Format('  Total Image Bytes: %d bytes (%.2f MB)', [TotalImgBytes, TotalImgBytes / (1024.0 * 1024.0)]));
  finally
    Q.Free;
  end;
end;

procedure TestQueryNoImage(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  SW: TStopwatch;
  Rows: Integer;
begin
  Writeln('=== Scenario A: TSQLQuery without INVIMG ===');
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := 'SELECT SERNUM, LICPLT, FUElTY, INVDATE, INVNUM, QUANTI, ACAMT, INVAM, EMPID, PAYDAT, ' +
                  'CARTYP, GRCOS, TAXAM, USRID, ENTDT, ACCON01, ACUSRID, ACENTDT, TAXCODE, CONFM ' +
                  'FROM dbo.M_OILAPP ORDER BY SERNUM';
    SW := TStopwatch.StartNew;
    Q.Open;
    Rows := 0;
    while not Q.Eof do
    begin
      Inc(Rows);
      for var i := 0 to Q.FieldCount - 1 do
        var V := Q.Fields[i].Value;
      Q.Next;
    end;
    SW.Stop;
    Writeln(Format('  Fetched %d rows in %d ms', [Rows, SW.ElapsedMilliseconds]));
  finally
    Q.Free;
  end;
end;

procedure TestQueryWithImage(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  SW: TStopwatch;
  Rows, ImgCount: Integer;
  Stream: TMemoryStream;
  CarTypVal: Variant;
  TotalBytesRead: Int64;
begin
  Writeln('=== Scenario B: TSQLQuery with INVIMG (Full Column Order) ===');
  Stream := TMemoryStream.Create;
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := Conn;
    Q.SQL.Text := 'SELECT * FROM dbo.M_OILAPP ORDER BY SERNUM';
    SW := TStopwatch.StartNew;
    Q.Open;
    Rows := 0;
    ImgCount := 0;
    TotalBytesRead := 0;
    while not Q.Eof do
    begin
      Inc(Rows);
      // Read fields before INVIMG
      for var i := 0 to 9 do
        var V := Q.Fields[i].Value;

      // Read INVIMG (Field 10)
      if not Q.Fields[10].IsNull then
      begin
        Stream.Clear;
        TBlobField(Q.Fields[10]).SaveToStream(Stream);
        Inc(ImgCount);
        Inc(TotalBytesRead, Stream.Size);
      end;

      // Read fields after INVIMG (Field 11 to 20, starting with CARTYP)
      CarTypVal := Q.Fields[11].Value; // CARTYP
      for var i := 12 to Q.FieldCount - 1 do
        var V2 := Q.Fields[i].Value;

      Q.Next;
    end;
    SW.Stop;
    Writeln(Format('  Fetched %d rows (%d images, %d bytes) in %d ms',
      [Rows, ImgCount, TotalBytesRead, SW.ElapsedMilliseconds]));
  finally
    Q.Free;
    Stream.Free;
  end;
end;

procedure TestCdsNoImage(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
begin
  Writeln('=== Scenario C1: DSP -> ClientDataSet without INVIMG ===');
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

    SW := TStopwatch.StartNew;
    CDS.Open;
    SW.Stop;
    Writeln(Format('  CDS.Open fetched %d records in %d ms', [CDS.RecordCount, SW.ElapsedMilliseconds]));
  finally
    CDS.Free;
    DSP.Free;
    Q.Free;
  end;
end;

procedure TestCdsWithImage(Conn: TSQLConnection);
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
  ImgBytesCount: Int64;
  Stream: TMemoryStream;
begin
  Writeln('=== Scenario C2: DSP -> ClientDataSet with INVIMG ===');
  Stream := TMemoryStream.Create;
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

    SW := TStopwatch.StartNew;
    CDS.Open;
    SW.Stop;
    Writeln(Format('  CDS.Open fetched %d records in %d ms', [CDS.RecordCount, SW.ElapsedMilliseconds]));

    // Verify images inside CDS
    ImgBytesCount := 0;
    CDS.First;
    while not CDS.Eof do
    begin
      if not CDS.FieldByName('INVIMG').IsNull then
      begin
        Stream.Clear;
        TBlobField(CDS.FieldByName('INVIMG')).SaveToStream(Stream);
        Inc(ImgBytesCount, Stream.Size);
      end;
      CDS.Next;
    end;
    Writeln(Format('  Verified images inside CDS: total %d bytes', [ImgBytesCount]));
  finally
    CDS.Free;
    DSP.Free;
    Q.Free;
    Stream.Free;
  end;
end;

var
  Conn: TSQLConnection;
begin
  CoInitialize(nil);
  try
    if not LoadConfig then Exit;
    Conn := CreateConnection;
    try
      TestOilAppProbe(Conn);
      TestQueryNoImage(Conn);
      TestQueryWithImage(Conn);
      TestCdsNoImage(Conn);
      TestCdsWithImage(Conn);
    finally
      Conn.Free;
    end;
  finally
    CoUninitialize;
  end;
end.

