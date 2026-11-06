{
  Delphi open source DbExpress Native DBX4 Driver for ODBC
  Version 4.2026.11.05

  Copyright (c) 2001-2012 Edward Benson, Vadim V. Lopushansky
  Copyright (c) 2019-2026 Eden Wu (Native DBX4 Refactoring)

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Home Page:
    https://github.com/Eden5Wu/dbxoodbc
}
unit DbxOpenOdbcDriver;

{$B-}
{$R-}

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Data.DBCommonTypes,
  Data.FmtBcd,
  Data.SqlTimSt,
  Data.DBXCommon,
  Data.DBXPlatform,
  Data.DBXClassRegistry,
  OdbcApi,
  DbxOpenOdbcCore;

const
  sDbxOpenOdbcDriverName = 'DbxOpenOdbc';
  sOpenOdbcAliasName     = 'OpenOdbc';
  sDbxOpenOdbcVersion    = '4.2026.11.06 (DBX4 Remastered)';

type
  TDBXOpenOdbcConnectionNative = class;
  TDBXOpenOdbcCommandNative = class;

  (* ---------------------------------------------------------------------------
    Connection String & Extended Parameters Guide (連線字串與擴充參數規則):
    ---------------------------------------------------------------------------
    1. Entry Points (設定位置，依優先序讀取):
       - SQLConnection.Params.Values['ConnectionString'] (Recommended / 現代標準)
       - SQLConnection.Params.Values['Database']         (Standard DBX / 相容屬性)
       - SQLConnection.Params.Values['Custom String']    (Legacy 3.x / 歷史相容)

    2. Smart ADO/OLEDB Translation (自動轉譯規則):
       - Provider=SQLOLEDB / SQLNCLI11 / MSOLEDBSQL -> Driver={...}
       - Data Source=... / Address=...              -> Server=...
       - Initial Catalog=...                        -> Database=...
       - User ID=... / Password=...                 -> Uid=... / Pwd=...
       - Integrated Security=SSPI                   -> Trusted_Connection=yes
       - Application Name=... / Application_Name=.. -> APP=... (SQL Profiler 追蹤)
       - Workstation ID=...                         -> WSID=... (SQL Profiler 機台)
       - Legacy co* prefixes (coConnectionString=, coLockMode=, etc.) are stripped.

    3. Native Pass-Through (擴充參數直通):
       Any additional "Key=Value;" pairs appended to the connection string
       (e.g., TrustServerCertificate=yes;LoginTimeout=5;ApplicationIntent=ReadOnly;)
       are passed directly to the underlying Windows ODBC Driver via SQLDriverConnectW.
    --------------------------------------------------------------------------- *)
  TDBXOpenOdbcProperties = class(TDBXProperties)
  public const
    StrConnectionString = 'ConnectionString';
    StrCustomString     = 'Custom String';
    StrUseUnicode       = 'UseUnicode';
    StrTrimChar         = 'Trim Char';
    StrTrimFixedChar    = 'TrimFixedChar';
    StrTrimVarChar      = 'TrimVarChar';
  public
    constructor Create(DBXContext: TDBXContext); override;
  end;

  TDBXOpenOdbcDriverLoaderNative = class(TDBXDriverLoader)
  public
    constructor Create; override;
    function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;
  end;

  TDBXOpenOdbcDriverNative = class(TDBXDriver)
  private
    FOdbcEnv: TOdbcEnvHandle;
    function GetOdbcEnv: TOdbcEnvHandle;
  protected
    function CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; override;
    procedure Close; override;
  public
    constructor Create(DriverDef: TDBXDriverDef); override;
    destructor Destroy; override;
    procedure GetDriverPropertyNames(List: TStrings); override;
    function GetDriverVersion: string; override;
    property OdbcEnv: TOdbcEnvHandle read GetOdbcEnv;
  end;

  TDBXOpenOdbcTransactionNative = class(TDBXTransaction)
  private
    FTransactionId: Integer;
  public
    constructor Create(Connection: TDBXConnection; IsolationLevel: TDBXIsolation; ATransactionId: Integer);
    property TransactionId: Integer read FTransactionId;
  end;

  TDBXOpenOdbcConnectionNative = class(TDBXConnection)
  private
    FOdbcDriver: TDBXOpenOdbcDriverNative;
    FOdbcConn: TOdbcConnectionHandle;
    FNextTranId: Integer;
    function BuildOdbcConnectionString: string;
  protected
    function CreateAndBeginTransaction(const Isolation: TDBXIsolation): TDBXTransaction; override;
    procedure Commit(const Transaction: TDBXTransaction); override;
    procedure Rollback(const Transaction: TDBXTransaction); override;
    function DerivedCreateCommand: TDBXCommand; override;
    procedure DerivedOpen; override;
    procedure DerivedGetCommandTypes(const List: TStrings); override;
    procedure DerivedGetCommands(const CommandType: string; const List: TStrings); override;
    procedure DerivedClose; override;
    function GetProductVersion: string; override;
    function GetProductName: string; override;
  public
    constructor Create(ConnectionBuilder: TDBXConnectionBuilder;
      AOdbcDriver: TDBXOpenOdbcDriverNative);
    destructor Destroy; override;
    function GetVendorProperty(const Name: string): string; override;
    property OdbcConn: TOdbcConnectionHandle read FOdbcConn;
  end;

  TDBXOpenOdbcRowNative = class(TDBXRow)
  private
    FStmt: TOdbcStatementHandle;
    FOdbcColIndices: TArray<SqlUSmallint>;
    function ColNum(DbxValue: TDBXValue): SqlUSmallint; inline;
  protected
    procedure GetAnsiString(DbxValue: TDBXAnsiStringValue;
      var AnsiStringBuilder: TDBXAnsiStringBuilder; var IsNull: LongBool); override;
    procedure GetWideString(DbxValue: TDBXWideStringValue;
      var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); overload; override;
    procedure GetWideString(DbxValue: TDBXWideStringValue;
      var Value: string; var IsNull: LongBool); overload; override;
    procedure GetBoolean(DbxValue: TDBXBooleanValue;
      var Value: LongBool; var IsNull: LongBool); override;
    procedure GetUInt8(DbxValue: TDBXUInt8Value;
      var Value: Byte; var IsNull: LongBool); override;
    procedure GetInt8(DbxValue: TDBXInt8Value;
      var Value: ShortInt; var IsNull: LongBool); override;
    procedure GetUInt16(DbxValue: TDBXUInt16Value;
      var Value: Word; var IsNull: LongBool); override;
    procedure GetInt16(DbxValue: TDBXInt16Value;
      var Value: SmallInt; var IsNull: LongBool); override;
    procedure GetInt32(DbxValue: TDBXInt32Value;
      var Value: TInt32; var IsNull: LongBool); override;
    procedure GetInt64(DbxValue: TDBXInt64Value;
      var Value: Int64; var IsNull: LongBool); override;
    procedure GetSingle(DbxValue: TDBXSingleValue;
      var Value: Single; var IsNull: LongBool); override;
    procedure GetDouble(DbxValue: TDBXDoubleValue;
      var Value: Double; var IsNull: LongBool); override;
    procedure GetBcd(DbxValue: TDBXBcdValue;
      var Value: TBcd; var IsNull: LongBool); override;
    procedure GetDate(DbxValue: TDBXDateValue;
      var Value: TDBXDate; var IsNull: LongBool); override;
    procedure GetTime(DbxValue: TDBXTimeValue;
      var Value: TDBXTime; var IsNull: LongBool); override;
    procedure GetTimeStamp(DbxValue: TDBXTimeStampValue;
      var Value: TSQLTimeStamp; var IsNull: LongBool); override;
    procedure GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64;
      const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
      var ReturnLength: Int64; var IsNull: LongBool); override;
    procedure GetByteLength(DbxValue: TDBXByteArrayValue;
      var ByteLength: Int64; var IsNull: LongBool); override;
    function CreateCustomValue(const ValueType: TDBXValueType): TDBXValue; override;
  public
    constructor Create(DBXContext: TDBXContext; AStmt: TOdbcStatementHandle; const ColMetas: TOdbcColumnMetaArray);
  end;

  TDBXOpenOdbcReaderNative = class(TDBXReader)
  private
    FStmt: TOdbcStatementHandle;
    FOwnsStmt: Boolean;
    FByteReader: TDBXReaderByteReader;
    procedure InitColumns(const ColMetas: TOdbcColumnMetaArray);
  protected
    function DerivedNext: Boolean; override;
    procedure DerivedClose; override;
    function GetByteReader: TDBXByteReader; override;
  public
    constructor Create(DBXContext: TDBXContext; AStmt: TOdbcStatementHandle;
      const ColMetas: TOdbcColumnMetaArray; AOwnsStmt: Boolean = False);
    destructor Destroy; override;
  end;

  TDBXOpenOdbcCommandNative = class(TDBXCommand)
  private
    FOdbcConnection: TDBXOpenOdbcConnectionNative;
    FStmt: TOdbcStatementHandle;
    FRowSetSize: Int64;
    FMaxBlobSize: Int64;
    function CreateDatabaseMetaDataReader: TDBXReader;
    function CreateDataTypesMetaDataReader: TDBXReader;
    function CreateProceduresMetaDataReader(const Identifier, ProcedureTypes: string): TDBXReader;
    function CreateProcedureParametersMetaDataReader(const Identifier: string): TDBXReader;
    function CreateTablesMetaDataReader(const Identifier, TableTypes, Collection: string): TDBXReader;
    function CreateColumnsMetaDataReader(const Identifier: string): TDBXReader;
    function CreateIndexesMetaDataReader(const Identifier: string): TDBXReader;
    function CreateIndexColumnsMetaDataReader(const Identifier, SubIdentifier: string): TDBXReader;
    function CreateForeignKeysMetaDataReader(const Identifier: string): TDBXReader;
    function CreateForeignKeyColumnsMetaDataReader(const Identifier, SubIdentifier: string): TDBXReader;
    function CreateSqlServerMetaDataReader(const Identifier, Types, Collection: string): TDBXReader;
  protected
    function CreateParameterRow: TDBXRow; override;
    procedure SetRowSetSize(const RowSetSize: Int64); override;
    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    function GetRowsAffected: Int64; override;
    function DerivedGetNextReader: TDBXReader; override;
    procedure DerivedOpen; override;
    procedure DerivedClose; override;
    procedure DerivedPrepare; override;
    function DerivedExecuteQuery: TDBXReader; override;
    procedure DerivedExecuteUpdate; override;
  public
    constructor Create(DBXContext: TDBXContext; AConnection: TDBXOpenOdbcConnectionNative);
    destructor Destroy; override;
  end;

// Conversion keeps ownership of Source with the caller. The returned reader
// owns its independent DBX metadata rows and can outlive the ODBC cursor.
function CreateOdbcProceduresMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const ProcedureTypes: string): TDBXReader;
function CreateOdbcProcedureParametersMetadata(DBXContext: TDBXContext;
  Source: TDBXReader): TDBXReader;
function CreateOdbcTablesMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const TableTypes, Collection: string): TDBXReader;
function CreateOdbcColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader): TDBXReader;
function CreateOdbcIndexesMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  PrimaryKeys: TStrings = nil): TDBXReader;
function CreateOdbcIndexColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const IndexNameFilter: string = ''): TDBXReader;
function CreateOdbcForeignKeysMetadata(DBXContext: TDBXContext; Source: TDBXReader): TDBXReader;
function CreateOdbcForeignKeyColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const ForeignKeyFilter: string = ''): TDBXReader;

implementation

uses
  Data.DBXCommonTable,
  Data.DBXDBReaders,
  Data.DBXMetaDataReader;

type
  // TSQLDataSet also requires byte access to materialized metadata values.
  TDBXOpenOdbcMetaTableReader = class(TDBXTableReader)
  private
    FByteReader: TDBXReaderByteReader;
  protected
    function GetByteReader: TDBXByteReader; override;
    procedure DerivedClose; override;
  public
    function GetOrdinal(const Name: string): TInt32; override;
    destructor Destroy; override;
  end;

  // Lightweight in-memory row/reader for TDBXMetaDataCommands.GetDatabase
  TDBXOpenOdbcDatabaseMetaRow = class(TDBXRow)
  private
    FQuoteChar: string;
  protected
    procedure GetWideString(DbxValue: TDBXWideStringValue;
      var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); overload; override;
    procedure GetWideString(DbxValue: TDBXWideStringValue;
      var Value: string; var IsNull: LongBool); overload; override;
    procedure GetInt32(DbxValue: TDBXInt32Value;
      var Value: TInt32; var IsNull: LongBool); override;
    procedure GetBoolean(DbxValue: TDBXBooleanValue;
      var Value: LongBool; var IsNull: LongBool); override;
    function CreateCustomValue(const ValueType: TDBXValueType): TDBXValue; override;
  public
    constructor Create(DBXContext: TDBXContext; const AQuoteChar: string);
  end;

  TDBXOpenOdbcDatabaseMetaReader = class(TDBXReader)
  private
    FFetched: Boolean;
    FByteReader: TDBXReaderByteReader;
  protected
    function DerivedNext: Boolean; override;
    procedure DerivedClose; override;
    function GetByteReader: TDBXByteReader; override;
  public
    constructor Create(DBXContext: TDBXContext; const AQuoteChar: string);
    destructor Destroy; override;
  end;

function TDBXOpenOdbcMetaTableReader.GetOrdinal(const Name: string): TInt32;
var
  I: Integer;
  MappedName: string;
begin
  // An empty memory table has no value row; resolve names from its schema.
  for I := 0 to ColumnCount-1 do
    if SameText(ValueType[I].Name, Name) then Exit(I);
  MappedName := '';
  if SameText(Name, 'COLUMN_NAME') then MappedName := 'ColumnName'
  else if SameText(Name, 'INDEX_NAME') then MappedName := 'IndexName'
  else if SameText(Name, 'TABLE_NAME') then MappedName := 'TableName'
  else if SameText(Name, 'ORDINAL_POSITION') then MappedName := 'Ordinal';
  if MappedName <> '' then
    for I := 0 to ColumnCount-1 do
      if SameText(ValueType[I].Name, MappedName) then Exit(I);
  Result := inherited GetOrdinal(Name);
end;

function TDBXOpenOdbcMetaTableReader.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader := TDBXReaderByteReader.Create(FDBXContext, Self);
  Result := FByteReader;
end;

procedure TDBXOpenOdbcMetaTableReader.DerivedClose;
begin
  // Retain the table for TDBXTableReader.Destroy, which owns and frees it.
  FreeAndNil(FByteReader);
end;

destructor TDBXOpenOdbcMetaTableReader.Destroy;
begin
  FreeAndNil(FByteReader);
  inherited;
end;

function SplitMetadataParts(const Text: string; const Separators: TSysCharSet;
  KeepEmpty: Boolean): TArray<string>;
var
  I, Start, Count: Integer;
  QuoteEnd, Ch: Char;
begin
  SetLength(Result, 0);
  Start := 1;
  I := 1;
  QuoteEnd := #0;
  while I <= Length(Text) do
  begin
    Ch := Text[I];
    if QuoteEnd <> #0 then
    begin
      if Ch = QuoteEnd then
        if (I < Length(Text)) and (Text[I+1] = QuoteEnd) then
          Inc(I)
        else
          QuoteEnd := #0;
    end
    else if CharInSet(Ch, ['"', '''', '`', '[']) then
    begin
      if Ch = '[' then QuoteEnd := ']' else QuoteEnd := Ch;
    end
    else if CharInSet(Ch, Separators) then
    begin
      if KeepEmpty or (I > Start) then
      begin
        Count := Length(Result);
        SetLength(Result, Count+1);
        Result[Count] := Copy(Text, Start, I-Start);
      end;
      Start := I+1;
    end;
    Inc(I);
  end;
  if QuoteEnd <> #0 then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Unclosed metadata identifier quote');
  if KeepEmpty or (Start <= Length(Text)) then
  begin
    Count := Length(Result);
    SetLength(Result, Count+1);
    Result[Count] := Copy(Text, Start, MaxInt);
  end;
end;

procedure ParseMetadataIdentifier(const Identifier: string;
  out Catalog, Schema, ProcedurePattern: string);
var
  Parts: TArray<string>;
  I: Integer;
  QuoteEnd: Char;
begin
  Catalog := '';
  Schema := '';
  ProcedurePattern := '%';
  if Identifier = '' then Exit;
  Parts := SplitMetadataParts(Identifier, ['.'], True);
  if Length(Parts) > 3 then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected [catalog.][schema.]object');
  for I := 0 to High(Parts) do
  begin
    Parts[I] := Trim(Parts[I]);
    if (Length(Parts[I]) >= 2) and CharInSet(Parts[I][1], ['"', '''', '`', '[']) then
    begin
      QuoteEnd := Parts[I][1];
      if QuoteEnd = '[' then QuoteEnd := ']';
      Parts[I] := Copy(Parts[I], 2, Length(Parts[I])-2);
      Parts[I] := StringReplace(Parts[I], string(QuoteEnd)+QuoteEnd, QuoteEnd, [rfReplaceAll]);
    end;
  end;
  ProcedurePattern := Parts[High(Parts)];
  if Length(Parts) >= 2 then Schema := Parts[High(Parts)-1];
  if Length(Parts) = 3 then Catalog := Parts[0];
  if Catalog = '?' then Catalog := ''; // Historical template placeholder, not a catalog name.
end;

{ TDBXOpenOdbcDatabaseMetaRow }

constructor TDBXOpenOdbcDatabaseMetaRow.Create(DBXContext: TDBXContext; const AQuoteChar: string);
begin
  inherited Create(DBXContext);
  FQuoteChar := AQuoteChar;
  if FQuoteChar = '' then
    FQuoteChar := '"';
end;

function TDBXOpenOdbcDatabaseMetaRow.CreateCustomValue(const ValueType: TDBXValueType): TDBXValue;
begin
  if ValueType.DataType = TDBXDataTypes.WideStringType then
    Result := TDBXStringValue.Create(ValueType)
  else
    Result := nil;
end;

procedure TDBXOpenOdbcDatabaseMetaRow.GetWideString(DbxValue: TDBXWideStringValue;
  var Value: string; var IsNull: LongBool);
begin
  IsNull := False;
  case DbxValue.ValueType.Ordinal of
    0: Value := FQuoteChar; // QuoteChar
    1: Value := FQuoteChar; // ProcedureQuoteChar
    2: Value := FQuoteChar; // QuotePrefix
    3: Value := FQuoteChar; // QuoteSuffix
  else
    Value := '';
  end;
end;

procedure TDBXOpenOdbcDatabaseMetaRow.GetWideString(DbxValue: TDBXWideStringValue;
  var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  S: string;
begin
  GetWideString(DbxValue, S, IsNull);
  if not IsNull then
    TDBXPlatform.CopyWideStringToBuilder(S, S.Length + 1, WideStringBuilder);
end;

procedure TDBXOpenOdbcDatabaseMetaRow.GetInt32(DbxValue: TDBXInt32Value;
  var Value: TInt32; var IsNull: LongBool);
begin
  IsNull := False;
  Value := 0; // MaxCommands = 0 (unlimited)
end;

procedure TDBXOpenOdbcDatabaseMetaRow.GetBoolean(DbxValue: TDBXBooleanValue;
  var Value: LongBool; var IsNull: LongBool);
begin
  IsNull := False;
  case DbxValue.ValueType.Ordinal of
    5:  Value := True;  // SupportsTransactions
    6:  Value := False; // SupportsNestedTransactions
    7:  Value := True;  // SupportsRowSetSize
    8:  Value := False; // SupportsLowerCaseIdentifiers
    9:  Value := False; // SupportsUpperCaseIdentifiers
    10: Value := True;  // SupportsSPReturnCode
    11: Value := True;  // SupportsParameterMetadata
    12: Value := False; // SupportsCatalogFunctions (False = use DBX4 GetIndexes + GetIndexColumns)
    13: Value := True;  // SupportsCatalogs
    14: Value := True;  // SupportsSchemas
  else
    Value := False;
  end;
end;

{ TDBXOpenOdbcDatabaseMetaReader }

constructor TDBXOpenOdbcDatabaseMetaReader.Create(DBXContext: TDBXContext; const AQuoteChar: string);
var
  Row: TDBXOpenOdbcDatabaseMetaRow;
  Vals: TDBXWritableValueArray;

  procedure AddCol(Ordinal: Integer; const AName: string; ADataType: TDBXType; ASize: Integer);
  var
    VT: TDBXValueType;
  begin
    VT := TDBXDriverHelp.CreateTDBXValueType(DBXContext, Row);
    VT.Name := AName;
    VT.DisplayName := AName;
    VT.Ordinal := Ordinal;
    VT.DataType := ADataType;
    VT.Size := ASize;
    Vals[Ordinal] := TDBXValue.CreateValue(DBXContext, VT, Row, True);
  end;

begin
  Row := TDBXOpenOdbcDatabaseMetaRow.Create(DBXContext, AQuoteChar);
  inherited Create(DBXContext, Row, nil);
  SetLength(Vals, 15);
  // Column definitions matching Delphi TDBXDatabaseMetaData requirements (ColumnCount >= 10 elevates to DBXVersion40)
  AddCol(0,  TDBXMetaDatabaseColumnNames.QuoteChar, TDBXDataTypes.WideStringType, 8);
  AddCol(1,  TDBXMetaDatabaseColumnNames.ProcedureQuoteChar, TDBXDataTypes.WideStringType, 8);
  AddCol(2,  TDBXMetaDatabaseColumnNames.QuotePrefix, TDBXDataTypes.WideStringType, 8);
  AddCol(3,  TDBXMetaDatabaseColumnNames.QuoteSuffix, TDBXDataTypes.WideStringType, 8);
  AddCol(4,  TDBXMetaDatabaseColumnNames.MaxCommands, TDBXDataTypes.Int32Type, SizeOf(TInt32));
  AddCol(5,  TDBXMetaDatabaseColumnNames.SupportsTransactions, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(6,  TDBXMetaDatabaseColumnNames.SupportsNestedTransactions, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(7,  TDBXMetaDatabaseColumnNames.SupportsRowSetSize, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(8,  TDBXMetaDatabaseColumnNames.SupportsLowerCaseIdentifiers, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(9,  TDBXMetaDatabaseColumnNames.SupportsUpperCaseIdentifiers, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(10, TDBXMetaDatabaseColumnNames.SupportsSPReturnCode, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(11, TDBXMetaDatabaseColumnNames.SupportsParameterMetadata, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(12, TDBXMetaDatabaseColumnNames.SupportsCatalogFunctions, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(13, TDBXMetaDatabaseColumnNames.SupportsCatalogs, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  AddCol(14, TDBXMetaDatabaseColumnNames.SupportsSchemas, TDBXDataTypes.BooleanType, SizeOf(WordBool));
  SetValues(Vals);
end;

function TDBXOpenOdbcDatabaseMetaReader.DerivedNext: Boolean;
begin
  if not FFetched then
  begin
    FFetched := True;
    Result := True;
  end
  else
    Result := False;
end;

function TDBXOpenOdbcDatabaseMetaReader.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader := TDBXReaderByteReader.Create(FDBXContext, Self);
  Result := FByteReader;
end;

procedure TDBXOpenOdbcDatabaseMetaReader.DerivedClose;
begin
  FreeAndNil(FByteReader);
end;

destructor TDBXOpenOdbcDatabaseMetaReader.Destroy;
begin
  FreeAndNil(FByteReader);
  inherited;
end;

{ TDBXOpenOdbcProperties }

constructor TDBXOpenOdbcProperties.Create(DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
  Values[TDBXPropertyNames.DriverUnit] := 'DbxOpenOdbcDriver';
  Values[TDBXPropertyNames.DriverPackageLoader] := TDBXOpenOdbcDriverLoaderNative.ClassName;
  Values[StrUseUnicode] := 'True';
  Values[StrTrimChar] := 'True';
  Values[StrTrimFixedChar] := 'True';
  Values[StrTrimVarChar] := 'False';
end;

{ TDBXOpenOdbcDriverLoaderNative }

constructor TDBXOpenOdbcDriverLoaderNative.Create;
begin
  inherited Create;
  FLoaderName := TDBXOpenOdbcDriverLoaderNative.ClassName;
end;

function TDBXOpenOdbcDriverLoaderNative.Load(DriverDef: TDBXDriverDef): TDBXDriver;
begin
  Result := TDBXOpenOdbcDriverNative.Create(DriverDef);
end;

{ TDBXOpenOdbcDriverNative }

constructor TDBXOpenOdbcDriverNative.Create(DriverDef: TDBXDriverDef);
begin
  inherited Create(DriverDef);
  CacheUntilFinalization;
  InitDriverProperties(TDBXOpenOdbcProperties.Create(DriverDef.FDBXContext));
  if (DriverDef.FDriverProperties <> nil) then
    DriverProperties.MergeProperties(DriverDef.FDriverProperties.Properties);
  // DbxOpenOdbc implements all metadata natively in TDBXOpenOdbcCommandNative.
  // Proactively clear MetaDataPackageLoader to prevent DBX from attempting to load legacy/missing external factories.
  DriverProperties[TDBXPropertyNames.MetaDataPackageLoader] := '';
end;

destructor TDBXOpenOdbcDriverNative.Destroy;
begin
  FreeAndNil(FOdbcEnv);
  inherited;
end;

function TDBXOpenOdbcDriverNative.GetOdbcEnv: TOdbcEnvHandle;
begin
  if FOdbcEnv = nil then
    FOdbcEnv := TOdbcEnvHandle.Create;
  Result := FOdbcEnv;
end;

function TDBXOpenOdbcDriverNative.CreateConnection(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
begin
  Result := TDBXOpenOdbcConnectionNative.Create(ConnectionBuilder, Self);
end;

procedure TDBXOpenOdbcDriverNative.Close;
begin
  // Environment handle freed in Destroy
end;

procedure TDBXOpenOdbcDriverNative.GetDriverPropertyNames(List: TStrings);
begin
  inherited;
  List.Add(TDBXPropertyNames.Database);
  List.Add(TDBXPropertyNames.UserName);
  List.Add(TDBXPropertyNames.Password);
  List.Add(TDBXPropertyNames.HostName);
  List.Add(TDBXOpenOdbcProperties.StrConnectionString);
  List.Add(TDBXOpenOdbcProperties.StrCustomString);
end;

function TDBXOpenOdbcDriverNative.GetDriverVersion: string;
begin
  Result := sDbxOpenOdbcVersion;
end;

{ TDBXOpenOdbcTransactionNative }

constructor TDBXOpenOdbcTransactionNative.Create(Connection: TDBXConnection;
  IsolationLevel: TDBXIsolation; ATransactionId: Integer);
begin
  inherited Create(Connection);
  FIsolationLevel := IsolationLevel;
  FTransactionId := ATransactionId;
end;

{ TDBXOpenOdbcConnectionNative }

constructor TDBXOpenOdbcConnectionNative.Create(
  ConnectionBuilder: TDBXConnectionBuilder; AOdbcDriver: TDBXOpenOdbcDriverNative);
begin
  inherited Create(ConnectionBuilder);
  FOdbcDriver := AOdbcDriver;
  FNextTranId := 1;
end;

destructor TDBXOpenOdbcConnectionNative.Destroy;
begin
  Close;
  FreeAndNil(FOdbcConn);
  inherited;
end;

function TDBXOpenOdbcConnectionNative.BuildOdbcConnectionString: string;
var
  ConnStr, DbProp, HostProp, UserProp, PassProp, CustomProp: string;

  function StripLegacyPrefix(const AStr: string): string;
  const
    cPrefix = 'COCONNECTIONSTRING=';
  var
    Tokens: TArray<string>;
    Token, S, Key, Val: string;
    P: Integer;
    CleanParts: TStringBuilder;
  begin
    Result := Trim(AStr);
    if Pos(cPrefix, UpperCase(Result)) = 1 then
      Result := Trim(Copy(Result, Length(cPrefix) + 1, MaxInt));

    // Strip legacy dbxoodbc 3.x co* options (e.g. coLockMode, coCatPrefix, coEnableUnicode)
    // so native ODBC drivers do not choke on unknown connection string attributes
    if Pos(';CO', UpperCase(';' + Result)) > 0 then
    begin
      Tokens := Result.Split([';']);
      CleanParts := TStringBuilder.Create;
      try
        for Token in Tokens do
        begin
          S := Trim(Token);
          if S = '' then Continue;
          P := Pos('=', S);
          if P > 0 then
          begin
            Key := UpperCase(Trim(Copy(S, 1, P - 1)));
            Val := Trim(Copy(S, P + 1, MaxInt));
            if Key = 'COCONNECTIONSTRING' then
            begin
              if CleanParts.Length > 0 then CleanParts.Append(';');
              CleanParts.Append(Val);
              Continue;
            end
            else if (Length(Key) > 2) and (Copy(Key, 1, 2) = 'CO') and
              ((Key = 'COLOCKMODE') or (Key = 'COCATPREFIX') or (Key = 'COENABLEUNICODE') or
               (Key = 'CONETPACKETSIZE') or (Key = 'COBLOBCHUNKSIZE') or (Key = 'COSCHEMFLT') or
               (Key = 'COMETADATA') or (Key = 'COCATALOG') or (Key = 'COTRIMCHAR') or
               (Key = 'COMAPINT64TOBCD') or (Key = 'COMAPSMALLBCDTONATIVE') or
               (Key = 'COIGNOREUNKFLDTYPE') or (Key = 'COMAPCHARASBDE') or (Key = 'COICLONECON')) then
            begin
              Continue;
            end;
          end;
          if CleanParts.Length > 0 then CleanParts.Append(';');
          CleanParts.Append(S);
        end;
        Result := CleanParts.ToString;
      finally
        CleanParts.Free;
      end;
    end;
  end;

  function TranslateOleDbToOdbc(const AStr: string): string;
  var
    Tokens: TArray<string>;
    Token, Key, Val, S: string;
    P: Integer;
    Prov, Svr, DB, Uid, Pwd, AppName, Wsid: string;
    IntegratedSec: Boolean;
    OtherParts: TStringBuilder;
  begin
    IntegratedSec := False;
    Tokens := AStr.Split([';']);
    OtherParts := TStringBuilder.Create;
    try
      for Token in Tokens do
      begin
        S := Trim(Token);
        if S = '' then Continue;
        P := Pos('=', S);
        if P <= 0 then Continue;
        Key := UpperCase(Trim(Copy(S, 1, P - 1)));
        Val := Trim(Copy(S, P + 1, Length(S)));

        if (Key = 'PROVIDER') then
          Prov := Val
        else if (Key = 'DATA SOURCE') or (Key = 'SERVER') or (Key = 'ADDRESS') or (Key = 'ADDR') or (Key = 'NETWORK ADDRESS') then
          Svr := Val
        else if (Key = 'INITIAL CATALOG') or (Key = 'DATABASE') then
          DB := Val
        else if (Key = 'USER ID') or (Key = 'UID') or (Key = 'USER') then
          Uid := Val
        else if (Key = 'PASSWORD') or (Key = 'PWD') then
          Pwd := Val
        else if (Key = 'APPLICATION NAME') or (Key = 'APPLICATION_NAME') or (Key = 'APP') then
          AppName := Val
        else if (Key = 'WORKSTATION ID') or (Key = 'WSID') then
          Wsid := Val
        else if (Key = 'INTEGRATED SECURITY') or (Key = 'TRUSTED_CONNECTION') then
        begin
          if (UpperCase(Val) = 'SSPI') or (UpperCase(Val) = 'TRUE') or (UpperCase(Val) = 'YES') then
            IntegratedSec := True;
        end
        else if (Key = 'PERSIST SECURITY INFO') or (Key = 'USEUNICODE') or (Key = 'TRIM CHAR') or (Key = 'TRIMCHAR') or (Key = 'TRIMFIXEDCHAR') or (Key = 'TRIM FIXED CHAR') or (Key = 'TRIMVARCHAR') or (Key = 'TRIM VAR CHAR') or (Key = 'ROWSETSIZE') or (Key = 'BLOBSIZE') then
          Continue // Ignore ADO-only attribute
        else
        begin
          if OtherParts.Length > 0 then OtherParts.Append(';');
          OtherParts.Append(S);
        end;
      end;

      // Determine Driver based on Provider using dynamic system ODBC driver resolution
      if (Pos('MSOLEDBSQL', UpperCase(Prov)) > 0) or (Pos('SQLNCLI', UpperCase(Prov)) > 0)
        or (Pos('SQLOLEDB', UpperCase(Prov)) > 0) then
      begin
        Result := 'Driver={' + FOdbcDriver.OdbcEnv.ResolveSqlServerDriver(Prov) + '};';
      end
      else if Pos('MSDASQL', UpperCase(Prov)) > 0 then
        Result := ''
      else
        Result := 'Driver={' + Prov + '};';

      if Svr <> '' then
        Result := Result + 'Server=' + Svr + ';';
      if DB <> '' then
        Result := Result + 'Database=' + DB + ';';
      if IntegratedSec then
        Result := Result + 'Trusted_Connection=yes;';
      if Uid <> '' then
        Result := Result + 'Uid=' + Uid + ';';
      if Pwd <> '' then
        Result := Result + 'Pwd=' + Pwd + ';';
      if AppName <> '' then
        Result := Result + 'APP=' + AppName + ';';
      if Wsid <> '' then
        Result := Result + 'WSID=' + Wsid + ';';

      // Auto-enable MARS (Multiple Active Result Sets) for SQL Server drivers to allow concurrent active statements
      if (Pos('SQL', UpperCase(Result)) > 0) and (Pos('MARS_CONNECTION=', UpperCase(Result)) = 0)
        and (Pos('MARS_CONNECTION=', UpperCase(OtherParts.ToString)) = 0) then
      begin
        Result := Result + 'MARS_Connection=yes;';
      end;

      // Auto-trust server certificate for ODBC Driver 18+ if not explicitly configured
      if ((Pos('DRIVER 18', UpperCase(Result)) > 0) or (Pos('DRIVER 19', UpperCase(Result)) > 0))
        and (Pos('TRUSTSERVERCERTIFICATE=', UpperCase(OtherParts.ToString)) = 0) then
      begin
        Result := Result + 'TrustServerCertificate=yes;';
      end;

      if OtherParts.Length > 0 then
        Result := Result + OtherParts.ToString + ';';
    finally
      OtherParts.Free;
    end;
  end;

  function EnsureValidSqlDriver(const AStr: string): string;
  var
    Tokens: TArray<string>;
    Token, S, Key, Val, ResolvedDrv: string;
    P: Integer;
    Rebuilt: TStringBuilder;
    Replaced: Boolean;
  begin
    Result := AStr;
    if Pos('DRIVER=', UpperCase(AStr)) = 0 then
      Exit;

    Replaced := False;
    Tokens := AStr.Split([';']);
    Rebuilt := TStringBuilder.Create;
    try
      for Token in Tokens do
      begin
        S := Trim(Token);
        if S = '' then Continue;
        P := Pos('=', S);
        if P > 0 then
        begin
          Key := UpperCase(Trim(Copy(S, 1, P - 1)));
          Val := Trim(Copy(S, P + 1, MaxInt));
          if (Key = 'DRIVER') and ((Pos('SQL SERVER', UpperCase(Val)) > 0) or (Pos('SQL NATIVE CLIENT', UpperCase(Val)) > 0)) then
          begin
            if not FOdbcDriver.OdbcEnv.IsDriverInstalled(Val) then
            begin
              ResolvedDrv := FOdbcDriver.OdbcEnv.ResolveSqlServerDriver(Val);
              S := 'DRIVER={' + ResolvedDrv + '}';
              Replaced := True;
            end;
          end;
        end;
        if Rebuilt.Length > 0 then Rebuilt.Append(';');
        Rebuilt.Append(S);
      end;
      if Replaced then
      begin
        Result := Rebuilt.ToString + ';';
        if ((Pos('DRIVER 18', UpperCase(Result)) > 0) or (Pos('DRIVER 19', UpperCase(Result)) > 0))
          and (Pos('TRUSTSERVERCERTIFICATE=', UpperCase(Result)) = 0) then
        begin
          Result := Result + 'TrustServerCertificate=yes;';
        end;
      end;
    finally
      Rebuilt.Free;
    end;
  end;

  function ResolveSqlServerProtocol(const AConnStr: string): string;
  var
    Tokens: TArray<string>;
    Token, S, Key, Val, UpperVal: string;
    P, SlashPos, PortPos: Integer;
    HostPart, InstancePart, LocalComp: string;
    IsSharedMem, IsRemoteHost, IsLocalNamed, HasExplicitProtocol: Boolean;
    Rebuilt: TStringBuilder;

    function GetLocalComputerName: string;
    var
      Buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
      Size: DWORD;
    begin
      Size := Length(Buffer);
      if Winapi.Windows.GetComputerName(@Buffer[0], Size) then
        SetString(Result, Buffer, Size)
      else
        Result := '';
    end;

    function IsLocalHost(const AHost, ALocalComp: string): Boolean;
    var
      H: string;
    begin
      H := Trim(AHost);
      Result := (H = '.') or
                SameText(H, '(local)') or
                SameText(H, 'localhost') or
                (H = '127.0.0.1') or
                ((ALocalComp <> '') and SameText(H, ALocalComp)) or
                (Pos('(LOCALDB)', UpperCase(H)) = 1);
    end;

  begin
    Result := AConnStr;
    if (Pos('SQL SERVER', UpperCase(AConnStr)) = 0) and
       (Pos('SQLNCLI', UpperCase(AConnStr)) = 0) and
       (Pos('MSOLEDBSQL', UpperCase(AConnStr)) = 0) then
      Exit;

    LocalComp := GetLocalComputerName;
    IsSharedMem := False;
    IsRemoteHost := False;
    IsLocalNamed := False;
    HasExplicitProtocol := False;

    Tokens := AConnStr.Split([';']);

    // Pass 1: analyze Server / Data Source parameter
    for Token in Tokens do
    begin
      S := Trim(Token);
      if S = '' then Continue;
      P := Pos('=', S);
      if P <= 0 then Continue;
      Key := UpperCase(Trim(Copy(S, 1, P - 1)));
      Val := Trim(Copy(S, P + 1, MaxInt));

      if (Key = 'SERVER') or (Key = 'DATA SOURCE') then
      begin
        UpperVal := UpperCase(Val);
        if (Pos('TCP:', UpperVal) = 1) or (Pos('NP:', UpperVal) = 1) then
        begin
          HasExplicitProtocol := True;
        end
        else if Pos('LPC:', UpperVal) = 1 then
        begin
          HasExplicitProtocol := True;
          IsSharedMem := True;
        end
        else
        begin
          SlashPos := Pos('\', Val);
          if SlashPos > 0 then
          begin
            // Named instance (e.g. .\SQLEXPRESS, localhost\SQLEXPRESS, 127.0.0.1\SQLEXPRESS)
            HostPart := Trim(Copy(Val, 1, SlashPos - 1));
            InstancePart := Trim(Copy(Val, SlashPos + 1, MaxInt));
            if IsLocalHost(HostPart, LocalComp) then
            begin
              IsLocalNamed := True;
              IsSharedMem := True;
            end;
          end
          else
          begin
            PortPos := Pos(',', Val);
            if PortPos <= 0 then
            begin
              // Default instance: check if local or remote
              if not IsLocalHost(Val, LocalComp) then
                IsRemoteHost := True;
            end;
          end;
        end;
        Break;
      end;
    end;

    // Pass 2: rebuild connection string with protocol routing
    Rebuilt := TStringBuilder.Create;
    try
      for Token in Tokens do
      begin
        S := Trim(Token);
        if S = '' then Continue;
        P := Pos('=', S);
        if P <= 0 then
        begin
          if Rebuilt.Length > 0 then Rebuilt.Append(';');
          Rebuilt.Append(S);
          Continue;
        end;

        Key := UpperCase(Trim(Copy(S, 1, P - 1)));
        Val := Trim(Copy(S, P + 1, MaxInt));

        // Strip Network / Net / Network Library if using Shared Memory (lpc:)
        // Having Network=dbmssocn with Shared Memory causes ODBC login failure (08001 / HYT00)
        if IsSharedMem and ((Key = 'NETWORK') or (Key = 'NETWORK LIBRARY') or (Key = 'NET')) then
          Continue;

        if (Key = 'SERVER') or (Key = 'DATA SOURCE') then
        begin
          UpperVal := UpperCase(Val);
          if Pos('LPC:127.0.0.1', UpperVal) = 1 then
          begin
            // Microsoft SNI rejects LPC with numeric IP; normalize to localhost
            Val := 'lpc:localhost' + Copy(Val, 14, MaxInt);
            S := Key + '=' + Val;
          end
          else if IsLocalNamed and not HasExplicitProtocol then
          begin
            SlashPos := Pos('\', Val);
            HostPart := Trim(Copy(Val, 1, SlashPos - 1));
            InstancePart := Trim(Copy(Val, SlashPos + 1, MaxInt));
            if HostPart = '127.0.0.1' then
              HostPart := 'localhost';
            Val := 'lpc:' + HostPart + '\' + InstancePart;
            S := Key + '=' + Val;
          end;
        end;

        if Rebuilt.Length > 0 then Rebuilt.Append(';');
        Rebuilt.Append(S);
      end;

      // Fast TCP optimization: only for remote hosts without explicit port or instance
      // (avoids 15-30s Named Pipes timeout when connecting to remote IP/host)
      if IsRemoteHost and not IsSharedMem and not HasExplicitProtocol then
      begin
        if (Pos('NETWORK=', UpperCase(Rebuilt.ToString)) = 0) and
           (Pos('NETWORK LIBRARY=', UpperCase(Rebuilt.ToString)) = 0) and
           (Pos('NET=', UpperCase(Rebuilt.ToString)) = 0) then
        begin
          if Rebuilt.Length > 0 then Rebuilt.Append(';');
          Rebuilt.Append('Network=dbmssocn');
        end;
      end;

      Result := Rebuilt.ToString;
      if (Result <> '') and (Result[Length(Result)] <> ';') then
        Result := Result + ';';
    finally
      Rebuilt.Free;
    end;
  end;

begin
  ConnStr := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrConnectionString]);
  DbProp := Trim(FConnectionProperties[TDBXPropertyNames.Database]);
  HostProp := Trim(FConnectionProperties[TDBXPropertyNames.HostName]);
  if HostProp = '' then HostProp := Trim(FConnectionProperties['Server']);
  if HostProp = '' then HostProp := Trim(FConnectionProperties['Data Source']);
  UserProp := Trim(FConnectionProperties[TDBXPropertyNames.UserName]);
  PassProp := FConnectionProperties[TDBXPropertyNames.Password];
  CustomProp := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrCustomString]);

  if (Pos('PROVIDER=', UpperCase(DbProp)) > 0) or ((Pos('DRIVER=', UpperCase(DbProp)) > 0) and (Pos(';', DbProp) > 0)) then
    ConnStr := DbProp
  else if (Pos('PROVIDER=', UpperCase(CustomProp)) > 0) or ((Pos('DRIVER=', UpperCase(CustomProp)) > 0) and (Pos(';', CustomProp) > 0)) then
    ConnStr := CustomProp
  else if (ConnStr = '') and (DbProp <> '') and (DbProp <> '?') and ((Pos('=', DbProp) > 0) or (Pos(';', DbProp) > 0)) then
    ConnStr := DbProp;

  if (ConnStr = '') and (CustomProp <> '') then
    ConnStr := CustomProp;

  ConnStr := StripLegacyPrefix(ConnStr);

  // Auto-detect and translate ADO OLE DB connection strings (e.g. Provider=SQLOLEDB;...)
  if (ConnStr <> '') and (Pos('PROVIDER=', UpperCase(ConnStr)) > 0) then
    ConnStr := TranslateOleDbToOdbc(ConnStr)
  else if (ConnStr <> '') then
  begin
    if Pos('APPLICATION_NAME=', UpperCase(ConnStr)) > 0 then
      ConnStr := StringReplace(ConnStr, 'Application_Name=', 'APP=', [rfReplaceAll, rfIgnoreCase]);
    if Pos('APPLICATION NAME=', UpperCase(ConnStr)) > 0 then
      ConnStr := StringReplace(ConnStr, 'Application Name=', 'APP=', [rfReplaceAll, rfIgnoreCase]);
    ConnStr := EnsureValidSqlDriver(ConnStr);
  end;

  // Append HostName / Server if specified as individual property
  if (HostProp <> '') and (Pos('SERVER=', UpperCase(ConnStr)) = 0) and (Pos('DATA SOURCE=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'Server=' + HostProp + ';';
  end;

  // Append Database if specified as individual property
  if (DbProp <> '') and (DbProp <> '?') and (Pos('DATABASE=', UpperCase(ConnStr)) = 0) and (Pos('INITIAL CATALOG=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'Database=' + DbProp + ';';
  end;

  // If parameters are provided but no Driver or DSN, default to installed SQL Server driver
  if (ConnStr <> '') and (Pos('DRIVER=', UpperCase(ConnStr)) = 0) and (Pos('DSN=', UpperCase(ConnStr)) = 0) and (Pos('=', ConnStr) > 0) then
    ConnStr := 'Driver={' + FOdbcDriver.OdbcEnv.ResolveSqlServerDriver('SQL Server') + '};' + ConnStr;

  if (ConnStr <> '') and (Pos('=', ConnStr) = 0) then
    ConnStr := 'DSN=' + ConnStr;

  if (UserProp <> '') and (Pos('UID=', UpperCase(ConnStr)) = 0) and (Pos('TRUSTED_CONNECTION=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'UID=' + UserProp;
  end;

  if (PassProp <> '') and (Pos('PWD=', UpperCase(ConnStr)) = 0) and (Pos('TRUSTED_CONNECTION=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'PWD=' + PassProp;
  end;

  // Smart SQL Server protocol routing and named instance resolution
  ConnStr := ResolveSqlServerProtocol(ConnStr);

  Result := ConnStr;
end;

procedure TDBXOpenOdbcConnectionNative.DerivedOpen;
var
  ConnStr: string;
  UseUnicodeVal: string;
  TrimFixedVal, TrimVarVal: string;
begin
  if FOdbcConn = nil then
    FOdbcConn := TOdbcConnectionHandle.Create(FOdbcDriver.OdbcEnv, False);

  ConnStr := BuildOdbcConnectionString;
  UseUnicodeVal := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrUseUnicode]);
  if UseUnicodeVal = '' then
    UseUnicodeVal := Trim(FConnectionProperties['UseUnicode']);

  if (SameText(UseUnicodeVal, 'False') or (UseUnicodeVal = '0')) or
     (Pos('USEUNICODE=FALSE', UpperCase(ConnStr)) > 0) or
     (Pos('USEUNICODE=0', UpperCase(ConnStr)) > 0) then
    FOdbcConn.UseUnicode := False
  else
    FOdbcConn.UseUnicode := True;

  TrimFixedVal := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrTrimFixedChar]);
  if TrimFixedVal = '' then TrimFixedVal := Trim(FConnectionProperties['TrimFixedChar']);
  if TrimFixedVal = '' then TrimFixedVal := Trim(FConnectionProperties['Trim Fixed Char']);
  if TrimFixedVal = '' then TrimFixedVal := Trim(FConnectionProperties['Trim Char']);
  if TrimFixedVal = '' then TrimFixedVal := Trim(FConnectionProperties['TrimChar']);
  if (SameText(TrimFixedVal, 'False') or (TrimFixedVal = '0')) or
     (Pos('TRIMFIXEDCHAR=FALSE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM FIXED CHAR=FALSE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM CHAR=FALSE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIMCHAR=FALSE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIMFIXEDCHAR=0', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM FIXED CHAR=0', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM CHAR=0', UpperCase(ConnStr)) > 0) or
     (Pos('TRIMCHAR=0', UpperCase(ConnStr)) > 0) then
    FOdbcConn.TrimFixedChar := False
  else
    FOdbcConn.TrimFixedChar := True;

  TrimVarVal := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrTrimVarChar]);
  if TrimVarVal = '' then TrimVarVal := Trim(FConnectionProperties['TrimVarChar']);
  if TrimVarVal = '' then TrimVarVal := Trim(FConnectionProperties['Trim Var Char']);
  if (SameText(TrimVarVal, 'True') or (TrimVarVal = '1')) or
     (Pos('TRIMVARCHAR=TRUE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM VAR CHAR=TRUE', UpperCase(ConnStr)) > 0) or
     (Pos('TRIMVARCHAR=1', UpperCase(ConnStr)) > 0) or
     (Pos('TRIM VAR CHAR=1', UpperCase(ConnStr)) > 0) then
    FOdbcConn.TrimVarChar := True
  else
    FOdbcConn.TrimVarChar := False;
  FOdbcConn.Connect(ConnStr);
end;

procedure TDBXOpenOdbcConnectionNative.DerivedClose;
begin
  if FOdbcConn <> nil then
    FOdbcConn.Disconnect;
end;

function TDBXOpenOdbcConnectionNative.DerivedCreateCommand: TDBXCommand;
begin
  Result := TDBXOpenOdbcCommandNative.Create(FDBXContext, Self);
end;

procedure TDBXOpenOdbcConnectionNative.DerivedGetCommandTypes(const List: TStrings);
begin
  List.Add(TDBXCommandTypes.DbxSQL);
  List.Add(TDBXCommandTypes.DbxStoredProcedure);
  List.Add(TDBXCommandTypes.DbxMetaData);
end;

procedure TDBXOpenOdbcConnectionNative.DerivedGetCommands(const CommandType: string;
  const List: TStrings);
begin
  if SameText(CommandType, TDBXCommandTypes.DbxMetaData) then
  begin
    List.Add(TDBXMetaDataCommands.GetDatabase);
    List.Add(TDBXMetaDataCommands.GetDatatypes);
    List.Add(TDBXMetaDataCommands.GetCatalogs);
    List.Add(TDBXMetaDataCommands.GetSchemas);
    List.Add(TDBXMetaDataCommands.GetTables);
    List.Add(TDBXMetaDataCommands.GetViews);
    List.Add(TDBXMetaDataCommands.GetSynonyms);
    List.Add(TDBXMetaDataCommands.GetColumns);
    List.Add(TDBXMetaDataCommands.GetIndexes);
    List.Add(TDBXMetaDataCommands.GetIndexColumns);
    List.Add(TDBXMetaDataCommands.GetForeignKeys);
    List.Add(TDBXMetaDataCommands.GetForeignKeyColumns);
    List.Add(TDBXMetaDataCommands.GetProcedures);
    List.Add(TDBXMetaDataCommands.GetProcedureParameters);
  end;
end;

function TDBXOpenOdbcConnectionNative.CreateAndBeginTransaction(
  const Isolation: TDBXIsolation): TDBXTransaction;
begin
  FOdbcConn.BeginTransaction(Isolation);
  Result := TDBXOpenOdbcTransactionNative.Create(Self, Isolation, FNextTranId);
  Inc(FNextTranId);
end;

procedure TDBXOpenOdbcConnectionNative.Commit(const Transaction: TDBXTransaction);
begin
  FOdbcConn.Commit;
end;

procedure TDBXOpenOdbcConnectionNative.Rollback(const Transaction: TDBXTransaction);
begin
  FOdbcConn.Rollback;
end;

function TDBXOpenOdbcConnectionNative.GetProductVersion: string;
begin
  if (FOdbcConn <> nil) and FOdbcConn.Connected then
    Result := FOdbcConn.DbmsVersion
  else
    Result := '';
end;

function TDBXOpenOdbcConnectionNative.GetProductName: string;
begin
  if (FOdbcConn <> nil) and FOdbcConn.Connected then
    Result := FOdbcConn.DbmsName
  else
    Result := sDbxOpenOdbcDriverName;
end;

function TDBXOpenOdbcConnectionNative.GetVendorProperty(const Name: string): string;
begin
  if SameText(Name, TDBXPropertyNames.ProductName) then
    Result := GetProductName
  else if SameText(Name, TDBXPropertyNames.ProductVersion) then
    Result := GetProductVersion
  else if SameText(Name, 'DriverVersion') then
    Result := sDbxOpenOdbcVersion
  else
    Result := '';
end;

{ TDBXOpenOdbcRowNative }

constructor TDBXOpenOdbcRowNative.Create(DBXContext: TDBXContext; AStmt: TOdbcStatementHandle;
  const ColMetas: TOdbcColumnMetaArray);
var
  i: Integer;
begin
  inherited Create(DBXContext);
  FStmt := AStmt;
  SetLength(FOdbcColIndices, Length(ColMetas));
  for i := 0 to High(ColMetas) do
    FOdbcColIndices[i] := ColMetas[i].ColumnNumber;
end;

function TDBXOpenOdbcRowNative.ColNum(DbxValue: TDBXValue): SqlUSmallint;
var
  Ord: Integer;
begin
  Ord := DbxValue.ValueType.Ordinal;
  if (Ord >= 0) and (Ord < Length(FOdbcColIndices)) then
    Result := FOdbcColIndices[Ord]
  else
    Result := Ord + 1;
end;

function TDBXOpenOdbcRowNative.CreateCustomValue(const ValueType: TDBXValueType): TDBXValue;
begin
  if ValueType.DataType = TDBXDataTypes.WideStringType then
    Result := TDBXStringValue.Create(ValueType)
  else
    Result := nil;
end;

procedure TDBXOpenOdbcRowNative.GetAnsiString(DbxValue: TDBXAnsiStringValue;
  var AnsiStringBuilder: TDBXAnsiStringBuilder; var IsNull: LongBool);
var
  S: AnsiString;
begin
  FStmt.GetAnsiString(ColNum(DbxValue), S, IsNull);
  if not IsNull then
    TDBXPlatform.CopyStringToBuilder(S, Length(S) + 1, AnsiStringBuilder);
end;

procedure TDBXOpenOdbcRowNative.GetWideString(DbxValue: TDBXWideStringValue;
  var Value: string; var IsNull: LongBool);
begin
  FStmt.GetWideString(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetWideString(DbxValue: TDBXWideStringValue;
  var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  S: string;
begin
  FStmt.GetWideString(ColNum(DbxValue), S, IsNull);
  if not IsNull then
    TDBXPlatform.CopyWideStringToBuilder(S, S.Length + 1, WideStringBuilder);
end;

procedure TDBXOpenOdbcRowNative.GetBoolean(DbxValue: TDBXBooleanValue;
  var Value: LongBool; var IsNull: LongBool);
begin
  FStmt.GetBoolean(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetUInt8(DbxValue: TDBXUInt8Value;
  var Value: Byte; var IsNull: LongBool);
var
  V16: Word;
begin
  FStmt.GetUInt16(ColNum(DbxValue), V16, IsNull);
  Value := Byte(V16);
end;

procedure TDBXOpenOdbcRowNative.GetInt8(DbxValue: TDBXInt8Value;
  var Value: ShortInt; var IsNull: LongBool);
var
  V16: SmallInt;
begin
  FStmt.GetInt16(ColNum(DbxValue), V16, IsNull);
  Value := ShortInt(V16);
end;

procedure TDBXOpenOdbcRowNative.GetUInt16(DbxValue: TDBXUInt16Value;
  var Value: Word; var IsNull: LongBool);
begin
  FStmt.GetUInt16(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetInt16(DbxValue: TDBXInt16Value;
  var Value: SmallInt; var IsNull: LongBool);
begin
  FStmt.GetInt16(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetInt32(DbxValue: TDBXInt32Value;
  var Value: TInt32; var IsNull: LongBool);
begin
  FStmt.GetInt32(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetInt64(DbxValue: TDBXInt64Value;
  var Value: Int64; var IsNull: LongBool);
begin
  FStmt.GetInt64(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetSingle(DbxValue: TDBXSingleValue;
  var Value: Single; var IsNull: LongBool);
begin
  FStmt.GetSingle(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetDouble(DbxValue: TDBXDoubleValue;
  var Value: Double; var IsNull: LongBool);
begin
  FStmt.GetDouble(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetBcd(DbxValue: TDBXBcdValue;
  var Value: TBcd; var IsNull: LongBool);
begin
  FStmt.GetBcd(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetDate(DbxValue: TDBXDateValue;
  var Value: TDBXDate; var IsNull: LongBool);
begin
  FStmt.GetDate(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetTime(DbxValue: TDBXTimeValue;
  var Value: TDBXTime; var IsNull: LongBool);
begin
  FStmt.GetTime(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
begin
  FStmt.GetTimeStamp(ColNum(DbxValue), Value, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetBytes(DbxValue: TDBXByteArrayValue;
  Offset: Int64; const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
  var ReturnLength: Int64; var IsNull: LongBool);
begin
  FStmt.GetBytes(ColNum(DbxValue), Offset, Buffer, BufferOffset, Length, ReturnLength, IsNull);
end;

procedure TDBXOpenOdbcRowNative.GetByteLength(DbxValue: TDBXByteArrayValue;
  var ByteLength: Int64; var IsNull: LongBool);
begin
  FStmt.GetByteLength(ColNum(DbxValue), ByteLength, IsNull);
end;

{ TDBXOpenOdbcReaderNative }

constructor TDBXOpenOdbcReaderNative.Create(DBXContext: TDBXContext;
  AStmt: TOdbcStatementHandle; const ColMetas: TOdbcColumnMetaArray; AOwnsStmt: Boolean);
var
  Row: TDBXOpenOdbcRowNative;
begin
  Row := TDBXOpenOdbcRowNative.Create(DBXContext, AStmt, ColMetas);
  inherited Create(DBXContext, Row, nil);
  FStmt := AStmt;
  FOwnsStmt := AOwnsStmt;
  InitColumns(ColMetas);
end;

destructor TDBXOpenOdbcReaderNative.Destroy;
begin
  FreeAndNil(FByteReader);
  inherited;
  if FOwnsStmt then
    FreeAndNil(FStmt);
end;

procedure TDBXOpenOdbcReaderNative.InitColumns(const ColMetas: TOdbcColumnMetaArray);
var
  Values: TDBXWritableValueArray;
  i: Integer;
  VT: TDBXValueType;
  Flags: TInt32;
begin
  SetLength(Values, Length(ColMetas));
  for i := 0 to High(ColMetas) do
  begin
    VT := TDBXDriverHelp.CreateTDBXValueType(FDBXContext, FDbxRow);
    VT.Name := ColMetas[i].Name;
    VT.DisplayName := ColMetas[i].Name;
    VT.Ordinal := i;
    VT.DataType := ColMetas[i].DBXDataType;
    VT.SubType := ColMetas[i].DBXSubType;
    VT.Size := ColMetas[i].DBXSize;
    VT.Precision := ColMetas[i].DBXPrecision;
    VT.Scale := ColMetas[i].DBXScale;
    Flags := TDBXValueTypeFlags.Searchable;
    if ColMetas[i].Nullable <> SQL_NO_NULLS then
      Flags := Flags or TDBXValueTypeFlags.Nullable;
    VT.ValueTypeFlags := Flags;

    Values[i] := TDBXValue.CreateValue(FDBXContext, VT, FDbxRow, True);
  end;
  SetValues(Values);
end;

function TDBXOpenOdbcReaderNative.DerivedNext: Boolean;
begin
  Result := FStmt.FetchNext;
  if not Result then
  begin
    // Devart-style autonomous EOF defense:
    // Once EOF is reached, proactively close the statement cursor so that subsequent
    // SQLMoreResults or commands on the same connection are never blocked,
    // even if Delphi RTL fails to invoke CloseReader due to missing FLastReader assignment.
    if FStmt <> nil then
      // In ODBC, SQLMoreResults automatically closes the current cursor and advances to the next.
  // FStmt.CloseCursor; should NOT be called here because SQLFreeStmt(SQL_CLOSE) discards all pending results!
  end;
end;

function TDBXOpenOdbcReaderNative.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader := TDBXReaderByteReader.Create(FDBXContext, Self);
  Result := FByteReader;
end;

procedure TDBXOpenOdbcReaderNative.DerivedClose;
begin
  FreeAndNil(FByteReader);
  // Autonomous defense on reader close: ensure cursor is closed
  if FStmt <> nil then
    // In ODBC, SQLMoreResults automatically closes the current cursor and advances to the next.
  // FStmt.CloseCursor; should NOT be called here because SQLFreeStmt(SQL_CLOSE) discards all pending results!
end;

{ TDBXOpenOdbcCommandNative }

constructor TDBXOpenOdbcCommandNative.Create(DBXContext: TDBXContext;
  AConnection: TDBXOpenOdbcConnectionNative);
begin
  inherited Create(DBXContext);
  FOdbcConnection := AConnection;
  FRowSetSize := 20;
  FMaxBlobSize := -1;
end;

destructor TDBXOpenOdbcCommandNative.Destroy;
begin
  Close;
  FreeAndNil(FStmt);
  inherited;
end;

function TDBXOpenOdbcCommandNative.CreateParameterRow: TDBXRow;
begin
  Result := TDBXOpenOdbcParameterRow.Create(FDBXContext);
end;

procedure TDBXOpenOdbcCommandNative.SetRowSetSize(const RowSetSize: Int64);
begin
  FRowSetSize := RowSetSize;
end;

procedure TDBXOpenOdbcCommandNative.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  FMaxBlobSize := MaxBlobSize;
end;

function TDBXOpenOdbcCommandNative.GetRowsAffected: Int64;
begin
  if FStmt <> nil then
    Result := FStmt.RowsAffected
  else
    Result := -1;
end;

procedure TDBXOpenOdbcCommandNative.DerivedOpen;
begin
  if FStmt = nil then
    FStmt := TOdbcStatementHandle.Create(FOdbcConnection.OdbcConn);
end;

procedure TDBXOpenOdbcCommandNative.DerivedClose;
begin
  if FStmt <> nil then
    FStmt.FreeStatement;
end;

procedure TDBXOpenOdbcCommandNative.DerivedPrepare;
var
  NumParams, i: SqlSmallint;
  SqlType, DecDigits, Nullable: SqlSmallint;
  ParamSize: TSqlULen;
  Param: TDBXParameter;
begin
  DerivedOpen;
  if not SameText(CommandType, TDBXCommandTypes.DbxMetaData) then
  begin
    FStmt.Prepare(Text);

    // 若呼叫端尚未手動加入參數，依據 ODBC 探測到的參數個數自動建立 Parameters
    if (Parameters <> nil) and (Parameters.Count = 0) then
    begin
      NumParams := FStmt.GetNumParams;
      for i := 1 to NumParams do
      begin
        Param := CreateParameter;
        if FStmt.DescribeParam(i, SqlType, ParamSize, DecDigits, Nullable) then
          Param.DataType := MapOdbcParamTypeToDbx(SqlType)
        else
          Param.DataType := TDBXDataTypes.WideStringType;

        Param.Name := 'Param' + IntToStr(i);
        Parameters.AddParameter(Param);
      end;
    end;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateDatabaseMetaDataReader: TDBXReader;
var
  QuoteCh: string;
begin
  if (FOdbcConnection <> nil) and (FOdbcConnection.OdbcConn <> nil) then
    QuoteCh := FOdbcConnection.OdbcConn.QuoteChar
  else
    QuoteCh := '"';
  Result := TDBXOpenOdbcDatabaseMetaReader.Create(FDBXContext, QuoteCh);
end;

function CreateOdbcProceduresMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const ProcedureTypes: string): TDBXReader;
var
  Table: TDBXMemoryTable;
  Kind, Filter: string;
  Names: array[0..2] of string;
  NullNames: array[0..2] of LongBool;
  I, ProcedureType: Integer;
  IsNull: LongBool;
begin
  if (Source = nil) or (Source.ColumnCount < 8) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLProcedures metadata columns');
  Filter := UpperCase(ProcedureTypes);
  Table := nil;
  try
    Table := TDBXMemoryTable.Create;
    Table.Columns := TDBXMetaDataCollectionColumns.CreateProceduresColumns;
    while Source.Next do
    begin
      // Read ODBC columns in ascending order for forward-only drivers.
      for I := 0 to 2 do
      begin
        NullNames[I] := Source.Value[I].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I].AsString;
      end;
      IsNull := Source.Value[7].IsNull;
      Kind := '';
      if not IsNull then
      begin
        ProcedureType := Source.Value[7].AsInt32;
        case ProcedureType of
          1: Kind := 'PROCEDURE'; // SQL_PT_PROCEDURE
          2: Kind := 'FUNCTION';  // SQL_PT_FUNCTION
        end;
      end;
      if (Filter <> '') and (Filter <> '%') and
        ((Kind = '') or (Pos(Kind, Filter) = 0)) then
        Continue;
      Table.Insert;
      for I := 0 to 2 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      if Kind = '' then Table.Value[3].SetNull
      else Table.Value[3].SetWideString(Kind);
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil; // Reader owns the materialized table.
  finally
    Table.Free;
  end;
end;

function CreateOdbcProcedureParametersMetadata(DBXContext: TDBXContext;
  Source: TDBXReader): TDBXReader;
var
  Table: TDBXMemoryTable;
  Mode, TypeName: string;
  Names: array[0..3] of string;
  NullNames: array[0..3] of LongBool;
  I, ColumnType, SqlType, Nullable: Integer;
  IsNull, SqlTypeNull: Boolean;
  DbxType: TDBXType;
begin
  if (Source = nil) or (Source.ColumnCount < 19) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLProcedureColumns metadata columns');
  Table := nil;
  try
    Table := TDBXMemoryTable.Create;
    Table.Columns := TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns;
    while Source.Next do
    begin
      for I := 0 to 3 do
      begin
        NullNames[I] := Source.Value[I].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I].AsString;
      end;
      IsNull := Source.Value[4].IsNull;
      ColumnType := 0;
      if not IsNull then ColumnType := Source.Value[4].AsInt32;
      if not IsNull and (ColumnType = 3) then Continue; // SQL_RESULT_COL is not a parameter.
      Mode := '';
      if not IsNull then
        case ColumnType of
          SQL_PARAM_INPUT: Mode := 'IN';
          SQL_PARAM_INPUT_OUTPUT: Mode := 'INOUT';
          SQL_PARAM_OUTPUT: Mode := 'OUT';
          SQL_RETURN_VALUE: Mode := 'RESULT';
        end;
      SqlTypeNull := Source.Value[5].IsNull;
      SqlType := 0;
      if not SqlTypeNull then SqlType := Source.Value[5].AsInt32;
      DbxType := MapOdbcParamTypeToDbx(SqlType);
      if (SqlType = SQL_NUMERIC) or (SqlType = SQL_DECIMAL) then DbxType := TDBXDataTypes.BcdType;
      IsNull := Source.Value[6].IsNull;
      if not IsNull then TypeName := Source.Value[6].AsString;
      Table.Insert;
      for I := 0 to 3 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      if Mode = '' then Table.Value[4].SetNull else Table.Value[4].SetWideString(Mode);
      if IsNull then Table.Value[5].SetNull else Table.Value[5].SetWideString(TypeName);
      if Source.Value[7].IsNull then Table.Value[6].SetNull
      else Table.Value[6].SetInt64(Source.Value[7].AsInt64);
      if Source.Value[9].IsNull then Table.Value[7].SetNull
      else Table.Value[7].SetInt32(Source.Value[9].AsInt32);
      IsNull := Source.Value[11].IsNull;
      Nullable := SQL_NULLABLE_UNKNOWN;
      if not IsNull then Nullable := Source.Value[11].AsInt32;
      if Source.Value[17].IsNull then Table.Value[8].SetNull
      else Table.Value[8].SetInt32(Source.Value[17].AsInt32);
      if IsNull or (Nullable = SQL_NULLABLE_UNKNOWN) then Table.Value[9].SetNull
      else Table.Value[9].SetBoolean(Nullable <> SQL_NO_NULLS);
      if SqlTypeNull then Table.Value[10].SetNull else Table.Value[10].SetInt32(DbxType);
      Table.Value[11].SetBoolean((SqlType = SQL_CHAR) or (SqlType = SQL_WCHAR) or (SqlType = SQL_BINARY));
      Table.Value[12].SetBoolean((SqlType = SQL_WCHAR) or (SqlType = SQL_WVARCHAR) or (SqlType = SQL_WLONGVARCHAR));
      Table.Value[13].SetBoolean((SqlType = SQL_LONGVARCHAR) or (SqlType = SQL_WLONGVARCHAR) or (SqlType = SQL_LONGVARBINARY));
      Table.Value[14].SetNull; // SQLProcedureColumns does not report signedness.
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function TableMetadataColumns(const Collection: string): TDBXValueTypeArray;
begin
  if SameText(Collection, TDBXMetaDataCommands.GetViews) then
    Result := TDBXMetaDataCollectionColumns.CreateViewsColumns
  else if SameText(Collection, TDBXMetaDataCommands.GetSynonyms) then
    Result := TDBXMetaDataCollectionColumns.CreateSynonymsColumns
  else if SameText(Collection, TDBXMetaDataCommands.GetProcedures) then
    Result := TDBXMetaDataCollectionColumns.CreateProceduresColumns
  else
    Result := TDBXMetaDataCollectionColumns.CreateTablesColumns;
end;

function CreateOdbcTablesMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const TableTypes, Collection: string): TDBXReader;
var
  Table: TDBXMemoryTable;
  Filter, Kind: string;
  Names: array[0..2] of string;
  NullNames: array[0..2] of Boolean;
  I: Integer;
begin
  if (Source = nil) or (Source.ColumnCount < 4) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLTables metadata columns');
  Filter := NormalizeOdbcTableTypes(TableTypes);
  Table := TDBXMemoryTable.Create;
  try
    Table.Columns := TableMetadataColumns(Collection);
    while Source.Next do
    begin
      for I := 0 to 2 do
      begin
        NullNames[I] := Source.Value[I].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I].AsString;
      end;
      Kind := UpperCase(Trim(Source.Value[3].AsString));
      if (Filter <> '') and (Pos(','+Kind+',', ','+Filter+',') = 0) then Continue;
      if Kind = 'TABLE' then Kind := 'Table'
      else if Kind = 'VIEW' then Kind := 'View'
      else if Kind = 'SYSTEM TABLE' then Kind := 'SystemTable'
      else if Kind = 'SYSTEM VIEW' then Kind := 'SystemView'
      else if (Kind = 'SYNONYM') or (Kind = 'ALIAS') then Kind := 'Synonym';
      Table.Insert;
      for I := 0 to 2 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      if SameText(Collection, TDBXMetaDataCommands.GetTables) then
        Table.Value[3].SetWideString(Kind)
      else
        for I := 3 to Length(Table.Columns)-1 do Table.Value[I].SetNull;
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally Table.Free end;
end;

function TDBXOpenOdbcCommandNative.CreateSqlServerMetaDataReader(
  const Identifier, Types, Collection: string): TDBXReader;
var
  Catalog, Schema, Pattern, SQL, FromSQL, TypeSQL, FilterSQL, Name, Value, QuotedCatalog: string;
  Catalogs, Kinds: TStringList;
  Table: TDBXMemoryTable;
  IsNull: LongBool;
  I: Integer;
begin
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  Catalogs := TStringList.Create;
  Kinds := TStringList.Create;
  Table := nil;
  try
    DerivedOpen;
    if Catalog = '' then SQL := 'SELECT DB_NAME()'
    else SQL := 'SELECT name FROM sys.databases WHERE name LIKE N'+QuotedStr(Catalog)+
      ' AND HAS_DBACCESS(name)=1';
    FStmt.ExecuteDirect(SQL);
    while FStmt.FetchNext do
    begin
      FStmt.GetWideString(1, Value, IsNull);
      if not IsNull then Catalogs.Add(Value);
    end;
    FStmt.FreeStatement;
    if SameText(Collection, TDBXMetaDataCommands.GetProcedures) then
    begin
      if (Trim(Types) = '') or (Types = '%') or (Pos('PROCEDURE', UpperCase(Types)) > 0) then
        Kinds.Add('PROCEDURE');
      if (Trim(Types) = '') or (Types = '%') or (Pos('FUNCTION', UpperCase(Types)) > 0) then
        Kinds.Add('FUNCTION');
      if Kinds.Count = 0 then
        raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Unknown procedure type');
      TypeSQL := 'CASE WHEN o.type IN (''FN'',''IF'',''TF'',''FS'',''FT'') THEN ''FUNCTION'' ELSE ''PROCEDURE'' END';
      FilterSQL := 'o.type IN (''P'',''PC'',''X'',''FN'',''IF'',''TF'',''FS'',''FT'') AND o.is_ms_shipped=0';
    end
    else
    begin
      for Name in NormalizeOdbcTableTypes(Types).Split([','], TStringSplitOptions.ExcludeEmpty) do
      begin
        Value := Name;
        if Name = 'TABLE' then Value := 'Table'
        else if Name = 'VIEW' then Value := 'View'
        else if Name = 'SYSTEM TABLE' then Value := 'SystemTable'
        else if Name = 'SYSTEM VIEW' then Value := 'SystemView'
        else if (Name = 'SYNONYM') or (Name = 'ALIAS') then Value := 'Synonym';
        if Kinds.IndexOf(Value) < 0 then Kinds.Add(Value);
      end;
      TypeSQL := 'CASE WHEN o.type=''SN'' THEN ''Synonym'' '+
        'WHEN o.type=''V'' AND o.is_ms_shipped=1 THEN ''SystemView'' '+
        'WHEN o.type=''V'' THEN ''View'' WHEN o.is_ms_shipped=1 THEN ''SystemTable'' ELSE ''Table'' END';
      FilterSQL := 'o.type IN (''U'',''V'',''S'',''IT'',''SN'')';
    end;
    if Kinds.Count > 0 then
    begin
      FilterSQL := FilterSQL+' AND ('+TypeSQL+') IN (';
      for I := 0 to Kinds.Count-1 do
      begin
        if I > 0 then FilterSQL := FilterSQL+',';
        FilterSQL := FilterSQL+QuotedStr(Kinds[I]);
      end;
      FilterSQL := FilterSQL+')';
    end;
    if Schema <> '' then FilterSQL := FilterSQL+' AND s.name LIKE N'+QuotedStr(Schema);
    if Pattern <> '' then FilterSQL := FilterSQL+' AND o.name LIKE N'+QuotedStr(Pattern);
    Table := TDBXMemoryTable.Create;
    Table.Columns := TableMetadataColumns(Collection);
    for Name in Catalogs do
    begin
      QuotedCatalog := '['+StringReplace(Name, ']', ']]', [rfReplaceAll])+']';
      FromSQL := QuotedCatalog+'.sys.objects o JOIN '+QuotedCatalog+
        '.sys.schemas s ON s.schema_id=o.schema_id';
      SQL := 'SELECT N'+QuotedStr(Name)+',s.name,o.name,CAST(('+TypeSQL+
        ') AS nvarchar(32)) FROM '+FromSQL+' WHERE '+FilterSQL+' ORDER BY s.name,o.name';
      FStmt.ExecuteDirect(SQL);
      while FStmt.FetchNext do
      begin
        Table.Insert;
        for I := 0 to 2 do
        begin
          FStmt.GetWideString(I+1, Value, IsNull);
          if IsNull then Table.Value[I].SetNull else Table.Value[I].SetWideString(Value);
        end;
        FStmt.GetWideString(4, Value, IsNull);
        if SameText(Collection, TDBXMetaDataCommands.GetTables) or
          SameText(Collection, TDBXMetaDataCommands.GetProcedures) then
          Table.Value[3].SetWideString(Value)
        else
          for I := 3 to Length(Table.Columns)-1 do Table.Value[I].SetNull;
        Table.Post;
      end;
      FStmt.FreeStatement;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(FDBXContext, Table);
    Table := nil;
  finally
    Table.Free;
    Kinds.Free;
    Catalogs.Free;
    if FStmt <> nil then FStmt.FreeStatement;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateTablesMetaDataReader(
  const Identifier, TableTypes, Collection: string): TDBXReader;
var
  Catalog, Schema, Pattern: string;
  Source: TDBXReader;
begin
  if Pos('SQL SERVER', UpperCase(FOdbcConnection.OdbcConn.DbmsName)) > 0 then
    Exit(CreateSqlServerMetaDataReader(Identifier, TableTypes, Collection));
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  FStmt.ExecuteCatalogTables(Catalog, Schema, Pattern, TableTypes);
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try Result := CreateOdbcTablesMetadata(FDBXContext, Source, TableTypes, Collection);
  finally Source.Free end;
end;

function TDBXOpenOdbcCommandNative.CreateProceduresMetaDataReader(
  const Identifier, ProcedureTypes: string): TDBXReader;
var
  Catalog, Schema, Pattern: string;
  Source: TDBXReader;
begin
  if Pos('SQL SERVER', UpperCase(FOdbcConnection.OdbcConn.DbmsName)) > 0 then
    Exit(CreateSqlServerMetaDataReader(Identifier, ProcedureTypes, TDBXMetaDataCommands.GetProcedures));
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  FStmt.ExecuteCatalogProcedures(Catalog, Schema, Pattern);
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try
    Result := CreateOdbcProceduresMetadata(FDBXContext, Source, ProcedureTypes);
  finally
    Source.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateProcedureParametersMetaDataReader(
  const Identifier: string): TDBXReader;
var
  Catalog, Schema, Pattern: string;
  Source: TDBXReader;
begin
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  FStmt.ExecuteCatalogProcedureColumns(Catalog, Schema, Pattern);
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try
    Result := CreateOdbcProcedureParametersMetadata(FDBXContext, Source);
  finally
    Source.Free;
  end;
end;

function UnquoteMetadataPart(const Part: string): string;
var
  QuoteEnd: Char;
begin
  Result := Trim(Part);
  if (Length(Result) >= 2) and CharInSet(Result[1], ['"', '''', '`', '[']) then
  begin
    QuoteEnd := Result[1];
    if QuoteEnd = '[' then QuoteEnd := ']';
    Result := Copy(Result, 2, Length(Result) - 2);
    Result := StringReplace(Result, string(QuoteEnd) + QuoteEnd, QuoteEnd, [rfReplaceAll]);
  end;
end;

function CreateOdbcColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader): TDBXReader;
type
  TColumnMetaRow = record
    Names: array[0..3] of string;
    NullNames: array[0..3] of Boolean;
    SqlTypeNull: Boolean;
    SqlType: Integer;
    TypeNameNull: Boolean;
    TypeName: string;
    PrecisionNull: Boolean;
    Precision: Int64;
    ScaleNull: Boolean;
    Scale: Integer;
    NullableNull: Boolean;
    Nullable: Integer;
    DefNull: Boolean;
    DefVal: string;
    OrdinalNull: Boolean;
    Ordinal: Integer;
  end;
var
  Table: TDBXMemoryTable;
  Rows: TArray<TColumnMetaRow>;
  RowCount, I, J, Seq: Integer;
  Row, Temp: TColumnMetaRow;
  DbxType: TDBXType;
  UpperType: string;
begin
  if (Source = nil) or (Source.ColumnCount < 17) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLColumns metadata columns');
  RowCount := 0;
  Seq := 0;
  while Source.Next do
  begin
    Inc(Seq);
    // Release managed strings retained by the previous row before resetting it.
    Row := Default(TColumnMetaRow);
    // Read ODBC columns in strictly ascending order (0,1,2,3,4,5,6,8,10,12,16)
    for I := 0 to 3 do
    begin
      Row.NullNames[I] := Source.Value[I].IsNull;
      if not Row.NullNames[I] then Row.Names[I] := Source.Value[I].AsString;
    end;
    Row.SqlTypeNull := Source.Value[4].IsNull;
    if not Row.SqlTypeNull then Row.SqlType := Source.Value[4].AsInt32;
    Row.TypeNameNull := Source.Value[5].IsNull;
    if not Row.TypeNameNull then Row.TypeName := Source.Value[5].AsString;
    Row.PrecisionNull := Source.Value[6].IsNull;
    if not Row.PrecisionNull then Row.Precision := Source.Value[6].AsInt64;
    Row.ScaleNull := Source.Value[8].IsNull;
    if not Row.ScaleNull then Row.Scale := Source.Value[8].AsInt32;
    Row.NullableNull := Source.Value[10].IsNull;
    if not Row.NullableNull then Row.Nullable := Source.Value[10].AsInt32
    else Row.Nullable := SQL_NULLABLE_UNKNOWN;
    Row.DefNull := Source.Value[12].IsNull;
    if not Row.DefNull then Row.DefVal := Source.Value[12].AsString;
    Row.OrdinalNull := Source.Value[16].IsNull;
    if not Row.OrdinalNull then Row.Ordinal := Source.Value[16].AsInt32
    else Row.Ordinal := Seq;

    SetLength(Rows, RowCount + 1);
    Rows[RowCount] := Row;
    Inc(RowCount);
  end;

  // Stable insertion sort by (Catalog, Schema, Table, Ordinal) to guarantee table definition order
  for I := 1 to RowCount - 1 do
  begin
    Temp := Rows[I];
    J := I - 1;
    while (J >= 0) and
      SameText(Rows[J].Names[0], Temp.Names[0]) and
      SameText(Rows[J].Names[1], Temp.Names[1]) and
      SameText(Rows[J].Names[2], Temp.Names[2]) and
      (Rows[J].Ordinal > Temp.Ordinal) do
    begin
      Rows[J + 1] := Rows[J];
      Dec(J);
    end;
    Rows[J + 1] := Temp;
  end;

  Table := TDBXMemoryTable.Create;
  try
    Table.Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
    for I := 0 to RowCount - 1 do
    begin
      Row := Rows[I];
      DbxType := MapOdbcParamTypeToDbx(Row.SqlType);
      if (Row.SqlType = SQL_NUMERIC) or (Row.SqlType = SQL_DECIMAL) then
        DbxType := TDBXDataTypes.BcdType;
      UpperType := UpperCase(Row.TypeName);

      Table.Insert;
      for J := 0 to 3 do
        if Row.NullNames[J] then Table.Value[J].SetNull
        else Table.Value[J].SetWideString(Row.Names[J]);
      if Row.TypeNameNull then Table.Value[4].SetNull
      else Table.Value[4].SetWideString(Row.TypeName);
      if Row.PrecisionNull then Table.Value[5].SetNull
      else Table.Value[5].SetInt64(Row.Precision);
      if Row.ScaleNull then Table.Value[6].SetNull
      else Table.Value[6].SetInt32(Row.Scale);
      Table.Value[7].SetInt32(Row.Ordinal);
      if Row.DefNull then Table.Value[8].SetNull
      else Table.Value[8].SetWideString(Row.DefVal);
      if Row.NullableNull or (Row.Nullable = SQL_NULLABLE_UNKNOWN) then
        Table.Value[9].SetBoolean(True)
      else
        Table.Value[9].SetBoolean(Row.Nullable <> SQL_NO_NULLS);
      Table.Value[10].SetBoolean((Pos('IDENTITY', UpperType) > 0) or
        (Pos('AUTOINC', UpperType) > 0) or (UpperType = 'COUNTER'));
      Table.Value[11].SetNull; // MaxInline
      if Row.SqlTypeNull then Table.Value[12].SetNull
      else Table.Value[12].SetInt32(DbxType);
      Table.Value[13].SetBoolean((Row.SqlType = SQL_CHAR) or (Row.SqlType = SQL_WCHAR) or (Row.SqlType = SQL_BINARY));
      Table.Value[14].SetBoolean((Row.SqlType = SQL_WCHAR) or (Row.SqlType = SQL_WVARCHAR) or (Row.SqlType = SQL_WLONGVARCHAR));
      Table.Value[15].SetBoolean((Row.SqlType = SQL_LONGVARCHAR) or (Row.SqlType = SQL_WLONGVARCHAR) or
        (Row.SqlType = SQL_LONGVARBINARY) or (not Row.PrecisionNull and (Row.Precision > 8000)));
      Table.Value[16].SetBoolean(Pos('UNSIGNED', UpperType) > 0);
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function CreateOdbcIndexesMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  PrimaryKeys: TStrings): TDBXReader;
var
  Table: TDBXMemoryTable;
  Seen: TStringList;
  Names: array[0..2] of string;
  NullNames: array[0..2] of Boolean;
  IndexName, AscOrDesc, Key: string;
  NonUnique, IndexType, I: Integer;
  IsPrimary, IsUnique, IsAsc: Boolean;
begin
  if (Source = nil) or (Source.ColumnCount < 10) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLStatistics metadata columns');
  Table := TDBXMemoryTable.Create;
  Seen := TStringList.Create;
  try
    Seen.CaseSensitive := False;
    Table.Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
    while Source.Next do
    begin
      // Read ODBC SQLStatistics columns in ascending order: 0, 1, 2, 3, 5, 6, 9
      for I := 0 to 2 do
      begin
        NullNames[I] := Source.Value[I].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I].AsString else Names[I] := '';
      end;
      NonUnique := 1;
      if not Source.Value[3].IsNull then NonUnique := Source.Value[3].AsInt32;
      IndexName := '';
      if not Source.Value[5].IsNull then IndexName := Trim(Source.Value[5].AsString);
      IndexType := SQL_TABLE_STAT;
      if not Source.Value[6].IsNull then IndexType := Source.Value[6].AsInt32;
      AscOrDesc := 'A';
      if not Source.Value[9].IsNull then AscOrDesc := Trim(Source.Value[9].AsString);

      if (IndexType = SQL_TABLE_STAT) or (IndexName = '') then
        Continue;

      Key := Names[0] + #1 + Names[1] + #1 + Names[2] + #1 + IndexName;
      if Seen.IndexOf(Key) >= 0 then
        Continue;
      Seen.Add(Key);

      IsPrimary := ((PrimaryKeys <> nil) and (PrimaryKeys.IndexOf(IndexName) >= 0)) or
        (((PrimaryKeys = nil) or (PrimaryKeys.Count = 0)) and
         (SameText(IndexName, 'PrimaryKey') or (Pos('PK_', UpperCase(IndexName)) = 1)));
      IsUnique := (NonUnique = 0) or IsPrimary;
      IsAsc := not SameText(AscOrDesc, 'D');

      Table.Insert;
      for I := 0 to 2 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      Table.Value[3].SetWideString(IndexName);
      if IsPrimary then Table.Value[4].SetWideString(IndexName)
      else Table.Value[4].SetNull;
      Table.Value[5].SetBoolean(IsPrimary);
      Table.Value[6].SetBoolean(IsUnique);
      Table.Value[7].SetBoolean(IsAsc);
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Seen.Free;
    Table.Free;
  end;
end;

function CreateOdbcIndexColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const IndexNameFilter: string): TDBXReader;
var
  Table: TDBXMemoryTable;
  Names: array[0..2] of string;
  NullNames: array[0..2] of Boolean;
  IndexName, ColumnName, AscOrDesc, CleanFilter: string;
  IndexType, Ordinal, Seq, I: Integer;
begin
  if (Source = nil) or (Source.ColumnCount < 10) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLStatistics metadata columns');
  CleanFilter := UnquoteMetadataPart(IndexNameFilter);
  Table := TDBXMemoryTable.Create;
  try
    Table.Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
    Seq := 0;
    while Source.Next do
    begin
      // Read ODBC SQLStatistics columns in ascending order: 0, 1, 2, 5, 6, 7, 8, 9
      for I := 0 to 2 do
      begin
        NullNames[I] := Source.Value[I].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I].AsString else Names[I] := '';
      end;
      IndexName := '';
      if not Source.Value[5].IsNull then IndexName := Trim(Source.Value[5].AsString);
      IndexType := SQL_TABLE_STAT;
      if not Source.Value[6].IsNull then IndexType := Source.Value[6].AsInt32;
      Ordinal := 0;
      if not Source.Value[7].IsNull then Ordinal := Source.Value[7].AsInt32;
      ColumnName := '';
      if not Source.Value[8].IsNull then ColumnName := Trim(Source.Value[8].AsString);
      AscOrDesc := 'A';
      if not Source.Value[9].IsNull then AscOrDesc := Trim(Source.Value[9].AsString);

      if (IndexType = SQL_TABLE_STAT) or (IndexName = '') or (ColumnName = '') then
        Continue;
      if (CleanFilter <> '') and (CleanFilter <> '%') and not SameText(IndexName, CleanFilter) then
        Continue;

      Inc(Seq);
      if Ordinal <= 0 then Ordinal := Seq;

      Table.Insert;
      for I := 0 to 2 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      Table.Value[3].SetWideString(IndexName);
      Table.Value[4].SetWideString(ColumnName);
      Table.Value[5].SetInt32(Ordinal);
      Table.Value[6].SetBoolean(not SameText(AscOrDesc, 'D'));
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function CreateOdbcForeignKeysMetadata(DBXContext: TDBXContext; Source: TDBXReader): TDBXReader;
var
  Table: TDBXMemoryTable;
  Seen: TStringList;
  Names: array[0..2] of string;
  NullNames: array[0..2] of Boolean;
  FKName, Key: string;
  I: Integer;
begin
  if (Source = nil) or (Source.ColumnCount < 12) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLForeignKeys metadata columns');
  Table := TDBXMemoryTable.Create;
  Seen := TStringList.Create;
  try
    Seen.CaseSensitive := False;
    Table.Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
    while Source.Next do
    begin
      // Read ODBC SQLForeignKeys columns in ascending order: 4, 5, 6, 11
      for I := 0 to 2 do
      begin
        NullNames[I] := Source.Value[I + 4].IsNull;
        if not NullNames[I] then Names[I] := Source.Value[I + 4].AsString else Names[I] := '';
      end;
      FKName := '';
      if not Source.Value[11].IsNull then FKName := Trim(Source.Value[11].AsString);
      if FKName = '' then Continue;

      Key := Names[0] + #1 + Names[1] + #1 + Names[2] + #1 + FKName;
      if Seen.IndexOf(Key) >= 0 then Continue;
      Seen.Add(Key);

      Table.Insert;
      for I := 0 to 2 do
        if NullNames[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(Names[I]);
      Table.Value[3].SetWideString(FKName);
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Seen.Free;
    Table.Free;
  end;
end;

function CreateOdbcForeignKeyColumnsMetadata(DBXContext: TDBXContext; Source: TDBXReader;
  const ForeignKeyFilter: string): TDBXReader;
var
  Table: TDBXMemoryTable;
  PKNames: array[0..3] of string;
  PKNulls: array[0..3] of Boolean;
  FKNames: array[0..3] of string;
  FKNulls: array[0..3] of Boolean;
  FKName, PKName, CleanFilter: string;
  FKNameNull, PKNameNull: Boolean;
  KeySeq, Seq, I: Integer;
begin
  if (Source = nil) or (Source.ColumnCount < 13) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Expected SQLForeignKeys metadata columns');
  CleanFilter := UnquoteMetadataPart(ForeignKeyFilter);
  Table := TDBXMemoryTable.Create;
  try
    Table.Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
    Seq := 0;
    while Source.Next do
    begin
      // Read ODBC SQLForeignKeys columns in ascending order: 0..3, 4..7, 8, 11, 12
      for I := 0 to 3 do
      begin
        PKNulls[I] := Source.Value[I].IsNull;
        if not PKNulls[I] then PKNames[I] := Source.Value[I].AsString else PKNames[I] := '';
      end;
      for I := 0 to 3 do
      begin
        FKNulls[I] := Source.Value[I + 4].IsNull;
        if not FKNulls[I] then FKNames[I] := Source.Value[I + 4].AsString else FKNames[I] := '';
      end;
      KeySeq := 0;
      if not Source.Value[8].IsNull then KeySeq := Source.Value[8].AsInt32;
      FKNameNull := Source.Value[11].IsNull;
      if not FKNameNull then FKName := Trim(Source.Value[11].AsString) else FKName := '';
      PKNameNull := Source.Value[12].IsNull;
      if not PKNameNull then PKName := Trim(Source.Value[12].AsString) else PKName := '';

      if (CleanFilter <> '') and (CleanFilter <> '%') and not SameText(FKName, CleanFilter) then
        Continue;

      Inc(Seq);
      if KeySeq <= 0 then KeySeq := Seq;

      Table.Insert;
      // 0..2: FK Catalog, Schema, Table
      for I := 0 to 2 do
        if FKNulls[I] then Table.Value[I].SetNull
        else Table.Value[I].SetWideString(FKNames[I]);
      // 3: ForeignKeyName
      if FKNameNull then Table.Value[3].SetNull else Table.Value[3].SetWideString(FKName);
      // 4: FK ColumnName
      if FKNulls[3] then Table.Value[4].SetNull else Table.Value[4].SetWideString(FKNames[3]);
      // 5..7: PK Catalog, Schema, Table
      for I := 0 to 2 do
        if PKNulls[I] then Table.Value[I + 5].SetNull
        else Table.Value[I + 5].SetWideString(PKNames[I]);
      // 8: PrimaryKeyName
      if PKNameNull then Table.Value[8].SetNull else Table.Value[8].SetWideString(PKName);
      // 9: PrimaryColumnName
      if PKNulls[3] then Table.Value[9].SetNull else Table.Value[9].SetWideString(PKNames[3]);
      // 10: Ordinal
      Table.Value[10].SetInt32(KeySeq);
      Table.Post;
    end;
    Result := TDBXOpenOdbcMetaTableReader.Create(DBXContext, Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateDataTypesMetaDataReader: TDBXReader;
var
  Table: TDBXMemoryTable;
begin
  Table := TDBXMemoryTable.Create;
  try
    Table.Columns := TDBXMetaDataCollectionColumns.CreateDataTypesColumns;
    Result := TDBXOpenOdbcMetaTableReader.Create(FDBXContext, Table);
    Table := nil;
  finally
    Table.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateColumnsMetaDataReader(
  const Identifier: string): TDBXReader;
var
  Catalog, Schema, Pattern: string;
  Source: TDBXReader;
begin
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  FStmt.ExecuteCatalogColumns(Catalog, Schema, Pattern, '');
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try
    Result := CreateOdbcColumnsMetadata(FDBXContext, Source);
  finally
    Source.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateIndexesMetaDataReader(
  const Identifier: string): TDBXReader;
var
  Catalog, Schema, Pattern, PKName: string;
  IsNull: LongBool;
  PrimaryKeys: TStringList;
  Source: TDBXReader;
begin
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  PrimaryKeys := TStringList.Create;
  try
    PrimaryKeys.CaseSensitive := False;
    try
      FStmt.ExecuteCatalogPrimaryKeys(Catalog, Schema, Pattern);
      while FStmt.FetchNext do
      begin
        FStmt.GetWideString(6, PKName, IsNull);
        if not IsNull and (Trim(PKName) <> '') and (PrimaryKeys.IndexOf(Trim(PKName)) < 0) then
          PrimaryKeys.Add(Trim(PKName));
      end;
    except
      // Optional ODBC catalog function: ignore if driver does not support SQLPrimaryKeysW
    end;
    // In ODBC, SQLMoreResults automatically closes the current cursor and advances to the next.
  // FStmt.CloseCursor; should NOT be called here because SQLFreeStmt(SQL_CLOSE) discards all pending results!
    FStmt.ExecuteCatalogStatistics(Catalog, Schema, Pattern, False);
    Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
    try
      Result := CreateOdbcIndexesMetadata(FDBXContext, Source, PrimaryKeys);
    finally
      Source.Free;
    end;
  finally
    PrimaryKeys.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateIndexColumnsMetaDataReader(
  const Identifier, SubIdentifier: string): TDBXReader;

  procedure TryFetchIndexColumns(const ACatalog, ASchema, ATable, AIndex: string;
    out AReader: TDBXReader);
  var
    LSource, LResult: TDBXReader;
  begin
    AReader := nil;
    FStmt.ExecuteCatalogStatistics(ACatalog, ASchema, ATable, False);
    LSource := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
    try
      LResult := CreateOdbcIndexColumnsMetadata(FDBXContext, LSource, AIndex);
    finally
      LSource.Free;
    end;
    AReader := LResult;
  end;

var
  Parts: TArray<string>;
  Catalog, Schema, TableName, IndexName, CleanSub: string;
  I: Integer;
  Source: TDBXReader;
begin
  DerivedOpen;
  CleanSub := Trim(SubIdentifier);
  while (CleanSub <> '') and (CleanSub[1] = '.') do
    CleanSub := Trim(Copy(CleanSub, 2, MaxInt));

  if CleanSub <> '' then
  begin
    ParseMetadataIdentifier(Identifier, Catalog, Schema, TableName);
    IndexName := UnquoteMetadataPart(CleanSub);
    TryFetchIndexColumns(Catalog, Schema, TableName, IndexName, Result);
    Exit;
  end;

  Parts := SplitMetadataParts(Identifier, ['.'], True);
  for I := 0 to High(Parts) do
    Parts[I] := UnquoteMetadataPart(Parts[I]);

  if Length(Parts) = 4 then
  begin
    Catalog := Parts[0];
    if (Catalog = '?') or (Catalog = '%') then Catalog := '';
    TryFetchIndexColumns(Catalog, Parts[1], Parts[2], Parts[3], Result);
    Exit;
  end;

  if Length(Parts) = 3 then
  begin
    // Data.SqlExpr builds GetIndexColumns "<Schema>"."<Table>"."<Index>" when Catalog is empty.
    try
      FStmt.ExecuteCatalogStatistics('', Parts[0], Parts[1], False);
      Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
      try
        Result := CreateOdbcIndexColumnsMetadata(FDBXContext, Source, Parts[2]);
      finally
        Source.Free;
      end;
      if Result.Next then
      begin
        Result.Free;
        TryFetchIndexColumns('', Parts[0], Parts[1], Parts[2], Result);
        Exit;
      end;
      FreeAndNil(Result);
    except
      FreeAndNil(Result);
    end;
    Catalog := Parts[0];
    if Catalog = '?' then Catalog := '';
    TryFetchIndexColumns(Catalog, Parts[1], Parts[2], '', Result);
    Exit;
  end;

  if Length(Parts) = 2 then
  begin
    if not FOdbcConnection.OdbcConn.SupportsSchemas then
    begin
      TryFetchIndexColumns('', '', Parts[0], Parts[1], Result);
      Exit;
    end;
    try
      FStmt.ExecuteCatalogStatistics('', '', Parts[0], False);
      Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
      try
        Result := CreateOdbcIndexColumnsMetadata(FDBXContext, Source, Parts[1]);
      finally
        Source.Free;
      end;
      if Result.Next then
      begin
        Result.Free;
        TryFetchIndexColumns('', '', Parts[0], Parts[1], Result);
        Exit;
      end;
      FreeAndNil(Result);
    except
      FreeAndNil(Result);
    end;
    TryFetchIndexColumns('', Parts[0], Parts[1], '', Result);
    Exit;
  end;

  ParseMetadataIdentifier(Identifier, Catalog, Schema, TableName);
  TryFetchIndexColumns(Catalog, Schema, TableName, '', Result);
end;

function TDBXOpenOdbcCommandNative.CreateForeignKeysMetaDataReader(
  const Identifier: string): TDBXReader;
var
  Catalog, Schema, Pattern: string;
  Source: TDBXReader;
  Table: TDBXMemoryTable;
begin
  ParseMetadataIdentifier(Identifier, Catalog, Schema, Pattern);
  DerivedOpen;
  try
    FStmt.ExecuteCatalogForeignKeys('', '', '', Catalog, Schema, Pattern);
  except
    on E: EOdbcError do
    begin
      if (E.SqlState <> 'HYC00') and (E.SqlState <> 'IM001') then raise;
      Table := TDBXMemoryTable.Create;
      try
        Table.Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
        Result := TDBXOpenOdbcMetaTableReader.Create(FDBXContext, Table);
        Table := nil;
      finally
        Table.Free;
      end;
      Exit;
    end;
  end;
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try
    Result := CreateOdbcForeignKeysMetadata(FDBXContext, Source);
  finally
    Source.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.CreateForeignKeyColumnsMetaDataReader(
  const Identifier, SubIdentifier: string): TDBXReader;
var
  Parts: TArray<string>;
  Catalog, Schema, TableName, FKName, CleanSub: string;
  I: Integer;
  Source: TDBXReader;
  Table: TDBXMemoryTable;
begin
  DerivedOpen;
  CleanSub := Trim(SubIdentifier);
  while (CleanSub <> '') and (CleanSub[1] = '.') do
    CleanSub := Trim(Copy(CleanSub, 2, MaxInt));
  FKName := UnquoteMetadataPart(CleanSub);
  if SameText(FKName, 'PrimaryKey') or SameText(FKName, 'ForeignKey') then
    FKName := '';

  Parts := SplitMetadataParts(Identifier, ['.'], True);
  for I := 0 to High(Parts) do
    Parts[I] := UnquoteMetadataPart(Parts[I]);

  if (FKName = '') and (Length(Parts) = 4) then
  begin
    Catalog := Parts[0];
    if (Catalog = '?') or (Catalog = '%') then Catalog := '';
    Schema := Parts[1];
    TableName := Parts[2];
    FKName := Parts[3];
  end
  else
    ParseMetadataIdentifier(Identifier, Catalog, Schema, TableName);

  try
    FStmt.ExecuteCatalogForeignKeys('', '', '', Catalog, Schema, TableName);
  except
    on E: EOdbcError do
    begin
      if (E.SqlState <> 'HYC00') and (E.SqlState <> 'IM001') then raise;
      Table := TDBXMemoryTable.Create;
      try
        Table.Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
        Result := TDBXOpenOdbcMetaTableReader.Create(FDBXContext, Table);
        Table := nil;
      finally
        Table.Free;
      end;
      Exit;
    end;
  end;
  Source := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, FStmt.DescribeResultColumns, False);
  try
    Result := CreateOdbcForeignKeyColumnsMetadata(FDBXContext, Source, FKName);
  finally
    Source.Free;
  end;
end;

function TDBXOpenOdbcCommandNative.DerivedExecuteQuery: TDBXReader;
var
  ColCount: SqlSmallint;
  ColMetas: TOdbcColumnMetaArray;
  CmdText, CmdName, Identifier, ProcedureTypes: string;
  Tokens: TArray<string>;
begin
  if SameText(CommandType, TDBXCommandTypes.DbxMetaData) then
  begin
    CmdText := Trim(Text);
    Tokens := SplitMetadataParts(CmdText, [' ', #9, #13, #10], False);
    CmdName := '';
    if Length(Tokens) > 0 then
      CmdName := Tokens[0];

    if SameText(CmdName, TDBXMetaDataCommands.GetDatabase) then
      Exit(CreateDatabaseMetaDataReader);

    if SameText(CmdName, TDBXMetaDataCommands.GetDatatypes) then
      Exit(CreateDataTypesMetaDataReader);

    if SameText(CmdName, TDBXMetaDataCommands.GetProcedures) or
      SameText(CmdName, TDBXMetaDataCommands.GetProcedureParameters) then
    begin
      Identifier := '';
      ProcedureTypes := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      if Length(Tokens) > 2 then
        ProcedureTypes := string.Join(' ', Copy(Tokens, 2, Length(Tokens)-2));
      if SameText(CmdName, TDBXMetaDataCommands.GetProcedures) then
        Exit(CreateProceduresMetaDataReader(Identifier, ProcedureTypes));
      Exit(CreateProcedureParametersMetaDataReader(Identifier));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetSchemas) then
    begin
      DerivedOpen;
      FStmt.ExecuteCatalogSchemas;
      ColMetas := FStmt.DescribeResultColumns;
      // Keep physical ODBC column numbers, but expose the DBX collection shape.
      SetLength(ColMetas, 2);
      ColMetas[0].Name := 'CatalogName';
      ColMetas[1].Name := 'SchemaName';
      Exit(TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetCatalogs) then
    begin
      DerivedOpen;
      FStmt.ExecuteCatalogCatalogs;
      ColMetas := FStmt.DescribeResultColumns;
      SetLength(ColMetas, 1);
      ColMetas[0].Name := 'CatalogName';
      Exit(TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False));
    end;

    DerivedOpen;

    if SameText(CmdName, TDBXMetaDataCommands.GetTables) then
    begin
      Identifier := '';
      ProcedureTypes := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      if Length(Tokens) > 2 then
        ProcedureTypes := string.Join(' ', Copy(Tokens, 2, Length(Tokens)-2));
      Exit(CreateTablesMetaDataReader(Identifier, ProcedureTypes, CmdName));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetViews) then
    begin
      Identifier := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      Exit(CreateTablesMetaDataReader(Identifier, 'View', CmdName));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetSynonyms) then
    begin
      Identifier := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      Exit(CreateTablesMetaDataReader(Identifier, 'Synonym', CmdName));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetColumns) then
    begin
      Identifier := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      Exit(CreateColumnsMetaDataReader(Identifier));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetIndexes) then
    begin
      Identifier := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      Exit(CreateIndexesMetaDataReader(Identifier));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetIndexColumns) then
    begin
      Identifier := '';
      ProcedureTypes := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      if Length(Tokens) > 2 then
        ProcedureTypes := string.Join(' ', Copy(Tokens, 2, Length(Tokens)-2));
      Exit(CreateIndexColumnsMetaDataReader(Identifier, ProcedureTypes));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetForeignKeys) then
    begin
      Identifier := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      Exit(CreateForeignKeysMetaDataReader(Identifier));
    end;

    if SameText(CmdName, TDBXMetaDataCommands.GetForeignKeyColumns) then
    begin
      Identifier := '';
      ProcedureTypes := '';
      if Length(Tokens) > 1 then Identifier := Tokens[1];
      if Length(Tokens) > 2 then
        ProcedureTypes := string.Join(' ', Copy(Tokens, 2, Length(Tokens)-2));
      Exit(CreateForeignKeyColumnsMetaDataReader(Identifier, ProcedureTypes));
    end;

    // DBX metadata requests are protocol commands, never SQL statements.
    raise TDBXError.Create(TDBXErrorCodes.NotSupported,
      'Unsupported DBX metadata command: ' + CmdName);
  end;

  DerivedOpen;

  // Bind parameters if command has parameters
  if (Parameters <> nil) and (Parameters.Count > 0) then
  begin
    if not IsPrepared then
      DerivedPrepare;
    FStmt.BindParameters(Parameters);
    ColCount := FStmt.ExecutePrepared;
  end
  else
  begin
    if IsPrepared then
      ColCount := FStmt.ExecutePrepared
    else
      ColCount := FStmt.ExecuteDirect(Text);
  end;

  if ColCount > 0 then
  begin
    ColMetas := FStmt.DescribeResultColumns;
    Result := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False);
  end
  else
    Result := nil;
end;

procedure TDBXOpenOdbcCommandNative.DerivedExecuteUpdate;
begin
  if SameText(CommandType, TDBXCommandTypes.DbxMetaData) then
    raise TDBXError.Create(TDBXErrorCodes.NotSupported,
      'DBX metadata commands must be executed as queries');
  DerivedOpen;

  // Bind parameters if command has parameters
  if (Parameters <> nil) and (Parameters.Count > 0) then
  begin
    if not IsPrepared then
      DerivedPrepare;
    FStmt.BindParameters(Parameters);
    FStmt.ExecutePrepared;
  end
  else
  begin
    if IsPrepared then
      FStmt.ExecutePrepared
    else
      FStmt.ExecuteDirect(Text);
  end;
end;

function TDBXOpenOdbcCommandNative.DerivedGetNextReader: TDBXReader;
var
  ColCount: SqlSmallint;
  ColMetas: TOdbcColumnMetaArray;
begin
  Result := nil;
  if FStmt = nil then
    Exit;

  // Proactive defense before calling SQLMoreResults:
  // Ensure the preceding result set's cursor is closed cleanly
  // In ODBC, SQLMoreResults automatically closes the current cursor and advances to the next.
  // FStmt.CloseCursor; should NOT be called here because SQLFreeStmt(SQL_CLOSE) discards all pending results!

  while FStmt.MoreResults(ColCount) do
  begin
    if ColCount > 0 then
    begin
      ColMetas := FStmt.DescribeResultColumns;
      Result := TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False);
      Exit;
    end;
  end;
end;

initialization
  TDBXDriverRegistry.RegisterDriverClass(sDbxOpenOdbcDriverName, TDBXOpenOdbcDriverNative);
  TDBXDriverRegistry.RegisterDriverClass(sOpenOdbcAliasName, TDBXOpenOdbcDriverNative);
  TClassRegistry.GetClassRegistry.RegisterRegistryClass(
    TDBXOpenOdbcDriverLoaderNative.ClassName, TDBXOpenOdbcDriverLoaderNative);

finalization
  TClassRegistry.GetClassRegistry.UnregisterClass(TDBXOpenOdbcDriverLoaderNative.ClassName);
  TDBXDriverRegistry.UnregisterDriverClass(sOpenOdbcAliasName);
  TDBXDriverRegistry.UnregisterDriverClass(sDbxOpenOdbcDriverName);

end.
