{
  Delphi open source DbExpress Native DBX4 Driver for ODBC
  Version 4.2026.11.02

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
  sDbxOpenOdbcVersion    = '4.2026.11.02 (DBX4 Remastered)';

type
  TDBXOpenOdbcConnectionNative = class;
  TDBXOpenOdbcCommandNative = class;

  TDBXOpenOdbcProperties = class(TDBXProperties)
  public const
    StrConnectionString = 'ConnectionString';
    StrCustomString     = 'Custom String';
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
    procedure EnsureMetaColumnAliases(var ColMetas: TOdbcColumnMetaArray; const OdbcName, AliasName: string);
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

implementation

type
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
    12: Value := True;  // SupportsCatalogFunctions
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
  ConnStr, DbProp, UserProp, PassProp, CustomProp: string;

  function TranslateOleDbToOdbc(const AStr: string): string;
  var
    Tokens: TArray<string>;
    Token, Key, Val, S: string;
    P: Integer;
    Prov, Svr, DB, Uid, Pwd: string;
    OtherParts: TStringBuilder;
  begin
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
        else
        begin
          if OtherParts.Length > 0 then OtherParts.Append(';');
          OtherParts.Append(S);
        end;
      end;

      // Determine Driver based on Provider
      if Pos('MSOLEDBSQL', UpperCase(Prov)) > 0 then
        Result := 'Driver={ODBC Driver 17 for SQL Server};'
      else if Pos('SQLNCLI11', UpperCase(Prov)) > 0 then
        Result := 'Driver={SQL Server Native Client 11.0};'
      else if Pos('SQLNCLI10', UpperCase(Prov)) > 0 then
        Result := 'Driver={SQL Server Native Client 10.0};'
      else if Pos('SQLNCLI', UpperCase(Prov)) > 0 then
        Result := 'Driver={SQL Native Client};'
      else if Pos('SQLOLEDB', UpperCase(Prov)) > 0 then
        Result := 'Driver={SQL Server};'
      else if Pos('MSDASQL', UpperCase(Prov)) > 0 then
        Result := ''
      else
        Result := 'Driver={' + Prov + '};';

      if Svr <> '' then
        Result := Result + 'Server=' + Svr + ';';
      if DB <> '' then
        Result := Result + 'Database=' + DB + ';';
      if Uid <> '' then
        Result := Result + 'Uid=' + Uid + ';';
      if Pwd <> '' then
        Result := Result + 'Pwd=' + Pwd + ';';

      // Auto-enable MARS (Multiple Active Result Sets) for SQL Server drivers to allow concurrent active statements
      if (Pos('SQL', UpperCase(Result)) > 0) and (Pos('MARS_CONNECTION=', UpperCase(Result)) = 0)
        and (Pos('MARS_CONNECTION=', UpperCase(OtherParts.ToString)) = 0) then
      begin
        Result := Result + 'MARS_Connection=yes;';
      end;

      if OtherParts.Length > 0 then
        Result := Result + OtherParts.ToString + ';';
    finally
      OtherParts.Free;
    end;
  end;

begin
  ConnStr := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrConnectionString]);
  DbProp := Trim(FConnectionProperties[TDBXPropertyNames.Database]);
  UserProp := Trim(FConnectionProperties[TDBXPropertyNames.UserName]);
  PassProp := FConnectionProperties[TDBXPropertyNames.Password];
  CustomProp := Trim(FConnectionProperties[TDBXOpenOdbcProperties.StrCustomString]);

  if ConnStr = '' then
    ConnStr := DbProp;

  // Auto-detect and translate ADO OLE DB connection strings (e.g. Provider=SQLOLEDB;...)
  if (ConnStr <> '') and (Pos('PROVIDER=', UpperCase(ConnStr)) > 0) then
    ConnStr := TranslateOleDbToOdbc(ConnStr);

  if (ConnStr <> '') and (Pos('=', ConnStr) = 0) then
    ConnStr := 'DSN=' + ConnStr;

  if (UserProp <> '') and (Pos('UID=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'UID=' + UserProp;
  end;

  if (PassProp <> '') and (Pos('PWD=', UpperCase(ConnStr)) = 0) then
  begin
    if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
      ConnStr := ConnStr + ';';
    ConnStr := ConnStr + 'PWD=' + PassProp;
  end;

  if (CustomProp <> '') and (Pos('=', CustomProp) > 0) and (Pos('DRIVER=', UpperCase(CustomProp)) > 0) and (ConnStr = '') then
    ConnStr := CustomProp;

  // Fast TCP optimization for Microsoft SQL Server ODBC drivers (bypasses slow Named Pipes timeout)
  if (Pos('SQL SERVER', UpperCase(ConnStr)) > 0) or (Pos('SQLNCLI', UpperCase(ConnStr)) > 0) or (Pos('MSOLEDBSQL', UpperCase(ConnStr)) > 0) then
  begin
    if (Pos('NETWORK=', UpperCase(ConnStr)) = 0) and (Pos('NETWORK LIBRARY=', UpperCase(ConnStr)) = 0)
      and (Pos('NET=', UpperCase(ConnStr)) = 0) and (Pos('SERVER=TCP:', UpperCase(ConnStr)) = 0) then
    begin
      if (ConnStr <> '') and (ConnStr[Length(ConnStr)] <> ';') then
        ConnStr := ConnStr + ';';
      ConnStr := ConnStr + 'Network=dbmssocn;';
    end;
  end;

  Result := ConnStr;
end;

procedure TDBXOpenOdbcConnectionNative.DerivedOpen;
var
  ConnStr: string;
begin
  if FOdbcConn = nil then
    FOdbcConn := TOdbcConnectionHandle.Create(FOdbcDriver.OdbcEnv, False);

  ConnStr := BuildOdbcConnectionString;
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
  // Optional metadata command listing
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
      FStmt.CloseCursor;
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
    FStmt.CloseCursor;
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
  if CommandType <> TDBXCommandTypes.DbxMetaData then
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

procedure TDBXOpenOdbcCommandNative.EnsureMetaColumnAliases(var ColMetas: TOdbcColumnMetaArray;
  const OdbcName, AliasName: string);
var
  i, FoundIdx: Integer;
  NewMeta: TOdbcColumnMeta;
begin
  FoundIdx := -1;
  for i := 0 to High(ColMetas) do
  begin
    if SameText(ColMetas[i].Name, AliasName) then
      Exit;
    if SameText(ColMetas[i].Name, OdbcName) then
      FoundIdx := i;
  end;

  if FoundIdx >= 0 then
  begin
    NewMeta := ColMetas[FoundIdx];
    NewMeta.Name := AliasName;
    SetLength(ColMetas, Length(ColMetas) + 1);
    ColMetas[High(ColMetas)] := NewMeta;
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

function TDBXOpenOdbcCommandNative.DerivedExecuteQuery: TDBXReader;
var
  ColCount: SqlSmallint;
  ColMetas: TOdbcColumnMetaArray;
  CmdText, UpperCmd: string;
  Tokens: TArray<string>;
begin
  if CommandType = TDBXCommandTypes.DbxMetaData then
  begin
    CmdText := Trim(Text);
    UpperCmd := UpperCase(CmdText);

    if UpperCmd.StartsWith('GETDATABASE') or SameText(CmdText, TDBXMetaDataCommands.GetDatabase) then
      Exit(CreateDatabaseMetaDataReader);

    DerivedOpen;

    if UpperCmd.StartsWith('GETTABLES') or SameText(CmdText, TDBXMetaDataCommands.GetTables) then
    begin
      Tokens := CmdText.Split([' ']);
      if Length(Tokens) >= 3 then
        FStmt.ExecuteCatalogTables(Tokens[1], Tokens[2])
      else if Length(Tokens) = 2 then
        FStmt.ExecuteCatalogTables(Tokens[1], 'TABLE,VIEW')
      else
        FStmt.ExecuteCatalogTables('', 'TABLE,VIEW');

      ColMetas := FStmt.DescribeResultColumns;
      EnsureMetaColumnAliases(ColMetas, 'TABLE_NAME', 'TableName');
      EnsureMetaColumnAliases(ColMetas, 'TABLE_TYPE', 'TableType');
      Exit(TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False));
    end;

    if UpperCmd.StartsWith('GETVIEWS') or SameText(CmdText, TDBXMetaDataCommands.GetViews) then
    begin
      Tokens := CmdText.Split([' ']);
      if Length(Tokens) >= 2 then
        FStmt.ExecuteCatalogTables(Tokens[1], 'VIEW')
      else
        FStmt.ExecuteCatalogTables('', 'VIEW');

      ColMetas := FStmt.DescribeResultColumns;
      EnsureMetaColumnAliases(ColMetas, 'TABLE_NAME', 'TableName');
      EnsureMetaColumnAliases(ColMetas, 'TABLE_TYPE', 'TableType');
      Exit(TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False));
    end;

    if UpperCmd.StartsWith('GETCOLUMNS') or SameText(CmdText, TDBXMetaDataCommands.GetColumns) then
    begin
      Tokens := CmdText.Split([' ']);
      if Length(Tokens) >= 2 then
        FStmt.ExecuteCatalogColumns(Tokens[1], '')
      else
        FStmt.ExecuteCatalogColumns('', '');

      ColMetas := FStmt.DescribeResultColumns;
      EnsureMetaColumnAliases(ColMetas, 'COLUMN_NAME', 'ColumnName');
      Exit(TDBXOpenOdbcReaderNative.Create(FDBXContext, FStmt, ColMetas, False));
    end;
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
  FStmt.CloseCursor;

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
