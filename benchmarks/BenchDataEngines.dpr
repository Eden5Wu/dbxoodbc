program BenchDataEngines;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  Winapi.PsAPI,
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Diagnostics,
  Data.DB,
  Data.SqlExpr,
  Data.DBXCommon,
  Data.DBXMSSQL,
  Data.DBXOdbc,
  Data.Win.ADODB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Option,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,
  FireDAC.DApt,
  Datasnap.DBClient,
  Datasnap.Provider,
  MidasLib,
  DbxOpenOdbcDriver in '..\source\DbxOpenOdbcDriver.pas';

type
  TEngineKind = (ekDbxOdbc, ekFireDac, ekAdo, ekEmbtSnc, ekEmbtOdbc);

const
  EngineNames: array[TEngineKind] of string = (
    'DBXOODBC (DBX4 Native)',
    'FireDAC (PhysMSSQL)',
    'ADO (dbGo / OLEDB)',
    'EMBT DBX (MSSQL / SNC)',
    'EMBT DBX (ODBC Generic)'
  );

var
  G_Server: string;
  G_Database: string;
  G_User: string;
  G_Password: string;
  G_OdbcDriver: string;
  G_OledbProvider: string;
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
    Writeln('================================================================================');
    Writeln(' ERROR: Configuration file not found!');
    Writeln(' Expected: ', IniPath);
    Writeln;
    Writeln(' Please copy bench_config.example.ini to bench_config.ini and customize it');
    Writeln(' with your SQL Server connection details.');
    Writeln('================================================================================');
    Exit(False);
  end;

  Ini := TIniFile.Create(IniPath);
  try
    G_Server        := Ini.ReadString('Database', 'Server', '127.0.0.1');
    G_Database      := Ini.ReadString('Database', 'Database', 'TestDB');
    G_User          := Ini.ReadString('Database', 'User', 'sa');
    G_Password      := Ini.ReadString('Database', 'Password', '');
    G_OdbcDriver    := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');
    G_OledbProvider := Ini.ReadString('Database', 'OLEDBProvider', 'SQLOLEDB');

    G_ScalarRowCount := Ini.ReadInteger('Scenarios', 'ScalarRowCount', 5000);
    G_MultiMemoTable := Ini.ReadString('Scenarios', 'MultiMemoTable', '');
    G_WideTable      := Ini.ReadString('Scenarios', 'WideTable', '');
    G_BlobTable      := Ini.ReadString('Scenarios', 'BlobTable', '');
    Result := True;
  finally
    Ini.Free;
  end;
end;

function GetProcessMemoryMB: Double;
var
  PMC: PROCESS_MEMORY_COUNTERS;
begin
  PMC.cb := SizeOf(PMC);
  if GetProcessMemoryInfo(GetCurrentProcess, @PMC, SizeOf(PMC)) then
    Result := PMC.WorkingSetSize / (1024 * 1024)
  else
    Result := 0.0;
end;

type
  TBenchContext = class
  public
    Engine: TEngineKind;
    DbxConn: TSQLConnection;
    FdConn: TFDConnection;
    AdoConn: TADOConnection;

    constructor Create(AEngine: TEngineKind);
    destructor Destroy; override;

    function CreateDataSet(const SQL: string): TDataSet;
  end;

constructor TBenchContext.Create(AEngine: TEngineKind);
begin
  inherited Create;
  Engine := AEngine;
  case Engine of
    ekDbxOdbc:
    begin
      DbxConn := TSQLConnection.Create(nil);
      DbxConn.DriverName := 'DbxOpenOdbc';
      DbxConn.LoginPrompt := False;
      DbxConn.Params.Values['ConnectionString'] := Format(
        'Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;MARS_Connection=yes;Packet Size=16384;',
        [G_OdbcDriver, G_Server, G_Database, G_User, G_Password]);
      DbxConn.Open;
    end;

    ekFireDac:
    begin
      FdConn := TFDConnection.Create(nil);
      FdConn.LoginPrompt := False;
      FdConn.DriverName := 'MSSQL';
      FdConn.Params.Values['Server'] := G_Server;
      FdConn.Params.Values['Database'] := G_Database;
      FdConn.Params.Values['User_Name'] := G_User;
      FdConn.Params.Values['Password'] := G_Password;
      FdConn.Params.Values['ODBCDriver'] := G_OdbcDriver;
      FdConn.Open;
    end;

    ekAdo:
    begin
      AdoConn := TADOConnection.Create(nil);
      AdoConn.LoginPrompt := False;
      AdoConn.ConnectionString := Format(
        'Provider=%s;Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;',
        [G_OledbProvider, G_Server, G_Database, G_User, G_Password]);
      AdoConn.Open;
    end;

    ekEmbtSnc:
    begin
      DbxConn := TSQLConnection.Create(nil);
      DbxConn.DriverName := 'MSSQL';
      DbxConn.LoginPrompt := False;
      DbxConn.Params.Values['HostName'] := G_Server;
      DbxConn.Params.Values['DataBase'] := G_Database;
      DbxConn.Params.Values['User_Name'] := G_User;
      DbxConn.Params.Values['Password'] := G_Password;
      DbxConn.Params.Values['VendorLib'] := 'sqlncli11.dll';
      DbxConn.Params.Values['BlobSize'] := '-1';
      DbxConn.Open;
    end;

    ekEmbtOdbc:
    begin
      DbxConn := TSQLConnection.Create(nil);
      DbxConn.DriverName := 'ODBC';
      DbxConn.LoginPrompt := False;
      DbxConn.Params.Values['ConnectionString'] := Format(
        'Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;MARS_Connection=yes;Packet Size=16384;',
        [G_OdbcDriver, G_Server, G_Database, G_User, G_Password]);
      DbxConn.Open;
    end;
  end;
end;

destructor TBenchContext.Destroy;
begin
  FreeAndNil(DbxConn);
  FreeAndNil(FdConn);
  FreeAndNil(AdoConn);
  inherited;
end;

function TBenchContext.CreateDataSet(const SQL: string): TDataSet;
var
  QDbx: TSQLQuery;
  QFd: TFDQuery;
  QAdo: TADOQuery;
begin
  Result := nil;
  case Engine of
    ekDbxOdbc, ekEmbtSnc, ekEmbtOdbc:
    begin
      QDbx := TSQLQuery.Create(nil);
      QDbx.SQLConnection := DbxConn;
      QDbx.SQL.Text := SQL;
      Result := QDbx;
    end;

    ekFireDac:
    begin
      QFd := TFDQuery.Create(nil);
      QFd.Connection := FdConn;
      QFd.SQL.Text := SQL;
      QFd.FetchOptions.Mode := fmOnDemand;
      Result := QFd;
    end;

    ekAdo:
    begin
      QAdo := TADOQuery.Create(nil);
      QAdo.Connection := AdoConn;
      QAdo.CursorType := ctOpenForwardOnly;
      QAdo.LockType := ltReadOnly;
      QAdo.SQL.Text := SQL;
      Result := QAdo;
    end;
  end;
end;

function RunPureReaderTest(Ctx: TBenchContext; const SQL: string; ReadBlobs: Boolean; out TotalRows, TotalCols: Integer): Double;
var
  DS: TDataSet;
  SW: TStopwatch;
  ColCount, I: Integer;
  V: Variant;
  F: TField;
  Stream: TMemoryStream;
begin
  TotalRows := 0;
  TotalCols := 0;
  Stream := TMemoryStream.Create;
  DS := Ctx.CreateDataSet(SQL);
  try
    SW := TStopwatch.StartNew;
    DS.Open;
    ColCount := DS.FieldCount;
    TotalCols := ColCount;
    while not DS.Eof do
    begin
      Inc(TotalRows);
      for I := 0 to ColCount - 1 do
      begin
        F := DS.Fields[I];
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
      DS.Next;
    end;
    SW.Stop;
    Result := SW.ElapsedMilliseconds;
  finally
    DS.Free;
    Stream.Free;
  end;
end;

function RunCdsTest(Ctx: TBenchContext; const SQL: string; out TotalRows: Integer): Double;
var
  DS: TDataSet;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
begin
  TotalRows := 0;
  DS := Ctx.CreateDataSet(SQL);
  DSP := TDataSetProvider.Create(nil);
  CDS := TClientDataSet.Create(nil);
  try
    DSP.DataSet := DS;
    DSP.ResolveToDataSet := False;
    CDS.SetProvider(DSP);
    CDS.PacketRecords := -1;

    SW := TStopwatch.StartNew;
    CDS.Open;
    SW.Stop;
    TotalRows := CDS.RecordCount;
    Result := SW.ElapsedMilliseconds;
  finally
    CDS.Free;
    DSP.Free;
    DS.Free;
  end;
end;

procedure BenchScenario(const Title, SQL: string; ReadBlobs: Boolean);
var
  E: TEngineKind;
  Ctx: TBenchContext;
  Rows, Cols, Iter: Integer;
  Ms, TotalMs, MemPeak: Double;
const
  ITER_COUNT = 3;
begin
  Writeln('>>> ' + Title + ' <<<');
  Writeln(Format('%-26s | %-12s | %-10s | %-12s | %-10s', ['Engine', 'Time (ms)', 'Rows/sec', 'us/row', 'Mem (MB)']));
  Writeln(StringOfChar('-', 80));
  for E := Low(TEngineKind) to High(TEngineKind) do
  begin
    try
      Ctx := TBenchContext.Create(E);
      try
        // Warmup
        RunPureReaderTest(Ctx, SQL, ReadBlobs, Rows, Cols);

        TotalMs := 0;
        for Iter := 1 to ITER_COUNT do
        begin
          Ms := RunPureReaderTest(Ctx, SQL, ReadBlobs, Rows, Cols);
          TotalMs := TotalMs + Ms;
        end;
        Ms := TotalMs / ITER_COUNT;
        MemPeak := GetProcessMemoryMB;

        Writeln(Format('%-26s | %10.1f ms | %10.0f | %9.2f us | %7.1f MB', [
          EngineNames[E],
          Ms,
          (Rows / (Ms / 1000.0)),
          (Ms * 1000.0 / Rows),
          MemPeak
        ]));
      finally
        Ctx.Free;
      end;
    except
      on Ex: Exception do
        Writeln(Format('%-26s | EXCEPTION: %s', [EngineNames[E], Ex.Message]));
    end;
  end;
  Writeln;
end;

procedure BenchDataSnapScenario(const Title, SQL: string);
var
  E: TEngineKind;
  Ctx: TBenchContext;
  Rows, Iter: Integer;
  Ms, TotalMs, MemPeak: Double;
const
  ITER_COUNT = 3;
begin
  Writeln('>>> ' + Title + ' <<<');
  Writeln(Format('%-26s | %-12s | %-10s | %-12s | %-10s', ['Engine', 'Time (ms)', 'Rows/sec', 'us/row', 'Mem (MB)']));
  Writeln(StringOfChar('-', 80));
  for E := Low(TEngineKind) to High(TEngineKind) do
  begin
    try
      Ctx := TBenchContext.Create(E);
      try
        // Warmup
        RunCdsTest(Ctx, SQL, Rows);

        TotalMs := 0;
        for Iter := 1 to ITER_COUNT do
        begin
          Ms := RunCdsTest(Ctx, SQL, Rows);
          TotalMs := TotalMs + Ms;
        end;
        Ms := TotalMs / ITER_COUNT;
        MemPeak := GetProcessMemoryMB;

        Writeln(Format('%-26s | %10.1f ms | %10.0f | %9.2f us | %7.1f MB', [
          EngineNames[E],
          Ms,
          (Rows / (Ms / 1000.0)),
          (Ms * 1000.0 / Rows),
          MemPeak
        ]));
      finally
        Ctx.Free;
      end;
    except
      on Ex: Exception do
        Writeln(Format('%-26s | EXCEPTION: %s', [EngineNames[E], Ex.Message]));
    end;
  end;
  Writeln;
end;

var
  SqlScalar5K: string;
begin
  CoInitialize(nil);
  try
    Writeln('================================================================================');
    Writeln(' DELPHI FIVE-ENGINE BENCHMARK (2026 Edition)');
    Writeln(' Engines: DBXOODBC | FireDAC | ADO | EMBT SNC | EMBT ODBC');
    Writeln('================================================================================');
    Writeln;

    if not LoadConfig then
      Exit;

    Writeln(Format('Connecting to Server: %s | Database: %s', [G_Server, G_Database]));
    Writeln;

    // Scenario 1: Always executable synthetic scalar test
    SqlScalar5K :=
      Format('SELECT TOP %d ' +
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

    BenchScenario(
      Format('Scenario 1: Pure Reader (%d rows x 10 scalar columns)', [G_ScalarRowCount]),
      SqlScalar5K, False);

    // Scenario 2: Multi-Memo Table (Optional)
    if G_MultiMemoTable <> '' then
      BenchScenario(
        'Scenario 2: Memo/LOB Intensive (Table: ' + G_MultiMemoTable + ')',
        'SELECT TOP 3000 * FROM ' + G_MultiMemoTable + ' WITH (NOLOCK)', False)
    else
      Writeln('Scenario 2: [SKIPPED] MultiMemoTable not configured in bench_config.ini'#13#10);

    // Scenario 3: Wide Table (Optional)
    if G_WideTable <> '' then
      BenchScenario(
        'Scenario 3: Wide Table (Table: ' + G_WideTable + ')',
        'SELECT * FROM ' + G_WideTable + ' WITH (NOLOCK)', False)
    else
      Writeln('Scenario 3: [SKIPPED] WideTable not configured in bench_config.ini'#13#10);

    // Scenario 4: BLOB Table (Optional)
    if G_BlobTable <> '' then
      BenchScenario(
        'Scenario 4: BLOB Streaming (Table: ' + G_BlobTable + ')',
        'SELECT * FROM ' + G_BlobTable + ' WITH (NOLOCK)', True)
    else
      Writeln('Scenario 4: [SKIPPED] BlobTable not configured in bench_config.ini'#13#10);

    // Scenario 5: DataSnap Simulation (Optional)
    if G_MultiMemoTable <> '' then
      BenchDataSnapScenario(
        'Scenario 5: DataSnap Real Simulation (DSP -> CDS.Open, Table: ' + G_MultiMemoTable + ')',
        'SELECT TOP 3000 * FROM ' + G_MultiMemoTable + ' WITH (NOLOCK)')
    else
      Writeln('Scenario 5: [SKIPPED] MultiMemoTable not configured in bench_config.ini'#13#10);

    Writeln('================================================================================');
    Writeln(' ALL BENCHMARK SCENARIOS COMPLETED');
    Writeln('================================================================================');
  finally
    CoUninitialize;
  end;
end.

