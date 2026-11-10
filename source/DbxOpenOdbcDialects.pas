unit DbxOpenOdbcDialects;

{===============================================================================
 Open DBX4 ODBC Driver Remastered (dbx4odbc)
 Pure Native Delphi dbExpress (DBX4) Driver for ODBC (Win32 & Win64)
 File: DbxOpenOdbcDialects.pas
 Description: DBMS Dialect Strategy Hierarchy & Quirk Handlers
 ===============================================================================}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Data.DBXCommon,
  Data.DBXPlatform,
  OdbcApi;

type
  // Strongly-typed column metadata passed to dialect hooks
  TOdbcColumnMeta = record
    ColumnNumber: SqlUSmallint; // 1-based ODBC column index
    Name: string;
    SqlType: SqlSmallint;
    ColumnSize: TSqlULen;
    DecimalDigits: SqlSmallint;
    Nullable: SqlSmallint;
    IsUnsigned: Boolean;
    DBXDataType: TDBXType;
    DBXSubType: TDBXType;
    DBXSize: TInt32;
    DBXPrecision: TInt32;
    DBXScale: TInt32;
  end;
  TOdbcColumnMetaArray = TArray<TOdbcColumnMeta>;

  { TOdbcDialect - Base ANSI SQL-92 / Standard ODBC 3.x Dialect Handler
    Provides full out-of-the-box support for any ODBC-compliant database
    without requiring a dedicated subclass. }
  TOdbcDialect = class
  protected
    FDbmsName: string;
    FDbmsVer: string;
    FQuoteChar: WideChar;
    FSupportsSchemas: Boolean;
    FSupportsCatalogs: Boolean;
    FSupportsTransactions: Boolean;
  public
    constructor Create(const ADbmsName, ADbmsVer: string); virtual;

    property DbmsName: string read FDbmsName;
    property DbmsVer: string read FDbmsVer;
    property QuoteChar: WideChar read FQuoteChar write FQuoteChar;
    property SupportsSchemas: Boolean read FSupportsSchemas write FSupportsSchemas;
    property SupportsCatalogs: Boolean read FSupportsCatalogs write FSupportsCatalogs;
    property SupportsTransactions: Boolean read FSupportsTransactions write FSupportsTransactions;

    // Cold-path hook: Adjust column metadata after standard ODBC describe & mapping
    procedure AdjustColumnMetadata(StatementHandle: SqlHStmt; ColIndex: Integer;
      var ColMeta: TOdbcColumnMeta); virtual;

    // Cold-path hook: Adjust catalog query filters before calling SQLTablesW / SQLColumnsW
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); virtual;

    // Fast-path capability flags
    function SupportsFastSqlServerMetadata: Boolean; virtual;

    // Identifier quoting
    function QuoteIdentifier(const AIdentifier: string): string; virtual;

    // Connection pooling session reset & ping hooks
    procedure ResetSession(ConnectionHDbc: SqlHDbc); virtual;
    function GetPingSql: string; virtual;
  end;

  TOdbcDialectClass = class of TOdbcDialect;

  { TSqlServerDialect - Microsoft SQL Server specialized dialect }
  TSqlServerDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    function SupportsFastSqlServerMetadata: Boolean; override;
    function QuoteIdentifier(const AIdentifier: string): string; override;
    procedure ResetSession(ConnectionHDbc: SqlHDbc); override;
    function GetPingSql: string; override;
  end;

  { TPostgreSqlDialect - PostgreSQL specialized dialect }
  TPostgreSqlDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    procedure AdjustColumnMetadata(StatementHandle: SqlHStmt; ColIndex: Integer;
      var ColMeta: TOdbcColumnMeta); override;
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); override;
    procedure ResetSession(ConnectionHDbc: SqlHDbc); override;
    function GetPingSql: string; override;
  end;

  { TMySqlDialect - MySQL & MariaDB specialized dialect }
  TMySqlDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    procedure AdjustColumnMetadata(StatementHandle: SqlHStmt; ColIndex: Integer;
      var ColMeta: TOdbcColumnMeta); override;
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); override;
    function QuoteIdentifier(const AIdentifier: string): string; override;
    procedure ResetSession(ConnectionHDbc: SqlHDbc); override;
    function GetPingSql: string; override;
  end;

  { TSqliteDialect - SQLite 3 specialized dialect }
  TSqliteDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    procedure AdjustColumnMetadata(StatementHandle: SqlHStmt; ColIndex: Integer;
      var ColMeta: TOdbcColumnMeta); override;
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); override;
    function GetPingSql: string; override;
  end;

  { TOracleDialect - Oracle Database specialized dialect }
  TOracleDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    procedure AdjustColumnMetadata(StatementHandle: SqlHStmt; ColIndex: Integer;
      var ColMeta: TOdbcColumnMeta); override;
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); override;
    procedure ResetSession(ConnectionHDbc: SqlHDbc); override;
    function GetPingSql: string; override;
  end;

  { TFirebirdDialect - Firebird specialized dialect }
  TFirebirdDialect = class(TOdbcDialect)
  public
    constructor Create(const ADbmsName, ADbmsVer: string); override;
    procedure AdjustCatalogFilter(var CatalogPattern, SchemaPattern, TablePattern: string;
      const ConnectionUserName: string); override;
    function GetPingSql: string; override;
  end;

  { TOdbcDialectFactory - Auto-detects and instantiates dialect based on SQL_DBMS_NAME }
  TOdbcDialectFactory = class
  public
    class function CreateDialect(const ADbmsName, ADbmsVer: string): TOdbcDialect;
  end;

implementation

uses
  Data.FmtBcd,
  Data.SqlTimSt;

{ TOdbcDialect }

constructor TOdbcDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create;
  FDbmsName := ADbmsName;
  FDbmsVer := ADbmsVer;
  FQuoteChar := '"';
  FSupportsSchemas := True;
  FSupportsCatalogs := True;
  FSupportsTransactions := True;
end;

procedure TOdbcDialect.AdjustColumnMetadata(StatementHandle: SqlHStmt;
  ColIndex: Integer; var ColMeta: TOdbcColumnMeta);
begin
  // Base implementation: standard ODBC 3.0 types need no adjustment
end;

procedure TOdbcDialect.AdjustCatalogFilter(var CatalogPattern, SchemaPattern,
  TablePattern: string; const ConnectionUserName: string);
begin
  if not FSupportsCatalogs then
    CatalogPattern := '';
  if not FSupportsSchemas then
    SchemaPattern := '';
end;

function TOdbcDialect.SupportsFastSqlServerMetadata: Boolean;
begin
  Result := False;
end;

function TOdbcDialect.QuoteIdentifier(const AIdentifier: string): string;
begin
  if FQuoteChar = #0 then
    Result := AIdentifier
  else
    Result := FQuoteChar + AIdentifier + FQuoteChar;
end;

procedure TOdbcDialect.ResetSession(ConnectionHDbc: SqlHDbc);
begin
  // Base dialect: No-op
end;

function TOdbcDialect.GetPingSql: string;
begin
  Result := 'SELECT 1';
end;

{ TSqlServerDialect }

constructor TSqlServerDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '"';
  FSupportsSchemas := True;
  FSupportsCatalogs := True;
  FSupportsTransactions := True;
end;

function TSqlServerDialect.SupportsFastSqlServerMetadata: Boolean;
begin
  Result := True;
end;

function TSqlServerDialect.QuoteIdentifier(const AIdentifier: string): string;
begin
  Result := '[' + AIdentifier + ']';
end;

procedure TSqlServerDialect.ResetSession(ConnectionHDbc: SqlHDbc);
var
  HStmt: SqlHStmt;
  Ret: SqlReturn;
  Cmd: WideString;
begin
  Ret := SQLAllocHandle(SQL_HANDLE_STMT, ConnectionHDbc, HStmt);
  if OdbcSucceeded(Ret) then
  begin
    try
      Cmd := 'exec sp_reset_connection';
      SQLExecDirectW(HStmt, PWideChar(Cmd), SQL_NTS);
    finally
      SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
    end;
  end;
end;

function TSqlServerDialect.GetPingSql: string;
begin
  Result := 'SELECT 1';
end;

{ TPostgreSqlDialect }

constructor TPostgreSqlDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '"';
  FSupportsSchemas := True;
  FSupportsCatalogs := True;
  FSupportsTransactions := True;
end;

procedure TPostgreSqlDialect.AdjustColumnMetadata(StatementHandle: SqlHStmt;
  ColIndex: Integer; var ColMeta: TOdbcColumnMeta);
var
  TypeNameBuf: array[0..127] of WideChar;
  TypeNameLen: SqlSmallint;
  TypeName: string;
begin
  inherited;
  FillChar(TypeNameBuf, SizeOf(TypeNameBuf), 0);
  TypeNameLen := 0;
  if OdbcSucceeded(SQLColAttributeW(StatementHandle, ColIndex, SQL_DESC_TYPE_NAME,
    @TypeNameBuf[0], SizeOf(TypeNameBuf), @TypeNameLen, nil)) then
    TypeName := LowerCase(Trim(string(PWideChar(@TypeNameBuf[0]))))
  else
    TypeName := '';

  if (TypeName = 'bool') or (TypeName = 'boolean') or
     ((ColMeta.ColumnSize = 1) and ((ColMeta.SqlType = SQL_CHAR) or (ColMeta.SqlType = SQL_BIT))) then
  begin
    ColMeta.DBXDataType := TDBXDataTypes.BooleanType;
    ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
    ColMeta.DBXSize := SizeOf(WordBool);
  end;
end;

procedure TPostgreSqlDialect.AdjustCatalogFilter(var CatalogPattern,
  SchemaPattern, TablePattern: string; const ConnectionUserName: string);
begin
  inherited;
  // Fixes #24: Delphi TSQLConnection defaults unsupplied schema to UserName.
  // In PostgreSQL, standard user tables reside in 'public' schema.
  if (SchemaPattern = '') or SameText(SchemaPattern, ConnectionUserName) then
    SchemaPattern := 'public';
end;

procedure TPostgreSqlDialect.ResetSession(ConnectionHDbc: SqlHDbc);
var
  HStmt: SqlHStmt;
  Ret: SqlReturn;
  Cmd: WideString;
begin
  Ret := SQLAllocHandle(SQL_HANDLE_STMT, ConnectionHDbc, HStmt);
  if OdbcSucceeded(Ret) then
  begin
    try
      Cmd := 'DISCARD TEMP';
      SQLExecDirectW(HStmt, PWideChar(Cmd), SQL_NTS);
    finally
      SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
    end;
  end;
end;

function TPostgreSqlDialect.GetPingSql: string;
begin
  Result := 'SELECT 1';
end;

{ TMySqlDialect }

constructor TMySqlDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '`';
  FSupportsSchemas := False; // MySQL does not have SQL-92 schemas
  FSupportsCatalogs := True;  // Database is Catalog in MySQL
  FSupportsTransactions := True;
end;

procedure TMySqlDialect.AdjustColumnMetadata(StatementHandle: SqlHStmt;
  ColIndex: Integer; var ColMeta: TOdbcColumnMeta);
begin
  inherited;
  // Fixes #21: INT UNSIGNED integer overflow beyond 2.14B
  if (ColMeta.SqlType = SQL_INTEGER) and ColMeta.IsUnsigned then
  begin
    ColMeta.DBXDataType := TDBXDataTypes.Int64Type;
    ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
    ColMeta.DBXSize := SizeOf(Int64);
  end;
end;

procedure TMySqlDialect.AdjustCatalogFilter(var CatalogPattern,
  SchemaPattern, TablePattern: string; const ConnectionUserName: string);
begin
  inherited;
  // Fixes #22: Support for schemas is disabled by NO_SCHEMA option (HY000)
  SchemaPattern := '';
end;

function TMySqlDialect.QuoteIdentifier(const AIdentifier: string): string;
begin
  Result := '`' + AIdentifier + '`';
end;

procedure TMySqlDialect.ResetSession(ConnectionHDbc: SqlHDbc);
var
  HStmt: SqlHStmt;
  Ret: SqlReturn;
  Cmd: WideString;
begin
  Ret := SQLAllocHandle(SQL_HANDLE_STMT, ConnectionHDbc, HStmt);
  if OdbcSucceeded(Ret) then
  begin
    try
      Cmd := 'SET autocommit=1';
      SQLExecDirectW(HStmt, PWideChar(Cmd), SQL_NTS);
    finally
      SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
    end;
  end;
end;

function TMySqlDialect.GetPingSql: string;
begin
  Result := 'SELECT 1';
end;

{ TSqliteDialect }

constructor TSqliteDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '"';
  FSupportsSchemas := False;
  FSupportsCatalogs := False;
  FSupportsTransactions := True;
end;

procedure TSqliteDialect.AdjustColumnMetadata(StatementHandle: SqlHStmt;
  ColIndex: Integer; var ColMeta: TOdbcColumnMeta);
begin
  inherited;
  // Fixes #23: SQLite 0-length SQL_BINARY mapped to BlobType instead of BytesType
  if ((ColMeta.SqlType = SQL_BINARY) or (ColMeta.SqlType = SQL_VARBINARY) or
      (ColMeta.SqlType = SQL_LONGVARBINARY)) and
     ((ColMeta.ColumnSize = 0) or (ColMeta.ColumnSize > 8000)) then
  begin
    ColMeta.DBXDataType := TDBXDataTypes.BlobType;
    ColMeta.DBXSubType := TDBXDataTypes.BinarySubType;
    ColMeta.DBXSize := 1;
    ColMeta.DBXPrecision := 1;
  end;
end;

procedure TSqliteDialect.AdjustCatalogFilter(var CatalogPattern,
  SchemaPattern, TablePattern: string; const ConnectionUserName: string);
begin
  inherited;
  CatalogPattern := '';
  SchemaPattern := '';
end;

function TSqliteDialect.GetPingSql: string;
begin
  Result := 'SELECT 1';
end;

{ TOracleDialect }

constructor TOracleDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '"';
  FSupportsSchemas := True;
  FSupportsCatalogs := False; // Oracle uses schemas/users, not catalogs
  FSupportsTransactions := True;
end;

procedure TOracleDialect.AdjustColumnMetadata(StatementHandle: SqlHStmt;
  ColIndex: Integer; var ColMeta: TOdbcColumnMeta);
begin
  inherited;
  // Fixes #25: Oracle DATE carries hours, minutes and seconds; map to TimeStampType
  if (ColMeta.SqlType = SQL_TYPE_DATE) or (ColMeta.SqlType = SQL_DATE) then
  begin
    ColMeta.DBXDataType := TDBXDataTypes.TimeStampType;
    ColMeta.DBXSubType := TDBXDataTypes.UnknownType;
    ColMeta.DBXSize := SizeOf(TSQLTimeStamp);
  end;
  // Fixes #26: Oracle unconstrained NUMBER returns Scale = -127
  if ColMeta.DBXScale < 0 then
    ColMeta.DBXScale := 0;
end;

procedure TOracleDialect.AdjustCatalogFilter(var CatalogPattern,
  SchemaPattern, TablePattern: string; const ConnectionUserName: string);
begin
  inherited;
  // Fixes #27: Unscoped schema queries scan entire data dictionary (SYS, SYSTEM, etc.)
  if (SchemaPattern = '') and (ConnectionUserName <> '') then
    SchemaPattern := UpperCase(ConnectionUserName);
end;

procedure TOracleDialect.ResetSession(ConnectionHDbc: SqlHDbc);
var
  HStmt: SqlHStmt;
  Ret: SqlReturn;
  Cmd: WideString;
begin
  Ret := SQLAllocHandle(SQL_HANDLE_STMT, ConnectionHDbc, HStmt);
  if OdbcSucceeded(Ret) then
  begin
    try
      Cmd := 'BEGIN DBMS_SESSION.RESET_PACKAGE; END;';
      SQLExecDirectW(HStmt, PWideChar(Cmd), SQL_NTS);
    finally
      SQLFreeHandle(SQL_HANDLE_STMT, HStmt);
    end;
  end;
end;

function TOracleDialect.GetPingSql: string;
begin
  Result := 'SELECT 1 FROM DUAL';
end;

{ TFirebirdDialect }

constructor TFirebirdDialect.Create(const ADbmsName, ADbmsVer: string);
begin
  inherited Create(ADbmsName, ADbmsVer);
  FQuoteChar := '"';
  FSupportsSchemas := False; // Firebird has no schema concept in ODBC driver
  FSupportsCatalogs := False;
  FSupportsTransactions := True;
end;

procedure TFirebirdDialect.AdjustCatalogFilter(var CatalogPattern,
  SchemaPattern, TablePattern: string; const ConnectionUserName: string);
begin
  inherited;
  CatalogPattern := '';
  SchemaPattern := '';
end;

function TFirebirdDialect.GetPingSql: string;
begin
  Result := 'SELECT 1 FROM RDB$DATABASE';
end;

{ TOdbcDialectFactory }

class function TOdbcDialectFactory.CreateDialect(const ADbmsName,
  ADbmsVer: string): TOdbcDialect;
var
  Upper: string;
begin
  Upper := UpperCase(Trim(ADbmsName));
  if Pos('SQL SERVER', Upper) > 0 then
    Result := TSqlServerDialect.Create(ADbmsName, ADbmsVer)
  else if (Pos('POSTGRES', Upper) > 0) or (Pos('PGSQL', Upper) > 0) then
    Result := TPostgreSqlDialect.Create(ADbmsName, ADbmsVer)
  else if (Pos('MYSQL', Upper) > 0) or (Pos('MARIADB', Upper) > 0) then
    Result := TMySqlDialect.Create(ADbmsName, ADbmsVer)
  else if Pos('SQLITE', Upper) > 0 then
    Result := TSqliteDialect.Create(ADbmsName, ADbmsVer)
  else if Pos('ORACLE', Upper) > 0 then
    Result := TOracleDialect.Create(ADbmsName, ADbmsVer)
  else if Pos('FIREBIRD', Upper) > 0 then
    Result := TFirebirdDialect.Create(ADbmsName, ADbmsVer)
  else
    Result := TOdbcDialect.Create(ADbmsName, ADbmsVer); // Generic ANSI ODBC Fallback
end;

end.
