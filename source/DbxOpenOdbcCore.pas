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
  OdbcApi;

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

  TOdbcColumnMeta = record
    ColumnNumber: SqlUSmallint; // 1-based ODBC column index
    Name: string;
    SqlType: SqlSmallint;
    ColumnSize: TSqlULen;
    DecimalDigits: SqlSmallint;
    Nullable: SqlSmallint;
    DBXDataType: TDBXType;
    DBXSubType: TDBXType;
    DBXSize: TInt32;
    DBXPrecision: TInt32;
    DBXScale: TInt32;
  end;
  TOdbcColumnMetaArray = TArray<TOdbcColumnMeta>;

  TOdbcEnvHandle = class
  private
    FHEnv: SqlHEnv;
    FInstalledDrivers: TArray<string>;
    FDriversLoaded: Boolean;
    procedure LoadInstalledDrivers;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CheckError(RetCode: SqlReturn; const ContextMsg: string);
    function IsDriverInstalled(const ADriverName: string): Boolean;
    function ResolveSqlServerDriver(const RequestedDriverOrProvider: string): string;
    property HEnv: SqlHEnv read FHEnv;
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
    FQuoteChar: string;
    procedure QueryConnectionMetadata;
    function GetStringInfoW(InfoType: SqlUSmallint): string;
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
    property ReturnedConnectionString: string read FReturnedConnectionString;
    property DbmsName: string read FDbmsName;
    property DbmsVersion: string read FDbmsVersion;
    property DriverName: string read FDriverName;
    property DriverVersion: string read FDriverVersion;
    property QuoteChar: string read FQuoteChar;
  end;

type
  TOdbcBoundParamHolder = record
    Ind: TSqlLen;
    Int64Val: Int64;
    Int32Val: TInt32;
    DoubleVal: Double;
    TSVal: tagTIMESTAMP_STRUCT;
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
    procedure ExecuteCatalogTables(const TablePattern, TableType: string);
    procedure ExecuteCatalogColumns(const TableName, ColumnPattern: string);

    property Connection: TOdbcConnectionHandle read FConnection;
    property HStmt: SqlHStmt read FHStmt;
    property Columns: TOdbcColumnMetaArray read FColumns;
    property RowsAffected: Int64 read FRowsAffected;
  end;

function OdbcSucceeded(RetCode: SqlReturn): Boolean; inline;
function MapOdbcParamTypeToDbx(SqlType: SqlSmallint): TDBXType;

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
function SQLGetDiagRecW(HandleType: SqlSmallint; Handle: SqlHandle;
  RecNumber: SqlSmallint; SqlState: PWideChar; out NativeErrorPtr: SqlInteger;
  MessageText: PWideChar; BufferLength: SqlSmallint;
  out TextLengthPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLDriversW(EnvironmentHandle: SqlHEnv; Direction: SqlUSmallint;
  DriverDescription: PWideChar; BufferLength1: SqlSmallint;
  out DescriptionLengthPtr: SqlSmallint; DriverAttributes: PWideChar;
  BufferLength2: SqlSmallint; out AttributesLengthPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;

function OdbcSucceeded(RetCode: SqlReturn): Boolean;
begin
  Result := (RetCode = SQL_SUCCESS) or (RetCode = SQL_SUCCESS_WITH_INFO);
end;

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

constructor TOdbcEnvHandle.Create;
var
  Ret: SqlReturn;
begin
  inherited Create;
  FHEnv := SQL_NULL_HANDLE;
  Ret := SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, FHEnv);
  if not OdbcSucceeded(Ret) then
    RaiseOdbcDiagError(SQL_HANDLE_ENV, SQL_NULL_HANDLE, Ret, 'SQLAllocHandle(SQL_HANDLE_ENV)');

  Ret := SQLSetEnvAttr(FHEnv, SQL_ATTR_ODBC_VERSION, SqlPointer(NativeInt(SQL_OV_ODBC3)), 0);
  CheckError(Ret, 'SQLSetEnvAttr(SQL_ATTR_ODBC_VERSION)');
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

function TOdbcEnvHandle.ResolveSqlServerDriver(const RequestedDriverOrProvider: string): string;
const
  // Priority fallback list from newest Microsoft ODBC Driver down to built-in Windows SQL Server driver
  cSqlDriversPriority: array[0..8] of string = (
    'ODBC Driver 18 for SQL Server',
    'ODBC Driver 17 for SQL Server',
    'ODBC Driver 13.1 for SQL Server',
    'ODBC Driver 13 for SQL Server',
    'ODBC Driver 11 for SQL Server',
    'SQL Server Native Client 11.0',
    'SQL Server Native Client 10.0',
    'SQL Native Client',
    'SQL Server'
  );
var
  ReqUpper, Preferred: string;
  I: Integer;
begin
  LoadInstalledDrivers;
  ReqUpper := UpperCase(Trim(RequestedDriverOrProvider));
  if (Length(ReqUpper) >= 2) and (ReqUpper[1] = '{') and (ReqUpper[Length(ReqUpper)] = '}') then
    ReqUpper := Trim(Copy(ReqUpper, 2, Length(ReqUpper) - 2));

  // 1. If the caller requested an exact ODBC driver name that is already installed, use it directly
  if IsDriverInstalled(ReqUpper) then
  begin
    for I := 0 to High(FInstalledDrivers) do
      if SameText(FInstalledDrivers[I], ReqUpper) then
        Exit(FInstalledDrivers[I]);
  end;

  // 2. Map OLE DB Provider names to their closest preferred ODBC driver first
  Preferred := '';
  if (Pos('MSOLEDBSQL19', ReqUpper) > 0) or (Pos('DRIVER 18', ReqUpper) > 0) then
    Preferred := 'ODBC Driver 18 for SQL Server'
  else if (Pos('MSOLEDBSQL', ReqUpper) > 0) or (Pos('DRIVER 17', ReqUpper) > 0) then
    Preferred := 'ODBC Driver 17 for SQL Server'
  else if (Pos('SQLNCLI11', ReqUpper) > 0) or (Pos('11.0', ReqUpper) > 0) then
    Preferred := 'SQL Server Native Client 11.0'
  else if (Pos('SQLNCLI10', ReqUpper) > 0) or (Pos('10.0', ReqUpper) > 0) then
    Preferred := 'SQL Server Native Client 10.0'
  else if (Pos('SQLNCLI', ReqUpper) > 0) then
    Preferred := 'SQL Native Client'
  else if (Pos('SQLOLEDB', ReqUpper) > 0) then
    Preferred := 'SQL Server';

  if (Preferred <> '') and IsDriverInstalled(Preferred) then
    Exit(Preferred);

  // 3. Smart Fallback: if the preferred driver is not installed on this machine,
  //    pick the best installed SQL Server ODBC driver in priority order.
  for I := Low(cSqlDriversPriority) to High(cSqlDriversPriority) do
  begin
    if IsDriverInstalled(cSqlDriversPriority[I]) then
      Exit(cSqlDriversPriority[I]);
  end;

  // 4. Ultimate fallback (always present in Windows)
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
  Ret := SQLAllocHandle(SQL_HANDLE_DBC, FEnv.HEnv, FHDbc);
  if not OdbcSucceeded(Ret) then
    FEnv.CheckError(Ret, 'SQLAllocHandle(SQL_HANDLE_DBC)');
end;

destructor TOdbcConnectionHandle.Destroy;
begin
  Disconnect;
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

procedure TOdbcConnectionHandle.QueryConnectionMetadata;
begin
  FDbmsName := GetStringInfoW(SQL_DBMS_NAME);
  FDbmsVersion := GetStringInfoW(SQL_DBMS_VER);
  FDriverName := GetStringInfoW(SQL_DRIVER_NAME);
  FDriverVersion := GetStringInfoW(SQL_DRIVER_VER);
  FQuoteChar := Trim(GetStringInfoW(SQL_IDENTIFIER_QUOTE_CHAR));
  if FQuoteChar = '' then
    FQuoteChar := '"';
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
  end;
end;

procedure TOdbcConnectionHandle.BeginTransaction(IsolationLevel: TDBXIsolation);
var
  OdbcIso: NativeInt;
  Ret: SqlReturn;
begin
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
  // Optional: set isolation if supported by driver (ignore if driver like MS Jet doesn't support changing it)
  SQLSetConnectAttrW(FHDbc, SQL_ATTR_TXN_ISOLATION, SqlPointer(OdbcIso), 0);

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
    SQLSetConnectAttrW(FHDbc, SQL_ATTR_AUTOCOMMIT, SqlPointer(NativeInt(SQL_AUTOCOMMIT_ON)), 0);
    FInTransaction := False;
  end;
end;

procedure TOdbcConnectionHandle.Rollback;
var
  Ret: SqlReturn;
begin
  if FInTransaction then
  begin
    Ret := SQLEndTran(SQL_HANDLE_DBC, FHDbc, SQL_ROLLBACK);
    CheckError(Ret, 'SQLEndTran(SQL_ROLLBACK)');
    SQLSetConnectAttrW(FHDbc, SQL_ATTR_AUTOCOMMIT, SqlPointer(NativeInt(SQL_AUTOCOMMIT_ON)), 0);
    FInTransaction := False;
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
  if (FHStmt <> SQL_NULL_HANDLE) and FCursorOpen then
  begin
    SQLCloseCursor(FHStmt);
    SQLFreeStmt(FHStmt, SQL_CLOSE);
    FCursorOpen := False;
  end;
end;

procedure TOdbcStatementHandle.FreeStatement;
begin
  if FHStmt <> SQL_NULL_HANDLE then
  begin
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
  Ret := SQLExecute(FHStmt);
  if Ret <> SQL_NO_DATA then
    CheckError(Ret, 'SQLExecute');

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

function TOdbcStatementHandle.ExecuteDirect(const SQL: string): SqlSmallint;
var
  Ret: SqlReturn;
  RowCnt: TSqlLen;
begin
  AllocateHandle;
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
    // SQL Server int -> ftInteger (TIntegerField)
    SQL_INTEGER:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.Int32Type;
        ColMeta.DBXSize := SizeOf(TInt32);
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
    // SQL Server decimal, numeric, money, smallmoney
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
          ColMeta.DBXSize := SizeOf(TBcd);
          if (ColMeta.DBXPrecision <= 0) or (ColMeta.DBXPrecision > 64) then
            ColMeta.DBXPrecision := 32;
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
    // SQL Server binary, timestamp -> ftBytes (TBytesField)
    SQL_BINARY:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.BytesType;
        if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
          ColMeta.DBXSize := 8;
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
        if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
          ColMeta.DBXSize := 255;
      end;
    // SQL Server varchar, sql_variant -> ftString (TStringField) or ftMemo if max
    SQL_VARCHAR, SQL_SS_VARIANT:
      begin
        if (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 8000) then
        begin
          // varchar(max) -> ftMemo (TMemoField)
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          ColMeta.DBXSubType := TDBXDataTypes.MemoSubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          // varchar -> ftString (TStringField)
          ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
          if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
            ColMeta.DBXSize := 255;
        end;
      end;
    // SQL Server text, ntext, xml, varchar(max), nvarchar(max) -> ftMemo (TMemoField)
    SQL_LONGVARCHAR, SQL_WLONGVARCHAR, SQL_SS_XML:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.BlobType;
        ColMeta.DBXSubType := TDBXDataTypes.MemoSubType;
        ColMeta.DBXSize := 1;
        ColMeta.DBXPrecision := 1;
      end;
    // SQL Server nchar -> ftFixedChar (TStringField)
    SQL_WCHAR:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
        ColMeta.DBXSubType := TDBXDataTypes.FixedSubType;
        if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
          ColMeta.DBXSize := 255;
      end;
    // SQL Server nvarchar -> ftString (TStringField) or ftMemo if max
    SQL_WVARCHAR:
      begin
        if (ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 8000) then
        begin
          // nvarchar(max) -> ftMemo (TMemoField)
          ColMeta.DBXDataType := TDBXDataTypes.BlobType;
          ColMeta.DBXSubType := TDBXDataTypes.MemoSubType;
          ColMeta.DBXSize := 1;
          ColMeta.DBXPrecision := 1;
        end
        else
        begin
          // nvarchar -> ftString (TStringField)
          ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
          if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
            ColMeta.DBXSize := 255;
        end;
      end;
    // SQL Server guid (uniqueidentifier) -> ftFixedChar (Size=38)
    SQL_GUID:
      begin
        ColMeta.DBXDataType := TDBXDataTypes.AnsiStringType;
        ColMeta.DBXSubType := TDBXDataTypes.FixedSubType;
        ColMeta.DBXSize := 38;
        ColMeta.DBXPrecision := 38;
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
      if (ColMeta.DBXSize <= 0) or (ColMeta.DBXSize > 8000) then
        ColMeta.DBXSize := 255;
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
    MapOdbcTypeToDbx(FColumns[i - 1]);
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
    FCursorOpen := False;
    Result := False;
    Exit;
  end;
  CheckError(Ret, 'SQLFetch');
  Result := True;
end;

function TOdbcStatementHandle.MoreResults(out ColumnCount: SqlSmallint): Boolean;
var
  Ret: SqlReturn;
begin
  ColumnCount := 0;
  FCursorOpen := False;
  Ret := SQLMoreResults(FHStmt);
  if Ret = SQL_NO_DATA then
    Exit(False);
  CheckError(Ret, 'SQLMoreResults');
  Ret := SQLNumResultCols(FHStmt, ColumnCount);
  CheckError(Ret, 'SQLNumResultCols');
  FCursorOpen := (ColumnCount > 0);
  Result := True;
end;

procedure TOdbcStatementHandle.GetInt16(ColNo: SqlUSmallint; out Value: SmallInt; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_SSHORT, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(Int16)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetUInt16(ColNo: SqlUSmallint; out Value: Word; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_USHORT, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(UInt16)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetInt32(ColNo: SqlUSmallint; out Value: TInt32; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_SLONG, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(Int32)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetInt64(ColNo: SqlUSmallint; out Value: Int64; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_SBIGINT, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(Int64)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetDouble(ColNo: SqlUSmallint; out Value: Double; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0.0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_DOUBLE, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(Double)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetSingle(ColNo: SqlUSmallint; out Value: Single; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := 0.0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_FLOAT, @Value, SizeOf(Value), @Ind);
  CheckError(Ret, 'SQLGetData(Single)');
  IsNull := (Ind = SQL_NULL_DATA);
end;

procedure TOdbcStatementHandle.GetBoolean(ColNo: SqlUSmallint; out Value: LongBool; out IsNull: LongBool);
var
  BitVal: Byte;
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  BitVal := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_BIT, @BitVal, SizeOf(BitVal), @Ind);
  CheckError(Ret, 'SQLGetData(Boolean)');
  IsNull := (Ind = SQL_NULL_DATA);
  Value := (not IsNull) and (BitVal <> 0);
end;

procedure TOdbcStatementHandle.GetWideString(ColNo: SqlUSmallint; out Value: string; out IsNull: LongBool);
var
  Buf: array of WideChar;
  Ind: TSqlLen;
  Ret: SqlReturn;
  CharCount: Integer;
begin
  Value := '';
  SetLength(Buf, 4096);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_WCHAR, @Buf[0], Length(Buf) * SizeOf(WideChar), @Ind);
  if Ret = SQL_NO_DATA then
  begin
    IsNull := True;
    Exit;
  end;
  CheckError(Ret, 'SQLGetData(WideString)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    if (Ind > 0) and (Ind < TSqlLen((Length(Buf) - 1) * SizeOf(WideChar))) then
    begin
      CharCount := Ind div SizeOf(WideChar);
      SetString(Value, PWideChar(@Buf[0]), CharCount);
    end
    else
      Value := string(PWideChar(@Buf[0]));
  end;
end;

procedure TOdbcStatementHandle.GetAnsiString(ColNo: SqlUSmallint; out Value: AnsiString; out IsNull: LongBool);
var
  Buf: array of AnsiChar;
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  Value := '';
  SetLength(Buf, 4096);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_CHAR, @Buf[0], Length(Buf), @Ind);
  if Ret = SQL_NO_DATA then
  begin
    IsNull := True;
    Exit;
  end;
  CheckError(Ret, 'SQLGetData(AnsiString)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    if (Ind > 0) and (Ind < Length(Buf)) then
      SetString(Value, PAnsiChar(@Buf[0]), Ind)
    else
      Value := AnsiString(PAnsiChar(@Buf[0]));
  end;
end;

procedure TOdbcStatementHandle.GetDate(ColNo: SqlUSmallint; out Value: TDBXDate; out IsNull: LongBool);
var
  OdbcDate: tagDATE_STRUCT;
  Ind: TSqlLen;
  Ret: SqlReturn;
  DT: TDateTime;
  TS: TTimeStamp;
begin
  Value := 0;
  FillChar(OdbcDate, SizeOf(OdbcDate), 0);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_TYPE_DATE, @OdbcDate, SizeOf(OdbcDate), @Ind);
  CheckError(Ret, 'SQLGetData(Date)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    DT := EncodeDate(OdbcDate.Year, OdbcDate.Month, OdbcDate.Day);
    TS := DateTimeToTimeStamp(DT);
    Value := TS.Date;
  end;
end;

procedure TOdbcStatementHandle.GetTime(ColNo: SqlUSmallint; out Value: TDBXTime; out IsNull: LongBool);
var
  OdbcTime: tagTIME_STRUCT;
  Ind: TSqlLen;
  Ret: SqlReturn;
  DT: TDateTime;
  TS: TTimeStamp;
begin
  Value := 0;
  FillChar(OdbcTime, SizeOf(OdbcTime), 0);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_TYPE_TIME, @OdbcTime, SizeOf(OdbcTime), @Ind);
  CheckError(Ret, 'SQLGetData(Time)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    DT := EncodeTime(OdbcTime.Hour, OdbcTime.Minute, OdbcTime.Second, 0);
    TS := DateTimeToTimeStamp(DT);
    Value := TS.Time;
  end;
end;

procedure TOdbcStatementHandle.GetTimeStamp(ColNo: SqlUSmallint; out Value: TSQLTimeStamp; out IsNull: LongBool);
var
  OdbcTS: tagTIMESTAMP_STRUCT;
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  FillChar(Value, SizeOf(Value), 0);
  FillChar(OdbcTS, SizeOf(OdbcTS), 0);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_TYPE_TIMESTAMP, @OdbcTS, SizeOf(OdbcTS), @Ind);
  CheckError(Ret, 'SQLGetData(TimeStamp)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    Value.Year := OdbcTS.Year;
    Value.Month := OdbcTS.Month;
    Value.Day := OdbcTS.Day;
    Value.Hour := OdbcTS.Hour;
    Value.Minute := OdbcTS.Minute;
    Value.Second := OdbcTS.Second;
    Value.Fractions := OdbcTS.Fraction div 1000000;
  end;
end;

procedure TOdbcStatementHandle.GetBcd(ColNo: SqlUSmallint; out Value: TBcd; out IsNull: LongBool);
var
  StrVal: string;
  Fmt: TFormatSettings;
begin
  GetWideString(ColNo, StrVal, IsNull);
  if IsNull or (Trim(StrVal) = '') then
    Value := NullBcd
  else
  begin
    Fmt := TFormatSettings.Invariant;
    StrVal := StringReplace(Trim(StrVal), ',', '.', [rfReplaceAll]);
    if not TryStrToBcd(StrVal, Value, Fmt) then
      Value := DoubleToBcd(StrToFloatDef(StrVal, 0, Fmt));
  end;
end;

procedure TOdbcStatementHandle.GetBytes(ColNo: SqlUSmallint; Offset: Int64;
  const Buffer: TArray<Byte>; BufferOffset, Length: Int64;
  out ReturnLength: Int64; out IsNull: LongBool);
var
  Ind: TSqlLen;
  Ret: SqlReturn;
  TmpBuf: TArray<Byte>;
  TotalAvail: Int64;
begin
  ReturnLength := 0;
  if Length <= 0 then
  begin
    IsNull := False;
    Exit;
  end;
  SetLength(TmpBuf, Offset + Length);
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_BINARY, @TmpBuf[0], System.Length(TmpBuf), @Ind);
  if Ret = SQL_NO_DATA then
  begin
    IsNull := True;
    Exit;
  end;
  CheckError(Ret, 'SQLGetData(Bytes)');
  IsNull := (Ind = SQL_NULL_DATA);
  if not IsNull then
  begin
    if (Ind = SQL_NO_TOTAL) or (Ind > System.Length(TmpBuf)) then
      TotalAvail := System.Length(TmpBuf)
    else
      TotalAvail := Ind;
    if TotalAvail > Offset then
    begin
      ReturnLength := TotalAvail - Offset;
      if ReturnLength > Length then
        ReturnLength := Length;
      Move(TmpBuf[Offset], Buffer[BufferOffset], ReturnLength);
    end;
  end;
end;

procedure TOdbcStatementHandle.GetByteLength(ColNo: SqlUSmallint; out ByteLength: Int64; out IsNull: LongBool);
var
  Dummy: Byte;
  Ind: TSqlLen;
  Ret: SqlReturn;
begin
  ByteLength := 0;
  Dummy := 0;
  Ind := 0;
  Ret := SQLGetData(FHStmt, ColNo, SQL_C_BINARY, @Dummy, 0, @Ind);
  if Ret = SQL_NO_DATA then
  begin
    IsNull := True;
    Exit;
  end;
  CheckError(Ret, 'SQLGetData(ByteLength)');
  IsNull := (Ind = SQL_NULL_DATA);
  if (not IsNull) and (Ind > 0) then
    ByteLength := Ind;
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
    FillChar(Result, SizeOf(Result), 0);
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
begin
  Idx := DbxValue.ValueType.Ordinal;
  EnsureCapacity(Idx);
  FValues[Idx].IsNull := False;
  FValues[Idx].DataType := TDBXDataTypes.BytesType;
  SetLength(FValues[Idx].AsBytes, Length);
  if Length > 0 then
    Move(Buffer[BufferOffset], FValues[Idx].AsBytes[0], Length);
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
  i, ParamCount: Integer;
  Param: TDBXParameter;
  ParamRow: TDBXOpenOdbcParameterRow;
  IsParamNullValue: Boolean;
  ParamType, CType, SqlType: SqlSmallint;
  ColSize: TSqlULen;
  DecDigits: SqlSmallint;
  DataPtr: SqlPointer;
  BufLen: TSqlLen;
  Ret: SqlReturn;
  TS: TSQLTimeStamp;
  TSOffset: TSQLTimeStampOffset;
begin
  if (Parameters = nil) or (Parameters.Count = 0) then
  begin
    SetLength(FBoundParams, 0);
    Exit;
  end;

  if (Parameters <> nil) and (TDBXParameterListAccess(Parameters).ExtractRow is TDBXOpenOdbcParameterRow) then
    ParamRow := TDBXOpenOdbcParameterRow(TDBXParameterListAccess(Parameters).ExtractRow)
  else
    ParamRow := nil;

  ParamCount := Parameters.Count;
  SetLength(FBoundParams, ParamCount);

  for i := 0 to ParamCount - 1 do
  begin
    Param := Parameters[i];
    case Param.ParameterDirection of
      TDBXParameterDirections.OutParameter:
        ParamType := 4; // SQL_PARAM_OUTPUT
      TDBXParameterDirections.InOutParameter:
        ParamType := 2; // SQL_PARAM_INPUT_OUTPUT
    else
      ParamType := 1;   // SQL_PARAM_INPUT
    end;

    if ParamRow <> nil then
      IsParamNullValue := ParamRow.IsParamNull(i)
    else
    begin
      try
        IsParamNullValue := Param.Value.IsNull;
      except
        IsParamNullValue := False;
      end;
    end;

    if IsParamNullValue then
    begin
      FBoundParams[i].Ind := SQL_NULL_DATA;
      DataPtr := nil;
      BufLen := 0;
      ColSize := 1;
      DecDigits := 0;
      case Param.DataType of
        TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type:
          begin
            CType := SQL_C_SLONG;
            SqlType := SQL_INTEGER;
          end;
        TDBXDataTypes.Int64Type:
          begin
            CType := SQL_C_SBIGINT;
            SqlType := SQL_BIGINT;
          end;
        TDBXDataTypes.DoubleType, TDBXDataTypes.SingleType:
          begin
            CType := SQL_C_DOUBLE;
            SqlType := SQL_DOUBLE;
          end;
        TDBXDataTypes.DateType, TDBXDataTypes.TimeType, TDBXDataTypes.TimeStampType:
          begin
            CType := SQL_C_TIMESTAMP;
            SqlType := SQL_TYPE_TIMESTAMP;
          end;
      else
        CType := SQL_C_WCHAR;
        SqlType := SQL_WVARCHAR;
        ColSize := 255;
      end;
    end
    else
    begin
      case Param.DataType of
        TDBXDataTypes.Int8Type, TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type:
          begin
            CType := SQL_C_SLONG;
            SqlType := SQL_INTEGER;
            ColSize := 10;
            DecDigits := 0;
            FBoundParams[i].Int32Val := Param.Value.GetInt32;
            FBoundParams[i].Ind := SizeOf(TInt32);
            DataPtr := @FBoundParams[i].Int32Val;
            BufLen := SizeOf(TInt32);
          end;

        TDBXDataTypes.Int64Type:
          begin
            CType := SQL_C_SBIGINT;
            SqlType := SQL_BIGINT;
            ColSize := 19;
            DecDigits := 0;
            FBoundParams[i].Int64Val := Param.Value.GetInt64;
            FBoundParams[i].Ind := SizeOf(Int64);
            DataPtr := @FBoundParams[i].Int64Val;
            BufLen := SizeOf(Int64);
          end;

        TDBXDataTypes.SingleType, TDBXDataTypes.DoubleType:
          begin
            CType := SQL_C_DOUBLE;
            SqlType := SQL_DOUBLE;
            ColSize := 15;
            DecDigits := 0;
            FBoundParams[i].DoubleVal := Param.Value.GetDouble;
            FBoundParams[i].Ind := SizeOf(Double);
            DataPtr := @FBoundParams[i].DoubleVal;
            BufLen := SizeOf(Double);
          end;

        TDBXDataTypes.BooleanType:
          begin
            CType := SQL_C_SLONG;
            SqlType := SQL_BIT;
            ColSize := 1;
            DecDigits := 0;
            if Param.Value.GetBoolean then
              FBoundParams[i].Int32Val := 1
            else
              FBoundParams[i].Int32Val := 0;
            FBoundParams[i].Ind := SizeOf(TInt32);
            DataPtr := @FBoundParams[i].Int32Val;
            BufLen := SizeOf(TInt32);
          end;

        TDBXDataTypes.DateType, TDBXDataTypes.TimeStampType:
          begin
            CType := SQL_C_TIMESTAMP;
            SqlType := SQL_TYPE_TIMESTAMP;
            ColSize := 23;
            DecDigits := 3;
            TS := Param.Value.GetTimeStamp;
            FBoundParams[i].TSVal.year := TS.Year;
            FBoundParams[i].TSVal.month := TS.Month;
            FBoundParams[i].TSVal.day := TS.Day;
            FBoundParams[i].TSVal.hour := TS.Hour;
            FBoundParams[i].TSVal.minute := TS.Minute;
            FBoundParams[i].TSVal.second := TS.Second;
            FBoundParams[i].TSVal.fraction := TS.Fractions;
            FBoundParams[i].Ind := SizeOf(tagTIMESTAMP_STRUCT);
            DataPtr := @FBoundParams[i].TSVal;
            BufLen := SizeOf(tagTIMESTAMP_STRUCT);
          end;

        TDBXDataTypes.TimeStampOffsetType:
          begin
            CType := SQL_C_TIMESTAMP;
            SqlType := SQL_TYPE_TIMESTAMP;
            ColSize := 27;
            DecDigits := 7;
            TSOffset := Param.Value.GetTimeStampOffset;
            FBoundParams[i].TSVal.year := TSOffset.Year;
            FBoundParams[i].TSVal.month := TSOffset.Month;
            FBoundParams[i].TSVal.day := TSOffset.Day;
            FBoundParams[i].TSVal.hour := TSOffset.Hour;
            FBoundParams[i].TSVal.minute := TSOffset.Minute;
            FBoundParams[i].TSVal.second := TSOffset.Second;
            FBoundParams[i].TSVal.fraction := TSOffset.Fractions;
            FBoundParams[i].Ind := SizeOf(tagTIMESTAMP_STRUCT);
            DataPtr := @FBoundParams[i].TSVal;
            BufLen := SizeOf(tagTIMESTAMP_STRUCT);
          end;

        TDBXDataTypes.BytesType, TDBXDataTypes.VarBytesType, TDBXDataTypes.BlobType:
          begin
            CType := SQL_C_BINARY;
            SqlType := SQL_VARBINARY;
            ColSize := Param.Value.GetValueSize;
            if ColSize <= 0 then ColSize := 1;
            SetLength(FBoundParams[i].BytesVal, ColSize);
            DecDigits := 0;
            BufLen := Param.Value.GetBytes(0, FBoundParams[i].BytesVal, 0, ColSize);
            FBoundParams[i].Ind := BufLen;
            if BufLen > 0 then
              DataPtr := @FBoundParams[i].BytesVal[0]
            else
              DataPtr := nil;
          end;

      else
        // Default to Unicode WideString (covers AnsiString, WideString, Bcd, etc.)
        CType := SQL_C_WCHAR;
        SqlType := SQL_WVARCHAR;
        FBoundParams[i].WideStrVal := Param.Value.AsString;
        ColSize := Length(FBoundParams[i].WideStrVal);
        if ColSize = 0 then ColSize := 1;
        DecDigits := 0;
        BufLen := Length(FBoundParams[i].WideStrVal) * SizeOf(WideChar);
        FBoundParams[i].Ind := BufLen;
        if Length(FBoundParams[i].WideStrVal) > 0 then
          DataPtr := PWideChar(FBoundParams[i].WideStrVal)
        else
          DataPtr := nil;
      end;
    end;

    Ret := SQLBindParameter(
      FHStmt,
      i + 1,        // 1-based parameter index
      ParamType,
      CType,
      SqlType,
      ColSize,
      DecDigits,
      DataPtr,
      BufLen,
      @FBoundParams[i].Ind
    );
    CheckError(Ret, 'SQLBindParameter(param ' + IntToStr(i + 1) + ')');
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

procedure TOdbcStatementHandle.ExecuteCatalogTables(const TablePattern, TableType: string);
var
  Ret: SqlReturn;
  PTable, PType: PWideChar;
  TableLen, TypeLen: SqlSmallint;
  CleanPattern, CleanType: string;
begin
  AllocateHandle;
  CloseCursor;

  CleanPattern := Trim(TablePattern);
  if Pos('.', CleanPattern) > 0 then
    CleanPattern := Copy(CleanPattern, LastDelimiter('.', CleanPattern) + 1, Length(CleanPattern));
  CleanPattern := StringReplace(CleanPattern, '"', '', [rfReplaceAll]);
  CleanPattern := StringReplace(CleanPattern, '''', '', [rfReplaceAll]);
  CleanPattern := StringReplace(CleanPattern, '`', '', [rfReplaceAll]);

  if (CleanPattern = '') or (CleanPattern = '%') then
  begin
    PTable := nil;
    TableLen := 0;
  end
  else
  begin
    PTable := PWideChar(CleanPattern);
    TableLen := Length(CleanPattern);
  end;

  CleanType := UpperCase(Trim(TableType));
  if (CleanType = '') or ((Pos('TABLE', CleanType) > 0) and (Pos('VIEW', CleanType) > 0)) then
  begin
    PType := nil;
    TypeLen := 0;
  end
  else if Pos('VIEW', CleanType) > 0 then
  begin
    CleanType := 'VIEW';
    PType := PWideChar(CleanType);
    TypeLen := Length(CleanType);
  end
  else if Pos('SYSTEM', CleanType) > 0 then
  begin
    CleanType := 'SYSTEM TABLE';
    PType := PWideChar(CleanType);
    TypeLen := Length(CleanType);
  end
  else
  begin
    CleanType := 'TABLE';
    PType := PWideChar(CleanType);
    TypeLen := Length(CleanType);
  end;

  Ret := SQLTablesW(FHStmt, nil, 0, nil, 0, PTable, TableLen, PType, TypeLen);
  CheckError(Ret, 'SQLTablesW');
  FCursorOpen := True;
end;

procedure TOdbcStatementHandle.ExecuteCatalogColumns(const TableName, ColumnPattern: string);
var
  Ret: SqlReturn;
  PTable, PCol: PWideChar;
  TableLen, ColLen: SqlSmallint;
  CleanTable, CleanCol: string;
begin
  AllocateHandle;
  CloseCursor;

  CleanTable := Trim(TableName);
  if Pos('.', CleanTable) > 0 then
    CleanTable := Copy(CleanTable, LastDelimiter('.', CleanTable) + 1, Length(CleanTable));
  CleanTable := StringReplace(CleanTable, '"', '', [rfReplaceAll]);
  CleanTable := StringReplace(CleanTable, '''', '', [rfReplaceAll]);
  CleanTable := StringReplace(CleanTable, '`', '', [rfReplaceAll]);

  if (CleanTable = '') or (CleanTable = '%') then
  begin
    PTable := nil;
    TableLen := 0;
  end
  else
  begin
    PTable := PWideChar(CleanTable);
    TableLen := Length(CleanTable);
  end;

  CleanCol := Trim(ColumnPattern);
  CleanCol := StringReplace(CleanCol, '"', '', [rfReplaceAll]);
  CleanCol := StringReplace(CleanCol, '''', '', [rfReplaceAll]);
  CleanCol := StringReplace(CleanCol, '`', '', [rfReplaceAll]);

  if (CleanCol = '') or (CleanCol = '%') then
  begin
    PCol := nil;
    ColLen := 0;
  end
  else
  begin
    PCol := PWideChar(CleanCol);
    ColLen := Length(CleanCol);
  end;

  Ret := SQLColumnsW(FHStmt, nil, 0, nil, 0, PTable, TableLen, PCol, ColLen);
  CheckError(Ret, 'SQLColumnsW');
  FCursorOpen := True;
end;

end.
