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

  Based on idea:
    zmars:
      https://sourceforge.net/projects/open-dbexpress/forums/forum/119358/topic/3490684
}
unit Dbx34Drv;
//
// + Delphi 2012 XE2
// + Delphi 2011 XE
// + Delphi 2010 : ide debugger: trap app on TSQLConnection reconnect (only for msjet odbc driver (dbf,db,xls,csv) ).
// + Delphi 2009
// + Delphi 2007
//

(*
{$UNDEF _DBX4_}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 18.50}   // Delphi 2007 Up
    {$DEFINE _DBX4_}
  {$IFEND}
{$ENDIF}
//*)

interface

{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 18.50}

{$IF CompilerVersion < 15.00}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
    {$DEFINE POSIX}
  {$ENDIF}
{$IFEND}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ELSE}
  {$IFDEF _KYLIX_}
  Types, Libc,
  {$ELSE}
  {$IFDEF POSIX}
  //Posix.Unistd, Posix.String_,
  {$ENDIF}{$ENDIF}{$ENDIF}
  SysUtils, Classes,
  {$IF CompilerVersion >= 23.00}
  Data.DBXClassRegistry,
  {$ELSE}
  ClassRegistry,
  {$IFEND}
  DB, DBCommonTypes, DBXCommon, DBXPlatform, DBXDynalink, DBXDynalinkNative,
  DBXMetaDataReader, 
  //DBXMetaDataCommand, 
  DBXMetaDataCommandFactory,
  {$IF CompilerVersion <= 18.50}
  DBXPlatformUtil, DBXTableStorage, DBXDelegate, WideStrings,
  {$IFEND}
  {$IF CompilerVersion > 18.50}
  DBXCommonTable,
  {$IFEND}
  DBXMetaDataNames;

type
  EDBXError = class(EDatabaseError);
  EDbxOODBCDriverError = class(EDBXError);

  {$IF CompilerVersion <= 18.50}
const
  NullString = '';

type
  UnicodeString = WideString;

  TDBXStringArray  = DBXPlatformUtil.TDBXWideStringArray; // array of UnicodeString;
  TDBXObjectStore = DBXPlatformUtil.TDBXObjectStore;
  TDBXArrayList = DBXPlatformUtil.TDBXArrayList;
  TDBXTable = DBXTableStorage.TDBXTableStorage;

  TDBXDataTypes = class(DBXCommon.TDBXDataTypes)
  const
    SingleType         = 27;
    Int8Type           = 28;
    Uint8Type          = 29;
    ObjectType         = 30;
    CharArrayType      = 31;
    IntervalType       = 32;
    //
    TimeStampOffsetType   = 36;
  end;

  TDBXOpenOdbcPropertyNames = class(DBXCommon.TDBXPropertyNames)
  const
    MetaDataPackageLoader = 'MetaDataPackageLoader';
  end;

  TDBXValueTypeArray = DBXTableStorage.TDBXColumnDescriptorArray; //array of TDBXValueType;

  TDBXEmptyTableCursor = DBXMetaDataReader.TDBXBaseMetaDataReader.TDBXEmptyTableCursor;
  TDBXCustomMetaDataTable = DBXMetaDataReader.TDBXBaseMetaDataReader.TDBXSanitizedTableCursor;

  TDBXDynalinkPropertyNames = class
    const
      BlobSize = 'BlobSize'; {Do not Resource}
      //ErrorResourceFile = 'ErrorResourceFile'; {Do not Resource}
      LocaleCode = 'LocaleCode'; {Do not Resource}
      //Compressed = 'Compressed'; {Do not Resource}
      //Encrypted = 'Encrypted'; {Do not Resource}
  end;

  {$ELSE}
  TDBXOpenOdbcPropertyNames = class(DBXCommon.TDBXPropertyNames); //@@@
  TDBXDynalinkPropertyNames = DBXDynalink.TDBXDynalinkPropertyNames;

  {$IF CompilerVersion < 21.00}
  TDBXDataTypes = class(DBXCommon.TDBXDataTypes)
  const
    TimeStampOffsetType   = 36;
  end;
  {$IFEND}

  {$IFEND}

  TDBXPropertyNames = class(TDBXOpenOdbcPropertyNames)
  const
    {$IF CompilerVersion <= 18.50}
    ProductVersion = 'ProductVersion';
    {$IFEND}
    {$IF CompilerVersion < 22.00}
    RowSetSize = 'RowSetSize';
    {$IFEND}
    MetaDataDisabled = 'MetaDataDisabled';
    MetadataSQL = 'MetadataSQL';
    MetadataDBX = 'MetadataDBX';
    UseAnsiStrings = 'UseAnsiStrings';
  end;

  {$IF CompilerVersion > 18.50}
  TDbxOpenOdbcDriver = class(TDBXDynalinkDriverNative)
  protected
    function CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; override;
    procedure LoadDriverWithConnectionBuilder(ConnectionBuilder: TDBXConnectionBuilder);
    function CreateCommandOpenOdbc(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
  public
    //procedure AfterConstruction; override;

    constructor Create(DriverDef: TDBXDriverDef); {$IF CompilerVersion > 18.50} override; {$IFEND}

    procedure GetDriverPropertyNames(List: TStrings); override;
    function GetDriverVersion: UnicodeString; override;
  end;
  {$IFEND CompilerVersion > 18.50}

  {.$IF CompilerVersion > 18.50}
  TDBXOpenOdbcProperties = class(TDBXProperties)
  strict private
    function GetConnectionString: string;
    procedure SetConnectionString(const Value: string);

    function GetDatabase: string;
    procedure SetDatabase(const Value: string);

    function GetUserName: string;
    procedure SetUserName(const Value: string);

    function GetPassWord: string;
    procedure SetPassWord(const Value: string);

    function GetBlobSize: Integer;
    procedure SetBlobSize(const Value: Integer);

    function GetOdbcTransIsolation: string;
    procedure SetOdbcTransIsolation(const Value: string);

    function GetDecimalSeparator: string;
    procedure SetDecimalSeparator(const Value: string);

    function GetTrimChar: Boolean;
    procedure SetTrimChar(const Value: Boolean);

    function GetCustomString: string;
    procedure SetCustomString(const Value: string);
  public
    //const StrDriverName = 'DbxOpenOdbc';
    const StrConnectionString = 'ConnectionString';
    const StrTrimChar = 'Trim Char';
    const StrOdbcTransIsolation = 'DbxOpenOdbc TransIsolation';
    const StrDecimalSeparator = 'Decimal Separator';
    const StrCustomString = 'Custom String';
    const StrPrepareSQL = 'Prepare SQL';
  public
    constructor Create(DBXContext: TDBXContext); {$IF CompilerVersion > 18.50} override; {$IFEND}
  {$IF CompilerVersion > 18.50}
  published
  {$IFEND}
    property ConnectionString: string read GetConnectionString write SetConnectionString;
    property Database: string read GetDatabase write SetDatabase;
    property UserName: string read GetUserName write SetUserName;
    property PassWord: string read GetPassWord write SetPassWord;
    property BlobSize: Integer read GetBlobSize write SetBlobSize;
    property OdbcTransIsolation:string read GetOdbcTransIsolation write SetOdbcTransIsolation;
    property DecimalSeparator: string read GetDecimalSeparator write SetDecimalSeparator;
    property TrimChar: Boolean read GetTrimChar write SetTrimChar;
    property CustomString: string read GetCustomString write SetCustomString;
  end;
  {.$IFEND CompilerVersion > 18.50}

  TDBXDynalinkDriverLoaderOpenOdbc = class(TDBXDynalinkDriverLoader)
  private
  {$IF CompilerVersion > 18.50}
    procedure FreeOldLibrary;
    procedure LoadDriverLibraryAndMethodTable(DBXContext: TDBXContext; Properties: TDBXProperties);
  {.$IF CompilerVersion <= 18.50}
  protected
    property MethodTable: TDBXMethodTable read FMethodTable write FMethodTable;
    property DriverHandle: TDBXDriverHandle read FDriverHandle write FDriverHandle;
  {$IFEND}
  {$IF CompilerVersion <= 18.50} // D2007
  public
    function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;
    function  CreateDynalinkDriver: TDBXDynalinkDriver; override;
  {$IFEND CompilerVersion <= 18.50}
  end;

  {$IF CompilerVersion <= 18.50} // D2007
  TDBXDynalinkDriverNativeOpenOdbc = class(TDBXDynalinkDriverNative)
  protected
    //function  CreateMorphCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; override;
    function CreateConnection(ConnectionBuilder:  TDBXConnectionBuilder): TDBXConnection; override; // transfer connection options
  end;
  {$IFEND CompilerVersion <= 18.50}

  //TDBXDatabaseMetaDataOpenOdbc = class(TDBXDatabaseMetaData)
  //end;

  TDBXDynalinkConnectionOpenOdbc = class(TDBXDynalinkConnection)
  const
    dbxoodbc_version_min = '3.2012.04.07';
  private
    FDBMSVersion: UnicodeString;
    FQuoteChar: UnicodeString;
    //FDatabaseMetaData: TDBXDatabaseMetaData;
    procedure DoDerivedOpenBefore;
    procedure DoDerivedOpenAfter;
  protected
    function GetProductVersion: UnicodeString; override;
    function GetProductName: UnicodeString; override;

     {$IF CompilerVersion > 18.50}
    procedure DerivedGetCommands(const CommandType: UnicodeString; const List: TStrings); override; { empty }
    {$ELSE}
    procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); override; { empty }
    {$IFEND}
     {$IF CompilerVersion > 18.50}
    procedure DerivedGetCommandTypes(const List: TStrings); override; { empty }
    {$ELSE}
    procedure DerivedGetCommandTypes(List: TWideStrings); override; { empty }
    {$IFEND}

    procedure DerivedOpen; override;
     {$IF CompilerVersion > 18.50}
    procedure DerivedClose; override; { empty }
    {$IFEND}
    function  DerivedCreateCommand: TDBXCommand; override;
    function  GetDatabaseMetaData: TDBXDatabaseMetaData; override;
  public
    procedure Close; override;
    function GetVendorProperty(const Name: UnicodeString): UnicodeString; override;
  end;

  TDBXMorphicCommandOpenOdbc = class(TDBXMorphicCommand)
  protected
    function DerivedExecuteQuery: TDBXReader; override;
    //procedure SetText(const Value: UnicodeString); override;
  public
    constructor Create(DBXContext: TDBXContext; Connection: TDBXConnection); reintroduce;
    //function  ExecuteQuery: TDBXReader; override;
  end;

  TDBXDataExpressProviderContextOpenOdbc = class(TDBXDataExpressProviderContext)
  {$IF CompilerVersion < 23.00} // XE2
  private
    FConnection: TDBXConnection;
    procedure SetConnection(Value: TDBXConnection);
  public
    property Connection: TDBXConnection read FConnection write SetConnection;
  {$IFEND}
  end;

  TDBXCustomOpenODBCMetaDataReader = class(TDBXBaseMetaDataReader)
  protected
    //const Colon = ':';
    //const Dot = '.';
    const DoubleQuote = '"';

  protected
    FMetadataInitialized: Boolean;

    //FDefaultCharSetIsUnicode: Boolean;
    FQuoteChar: UnicodeString;
    FUseAnsiStrings: Integer;

    procedure InitMetadata(Connection: TDBXDynalinkConnectionOpenOdbc);
    procedure CheckMetadata();
  protected
    procedure SetContext(const Context: TDBXProviderContext); override;
     {$IF CompilerVersion <= 18.50}
    procedure PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); reintroduce; virtual;
    {$IFEND}
    //
    function GetProductName: UnicodeString; override;
    //function GetSqlDefaultParameterMarker: UnicodeString; virtual;
    function GetSqlIdentifierQuotePrefix: UnicodeString; override;
    function GetSqlIdentifierQuoteSuffix: UnicodeString; override;
    //function IsQuotedIdentifiersSupported: Boolean; override;
    function IsParameterMetadataSupported: Boolean; {$IF CompilerVersion >= 22.00} override; {$ELSE} virtual; {$IFEND}
    function IsLowerCaseIdentifiersSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsDescendingIndexSupported: Boolean; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function GetSqlIdentifierQuoteChar: UnicodeString; override;
    function GetSqlProcedureQuoteChar: UnicodeString; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function IsTransactionsSupported: Boolean; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean; override;
    //
    function GetUseAnsiStrings: Boolean; // virtual;
  end;

  TDBXOpenODBCMetaDataCommand = class(TDBXMetaDataCommand)
  protected
    function DerivedExecuteQuery: TDBXReader; override;
  end;

  TDBXOpenODBCMetaDataReader = class;
  TDBXOpenODBCMetaDataReaderClass = class of TDBXOpenODBCMetaDataReader;

  TMetadataMode = set of (mmSQL, mmDBX);

  TDBXOpenODBCMetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  protected
    FDBXMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
    FCurrentConnection: TDBXConnection;
    fMetadataSupported: Integer;
    fMetadataMode: TMetadataMode;
    FUseAnsiStrings: Integer;

    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; virtual;
    procedure InitMetaDataReaderClass(Connection: TDBXConnection);
  public
    function CreateMetaDataReader: TDBXMetaDataReader; overload; override;
    function CreateMetaDataReader(Connection: TDBXConnection): TDBXCustomOpenODBCMetaDataReader; reintroduce; overload;
    function CreateCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; override;

    function GetProductName: UnicodeString; {$IF CompilerVersion > 18.50} override; {$IFEND}

    class procedure RegisterMetaDataCommandFactory;
    class procedure UnRegisterMetaDataCommandFactory;
  end;
  TDBXOpenODBCMetaDataCommandFactoryClass = class of TDBXOpenODBCMetaDataCommandFactory;

  TDBXOpenODBCMetaDataCommandFactoryCustom = class(TDBXOpenODBCMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

  TDBXOpenODBCMetaDataReader = class(TDBXCustomOpenODBCMetaDataReader)
  protected
    fMetadataSupported: Boolean;
    fMetadataMode: TMetadataMode;
    fDbxMode: Boolean;

    //procedure BeginMetadataQuery;
    //procedure EndMetadataQuery;
  protected
    function GetProductName: UnicodeString; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean; override;
    function GetSqlForSchemas: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForViews: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetSqlForForeignKeys: UnicodeString; override;
    function GetSqlForForeignKeyColumns: UnicodeString; override;
    function GetSqlForSynonyms: UnicodeString; override;
    function GetSqlForProcedures: UnicodeString; override;
    function GetSqlForProcedureSources: UnicodeString; override;
    function GetSqlForProcedureParameters: UnicodeString; override;
    function GetSqlForPackages: UnicodeString; override;
    function GetSqlForPackageSources: UnicodeString; override;
    function GetSqlForPackageProcedures: UnicodeString; override;
    function GetSqlForPackageProcedureParameters: UnicodeString; override;
    function GetSqlForUsers: UnicodeString; override;
    function GetSqlForRoles: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    { TDBXBaseMetaDataReader }
  public
    //procedure AfterConstruction; override;

    constructor Create; virtual;

    function FetchDataTypes: TDBXTable; override;
    function FetchCatalogs: TDBXTable; override;
    function FetchSchemas(const Catalog: UnicodeString): TDBXTable; override;
    function FetchTables(const Catalog: UnicodeString; const Schema: UnicodeString; const TableName: UnicodeString; const TableType: UnicodeString): TDBXTable; override;
    function FetchViews(const Catalog: UnicodeString; const Schema: UnicodeString; const View: UnicodeString): TDBXTable; override;
    function FetchColumns(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString): TDBXTable; override;
    function FetchColumnConstraints(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString): TDBXTable; override;
    function FetchIndexes(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString): TDBXTable; override;
    function FetchIndexColumns(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString; const Index: UnicodeString): TDBXTable; override;
    function FetchForeignKeys(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString): TDBXTable; override;
    function FetchForeignKeyColumns(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString; const ForeignKeyName: UnicodeString; const PrimaryCatalog: UnicodeString; const PrimarySchema: UnicodeString; const PrimaryTable: UnicodeString; const PrimaryKeyName: UnicodeString): TDBXTable; override;
    function FetchSynonyms(const Catalog: UnicodeString; const Schema: UnicodeString; const Synonym: UnicodeString): TDBXTable; override;
    function FetchProcedures(const Catalog: UnicodeString; const Schema: UnicodeString; const ProcedureName: UnicodeString; const ProcedureType: UnicodeString): TDBXTable; override;
    function FetchProcedureSources(const Catalog: UnicodeString; const Schema: UnicodeString; const &Procedure: UnicodeString): TDBXTable; override;
    function FetchProcedureParameters(const Catalog: UnicodeString; const Schema: UnicodeString; const &Procedure: UnicodeString; const Parameter: UnicodeString): TDBXTable; override;
    function FetchPackages(const Catalog: UnicodeString; const Schema: UnicodeString; const PackageName: UnicodeString): TDBXTable; override;
    function FetchPackageProcedures(const Catalog: UnicodeString; const Schema: UnicodeString; const PackageName: UnicodeString; const ProcedureName: UnicodeString; const ProcedureType: UnicodeString): TDBXTable; override;
    function FetchPackageProcedureParameters(const Catalog: UnicodeString; const Schema: UnicodeString; const PackageName: UnicodeString; const ProcedureName: UnicodeString; const ParameterName: UnicodeString): TDBXTable; override;
    function FetchPackageSources(const Catalog: UnicodeString; const Schema: UnicodeString; const PackageName: UnicodeString): TDBXTable; override;
    function FetchUsers: TDBXTable; override;
    function FetchRoles: TDBXTable; override;
    function FetchReservedWords: TDBXTable; override;
  end;

{$IFEND CompilerVersion >= 18.50}
{$ENDIF CONDITIONALEXPRESSIONS}

{$IFDEF CONDITIONALEXPRESSIONS}
var
  bIsDbx34Drv: Boolean = False;
{$ENDIF}

implementation

{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 18.50}

uses
  DbxXXDrv, Dbx34DrvDbms, StrUtils;

{$IFOPT R+}
  {$DEFINE RANGECHECKS_ON}
{$ELSE}
  {$DEFINE RANGECHECKS_OFF}
{$ENDIF}

const
  DBX4_CMD_PREFIX = '@DBX_';
  DBX4_CMD_EMPTY_CURSOR = DBX4_CMD_PREFIX + '@';
  DBX4_CMD_PARAM_DELIMITER = #1;
//
// GetVendorProperty commands:
//
  //
  // full command name (with prefix)
  //
  cfvp_Supported = 'dbxoodbc:dbx34';
  cfvp_GetVersion = 'dbxoodbc:version';
  cfvp_GetQuoteCharacter = 'dbxoodbc:GetQuoteCharacter';
  cfvp_SetQuotationEnabled = 'dbxoodbc:SetQuotationEnabled';
  cfvp_SetMetadataQueryBegin = 'dbxoodbc:MetadataQueryBegin';
  cfvp_SetMetadataQueryEnd = 'dbxoodbc:MetadataQueryEnd';
  cfvp_GetMetadataSupported = 'dbxoodbc:GetMetadataSupported';
//  cfvp_GetReservedWords = 'dbxoodbc:GetReserverWords';
  //
  // short command name (without prefix "DBX4_CMD_PREFIX")
  //
  csvp_SetVendorLib = 'SetVendorLib';
  csvp_SetCustomString = 'SetCustomString';
//
// GetVendorProperty commands.
//

//function DBXStringArrayToParams(P: TDBXStringArray): UnicodeString;
//var
//  i: Integer;
//begin
//  Result := '';
//  for i := 0 to High(P) do
//    Result := Result + ' :' + P[i]
//end;
//
//function DBXStringArrayToQueryParams(P: TDBXStringArray): UnicodeString;
//var
//  i: Integer;
//begin
//  Result := '';
//  for i := 0 to High(P) do
//    Result := Result + DBX4_CMD_PARAM_DELIMITER + P[i]
//end;

function DBXStringArrayToNamedQueryParams(N, P: TDBXStringArray): UnicodeString;
var
  i, iHigh: Integer;
  V: UnicodeString;
begin
  Result := '';
  iHigh := High(N);
  if iHigh > High(P) then
    iHigh := High(P);
  for i := 0 to iHigh do
  begin
    V := P[i];
    if Pos(DBX4_CMD_PARAM_DELIMITER, V) > 0 then
      V := '';
    Result := Result
      + DBX4_CMD_PARAM_DELIMITER + N[i]
      + DBX4_CMD_PARAM_DELIMITER + V;
  end;
end;

function DBXStringArrayToErrorInfo(N, P: TDBXStringArray): string;
var
  i, iHigh: Integer;
  V, R: UnicodeString;
begin
  R := '';
  iHigh := High(N);
  if iHigh > High(P) then
    iHigh := High(P);
  for i := 0 to iHigh do
  begin
    V := P[i];
    if Pos(DBX4_CMD_PARAM_DELIMITER, V) > 0 then
      V := '';
    R := R
      + ' ' + N[i]
      + ' = ' + V + ';';
  end;
  Result := string(R);
end;

type
  TDXBStrings = {$IFDEF UNICODE}TStrings{$ELSE}TWideStrings{$ENDIF};
  TDXBStringList = {$IFDEF UNICODE}TStringList{$ELSE}TWideStringList{$ENDIF};

{$IF CompilerVersion < 22.00} // < D2011 (XE)
function TDXBStrings_ToStringArray(L: TDXBStrings): TDBXStringArray;
var
  I: Integer;
begin
  SetLength(Result, L.Count);
  for I := 0 to L.Count - 1 do
    Result[I] := L.Strings[I];
end;
{$IFEND}

function DBXStringArrayFromStrings(L: TDXBStrings): TDBXStringArray; overload;
begin
  if Assigned(L) then
  begin
    {$IF CompilerVersion >= 22.00} // D2011 XE
    Result := TDBXStringArray(L.ToStringArray)
    {$ELSE}
    Result := TDXBStrings_ToStringArray(L);
    {$IFEND}
  end
  else
    Result := nil;
end;

function DBXStringArrayFromStrings(const S: UnicodeString): TDBXStringArray; overload;
var
  L: TDXBStrings;
begin
  if S <> '' then
  begin
    L := TDXBStringList.Create;
    try
      L.Text := S;
      {$IF CompilerVersion >= 22.00} // D2011 XE
      Result := TDBXStringArray(L.ToStringArray);
      {$ELSE}
      Result := TDXBStrings_ToStringArray(L);
      {$IFEND}
    finally
      L.Free;
    end;
  end
  else
    Result := nil;
end;

//
// GetVendorProperty methods:
//

procedure ErrorGetVendorPropertyCommand(const ACommand, AError: string; N, P: TDBXStringArray);
var
  S: string;
begin
  S := 'DBXOODBC Error (' + Trim(AError) + '): "GetVendorProperty" command "'
    + ACommand + DBXStringArrayToErrorInfo(N, P);
  raise EDbxOODBCDriverError.Create(S);
end;

procedure CheckGetVendorPropertyCommand(const AStatus, ACommand: string; N, P: TDBXStringArray);
begin
  if not SameText(AStatus, 'true') then
    ErrorGetVendorPropertyCommand(ACommand, AStatus, N, P);
end;

//
// GetVendorProperty methods.
//

function CheckPathEnvironmet(var LibraryPath, LibraryName: UnicodeString): Boolean; // returned modification state
var
  iLen, iPos, iLenBuf: Integer;
  wsEnvName, wsEnvValue: UnicodeString;
  {$IFNDEF POSIX}
  sEnvName, sEnvValue: AnsiString;
  {$ENDIF}
begin
  Result := False;
  iLen := Length(LibraryPath);
  if (iLen <= 2) or (LibraryPath[1] <> '%') then
    Exit;
  iPos := PosEx('%', LibraryPath, 3);
  if iPos < 3 then
    Exit;
  wsEnvName := Copy(LibraryPath, 2, iPos-2);
  {$IFDEF MSWINDOWS}
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then // Windows Me/98/95:  GetEnvironmentVariableW is supported by the Microsoft Layer for Unicode.
  begin
    SetLength(wsEnvValue, 32767);
    iLenBuf := GetEnvironmentVariableW(PWideChar(wsEnvName), PWideChar(wsEnvValue), Length(wsEnvValue));
    if iLenBuf > 0 then
      SetLength(wsEnvValue, iLenBuf);
  end
  else
  begin
    sEnvName := AnsiString(wsEnvName);
    SetLength(sEnvValue, 32767);
    iLenBuf := GetEnvironmentVariableA(PAnsiChar(sEnvName), PAnsiChar(sEnvValue), Length(sEnvValue));
    if iLenBuf > 0 then
    begin
      SetLength(sEnvValue, iLenBuf);
      wsEnvValue := UnicodeString(sEnvValue);
    end;
  end;
  {$ELSE !MSWINDOWS}
  {$IFDEF POSIX}
    wsEnvValue := WideString(GetEnvironmentVariable(string(wsEnvName)));
    iLenBuf := Length(wsEnvValue);
  {$ELSE !POSIX}
  ERROR_PLATFORM_NOT_SUPPORTED
  {$ENDIF !POSIX}
  {$ENDIF !MSWINDOWS}
  if (iLenBuf > 0) and (wsEnvValue <> '') then
  begin
    LibraryPath := wsEnvValue + Copy(LibraryPath, iPos+1, iLen);
    LibraryName := LibraryPath + ExtractFileName(LibraryName);
    Result := True;
  end;
end;

function CheckLibraryPath(var LibraryName: UnicodeString): Boolean; // returned modification state
var
  LibraryPath: UnicodeString;
begin
  Result := False;
  if LibraryName <> '' then
  begin
    LibraryPath := ExtractFilePath(LibraryName);
    if LibraryPath <> '' then
    begin
      Result := CheckPathEnvironmet(LibraryPath, LibraryName);
      if not FileExists(LibraryName) then
      begin
        LibraryName := ExtractFileName(LibraryName);
        Result := True;
      end;
    end;
  end;
end;

function CheckLibraryName(var sLibraryName: UnicodeString): Boolean; // returned modification state
begin // debug: '%SystemDrive%\delphi\2010\projects\bpl\dbxoodbc.dll'
  if sLibraryName = '' then
  begin
    sLibraryName := UnicodeString(DbxOODBCDriverLibname);
    Result := True;
  end
  else
    Result := CheckLibraryPath(sLibraryName);
end;

function CheckVendorLib(var sVendorLib: UnicodeString): Boolean; // returned modification state
begin  // debug: '%windir%\System32\odbc32.dll'
  if sVendorLib = '' then
  begin
    sVendorLib := UnicodeString(DbxOODBCDriverVendorLib);
    Result := True;
  end
  else
    Result := CheckLibraryPath(sVendorLib);
end;

{ TDbxOpenOdbcDriver }

{$IF CompilerVersion > 18.50}

constructor TDbxOpenOdbcDriver.Create(DriverDef: TDBXDriverDef);
begin
{$IF CompilerVersion > 18.50}
  inherited Create(DriverDef, TDBXDynalinkDriverLoader);
  InitDriverProperties(TDBXOpenOdbcProperties.Create(DriverDef.FDBXContext));
  // '' makes this the default command factory. But, Will get the "Duplicates not allowed" in XE2 up.
  //AddCommandFactory('', CreateCommandOpenOdbc);
  AddCommandFactory('DbxOpenOdbc', CreateCommandOpenOdbc);
  //AddCommandFactory(TDBXCommandTypes.DbxMetaData
{$ELSE}
  raise EDbxOODBCDriverError.Create('Not Implemented: TDbxOpenOdbcDriver.Create(DriverDef: TDBXDriverDef)');
{$IFEND}
end;

//procedure TDbxOpenOdbcDriver.AfterConstruction;
//begin
//  inherited;
//end;

function TDbxOpenOdbcDriver.CreateCommandOpenOdbc(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
begin
  Result := TDBXMorphicCommandOpenOdbc.Create(DbxContext, Connection);
end;

function TDbxOpenOdbcDriver.CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
var
  ConnectionHandle: TDBXConnectionHandle;
  ErrorResult: TDBXErrorCode;
begin   {check old logic}{result:=inherited CreateConnection(ConnectionBuilder); exit;{@@@}
  LoadDriverWithConnectionBuilder(ConnectionBuilder);
  ErrorResult := FMethodTable.FDBXDriver_CreateConnection(FDriverHandle, ConnectionHandle);
  CheckResult(ErrorResult);
  Result := TDBXDynalinkConnectionOpenOdbc.Create(ConnectionBuilder, ConnectionHandle, FMethodTable);
end;

procedure TDbxOpenOdbcDriver.LoadDriverWithConnectionBuilder(ConnectionBuilder: TDBXConnectionBuilder);
var
  Loader: TDBXDynalinkDriverLoaderOpenOdbc;
begin
  if not Assigned(FMethodTable) then
  begin
    Loader := TDBXDynalinkDriverLoaderOpenOdbc(
      {$IF CompilerVersion > 18.50}FDriverLoaderClass{$ELSE}TDBXDynalinkDriverLoader{$IFEND}.Create);
    try
      Loader.LoadDriverLibraryAndMethodTable(ConnectionBuilder.DBXContext, ConnectionBuilder.ConnectionProperties);
      {$IF CompilerVersion > 18.50}
      FMethodTable := Loader.FMethodTable;
      Loader.FMethodTable := nil;
      FDriverHandle := Loader.FDriverHandle;
      {$ELSE}
      FMethodTable := Loader.MethodTable;
      Loader.MethodTable := nil;
      FDriverHandle := Loader.DriverHandle;
      {$IFEND}
      Loader.FreeOldLibrary;
    finally
      {$IF CompilerVersion > 18.50}
      FreeAndNil(Loader.FMethodTable);
      {$ELSE}
      if Assigned(Loader.MethodTable) then
      begin
        Loader.MethodTable.Free;
        Loader.MethodTable := nil;
      end;
      {$IFEND}
      Loader.Free;
    end;
  end;
end;

procedure TDbxOpenOdbcDriver.GetDriverPropertyNames(List: TStrings);
begin
  inherited;
//  List.Add(TDBXPropertyNames.DriverUnit);
end;

function TDbxOpenOdbcDriver.GetDriverVersion: UnicodeString;
begin
  inherited;
  //Result := DBXVersion40;
end;

{$IFEND CompilerVersion > 18.50}

{ TDBXOpenOdbcProperties }

{.$IF CompilerVersion > 18.50}

constructor TDBXOpenOdbcProperties.Create(DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
  //Values[TDBXPropertyNames.DriverPackageLoader] := 'TDBXDynalinkDriverCommonLoader';
  //Values[TDBXPropertyNames.MetaDataPackageLoader] := 'TDBXMetaDataCommandFactory';
  //
  Values[TDBXPropertyNames.DriverUnit] := 'Dbx34Drv';
  Values[TDBXPropertyNames.DriverPackageLoader] := 'TDBXDynalinkDriverLoaderOpenOdbc';
  // ?
  // + ',PkgDbxXXDrv2011.bpl';

//
// !!!!!!!!!!!!!!
//
// Fixed error:
//  cannot open Table:
//    error: Schema or user name separated by a '.' must be specified
//
  //
  // DBXOODBC: uses Dbx34Drv
  //
  Values[TDBXPropertyNames.MetaDataPackageLoader] := // 'TDBXOpenODBCMetaDataCommandFactory';
    TDBXOpenODBCMetaDataCommandFactory.ClassName;
  //?
  // + ',PkgDbxXXDrv2011.bpl';
  //
  //Values[TDBXPropertyNames.IsolationLevel] := 'ReadCommitted'; // == default
  //Values['RowSetSize'] := '20';                                // == default

//
// TEST:
//
  //
  // ORACLE (DEFAULT): uses DBXOracleMetaDataReader, DBXOracleReadOnlyMetaData,
  //
  // Values[TDBXPropertyNames.MetaDataPackageLoader] := 'TDBXOracleMetaDataCommandFactory';

  //
  // ORACLE (THIS): uses Dbx34DrvDbms
  //
  // Values[TDBXPropertyNames.MetaDataPackageLoader] := Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryOracle.ClassName;
//
// !!!!!!!!!!!!!!
//
//  Clear;
//  Values[TDBXPropertyNames.VendorLib] := DbxOODBCDriverVendorLib;
//  //Values[TDBXPropertyNames.LibraryName] := DbxOODBCDriverLibname;
//  Values[TDBXPropertyNames.LibraryName] := 'C:\delphi\2010\projects\bpl\dbxoodbc.dll';
//  Values[TDBXPropertyNames.GetDriverFunc] := 'getSQLDriverODBCW';
//    Values[TDBXPropertyNames.DriverUnit] := 'Dbx34Drv';
end;

function TDBXOpenOdbcProperties.GetConnectionString: string;
begin
  Result := Values[StrConnectionString];
end;

procedure TDBXOpenOdbcProperties.SetConnectionString(const Value: string);
begin
  Values[StrConnectionString] := Value;
end;

function TDBXOpenOdbcProperties.GetDatabase: string;
begin
  Result := Values[TDBXPropertyNames.Database];
end;

procedure TDBXOpenOdbcProperties.SetDatabase(const Value: string);
begin
  Values[TDBXPropertyNames.Database] := Value;
end;

function TDBXOpenOdbcProperties.GetUserName: string;
begin
  Result := Values[TDBXPropertyNames.UserName];
end;

procedure TDBXOpenOdbcProperties.SetUserName(const Value: string);
begin
  Values[TDBXPropertyNames.UserName] := Value;
end;

function TDBXOpenOdbcProperties.GetPassWord: string;
begin
  Result := Values[TDBXPropertyNames.Password];
end;

procedure TDBXOpenOdbcProperties.SetPassWord(const Value: string);
begin
  Values[TDBXPropertyNames.Password] := Value;
end;

function TDBXOpenOdbcProperties.GetBlobSize: Integer;
begin
  Result := StrToIntDef(Values[TDBXPropertyNames.MaxBlobSize], -1);
end;

procedure TDBXOpenOdbcProperties.SetBlobSize(const Value: Integer);
begin
  Values[TDBXPropertyNames.MaxBlobSize] := IntToStr(Value);
end;

function TDBXOpenOdbcProperties.GetOdbcTransIsolation: string;
begin
  Result := Values[StrOdbcTransisolation];
end;

procedure TDBXOpenOdbcProperties.SetOdbcTransIsolation(const Value: string);
begin
  Values[StrOdbcTransisolation] := Value;
end;

function TDBXOpenOdbcProperties.GetDecimalSeparator: string;
begin
  Result := Values[StrDecimalSeparator];
end;

procedure TDBXOpenOdbcProperties.SetDecimalSeparator(const Value: string);
begin
  Values[StrDecimalSeparator] := Value;
end;

function TDBXOpenOdbcProperties.GetTrimChar: Boolean;
begin
  Result := StrToBoolDef(Values[StrTrimChar], False);
end;

procedure TDBXOpenOdbcProperties.SetTrimChar(const Value: Boolean);
begin
  Values[StrTrimChar] := BoolToStr(Value, True);
end;

function TDBXOpenOdbcProperties.GetCustomString: string;
begin
  Result := Values[StrCustomString];
end;

procedure TDBXOpenOdbcProperties.SetCustomString(const Value: string);
begin
  Values[StrCustomString] := Value;
end;

{.$IFEND CompilerVersion > 18.50}

{ TDBXDynalinkDriverLoaderOpenOdbc }

{$IF CompilerVersion > 18.50}
procedure TDBXDynalinkDriverLoaderOpenOdbc.LoadDriverLibraryAndMethodTable(DBXContext: TDBXContext;
  Properties: TDBXProperties);
var
  ErrorResult: TDBXErrorCode;
  ErrorMessageBuilder: TDBXWideStringBuilder;
  Count: TInt32;
  Names: TWideStringArray;
  Values: TWideStringArray;
  ErrorMessage: UnicodeString;
  //
  sLibraryName: UnicodeString;
  sGetDriverFunc: string;
begin
  sLibraryName := UnicodeString(Properties[TDBXPropertyNames.LibraryName]);
  if CheckLibraryName(sLibraryName) then
    Properties[TDBXPropertyNames.LibraryName] := sLibraryName;
//-  if Properties[TDBXPropertyNames.MetaDataPackageLoader] = '' then
//-  begin
//-    Properties[TDBXPropertyNames.MetaDataPackageLoader] := 'TDBXOpenODBCMetaDataCommandFactory';
//-  end;
  //
  if Properties[TDBXPropertyNames.LibraryName] <> '' then
  begin
    {+}
    sGetDriverFunc := Properties[TDBXPropertyNames.GetDriverFunc];
    if (sGetDriverFunc = '') or (Pos('GETSQLDRIVERODBCW', UpperCase(sGetDriverFunc)) <= 0) then
    begin
      // replace for old dbx2 applications:
      sGetDriverFunc := 'getSQLDriverODBCW';
      Properties[TDBXPropertyNames.GetDriverFunc] := sGetDriverFunc;
    end;
    {+.}
    LoadDriverLibrary(Properties, DBXContext);
    FMethodTable := CreateMethodTable;
    try
      FMethodTable.LoadMethods;
    except
      on EDBXError: TDBXError do
      begin
        DBXContext.OnError(EDBXError);
        raise;
      end;
    end;
    Count := Properties.Properties.Count;
    Properties.GetLists(Names, Values);

    ErrorMessageBuilder := TDBXPlatform.CreateWideStringBuilder(256);
    try
      ErrorResult := FMethodTable.FDBXLoader_GetDriver(Count, Names, Values,
        TDBXWideStringBuilder(ErrorMessageBuilder), FDriverHandle);

      if ErrorResult <> TDBXErrorCodes.None then
      begin
        TDBXPlatform.CopyWideStringBuilder(ErrorMessageBuilder, ErrorMessage);

        DBXContext.Error(ErrorResult, ErrorMessage);
      end;
    finally
      TDBXPlatform.FreeAndNilWideStringBuilder(ErrorMessageBuilder);
    end;
  end;
end;

procedure TDBXDynalinkDriverLoaderOpenOdbc.FreeOldLibrary;
begin
  if FOldLibraryHandle <> 0 then
  begin
    FreeLibrary(FOldLibraryHandle);
    FOldLibraryHandle := 0;
  end;
end;
{$IFEND IF CompilerVersion > 18.50}

{$IF CompilerVersion <= 18.50}
function TDBXDynalinkDriverLoaderOpenOdbc.Load(DriverDef: TDBXDriverDef): TDBXDriver;
var
  sGetDriverFunc: string;
  sLibraryName, sVendorLib: UnicodeString;
begin
  //--------FLoaderName := 'TDBXDynalinkDriverLoaderOpenOdbc';
  //if DriverDef.FDriverProperties[TDBXPropertyNames.LibraryName] <> '' then
  begin
    sLibraryName := UnicodeString(DriverDef.FDriverProperties[TDBXPropertyNames.LibraryName]);
    if CheckLibraryName(sLibraryName) then
      DriverDef.FDriverProperties[TDBXPropertyNames.LibraryName] := string(sLibraryName);
    //
    sGetDriverFunc := DriverDef.FDriverProperties[TDBXPropertyNames.GetDriverFunc];
    if (sGetDriverFunc = '') or (Pos('GETSQLDRIVERODBCW', UpperCase(sGetDriverFunc)) <= 0) then
    begin
      // replace for old dbx2 applications:
      sGetDriverFunc := 'getSQLDriverODBCW';
      DriverDef.FDriverProperties[TDBXPropertyNames.GetDriverFunc] := sGetDriverFunc;
    end;
    // D2007:
    sVendorLib := UnicodeString(DriverDef.FDriverProperties[TDBXPropertyNames.VendorLib]);
    if CheckVendorLib(sVendorLib) then
      DriverDef.FDriverProperties[TDBXPropertyNames.VendorLib] := string(sVendorLib);
    // @d2007: critical
    DriverDef.FDriverProperties[TDBXPropertyNames.MetaDataPackageLoader] := // 'TDBXOpenODBCMetaDataCommandFactory';
      TDBXOpenODBCMetaDataCommandFactory.ClassName;
    // D2007.
  end;
  Result := inherited Load(DriverDef);
end;

function  TDBXDynalinkDriverLoaderOpenOdbc.CreateDynalinkDriver: TDBXDynalinkDriver;
begin
  Result := TDBXDynalinkDriverNativeOpenOdbc.Create(TDBXDriver(nil), FDriverHandle, FMethodTable);
end;

//function TDBXDynalinkDriverLoaderOpenOdbc.CreateMorphCommand(DbxContext: TDBXContext; Connection: TDBXConnection;
//  MorphicCommand: TDBXCommand): TDBXCommand;
//begin
//
//end;

function TDBXDynalinkDriverNativeOpenOdbc.CreateConnection;//(ConnectionBuilder:  TDBXConnectionBuilder): TDBXConnection;
var
  ConnectionHandle: TDBXConnectionHandle;
  ErrorResult:  TDBXErrorCode;
begin
  ErrorResult := FMethodTable.FDBXDriver_CreateConnection(FDriverHandle, ConnectionHandle);
  CheckResult(ErrorResult);
  Result := TDBXDynalinkConnectionOpenOdbc.Create(ConnectionBuilder, ConnectionHandle, FMethodTable);
end;

{$IFEND CompilerVersion <= 18.50}

{ TDBXDynalinkConnectionOpenOdbc }

function TDBXDynalinkConnectionOpenOdbc.GetProductVersion: UnicodeString;
begin
  Result := FDBMSVersion;
end;

function TDBXDynalinkConnectionOpenOdbc.GetProductName: UnicodeString;
begin
  Result := DbxOODBCDriverProductName;
end;

procedure TDBXDynalinkConnectionOpenOdbc.DerivedGetCommands;//(const CommandType: UnicodeString; const List: TStrings);
begin
  { empty }
end;

procedure TDBXDynalinkConnectionOpenOdbc.DerivedGetCommandTypes;//(const List: TStrings);
begin
  { empty }
end;

procedure TDBXDynalinkConnectionOpenOdbc.DerivedOpen;
var
  S: string;
  i: Integer;
  //
  procedure RaiseDriverVersionFailed();
  begin
    raise EDbxOODBCDriverError.Create('Your version "dbxoodbc" is old. Need update it!');
  end;
  //
begin
  S := GetVendorProperty(cfvp_Supported);
  if not SameText(S, 'true') then
    RaiseDriverVersionFailed();
  //
  S := GetVendorProperty(cfvp_GetVersion); // version of "dbxoodbx.dll" (DbxOODBCDriverLibname)
  i := Pos(' ', S);
  if i > 0 then
    S := Copy(S, 1, i-1);
  if S < TDBXDynalinkConnectionOpenOdbc.dbxoodbc_version_min then
     RaiseDriverVersionFailed();
  //
  DoDerivedOpenBefore;
  inherited;
  DoDerivedOpenAfter;
end;

procedure TDBXDynalinkConnectionOpenOdbc.DoDerivedOpenBefore;
var
  sVendorCommand, sVendorLib, sGetDriverFunc, sCustomString: UnicodeString;
  N, P: TDBXStringArray;
begin
  //
  // Fix: Transfer cached dbx3 driver options (VendorLib, GetDriverFunc):
  //
  sVendorLib := UnicodeString(ConnectionProperty[TDBXPropertyNames.VendorLib]);
  if CheckVendorLib(sVendorLib) then
     ConnectionProperties[TDBXPropertyNames.VendorLib] := sVendorLib;
  //
  sGetDriverFunc := UnicodeString(ConnectionProperty[TDBXPropertyNames.GetDriverFunc]);
  if (sGetDriverFunc = '') or (Pos('GETSQLDRIVERODBCW', UpperCase(string(sGetDriverFunc))) <= 0) then
  begin
    // replace for old dbx2 applications:
    sGetDriverFunc := UnicodeString('getSQLDriverODBCW');
    ConnectionProperties[TDBXPropertyNames.GetDriverFunc] := sGetDriverFunc;
  end;
  //
  SetLength(N, 2);
  SetLength(P, 2);
  N[0] := TDBXPropertyNames.VendorLib;
  P[0] := sVendorLib;
  N[1] := TDBXPropertyNames.GetDriverFunc;
  P[1] := sGetDriverFunc;
  //
  sVendorCommand := DBX4_CMD_PREFIX + csvp_SetVendorLib + DBXStringArrayToNamedQueryParams(N, P);
  CheckGetVendorPropertyCommand(GetVendorProperty(sVendorCommand), csvp_SetVendorLib, N, P);
  //
  // Fix: Transfer connection options: (Custom String)
  //
  sCustomString := ConnectionProperty[TDBXOpenOdbcProperties.StrCustomString];
  if sCustomString <> '' then
  begin
    SetLength(N, 1);
    SetLength(P, 1);
    N[0] := TDBXOpenOdbcProperties.StrCustomString;
    P[0] := sCustomString;
    sVendorCommand := DBX4_CMD_PREFIX + csvp_SetCustomString + DBXStringArrayToNamedQueryParams(N, P);
    CheckGetVendorPropertyCommand(GetVendorProperty(sVendorCommand), csvp_SetCustomString, N, P);
  end;
  //
  // test:
  //
  //sValue := GetVendorProperty('DbxOODBC.SupportsQuotation.Disable'); // Disable: fSupportsDbxQuotation
end;

procedure TDBXDynalinkConnectionOpenOdbc.DoDerivedOpenAfter;
begin
  { read odbc driver and dbms options }
  FDBMSVersion := GetVendorProperty(TDBXPropertyNames.ProductVersion); // DBMS Version
  FQuoteChar := GetVendorProperty(cfvp_GetQuoteCharacter);
end;

{$IF CompilerVersion > 18.50}
procedure TDBXDynalinkConnectionOpenOdbc.DerivedClose;
begin
  { empty }
end;
{$IFEND}

function TDBXDynalinkConnectionOpenOdbc.GetDatabaseMetaData: TDBXDatabaseMetaData;
begin
  Result := inherited GetDatabaseMetaData;
//  if FDatabaseMetaData = nil then
//  begin
//    FDatabaseMetaData := TDBXDatabaseMetaDataOpenOdbc.Create(FDBXContext);
//    ? FDatabaseMetaData.Init(Self);
//  end;
//  Result := FDatabaseMetaData;
//  Result.SupportsLowerCaseIdentifiers := True;  // todo: abstract
//  Result.SupportsUpperCaseIdentifiers := True;  // todo: abstract
end;

procedure TDBXDynalinkConnectionOpenOdbc.Close;
begin
  inherited Close;
  //FreeAndNil(FDatabaseMetaData);
end;

function  TDBXDynalinkConnectionOpenOdbc.DerivedCreateCommand: TDBXCommand;
begin
  //{$IF CompilerVersion > 18.50}
  Result := TDBXMorphicCommandOpenOdbc.Create(FDBXContext, Self);
  //{$ELSE}
  //Result := inherited DerivedCreateCommand;
  //{$IFEND}
end;

function TDBXDynalinkConnectionOpenOdbc.GetVendorProperty(const Name: UnicodeString): UnicodeString;
begin
  if Name <> 'DriverName' then
    Result := inherited GetVendorProperty(Name)
  else
    Result := DbxOODBCDriverName;
end;

{ TDBXMorphicCommandOpenOdbc }

constructor TDBXMorphicCommandOpenOdbc.Create(DBXContext: TDBXContext; Connection: TDBXConnection);
begin
  inherited Create(DBXContext, Connection);
end;

function TDBXMorphicCommandOpenOdbc.DerivedExecuteQuery: TDBXReader;
begin
  Result := inherited DerivedExecuteQuery;
end;
(*
function TDBXMorphicCommandOpenOdbc.ExecuteQuery: TDBXReader;
//var
//  AText: string;
begin
  //
  // Fixed: TSQLTable.Open when property TSQLTable.GetMetadata = True
  //
//  if CommandType = TDBXCommandTypes.DbxMetaData then
//  begin
//    AText := string(GetText);
//    //
//    // TDBXMetaDataCommands:
//    //
//    // GetDatabase GetDataTypes GetTables GetColumns GetForeignKeys GetForeignKeyColumns
//    // GetIndexes GetIndexColumns GetPackages GetProcedures GetProcedureParameters GetUsers GetViews
//    // GetSynonyms GetCatalogs GetSchemas GetProcedureSources GetPackageProcedures GetPackageProcedureParameters
//    // GetPackageSources GetRoles GetReservedWords
//    //
//    //if (AText <> TDBXMetaDataCommands.GetDatabase) then
//    //if (AText = 'GetDatabase') or (Pos('GetIndexes ', AText)  = 1) or (Pos('GetTables ', AText)  = 1) then
//    //if (Pos('GetIndexes ', AText)  = 1) or (Pos('GetTables ', AText)  = 1) then
//    if (Pos('GetIndexes ', AText)  = 1) then
//    begin
//      //AText := FConnection.GetVendorProperty('DbxOODBC.SupportsQuotation.Disable'); // Disable: fSupportsDbxQuotation
//      AText := FConnection.GetVendorProperty('DbxOODBC.MetaObjectQuoteChar.Disable'); // Disable: fSupportsMetaObjectQuoteChar
//      try
//        Result := inherited ExecuteQuery;
//      finally
//        AText := FConnection.GetVendorProperty('DbxOODBC.MetaObjectQuoteChar.Enable'); // Enable: fSupportsMetaObjectQuoteChar
//      end;
//      Exit;
//    end;
//  end;
  Result := inherited ExecuteQuery;
end;

procedure TDBXMorphicCommandOpenOdbc.SetText(const Value: UnicodeString);
//var
//  ANewValue: UnicodeString;
//  //AQuotedChar: string;
begin
//  ANewValue := Value;
//  if CommandType = TDBXCommandTypes.DbxMetaData then
//  begin
//    if ANewValue = 'GetIndexes `?`.%.`country$` ' then
//    begin
//      //ANewValue := 'GetIndexes country$';
//      ANewValue := ANewValue;
//    end;
//  end;
//  inherited SetText(ANewValue);
  inherited;
end;//*)

{ TDBXDataExpressProviderContextOpenOdbc }

{$IF CompilerVersion < 23.00} // XE2

procedure TDBXDataExpressProviderContextOpenOdbc.SetConnection;//(Value: TDBXConnection);
begin
  inherited Connection := Value;
  FConnection := Value;
end;

{$IFEND}

{ TDBXCustomOpenODBCMetaDataReader }

procedure TDBXCustomOpenODBCMetaDataReader.InitMetadata(Connection: TDBXDynalinkConnectionOpenOdbc);
begin
  FMetadataInitialized := True;
  if Assigned(Connection) then
  begin
    //FDefaultCharSetIsUnicode := (Context.GetVendorProperty('UnicodeEncoding') = 'true');
    //FQuoteChar := C_Conditional((Context.GetVendorProperty('QuoteCharEnabled') = 'true'), '"', '');
    FQuoteChar := Trim(Context.GetVendorProperty(cfvp_GetQuoteCharacter));
{ todo: customize next options:
    function GetSqlIdentifierQuotePrefix: UnicodeString; override;
    function GetSqlIdentifierQuoteSuffix: UnicodeString; override;
    function IsParameterMetadataSupported: Boolean; override;
    function IsLowerCaseIdentifiersSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsDescendingIndexSupported: Boolean; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function IsSPReturnCodeSupported: Boolean; override;
    function GetSqlIdentifierQuoteChar: UnicodeString; override;
    function GetSqlProcedureQuoteChar: UnicodeString; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function IsTransactionsSupported: Boolean; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean; override;
}
  end
  else
  begin
    FQuoteChar := DoubleQuote;
  end;
end;

procedure TDBXCustomOpenODBCMetaDataReader.CheckMetadata();
var
  C: TDBXDynalinkConnectionOpenOdbc;
begin
  if FMetadataInitialized then
    Exit;
  C := nil;
  if Assigned(Context) and (Context is TDBXDataExpressProviderContext)
    and (Context.ClassType = TDBXDataExpressProviderContextOpenOdbc) then
  begin
    with TDBXDataExpressProviderContextOpenOdbc(Context) do
    begin
      if Assigned(Connection) and (Connection.ClassType = TDBXDynalinkConnectionOpenOdbc) then
      begin
        if (Connection.ClassType = TDBXDynalinkConnectionOpenOdbc) then
          C := TDBXDynalinkConnectionOpenOdbc(Connection);
      end;
    end;
  end;
  InitMetadata(C);
end;

procedure TDBXCustomOpenODBCMetaDataReader.SetContext(const Context: TDBXProviderContext);
begin // @dbg: TDBXDataExpressProviderContext(Context).FConnection.ClassType
  inherited SetContext(Context);
  FMetadataInitialized := False;
  CheckMetadata();
end;

 {$IF CompilerVersion <= 18.50}
procedure TDBXCustomOpenODBCMetaDataReader.PopulateDataTypes(const Hash: TDBXObjectStore; const Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
begin
  inherited PopulateDataTypes(Hash, Types, Descr);
end;
{$IFEND}

function TDBXCustomOpenODBCMetaDataReader.GetProductName: UnicodeString;
begin
  Result := inherited GetProductName;
  Result := DbxOODBCDriverProductName;
end;

//function TDBXCustomOpenODBCMetaDataReader.GetSqlDefaultParameterMarker: UnicodeString;
//begin
//  Result := Colon; // ':'
//end;

function TDBXCustomOpenODBCMetaDataReader.GetSqlIdentifierQuotePrefix: UnicodeString;
begin
  Result := FQuoteChar;
end;

function TDBXCustomOpenODBCMetaDataReader.GetSqlIdentifierQuoteSuffix: UnicodeString;
begin
  Result := FQuoteChar;
end;

//function TDBXCustomOpenODBCMetaDataReader.IsQuotedIdentifiersSupported: Boolean;
//begin
//  Result := (Length(SqlIdentifierQuoteChar) > 0) or ((Length(SqlIdentifierQuotePrefix) > 0) and (Length(SqlIdentifierQuoteSuffix) > 0));
//end;

function TDBXCustomOpenODBCMetaDataReader.IsParameterMetadataSupported: Boolean;
begin
  Result := True;
end;

function TDBXCustomOpenODBCMetaDataReader.IsLowerCaseIdentifiersSupported: Boolean;
begin { SqlExp.pas: function GetIdOption(Connection: TSQLConnection): IDENTIFIEROption; }
  Result := True; // idMixCase := IsUpperCaseIdentifiersSupported and IsLowerCaseIdentifiersSupported
end;

function TDBXCustomOpenODBCMetaDataReader.IsUpperCaseIdentifiersSupported: Boolean;
begin { SqlExp.pas: function GetIdOption(Connection: TSQLConnection): IDENTIFIEROption; }
  Result := True; // idMixCase := IsUpperCaseIdentifiersSupported and IsLowerCaseIdentifiersSupported
end;

function TDBXCustomOpenODBCMetaDataReader.IsDescendingIndexSupported: Boolean;
begin
  Result := True;
end;

function TDBXCustomOpenODBCMetaDataReader.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := True;
end;

function TDBXCustomOpenODBCMetaDataReader.GetSqlIdentifierQuoteChar: UnicodeString;
begin
  Result := FQuoteChar;
end;

function TDBXCustomOpenODBCMetaDataReader.GetSqlProcedureQuoteChar: UnicodeString;
begin
  Result := FQuoteChar;
end;

function TDBXCustomOpenODBCMetaDataReader.IsMultipleCommandsSupported: Boolean;
begin
  Result := True; // todo: read from driver
end;

function TDBXCustomOpenODBCMetaDataReader.IsTransactionsSupported: Boolean;
begin
  Result := True; // todo: read from driver
end;

function TDBXCustomOpenODBCMetaDataReader.IsNestedTransactionsSupported: Boolean;
begin
  Result := False; // todo: ...
end;

function TDBXCustomOpenODBCMetaDataReader.IsSetRowSizeSupported: Boolean;
begin
  Result := True;
end;

function TDBXCustomOpenODBCMetaDataReader.GetUseAnsiStrings: Boolean;
begin
  Result := FUseAnsiStrings >= 0;
end;

{ TDBXOpenODBCMetaDataCommand }

function TDBXOpenODBCMetaDataCommand.DerivedExecuteQuery: TDBXReader;
begin
//  if CommandType = TDBXCommandTypes.DbxMetaData then
//  begin
//    if Text = TDBXMetaDataCommands.GetDatabase then
//    begin
//      Result := nil; // AV: !!!
//      Exit;
//    end;
//    //ExecuteCatalogFunction
//  end;
  Result := inherited DerivedExecuteQuery;
end;

{ TDBXOpenODBCMetaDataCommandFactoryCustom }

function TDBXOpenODBCMetaDataCommandFactoryCustom.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := GetMetaDataReaderClass.Create;
end;

{ TDBXOpenODBCMetaDataCommandFactory }

class function TDBXOpenODBCMetaDataCommandFactory.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReader;
end;

procedure TDBXOpenODBCMetaDataCommandFactory.InitMetaDataReaderClass(Connection: TDBXConnection);
var
  S: string;
  i: Integer;
  C: TClass;
  ClassRegistry: TClassRegistry;
  O: TObject;
begin
  if (FDBXMetaDataReaderClass = nil) and Assigned(Connection) then
  begin
    S := Trim(Connection.ConnectionProperties[TDBXPropertyNames.MetaDataPackageLoader]);
    if (S <> '') and ( not SameText(S, TDBXOpenODBCMetaDataCommandFactory.ClassName)) then
    begin
      i := Pos(',', S);
      if i > 0 then
        S := Trim(Copy(S, 1, i-1));
      if (S <> '') and ( not SameText(S, TDBXOpenODBCMetaDataCommandFactory.ClassName)) then
      begin
        //C := GetClass(S);
        //if Assigned(C) and C.InheritsFrom(TDBXOpenODBCMetaDataReader) then
        //  FDBXMetaDataReaderClass := TDBXOpenODBCMetaDataReaderClass(C)
        //else
        begin
          ClassRegistry := TClassRegistry.GetClassRegistry;
          if ClassRegistry.HasClass(S) then
          begin
            O := ClassRegistry.CreateInstance(S);
            try
              C := O.ClassType;
              if Assigned(C) and C.InheritsFrom(TDBXOpenODBCMetaDataCommandFactory) then
              begin
                FDBXMetaDataReaderClass := TDBXOpenODBCMetaDataCommandFactoryClass(C).GetMetaDataReaderClass;
              end;
            finally
              O.Free;
            end;
          end;
        end;
      end;
    end;
    if FDBXMetaDataReaderClass = nil then
      FDBXMetaDataReaderClass := TDBXOpenODBCMetaDataReader;
  end;
end;

function TDBXOpenODBCMetaDataCommandFactory.CreateCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
//begin
//  if (FDBXMetaDataReaderClass = nil) and Assigned(Connection) then
//    InitMetaDataReaderClass(Connection);
//  if fMetadataSupported = 0 then
//    FCurrentConnection := Connection;
//  Result := inherited CreateCommand(DbxContext, Connection, MorphicCommand);
//end;
var
  Reader: TDBXMetaDataReader;
  R: TDBXCustomOpenODBCMetaDataReader;
  ProviderContext: TDBXDataExpressProviderContextOpenOdbc;
   {$IF CompilerVersion <= 18.50}
  ConnectionEx: TDBXConnectionEx;
  {$IFEND}
begin
  if (FDBXMetaDataReaderClass = nil) and Assigned(Connection) then
    InitMetaDataReaderClass(Connection);
  if fMetadataSupported = 0 then
    FCurrentConnection := Connection;
  //
  {$IF CompilerVersion > 18.50}
  Reader := TDBXMetaDataReader(TDBXDriverHelp.GetMetaDataReader(Connection));
  {$ELSE}
  ConnectionEx := TDBXConnectionEx(Connection);
  Reader := TDBXMetaDataReader(ConnectionEx.MetaDataReader);
  {$IFEND}
  if Reader = nil then
  begin
    R := CreateMetaDataReader(Connection);
    Reader := R;
    ProviderContext := TDBXDataExpressProviderContextOpenOdbc.Create;
    ProviderContext.Connection := Connection;
    ProviderContext.UseAnsiStrings := R.GetUseAnsiStrings;//TDBXProviderContext.UseAnsiString(Reader.ProductName);
    ProviderContext.RemoveIsNull := False; // not assign null value to DummyValue ('A')
    Reader.Context := ProviderContext;
    {$IF CompilerVersion > 18.50}
    Reader.Version := TDBXConnection(Connection).ProductVersion;
    TDBXDriverHelp.SetMetaDataReader(Connection, Reader);
    {$ELSE}
    Reader.Version := TDBXConnectionEx(Connection).ProductVersion;
    ConnectionEx.MetaDataReader := Reader;
    {$IFEND}
  end;
  Result := TDBXOpenODBCMetaDataCommand.Create(DBXContext, MorphicCommand, Reader);
end;

function TDBXOpenODBCMetaDataCommandFactory.GetProductName: UnicodeString;
begin
  //Result := '';
  Result := {DbxXXDrv.pas}DbxOODBCDriverProductName; // ProductName VendorProperty from "dbxoodbc.dll" (DbxOpenOdbc3.pas)
end;

function TDBXOpenODBCMetaDataCommandFactory.CreateMetaDataReader(Connection: TDBXConnection): TDBXCustomOpenODBCMetaDataReader;
var
  S: string;
begin
  if Assigned(FDBXMetaDataReaderClass) then
    Result := FDBXMetaDataReaderClass.Create
  else
    Result := GetMetaDataReaderClass.Create;
  //
  if (fMetadataSupported = 0) and Assigned(Connection) then
  begin
    if SameText(Connection.ConnectionProperties[TDBXPropertyNames.MetaDataDisabled], 'true') then
      fMetadataSupported := -1
    else
      fMetadataSupported := 1;
    //
    fMetadataMode := [mmSQL, mmDBX];
    if SameText(Connection.ConnectionProperties[TDBXPropertyNames.MetadataSQL], 'false') then
      Exclude(fMetadataMode,mmSQL);
    if SameText(Connection.ConnectionProperties[TDBXPropertyNames.MetadataDBX], 'false') then
      Exclude(fMetadataMode,mmDBX);
    //
    S := Connection.ConnectionProperties[TDBXPropertyNames.UseAnsiStrings];
    if S <> '' then
    begin
      if SameText(S, 'true') then
        FUseAnsiStrings := 1
      else if SameText(S, 'false') then
        FUseAnsiStrings := -1;
    end;
    //
    FCurrentConnection := nil;
  end;
  if fMetadataSupported < 0 then
    TDBXOpenODBCMetaDataReader(Result).fMetadataSupported := False;
  TDBXOpenODBCMetaDataReader(Result).fMetadataMode := fMetadataMode;
  if FUseAnsiStrings <> 0 then
    TDBXOpenODBCMetaDataReader(Result).FUseAnsiStrings := FUseAnsiStrings;
end;

function TDBXOpenODBCMetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := CreateMetaDataReader(FCurrentConnection);
end;

class procedure TDBXOpenODBCMetaDataCommandFactory.RegisterMetaDataCommandFactory;
begin
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(Self);
end;

class procedure TDBXOpenODBCMetaDataCommandFactory.UnRegisterMetaDataCommandFactory;
begin
  {$IF CompilerVersion > 18.50}
  TDBXMetaDataCommandFactory.UnRegisterMetaDataCommandFactory(Self);
  {$ELSE}
  TClassRegistry.GetClassRegistry.UnRegisterClass(Self.ClassName);
  {$IFEND}
end;

{ TDBXOpenODBCMetaDataReader }

constructor TDBXOpenODBCMetaDataReader.Create;
begin
  fMetadataSupported := True;
  inherited;
end;

//procedure TDBXOpenODBCMetaDataReader.AfterConstruction;
//begin
//  inherited;
//end;

//procedure TDBXOpenODBCMetaDataReader.BeginMetadataQuery;
//begin
//  {S:= }Context.GetVendorProperty(cfvp_SetMetadataQueryBegin);
//  //if S <> '1' then raise ...
//end;
//
//procedure TDBXOpenODBCMetaDataReader.EndMetadataQuery;
//begin
//  {S:= }Context.GetVendorProperty(cfvp_SetMetadataQueryEnd);
//  //if S <> '0' then raise ...
//end;

function TDBXOpenODBCMetaDataReader.FetchDataTypes: TDBXTable;
var
  Columns: TDBXValueTypeArray;
begin
  fDbxMode := False;
  Columns := TDBXMetaDataCollectionColumns.CreateDataTypesColumns;
  Result := TDBXDataTypeCursor.Create(Self, Columns, DataTypes);
end;

function TDBXOpenODBCMetaDataReader.FetchCatalogs: TDBXTable;
var
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  Cursor: TDBXTable;
  sDbxCommand: UnicodeString;
  {@dbxoodbc.}
begin
  fDbxMode := False;
  (*//
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    //sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
    //  + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Catalogs,{$IFEND}
    TDBXMetaDataCollectionName.Catalogs, Columns);
end;

function TDBXOpenODBCMetaDataReader.FetchSchemas(const Catalog: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  Cursor: TDBXTable;
  sDbxCommand: UnicodeString;
  {@dbxoodbc.}
begin
  if fMetadataSupported and (mmSQL in fMetadataMode) then
  begin
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    fDbxMode := False;
    if SqlForSchemas <> '' then
    try
      Result := inherited FetchSchemas(sCatalog);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,1);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  SetLength(ParameterValues,1);
  ParameterValues[0] := sCatalog;
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
     todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForSchemas, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateSchemasColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Schemas,{$IFEND}
  //  TDBXMetaDataCollectionName.Schemas, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Schemas,{$IFEND}
    TDBXMetaDataCollectionName.Schemas, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchTables(const Catalog: UnicodeString; const Schema: UnicodeString; const TableName: UnicodeString; const TableType: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}
  TypeMask: Integer;
  Tables: UnicodeString;
  Views: UnicodeString;
  SystemTables: UnicodeString;
  SystemViews: UnicodeString;
  Synonyms: UnicodeString;
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported and (mmSQL in fMetadataMode) then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForTables <> '' then
    try
      Result := inherited FetchTables(sCatalog, Schema, TableName, TableType);
      Exit;
    except
    end;
  end;
  //
  {@dbxoodbc:}
  if fMetadataSupported and (mmDBX in fMetadataMode) then
  try
    fDbxMode := True;
    TypeMask := TDBXTableTypeParser.ParseTableTypes(TableType);
    Tables := MakeTableTypeString(TDBXTableTypeFlag.Table, TypeMask);
    Views := MakeTableTypeString(TDBXTableTypeFlag.View, TypeMask);
    SystemTables := MakeTableTypeString(TDBXTableTypeFlag.SystemTable, TypeMask);
    SystemViews := MakeTableTypeString(TDBXTableTypeFlag.SystemView, TypeMask);
    Synonyms := MakeTableTypeString(TDBXTableTypeFlag.Synonym, TypeMask);
    SetLength(ParameterNames,8);
    ParameterNames[0] := TDBXParameterName.CatalogName;
    ParameterNames[1] := TDBXParameterName.SchemaName;
    ParameterNames[2] := TDBXParameterName.TableName;
    ParameterNames[3] := TDBXParameterName.Tables;
    ParameterNames[4] := TDBXParameterName.Views;
    ParameterNames[5] := TDBXParameterName.SystemTables;
    ParameterNames[6] := TDBXParameterName.SystemViews;
    ParameterNames[7] := TDBXParameterName.Synonyms;
    SetLength(ParameterValues,8);
    ParameterValues[0] := sCatalog;
    ParameterValues[1] := Schema;
    ParameterValues[2] := TableName;
    ParameterValues[3] := Tables;
    ParameterValues[4] := Views;
    ParameterValues[5] := SystemTables;
    ParameterValues[6] := SystemViews;
    ParameterValues[7] := Synonyms;
    //
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.GetTables
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Cursor := Context.ExecuteQuery(sDbxCommand, nil, nil);
    Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
    Result := TDBXCustomMetaDataTable.Create(Context, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Tables,{$IFEND}
      TDBXMetaDataCollectionName.Tables, Columns, Cursor);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForTables, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Tables,{$IFEND}
  //  TDBXMetaDataCollectionName.Tables, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Tables,{$IFEND}
    TDBXMetaDataCollectionName.Tables, Columns);
  {@EMPTY.}//*)
end;

function TDBXOpenODBCMetaDataReader.FetchViews(const Catalog: UnicodeString; const Schema: UnicodeString; const View: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  OrdinalLineNumber: Integer;
  {@dbxoodbc.}
begin
  if fMetadataSupported and (mmSQL in fMetadataMode) then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForViews <> '' then
    try
      Result := inherited FetchViews(sCatalog, Schema, View);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ViewName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := View;
  if fMetadataSupported and (mmDBX in fMetadataMode) then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForViews, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateViewsColumns;
  //OrdinalLineNumber := FindSourceLineColumn(Cursor, Length(Columns));
  //if OrdinalLineNumber > 0 then
  //  Result := TDBXSourceTableCursor.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Views,{$IFEND}
  //    TDBXMetaDataCollectionName.Views, Columns, Cursor, TDBXViewsIndex.Definition, OrdinalLineNumber)
  //else
  //  Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Views,{$IFEND}
  //    TDBXMetaDataCollectionName.Views, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Views,{$IFEND}
    TDBXMetaDataCollectionName.Views, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchColumns(const Catalog: UnicodeString; const Schema: UnicodeString; const Table: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  OrdinalLineNumber: Integer;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForColumns <> '' then
    try
      Result := inherited FetchColumns(sCatalog, Schema, Table);
      Exit;
    except
    end;
  end;
  DataTypeHash;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
  //Cursor := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Columns,{$IFEND}
  //    TDBXMetaDataCollectionName.Columns, Columns, Cursor);
  //Result := TDBXColumnsTableCursor.Create(Self, False, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Columns,{$IFEND}
    TDBXMetaDataCollectionName.Columns, Columns);
  {@EMPTY:}
end;

function TDBXOpenODBCMetaDataReader.FetchColumnConstraints(const Catalog, Schema, Table: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForColumnConstraints <> '' then
    try
      Result := inherited FetchColumnConstraints(sCatalog, Schema, Table);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForColumnConstraints, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ColumnConstraints,{$IFEND}
  //  TDBXMetaDataCollectionName.ColumnConstraints, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ColumnConstraints,{$IFEND}
    TDBXMetaDataCollectionName.ColumnConstraints, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchForeignKeyColumns(const Catalog, Schema, Table, ForeignKeyName,
  PrimaryCatalog, PrimarySchema, PrimaryTable, PrimaryKeyName: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForForeignKeyColumns <> '' then
    try
      Result := inherited FetchForeignKeyColumns(sCatalog, Schema, Table, ForeignKeyName,
        PrimaryCatalog, PrimarySchema, PrimaryTable, PrimaryKeyName);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,8);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  ParameterNames[3] := TDBXParameterName.ForeignKeyName;
  ParameterNames[4] := TDBXParameterName.PrimaryCatalogName;
  ParameterNames[5] := TDBXParameterName.PrimarySchemaName;
  ParameterNames[6] := TDBXParameterName.PrimaryTableName;
  ParameterNames[7] := TDBXParameterName.PrimaryKeyName;
  SetLength(ParameterValues,8);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  ParameterValues[3] := ForeignKeyName;
  ParameterValues[4] := PrimaryCatalog;
  ParameterValues[5] := PrimarySchema;
  ParameterValues[6] := PrimaryTable;
  ParameterValues[7] := PrimaryKeyName;
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForForeignKeyColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ForeignKeyColumns,{$IFEND}
  //  TDBXMetaDataCollectionName.ForeignKeyColumns, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ForeignKeyColumns,{$IFEND}
    TDBXMetaDataCollectionName.ForeignKeyColumns, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchForeignKeys(const Catalog, Schema, Table: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForForeignKeys <> '' then
    try
      Result := inherited FetchForeignKeys(sCatalog, Schema, Table);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForForeignKeys, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50} TDBXMetaDataCollectionIndex.ForeignKeys,{$IFEND},
  //  TDBXMetaDataCollectionName.ForeignKeys, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50} TDBXMetaDataCollectionIndex.ForeignKeys,{$IFEND}
    TDBXMetaDataCollectionName.ForeignKeys, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchIndexColumns(const Catalog, Schema, Table, Index: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}//{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  //?d16: CheckInitialized; => procedure TDBXOdbcMetaDataReader.Init; =>: FSqlIdentifierQuoteChar FSupportsParameterMetaData FSupportsMultipleTransactions FIndexKeyword  FTransactionCapable GetDataTypes
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForIndexColumns <> '' then
    try
      Result := inherited FetchIndexColumns(sCatalog, Schema, Table, Index);
      Exit;
    except
    end;
  end;
  //(*//
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    fDbxMode := True;
    SetLength(ParameterNames,4);
    ParameterNames[0] := TDBXParameterName.CatalogName;
    ParameterNames[1] := TDBXParameterName.SchemaName;
    ParameterNames[2] := TDBXParameterName.TableName;
    ParameterNames[3] := TDBXParameterName.IndexName;
    SetLength(ParameterValues,4);
    ParameterValues[0] := sCatalog;
    ParameterValues[1] := Schema;
    ParameterValues[2] := Table;
    ParameterValues[3] := Index;
    //
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.GetIndexColumns
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Cursor := Context.ExecuteQuery(sDbxCommand, nil, nil);
    Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
    Columns[TDBXIndexColumnsIndex.IsAscending].Hidden := DescendingIndexColumnsSupported;
    Result := TDBXCustomMetaDataTable.Create(Context, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.IndexColumns,{$IFEND}
      TDBXMetaDataCollectionName.IndexColumns, Columns, Cursor);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForIndexColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
  Columns[TDBXIndexColumnsIndex.IsAscending].Hidden := DescendingIndexColumnsSupported;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.IndexColumns,{$IFEND}
  //  TDBXMetaDataCollectionName.IndexColumns, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.IndexColumns,{$IFEND}
    TDBXMetaDataCollectionName.IndexColumns, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchIndexes(const Catalog, Schema, Table: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForIndexes <> '' then
    try
      Result := inherited FetchIndexes(sCatalog, Schema, Table);
      Exit;
    except
    end;
  end;
  //
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    fDbxMode := True;
    SetLength(ParameterNames,3);
    ParameterNames[0] := TDBXParameterName.CatalogName;
    ParameterNames[1] := TDBXParameterName.SchemaName;
    ParameterNames[2] := TDBXParameterName.TableName;
    SetLength(ParameterValues,3);
    ParameterValues[0] := sCatalog;
    ParameterValues[1] := Schema;
    ParameterValues[2] := Table;
    //
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.GetIndexes
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Cursor := Context.ExecuteQuery(sDbxCommand, nil, nil);
    Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
    Columns[TDBXIndexesIndex.IsAscending].Hidden := DescendingIndexSupported;
    Result := TDBXCustomMetaDataTable.Create(Context, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Indexes,{$IFEND}
      TDBXMetaDataCollectionName.Indexes, Columns, Cursor);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //
  {@EMPTY:}
  //  Cursor := FContext.ExecuteQuery(SqlForIndexes, ParameterNames, ParameterValues)
  Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
  Columns[TDBXIndexesIndex.IsAscending].Hidden := DescendingIndexSupported;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Indexes,{$IFEND}
  //  TDBXMetaDataCollectionName.Indexes, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Indexes,{$IFEND}
    TDBXMetaDataCollectionName.Indexes, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchProcedures(const Catalog, Schema, ProcedureName,
  ProcedureType: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForProcedures <> '' then
    try
      Result := inherited FetchProcedures(sCatalog, Schema, ProcedureName, ProcedureType);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  ParameterNames[3] := TDBXParameterName.ProcedureType;
  SetLength(ParameterValues,4);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := ProcedureName;
  ParameterValues[3] := ProcedureType;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.GetProcedures
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForProcedures, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProceduresColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Procedures,{$IFEND}
  //  TDBXMetaDataCollectionName.Procedures, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Procedures,{$IFEND}
    TDBXMetaDataCollectionName.Procedures, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchProcedureSources(const Catalog: UnicodeString;
  const Schema: UnicodeString; const &Procedure: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  OrdinalLineNumber: Integer;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForProcedureSources <> '' then
    try
      Result := inherited FetchProcedureSources(sCatalog, Schema, &Procedure);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := &Procedure;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForProcedureSources, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureSourcesColumns;
  //OrdinalLineNumber := FindSourceLineColumn(Cursor, Length(Columns));
  //if OrdinalLineNumber > 0 then
  //  Result := TDBXSourceTableCursor.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ProcedureSources,{$IFEND}
  //    TDBXMetaDataCollectionName.ProcedureSources, Columns, Cursor, TDBXProcedureSourcesIndex.Definition, OrdinalLineNumber)
  //else
  //  Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ProcedureSources,{$IFEND}
  //    TDBXMetaDataCollectionName.ProcedureSources, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ProcedureSources,{$IFEND}
    TDBXMetaDataCollectionName.ProcedureSources, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchSynonyms(const Catalog, Schema, Synonym: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForSynonyms <> '' then
    try
      Result := inherited FetchSynonyms(sCatalog, Schema, Synonym);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.SynonymName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Synonym;
  if fMetadataSupported then
  try
    //sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
    //  + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForSynonyms, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateSynonymsColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Synonyms,{$IFEND}
  //  TDBXMetaDataCollectionName.Synonyms, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Synonyms,{$IFEND}
    TDBXMetaDataCollectionName.Synonyms, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchProcedureParameters(const Catalog: UnicodeString;
  const Schema: UnicodeString; const &Procedure: UnicodeString; const Parameter: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForProcedureParameters <> '' then
    try
      Result := inherited FetchProcedureParameters(sCatalog, Schema, &Procedure, Parameter);
      Exit;
    except
    end;
  end;
  DataTypeHash;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  ParameterNames[3] := TDBXParameterName.ParameterName;
  SetLength(ParameterValues,4);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := &Procedure;
  ParameterValues[3] := Parameter;
  if fMetadataSupported then
  try
    //sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
    //  + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForProcedureParameters, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns;
  //Cursor := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ProcedureParameters,{$IFEND}
  //  TDBXMetaDataCollectionName.ProcedureParameters, Columns, Cursor);
  //Result := TDBXColumnsTableCursor.Create(Self, False, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.ProcedureParameters,{$IFEND}
    TDBXMetaDataCollectionName.ProcedureParameters, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchPackages(const Catalog: UnicodeString; const Schema: UnicodeString;
  const PackageName: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForPackages <> '' then
    try
      Result := inherited FetchPackages(sCatalog, Schema, PackageName);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForPackages, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackagesColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Packages,{$IFEND}
  //  TDBXMetaDataCollectionName.Packages, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Packages,{$IFEND}
    TDBXMetaDataCollectionName.Packages, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchPackageProcedures(const Catalog: UnicodeString; const Schema: UnicodeString;
  const PackageName: UnicodeString; const ProcedureName: UnicodeString; const ProcedureType: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForPackageProcedures <> '' then
    try
      Result := inherited FetchPackageProcedures(sCatalog, Schema, PackageName, ProcedureName, ProcedureType);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,5);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  ParameterNames[3] := TDBXParameterName.ProcedureName;
  ParameterNames[4] := TDBXParameterName.ProcedureType;
  SetLength(ParameterValues,5);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  ParameterValues[3] := ProcedureName;
  ParameterValues[4] := ProcedureType;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForPackageProcedures, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageProcedures,{$IFEND}
  //  TDBXMetaDataCollectionName.PackageProcedures, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageProcedures,{$IFEND}
    TDBXMetaDataCollectionName.PackageProcedures, Columns);
  {@EMPTY:}
end;

function TDBXOpenODBCMetaDataReader.FetchPackageProcedureParameters(const Catalog: UnicodeString; const Schema: UnicodeString;
  const PackageName: UnicodeString; const ProcedureName: UnicodeString; const ParameterName: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForPackageProcedureParameters <> '' then
    try
      Result := inherited FetchPackageProcedureParameters(sCatalog, Schema, PackageName, ProcedureName, ParameterName);
      Exit;
    except
    end;
  end;
  DataTypeHash;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,5);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  ParameterNames[3] := TDBXParameterName.ProcedureName;
  ParameterNames[4] := TDBXParameterName.ParameterName;
  SetLength(ParameterValues,5);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  ParameterValues[3] := ProcedureName;
  ParameterValues[4] := ParameterName;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForPackageProcedureParameters, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns;
  //Cursor := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageProcedureParameters,{$IFEND}
  //  TDBXMetaDataCollectionName.PackageProcedureParameters, Columns, Cursor);
  //Result := TDBXColumnsTableCursor.Create(Self, False, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageProcedureParameters,{$IFEND}
    TDBXMetaDataCollectionName.PackageProcedureParameters, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchPackageSources(const Catalog: UnicodeString; const Schema: UnicodeString; const PackageName: UnicodeString): TDBXTable;
var
  sCatalog: UnicodeString;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  ParameterNames: TDBXStringArray;
  ParameterValues: TDBXStringArray;
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    sCatalog := Catalog;
    if sCatalog = '?' then
      sCatalog := '';
    if SqlForPackageSources <> '' then
    try
      Result := inherited FetchPackageSources(sCatalog, Schema, PackageName);
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  fDbxMode := True;
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := sCatalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  if fMetadataSupported then
  try
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForPackageSources, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageSources,{$IFEND}
  //  TDBXMetaDataCollectionName.PackageSources, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.PackageSources,{$IFEND}
    TDBXMetaDataCollectionName.PackageSources, Columns);
  {@EMPTY:}
end;

function TDBXOpenODBCMetaDataReader.FetchUsers: TDBXTable;
var
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    if SqlForUsers <> '' then
    try
      Result := inherited FetchUsers;
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForUsers, nil, nil);
  Columns := TDBXMetaDataCollectionColumns.CreateUsersColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Users,{$IFEND}
  //  TDBXMetaDataCollectionName.Users, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Users,{$IFEND}
    TDBXMetaDataCollectionName.Users, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchRoles: TDBXTable;
var
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    if SqlForRoles <> '' then
    try
      Result := inherited FetchRoles;
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  {@EMPTY:}
  //Cursor := FContext.ExecuteQuery(SqlForRoles, nil, nil);
  Columns := TDBXMetaDataCollectionColumns.CreateRolesColumns;
  //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Roles,{$IFEND}
  //  TDBXMetaDataCollectionName.Roles, Columns, Cursor);
  Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50}TDBXMetaDataCollectionIndex.Roles,{$IFEND}
    TDBXMetaDataCollectionName.Roles, Columns);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.FetchReservedWords: TDBXTable;
var
  ReservedSqlWords: TDBXStringArray;
  Columns: TDBXValueTypeArray;
  {@dbxoodbc:}{
  sDbxCommand: UnicodeString;
  Cursor: TDBXTable;
  {@dbxoodbc.}
begin
  if fMetadataSupported then
  begin
    fDbxMode := False;
    if SqlForReservedWords <> '' then
    try
      Result := inherited FetchReservedWords;
      Exit;
    except
    end;
  end;
  (*//
  {@dbxoodbc:}
  if fMetadataSupported then
  try
    fDbxMode := True;
    sDbxCommand := DBX4_CMD_PREFIX + TDBXMetaDataCommands.Get?
      + DBXStringArrayToNamedQueryParams(ParameterNames, ParameterValues);
    todo: ...
    Exit;
  except
  end;
  {@dbxoodbc.}
  //*)
  ReservedSqlWords := ReservedWords;
  Columns := TDBXMetaDataCollectionColumns.CreateReservedWordsColumns;
  {@EMPTY:}
  if ReservedSqlWords = nil then
  begin
    //Cursor := FContext.ExecuteQuery(SqlForReservedWords, nil, nil);
    //Result := TDBXCustomMetaDataTable.Create(FContext, {$IF CompilerVersion = 18.50} TDBXMetaDataCollectionIndex.ReservedWords,{$IFEND}
    //  TDBXMetaDataCollectionName.ReservedWords, Columns, Cursor);
    Result := TDBXEmptyTableCursor.Create({$IF CompilerVersion = 18.50} TDBXMetaDataCollectionIndex.ReservedWords,{$IFEND}
      TDBXMetaDataCollectionName.ReservedWords, Columns);
  end
  else
    Result := TDBXReservedWordsCursor.Create(Context, Columns, ReservedSqlWords);
  {@EMPTY.}
end;

function TDBXOpenODBCMetaDataReader.GetProductName: UnicodeString;
begin
  Result := DbxOODBCDriverProductName;
end;

function TDBXOpenODBCMetaDataReader.GetReservedWords: TDBXStringArray;
begin
  Result := nil;
  // todo dbxoodbc: SQLGetInfo(FConnectionHandle, SQL_KEYWORDS,
  // todo: Result := DBXStringArrayFromStrings(GetVendorProperty(cfvp_GetReservedWords));
end;

function TDBXOpenODBCMetaDataReader.GetSqlForColumns: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForForeignKeyColumns: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForForeignKeys: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForIndexColumns: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForIndexes: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForPackageProcedureParameters: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForPackageProcedures: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForPackages: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForPackageSources: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForProcedureParameters: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForProcedures: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForProcedureSources: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForRoles: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForSchemas: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForSynonyms: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForTables: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForUsers: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.GetSqlForViews: UnicodeString;
begin
  Result := ''; // DBX4_CMD_EMPTY_CURSOR;
end;

function TDBXOpenODBCMetaDataReader.IsNestedTransactionsSupported: Boolean;
begin
  Result := False;
end;

function TDBXOpenODBCMetaDataReader.IsSetRowSizeSupported: Boolean;
begin
  Result := True;
end;

{procedure InitConnectionFactory;
var
  CF: TDBXMemoryConnectionFactory;
begin
  CF := TDBXMemoryConnectionFactory.Create;
  CF.Open;
  TDBXConnectionFactory.SetConnectionFactory(CF);
end;{}

initialization
  {$IF CompilerVersion > 18.50} // Delphi 2009
  TDBXDriverRegistry.RegisterDriverClass({DbxXXDrv.pas}DbxOODBCDriverName, TDbxOpenOdbcDriver);
  {$IFEND}
  bIsDbx34Drv := True;
  TDBXOpenODBCMetaDataCommandFactory.RegisterMetaDataCommandFactory;
//@D2007: !!!
  TClassRegistry.GetClassRegistry.RegisterRegistryClass(TDBXDynalinkDriverLoaderOpenOdbc.ClassName, TDBXDynalinkDriverLoaderOpenOdbc);
//@D2007.
  //InitConnectionFactory;
finalization
  {$IF CompilerVersion > 18.50}
  TDBXDriverRegistry.UnregisterDriverClass({DbxXXDrv.pas}DbxOODBCDriverName);
  {$IFEND}
  TDBXOpenODBCMetaDataCommandFactory.UnRegisterMetaDataCommandFactory;
//@D2007:
  TClassRegistry.GetClassRegistry.UnRegisterClass(TDBXDynalinkDriverLoaderOpenOdbc.ClassName);
//@D2007.
{$IFEND CompilerVersion >= 18.50}
{$ENDIF CONDITIONALEXPRESSIONS}
end.
