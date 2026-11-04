program Dbx4MetadataTester;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Data.DBXCommon,
  Data.SqlExpr,
  OdbcProcedureMetadataTests in 'OdbcProcedureMetadataTests.pas',
  OdbcTableMetadataTests in 'OdbcTableMetadataTests.pas',
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas';

procedure Check(Condition: Boolean; const Message: string);
begin
  if not Condition then
    raise Exception.Create(Message);
end;

procedure CheckNameMetadata(Connection: TDBXConnection; const Text: string;
  const Columns: array of string);
var
  Command: TDBXCommand;
  Reader: TDBXReader;
  I: Integer;
begin
  Command := Connection.CreateCommand;
  try
    Command.CommandType := TDBXCommandTypes.DbxMetaData;
    Command.Text := Text;
    Reader := Command.ExecuteQuery;
    try
      Check(Reader <> nil, 'Missing metadata reader: ' + Text);
      Check(Reader.ColumnCount = Length(Columns), 'Wrong metadata column count: ' + Text);
      for I := 0 to High(Columns) do
        Check(Reader.ValueType[I].Name = Columns[I], 'Wrong metadata column name: ' + Text);
      while Reader.Next do
        for I := 0 to Reader.ColumnCount - 1 do
          if not Reader.Value[I].IsNull then
            case Reader.ValueType[I].DataType of
              TDBXDataTypes.Int32Type: Reader.Value[I].AsInt32;
              TDBXDataTypes.Int64Type: Reader.Value[I].AsInt64;
              TDBXDataTypes.BooleanType: Reader.Value[I].AsBoolean;
            else
              Reader.Value[I].AsString;
            end;
    finally
      Reader.Free;
    end;
  finally
    Command.Free;
  end;
  Writeln('[PASS] ', Text);
  Flush(Output);
end;

procedure CheckUnsupportedMetadata(Connection: TDBXConnection);
var
  Command: TDBXCommand;
  Reader: TDBXReader;
  Rejected: Boolean;
begin
  Command := Connection.CreateCommand;
  try
    Command.CommandType := TDBXCommandTypes.DbxMetaData;
    Command.Text := 'GetUnknownMetadata %';
    Rejected := False;
    try
      Reader := Command.ExecuteQuery;
      Reader.Free;
    except
      on E: TDBXError do
      begin
        if E.ErrorCode <> TDBXErrorCodes.NotSupported then
          raise;
        Rejected := True;
      end;
    end;
    Check(Rejected, 'Unsupported metadata must not be executed as SQL');
  finally
    Command.Free;
  end;
  Writeln('[PASS] Unsupported metadata rejected before SQL execution');
  Flush(Output);
end;

procedure CheckOptionalNameMetadata(Connection: TDBXConnection; const Text: string;
  const Columns: array of string);
begin
  try
    CheckNameMetadata(Connection, Text, Columns);
  except
    on E: EOdbcError do
    begin
      // Jet has no schema enumeration. A SQLTables optional-feature error is
      // valid here; SQLExecDirect syntax errors must still fail the regression.
      if (E.SqlState <> 'HYC00') or not (E.Message.StartsWith('SQLTablesW') or
        E.Message.StartsWith('SQLProceduresW') or E.Message.StartsWith('SQLProcedureColumnsW')) then
        raise;
      Writeln('[SKIP] ODBC driver does not support enumeration: ', Text);
      Flush(Output);
    end;
  end;
end;

procedure CheckSqlPercent(Connection: TDBXConnection);
var
  Command: TDBXCommand;
  Reader: TDBXReader;
begin
  Command := Connection.CreateCommand;
  try
    Command.CommandType := TDBXCommandTypes.DbxSQL;
    Command.Text := 'SELECT ''100%'' AS PercentValue';
    Reader := Command.ExecuteQuery;
    try
      Check((Reader <> nil) and Reader.Next, 'SQL query must return a row');
      Check(Reader.Value[0].AsString = '100%', 'Percent literal changed');
    finally
      Reader.Free;
    end;
  finally
    Command.Free;
  end;
  Writeln('[PASS] SQL percent literal remains valid');
  Flush(Output);
end;

var
  Connection: TSQLConnection;
  Names: TStringList;
  DriverName: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    Check(ParamCount = 1, 'Usage: Dbx4MetadataTester <path to dbdemos.mdb>');
    RunProcedureMetadataTests;
    RunTableMetadataTests;
    {$IFDEF WIN64}
    DriverName := 'Microsoft Access Driver (*.mdb, *.accdb)';
    {$ELSE}
    DriverName := 'Microsoft Access Driver (*.mdb)';
    {$ENDIF}
    Connection := TSQLConnection.Create(nil);
    try
      Connection.DriverName := 'DbxOpenOdbc';
      Connection.LoginPrompt := False;
      Connection.Params.Clear;
      Connection.Params.Values['DriverName'] := 'DbxOpenOdbc';
      Connection.Params.Values['ConnectionString'] := 'Driver={' + DriverName +
        '};DBQ=' + ExpandFileName(ParamStr(1)) + ';ReadOnly=1;';
      Connection.Open;
      // Delphi's GetSchemaNames sends exactly the metadata command GetSchemas %.
      Names := TStringList.Create;
      try
        try
          Connection.GetSchemaNames(Names);
          Writeln('[PASS] TSQLConnection.GetSchemaNames');
        except
          on E: EOdbcError do
          begin
            if (E.SqlState <> 'HYC00') or not E.Message.StartsWith('SQLTablesW') then
              raise;
            Writeln('[SKIP] Access ODBC does not support schema enumeration');
          end;
        end;
        Flush(Output);
        Connection.GetTableNames(Names);
        Check(Names.Count > 0, 'Expected tables in dbdemos.mdb');
        Writeln('[PASS] TSQLConnection.GetTableNames');
        Flush(Output);
        Connection.GetFieldNames('customer', Names);
        Check(Names.IndexOf('CustNo') >= 0, 'GetFieldNames(customer) must return CustNo');
        Writeln('[PASS] TSQLConnection.GetFieldNames(customer): ', Names.Count, ' fields');
        Names.Clear;
        try
          Connection.GetProcedureNames(Names);
          Writeln('[PASS] TSQLConnection.GetProcedureNames: ', Names.Count, ' procedures');
        except
          on E: EOdbcError do
          begin
            if (E.SqlState <> 'HYC00') or not E.Message.StartsWith('SQLProceduresW') then raise;
            Writeln('[SKIP] Access ODBC does not support procedure enumeration');
          end;
        end;
        Flush(Output);
      finally
        Names.Free;
      end;
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetSchemas %', ['CatalogName', 'SchemaName']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'getschemaS %', ['CatalogName', 'SchemaName']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetCatalogs', ['CatalogName']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetProcedures',
        ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetProcedures % PROCEDURE FUNCTION',
        ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetProcedures "No Such Procedure.%"',
        ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetProcedureParameters %',
        ['CatalogName', 'SchemaName', 'ProcedureName', 'ParameterName', 'ParameterMode',
         'TypeName', 'Precision', 'Scale', 'Ordinal', 'IsNullable', 'DbxDataType',
         'IsFixedLength', 'IsUnicode', 'IsLong', 'IsUnsigned']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetColumns employee',
        ['CatalogName', 'SchemaName', 'TableName', 'ColumnName', 'TypeName',
         'Precision', 'Scale', 'Ordinal', 'DefaultValue', 'IsNullable', 'IsAutoIncrement',
         'MaxInline', 'DbxDataType', 'IsFixedLength', 'IsUnicode', 'IsLong', 'IsUnsigned']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetIndexes employee',
        ['CatalogName', 'SchemaName', 'TableName', 'IndexName', 'ConstraintName',
         'IsPrimary', 'IsUnique', 'IsAscending']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetIndexColumns employee',
        ['CatalogName', 'SchemaName', 'TableName', 'IndexName', 'ColumnName',
         'Ordinal', 'IsAscending']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetForeignKeys employee',
        ['CatalogName', 'SchemaName', 'TableName', 'ForeignKeyName']);
      CheckOptionalNameMetadata(Connection.DBXConnection, 'GetForeignKeyColumns employee',
        ['CatalogName', 'SchemaName', 'TableName', 'ForeignKeyName', 'ColumnName',
         'PrimaryCatalogName', 'PrimarySchemaName', 'PrimaryTableName',
         'PrimaryKeyName', 'PrimaryColumnName', 'Ordinal']);
      CheckUnsupportedMetadata(Connection.DBXConnection);
      CheckSqlPercent(Connection.DBXConnection);
    finally
      Connection.Free;
    end;
  except
    on E: Exception do
    begin
      Writeln('[FAIL] ', E.ClassName, ': ', E.Message);
      Flush(Output);
      ExitCode := 1;
    end;
  end;
end.
