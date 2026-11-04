unit OdbcProcedureMetadataTests;

interface

procedure RunProcedureMetadataTests;

implementation

uses
  System.SysUtils,
  Data.DBXCommon,
  Data.DBXCommonTable,
  Data.DBXDBReaders,
  Data.DBXMetaDataReader,
  DbxOpenOdbcDriver,
  OdbcApi;

procedure Check(Condition: Boolean; const Message: string);
begin
  if not Condition then raise Exception.Create(Message);
end;

function ProcedureRows(Empty: Boolean = False): TDBXReader;
var
  Table: TDBXMemoryTable;
  Columns: TDBXValueTypeArray;
  I: Integer;
begin
  Table := TDBXMemoryTable.Create;
  try
    SetLength(Columns, 8);
    for I := 0 to 7 do
      if I = 7 then
        Columns[I] := TDBXMetaDataCollectionColumns.CreateValueType('PROCEDURE_TYPE', '', TDBXDataTypes.Int16Type)
      else
        Columns[I] := TDBXMetaDataCollectionColumns.CreateValueType('Column'+IntToStr(I), '', TDBXDataTypes.WideStringType);
    Table.Columns := Columns;
    if not Empty then
      for I := 0 to 2 do
      begin
        Table.Insert;
        Table.Value[0].SetWideString('catalog');
        Table.Value[1].SetWideString('schema');
        Table.Value[2].SetWideString('procedure ' + IntToStr(I));
        Table.Value[7].SetInt16(I); // unknown / procedure / function
        Table.Post;
      end;
    Result := TDBXTableReader.Create(Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function ParameterRows: TDBXReader;
var
  Table: TDBXMemoryTable;
  Columns: TDBXValueTypeArray;
  I, Row: Integer;
const
  Modes: array[0..4] of Integer = (SQL_PARAM_INPUT, SQL_PARAM_OUTPUT,
    SQL_PARAM_INPUT_OUTPUT, SQL_RETURN_VALUE, 3); // final row is SQL_RESULT_COL
begin
  Table := TDBXMemoryTable.Create;
  try
    SetLength(Columns, 19);
    for I := 0 to 18 do
      if (I < 4) or (I = 6) or (I in [12, 13, 18]) then
        Columns[I] := TDBXMetaDataCollectionColumns.CreateValueType('Column'+IntToStr(I), '', TDBXDataTypes.WideStringType)
      else
        Columns[I] := TDBXMetaDataCollectionColumns.CreateValueType('Column'+IntToStr(I), '', TDBXDataTypes.Int32Type);
    Table.Columns := Columns;
    for Row := 0 to 4 do
    begin
      Table.Insert;
      Table.Value[0].SetNull;
      Table.Value[1].SetWideString('dbo');
      Table.Value[2].SetWideString('TestProcedure');
      Table.Value[3].SetWideString('@parameter' + IntToStr(Row));
      Table.Value[4].SetInt32(Modes[Row]);
      if Row = 2 then Table.Value[5].SetInt32(SQL_DECIMAL)
      else Table.Value[5].SetInt32(SQL_WVARCHAR);
      Table.Value[6].SetWideString('nvarchar');
      Table.Value[7].SetInt32(38);
      Table.Value[9].SetInt32(4);
      Table.Value[11].SetInt32(SQL_NULLABLE);
      if Row = 3 then Table.Value[17].SetInt32(0)
      else Table.Value[17].SetInt32(Row+1);
      Table.Post;
    end;
    Result := TDBXTableReader.Create(Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

procedure RunProcedureMetadataTests;
var
  Source, Reader: TDBXReader;
  Count: Integer;
  Buffer: TArray<Byte>;
  IsNull: LongBool;
const
  ExpectedModes: array[0..3] of string = ('IN', 'OUT', 'INOUT', 'RESULT');
begin
  Source := ProcedureRows;
  try
    Reader := CreateOdbcProceduresMetadata(nil, Source, '');
  finally
    Source.Free; // Converted rows must survive the source cursor.
  end;
  try
    Check(Reader.ColumnCount = 4, 'Procedure collection must have four DBX columns');
    Check(Reader.ValueType[3].Name = 'ProcedureType', 'Procedure type column is missing');
    Check(Reader.Next and Reader.Value[3].IsNull, 'Unknown procedure type must remain NULL');
    Check(Reader.Next and (Reader.Value[3].AsString = 'PROCEDURE'), 'Procedure type conversion failed');
    Check(Reader.Next and (Reader.Value[3].AsString = 'FUNCTION'), 'Function type conversion failed');
    Check(not Reader.Next, 'Unexpected procedure rows');
    Reader.Close;
  finally
    Reader.Free;
  end;

  Source := ProcedureRows;
  try Reader := CreateOdbcProceduresMetadata(nil, Source, 'PROCEDURE');
  finally Source.Free end;
  try
    Check(Reader.Next and (Reader.Value[2].AsString = 'procedure 1'), 'Procedure filter failed');
    Check(not Reader.Next, 'Function leaked through the procedure filter');
  finally Reader.Free end;

  Source := ProcedureRows(True);
  try Reader := CreateOdbcProceduresMetadata(nil, Source, '');
  finally Source.Free end;
  try
    Check((Reader.ColumnCount = 4) and not Reader.Next, 'Empty result lost its DBX schema');
    Check(Reader.GetOrdinal('ProcedureName') = 2, 'Empty result lost name-based column lookup');
  finally Reader.Free end;

  Source := ParameterRows;
  try Reader := CreateOdbcProcedureParametersMetadata(nil, Source);
  finally Source.Free end;
  try
    Check(Reader.ColumnCount = 15, 'Parameter collection must have fifteen DBX columns');
    Count := 0;
    while Reader.Next do
    begin
      Check(Count <= High(ExpectedModes), 'Result-set columns were exposed as parameters');
      Check(Reader.Value[0].IsNull, 'NULL catalog was lost');
      Check(Reader.Value[4].AsString = ExpectedModes[Count], 'Parameter direction conversion failed');
      Check(Reader.Value[6].AsInt64 = 38, 'Parameter precision was lost');
      Check(Reader.Value[7].AsInt32 = 4, 'Parameter scale was lost');
      Check(Reader.Value[9].AsBoolean, 'Parameter nullable flag was lost');
      Check(Reader.Value[14].IsNull, 'Unknown signedness must remain NULL');
      if Count = 2 then
        Check(Reader.Value[10].AsInt32 = TDBXDataTypes.BcdType, 'Decimal type mapping failed')
      else
        Check(Reader.Value[12].AsBoolean, 'Unicode parameter flag was lost');
      if Count = 3 then Check(Reader.Value[8].AsInt32 = 0, 'Return-value ordinal must be zero');
      SetLength(Buffer, SizeOf(Integer));
      Reader.ByteReader.GetInt32(7, Buffer, 0, IsNull);
      Check(not IsNull and (PInteger(@Buffer[0])^ = 4), 'Design-time byte reader failed');
      Inc(Count);
    end;
    Check(Count = 4, 'Wrong number of procedure parameters');
    Reader.Close;
  finally Reader.Free end;
  Writeln('[PASS] Procedure/parameter conversions, filtering, NULLs, empty results and byte access');
  Flush(Output);
end;

end.
