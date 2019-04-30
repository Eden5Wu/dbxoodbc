{
  Part of Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.07.24

  Copyright (c) 2010 by "Vadim V.Lopushansky" <pult@ukr.net>

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public License
  as published by the Free Software Foundation; either version 2.1
  of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Home Page:
    https://sourceforge.net/projects/open-dbexpress/
}
unit Dbx34DrvDbms;
//
// Delphi: 2012 XE2,2011 XE,2010,2009,2007
//
interface

{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 18.50}

{$IF CompilerVersion < 23.00}
  {$UNDEF POSIX}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
  {$ENDIF}
{$IFEND}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ELSE}
  {$IFDEF POSIX}
  //Posix.Unistd, Posix.String_,
  {$ELSE}
  {$IFDEF LINUX}
  Types,
  {$ENDIF}{$ENDIF}{$ENDIF}
  SysUtils, Classes
  {$IF CompilerVersion > 18.00}
  ,DBXCommon
  {$ELSE}
  ,DBXpress
  {$IFEND}
  {$IF CompilerVersion >= 19.00}
  ,DBXDynalink
  {$IFEND}
  {$IF CompilerVersion > 17.00}
  ,WideStrings
  {$IFEND}
  {$IF CompilerVersion <= 18.50}
  ,DBXPlatformUtil//, DBXTableStorage, DBXDelegate, WideStrings
  {$IFEND}
  ,DBXPlatform
  ,DBXMetaDataReader
  ,DBXMetaDataNames
  ,Dbx34Drv
  ;

//
// ORACLE: ${BDS}\source\database\DBXOracleMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryOracle = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderOracle = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForSchemas: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    //function IsNestedTransactionsSupported: Boolean; override;
    procedure PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  end;

//
// MSSQL: ${BDS}\source\database\DBXMSSQLMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryMSSQL = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderMSSQL = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    //function IsSPReturnCodeSupported: Boolean; override;
    function GetSqlIdentifierQuotePrefix: UnicodeString; override;
    function GetSqlIdentifierQuoteSuffix: UnicodeString; override;
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    function GetSystemViewType: UnicodeString; override;
    function GetSynonymType: UnicodeString; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  end;

//
// MySQL: ${BDS}\source\database\DBXMySqlMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryMySQL = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderMySQL = class(TDBXOpenODBCMetaDataReader)
  private
    const DefaultCharsetIsUnicode = 'UnicodeEncoding';
  private
    FDefaultCharSetIsUnicode: Boolean;
  public
    property DefaultCharSetUnicode: Boolean read FDefaultCharSetIsUnicode;
  protected
    procedure SetContext(const Context: TDBXProviderContext); override;
    procedure PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); override;
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function GetSqlIdentifierQuotePrefix: UnicodeString; override;
    function GetSqlIdentifierQuoteSuffix: UnicodeString; override;
    function GetSqlIdentifierQuoteChar: UnicodeString; override;
    function GetTableType: UnicodeString; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  end;

//
// SybaseASA: ${BDS}\source\database\DBXSybaseASAMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactorySybaseASA = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderSybaseASA = class(TDBXOpenODBCMetaDataReader)
  private
    const SupportsNLSDataTypePropertyName = 'SupportsNLSDataType';
    const IsServerCharsetUTF8PropertyName = 'IsServerCharsetUTF8';
    const IsCharUnicodePropertyName = 'IsCharUnicode';
    const UnicodeEncodingPropertyName = 'UnicodeEncoding';
  private
    FSupportsNLSDataType: Boolean;
    FIsServerCharsetUTF8: Boolean;
    FIsCharUnicode: Boolean;
  protected
    procedure SetContext(const Context: TDBXProviderContext); override;
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    function GetSystemViewType: UnicodeString; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  public
    property SupportsNLSDataType: Boolean read FSupportsNLSDataType;
    property IsServerCharsetUTF8: Boolean read FIsServerCharsetUTF8;
    property IsCharUnicode: Boolean read FIsCharUnicode;
    property DefaultCharSetUnicode: Boolean read FIsServerCharsetUTF8;
  end;

//
// SybaseASE: ${BDS}\source\database\DBXSybaseASEMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactorySybaseASE = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderSybaseASE = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    //function IsNestedTransactionsSupported: Boolean; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  end;

//
// DB2: ${BDS}\source\database\DBXDb2MetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryDB2 = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderDB2 = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    function GetSqlProcedureQuoteChar: UnicodeString; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  end;

//
// Informix: ${BDS}\source\database\DBXInformixMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryInformix = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderInformix = class(TDBXOpenODBCMetaDataReader)
  private
    const CharType = 0;
    const SmallintType = 1;
    const IntegerType = 2;
    const FloatType = 3;
    const SmallfloatType = 4;
    const DecimalType = 5;
    const SerialType = 6;
    const DateType = 7;
    const MoneyType = 8;
    const DatetimeType = 10;
    const ByteType = 11;
    const TextType = 12;
    const VarcharType = 13;
    const IntervalType = 14;
    const NcharType = 15;
    const NvarcharType = 16;
    const Int8_Type = 17;
    const Serial8_Type = 18;
    const LvarcharType = 19;
    const BooleanType = 20;
    const TypesCount = 21;
    const NullType = 9;
    const SetType = 19;
    const MultisetType = 20;
    const ListType = 21;
    const UnnamedRowType = 22;
    const VarOpaqueType = 40;
    const FixedOpaqueType = 41;
    const NullTypeFlag = 256;
    const CharTypename = 'CHAR';
    const VarcharTypename = 'VARCHAR';
    const LvarcharTypename = 'LVARCHAR';
    const NcharTypename = 'NCHAR';
    const NvarcharTypename = 'NVARCHAR';
    const SmallintTypename = 'SMALLINT';
    const IntegerTypename = 'INTEGER';
    const Int8_Typename = 'INT8';
    const FloatTypename = 'FLOAT';
    const SmallfloatTypename = 'SMALLFLOAT';
    const DecimalTypename = 'DECIMAL';
    const SerialTypename = 'SERIAL';
    const Serial8_Typename = 'SERIAL8';
    const DateTypename = 'DATE';
    const DatetimeTypename = 'DATETIME';
    const IntervalTypename = 'INTERVAL';
    const MoneyTypename = 'MONEY';
    const ByteTypename = 'BYTE';
    const TextTypename = 'TEXT';
    const BooleanTypename = 'BOOLEAN';
    const &Create = 'CREATE';
    const Returning = 'RETURNING';
    const &In = 'IN';
    const Out = 'OUT';
    const Inout = 'INOUT';
    const Like = 'LIKE';
    const References = 'REFERENCES';
    const IntType = 'INT';
    const DecType = 'DEC';
    const BigintType = 'BIGINT';
    const Character = 'CHARACTER';
    const Varying = 'VARYING';
    const RealType = 'REAL';
    const DoubleType = 'DOUBLE';
    const Precision = 'PRECISION';
    const Numeric = 'NUMERIC';
    const Default = 'DEFAULT';
    const QuoteCharacterEnabled = 'QuoteCharEnabled';
    const TokenCreate = 51;
    const TokenProcedure = 52;
    const TokenFunction = 53;
    const TokenReturning = 54;
    const TokenOut = 55;
    const TokenInout = 56;
    const TokenLike = 57;
    const TokenReferences = 58;
    const TokenInt = 59;
    const TokenDec = 60;
    const TokenBigint = 61;
    const TokenCharacter = 62;
    const TokenVarying = 63;
    const TokenReal = 64;
    const TokenDouble = 65;
    const TokenPrecision = 66;
    const TokenNumeric = 67;
    const TokenDefault = 68;
  private
    FAlltypes: TDBXDataTypeDescriptionArray;
  protected
    function GetAllDataTypes: TDBXDataTypeDescriptionArray;
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    function GetSynonymType: UnicodeString; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  public
    destructor Destroy; override;
  end;

//
// DataStorage: ${BDS}\source\database\DBXDataStoreMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryDataStorage = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderDataStorage = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
  end;

//
// Firebird: ${BDS}\source\database\DBXFirebirdMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryFirebird = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderFirebird = class(TDBXOpenODBCMetaDataReader)
  public
    const CharType = 0;
    const VarcharType = 1;
    const IntegerType = 2;
    const SmallintType = 3;
    const FloatType = 4;
    const DoubleType = 5;
    const NumericType = 6;
    const DecimalType = 7;
    const DateType = 8;
    const TimeType = 9;
    const TimestampType = 10;
    const BlobType = 11;
    const BigintType = 12;
    const DefaultCharset = 0;
    const CharsetUnicodeFss = 3;
    const CharsetSjis208 = 5;
    const CharsetEucj208 = 6;
  private
    const TypesCount = 13;
    const DefaultStringStart = 'DEFAULT ';
    const DefaultCharsetIsUnicode = 'UnicodeEncoding';
    const QuoteCharacterEnabled = 'QuoteCharEnabled';
    const ColumnsFieldType = TDBXColumnsIndex.TypeName;
    const ColumnsSubtype = TDBXColumnsIndex.DbxDataType;
    const ParametersFieldType = TDBXProcedureParametersIndex.TypeName;
    const ParametersSubtype = TDBXProcedureParametersIndex.DbxDataType;
  private
    FDefaultCharSetIsUnicode: Boolean;
    FAlltypes: TDBXDataTypeDescriptionArray;
  protected
    function GetAllDataTypes: TDBXDataTypeDescriptionArray;
    procedure SetContext(const Context: TDBXProviderContext); override;
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function IsDescendingIndexColumnsSupported: Boolean; override;
    //function IsNestedTransactionsSupported: Boolean; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  public
    destructor Destroy; override;
  end;

//
// Interbase: ${BDS}\source\database\DBXInterbaseMetaDataReader.pas
//

type
  TDBXOpenODBCMetaDataCommandFactoryInterbase = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderInterbase = class(TDBXOpenODBCMetaDataReader)
  public
    const CharType = 0;
    const VarcharType = 1;
    const IntegerType = 2;
    const SmallintType = 3;
    const FloatType = 4;
    const DoubleType = 5;
    const NumericType = 6;
    const DecimalType = 7;
    const DateType = 8;
    const TimeType = 9;
    const TimestampType = 10;
    const BlobType = 11;
    const BooleanType = 12;
    const DefaultCharset = 0;
    const CharsetUnicodeFss = 3;
    const CharsetSjis208 = 5;
    const CharsetEucj208 = 6;
  private
    const TypesCount = 13;
    const DefaultStringStart = 'DEFAULT ';
    const DefaultCharsetIsUnicode = 'UnicodeEncoding';
    const QuoteCharacterEnabled = 'QuoteCharEnabled';
    const ColumnsFieldType = TDBXColumnsIndex.TypeName;
    const ColumnsSubtype = TDBXColumnsIndex.DbxDataType;
    const ParametersFieldType = TDBXProcedureParametersIndex.TypeName;
    const ParametersSubtype = TDBXProcedureParametersIndex.DbxDataType;
  private
    FDefaultCharSetIsUnicode: Boolean;
    FAlltypes: TDBXDataTypeDescriptionArray;
  protected
    function GetAllDataTypes: TDBXDataTypeDescriptionArray;
    procedure SetContext(const Context: TDBXProviderContext); override;
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    function IsDescendingIndexColumnsSupported: Boolean; override;
    //function IsNestedTransactionsSupported: Boolean; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
  public
    destructor Destroy; override;
  end;

//
// SQLite
//

type
  TDBXOpenODBCMetaDataCommandFactorySQLite = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderSQLite = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetSqlForTables: UnicodeString; override;
    //function GetSqlForColumns: UnicodeString; override;
    //function GetSqlForIndexes: UnicodeString; override;
    //function GetSqlForIndexColumns: UnicodeString; override;
    //function GetReservedWords: TDBXStringArray; override;
  end;

//
// PostgreSQL
//

type
  TDBXOpenODBCMetaDataCommandFactoryPostgreSQL = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReaderPostgreSQL = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
  end;

{$IFEND CompilerVersion >= 18.50}
{$ENDIF CONDITIONALEXPRESSIONS}

implementation

{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 18.50}

//
// ORACLE
//

{ TDBXOpenODBCMetaDataCommandFactoryOracle }

class function TDBXOpenODBCMetaDataCommandFactoryOracle.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderOracle;
end;

{ TDBXOpenODBCMetaDataReaderOracle }

function TDBXOpenODBCMetaDataReaderOracle.GetProductName: UnicodeString;
begin
  Result := 'Oracle';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetSqlForSchemas: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DISTINCT NULL, OWNER ' +
            'FROM ALL_OBJECTS ' +
            'WHERE (1<2 OR :CATALOG_NAME IS NULL) ' +
            'ORDER BY 1';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result :=
    'SELECT /*+ NO_EXPAND */ NULL, OWNER, OBJECT_NAME, CASE WHEN OWNER IN (''SYS'',''SYSTEM'',''CTXSYS'',''DMSYS'',''EXFSYS'',''OLAPSYS'',''ORDSYS'',''MDSYS'',''WKSYS'',''WK_TEST'',''WMSYS'',''XDB'') THEN ''SYSTEM '' ELSE '''' END || OBJECT_TYPE ' +
    'FROM ALL_OBJECTS ' +
    'WHERE OBJECT_TYPE IN (''VIEW'',''TABLE'',''SYNONYM'') ' +
    ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(NVL(:SCHEMA_NAME, USER)) ) AND (OBJECT_NAME = NVL(:TABLE_NAME, OBJECT_NAME) ) ' +
    ' AND ((CASE WHEN OWNER IN (''SYS'',''SYSTEM'',''CTXSYS'',''DMSYS'',''EXFSYS'',''OLAPSYS'',''ORDSYS'',''MDSYS'',''WKSYS'',''WK_TEST'',''WMSYS'',''XDB'') THEN ''SYSTEM '' ELSE '''' END) || OBJECT_TYPE IN (:TABLES,:VIEWS,:SYSTEM_TABLES,:SYSTEM_VIEWS,:SYNONYMS)) ' +
    'ORDER BY 2, 3';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result :=
    'SELECT NULL, OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, COALESCE(DATA_PRECISION,CHAR_COL_DECL_LENGTH,DATA_LENGTH), DATA_SCALE, COLUMN_ID, DATA_DEFAULT, DECODE(NULLABLE,''Y'',1,''YES'',1,0), 0, NULL ' +
    'FROM SYS.ALL_TAB_COLUMNS ' +
    'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(NVL(:SCHEMA_NAME, USER))) AND (TABLE_NAME = NVL(:TABLE_NAME, TABLE_NAME)) ' +
    'ORDER BY 2, 3, COLUMN_ID';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result :=
    'SELECT NULL, I.TABLE_OWNER, I.TABLE_NAME, I.INDEX_NAME, C.CONSTRAINT_NAME, CASE WHEN C.CONSTRAINT_TYPE = ''P'' THEN 1 ELSE 0 END, CASE WHEN I.UNIQUENESS = ''UNIQUE'' THEN 1 ELSE 0 END, 1 ' +
    'FROM SYS.ALL_INDEXES I, SYS.ALL_CONSTRAINTS C ' +
    'WHERE I.TABLE_OWNER=C.OWNER(+) AND I.INDEX_NAME=C.INDEX_NAME(+) AND I.TABLE_NAME=C.TABLE_NAME(+) ' +
    ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(I.TABLE_OWNER) = LOWER(NVL(:SCHEMA_NAME, USER))) AND (I.TABLE_NAME = NVL(:TABLE_NAME, I.TABLE_NAME)) ' +
    'ORDER BY 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result :=
    'SELECT NULL, C.TABLE_OWNER, C.TABLE_NAME, C.INDEX_NAME, C.COLUMN_NAME, C.COLUMN_POSITION, CASE WHEN C.DESCEND = ''DESC'' THEN 0 ELSE 1 END, E.COLUMN_EXPRESSION, CASE WHEN E.COLUMN_EXPRESSION IS NULL THEN 1 ELSE 0 END ' +
    'FROM ALL_IND_COLUMNS C, ALL_IND_EXPRESSIONS E ' +
    'WHERE C.INDEX_OWNER=E.INDEX_OWNER(+) AND C.INDEX_NAME=E.INDEX_NAME(+) AND C.COLUMN_POSITION=E.COLUMN_POSITION(+) ' +
    ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(C.TABLE_OWNER) = LOWER(NVL(:SCHEMA_NAME, USER))) AND (C.TABLE_NAME = NVL(:TABLE_NAME, C.TABLE_NAME)) AND (C.INDEX_NAME = NVL(:INDEX_NAME, C.INDEX_NAME)) ' +
    'ORDER BY 2, 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderOracle.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 80);
  Words[0] := 'ALL';
  Words[1] := 'ALTER';
  Words[2] := 'AND';
  Words[3] := 'ANY';
  Words[4] := 'AS';
  Words[5] := 'ASC';
  Words[6] := 'BETWEEN';
  Words[7] := 'BY';
  Words[8] := 'CHAR';
  Words[9] := 'CHECK';
  Words[10] := 'CLUSTER';
  Words[11] := 'COMPRESS';
  Words[12] := 'CONNECT';
  Words[13] := 'CREATE';
  Words[14] := 'DATE';
  Words[15] := 'DECIMAL';
  Words[16] := 'DEFAULT';
  Words[17] := 'DELETE';
  Words[18] := 'DESC';
  Words[19] := 'DISTINCT';
  Words[20] := 'DROP';
  Words[21] := 'ELSE';
  Words[22] := 'EXCLUSIVE';
  Words[23] := 'EXISTS';
  Words[24] := 'FLOAT';
  Words[25] := 'FOR';
  Words[26] := 'FROM';
  Words[27] := 'GRANT';
  Words[28] := 'GROUP';
  Words[29] := 'HAVING';
  Words[30] := 'IDENTIFIED';
  Words[31] := 'IN';
  Words[32] := 'INDEX';
  Words[33] := 'INSERT';
  Words[34] := 'INTEGER';
  Words[35] := 'INTERSECT';
  Words[36] := 'INTO';
  Words[37] := 'IS';
  Words[38] := 'LIKE';
  Words[39] := 'LOCK';
  Words[40] := 'LONG';
  Words[41] := 'MINUS';
  Words[42] := 'MODE';
  Words[43] := 'NOCOMPRESS';
  Words[44] := 'NOT';
  Words[45] := 'NOWAIT';
  Words[46] := 'NULL';
  Words[47] := 'NUMBER';
  Words[48] := 'OF';
  Words[49] := 'ON';
  Words[50] := 'OPTION';
  Words[51] := 'OR';
  Words[52] := 'ORDER';
  Words[53] := 'PCTFREE';
  Words[54] := 'PRIOR';
  Words[55] := 'PUBLIC';
  Words[56] := 'RAW';
  Words[57] := 'RENAME';
  Words[58] := 'RESOURCE';
  Words[59] := 'REVOKE';
  Words[60] := 'SELECT';
  Words[61] := 'SET';
  Words[62] := 'SHARE';
  Words[63] := 'SIZE';
  Words[64] := 'SMALLINT';
  Words[65] := 'START';
  Words[66] := 'SYNONYM';
  Words[67] := 'TABLE';
  Words[68] := 'THEN';
  Words[69] := 'TO';
  Words[70] := 'TRIGGER';
  Words[71] := 'UNION';
  Words[72] := 'UNIQUE';
  Words[73] := 'UPDATE';
  Words[74] := 'VALUES';
  Words[75] := 'VARCHAR';
  Words[76] := 'VARCHAR2';
  Words[77] := 'VIEW';
  Words[78] := 'WHERE';
  Words[79] := 'WITH';
  Result := Words;
end;

//function TDBXOpenODBCMetaDataReaderOracle.IsNestedTransactionsSupported: Boolean;
//begin
//  Result := True;
//end;

procedure TDBXOpenODBCMetaDataReaderOracle.PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Def: TDBXDataTypeDescription;
begin
  inherited PopulateDataTypes(Hash, Types, Descr);
  Def := TDBXDataTypeDescription.Create('REF CURSOR', TDBXDataTypes.CursorType, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
  Def := TDBXDataTypeDescription.Create('PL/SQL BOOLEAN', TDBXDataTypes.BooleanType, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
  Def := TDBXDataTypeDescription.Create('BINARY_INTEGER', TDBXDataTypes.Int32Type, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
end;

function TDBXOpenODBCMetaDataReaderOracle.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,22);
  Types[0] := TDBXDataTypeDescription.Create('BFILE', TDBXDataTypes.BlobType, 4294967296, 'BFILE', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[1] := TDBXDataTypeDescription.Create('BLOB', TDBXDataTypes.BlobType, 4294967296, 'BLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[2] := TDBXDataTypeDescription.Create('CHAR', TDBXDataTypes.WideStringType, 2000, 'CHAR({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported);
  Types[3] := TDBXDataTypeDescription.Create('CLOB', TDBXDataTypes.WideStringType, 4294967296, 'CLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[4] := TDBXDataTypeDescription.Create('DATE', TDBXDataTypes.TimeStampType, 19, 'DATE', NullString, -1, -1, 'TO_DATE(''', ''',''YYYY-MM-DD HH24:MI:SS'')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[5] := TDBXDataTypeDescription.Create('FLOAT', TDBXDataTypes.BcdType, 126, 'FLOAT({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[6] := TDBXDataTypeDescription.Create('BINARY_FLOAT', TDBXDataTypes.SingleType, 7, 'BINARY_FLOAT', NullString, -1, -1, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[7] := TDBXDataTypeDescription.Create('BINARY_DOUBLE', TDBXDataTypes.DoubleType, 53, 'BINARY_DOUBLE', NullString, -1, -1, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[8] := TDBXDataTypeDescription.Create('INTERVAL DAY TO SECOND', TDBXDataTypes.IntervalType, 0, 'INTERVAL DAY({0}) TO SECOND({1})', 'Precision,Scale', -1, -1, 'TO_DSINTERVAL(''', ''')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[9] := TDBXDataTypeDescription.Create('INTERVAL YEAR TO MONTH', TDBXDataTypes.IntervalType, 0, 'INTERVAL YEAR({0}) TO MONTH', 'Precision', -1, -1, 'TO_YMINTERVAL(''', ''')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[10] := TDBXDataTypeDescription.Create('LONG', TDBXDataTypes.WideStringType, 2147483647, 'LONG', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long);
  Types[11] := TDBXDataTypeDescription.Create('LONG RAW', TDBXDataTypes.BytesType, 2147483647, 'LONG RAW', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[12] := TDBXDataTypeDescription.Create('NCHAR', TDBXDataTypes.WideStringType, 2000, 'NCHAR({0})', 'Precision', -1, -1, 'N''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported or TDBXTypeFlag.Unicode);
  Types[13] := TDBXDataTypeDescription.Create('NCLOB', TDBXDataTypes.WideStringType, 4294967296, 'NCLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Unicode);
  Types[14] := TDBXDataTypeDescription.Create('NUMBER', TDBXDataTypes.BcdType, 38, 'NUMBER({0},{1})', 'Precision,Scale', 127, -84, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[15] := TDBXDataTypeDescription.Create('NVARCHAR2', TDBXDataTypes.WideStringType, 4000, 'NVARCHAR2({0})', 'Precision', -1, -1, 'N''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported or TDBXTypeFlag.Unicode);
  Types[16] := TDBXDataTypeDescription.Create('RAW', TDBXDataTypes.BytesType, 2000, 'RAW({0})', 'Precision', -1, -1, 'HEXTORAW(''', ''')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[17] := TDBXDataTypeDescription.Create('TIMESTAMP', TDBXDataTypes.TimeStampType, 27, 'TIMESTAMP({0})', 'Precision', -1, -1, 'TO_TIMESTAMP(''', ''',''YYYY-MM-DD HH24:MI:SS.FF'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[18] := TDBXDataTypeDescription.Create('TIMESTAMP WITH LOCAL TIME ZONE', TDBXDataTypes.TimeStampType, 27, 'TIMESTAMP({0} WITH LOCAL TIME ZONE)', 'Precision', -1, -1, 'TO_TIMESTAMP_TZ(''', ''',''YYYY-MM-DD HH24:MI:SS.FF'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[19] := TDBXDataTypeDescription.Create('TIMESTAMP WITH TIME ZONE', TDBXDataTypes.TimeStampType, 34, 'TIMESTAMP({0} WITH TIME ZONE)', 'Precision', -1, -1, 'TO_TIMESTAMP_TZ(''', ''',''YYYY-MM-DD HH24:MI:SS.FF TZH:TZM'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[20] := TDBXDataTypeDescription.Create('VARCHAR2', TDBXDataTypes.WideStringType, 4000, 'VARCHAR2({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported);
  Types[21] := TDBXDataTypeDescription.Create('XMLTYPE', TDBXDataTypes.WideStringType, 4000, 'XMLTYPE', NullString, -1, -1, '', '', NullString, NullString, TDBXTypeFlag.LiteralSupported);
  Result := Types;
end;

//
// MSSQL
//

{ TDBXOpenODBCMetaDataCommandFactoryMSSQL }

class function TDBXOpenODBCMetaDataCommandFactoryMSSQL.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderMSSQL;
end;

{ TDBXOpenODBCMetaDataReaderMSSQL }

function TDBXOpenODBCMetaDataReaderMSSQL.GetProductName: UnicodeString;
begin
  Result := 'Microsoft SQL Server';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlForTables: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '09.00.0000' then
    Result := 'SELECT DB_NAME(), SCHEMA_NAME(a.schema_id), a.name, CASE WHEN a.type=''U'' THEN ''TABLE'' WHEN s.type=''V'' THEN ''SYSTEM VIEW'' WHEN a.type=''V'' THEN ''VIEW'' WHEN a.type=''S'' THEN ''SYSTEM TABLE'' WHEN a.type=''SN'' THEN ''SYNONYM'' END ' +
              'FROM  sys.all_objects a LEFT OUTER JOIN sys.system_objects s ON a.object_id=s.object_id ' +
              'WHERE (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (SCHEMA_NAME(a.schema_id) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (a.name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              ' AND  (a.type = :TABLES OR a.type = :VIEWS OR a.type = :SYSTEM_TABLES OR s.type = :SYSTEM_VIEWS OR a.type = :SYNONYMS) ' +
              'ORDER BY 1, 2, 3'
  else
    Result := 'SELECT DB_NAME(), USER_NAME(uid), name, CASE type WHEN ''U'' THEN ''TABLE'' WHEN ''V'' THEN ''VIEW'' WHEN ''S'' THEN ''SYSTEM TABLE'' WHEN ''SN'' THEN ''SYNONYM'' END ' +
              'FROM  dbo.sysobjects ' +
              'WHERE (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              ' AND  (type = :TABLES OR type = :VIEWS OR type = :SYSTEM_TABLES OR type = :SYNONYMS) ' +
              'ORDER BY 1, 2, 3';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlForColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '09.00.0000' then
    Result := 'SELECT DB_NAME(), SCHEMA_NAME(O.uid), O.NAME, C.NAME, T.NAME, CONVERT(INT,C.PREC), CONVERT(INT,C.SCALE), CONVERT(INT,C.colid), CASE WHEN COM.TEXT LIKE ''((%))'' THEN SUBSTRING(COM.TEXT,3,LEN(COM.TEXT)-4) WHEN COM.TEXT LIKE ''(''''%'''')'' THEN SUBSTRING(COM.TEXT,' + '2,LEN(COM.TEXT)-2) ELSE COM.TEXT END AS DEFAULT_VALUE, CONVERT(BIT, C.ISNULLABLE), CONVERT(BIT, COLUMNPROPERTY(O.id, C.NAME, ''ISIDENTITY'')), NULL ' +
              'FROM sysobjects O INNER JOIN syscolumns C ON O.id=C.id INNER JOIN SYSTYPES T ON C.XUSERTYPE = T.XUSERTYPE LEFT OUTER JOIN SYSCOMMENTS COM ON CDEFAULT=COM.id ' +
              'WHERE OBJECTPROPERTY(O.id,''IsView'')+OBJECTPROPERTY(O.id,''IsUserTable'') > 0 AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (SCHEMA_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, C.colid'
  else
    Result := 'SELECT DB_NAME(), USER_NAME(O.uid), O.NAME, C.NAME, T.NAME, CONVERT(INT,C.PREC), CONVERT(INT,C.SCALE), CONVERT(INT,C.colid), CASE WHEN COM.TEXT LIKE ''(%)'' THEN SUBSTRING(COM.TEXT,2,LEN(COM.TEXT)-2) WHEN COM.TEXT LIKE ''(''''%'''')'' THEN SUBSTRING(COM.TEXT,2,LE' + 'N(COM.TEXT)-2) ELSE COM.TEXT END AS DEFAULT_VALUE, CONVERT(BIT, C.ISNULLABLE), CONVERT(BIT, COLUMNPROPERTY(O.id, C.NAME, ''ISIDENTITY'')), NULL ' +
              'FROM sysobjects O INNER JOIN syscolumns C ON O.id=C.id INNER JOIN SYSTYPES T ON C.XUSERTYPE = T.XUSERTYPE LEFT OUTER JOIN SYSCOMMENTS COM ON CDEFAULT=COM.id ' +
              'WHERE OBJECTPROPERTY(O.id,''IsView'')+OBJECTPROPERTY(O.id,''IsUserTable'') > 0 AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, C.colid';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlForIndexes: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '09.00.0000' then
    Result := 'SELECT DISTINCT DB_NAME(), SCHEMA_NAME(O.uid), O.NAME, I.NAME, CASE WHEN INDEXPROPERTY(I.id, I.NAME,  ''IsUnique'') > 0 THEN I.NAME ELSE NULL END, CONVERT(BIT, COALESCE(OBJECTPROPERTY(object_id(I.NAME), ''IsPrimaryKey''), 0)), CONVERT(BIT, COALESCE(INDEXPROPE' + 'RTY(I.id, I.NAME,  ''IsUnique''), 0)), CONVERT(BIT, 1) ' +
              'FROM sysobjects O, sysindexes I, sysindexkeys IK ' +
              'WHERE O.TYPE IN (''U'') and I.id = O.id AND O.id = IK.id AND I.indid = IK.indid AND IK.KEYNO <= I.KEYCNT ' +
              ' AND (DB_NAME() = :CATALOG_NAME or (:CATALOG_NAME IS NULL)) AND (SCHEMA_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4'
  else
    Result := 'SELECT DISTINCT DB_NAME(), USER_NAME(O.uid), O.NAME, I.NAME, CASE WHEN INDEXPROPERTY(I.id, I.NAME,  ''IsUnique'') > 0 THEN I.NAME ELSE NULL END, CONVERT(BIT, COALESCE(OBJECTPROPERTY(object_id(I.NAME), ''IsPrimaryKey''), 0)), CONVERT(BIT, COALESCE(INDEXPROPERT' + 'Y(I.id, I.NAME,  ''IsUnique''), 0)), CONVERT(BIT, 1) ' +
              'FROM sysobjects O, sysindexes I, sysindexkeys IK ' +
              'WHERE O.TYPE IN (''U'') and I.id = O.id AND O.id = IK.id AND I.indid = IK.indid AND IK.KEYNO <= I.KEYCNT  AND I.STATUS & 0x800000 = 0 ' +
              ' AND (DB_NAME() = :CATALOG_NAME or (:CATALOG_NAME IS NULL)) AND (USER_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlForIndexColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '09.00.0000' then
    Result := 'SELECT DISTINCT DB_NAME(), SCHEMA_NAME(O.uid), O.NAME, I.NAME, C.NAME, CONVERT(INT, IK.KEYNO), CONVERT(BIT, 1 - INDEXKEY_PROPERTY(O.id, I.indid, IK.KEYNO, ''IsDescending'')) ' +
              'FROM sysobjects O, sysindexes I, sysindexkeys IK, syscolumns C ' +
              'WHERE O.TYPE IN (''U'') AND I.id = O.id AND O.id = IK.id AND O.id = C.id AND C.colid = IK.colid AND I.indid = IK.indid AND IK.KEYNO <= I.KEYCNT AND ' +
              '(DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (SCHEMA_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (I.NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4, 6'
  else
    Result := 'SELECT DISTINCT DB_NAME(), USER_NAME(O.uid), O.NAME, I.NAME, C.NAME, CONVERT(INT, IK.KEYNO), CONVERT(BIT, 1 - INDEXKEY_PROPERTY(O.id, I.indid, IK.KEYNO, ''IsDescending'')) ' +
              'FROM sysobjects O, sysindexes I, sysindexkeys IK, syscolumns C ' +
              'WHERE O.TYPE IN (''U'') AND I.id = O.id AND O.id = IK.id AND O.id = C.id AND C.colid = IK.colid AND I.indid = IK.indid AND IK.KEYNO <= I.KEYCNT AND ' +
              '(DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(O.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (O.NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (I.NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 393);
  Words[0] := 'ADD';
  Words[1] := 'EXCEPT';
  Words[2] := 'PERCENT';
  Words[3] := 'ALL';
  Words[4] := 'EXEC';
  Words[5] := 'PLAN';
  Words[6] := 'ALTER';
  Words[7] := 'EXECUTE';
  Words[8] := 'PRECISION';
  Words[9] := 'AND';
  Words[10] := 'EXISTS';
  Words[11] := 'PRIMARY';
  Words[12] := 'ANY';
  Words[13] := 'EXIT';
  Words[14] := 'PRINT';
  Words[15] := 'AS';
  Words[16] := 'FETCH';
  Words[17] := 'PROC';
  Words[18] := 'ASC';
  Words[19] := 'FILE';
  Words[20] := 'PROCEDURE';
  Words[21] := 'AUTHORIZATION';
  Words[22] := 'FILLFACTOR';
  Words[23] := 'PUBLIC';
  Words[24] := 'BACKUP';
  Words[25] := 'FOR';
  Words[26] := 'RAISERROR';
  Words[27] := 'BEGIN';
  Words[28] := 'FOREIGN';
  Words[29] := 'READ';
  Words[30] := 'BETWEEN';
  Words[31] := 'FREETEXT';
  Words[32] := 'READTEXT';
  Words[33] := 'BREAK';
  Words[34] := 'FREETEXTTABLE';
  Words[35] := 'RECONFIGURE';
  Words[36] := 'BROWSE';
  Words[37] := 'FROM';
  Words[38] := 'REFERENCES';
  Words[39] := 'BULK';
  Words[40] := 'FULL';
  Words[41] := 'REPLICATION';
  Words[42] := 'BY';
  Words[43] := 'FUNCTION';
  Words[44] := 'RESTORE';
  Words[45] := 'CASCADE';
  Words[46] := 'GOTO';
  Words[47] := 'RESTRICT';
  Words[48] := 'CASE';
  Words[49] := 'GRANT';
  Words[50] := 'RETURN';
  Words[51] := 'CHECK';
  Words[52] := 'GROUP';
  Words[53] := 'REVOKE';
  Words[54] := 'CHECKPOINT';
  Words[55] := 'HAVING';
  Words[56] := 'RIGHT';
  Words[57] := 'CLOSE';
  Words[58] := 'HOLDLOCK';
  Words[59] := 'ROLLBACK';
  Words[60] := 'CLUSTERED';
  Words[61] := 'IDENTITY';
  Words[62] := 'ROWCOUNT';
  Words[63] := 'COALESCE';
  Words[64] := 'IDENTITY_INSERT';
  Words[65] := 'ROWGUIDCOL';
  Words[66] := 'COLLATE';
  Words[67] := 'IDENTITYCOL';
  Words[68] := 'RULE';
  Words[69] := 'COLUMN';
  Words[70] := 'IF';
  Words[71] := 'SAVE';
  Words[72] := 'COMMIT';
  Words[73] := 'IN';
  Words[74] := 'SCHEMA';
  Words[75] := 'COMPUTE';
  Words[76] := 'INDEX';
  Words[77] := 'SELECT';
  Words[78] := 'CONSTRAINT';
  Words[79] := 'INNER';
  Words[80] := 'SESSION_USER';
  Words[81] := 'CONTAINS';
  Words[82] := 'INSERT';
  Words[83] := 'SET';
  Words[84] := 'CONTAINSTABLE';
  Words[85] := 'INTERSECT';
  Words[86] := 'SETUSER';
  Words[87] := 'CONTINUE';
  Words[88] := 'INTO';
  Words[89] := 'SHUTDOWN';
  Words[90] := 'CONVERT';
  Words[91] := 'IS';
  Words[92] := 'SOME';
  Words[93] := 'CREATE';
  Words[94] := 'JOIN';
  Words[95] := 'STATISTICS';
  Words[96] := 'CROSS';
  Words[97] := 'KEY';
  Words[98] := 'SYSTEM_USER';
  Words[99] := 'CURRENT';
  Words[100] := 'KILL';
  Words[101] := 'TABLE';
  Words[102] := 'CURRENT_DATE';
  Words[103] := 'LEFT';
  Words[104] := 'TEXTSIZE';
  Words[105] := 'CURRENT_TIME';
  Words[106] := 'LIKE';
  Words[107] := 'THEN';
  Words[108] := 'CURRENT_TIMESTAMP';
  Words[109] := 'LINENO';
  Words[110] := 'TO';
  Words[111] := 'CURRENT_USER';
  Words[112] := 'LOAD';
  Words[113] := 'TOP';
  Words[114] := 'CURSOR';
  Words[115] := 'NATIONAL';
  Words[116] := 'TRAN';
  Words[117] := 'DATABASE';
  Words[118] := 'NOCHECK';
  Words[119] := 'TRANSACTION';
  Words[120] := 'DBCC';
  Words[121] := 'NONCLUSTERED';
  Words[122] := 'TRIGGER';
  Words[123] := 'DEALLOCATE';
  Words[124] := 'NOT';
  Words[125] := 'TRUNCATE';
  Words[126] := 'DECLARE';
  Words[127] := 'NULL';
  Words[128] := 'TSEQUAL';
  Words[129] := 'DEFAULT';
  Words[130] := 'NULLIF';
  Words[131] := 'UNION';
  Words[132] := 'DELETE';
  Words[133] := 'OF';
  Words[134] := 'UNIQUE';
  Words[135] := 'DENY';
  Words[136] := 'OFF';
  Words[137] := 'UPDATE';
  Words[138] := 'DESC';
  Words[139] := 'OFFSETS';
  Words[140] := 'UPDATETEXT';
  Words[141] := 'DISK';
  Words[142] := 'ON';
  Words[143] := 'USE';
  Words[144] := 'DISTINCT';
  Words[145] := 'OPEN';
  Words[146] := 'USER';
  Words[147] := 'DISTRIBUTED';
  Words[148] := 'OPENDATASOURCE';
  Words[149] := 'VALUES';
  Words[150] := 'DOUBLE';
  Words[151] := 'OPENQUERY';
  Words[152] := 'VARYING';
  Words[153] := 'DROP';
  Words[154] := 'OPENROWSET';
  Words[155] := 'VIEW';
  Words[156] := 'DUMMY';
  Words[157] := 'OPENXML';
  Words[158] := 'WAITFOR';
  Words[159] := 'DUMP';
  Words[160] := 'OPTION';
  Words[161] := 'WHEN';
  Words[162] := 'ELSE';
  Words[163] := 'OR';
  Words[164] := 'WHERE';
  Words[165] := 'END';
  Words[166] := 'ORDER';
  Words[167] := 'WHILE';
  Words[168] := 'ERRLVL';
  Words[169] := 'OUTER';
  Words[170] := 'WITH';
  Words[171] := 'ESCAPE';
  Words[172] := 'OVER';
  Words[173] := 'WRITETEXT';
  Words[174] := 'ABSOLUTE';
  Words[175] := 'FOUND';
  Words[176] := 'PRESERVE';
  Words[177] := 'ACTION';
  Words[178] := 'FREE';
  Words[179] := 'PRIOR';
  Words[180] := 'ADMIN';
  Words[181] := 'GENERAL';
  Words[182] := 'PRIVILEGES';
  Words[183] := 'AFTER';
  Words[184] := 'GET';
  Words[185] := 'READS';
  Words[186] := 'AGGREGATE';
  Words[187] := 'GLOBAL';
  Words[188] := 'REAL';
  Words[189] := 'ALIAS';
  Words[190] := 'GO';
  Words[191] := 'RECURSIVE';
  Words[192] := 'ALLOCATE';
  Words[193] := 'GROUPING';
  Words[194] := 'REF';
  Words[195] := 'ARE';
  Words[196] := 'HOST';
  Words[197] := 'REFERENCING';
  Words[198] := 'ARRAY';
  Words[199] := 'HOUR';
  Words[200] := 'RELATIVE';
  Words[201] := 'ASSERTION';
  Words[202] := 'IGNORE';
  Words[203] := 'RESULT';
  Words[204] := 'AT';
  Words[205] := 'IMMEDIATE';
  Words[206] := 'RETURNS';
  Words[207] := 'BEFORE';
  Words[208] := 'INDICATOR';
  Words[209] := 'ROLE';
  Words[210] := 'BINARY';
  Words[211] := 'INITIALIZE';
  Words[212] := 'ROLLUP';
  Words[213] := 'BIT';
  Words[214] := 'INITIALLY';
  Words[215] := 'ROUTINE';
  Words[216] := 'BLOB';
  Words[217] := 'INOUT';
  Words[218] := 'ROW';
  Words[219] := 'BOOLEAN';
  Words[220] := 'INPUT';
  Words[221] := 'ROWS';
  Words[222] := 'BOTH';
  Words[223] := 'INT';
  Words[224] := 'SAVEPOINT';
  Words[225] := 'BREADTH';
  Words[226] := 'INTEGER';
  Words[227] := 'SCROLL';
  Words[228] := 'CALL';
  Words[229] := 'INTERVAL';
  Words[230] := 'SCOPE';
  Words[231] := 'CASCADED';
  Words[232] := 'ISOLATION';
  Words[233] := 'SEARCH';
  Words[234] := 'CAST';
  Words[235] := 'ITERATE';
  Words[236] := 'SECOND';
  Words[237] := 'CATALOG';
  Words[238] := 'LANGUAGE';
  Words[239] := 'SECTION';
  Words[240] := 'CHAR';
  Words[241] := 'LARGE';
  Words[242] := 'SEQUENCE';
  Words[243] := 'CHARACTER';
  Words[244] := 'LAST';
  Words[245] := 'SESSION';
  Words[246] := 'CLASS';
  Words[247] := 'LATERAL';
  Words[248] := 'SETS';
  Words[249] := 'CLOB';
  Words[250] := 'LEADING';
  Words[251] := 'SIZE';
  Words[252] := 'COLLATION';
  Words[253] := 'LESS';
  Words[254] := 'SMALLINT';
  Words[255] := 'COMPLETION';
  Words[256] := 'LEVEL';
  Words[257] := 'SPACE';
  Words[258] := 'CONNECT';
  Words[259] := 'LIMIT';
  Words[260] := 'SPECIFIC';
  Words[261] := 'CONNECTION';
  Words[262] := 'LOCAL';
  Words[263] := 'SPECIFICTYPE';
  Words[264] := 'CONSTRAINTS';
  Words[265] := 'LOCALTIME';
  Words[266] := 'SQL';
  Words[267] := 'CONSTRUCTOR';
  Words[268] := 'LOCALTIMESTAMP';
  Words[269] := 'SQLEXCEPTION';
  Words[270] := 'CORRESPONDING';
  Words[271] := 'LOCATOR';
  Words[272] := 'SQLSTATE';
  Words[273] := 'CUBE';
  Words[274] := 'MAP';
  Words[275] := 'SQLWARNING';
  Words[276] := 'CURRENT_PATH';
  Words[277] := 'MATCH';
  Words[278] := 'START';
  Words[279] := 'CURRENT_ROLE';
  Words[280] := 'MINUTE';
  Words[281] := 'STATE';
  Words[282] := 'CYCLE';
  Words[283] := 'MODIFIES';
  Words[284] := 'STATEMENT';
  Words[285] := 'DATA';
  Words[286] := 'MODIFY';
  Words[287] := 'STATIC';
  Words[288] := 'DATE';
  Words[289] := 'MODULE';
  Words[290] := 'STRUCTURE';
  Words[291] := 'DAY';
  Words[292] := 'MONTH';
  Words[293] := 'TEMPORARY';
  Words[294] := 'DEC';
  Words[295] := 'NAMES';
  Words[296] := 'TERMINATE';
  Words[297] := 'DECIMAL';
  Words[298] := 'NATURAL';
  Words[299] := 'THAN';
  Words[300] := 'DEFERRABLE';
  Words[301] := 'NCHAR';
  Words[302] := 'TIME';
  Words[303] := 'DEFERRED';
  Words[304] := 'NCLOB';
  Words[305] := 'TIMESTAMP';
  Words[306] := 'DEPTH';
  Words[307] := 'NEW';
  Words[308] := 'TIMEZONE_HOUR';
  Words[309] := 'DEREF';
  Words[310] := 'NEXT';
  Words[311] := 'TIMEZONE_MINUTE';
  Words[312] := 'DESCRIBE';
  Words[313] := 'NO';
  Words[314] := 'TRAILING';
  Words[315] := 'DESCRIPTOR';
  Words[316] := 'NONE';
  Words[317] := 'TRANSLATION';
  Words[318] := 'DESTROY';
  Words[319] := 'NUMERIC';
  Words[320] := 'TREAT';
  Words[321] := 'DESTRUCTOR';
  Words[322] := 'OBJECT';
  Words[323] := 'TRUE';
  Words[324] := 'DETERMINISTIC';
  Words[325] := 'OLD';
  Words[326] := 'UNDER';
  Words[327] := 'DICTIONARY';
  Words[328] := 'ONLY';
  Words[329] := 'UNKNOWN';
  Words[330] := 'DIAGNOSTICS';
  Words[331] := 'OPERATION';
  Words[332] := 'UNNEST';
  Words[333] := 'DISCONNECT';
  Words[334] := 'ORDINALITY';
  Words[335] := 'USAGE';
  Words[336] := 'DOMAIN';
  Words[337] := 'OUT';
  Words[338] := 'USING';
  Words[339] := 'DYNAMIC';
  Words[340] := 'OUTPUT';
  Words[341] := 'VALUE';
  Words[342] := 'EACH';
  Words[343] := 'PAD';
  Words[344] := 'VARCHAR';
  Words[345] := 'END-EXEC';
  Words[346] := 'PARAMETER';
  Words[347] := 'VARIABLE';
  Words[348] := 'EQUALS';
  Words[349] := 'PARAMETERS';
  Words[350] := 'WHENEVER';
  Words[351] := 'EVERY';
  Words[352] := 'PARTIAL';
  Words[353] := 'WITHOUT';
  Words[354] := 'EXCEPTION';
  Words[355] := 'PATH';
  Words[356] := 'WORK';
  Words[357] := 'EXTERNAL';
  Words[358] := 'POSTFIX';
  Words[359] := 'WRITE';
  Words[360] := 'FALSE';
  Words[361] := 'PREFIX';
  Words[362] := 'YEAR';
  Words[363] := 'FIRST';
  Words[364] := 'PREORDER';
  Words[365] := 'ZONE';
  Words[366] := 'FLOAT';
  Words[367] := 'PREPARE';
  Words[368] := 'ADA';
  Words[369] := 'AVG';
  Words[370] := 'BIT_LENGTH';
  Words[371] := 'CHAR_LENGTH';
  Words[372] := 'CHARACTER_LENGTH';
  Words[373] := 'COUNT';
  Words[374] := 'EXTRACT';
  Words[375] := 'FORTRAN';
  Words[376] := 'INCLUDE';
  Words[377] := 'INSENSITIVE';
  Words[378] := 'LOWER';
  Words[379] := 'MAX';
  Words[380] := 'MIN';
  Words[381] := 'OCTET_LENGTH';
  Words[382] := 'OVERLAPS';
  Words[383] := 'PASCAL';
  Words[384] := 'POSITION';
  Words[385] := 'SQLCA';
  Words[386] := 'SQLCODE';
  Words[387] := 'SQLERROR';
  Words[388] := 'SUBSTRING';
  Words[389] := 'SUM';
  Words[390] := 'TRANSLATE';
  Words[391] := 'TRIM';
  Words[392] := 'UPPER';
  Result := Words;
end;

//function TDBXOpenODBCMetaDataReaderMSSQL.IsSPReturnCodeSupported: Boolean;
//begin
//  Result := True;
//end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlIdentifierQuotePrefix: UnicodeString;
begin
  Result := '[';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSqlIdentifierQuoteSuffix: UnicodeString;
begin
  Result := ']';
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'U'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'V'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSystemTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'S'
  else
    Result := inherited GetSystemTableType;
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSystemViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'V'
  else
    Result := inherited GetSystemViewType;
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetSynonymType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'SN'
  else
    Result := inherited GetSynonymType;
end;

function TDBXOpenODBCMetaDataReaderMSSQL.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,38);
  Types[0] := TDBXDataTypeDescription.Create('smallint', TDBXDataTypes.Int16Type, 5, 'smallint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[1] := TDBXDataTypeDescription.Create('int', TDBXDataTypes.Int32Type, 10, 'int', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[2] := TDBXDataTypeDescription.Create('real', TDBXDataTypes.SingleType, 7, 'real', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[3] := TDBXDataTypeDescription.Create('float', TDBXDataTypes.DoubleType, 53, 'float({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[4] := TDBXDataTypeDescription.Create('money', TDBXDataTypes.BcdType, 19, 'money', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[5] := TDBXDataTypeDescription.Create('smallmoney', TDBXDataTypes.BcdType, 10, 'smallmoney', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[6] := TDBXDataTypeDescription.Create('bit', TDBXDataTypes.BooleanType, 1, 'bit', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[7] := TDBXDataTypeDescription.Create('tinyint', TDBXDataTypes.UInt8Type, 3, 'tinyint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
  Types[8] := TDBXDataTypeDescription.Create('bigint', TDBXDataTypes.Int64Type, 19, 'bigint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[9] := TDBXDataTypeDescription.Create('timestamp', TDBXDataTypes.VarBytesType, 8, 'timestamp', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable or TDBXTypeFlag.ConcurrencyType);
  Types[10] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 8000, 'binary({0})', 'Precision', -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[11] := TDBXDataTypeDescription.Create('image', TDBXDataTypes.BlobType, 2147483647, 'image', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[12] := TDBXDataTypeDescription.Create('text', TDBXDataTypes.AnsiStringType, 2147483647, 'text', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[13] := TDBXDataTypeDescription.Create('ntext', TDBXDataTypes.WideStringType, 1073741823, 'ntext', NullString, -1, -1, 'N''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[14] := TDBXDataTypeDescription.Create('decimal', TDBXDataTypes.BcdType, 38, 'decimal({0}, {1})', 'Precision, Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[15] := TDBXDataTypeDescription.Create('numeric', TDBXDataTypes.BcdType, 38, 'numeric({0}, {1})', 'Precision, Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[16] := TDBXDataTypeDescription.Create('datetime', TDBXDataTypes.TimeStampType, 23, 'datetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[17] := TDBXDataTypeDescription.Create('smalldatetime', TDBXDataTypes.TimeStampType, 16, 'smalldatetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[18] := TDBXDataTypeDescription.Create('sql_variant', TDBXDataTypes.ObjectType, 0, 'sql_variant', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[19] := TDBXDataTypeDescription.Create('xml', TDBXDataTypes.WideStringType, 2147483647, 'xml', NullString, -1, -1, NullString, NullString, NullString, '09.00.0000', TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[20] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 8000, 'varchar({0})', 'Precision', -1, -1, '''', '''', '08.99.9999', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[21] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 2147483647, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, '09.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[22] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 8000, 'char({0})', 'Precision', -1, -1, '''', '''', '08.99.9999', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[23] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 2147483647, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, '09.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[24] := TDBXDataTypeDescription.Create('nchar', TDBXDataTypes.WideStringType, 4000, 'nchar({0})', 'Precision', -1, -1, 'N''', '''', '08.99.9999', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[25] := TDBXDataTypeDescription.Create('nchar', TDBXDataTypes.WideStringType, 1073741823, 'nchar({0})', 'Precision', -1, -1, 'N''', '''', NullString, '09.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[26] := TDBXDataTypeDescription.Create('nvarchar', TDBXDataTypes.WideStringType, 4000, 'nvarchar({0})', 'Precision', -1, -1, 'N''', '''', '08.99.9999', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[27] := TDBXDataTypeDescription.Create('nvarchar', TDBXDataTypes.WideStringType, 1073741823, 'nvarchar({0})', 'Precision', -1, -1, 'N''', '''', NullString, '09.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[28] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 8000, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, '08.99.9999', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[29] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 1073741823, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '09.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[30] := TDBXDataTypeDescription.Create('uniqueidentifier', TDBXDataTypes.AnsiStringType, 16, 'uniqueidentifier', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[31] := TDBXDataTypeDescription.Create('date', TDBXDataTypes.DateType, 10, 'date', NullString, -1, -1, '''', '''', NullString, '10.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[32] := TDBXDataTypeDescription.Create('datetime2', TDBXDataTypes.TimeStampType, 27, 'datetime2', NullString, -1, -1, '{ts ''', '''}', NullString, '10.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[33] := TDBXDataTypeDescription.Create('datetimeoffset', TDBXDataTypes.TimeStampOffsetType, 34, 'datetimeoffset', NullString, -1, -1, '{ts ''', '''}', NullString, '10.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[34] := TDBXDataTypeDescription.Create('time', TDBXDataTypes.TimeType, 16, 'time', NullString, -1, -1, '''', '''', NullString, '10.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[35] := TDBXDataTypeDescription.Create('hierarchyid', TDBXDataTypes.VarBytesType, 892, 'hierarchyid', NullString, -1, -1, '0x', NullString, NullString, '10.00.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[36] := TDBXDataTypeDescription.Create('geometry', TDBXDataTypes.VarBytesType, 1073741823, 'geometry', NullString, -1, -1, '0x', NullString, NullString, '10.00.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[37] := TDBXDataTypeDescription.Create('geography', TDBXDataTypes.VarBytesType, 1073741823, 'geography', NullString, -1, -1, '0x', NullString, NullString, '10.00.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Result := Types;
end;

//
// MySQL
//

{ TDBXOpenODBCMetaDataCommandFactoryMySQL }

class function TDBXOpenODBCMetaDataCommandFactoryMySQL.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderMySQL;
end;

{ TDBXOpenODBCMetaDataReaderMySQL }

function TDBXOpenODBCMetaDataReaderMySQL.GetProductName: UnicodeString;
begin
  Result := 'MySQL';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlForTables: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, CAST(NULL AS CHAR(1)), TABLE_NAME, CASE TABLE_TYPE WHEN ''BASE TABLE'' THEN ''TABLE'' ELSE TABLE_TYPE END ' +
              'FROM INFORMATION_SCHEMA.TABLES ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (TABLE_TYPE IN (:TABLES,:VIEWS,:SYSTEM_VIEWS,:SYSTEM_TABLES)) ' +
              'ORDER BY 1,2,3'
  else
    //Result := 'SHOW TABLES';
    Result := '';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlForColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, CAST(NULL AS CHAR(1)), TABLE_NAME, COLUMN_NAME, DATA_TYPE, COALESCE(NUMERIC_PRECISION,CHARACTER_MAXIMUM_LENGTH), NUMERIC_SCALE, ORDINAL_POSITION, CAST(CASE WHEN COLUMN_DEFAULT IS NOT NULL AND COLUMN_DEFAULT <> ''CURRENT_TIMESTAMP'' AND ' + 'DATA_TYPE IN (''char'',''varchar'',''timestamp'',''datetime'',''date'',''time'',''year'') THEN CONCAT("''",COLUMN_DEFAULT,"''") ELSE COLUMN_DEFAULT END AS CHAR(255)), IS_NULLABLE=''YES'', LOCATE(''auto_increment'',EXTRA) > 0, -1, CHARACTER_SET_NAME, (LOCATE(''unsigned'',COLUMN' + '_TYPE) > 0) ' +
              'FROM INFORMATION_SCHEMA.COLUMNS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,ORDINAL_POSITION'
  else
    //Result := 'SHOW COLUMNS FROM :TABLE_NAME';
    Result := '';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlForIndexes: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, CAST(NULL AS CHAR(1)), TABLE_NAME, INDEX_NAME, CASE WHEN NON_UNIQUE = 0 THEN INDEX_NAME ELSE NULL END, INDEX_NAME=''PRIMARY'', NON_UNIQUE=0, 1=1 ' +
              'FROM INFORMATION_SCHEMA.STATISTICS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'GROUP BY 1, 2, 3 ,4 ' +
              'ORDER BY 1, 2, 3, 4'
  else
    //Result := 'SHOW INDEX FROM :TABLE_NAME';
    Result := '';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlForIndexColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, CAST(NULL AS CHAR(1)), TABLE_NAME, INDEX_NAME, COLUMN_NAME, SEQ_IN_INDEX, COLLATION=''A'' ' +
              'FROM INFORMATION_SCHEMA.STATISTICS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (INDEX_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4, SEQ_IN_INDEX'
  else
    //Result := 'SHOW INDEX FROM :TABLE_NAME';
    Result := '';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 225);
  Words[0] := 'ADD';
  Words[1] := 'ALL';
  Words[2] := 'ALTER';
  Words[3] := 'ANALYZE';
  Words[4] := 'AND';
  Words[5] := 'AS';
  Words[6] := 'ASC';
  Words[7] := 'ASENSITIVE';
  Words[8] := 'BEFORE';
  Words[9] := 'BETWEEN';
  Words[10] := 'BIGINT';
  Words[11] := 'BINARY';
  Words[12] := 'BLOB';
  Words[13] := 'BOTH';
  Words[14] := 'BY';
  Words[15] := 'CALL';
  Words[16] := 'CASCADE';
  Words[17] := 'CASE';
  Words[18] := 'CHANGE';
  Words[19] := 'CHAR';
  Words[20] := 'CHARACTER';
  Words[21] := 'CHECK';
  Words[22] := 'COLLATE';
  Words[23] := 'COLUMN';
  Words[24] := 'CONDITION';
  Words[25] := 'CONNECTION';
  Words[26] := 'CONSTRAINT';
  Words[27] := 'CONTINUE';
  Words[28] := 'CONVERT';
  Words[29] := 'CREATE';
  Words[30] := 'CROSS';
  Words[31] := 'CURRENT_DATE';
  Words[32] := 'CURRENT_TIME';
  Words[33] := 'CURRENT_TIMESTAMP';
  Words[34] := 'CURRENT_USER';
  Words[35] := 'CURSOR';
  Words[36] := 'DATABASE';
  Words[37] := 'DATABASES';
  Words[38] := 'DAY_HOUR';
  Words[39] := 'DAY_MICROSECOND';
  Words[40] := 'DAY_MINUTE';
  Words[41] := 'DAY_SECOND';
  Words[42] := 'DEC';
  Words[43] := 'DECIMAL';
  Words[44] := 'DECLARE';
  Words[45] := 'DEFAULT';
  Words[46] := 'DELAYED';
  Words[47] := 'DELETE';
  Words[48] := 'DESC';
  Words[49] := 'DESCRIBE';
  Words[50] := 'DETERMINISTIC';
  Words[51] := 'DISTINCT';
  Words[52] := 'DISTINCTROW';
  Words[53] := 'DIV';
  Words[54] := 'DOUBLE';
  Words[55] := 'DROP';
  Words[56] := 'DUAL';
  Words[57] := 'EACH';
  Words[58] := 'ELSE';
  Words[59] := 'ELSEIF';
  Words[60] := 'ENCLOSED';
  Words[61] := 'ESCAPED';
  Words[62] := 'EXISTS';
  Words[63] := 'EXIT';
  Words[64] := 'EXPLAIN';
  Words[65] := 'FALSE';
  Words[66] := 'FETCH';
  Words[67] := 'FLOAT';
  Words[68] := 'FLOAT4';
  Words[69] := 'FLOAT8';
  Words[70] := 'FOR';
  Words[71] := 'FORCE';
  Words[72] := 'FOREIGN';
  Words[73] := 'FROM';
  Words[74] := 'FULLTEXT';
  Words[75] := 'GOTO';
  Words[76] := 'GRANT';
  Words[77] := 'GROUP';
  Words[78] := 'HAVING';
  Words[79] := 'HIGH_PRIORITY';
  Words[80] := 'HOUR_MICROSECOND';
  Words[81] := 'HOUR_MINUTE';
  Words[82] := 'HOUR_SECOND';
  Words[83] := 'IF';
  Words[84] := 'IGNORE';
  Words[85] := 'IN';
  Words[86] := 'INDEX';
  Words[87] := 'INFILE';
  Words[88] := 'INNER';
  Words[89] := 'INOUT';
  Words[90] := 'INSENSITIVE';
  Words[91] := 'INSERT';
  Words[92] := 'INT';
  Words[93] := 'INT1';
  Words[94] := 'INT2';
  Words[95] := 'INT3';
  Words[96] := 'INT4';
  Words[97] := 'INT8';
  Words[98] := 'INTEGER';
  Words[99] := 'INTERVAL';
  Words[100] := 'INTO';
  Words[101] := 'IS';
  Words[102] := 'ITERATE';
  Words[103] := 'JOIN';
  Words[104] := 'KEY';
  Words[105] := 'KEYS';
  Words[106] := 'KILL';
  Words[107] := 'LABEL';
  Words[108] := 'LEADING';
  Words[109] := 'LEAVE';
  Words[110] := 'LEFT';
  Words[111] := 'LIKE';
  Words[112] := 'LIMIT';
  Words[113] := 'LINES';
  Words[114] := 'LOAD';
  Words[115] := 'LOCALTIME';
  Words[116] := 'LOCALTIMESTAMP';
  Words[117] := 'LOCK';
  Words[118] := 'LONG';
  Words[119] := 'LONGBLOB';
  Words[120] := 'LONGTEXT';
  Words[121] := 'LOOP';
  Words[122] := 'LOW_PRIORITY';
  Words[123] := 'MATCH';
  Words[124] := 'MEDIUMBLOB';
  Words[125] := 'MEDIUMINT';
  Words[126] := 'MEDIUMTEXT';
  Words[127] := 'MIDDLEINT';
  Words[128] := 'MINUTE_MICROSECOND';
  Words[129] := 'MINUTE_SECOND';
  Words[130] := 'MOD';
  Words[131] := 'MODIFIES';
  Words[132] := 'NATURAL';
  Words[133] := 'NO_WRITE_TO_BINLOG';
  Words[134] := 'NOT';
  Words[135] := 'NULL';
  Words[136] := 'NUMERIC';
  Words[137] := 'ON';
  Words[138] := 'OPTIMIZE';
  Words[139] := 'OPTION';
  Words[140] := 'OPTIONALLY';
  Words[141] := 'OR';
  Words[142] := 'ORDER';
  Words[143] := 'OUT';
  Words[144] := 'OUTER';
  Words[145] := 'OUTFILE';
  Words[146] := 'PRECISION';
  Words[147] := 'PRIMARY';
  Words[148] := 'PROCEDURE';
  Words[149] := 'PURGE';
  Words[150] := 'RAID0';
  Words[151] := 'READ';
  Words[152] := 'READS';
  Words[153] := 'REAL';
  Words[154] := 'REFERENCES';
  Words[155] := 'REGEXP';
  Words[156] := 'RELEASE';
  Words[157] := 'RENAME';
  Words[158] := 'REPEAT';
  Words[159] := 'REPLACE';
  Words[160] := 'REQUIRE';
  Words[161] := 'RESTRICT';
  Words[162] := 'RETURN';
  Words[163] := 'REVOKE';
  Words[164] := 'RIGHT';
  Words[165] := 'RLIKE';
  Words[166] := 'SCHEMA';
  Words[167] := 'SCHEMAS';
  Words[168] := 'SECOND_MICROSECOND';
  Words[169] := 'SELECT';
  Words[170] := 'SENSITIVE';
  Words[171] := 'SEPARATOR';
  Words[172] := 'SET';
  Words[173] := 'SHOW';
  Words[174] := 'SMALLINT';
  Words[175] := 'SONAME';
  Words[176] := 'SPATIAL';
  Words[177] := 'SPECIFIC';
  Words[178] := 'SQL';
  Words[179] := 'SQL_BIG_RESULT';
  Words[180] := 'SQL_CALC_FOUND_ROWS';
  Words[181] := 'SQL_SMALL_RESULT';
  Words[182] := 'SQLEXCEPTION';
  Words[183] := 'SQLSTATE';
  Words[184] := 'SQLWARNING';
  Words[185] := 'SSL';
  Words[186] := 'STARTING';
  Words[187] := 'STRAIGHT_JOIN';
  Words[188] := 'TABLE';
  Words[189] := 'TERMINATED';
  Words[190] := 'THEN';
  Words[191] := 'TINYBLOB';
  Words[192] := 'TINYINT';
  Words[193] := 'TINYTEXT';
  Words[194] := 'TO';
  Words[195] := 'TRAILING';
  Words[196] := 'TRIGGER';
  Words[197] := 'TRUE';
  Words[198] := 'UNDO';
  Words[199] := 'UNION';
  Words[200] := 'UNIQUE';
  Words[201] := 'UNLOCK';
  Words[202] := 'UNSIGNED';
  Words[203] := 'UPDATE';
  Words[204] := 'UPGRADE';
  Words[205] := 'USAGE';
  Words[206] := 'USE';
  Words[207] := 'USING';
  Words[208] := 'UTC_DATE';
  Words[209] := 'UTC_TIME';
  Words[210] := 'UTC_TIMESTAMP';
  Words[211] := 'VALUES';
  Words[212] := 'VARBINARY';
  Words[213] := 'VARCHAR';
  Words[214] := 'VARCHARACTER';
  Words[215] := 'VARYING';
  Words[216] := 'WHEN';
  Words[217] := 'WHERE';
  Words[218] := 'WHILE';
  Words[219] := 'WITH';
  Words[220] := 'WRITE';
  Words[221] := 'X509';
  Words[222] := 'XOR';
  Words[223] := 'YEAR_MONTH';
  Words[224] := 'ZEROFILL';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlIdentifierQuotePrefix: UnicodeString;
begin
  Result := '`';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlIdentifierQuoteSuffix: UnicodeString;
begin
  Result := '`';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetSqlIdentifierQuoteChar: UnicodeString;
begin
  Result := '`';
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'BASE TABLE'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderMySQL.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := False;
end;

function TDBXOpenODBCMetaDataReaderMySQL.IsUpperCaseIdentifiersSupported: Boolean;
begin
  Result := False;
end;

function TDBXOpenODBCMetaDataReaderMySQL.IsMultipleCommandsSupported: Boolean;
begin
  Result := False;
end;

procedure TDBXOpenODBCMetaDataReaderMySQL.SetContext(const Context: TDBXProviderContext);
begin
  inherited SetContext(Context);
  FDefaultCharSetIsUnicode := (Context.GetVendorProperty(DefaultCharsetIsUnicode) = 'true');
end;

procedure TDBXOpenODBCMetaDataReaderMySQL.PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Index: Integer;
  DataType: TDBXDataTypeDescription;
begin
  if FDefaultCharSetIsUnicode or (CompareVersion('05.00.0000') >= 0) then
    for Index := 0 to Length(Descr) - 1 do
    begin
      DataType := Descr[Index];
      if (DataType.DbxDataType = TDBXDataTypes.AnsiStringType) or (DataType.DbxDataType = TDBXDataTypes.WideStringType) then
        DataType.UnicodeOptionSupported := True;
    end;
  inherited PopulateDataTypes(Hash, Types, Descr);
end;

function TDBXOpenODBCMetaDataReaderMySQL.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  StringType: Integer;
  Types: TDBXDataTypeDescriptionArray;
begin
  StringType := TDBXDataTypes.AnsiStringType;
  if FDefaultCharSetIsUnicode then
    StringType := TDBXDataTypes.WideStringType;
  SetLength(Types,32);
  Types[0] := TDBXDataTypeDescription.Create('tinyint', TDBXDataTypes.Int8Type, 3, 'tinyint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[1] := TDBXDataTypeDescription.Create('smallint', TDBXDataTypes.Int16Type, 5, 'smallint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[2] := TDBXDataTypeDescription.Create('int', TDBXDataTypes.Int32Type, 10, 'int', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[3] := TDBXDataTypeDescription.Create('mediumint', TDBXDataTypes.Int64Type, 19, 'mediumint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[4] := TDBXDataTypeDescription.Create('bigint', TDBXDataTypes.Int64Type, 19, 'bigint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[5] := TDBXDataTypeDescription.Create('float', TDBXDataTypes.SingleType, 23, 'float', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[6] := TDBXDataTypeDescription.Create('double', TDBXDataTypes.DoubleType, 53, 'double', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[7] := TDBXDataTypeDescription.Create('decimal', TDBXDataTypes.BcdType, 64, 'decimal({0}, {1})', 'Precision, Scale', 64, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[8] := TDBXDataTypeDescription.Create('numeric', TDBXDataTypes.BcdType, 64, 'numeric({0}, {1})', 'Precision, Scale', 64, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[9] := TDBXDataTypeDescription.Create('timestamp', TDBXDataTypes.TimeStampType, 4, 'timestamp', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable or TDBXTypeFlag.ConcurrencyType);
  Types[10] := TDBXDataTypeDescription.Create('datetime', TDBXDataTypes.TimeStampType, 8, 'datetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[11] := TDBXDataTypeDescription.Create('date', TDBXDataTypes.DateType, 3, 'date', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[12] := TDBXDataTypeDescription.Create('time', TDBXDataTypes.TimeType, 3, 'time', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[13] := TDBXDataTypeDescription.Create('year', TDBXDataTypes.Int32Type, 1, 'year', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[14] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 255, 'binary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '05.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[15] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 254, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, '05.00.0002', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[16] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 65533, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '05.00.0003', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[17] := TDBXDataTypeDescription.Create('char', StringType, 255, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, '05.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[18] := TDBXDataTypeDescription.Create('varchar', StringType, 254, 'varchar({0})', 'Precision', -1, -1, '''', '''', '05.00.0002', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[19] := TDBXDataTypeDescription.Create('varchar', StringType, 65533, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, '05.00.0003', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[20] := TDBXDataTypeDescription.Create('tinytext', StringType, 254, 'tinytext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[21] := TDBXDataTypeDescription.Create('text', StringType, 65533, 'text', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[22] := TDBXDataTypeDescription.Create('mediumtext', StringType, 16777212, 'mediumtext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[23] := TDBXDataTypeDescription.Create('longtext', StringType, 4294967291, 'longtext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[24] := TDBXDataTypeDescription.Create('tinyblob', TDBXDataTypes.BlobType, 254, 'tinyblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[25] := TDBXDataTypeDescription.Create('blob', TDBXDataTypes.BlobType, 65533, 'blob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[26] := TDBXDataTypeDescription.Create('mediumblob', TDBXDataTypes.BlobType, 16777212, 'mediumblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[27] := TDBXDataTypeDescription.Create('longblob', TDBXDataTypes.BlobType, 4294967291, 'longblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[28] := TDBXDataTypeDescription.Create('bool', TDBXDataTypes.BooleanType, 1, 'bool', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[29] := TDBXDataTypeDescription.Create('enum', StringType, 65535, 'enum', NullString, -1, -1, '''', '''', NullString, '05.00.0003', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[30] := TDBXDataTypeDescription.Create('set', StringType, 64, 'set', NullString, -1, -1, '''', '''', NullString, '05.00.0003', TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[31] := TDBXDataTypeDescription.Create('bit', TDBXDataTypes.VarBytesType, 8, 'bit({0})', 'Precision', -1, -1, NullString, NullString, NullString, '05.00.0003', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Result := Types;
end;

//
// SybaseASA
//

{ TDBXOpenODBCMetaDataCommandFactorySybaseASA }

class function TDBXOpenODBCMetaDataCommandFactorySybaseASA.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderSybaseASA;
end;

{ TDBXOpenODBCMetaDataReaderSybaseASA }

function TDBXOpenODBCMetaDataReaderSybaseASA.GetProductName: UnicodeString;
begin
  Result := 'Adaptive Server Anywhere';
end;

procedure TDBXOpenODBCMetaDataReaderSybaseASA.SetContext(const Context: TDBXProviderContext);
begin
  inherited SetContext(Context);
  FSupportsNLSDataType := (Context.GetVendorProperty(SupportsNLSDataTypePropertyName) = 'true');
  FIsServerCharsetUTF8 := (Context.GetVendorProperty(IsServerCharsetUTF8PropertyName) = 'true');
  FIsCharUnicode := (Context.GetVendorProperty(IsCharUnicodePropertyName) = 'true');
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(CREATOR), TABLE_NAME, CASE WHEN USER_NAME(CREATOR) = ''SYS'' OR USER_NAME(CREATOR) = ''rs_systabgroup'' THEN ''SYSTEM '' ELSE '''' END || CASE TABLE_TYPE WHEN ''BASE'' THEN ''TABLE'' ELSE ''VIEW'' END ' +
            'FROM SYS.SYSTABLE ' +
            'WHERE TABLE_TYPE IN (''BASE'',''VIEW'') ' +
            ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND (TABLE_TYPE=CASE WHEN USER_NAME(CREATOR) = ''SYS'' OR USER_NAME(CREATOR) = ''rs_systabgroup'' THEN :SYSTEM_TABLES ELSE :TABLES END OR TABLE_TYPE=CASE WHEN USER_NAME(CREATOR) = ''SYS'' OR USER_NAME(CREATOR) = ''rs_systabgroup'' THEN :SYSTEM_VIEWS ELSE :VIEWS ' + 'END) ' +
            'ORDER BY 1,2,3';
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, C.COLUMN_NAME, D.DOMAIN_NAME, C.WIDTH, C.SCALE, C.COLUMN_ID, CASE WHEN C."DEFAULT" = ''autoincrement'' THEN NULL ELSE C."DEFAULT" END, CASE WHEN C.NULLS=''Y'' THEN 1 ELSE 0 END, CASE WHEN C."DEFAULT"=''auto' + 'increment'' THEN 1 ELSE 0 END, NULL ' +
            'FROM SYS.SYSCOLUMN C, SYS.SYSTABLE T, SYS.SYSDOMAIN D ' +
            'WHERE C.TABLE_ID=T.TABLE_ID AND C.DOMAIN_ID=D.DOMAIN_ID ' +
            ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 1,2,3,C.COLUMN_ID';
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSqlForIndexes: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '10.00.0000' then
    Result := 'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, I.INDEX_NAME, C.CONSTRAINT_NAME, CASE I.INDEX_CATEGORY WHEN 1 THEN 1 ELSE 0 END, CASE WHEN I."UNIQUE" IN (1,2) THEN 1 ELSE 0 END, 1 ' +
              'FROM SYS.SYSIDX I JOIN SYS.SYSTAB T ON I.TABLE_ID=T.TABLE_ID LEFT OUTER JOIN SYS.SYSCONSTRAINT C ON C.TABLE_OBJECT_ID=T.OBJECT_ID AND C.REF_OBJECT_ID=I.OBJECT_ID ' +
              'WHERE I.TABLE_ID=T.TABLE_ID AND I.INDEX_CATEGORY IN (1,3) ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,4'
  else
    Result := 'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, I.INDEX_NAME, C.CONSTRAINT_NAME, 0, CASE WHEN I."UNIQUE" IN (''Y'',''U'') THEN 1 ELSE 0 END, 1 ' +
              'FROM SYS.SYSINDEX I LEFT OUTER JOIN SYS.SYSCONSTRAINT C ON C.TABLE_ID=I.TABLE_ID AND C.INDEX_ID=I.INDEX_ID, SYS.SYSTABLE T ' +
              'WHERE I.TABLE_ID=T.TABLE_ID ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'UNION ALL ' +
              'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, C.CONSTRAINT_NAME, C.CONSTRAINT_NAME, 1, 1, 1 ' +
              'FROM SYS.SYSCONSTRAINT C, SYS.SYSTABLE T ' +
              'WHERE C.TABLE_ID=T.TABLE_ID AND C.CONSTRAINT_TYPE=''P'' ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,4';
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSqlForIndexColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '10.00.0000' then
    Result := 'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, I.INDEX_NAME, C.COLUMN_NAME, IC.SEQUENCE+1, CASE WHEN IC."ORDER"=''A'' THEN 1 ELSE 0 END ' +
              'FROM SYS.SYSIDXCOL IC, SYS.SYSIDX I, SYS.SYSTABCOL C, SYS.SYSTAB T ' +
              'WHERE IC.TABLE_ID=I.TABLE_ID AND IC.INDEX_ID=I.INDEX_ID AND IC.TABLE_ID=T.TABLE_ID AND C.COLUMN_ID=IC.COLUMN_ID AND C.TABLE_ID=T.TABLE_ID  AND I.INDEX_CATEGORY IN (1,3) ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (I.INDEX_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,4,6'
  else
    Result := 'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, I.INDEX_NAME, C.COLUMN_NAME, IC.SEQUENCE+1, CASE WHEN IC."ORDER"=''A'' THEN 1 ELSE 0 END ' +
              'FROM SYS.SYSIXCOL IC, SYS.SYSINDEX I, SYS.SYSCOLUMN C, SYS.SYSTABLE T ' +
              'WHERE IC.TABLE_ID=I.TABLE_ID AND IC.INDEX_ID=I.INDEX_ID AND IC.TABLE_ID=T.TABLE_ID AND C.COLUMN_ID=IC.COLUMN_ID AND C.TABLE_ID=T.TABLE_ID ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (I.INDEX_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'UNION ALL ' +
              'SELECT DB_NAME(), USER_NAME(T.CREATOR), T.TABLE_NAME, SC.CONSTRAINT_NAME, C.COLUMN_NAME, C.COLUMN_ID, 1 ' +
              'FROM SYS.SYSCOLUMN C, SYS.SYSTABLE T, SYS.SYSCONSTRAINT SC ' +
              'WHERE C.TABLE_ID=T.TABLE_ID AND T.TABLE_ID=SC.TABLE_ID AND SC.CONSTRAINT_TYPE=''P'' AND C.PKEY=''Y'' ' +
              ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(T.CREATOR) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (SC.CONSTRAINT_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,4,6';
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 223);
  Words[0] := 'add';
  Words[1] := 'all';
  Words[2] := 'alter';
  Words[3] := 'and';
  Words[4] := 'any';
  Words[5] := 'as';
  Words[6] := 'asc';
  Words[7] := 'backup';
  Words[8] := 'begin';
  Words[9] := 'between';
  Words[10] := 'bigint';
  Words[11] := 'binary';
  Words[12] := 'bit';
  Words[13] := 'bottom';
  Words[14] := 'break';
  Words[15] := 'by';
  Words[16] := 'call';
  Words[17] := 'capability';
  Words[18] := 'cascade';
  Words[19] := 'case';
  Words[20] := 'cast';
  Words[21] := 'char';
  Words[22] := 'char_convert';
  Words[23] := 'character';
  Words[24] := 'check';
  Words[25] := 'checkpoint';
  Words[26] := 'close';
  Words[27] := 'comment';
  Words[28] := 'commit';
  Words[29] := 'connect';
  Words[30] := 'constraint';
  Words[31] := 'contains';
  Words[32] := 'continue';
  Words[33] := 'convert';
  Words[34] := 'create';
  Words[35] := 'cross';
  Words[36] := 'cube';
  Words[37] := 'current';
  Words[38] := 'current_timestamp';
  Words[39] := 'current_user';
  Words[40] := 'cursor';
  Words[41] := 'date';
  Words[42] := 'dbspace';
  Words[43] := 'deallocate';
  Words[44] := 'dec';
  Words[45] := 'decimal';
  Words[46] := 'declare';
  Words[47] := 'default';
  Words[48] := 'delete';
  Words[49] := 'deleting';
  Words[50] := 'desc';
  Words[51] := 'distinct';
  Words[52] := 'do';
  Words[53] := 'double';
  Words[54] := 'drop';
  Words[55] := 'dynamic';
  Words[56] := 'else';
  Words[57] := 'elseif';
  Words[58] := 'encrypted';
  Words[59] := 'end';
  Words[60] := 'endif';
  Words[61] := 'escape';
  Words[62] := 'except';
  Words[63] := 'exception';
  Words[64] := 'exec';
  Words[65] := 'execute';
  Words[66] := 'existing';
  Words[67] := 'exists';
  Words[68] := 'externlogin';
  Words[69] := 'fetch';
  Words[70] := 'first';
  Words[71] := 'float';
  Words[72] := 'for';
  Words[73] := 'force';
  Words[74] := 'foreign';
  Words[75] := 'forward';
  Words[76] := 'from';
  Words[77] := 'full';
  Words[78] := 'goto';
  Words[79] := 'grant';
  Words[80] := 'group';
  Words[81] := 'having';
  Words[82] := 'holdlock';
  Words[83] := 'identified';
  Words[84] := 'if';
  Words[85] := 'in';
  Words[86] := 'index';
  Words[87] := 'index_lparen';
  Words[88] := 'inner';
  Words[89] := 'inout';
  Words[90] := 'insensitive';
  Words[91] := 'insert';
  Words[92] := 'inserting';
  Words[93] := 'install';
  Words[94] := 'instead';
  Words[95] := 'int';
  Words[96] := 'integer';
  Words[97] := 'integrated';
  Words[98] := 'intersect';
  Words[99] := 'into';
  Words[100] := 'iq';
  Words[101] := 'is';
  Words[102] := 'isolation';
  Words[103] := 'join';
  Words[104] := 'key';
  Words[105] := 'lateral';
  Words[106] := 'left';
  Words[107] := 'like';
  Words[108] := 'lock';
  Words[109] := 'login';
  Words[110] := 'long';
  Words[111] := 'match';
  Words[112] := 'membership';
  Words[113] := 'message';
  Words[114] := 'mode';
  Words[115] := 'modify';
  Words[116] := 'natural';
  Words[117] := 'new';
  Words[118] := 'no';
  Words[119] := 'noholdlock';
  Words[120] := 'not';
  Words[121] := 'notify';
  Words[122] := 'null';
  Words[123] := 'numeric';
  Words[124] := 'of';
  Words[125] := 'off';
  Words[126] := 'on';
  Words[127] := 'open';
  Words[128] := 'option';
  Words[129] := 'options';
  Words[130] := 'or';
  Words[131] := 'order';
  Words[132] := 'others';
  Words[133] := 'out';
  Words[134] := 'outer';
  Words[135] := 'over';
  Words[136] := 'passthrough';
  Words[137] := 'precision';
  Words[138] := 'prepare';
  Words[139] := 'primary';
  Words[140] := 'print';
  Words[141] := 'privileges';
  Words[142] := 'proc';
  Words[143] := 'procedure';
  Words[144] := 'publication';
  Words[145] := 'raiserror';
  Words[146] := 'readtext';
  Words[147] := 'real';
  Words[148] := 'reference';
  Words[149] := 'references';
  Words[150] := 'release';
  Words[151] := 'remote';
  Words[152] := 'remove';
  Words[153] := 'rename';
  Words[154] := 'reorganize';
  Words[155] := 'resource';
  Words[156] := 'restore';
  Words[157] := 'restrict';
  Words[158] := 'return';
  Words[159] := 'revoke';
  Words[160] := 'right';
  Words[161] := 'rollback';
  Words[162] := 'rollup';
  Words[163] := 'save';
  Words[164] := 'savepoint';
  Words[165] := 'scroll';
  Words[166] := 'select';
  Words[167] := 'sensitive';
  Words[168] := 'session';
  Words[169] := 'set';
  Words[170] := 'setuser';
  Words[171] := 'share';
  Words[172] := 'smallint';
  Words[173] := 'some';
  Words[174] := 'sqlcode';
  Words[175] := 'sqlstate';
  Words[176] := 'start';
  Words[177] := 'stop';
  Words[178] := 'subtrans';
  Words[179] := 'subtransaction';
  Words[180] := 'synchronize';
  Words[181] := 'syntax_error';
  Words[182] := 'table';
  Words[183] := 'temporary';
  Words[184] := 'then';
  Words[185] := 'time';
  Words[186] := 'timestamp';
  Words[187] := 'tinyint';
  Words[188] := 'to';
  Words[189] := 'top';
  Words[190] := 'tran';
  Words[191] := 'trigger';
  Words[192] := 'truncate';
  Words[193] := 'tsequal';
  Words[194] := 'unbounded';
  Words[195] := 'union';
  Words[196] := 'unique';
  Words[197] := 'unknown';
  Words[198] := 'unsigned';
  Words[199] := 'update';
  Words[200] := 'updating';
  Words[201] := 'user';
  Words[202] := 'using';
  Words[203] := 'validate';
  Words[204] := 'values';
  Words[205] := 'varbinary';
  Words[206] := 'varchar';
  Words[207] := 'variable';
  Words[208] := 'varying';
  Words[209] := 'view';
  Words[210] := 'wait';
  Words[211] := 'waitfor';
  Words[212] := 'when';
  Words[213] := 'where';
  Words[214] := 'while';
  Words[215] := 'window';
  Words[216] := 'with';
  Words[217] := 'with_cube';
  Words[218] := 'with_lparen';
  Words[219] := 'with_rollup';
  Words[220] := 'within';
  Words[221] := 'work';
  Words[222] := 'writetext';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'BASE'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'VIEW'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSystemTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'BASE'
  else
    Result := inherited GetSystemTableType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetSystemViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'VIEW'
  else
    Result := inherited GetSystemViewType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASA.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,23);
  Types[0] := TDBXDataTypeDescription.Create('bigint', TDBXDataTypes.Int64Type, 19, 'bigint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[1] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 32767, 'binary({0})', 'Precision', -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[2] := TDBXDataTypeDescription.Create('bit', TDBXDataTypes.BooleanType, 1, 'bit', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable);
  if IsCharUnicode then
    Types[3] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.WideStringType, 8191, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode)
  else
    Types[3] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 32767, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[4] := TDBXDataTypeDescription.Create('nchar', TDBXDataTypes.WideStringType, 8191, 'nchar({0})', 'Precision', -1, -1, '''', '''', NullString, '10.00.0000', TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[5] := TDBXDataTypeDescription.Create('date', TDBXDataTypes.DateType, 4, 'date', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[6] := TDBXDataTypeDescription.Create('decimal', TDBXDataTypes.BcdType, 38, 'decimal({0}, {1})', 'Precision,Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[7] := TDBXDataTypeDescription.Create('double', TDBXDataTypes.DoubleType, 53, 'double', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[8] := TDBXDataTypeDescription.Create('float', TDBXDataTypes.SingleType, 48, 'float({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[9] := TDBXDataTypeDescription.Create('integer', TDBXDataTypes.Int32Type, 10, 'integer', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[10] := TDBXDataTypeDescription.Create('long binary', TDBXDataTypes.BlobType, 2147483647, 'long binary', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  if IsCharUnicode then
    Types[11] := TDBXDataTypeDescription.Create('long varchar', TDBXDataTypes.WideStringType, 2147483647, 'long varchar', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode)
  else
    Types[11] := TDBXDataTypeDescription.Create('long varchar', TDBXDataTypes.AnsiStringType, 2147483647, 'long varchar', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[12] := TDBXDataTypeDescription.Create('long nvarchar', TDBXDataTypes.WideStringType, 2147483647, 'long nvarchar', NullString, -1, -1, '0x', NullString, NullString, '10.00.0000', TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[13] := TDBXDataTypeDescription.Create('numeric', TDBXDataTypes.BcdType, 38, 'numeric({0}, {1})', 'Precision,Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[14] := TDBXDataTypeDescription.Create('smallint', TDBXDataTypes.Int16Type, 5, 'smallint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[15] := TDBXDataTypeDescription.Create('time', TDBXDataTypes.TimeType, 8, 'time', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[16] := TDBXDataTypeDescription.Create('timestamp', TDBXDataTypes.TimeStampType, 8, 'timestamp', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[17] := TDBXDataTypeDescription.Create('tinyint', TDBXDataTypes.UInt8Type, 1, 'tinyint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
  Types[18] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 32767, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  if IsCharUnicode then
    Types[19] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.WideStringType, 8191, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode)
  else
    Types[19] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 32767, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[20] := TDBXDataTypeDescription.Create('nvarchar', TDBXDataTypes.WideStringType, 8191, 'nvarchar({0})', 'Precision', -1, -1, '''', '''', NullString, '10.00.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[21] := TDBXDataTypeDescription.Create('xml', TDBXDataTypes.WideStringType,  2147483647, 'xml', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[22] := TDBXDataTypeDescription.Create('TIMESTAMP WITH TIME ZONE', TDBXDataTypes.TimeStampOffsetType, 34, 'TIMESTAMP({0} WITH TIME ZONE)', 'Precision', -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Result := Types;
end;

//
// SybaseASE
//

{ TDBXOpenODBCMetaDataCommandFactorySybaseASE }

class function TDBXOpenODBCMetaDataCommandFactorySybaseASE.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderSybaseASE;
end;

{ TDBXOpenODBCMetaDataReaderSybaseASE }

function TDBXOpenODBCMetaDataReaderSybaseASE.GetProductName: UnicodeString;
begin
  Result := 'Sybase SQL Server';
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(uid), name, CASE WHEN type=''U'' THEN ''TABLE'' WHEN type=''V'' THEN ''VIEW'' ELSE ''SYSTEM TABLE'' END ' +
            'FROM  dbo.sysobjects ' +
            'WHERE type IN (''U'', ''V'', ''S'') ' +
            ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND  (type = :TABLES OR type = :VIEWS OR type = :SYSTEM_TABLES) ' +
            'ORDER BY 1, 2, 3';
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(o.uid), o.name, c.name, CASE WHEN t.name=''float'' THEN ''double precision'' ELSE t.name END, COALESCE(c.prec,c.length), c.scale, c.colid, CASE WHEN com.text LIKE ''DEFAULT  %'' THEN SUBSTRING(com.text,10,CHAR_LENGTH(com.text)-9) ELS' + 'E com.text END, c.status & 8, c.status & 128, NULL ' +
            'FROM dbo.sysobjects o INNER JOIN dbo.syscolumns c ON o.id=c.id INNER JOIN dbo.systypes t ON c.usertype = t.usertype LEFT OUTER JOIN dbo.syscomments com ON cdefault=com.id ' +
            'WHERE o.type IN (''U'',''V'',''S'') ' +
            ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(o.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (o.name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 1, 2, 3, c.colid';
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(o.uid), o.name, i.name, CASE WHEN status&2 > 0 THEN i.name ELSE NULL END, status&2048, status&2, 1 ' +
            'FROM dbo.sysobjects o, dbo.sysindexes i ' +
            'WHERE o.type IN (''U'',''S'') AND i.id = o.id and keycnt <> 0 ' +
            ' AND (DB_NAME() = :CATALOG_NAME or (:CATALOG_NAME IS NULL)) AND (USER_NAME(o.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (o.name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 1, 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT DB_NAME(), USER_NAME(o.uid), o.name, i.name, index_col(o.name, i.indid, cn.id, o.uid), cn.id, CASE WHEN index_colorder(o.name, i.indid, cn.id, o.uid) = ''ASC'' THEN 1 ELSE 0 END ' +
            'FROM dbo.sysobjects o, dbo.sysindexes i, dbo.sysobjects cn ' +
            'WHERE o.type IN (''U'',''S'') AND i.id = o.id AND cn.id > 0 AND cn.id <= i.keycnt - CASE WHEN i.indid=1 THEN 0 ELSE 1 END ' +
            ' AND (DB_NAME() = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (USER_NAME(o.uid) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (o.name = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (i.name = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
            'ORDER BY 1, 2, 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 322);
  Words[0] := 'absolute';
  Words[1] := 'action';
  Words[2] := 'add';
  Words[3] := 'all';
  Words[4] := 'allocate';
  Words[5] := 'alter';
  Words[6] := 'and';
  Words[7] := 'any';
  Words[8] := 'are';
  Words[9] := 'arith_overflow';
  Words[10] := 'as';
  Words[11] := 'asc';
  Words[12] := 'assertion';
  Words[13] := 'at';
  Words[14] := 'authorization';
  Words[15] := 'avg';
  Words[16] := 'begin';
  Words[17] := 'between';
  Words[18] := 'bit';
  Words[19] := 'bit_length';
  Words[20] := 'both';
  Words[21] := 'break';
  Words[22] := 'browse';
  Words[23] := 'bulk';
  Words[24] := 'by';
  Words[25] := 'cascade';
  Words[26] := 'cascaded';
  Words[27] := 'case';
  Words[28] := 'cast';
  Words[29] := 'catalog';
  Words[30] := 'char';
  Words[31] := 'char_convert';
  Words[32] := 'char_length';
  Words[33] := 'character';
  Words[34] := 'character_length';
  Words[35] := 'check';
  Words[36] := 'checkpoint';
  Words[37] := 'close';
  Words[38] := 'clustered';
  Words[39] := 'coalesce';
  Words[40] := 'collate';
  Words[41] := 'collation';
  Words[42] := 'column';
  Words[43] := 'commit';
  Words[44] := 'compute';
  Words[45] := 'confirm';
  Words[46] := 'connect';
  Words[47] := 'connection';
  Words[48] := 'constraint';
  Words[49] := 'constraints';
  Words[50] := 'continue';
  Words[51] := 'controlrow';
  Words[52] := 'convert';
  Words[53] := 'corresponding';
  Words[54] := 'count';
  Words[55] := 'create';
  Words[56] := 'cross';
  Words[57] := 'current';
  Words[58] := 'current_date';
  Words[59] := 'current_time';
  Words[60] := 'current_timestamp';
  Words[61] := 'current_user';
  Words[62] := 'cursor';
  Words[63] := 'database';
  Words[64] := 'date';
  Words[65] := 'day';
  Words[66] := 'dbcc';
  Words[67] := 'deallocate';
  Words[68] := 'dec';
  Words[69] := 'decimal';
  Words[70] := 'declare';
  Words[71] := 'default';
  Words[72] := 'deferrable';
  Words[73] := 'deferred';
  Words[74] := 'delete';
  Words[75] := 'desc';
  Words[76] := 'describe';
  Words[77] := 'descriptor';
  Words[78] := 'deterministic';
  Words[79] := 'diagnostics';
  Words[80] := 'disconnect';
  Words[81] := 'disk';
  Words[82] := 'distinct';
  Words[83] := 'domain';
  Words[84] := 'double';
  Words[85] := 'drop';
  Words[86] := 'dummy';
  Words[87] := 'dump';
  Words[88] := 'else';
  Words[89] := 'end';
  Words[90] := 'end-exec';
  Words[91] := 'endtran';
  Words[92] := 'errlvl';
  Words[93] := 'errordata';
  Words[94] := 'errorexit';
  Words[95] := 'escape';
  Words[96] := 'except';
  Words[97] := 'exception';
  Words[98] := 'exclusive';
  Words[99] := 'exec';
  Words[100] := 'execute';
  Words[101] := 'exists';
  Words[102] := 'exit';
  Words[103] := 'exp_row_size';
  Words[104] := 'external';
  Words[105] := 'extract';
  Words[106] := 'false';
  Words[107] := 'fetch';
  Words[108] := 'fillfactor';
  Words[109] := 'first';
  Words[110] := 'float';
  Words[111] := 'for';
  Words[112] := 'foreign';
  Words[113] := 'found';
  Words[114] := 'from';
  Words[115] := 'full';
  Words[116] := 'func';
  Words[117] := 'get';
  Words[118] := 'global';
  Words[119] := 'go';
  Words[120] := 'goto';
  Words[121] := 'grant';
  Words[122] := 'group';
  Words[123] := 'having';
  Words[124] := 'holdlock';
  Words[125] := 'hour';
  Words[126] := 'identity';
  Words[127] := 'identity_gap';
  Words[128] := 'identity_insert';
  Words[129] := 'identity_start';
  Words[130] := 'if';
  Words[131] := 'immediate';
  Words[132] := 'in';
  Words[133] := 'index';
  Words[134] := 'indicator';
  Words[135] := 'initially';
  Words[136] := 'inner';
  Words[137] := 'inout';
  Words[138] := 'input';
  Words[139] := 'insensitive';
  Words[140] := 'insert';
  Words[141] := 'install';
  Words[142] := 'int';
  Words[143] := 'integer';
  Words[144] := 'intersect';
  Words[145] := 'interval';
  Words[146] := 'into';
  Words[147] := 'is';
  Words[148] := 'isolation';
  Words[149] := 'jar';
  Words[150] := 'join';
  Words[151] := 'key';
  Words[152] := 'kill';
  Words[153] := 'language';
  Words[154] := 'last';
  Words[155] := 'leading';
  Words[156] := 'left';
  Words[157] := 'level';
  Words[158] := 'like';
  Words[159] := 'lineno';
  Words[160] := 'load';
  Words[161] := 'local';
  Words[162] := 'lock';
  Words[163] := 'lower';
  Words[164] := 'match';
  Words[165] := 'max';
  Words[166] := 'max_rows_per_page';
  Words[167] := 'min';
  Words[168] := 'minute';
  Words[169] := 'mirror';
  Words[170] := 'mirrorexit';
  Words[171] := 'modify';
  Words[172] := 'module';
  Words[173] := 'month';
  Words[174] := 'names';
  Words[175] := 'national';
  Words[176] := 'natural';
  Words[177] := 'nchar';
  Words[178] := 'new';
  Words[179] := 'next';
  Words[180] := 'no';
  Words[181] := 'noholdlock';
  Words[182] := 'nonclustered';
  Words[183] := 'not';
  Words[184] := 'null';
  Words[185] := 'nullif';
  Words[186] := 'numeric';
  Words[187] := 'numeric_truncation';
  Words[188] := 'octet_length';
  Words[189] := 'of';
  Words[190] := 'off';
  Words[191] := 'offsets';
  Words[192] := 'on';
  Words[193] := 'once';
  Words[194] := 'online';
  Words[195] := 'only';
  Words[196] := 'open';
  Words[197] := 'option';
  Words[198] := 'or';
  Words[199] := 'order';
  Words[200] := 'out';
  Words[201] := 'outer';
  Words[202] := 'output';
  Words[203] := 'over';
  Words[204] := 'overlaps';
  Words[205] := 'pad';
  Words[206] := 'partial';
  Words[207] := 'partition';
  Words[208] := 'perm';
  Words[209] := 'permanent';
  Words[210] := 'plan';
  Words[211] := 'position';
  Words[212] := 'precision';
  Words[213] := 'prepare';
  Words[214] := 'preserve';
  Words[215] := 'primary';
  Words[216] := 'print';
  Words[217] := 'prior';
  Words[218] := 'privileges';
  Words[219] := 'proc';
  Words[220] := 'procedure';
  Words[221] := 'processexit';
  Words[222] := 'proxy_table';
  Words[223] := 'public';
  Words[224] := 'quiesce';
  Words[225] := 'raiserror';
  Words[226] := 'read';
  Words[227] := 'readpast';
  Words[228] := 'readtext';
  Words[229] := 'real';
  Words[230] := 'reconfigure';
  Words[231] := 'references remove';
  Words[232] := 'relative';
  Words[233] := 'reorg';
  Words[234] := 'replace';
  Words[235] := 'replication';
  Words[236] := 'reservepagegap';
  Words[237] := 'restrict';
  Words[238] := 'return';
  Words[239] := 'returns';
  Words[240] := 'revoke';
  Words[241] := 'right';
  Words[242] := 'role';
  Words[243] := 'rollback';
  Words[244] := 'rowcount';
  Words[245] := 'rows';
  Words[246] := 'rule';
  Words[247] := 'save';
  Words[248] := 'schema';
  Words[249] := 'scroll';
  Words[250] := 'second';
  Words[251] := 'section';
  Words[252] := 'select';
  Words[253] := 'session_user';
  Words[254] := 'set';
  Words[255] := 'setuser';
  Words[256] := 'shared';
  Words[257] := 'shutdown';
  Words[258] := 'size';
  Words[259] := 'smallint';
  Words[260] := 'some';
  Words[261] := 'space';
  Words[262] := 'sql';
  Words[263] := 'sqlcode';
  Words[264] := 'sqlerror';
  Words[265] := 'sqlstate';
  Words[266] := 'statistics';
  Words[267] := 'stringsize';
  Words[268] := 'stripe';
  Words[269] := 'substring';
  Words[270] := 'sum';
  Words[271] := 'syb_identity';
  Words[272] := 'syb_restree';
  Words[273] := 'syb_terminate';
  Words[274] := 'system_user';
  Words[275] := 'table';
  Words[276] := 'temp';
  Words[277] := 'temporary';
  Words[278] := 'textsize';
  Words[279] := 'then';
  Words[280] := 'time';
  Words[281] := 'timestamp';
  Words[282] := 'timezone_hour';
  Words[283] := 'timezone_minute';
  Words[284] := 'to';
  Words[285] := 'trailing';
  Words[286] := 'tran';
  Words[287] := 'transaction';
  Words[288] := 'translate';
  Words[289] := 'translation';
  Words[290] := 'trigger';
  Words[291] := 'trim';
  Words[292] := 'true';
  Words[293] := 'truncate';
  Words[294] := 'tsequal';
  Words[295] := 'union';
  Words[296] := 'unique';
  Words[297] := 'unknown';
  Words[298] := 'unpartition';
  Words[299] := 'update';
  Words[300] := 'upper';
  Words[301] := 'usage';
  Words[302] := 'use';
  Words[303] := 'user';
  Words[304] := 'user_option';
  Words[305] := 'using';
  Words[306] := 'value';
  Words[307] := 'values';
  Words[308] := 'varchar';
  Words[309] := 'varying';
  Words[310] := 'view';
  Words[311] := 'waitfor';
  Words[312] := 'when';
  Words[313] := 'whenever';
  Words[314] := 'where';
  Words[315] := 'while';
  Words[316] := 'with';
  Words[317] := 'work';
  Words[318] := 'write';
  Words[319] := 'writetext';
  Words[320] := 'year';
  Words[321] := 'zone';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'U'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'V'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetSystemTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'S'
  else
    Result := inherited GetSystemTableType;
end;

//function TDBXOpenODBCMetaDataReaderSybaseASE.IsNestedTransactionsSupported: Boolean;
//begin
//  Result := True;
//end;

function TDBXOpenODBCMetaDataReaderSybaseASE.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,29);
  Types[0] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 1960, 'binary({0})', 'Precision', -1, -1, '0x', NullString, '12.04.9999', NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[1] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 7960, 'binary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '12.05.0000', TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[2] := TDBXDataTypeDescription.Create('bit', TDBXDataTypes.BooleanType, 1, 'bit', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable);
  Types[3] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 1960, 'char({0})', 'Precision', -1, -1, '''', '''', '12.04.9999', NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[4] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 7960, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, '12.05.0000', TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[5] := TDBXDataTypeDescription.Create('datetime', TDBXDataTypes.TimeStampType, 23, 'datetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[6] := TDBXDataTypeDescription.Create('decimal', TDBXDataTypes.BcdType, 38, 'decimal({0}, {1})', 'Precision,Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[7] := TDBXDataTypeDescription.Create('double precision', TDBXDataTypes.DoubleType, 53, 'double precision', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[8] := TDBXDataTypeDescription.Create('image', TDBXDataTypes.BlobType, 2147483647, 'image', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[9] := TDBXDataTypeDescription.Create('int', TDBXDataTypes.Int32Type, 10, 'int', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[10] := TDBXDataTypeDescription.Create('money', TDBXDataTypes.BcdType, 19, 'money', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[11] := TDBXDataTypeDescription.Create('numeric', TDBXDataTypes.BcdType, 38, 'numeric({0}, {1})', 'Precision,Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[12] := TDBXDataTypeDescription.Create('unichar', TDBXDataTypes.WideStringType, 960, 'unichar({0})', 'Precision', -1, -1, 'N''', '''', '12.04.9999', NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[13] := TDBXDataTypeDescription.Create('unichar', TDBXDataTypes.WideStringType, 3960, 'unichar({0})', 'Precision', -1, -1, 'N''', '''', NullString, '12.05.0000', TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[14] := TDBXDataTypeDescription.Create('univarchar', TDBXDataTypes.WideStringType, 960, 'univarchar({0})', 'Precision', -1, -1, 'N''', '''', '12.04.9999', NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[15] := TDBXDataTypeDescription.Create('univarchar', TDBXDataTypes.WideStringType, 3960, 'univarchar({0})', 'Precision', -1, -1, 'N''', '''', NullString, '12.05.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unicode);
  Types[16] := TDBXDataTypeDescription.Create('real', TDBXDataTypes.SingleType, 7, 'real', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[17] := TDBXDataTypeDescription.Create('smalldatetime', TDBXDataTypes.TimeStampType, 16, 'smalldatetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[18] := TDBXDataTypeDescription.Create('smallint', TDBXDataTypes.Int16Type, 5, 'smallint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[19] := TDBXDataTypeDescription.Create('smallmoney', TDBXDataTypes.BcdType, 10, 'smallmoney', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[20] := TDBXDataTypeDescription.Create('sysname', TDBXDataTypes.AnsiStringType, 30, 'sysname', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[21] := TDBXDataTypeDescription.Create('text', TDBXDataTypes.AnsiStringType, 2147483647, 'text', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[22] := TDBXDataTypeDescription.Create('unitext', TDBXDataTypes.WideStringType, 1073741823, 'unitext', NullString, -1, -1, '''', '''', NullString, '15.00.0000', TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Unicode);
  Types[23] := TDBXDataTypeDescription.Create('timestamp', TDBXDataTypes.BytesType, 8, 'timestamp', NullString, -1, -1, '0x', NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable);
  Types[24] := TDBXDataTypeDescription.Create('tinyint', TDBXDataTypes.UInt8Type, 3, 'tinyint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
  Types[25] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 1960, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, '12.04.9999', NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[26] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarBytesType, 7960, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '12.05.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[27] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 1960, 'varchar({0})', 'Precision', -1, -1, '''', '''', '12.04.9999', NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[28] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 7960, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, '12.05.0000', TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Result := Types;
end;

//
// DB2
//

{ TDBXOpenODBCMetaDataCommandFactoryDB2 }

class function TDBXOpenODBCMetaDataCommandFactoryDB2.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderDB2;
end;

{ TDBXOpenODBCMetaDataReaderDB2 }

function TDBXOpenODBCMetaDataReaderDB2.GetProductName: UnicodeString;
begin
  Result := 'Db2';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), TABSCHEMA, TABNAME, CASE WHEN TABSCHEMA IN (''SYSIBM'',''SYSCAT'',''SYSSTAT'') THEN ''SYSTEM '' ELSE '''' END || CASE TYPE WHEN ''T'' THEN ''TABLE'' ELSE ''VIEW'' END ' +
            'FROM SYSCAT.TABLES ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(TABSCHEMA) = LOWER(CAST(:SCHEMA_NAME AS VARCHAR(128))) OR (:SCHEMA_NAME IS NULL)) AND (TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND (TYPE IN (''T'',''V'')) ' +
            ' AND (TYPE=CASE WHEN TABSCHEMA IN (''SYSIBM'',''SYSCAT'',''SYSSTAT'') THEN CAST(:SYSTEM_TABLES AS VARCHAR(12)) ELSE CAST(:TABLES AS VARCHAR(12)) END OR TYPE=CASE WHEN TABSCHEMA IN (''SYSIBM'',''SYSCAT'',''SYSSTAT'') THEN CAST(:SYSTEM_VIEWS AS VARCHAR(12)) ELSE CAST(:' + 'VIEWS AS VARCHAR(12)) END) ' +
            'ORDER BY 2,3';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), TABSCHEMA, TABNAME, COLNAME, TYPENAME, LENGTH, SCALE, COLNO+1, DEFAULT, CASE WHEN NULLS=''Y'' THEN 1 ELSE 0 END, CASE WHEN IDENTITY=''Y'' THEN 1 ELSE 0 END, CAST(NULL AS INTEGER) ' +
            'FROM SYSCAT.COLUMNS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(TABSCHEMA) = LOWER(CAST(:SCHEMA_NAME AS VARCHAR(128))) OR (:SCHEMA_NAME IS NULL)) AND (TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, COLNO';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), TABSCHEMA, TABNAME, INDNAME, CASE WHEN USER_DEFINED=1 THEN CAST(NULL AS VARCHAR(1)) ELSE INDNAME END, CASE WHEN UNIQUERULE=''P'' THEN 1 ELSE 0 END, CASE WHEN UNIQUERULE=''D'' THEN 0 ELSE 1 END, 1 ' +
            'FROM SYSCAT.INDEXES ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(TABSCHEMA) = LOWER(CAST(:SCHEMA_NAME AS VARCHAR(128))) OR (:SCHEMA_NAME IS NULL)) AND (TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), I.TABSCHEMA, I.TABNAME, I.INDNAME, C.COLNAME, C.COLSEQ, CASE WHEN COLORDER=''A'' THEN 1 WHEN COLORDER=''D'' THEN 0 ELSE CAST (NULL AS INTEGER) END ' +
            'FROM SYSCAT.INDEXES I, SYSCAT.INDEXCOLUSE C ' +
            'WHERE I.INDSCHEMA = C.INDSCHEMA AND I.INDNAME = C.INDNAME ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(I.TABSCHEMA) = LOWER(CAST(:SCHEMA_NAME AS VARCHAR(128))) OR (:SCHEMA_NAME IS NULL)) AND (I.TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (I.INDNAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 310);
  Words[0] := 'ADD';
  Words[1] := 'AFTER';
  Words[2] := 'ALIAS';
  Words[3] := 'ALL';
  Words[4] := 'ALLOCATE';
  Words[5] := 'ALLOW';
  Words[6] := 'ALTER';
  Words[7] := 'AND';
  Words[8] := 'ANY';
  Words[9] := 'APPLICATION';
  Words[10] := 'AS';
  Words[11] := 'ASSOCIATE';
  Words[12] := 'ASUTIME';
  Words[13] := 'AUDIT';
  Words[14] := 'AUTHORIZATION';
  Words[15] := 'AUX';
  Words[16] := 'AUXILIARY';
  Words[17] := 'BEFORE';
  Words[18] := 'BEGIN';
  Words[19] := 'BETWEEN';
  Words[20] := 'BINARY';
  Words[21] := 'BUFFERPOOL';
  Words[22] := 'BY';
  Words[23] := 'CACHE';
  Words[24] := 'CALL';
  Words[25] := 'CALLED';
  Words[26] := 'CAPTURE';
  Words[27] := 'CARDINALITY';
  Words[28] := 'CASCADED';
  Words[29] := 'CASE';
  Words[30] := 'CAST';
  Words[31] := 'CCSID';
  Words[32] := 'CHAR';
  Words[33] := 'CHARACTER';
  Words[34] := 'CHECK';
  Words[35] := 'CLOSE';
  Words[36] := 'CLUSTER';
  Words[37] := 'COLLECTION';
  Words[38] := 'COLLID';
  Words[39] := 'COLUMN';
  Words[40] := 'COMMENT';
  Words[41] := 'COMMIT';
  Words[42] := 'CONCAT';
  Words[43] := 'CONDITION';
  Words[44] := 'CONNECT';
  Words[45] := 'CONNECTION';
  Words[46] := 'CONSTRAINT';
  Words[47] := 'CONTAINS';
  Words[48] := 'CONTINUE';
  Words[49] := 'COUNT';
  Words[50] := 'COUNT_BIG';
  Words[51] := 'CREATE';
  Words[52] := 'CROSS';
  Words[53] := 'CURRENT';
  Words[54] := 'CURRENT_DATE';
  Words[55] := 'CURRENT_LC_CTYPE';
  Words[56] := 'CURRENT_PATH';
  Words[57] := 'CURRENT_SERVER';
  Words[58] := 'CURRENT_TIME';
  Words[59] := 'CURRENT_TIMESTAMP';
  Words[60] := 'CURRENT_TIMEZONE';
  Words[61] := 'CURRENT_USER';
  Words[62] := 'CURSOR';
  Words[63] := 'CYCLE';
  Words[64] := 'DATA';
  Words[65] := 'DATABASE';
  Words[66] := 'DAY';
  Words[67] := 'DAYS';
  Words[68] := 'DB2GENERAL';
  Words[69] := 'DB2GENRL';
  Words[70] := 'DB2SQL';
  Words[71] := 'DBINFO';
  Words[72] := 'DECLARE';
  Words[73] := 'DEFAULT';
  Words[74] := 'DEFAULTS';
  Words[75] := 'DEFINITION';
  Words[76] := 'DELETE';
  Words[77] := 'DESCRIPTOR';
  Words[78] := 'DETERMINISTIC';
  Words[79] := 'DISALLOW';
  Words[80] := 'DISCONNECT';
  Words[81] := 'DISTINCT';
  Words[82] := 'DO';
  Words[83] := 'DOUBLE';
  Words[84] := 'DROP';
  Words[85] := 'DSNHATTR';
  Words[86] := 'DSSIZE';
  Words[87] := 'DYNAMIC';
  Words[88] := 'EACH';
  Words[89] := 'EDITPROC';
  Words[90] := 'ELSE';
  Words[91] := 'ELSEIF';
  Words[92] := 'ENCODING';
  Words[93] := 'END-EXEC';
  Words[94] := 'END-EXEC1';
  Words[95] := 'END';
  Words[96] := 'ERASE';
  Words[97] := 'ESCAPE';
  Words[98] := 'EXCEPT';
  Words[99] := 'EXCEPTION';
  Words[100] := 'EXCLUDING';
  Words[101] := 'EXECUTE';
  Words[102] := 'EXISTS';
  Words[103] := 'EXIT';
  Words[104] := 'EXTERNAL';
  Words[105] := 'FENCED';
  Words[106] := 'FETCH';
  Words[107] := 'FIELDPROC';
  Words[108] := 'FILE';
  Words[109] := 'FINAL';
  Words[110] := 'FOR';
  Words[111] := 'FOREIGN';
  Words[112] := 'FREE';
  Words[113] := 'FROM';
  Words[114] := 'FULL';
  Words[115] := 'FUNCTION';
  Words[116] := 'GENERAL';
  Words[117] := 'GENERATED';
  Words[118] := 'GET';
  Words[119] := 'GLOBAL';
  Words[120] := 'GO';
  Words[121] := 'GOTO';
  Words[122] := 'GRANT';
  Words[123] := 'GRAPHIC';
  Words[124] := 'GROUP';
  Words[125] := 'HANDLER';
  Words[126] := 'HAVING';
  Words[127] := 'HOLD';
  Words[128] := 'HOUR';
  Words[129] := 'HOURS';
  Words[130] := 'IDENTITY';
  Words[131] := 'IF';
  Words[132] := 'IMMEDIATE';
  Words[133] := 'IN';
  Words[134] := 'INCLUDING';
  Words[135] := 'INCREMENT';
  Words[136] := 'INDEX';
  Words[137] := 'INDICATOR';
  Words[138] := 'INHERIT';
  Words[139] := 'INNER';
  Words[140] := 'INOUT';
  Words[141] := 'INSENSITIVE';
  Words[142] := 'INSERT';
  Words[143] := 'INTEGRITY';
  Words[144] := 'INTO';
  Words[145] := 'IS';
  Words[146] := 'ISOBID';
  Words[147] := 'ISOLATION';
  Words[148] := 'ITERATE';
  Words[149] := 'JAR';
  Words[150] := 'JAVA';
  Words[151] := 'JOIN';
  Words[152] := 'KEY';
  Words[153] := 'LABEL';
  Words[154] := 'LANGUAGE';
  Words[155] := 'LC_CTYPE';
  Words[156] := 'LEAVE';
  Words[157] := 'LEFT';
  Words[158] := 'LIKE';
  Words[159] := 'LINKTYPE';
  Words[160] := 'LOCAL';
  Words[161] := 'LOCALE';
  Words[162] := 'LOCATOR';
  Words[163] := 'LOCATORS';
  Words[164] := 'LOCK';
  Words[165] := 'LOCKMAX';
  Words[166] := 'LOCKSIZE';
  Words[167] := 'LONG';
  Words[168] := 'LOOP';
  Words[169] := 'MAXVALUE';
  Words[170] := 'MICROSECOND';
  Words[171] := 'MICROSECONDS';
  Words[172] := 'MINUTE';
  Words[173] := 'MINUTES';
  Words[174] := 'MINVALUE';
  Words[175] := 'MODE';
  Words[176] := 'MODIFIES';
  Words[177] := 'MONTH';
  Words[178] := 'MONTHS';
  Words[179] := 'NEW';
  Words[180] := 'NEW_TABLE';
  Words[181] := 'NO';
  Words[182] := 'NOCACHE';
  Words[183] := 'NOCYCLE';
  Words[184] := 'NODENAME';
  Words[185] := 'NODENUMBER';
  Words[186] := 'NOMAXVALUE';
  Words[187] := 'NOMINVALUE';
  Words[188] := 'NOORDER';
  Words[189] := 'NOT';
  Words[190] := 'NULL';
  Words[191] := 'NULLS';
  Words[192] := 'NUMPARTS';
  Words[193] := 'OBID';
  Words[194] := 'OF';
  Words[195] := 'OLD';
  Words[196] := 'OLD_TABLE';
  Words[197] := 'ON';
  Words[198] := 'OPEN';
  Words[199] := 'OPTIMIZATION';
  Words[200] := 'OPTIMIZE';
  Words[201] := 'OPTION';
  Words[202] := 'OR';
  Words[203] := 'ORDER';
  Words[204] := 'OUT';
  Words[205] := 'OUTER';
  Words[206] := 'OVERRIDING';
  Words[207] := 'PACKAGE';
  Words[208] := 'PARAMETER';
  Words[209] := 'PART';
  Words[210] := 'PARTITION';
  Words[211] := 'PATH';
  Words[212] := 'PIECESIZE';
  Words[213] := 'PLAN';
  Words[214] := 'POSITION';
  Words[215] := 'PRECISION';
  Words[216] := 'PREPARE';
  Words[217] := 'PRIMARY';
  Words[218] := 'PRIQTY';
  Words[219] := 'PRIVILEGES';
  Words[220] := 'PROCEDURE';
  Words[221] := 'PROGRAM';
  Words[222] := 'PSID';
  Words[223] := 'QUERYNO';
  Words[224] := 'READ';
  Words[225] := 'READS';
  Words[226] := 'RECOVERY';
  Words[227] := 'REFERENCES';
  Words[228] := 'REFERENCING';
  Words[229] := 'RELEASE';
  Words[230] := 'RENAME';
  Words[231] := 'REPEAT';
  Words[232] := 'RESET';
  Words[233] := 'RESIGNAL';
  Words[234] := 'RESTART';
  Words[235] := 'RESTRICT';
  Words[236] := 'RESULT';
  Words[237] := 'RESULT_SET_LOCATOR';
  Words[238] := 'RETURN';
  Words[239] := 'RETURNS';
  Words[240] := 'REVOKE';
  Words[241] := 'RIGHT';
  Words[242] := 'ROLLBACK';
  Words[243] := 'ROUTINE';
  Words[244] := 'ROW';
  Words[245] := 'ROWS';
  Words[246] := 'RRN';
  Words[247] := 'RUN';
  Words[248] := 'SAVEPOINT';
  Words[249] := 'SCHEMA';
  Words[250] := 'SCRATCHPAD';
  Words[251] := 'SECOND';
  Words[252] := 'SECONDS';
  Words[253] := 'SECQTY';
  Words[254] := 'SECURITY';
  Words[255] := 'SELECT';
  Words[256] := 'SENSITIVE';
  Words[257] := 'SET';
  Words[258] := 'SIGNAL';
  Words[259] := 'SIMPLE';
  Words[260] := 'SOME';
  Words[261] := 'SOURCE';
  Words[262] := 'SPECIFIC';
  Words[263] := 'SQL';
  Words[264] := 'SQLID';
  Words[265] := 'STANDARD';
  Words[266] := 'START';
  Words[267] := 'STATIC';
  Words[268] := 'STAY';
  Words[269] := 'STOGROUP';
  Words[270] := 'STORES';
  Words[271] := 'STYLE';
  Words[272] := 'SUBPAGES';
  Words[273] := 'SUBSTRING';
  Words[274] := 'SYNONYM';
  Words[275] := 'SYSFUN';
  Words[276] := 'SYSIBM';
  Words[277] := 'SYSPROC';
  Words[278] := 'SYSTEM';
  Words[279] := 'TABLE';
  Words[280] := 'TABLESPACE';
  Words[281] := 'THEN';
  Words[282] := 'TO';
  Words[283] := 'TRANSACTION';
  Words[284] := 'TRIGGER';
  Words[285] := 'TRIM';
  Words[286] := 'TYPE';
  Words[287] := 'UNDO';
  Words[288] := 'UNION';
  Words[289] := 'UNIQUE';
  Words[290] := 'UNTIL';
  Words[291] := 'UPDATE';
  Words[292] := 'USAGE';
  Words[293] := 'USER';
  Words[294] := 'USING';
  Words[295] := 'VALIDPROC';
  Words[296] := 'VALUES';
  Words[297] := 'VARIABLE';
  Words[298] := 'VARIANT';
  Words[299] := 'VCAT';
  Words[300] := 'VIEW';
  Words[301] := 'VOLUMES';
  Words[302] := 'WHEN';
  Words[303] := 'WHERE';
  Words[304] := 'WHILE';
  Words[305] := 'WITH';
  Words[306] := 'WLM';
  Words[307] := 'WRITE';
  Words[308] := 'YEAR';
  Words[309] := 'YEARS';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderDB2.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'T'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderDB2.GetViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'V'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSystemTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'T'
  else
    Result := inherited GetSystemTableType;
end;

function TDBXOpenODBCMetaDataReaderDB2.GetSqlProcedureQuoteChar: UnicodeString;
begin
  Result := '';
end;

function TDBXOpenODBCMetaDataReaderDB2.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,14);
  Types[0] := TDBXDataTypeDescription.Create('SMALLINT', TDBXDataTypes.Int16Type, 5, 'SMALLINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[1] := TDBXDataTypeDescription.Create('INTEGER', TDBXDataTypes.Int32Type, 10, 'INTEGER', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[2] := TDBXDataTypeDescription.Create('BIGINT', TDBXDataTypes.Int64Type, 19, 'BIGINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[3] := TDBXDataTypeDescription.Create('REAL', TDBXDataTypes.SingleType, 7, 'REAL', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[4] := TDBXDataTypeDescription.Create('DOUBLE', TDBXDataTypes.DoubleType, 53, 'DOUBLE', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[5] := TDBXDataTypeDescription.Create('DECIMAL', TDBXDataTypes.BcdType, 38, 'DECIMAL({0}, {1})', 'Precision, Scale', 38, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[6] := TDBXDataTypeDescription.Create('CHARACTER', TDBXDataTypes.AnsiStringType, 4000, 'CHARACTER({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[7] := TDBXDataTypeDescription.Create('VARCHAR', TDBXDataTypes.AnsiStringType, 4000, 'VARCHAR({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[8] := TDBXDataTypeDescription.Create('LONG VARCHAR', TDBXDataTypes.AnsiStringType, 32700, 'LONG VARCHAR', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[9] := TDBXDataTypeDescription.Create('BLOB', TDBXDataTypes.BlobType, 2147483647, 'BLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[10] := TDBXDataTypeDescription.Create('CLOB', TDBXDataTypes.BlobType, 2147483647, 'CLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.StringOption);
  Types[11] := TDBXDataTypeDescription.Create('DATE', TDBXDataTypes.DateType, 4, 'DATE', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[12] := TDBXDataTypeDescription.Create('TIME', TDBXDataTypes.TimeType, 3, 'TIME', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[13] := TDBXDataTypeDescription.Create('TIMESTAMP', TDBXDataTypes.TimeStampType, 10, 'TIMESTAMP', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Result := Types;
end;

//
// Informix
//

{ TDBXOpenODBCMetaDataCommandFactoryInformix }

class function TDBXOpenODBCMetaDataCommandFactoryInformix.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderInformix;
end;

{ TDBXOpenODBCMetaDataReaderInformix }

function TDBXOpenODBCMetaDataReaderInformix.GetProductName: UnicodeString;
begin
  Result := 'Informix Dynamic Server';
end;

destructor TDBXOpenODBCMetaDataReaderInformix.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FAlltypes));
  inherited Destroy;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(10)), OWNER, TABNAME, CASE WHEN SUBSTRING(TABNAME FROM 1 FOR 3) = ''sys'' AND OWNER = ''informix'' THEN CASE TABTYPE WHEN ''V'' THEN ''SYSTEM VIEW'' ELSE ''SYSTEM TABLE'' END ELSE CASE TABTYPE WHEN ''V'' THEN ''VIEW'' ELSE ''TABLE'' END END ' +
            'FROM INFORMIX.SYSTABLES ' +
            'WHERE NCOLS > 0 ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (OWNER = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND  ((TABTYPE = CASE WHEN SUBSTRING(TABNAME FROM 1 FOR 3) = ''sys'' AND OWNER = ''informix'' THEN :SYSTEM_TABLES ELSE :TABLES END) OR (TABTYPE = CASE WHEN SUBSTRING(TABNAME FROM 1 FOR 3) = ''sys'' AND OWNER = ''informix'' THEN :SYSTEM_VIEWS ELSE :VIEWS END) OR ' + '(TABTYPE = :SYNONYMS)) ' +
            'ORDER BY 2, 3';
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(10)), T.OWNER, T.TABNAME, C.COLNAME, C.COLTYPE, UPPER(X.NAME), C.COLLENGTH, C.COLNO, D.TYPE, D.DEFAULT, 0, CAST(NULL AS INTEGER) ' +
            'FROM INFORMIX.SYSCOLUMNS C, INFORMIX.SYSTABLES T, OUTER INFORMIX.SYSDEFAULTS D, OUTER INFORMIX.SYSXTDTYPES X ' +
            'WHERE C.TABID=T.TABID AND D.TABID=T.TABID AND C.COLNO=D.COLNO AND C.EXTENDED_ID=X.EXTENDED_ID ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (T.OWNER = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, C.COLNO';
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), T.OWNER, T.TABNAME, NVL(C.CONSTRNAME,I.IDXNAME), C.CONSTRNAME, CASE WHEN C.CONSTRTYPE=''P'' THEN 1 ELSE 0 END, I.IDXTYPE IN (''u'',''U''), 1 ' +
            'FROM INFORMIX.SYSTABLES T JOIN INFORMIX.SYSINDEXES I ON I.TABID=T.TABID LEFT JOIN INFORMIX.SYSCONSTRAINTS C ON C.TABID=I.TABID AND C.IDXNAME=I.IDXNAME AND C.CONSTRTYPE IN (''P'',''U'') ' +
            'WHERE SUBSTR(NVL(C.CONSTRNAME,I.IDXNAME),1,1) <> '' '' ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (T.OWNER = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 1, 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT CAST(NULL AS VARCHAR(1)), T.OWNER, T.TABNAME, NVL(C.CONSTRNAME,I.IDXNAME), ' +
            '  I.PART1, C1.COLNAME, ' +
            '  I.PART2, C2.COLNAME, ' +
            '  I.PART3, C3.COLNAME, ' +
            '  I.PART4, C4.COLNAME, ' +
            '  I.PART5, C5.COLNAME, ' +
            '  I.PART6, C6.COLNAME, ' +
            '  I.PART7, C7.COLNAME, ' +
            '  I.PART8, C8.COLNAME, ' +
            '  I.PART9, C9.COLNAME, ' +
            '  I.PART10, C10.COLNAME, ' +
            '  I.PART11, C11.COLNAME, ' +
            '  I.PART12, C12.COLNAME, ' +
            '  I.PART13, C13.COLNAME, ' +
            '  I.PART14, C14.COLNAME, ' +
            '  I.PART15, C15.COLNAME, ' +
            '  I.PART16, C16.COLNAME ' +
            'FROM INFORMIX.SYSTABLES T JOIN INFORMIX.SYSINDEXES I ON I.TABID=T.TABID LEFT JOIN INFORMIX.SYSCONSTRAINTS C ON C.TABID=I.TABID AND C.IDXNAME=I.IDXNAME AND C.CONSTRTYPE IN (''P'',''U'') ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C1 ON C1.TABID=I.TABID AND C1.COLNO=ABS(I.PART1) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C2 ON C2.TABID=I.TABID AND C2.COLNO=ABS(I.PART2) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C3 ON C3.TABID=I.TABID AND C3.COLNO=ABS(I.PART3) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C4 ON C4.TABID=I.TABID AND C4.COLNO=ABS(I.PART4) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C5 ON C5.TABID=I.TABID AND C5.COLNO=ABS(I.PART5) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C6 ON C6.TABID=I.TABID AND C6.COLNO=ABS(I.PART6) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C7 ON C7.TABID=I.TABID AND C7.COLNO=ABS(I.PART7) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C8 ON C8.TABID=I.TABID AND C8.COLNO=ABS(I.PART8) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C9 ON C9.TABID=I.TABID AND C9.COLNO=ABS(I.PART9) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C10 ON C10.TABID=I.TABID AND C10.COLNO=ABS(I.PART10) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C11 ON C11.TABID=I.TABID AND C11.COLNO=ABS(I.PART11) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C12 ON C12.TABID=I.TABID AND C12.COLNO=ABS(I.PART12) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C13 ON C13.TABID=I.TABID AND C13.COLNO=ABS(I.PART13) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C14 ON C14.TABID=I.TABID AND C14.COLNO=ABS(I.PART14) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C15 ON C15.TABID=I.TABID AND C15.COLNO=ABS(I.PART15) ' +
            '  LEFT JOIN INFORMIX.SYSCOLUMNS C16 ON C16.TABID=I.TABID AND C16.COLNO=ABS(I.PART16) ' +
            'WHERE SUBSTR(NVL(C.CONSTRNAME,I.IDXNAME),1,1) <> '' '' ' +
            '  AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (T.OWNER = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (T.TABNAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (NVL(C.CONSTRNAME,I.IDXNAME) = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
            'ORDER BY 1, 2, 3, 4';
end;

function TDBXOpenODBCMetaDataReaderInformix.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 506);
  Words[0] := 'ABSOLUTE';
  Words[1] := 'ACCESS';
  Words[2] := 'ACCESS_METHOD';
  Words[3] := 'ACTIVE';
  Words[4] := 'ADD';
  Words[5] := 'AFTER';
  Words[6] := 'AGGREGATE';
  Words[7] := 'ALIGNMENT';
  Words[8] := 'ALL';
  Words[9] := 'ALL_ROWS';
  Words[10] := 'ALLOCATE';
  Words[11] := 'ALTER';
  Words[12] := 'AND';
  Words[13] := 'ANSI';
  Words[14] := 'ANY';
  Words[15] := 'APPEND';
  Words[16] := 'AS';
  Words[17] := 'ASC';
  Words[18] := 'AT';
  Words[19] := 'ATTACH';
  Words[20] := 'AUDIT';
  Words[21] := 'AUTHORIZATION';
  Words[22] := 'AUTO';
  Words[23] := 'AUTOFREE';
  Words[24] := 'AVG';
  Words[25] := 'AVOID_EXECUTE';
  Words[26] := 'AVOID_SUBQF';
  Words[27] := 'BEFORE';
  Words[28] := 'BEGIN';
  Words[29] := 'BETWEEN';
  Words[30] := 'BINARY';
  Words[31] := 'BOOLEAN';
  Words[32] := 'BOTH';
  Words[33] := 'BUFFERED';
  Words[34] := 'BUILTIN';
  Words[35] := 'BY';
  Words[36] := 'BYTE';
  Words[37] := 'CACHE';
  Words[38] := 'CALL';
  Words[39] := 'CANNOTHASH';
  Words[40] := 'CARDINALITY';
  Words[41] := 'CASCADE';
  Words[42] := 'CASE';
  Words[43] := 'CAST';
  Words[44] := 'CHAR';
  Words[45] := 'CHAR_LENGTH';
  Words[46] := 'CHARACTER';
  Words[47] := 'CHARACTER_LENGTH';
  Words[48] := 'CHECK';
  Words[49] := 'CLASS';
  Words[50] := 'CLIENT';
  Words[51] := 'CLOSE';
  Words[52] := 'CLUSTER';
  Words[53] := 'CLUSTERSIZE';
  Words[54] := 'COARSE';
  Words[55] := 'COBOL';
  Words[56] := 'CODESET';
  Words[57] := 'COLLATION';
  Words[58] := 'COLLECTION';
  Words[59] := 'COLUMN';
  Words[60] := 'COMMIT';
  Words[61] := 'COMMITTED';
  Words[62] := 'COMMUTATOR';
  Words[63] := 'CONCURRENT';
  Words[64] := 'CONNECT';
  Words[65] := 'CONNECTION';
  Words[66] := 'CONST';
  Words[67] := 'CONSTRAINT';
  Words[68] := 'CONSTRAINTS';
  Words[69] := 'CONSTRUCTOR';
  Words[70] := 'CONTINUE';
  Words[71] := 'COPY';
  Words[72] := 'COSTFUNC';
  Words[73] := 'COUNT';
  Words[74] := 'CRCOLS';
  Words[75] := 'CREATE';
  Words[76] := 'CROSS';
  Words[77] := 'CURRENT';
  Words[78] := 'CURRENT_ROLE';
  Words[79] := 'CURSOR';
  Words[80] := 'CYCLE';
  Words[81] := 'DATABASE';
  Words[82] := 'DATAFILES';
  Words[83] := 'DATASKIP';
  Words[84] := 'DATE';
  Words[85] := 'DATETIME';
  Words[86] := 'DAY';
  Words[87] := 'DBA';
  Words[88] := 'DBDATE';
  Words[89] := 'DBPASSWORD';
  Words[90] := 'DBSERVERNAME';
  Words[91] := 'DEALLOCATE';
  Words[92] := 'DEBUG';
  Words[93] := 'DEC';
  Words[94] := 'DEC_T';
  Words[95] := 'DECIMAL';
  Words[96] := 'DECLARE';
  Words[97] := 'DECODE';
  Words[98] := 'DEFAULT';
  Words[99] := 'DEFAULT_ROLE';
  Words[100] := 'DEFERRED';
  Words[101] := 'DEFERRED_PREPARE';
  Words[102] := 'DEFINE';
  Words[103] := 'DELAY';
  Words[104] := 'DELETE';
  Words[105] := 'DELIMITER';
  Words[106] := 'DELUXE';
  Words[107] := 'DEREF';
  Words[108] := 'DESC';
  Words[109] := 'DESCRIBE';
  Words[110] := 'DESCRIPTOR';
  Words[111] := 'DETACH';
  Words[112] := 'DIAGNOSTICS';
  Words[113] := 'DIRECTIVES';
  Words[114] := 'DIRTY';
  Words[115] := 'DISABLED';
  Words[116] := 'DISCONNECT';
  Words[117] := 'DISTINCT';
  Words[118] := 'DISTRIBUTEBINARY';
  Words[119] := 'DISTRIBUTESREFERENCES';
  Words[120] := 'DISTRIBUTIONS';
  Words[121] := 'DOCUMENT';
  Words[122] := 'DOMAIN';
  Words[123] := 'DONOTDISTRIBUTE';
  Words[124] := 'DORMANT';
  Words[125] := 'DOUBLE';
  Words[126] := 'DROP';
  Words[127] := 'DTIME_T';
  Words[128] := 'EACH';
  Words[129] := 'ELIF';
  Words[130] := 'ELSE';
  Words[131] := 'ENABLED';
  Words[132] := 'ENCRYPTION';
  Words[133] := 'END';
  Words[134] := 'ENUM';
  Words[135] := 'ENVIRONMENT';
  Words[136] := 'ERROR';
  Words[137] := 'ESCAPE';
  Words[138] := 'EXCEPTION';
  Words[139] := 'EXCLUSIVE';
  Words[140] := 'EXEC';
  Words[141] := 'EXECUTE';
  Words[142] := 'EXECUTEANYWHERE';
  Words[143] := 'EXISTS';
  Words[144] := 'EXIT';
  Words[145] := 'EXPLAIN';
  Words[146] := 'EXPLICIT';
  Words[147] := 'EXPRESS';
  Words[148] := 'EXPRESSION';
  Words[149] := 'EXTEND';
  Words[150] := 'EXTENT';
  Words[151] := 'EXTERNAL';
  Words[152] := 'FALSE';
  Words[153] := 'FAR';
  Words[154] := 'FETCH';
  Words[155] := 'FILE';
  Words[156] := 'FILLFACTOR';
  Words[157] := 'FILTERING';
  Words[158] := 'FIRST';
  Words[159] := 'FIRST_ROWS';
  Words[160] := 'FIXCHAR';
  Words[161] := 'FIXED';
  Words[162] := 'FLOAT';
  Words[163] := 'FLUSH';
  Words[164] := 'FOR';
  Words[165] := 'FOREACH';
  Words[166] := 'FOREIGN';
  Words[167] := 'FORMAT';
  Words[168] := 'FORTRAN';
  Words[169] := 'FOUND';
  Words[170] := 'FRACTION';
  Words[171] := 'FRAGMENT';
  Words[172] := 'FREE';
  Words[173] := 'FROM';
  Words[174] := 'FULL';
  Words[175] := 'FUNCTION';
  Words[176] := 'GENERAL';
  Words[177] := 'GET';
  Words[178] := 'GK';
  Words[179] := 'GLOBAL';
  Words[180] := 'GO';
  Words[181] := 'GOTO';
  Words[182] := 'GRANT';
  Words[183] := 'GROUP';
  Words[184] := 'HANDLESNULLS';
  Words[185] := 'HASH';
  Words[186] := 'HAVING';
  Words[187] := 'HIGH';
  Words[188] := 'HINT';
  Words[189] := 'HOLD';
  Words[190] := 'HOUR';
  Words[191] := 'HYBRID';
  Words[192] := 'IF';
  Words[193] := 'IFX_INT8_T';
  Words[194] := 'IFX_LO_CREATE_SPEC_T';
  Words[195] := 'IFX_LO_STAT_T';
  Words[196] := 'IMMEDIATE';
  Words[197] := 'IMPLICIT';
  Words[198] := 'IN';
  Words[199] := 'INACTIVE';
  Words[200] := 'INCREMENT';
  Words[201] := 'INDEX';
  Words[202] := 'INDEXES';
  Words[203] := 'INDICATOR';
  Words[204] := 'INIT';
  Words[205] := 'INITCAP';
  Words[206] := 'INLINE';
  Words[207] := 'INNER';
  Words[208] := 'INOUT';
  Words[209] := 'INSERT';
  Words[210] := 'INSTEAD';
  Words[211] := 'INT';
  Words[212] := 'INT8';
  Words[213] := 'INTEG';
  Words[214] := 'INTEGER';
  Words[215] := 'INTERNAL';
  Words[216] := 'INTERNALLENGTH';
  Words[217] := 'INTERVAL';
  Words[218] := 'INTO';
  Words[219] := 'INTRVL_T';
  Words[220] := 'IS';
  Words[221] := 'ISCANONICAL';
  Words[222] := 'ISOLATION';
  Words[223] := 'ITEM';
  Words[224] := 'ITERATOR';
  Words[225] := 'JOIN';
  Words[226] := 'KEEP';
  Words[227] := 'KEY';
  Words[228] := 'LABELEQ';
  Words[229] := 'LABELGE';
  Words[230] := 'LABELGLB';
  Words[231] := 'LABELGT';
  Words[232] := 'LABELLE';
  Words[233] := 'LABELLT';
  Words[234] := 'LABELLUB';
  Words[235] := 'LABELTOSTRING';
  Words[236] := 'LANGUAGE';
  Words[237] := 'LAST';
  Words[238] := 'LEADING';
  Words[239] := 'LEFT';
  Words[240] := 'LET';
  Words[241] := 'LEVEL';
  Words[242] := 'LIKE';
  Words[243] := 'LIMIT';
  Words[244] := 'LIST';
  Words[245] := 'LISTING';
  Words[246] := 'LOAD';
  Words[247] := 'LOC_T';
  Words[248] := 'LOCAL';
  Words[249] := 'LOCATOR';
  Words[250] := 'LOCK';
  Words[251] := 'LOCKS';
  Words[252] := 'LOG';
  Words[253] := 'LONG';
  Words[254] := 'LOW';
  Words[255] := 'LOWER';
  Words[256] := 'LVARCHAR';
  Words[257] := 'MATCHES';
  Words[258] := 'MAX';
  Words[259] := 'MAXERRORS';
  Words[260] := 'MAXLEN';
  Words[261] := 'MAXVALUE';
  Words[262] := 'MDY';
  Words[263] := 'MEDIAN';
  Words[264] := 'MEDIUM';
  Words[265] := 'MEMORY_RESIDENT';
  Words[266] := 'MIDDLE';
  Words[267] := 'MIN';
  Words[268] := 'MINUTE';
  Words[269] := 'MINVALUE';
  Words[270] := 'MODE';
  Words[271] := 'MODERATE';
  Words[272] := 'MODIFY';
  Words[273] := 'MODULE';
  Words[274] := 'MONEY';
  Words[275] := 'MONTH';
  Words[276] := 'MOUNTING';
  Words[277] := 'MULTISET';
  Words[278] := 'NAME';
  Words[279] := 'NCHAR';
  Words[280] := 'NEGATOR';
  Words[281] := 'NEW';
  Words[282] := 'NEXT';
  Words[283] := 'NO';
  Words[284] := 'NOCACHE';
  Words[285] := 'NOCYCLE';
  Words[286] := 'NOMAXVALUE';
  Words[287] := 'NOMIGRATE';
  Words[288] := 'NOMINVALUE';
  Words[289] := 'NON_RESIDENT';
  Words[290] := 'NONE';
  Words[291] := 'NOORDERNORMAL';
  Words[292] := 'NOT';
  Words[293] := 'NOTEMPLATEARG';
  Words[294] := 'NULL';
  Words[295] := 'NUMERIC';
  Words[296] := 'NVARCHAR';
  Words[297] := 'NVL';
  Words[298] := 'OCTET_LENGTH';
  Words[299] := 'OF';
  Words[300] := 'OFF';
  Words[301] := 'OLD';
  Words[302] := 'ON';
  Words[303] := 'ONLINE';
  Words[304] := 'ONLY';
  Words[305] := 'OPAQUE';
  Words[306] := 'OPCLASS';
  Words[307] := 'OPEN';
  Words[308] := 'OPERATIONAL';
  Words[309] := 'OPTCOMPIND';
  Words[310] := 'OPTICAL';
  Words[311] := 'OPTIMIZATION';
  Words[312] := 'OPTION';
  Words[313] := 'OR';
  Words[314] := 'ORDER';
  Words[315] := 'OUT';
  Words[316] := 'OUTER';
  Words[317] := 'OUTPUT';
  Words[318] := 'PAGE';
  Words[319] := 'PARALLELIZABLE';
  Words[320] := 'PARAMETER';
  Words[321] := 'PARTITION';
  Words[322] := 'PASCAL';
  Words[323] := 'PASSEDBYVALUE';
  Words[324] := 'PASSWORD';
  Words[325] := 'PDQPRIORITY';
  Words[326] := 'PERCALL_COST';
  Words[327] := 'PLI';
  Words[328] := 'PLOAD';
  Words[329] := 'PRECISION';
  Words[330] := 'PREPARE';
  Words[331] := 'PREVIOUS';
  Words[332] := 'PRIMARY';
  Words[333] := 'PRIOR';
  Words[334] := 'PRIVATE';
  Words[335] := 'PRIVILEGES';
  Words[336] := 'PROCEDURE';
  Words[337] := 'PUBLIC';
  Words[338] := 'PUT';
  Words[339] := 'RAISE';
  Words[340] := 'RANGE';
  Words[341] := 'RAW';
  Words[342] := 'READ';
  Words[343] := 'REAL';
  Words[344] := 'RECORDEND';
  Words[345] := 'REF';
  Words[346] := 'REFERENCES';
  Words[347] := 'REFERENCING';
  Words[348] := 'REGISTER';
  Words[349] := 'REJECTFILE';
  Words[350] := 'RELATIVE';
  Words[351] := 'RELEASE';
  Words[352] := 'REMAINDER';
  Words[353] := 'RENAME';
  Words[354] := 'REOPTIMIZATION';
  Words[355] := 'REPEATABLE';
  Words[356] := 'REPLICATION';
  Words[357] := 'RESERVE';
  Words[358] := 'RESOLUTION';
  Words[359] := 'RESOURCE';
  Words[360] := 'RESTART';
  Words[361] := 'RESTRICT';
  Words[362] := 'RESUME';
  Words[363] := 'RETAIN';
  Words[364] := 'RETURN';
  Words[365] := 'RETURNING';
  Words[366] := 'RETURNS';
  Words[367] := 'REUSE';
  Words[368] := 'REVOKE';
  Words[369] := 'RIGHT';
  Words[370] := 'ROBIN';
  Words[371] := 'ROLE';
  Words[372] := 'ROLLBACK';
  Words[373] := 'ROLLFORWARD';
  Words[374] := 'ROUND';
  Words[375] := 'ROUTINE';
  Words[376] := 'ROW';
  Words[377] := 'ROWID';
  Words[378] := 'ROWIDS';
  Words[379] := 'ROWS';
  Words[380] := 'SAMEAS';
  Words[381] := 'SAMPLES';
  Words[382] := 'SAVE';
  Words[383] := 'SCHEDULE';
  Words[384] := 'SCHEMA';
  Words[385] := 'SCRATCH';
  Words[386] := 'SCROLL';
  Words[387] := 'SECOND';
  Words[388] := 'SECONDARY';
  Words[389] := 'SECTION';
  Words[390] := 'SELCONST';
  Words[391] := 'SELECT';
  Words[392] := 'SELFUNC';
  Words[393] := 'SEQUENCE';
  Words[394] := 'SERIAL';
  Words[395] := 'SERIAL8';
  Words[396] := 'SERIALIZABLE';
  Words[397] := 'SERVERUUID';
  Words[398] := 'SESSION';
  Words[399] := 'SET';
  Words[400] := 'SHARE';
  Words[401] := 'SHORT';
  Words[402] := 'SIGNED';
  Words[403] := 'SITENAME';
  Words[404] := 'SIZE';
  Words[405] := 'SKALL';
  Words[406] := 'SKINHIBIT';
  Words[407] := 'SKIP';
  Words[408] := 'SKSHOW';
  Words[409] := 'SMALLFLOAT';
  Words[410] := 'SMALLINT';
  Words[411] := 'SOME';
  Words[412] := 'SPECIFIC';
  Words[413] := 'SQL';
  Words[414] := 'SQLCODE';
  Words[415] := 'SQLCONTEXT';
  Words[416] := 'SQLERROR';
  Words[417] := 'SQLSTATE';
  Words[418] := 'SQLWARNING';
  Words[419] := 'STABILITY';
  Words[420] := 'STACK';
  Words[421] := 'STANDARD';
  Words[422] := 'START';
  Words[423] := 'STATIC';
  Words[424] := 'STATISTICS';
  Words[425] := 'STDEV';
  Words[426] := 'STEP';
  Words[427] := 'STOP';
  Words[428] := 'STORAGE';
  Words[429] := 'STRATEGIES';
  Words[430] := 'STRING';
  Words[431] := 'STRINGTOLABEL';
  Words[432] := 'STRUCT';
  Words[433] := 'STYLE';
  Words[434] := 'SUBSTR';
  Words[435] := 'SUBSTRING';
  Words[436] := 'SUM';
  Words[437] := 'SUPPORT';
  Words[438] := 'SYNC';
  Words[439] := 'SYNONYM';
  Words[440] := 'SYSTEM';
  Words[441] := 'TABLE';
  Words[442] := 'TEMP';
  Words[443] := 'TEMPLATE';
  Words[444] := 'TEST';
  Words[445] := 'TEXT';
  Words[446] := 'THEN';
  Words[447] := 'TIME';
  Words[448] := 'TIMEOUT';
  Words[449] := 'TO';
  Words[450] := 'TODAY';
  Words[451] := 'TRACE';
  Words[452] := 'TRAILING';
  Words[453] := 'TRANSACTION';
  Words[454] := 'TRIGGER';
  Words[455] := 'TRIGGERS';
  Words[456] := 'TRIM';
  Words[457] := 'TRUE';
  Words[458] := 'TRUNCATE';
  Words[459] := 'TYPE';
  Words[460] := 'TYPEDEF';
  Words[461] := 'TYPEID';
  Words[462] := 'TYPENAME';
  Words[463] := 'TYPEOF';
  Words[464] := 'UNCOMMITTED';
  Words[465] := 'UNDER';
  Words[466] := 'UNION';
  Words[467] := 'UNIQUE';
  Words[468] := 'UNITS';
  Words[469] := 'UNKNOWN';
  Words[470] := 'UNLOAD';
  Words[471] := 'UNLOCK';
  Words[472] := 'UNSIGNED';
  Words[473] := 'UPDATE';
  Words[474] := 'UPPER';
  Words[475] := 'USAGE';
  Words[476] := 'USE_SUBQF';
  Words[477] := 'USER';
  Words[478] := 'USING';
  Words[479] := 'VALUE';
  Words[480] := 'VALUES';
  Words[481] := 'VAR';
  Words[482] := 'VARCHAR';
  Words[483] := 'VARIABLE';
  Words[484] := 'VARIANCE';
  Words[485] := 'VARIANT';
  Words[486] := 'VARYING';
  Words[487] := 'VIEW';
  Words[488] := 'VIOLATIONS';
  Words[489] := 'VOID';
  Words[490] := 'VOLATILE';
  Words[491] := 'WAIT';
  Words[492] := 'WARNING';
  Words[493] := 'WHEN';
  Words[494] := 'WHENEVER';
  Words[495] := 'WHERE';
  Words[496] := 'WHILE';
  Words[497] := 'WITH';
  Words[498] := 'WITHOUT';
  Words[499] := 'WORK';
  Words[500] := 'WRITE';
  Words[501] := 'XADATASOURCE';
  Words[502] := 'XID';
  Words[503] := 'XLOAD';
  Words[504] := 'XUNLOAD';
  Words[505] := 'YEAR';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'T'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetViewType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'V'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSystemTableType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'T'
  else
    Result := inherited GetSystemTableType;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetSynonymType: UnicodeString;
begin
  if not fDbxMode then
    Result := 'S'
  else
    Result := inherited GetSynonymType;
end;

function TDBXOpenODBCMetaDataReaderInformix.IsUpperCaseIdentifiersSupported: Boolean;
begin
  Result := False;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetAllDataTypes: TDBXDataTypeDescriptionArray;
var
  Newtypes: TDBXDataTypeDescriptionArray;
begin
  if FAlltypes = nil then
  begin
    SetLength(Newtypes,TypesCount);
    Newtypes[CharType] := TDBXDataTypeDescription.Create(CharTypename, TDBXDataTypes.AnsiStringType, 32767, 'CHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned);
    Newtypes[VarcharType] := TDBXDataTypeDescription.Create(VarcharTypename, TDBXDataTypes.AnsiStringType, 254, 'VARCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned);
    Newtypes[NcharType] := TDBXDataTypeDescription.Create(NcharTypename, TDBXDataTypes.WideStringType, 32767, 'NCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned);
    Newtypes[NvarcharType] := TDBXDataTypeDescription.Create(NvarcharTypename, TDBXDataTypes.WideStringType, 254, 'NVARCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned);
    Newtypes[SmallintType] := TDBXDataTypeDescription.Create(SmallintTypename, TDBXDataTypes.Int16Type, 5, 'SMALLINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[IntegerType] := TDBXDataTypeDescription.Create(IntegerTypename, TDBXDataTypes.Int32Type, 10, 'INTEGER', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[Int8_Type] := TDBXDataTypeDescription.Create(Int8_Typename, TDBXDataTypes.Int64Type, 19, 'INT8', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[FloatType] := TDBXDataTypeDescription.Create(FloatTypename, TDBXDataTypes.DoubleType, 14, 'FLOAT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[SmallfloatType] := TDBXDataTypeDescription.Create(SmallfloatTypename, TDBXDataTypes.SingleType, 7, 'SMALLFLOAT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DecimalType] := TDBXDataTypeDescription.Create(DecimalTypename, TDBXDataTypes.DoubleType, 14, 'DECIMAL({0}, {1})', 'Precision, Scale', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[SerialType] := TDBXDataTypeDescription.Create(SerialTypename, TDBXDataTypes.Int32Type, 10, 'SERIAL', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Searchable);
    Newtypes[Serial8_Type] := TDBXDataTypeDescription.Create(Serial8_Typename, TDBXDataTypes.Int64Type, 19, 'SERIAL8', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Searchable);
    Newtypes[DateType] := TDBXDataTypeDescription.Create(DateTypename, TDBXDataTypes.DateType, 10, 'DATE', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DatetimeType] := TDBXDataTypeDescription.Create(DatetimeTypename, TDBXDataTypes.TimeStampType, 11, 'DATETIME YEAR TO FRACTION', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    //Newtypes[INTERVAL_TYPE] = new DataTypeDescription(INTERVAL_TYPENAME, DataTypes.INTERVAL_TYPE, 11L, "INTERVAL", null, -1, -1, null, null, null, null, TypeFlag.BEST_MATCH | TypeFlag.NULLABLE | TypeFlag.SEARCHABLE);
    Newtypes[MoneyType] := TDBXDataTypeDescription.Create(MoneyTypename, TDBXDataTypes.BcdType, 32, 'MONEY({0},{1})', 'Precision, Scale', 32, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[ByteType] := TDBXDataTypeDescription.Create(ByteTypename, TDBXDataTypes.BlobType, 2147483647, 'BYTE', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
    Newtypes[TextType] := TDBXDataTypeDescription.Create(TextTypename, TDBXDataTypes.AnsiStringType, 2147483647, 'TEXT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
    Newtypes[LvarcharType] := TDBXDataTypeDescription.Create(LvarcharTypename, TDBXDataTypes.AnsiStringType, 32739, 'LVARCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned);
    Newtypes[BooleanType] := TDBXDataTypeDescription.Create(BooleanTypename, TDBXDataTypes.BooleanType, 1, 'BOOLEAN', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
    FAlltypes := Newtypes;
  end;
  Result := FAlltypes;
end;

function TDBXOpenODBCMetaDataReaderInformix.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Index: Integer;
  TargetIndex: Integer;
  DataTypes: TDBXDataTypeDescriptionArray;
begin
  GetAllDataTypes();
  TargetIndex := 0;
  for Index := 0 to Length(FAlltypes) - 1 do
  begin
    if FAlltypes[Index] <> nil then
      IncrAfter(TargetIndex);
  end;
  SetLength(DataTypes,TargetIndex);
  TargetIndex := 0;
  for Index := 0 to Length(FAlltypes) - 1 do
  begin
    if FAlltypes[Index] <> nil then
    begin
      DataTypes[TargetIndex] := TDBXDataTypeDescription.Create(FAlltypes[Index]);
      IncrAfter(TargetIndex);
    end;
  end;
  Result := DataTypes;
end;

//
// DataStorage
//

{ TDBXOpenODBCMetaDataCommandFactoryDataStorage }

class function TDBXOpenODBCMetaDataCommandFactoryDataStorage.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderDataStorage;
end;

{ TDBXOpenODBCMetaDataReaderDataStorage }

function TDBXOpenODBCMetaDataReaderDataStorage.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'CALL DB_ADMIN.GET_TABLES_EXT(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,:TABLES,:VIEWS,:SYSTEM_TABLES,:SYSTEM_VIEWS,:SYNONYMS)';
end;

function TDBXOpenODBCMetaDataReaderDataStorage.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'CALL DB_ADMIN.GET_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,NULL)';
end;

function TDBXOpenODBCMetaDataReaderDataStorage.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'CALL DB_ADMIN.GET_INDEXES(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME)';
end;

function TDBXOpenODBCMetaDataReaderDataStorage.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'CALL DB_ADMIN.GET_INDEX_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,:INDEX_NAME)';
end;

//
// Firebird
//

{ TDBXOpenODBCMetaDataCommandFactoryFirebird }

class function TDBXOpenODBCMetaDataCommandFactoryFirebird.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderFirebird;
end;

{ TDBXOpenODBCMetaDataReaderFirebird }

function TDBXOpenODBCMetaDataReaderFirebird.GetProductName: UnicodeString;
begin
  Result := 'Firebird';
end;

destructor TDBXOpenODBCMetaDataReaderFirebird.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FAlltypes));
  inherited Destroy;
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, RDB$RELATION_NAME, CASE WHEN RDB$SYSTEM_FLAG > 0 THEN ''SYSTEM TABLE'' WHEN RDB$VIEW_SOURCE IS NOT NULL THEN ''VIEW'' ELSE ''TABLE'' END AS TABLE_TYPE ' +
            'FROM RDB$RELATIONS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND ((RDB$SYSTEM_FLAG > 0 AND :SYSTEM_TABLES=''SYSTEM TABLE'') OR (RDB$VIEW_SOURCE IS NOT NULL AND :VIEWS=''VIEW'') OR (RDB$SYSTEM_FLAG = 0 AND RDB$VIEW_SOURCE IS NULL AND :TABLES=''TABLE'')) ' +
            'ORDER BY 3';
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, RF.RDB$RELATION_NAME, RF.RDB$FIELD_NAME, F.RDB$FIELD_TYPE, COALESCE(F.RDB$FIELD_PRECISION,F.RDB$CHARACTER_LENGTH,F.RDB$FIELD_LENGTH), F.RDB$FIELD_SCALE, RF.RDB$FIELD_POSITION+1, RF.RDB$DEFAULT_SOURCE, CASE WHEN RF.RDB$NULL_FLAG=1 THEN 0' + ' ELSE 1 END, 0, NULL, F.RDB$FIELD_SUB_TYPE, F.RDB$CHARACTER_SET_ID ' +
            'FROM RDB$RELATION_FIELDS RF, RDB$FIELDS F ' +
            'WHERE (RF.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME) ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (RF.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 3, RF.RDB$FIELD_POSITION';
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, I.RDB$RELATION_NAME, CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END, C.RDB$CONSTRAINT_NAME, CASE WHEN C.RDB$CONSTRAINT_TYPE=''PRIMARY KEY'' THEN 1 ELSE 0 END, COALESCE(I.RDB$UNIQUE_FLAG,0), CO' + 'ALESCE(1-I.RDB$INDEX_TYPE,1) ' +
            'FROM RDB$INDICES I LEFT OUTER JOIN RDB$RELATION_CONSTRAINTS C ON I.RDB$INDEX_NAME = C.RDB$INDEX_NAME ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (I.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 3, 4';
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, I.RDB$RELATION_NAME, CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END, S.RDB$FIELD_NAME, S.RDB$FIELD_POSITION+1, 1 ' +
            'FROM RDB$INDICES I LEFT OUTER JOIN RDB$RELATION_CONSTRAINTS C ON I.RDB$INDEX_NAME = C.RDB$INDEX_NAME, RDB$INDEX_SEGMENTS S ' +
            'WHERE I.RDB$INDEX_NAME = S.RDB$INDEX_NAME ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (I.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END = :INDEX_NAME OR (' + ':INDEX_NAME IS NULL)) ' +
            'ORDER BY 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := 'nil Exit; {@dbg}
  SetLength(Words, 289);
  Words[0] := 'ACTION';
  Words[1] := 'ACTIVE';
  Words[2] := 'ADD';
  Words[3] := 'ADMIN';
  Words[4] := 'AFTER';
  Words[5] := 'ALL';
  Words[6] := 'ALTER';
  Words[7] := 'AND';
  Words[8] := 'ANY';
  Words[9] := 'AS';
  Words[10] := 'ASC';
  Words[11] := 'ASCENDING';
  Words[12] := 'AT';
  Words[13] := 'AUTO';
  Words[14] := 'AUTODDL';
  Words[15] := 'AVG';
  Words[16] := 'BASED';
  Words[17] := 'BASENAME';
  Words[18] := 'BASE_NAME';
  Words[19] := 'BEFORE';
  Words[20] := 'BEGIN';
  Words[21] := 'BETWEEN';
  Words[22] := 'BLOB';
  Words[23] := 'BLOBEDIT';
  Words[24] := 'BOOLEAN';
  Words[25] := 'BUFFER';
  Words[26] := 'BY';
  Words[27] := 'CACHE';
  Words[28] := 'CASCADE';
  Words[29] := 'CAST';
  Words[30] := 'CHAR';
  Words[31] := 'CHARACTER';
  Words[32] := 'CHARACTER_LENGTH';
  Words[33] := 'CHAR_LENGTH';
  Words[34] := 'CHECK';
  Words[35] := 'CHECK_POINT_LEN';
  Words[36] := 'CHECK_POINT_LENGTH';
  Words[37] := 'COLLATE';
  Words[38] := 'COLLATION';
  Words[39] := 'COLUMN';
  Words[40] := 'COMMIT';
  Words[41] := 'COMMITTED';
  Words[42] := 'COMPILETIME';
  Words[43] := 'COMPUTED';
  Words[44] := 'CLOSE';
  Words[45] := 'CONDITIONAL';
  Words[46] := 'CONNECT';
  Words[47] := 'CONSTRAINT';
  Words[48] := 'CONTAINING';
  Words[49] := 'CONTINUE';
  Words[50] := 'COUNT';
  Words[51] := 'CREATE';
  Words[52] := 'CSTRING';
  Words[53] := 'CURRENT';
  Words[54] := 'CURRENT_DATE';
  Words[55] := 'CURRENT_TIME';
  Words[56] := 'CURRENT_TIMESTAMP';
  Words[57] := 'CURSOR';
  Words[58] := 'DATABASE';
  Words[59] := 'DATE';
  Words[60] := 'DAY';
  Words[61] := 'DB_KEY';
  Words[62] := 'DEBUG';
  Words[63] := 'DEC';
  Words[64] := 'DECIMAL';
  Words[65] := 'DECLARE';
  Words[66] := 'DEFAULT';
  Words[67] := 'DELETE';
  Words[68] := 'DESC';
  Words[69] := 'DESCENDING';
  Words[70] := 'DESCRIBE';
  Words[71] := 'DESCRIPTOR';
  Words[72] := 'DISCONNECT';
  Words[73] := 'DISPLAY';
  Words[74] := 'DISTINCT';
  Words[75] := 'DO';
  Words[76] := 'DOMAIN';
  Words[77] := 'DOUBLE';
  Words[78] := 'DROP';
  Words[79] := 'ECHO';
  Words[80] := 'EDIT';
  Words[81] := 'ELSE';
  Words[82] := 'END';
  Words[83] := 'ENTRY_POINT';
  Words[84] := 'ESCAPE';
  Words[85] := 'EVENT';
  Words[86] := 'EXCEPTION';
  Words[87] := 'EXECUTE';
  Words[88] := 'EXISTS';
  Words[89] := 'EXIT';
  Words[90] := 'EXTERN';
  Words[91] := 'EXTERNAL';
  Words[92] := 'EXTRACT';
  Words[93] := 'FALSE';
  Words[94] := 'FETCH';
  Words[95] := 'FILE';
  Words[96] := 'FILTER';
  Words[97] := 'FLOAT';
  Words[98] := 'FOR';
  Words[99] := 'FOREIGN';
  Words[100] := 'FOUND';
  Words[101] := 'FREE_IT';
  Words[102] := 'FROM';
  Words[103] := 'FULL';
  Words[104] := 'FUNCTION';
  Words[105] := 'GDSCODE';
  Words[106] := 'GENERATOR';
  Words[107] := 'GEN_ID';
  Words[108] := 'GLOBAL';
  Words[109] := 'GOTO';
  Words[110] := 'GRANT';
  Words[111] := 'GROUP';
  Words[112] := 'GROUP_COMMIT_WAIT';
  Words[113] := 'GROUP_COMMIT_WAIT_TIME';
  Words[114] := 'HAVING';
  Words[115] := 'HELP';
  Words[116] := 'HOUR';
  Words[117] := 'IF';
  Words[118] := 'IMMEDIATE';
  Words[119] := 'IN';
  Words[120] := 'INACTIVE';
  Words[121] := 'INDEX';
  Words[122] := 'INDICATOR';
  Words[123] := 'INIT';
  Words[124] := 'INNER';
  Words[125] := 'INPUT';
  Words[126] := 'INPUT_TYPE';
  Words[127] := 'INSERT';
  Words[128] := 'INT';
  Words[129] := 'INTEGER';
  Words[130] := 'INTO';
  Words[131] := 'IS';
  Words[132] := 'ISOLATION';
  Words[133] := 'ISQL';
  Words[134] := 'JOIN';
  Words[135] := 'KEY';
  Words[136] := 'LC_MESSAGES';
  Words[137] := 'LC_TYPE';
  Words[138] := 'LEFT';
  Words[139] := 'LENGTH';
  Words[140] := 'LEV';
  Words[141] := 'LEVEL';
  Words[142] := 'LIKE';
  Words[143] := 'LOGFILE';
  Words[144] := 'LOG_BUFFER_SIZE';
  Words[145] := 'LOG_BUF_SIZE';
  Words[146] := 'LONG';
  Words[147] := 'MANUAL';
  Words[148] := 'MAX';
  Words[149] := 'MAXIMUM';
  Words[150] := 'MAXIMUM_SEGMENT';
  Words[151] := 'MAX_SEGMENT';
  Words[152] := 'MERGE';
  Words[153] := 'MESSAGE';
  Words[154] := 'MIN';
  Words[155] := 'MINIMUM';
  Words[156] := 'MINUTE';
  Words[157] := 'MODULE_NAME';
  Words[158] := 'MONTH';
  Words[159] := 'NAMES';
  Words[160] := 'NATIONAL';
  Words[161] := 'NATURAL';
  Words[162] := 'NCHAR';
  Words[163] := 'NO';
  Words[164] := 'NOAUTO';
  Words[165] := 'NOT';
  Words[166] := 'NULL';
  Words[167] := 'NUMERIC';
  Words[168] := 'NUM_LOG_BUFS';
  Words[169] := 'NUM_LOG_BUFFERS';
  Words[170] := 'OCTET_LENGTH';
  Words[171] := 'OF';
  Words[172] := 'ON';
  Words[173] := 'ONLY';
  Words[174] := 'OPEN';
  Words[175] := 'OPTION';
  Words[176] := 'OR';
  Words[177] := 'ORDER';
  Words[178] := 'OUTER';
  Words[179] := 'OUTPUT';
  Words[180] := 'OUTPUT_TYPE';
  Words[181] := 'OVERFLOW';
  Words[182] := 'PAGE';
  Words[183] := 'PAGELENGTH';
  Words[184] := 'PAGES';
  Words[185] := 'PAGE_SIZE';
  Words[186] := 'PARAMETER';
  Words[187] := 'PASSWORD';
  Words[188] := 'PERCENT';
  Words[189] := 'PLAN';
  Words[190] := 'POSITION';
  Words[191] := 'POST_EVENT';
  Words[192] := 'PRECISION';
  Words[193] := 'PREPARE';
  Words[194] := 'PRESERVE';
  Words[195] := 'PROCEDURE';
  Words[196] := 'PROTECTED';
  Words[197] := 'PRIMARY';
  Words[198] := 'PRIVILEGES';
  Words[199] := 'PUBLIC';
  Words[200] := 'QUIT';
  Words[201] := 'RAW_PARTITIONS';
  Words[202] := 'RDB$DB_KEY';
  Words[203] := 'READ';
  Words[204] := 'REAL';
  Words[205] := 'RECORD_VERSION';
  Words[206] := 'REFERENCES';
  Words[207] := 'RELEASE';
  Words[208] := 'RESERV';
  Words[209] := 'RESERVING';
  Words[210] := 'RESTRICT';
  Words[211] := 'RETAIN';
  Words[212] := 'RETURN';
  Words[213] := 'RETURNING_VALUES';
  Words[214] := 'RETURNS';
  Words[215] := 'REVOKE';
  Words[216] := 'RIGHT';
  Words[217] := 'ROLE';
  Words[218] := 'ROLLBACK';
  Words[219] := 'ROWS';
  Words[220] := 'RUNTIME';
  Words[221] := 'SCHEMA';
  Words[222] := 'SECOND';
  Words[223] := 'SEGMENT';
  Words[224] := 'SELECT';
  Words[225] := 'SET';
  Words[226] := 'SHADOW';
  Words[227] := 'SHARED';
  Words[228] := 'SHELL';
  Words[229] := 'SHOW';
  Words[230] := 'SINGULAR';
  Words[231] := 'SIZE';
  Words[232] := 'SMALLINT';
  Words[233] := 'SNAPSHOT';
  Words[234] := 'SOME';
  Words[235] := 'SORT';
  Words[236] := 'SQLCODE';
  Words[237] := 'SQLERROR';
  Words[238] := 'SQLWARNING';
  Words[239] := 'STABILITY';
  Words[240] := 'STARTING';
  Words[241] := 'STARTS';
  Words[242] := 'STATEMENT';
  Words[243] := 'STATIC';
  Words[244] := 'STATISTICS';
  Words[245] := 'SUB_TYPE';
  Words[246] := 'SUM';
  Words[247] := 'SUSPEND';
  Words[248] := 'TABLE';
  Words[249] := 'TEMPORARY';
  Words[250] := 'TERMINATOR';
  Words[251] := 'THEN';
  Words[252] := 'TIES';
  Words[253] := 'TIME';
  Words[254] := 'TIMESTAMP';
  Words[255] := 'TO';
  Words[256] := 'TRANSACTION';
  Words[257] := 'TRANSLATE';
  Words[258] := 'TRANSLATION';
  Words[259] := 'TRIGGER';
  Words[260] := 'TRIM';
  Words[261] := 'TRUE';
  Words[262] := 'TYPE';
  Words[263] := 'UNCOMMITTED';
  Words[264] := 'UNION';
  Words[265] := 'UNIQUE';
  Words[266] := 'UNKNOWN';
  Words[267] := 'UPDATE';
  Words[268] := 'UPPER';
  Words[269] := 'USER';
  Words[270] := 'USING';
  Words[271] := 'VALUE';
  Words[272] := 'VALUES';
  Words[273] := 'VARCHAR';
  Words[274] := 'VARIABLE';
  Words[275] := 'VARYING';
  Words[276] := 'VERSION';
  Words[277] := 'VIEW';
  Words[278] := 'WAIT';
  Words[279] := 'WEEKDAY';
  Words[280] := 'WHEN';
  Words[281] := 'WHENEVER';
  Words[282] := 'WHERE';
  Words[283] := 'WHILE';
  Words[284] := 'WITH';
  Words[285] := 'WORK';
  Words[286] := 'WRITE';
  Words[287] := 'YEAR';
  Words[288] := 'YEARDAY';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderFirebird.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := False;
end;

procedure TDBXOpenODBCMetaDataReaderFirebird.SetContext(const Context: TDBXProviderContext);
begin
  inherited SetContext(Context);
  FDefaultCharSetIsUnicode := (Context.GetVendorProperty(DefaultCharsetIsUnicode) = 'true');
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetAllDataTypes: TDBXDataTypeDescriptionArray;
var
  Newtypes: TDBXDataTypeDescriptionArray;
  StringType: Integer;
begin
  if FAlltypes = nil then
  begin
    SetLength(Newtypes,TypesCount);
    StringType := TDBXDataTypes.AnsiStringType;
    if FDefaultCharSetIsUnicode then
      StringType := TDBXDataTypes.WideStringType;
    Newtypes[CharType] := TDBXDataTypeDescription.Create('CHAR', StringType, 32768, 'CHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned or TDBXTypeFlag.UnicodeOption);
    Newtypes[VarcharType] := TDBXDataTypeDescription.Create('VARCHAR', StringType, 32678, 'VARCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned or TDBXTypeFlag.UnicodeOption);
    Newtypes[IntegerType] := TDBXDataTypeDescription.Create('INTEGER', TDBXDataTypes.Int32Type, 10, 'INTEGER', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[SmallintType] := TDBXDataTypeDescription.Create('SMALLINT', TDBXDataTypes.Int16Type, 5, 'SMALLINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[FloatType] := TDBXDataTypeDescription.Create('FLOAT', TDBXDataTypes.SingleType, 53, 'FLOAT({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DoubleType] := TDBXDataTypeDescription.Create('DOUBLE PRECISION', TDBXDataTypes.DoubleType, 53, 'DOUBLE PRECISION', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[NumericType] := TDBXDataTypeDescription.Create('NUMERIC', TDBXDataTypes.BcdType, 18, 'NUMERIC({0}, {1})', 'Precision, Scale', 18, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DecimalType] := TDBXDataTypeDescription.Create('DECIMAL', TDBXDataTypes.BcdType, 18, 'DECIMAL({0}, {1})', 'Precision, Scale', 18, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
    Newtypes[DateType] := TDBXDataTypeDescription.Create('DATE', TDBXDataTypes.DateType, 0, 'DATE', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[TimeType] := TDBXDataTypeDescription.Create('TIME', TDBXDataTypes.TimeType, 0, 'TIME', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[TimestampType] := TDBXDataTypeDescription.Create('TIMESTAMP', TDBXDataTypes.TimeStampType, 0, 'TIMESTAMP', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[BlobType] := TDBXDataTypeDescription.Create('BLOB', TDBXDataTypes.BlobType, 2147483647, 'BLOB', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Unsigned or TDBXTypeFlag.StringOption or TDBXTypeFlag.UnicodeOption);
    Newtypes[BigintType] := TDBXDataTypeDescription.Create('BIGINT', TDBXDataTypes.Int64Type, 19, 'BIGINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch + TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    FAlltypes := Newtypes;
  end;
  Result := FAlltypes;
end;

function TDBXOpenODBCMetaDataReaderFirebird.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  DataTypes: TDBXDataTypeDescriptionArray;
  Index: Integer;
begin
  GetAllDataTypes;
  SetLength(DataTypes,Length(FAlltypes));
  for index := 0 to Length(DataTypes) - 1 do
    DataTypes[Index] := TDBXDataTypeDescription.Create(FAlltypes[Index]);
  Result := DataTypes;
end;

//
// Interbase
//

{ TDBXOpenODBCMetaDataCommandFactoryInterbase }

class function TDBXOpenODBCMetaDataCommandFactoryInterbase.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderInterbase;
end;

{ TDBXOpenODBCMetaDataReaderInterbase }

function TDBXOpenODBCMetaDataReaderInterbase.GetProductName: UnicodeString;
begin
  Result := 'InterBase';
end;

destructor TDBXOpenODBCMetaDataReaderInterbase.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FAlltypes));
  inherited Destroy;
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, RDB$RELATION_NAME, CASE WHEN RDB$SYSTEM_FLAG > 0 THEN ''SYSTEM TABLE'' WHEN RDB$VIEW_SOURCE IS NOT NULL THEN ''VIEW'' ELSE ''TABLE'' END AS TABLE_TYPE ' +
            'FROM RDB$RELATIONS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND ((RDB$SYSTEM_FLAG > 0 AND :SYSTEM_TABLES=''SYSTEM TABLE'') OR (RDB$VIEW_SOURCE IS NOT NULL AND :VIEWS=''VIEW'') OR (RDB$SYSTEM_FLAG = 0 AND RDB$VIEW_SOURCE IS NULL AND :TABLES=''TABLE'')) ' +
            'ORDER BY 3';
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, RF.RDB$RELATION_NAME, RF.RDB$FIELD_NAME, F.RDB$FIELD_TYPE, COALESCE(F.RDB$FIELD_PRECISION,F.RDB$CHARACTER_LENGTH,F.RDB$FIELD_LENGTH), F.RDB$FIELD_SCALE, RF.RDB$FIELD_POSITION+1, RF.RDB$DEFAULT_SOURCE, CASE WHEN RF.RDB$NULL_FLAG=1 THEN 0' + ' ELSE 1 END, 0, NULL, F.RDB$FIELD_SUB_TYPE, F.RDB$CHARACTER_SET_ID ' +
            'FROM RDB$RELATION_FIELDS RF, RDB$FIELDS F ' +
            'WHERE (RF.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME) ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (RF.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 3, RF.RDB$FIELD_POSITION';
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, I.RDB$RELATION_NAME, CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END, C.RDB$CONSTRAINT_NAME, CASE WHEN C.RDB$CONSTRAINT_TYPE=''PRIMARY KEY'' THEN 1 ELSE 0 END, COALESCE(I.RDB$UNIQUE_FLAG,0), CO' + 'ALESCE(1-I.RDB$INDEX_TYPE,1) ' +
            'FROM RDB$INDICES I LEFT OUTER JOIN RDB$RELATION_CONSTRAINTS C ON I.RDB$INDEX_NAME = C.RDB$INDEX_NAME ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (I.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 3, 4';
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := 'SELECT NULL, NULL, I.RDB$RELATION_NAME, CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END, S.RDB$FIELD_NAME, S.RDB$FIELD_POSITION+1, 1 ' +
            'FROM RDB$INDICES I LEFT OUTER JOIN RDB$RELATION_CONSTRAINTS C ON I.RDB$INDEX_NAME = C.RDB$INDEX_NAME, RDB$INDEX_SEGMENTS S ' +
            'WHERE I.RDB$INDEX_NAME = S.RDB$INDEX_NAME ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (1<2 OR (:SCHEMA_NAME IS NULL)) AND (I.RDB$RELATION_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (CASE WHEN C.RDB$CONSTRAINT_NAME IS NULL THEN I.RDB$INDEX_NAME ELSE C.RDB$CONSTRAINT_NAME END = :INDEX_NAME OR (' + ':INDEX_NAME IS NULL)) ' +
            'ORDER BY 3, 4, 6';
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 289);
  Words[0] := 'ACTION';
  Words[1] := 'ACTIVE';
  Words[2] := 'ADD';
  Words[3] := 'ADMIN';
  Words[4] := 'AFTER';
  Words[5] := 'ALL';
  Words[6] := 'ALTER';
  Words[7] := 'AND';
  Words[8] := 'ANY';
  Words[9] := 'AS';
  Words[10] := 'ASC';
  Words[11] := 'ASCENDING';
  Words[12] := 'AT';
  Words[13] := 'AUTO';
  Words[14] := 'AUTODDL';
  Words[15] := 'AVG';
  Words[16] := 'BASED';
  Words[17] := 'BASENAME';
  Words[18] := 'BASE_NAME';
  Words[19] := 'BEFORE';
  Words[20] := 'BEGIN';
  Words[21] := 'BETWEEN';
  Words[22] := 'BLOB';
  Words[23] := 'BLOBEDIT';
  Words[24] := 'BOOLEAN';
  Words[25] := 'BUFFER';
  Words[26] := 'BY';
  Words[27] := 'CACHE';
  Words[28] := 'CASCADE';
  Words[29] := 'CAST';
  Words[30] := 'CHAR';
  Words[31] := 'CHARACTER';
  Words[32] := 'CHARACTER_LENGTH';
  Words[33] := 'CHAR_LENGTH';
  Words[34] := 'CHECK';
  Words[35] := 'CHECK_POINT_LEN';
  Words[36] := 'CHECK_POINT_LENGTH';
  Words[37] := 'COLLATE';
  Words[38] := 'COLLATION';
  Words[39] := 'COLUMN';
  Words[40] := 'COMMIT';
  Words[41] := 'COMMITTED';
  Words[42] := 'COMPILETIME';
  Words[43] := 'COMPUTED';
  Words[44] := 'CLOSE';
  Words[45] := 'CONDITIONAL';
  Words[46] := 'CONNECT';
  Words[47] := 'CONSTRAINT';
  Words[48] := 'CONTAINING';
  Words[49] := 'CONTINUE';
  Words[50] := 'COUNT';
  Words[51] := 'CREATE';
  Words[52] := 'CSTRING';
  Words[53] := 'CURRENT';
  Words[54] := 'CURRENT_DATE';
  Words[55] := 'CURRENT_TIME';
  Words[56] := 'CURRENT_TIMESTAMP';
  Words[57] := 'CURSOR';
  Words[58] := 'DATABASE';
  Words[59] := 'DATE';
  Words[60] := 'DAY';
  Words[61] := 'DB_KEY';
  Words[62] := 'DEBUG';
  Words[63] := 'DEC';
  Words[64] := 'DECIMAL';
  Words[65] := 'DECLARE';
  Words[66] := 'DEFAULT';
  Words[67] := 'DELETE';
  Words[68] := 'DESC';
  Words[69] := 'DESCENDING';
  Words[70] := 'DESCRIBE';
  Words[71] := 'DESCRIPTOR';
  Words[72] := 'DISCONNECT';
  Words[73] := 'DISPLAY';
  Words[74] := 'DISTINCT';
  Words[75] := 'DO';
  Words[76] := 'DOMAIN';
  Words[77] := 'DOUBLE';
  Words[78] := 'DROP';
  Words[79] := 'ECHO';
  Words[80] := 'EDIT';
  Words[81] := 'ELSE';
  Words[82] := 'END';
  Words[83] := 'ENTRY_POINT';
  Words[84] := 'ESCAPE';
  Words[85] := 'EVENT';
  Words[86] := 'EXCEPTION';
  Words[87] := 'EXECUTE';
  Words[88] := 'EXISTS';
  Words[89] := 'EXIT';
  Words[90] := 'EXTERN';
  Words[91] := 'EXTERNAL';
  Words[92] := 'EXTRACT';
  Words[93] := 'FALSE';
  Words[94] := 'FETCH';
  Words[95] := 'FILE';
  Words[96] := 'FILTER';
  Words[97] := 'FLOAT';
  Words[98] := 'FOR';
  Words[99] := 'FOREIGN';
  Words[100] := 'FOUND';
  Words[101] := 'FREE_IT';
  Words[102] := 'FROM';
  Words[103] := 'FULL';
  Words[104] := 'FUNCTION';
  Words[105] := 'GDSCODE';
  Words[106] := 'GENERATOR';
  Words[107] := 'GEN_ID';
  Words[108] := 'GLOBAL';
  Words[109] := 'GOTO';
  Words[110] := 'GRANT';
  Words[111] := 'GROUP';
  Words[112] := 'GROUP_COMMIT_WAIT';
  Words[113] := 'GROUP_COMMIT_WAIT_TIME';
  Words[114] := 'HAVING';
  Words[115] := 'HELP';
  Words[116] := 'HOUR';
  Words[117] := 'IF';
  Words[118] := 'IMMEDIATE';
  Words[119] := 'IN';
  Words[120] := 'INACTIVE';
  Words[121] := 'INDEX';
  Words[122] := 'INDICATOR';
  Words[123] := 'INIT';
  Words[124] := 'INNER';
  Words[125] := 'INPUT';
  Words[126] := 'INPUT_TYPE';
  Words[127] := 'INSERT';
  Words[128] := 'INT';
  Words[129] := 'INTEGER';
  Words[130] := 'INTO';
  Words[131] := 'IS';
  Words[132] := 'ISOLATION';
  Words[133] := 'ISQL';
  Words[134] := 'JOIN';
  Words[135] := 'KEY';
  Words[136] := 'LC_MESSAGES';
  Words[137] := 'LC_TYPE';
  Words[138] := 'LEFT';
  Words[139] := 'LENGTH';
  Words[140] := 'LEV';
  Words[141] := 'LEVEL';
  Words[142] := 'LIKE';
  Words[143] := 'LOGFILE';
  Words[144] := 'LOG_BUFFER_SIZE';
  Words[145] := 'LOG_BUF_SIZE';
  Words[146] := 'LONG';
  Words[147] := 'MANUAL';
  Words[148] := 'MAX';
  Words[149] := 'MAXIMUM';
  Words[150] := 'MAXIMUM_SEGMENT';
  Words[151] := 'MAX_SEGMENT';
  Words[152] := 'MERGE';
  Words[153] := 'MESSAGE';
  Words[154] := 'MIN';
  Words[155] := 'MINIMUM';
  Words[156] := 'MINUTE';
  Words[157] := 'MODULE_NAME';
  Words[158] := 'MONTH';
  Words[159] := 'NAMES';
  Words[160] := 'NATIONAL';
  Words[161] := 'NATURAL';
  Words[162] := 'NCHAR';
  Words[163] := 'NO';
  Words[164] := 'NOAUTO';
  Words[165] := 'NOT';
  Words[166] := 'NULL';
  Words[167] := 'NUMERIC';
  Words[168] := 'NUM_LOG_BUFS';
  Words[169] := 'NUM_LOG_BUFFERS';
  Words[170] := 'OCTET_LENGTH';
  Words[171] := 'OF';
  Words[172] := 'ON';
  Words[173] := 'ONLY';
  Words[174] := 'OPEN';
  Words[175] := 'OPTION';
  Words[176] := 'OR';
  Words[177] := 'ORDER';
  Words[178] := 'OUTER';
  Words[179] := 'OUTPUT';
  Words[180] := 'OUTPUT_TYPE';
  Words[181] := 'OVERFLOW';
  Words[182] := 'PAGE';
  Words[183] := 'PAGELENGTH';
  Words[184] := 'PAGES';
  Words[185] := 'PAGE_SIZE';
  Words[186] := 'PARAMETER';
  Words[187] := 'PASSWORD';
  Words[188] := 'PERCENT';
  Words[189] := 'PLAN';
  Words[190] := 'POSITION';
  Words[191] := 'POST_EVENT';
  Words[192] := 'PRECISION';
  Words[193] := 'PREPARE';
  Words[194] := 'PRESERVE';
  Words[195] := 'PROCEDURE';
  Words[196] := 'PROTECTED';
  Words[197] := 'PRIMARY';
  Words[198] := 'PRIVILEGES';
  Words[199] := 'PUBLIC';
  Words[200] := 'QUIT';
  Words[201] := 'RAW_PARTITIONS';
  Words[202] := 'RDB$DB_KEY';
  Words[203] := 'READ';
  Words[204] := 'REAL';
  Words[205] := 'RECORD_VERSION';
  Words[206] := 'REFERENCES';
  Words[207] := 'RELEASE';
  Words[208] := 'RESERV';
  Words[209] := 'RESERVING';
  Words[210] := 'RESTRICT';
  Words[211] := 'RETAIN';
  Words[212] := 'RETURN';
  Words[213] := 'RETURNING_VALUES';
  Words[214] := 'RETURNS';
  Words[215] := 'REVOKE';
  Words[216] := 'RIGHT';
  Words[217] := 'ROLE';
  Words[218] := 'ROLLBACK';
  Words[219] := 'ROWS';
  Words[220] := 'RUNTIME';
  Words[221] := 'SCHEMA';
  Words[222] := 'SECOND';
  Words[223] := 'SEGMENT';
  Words[224] := 'SELECT';
  Words[225] := 'SET';
  Words[226] := 'SHADOW';
  Words[227] := 'SHARED';
  Words[228] := 'SHELL';
  Words[229] := 'SHOW';
  Words[230] := 'SINGULAR';
  Words[231] := 'SIZE';
  Words[232] := 'SMALLINT';
  Words[233] := 'SNAPSHOT';
  Words[234] := 'SOME';
  Words[235] := 'SORT';
  Words[236] := 'SQLCODE';
  Words[237] := 'SQLERROR';
  Words[238] := 'SQLWARNING';
  Words[239] := 'STABILITY';
  Words[240] := 'STARTING';
  Words[241] := 'STARTS';
  Words[242] := 'STATEMENT';
  Words[243] := 'STATIC';
  Words[244] := 'STATISTICS';
  Words[245] := 'SUB_TYPE';
  Words[246] := 'SUM';
  Words[247] := 'SUSPEND';
  Words[248] := 'TABLE';
  Words[249] := 'TEMPORARY';
  Words[250] := 'TERMINATOR';
  Words[251] := 'THEN';
  Words[252] := 'TIES';
  Words[253] := 'TIME';
  Words[254] := 'TIMESTAMP';
  Words[255] := 'TO';
  Words[256] := 'TRANSACTION';
  Words[257] := 'TRANSLATE';
  Words[258] := 'TRANSLATION';
  Words[259] := 'TRIGGER';
  Words[260] := 'TRIM';
  Words[261] := 'TRUE';
  Words[262] := 'TYPE';
  Words[263] := 'UNCOMMITTED';
  Words[264] := 'UNION';
  Words[265] := 'UNIQUE';
  Words[266] := 'UNKNOWN';
  Words[267] := 'UPDATE';
  Words[268] := 'UPPER';
  Words[269] := 'USER';
  Words[270] := 'USING';
  Words[271] := 'VALUE';
  Words[272] := 'VALUES';
  Words[273] := 'VARCHAR';
  Words[274] := 'VARIABLE';
  Words[275] := 'VARYING';
  Words[276] := 'VERSION';
  Words[277] := 'VIEW';
  Words[278] := 'WAIT';
  Words[279] := 'WEEKDAY';
  Words[280] := 'WHEN';
  Words[281] := 'WHENEVER';
  Words[282] := 'WHERE';
  Words[283] := 'WHILE';
  Words[284] := 'WITH';
  Words[285] := 'WORK';
  Words[286] := 'WRITE';
  Words[287] := 'YEAR';
  Words[288] := 'YEARDAY';
  Result := Words;
end;

function TDBXOpenODBCMetaDataReaderInterbase.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := False;
end;

procedure TDBXOpenODBCMetaDataReaderInterbase.SetContext(const Context: TDBXProviderContext);
begin
  inherited SetContext(Context);
  FDefaultCharSetIsUnicode := (Context.GetVendorProperty(DefaultCharsetIsUnicode) = 'true');
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetAllDataTypes: TDBXDataTypeDescriptionArray;
var
  Newtypes: TDBXDataTypeDescriptionArray;
  StringType: Integer;
begin
  if FAlltypes = nil then
  begin
    SetLength(Newtypes,TypesCount);
    StringType := TDBXDataTypes.AnsiStringType;
    if FDefaultCharSetIsUnicode then
      StringType := TDBXDataTypes.WideStringType;
    Newtypes[CharType] := TDBXDataTypeDescription.Create('CHAR', StringType, 32768, 'CHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned or TDBXTypeFlag.UnicodeOption);
    Newtypes[VarcharType] := TDBXDataTypeDescription.Create('VARCHAR', StringType, 32678, 'VARCHAR({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.Unsigned or TDBXTypeFlag.UnicodeOption);
    Newtypes[IntegerType] := TDBXDataTypeDescription.Create('INTEGER', TDBXDataTypes.Int32Type, 10, 'INTEGER', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[SmallintType] := TDBXDataTypeDescription.Create('SMALLINT', TDBXDataTypes.Int16Type, 5, 'SMALLINT', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[FloatType] := TDBXDataTypeDescription.Create('FLOAT', TDBXDataTypes.SingleType, 53, 'FLOAT({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DoubleType] := TDBXDataTypeDescription.Create('DOUBLE PRECISION', TDBXDataTypes.DoubleType, 53, 'DOUBLE PRECISION', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[NumericType] := TDBXDataTypeDescription.Create('NUMERIC', TDBXDataTypes.BcdType, 18, 'NUMERIC({0}, {1})', 'Precision, Scale', 18, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[DecimalType] := TDBXDataTypeDescription.Create('DECIMAL', TDBXDataTypes.BcdType, 18, 'DECIMAL({0}, {1})', 'Precision, Scale', 18, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
    Newtypes[DateType] := TDBXDataTypeDescription.Create('DATE', TDBXDataTypes.DateType, 0, 'DATE', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[TimeType] := TDBXDataTypeDescription.Create('TIME', TDBXDataTypes.TimeType, 0, 'TIME', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[TimestampType] := TDBXDataTypeDescription.Create('TIMESTAMP', TDBXDataTypes.TimeStampType, 0, 'TIMESTAMP', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
    Newtypes[BlobType] := TDBXDataTypeDescription.Create('BLOB', TDBXDataTypes.BlobType, 2147483647, 'BLOB', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Unsigned or TDBXTypeFlag.StringOption or TDBXTypeFlag.UnicodeOption);
    Newtypes[BooleanType] := TDBXDataTypeDescription.Create('BOOLEAN', TDBXDataTypes.BooleanType, 1, 'BOOLEAN', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.Unsigned);
    FAlltypes := Newtypes;
  end;
  Result := FAlltypes;
end;

function TDBXOpenODBCMetaDataReaderInterbase.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  DataTypes: TDBXDataTypeDescriptionArray;
  Index: Integer;
begin
  GetAllDataTypes;
  SetLength(DataTypes,Length(FAlltypes));
  for Index := 0 to Length(DataTypes) - 1 do
    DataTypes[Index] := TDBXDataTypeDescription.Create(FAlltypes[Index]);
  Result := DataTypes;
end;

//
// SQLite
//

{ TDBXOpenODBCMetaDataCommandFactorySQLite }

class function TDBXOpenODBCMetaDataCommandFactorySQLite.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderSQLite;
end;

{ TDBXOpenODBCMetaDataReaderSQLite }

function TDBXOpenODBCMetaDataReaderSQLite.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  {Result := 'SELECT ' +
     ''''' DB_NAME, ' +
     ''''' SCHEMA_NAME, ' +
     'rtrim(name) NAME, ' +
     'UPPER(rtrim(type)) TYPE_NAME ' +
     //dbg: '  case when type='table' then 1 else 0 end as is_table ' +
   'FROM sqlite_master ' +
   'WHERE LOWER(type) in (''table'', ''view'') ' +
   'and (length(:TABLE_NAME)=0 or :TABLE_NAME=:TABLE_NAME) ' +
   'and UPPER(rtrim(type))  in (:TABLES, :VIEWS) ' +
   'ORDER by 4, LOWER(name) ';{}
  Result := '';
end;

(*
function TDBXOpenODBCMetaDataReaderSQLite.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReaderSQLite.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReaderSQLite.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReaderSQLite.GetReservedWords: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  Result := nil;
  {SetLength(Words, 1);
  Words[0] := 'SELECT';
  Result := Words;{}
end;
//*)

//
// PostgreSQL
//

{ TDBXOpenODBCMetaDataCommandFactoryPostgreSQL }

class function TDBXOpenODBCMetaDataCommandFactoryPostgreSQL.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReaderPostgreSQL;
end;

{ TDBXOpenODBCMetaDataReaderPostgreSQL }

function TDBXOpenODBCMetaDataReaderPostgreSQL.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '/*Tables*/ SELECT '
    //+ 'current_database() AS CatalogName, '
    + 'NULL'#7#7'varchar(1) AS CatalogName, '
    {
    + 'n.nspname AS SchemaName, '
    //+ 'NULL'#7#7'varchar(1) AS SchemaName, '
    //+ 'c.relname AS TableName, '
    + 'n.nspname || ''.''|| c.relname AS TableName, '
    //+ 'CASE WHEN n.nspname=''public'' THEN '''' ELSE n.nspname || ''.'' END || c.relname AS TableName, '
    {}
    + 'NULL'#7#7'varchar(1) AS SchemaName, '
    + '''"'' || n.nspname || ''"."'' || c.relname || ''"'' AS TableName, '
    + 'CASE '
    + 'WHEN c.relkind = ''r'' THEN ''TABLE'' '
    + 'WHEN c.relkind = ''v'' THEN ''VIEW'' '
    + 'END'#7#7'varchar(5) AS TableType ' // ::varchar(5)
    + 'FROM pg_class c '
    + 'INNER JOIN pg_namespace n ON n.oid = c.relnamespace '
    + 'WHERE '
    + '(:CATALOG_NAME is NULL or current_database() = :CATALOG_NAME) and '
    + '(:SCHEMA_NAME is NULL or n.nspname = :SCHEMA_NAME) and '
    + '(not n.nspname in (''information_schema'', ''pg_catalog'')) and '
    + '(:TABLE_NAME is NULL or c.relname = :TABLE_NAME) and '
    //+ 'n.nspname = CURRENT_SCHEMA() and ' // ?
    + 'c.relkind in (''r'', ''v'') '
    + 'and CASE WHEN c.relkind =''r'' THEN ''TABLE'' WHEN c.relkind =''v'' THEN ''VIEW'' END in (:TABLES, :VIEWS) '
    //
    + 'ORDER BY n.nspname, c.relname'
  ;
end;

function TDBXOpenODBCMetaDataReaderPostgreSQL.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '/*Columns*/ SELECT '
    //+ 'current_database() AS CatalogName, '
    + 'NULL'#7#7'varchar(1) AS CatalogName, '
    + 'n.nspname AS SchemaName, '
    + 'c.relname AS TableName, '
    + 'a.attname AS ColumnName, '
    //+ 'a.atttypid AS TypeName, ' // ?
    //+ 'NULL AS TypeName, '
    + 't.typname AS TypeName, '
    //+ '0 AS Precision, ' // ?
    + 'CASE '
    + 'WHEN a.attlen >0 THEN a.attlen '
    + 'ELSE 0 '
    + 'END AS Precision, ' // ?
    + '0 AS Scale, '     // ?
    + 'a.attnum AS Ordinal, '
    + 'pg_get_expr(ad.adbin, ad.adrelid)'#7#7'varchar(255) AS DefaultValue, '
    + '(not a.attnotnull)'#7#7'integer AS IsNullable, ' // ::integer
    + '0=1 AS IsAutoIncrement, '
    + 'NULL'#7#7'integer MaxInline'
    + 'FROM pg_class c '
    + 'INNER JOIN pg_namespace n ON n.oid = c.relnamespace '
    + 'INNER JOIN pg_attribute a ON a.attrelid = c.oid '
    + 'LEFT JOIN pg_attrdef ad ON a.attrelid = ad.adrelid and a.attnum = ad.adnum '
    + 'LEFT JOIN pg_type t ON a.atttypid = t.oid '
    + 'WHERE '
    + '(:CATALOG_NAME is NULL or current_database() = :CATALOG_NAME) and '
    //+ '(:SCHEMA_NAME is NULL or n.nspname = :SCHEMA_NAME) and '
    + '((:SCHEMA_NAME is NULL and n.nspname = ''public'') or n.nspname = :SCHEMA_NAME) and '
    + '(not n.nspname in (''information_schema'', ''pg_catalog'')) and '
    + '(:TABLE_NAME is NULL or c.relname = :TABLE_NAME) and '
    //+ 'n.nspname = CURRENT_SCHEMA() and ' // ?
    + 'c.relkind in (''r'', ''v'') and a.attnum > 0 AND not a.attisdropped '
    + 'ORDER BY n.nspname, c.relname, a.attnum'
  ;
end;

function TDBXOpenODBCMetaDataReaderPostgreSQL.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '/*Indexes*/ SELECT '
    //+ 'current_database() AS CatalogName, '
    + 'NULL'#7#7'varchar(1) AS CatalogName, '
    + 'n.nspname AS SchemaName, '
    + 't.relname AS TableName, '
    + 'c.relname AS IndexName, '
    + 'NULL'#7#7'varchar(1) AS ConstraintName, ' // ?
    //+ '0 AS IsPrimary, '     // ?
    //+ 'CASE WHEN i.indisprimary = 't' THEN 1 ELSE 0 END AS IsPrimary, '
    + 'i.indisprimary'#7#7'integer AS IsPrimary, '
    + 'i.indisunique'#7#7'integer AS IsUnique, ' // ::integer
    + '1 AS IsAscending '
    + 'FROM pg_index i '
    + 'INNER JOIN pg_class c ON c.oid = i.indexrelid '
    + 'INNER JOIN pg_class t ON t.oid = i.indrelid '
    + 'INNER JOIN pg_namespace n ON n.oid = t.relnamespace '
    + 'WHERE '
    + '(:CATALOG_NAME is NULL or current_database() = :CATALOG_NAME) and '
    //+ '(:SCHEMA_NAME is NULL or n.nspname = :SCHEMA_NAME) and '
    + '((:SCHEMA_NAME is NULL and n.nspname = ''public'') or n.nspname = :SCHEMA_NAME) and '
    + '(not n.nspname in (''information_schema'', ''pg_catalog'')) and '
    + '(:TABLE_NAME is NULL or t.relname = :TABLE_NAME) '
    //+ 'n.nspname = CURRENT_SCHEMA() ' // ?
    + 'ORDER BY i.indisprimary desc, i.indisunique desc, n.nspname, t.relname, c.relname'
  ;
end;

function TDBXOpenODBCMetaDataReaderPostgreSQL.GetSqlForIndexColumns: UnicodeString;
var
  CurrentVersion: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  CurrentVersion := Version;
  if CurrentVersion >= '08.03.0000' then
    Result := '/*IndexColumns*/ SELECT '
      //+ 'current_database() AS CatalogName, '
      + 'NULL'#7#7'varchar(1) AS CatalogName, '
      + 'n.nspname AS SchemaName, '
      + 't.relname AS TableName, '
      + 'c.relname AS IndexName, '
      + 'a.attname AS ColumnName, '
      + 'a.attnum AS Ordinal, '
      + '((indoption[index] & 1)= 0)'#7#7'integer  AS IsAscending '
      + 'FROM '
      + '(SELECT generate_series(0, indnatts - 1), indrelid, indexrelid, indkey, '
      + 'indoption, indisunique, indisprimary FROM pg_index i) '
      + 'i(index, indrelid, indexrelid, indkey, indoption, indisunique, indisprimary) '
      + 'INNER JOIN pg_class c ON c.oid = indexrelid '
      + 'INNER JOIN pg_class t ON t.oid = indrelid '
      + 'INNER JOIN pg_namespace n ON n.oid = t.relnamespace '
      + 'INNER JOIN pg_attribute a ON a.attrelid = indrelid and a.attnum = indkey[index] '
      + 'WHERE '
      + '(:CATALOG_NAME is NULL or current_database() = :CATALOG_NAME) and '
      //+ '(:SCHEMA_NAME is NULL or n.nspname = :SCHEMA_NAME) and '
      + '((:SCHEMA_NAME is NULL and n.nspname = ''public'') or n.nspname = :SCHEMA_NAME) and '
      + '(not n.nspname in (''information_schema'', ''pg_catalog'')) and '
      + '(:TABLE_NAME is NULL or t.relname = :TABLE_NAME) and '
      //+ 'n.nspname = CURRENT_SCHEMA() ' // ?
      + '(:INDEX_NAME is NULL or c.relname = :INDEX_NAME) '
      + 'ORDER BY '
      + 'n.nspname, t.relname, c.relname, a.attnum'
  else
    Result := '/*IndexColumns*/ SELECT '
      //+ 'current_database() AS CatalogName, '
      + 'NULL'#7#7'varchar(1) AS CatalogName, '
      + 'n.nspname AS SchemaName, '
      + 't.relname AS TableName, '
      + 'c.relname AS IndexName, '
      + 'a.attname AS ColumnName, '
      + 'a.attnum AS Ordinal, '
      + '1 AS IsAscending '
      + 'FROM pg_index i '
      + 'INNER JOIN pg_class c ON c.oid = i.indexrelid '
      + 'INNER JOIN pg_class t ON t.oid = i.indrelid '
      + 'INNER JOIN pg_namespace n ON n.oid = t.relnamespace '
      + 'INNER JOIN pg_attribute a ON a.attrelid = i.indrelid and a.attnum = any (i.indkey) '
      + 'WHERE '
      + '(:CATALOG_NAME is NULL or current_database() = :CATALOG_NAME) and '
      //+ '(:SCHEMA_NAME is NULL or n.nspname = :SCHEMA_NAME) and '
      + '((:SCHEMA_NAME is NULL and n.nspname = ''public'') or n.nspname = :SCHEMA_NAME) and '
      + '(not n.nspname in (''information_schema'', ''pg_catalog'')) and '
      + '(:TABLE_NAME is NULL or t.relname = :TABLE_NAME) and '
      //+ 'n.nspname = CURRENT_SCHEMA() ' // ?
      + '(:INDEX_NAME is NULL or c.relname = :INDEX_NAME) '
      + 'ORDER BY '
      + 'n.nspname, t.relname, c.relname, a.attnum'
  ;
end;

function TDBXOpenODBCMetaDataReaderPostgreSQL.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  SetLength(Words, 44);
  Words[0] := 'ALL';
  Words[1] := 'AND';
  Words[2] := 'AS';
  Words[3] := 'BEGIN';
  Words[4] := 'BY';
  Words[5] := 'COMMIT';
  Words[6] := 'DELETE';
  Words[7] := 'DISTINCT';
  Words[8] := 'END';
  Words[9] := 'EXECUTE';
  Words[10] := 'FETCH';
  Words[11] := 'FOR';
  Words[12] := 'FROM';
  Words[13] := 'FULL';
  Words[14] := 'GROUP';
  Words[15] := 'HAVING';
  Words[16] := 'INNER';
  Words[17] := 'INSERT';
  Words[18] := 'INTO';
  Words[19] := 'IS';
  Words[20] := 'JOIN';
  Words[21] := 'LEFT';
  Words[22] := 'LIMIT';
  Words[23] := 'LOCK';
  Words[24] := 'MINUS';
  Words[25] := 'NOT';
  Words[26] := 'OFFSET';
  Words[27] := 'ON';
  Words[28] := 'OR';
  Words[29] := 'ORDER';
  Words[30] := 'OUTER';
  Words[31] := 'RELEASE';
  Words[32] := 'RETURNING';
  Words[33] := 'RIGHT';
  Words[34] := 'ROLLBACK';
  Words[35] := 'SAVEPOINT';
  Words[36] := 'SELECT';
  Words[37] := 'SET';
  Words[38] := 'TO';
  Words[39] := 'TRANSACTION';
  Words[40] := 'UNION';
  Words[41] := 'UPDATE';
  Words[42] := 'WHERE';
  Words[43] := 'WITH';
  Result := Words;
end;

initialization
//
// ORACLE
//
  TDBXOpenODBCMetaDataCommandFactoryOracle.RegisterMetaDataCommandFactory;
//
// MSSQL
//
  TDBXOpenODBCMetaDataCommandFactoryMSSQL.RegisterMetaDataCommandFactory;
//
// MySQL
//
  TDBXOpenODBCMetaDataCommandFactoryMySQL.RegisterMetaDataCommandFactory;
//
// SybaseASA
//
  TDBXOpenODBCMetaDataCommandFactorySybaseASA.RegisterMetaDataCommandFactory;
//
// SybaseASE
//
  TDBXOpenODBCMetaDataCommandFactorySybaseASE.RegisterMetaDataCommandFactory;
//
// DB2
//
  TDBXOpenODBCMetaDataCommandFactoryDB2.RegisterMetaDataCommandFactory;
//
// Informix
//
  TDBXOpenODBCMetaDataCommandFactoryInformix.RegisterMetaDataCommandFactory;
//
// DataStorage
//
  TDBXOpenODBCMetaDataCommandFactoryDataStorage.RegisterMetaDataCommandFactory;
//
// Firebird
//
  TDBXOpenODBCMetaDataCommandFactoryFirebird.RegisterMetaDataCommandFactory;
//
// Interbase
//
  TDBXOpenODBCMetaDataCommandFactoryInterbase.RegisterMetaDataCommandFactory;
//
// SQLite
//
  TDBXOpenODBCMetaDataCommandFactorySQLite.RegisterMetaDataCommandFactory;
//
// PostgreSQL
//
  TDBXOpenODBCMetaDataCommandFactoryPostgreSQL.RegisterMetaDataCommandFactory;
finalization
//
// ORACLE
//
  TDBXOpenODBCMetaDataCommandFactoryOracle.UnRegisterMetaDataCommandFactory;
//
// MSSQL
//
  TDBXOpenODBCMetaDataCommandFactoryMSSQL.UnRegisterMetaDataCommandFactory;
//
// MySQL
//
  TDBXOpenODBCMetaDataCommandFactoryMySQL.UnRegisterMetaDataCommandFactory;
//
// SybaseASA
//
  TDBXOpenODBCMetaDataCommandFactorySybaseASA.UnRegisterMetaDataCommandFactory;
//
// SybaseASE
//
  TDBXOpenODBCMetaDataCommandFactorySybaseASE.UnRegisterMetaDataCommandFactory;
//
// DB2
//
  TDBXOpenODBCMetaDataCommandFactoryDB2.UnRegisterMetaDataCommandFactory;
//
// Informix
//
  TDBXOpenODBCMetaDataCommandFactoryInformix.UnRegisterMetaDataCommandFactory;
//
// DataStorage
//
  TDBXOpenODBCMetaDataCommandFactoryDataStorage.UnRegisterMetaDataCommandFactory;
//
// Firebird
//
  TDBXOpenODBCMetaDataCommandFactoryFirebird.UnRegisterMetaDataCommandFactory;
//
// Interbase
//
  TDBXOpenODBCMetaDataCommandFactoryInterbase.UnRegisterMetaDataCommandFactory;
//
// SQLite
//
  TDBXOpenODBCMetaDataCommandFactorySQLite.UnRegisterMetaDataCommandFactory;
//
// PostgreSQL
//
  TDBXOpenODBCMetaDataCommandFactoryPostgreSQL.UnRegisterMetaDataCommandFactory;

{$IFEND CompilerVersion >= 18.50}
{$ENDIF CONDITIONALEXPRESSIONS}
end.
