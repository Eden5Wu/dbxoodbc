program Dbx4MvpTester;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Data.DB,
  Data.DBXCommon,
  Data.SqlExpr,
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas';

function BuildTestConnectionString(out MdbPath: string): string;
var
  BaseDir: string;
begin
  BaseDir := ExtractFilePath(ParamStr(0));
  MdbPath := ExpandFileName(BaseDir + '..\..\demos\dbms\msaccess\sql\dbdemos.mdb');
  if not FileExists(MdbPath) then
    MdbPath := 'D:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\demos\dbms\msaccess\sql\dbdemos.mdb';

  {$IFDEF WIN64}
  Result := 'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + MdbPath + ';ReadOnly=1;';
  {$ELSE}
  Result := 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=' + MdbPath + ';ReadOnly=1;';
  {$ENDIF}
end;

procedure RunLowLevelDBX4Test(const ConnStr: string);
var
  Props: TDBXProperties;
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
begin
  Writeln('=== [Test 1] Low-Level Native DBX4 API (TDBXConnection / TDBXCommand / TDBXReader) ===');
  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;

    Conn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Writeln('  [+] Connected via Native DBX4 Driver!');
      Writeln('  [+] ProductName    : ', Conn.ProductName);
      Writeln('  [+] ProductVersion : ', Conn.ProductVersion);
      Writeln('  [+] DriverVersion  : ', Conn.GetVendorProperty('DriverVersion'));
      Writeln('  [+] QuoteChar      : ', Conn.DatabaseMetaData.QuoteChar);

      Cmd := Conn.CreateCommand;
      try
        Cmd.CommandType := TDBXCommandTypes.DbxMetaData;
        Cmd.Text := 'GetTables';
        Reader := Cmd.ExecuteQuery;
        try
          Writeln('  [+] MetaData GetTables ColumnCount = ', Reader.ColumnCount);
          for var c := 0 to Reader.ColumnCount - 1 do
            Write(Reader.ValueType[c].Name, ' | ');
          Writeln;
          var MetaRowCount := 0;
          while Reader.Next do
          begin
            Inc(MetaRowCount);
            if MetaRowCount <= 5 then
              Writeln(Format('      Table[%d]: %s (Type: %s)', [
                MetaRowCount,
                Reader.Value[2].AsString,
                Reader.Value[3].AsString
              ]));
          end;
          Writeln('  [+] MetaData GetTables Total rows: ', MetaRowCount);
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT 1 AS TestInt, ''NativeDBX4_OK'' AS TestStr';
        Reader := Cmd.ExecuteQuery;
        try
          if Reader = nil then
            raise Exception.Create('Reader is nil for SELECT 1');
          if not Reader.Next then
            raise Exception.Create('Reader.Next returned False for SELECT 1');

          Writeln('  [+] Executed SQL   : ', Cmd.Text);
          Writeln('  [+] ColumnCount    : ', Reader.ColumnCount);
          Writeln('  [+] Column[0] Name : ', Reader.ValueType[0].Name, ' = ', Reader.Value[0].AsInt32);
          Writeln('  [+] Column[1] Name : ', Reader.ValueType[1].Name, ' = ', Reader.Value[1].AsString);

          if Reader.Value[0].AsInt32 <> 1 then
            raise Exception.CreateFmt('Unexpected Column[0] value: %d', [Reader.Value[0].AsInt32]);
          if Reader.Value[1].AsString <> 'NativeDBX4_OK' then
            raise Exception.CreateFmt('Unexpected Column[1] value: %s', [Reader.Value[1].AsString]);
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;
    finally
      Conn.Free;
    end;
  finally
    Props.Free;
  end;
  Writeln('  [PASS] Low-Level Native DBX4 Test Succeeded!');
  Writeln;
end;

procedure RunHighLevelTSQLConnectionTest(const ConnStr: string);
var
  SQLConn: TSQLConnection;
  SQLQuery: TSQLQuery;
  RowCount: Integer;
begin
  Writeln('=== [Test 2] High-Level VCL dbExpress (TSQLConnection + TSQLQuery) ===');
  SQLConn := TSQLConnection.Create(nil);
  try
    SQLConn.DriverName := sDbxOpenOdbcDriverName;
    SQLConn.LoginPrompt := False;
    SQLConn.Params.Clear;
    SQLConn.Params.Values[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    SQLConn.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;

    SQLConn.Open;
    Writeln('  [+] TSQLConnection.Open Succeeded!');

    // Test Transaction Support
    Writeln('  [+] Testing Transaction Begin & Commit...');
    var Tran := SQLConn.BeginTransaction;
    if Tran = nil then
      raise Exception.Create('BeginTransaction returned nil');
    SQLConn.CommitFreeAndNil(Tran);
    Writeln('  [+] Transaction Commit Succeeded!');

    Writeln('  [+] Testing Transaction Begin & Rollback...');
    Tran := SQLConn.BeginTransaction;
    if Tran = nil then
      raise Exception.Create('BeginTransaction returned nil');
    SQLConn.RollbackFreeAndNil(Tran);
    Writeln('  [+] Transaction Rollback Succeeded!');

    // Test Schema: GetTableNames & GetFieldNames
    var TableList := TStringList.Create;
    var FieldList := TStringList.Create;
    try
      SQLConn.GetTableNames(TableList, False);
      Writeln('  [+] GetTableNames Succeeded! Total tables: ', TableList.Count);
      if TableList.Count > 0 then
        Writeln('      Sample tables: ', TableList.CommaText);

      SQLConn.GetFieldNames('customer', FieldList);
      Writeln('  [+] GetFieldNames(customer) Succeeded! Total fields: ', FieldList.Count);
      if FieldList.Count > 0 then
        Writeln('      Fields: ', FieldList.CommaText);
    finally
      TableList.Free;
      FieldList.Free;
    end;

    SQLQuery := TSQLQuery.Create(nil);
    try
      SQLQuery.SQLConnection := SQLConn;
      SQLQuery.SQL.Text := 'SELECT CustNo, Company, Country FROM customer WHERE CustNo < 1300 ORDER BY CustNo';
      SQLQuery.Open;
      RowCount := 0;
      while not SQLQuery.Eof do
      begin
        Inc(RowCount);
        if RowCount <= 3 then
          Writeln(Format('  [Row %d] CustNo=%s | Company=%s | Country=%s', [
            RowCount,
            SQLQuery.FieldByName('CustNo').AsString,
            SQLQuery.FieldByName('Company').AsString,
            SQLQuery.FieldByName('Country').AsString
          ]));
        SQLQuery.Next;
      end;
      Writeln('  [+] Total rows fetched from customer table: ', RowCount);
      if RowCount = 0 then
        raise Exception.Create('Expected rows from customer table, got 0');
      SQLQuery.Close;
    finally
      SQLQuery.Free;
    end;

    SQLConn.Close;
  finally
    SQLConn.Free;
  end;
  Writeln('  [PASS] High-Level TSQLConnection + TSQLQuery Test Succeeded!');
  Writeln;
end;

var
  ConnStr, MdbPath: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    Writeln('================================================================');
    Writeln(' dbxoodbc Native DBX4 Driver MVP Verification');
    {$IFDEF WIN64}
    Writeln(' Platform: Win64 (64-bit Native)');
    {$ELSE}
    Writeln(' Platform: Win32 (32-bit Native)');
    {$ENDIF}
    Writeln('================================================================');

    if GetModuleHandle('dbxadapter30.dll') <> 0 then
      raise Exception.Create('Error: dbxadapter30.dll is loaded!');
    if GetModuleHandle('dbxoodbc.dll') <> 0 then
      raise Exception.Create('Error: dbxoodbc.dll is loaded!');
    Writeln('[Check] Zero external DBX3 DLLs (dbxadapter30.dll / dbxoodbc.dll): VERIFIED');
    Writeln;

    ConnStr := BuildTestConnectionString(MdbPath);
    Writeln('Using MDB: ', MdbPath);
    Writeln('Using ODBC ConnectionString: ', ConnStr);
    Writeln;

    RunLowLevelDBX4Test(ConnStr);
    RunHighLevelTSQLConnectionTest(ConnStr);

    if GetModuleHandle('dbxadapter30.dll') <> 0 then
      raise Exception.Create('Error: dbxadapter30.dll was loaded during test!');
    if GetModuleHandle('dbxoodbc.dll') <> 0 then
      raise Exception.Create('Error: dbxoodbc.dll was loaded during test!');

    Writeln('================================================================');
    Writeln(' ALL MILESTONE 1 MVP TESTS PASSED SUCCESSFULLY!');
    Writeln('================================================================');
    ExitCode := 0;
  except
    on E: Exception do
    begin
      Writeln('[FAIL] ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
