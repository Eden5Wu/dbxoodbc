{
  Delphi open source DbExpress Native DBX4 Driver for ODBC
  Version 4.2026.11.11

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
    https://github.com/Eden5Wu/dbx4odbc
}
unit DbxOpenOdbcCore;

{$B-}
{$R-}

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Data.FmtBcd,
  Data.SqlTimSt,
  Data.DBXPlatform,
  Data.DBXCommon,
  OdbcApi,
  DbxOpenOdbcDialects;

type
  // 32-bit / 64-bit exact ODBC length/indicator types (fixes legacy Win64 SQLLEN truncation)
  TSqlLen = NativeInt;
  PSqlLen = ^TSqlLen;
  TSqlULen = NativeUInt;
  PSqlULen = ^TSqlULen;

  EOdbcError = class(TDBXError)
  private
    FSqlState: string;
    FNativeError: SqlInteger;
  public
    constructor Create(ErrorCode: TDBXErrorCode; const Message, ASqlState: string; ANativeError: SqlInteger);
    property SqlState: string read FSqlState;
    property NativeError: SqlInteger read FNativeError;
  end;

  TOdbcColumnMeta = DbxOpenOdbcDialects.TOdbcColumnMeta;
  TOdbcColumnMetaArray = DbxOpenOdbcDialects.TOdbcColumnMetaArray;

  TOdbcEnvHandle = class
  private
    FHEnv: SqlHEnv;
    FOdbcPooling: Boolean;
    FInstalledDrivers: TArray<string>;
    FDriversLoaded: Boolean;
    procedure LoadInstalledDrivers;
  public
    constructor Create(AOdbcPooling: Boolean = False);
    destructor Destroy; override;
    procedure CheckError(RetCode: SqlReturn; const ContextMsg: string);
    function IsDriverInstalled(const ADriverName: string): Boolean;
    function TryParseOdbcDriverVersion(const ADriverName: string; out Major, Minor: Integer): Boolean;
    function IsDriver18Plus(const ADriverNameOrConnStr: string): Boolean;
    function ResolveSqlServerDriver(const RequestedDriverOrProvider: string): string;
    property HEnv: SqlHEnv read FHEnv;
    property OdbcPooling: Boolean read FOdbcPooling;
  end;

  TOdbcConnectionHandle = class
  private
    FEnv: TOdbcEnvHandle;
    FOwnsEnv: Boolean;
    FHDbc: SqlHDbc;
    FConnected: Boolean;
    FInTransaction: Boolean;
    FReturnedConnectionString: string;
    FDbmsName: string;
    FDbmsVersion: string;
    FDriverName: string;
    FDriverVersion: string;
    FUserName: string;
    FQuoteChar: string;
    FSupportsCatalogs: Boolean;
    FSupportsSchemas: Boolean;
    FDialect: TOdbcDialect;
    FUseUnicode: Boolean;
    FTrimFixedChar: Boolean;
    FTrimVarChar: Boolean;
    FSupportsTxnIsolation: Boolean;
    FCurIsolation: NativeInt;
    procedure QueryConnectionMetadata;
    function GetStringInfoW(InfoType: SqlUSmallint): string;
    function HasNamespaceUsage(InfoType: SqlUSmallint): Boolean;
  public
    constructor Create(AEnv: TOdbcEnvHandle; AOwnsEnv: Boolean = False);
    destructor Destroy; override;

    procedure CheckError(RetCode: SqlReturn; const ContextMsg: string);
    procedure Connect(const ConnectionString: string);
    procedure Disconnect;

    procedure BeginTransaction(IsolationLevel: TDBXIsolation);
    procedure Commit;
    procedure Rollback;

    property Env: TOdbcEnvHandle read FEnv;
    property HDbc: SqlHDbc read FHDbc;
    property Connected: Boolean read FConnected;
    property InTransaction: Boolean read FInTransaction;
    property ReturnedConnectionString: string read FReturnedConnectionString;
    property DbmsName: string read FDbmsName;
    property DbmsVersion: string read FDbmsVersion;
    property DriverName: string read FDriverName;
    property DriverVersion: string read FDriverVersion;
    property UserName: string read FUserName;
    property QuoteChar: string read FQuoteChar;
    property SupportsCatalogs: Boolean read FSupportsCatalogs;
    property SupportsSchemas: Boolean read FSupportsSchemas;
    property Dialect: TOdbcDialect read FDialect;
    property UseUnicode: Boolean read FUseUnicode write FUseUnicode;
    property TrimFixedChar: Boolean read FTrimFixedChar write FTrimFixedChar;
    property TrimVarChar: Boolean read FTrimVarChar write FTrimVarChar;
    property SupportsTxnIsolation: Boolean read FSupportsTxnIsolation;
    property CurIsolation: NativeInt read FCurIsolation;
  end;

type
  TOdbcBoundParamHolder = record
    Ind: TSqlLen;
    Int64Val: Int64;
    Int32Val: TInt32;
    DoubleVal: Double;
    TSVal: tagTIMESTAMP_STRUCT;
    DateVal: tagDATE_STRUCT;
    WideStrVal: WideString;
    BytesVal: TBytes;
  end;

  TOdbcParamStorage = record
    IsNull: Boolean;
    DataType: Integer;
    AsInt64: Int64;
    AsDouble: Double;
    AsString: string;
    AsAnsiString: AnsiString;
    AsBytes: TArray<Byte>;
    AsTimeStamp: TSQLTimeStamp;
    AsTimeStampOffset: TSQLTimeStampOffset;
    AsBcd: TBcd;
  end;

  TOdbcRowCell = record
    IsNull: LongBool;
    IntVal: Int64;
    DoubleVal: Double;
    BcdVal: TBcd;
    DateVal: TDBXDate;
    TimeVal: TDBXTime;
    TimeStampVal: TSQLTimeStamp;
    StrVal: string;
    AnsiVal: AnsiString;
    BytesVal: TBytes;
  end;

  TDBXOpenOdbcParameterRow = class(TDBXRow)
  private
    FValues: TArray<TOdbcParamStorage>;
    procedure EnsureCapacity(Ordinal: Integer);
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
    procedure GetTimeStampOffset(DbxValue: TDBXTimeStampOffsetValue;
      var Value: TSQLTimeStampOffset; var IsNull: LongBool); override;
    procedure GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64;
      const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
      var ReturnLength: Int64; var IsNull: LongBool); override;
    procedure GetByteLength(DbxValue: TDBXByteArrayValue;
      var ByteLength: Int64; var IsNull: LongBool); override;

    function IsStoredNull(DbxValue: TDBXValue): Boolean; override;
    procedure SetNull(DbxValue: TDBXValue); override;
    procedure SetString(DbxValue: TDBXAnsiStringValue; const Value: AnsiString); override;
    procedure SetAnsiString(DbxValue: TDBXAnsiStringValue; const Value: AnsiString); override;
    procedure SetWideString(DbxValue: TDBXWideStringValue; const Value: string); override;
    procedure SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean); override;
    procedure SetUInt8(DbxValue: TDBXUInt8Value; Value: Byte); override;
    procedure SetInt8(DbxValue: TDBXInt8Value; Value: ShortInt); override;
    procedure SetUInt16(DbxValue: TDBXUInt16Value; Value: Word); override;
    procedure SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt); override;
    procedure SetInt32(DbxValue: TDBXInt32Value; Value: TInt32); override;
    procedure SetInt64(DbxValue: TDBXInt64Value; Value: Int64); override;
    procedure SetSingle(DbxValue: TDBXSingleValue; Value: Single); override;
    procedure SetDouble(DbxValue: TDBXDoubleValue; Value: Double); override;
    procedure SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd); override;
    procedure SetDate(DbxValue: TDBXDateValue; Value: TDBXDate); override;
    procedure SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime); override;
    procedure SetTimestamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp); override;
    procedure SetTimestampOffset(DbxValue: TDBXTimeStampOffsetValue; var Value: TSQLTimeStampOffset); override;
    procedure SetDynamicBytes(DbxValue: TDBXValue; Offset: Int64;
      const Buffer: TArray<Byte>; BufferOffset, Length: Int64); override;
    procedure SetValueType(ValueType: TDBXValueType); override;
  public
    constructor Create(DBXContext: TDBXContext);
    function IsParamNull(Ordinal: Integer): Boolean;
    function GetParamStorage(Ordinal: Integer): TOdbcParamStorage;
    procedure StoreOutput(Ordinal: Integer; const Value: TOdbcParamStorage);
  end;

  TOdbcStatementHandle = class
  private
    FConnection: TOdbcConnectionHandle;
    FHStmt: SqlHStmt;
    FColumns: TOdbcColumnMetaArray;
    FRowsAffected: Int64;
    FCursorOpen: Boolean;
    FPrepared: Boolean;
    FBoundParams: TArray<TOdbcBoundParamHolder>;
    FBoundParameterList: TDBXParameterList;
    FOutputPending: Boolean;
    FHasOutputParameters: Boolean;
    FRowCells: TArray<TOdbcRowCell>;
    function GetBlobTargetType(ColNo: SqlUSmallint): SqlSmallint;
    function ReadRawColumnData(ColNo: SqlUSmallint; TargetType: SqlSmallint;
      out IsNull: LongBool): TBytes;
    procedure CheckColIndex(ColNo: SqlUSmallint); inline;
    procedure PreFetchRow;
    procedure FetchColumnCell(ColNo: SqlUSmallint; const ColMeta: TOdbcColumnMeta; var Cell: TOdbcRowCell);
    procedure CopyOutputParameters;
    procedure CompleteOutputParameters;
    procedure MapOdbcTypeToDbx(var ColMeta: TOdbcColumnMeta);
  public
    constructor Create(AConnection: TOdbcConnectionHandle);
    destructor Destroy; override;

    procedure CheckError(RetCode: SqlReturn; const ContextMsg: string);
    procedure AllocateHandle;
    procedure CloseCursor;
    procedure FreeStatement;

    procedure Prepare(const SQL: string);
    function ExecutePrepared: SqlSmallint;
    function ExecuteDirect(const SQL: string): SqlSmallint;
    function DescribeResultColumns: TOdbcColumnMetaArray;
    function FetchNext: Boolean;
    function MoreResults(out ColumnCount: SqlSmallint): Boolean;

    // Scalar & Buffer Value Readers (1-based ColNo)
    procedure GetInt16(ColNo: SqlUSmallint; out Value: SmallInt; out IsNull: LongBool);
    procedure GetUInt16(ColNo: SqlUSmallint; out Value: Word; out IsNull: LongBool);
    procedure GetInt32(ColNo: SqlUSmallint; out Value: TInt32; out IsNull: LongBool);
    procedure GetInt64(ColNo: SqlUSmallint; out Value: Int64; out IsNull: LongBool);
    procedure GetDouble(ColNo: SqlUSmallint; out Value: Double; out IsNull: LongBool);
    procedure GetSingle(ColNo: SqlUSmallint; out Value: Single; out IsNull: LongBool);
    procedure GetBoolean(ColNo: SqlUSmallint; out Value: LongBool; out IsNull: LongBool);
    procedure GetWideString(ColNo: SqlUSmallint; out Value: string; out IsNull: LongBool);
    procedure GetAnsiString(ColNo: SqlUSmallint; out Value: AnsiString; out IsNull: LongBool);
    procedure GetDate(ColNo: SqlUSmallint; out Value: TDBXDate; out IsNull: LongBool);
    procedure GetTime(ColNo: SqlUSmallint; out Value: TDBXTime; out IsNull: LongBool);
    procedure GetTimeStamp(ColNo: SqlUSmallint; out Value: TSQLTimeStamp; out IsNull: LongBool);
    procedure GetBcd(ColNo: SqlUSmallint; out Value: TBcd; out IsNull: LongBool);
    procedure GetBytes(ColNo: SqlUSmallint; Offset: Int64; const Buffer: TArray<Byte>;
      BufferOffset, Length: Int64; out ReturnLength: Int64; out IsNull: LongBool);
    procedure GetByteLength(ColNo: SqlUSmallint; out ByteLength: Int64; out IsNull: LongBool);

    // Parameter Binding Support
    procedure BindParameters(Parameters: TDBXParameterList);
    function GetNumParams: SqlSmallint;
    function DescribeParam(ParamNo: SqlUSmallint; out SqlType: SqlSmallint;
      out ParamSize: TSqlULen; out DecDigits: SqlSmallint; out Nullable: SqlSmallint): Boolean;

    // Catalog Metadata Functions
    procedure ExecuteCatalogSchemas;
    procedure ExecuteCatalogCatalogs;
    procedure ExecuteCatalogTables(const TablePattern, TableType: string); overload;
    procedure ExecuteCatalogTables(const Catalog, Schema, TablePattern, TableTypes: string); overload;
    procedure ExecuteCatalogColumns(const TableName, ColumnPattern: string); overload;
    procedure ExecuteCatalogColumns(const Catalog, Schema, TableName, ColumnPattern: string); overload;
    procedure ExecuteCatalogStatistics(const Catalog, Schema, TableName: string; UniqueOnly: Boolean = False);
    procedure ExecuteCatalogPrimaryKeys(const Catalog, Schema, TableName: string);
    procedure ExecuteCatalogForeignKeys(const PKCatalog, PKSchema, PKTable,
      FKCatalog, FKSchema, FKTable: string);
    procedure ExecuteCatalogProcedures(const Catalog, Schema, ProcedurePattern: string);
    procedure ExecuteCatalogProcedureColumns(const Catalog, Schema, ProcedurePattern: string);

    property Connection: TOdbcConnectionHandle read FConnection;
    property HStmt: SqlHStmt read FHStmt;
    property Columns: TOdbcColumnMetaArray read FColumns;
    property RowsAffected: Int64 read FRowsAffected;
  end;

function MapOdbcParamTypeToDbx(SqlType: SqlSmallint): TDBXType;
function NormalizeOdbcTableTypes(const TableTypes: string): string;

implementation

const
  odbc32_dll = 'odbc32.dll';

  // Additional ODBC SQL Type Constants
  SQL_WCHAR         = -8;
  SQL_WVARCHAR      = -9;
  SQL_WLONGVARCHAR  = -10;
  SQL_GUID          = -11;
  SQL_SS_VARIANT    = -150;
  SQL_SS_XML        = -152;
  SQL_SS_TIME2      = -154;

  SQL_DESC_UNSIGNED = 8;
  SQL_USER_NAME     = 47;

// Direct 32/64-bit safe imports from Windows odbc32.dll
function SQLAllocHandle(HandleType: SqlSmallint; InputHandle: SqlHandle;
  out OutputHandle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLFreeHandle(HandleType: SqlSmallint; Handle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLFreeStmt(StatementHandle: SqlHStmt; Option: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLCloseCursor(StatementHandle: SqlHStmt): SqlReturn; stdcall; external odbc32_dll;
function SQLSetEnvAttr(EnvironmentHandle: SqlHEnv; Attribute: SqlInteger;
  ValuePtr: SqlPointer; StringLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLDriverConnectW(ConnectionHandle: SqlHDbc; WindowHandle: SqlHWnd;
  InConnectionString: PWideChar; StringLength1: SqlSmallint;
  OutConnectionString: PWideChar; BufferLength: SqlSmallint;
  out StringLength2Ptr: SqlSmallint; DriverCompletion: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLDisconnect(ConnectionHandle: SqlHDbc): SqlReturn; stdcall; external odbc32_dll;
function SQLSetConnectAttrW(ConnectionHandle: SqlHDbc; Attribute: SqlInteger;
  ValuePtr: SqlPointer; StringLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLGetConnectAttrW(ConnectionHandle: SqlHDbc; Attribute: SqlInteger;
  ValuePtr: SqlPointer; BufferLength: SqlInteger;
  StringLengthPtr: PSqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLEndTran(HandleType: SqlSmallint; Handle: SqlHandle;
  CompletionType: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLGetInfoW(ConnectionHandle: SqlHDbc; InfoType: SqlUSmallint;
  InfoValuePtr: SqlPointer; BufferLength: SqlSmallint;
  StringLengthPtr: PSqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLPrepareW(StatementHandle: SqlHStmt; StatementText: PWideChar;
  TextLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLExecute(StatementHandle: SqlHStmt): SqlReturn; stdcall; external odbc32_dll;
function SQLExecDirectW(StatementHandle: SqlHStmt; StatementText: PWideChar;
  TextLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLNumResultCols(StatementHandle: SqlHStmt;
  out ColumnCountPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLRowCount(StatementHandle: SqlHStmt;
  out RowCountPtr: TSqlLen): SqlReturn; stdcall; external odbc32_dll;
function SQLDescribeColW(StatementHandle: SqlHStmt; ColumnNumber: SqlUSmallint;
  ColumnName: PWideChar; BufferLength: SqlSmallint; out NameLengthPtr: SqlSmallint;
  out DataTypePtr: SqlSmallint; out ColumnSizePtr: TSqlULen;
  out DecimalDigitsPtr: SqlSmallint; out NullablePtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLFetch(StatementHandle: SqlHStmt): SqlReturn; stdcall; external odbc32_dll;
function SQLMoreResults(StatementHandle: SqlHStmt): SqlReturn; stdcall; external odbc32_dll;
function SQLGetData(StatementHandle: SqlHStmt; Col_or_Param_Num: SqlUSmallint;
  TargetType: SqlSmallint; TargetValuePtr: SqlPointer; BufferLength: TSqlLen;
  StrLen_or_IndPtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;
function SQLBindParameter(StatementHandle: SqlHStmt; ParameterNumber: SqlUSmallint;
  InputOutputType: SqlSmallint; ValueType: SqlSmallint; ParameterType: SqlSmallint;
  ColumnSize: TSqlULen; DecimalDigits: SqlSmallint; ParameterValuePtr: SqlPointer;
  BufferLength: TSqlLen; StrLen_or_IndPtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;
function SQLNumParams(StatementHandle: SqlHStmt; ParameterCountPtr: PSqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLDescribeParam(StatementHandle: SqlHStmt; ParameterNumber: SqlUSmallint;
  DataTypePtr: PSqlSmallint; ParameterSizePtr: PSqlULen; DecimalDigitsPtr: PSqlSmallint;
  NullablePtr: PSqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLTablesW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  TableName: PWideChar; NameLength3: SqlSmallint;
  TableType: PWideChar; NameLength4: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLColumnsW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  TableName: PWideChar; NameLength3: SqlSmallint;
  ColumnName: PWideChar; NameLength4: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLStatisticsW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  TableName: PWideChar; NameLength3: SqlSmallint;
  Unique: SqlUSmallint; Reserved: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLPrimaryKeysW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  TableName: PWideChar; NameLength3: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLForeignKeysW(StatementHandle: SqlHStmt;
  PKCatalogName: PWideChar; NameLength1: SqlSmallint;
  PKSchemaName: PWideChar; NameLength2: SqlSmallint;
  PKTableName: PWideChar; NameLength3: SqlSmallint;
  FKCatalogName: PWideChar; NameLength4: SqlSmallint;
  FKSchemaName: PWideChar; NameLength5: SqlSmallint;
  FKTableName: PWideChar; NameLength6: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLProceduresW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  ProcName: PWideChar; NameLength3: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLProcedureColumnsW(StatementHandle: SqlHStmt;
  CatalogName: PWideChar; NameLength1: SqlSmallint;
  SchemaName: PWideChar; NameLength2: SqlSmallint;
  ProcName: PWideChar; NameLength3: SqlSmallint;
  ColumnName: PWideChar; NameLength4: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLGetDiagRecW(HandleType: SqlSmallint; Handle: SqlHandle;
  RecNumber: SqlSmallint; SqlState: PWideChar; out NativeErrorPtr: SqlInteger;
  MessageText: PWideChar; BufferLength: SqlSmallint;
  out TextLengthPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLDriversW(EnvironmentHandle: SqlHEnv; Direction: SqlUSmallint;
  DriverDescription: PWideChar; BufferLength1: SqlSmallint;
  out DescriptionLengthPtr: SqlSmallint; DriverAttributes: PWideChar;
  BufferLength2: SqlSmallint; out AttributesLengthPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;

function MapOdbcParamTypeToDbx(SqlType: SqlSmallint): TDBXType;
begin
  case SqlType of
    SQL_SMALLINT, SQL_TINYINT:
      Result := TDBXDataTypes.Int16Type;
    SQL_INTEGER:
      Result := TDBXDataTypes.Int32Type;
    SQL_BIGINT:
      Result := TDBXDataTypes.Int64Type;
    SQL_FLOAT, SQL_DOUBLE:
      Result := TDBXDataTypes.DoubleType;
    SQL_REAL:
      Result := TDBXDataTypes.SingleType;
    SQL_BIT:
      Result := TDBXDataTypes.BooleanType;
    SQL_TYPE_DATE, SQL_DATE:
      Result := TDBXDataTypes.DateType;
    SQL_TYPE_TIME, SQL_TIME:
      Result := TDBXDataTypes.TimeType;
    SQL_TYPE_TIMESTAMP, SQL_TIMESTAMP:
      Result := TDBXDataTypes.TimeStampType;
    SQL_BINARY, SQL_VARBINARY, SQL_LONGVARBINARY:
      Result := TDBXDataTypes.BytesType;
  else
    Result := TDBXDataTypes.WideStringType;
  end;
end;

procedure RaiseOdbcDiagError(HandleType: SqlSmallint; Handle: SqlHandle;
  RetCode: SqlReturn; const ContextMsg: string);
var
  RecNo: SqlSmallint;
  StateBuf: array[0..5] of WideChar;
  MsgBuf: array[0..1023] of WideChar;
  NativeErr, FirstNativeErr: SqlInteger;
  MsgLen: SqlSmallint;
  DiagRet: SqlReturn;
  FullMsg, FirstState, StateStr, RecMsg: string;
begin
  FullMsg := '';
  FirstState := '';
  FirstNativeErr := RetCode;
  RecNo := 1;
  while RecNo <= 8 do
  begin
    FillChar(StateBuf, SizeOf(StateBuf), 0);
    FillChar(MsgBuf, SizeOf(MsgBuf), 0);
    NativeErr := 0;
    MsgLen := 0;
    DiagRet := SQLGetDiagRecW(HandleType, Handle, RecNo, @StateBuf[0],
      NativeErr, @MsgBuf[0], Length(MsgBuf) - 1, MsgLen);
    if not OdbcSucceeded(DiagRet) then
      Break;
    StateStr := string(PWideChar(@StateBuf[0]));
    RecMsg := string(PWideChar(@MsgBuf[0]));
    if RecNo = 1 then
    begin
      FirstState := StateStr;
      FirstNativeErr := NativeErr;
    end;
    if FullMsg <> '' then
      FullMsg := FullMsg + sLineBreak;
    FullMsg := FullMsg + Format('[%s] (%d) %s', [StateStr, NativeErr, RecMsg]);
    Inc(RecNo);
  end;

  if FullMsg = '' then
    FullMsg := Format('ODBC Error (ReturnCode=%d) in %s', [RetCode, ContextMsg])
  else if ContextMsg <> '' then
    FullMsg := ContextMsg + ': ' + FullMsg;

  raise EOdbcError.Create(TDBXErrorCodes.DriverInitFailed, FullMsg, FirstState, FirstNativeErr);
end;

{ EOdbcError }

constructor EOdbcError.Create(ErrorCode: TDBXErrorCode; const Message, ASqlState: string;
  ANativeError: SqlInteger);
begin
  inherited Create(ErrorCode, Message);
  FSqlState := ASqlState;
  FNativeError := ANativeError;
end;

{ TOdbcEnvHandle }

var
  GOdbcEnvInitLock: TRTLCriticalSection;

constructor TOdbcEnvHandle.Create(AOdbcPooling: Boolean);
var
  Ret: SqlReturn;
begin
  inherited Create;
  FHEnv := SQL_NULL_HANDLE;
  FOdbcPooling := AOdbcPooling;

  // Serialize process-level SQL_ATTR_CONNECTION_POOLING toggle + SQLAllocHandle(SQL_HANDLE_ENV)
  // across all dbx4odbc threads in this process.
  EnterCriticalSection(GOdbcEnvInitLock);
  try
    if AOdbcPooling then
    begin
      Ret := SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING,
        SqlPointer(NativeUInt(SQL_CP_ONE_PER_HENV)), SQL_IS_UINTEGER);
      if not OdbcSucceeded(Ret) then
        RaiseOdbcDiagError(SQL_HANDLE_ENV, SQL_NULL_HANDLE, Ret, 'SQLSetEnvAttr(SQL_ATTR_CONNECTION_POOLING)');
    end;

    Ret := SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, FHEnv);
    if AOdbcPooling then
    begin
      // Restore process-level attribute to SQL_CP_OFF immediately after allocating FHEnv
      SQLSetEnvAttr(SQL_NULL_HANDLE, SQL_ATTR_CONNECTION_POOLING,
        SqlPointer(NativeUInt(SQL_CP_OFF)), SQL_IS_UINTEGER);
    end;
  finally
    LeaveCriticalSection(GOdbcEnvInitLock);
  end;
  if not OdbcSucceeded(Ret) then
    RaiseOdbcDiagError(SQL_HANDLE_ENV, SQL_NULL_HANDLE, Ret, 'SQLAllocHandle(SQL_HANDLE_ENV)');

  Ret := SQLSetEnvAttr(FHEnv, SQL_ATTR_ODBC_VERSION, SqlPointer(NativeInt(SQL_OV_ODBC3)), 0);
  CheckError(Ret, 'SQLSetEnvAttr(SQL_ATTR_ODBC_VERSION)');

  if AOdbcPooling then
  begin
    Ret := SQLSetEnvAttr(FHEnv, SQL_ATTR_CP_MATCH,
      SqlPointer(NativeUInt(SQL_CP_STRICT_MATCH)), SQL_IS_UINTEGER);
    CheckError(Ret, 'SQLSetEnvAttr(SQL_ATTR_CP_MATCH)');
  end;
end;

destructor TOdbcEnvHandle.Destroy;
begin
  if FHEnv <> SQL_NULL_HANDLE then
  begin
    SQLFreeHandle(SQL_HANDLE_ENV, FHEnv);
    FHEnv := SQL_NULL_HANDLE;
  end;
  inherited;
end;

procedure TOdbcEnvHandle.CheckError(RetCode: SqlReturn; const ContextMsg: string);
begin
  if not OdbcSucceeded(RetCode) then
    RaiseOdbcDiagError(SQL_HANDLE_ENV, FHEnv, RetCode, ContextMsg);
end;

procedure TOdbcEnvHandle.LoadInstalledDrivers;
var
  Direction: SqlUSmallint;
  DescBuf: array[0..511] of WideChar;
  AttrBuf: array[0..1023] of WideChar;
  DescLen, AttrLen: SqlSmallint;
  Ret: SqlReturn;
  Count: Integer;
  DrvName: string;
begin
  if FDriversLoaded then
    Exit;
  FDriversLoaded := True;
  Count := 0;
  SetLength(FInstalledDrivers, 32);

  Direction := SQL_FETCH_FIRST;
  while True do
  begin
    FillChar(DescBuf, SizeOf(DescBuf), 0);
    DescLen := 0;
    AttrLen := 0;
    Ret := SQLDriversW(FHEnv, Direction, @DescBuf[0], Length(DescBuf) - 1, DescLen,
      @AttrBuf[0], Length(AttrBuf) - 1, AttrLen);
    if not OdbcSucceeded(Ret) then
      Break;
    DrvName := Trim(string(PWideChar(@DescBuf[0])));
    if DrvName <> '' then
    begin
      if Count >= Length(FInstalledDrivers) then
        SetLength(FInstalledDrivers, Length(FInstalledDrivers) * 2);
      FInstalledDrivers[Count] := DrvName;
      Inc(Count);
    end;
    Direction := SQL_FETCH_NEXT;
  end;
  SetLength(FInstalledDrivers, Count);
end;

function TOdbcEnvHandle.IsDriverInstalled(const ADriverName: string): Boolean;
var
  CleanName: string;
  I: Integer;
begin
  LoadInstalledDrivers;
  CleanName := Trim(ADriverName);
  if (Length(CleanName) >= 2) and (CleanName[1] = '{') and (CleanName[Length(CleanName)] = '}') then
    CleanName := Trim(Copy(CleanName, 2, Length(CleanName) - 2));

  for I := 0 to High(FInstalledDrivers) do
  begin
    if SameText(FInstalledDrivers[I], CleanName) then
      Exit(True);
  end;
  Result := False;
end;

function TOdbcEnvHandle.TryParseOdbcDriverVersion(const ADriverName: string; out Major, Minor: Integer): Boolean;
var
  Upper: string;
  PStart, PEnd, DotPos: Integer;
  VerStr, MajorStr, MinorStr: string;
begin
  Result := False;
  Major := 0;
  Minor := 0;
  Upper := UpperCase(Trim(ADriverName));
  if (Length(Upper) >= 2) and (Upper[1] = '{') and (Upper[Length(Upper)] = '}') then
    Upper := Trim(Copy(Upper, 2, Length(Upper) - 2));

  PStart := Pos('ODBC DRIVER ', Upper);
  if PStart > 0 then
  begin
    Inc(PStart, Length('ODBC DRIVER '));
    PEnd := Pos(' FOR SQL SERVER', Upper);
    if PEnd > PStart then
    begin
      VerStr := Trim(Copy(Upper, PStart, PEnd - PStart));
      DotPos := Pos('.', VerStr);
      if DotPos > 0 then
      begin
        MajorStr := Copy(VerStr, 1, DotPos - 1);
        MinorStr := Copy(VerStr, DotPos + 1, Length(VerStr) - DotPos);
        if TryStrToInt(MajorStr, Major) then
        begin
          if not TryStrToInt(MinorStr, Minor) then
            Minor := 0;
          Result := True;
        end;
      end
      else
      begin
        if TryStrToInt(VerStr, Major) then
        begin
          Minor := 0;
          Result := True;
        end;
      end;
    end;
  end;
end;

function TOdbcEnvHandle.IsDriver18Plus(const ADriverNameOrConnStr: string): Boolean;
var
  Major, Minor: Integer;
begin
  Result := TryParseOdbcDriverVersion(ADriverNameOrConnStr, Major, Minor) and (Major >= 18);
end;

function TOdbcEnvHandle.ResolveSqlServerDriver(const RequestedDriverOrProvider: string): string;
var
  ReqUpper, Preferred: string;
  I: Integer;
  BestWeight, CurWeight: Integer;
  BestDriver: string;
  Major, Minor: Integer;
begin
  LoadInstalledDrivers;
  ReqUpper := UpperCase(Trim(RequestedDriverOrProvider));
  if (Length(ReqUpper) >= 2) and (ReqUpper[1] = '{') and (ReqUpper[Length(ReqUpper)] = '}') then
    ReqUpper := Trim(Copy(ReqUpper, 2, Length(ReqUpper) - 2));

  // 1. If the caller requested an exact non-generic ODBC driver name that is already installed, use it directly.
  //    Generic tokens ('SQL SERVER', 'SQLSERVER', 'MSSQL', '') mean "pick best installed modern SQL driver",
  //    so they must NOT bypass the priority list and short-circuit to legacy sqlsrv32.dll.
  if (ReqUpper <> '') and (ReqUpper <> 'SQL SERVER') and (ReqUpper <> 'SQLSERVER') and
     (ReqUpper <> 'MSSQL') and (ReqUpper <> 'DEFAULT') and IsDriverInstalled(ReqUpper) then
  begin
    for I := 0 to High(FInstalledDrivers) do
      if SameText(FInstalledDrivers[I], ReqUpper) then
        Exit(FInstalledDrivers[I]);
  end;

  // 2. Map OLE DB Provider names to their closest preferred ODBC driver first
  Preferred := '';
  if (Pos('MSOLEDBSQL19', ReqUpper) > 0) or (Pos('DRIVER 19', ReqUpper) > 0) then
  begin
    if IsDriverInstalled('ODBC Driver 19 for SQL Server') then
      Preferred := 'ODBC Driver 19 for SQL Server'
    else if IsDriverInstalled('ODBC Driver 18 for SQL Server') then
      Preferred := 'ODBC Driver 18 for SQL Server';
  end
  else if (Pos('MSOLEDBSQL', ReqUpper) > 0) or (Pos('DRIVER 18', ReqUpper) > 0) then
  begin
    if IsDriverInstalled('ODBC Driver 18 for SQL Server') then
      Preferred := 'ODBC Driver 18 for SQL Server'
    else if IsDriverInstalled('ODBC Driver 17 for SQL Server') then
      Preferred := 'ODBC Driver 17 for SQL Server';
  end
  else if (Pos('DRIVER 17', ReqUpper) > 0) then
    Preferred := 'ODBC Driver 17 for SQL Server'
  else if (Pos('SQLNCLI11', ReqUpper) > 0) or (Pos('11.0', ReqUpper) > 0) then
    Preferred := 'SQL Server Native Client 11.0'
  else if (Pos('SQLNCLI10', ReqUpper) > 0) or (Pos('10.0', ReqUpper) > 0) then
    Preferred := 'SQL Server Native Client 10.0'
  else if (Pos('SQLNCLI', ReqUpper) > 0) then
    Preferred := 'SQL Native Client'
  else if (Pos('SQLOLEDB', ReqUpper) > 0) or (Pos('SQL SERVER', ReqUpper) > 0) or (Pos('MSSQL', ReqUpper) > 0) then
    Preferred := ''; // Auto-select best installed modern SQL driver (ODBC Driver 18/17/etc.)

  if (Preferred <> '') and IsDriverInstalled(Preferred) then
    Exit(Preferred);

  // 3. Dynamic Discovery Tier 1: Find the newest installed "ODBC Driver <X> for SQL Server"
  //    Dynamically inspects version numbers (e.g. 21, 20, 19, 18, 17, 13.1, 13, 11)
  //    and automatically selects the highest installed version without static array limits.
  BestWeight := 0;
  BestDriver := '';
  for I := 0 to High(FInstalledDrivers) do
  begin
    if TryParseOdbcDriverVersion(FInstalledDrivers[I], Major, Minor) then
    begin
      CurWeight := Major * 1000 + Minor;
      if CurWeight > BestWeight then
      begin
        BestWeight := CurWeight;
        BestDriver := FInstalledDrivers[I];
      end;
    end;
  end;

  if BestDriver <> '' then
    Exit(BestDriver);

  // 4. Fallback Tier 2: SQL Server Native Client line (discontinued by Microsoft at 11.0)
  if IsDriverInstalled('SQL Server Native Client 11.0') then
    Exit('SQL Server Native Client 11.0')
  else if IsDriverInstalled('SQL Server Native Client 10.0') then
    Exit('SQL Server Native Client 10.0')
  else if IsDriverInstalled('SQL Native Client') then
    Exit('SQL Native Client');

  // 5. Ultimate Fallback Tier 3: Built-in Windows legacy driver (sqlsrv32.dll)
  Result := 'SQL Server';
end;

{ TOdbcConnectionHandle }

constructor TOdbcConnectionHandle.Create(AEnv: TOdbcEnvHandle; AOwnsEnv: Boolean);
var
  Ret: SqlReturn;
begin
  inherited Create;
  FEnv := AEnv;
  FOwnsEnv := AOwnsEnv;
  FHDbc := SQL_NULL_HANDLE;
  FTrimFixedChar := True;
  FTrimVarChar := False;
  FInTransaction := False;
  FSupportsTxnIsolation := True;
  FCurIsolation := 0;
  Ret := SQLAllocHandle(SQL_HANDLE_DBC, FEnv.HEnv, FHDbc);
  if not OdbcSucceeded(Ret) then
    FEnv.CheckError(Ret, 'SQLAllocHandle(SQL_HANDLE_DBC)');
end;

destructor TOdbcConnectionHandle.Destroy;
begin
  Disconnect;
  FreeAndNil(FDialect);
  if FHDbc <> SQL_NULL_HANDLE then
  begin
    SQLFreeHandle(SQL_HANDLE_DBC, FHDbc);
    FHDbc := SQL_NULL_HANDLE;
  end;
  if FOwnsEnv then
    FreeAndNil(FEnv);
  inherited;
end;

procedure TOdbcConnectionHandle.CheckError(RetCode: SqlReturn; const ContextMsg: string);
begin
  if not OdbcSucceeded(RetCode) then
    RaiseOdbcDiagError(SQL_HANDLE_DBC, FHDbc, RetCode, ContextMsg);
end;

function TOdbcConnectionHandle.GetStringInfoW(InfoType: SqlUSmallint): string;
var
  Buf: array[0..255] of WideChar;
  StrLen: SqlSmallint;
  Ret: SqlReturn;
begin
  Result := '';
  FillChar(Buf, SizeOf(Buf), 0);
  StrLen := 0;
  Ret := SQLGetInfoW(FHDbc, InfoType, @Buf[0], SizeOf(Buf), @StrLen);
  if OdbcSucceeded(Ret) then
    Result := string(PWideChar(@Buf[0]));
end;

function TOdbcConnectionHandle.HasNamespaceUsage(InfoType: SqlUSmallint): Boolean;
var
  Usage: SqlUInteger;
  InfoLength: SqlSmallint;
  Ret: SqlReturn;
begin
  Usage := 0;
  Ret := SQLGetInfoW(FHDbc, InfoType, @Usage, SizeOf(Usage), @InfoLength);
  // Unknown capabilities must not silently discard a caller's namespace filter.
  Result := not OdbcSucceeded(Ret) or (Usage <> 0);
end;

procedure TOdbcConnectionHandle.QueryConnectionMetadata;
begin
  FDbmsName := GetStringInfoW(SQL_DBMS_NAME);
  FDbmsVersion := GetStringInfoW(SQL_DBMS_VER);
  FDriverName := GetStringInfoW(SQL_DRIVER_NAME);
  FDriverVersion := GetStringInfoW(SQL_DRIVER_VER);
  FUserName := GetStringInfoW(SQL_USER_NAME);
  FQuoteChar := Trim(GetStringInfoW(SQL_IDENTIFIER_QUOTE_CHAR));
  FSupportsCatalogs := HasNamespaceUsage(SQL_CATALOG_USAGE);
  FSupportsSchemas := HasNamespaceUsage(SQL_SCHEMA_USAGE);
  if FQuoteChar = '' then
    FQuoteChar := '"';

  FreeAndNil(FDialect);
  FDialect := TOdbcDialectFactory.CreateDialect(FDbmsName, FDbmsVersion);
  if not FSupportsCatalogs then
    FDialect.SupportsCatalogs := False
  else if not FDialect.SupportsCatalogs then
    FSupportsCatalogs := False;

  if not FSupportsSchemas then
    FDialect.SupportsSchemas := False
  else if not FDialect.SupportsSchemas then
    FSupportsSchemas := False;

  if FDialect.QuoteChar <> #0 then
    FQuoteChar := FDialect.QuoteChar;
end;

procedure TOdbcConnectionHandle.Connect(const ConnectionString: string);
var
  OutBuf: array[0..2047] of WideChar;
  OutLen: SqlSmallint;
  Ret: SqlReturn;
begin
  if FConnected then
    Exit;
  if Trim(ConnectionString) = '' then
    raise EOdbcError.Create(TDBXErrorCodes.InvalidArgument,
      'ODBC ConnectionString cannot be empty.', '08001', 0);

  FillChar(OutBuf, SizeOf(OutBuf), 0);
  OutLen := 0;
  Ret := SQLDriverConnectW(
    FHDbc,
    0,
    PWideChar(ConnectionString),
    SQL_NTS,
    @OutBuf[0],
    Length(OutBuf) - 1,
    OutLen,
    SQL_DRIVER_NOPROMPT
  );
  CheckError(Ret, 'SQLDriverConnectW');
  FConnected := True;
  FInTransaction := False;
  FSupportsTxnIsolation := True;
  FCurIsolation := 0;
  FReturnedConnectionString := string(PWideChar(@OutBuf[0]));
  QueryConnectionMetadata;
end;

procedure TOdbcConnectionHandle.Disconnect;
begin
  if FConnected and (FHDbc <> SQL_NULL_HANDLE) then
  begin
    if FInTransaction then
    begin
      try
        Rollback;
      except
        // Ignore rollback errors during disconnect
      end;
    end;
    SQLDisconnect(FHDbc);
    FConnected := False;
    FInTransaction := False;
    FCurIsolation := 0;
    FreeAndNil(FDialect);
  end;
end;

procedure TOdbcConnectionHandle.BeginTransaction(IsolationLevel: TDBXIsolation);
var
  OdbcIso: NativeInt;
  Ret: SqlReturn;
  ActualIso: SqlUInteger;
  ActualLen: SqlInteger;
begin
  if FInTransaction then
    raise TDBXError.Create(TDBXErrorCodes.TransactionActive, 'A transaction is already active.');

  case IsolationLevel of
    TDBXIsolations.DirtyRead:
      OdbcIso := SQL_TXN_READ_UNCOMMITTED;
    TDBXIsolations.RepeatableRead:
      OdbcIso := SQL_TXN_REPEATABLE_READ;
    TDBXIsolations.Serializable:
      OdbcIso := SQL_TXN_SERIALIZABLE;
  else
    OdbcIso := SQL_TXN_READ_COMMITTED;
  end;

  if FSupportsTxnIsolation and (FCurIsolation <> OdbcIso) then
  begin
    Ret := SQLSetConnectAttrW(FHDbc, SQL_ATTR_TXN_ISOLATION, SqlPointer(OdbcIso), 0);
    if not OdbcSucceeded(Ret) then
    begin
      try
        CheckError(Ret, 'SQLSetConnectAttrW(SQL_ATTR_TXN_ISOLATION)');
      except
        on E: EOdbcError do
        begin
          if (E.SqlState = 'HYC00') or (E.SqlState = 'IM001') or
             (E.SqlState = 'S1C00') or (E.SqlState = 'HY092') then
          begin
            // Driver does not support configurable transaction isolation (e.g. MS Jet / Access)
            FSupportsTxnIsolation := False;
          end
          else
            raise;
        end;
      end;
    end
    else
    begin
      FCurIsolation := OdbcIso;
      if Ret = SQL_SUCCESS_WITH_INFO then
      begin
        ActualIso := 0;
        ActualLen := 0;
        if OdbcSucceeded(SQLGetConnectAttrW(FHDbc, SQL_ATTR_TXN_ISOLATION, @ActualIso, SizeOf(ActualIso), @ActualLen)) and (ActualIso <> 0) then
          FCurIsolation := ActualIso;
      end;
    end;
  end;

  Ret := SQLSetConnectAttrW(FHDbc, SQL_ATTR_AUTOCOMMIT, SqlPointer(NativeInt(SQL_AUTOCOMMIT_OFF)), 0);
  CheckError(Ret, 'SQLSetConnectAttrW(SQL_ATTR_AUTOCOMMIT_OFF)');
  FInTransaction := True;
end;

procedure TOdbcConnectionHandle.Commit;
var
  Ret: SqlReturn;
begin
  if FInTransaction then
  begin
    Ret := SQLEndTran(SQL_HANDLE_DBC, FHDbc, SQL_COMMIT);
    CheckError(Ret, 'SQLEndTran(SQL_COMMIT)');
    Ret := SQLSetConnectAttrW(FHDbc, SQL_ATTR_AUTOCOMMIT, SqlPointer(NativeInt(SQL_AUTOCOMMIT_ON)), 0);
    CheckError(Ret, 'SQLSetConnectAttrW(SQL_ATTR_AUTOCOMMIT_ON)');
    FInTransaction := False;
  end;
end;

procedure TOdbcConnectionHandle.Rollback;
var
  Ret: SqlReturn;
  EndTranFailed: Boolean;
begin
  if FInTransaction then
  begin
    EndTranFailed := False;
    try
      try
        Ret := SQLEndTran(SQL_HANDLE_DBC, FHDbc, SQL_ROLLBACK);
        CheckError(Ret, 'SQLEndTran(SQL_ROLLBACK)');
      except
        EndTranFailed := True;
        raise;
      end;
    finally
      Ret := SQLSetConnectAttrW(FHDbc, SQL_ATTR_AUTOCOMMIT, SqlPointer(NativeInt(SQL_AUTOCOMMIT_ON)), 0);
      if OdbcSucceeded(Ret) then
        FInTransaction := False
      else if not EndTranFailed then
        CheckError(Ret, 'SQLSetConnectAttrW(SQL_ATTR_AUTOCOMMIT_ON)');
    end;
  end;
end;

{ TOdbcStatementHandle }

constructor TOdbcStatementHandle.Create(AConnection: TOdbcConnectionHandle);
begin
  inherited Create;
  FConnection := AConnection;
  FHStmt := SQL_NULL_HANDLE;
  FRowsAffected := -1;
end;

destructor TOdbcStatementHandle.Destroy;
begin
  FreeStatement;
  inherited;
end;

procedure TOdbcStatementHandle.CheckError(RetCode: SqlReturn; const ContextMsg: string);
begin
  if not OdbcSucceeded(RetCode) then
    RaiseOdbcDiagError(SQL_HANDLE_STMT, FHStmt, RetCode, ContextMsg);
end;

procedure TOdbcStatementHandle.AllocateHandle;
var
  Ret: SqlReturn;
begin
  if FHStmt = SQL_NULL_HANDLE then
  begin
    Ret := SQLAllocHandle(SQL_HANDLE_STMT, FConnection.HDbc, FHStmt);
    if not OdbcSucceeded(Ret) then
      FConnection.CheckError(Ret, 'SQLAllocHandle(SQL_HANDLE_STMT)');
  end
  else
  begin
    CloseCursor;
  end;
end;

procedure TOdbcStatementHandle.CloseCursor;
begin
  SetLength(FRowCells, 0);
  if FOutputPending and FCursorOpen then
    CompleteOutputParameters;
  if FHStmt <> SQL_NULL_HANDLE then
  begin
    // SQLCloseCursor(FHStmt);
    SQLFreeStmt(FHStmt, SQL_CLOSE);
    FCursorOpen := False;
  end;
end;

procedure TOdbcStatementHandle.FreeStatement;
begin
  if FHStmt <> SQL_NULL_HANDLE then
  begin
    SetLength(FRowCells, 0);
    if FOutputPending then CompleteOutputParameters;
    CloseCursor;
    SQLFreeHandle(SQL_HANDLE_STMT, FHStmt);
    FHStmt := SQL_NULL_HANDLE;
    FPrepared := False;
  end;
end;

procedure TOdbcStatementHandle.Prepare(const SQL: string);
var
  Ret: SqlReturn;
begin
  AllocateHandle;
  Ret := SQLPrepareW(FHStmt, PWideChar(SQL), SQL_NTS);
  CheckError(Ret, 'SQLPrepareW');
  FPrepared := True;
end;

function TOdbcStatementHandle.ExecutePrepared: SqlSmallint;
var
  Ret: SqlReturn;
  RowCnt: TSqlLen;
begin
  CloseCursor;
  SetLength(FRowCells, 0);
  Ret := SQLExecute(FHStmt);
  if Ret <> SQL_NO_DATA then
    CheckError(Ret, 'SQLExecute');
  FOutputPending := FHasOutputParameters;

  RowCnt := -1;
  if OdbcSucceeded(SQLRowCount(FHStmt, RowCnt)) then
    FRowsAffected := RowCnt
  else
    FRowsAffected := -1;

  Result := 0;
  Ret := SQLNumResultCols(FHStmt, Result);
  CheckError(Ret, 'SQLNumResultCols');
  FCursorOpen := (Result > 0);
  if not FCursorOpen and FOutputPending then
    CompleteOutputParameters;
end;

function TOdbcStatementHandle.ExecuteDirect(const SQL: string): SqlSmallint;
var
  Ret: SqlReturn;
  RowCnt: TSqlLen;
begin
  AllocateHandle;
  SetLength(FRowCells, 0);
  Ret := SQLExecDirectW(FHStmt, PWideChar(SQL), SQL_NTS);
  if Ret <> SQL_NO_DATA then
    CheckError(Ret, 'SQLExecDirectW');

  RowCnt := -1;
  if OdbcSucceeded(SQLRowCount(FHStmt, RowCnt)) then
    FRowsAffected := RowCnt
  else
    FRowsAffected := -1;

  Result := 0;
  Ret := SQLNumResultCols(FHStmt, Result);
  CheckError(Ret, 'SQLNumResultCols');
  FCursorOpen := (Result > 0);
end;

procedure TOdbcStatementHandle.MapOdbcTypeToDbx(var ColMeta: TOdbcColumnMeta);
begin
  ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
  ColMeta.DBXPrecision := TInt32(ColMeta.ColumnSize);
  ColMeta.DBXScale := ColMeta.DecimalDigits;
  if ColMeta.DBXScale < 0 then
    ColMeta.DBXScale := 0;
  ColMeta.DBXSize := TInt32(ColMeta.ColumnSize);

  case ColMeta.SqlType of
    // SQL Server tinyint -> ftSmallint (TSmallIntField)
    SQL_TINYINT:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.Int16Type;
        ColMeta.DBXSize := SizeOf(SmallInt);
      end;
    // SQL Server smallint -> ftInteger (TIntegerField)
    SQL_SMALLINT:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.Int32Type;
        ColMeta.DBXSize := SizeOf(TInt32);
      end;
    // SQL Server int -> ftInteger (TIntegerField), or ftLargeint for unsigned (e.g. MySQL INT UNSIGNED up to 4.29B)
    SQL_INTEGER:
      begin
        if ColMeta.IsUnsigned then
        begin
          ColMeta.DBXDataType := TDBXDataTypes.Int64Type;
          ColMeta.DBXSize := SizeOf(Int64);
        end
        else
        begin
          ColMeta.DBXDataType := TDBXDataTypes.Int32Type;
          ColMeta.DBXSize := SizeOf(TInt32);
        end;
      end;
    // SQL Server bigint -> ftLargeint (TLargeIntField)
    SQL_BIGINT:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.Int64Type;
        ColMeta.DBXSize := SizeOf(Int64);
      end;
    // SQL Server real -> ftSingle (TSingleField)
    SQL_REAL:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.SingleType;
        ColMeta.DBXSize := SizeOf(Single);
      end;
    // SQL Server float -> ftFloat (TFloatField)
    SQL_FLOAT, SQL_DOUBLE:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.DoubleType;
        ColMeta.DBXSize := SizeOf(Double);
      end;
    // SQL Server bit -> ftBoolean (TBooleanField)
    SQL_BIT:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.BooleanType;
        ColMeta.DBXSize := SizeOf(WordBool);
      end;
    // SQL Server decimal, numeric, money, smallmoney, Oracle NUMBER
    SQL_DECIMAL, SQL_NUMERIC:
      begin
        if (ColMeta.DecimalDigits = 0) and (ColMeta.ColumnSize > 0) and (ColMeta.ColumnSize <= 9) then
        begin
          ColMeta.DBXDataType := TDBXDataTypes.Int32Type;
          ColMeta.DBXSize := SizeOf(TInt32);
        end
        else if (ColMeta.DecimalDigits = 0) and (ColMeta.ColumnSize > 0) and (ColMeta.ColumnSize <= 18) then
        begin
          ColMeta.DBXDataType := TDBXDataTypes.Int64Type;
          ColMeta.DBXSize := SizeOf(Int64);
        end
        else
        begin
          // Maps to ftBCD / ftFMTBcd via BcdType
          ColMeta.DBXDataType := TDBXDataTypes.BcdType;
          ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
          ColMeta.DBXSize := SizeOf(TBcd);
          if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 64) then
            ColMeta.DBXPrecision := 38;
          if (ColMeta.DBXScale < 0) or (ColMeta.DBXScale > 38) then
            ColMeta.DBXScale := 0;
        end;
      end;
    SQL_TYPE_DATE, SQL_DATE:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.DateType;
        ColMeta.DBXSize := SizeOf(TDBXDate);
      end;
    SQL_TYPE_TIME, SQL_TIME, SQL_SS_TIME2:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.TimeType;
        ColMeta.DBXSize := SizeOf(TDBXTime);
      end;
    SQL_TYPE_TIMESTAMP, SQL_TIMESTAMP:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.TimeStampType;
        ColMeta.DBXSize := SizeOf(TSQLTimeStamp);
      end;
    // SQL_BINARY: if ColumnSize = 0 (e.g. SQLite / other DBMS BLOB), map to BlobType
    // Otherwise fixed binary / timestamp -> ftBytes (TBytesField)
    SQL_BINARY:
      begin
        if ColMeta.ColumnSize = 0 then
        begin
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          ColMeta.DBXSubType := TDBXDataTypes.BinarySubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          ColMeta.DBXDataType := TDBXDataTypes.BytesType;
          if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
            ColMeta.DBXSize := 8;
          ColMeta.DBXScale := ColMeta.DBXSize;
        end;
      end;
    // SQL Server varbinary -> ftVarBytes (TVarBytesField) or ftBlob if max
    SQL_VARBINARY, SQL_LONGVARBINARY:
      begin
        if (ColMeta.SqlType = SQL_LONGVARBINARY) or (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 8000) then
        begin
          // image / varbinary(max) -> ftBlob (TBlobField)
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          ColMeta.DBXSubType := TDBXDataTypes.BinarySubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          // varbinary -> ftVarBytes (TVarBytesField)
          ColMeta.DBXDataType := TDBXDataTypes.VarBytesType;
        end;
      end;
    // SQL Server char -> ftFixedChar (TStringField)
    SQL_CHAR:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
        ColMeta.DBXSubType := TDBXDataTypes.FixedSubType;
        if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 8000) then
          ColMeta.DBXPrecision := 255;
        ColMeta.DBXSize := ColMeta.DBXPrecision + 1;
      end;
    // SQL Server varchar, sql_variant -> ftString (TStringField) or ftMemo/ftWideMemo if max
    SQL_VARCHAR, SQL_SS_VARIANT:
      begin
        if (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 8000) then
        begin
          // varchar(max) -> ftWideMemo when UseUnicode, else ftMemo
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          if (FConnection <> nil) and not FConnection.UseUnicode then
            ColMeta.DBXSubType := TDBXDataTypes.MemoSubType
          else
            ColMeta.DBXSubType := TDBXDataTypes.WideMemoSubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          // varchar -> ftString (TStringField)
          ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
          if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 8000) then
            ColMeta.DBXPrecision := 255;
          ColMeta.DBXSize := ColMeta.DBXPrecision + 1;
        end;
      end;
    // In Delphi 2009+, string is UnicodeString and TStringField/TMemoField natively
    // handles Unicode in modern VCL applications.
    // By default (UseUnicode=False), map string and memo fields to AnsiStringType /
    // MemoSubType so existing projects with persistent TStringField/TMemoField
    // (.dfm) definitions do not encounter runtime type mismatch errors.
    // When UseUnicode=True is specified, map to WideStringType / WideMemoSubType.
    SQL_LONGVARCHAR, SQL_WLONGVARCHAR, SQL_SS_XML:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.BlobType;
        if (FConnection <> nil) and not FConnection.UseUnicode then
          ColMeta.DBXSubType := TDBXDataTypes.MemoSubType
        else
          ColMeta.DBXSubType := TDBXDataTypes.WideMemoSubType;
        ColMeta.DBXSize := 1;
        ColMeta.DBXPrecision := 1;
      end;
    // SQL Server nchar -> fixed string
    SQL_WCHAR:
      begin
        if (FConnection <> nil) and FConnection.UseUnicode then
        begin
          ColMeta.DBXDataType := TDBXDataTypes.WideStringType;
          if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 4000) then
            ColMeta.DBXPrecision := 255;
          ColMeta.DBXSize := (ColMeta.DBXPrecision + 1) * SizeOf(Char);
        end
        else
        begin
          ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
          if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 8000) then
            ColMeta.DBXPrecision := 255;
          ColMeta.DBXSize := ColMeta.DBXPrecision + 1;
        end;
        ColMeta.DBXSubType := TDBXDataTypes.FixedSubType;
      end;
    // SQL Server nvarchar -> string or memo if max
    SQL_WVARCHAR:
      begin
        if (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 4000) then
        begin
          // nvarchar(max) -> memo
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          if (FConnection <> nil) and not FConnection.UseUnicode then
            ColMeta.DBXSubType := TDBXDataTypes.MemoSubType
          else
            ColMeta.DBXSubType := TDBXDataTypes.WideMemoSubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          // nvarchar -> string
          if (FConnection <> nil) and FConnection.UseUnicode then
          begin
            ColMeta.DBXDataType := TDBXDataTypes.WideStringType;
            if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 4000) then
              ColMeta.DBXPrecision := 255;
            ColMeta.DBXSize := (ColMeta.DBXPrecision + 1) * SizeOf(Char);
          end
          else
          begin
            ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
            if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 8000) then
              ColMeta.DBXPrecision := 255;
            ColMeta.DBXSize := ColMeta.DBXPrecision + 1;
          end;
        end;
      end;
    // SQL Server guid (uniqueidentifier) -> ftFixedChar (Size=38)
    SQL_GUID:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
        ColMeta.DBXSubType := TDBXDataTypes.FixedSubType;
        ColMeta.DBXPrecision := 38;
        ColMeta.DBXSize := 39;
      end;
  else
    // Fallback default
    if (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 4000) then
    begin
      ColMeta.DBXDataType := TDBXDataTypes.BlobType;
      ColMeta.DBXSubType := TDBXDataTypes.WideMemoSubType;
      ColMeta.DBXSize := 1;
      ColMeta.DBXPrecision := 1;
    end
    else
    begin
      ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
      if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 8000) then
        ColMeta.DBXPrecision := 255;
      ColMeta.DBXSize := ColMeta.DBXPrecision + 1;
    end;
  end;
end;

function TOdbcStatementHandle.DescribeResultColumns: TOdbcColumnMetaArray;
var
  ColCount, i: SqlSmallint;
  NameBuf: array[0..255] of WideChar;
  NameLen: SqlSmallint;
  Ret: SqlReturn;
begin
  ColCount := 0;
  Ret := SQLNumResultCols(FHStmt, ColCount);
  CheckError(Ret, 'SQLNumResultCols');
  SetLength(FColumns, ColCount);
  for i := 1 to ColCount do
  begin
    FillChar(NameBuf, SizeOf(NameBuf), 0);
    NameLen := 0;
    FColumns[i - 1].ColumnNumber := i;
    Ret := SQLDescribeColW(
      FHStmt,
      i,
      @NameBuf[0],
      Length(NameBuf) - 1,
      NameLen,
      FColumns[i - 1].SqlType,
      FColumns[i - 1].ColumnSize,
      FColumns[i - 1].DecimalDigits,
      FColumns[i - 1].Nullable
    );
    CheckError(Ret, 'SQLDescribeColW');
    FColumns[i - 1].Name := string(PWideChar(@NameBuf[0]));
    if FColumns[i - 1].Name = '' then
      FColumns[i - 1].Name := 'Column' + IntToStr(i);

    FColumns[i - 1].IsUnsigned := False;
    case FColumns[i - 1].SqlType of
      SQL_TINYINT, SQL_SMALLINT, SQL_INTEGER, SQL_BIGINT:
        begin
          var NumAttr: TSqlLen := 0;
          if OdbcSucceeded(SQLColAttributeW(FHStmt, i, SQL_DESC_UNSIGNED, nil, 0, nil, @NumAttr)) then
            FColumns[i - 1].IsUnsigned := (NumAttr = 1);
        end;
    end;

    MapOdbcTypeToDbx(FColumns[i - 1]);
    if (FConnection <> nil) and (FConnection.Dialect <> nil) then
      FConnection.Dialect.AdjustColumnMetadata(FHStmt, i, FColumns[i - 1]);
  end;
  Result := FColumns;
end;

function TOdbcStatementHandle.FetchNext: Boolean;
var
  Ret: SqlReturn;
begin
  Ret := SQLFetch(FHStmt);
  if Ret = SQL_NO_DATA then
  begin
    SetLength(FRowCells, 0);
    FCursorOpen := False;
    Result := False;
    Exit;
  end;
  try
    CheckError(Ret, 'SQLFetch');
    PreFetchRow;
  except
    SetLength(FRowCells, 0);
    raise;
  end;
  Result := True;
end;

function TOdbcStatementHandle.MoreResults(out ColumnCount: SqlSmallint): Boolean;
var
  Ret: SqlReturn;
begin
  SetLength(FRowCells, 0);
  SetLength(FColumns, 0);
  ColumnCount := 0;
  FCursorOpen := False;
  Ret := SQLMoreResults(FHStmt);
  if Ret = SQL_NO_DATA then
  begin
    CopyOutputParameters;
    Exit(False);
  end;
  CheckError(Ret, 'SQLMoreResults');
  Ret := SQLNumResultCols(FHStmt, ColumnCount);
  CheckError(Ret, 'SQLNumResultCols');
  FCursorOpen := (ColumnCount > 0);
  Result := True;
end;

procedure TOdbcStatementHandle.CheckColIndex(ColNo: SqlUSmallint);
begin
  if (ColNo < 1) or (ColNo > Length(FRowCells)) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument,
      Format('ODBC column index %d out of bounds (1..%d)', [ColNo, Length(FRowCells)]));
end;

function TOdbcStatementHandle.ReadRawColumnData(ColNo: SqlUSmallint;
  TargetType: SqlSmallint; out IsNull: LongBool): TBytes;
var
  Buffer: array[0..8191] of Byte;
  Ind: TSqlLen;
  Ret: SqlReturn;
  Payload, Count: Integer;
  DataLen, Capacity: Integer;
begin
  Payload := SizeOf(Buffer);
  if TargetType = SQL_C_CHAR then Dec(Payload);
  if TargetType = SQL_C_WCHAR then Dec(Payload, SizeOf(WideChar));

  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, TargetType, @Buffer[0], SizeOf(Buffer), @Ind);
  if Ret = SQL_NO_DATA then
  begin
    IsNull := True;
    Result := nil;
    Exit;
  end;
  CheckError(Ret, 'SQLGetData(column data)');
  if Ind = SQL_NULL_DATA then
  begin
    IsNull := True;
    Result := nil;
    Exit;
  end;
  IsNull := False;

  // Fast path: all data fits in the first stack buffer chunk
  if (Ret = SQL_SUCCESS) and (Ind >= 0) and (Ind <= Payload) then
  begin
    if Ind = 0 then
      Result := nil
    else
    begin
      SetLength(Result, Ind);
      Move(Buffer[0], Result[0], Ind);
    end;
    Exit;
  end;

  // Multi-chunk path for large strings and binary blobs.
  // Assemble directly into Result (TBytes) with separate capacity tracking to eliminate
  // intermediate TMemoryStream heap allocation and the subsequent full-buffer copy.
  if (Ind = SQL_NO_TOTAL) or (Ind > Payload) then
    Count := Payload
  else
    Count := Ind;

  if (Ind <> SQL_NO_TOTAL) and (Ind > Count) then
  begin
    // Driver reported total data length up front (e.g. SQL Server). Pre-allocate exact buffer.
    Capacity := Ind;
    SetLength(Result, Capacity);
  end
  else
  begin
    // Driver did not report total length up front (SQL_NO_TOTAL). Use geometric capacity growth.
    Capacity := 32768;
    if Capacity < Count then
      Capacity := Count * 2;
    SetLength(Result, Capacity);
  end;

  DataLen := 0;
  if Count > 0 then
  begin
    Move(Buffer[0], Result[0], Count);
    DataLen := Count;
  end;

  while (Ret <> SQL_SUCCESS) and ((Ind = SQL_NO_TOTAL) or (Ind > Payload)) do
  begin
    Ind := 0;
    Ret := SQLGetData(FHStmt, ColNo, TargetType, @Buffer[0], SizeOf(Buffer), @Ind);
    if Ret = SQL_NO_DATA then
      Break;
    CheckError(Ret, 'SQLGetData(column data chunk)');
    if Ind = SQL_NULL_DATA then
      Break;

    if (Ind = SQL_NO_TOTAL) or (Ind > Payload) then
      Count := Payload
    else
      Count := Ind;

    if Count > 0 then
    begin
      if DataLen + Count > Capacity then
      begin
        Capacity := Capacity * 2;
        if Capacity < DataLen + Count then
          Capacity := DataLen + Count + 16384;
        SetLength(Result, Capacity);
      end;
      Move(Buffer[0], Result[DataLen], Count);
      Inc(DataLen, Count);
    end;
  end;

  if DataLen = 0 then
    Result := nil
  else if Length(Result) <> DataLen then
    SetLength(Result, DataLen);
end;

function OdbcTimeTextToDbx(const Text: string): TDBXTime;
var
  S, Fraction: string;
  Dot: Integer;
begin
  S := Trim(Text);
  Dot := Pos('.', S);
  Fraction := '000';
  if Dot > 0 then Fraction := Copy(Copy(S, Dot+1, MaxInt)+'000', 1, 3);
  Result := DateTimeToTimeStamp(EncodeTime(StrToInt(Copy(S,1,2)),
    StrToInt(Copy(S,4,2)), StrToInt(Copy(S,7,2)), StrToInt(Fraction))).Time;
end;

function OdbcTimestampOffsetText(const Text: string): TSQLTimeStampOffset;
var
  S: string;
  ZonePos, ZoneSign: Integer;
  Clock: TDBXTime;
begin
  S := Trim(Text);
  Result := NullSQLTimeStampOffset;
  if (Length(S) < 25) or (S[5] <> '-') or (S[8] <> '-') then
    raise EConvertError.Create('Invalid ODBC timestamp offset format');
  ZonePos := Length(S)-5;
  if not CharInSet(S[ZonePos], ['+', '-']) or (S[ZonePos+3] <> ':') then
    raise EConvertError.Create('Invalid ODBC timestamp timezone');
  Result.Year := StrToInt(Copy(S,1,4));
  Result.Month := StrToInt(Copy(S,6,2));
  Result.Day := StrToInt(Copy(S,9,2));
  EncodeDate(Result.Year, Result.Month, Result.Day); // Validate the calendar date.
  Clock := OdbcTimeTextToDbx(Copy(S,12,ZonePos-12));
  Result.Hour := Clock div 3600000;
  Result.Minute := (Clock div 60000) mod 60;
  Result.Second := (Clock div 1000) mod 60;
  Result.Fractions := Clock mod 1000;
  ZoneSign := 1;
  if S[ZonePos] = '-' then ZoneSign := -1;
  Result.TimeZoneHour := StrToInt(Copy(S,ZonePos+1,2));
  Result.TimeZoneMinute := StrToInt(Copy(S,ZonePos+4,2));
  if (Result.TimeZoneHour > 14) or (Result.TimeZoneMinute > 59) or
    ((Result.TimeZoneHour = 14) and (Result.TimeZoneMinute <> 0)) then
    raise EConvertError.Create('Invalid ODBC timestamp timezone range');
  Result.TimeZoneHour := Result.TimeZoneHour*ZoneSign;
  Result.TimeZoneMinute := Result.TimeZoneMinute*ZoneSign;
end;

procedure TOdbcStatementHandle.PreFetchRow;
var
  i, ColCount: Integer;
begin
  if Length(FColumns) = 0 then
    DescribeResultColumns;
  ColCount := Length(FColumns);
  if Length(FRowCells) <> ColCount then
    SetLength(FRowCells, ColCount);
  for i := 0 to ColCount - 1 do
    FetchColumnCell(i + 1, FColumns[i], FRowCells[i]);
end;

procedure TOdbcStatementHandle.FetchColumnCell(ColNo: SqlUSmallint;
  const ColMeta: TOdbcColumnMeta; var Cell: TOdbcRowCell);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
  BoolVal: WordBool;
  ShortVal: SmallInt;
  LongVal: TInt32;
  BigIntVal: Int64;
  SngVal: Single;
  DblVal: Double;
  OdbcDate: tagDATE_STRUCT;
  OdbcTS: tagTIMESTAMP_STRUCT;
  RawBytes: TBytes;
  Fmt: TFormatSettings;
  S: string;
  IsFixed, IsVar: Boolean;
  ChBuf: array[0..15] of AnsiChar;
begin
  Cell := Default(TOdbcRowCell);
  Ind := 0;

  case ColMeta.DBXDataType of
    TDBXDataTypes.BooleanType:
      begin
        BoolVal := False;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_BIT, @BoolVal, SizeOf(BoolVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else if OdbcSucceeded(Ret) then
        begin
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.IntVal := Ord(Byte(BoolVal) <> 0);
        end
        else
        begin
          // Fallback if driver does not support SQL_C_BIT directly (e.g. returns 't'/'f')
          FillChar(ChBuf, SizeOf(ChBuf), 0);
          Ret := SQLGetData(FHStmt, ColNo, SQL_C_CHAR, @ChBuf[0], SizeOf(ChBuf), @Ind);
          if (Ret = SQL_NO_DATA) or (Ind = SQL_NULL_DATA) then
            Cell.IsNull := True
          else if OdbcSucceeded(Ret) then
          begin
            Cell.IsNull := False;
            Cell.IntVal := Ord(ChBuf[0] in ['1', 't', 'T', 'y', 'Y']);
          end;
        end;
      end;

    TDBXDataTypes.Int16Type, TDBXDataTypes.UInt16Type, TDBXDataTypes.Int8Type, TDBXDataTypes.UInt8Type:
      begin
        ShortVal := 0;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_SSHORT, @ShortVal, SizeOf(ShortVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Int16)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.IntVal := ShortVal;
        end;
      end;

    TDBXDataTypes.Int32Type:
      begin
        LongVal := 0;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_SLONG, @LongVal, SizeOf(LongVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Int32)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.IntVal := LongVal;
        end;
      end;

    TDBXDataTypes.Int64Type:
      begin
        BigIntVal := 0;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_SBIGINT, @BigIntVal, SizeOf(BigIntVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Int64)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.IntVal := BigIntVal;
        end;
      end;

    TDBXDataTypes.SingleType:
      begin
        SngVal := 0;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_FLOAT, @SngVal, SizeOf(SngVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Single)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.DoubleVal := SngVal;
        end;
      end;

    TDBXDataTypes.DoubleType:
      begin
        DblVal := 0;
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_DOUBLE, @DblVal, SizeOf(DblVal), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Double)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
            Cell.DoubleVal := DblVal;
        end;
      end;

    TDBXDataTypes.DateType:
      begin
        FillChar(OdbcDate, SizeOf(OdbcDate), 0);
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_TYPE_DATE, @OdbcDate, SizeOf(OdbcDate), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(Date)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
          begin
            if (OdbcDate.Year >= 1) and (OdbcDate.Month in [1..12]) and (OdbcDate.Day in [1..31]) then
            begin
              try
                Cell.DateVal := DateTimeToTimeStamp(EncodeDate(OdbcDate.Year, OdbcDate.Month, OdbcDate.Day)).Date;
              except
                Cell.DateVal := 0;
              end;
            end
            else
              Cell.DateVal := 0;
          end;
        end;
      end;

    TDBXDataTypes.TimeType:
      begin
        RawBytes := ReadRawColumnData(ColNo, SQL_C_WCHAR, Cell.IsNull);
        if not Cell.IsNull and (Length(RawBytes) > 0) then
        begin
          SetString(Cell.StrVal, PWideChar(@RawBytes[0]), Length(RawBytes) div SizeOf(WideChar));
          Cell.TimeVal := OdbcTimeTextToDbx(Cell.StrVal);
        end;
      end;

    TDBXDataTypes.TimeStampType:
      begin
        FillChar(OdbcTS, SizeOf(OdbcTS), 0);
        Ret := SQLGetData(FHStmt, ColNo, SQL_C_TYPE_TIMESTAMP, @OdbcTS, SizeOf(OdbcTS), @Ind);
        if Ret = SQL_NO_DATA then
          Cell.IsNull := True
        else
        begin
          CheckError(Ret, 'SQLGetData(TimeStamp)');
          Cell.IsNull := (Ind = SQL_NULL_DATA);
          if not Cell.IsNull then
          begin
            Cell.TimeStampVal.Year := OdbcTS.Year;
            Cell.TimeStampVal.Month := OdbcTS.Month;
            Cell.TimeStampVal.Day := OdbcTS.Day;
            Cell.TimeStampVal.Hour := OdbcTS.Hour;
            Cell.TimeStampVal.Minute := OdbcTS.Minute;
            Cell.TimeStampVal.Second := OdbcTS.Second;
            Cell.TimeStampVal.Fractions := OdbcTS.Fraction div 1000000;
          end;
        end;
      end;

    TDBXDataTypes.BcdType:
      begin
        RawBytes := ReadRawColumnData(ColNo, SQL_C_WCHAR, Cell.IsNull);
        if not Cell.IsNull and (Length(RawBytes) > 0) then
        begin
          SetString(Cell.StrVal, PWideChar(@RawBytes[0]), Length(RawBytes) div SizeOf(WideChar));
          Cell.StrVal := Trim(Cell.StrVal);
          if Cell.StrVal <> '' then
          begin
            Fmt := TFormatSettings.Invariant;
            S := StringReplace(Cell.StrVal, ',', '.', [rfReplaceAll]);
            if not TryStrToBcd(S, Cell.BcdVal, Fmt) then
              Cell.BcdVal := DoubleToBcd(StrToFloatDef(S, 0, Fmt));
          end
          else
            Cell.BcdVal := NullBcd;
        end
        else
          Cell.BcdVal := NullBcd;
      end;

    TDBXDataTypes.WideStringType:
      begin
        RawBytes := ReadRawColumnData(ColNo, SQL_C_WCHAR, Cell.IsNull);
        if not Cell.IsNull and (Length(RawBytes) > 0) then
        begin
          SetString(Cell.StrVal, PWideChar(@RawBytes[0]), Length(RawBytes) div SizeOf(WideChar));
          if FConnection <> nil then
          begin
            IsFixed := (ColMeta.DBXSubType = TDBXDataTypes.FixedSubType) or (ColMeta.SqlType = SQL_WCHAR);
            IsVar := (ColMeta.SqlType = SQL_WVARCHAR);
            if (FConnection.TrimFixedChar and IsFixed) or (FConnection.TrimVarChar and IsVar) then
              Cell.StrVal := TrimRight(Cell.StrVal);
          end;
        end;
      end;

    TDBXDataTypes.AnsiStringType:
      begin
        RawBytes := ReadRawColumnData(ColNo, SQL_C_CHAR, Cell.IsNull);
        if not Cell.IsNull and (Length(RawBytes) > 0) then
        begin
          SetString(Cell.AnsiVal, PAnsiChar(@RawBytes[0]), Length(RawBytes));
          if FConnection <> nil then
          begin
            IsFixed := (ColMeta.DBXSubType = TDBXDataTypes.FixedSubType) or (ColMeta.SqlType = SQL_CHAR);
            IsVar := (ColMeta.SqlType = SQL_VARCHAR);
            if (FConnection.TrimFixedChar and IsFixed) or (FConnection.TrimVarChar and IsVar) then
              Cell.AnsiVal := AnsiString(TrimRight(string(Cell.AnsiVal)));
          end;
          Cell.StrVal := string(Cell.AnsiVal);
        end;
      end;

    TDBXDataTypes.BytesType, TDBXDataTypes.BlobType:
      begin
        Cell.BytesVal := ReadRawColumnData(ColNo, GetBlobTargetType(ColNo), Cell.IsNull);
        if not Cell.IsNull and (Length(Cell.BytesVal) > 0) then
        begin
          if ColMeta.DBXSubType = TDBXDataTypes.WideMemoSubType then
            SetString(Cell.StrVal, PWideChar(@Cell.BytesVal[0]), Length(Cell.BytesVal) div SizeOf(WideChar))
          else if ColMeta.DBXSubType = TDBXDataTypes.MemoSubType then
          begin
            SetString(Cell.AnsiVal, PAnsiChar(@Cell.BytesVal[0]), Length(Cell.BytesVal));
            Cell.StrVal := string(Cell.AnsiVal);
          end;
        end;
      end;
  else
    // Fallback: read as WideString
    RawBytes := ReadRawColumnData(ColNo, SQL_C_WCHAR, Cell.IsNull);
    if not Cell.IsNull and (Length(RawBytes) > 0) then
      SetString(Cell.StrVal, PWideChar(@RawBytes[0]), Length(RawBytes) div SizeOf(WideChar));
  end;
end;

procedure TOdbcStatementHandle.GetInt16(ColNo: SqlUSmallint; out Value: SmallInt; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else Value := SmallInt(FRowCells[ColNo - 1].IntVal);
end;

procedure TOdbcStatementHandle.GetUInt16(ColNo: SqlUSmallint; out Value: Word; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else Value := Word(FRowCells[ColNo - 1].IntVal);
end;

procedure TOdbcStatementHandle.GetInt32(ColNo: SqlUSmallint; out Value: TInt32; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else
  begin
    if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType] then
      Value := StrToIntDef(Trim(FRowCells[ColNo - 1].StrVal), 0)
    else if FColumns[ColNo - 1].DBXDataType = TDBXDataTypes.BcdType then
      Value := BcdToInteger(FRowCells[ColNo - 1].BcdVal, True)
    else if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.DoubleType, TDBXDataTypes.SingleType] then
      Value := Trunc(FRowCells[ColNo - 1].DoubleVal)
    else
      Value := TInt32(FRowCells[ColNo - 1].IntVal);
  end;
end;

procedure TOdbcStatementHandle.GetInt64(ColNo: SqlUSmallint; out Value: Int64; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else
  begin
    if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType] then
      Value := StrToInt64Def(Trim(FRowCells[ColNo - 1].StrVal), 0)
    else if FColumns[ColNo - 1].DBXDataType = TDBXDataTypes.BcdType then
      Value := BcdToInteger(FRowCells[ColNo - 1].BcdVal, True)
    else if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.DoubleType, TDBXDataTypes.SingleType] then
      Value := Trunc(FRowCells[ColNo - 1].DoubleVal)
    else
      Value := FRowCells[ColNo - 1].IntVal;
  end;
end;

procedure TOdbcStatementHandle.GetDouble(ColNo: SqlUSmallint; out Value: Double; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0.0
  else
  begin
    if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.DoubleType, TDBXDataTypes.SingleType] then
      Value := FRowCells[ColNo - 1].DoubleVal
    else if FColumns[ColNo - 1].DBXDataType = TDBXDataTypes.BcdType then
      Value := BcdToDouble(FRowCells[ColNo - 1].BcdVal)
    else if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType] then
      Value := StrToFloatDef(Trim(FRowCells[ColNo - 1].StrVal), 0.0, TFormatSettings.Invariant)
    else
      Value := FRowCells[ColNo - 1].IntVal;
  end;
end;

procedure TOdbcStatementHandle.GetSingle(ColNo: SqlUSmallint; out Value: Single; out IsNull: LongBool);
var
  DblVal: Double;
begin
  GetDouble(ColNo, DblVal, IsNull);
  Value := Single(DblVal);
end;

procedure TOdbcStatementHandle.GetBoolean(ColNo: SqlUSmallint; out Value: LongBool; out IsNull: LongBool);
var
  S: string;
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := False
  else
  begin
    if FColumns[ColNo - 1].DBXDataType in [TDBXDataTypes.WideStringType, TDBXDataTypes.AnsiStringType] then
    begin
      S := UpperCase(Trim(FRowCells[ColNo - 1].StrVal));
      if (S = '1') or (S = 'T') or (S = 'TRUE') or (S = 'Y') or (S = 'YES') then
        Value := True
      else if (S = '0') or (S = 'F') or (S = 'FALSE') or (S = 'N') or (S = 'NO') then
        Value := False
      else
        Value := StrToBoolDef(S, False);
    end
    else
      Value := (FRowCells[ColNo - 1].IntVal <> 0);
  end;
end;

procedure TOdbcStatementHandle.GetWideString(ColNo: SqlUSmallint; out Value: string; out IsNull: LongBool);
var
  Idx: Integer;
  TS: TTimeStamp;
  Y, M, D: Word;
begin
  CheckColIndex(ColNo);
  Idx := ColNo - 1;
  IsNull := FRowCells[Idx].IsNull;
  if IsNull then
  begin
    Value := '';
    Exit;
  end;

  if FRowCells[Idx].StrVal = '' then
  begin
    if FRowCells[Idx].AnsiVal <> '' then
      FRowCells[Idx].StrVal := string(FRowCells[Idx].AnsiVal)
    else
    begin
      case FColumns[Idx].DBXDataType of
        TDBXDataTypes.BooleanType:
          if FRowCells[Idx].IntVal <> 0 then
            FRowCells[Idx].StrVal := 'True'
          else
            FRowCells[Idx].StrVal := 'False';

        TDBXDataTypes.Int16Type, TDBXDataTypes.UInt16Type,
        TDBXDataTypes.Int8Type, TDBXDataTypes.UInt8Type,
        TDBXDataTypes.Int32Type, TDBXDataTypes.Int64Type:
          FRowCells[Idx].StrVal := IntToStr(FRowCells[Idx].IntVal);

        TDBXDataTypes.SingleType, TDBXDataTypes.DoubleType:
          FRowCells[Idx].StrVal := FloatToStr(FRowCells[Idx].DoubleVal);

        TDBXDataTypes.DateType:
          if FRowCells[Idx].DateVal <> 0 then
          begin
            TS.Time := 0;
            TS.Date := FRowCells[Idx].DateVal;
            DecodeDate(TimeStampToDateTime(TS), Y, M, D);
            FRowCells[Idx].StrVal := Format('%.4d-%.2d-%.2d', [Y, M, D]);
          end;

        TDBXDataTypes.TimeStampType:
          with FRowCells[Idx].TimeStampVal do
            FRowCells[Idx].StrVal := Format('%.4d-%.2d-%.2d %.2d:%.2d:%.2d.%.3d',
              [Year, Month, Day, Hour, Minute, Second, Fractions]);
      end;
    end;
  end;

  Value := FRowCells[Idx].StrVal;
end;

procedure TOdbcStatementHandle.GetAnsiString(ColNo: SqlUSmallint; out Value: AnsiString; out IsNull: LongBool);
var
  WideVal: string;
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then
    Value := ''
  else if FRowCells[ColNo - 1].AnsiVal <> '' then
    Value := FRowCells[ColNo - 1].AnsiVal
  else
  begin
    GetWideString(ColNo, WideVal, IsNull);
    Value := AnsiString(WideVal);
  end;
end;

procedure TOdbcStatementHandle.GetDate(ColNo: SqlUSmallint; out Value: TDBXDate; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else Value := FRowCells[ColNo - 1].DateVal;
end;

procedure TOdbcStatementHandle.GetTime(ColNo: SqlUSmallint; out Value: TDBXTime; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := 0
  else Value := FRowCells[ColNo - 1].TimeVal;
end;

procedure TOdbcStatementHandle.GetTimeStamp(ColNo: SqlUSmallint; out Value: TSQLTimeStamp; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then FillChar(Value, SizeOf(Value), 0)
  else Value := FRowCells[ColNo - 1].TimeStampVal;
end;

procedure TOdbcStatementHandle.GetBcd(ColNo: SqlUSmallint; out Value: TBcd; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then Value := NullBcd
  else Value := FRowCells[ColNo - 1].BcdVal;
end;

function TOdbcStatementHandle.GetBlobTargetType(ColNo: SqlUSmallint): SqlSmallint;
begin
  Result := SQL_C_BINARY;
  if (ColNo >= 1) and (ColNo <= Length(FColumns)) then
  begin
    if FColumns[ColNo - 1].DBXSubType = TDBXDataTypes.MemoSubType then
      Result := SQL_C_CHAR
    else if FColumns[ColNo - 1].DBXSubType = TDBXDataTypes.WideMemoSubType then
      Result := SQL_C_WCHAR;
  end;
end;

procedure TOdbcStatementHandle.GetBytes(ColNo: SqlUSmallint; Offset: Int64;
  const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
  out ReturnLength: Int64; out IsNull: LongBool);
var
  DataLen: Int64;
begin
  CheckColIndex(ColNo);
  if (Offset < 0) or (BufferOffset < 0) or (Length < 0) or
    (BufferOffset > System.Length(Buffer)) or
    (Length > System.Length(Buffer)-BufferOffset) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Invalid byte buffer range');
  IsNull := FRowCells[ColNo - 1].IsNull;
  ReturnLength := 0;
  DataLen := System.Length(FRowCells[ColNo - 1].BytesVal);
  if not IsNull and (Offset < DataLen) then
  begin
    ReturnLength := DataLen - Offset;
    if ReturnLength > Length then ReturnLength := Length;
    if ReturnLength > 0 then
      Move(FRowCells[ColNo - 1].BytesVal[Offset], Buffer[BufferOffset], ReturnLength);
  end;
end;

procedure TOdbcStatementHandle.GetByteLength(ColNo: SqlUSmallint;
  out ByteLength: Int64; out IsNull: LongBool);
begin
  CheckColIndex(ColNo);
  IsNull := FRowCells[ColNo - 1].IsNull;
  if IsNull then ByteLength := 0
  else ByteLength := System.Length(FRowCells[ColNo - 1].BytesVal);
end;

{ TDBXOpenOdbcParameterRow }

constructor TDBXOpenOdbcParameterRow.Create(DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
  SetLength(FValues, 0);
end;

procedure TDBXOpenOdbcParameterRow.EnsureCapacity(Ordinal: Integer);
var
  OldLen, i: Integer;
begin
  if Ordinal >= Length(FValues) then
  begin
    OldLen := Length(FValues);
    SetLength(FValues, Ordinal + 8);
    for i := OldLen to High(FValues) do
      FValues[i].IsNull := True;
  end;
end;

function TDBXOpenOdbcParameterRow.IsParamNull(Ordinal: Integer): Boolean;
begin
  if (Ordinal < 0) or (Ordinal >= Length(FValues)) then
    Result := True
  else
    Result := FValues[Ordinal].IsNull;
end;

function TDBXOpenOdbcParameterRow.GetParamStorage(Ordinal: Integer): TOdbcParamStorage;
begin
  if (Ordinal >= 0) and (Ordinal < Length(FValues)) then
    Result := FValues[Ordinal]
  else
  begin
    Result := Default(TOdbcParamStorage);
    Result.IsNull := True;
  end;
end;

function TDBXOpenOdbcParameterRow.IsStoredNull(DbxValue: TDBXValue): Boolean;
begin
  Result := IsParamNull(DbxValue.ValueType.Ordinal);
end;

procedure TDBXOpenOdbcParameterRow.SetNull(DbxValue: TDBXValue);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := True;
end;

procedure TDBXOpenOdbcParameterRow.SetString(DbxValue: TDBXAnsiStringValue; const Value: AnsiString);
begin
  SetAnsiString(DbxValue, Value);
end;

procedure TDBXOpenOdbcParameterRow.SetAnsiString(DbxValue: TDBXAnsiStringValue; const Value: AnsiString);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.AnsiStringType;
  FValues[Idx].AsAnsiString := Value;
  FValues[Idx].AsString := string(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetWideString(DbxValue: TDBXWideStringValue; const Value: string);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.WideStringType;
  FValues[Idx].AsString := Value;
  FValues[Idx].AsAnsiString := AnsiString(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.BooleanType;
  if Value then
    FValues[Idx].AsInt64 := 1
  else
    FValues[Idx].AsInt64 := 0;
end;

procedure TDBXOpenOdbcParameterRow.SetUInt8(DbxValue: TDBXUInt8Value; Value: Byte);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.UInt8Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetInt8(DbxValue: TDBXInt8Value; Value: ShortInt);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.Int8Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetUInt16(DbxValue: TDBXUInt16Value; Value: Word);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.UInt16Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.Int16Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetInt32(DbxValue: TDBXInt32Value; Value: TInt32);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.Int32Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetInt64(DbxValue: TDBXInt64Value; Value: Int64);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.Int64Type;
  FValues[Idx].AsInt64 := Value;
  FValues[Idx].AsString := IntToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetSingle(DbxValue: TDBXSingleValue; Value: Single);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.SingleType;
  FValues[Idx].AsDouble := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetDouble(DbxValue: TDBXDoubleValue; Value: Double);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.DoubleType;
  FValues[Idx].AsDouble := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.BcdType;
  FValues[Idx].AsBcd := Value;
  FValues[Idx].AsString := BcdToStr(Value);
end;

procedure TDBXOpenOdbcParameterRow.SetDate(DbxValue: TDBXDateValue; Value: TDBXDate);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.DateType;
  FValues[Idx].AsInt64 := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.TimeType;
  FValues[Idx].AsInt64 := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetTimestamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.TimeStampType;
  FValues[Idx].AsTimeStamp := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetTimestampOffset(DbxValue: TDBXTimeStampOffsetValue; var Value: TSQLTimeStampOffset);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.TimeStampOffsetType;
  FValues[Idx].AsTimeStampOffset := Value;
end;

procedure TDBXOpenOdbcParameterRow.SetDynamicBytes(DbxValue: TDBXValue; Offset: Int64;
  const Buffer: TArray<Byte>; BufferOffset, Length: Int64);
var
  Idx: Integer;
  AnsiStr: AnsiString;
  WideStr: string;
begin
  if (Offset < 0) or (BufferOffset < 0) or (Length < 0) or
    (BufferOffset > System.Length(Buffer)) or (Length > System.Length(Buffer)-BufferOffset) or
    (Offset > MaxInt-Length) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Invalid parameter byte range');
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := DbxValue.ValueType.DataType;
  if Offset = 0 then SetLength(FValues[Idx].AsBytes, Length)
  else if Offset+Length > System.Length(FValues[Idx].AsBytes) then
    SetLength(FValues[Idx].AsBytes, Offset+Length);
  if Length > 0 then
    Move(Buffer[BufferOffset], FValues[Idx].AsBytes[Offset], Length);

  case DbxValue.ValueType.DataType of
    TDBXDataTypes.AnsiStringType:
      begin
        if System.Length(FValues[Idx].AsBytes) > 0 then
        begin
          System.SetString(AnsiStr, PAnsiChar(@FValues[Idx].AsBytes[0]), System.Length(FValues[Idx].AsBytes));
          while (System.Length(AnsiStr) > 0) and (AnsiStr[System.Length(AnsiStr)] = #0) do
            System.Delete(AnsiStr, System.Length(AnsiStr), 1);
          FValues[Idx].AsAnsiString := AnsiStr;
          FValues[Idx].AsString := string(AnsiStr);
        end
        else
        begin
          FValues[Idx].AsAnsiString := '';
          FValues[Idx].AsString := '';
        end;
      end;
    TDBXDataTypes.WideStringType:
      begin
        if System.Length(FValues[Idx].AsBytes) > 0 then
        begin
          System.SetString(WideStr, PWideChar(@FValues[Idx].AsBytes[0]), System.Length(FValues[Idx].AsBytes) div SizeOf(WideChar));
          while (System.Length(WideStr) > 0) and (WideStr[System.Length(WideStr)] = #0) do
            System.Delete(WideStr, System.Length(WideStr), 1);
          FValues[Idx].AsString := WideStr;
          FValues[Idx].AsAnsiString := AnsiString(WideStr);
        end
        else
        begin
          FValues[Idx].AsString := '';
          FValues[Idx].AsAnsiString := '';
        end;
      end;
  end;
end;

procedure TDBXOpenOdbcParameterRow.StoreOutput(Ordinal: Integer;
  const Value: TOdbcParamStorage);
begin
  EnsureCapacity(Ordinal);
  FValues[Ordinal] := Value;
  Inc(FGeneration);
end;

procedure TDBXOpenOdbcParameterRow.SetValueType(ValueType: TDBXValueType);
begin
  if ValueType <> nil then
    EnsureCapacity(ValueType.Ordinal);
end;

procedure TDBXOpenOdbcParameterRow.GetAnsiString(DbxValue: TDBXAnsiStringValue;
  var AnsiStringBuilder: TDBXAnsiStringBuilder; var IsNull: LongBool);
var
  Idx, StrLen: Integer;
  AStr: AnsiString;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    AStr := FValues[Idx].AsAnsiString;
    StrLen := Length(AStr) + 1;
    TDBXPlatform.ResizeStringBuilder(AnsiStringBuilder, StrLen);
    TDBXPlatform.CopyStringToBuilder(AStr, StrLen, AnsiStringBuilder);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetWideString(DbxValue: TDBXWideStringValue;
  var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  Idx, StrLen: Integer;
  Str: string;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Str := FValues[Idx].AsString;
    StrLen := Length(Str) + 1;
    TDBXPlatform.ResizeWideStringBuilder(WideStringBuilder, StrLen * SizeOf(Char));
    TDBXPlatform.CopyWideStringToBuilder(Str, StrLen * SizeOf(Char), WideStringBuilder);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetWideString(DbxValue: TDBXWideStringValue;
  var Value: string; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsString;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetBoolean(DbxValue: TDBXBooleanValue;
  var Value: LongBool; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsInt64 <> 0;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetUInt8(DbxValue: TDBXUInt8Value;
  var Value: Byte; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := Byte(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetInt8(DbxValue: TDBXInt8Value;
  var Value: ShortInt; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := ShortInt(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetUInt16(DbxValue: TDBXUInt16Value;
  var Value: Word; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := Word(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetInt16(DbxValue: TDBXInt16Value;
  var Value: SmallInt; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := SmallInt(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetInt32(DbxValue: TDBXInt32Value;
  var Value: TInt32; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := TInt32(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetInt64(DbxValue: TDBXInt64Value;
  var Value: Int64; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsInt64;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetSingle(DbxValue: TDBXSingleValue;
  var Value: Single; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := Single(FValues[Idx].AsDouble);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetDouble(DbxValue: TDBXDoubleValue;
  var Value: Double; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsDouble;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetBcd(DbxValue: TDBXBcdValue;
  var Value: TBcd; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsBcd;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetDate(DbxValue: TDBXDateValue;
  var Value: TDBXDate; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := TDBXDate(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetTime(DbxValue: TDBXTimeValue;
  var Value: TDBXTime; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := TDBXTime(FValues[Idx].AsInt64);
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsTimeStamp;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetTimeStampOffset(DbxValue: TDBXTimeStampOffsetValue;
  var Value: TSQLTimeStampOffset; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
    IsNull := True
  else
  begin
    Value := FValues[Idx].AsTimeStampOffset;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetBytes(DbxValue: TDBXByteArrayValue;
  Offset: Int64; const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
  var ReturnLength: Int64; var IsNull: LongBool);
var
  Idx, TotalLen: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
  begin
    ReturnLength := 0;
    IsNull := True;
  end
  else
  begin
    TotalLen := System.Length(FValues[Idx].AsBytes);
    if Offset >= TotalLen then
      ReturnLength := 0
    else
    begin
      ReturnLength := TotalLen - Offset;
      if ReturnLength > Length then
        ReturnLength := Length;
      Move(FValues[Idx].AsBytes[Offset], Buffer[BufferOffset], ReturnLength);
    end;
    IsNull := False;
  end;
end;

procedure TDBXOpenOdbcParameterRow.GetByteLength(DbxValue: TDBXByteArrayValue;
  var ByteLength: Int64; var IsNull: LongBool);
var
  Idx: Integer;
begin
  Idx := DbxValue.ValueType.Ordinal;
  if IsParamNull(Idx) then
  begin
    ByteLength := 0;
    IsNull := True;
  end
  else
  begin
    ByteLength := System.Length(FValues[Idx].AsBytes);
    IsNull := False;
  end;
end;

type
  TDBXParameterListAccess = class(TDBXParameterList)
  public
    function ExtractRow: TDBXRow;
  end;

function TDBXParameterListAccess.ExtractRow: TDBXRow;
begin
  Result := GetRow;
end;

procedure TOdbcStatementHandle.BindParameters(Parameters: TDBXParameterList);
var
  I, Capacity: Integer;
  Param: TDBXParameter;
  Row: TDBXOpenOdbcParameterRow;
  V: TOdbcParamStorage;
  ParamType, CType, SqlType, DecDigits: SqlSmallint;
  ColSize: TSqlULen;
  DataPtr: SqlPointer;
  BufLen: TSqlLen;
  Text, ZoneSign: string;
  Stamp: TTimeStamp;
  TS: TSQLTimeStamp;
  Ret: SqlReturn;
  DeclaredType, DeclaredScale, DeclaredNullable: SqlSmallint;
  DeclaredSize: TSqlULen;
begin
  // Unbind pointers before resizing the storage backing those pointers.
  if FOutputPending then CompleteOutputParameters;
  Ret := SQLFreeStmt(FHStmt, SQL_RESET_PARAMS);
  CheckError(Ret, 'SQLFreeStmt(SQL_RESET_PARAMS)');
  FBoundParameterList := Parameters;
  FHasOutputParameters := False;
  if Parameters = nil then
  begin
    SetLength(FBoundParams, 0);
    Exit;
  end;
  if not (TDBXParameterListAccess(Parameters).ExtractRow is TDBXOpenOdbcParameterRow) then
    raise TDBXError.Create(TDBXErrorCodes.InvalidOperation, 'Expected ODBC parameter row');
  Row := TDBXOpenOdbcParameterRow(TDBXParameterListAccess(Parameters).ExtractRow);
  SetLength(FBoundParams, 0);
  SetLength(FBoundParams, Parameters.Count);
  for I := 0 to Parameters.Count-1 do
  begin
    Param := Parameters[I];
    V := Row.GetParamStorage(I);
    case Param.ParameterDirection of
      TDBXParameterDirections.OutParameter, TDBXParameterDirections.ReturnParameter:
        ParamType := SQL_PARAM_OUTPUT;
      TDBXParameterDirections.InOutParameter: ParamType := SQL_PARAM_INPUT_OUTPUT;
    else ParamType := SQL_PARAM_INPUT;
    end;
    if ParamType <> SQL_PARAM_INPUT then FHasOutputParameters := True;
    if ParamType = SQL_PARAM_OUTPUT then
    begin
      V := Default(TOdbcParamStorage);
      V.IsNull := True;
    end;
    DecDigits := 0;
    Capacity := 0;
    Text := '';
    case Param.DataType of
      TDBXDataTypes.UInt8Type, TDBXDataTypes.Int8Type,
      TDBXDataTypes.UInt16Type, TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type,
      TDBXDataTypes.BooleanType:
        begin
          CType := SQL_C_SLONG;
          SqlType := SQL_INTEGER;
          if Param.DataType = TDBXDataTypes.BooleanType then SqlType := SQL_BIT;
          ColSize := 10;
          FBoundParams[I].Int32Val := V.AsInt64;
          DataPtr := @FBoundParams[I].Int32Val;
          BufLen := SizeOf(TInt32);
        end;
      TDBXDataTypes.Int64Type:
        begin
          CType := SQL_C_SBIGINT; SqlType := SQL_BIGINT; ColSize := 19;
          FBoundParams[I].Int64Val := V.AsInt64;
          DataPtr := @FBoundParams[I].Int64Val; BufLen := SizeOf(Int64);
        end;
      TDBXDataTypes.SingleType, TDBXDataTypes.DoubleType:
        begin
          CType := SQL_C_DOUBLE; SqlType := SQL_DOUBLE; ColSize := 15;
          FBoundParams[I].DoubleVal := V.AsDouble;
          DataPtr := @FBoundParams[I].DoubleVal; BufLen := SizeOf(Double);
        end;
      TDBXDataTypes.DateType:
        begin
          CType := SQL_C_TYPE_DATE; SqlType := SQL_TYPE_DATE; ColSize := 10;
          if not V.IsNull then
          begin
            Stamp.Date := V.AsInt64; Stamp.Time := 0;
            TS := DateTimeToSQLTimeStamp(TimeStampToDateTime(Stamp));
            FBoundParams[I].DateVal.Year := TS.Year;
            FBoundParams[I].DateVal.Month := TS.Month;
            FBoundParams[I].DateVal.Day := TS.Day;
          end;
          DataPtr := @FBoundParams[I].DateVal; BufLen := SizeOf(tagDATE_STRUCT);
        end;
      TDBXDataTypes.TimeStampType:
        begin
          CType := SQL_C_TIMESTAMP; SqlType := SQL_TYPE_TIMESTAMP;
          ColSize := 23; DecDigits := 3;
          TS := V.AsTimeStamp;
          FBoundParams[I].TSVal.Year := TS.Year;
          FBoundParams[I].TSVal.Month := TS.Month;
          FBoundParams[I].TSVal.Day := TS.Day;
          FBoundParams[I].TSVal.Hour := TS.Hour;
          FBoundParams[I].TSVal.Minute := TS.Minute;
          FBoundParams[I].TSVal.Second := TS.Second;
          FBoundParams[I].TSVal.Fraction := TS.Fractions * 1000000;
          DataPtr := @FBoundParams[I].TSVal; BufLen := SizeOf(tagTIMESTAMP_STRUCT);
        end;
      TDBXDataTypes.BytesType, TDBXDataTypes.VarBytesType, TDBXDataTypes.BlobType:
        begin
          CType := SQL_C_BINARY; SqlType := SQL_VARBINARY;
          Capacity := Length(V.AsBytes);
          if (ParamType <> SQL_PARAM_INPUT) and (Param.Size > Capacity) then Capacity := Param.Size;
          if Capacity < 1 then Capacity := 1;
          SetLength(FBoundParams[I].BytesVal, Capacity);
          if Length(V.AsBytes) > 0 then Move(V.AsBytes[0], FBoundParams[I].BytesVal[0], Length(V.AsBytes));
          DataPtr := @FBoundParams[I].BytesVal[0]; BufLen := Capacity; ColSize := Capacity;
          if Capacity > 8000 then SqlType := SQL_LONGVARBINARY;
        end;
    else
      CType := SQL_C_WCHAR; SqlType := SQL_WVARCHAR;
      case Param.DataType of
        TDBXDataTypes.TimeType:
          Text := Format('%.2d:%.2d:%.2d.%.3d', [V.AsInt64 div 3600000,
            (V.AsInt64 div 60000) mod 60, (V.AsInt64 div 1000) mod 60, V.AsInt64 mod 1000]);
        TDBXDataTypes.BcdType:
          if not V.IsNull then Text := BcdToStr(V.AsBcd, TFormatSettings.Invariant);
        TDBXDataTypes.TimeStampOffsetType:
          if not V.IsNull then
          begin
            ZoneSign := '+';
            if (V.AsTimeStampOffset.TimeZoneHour < 0) or
              (V.AsTimeStampOffset.TimeZoneMinute < 0) then ZoneSign := '-';
            with V.AsTimeStampOffset do
              Text := Format('%.4d-%.2d-%.2d %.2d:%.2d:%.2d.%.3d %s%.2d:%.2d',
                [Year,Month,Day,Hour,Minute,Second,Fractions,ZoneSign,
                 Abs(TimeZoneHour),Abs(TimeZoneMinute)]);
          end;
      else
      begin
        Text := V.AsString;
        if (Text = '') and (V.AsAnsiString <> '') then
          Text := string(V.AsAnsiString);
      end;
      end;
      Capacity := Length(Text);
      if ParamType <> SQL_PARAM_INPUT then
      begin
        if Param.Size > 0 then
        begin
          if Param.Size > Capacity then Capacity := Param.Size;
        end
        else if Param.Precision > Capacity then Capacity := Param.Precision;
        if Capacity = 0 then Capacity := 4096;
      end;
      if Capacity < 1 then Capacity := 1;
      SetLength(FBoundParams[I].WideStrVal, Capacity+1);
      FillChar(PWideChar(FBoundParams[I].WideStrVal)^, (Capacity+1)*SizeOf(WideChar), 0);
      if Length(Text) > 0 then Move(PChar(Text)^, PWideChar(FBoundParams[I].WideStrVal)^, Length(Text)*SizeOf(WideChar));
      DataPtr := PWideChar(FBoundParams[I].WideStrVal);
      BufLen := (Capacity+1)*SizeOf(WideChar); ColSize := Capacity;
      if Capacity > 4000 then SqlType := SQL_WLONGVARCHAR;
    end;
    // Parameter definition size and client output-buffer size are different.
    // Binding a short buffer as the SQL parameter's size can truncate on the
    // server before ODBC has a chance to report a truncated client buffer.
    if (ParamType <> SQL_PARAM_INPUT) and
      ((CType = SQL_C_WCHAR) or (CType = SQL_C_BINARY)) and
      DescribeParam(I+1, DeclaredType, DeclaredSize, DeclaredScale, DeclaredNullable) then
      case DeclaredType of
        SQL_CHAR, SQL_VARCHAR, SQL_LONGVARCHAR, SQL_WCHAR, SQL_WVARCHAR,
        SQL_WLONGVARCHAR, SQL_BINARY, SQL_VARBINARY, SQL_LONGVARBINARY:
          if DeclaredSize > ColSize then ColSize := DeclaredSize;
      end;
    // If optional parameter metadata is unavailable (e.g. temporary procedures),
    // allow at least one SQL character/byte beyond the client capacity. A value
    // larger than the buffer then remains detectable as client-side truncation,
    // instead of being silently converted to an equally short SQL parameter.
    if ParamType <> SQL_PARAM_INPUT then
    begin
      if CType = SQL_C_WCHAR then
      begin
        if ColSize <= TSqlULen(Capacity) then ColSize := TSqlULen(Capacity)+1;
        if ColSize > 4000 then SqlType := SQL_WLONGVARCHAR;
      end;
      if CType = SQL_C_BINARY then
      begin
        if ColSize <= TSqlULen(BufLen) then ColSize := TSqlULen(BufLen)+1;
        if ColSize > 8000 then SqlType := SQL_LONGVARBINARY;
      end;
    end;
    if V.IsNull or (ParamType = SQL_PARAM_OUTPUT) then FBoundParams[I].Ind := SQL_NULL_DATA
    else if CType = SQL_C_WCHAR then FBoundParams[I].Ind := Length(Text)*SizeOf(WideChar)
    else if CType = SQL_C_BINARY then FBoundParams[I].Ind := Length(V.AsBytes)
    else FBoundParams[I].Ind := BufLen;
Ret := SQLBindParameter(FHStmt, I+1, ParamType, CType, SqlType, ColSize,
      DecDigits, DataPtr, BufLen, @FBoundParams[I].Ind);
    CheckError(Ret, 'SQLBindParameter(param ' + IntToStr(I+1) + ')');
  end;
end;

procedure TOdbcStatementHandle.CompleteOutputParameters;
var
  Ret: SqlReturn;
begin
  if not FOutputPending then Exit;
  // Only output-parameter commands enter this path. Ordinary MRS is unchanged.
  try
    repeat
      Ret := SQLMoreResults(FHStmt);
      if Ret = SQL_NO_DATA then Break;
      CheckError(Ret, 'SQLMoreResults(output parameters)');
    until False;
    CopyOutputParameters;
  except
    FOutputPending := False;
    raise;
  end;
end;

procedure TOdbcStatementHandle.CopyOutputParameters;
var
  I, Count: Integer;
  Param: TDBXParameter;
  Row: TDBXOpenOdbcParameterRow;
  V: TOdbcParamStorage;
  Stamp: TTimeStamp;
begin
  if not FOutputPending then Exit;
  FOutputPending := False;
  Row := TDBXOpenOdbcParameterRow(TDBXParameterListAccess(FBoundParameterList).ExtractRow);
  for I := 0 to FBoundParameterList.Count-1 do
  begin
    Param := FBoundParameterList[I];
    if not (Param.ParameterDirection in [TDBXParameterDirections.OutParameter,
      TDBXParameterDirections.InOutParameter, TDBXParameterDirections.ReturnParameter]) then Continue;
    V := Default(TOdbcParamStorage);
    V.DataType := Param.DataType;
    V.IsNull := FBoundParams[I].Ind = SQL_NULL_DATA;
    if not V.IsNull then
      case Param.DataType of
        TDBXDataTypes.UInt8Type, TDBXDataTypes.Int8Type,
        TDBXDataTypes.UInt16Type, TDBXDataTypes.Int16Type,
        TDBXDataTypes.Int32Type, TDBXDataTypes.BooleanType: V.AsInt64 := FBoundParams[I].Int32Val;
        TDBXDataTypes.Int64Type: V.AsInt64 := FBoundParams[I].Int64Val;
        TDBXDataTypes.SingleType, TDBXDataTypes.DoubleType: V.AsDouble := FBoundParams[I].DoubleVal;
        TDBXDataTypes.DateType:
          begin
            Stamp := DateTimeToTimeStamp(EncodeDate(FBoundParams[I].DateVal.Year,
              FBoundParams[I].DateVal.Month, FBoundParams[I].DateVal.Day));
            V.AsInt64 := Stamp.Date;
          end;
        TDBXDataTypes.TimeStampType:
          begin
            V.AsTimeStamp.Year := FBoundParams[I].TSVal.Year;
            V.AsTimeStamp.Month := FBoundParams[I].TSVal.Month;
            V.AsTimeStamp.Day := FBoundParams[I].TSVal.Day;
            V.AsTimeStamp.Hour := FBoundParams[I].TSVal.Hour;
            V.AsTimeStamp.Minute := FBoundParams[I].TSVal.Minute;
            V.AsTimeStamp.Second := FBoundParams[I].TSVal.Second;
            V.AsTimeStamp.Fractions := FBoundParams[I].TSVal.Fraction div 1000000;
          end;
        TDBXDataTypes.BytesType, TDBXDataTypes.VarBytesType, TDBXDataTypes.BlobType:
          begin
            if (FBoundParams[I].Ind < 0) or (FBoundParams[I].Ind > Length(FBoundParams[I].BytesVal)) then
              raise EOdbcError.Create(TDBXErrorCodes.InvalidOperation, 'Output byte parameter truncated', '22001', 0);
            V.AsBytes := Copy(FBoundParams[I].BytesVal, 0, FBoundParams[I].Ind);
          end;
      else
        Count := FBoundParams[I].Ind div SizeOf(WideChar);
        if (FBoundParams[I].Ind < 0) or (Count >= Length(FBoundParams[I].WideStrVal)) then
          raise EOdbcError.Create(TDBXErrorCodes.InvalidOperation, 'Output string parameter truncated', '22001', 0);
        V.AsString := Copy(string(FBoundParams[I].WideStrVal), 1, Count);
        V.AsAnsiString := AnsiString(V.AsString);
        if Param.DataType = TDBXDataTypes.BcdType then
          V.AsBcd := StrToBcd(V.AsString, TFormatSettings.Invariant);
        if Param.DataType = TDBXDataTypes.TimeStampOffsetType then
          V.AsTimeStampOffset := OdbcTimestampOffsetText(V.AsString);
        if Param.DataType = TDBXDataTypes.TimeType then
          V.AsInt64 := OdbcTimeTextToDbx(V.AsString);
      end;
    Row.StoreOutput(I, V);
  end;
end;

function TOdbcStatementHandle.GetNumParams: SqlSmallint;
var
  Count: SqlSmallint;
  Ret: SqlReturn;
begin
  Count := 0;
  Ret := SQLNumParams(FHStmt, @Count);
  if OdbcSucceeded(Ret) then
    Result := Count
  else
    Result := 0;
end;

function TOdbcStatementHandle.DescribeParam(ParamNo: SqlUSmallint; out SqlType: SqlSmallint;
  out ParamSize: TSqlULen; out DecDigits: SqlSmallint; out Nullable: SqlSmallint): Boolean;
var
  Ret: SqlReturn;
begin
  SqlType := 0;
  ParamSize := 0;
  DecDigits := 0;
  Nullable := 0;
  Ret := SQLDescribeParam(FHStmt, ParamNo, @SqlType, @ParamSize, @DecDigits, @Nullable);
  Result := OdbcSucceeded(Ret);
end;

procedure TOdbcStatementHandle.ExecuteCatalogSchemas;
var
  Ret: SqlReturn;
  EmptyName: WideChar;
  Pattern: string;
begin
  AllocateHandle;
  CloseCursor;
  EmptyName := #0;
  Pattern := '%'; // SQL_ALL_SCHEMAS; other names must be non-nil empty strings.
  Ret := SQLTablesW(FHStmt, @EmptyName, 0, PWideChar(Pattern), Length(Pattern),
    @EmptyName, 0, nil, 0);
  CheckError(Ret, 'SQLTablesW (schemas)');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogCatalogs;
var
  Ret: SqlReturn;
  EmptyName: WideChar;
  Pattern: string;
begin
  AllocateHandle;
  CloseCursor;
  EmptyName := #0;
  Pattern := '%'; // SQL_ALL_CATALOGS; other names must be non-nil empty strings.
  Ret := SQLTablesW(FHStmt, PWideChar(Pattern), Length(Pattern), @EmptyName, 0,
    @EmptyName, 0, nil, 0);
  CheckError(Ret, 'SQLTablesW (catalogs)');
  FCursorOpen := True;
end;

function OdbcMetadataPattern(const Value: string): PWideChar;
begin
  if Value = '' then
    Result := nil
  else
    Result := PWideChar(Value);
end;

procedure TOdbcStatementHandle.ExecuteCatalogProcedures(
  const Catalog, Schema, ProcedurePattern: string);
var
  Ret: SqlReturn;
  CatalogPattern, SchemaPattern, ProcArg: string;
begin
  CatalogPattern := Catalog;
  SchemaPattern := Schema;
  ProcArg := ProcedurePattern;
  if (FConnection <> nil) and (FConnection.Dialect <> nil) then
    FConnection.Dialect.AdjustCatalogFilter(CatalogPattern, SchemaPattern, ProcArg, FConnection.UserName)
  else
  begin
    if (FConnection <> nil) and not FConnection.SupportsCatalogs then CatalogPattern := '';
    if (FConnection <> nil) and not FConnection.SupportsSchemas then SchemaPattern := '';
  end;
  AllocateHandle;
  CloseCursor;
  Ret := SQLProceduresW(FHStmt, OdbcMetadataPattern(CatalogPattern), Length(CatalogPattern),
    OdbcMetadataPattern(SchemaPattern), Length(SchemaPattern),
    OdbcMetadataPattern(ProcArg), Length(ProcArg));
  CheckError(Ret, 'SQLProceduresW');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogProcedureColumns(
  const Catalog, Schema, ProcedurePattern: string);
var
  Ret: SqlReturn;
  CatalogPattern, SchemaPattern, ProcArg: string;
begin
  CatalogPattern := Catalog;
  SchemaPattern := Schema;
  ProcArg := ProcedurePattern;
  if (FConnection <> nil) and (FConnection.Dialect <> nil) then
    FConnection.Dialect.AdjustCatalogFilter(CatalogPattern, SchemaPattern, ProcArg, FConnection.UserName)
  else
  begin
    if (FConnection <> nil) and not FConnection.SupportsCatalogs then CatalogPattern := '';
    if (FConnection <> nil) and not FConnection.SupportsSchemas then SchemaPattern := '';
  end;
  AllocateHandle;
  CloseCursor;
  Ret := SQLProcedureColumnsW(FHStmt, OdbcMetadataPattern(CatalogPattern), Length(CatalogPattern),
    OdbcMetadataPattern(SchemaPattern), Length(SchemaPattern),
    OdbcMetadataPattern(ProcArg), Length(ProcArg), nil, 0);
  CheckError(Ret, 'SQLProcedureColumnsW');
  FCursorOpen := True;
end;

function NormalizeOdbcTableTypes(const TableTypes: string): string;
var
  Clean, Token, Name: string;
  Tokens: TArray<string>;
  Names: TStringList;
begin
  Clean := UpperCase(Trim(TableTypes));
  Clean := StringReplace(Clean, '''', '', [rfReplaceAll]);
  Clean := StringReplace(Clean, '"', '', [rfReplaceAll]);
  Clean := StringReplace(Clean, 'SYSTEM TABLE', 'SYSTEMTABLE', [rfReplaceAll]);
  Clean := StringReplace(Clean, 'SYSTEM VIEW', 'SYSTEMVIEW', [rfReplaceAll]);
  Tokens := Clean.Split([';', ',', ' ', #9], TStringSplitOptions.ExcludeEmpty);
  Names := TStringList.Create;
  try
    for Token in Tokens do
    begin
      Name := Token;
      if Token = 'SYSTEMTABLE' then Name := 'SYSTEM TABLE'
      else if Token = 'SYSTEMVIEW' then Name := 'SYSTEM VIEW'
      else if (Token <> 'TABLE') and (Token <> 'VIEW') and
        (Token <> 'SYNONYM') and (Token <> 'ALIAS') then
        raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, 'Unknown table type: ' + Token);
      if Names.IndexOf(Name) < 0 then Names.Add(Name);
      if (Token = 'SYNONYM') and (Names.IndexOf('ALIAS') < 0) then Names.Add('ALIAS');
    end;
    Result := string.Join(',', Names.ToStringArray);
  finally
    Names.Free;
  end;
end;

procedure TOdbcStatementHandle.ExecuteCatalogTables(const TablePattern, TableType: string);
begin
  ExecuteCatalogTables('', '', TablePattern, TableType);
end;

procedure TOdbcStatementHandle.ExecuteCatalogTables(
  const Catalog, Schema, TablePattern, TableTypes: string);
var
  Ret: SqlReturn;
  Types, CatalogPattern, SchemaPattern, TableArg: string;
begin
  Types := NormalizeOdbcTableTypes(TableTypes);
  CatalogPattern := Catalog;
  SchemaPattern := Schema;
  TableArg := TablePattern;
  if (FConnection <> nil) and (FConnection.Dialect <> nil) then
    FConnection.Dialect.AdjustCatalogFilter(CatalogPattern, SchemaPattern, TableArg, FConnection.UserName)
  else
  begin
    if (FConnection <> nil) and not FConnection.SupportsCatalogs then CatalogPattern := '';
    if (FConnection <> nil) and not FConnection.SupportsSchemas then SchemaPattern := '';
  end;
  AllocateHandle;
  CloseCursor;
  Ret := SQLTablesW(FHStmt, OdbcMetadataPattern(CatalogPattern), Length(CatalogPattern),
    OdbcMetadataPattern(SchemaPattern), Length(SchemaPattern),
    OdbcMetadataPattern(TableArg), Length(TableArg),
    OdbcMetadataPattern(Types), Length(Types));
  CheckError(Ret, 'SQLTablesW');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogColumns(const TableName, ColumnPattern: string);
begin
  ExecuteCatalogColumns('', '', TableName, ColumnPattern);
end;

procedure TOdbcStatementHandle.ExecuteCatalogColumns(
  const Catalog, Schema, TableName, ColumnPattern: string);
var
  Ret: SqlReturn;
  CatalogPattern, SchemaPattern, TableArg: string;
begin
  CatalogPattern := Catalog;
  SchemaPattern := Schema;
  TableArg := TableName;
  if CatalogPattern = '%' then CatalogPattern := '';
  if (FConnection <> nil) and (FConnection.Dialect <> nil) then
    FConnection.Dialect.AdjustCatalogFilter(CatalogPattern, SchemaPattern, TableArg, FConnection.UserName)
  else
  begin
    if (FConnection <> nil) and not FConnection.SupportsCatalogs then CatalogPattern := '';
    if (FConnection <> nil) and not FConnection.SupportsSchemas then SchemaPattern := '';
  end;
  AllocateHandle;
  CloseCursor;

  Ret := SQLColumnsW(FHStmt, OdbcMetadataPattern(CatalogPattern), Length(CatalogPattern),
    OdbcMetadataPattern(SchemaPattern), Length(SchemaPattern),
    OdbcMetadataPattern(TableArg), Length(TableArg),
    OdbcMetadataPattern(ColumnPattern), Length(ColumnPattern));
  CheckError(Ret, 'SQLColumnsW');
  FCursorOpen := True;
end;

function OdbcCatalogObjectArg(const Value: string; Supported: Boolean): string;
begin
  if not Supported or (Value = '%') then
    Result := ''
  else
    Result := Value;
end;

procedure TOdbcStatementHandle.ExecuteCatalogStatistics(
  const Catalog, Schema, TableName: string; UniqueOnly: Boolean);
var
  Ret: SqlReturn;
  CatalogArg, SchemaArg, TableArg: string;
  UniqueFlag: SqlUSmallint;
begin
  CatalogArg := OdbcCatalogObjectArg(Catalog, FConnection.SupportsCatalogs);
  SchemaArg := OdbcCatalogObjectArg(Schema, FConnection.SupportsSchemas);
  if TableName = '%' then TableArg := '' else TableArg := TableName;
  if UniqueOnly then UniqueFlag := SQL_INDEX_UNIQUE else UniqueFlag := SQL_INDEX_ALL;
  AllocateHandle;
  CloseCursor;
  Ret := SQLStatisticsW(FHStmt, OdbcMetadataPattern(CatalogArg), Length(CatalogArg),
    OdbcMetadataPattern(SchemaArg), Length(SchemaArg),
    OdbcMetadataPattern(TableArg), Length(TableArg),
    UniqueFlag, SQL_QUICK);
  CheckError(Ret, 'SQLStatisticsW');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogPrimaryKeys(
  const Catalog, Schema, TableName: string);
var
  Ret: SqlReturn;
  CatalogArg, SchemaArg, TableArg: string;
begin
  CatalogArg := OdbcCatalogObjectArg(Catalog, FConnection.SupportsCatalogs);
  SchemaArg := OdbcCatalogObjectArg(Schema, FConnection.SupportsSchemas);
  if TableName = '%' then TableArg := '' else TableArg := TableName;
  AllocateHandle;
  CloseCursor;
  Ret := SQLPrimaryKeysW(FHStmt, OdbcMetadataPattern(CatalogArg), Length(CatalogArg),
    OdbcMetadataPattern(SchemaArg), Length(SchemaArg),
    OdbcMetadataPattern(TableArg), Length(TableArg));
  CheckError(Ret, 'SQLPrimaryKeysW');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogForeignKeys(
  const PKCatalog, PKSchema, PKTable, FKCatalog, FKSchema, FKTable: string);
var
  Ret: SqlReturn;
  PKCatArg, PKSchemArg, PKTabArg, FKCatArg, FKSchemArg, FKTabArg: string;
begin
  PKCatArg := OdbcCatalogObjectArg(PKCatalog, FConnection.SupportsCatalogs);
  PKSchemArg := OdbcCatalogObjectArg(PKSchema, FConnection.SupportsSchemas);
  if PKTable = '%' then PKTabArg := '' else PKTabArg := PKTable;
  FKCatArg := OdbcCatalogObjectArg(FKCatalog, FConnection.SupportsCatalogs);
  FKSchemArg := OdbcCatalogObjectArg(FKSchema, FConnection.SupportsSchemas);
  if FKTable = '%' then FKTabArg := '' else FKTabArg := FKTable;
  AllocateHandle;
  CloseCursor;
  Ret := SQLForeignKeysW(FHStmt,
    OdbcMetadataPattern(PKCatArg), Length(PKCatArg),
    OdbcMetadataPattern(PKSchemArg), Length(PKSchemArg),
    OdbcMetadataPattern(PKTabArg), Length(PKTabArg),
    OdbcMetadataPattern(FKCatArg), Length(FKCatArg),
    OdbcMetadataPattern(FKSchemArg), Length(FKSchemArg),
    OdbcMetadataPattern(FKTabArg), Length(FKTabArg));
  CheckError(Ret, 'SQLForeignKeysW');
  FCursorOpen := True;
end;

initialization
  InitializeCriticalSection(GOdbcEnvInitLock);

finalization
  DeleteCriticalSection(GOdbcEnvInitLock);

end.
