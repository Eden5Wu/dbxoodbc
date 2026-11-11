unit OdbcApi;

interface

uses
  Winapi.Windows;

type
  SqlHandle = Pointer;
  SqlHEnv = SqlHandle;
  SqlHDbc = SqlHandle;
  SqlHStmt = SqlHandle;
  SqlHWnd = HWND;

  SqlSmallint = SmallInt;
  PSqlSmallint = ^SqlSmallint;
  SqlUSmallint = Word;
  PSqlUSmallint = ^SqlUSmallint;
  SqlInteger = LongInt;
  PSqlInteger = ^SqlInteger;
  SqlUInteger = LongWord;
  SqlReturn = SqlSmallint;
  SqlPointer = Pointer;

  TSqlLen = NativeInt;
  PSqlLen = ^TSqlLen;
  TSqlULen = NativeUInt;
  PSqlULen = ^TSqlULen;

  tagDATE_STRUCT = record
    Year: SqlSmallint;
    Month: SqlUSmallint;
    Day: SqlUSmallint;
  end;
  TSqlDateStruct = tagDATE_STRUCT;

  tagTIME_STRUCT = record
    Hour: SqlUSmallint;
    Minute: SqlUSmallint;
    Second: SqlUSmallint;
  end;
  TSqlTimeStruct = tagTIME_STRUCT;

  tagTIMESTAMP_STRUCT = record
    Year: SqlSmallint;
    Month: SqlUSmallint;
    Day: SqlUSmallint;
    Hour: SqlUSmallint;
    Minute: SqlUSmallint;
    Second: SqlUSmallint;
    Fraction: SqlUInteger;
  end;
  TSqlTimestampStruct = tagTIMESTAMP_STRUCT;

const
  SQL_NULL_HANDLE = nil;

  // Handle types
  SQL_HANDLE_ENV  = 1;
  SQL_HANDLE_DBC  = 2;
  SQL_HANDLE_STMT = 3;
  SQL_HANDLE_DESC = 4;

  // Return codes
  SQL_SUCCESS           = 0;
  SQL_SUCCESS_WITH_INFO = 1;
  SQL_NO_DATA           = 100;
  SQL_ERROR             = -1;
  SQL_INVALID_HANDLE    = -2;
  SQL_STILL_EXECUTING   = 2;
  SQL_NEED_DATA         = 99;

  // Special lengths / indicators
  SQL_NULL_DATA         = -1;
  SQL_DATA_AT_EXEC      = -2;
  SQL_NTS               = -3;
  SQL_NO_TOTAL          = -4;

  // Environment attributes
  SQL_ATTR_ODBC_VERSION       = 200;
  SQL_OV_ODBC3                = 3;
  SQL_ATTR_CONNECTION_POOLING = 201;
  SQL_ATTR_CP_MATCH           = 202;

  // Connection pooling values
  SQL_CP_OFF                  = 0;
  SQL_CP_ONE_PER_DRIVER       = 1;
  SQL_CP_ONE_PER_HENV         = 2;
  SQL_CP_STRICT_MATCH         = 0;
  SQL_CP_RELAXED_MATCH        = 1;

  // Attribute value type indicators
  SQL_IS_POINTER              = -4;
  SQL_IS_UINTEGER             = -5;
  SQL_IS_INTEGER              = -6;

  // Connection attributes
  SQL_ATTR_AUTOCOMMIT     = 102;
  SQL_AUTOCOMMIT_OFF      = 0;
  SQL_AUTOCOMMIT_ON       = 1;
  SQL_ATTR_TXN_ISOLATION  = 108;
  SQL_DRIVER_NOPROMPT     = 0;
  SQL_ATTR_CONNECTION_DEAD = 1209;
  SQL_CD_TRUE             = 1;
  SQL_CD_FALSE            = 0;

  // Transaction isolation levels
  SQL_TXN_READ_UNCOMMITTED = $00000001;
  SQL_TXN_READ_COMMITTED   = $00000002;
  SQL_TXN_REPEATABLE_READ  = $00000004;
  SQL_TXN_SERIALIZABLE     = $00000008;

  // Completion types for SQLEndTran
  SQL_COMMIT   = 0;
  SQL_ROLLBACK = 1;

  // Free statement options
  SQL_CLOSE   = 0;
  SQL_DROP    = 1;
  SQL_UNBIND  = 2;
  SQL_RESET_PARAMS = 3;

  // Fetch orientation for SQLDrivers / SQLDataSources
  SQL_FETCH_NEXT  = 1;
  SQL_FETCH_FIRST = 2;

  // SQL data types
  SQL_CHAR              = 1;
  SQL_NUMERIC           = 2;
  SQL_DECIMAL           = 3;
  SQL_INTEGER           = 4;
  SQL_SMALLINT          = 5;
  SQL_FLOAT             = 6;
  SQL_REAL              = 7;
  SQL_DOUBLE            = 8;
  SQL_DATETIME          = 9;
  SQL_VARCHAR           = 12;
  SQL_TYPE_DATE         = 91;
  SQL_TYPE_TIME         = 92;
  SQL_TYPE_TIMESTAMP    = 93;
  SQL_DATE              = 9;
  SQL_TIME              = 10;
  SQL_TIMESTAMP         = 11;
  SQL_LONGVARCHAR       = -1;
  SQL_BINARY            = -2;
  SQL_VARBINARY         = -3;
  SQL_LONGVARBINARY     = -4;
  SQL_BIGINT            = -5;
  SQL_TINYINT           = -6;
  SQL_BIT               = -7;
  SQL_WCHAR             = -8;
  SQL_WVARCHAR          = -9;
  SQL_WLONGVARCHAR      = -10;
  SQL_GUID              = -11;
  SQL_SS_VARIANT        = -150;
  SQL_SS_XML            = -152;
  SQL_SS_TIME2          = -154;

  // C data types
  SQL_C_CHAR            = SQL_CHAR;
  SQL_C_LONG            = SQL_INTEGER;
  SQL_C_SHORT           = SQL_SMALLINT;
  SQL_C_FLOAT           = SQL_REAL;
  SQL_C_DOUBLE          = SQL_DOUBLE;
  SQL_C_DEFAULT         = 99;
  SQL_C_DATE            = SQL_DATE;
  SQL_C_TIME            = SQL_TIME;
  SQL_C_TIMESTAMP       = SQL_TIMESTAMP;
  SQL_C_TYPE_DATE       = SQL_TYPE_DATE;
  SQL_C_TYPE_TIME       = SQL_TYPE_TIME;
  SQL_C_TYPE_TIMESTAMP  = SQL_TYPE_TIMESTAMP;
  SQL_C_BINARY          = SQL_BINARY;
  SQL_C_BIT             = SQL_BIT;
  SQL_C_SBIGINT         = -25;
  SQL_C_UBIGINT         = -27;
  SQL_C_TINYINT         = SQL_TINYINT;
  SQL_C_SLONG           = SQL_C_LONG;
  SQL_C_SSHORT          = SQL_C_SHORT;
  SQL_C_USHORT          = -18;
  SQL_C_WCHAR           = SQL_WCHAR;

  // Parameter directions
  SQL_PARAM_INPUT         = 1;
  SQL_PARAM_INPUT_OUTPUT  = 2;
  SQL_PARAM_OUTPUT        = 4;
  SQL_RETURN_VALUE        = 5;

  // SQLGetInfo options
  SQL_DBMS_NAME               = 17;
  SQL_DBMS_VER                = 18;
  SQL_IDENTIFIER_QUOTE_CHAR   = 29;
  SQL_DRIVER_NAME             = 6;
  SQL_DRIVER_VER              = 7;
  SQL_SCHEMA_USAGE            = 91;
  SQL_CATALOG_USAGE           = 92;

  // Nullable
  SQL_NO_NULLS          = 0;
  SQL_NULLABLE          = 1;
  SQL_NULLABLE_UNKNOWN  = 2;

  // SQLStatistics options
  SQL_INDEX_UNIQUE      = 0;
  SQL_INDEX_ALL         = 1;
  SQL_QUICK             = 0;
  SQL_ENSURE            = 1;
  SQL_TABLE_STAT        = 0;

  // Descriptor field identifiers
  SQL_DESC_UNSIGNED     = 8;
  SQL_DESC_TYPE_NAME    = 14;

const
  odbc32_dll = 'odbc32.dll';

function OdbcSucceeded(RetCode: SqlReturn): Boolean; inline;

function SQLColAttributeW(StatementHandle: SqlHStmt; ColumnNumber: SqlUSmallint;
  FieldIdentifier: SqlUSmallint; CharacterAttributePtr: SqlPointer;
  BufferLength: SqlSmallint; StringLengthPtr: PSqlSmallint;
  NumericAttributePtr: PSqlLen): SqlReturn; stdcall; external odbc32_dll;

function SQLAllocHandle(HandleType: SqlSmallint; InputHandle: SqlHandle;
  out OutputHandle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLFreeHandle(HandleType: SqlSmallint; Handle: SqlHandle): SqlReturn; stdcall; external odbc32_dll;
function SQLExecDirectW(StatementHandle: SqlHStmt; StatementText: PWideChar;
  TextLength: SqlInteger): SqlReturn; stdcall; external odbc32_dll;
function SQLGetConnectAttrW(ConnectionHandle: SqlHDbc; Attribute: SqlInteger;
  ValuePtr: SqlPointer; BufferLength: SqlInteger;
  StringLengthPtr: PSqlInteger): SqlReturn; stdcall; external odbc32_dll;

implementation

function OdbcSucceeded(RetCode: SqlReturn): Boolean;
begin
  Result := (RetCode = SQL_SUCCESS) or (RetCode = SQL_SUCCESS_WITH_INFO);
end;

end.
