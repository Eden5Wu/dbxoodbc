program TestOdbcBoundTruncation;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils;

type
  SqlHandle = Pointer;
  SqlSmallint = SmallInt;
  SqlUSmallint = Word;
  SqlInteger = LongInt;
  SqlReturn = SqlSmallint;
  SqlPointer = Pointer;
  TSqlLen = NativeInt;
  PSqlLen = ^TSqlLen;

const
  odbc32_dll = 'odbc32.dll';

  SQL_HANDLE_ENV  = 1;
  SQL_HANDLE_DBC  = 2;
  SQL_HANDLE_STMT = 3;

  SQL_SUCCESS           = 0;
  SQL_SUCCESS_WITH_INFO = 1;
  SQL_NO_DATA           = 100;
  SQL_ERROR             = -1;

  SQL_ATTR_ODBC_VERSION = 200;
  SQL_OV_ODBC3          = 3;
  SQL_DRIVER_NOPROMPT   = 0;

  SQL_C_WCHAR   = -8;

function SQLAllocHandle(HandleType: SqlSmallint; InputHandle: SqlHandle;
  out OutputHandle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLFreeHandle(HandleType: SqlSmallint; Handle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLSetEnvAttr(EnvironmentHandle: SqlHandle; Attribute: SqlInteger;
  ValuePtr: SqlPointer; StringLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLDriverConnectW(ConnectionHandle: SqlHandle; WindowHandle: HWND;
  InConnectionString: PWideChar; StringLength1: SqlSmallint;
  OutConnectionString: PWideChar; BufferLength: SqlSmallint;
  out StringLength2Ptr: SqlSmallint; DriverCompletion: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLExecDirectW(StatementHandle: SqlHandle; StatementText: PWideChar;
  TextLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLFetch(StatementHandle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLBindCol(StatementHandle: SqlHandle; ColumnNumber: SqlUSmallint;
  TargetType: SqlSmallint; TargetValuePtr: SqlPointer; BufferLength: TSqlLen;
  StrLen_or_IndPtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;
function SQLGetData(StatementHandle: SqlHandle; Col_or_Param_Num: SqlUSmallint;
  TargetType: SqlSmallint; TargetValuePtr: SqlPointer; BufferLength: TSqlLen;
  StrLen_or_IndPtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;
function SQLGetDiagRecW(HandleType: SqlSmallint; Handle: SqlHandle;
  RecNumber: SqlSmallint; SQLState: PWideChar; out NativeErrorPtr: SqlInteger;
  MessageText: PWideChar; BufferLength: SqlSmallint;
  out TextLengthPtr: SqlSmallint): SqlReturn; stdcall; external odbc32_dll;

procedure PrintDiag(HandleType: SqlSmallint; H: SqlHandle; const Prefix: string);
var
  State, Msg: array[0..255] of WideChar;
  NativeErr: SqlInteger;
  MsgLen: SqlSmallint;
begin
  if SQLGetDiagRecW(HandleType, H, 1, State, NativeErr, Msg, SizeOf(Msg) div 2, MsgLen) = SQL_SUCCESS then
    Writeln(Format('    [%s] SQLState: %s, NativeError: %d, Msg: %s', [Prefix, string(State), NativeErr, string(Msg)]))
  else
    Writeln('    [', Prefix, '] (No diagnostic info)');
end;

procedure TestBoundColTruncation(const ConnStr: string);
var
  HEnv, HDbc, HStmt: SqlHandle;
  Ret, OutLen: SqlSmallint;
  BoundBuf: array[0..9] of WideChar; // Only room for 9 chars + null
  BoundInd: TSqlLen;
  GetDataBuf: array[0..63] of WideChar;
  GetDataInd: TSqlLen;
begin
  Writeln('=== Testing SQLBindCol Truncation + SQLGetData on Bound Column ===');
  SQLAllocHandle(SQL_HANDLE_ENV, nil, HEnv);
  SQLSetEnvAttr(HEnv, SQL_ATTR_ODBC_VERSION, SqlPointer(SQL_OV_ODBC3), 0);
  SQLAllocHandle(SQL_HANDLE_DBC, HEnv, HDbc);
  SQLDriverConnectW(HDbc, 0, PWideChar(ConnStr), Length(ConnStr), nil, 0, OutLen, SQL_DRIVER_NOPROMPT);

  SQLAllocHandle(SQL_HANDLE_STMT, HDbc, HStmt);
  try
    SQLExecDirectW(HStmt, 'SELECT REPLICATE(CAST(''ABCDE'' AS nvarchar(max)), 10)', -3);
    // Bind col 1 with only a 10-char buffer (data has 50 chars)
    Ret := SQLBindCol(HStmt, 1, SQL_C_WCHAR, @BoundBuf[0], SizeOf(BoundBuf), @BoundInd);
    Writeln('  SQLBindCol(1) with 10-char buffer: Ret=', Ret);
    Ret := SQLFetch(HStmt);
    Writeln('  SQLFetch: Ret=', Ret, ' (SQL_SUCCESS_WITH_INFO expected for truncation)');
    PrintDiag(SQL_HANDLE_STMT, HStmt, 'Fetch Diag');
    Writeln('  BoundBuf content: "', string(BoundBuf), '", Ind=', BoundInd);

    // Now try to retrieve the remaining 41 characters using SQLGetData on the bound column!
    Ret := SQLGetData(HStmt, 1, SQL_C_WCHAR, @GetDataBuf[0], SizeOf(GetDataBuf), @GetDataInd);
    Writeln('  SQLGetData(1) to get rest of truncated data: Ret=', Ret);
    if Ret <> SQL_SUCCESS then
      PrintDiag(SQL_HANDLE_STMT, HStmt, 'Expected Failure on SQLGetData on bound col');
  finally
    SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
  end;

  SQLFreeHandle(SQL_HANDLE_DBC, HDbc);
  SQLFreeHandle(SQL_HANDLE_ENV, HEnv);
  Flush(Output);
end;

var
  ConnStr: string;
begin
  SetConsoleOutputCP(CP_UTF8);
  ConnStr := GetEnvironmentVariable('DBXOODBC_TEST_CONNECTION');
  if ConnStr = '' then
    ConnStr := ParamStr(1);
  if ConnStr = '' then
  begin
    Writeln('Usage: TestOdbcBoundTruncation "<ConnectionString>" or set DBXOODBC_TEST_CONNECTION environment variable.');
    Exit;
  end;
  TestBoundColTruncation(ConnStr);
end.
