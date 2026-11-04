unit OdbcTableMetadataTests;

interface

procedure RunTableMetadataTests;

implementation

uses
  System.SysUtils,
  Data.DBXCommon,
  Data.DBXCommonTable,
  Data.DBXDBReaders,
  Data.DBXMetaDataReader,
  DbxOpenOdbcCore,
  DbxOpenOdbcDriver;

procedure Check(Condition: Boolean; const Message: string);
begin
  if not Condition then raise Exception.Create(Message);
end;

function TableRows: TDBXReader;
const
  Kinds: array[0..5] of string = ('TABLE', 'VIEW', 'SYSTEM TABLE', 'SYNONYM', 'ALIAS', 'SYSTEM VIEW');
var
  Table: TDBXMemoryTable;
  Columns: TDBXValueTypeArray;
  I: Integer;
begin
  Table := TDBXMemoryTable.Create;
  try
    SetLength(Columns, 5);
    for I := 0 to 4 do
      Columns[I] := TDBXMetaDataCollectionColumns.CreateValueType('Column'+IntToStr(I), '', TDBXDataTypes.WideStringType);
    Table.Columns := Columns;
    for I := 0 to High(Kinds) do
    begin
      Table.Insert;
      Table.Value[0].SetWideString('catalog.with.dot');
      Table.Value[1].SetWideString('actual_schema');
      Table.Value[2].SetWideString('object with.dot');
      Table.Value[3].SetWideString(Kinds[I]);
      Table.Post;
    end;
    Result := TDBXTableReader.Create(Table);
    Table := nil;
  finally Table.Free end;
end;

procedure RunTableMetadataTests;
var
  Source, Reader: TDBXReader;
  Mask, Expected, Count: Integer;
  Types: string;
  Rejected: Boolean;
begin
  Check(NormalizeOdbcTableTypes('Table;View;') = 'TABLE,VIEW', 'Mixed table/view scope changed to all types');
  Check(NormalizeOdbcTableTypes('SystemTable;View;') = 'SYSTEM TABLE,VIEW', 'System table scope is incorrect');
  Check(NormalizeOdbcTableTypes('Synonym') = 'SYNONYM,ALIAS', 'Synonym scope changed to ordinary tables');
  Rejected := False;
  try NormalizeOdbcTableTypes('UnexpectedType');
  except on E: TDBXError do Rejected := E.ErrorCode = TDBXErrorCodes.InvalidArgument end;
  Check(Rejected, 'Unknown table type must not silently become TABLE');
  for Mask := 0 to 15 do
  begin
    Expected := 0;
    Types := '';
    if Mask and 1 <> 0 then begin Types := Types+'Synonym;'; Inc(Expected, 2) end;
    if Mask and 2 <> 0 then begin Types := Types+'SystemTable;'; Inc(Expected) end;
    if Mask and 4 <> 0 then begin Types := Types+'Table;'; Inc(Expected) end;
    if Mask and 8 <> 0 then begin Types := Types+'View;'; Inc(Expected) end;
    if Mask = 0 then Expected := 6; // An empty DBX type filter requests all types.
    Source := TableRows;
    try Reader := CreateOdbcTablesMetadata(nil, Source, Types, TDBXMetaDataCommands.GetTables);
    finally Source.Free end;
    try
      Check(Reader.ColumnCount = 4, 'GetTables must have four DBX columns');
      Check(Reader.GetOrdinal('CatalogName') = 0, 'Catalog column mapping is missing');
      Check(Reader.GetOrdinal('SchemaName') = 1, 'Schema column mapping is missing');
      Count := 0;
      while Reader.Next do
      begin
        Check(Reader.Value[0].AsString = 'catalog.with.dot', 'Catalog name was lost');
        Check(Reader.Value[1].AsString = 'actual_schema', 'Schema name was fabricated');
        Check(Reader.Value[2].AsString = 'object with.dot', 'Object name was changed');
        Inc(Count);
      end;
      Check(Count = Expected, 'Table scope projection mismatch: '+IntToStr(Mask));
    finally Reader.Free end;
  end;

  Source := TableRows;
  try Reader := CreateOdbcTablesMetadata(nil, Source, 'View', TDBXMetaDataCommands.GetViews);
  finally Source.Free end;
  try
    Check((Reader.ColumnCount = 4) and (Reader.GetOrdinal('ViewName') = 2), 'View schema mapping failed');
    Check(Reader.Next and Reader.Value[3].IsNull, 'ODBC table type must not become a view definition');
    Check(not Reader.Next, 'Views contain other object types');
  finally Reader.Free end;

  Source := TableRows;
  try Reader := CreateOdbcTablesMetadata(nil, Source, 'Synonym', TDBXMetaDataCommands.GetSynonyms);
  finally Source.Free end;
  try
    Check((Reader.ColumnCount = 6) and (Reader.GetOrdinal('SynonymName') = 2), 'Synonym schema mapping failed');
    Count := 0;
    while Reader.Next do
    begin
      Check(Reader.Value[3].IsNull and Reader.Value[4].IsNull and Reader.Value[5].IsNull,
        'Unavailable synonym targets must not be fabricated');
      Inc(Count);
    end;
    Check(Count = 2, 'Synonym/alias filter is incorrect');
  finally Reader.Free end;
  Writeln('[PASS] All table scopes, catalog/schema preservation, views and synonyms');
  Flush(Output);
end;

end.
