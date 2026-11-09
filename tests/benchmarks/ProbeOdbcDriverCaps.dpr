program ProbeOdbcDriverCaps;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils;

type
  SqlHandle = Pointer;
  SqlHEnv = SqlHandle;
  SqlHDbc = SqlHandle;
  SqlHStmt = SqlHandle;
  SqlSmallint = SmallInt;
  SqlUSmallint = Word;
  SqlInteger = LongInt;
  SqlUInteger = LongWord;
  SqlReturn = SqlSmallint;
  SqlPointer = Pointer;

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

  // SQLGetInfo types
  SQL_DRIVER_NAME             = 6;
  SQL_DRIVER_VER              = 7;
  SQL_DBMS_NAME               = 17;
  SQL_DBMS_VER                = 18;
  SQL_GETDATA_EXTENSIONS      = 81;

  // SQL_GETDATA_EXTENSIONS bitmask
  SQL_GD_ANY_COLUMN = $00000001;
  SQL_GD_ANY_ORDER  = $00000002;
  SQL_GD_BLOCK      = $00000004;
  SQL_GD_BOUND      = $00000008;

function SQLAllocHandle(HandleType: SqlSmallint; InputHandle: SqlHandle;
  out OutputHandle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLFreeHandle(HandleType: SqlSmallint; Handle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLSetEnvAttr(EnvironmentHandle: SqlHEnv; Attribute: SqlInteger;
  ValuePtr: SqlPointer; StringLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLDriverConnectW(ConnectionHandle: SqlHDbc; WindowHandle: HWND;
  InConnectionString: PWideChar; StringLength1: SqlSmallint;
  OutConnectionString: PWideChar; BufferLength: SqlSmallint;
  out StringLength2Ptr: SqlSmallint; DriverCompletion: SqlUSmallint): SqlReturn; stdcall; external odbc32_dll;
function SQLGetInfoW(ConnectionHandle: SqlHDbc; InfoType: SqlUSmallint;
  InfoValuePtr: SqlPointer; BufferLength: SqlSmallint;
  StringLengthPtr: Pointer): SqlReturn; stdcall; external odbc32_dll;

procedure ProbeDriver(const ConnStr: string; const LabelName: string);
var
  HEnv, HDbc: SqlHandle;
  Ret, OutLen: SqlSmallint;
  DriverNameBuf: array[0..255] of WideChar;
  DriverVerBuf: array[0..255] of WideChar;
  DbmsNameBuf: array[0..255] of WideChar;
  DbmsVerBuf: array[0..255] of WideChar;
  ExtMask: SqlUInteger;
begin
  Writeln('================================================================');
  Writeln(' PROBING ODBC CAPABILITIES: ', LabelName);
  Writeln('================================================================');

  Ret := SQLAllocHandle(SQL_HANDLE_ENV, nil, HEnv);
  if Ret <> SQL_SUCCESS then
  begin
    Writeln('Failed SQLAllocHandle(ENV): ', Ret);
    Exit;
  end;
  try
    SQLSetEnvAttr(HEnv, SQL_ATTR_ODBC_VERSION, SqlPointer(SQL_OV_ODBC3), 0);
    Ret := SQLAllocHandle(SQL_HANDLE_DBC, HEnv, HDbc);
    if Ret <> SQL_SUCCESS then
    begin
      Writeln('Failed SQLAllocHandle(DBC): ', Ret);
      Exit;
    end;
    try
      Ret := SQLDriverConnectW(HDbc, 0, PWideChar(ConnStr), Length(ConnStr),
        nil, 0, OutLen, SQL_DRIVER_NOPROMPT);
      if (Ret <> SQL_SUCCESS) and (Ret <> SQL_SUCCESS_WITH_INFO) then
      begin
        Writeln('Failed SQLDriverConnectW: ', Ret);
        Exit;
      end;

      SQLGetInfoW(HDbc, SQL_DRIVER_NAME, @DriverNameBuf[0], SizeOf(DriverNameBuf), nil);
      SQLGetInfoW(HDbc, SQL_DRIVER_VER, @DriverVerBuf[0], SizeOf(DriverVerBuf), nil);
      SQLGetInfoW(HDbc, SQL_DBMS_NAME, @DbmsNameBuf[0], SizeOf(DbmsNameBuf), nil);
      SQLGetInfoW(HDbc, SQL_DBMS_VER, @DbmsVerBuf[0], SizeOf(DbmsVerBuf), nil);

      Writeln('  Driver Name : ', string(DriverNameBuf));
      Writeln('  Driver Ver  : ', string(DriverVerBuf));
      Writeln('  DBMS Name   : ', string(DbmsNameBuf));
      Writeln('  DBMS Ver    : ', string(DbmsVerBuf));

      ExtMask := 0;
      Ret := SQLGetInfoW(HDbc, SQL_GETDATA_EXTENSIONS, @ExtMask, SizeOf(ExtMask), nil);
      Writeln(Format('  SQL_GETDATA_EXTENSIONS Bitmask: 0x%08X (Ret=%d)', [ExtMask, Ret]));
      Writeln('    [0x01] SQL_GD_ANY_COLUMN : ', (ExtMask and SQL_GD_ANY_COLUMN) <> 0,
        ' (Can call SQLGetData on columns BEFORE the last bound column)');
      Writeln('    [0x02] SQL_GD_ANY_ORDER  : ', (ExtMask and SQL_GD_ANY_ORDER) <> 0,
        ' (Can call SQLGetData for unbound columns in ANY order)');
      Writeln('    [0x04] SQL_GD_BLOCK      : ', (ExtMask and SQL_GD_BLOCK) <> 0,
        ' (Can call SQLGetData when SQL_ATTR_ROW_ARRAY_SIZE > 1)');
      Writeln('    [0x08] SQL_GD_BOUND      : ', (ExtMask and SQL_GD_BOUND) <> 0,
        ' (Can call SQLGetData for columns that are ALREADY BOUND)');
    finally
      SQLFreeHandle(SQL_HANDLE_DBC, HDbc);
    end;
  finally
    SQLFreeHandle(SQL_HANDLE_ENV, HEnv);
  end;
  Writeln;
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
    Writeln('Usage: ProbeOdbcDriverCaps "<ConnectionString>" or set DBXOODBC_TEST_CONNECTION environment variable.');
    Writeln('Example: ProbeOdbcDriverCaps "Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=master;Trusted_Connection=yes;"');
    Exit;
  end;
  ProbeDriver(ConnStr, 'Target ODBC Driver');
end.
