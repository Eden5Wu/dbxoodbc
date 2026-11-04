program OdbcCatalogProbe;

{$APPTYPE CONSOLE}

// Read-only inspection of raw ODBC results, without DBX metadata conversion.
uses
  System.SysUtils,
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas';

procedure ShowTables(Statement: TOdbcStatementHandle; const Catalog, Schema: string);
var
  CatalogName, SchemaName, TableName, TableType: string;
  IsNull: LongBool;
  Count: Integer;
begin
  Statement.ExecuteCatalogTables(Catalog, Schema, '%', 'TABLE');
  Count := 0;
  while Statement.FetchNext do
  begin
    Statement.GetWideString(1, CatalogName, IsNull);
    Statement.GetWideString(2, SchemaName, IsNull);
    Statement.GetWideString(3, TableName, IsNull);
    Statement.GetWideString(4, TableType, IsNull);
    Writeln('  ', CatalogName, '.', SchemaName, '.', TableName, ' [', TableType, ']');
    Inc(Count);
  end;
  Statement.FreeStatement;
  Writeln('  TABLE count (schema=', Schema, '): ', Count);
end;

var
  Environment: TOdbcEnvHandle;
  Connection: TOdbcConnectionHandle;
  Statement: TOdbcStatementHandle;
  Catalog, ProcedureName: string;
  IsNull: LongBool;
  ProcedureType: Integer;
begin
  try
    if GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION') = '' then
      raise Exception.Create('Set DBXOODBC_TEST_CONNECTION');
    Environment := TOdbcEnvHandle.Create;
    try
      Connection := TOdbcConnectionHandle.Create(Environment, False);
      try
        Connection.Connect(GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION'));
        Writeln('Driver: ', Connection.DriverName, ' / ', Connection.DriverVersion);
        Statement := TOdbcStatementHandle.Create(Connection);
        try
          Statement.ExecuteDirect('SELECT DB_NAME()');
          Statement.FetchNext;
          Statement.GetWideString(1, Catalog, IsNull);
          Statement.FreeStatement;
          ShowTables(Statement, Catalog, '');
          ShowTables(Statement, Catalog, 'dbo');
          ShowTables(Statement, Catalog, 'sys');
          Statement.ExecuteCatalogProcedures(Catalog, 'dbo', '%');
          while Statement.FetchNext do
          begin
            Statement.GetWideString(3, ProcedureName, IsNull);
            Statement.GetInt32(8, ProcedureType, IsNull);
            Writeln('  Procedure ', ProcedureName, ' / ODBC PROCEDURE_TYPE=', ProcedureType);
          end;
        finally Statement.Free end;
      finally Connection.Free end;
    finally Environment.Free end;
    Flush(Output);
  except
    on E: Exception do
    begin Writeln('[FAIL] ', E.ClassName, ': ', E.Message); Flush(Output); ExitCode := 1 end;
  end;
end.
