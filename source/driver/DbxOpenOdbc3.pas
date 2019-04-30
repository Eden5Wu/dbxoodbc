{
  Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.15

  Copyright (c) 2001-2012 Vadim V.Lopushansky

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
unit DbxOpenOdbc3;

{$include DbxOpenOdbc_options.inc}

interface

{.$IFDEF _DBX30_}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF _KYLIX_}
  Types,
  {$ENDIF}
  {$IFNDEF _KYLIX_}{$IFDEF POSIX}
  Posix.Unistd, Posix.String_, Posix.Pthread,
  {$ENDIF}{$ENDIF}
  SysUtils,
  Classes,
  //
  DSIntf,
  FMTBcd,
  //
  DbxOpenOdbcTypes,
  DbxOpenOdbcInterface,
  OdbcApi,
  DbxOpenOdbcDbx3Types,
  DbxOpenOdbcFuncs,
  DbxOpenOdbcUtils,
  {$IFDEF _TRACE_CALLS_}
  DbxOpenOdbcTrace,
  {$ENDIF _TRACE_CALLS_}
  {$IFDEF _DBXCB_}
  DbxOpenOdbcCallback,
  {$ENDIF}
  DbxOpenOdbc;

{ getSQLDriverODBC is the starting point for everything else... }

// priority unicode odbc api
function getSQLDriverODBCW(sVendorLib, sResourceFile: PAnsiChar; out Obj): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
// priority ansi odbc api
function getSQLDriverODBCWA(sVendorLib, sResourceFile: PAnsiChar; out Obj): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}

type

  { TSqlDriverOdbc3 implements ISQLDriver }

  TSqlDriverOdbc3 = class(TSqlDriverOdbc, ISQLDriver)
  protected
    { begin ISQLDriver methods }
    function getSQLConnection(out pConn: ISQLConnection): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLDriver methods }
  public
    constructor Create(AOdbcApi: TOdbcApiProxy; bIsUnicodeOdbcApi: Boolean); override;
  end;

  { TSqlConnectionOdbc implements ISQLConnection }

  TSQLMetaDataOdbc3 = class;

  TSqlConnectionOdbc3 = class(TSqlConnectionOdbc, ISQLConnection, ISQLConnection30)
  protected
    fServerName, fUserName, fPassword: WideString;
    // @dbx34:
    fMetaDataReader: TSqlMetaDataOdbc3;
    //
    function GetMetaDataReader: TSqlMetaDataOdbc3;
    // @dbx34.
  protected
    { begin: ISQLConnection30 interface methods: }
     function connect(): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function connect(ServerName: PWideChar; UserName: PWideChar; Password: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function getSQLCommand(out pComm: ISQLCommand30): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function getSQLMetaData(out pMetaData: ISQLMetaData30): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function SetOption(eConnectOption: TSQLConnectionOption; lValue: LongInt): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function GetOption(eDOption: TSQLConnectionOption; PropValue: Pointer; MaxLength: SmallInt; out iLength: SmallInt): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     function getErrorMessageLen(out ErrorLen: SmallInt): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
     { end: ISQLConnection30 interface methods. }
  public
    constructor Create(OwnerDbxDriver: TSqlDriverOdbc); override;
    destructor Destroy; override;

    property MetaDataReader: TSqlMetaDataOdbc3 read GetMetaDataReader;
  end;

  { TSqlCommandOdbc implements ISQLCommand }

  TSqlCommandOdbc3 = class(TSqlCommandOdbc, ISQLCommand, ISQLCommand30)
  protected
    { begin ISQLCommand methods }
    function SetOption(eSqlCommandOption: TSQLCommandOption; ulValue: Integer): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(eSqlCommandOption: TSQLCommandOption; PropValue: Pointer; MaxLength: SmallInt; out iLength: SmallInt): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function prepare(SQL: PWideChar; ParamCount: Word): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function execute(var Cursor: ISQLCursor30): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function executeImmediate(SQL: PWideChar; var Cursor: ISQLCursor30): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getNextCursor(var Cursor: ISQLCursor30): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: SmallInt): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCommand methods }
  end;

  { TSqlCursorOdbc implements ISQLCursor }

  TSqlCursorOdbc3 = class(TSqlCursorOdbc, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(
      Error: PWideChar
      ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
      out ErrorLen: Smallint
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnNameLength(
      ColumnNumber: Word;
      var pLen: Word): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(
      ColumnNumber: Word;
      pColumnName: PWideChar
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getWideString(
      ColumnNumber: Word;
      Value: PWideChar;
      var IsBlank: LongBool
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getInt64(
       ColumnNumber: Word;
       Value: Pointer;
       var IsBlank: LongBool)
       : SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  { TSQLMetaDataOdbc implements ISQLMetaData }

  TSQLMetaDataOdbc3 = class(TSQLMetaDataOdbc, ISQLMetaData, ISQLMetaData30)
  protected
    { begin ISQLMetaData methods }
    function SetOption(
      eDOption: TSQLMetaDataOption;
      PropValue: Longint
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
      eDOption: TSQLMetaDataOption;
      PropValue: Pointer;
      MaxLength: Smallint;
      out iLength: Smallint
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getObjectList(
      eObjType: TSQLObjectType;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getTables(
      TableName: PWideChar;
      TableType: Longword;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedures(
      ProcedureName: PWideChar;
      ProcType: Longword;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumns(
      TableName: PWideChar;
      ColumnName: PWideChar;
      ColType: Longword;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedureParams(
      ProcName: PWideChar;
      ParamName: PWideChar;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getIndices(
      TableName: PWideChar;
      IndexType: Longword;
      out Cursor: ISQLCursor30
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
      Error: PWideChar
      ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
      out ErrorLen:
      Smallint
      ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLMetaData methods }
  end;

  { TSqlCursorMetaDataTables - implements cursor returned by ISQLMetaData.GetTables }
  TSqlCursorMetaDataTables3 = class(TSqlCursorMetaDataTables, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: Smallint): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(ColumnNumber: Word; pColumnName: PWideChar): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  { TSqlCursorMetaDataColumns - implements cursor returned by ISQLMetaData.GetColumns }

  TSqlCursorMetaDataColumns3 = class(TSqlCursorMetaDataColumns, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: Smallint): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(ColumnNumber: Word; pColumnName: PWideChar): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  { TSqlCursorMetaDataIndexes - implements cursor returned by ISQLMetaData.GetIndices }

  TSqlCursorMetaDataIndexes3 = class(TSqlCursorMetaDataIndexes, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: Smallint): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(ColumnNumber: Word; pColumnName: PWideChar): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  { TSqlCursorMetaDataProcedures - implements cursor returned by ISQLMetaData.GetProcedures }

  TSqlCursorMetaDataProcedures3 = class(TSqlCursorMetaDataProcedures, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: Smallint): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(ColumnNumber: Word; pColumnName: PWideChar): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  { TSqlCursorMetaDataProcedureParams - implements cursor returned by ISQLMetaData.GetProcedureParams }

  TSqlCursorMetaDataProcedureParams3 = class(TSqlCursorMetaDataProcedureParams, ISQLCursor, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getErrorMessage(Error: PWideChar): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(out ErrorLen: Smallint): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(ColumnNumber: Word; pColumnName: PWideChar): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

{ @dbx34: }

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

type
  TArrayOfAnsiString = array of AnsiString;
  TArrayOfWideString = array of WideString;

  TDbxCommandParser = class
  protected
    fDbxCommand: string;
    fParamCount: Integer;
    fParamNames: TArrayOfAnsiString;
    fParamValues: TArrayOfWideString;
    fNextParamIndex: Integer; // It is used for quick searching for of the following parameter.
                              // We expect that address to parameter will go in order of their determination.
                              // See method GetParam
    function GetParam(AName: AnsiString): WideString;
  public
    constructor Create(ADbxCmdText: WideString; CheckIsDbxCommand: Boolean = True);

    class function IsDbxCommand(ADbxCmdText: WideString): Boolean; overload; {$ifdef _inline_}inline; {$endif}
    class function IsDbxCommand(ADbxCmdText: PWideChar): Boolean; overload; {$ifdef _inline_}inline; {$endif}
    class function IsDbxCommand(ADbxCmdText: PAnsiChar): Boolean; overload; {$ifdef _inline_}inline; {$endif}
    class function IsDbxCommand(ADbxCmdText: Pointer; AUnicode: Boolean): Boolean; overload; {$ifdef _inline_}inline; {$endif}

    property DbxCommand: string read fDbxCommand;
    property ParamCount: Integer read fParamCount;
    property Params[AName: AnsiString]: WideString read GetParam;
  end;

type
  TSqlCursorMetaDataEmpty = class(TSqlCursorMetaDataIndexes3, ISQLCursor30)
  public
    constructor Create(AConnection: TSqlConnectionOdbc3); overload;
    constructor Create(AConnection: TSqlConnectionOdbc3;
      AColNames: array of AnsiString; AColTypes: array of Word); overload;
    constructor Create(AConnection: TSqlConnectionOdbc3; AColCount: Integer); overload;
  protected
    { begin ISQLCusror methods }
    function getColumnCount(
                var pColumns: Word
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnNameLength(
                ColumnNumber: Word;
                var pLen: Word): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(
                ColumnNumber: Word;
                pColumnName: PWideChar
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnType(
                ColumnNumber: Word;
                var puType: Word;
                var puSubType: Word
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnLength(
                ColumnNumber: Word;
                var pLength: Longword
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnPrecision(
                ColumnNumber: Word;
                var piPrecision: Smallint
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnScale(
                ColumnNumber: Word;
                var piScale: Smallint
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isNullable(
                ColumnNumber: Word;
                var Nullable: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getShort(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getLong(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getDouble(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBcd(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getTimeStamp(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getTime(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getDate(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBytes(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBlobSize(
                ColumnNumber: Word;
                var iLength: Longword;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBlob(
                ColumnNumber: Word;
                Value: Pointer;
                var IsBlank: LongBool;
                iLength: Longword
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getWideString(
                ColumnNumber: Word;
                Value: PWideChar;
                var IsBlank: LongBool
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  end;

  TSqlCursorMetaDataTablesDbx34 = class(TSqlCursorMetaDataTables3)
  protected
    procedure GetPhysColumnWideString(PhysColumnNumber: Word; Value: PWideChar); override;
  public
    constructor Create(AConnection: TSqlConnectionOdbc3);
  end;

  TSqlCursorMetaDataColumnsDbx34 = class(TSqlCursorMetaDataColumns3, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getLong(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getShort(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  public
    constructor Create(AConnection: TSqlConnectionOdbc3);
  end;

  TSqlCursorMetaDataIndexesDbx34 = class(TSqlCursorMetaDataIndexes3, ISQLCursor30)
  //protected
  //  procedure GetPhysColumnWideString(PhysColumnNumber: Word; Value: PWideChar); override;
  protected
    { begin ISQLCusror methods }
    function getShort(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  public
    constructor Create(AConnection: TSqlConnectionOdbc3);
  end;

  TSqlCursorMetaDataIndexColumnsDbx34 = class(TSqlCursorMetaDataIndexes3, ISQLCursor30)
  protected
    { begin ISQLCusror methods }
    function getLong(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getShort(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    { end ISQLCusror methods }
  public
    constructor Create(AConnection: TSqlConnectionOdbc3);
  end;

{ @dbx34. }

var
  cConnectionOptionsDefault3: TConnectionOptions;

{.$ENDIF _DBX30_}

implementation

{.$IFDEF _DBX30_}

uses
  //StrUtils, // PosEx
  {$IFDEF UNICODE}
  AnsiStrings,
  //{$ELSE}
  //StrUtils,
  {$ENDIF}
//
//  WideStrUtils,
//
  DB, SqlTimst, DateUtils;

{ Public function getSQLDriverODBC is the starting point for everything else... }

function getSQLDriverODBCW;//(sVendorLib, sResourceFile: PAnsiChar; out Obj): SQLResult;
var
  OdbcApiProxy: TOdbcApiProxy;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}
  try try {$R+}
  LogEnterProc('getSQLDriverODBCW', ['sVendorLib =', System.Ansistrings.StrPas(sVendorLib), 'sResourceFile =', sResourceFile, 'Obj =', Pointer(Obj)] ); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF}
  Pointer(Obj) := nil;
  OdbcApiProxy := LoadOdbcDriverManager(sVendorLib, {UnicodePriority:}True);
  if OdbcApiProxy = nil then
    raise EDbxError.Create('Unable to load specified Odbc Driver manager DLL: ''' + sVendorLib + '''');
  ISQLDriver(Obj) := TSqlDriverOdbc3.Create(OdbcApiProxy, {IsUnicodeOdbcApi:}True);
  {$IFDEF _TRACE_CALLS_}
    except
      on e: Exception do
      begin
        LogExceptProc('getSQLDriverODBCW', e);
        raise;
      end;
    end;
    finally
      LogExitProc('getSQLDriverODBCW', ['Result =', Result, 'Obj =', Pointer(Obj)]);
    end;
  {$ENDIF}
end;

function getSQLDriverODBCWA;//(sVendorLib, sResourceFile: PAnsiChar; out Obj): SQLResult;
var
  OdbcApiProxy: TOdbcApiProxy;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}
  try try {$R+}
  LogEnterProc('getSQLDriverODBCWA', ['sVendorLib =', System.AnsiStrings.StrPas(sVendorLib), 'sResourceFile =', sResourceFile, 'Obj =', Pointer(Obj)] ); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF}
  Pointer(Obj) := nil;
  OdbcApiProxy := LoadOdbcDriverManager(sVendorLib, {UnicodePriority:}False);
  if OdbcApiProxy = nil then
    raise EDbxError.Create('Unable to load specified Odbc Driver manager DLL: ''' + sVendorLib + '''');
  ISQLDriver(Obj) := TSqlDriverOdbc3.Create(OdbcApiProxy, {IsUnicodeOdbcApi:}False);
  {$IFDEF _TRACE_CALLS_}
    except
      on e: Exception do
      begin
        LogExceptProc('getSQLDriverODBCWA', e);
        raise;
      end;
    end;
    finally
      LogExitProc('getSQLDriverODBCWA', ['Result =', Result, 'Obj =', Pointer(Obj)]);
    end;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}

function BeginLock(const LockName: string; out hLock: THandle; TimeOut: DWORD = INFINITE): Boolean;
var
  S: string;
begin
  S := LockName;
  if S <> '' then
  begin
    //S := StringReplace(S, '\', '|', [rfReplaceAll]);
    //S := StringReplace(S, #0, '@', [rfReplaceAll]);
    StringCharModify(S, '\', '|', True);
    StringCharModify(S, #0, '?', '@', True);
    if Length(S) > MAX_PATH  then
      SetLength(S, MAX_PATH);
  end;
  hLock := CreateMutex(nil, True, PChar(S));
  Result := hLock <> 0;
  if Result then
  begin
    Result := WaitForSingleObject( hLock, TimeOut ) = WAIT_OBJECT_0;
    if not Result then
    begin
      CloseHandle(hLock);
      hLock := 0;
    end;
  end
  else
  begin
    hLock := 0;
    //RaiseLastOsError();
  end;
end;

procedure EndLock(var hLock: THandle);
begin
  if hLock <> 0 then
  begin
    CloseHandle(hLock);
    hLock := 0;
  end;
end;

var
  gClientVersionOverload: Integer = -1;

procedure HostAppPlatformInitialize();
var
  hLock: THandle;
begin
  BeginLock('{6603C100-8CE4-4B5A-ACF1-3D99B2F90B3C}:' + IntToStr(GetCurrentProcessID), hLock, 6000);
  try
    if gClientVersionOverload >= 0 then
      Exit;
    gClientVersionOverload := 0;
    //
    // Delphi 2009, 2010, 2011: 'dbxadapter.dll'
    //
    if (GetModuleHandle('dbxadapter.dll') <> 0) then
      gClientVersionOverload := 41
    //
    // Delphi 2007: 'dbxadapter30.dll'
    //
    else if (GetModuleHandle('dbxadapter30.dll') <> 0) then
      gClientVersionOverload := 40;
    //
    // Check that application works over CLR
    //
    if (GetModuleHandle('dbxintf.dll') <> 0) or (GetModuleHandle('bdpdbx25.dll') <> 0) then
    begin
      Include(gHostPlatform, hpCLR);
      //gClientVersionOverload := 40;
    end;
  finally
    EndLock(hLock);
  end;
end;

{$ENDIF MSWINDOWS}

{ TSqlDriverOdbc3 }

constructor TSqlDriverOdbc3.Create(AOdbcApi: TOdbcApiProxy; bIsUnicodeOdbcApi: Boolean);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlDriverOdbc3.Create'); {$ENDIF _TRACE_CALLS_}
  fDBXVersion := 30; { == 3.0 }
  //
  {$IFDEF MSWINDOWS}
  if gClientVersionOverload < 0 then
    HostAppPlatformInitialize();
  if gClientVersionOverload > 0 then
    fClientVersion := gClientVersionOverload { >= 4.0 }
  else
  {$ENDIF MSWINDOWS}
  fClientVersion := 30; { == 3.0 }
  //
  inherited Create(AOdbcApi, bIsUnicodeOdbcApi);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlDriverOdbc3.Create', e);  raise; end; end;
    finally LogExitProc('TSqlDriverOdbc3.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlDriverOdbc3.getSQLConnection;//(out pConn: ISQLConnection): SQLResult;
begin
  Pointer(pConn) := nil;
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlDriverOdbc3.getSQLConnection'); {$ENDIF _TRACE_CALLS_}
  ISQLConnection(pConn) := TSqlConnectionOdbc3.Create(Self);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlDriverOdbc3.getSQLConnection', e);  raise; end; end;
    finally LogExitProc('TSqlDriverOdbc3.getSQLConnection', ['Result =', Result, 'pConn =', Pointer(pConn)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlConnectionOdbc3 }

constructor TSqlConnectionOdbc3.Create;//(OwnerDbxDriver: TSqlDriverOdbc);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlConnectionOdbc3.Create'); {$ENDIF _TRACE_CALLS_}

  inherited Create(OwnerDbxDriver);

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.Create', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

destructor TSqlConnectionOdbc3.Destroy;
begin
  FreeAndNil(fMetaDataReader);
  inherited;
end;

function TSqlConnectionOdbc3.connect: SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlConnectionOdbc3.connect(A)'); {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  Result := inherited connect(PAnsiChar(AnsiString(fServerName)), PAnsiChar(AnsiString(fUserName)),  PAnsiChar(AnsiString(fPassword)));
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.connect(A)', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.connect(A)', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.connect(ServerName, UserName, Password: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSqlConnectionOdbc.connect(B)', ['ServerName=', PWideChar(ServerName), 'UserName =', PWideChar(UserName), 'Password =', PWideChar(Password)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  fServerName := ServerName;
  fUserName := UserName;
  fPassword := Password;
  // ansi:
  //
  Result := inherited connect(PAnsiChar(AnsiString(fServerName)), PAnsiChar(AnsiString(fUserName)),  PAnsiChar(AnsiString(fPassword)));
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc.connect(B)', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc.connect(B)', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlConnectionOdbc3.getErrorMessage', ['ErrorPtr =', Pointer(Error), 'UserName =']); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fConnectionErrorLines, Error);
    fConnectionErrorLines.Clear;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.getErrorMessage', ['Result =', Result, 'Error =', PWideChar(Error)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.getErrorMessageLen;//(out ErrorLen: SmallInt): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlConnectionOdbc3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fConnectionErrorLines) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.getErrorMessageLen', ['Result =', Result, 'ErrorLen =', ErrorLen]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.GetMetaDataReader;//: TSqlMetaDataOdbc3;
begin
  if fMetaDataReader = nil then
    fMetaDataReader := TSqlMetaDataOdbc3.Create(Self, {SupportWideString:}True);
  Result := fMetaDataReader;
end;

function TSqlConnectionOdbc3.GetOption;//(eDOption: TSQLConnectionOption; PropValue: Pointer;
//  MaxLength: SmallInt; out iLength: SmallInt): SQLResult;
var
  xeDOption: TXSQLConnectionOption absolute eDOption;
  sOptionValue: AnsiString;
  iMaxChars: Integer;
  sDbxCmdText: WideString;
  sPropName: string;
  // ---
{$IFDEF _TRACE_CALLS_}
var
  isError: Boolean;

  function Result2Str: AnsiString;
  begin
    if (xeDOption in cXSQLConnectionOptionStringTypes) then
    begin
      if (PropValue <> nil) then
        Result := AnsiString(WideString(PWideChar(PropValue)))
      else
        Result := '';
      if sPropName <> '' then
        Result := Result + '"; for property: "' + AnsiString(sPropName);
      Exit;
    end;
    case xeDOption of
      //xeConnServerVersion,
      //xeConnDatabaseName,
      //xeConnServerCharSet,
      //xeConnObjectQuoteChar,
      //xeConnConnectionName:
      //xeConnQualifiedName,
      //xeConnCatalogName,
      //xeConnSchemaName,
      //xeConnObjectName,
      //xeConnQuotedObjectName,
      //xeConnCustomInfo,
      //xeConnConnectionString,
      //xeVendorProperty:
      //  Result := StrPas(PAnsiChar(PropValue));
      //xeConnDecimalSeparator:
      //    Result := PAnsiChar(PropValue)^;
      xeConnAutoCommit,
      xeConnBlockingMode:
        Result := AnsiString(BoolToStr(Boolean(PropValue^)));
      xeConnBlobSize:
        Result := AnsiString(IntToStr(Integer(PropValue^)));
      xeConnTxnIsoLevel:
        case TTransIsolationLevel(PropValue^) of
          xilREPEATABLEREAD:
            Result := 'xilREPEATABLEREAD';
          xilREADCOMMITTED:
            Result := 'xilREADCOMMITTED';
          xilDIRTYREAD:
            Result := 'xilDIRTYREAD';
          else
            Result := AnsiString(IntToStr(Integer(PropValue^)));
        end;
      xeConnSupportsTransaction,
      xeConnMultipleTransaction,
      xeConnTrimChar:
        Result := AnsiString(BoolToStr(Boolean(PropValue^)));
      else
        Result := AnsiString(IntToStr(Longint(PropValue^)));
    end; //of: case
  end;
{$ENDIF _TRACE_CALLS_1}
  //
  function LGetISQLConnection30(): string;
  var
    AISQLConnection30: ISQLConnection30;
  begin
    AISQLConnection30 := Self;
    Result := IntToStr(Integer(Pointer(AISQLConnection30)));
    Pointer(AISQLConnection30) := nil;
  end;

var
  dbxcmd: TDbxCommandParser;

  procedure DoSetVendoLib;
  var
    sVendorLib, sGetDriverFunc: string;
    bUnicodePriority: Boolean;
    ASqlDriverClass: TSqlDriverOdbcClass;
  begin
    sOptionValue := 'true';
    sVendorLib := string(Trim(dbxcmd.Params['VendorLib']));
    sGetDriverFunc := string(Trim(dbxcmd.Params['GetDriverFunc']));
    if sVendorLib <> '' then
    begin
      bUnicodePriority := (sGetDriverFunc = '') or SameText(sGetDriverFunc, 'getSQLDriverODBCW')
        or SameText(sGetDriverFunc, 'getSQLDriverODBCAW');
      ASqlDriverClass := TSqlDriverOdbc3;
      try
        SetVendorLib(sVendorLib, bUnicodePriority, ASqlDriverClass);
      except
        on e: Exception do
        begin
          sOptionValue := AnsiString(e.Message);
        end;
      end
    end;
  end;

  procedure DoSetCustomString;
  var
    P: AnsiString;
  begin
    P := AnsiString(Trim(dbxcmd.Params['Custom String']));
    if (P = '') or (inherited SetOption(TSQLConnectionOption(xeConnCustomInfo), Integer(PAnsiChar(P))) = DBXERR_NONE) then
      sOptionValue := 'true'
    else
    begin
      sOptionValue := AnsiString(fConnectionErrorLines.Text);
      if sOptionValue = '' then
        sOptionValue := '0';
    end;
  end;

begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}
    isError := True;
    try try {$R+}
    LogEnterProc('TSqlConnectionOdbc3.GetOption', ['eDOption = '+cSQLConnectionOption[xeDOption], 'MaxLength =', MaxLength, 'Length =', iLength]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  iLength := 0;
  if (xeDOption in cXSQLConnectionOptionStringTypes)  then
  begin
    //if TSqlDriverOdbc3(fOwnerDbxDriver).fClientVersion >= 40 then // Delphi 2007
    begin
      if xeDOption = xeVendorProperty then
      begin
        sDbxCmdText := WideString(PWideChar(PropValue));
        sPropName := string(sDbxCmdText);
        if sPropName <> '' then
        begin
          {$IFDEF _TRACE_CALLS_}
          LogInfoProc('PropertyName = "' + AnsiString(sPropName) + '"');
          {$ENDIF}
          iMaxChars := MaxLength div SizeOf(WideChar) + 1;
          (*
          if iMaxChars = 1 then // detected for: 'SupportsParameterMetaData'
          begin
            // ERROR: uncorrect buffer length
            if PropValue <> nil then
              PWideChar(PropValue)^ := cNullWideChar;
            iLength := 0;
            {$IFDEF _TRACE_CALLS_}
            isError := False;
            {$ENDIF}
            Result := DBXERR_NOTSUPPORTED; // DBXERR_WARNING;
            Exit;
          end;
          //*)
          sOptionValue := '';
          if SameText(sPropName, 'ProductName') { !!! not to change !!! } then
          begin
            sOptionValue := 'DbxOpenOdbc';
          end
          else
          if SameText(sPropName, 'SupportsParameterMetaData') then
          begin
            // if MaxLength = 0 then
            // begin
            //   iLength := 0;
            //   Exit;
            //end;
            iLength := 0;
            Result := DBXERR_NOTSUPPORTED; // DBXERR_WARNING;
            Exit;
            //sOptionValue := AnsiString('false');
            //iMaxChars := MAX_VERSION_STRING_LENGTH; // ERROR: uncorrect buffer length
          end
          {@dbx34:}
          //
          // DBX34: Dbx34Drv.pas:
          //       procedure TDBXDynalinkConnection_Enhance.DerivedOpen;
          //       ...
          //           SISQLConnection30 := GetVendorProperty('ISQLConnection30');
          //
          else if SameText(sPropName, cfvp_Supported) then
          begin
            sOptionValue := AnsiString('true');
          end
          else if SameText(sPropName, 'DbxOODBC.ISQLConnection30')
            or SameText(sPropName, 'DbxOODBC.ISQLConnection') then
          begin
            sOptionValue := AnsiString(LGetISQLConnection30());
          end
          else
          begin
            if TDbxCommandParser.IsDbxCommand(sDbxCmdText) then
            begin
              dbxcmd := TDbxCommandParser.Create(sDbxCmdText, False);
              try
                sOptionValue := #0;
                if dbxcmd.ParamCount > 0 then
                begin
                  if SameText(dbxcmd.DbxCommand, csvp_SetVendorLib) then
                    DoSetVendoLib()
                  else if SameText(dbxcmd.DbxCommand, csvp_SetCustomString) then
                    DoSetCustomString()
                end;
              finally
                dbxcmd.Free;
              end;
            end;
          end;
          //
          // make result
          //
          if sOptionValue <> '' then
          begin
            {$IFDEF _DBXCB_}
            if Assigned(fDbxTraceCallbackEven) then
              DbxCallBackSendMsgFmt(cTDBXTraceFlags_Vendor, 'ISQLConnection.GetOption (VendorProperty): "%s" = "%s"', [AnsiString(sPropName), sOptionValue]);
            {$ENDIF}
            if System.Length(sOptionValue) > iMaxChars then
              SetLength(sOptionValue, iMaxChars);
            StringToWStr(sOptionValue, PWideChar(PropValue));
            iLength := System.Length(sOptionValue) * SizeOf(WideChar);
            {$IFDEF _TRACE_CALLS_}
            isError := False;
            {$ENDIF}
            Exit;
          end;
          {@dbx34.}
        end;
      end;
    end;

    if PropValue <> nil then
      PWideChar(PropValue)^ := cNullWideChar;

    iMaxChars := MaxLength div SizeOf(WideChar) + 1;
    if sPropName <> '' then
    begin
      if System.Length(sPropName) + 1 > iMaxChars then
      begin
        sOptionValue := AnsiString(sPropName + #0);
      end
      else
      begin
        sOptionValue := AnsiString(sPropName + #0);
        SetLength(sOptionValue, iMaxChars);
      end;
    end
    else
    begin
      SetLength(sOptionValue, iMaxChars);
      FillChar(sOptionValue[1], iMaxChars, 0);
    end;

    Result := inherited GetOption(eDOption, PAnsiChar(sOptionValue), iMaxChars, iLength);
    if Result = DBXERR_NONE then
    begin
      SetLength(sOptionValue, System.AnsiStrings.StrLen(PAnsiChar(sOptionValue)));
      if PropValue <> nil then
        iLength := StringToWideChar(sOptionValue, PWideChar(PropValue), iMaxChars)  * SizeOf(WideChar)
      else
        iLength := System.Length(sOptionValue) * SizeOf(WideChar);
    end;
  end
  else
  begin
    Result := inherited GetOption(eDOption, PropValue, MaxLength, iLength);
  end;
  {$IFDEF _TRACE_CALLS_}
    isError := False;
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.GetOption', e);  raise; end; end;
    finally
      if not isError then
      begin
        if Result = DBXERR_NONE then
          LogInfoProc('Result.PropValue = "' + Result2Str() + '"')
        else
          LogInfoProc('Result <> SQL_SUCCESS');
      end;
      LogExitProc('TSqlConnectionOdbc3.GetOption', ['Result =', Result, 'Length =', iLength]);
    end;
  {$ENDIF}
end;

function TSqlConnectionOdbc3.SetOption;//(eConnectOption: TSQLConnectionOption; lValue: Integer): SQLResult;
var
  xeConnectOption: TXSQLConnectionOption absolute eConnectOption;
  sOptionValue: AnsiString;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}
    try try {$R+}
    LogEnterProc('TSqlConnectionOdbc3.SetOption', ['eConnectOption = '+cSQLConnectionOption[xeConnectOption], 'lValuePtr =', Pointer(lValue)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (xeConnectOption in cXSQLConnectionOptionStringTypes) then
  begin
    if (lValue <> 0) then
    begin
      sOptionValue := AnsiString(WideString(PWideChar(lValue)));
      Result := inherited SetOption(eConnectOption, Integer(PAnsiChar(sOptionValue)));
    end;
  end
  else
    Result := inherited SetOption(eConnectOption, lValue);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.SetOption', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.SetOption', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.getSQLCommand;//(out pComm: ISQLCommand30): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlConnectionOdbc3.getSQLCommand', ['pComm =', Pointer(pComm)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  Pointer(pComm) := nil;
  if fConnected and (not fConnectionClosed) then
  begin
    pComm := TSqlCommandOdbc3.Create(Self);
  end
  else
  begin
    CheckMaxLines(fConnectionErrorLines);
    fConnectionErrorLines.Add('getSQLCommand called but not yet connected');
    Result := DBX_DRIVER_ERROR;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.getSQLCommand', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.getSQLCommand', ['Result =', Result, 'pComm =', Pointer(pComm)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlConnectionOdbc3.getSQLMetaData;//(out pMetaData: ISQLMetaData30): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlConnectionOdbc3.getSQLMetaData', ['pMetaData =', Pointer(pMetaData)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  Pointer(pMetaData) := nil;
  if fConnected and (not fConnectionClosed) then
  begin
    pMetaData := TSqlMetaDataOdbc3.Create(Self, {SupportWideString:}True);
  end
  else
  begin
    CheckMaxLines(fConnectionErrorLines);
    fConnectionErrorLines.Add('getSQLMetaData called but not yet connected');
    Result := DBX_DRIVER_ERROR;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlConnectionOdbc3.getSQLMetaData', e);  raise; end; end;
    finally LogExitProc('TSqlConnectionOdbc3.getSQLMetaData', ['Result =', Result, 'pMetaData =', Pointer(pMetaData)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCommandOdbc3 }

function TSqlCommandOdbc3.prepare;//(SQL: PWideChar; ParamCount: Word): SQLResult;
var
  S: AnsiString;
begin
  // ansi:
  //
  //S := WideString(SQL);
  //Result := inherited prepare(PAnsiChar(S), ParamCount);

  // unicode:
  //
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSqlCommandOdbc3.prepare',
    ['SQL =', PWideChar(SQL), 'ParamCount =', ParamCount, 'StoredProc =', fStoredProc]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  {$IFDEF _DBXCB_}
  if Assigned(TSqlConnectionOdbc3(fOwnerDbxConnection).fDbxTraceCallbackEven) then
    TSqlConnectionOdbc3(fOwnerDbxConnection).DbxCallBackSendMsgFmt(cTDBXTraceFlags_Prepare,
      'ISQLCommand.Prepare ParamCount: %d; SQL: %s', [ParamCount, AnsiString(WideString(SQL))]);
  {$ENDIF}
  if SQL = nil then
  begin
    Result := DBXERR_INVALIDPARAM;
    Exit;
  end;
  if TSqlDriverOdbc3(fOwnerDbxDriver).fIsUnicodeOdbcApi then
  begin
    Result := DoPrepare(PAnsiChar(SQL), ParamCount, {UpdateParams:}True,
      {bPrepareSQL:}TSqlConnectionOdbc3(fOwnerDbxConnection).fPrepareSQL, {bUseUnicodeOdbc:} True);
  end
  else
  begin
    S := AnsiString(WideString(SQL));
    Result := DoPrepare(PAnsiChar(S), ParamCount, {UpdateParams:}True,
      {bPrepareSQL:}TSqlConnectionOdbc3(fOwnerDbxConnection).fPrepareSQL, {bUseUnicodeOdbc:} False);
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCommandOdbc3.prepare', e);  raise; end; end;
    finally LogExitProc('TSqlCommandOdbc3.prepare', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCommandOdbc3.execute;//(var Cursor: ISQLCursor30): SQLResult;
var
  vCursor25: ISQLCursor25 absolute Cursor;
begin
  // unicode:
  //
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCommandOdbc3.execute'); {$ENDIF _TRACE_CALLS_}
  {$IFDEF _DBXCB_}
  if Assigned(TSqlConnectionOdbc3(fOwnerDbxConnection).fDbxTraceCallbackEven) then
    TSqlConnectionOdbc3(fOwnerDbxConnection).DbxCallBackSendMsg(cTDBXTraceFlags_Execute, 'ISQLCommand.Execute: ' + fSQL);
  {$ENDIF}
  Result := DoExecute(vCursor25, {bUseUnicodeOdbc:}TSqlDriverOdbc3(fOwnerDbxDriver).fIsUnicodeOdbcApi);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCommandOdbc3.execute', e);  raise; end; end;
    finally LogExitProc('TSqlCommandOdbc3.execute', ['Result =', Result, 'CursorPtr =', Pointer(Cursor)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCommandOdbc3.executeImmediate;//(SQL: PWideChar; var Cursor: ISQLCursor30): SQLResult;
var
  vCursor25: ISQLCursor25 absolute Cursor;
  S: AnsiString;
begin
  // unicode:
  //
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSqlCommandOdbc3.ExecuteImmediate', ['SQL =', PWideChar(SQL)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  {$IFDEF _DBXCB_}
  if Assigned(TSqlConnectionOdbc3(fOwnerDbxConnection).fDbxTraceCallbackEven) then
    TSqlConnectionOdbc3(fOwnerDbxConnection).DbxCallBackSendMsg(cTDBXTraceFlags_Execute, 'ISQLCommand.ExecuteImmediate: ' + AnsiString(WideString(SQL)));
  {$ENDIF}
  if SQL <> nil then
  begin
    if TSqlDriverOdbc3(fOwnerDbxDriver).fIsUnicodeOdbcApi and (fStoredProc <> 1) then
    begin
      Result := DoExecuteImmediate(PAnsiChar(SQL), vCursor25, {bUseUnicodeOdbc:} True)
    end
    else
    begin
      S := AnsiString(WideString(SQL));
      Result := DoExecuteImmediate(PAnsiChar(S), vCursor25, {bUseUnicodeOdbc:} False);
    end;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCommandOdbc3.ExecuteImmediate', e);  raise; end; end;
    finally LogExitProc('TSqlCommandOdbc3.ExecuteImmediate', ['Result =', Result, 'CursorPtr =', Pointer(Cursor)]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCommandOdbc3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  Result := TSqlConnectionOdbc3(fOwnerDbxConnection).getErrorMessage(Error);
end;

function TSqlCommandOdbc3.getErrorMessageLen;//(out ErrorLen: SmallInt): SQLResult;
begin
  Result := TSqlConnectionOdbc3(fOwnerDbxConnection).getErrorMessageLen(ErrorLen);
end;

function TSqlCommandOdbc3.getNextCursor;//(var Cursor: ISQLCursor30): SQLResult;
var
  vCursor25: ISQLCursor25 absolute Cursor;
begin
  Result := inherited getNextCursor(vCursor25);
end;

function TSqlCommandOdbc3.GetOption;//(eSqlCommandOption: TSQLCommandOption; PropValue: Pointer;
//  MaxLength: Smallint; out iLength: SmallInt): SQLResult;
var
  xeSqlCommandOption: TXSQLCommandOption absolute eSqlCommandOption;
  sOptionValue: AnsiString;
  iMaxChars: Integer;
begin
  {$IFDEF _TRACE_CALLS_}
    Result := DBXERR_NONE;
    try try {$R+}
    LogEnterProc('TSqlCommandOdbc3.GetOption', ['eSqlCommandOption =', cSQLCommandOption[xeSqlCommandOption], 'PropValuePtr =', PropValue, 'MaxLength =', MaxLength]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
    iLength := 0;
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (xeSqlCommandOption in cXSQLCommandOptionStringTypes) and (PropValue <> nil) and (MaxLength >= SizeOf(WideChar)) then
  begin
    iMaxChars := MaxLength div SizeOf(WideChar) + 1;
    SetLength(sOptionValue, iMaxChars);
    FillChar(sOptionValue[1], iMaxChars, 0);
    Result := inherited GetOption(eSqlCommandOption, PAnsiChar(sOptionValue), iMaxChars, iLength);
    if Result = DBXERR_NONE then
    begin
      SetLength(sOptionValue, System.AnsiStrings.StrLen(PAnsiChar(sOptionValue)));
      iLength := StringToWideChar(sOptionValue, PWideChar(PropValue), iMaxChars) * SizeOf(WideChar);
    end;
  end
  else
    Result := inherited GetOption(eSqlCommandOption, PropValue, MaxLength, iLength);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCommandOdbc3.GetOption', e);  raise; end; end;
    finally LogExitProc('TSqlCommandOdbc3.GetOption', ['Result =', Result, 'Length =', iLength]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCommandOdbc3.SetOption;//(eSqlCommandOption: TSQLCommandOption; ulValue: Integer): SQLResult;
var
  xeSqlCommandOption: TXSQLCommandOption absolute eSqlCommandOption;
  sOptionValue: AnsiString;
  {$IFDEF _TRACE_CALLS_}
  function ulValue2Str: AnsiString;
  begin
    case xeSqlCommandOption of
      xeCommBlockRead:
        Result := AnsiString(BoolToStr(Boolean(ulValue)));
      xeCommCursorName:
        Result := AnsiString(WideString(PWideChar(ulValue)));
      xeCommStoredProc:
        Result := AnsiString(BoolToStr(Boolean(ulValue)));
      xeCommPackageName:
        Result := AnsiString(WideString(PWideChar(ulValue)));
      xeCommTrimChar:
        Result := AnsiString(BoolToStr(Boolean(ulValue)));
      xeCommCatalogName:
        Result := AnsiString(WideString(PWideChar(ulValue)));
      xeCommSchemaName:
        Result := AnsiString(WideString(PWideChar(ulValue)));
      else
        Result := AnsiString(IntToStr(ulValue));
    end;
  end;
  {$ENDIF _TRACE_CALLS_}
begin
  {$IFDEF _TRACE_CALLS_}
    Result := DBXERR_NONE;
    try try {$R+}
    LogEnterProc('TSqlCommandOdbc3.SetOption', ['eSqlCommandOption =', cSQLCommandOption[xeSqlCommandOption], 'ulValue =', ulValue2Str()]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (xeSqlCommandOption in cXSQLCommandOptionStringTypes) and (ulValue <> 0) then
  begin
    sOptionValue := AnsiString(WideString(PWideChar(ulValue)));
    Result := inherited SetOption(eSqlCommandOption, Integer(PAnsiChar(sOptionValue)));
  end
  else
    Result := inherited SetOption(eSqlCommandOption, ulValue);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCommandOdbc3.SetOption', e);  raise; end; end;
    finally LogExitProc('TSqlCommandOdbc3.SetOption', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorOdbc3 }

function TSqlCursorOdbc3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  Result := TSqlConnectionOdbc3(fOwnerDbxConnection).getErrorMessage(Error);
end;

function TSqlCursorOdbc3.getErrorMessageLen;//(out ErrorLen: Smallint): SQLResult;
begin
  Result := TSqlConnectionOdbc3(fOwnerDbxConnection).getErrorMessageLen(ErrorLen);
end;

function TSqlCursorOdbc3.getColumnNameLength;//(ColumnNumber: WORD; var pLen: Word): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorOdbc3.getColumnNameLength', ['ColumnNumber =', ColumnNumber]); {$ENDIF _TRACE_CALLS_}
  pLen := min(Length(WideString(TOdbcBindCol(fOdbcBindList[ColumnNumber-1]).fColName))+1, SizeOf(DBINAME128)-1); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorOdbc3.getColumnNameLength', e);  raise; end; end;
    finally LogExitProc('TSqlCursorOdbc3.getColumnNameLength', ['pLen =', pLen]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorOdbc3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorOdbc3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  StringToWideChar(TOdbcBindCol(fOdbcBindList[ColumnNumber-1]).fColName, pColumnName, SizeOf(DBINAME128) - 1);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorOdbc3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorOdbc3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorOdbc3.getInt64;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorOdbc3.getInt64', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Value = nil then
  begin
    Result := DBXERR_INVALIDPARAM;
    Exit;
  end;
  with TOdbcBindCol(fOdbcBindList[ColumnNumber-1]) do
  begin
    if fOdbcLateBound then
      FetchLateBoundData(ColumnNumber);
    IsBlank := (fColValueSizePtr^ = OdbcApi.SQL_NULL_DATA) or
      (fColValueSizePtr^ = OdbcApi.SQL_NO_TOTAL);
    if IsBlank then
      Int64(Value^) := 0
    else
      Int64(Value^) := fOdbcHostVarAddress.ptrSqlBigInt^;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorOdbc3.getInt64', e);  raise; end; end;
    finally LogExitProc('TSqlCursorOdbc3.getInt64', ['Value =', Integer(Value^), 'IsBlank =', IsBlank]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorOdbc3.getWideString;//(ColumnNumber: Word; Value: PWideChar; var IsBlank: LongBool): SQLResult;
var
  vColValueSize, vColSizeBuff: SqlInteger;
  RCh: PAnsiChar;
  aOdbcBindCol: TOdbcBindCol;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}
    if Assigned(Value) then
      Value^ := cNullWideChar;
    IsBlank := True;
    try try {$R+}
    LogEnterProc('TSqlCursorOdbc3.getWideString', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  if Value = nil then
  begin
    Result := DBXERR_INVALIDPARAM;
    Exit;
  end;
  aOdbcBindCol := TOdbcBindCol(fOdbcBindList[ColumnNumber-1]);
  with aOdbcBindCol do
  begin
    if fOdbcLateBound then
    begin
      if not fIsBuffer then
        FetchLateBoundData(ColumnNumber)
      else
        FetchLongData(ColumnNumber);
    end;

    // check buffer overflow (for bad odbc drivers).
    vColValueSize := fColValueSizePtr^; // buffer length in  bytes
    IsBlank := (vColValueSize = OdbcApi.SQL_NULL_DATA) or
      (vColValueSize = OdbcApi.SQL_NO_TOTAL);

    vColSizeBuff := fColSize * SizeOf(WideChar);
    if (not IsBlank) and (vColValueSize > 0) then
    begin
      if vColValueSize > vColSizeBuff then
        vColValueSize := vColSizeBuff;
    end
    else
    begin
      vColValueSize := 0;
    end;

    if IsBlank then
    begin
      Value^ := cNullWideChar;
      if TSqlConnectionOdbc3(fOwnerDbxConnection).fConnectionOptions[coNullStrAsEmpty] = osOn then
        IsBlank := False;
    end
    else
    begin
      if vColValueSize = 0 then
      begin
        Value^ := cNullWideChar
      end
      else
      {$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
      //
      // QC: 58473:
      // Option TrimChar shall ignore because of error in Delphi for TWideStringFiled with FixedSize.
      // Delphi not will not send important information about field type (fldstFIXED) when is called method ".setParameter".
      // See: SqlExpr.pas: procedure D2006UP: SetQueryProcParams.
      //
      {$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}
      {begin: trim char:}
      if TSqlCommandOdbc3(fOwnerCommand).fTrimChar and (fDbxSubType and fldstFIXED <> 0) then
      begin
        RCh := PAnsiChar(NativeUInt(fOdbcHostVarAddress.ptrAnsiChar) + NativeUInt(vColValueSize - SizeOf(WideChar)));
        // debug: PAnsiChar(NativeUInt(aOdbcBindCol.fOdbcHostVarAddress.ptrAnsiChar) + NativeUInt(vColValueSize - SizeOf(WideChar)))
        // debug: aOdbcBindCol.fOdbcHostVarAddress.ptrWideChar
        while (RCh >= fOdbcHostVarAddress.ptrAnsiChar) and (PWideChar(RCh)^ = WideChar(' ')) do
          Dec(RCh, SizeOf(WideChar));
        vColValueSize := SqlUInteger(NativeUInt(RCh) + SizeOf(WideChar) - NativeUInt(fOdbcHostVarAddress.ptrAnsiChar));
        if vColValueSize > 0 then
        begin
          Move(fOdbcHostVarAddress.ptrAnsiChar^, Value^, vColValueSize);
          vColValueSize := vColValueSize div SizeOf(WideChar);
          Value[vColValueSize] := cNullWideChar;
        end
        else
          Value^ := cNullWideChar;
      end
      else
      {end: trim char.}
      begin
        Move(fOdbcHostVarAddress.ptrWideChar^, PWideChar(Value)^, vColValueSize);

        Inc(PAnsiChar(Value), vColValueSize);
        vColValueSize := vColValueSize div SizeOf(WideChar);

        if (fDbxSubType and fldstFIXED <> 0) and (vColValueSize < Integer(fColSize)) then
        begin
          // we shall add lacking spaces if driver their cuts itself
          while vColValueSize <= Integer(fColSize) do
          begin
            Value^ := WideChar(' ');
            Inc(PAnsiChar(Value), SizeOf(WideChar));
            Inc(vColValueSize, SizeOf(WideChar));
          end
        end;

        Value^ := cNullWideChar;
      end;
    end;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorOdbc3.getWideString', e);  raise; end; end;
    finally LogExitProc('TSqlCursorOdbc3.getWideString', ['Value =', PAnsiChar(Value), 'IsBlank =', IsBlank]); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSQLMetaDataOdbc3 }

function TSQLMetaDataOdbc3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getErrorMessage', ['ErrorPtr =', Pointer(Error)]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
    StringsToWStr(fMetaDataErrorLines, Error);
  fMetaDataErrorLines.Clear;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getErrorMessage', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getErrorMessageLen;//(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSQLMetaDataOdbc3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fMetaDataErrorLines) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getErrorMessageLen', ['Result =', Result, 'ErrorLen =', ErrorLen]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.GetOption;//(eDOption: TSQLMetaDataOption; PropValue: Pointer; MaxLength: Smallint; out iLength: Smallint): SQLResult;
var
  xeDOption: TXSQLMetaDataOption absolute eDOption;
  sOptionValue: AnsiString;
  iMaxChars: Integer;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.GetOption', ['MaxLength =', MaxLength]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (xeDOption in cXSQLMetaDataOptionStringTypes) and (PropValue <> nil) and (MaxLength >= SizeOf(WideChar)) then
  begin
    iMaxChars := MaxLength div SizeOf(WideChar) + 1;
    SetLength(sOptionValue, iMaxChars);
    FillChar(sOptionValue[1], iMaxChars, 0);
    Result := inherited GetOption(eDOption, PAnsiChar(sOptionValue), iMaxChars, iLength);
    if Result = DBXERR_NONE then
    begin
      SetLength(sOptionValue, System.AnsiStrings.StrLen(PAnsiChar(sOptionValue)));
      iLength := StringToWideChar(sOptionValue, PWideChar(PropValue), iMaxChars) * SizeOf(WideChar);
    end;
  end
  else
    Result := inherited GetOption(eDOption, PropValue, MaxLength, iLength);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.GetOption', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.GetOption', ['Result =', Result, 'Length =', iLength]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.SetOption;//(eDOption: TSQLMetaDataOption; PropValue: Integer): SQLResult;
var
  xeDOption: TXSQLMetaDataOption absolute eDOption;
  sOptionValue: AnsiString;
  {$IFDEF _TRACE_CALLS_}
  function PropValue2Str: AnsiString;
  begin
    case xeDOption of
      xeMetaCatalogName,
      xeMetaSchemaName,
      xeMetaDatabaseName,
      xeMetaPackageName:
        Result := AnsiString(WideString(PWideChar(PropValue)));
      else
        Result := AnsiString(IntToStr(Integer(PropValue)));
    end;
  end;
  {$ENDIF _TRACE_CALLS_}
begin
  {$IFDEF _TRACE_CALLS_}
    Result := DBXERR_NONE;
    try try {$R+}
    LogEnterProc('TSQLMetaDataOdbc3.SetOption', ['eDOption =', cSQLMetaDataOption[xeDOption], 'PropValue =', PropValue2Str()]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (xeDOption in cXSQLMetaDataOptionStringTypes) and (PropValue <> 0) then
  begin
    sOptionValue := AnsiString(WideString(PWideChar(PropValue)));
    Result := inherited SetOption(eDOption, Integer(PAnsiChar(sOptionValue)));
  end
  else
    Result := inherited SetOption(eDOption, PropValue);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.SetOption', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.SetOption', ['Result =', Result]); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getObjectList;//(eObjType: TSQLObjectType; out Cursor: ISQLCursor30): SQLResult;
begin
  Result := DBXERR_NOTSUPPORTED;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSQLMetaDataOdbc3.getObjectList');{$ENDIF _TRACE_CALLS_}
  Pointer(Cursor) := nil;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getObjectList', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getObjectList'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getTables;//(TableName: PWideChar; TableType: Longword; out Cursor: ISQLCursor30): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getTables',
    ['TableName =', TableName, 'TableType =', TableType]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  Result := DoGetTables({Cat}nil, {Schema}nil, PAnsiChar(TableName), TableType, Pointer(Cursor), {Unicode}True);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getTables', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getTables'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getProcedures;//(ProcedureName: PWideChar; ProcType: Longword; out Cursor: ISQLCursor30): SQLResult;
var
  vCursor: ISQLCursor25 absolute Cursor;
  sOptionValue: AnsiString;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getProcedures',
    ['ProcedureName =', ProcedureName, 'ProcType =', ProcType]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (ProcedureName = nil) or (Trim(WideString(ProcedureName)) = '') then
    Result := inherited getProcedures(nil, ProcType, vCursor)
  else
  begin
    sOptionValue := AnsiString(WideString(PWideChar(ProcedureName)));
    Result := inherited getProcedures(PAnsiChar(sOptionValue), ProcType, vCursor)
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getProcedures', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getProcedures'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getColumns;//(TableName, ColumnName: PWideChar; ColType: Longword; out Cursor: ISQLCursor30): SQLResult;
var
  vCursor: ISQLCursor25 absolute Cursor;
  sTableName, sColumnName: AnsiString;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getColumns',
    ['TableName =', TableName, 'ColumnName =', ColumnName, 'ColType =', ColType]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  //
  if (TableName <> nil) then
    sTableName := AnsiString(WideString(TableName));
  if (ColumnName <> nil) then
    sColumnName := AnsiString(WideString(ColumnName));
  Result := inherited getColumns(PAnsiChar(sTableName), PAnsiChar(sColumnName), ColType, vCursor)
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getColumns', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getColumns'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getIndices;//(TableName: PWideChar; IndexType: Longword; out Cursor: ISQLCursor30): SQLResult;
var
  vCursor: ISQLCursor25 absolute Cursor;
  sTableName: AnsiString;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getIndices',
    ['TableName =', TableName, 'IndexType =', IndexType]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  if (TableName <> nil) then
    sTableName := AnsiString(WideString(TableName));
  Result := inherited getIndices(PAnsiChar(sTableName), IndexType, vCursor)
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getIndices', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getIndices'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSQLMetaDataOdbc3.getProcedureParams;//(ProcName, ParamName: PWideChar; out Cursor: ISQLCursor30): SQLResult;
var
  vCursor: ISQLCursor25 absolute Cursor;
  sProcName, sParamName: AnsiString;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try {$R+} LogEnterProc('TSQLMetaDataOdbc3.getProcedureParams',
    ['ProcName =', ProcName, 'ParamName =', ParamName]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
  {$ENDIF _TRACE_CALLS_}
  // ansi:
  if (ProcName <> nil) then
    sProcName := AnsiString(WideString(ProcName));
  if (ParamName <> nil) then
    sParamName := AnsiString(WideString(ParamName));
  Result := inherited getProcedureParams(PAnsiChar(sProcName), PAnsiChar(sParamName), vCursor)
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSQLMetaDataOdbc3.getProcedureParams', e);  raise; end; end;
    finally LogExitProc('TSQLMetaDataOdbc3.getProcedureParams'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataTables3 }

function TSqlCursorMetaDataTables3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCursorMetaDataTables3.getErrorMessage'); {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fSqlCursorErrorMsg, Error);
    fSqlCursorErrorMsg.Clear;
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataTables3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataTables3.getErrorMessage'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataTables3.getErrorMessageLen;//(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataTables3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fSqlCursorErrorMsg) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataTables3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataTables3.getErrorMessageLen'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataTables3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataTables3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(pColumnName) and GetPhysColumnNumber(ColumnNumber) then
    //StrBuffCopy(fColumnNames[ColumnNumber], pColumnName, SizeOf(DBINAME32) - 1)
    // convert ansi name to wide
    StringToWStr(PAnsiChar(fColumnNames[ColumnNumber]), pColumnName)
  else
  begin
    if Assigned(pColumnName) then
      pColumnName^ := cNullAnsiChar;
    Result := DBXERR_INVALIDPARAM;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataTables3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataTables3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataColumns3 }

function TSqlCursorMetaDataColumns3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataColumns3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(pColumnName) and GetPhysColumnNumber(ColumnNumber) then
    //StrBuffCopy(fColumnNames[ColumnNumber], pColumnName, SizeOf(DBINAME32) - 1)
    // convert ansi name to wide
    StringToWStr(PAnsiChar(fColumnNames[ColumnNumber]), pColumnName)
  else
  begin
    if Assigned(pColumnName) then
      pColumnName^ := cNullAnsiChar;
    Result := DBXERR_INVALIDPARAM;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumns3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumns3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataColumns3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCursorMetaDataColumns3.getErrorMessage'); {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fSqlCursorErrorMsg, Error);
    fSqlCursorErrorMsg.Clear;
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumns3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumns3.getErrorMessage'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataColumns3.getErrorMessageLen;//(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataColumns3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fSqlCursorErrorMsg) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumns3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumns3.getErrorMessageLen'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataIndexes3 }

function TSqlCursorMetaDataIndexes3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataIndexes3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(pColumnName) and GetPhysColumnNumber(ColumnNumber) then
    //StrBuffCopy(fColumnNames[ColumnNumber], pColumnName, SizeOf(DBINAME32) - 1)
    // convert ansi name to wide
    StringToWStr(PAnsiChar(fColumnNames[ColumnNumber]), pColumnName)
  else
  begin
    if Assigned(pColumnName) then
      pColumnName^ := cNullAnsiChar;
    Result := DBXERR_INVALIDPARAM;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexes3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexes3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataIndexes3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCursorMetaDataIndexes3.getErrorMessage'); {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fSqlCursorErrorMsg, Error);
    fSqlCursorErrorMsg.Clear;
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexes3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexes3.getErrorMessage'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataIndexes3.getErrorMessageLen(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataIndexes3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fSqlCursorErrorMsg) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexes3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexes3.getErrorMessageLen'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataProcedures3 }

function TSqlCursorMetaDataProcedures3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataIndexes3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(pColumnName) and GetPhysColumnNumber(ColumnNumber) then
    //StrBuffCopy(fColumnNames[ColumnNumber], pColumnName, SizeOf(DBINAME32) - 1)
    // convert ansi name to wide
    StringToWStr(PAnsiChar(fColumnNames[ColumnNumber]), pColumnName)
  else
  begin
    if Assigned(pColumnName) then
      pColumnName^ := cNullAnsiChar;
    Result := DBXERR_INVALIDPARAM;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedures3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedures3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataProcedures3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCursorMetaDataProcedures3.getErrorMessage'); {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fSqlCursorErrorMsg, Error);
    fSqlCursorErrorMsg.Clear;
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedures3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedures3.getErrorMessage'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataProcedures3.getErrorMessageLen(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataProcedures3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fSqlCursorErrorMsg) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedures3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedures3.getErrorMessageLen'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataProcedureParams3 }

function TSqlCursorMetaDataProcedureParams3.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataProcedureParams3.getColumnName', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(pColumnName) and GetPhysColumnNumber(ColumnNumber) then
    //StrBuffCopy(fColumnNames[ColumnNumber], pColumnName, SizeOf(DBINAME32) - 1)
    // convert ansi name to wide
    StringToWStr(PAnsiChar(fColumnNames[ColumnNumber]), pColumnName)
  else
  begin
    if Assigned(pColumnName) then
      pColumnName^ := cNullAnsiChar;
    Result := DBXERR_INVALIDPARAM;
  end;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedureParams3.getColumnName', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedureParams3.getColumnName'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataProcedureParams3.getErrorMessage(Error: PWideChar): SQLResult;
begin
  {$IFDEF _TRACE_CALLS_} Result := DBXERR_NONE; try try LogEnterProc('TSqlCursorMetaDataProcedureParams3.getErrorMessage'); {$ENDIF _TRACE_CALLS_}
  if Error <> nil then
  begin
    StringsToWStr(fSqlCursorErrorMsg, Error);
    fSqlCursorErrorMsg.Clear;
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedureParams3.getErrorMessage', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedureParams3.getErrorMessage'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataProcedureParams3.getErrorMessageLen(out ErrorLen: Smallint): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataProcedureParams3.getErrorMessageLen'); {$ENDIF _TRACE_CALLS_}
  ErrorLen := WideStringLengthFromStrings(fSqlCursorErrorMsg) + 1;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataProcedureParams3.getErrorMessageLen', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataProcedureParams3.getErrorMessageLen'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{@dbx34:}

{ TDbxCommandParser }

class function TDbxCommandParser.IsDbxCommand(ADbxCmdText: WideString): Boolean;
begin
  Result := (Length(ADbxCmdText) >  Length(DBX4_CMD_PREFIX))
    and (WStrLComp(PWideChar(ADbxCmdText), PWideChar(WideString(DBX4_CMD_PREFIX)), Length(DBX4_CMD_PREFIX)) = 0);
end;

class function TDbxCommandParser.IsDbxCommand(ADbxCmdText: PWideChar): Boolean;
begin
  Result := WStrLComp(ADbxCmdText, PWideChar(WideString(DBX4_CMD_PREFIX)), Length(DBX4_CMD_PREFIX)) = 0;
end;

class function TDbxCommandParser.IsDbxCommand(ADbxCmdText: PAnsiChar): Boolean;
begin
  Result := System.AnsiStrings.StrLComp(ADbxCmdText, PAnsiChar(AnsiString(DBX4_CMD_PREFIX)), Length(DBX4_CMD_PREFIX)) = 0;
end;

class function TDbxCommandParser.IsDbxCommand(ADbxCmdText: Pointer; AUnicode: Boolean): Boolean;
begin
  if AUnicode then
    Result := WStrLComp(PWideChar(ADbxCmdText), PWideChar(WideString(DBX4_CMD_PREFIX)), Length(DBX4_CMD_PREFIX)) = 0
  else
    Result := System.AnsiStrings.StrLComp(PAnsiChar(ADbxCmdText), PAnsiChar(AnsiString(DBX4_CMD_PREFIX)), Length(DBX4_CMD_PREFIX)) = 0;
end;

constructor TDbxCommandParser.Create;//(ADbxCmdText: WideString; CheckIsDbxCommand: Boolean = True);
var
  i, iNext, iParamCount, iParamCountBuffLen: Integer;
  sCmd, sParName, sParValue: WideString;
begin
  inherited Create;
  //
  // parse command:
  //
  if CheckIsDbxCommand and (not IsDbxCommand(ADbxCmdText)) then
    Exit;
  i := PosChar(WideChar(DBX4_CMD_PARAM_DELIMITER), ADbxCmdText);
  if i > Length(DBX4_CMD_PREFIX) then
  begin
    sCmd := Trim(Copy(ADbxCmdText, Length(DBX4_CMD_PREFIX)+1, i-Length(DBX4_CMD_PREFIX)-1));
    if sCmd = '' then
      Exit;
    fDbxCommand := string(sCmd);
    sCmd := TrimLeft(Copy(ADbxCmdText, i+1, Length(ADbxCmdText)-i));
    if Length(sCmd) < 2 then
      Exit;
    iNext := PosChar(WideChar(DBX4_CMD_PARAM_DELIMITER), sCmd);
    if iNext <= 0 then
      Exit;
    iParamCount := 0;
    iParamCountBuffLen := 8;
    SetLength(fParamNames, iParamCountBuffLen);
    SetLength(fParamValues, iParamCountBuffLen);
    i := 1;
    repeat
      sParName := Trim(Copy(sCmd, i, iNext - i));
      i := iNext + 1;
      //iNext := PosEx(DBX4_CMD_PARAM_DELIMITER, sCmd, i);
      iNext := PosCharEx(WideChar(DBX4_CMD_PARAM_DELIMITER), sCmd, i);
      if iNext >= i then
        sParValue := Copy(sCmd, i, iNext - i)
      else
        sParValue := Copy(sCmd, i, Length(sCmd) - i + 1);
      //
      if iParamCount >= iParamCountBuffLen then
      begin
        iParamCountBuffLen := iParamCount + 8;
        SetLength(fParamNames, iParamCountBuffLen);
        SetLength(fParamValues, iParamCountBuffLen);
      end;
      //
      fParamNames[iParamCount] := AnsiString(LowerCase(sParName));
      fParamValues[iParamCount] := sParValue;
      inc(iParamCount);
      //
      if iNext >= i then
      begin
        i := iNext + 1;
        //iNext := PosEx(DBX4_CMD_PARAM_DELIMITER, sCmd, i);
        iNext := PosCharEx(WideChar(DBX4_CMD_PARAM_DELIMITER), sCmd, i);
      end;
    until iNext < i;
    {if iParamCount <> iParamCountBuffLen then
    begin
      SetLength(fParamNames, iParamCount);
      SetLength(fParamValues, iParamCount);
    end;}
    fParamCount := iParamCount;
  end
  else
  begin
    sCmd := Trim(Copy(ADbxCmdText, Length(DBX4_CMD_PREFIX)+1, Length(ADbxCmdText)-Length(DBX4_CMD_PREFIX)));
    fDbxCommand := string(sCmd);
  end;
end;

function TDbxCommandParser.GetParam(AName: AnsiString): WideString;
var
  i: Integer;
begin
  Result := '';
  if fParamCount = 0 then
    Exit;
  AName := LowerCase(AName);
  for i := fNextParamIndex to fParamCount-1 do
  begin
    if fParamNames[i] = AName then
    begin
      fNextParamIndex := i + 1;
      Result := fParamValues[i];
      Exit;
    end;
  end;
  for i := 0 to fNextParamIndex-1 do
  begin
    if fParamNames[i] = AName then
    begin
      fNextParamIndex := i + 1;
      Result := fParamValues[i];
      Exit;
    end;
  end;
  fNextParamIndex := 0;
end;

{ TSqlCursorMetaDataTablesDbx34 }

{$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
//DBXMetaDataReader.pas: class function TDBXMetaDataCollectionColumns.CreateTablesColumns
//DBXMetaDataReader.pas: class function TDBXMetaDataCollectionColumns.CreateTablesColumns: TDBXValueTypeArray;
//
//  Columns[0] := CreateValueType(TDBXTablesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
//  Columns[1] := CreateValueType(TDBXTablesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
//  Columns[2] := CreateValueType(TDBXTablesColumns.TableName, STableName, TDBXDataTypes.WideStringType);
//  Columns[3] := CreateValueType(TDBXTablesColumns.TableType, STableType, TDBXDataTypes.WideStringType);
{$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}

constructor TSqlCursorMetaDataTablesDbx34.Create;//(AConnection: TSqlConnectionOdbc3);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataTablesDbx34.Create'); {$ENDIF _TRACE_CALLS_}
  inherited Create(AConnection, {SupportWideString}True, AConnection.MetaDataReader);

  {define schema: DBXMetaDataNames.pas:TDBXTablesColumns}

  //
  // remap cursor columns:
  //

  fCursorColmnCount := 5;
  SetLength(fCursorColmnIndxs, fColumnCount);

  remap(0, 1, 'CatalogName', fldWIDESTRING, 1);           // CATALOG_NAME       -> RECNO
  remap(1, 2, 'SchemaName', fldWIDESTRING, 1);            // SCHEMA_NAME        -> CATALOG_NAME
  remap(2, 3, 'TableName', fldWIDESTRING, 1);             // TABLE_NAME         -> SCHEMA_NAME
  remap(3, 0, 'TableType', fldWIDESTRING, 16);            // NULL                  base column is not sring. GetPhysColumnWideString returned #0
  remap(4, 4, 'Remarks', fldWIDESTRING, 1);               // REMARKS            -> REMARKS

  {define schema.}

  fMergeNames := True; // Return table_name as merged catalog.schema.table for view FullName in Delphi IDE

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataTablesDbx34.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataTablesDbx34.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

procedure TSqlCursorMetaDataTablesDbx34.GetPhysColumnWideString;//(PhysColumnNumber: Word; Value: PWideChar);
var
  S: WideString;
begin
  if Assigned(fMetaTableCurrent) and (PhysColumnNumber = 4) then
  begin
    case fMetaTableCurrent.fTableType of
      eSQLTable:
        S := 'TABLE';
      eSQLView:
        S := 'VIEW';
      eSQLSynonym:
        S := 'SYNONYM';
      eSQLSystemTable:
        S := 'SYSTEM TABLE';
      eSQLSystemView:
        S := 'SYSTEM VIEW';
      else
        S := '';
    end;
    StrBuffCopy(S, Value, fColumnPhLen[PhysColumnNumber]);
  end
  else
    inherited GetPhysColumnWideString(PhysColumnNumber, Value);
end;

{ TSqlCursorMetaDataEmpty }

constructor TSqlCursorMetaDataEmpty.Create(AConnection: TSqlConnectionOdbc3);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataEmpty.Create'); {$ENDIF _TRACE_CALLS_}
  inherited Create({SupportWideString}True, AConnection.MetaDataReader);
  fColumnCount := 0;
  SetLength(fColumnTypes, 0);
  SetLength(fColumnNames, 0);
  SetLength(fColumnPhLen, 0);
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataEmpty.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataEmpty.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

constructor TSqlCursorMetaDataEmpty.Create(AConnection: TSqlConnectionOdbc3;
  AColNames: array of AnsiString; AColTypes: array of Word);
var
  i: Integer;
begin
  fColumnCount := Length(AColNames);
  i := Length(AColTypes);
  if i <  fColumnCount then
    fColumnCount := i;

  {define schema:}

  if fColumnCount > 0 then
  begin
    {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataEmpty.Create', ['ColumnCount =', fColumnCount]); {$ENDIF _TRACE_CALLS_}
    inherited Create({SupportWideString}True, AConnection.MetaDataReader);

    fColumnCount := 14;

    SetLength(fColumnNames, fColumnCount);
    SetLength(fColumnTypes, fColumnCount);
    SetLength(fColumnPhLen, fColumnCount);

    for i := 0 to fColumnCount - 1 do
    begin
      fColumnNames[i] := AColNames[i];
      fColumnTypes[i] := AColTypes[i];
    end;
    {$IFDEF _TRACE_CALLS_}
      except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataEmpty.Create', e);  raise; end; end;
      finally LogExitProc('TSqlCursorMetaDataEmpty.Create'); end;
    {$ENDIF _TRACE_CALLS_}
  end
  else
  begin
    Create(AConnection, 32);
  end;

  {define schema.}

end;

constructor TSqlCursorMetaDataEmpty.Create(AConnection: TSqlConnectionOdbc3; AColCount: Integer);
var
  i: Integer;
begin
  fColumnCount := AColCount;
  if (fColumnCount < 0) or (fColumnCount > 512) then
    fColumnCount := 0;
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataEmpty.Create', ['ColumnCount =', fColumnCount]); {$ENDIF _TRACE_CALLS_}
  inherited Create({SupportWideString}True, AConnection.MetaDataReader);

  {define schema:}

  if fColumnCount > 0 then
  begin
    SetLength(fColumnNames, fColumnCount);
    SetLength(fColumnTypes, fColumnCount);
    SetLength(fColumnPhLen, fColumnCount);
    for i := 0 to fColumnCount - 1 do
    begin
      fColumnNames[i] := AnsiString('NAME_' + IntToStr(i+1));
      fColumnTypes[i] := fldWIDESTRING;
      fColumnPhLen[i] := 2;
    end;
  end;

  {define schema.}

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataEmpty.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataEmpty.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataEmpty.getBcd;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getBlob;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool;
//  iLength: Longword): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getBlobSize;//(ColumnNumber: Word; var iLength: Longword;
//  var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getBytes;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnCount;//(var pColumns: Word): SQLResult;
begin
  if fColumnCount > 0 then
    pColumns := fColumnCount
  else
    pColumns := 32;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnNameLength;//(ColumnNumber: Word; var pLen: Word): SQLResult;
begin
  if (fColumnCount > 0) and (ColumnNumber > 0) and (ColumnNumber <= fColumnCount) then
    pLen := min(max(Length(fColumnNames[ColumnNumber-1])+1, 2), SizeOf(DBINAME128)-1)
  else
    pLen := Length('$NAME_') + Length(IntToStr(ColumnNumber)) + 1 + 1;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnName;//(ColumnNumber: Word; pColumnName: PWideChar): SQLResult;
var
  ws: WideString;
begin
  if Assigned(pColumnName) then
  begin
    if (fColumnCount > 0) and (ColumnNumber > 0) and (ColumnNumber <= fColumnCount) then
      ws := WideString(fColumnNames[ColumnNumber-1])
    else
      ws := WideString('$NAME_' + IntToStr(ColumnNumber) + #1);
    //
    StrBuffCopy(ws, pColumnName, SizeOf(DBINAME128)-1);
    //
    Result := DBXERR_NONE;
  end
  else
    Result := DBXERR_INVALIDPARAM;
end;

function TSqlCursorMetaDataEmpty.getColumnType;//(ColumnNumber: Word; var puType: Word; var puSubType: Word): SQLResult;
begin
  if (fColumnCount > 0) and (ColumnNumber > 0) and (ColumnNumber <= fColumnCount) then
    puType := fColumnTypes[ColumnNumber-1]
  else
    puType := fldWIDESTRING;
  puSubType := 0;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getDate;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getDouble;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getLong;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnLength;//(ColumnNumber: Word; var pLength: Longword): SQLResult;
begin
  { for string types: quantity of symbols with null terminator #0 }
  pLength := 1+1; // == physical size + 1 for #0 terminator
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnPrecision;//(ColumnNumber: Word; var piPrecision: Smallint): SQLResult;
begin
  piPrecision := 1;
  //if (fColumnCount > 0) and (ColumnNumber > 0) and (ColumnNumber <= fColumnCount) then
  //begin
  //  if IsColumnStringType(ColumnNumber) then
  //    { == physical size ( as defined ib db: char(3) => physical size == 3 ) }
  //    piPrecision := 1;
  //end;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getColumnScale;//( ColumnNumber: Word; var piScale: Smallint): SQLResult;
var
  pLength: Integer;
begin
  // == precission
  if (fColumnCount > 0) and (ColumnNumber > 0) and (ColumnNumber <= fColumnCount) then
  begin
    if GetPhysColumnNumber(ColumnNumber) and IsPhysColumnStringType(ColumnNumber) then
    begin
      pLength := fColumnPhLen[ColumnNumber];
      if pLength <= 0 then
        pLength := 1;
      if pLength < High(Smallint) then
        piScale :=  Smallint(pLength)
      else
        piScale := High(Smallint);
    end
    else
      piScale := 0;
  end
  else
    piScale := 1;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.isNullable;//(ColumnNumber: Word; var Nullable: LongBool): SQLResult;
begin
  Nullable := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getTime;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getTimeStamp;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getShort;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  if Assigned(Value) then
    Smallint(Value^) := 0;
  IsBlank := True;
  Result := DBXERR_NONE;
end;

function TSqlCursorMetaDataEmpty.getWideString;//(ColumnNumber: Word; Value: PWideChar; var IsBlank: LongBool): SQLResult;
begin
  IsBlank := Value = nil;
  if not IsBlank then
  begin
    IsBlank := True;
    Value^ := cNullWideChar;
  end;
  Result := DBXERR_NONE;
end;

{ TSqlCursorMetaDataColumnsDbx34 }

{$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
//DBXMetaDataNames.pas: class: TDBXColumnsColumns
//DBXMetaDataReader.pas: class function TDBXMetaDataCollectionColumns.CreateDataTypesColumns: TDBXValueTypeArray;
//
//  Columns[0] := CreateValueType(TDBXColumnsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
//  Columns[1] := CreateValueType(TDBXColumnsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
//  Columns[2] := CreateValueType(TDBXColumnsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
//  Columns[3] := CreateValueType(TDBXColumnsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
//  Columns[4] := CreateValueType(TDBXColumnsColumns.TypeName, STypeName, TDBXDataTypes.WideStringType);
//  Columns[5] := CreateValueType(TDBXColumnsColumns.Precision, SPrecision, TDBXDataTypes.Int32Type);
//  Columns[6] := CreateValueType(TDBXColumnsColumns.Scale, SScale, TDBXDataTypes.Int32Type);
//  Columns[7] := CreateValueType(TDBXColumnsColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
//  Columns[8] := CreateValueType(TDBXColumnsColumns.DefaultValue, SDefaultValue, TDBXDataTypes.WideStringType);
//  Columns[9] := CreateValueType(TDBXColumnsColumns.IsNullable, SIsNullable, TDBXDataTypes.BooleanType);
//  Columns[10] := CreateValueType(TDBXColumnsColumns.IsAutoIncrement, SIsAutoIncrement, TDBXDataTypes.BooleanType);
//  Columns[11] := CreateValueType(TDBXColumnsColumns.MaxInline, SMaxInline, TDBXDataTypes.Int32Type, True);
//  -Columns[12] := CreateValueType(TDBXColumnsColumns.DbxDataType, SDbxDataType, TDBXDataTypes.Int32Type, True);
//  -Columns[13] := CreateValueType(TDBXColumnsColumns.IsFixedLength, SIsFixedLength, TDBXDataTypes.BooleanType, True);
//  -Columns[14] := CreateValueType(TDBXColumnsColumns.IsUnicode, SIsUnicode, TDBXDataTypes.BooleanType, True);
//  -Columns[15] := CreateValueType(TDBXColumnsColumns.IsLong, SIsLong, TDBXDataTypes.BooleanType, True);
//  -Columns[16] := CreateValueType(TDBXColumnsColumns.IsUnsigned, SIsUnsigned, TDBXDataTypes.BooleanType, True);
{$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}

constructor TSqlCursorMetaDataColumnsDbx34.Create(AConnection: TSqlConnectionOdbc3);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataColumnsDbx34.Create'); {$ENDIF _TRACE_CALLS_}
  inherited Create({SupportWideString}True, AConnection.MetaDataReader);

  {define schema: DBXMetaDataNames.pas:TDBXColumnsColumns}

  //
  // remap cursor columns:
  //

  fCursorColmnCount := 12;
  SetLength(fCursorColmnIndxs, fColumnCount);

  remap(0, 1, 'CatalogName', fldWIDESTRING, 1);           // CATALOG_NAME       -> RECNO
  remap(1, 2, 'SchemaName', fldWIDESTRING, 1);            // SCHEMA_NAME        -> CATALOG_NAME
  remap(2, 3, 'TableName', fldWIDESTRING, 1);             // TABLE_NAME         -> SCHEMA_NAME
  remap(3, 4, 'ColumnName', fldWIDESTRING, 1);            // COLUMN_NAME        -> TABLE_NAME
  remap(4, 8, 'TypeName', fldWIDESTRING, 1);              // COLUMN_TYPENAME    -> COLUMN_NAME
  remap(5, 10, 'Precision', fldINT32, SizeOf(Longint));   // COLUMN_PRECISION   -> COLUMN_POSITION
  remap(6, 11, 'Scale', fldINT32, SizeOf(Longint));       // COLUMN_SCALE       -> COLUMN_TYPE
  remap(7, 5, 'Ordinal', fldINT32, SizeOf(Longint));      // COLUMN_POSITION    -> COLUMN_DATATYPE
  remap(8, 14, 'DefaultValue', fldWIDESTRING, 1);         // COLUMN_DEF         -> COLUMN_TYPENAME
  remap(9, 13, 'IsNullable', fldBOOL, 2);                 // COLUMN_NULLABLE    -> COLUMN_SUBTYPE
  remap(10, 10, 'IsAutoIncrement', fldBOOL, 2);           // Virtual column:       IsAutoIncrement (IS_AUTOINCREMENT)
  remap(11, 11, 'MaxInline', fldINT32, SizeOf(Longint));  // Virtual column:       MaxInline (MAX_INLINE)

  {define schema.}

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumnsDbx34.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumnsDbx34.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataColumnsDbx34.getLong;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataColumnsDbx34.getLong', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(Value) and Assigned(fMetaColumnCurrent) and GetPhysColumnNumber(ColumnNumber)
    and (fColumnTypes[ColumnNumber] = fldINT32) then
  begin
    with fMetaColumnCurrent do
    begin
      case ColumnNumber of
        10: //'Precision'
          begin
            if fPrecision = Low(Integer) then
            begin
              IsBlank := True;
              Integer(Value^) := 0;
            end
            else
            begin
              IsBlank := False;
              Integer(Value^) := fPrecision;
            end;
          end;
        11: //'Scale'
            begin
              if fDecimalScale = low(Smallint) then
              begin
                IsBlank := True;
                Integer(Value^) := 0;
              end
              else
              begin
                IsBlank := False;
                Integer(Value^) := fDecimalScale;
              end;
            end;
        5: //'Ordinal'
          begin
            IsBlank := False;
            Integer(Value^) := fOrdinalPosition;
          end;
        //11: //'MaxInline'
        //  IsBlank := True;
        else
          IsBlank := True;
      end;
    end;
  end
  else
    IsBlank := True;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumnsDbx34.getLong', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumnsDbx34.getLong'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataColumnsDbx34.getShort;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataColumnsDbx34.getShort', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(Value) and Assigned(fMetaColumnCurrent) and GetPhysColumnNumber(ColumnNumber)
    and (fColumnTypes[ColumnNumber] = fldBOOL) then
  begin
    with fMetaColumnCurrent do
    begin
      case ColumnNumber of
        10: // 'IsAutoIncrement'
          begin
            IsBlank := False;
            Smallint(Value^) := 0;
          end;
        13: // IsNullable
          begin
            IsBlank := False;
            Smallint(Value^) := fDbxNullable;
          end;
        else
          IsBlank := True;
      end;
    end;
  end
  else
    IsBlank := True;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataColumnsDbx34.getShort', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataColumnsDbx34.getShort'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataIndexesDbx34 }

{$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
//DBXMetaDataNames.pas: class: TDBXIndexesColumns
//DBXMetaDataReader.pas: class function TDBXMetaDataCollectionColumns.CreateIndexesColumns: TDBXValueTypeArray;
//
//  Columns[0] := CreateValueType(TDBXIndexesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
//  Columns[1] := CreateValueType(TDBXIndexesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
//  Columns[2] := CreateValueType(TDBXIndexesColumns.TableName, STableName, TDBXDataTypes.WideStringType);
//  Columns[3] := CreateValueType(TDBXIndexesColumns.IndexName, SIndexName, TDBXDataTypes.WideStringType);
//  Columns[4] := CreateValueType(TDBXIndexesColumns.ConstraintName, SConstraintName, TDBXDataTypes.WideStringType, True);
//  Columns[5] := CreateValueType(TDBXIndexesColumns.IsPrimary, SIsPrimary, TDBXDataTypes.BooleanType);
//  Columns[6] := CreateValueType(TDBXIndexesColumns.IsUnique, SIsUnique, TDBXDataTypes.BooleanType);
//  Columns[7] := CreateValueType(TDBXIndexesColumns.IsAscending, SIsAscending, TDBXDataTypes.BooleanType, True);
{$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}

constructor TSqlCursorMetaDataIndexesDbx34.Create;//(AConnection: TSqlConnectionOdbc3);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataIndexesDbx34.Create'); {$ENDIF _TRACE_CALLS_}
  inherited Create({SupportWideString}True, AConnection.MetaDataReader);

  {define schema: DBXMetaDataNames.pas:TDBXIndexesColumns}

  //
  // remap cursor columns:
  //

  fCursorColmnCount := 8;
  SetLength(fCursorColmnIndxs, fColumnCount);

  remap(0, 1, 'CatalogName', fldWIDESTRING, 1);           // CATALOG_NAME       -> RECNO
  remap(1, 2, 'SchemaName', fldWIDESTRING, 1);            // SCHEMA_NAME        -> CATALOG_NAME
  remap(2, 3, 'TableName', fldWIDESTRING, 1);             // TABLE_NAME         -> SCHEMA_NAME
  remap(3, 4, 'IndexName', fldWIDESTRING, 1);             // INDEX_NAME         -> TABLE_NAME
  remap(4, 0, 'ConstraintName', fldWIDESTRING, 1);        // NULL:                 base column is not sring. GetPhysColumnWideString returned #0
  remap(5, 5, 'IsPrimary', fldBOOL, 2);                   // Virtual column:       IsPrimary (PKEY_NAME)
  remap(6, 6, 'IsUnique', fldBOOL, 2);                    // Virtual column:       IsUnique (COLUMN_NAME)
  remap(7, 7, 'IsAscending', fldBOOL, 2);                 // Virtual column:       IsAscending (SORT_ORDER)

  {define schema.}

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexesDbx34.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexes4.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

//procedure TSqlCursorMetaDataIndexesDbx34.GetPhysColumnWideString;//(PhysColumnNumber: Word; Value: PWideChar);
//begin
//  if PhysColumnNumber = 0 then
//    Value^ := cNullWideChar  // ConstraintName is remaped from 4 to 0
//  else
//    inherited GetPhysColumnWideString(PhysColumnNumber, Value);
//end;

function TSqlCursorMetaDataIndexesDbx34.getShort;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataIndexesDbx34.getShort', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(Value) and Assigned(fCurrentIndexColumn) and GetPhysColumnNumber(ColumnNumber)
    and (fColumnTypes[ColumnNumber] = fldBOOL) then
  begin
    with fCurrentIndexColumn do
    begin
      case ColumnNumber of
        5: //'IsPrimary'
          begin
            IsBlank := False;
            Smallint(Value^) := Smallint((fIndexType and eSQLPrimaryKey) = eSQLPrimaryKey);
          end;
        6: //'IsUnique'
          begin
            IsBlank := False;
            Smallint(Value^) := Smallint((fIndexType and eSQLUnique) = eSQLUnique);
          end;
        7: //'IsAscending'
          begin
            IsBlank := False;
            Smallint(Value^) := Smallint(fSortOrder = AnsiChar('A'));
          end
        else
          IsBlank := True;
      end;
    end;
  end
  else
    IsBlank := True;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexesDbx34.getShort', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexes4.getShort'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{ TSqlCursorMetaDataIndexColumnsDbx34 }

{$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
//DBXMetaDataNames.pas: class: TDBXIndexColumnsColumns
//DBXMetaDataReader.pas: class function TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns: TDBXValueTypeArray;
//
//  Columns[0] := CreateValueType(TDBXIndexColumnsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
//  Columns[1] := CreateValueType(TDBXIndexColumnsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
//  Columns[2] := CreateValueType(TDBXIndexColumnsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
//  Columns[3] := CreateValueType(TDBXIndexColumnsColumns.IndexName, SIndexName, TDBXDataTypes.WideStringType);
//  Columns[4] := CreateValueType(TDBXIndexColumnsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
//  Columns[5] := CreateValueType(TDBXIndexColumnsColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
//  Columns[6] := CreateValueType(TDBXIndexColumnsColumns.IsAscending, SIsAscending, TDBXDataTypes.BooleanType);
{$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}

constructor TSqlCursorMetaDataIndexColumnsDbx34.Create(AConnection: TSqlConnectionOdbc3);
begin
  {$IFDEF _TRACE_CALLS_}try try LogEnterProc('TSqlCursorMetaDataIndexColumnsDbx34.Create'); {$ENDIF _TRACE_CALLS_}
  inherited Create({SupportWideString}True, AConnection.MetaDataReader);

  //
  // remap cursor columns:
  //

  fCursorColmnCount := 7;
  SetLength(fCursorColmnIndxs, fColumnCount);

  remap(0, 1, 'CatalogName', fldWIDESTRING, 1);           // CATALOG_NAME       -> RECNO
  remap(1, 2, 'SchemaName', fldWIDESTRING, 1);            // SCHEMA_NAME        -> CATALOG_NAME
  remap(2, 3, 'TableName', fldWIDESTRING, 1);             // TABLE_NAME         -> SCHEMA_NAME
  remap(3, 4, 'IndexName', fldWIDESTRING, 1);             // INDEX_NAME         -> TABLE_NAME
  remap(4, 6, 'ColumnName', fldWIDESTRING, 1);            // COLUMN_NAME        -> INDEX_NAME
  remap(5, 7, 'Ordinal', fldINT32, SizeOf(Longint));      // COLUMN_POSITION    -> PKEY_NAME
  remap(6, 9, 'IsAscending', fldBOOL, 2);                 // SORT_ORDER         -> COLUMN_NAME

  {define schema.}

  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexColumnsDbx34.Create', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataInTSqlCursorMetaDataIndexColumnsDbx34dexes4.Create'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataIndexColumnsDbx34.getLong;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataIndexColumnsDbx34.getLong', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(Value) and Assigned(fCurrentIndexColumn) and GetPhysColumnNumber(ColumnNumber)
    and (fColumnTypes[ColumnNumber] = fldINT32) then
  begin
    with fCurrentIndexColumn do
    begin
      case ColumnNumber of
        7: //'Ordinal'
          begin
            IsBlank := False;
            Integer(Value^) := fColumnPosition;
          end;
        else
          IsBlank := True;
      end;
    end;
  end
  else
    IsBlank := True;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexColumnsDbx34.getLong', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexColumnsDbx34.getLong'); end;
  {$ENDIF _TRACE_CALLS_}
end;

function TSqlCursorMetaDataIndexColumnsDbx34.getShort;//(ColumnNumber: Word; Value: Pointer; var IsBlank: LongBool): SQLResult;
begin
  Result := DBXERR_NONE;
  {$IFDEF _TRACE_CALLS_}try try {$R+} LogEnterProc('TSqlCursorMetaDataIndexColumnsDbx34.getShort', ['ColumnNumber =', ColumnNumber]); {$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF} {$ENDIF _TRACE_CALLS_}
  if Assigned(Value) and Assigned(fCurrentIndexColumn) and GetPhysColumnNumber(ColumnNumber)
    and (fColumnTypes[ColumnNumber] = fldBOOL) then
  begin
    with fCurrentIndexColumn do
    begin
      case ColumnNumber of
        9: // IsAscending
          begin
            IsBlank := False;
            Smallint(Value^) := Smallint(fSortOrder = 'A');
          end;
        else
          IsBlank := True;
      end;
    end;
  end
  else
    IsBlank := True;
  {$IFDEF _TRACE_CALLS_}
    except on e: Exception do begin LogExceptProc('TSqlCursorMetaDataIndexColumnsDbx34.getShort', e);  raise; end; end;
    finally LogExitProc('TSqlCursorMetaDataIndexColumnsDbx34.getShort'); end;
  {$ENDIF _TRACE_CALLS_}
end;

{@dbx34.}

procedure DoRegisterDbXpressLibW();
begin
  {$IFNDEF _D11UP_}
    {$IFDEF _D10UP_}
      SqlExpr_RegisterDbXpressLib(@getSQLDriverODBCW);
    {$ELSE}
      SqlExpr_RegisterDbXpressLib(@getSQLDriverODBCAW);
    {$ENDIF}
  {$ENDIF}
end;

procedure DoRegisterDbXpressLibWA();
begin
  {$IFNDEF _D11UP_}
    {$IFDEF _D10UP_}
      SqlExpr_RegisterDbXpressLib(@getSQLDriverODBCWA);
    {$ELSE}
      SqlExpr_RegisterDbXpressLib(@getSQLDriverODBC);
    {$ENDIF}
  {$ENDIF}
end;

initialization
begin
  cConnectionOptionsDefault3 := cConnectionOptionsDefault;
  {$IFDEF _INT64_BUGS_FIXED_}
  cConnectionOptionsDefault3[coMapInt64ToBcd] := osOff;
  {$ENDIF}
  cConnectionOptionsDefault3[coEnableUnicode] := osOn;

  RegisterDbXpressLibProc(DoRegisterDbXpressLibW, oaUnicode);
  RegisterDbXpressLibProc(DoRegisterDbXpressLibWA, oaUnicodeToAnsi);

// Deprecated:
//  This allows option of static linking the DbExpress driver into your app
//{$IFDEF MSWINDOWS}
//  {$IFNDEF _DENT_}
//    {$IFNDEF _D11UP_}
//      DoRegisterDbXpressLibW();
//    {$ENDIF}
//  {$ENDIF}
//{$ENDIF}

end;

{.$ENDIF _DBX30_}

end.
