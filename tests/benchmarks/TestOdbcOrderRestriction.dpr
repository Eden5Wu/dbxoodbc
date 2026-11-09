program TestOdbcOrderRestriction;

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

  SQL_C_SLONG   = 4;
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

procedure TestBindingOrder(const ConnStr: string);
var
  HEnv, HDbc, HStmt: SqlHandle;
  Ret, OutLen: SqlSmallint;
  Col1Val: Integer;
  Col1Ind: TSqlLen;
  Col2Val: Integer;
  Col2Ind: TSqlLen;
  GetDataBuf: array[0..63] of WideChar;
  GetDataInd: TSqlLen;
begin
  SQLAllocHandle(SQL_HANDLE_ENV, nil, HEnv);
  SQLSetEnvAttr(HEnv, SQL_ATTR_ODBC_VERSION, SqlPointer(SQL_OV_ODBC3), 0);
  SQLAllocHandle(SQL_HANDLE_DBC, HEnv, HDbc);
  SQLDriverConnectW(HDbc, 0, PWideChar(ConnStr), Length(ConnStr), nil, 0, OutLen, SQL_DRIVER_NOPROMPT);

  // Test Case 1: Bind Column 1, then SQLGetData on Column 2
  Writeln('--- Case 1: Bind Column 1, then SQLGetData on Column 2 (Bound column precedes unbound) ---');
  SQLAllocHandle(SQL_HANDLE_STMT, HDbc, HStmt);
  try
    SQLExecDirectW(HStmt, 'SELECT 123 AS Col1, ''Hello'' AS Col2', -3);
    Ret := SQLBindCol(HStmt, 1, SQL_C_SLONG, @Col1Val, SizeOf(Col1Val), @Col1Ind);
    Writeln('  SQLBindCol(1): Ret=', Ret);
    Ret := SQLFetch(HStmt);
    Writeln('  SQLFetch: Ret=', Ret, ', Col1Val=', Col1Val);
    Ret := SQLGetData(HStmt, 2, SQL_C_WCHAR, @GetDataBuf[0], SizeOf(GetDataBuf), @GetDataInd);
    Writeln('  SQLGetData(2): Ret=', Ret, ', Text=', string(GetDataBuf));
    if Ret <> SQL_SUCCESS then PrintDiag(SQL_HANDLE_STMT, HStmt, 'Error on GetData(2)');
  finally
    SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
  end;
  Writeln;

  // Test Case 2: Bind Column 2, then SQLGetData on Column 1 (Unbound column precedes bound column!)
  Writeln('--- Case 2: Bind Column 2, then SQLGetData on Column 1 (Unbound column precedes bound column!) ---');
  SQLAllocHandle(SQL_HANDLE_STMT, HDbc, HStmt);
  try
    SQLExecDirectW(HStmt, 'SELECT 123 AS Col1, ''Hello'' AS Col2', -3);
    Ret := SQLBindCol(HStmt, 2, SQL_C_SLONG, @Col2Val, SizeOf(Col2Val), @Col2Ind);
    Writeln('  SQLBindCol(2): Ret=', Ret);
    Ret := SQLFetch(HStmt);
    Writeln('  SQLFetch: Ret=', Ret);
    Ret := SQLGetData(HStmt, 1, SQL_C_SLONG, @Col1Val, SizeOf(Col1Val), @Col1Ind);
    Writeln('  SQLGetData(1) [PRECEDING BOUND COL 2]: Ret=', Ret);
    if Ret <> SQL_SUCCESS then
      PrintDiag(SQL_HANDLE_STMT, HStmt, 'Expected Failure on GetData(1)');
  finally
    SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
  end;
  Writeln;

  // Test Case 3: Calling SQLGetData out of order (Col 2 then Col 1) when neither is bound
  Writeln('--- Case 3: SQLGetData on Col 2, then SQLGetData on Col 1 (Out of order SQLGetData) ---');
  SQLAllocHandle(SQL_HANDLE_STMT, HDbc, HStmt);
  try
    SQLExecDirectW(HStmt, 'SELECT 123 AS Col1, ''Hello'' AS Col2', -3);
    Ret := SQLFetch(HStmt);
    Writeln('  SQLFetch: Ret=', Ret);
    Ret := SQLGetData(HStmt, 2, SQL_C_WCHAR, @GetDataBuf[0], SizeOf(GetDataBuf), @GetDataInd);
    Writeln('  SQLGetData(2): Ret=', Ret, ', Text=', string(GetDataBuf));
    Ret := SQLGetData(HStmt, 1, SQL_C_SLONG, @Col1Val, SizeOf(Col1Val), @Col1Ind);
    Writeln('  SQLGetData(1) [CALLED AFTER COL 2]: Ret=', Ret);
    if Ret <> SQL_SUCCESS then
      PrintDiag(SQL_HANDLE_STMT, HStmt, 'Expected Failure on Out-Of-Order GetData');
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
    Writeln('Usage: TestOdbcOrderRestriction "<ConnectionString>" or set DBXOODBC_TEST_CONNECTION environment variable.');
    Exit;
  end;
  TestBindingOrder(ConnStr);
end.
