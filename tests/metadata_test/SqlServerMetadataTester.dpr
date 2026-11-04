program SqlServerMetadataTester;

{$APPTYPE CONSOLE}

// Credentials are supplied only in the process environment, never in this file.
uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Data.DBXCommon,
  Data.SqlExpr,
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas';

function ReadNames(Connection: TDBXConnection; const Kind, Text: string;
  FullNames: Boolean = True): TStringList;
var
  Command: TDBXCommand;
  Reader: TDBXReader;
begin
  Result := TStringList.Create;
  try
    Result.Sorted := True;
    Command := Connection.CreateCommand;
    try
      Command.CommandType := Kind;
      Command.Text := Text;
      Reader := Command.ExecuteQuery;
      try
        while Reader.Next do
        begin
          if FullNames then
            Result.Add(Reader.Value[0].AsString + '.' + Reader.Value[1].AsString + '.' + Reader.Value[2].AsString)
          else Result.Add(Reader.Value[2].AsString);
          if (Kind = TDBXCommandTypes.DbxMetaData) and
            (GetEnvironmentVariable('DBXOODBC_INSPECT') = '1') then
            Writeln('[META] ', Reader.Value[1].AsString, '.', Reader.Value[2].AsString,
              ' [', Reader.Value[3].AsString, ']');
        end;
      finally Reader.Free end;
    finally Command.Free end;
  except
    Result.Free;
    raise;
  end;
end;

procedure CompareNames(Connection: TDBXConnection; const CommandText, ReferenceSQL: string);
var
  Actual, Expected: TStringList;
begin
  Expected := ReadNames(Connection, TDBXCommandTypes.DbxSQL, ReferenceSQL);
  try
    Actual := ReadNames(Connection, TDBXCommandTypes.DbxMetaData, CommandText);
    try
      if Actual.Text <> Expected.Text then
        raise Exception.CreateFmt('%s mismatch. Expected: %s; actual: %s',
          [CommandText, Expected.CommaText, Actual.CommaText]);
      Writeln('[PASS] ', CommandText, ' => ', Actual.Count, ' objects');
      if Actual.Count <= 5 then Writeln('       ', Actual.CommaText);
      Flush(Output);
    finally Actual.Free end;
  finally Expected.Free end;
end;

procedure CheckScopes(Connection: TSQLConnection; const Identifier: string);
var
  Mask: Integer;
  Scopes: TTableScopes;
  Types, Predicate, SQL: string;
  Actual, Expected: TStringList;

  procedure IncludeType(const TypeName, Condition: string);
  begin
    Types := Types+TypeName+';';
    if Predicate <> '' then Predicate := Predicate+' OR ';
    Predicate := Predicate+'('+Condition+')';
  end;

begin
  for Mask := 0 to 15 do
  begin
    Scopes := [];
    Types := '';
    Predicate := '';
    if Mask and 1 <> 0 then
    begin
      Include(Scopes, tsSynonym);
      IncludeType('Synonym', 'o.type=''SN''');
    end;
    if Mask and 2 <> 0 then
    begin
      Include(Scopes, tsSysTable);
      IncludeType('SystemTable', 'o.type IN (''U'',''S'',''IT'') AND o.is_ms_shipped=1');
    end;
    if Mask and 4 <> 0 then
    begin
      Include(Scopes, tsTable);
      IncludeType('Table', 'o.type=''U'' AND o.is_ms_shipped=0');
    end;
    if Mask and 8 <> 0 then
    begin
      Include(Scopes, tsView);
      IncludeType('View', 'o.type=''V'' AND o.is_ms_shipped=0');
    end;
    // DBX's empty type list means all types, including system views.
    if Predicate = '' then Predicate := 'o.type IN (''U'',''V'',''S'',''IT'',''SN'')';
    SQL := 'SELECT DB_NAME(),s.name,o.name FROM sys.objects o JOIN sys.schemas s '+
      'ON s.schema_id=o.schema_id WHERE '+Predicate;
    CompareNames(Connection.DBXConnection, 'GetTables '+Identifier+'."%"."%" '+Types, SQL);
    Connection.TableScope := Scopes;
    Expected := ReadNames(Connection.DBXConnection, TDBXCommandTypes.DbxSQL, SQL, False);
    try
      Actual := TStringList.Create;
      try
        Actual.Sorted := True;
        Connection.GetTableNames(Actual, '%', False);
        if Actual.Text <> Expected.Text then
          raise Exception.CreateFmt('TSQLConnection.TableScope mask %d mismatch', [Mask]);
      finally Actual.Free end;
    finally Expected.Free end;
  end;
  Writeln('[PASS] All 16 TableScope combinations through DBX and TSQLConnection');
  Flush(Output);
end;

var
  Connection: TSQLConnection;
  Command: TDBXCommand;
  Reader: TDBXReader;
  Catalog, Identifier, Schema, TableSQL, ViewSQL, ProcedureSQL: string;
begin
  try
    if GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION') = '' then
      raise Exception.Create('Set DBXOODBC_TEST_CONNECTION for this read-only SQL Server test.');
    Connection := TSQLConnection.Create(nil);
    try
      Connection.DriverName := 'DbxOpenOdbc';
      Connection.LoginPrompt := False;
      Connection.Params.Clear;
      Connection.Params.Values['DriverName'] := 'DbxOpenOdbc';
      Connection.Params.Values['ConnectionString'] := GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION');
      Connection.Open;
      Command := Connection.DBXConnection.CreateCommand;
      try
        Command.Text := 'SELECT DB_NAME()';
        Reader := Command.ExecuteQuery;
        try Reader.Next; Catalog := Reader.Value[0].AsString; finally Reader.Free end;
      finally Command.Free end;
      Connection.Params.Values['Database'] := Catalog;
      Identifier := '"' + StringReplace(Catalog, '"', '""', [rfReplaceAll]) + '"';
      TableSQL := 'SELECT DB_NAME(), s.name, t.name FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE t.is_ms_shipped=0';
      ViewSQL := 'SELECT DB_NAME(), s.name, v.name FROM sys.views v JOIN sys.schemas s ON s.schema_id=v.schema_id WHERE v.is_ms_shipped=0';
      ProcedureSQL := 'SELECT DB_NAME(), s.name, p.name FROM sys.procedures p JOIN sys.schemas s ON s.schema_id=p.schema_id WHERE p.is_ms_shipped=0';
      CompareNames(Connection.DBXConnection, 'GetTables '+Identifier+'."dbo"."%" Table;', TableSQL+' AND s.name=''dbo''');
      for Schema in ['sys', 'INFORMATION_SCHEMA'] do
        CompareNames(Connection.DBXConnection, 'GetTables '+Identifier+'."'+Schema+'"."%" Table;', TableSQL+' AND s.name='''+Schema+'''');
      CompareNames(Connection.DBXConnection, 'GetTables '+Identifier+'."%"."%" Table;', TableSQL);
      CompareNames(Connection.DBXConnection, 'GetTables '+Identifier+'."%"."%" Table;View;', TableSQL+' UNION ALL '+ViewSQL);
      CompareNames(Connection.DBXConnection, 'GetViews '+Identifier+'."%"."%"', ViewSQL);
      CompareNames(Connection.DBXConnection, 'GetProcedures '+Identifier+'."dbo"."%" PROCEDURE', ProcedureSQL+' AND s.name=''dbo''');
      CompareNames(Connection.DBXConnection, 'GetSynonyms '+Identifier+'."%"."%"',
        'SELECT DB_NAME(),s.name,o.name FROM sys.synonyms o JOIN sys.schemas s ON s.schema_id=o.schema_id');
      CheckScopes(Connection, Identifier);
    finally Connection.Free end;
  except
    on E: Exception do
    begin Writeln('[FAIL] ', E.ClassName, ': ', E.Message); Flush(Output); ExitCode := 1 end;
  end;
end.
