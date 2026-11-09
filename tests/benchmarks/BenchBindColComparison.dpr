program BenchBindColComparison;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  Winapi.PsAPI,
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  Data.DB,
  Data.DBXCommon,
  Data.SqlExpr,
  Datasnap.Provider,
  Datasnap.DBClient,
  MidasLib,
  OdbcApi in 'd:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\source\OdbcApi.pas',
  DbxOpenOdbcCore in 'd:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in 'd:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\source\DbxOpenOdbcDriver.pas';

var
  GConnStr: string;

function CreateConn(UseBindCol: Boolean): TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.DriverName := 'DbxOpenOdbc';
  Result.LoginPrompt := False;
  Result.Params.Values['DriverName'] := 'DbxOpenOdbc';
  Result.Params.Values['ConnectionString'] := GConnStr;
  if UseBindCol then
    Result.Params.Values['UseBindCol'] := 'True'
  else
    Result.Params.Values['UseBindCol'] := 'False';
  Result.Open;
end;

type
  TBenchResult = record
    RowCount: Integer;
    ReaderMs: Int64;
    CdsMs: Int64;
  end;

function RunBenchmark(C: TSQLConnection; const SQL: string; TestCDS: Boolean = True): TBenchResult;
var
  Q: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  SW: TStopwatch;
  Cmd: TDBXCommand;
  Rdr: TDBXReader;
  Cnt: Integer;
begin
  Result := Default(TBenchResult);

  // 1. Direct Low-Level DBX Reader
  Cmd := C.DBXConnection.CreateCommand;
  try
    Cmd.Text := SQL;
    Cmd.CommandType := TDBXCommandTypes.DbxSQL;
    SW := TStopwatch.StartNew;
    Rdr := Cmd.ExecuteQuery;
    try
      Cnt := 0;
      while Rdr.Next do
      begin
        Inc(Cnt);
        for var i := 0 to Rdr.ColumnCount - 1 do
        begin
          if not Rdr.Value[i].IsNull then
          begin
            case Rdr.Value[i].ValueType.DataType of
              TDBXDataTypes.Int32Type: Rdr.Value[i].AsInt32;
              TDBXDataTypes.Int64Type: Rdr.Value[i].AsInt64;
              TDBXDataTypes.DoubleType: Rdr.Value[i].AsDouble;
              TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType: Rdr.Value[i].AsString;
            end;
          end;
        end;
      end;
      SW.Stop;
      Result.RowCount := Cnt;
      Result.ReaderMs := SW.ElapsedMilliseconds;
    finally
      Rdr.Free;
    end;
  finally
    Cmd.Free;
  end;

  // 2. High-Level TSQLQuery -> DSP -> CDS
  if TestCDS then
  begin
    Q := TSQLQuery.Create(nil);
    try
      Q.SQLConnection := C;
      Q.SQL.Text := SQL;
      DSP := TDataSetProvider.Create(nil);
      try
        DSP.DataSet := Q;
        CDS := TClientDataSet.Create(nil);
        try
          CDS.SetProvider(DSP);
          SW := TStopwatch.StartNew;
          CDS.Open;
          SW.Stop;
          Result.CdsMs := SW.ElapsedMilliseconds;
          CDS.Close;
        finally
          CDS.Free;
        end;
      finally
        DSP.Free;
      end;
    finally
      Q.Free;
    end;
  end;
end;

procedure CompareDataCorrectness(const SQL: string; const LabelName: string);
var
  C0, C1: TSQLConnection;
  Cmd0, Cmd1: TDBXCommand;
  R0, R1: TDBXReader;
  RowIdx, ColIdx: Integer;
  MismatchCount: Integer;
begin
  Write(Format('  [*] Verifying correctness on %s ... ', [LabelName]));
  Flush(Output);
  C0 := CreateConn(False);
  C1 := CreateConn(True);
  try
    Cmd0 := C0.DBXConnection.CreateCommand;
    Cmd1 := C1.DBXConnection.CreateCommand;
    try
      Cmd0.Text := SQL;
      Cmd1.Text := SQL;
      R0 := Cmd0.ExecuteQuery;
      R1 := Cmd1.ExecuteQuery;
      try
        if R0.ColumnCount <> R1.ColumnCount then
          raise Exception.CreateFmt('Column count mismatch: %d vs %d', [R0.ColumnCount, R1.ColumnCount]);

        RowIdx := 0;
        MismatchCount := 0;
        while R0.Next do
        begin
          if not R1.Next then
            raise Exception.CreateFmt('Row count mismatch at row %d', [RowIdx]);
          Inc(RowIdx);

          for ColIdx := 0 to R0.ColumnCount - 1 do
          begin
            if R0.Value[ColIdx].IsNull <> R1.Value[ColIdx].IsNull then
              Inc(MismatchCount)
            else if not R0.Value[ColIdx].IsNull then
            begin
              case R0.Value[ColIdx].ValueType.DataType of
                TDBXDataTypes.Int32Type:
                  if R0.Value[ColIdx].AsInt32 <> R1.Value[ColIdx].AsInt32 then Inc(MismatchCount);
                TDBXDataTypes.Int64Type:
                  if R0.Value[ColIdx].AsInt64 <> R1.Value[ColIdx].AsInt64 then Inc(MismatchCount);
                TDBXDataTypes.DoubleType:
                  if Abs(R0.Value[ColIdx].AsDouble - R1.Value[ColIdx].AsDouble) > 0.0001 then Inc(MismatchCount);
                TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType:
                  if R0.Value[ColIdx].AsString <> R1.Value[ColIdx].AsString then Inc(MismatchCount);
              end;
            end;
          end;
        end;

        if R1.Next then
          raise Exception.Create('R1 has more rows than R0');

        if MismatchCount = 0 then
          Writeln(Format('VERIFIED PERFECT MATCH (%d rows x %d cols)', [RowIdx, R0.ColumnCount]))
        else
          Writeln(Format('FAILED (%d mismatches)', [MismatchCount]));
        Flush(Output);
      finally
        R0.Free;
        R1.Free;
      end;
    finally
      Cmd0.Free;
      Cmd1.Free;
    end;
  finally
    C0.Free;
    C1.Free;
  end;
end;

procedure RunComparison;
var
  C0, C1: TSQLConnection;
  R0, R1: TBenchResult;
  DiffRdr, DiffCds: Double;

  procedure CompareCase(const SQL: string; const CaseName: string; TestCDS: Boolean = True);
  begin
    Writeln(Format('--- Test: %s ---', [CaseName]));
    Flush(Output);
    // Warm up
    RunBenchmark(C0, SQL, False);
    RunBenchmark(C1, SQL, False);

    // Measure UseBindCol=0
    R0 := RunBenchmark(C0, SQL, TestCDS);
    // Measure UseBindCol=1
    R1 := RunBenchmark(C1, SQL, TestCDS);

    if R0.ReaderMs > 0 then
      DiffRdr := ((R1.ReaderMs - R0.ReaderMs) / R0.ReaderMs) * 100
    else
      DiffRdr := 0;

    if (R0.CdsMs > 0) and TestCDS then
      DiffCds := ((R1.CdsMs - R0.CdsMs) / R0.CdsMs) * 100
    else
      DiffCds := 0;

    Writeln(Format('  Rows: %d', [R0.RowCount]));
    Writeln(Format('  [Pure Reader]  UseBindCol=0: %4d ms  |  UseBindCol=1: %4d ms  |  Diff: %+6.1f%%',
      [R0.ReaderMs, R1.ReaderMs, DiffRdr]));
    if TestCDS then
      Writeln(Format('  [DSP -> CDS]   UseBindCol=0: %4d ms  |  UseBindCol=1: %4d ms  |  Diff: %+6.1f%%',
        [R0.CdsMs, R1.CdsMs, DiffCds]));
    Writeln;
    Flush(Output);
  end;

  function TableExists(C: TSQLConnection; const TableName: string): Boolean;
  var
    Cmd: TDBXCommand;
    Rdr: TDBXReader;
  begin
    Result := False;
    try
      Cmd := C.DBXConnection.CreateCommand;
      try
        Cmd.Text := Format('SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(''%s'')', [TableName]);
        Rdr := Cmd.ExecuteQuery;
        try
          Result := Rdr.Next;
        finally
          Rdr.Free;
        end;
      finally
        Cmd.Free;
      end;
    except
      Result := False;
    end;
  end;

begin
  Writeln('================================================================');
  Writeln(' BENCHMARK: SQLBindCol Bound Prefix vs Pure SQLGetData');
  Writeln(' Target: Standard Test Environment');
  Writeln('================================================================');
  Writeln;
  Flush(Output);

  // 1. Correctness Checks
  Writeln('=== Phase 1: Data Integrity Verification ===');
  CompareDataCorrectness(
    'SELECT TOP 5000 1 AS ID, 2 AS C1, 3.14 AS C2, 100 AS C3, 200 AS C4, 300 AS C5, 400 AS C6, 500 AS C7, 600 AS C8, 700 AS C9 FROM sys.all_columns a CROSS JOIN sys.all_columns b',
    'Synthetic 10-Scalar Table');

  C0 := CreateConn(False);
  C1 := CreateConn(True);
  try
    if TableExists(C0, 'dbo.M_SYSFIL') then
      CompareDataCorrectness('SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)', 'Enterprise_Metadata_Table (76 cols)');
    if TableExists(C0, 'dbo.M_SYSFI2') then
      CompareDataCorrectness('SELECT * FROM dbo.M_SYSFI2 WITH (NOLOCK)', 'Enterprise_Wide_Table (210 cols)');
    if TableExists(C0, 'dbo.S_Reports') then
      CompareDataCorrectness('SELECT * FROM dbo.S_Reports WITH (NOLOCK)', 'Report_Templates_Table (BLOBs)');
    Writeln;
    Flush(Output);

    // 2. Throughput Benchmarks
    Writeln('=== Phase 2: Performance Comparison ===');
    CompareCase(
      'SELECT TOP 20000 1 AS ID, 2 AS C1, 3.14 AS C2, 100 AS C3, 200 AS C4, 300 AS C5, 400 AS C6, 500 AS C7, 600 AS C8, 700 AS C9 FROM sys.all_columns a CROSS JOIN sys.all_columns b',
      'Synthetic 20,000 rows x 10 Scalars (100% Bound Prefix)');

    if TableExists(C0, 'dbo.M_SYSFIL') then
      CompareCase(
        'SELECT TOP 3000 * FROM dbo.M_SYSFIL WITH (NOLOCK)',
        'Enterprise_Metadata_Table (3,000 rows, 76 cols, 23 bound prefix cols)');

    if TableExists(C0, 'dbo.M_SYSFI2') then
      CompareCase(
        'SELECT * FROM dbo.M_SYSFI2 WITH (NOLOCK)',
        'Enterprise_Wide_Table (610 rows, 210 cols wide table)');

    if TableExists(C0, 'dbo.S_Reports') then
      CompareCase(
        'SELECT * FROM dbo.S_Reports WITH (NOLOCK)',
        'Report_Templates_Table (57 rows, BLOB templates)');

    if TableExists(C0, 'dbo.M_OILAPP') then
      CompareCase(
        'SELECT * FROM dbo.M_OILAPP WITH (NOLOCK)',
        'Document_Images_Table (342 rows, 320 MB Image BLOBs)', False);
  finally
    C0.Free;
    C1.Free;
  end;
end;

begin
  SetConsoleOutputCP(CP_UTF8);
  ReportMemoryLeaksOnShutdown := True;

  GConnStr := GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION');
  if GConnStr = '' then
    GConnStr := ParamStr(1);
  if GConnStr = '' then
  begin
    Writeln('Usage: BenchBindColComparison "<ConnectionString>" or set DBXOODBC_TEST_CONNECTION environment variable.');
    Writeln('Example: BenchBindColComparison "Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=TestDB;Trusted_Connection=yes;MARS_Connection=yes;"');
    Exit;
  end;

  try
    RunComparison;
  except
    on E: Exception do
    begin
      Writeln('[FATAL ERROR] ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
