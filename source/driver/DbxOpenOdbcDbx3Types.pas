{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1999, 2001 Borland Software Corporation                       }
{                                                                             }
{ *************************************************************************** }
{                                                                             }
{ Version 3.2012.04.15                                                        }
{                                                                             }
{ *************************************************************************** }

unit DbxOpenOdbcDbx3Types;
{$Z+}

{$UNDEF _D7UP_}  // Delphi 7
{$UNDEF _D9UP_}  // Delphi 2005
{$UNDEF _D10UP_} // Delphi 2006
{$UNDEF _D11UP_} // Delphi 2007
{$UNDEF _D12UP_} // Delphi 2009
{$UNDEF _D14UP_} // Delphi 2010
{$UNDEF _D15UP_} // Delphi 2011 XE
{$UNDEF _D16UP_} // Delphi 2012 XE2

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.00} // Delphi 7 Up
    {$DEFINE _D7UP_}
  {$IFEND}
  {$IF CompilerVersion >= 17.00} // Delphi 2005 Up
    {$DEFINE _D9UP_}
  {$IFEND}
  {$IF CompilerVersion >= 18.00} // Delphi 2006 Up
    {$DEFINE _D10UP_}
  {$IFEND}
  {$IF CompilerVersion >= 18.50} // Delphi 2007 Up
    {$DEFINE _D11UP_}
  {$IFEND}
  {$IF CompilerVersion >= 20.00} // Delphi 2009 Up
    {$DEFINE _D12UP_}
  {$IFEND}
  {$IF CompilerVersion >= 21.00} // Delphi 2010 Up
    {$DEFINE _D14UP_}
  {$IFEND}
  {$IF CompilerVersion >= 22.00}
    // D15: Delphi 2011 (XE) and up
    {$DEFINE _D15UP_}
  {$IFEND}
  {$IF CompilerVersion >= 23.00}
    // D15: Delphi 2012 (XE2) and up
    {$DEFINE _D16UP_}
  {$IFEND}
{$ENDIF}

{$IFNDEF _D16UP_} // XE2
  {$DEFINE CPUX86}
  {$IFNDEF LINUX}{$IFNDEF MACOS}
    {/$DEFINE WIN32}
    {/$DEFINE WINDOWS}
    {$DEFINE MSWINDOWS}
  {$ENDIF}{$ENDIF}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
  {$ENDIF}
{$ENDIF}

{$DEFINE _STDCALL_}
{$IF CompilerVersion >= 23.00}
  {$IFDEF POSIX}
    {$UNDEF _STDCALL_}
  {$ENDIF}
{$IFEND}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFNDEF UNICODE}{$IFDEF LINUX}
  Types,
  {$ENDIF}{$ENDIF}
  SysUtils,
  DB,
  DBCommon
  {$IFDEF _D11UP_}
  ,DBCommonTypes
  {$ENDIF}
  ;

// -------------
// DBXpress.pas:
// -------------
const
  DBXDRIVERVERSION30  = '3.0';
  DBXPRODUCTVERSION30 = '3.0';

  MAXNAMELEN       = 64;
  NAMEBUFLEN       = 32;
  SQL_ERROR        = -1;
  SQL_NULL_DATA    = 100;

  DBXERR_NONE                    = $0000;
  DBXERR_WARNING                 = $0001;
  DBXERR_NOMEMORY                = $0002;
  DBXERR_INVALIDFLDTYPE          = $0003;
  DBXERR_INVALIDHNDL             = $0004;
  DBXERR_NOTSUPPORTED            = $0005;
  DBXERR_INVALIDTIME             = $0006;
  DBXERR_INVALIDXLATION          = $0007;
  DBXERR_OUTOFRANGE              = $0008;
  DBXERR_INVALIDPARAM            = $0009;
  DBXERR_EOF                     = $000A;
  DBXERR_SQLPARAMNOTSET          = $000B;
  DBXERR_INVALIDUSRPASS          = $000C;
  DBXERR_INVALIDPRECISION        = $000D;
  DBXERR_INVALIDLEN              = $000E;
  DBXERR_INVALIDTXNISOLEVEL      = $000F;
  DBXERR_INVALIDTXNID            = $0010;
  DBXERR_DUPLICATETXNID          = $0011;
  DBXERR_DRIVERRESTRICTED        = $0012;
  DBXERR_LOCALTRANSACTIVE        = $0013;
  DBXERR_MULTIPLETRANSNOTENABLED = $0014;
  DBXERR_CONNECTIONFAILED        = $0015;
  DBXERR_DRIVERINITFAILED        = $0016;
  DBXERR_OPTLOCKFAILED           = $0017;
  DBXERR_INVALIDREF              = $0018;
  DBXERR_NOTABLE                 = $0019;
  DBXERR_MISSINGPARAMINSQL       = $001A;
  DBXERR_NOTIMPLEMENT            = $001B;
  DBXERR_DRIVERINCOMPATIBLE      = $001C;

  DBXERR_NODATA                  = $0064;
  DBX_MAXSTATICERRORS            = {$IFDEF _D9UP_}$0064{$ELSE}{$IFDEF _D7UP_}$0014{$ELSE}$0012{$ENDIF}{$ENDIF};

  MaxReservedStaticErrors        = 255;

  DBXERR_SQLERROR                = $0065;


// traceFlags

    trUNKNOWN   = $0000;
    trQPREPARE  = $0001;             { prepared query statements }
    trQEXECUTE  = $0002;             { executed query statements }
    trERROR     = $0004;             { vendor errors }
    trSTMT      = $0008;             { statement ops (i.e. allocate, free) }
    trCONNECT   = $0010;             { connect / disconnect }
    trTRANSACT  = $0020;             { transaction }
    trBLOB      = $0040;             { blob i/o }
    trMISC      = $0080;             { misc. }
    trVENDOR    = $0100;             { vendor calls }
    trDATAIN    = $0200;             { parameter bound data }
    trDATAOUT   = $0400;             { trace fetched data }

// eSQLTableType
    eSQLTable       = $0001;
    eSQLView        = $0002;
    eSQLSystemTable = $0004;
    eSQLSynonym     = $0008;
    eSQLTempTable   = $0010;
    eSQLLocal       = $0020;

// eSQLProcType
    eSQLProcedure   = $0001;
    eSQLFunction    = $0002;
    eSQLPackage     = $0004;
    eSQLSysProcedure = $0008;

// eSQLColType
    eSQLRowId       = $0001;
    eSQLRowVersion  = $0002;
    eSQLAutoIncr    = $0004;
    eSQLDefault     = $0008;

// eSQLIndexType
    eSQLNonUnique   = $0001;
    eSQLUnique      = $0002;
    eSQLPrimaryKey  = $0004;

{ Field Types (Logical) }

  fldUNKNOWN         = 0;
  fldZSTRING         = 1;               { Null terminated string }
  fldDATE            = 2;               { Date     (32 bit) }
  fldBLOB            = 3;               { Blob }
  fldBOOL            = 4;               { Boolean  (16 bit) }
  fldINT16           = 5;               { 16 bit signed number }
  fldINT32           = 6;               { 32 bit signed number }
  fldFLOAT           = 7;               { 64 bit floating point }
  fldBCD             = 8;               { BCD }
  fldBYTES           = 9;               { Fixed number of bytes }
  fldTIME            = 10;              { Time        (32 bit) }
  fldTIMESTAMP       = 11;              { Time-stamp  (64 bit) }
  fldUINT16          = 12;              { Unsigned 16 bit Integer }
  fldUINT32          = 13;              { Unsigned 32 bit Integer }
  fldFLOATIEEE       = 14;              { 80-bit IEEE float }
  fldVARBYTES        = 15;              { Length prefixed var bytes }
  fldLOCKINFO        = 16;              { Look for LOCKINFO typedef }
  fldCURSOR          = 17;              { For Oracle Cursor type }
  fldINT64           = 18;              { 64 bit signed number }
  fldUINT64          = 19;              { Unsigned 64 bit Integer }
  fldADT             = 20;              { Abstract datatype (structure) }
  fldARRAY           = 21;              { Array field type }
  fldREF             = 22;              { Reference to ADT }
  fldTABLE           = 23;              { Nested table (reference) }
  fldDATETIME        = 24;              { DateTime structure field }
  fldFMTBCD          = 25;              { BCD Variant type: required by Midas, same as BCD for DBExpress}
  fldWIDESTRING      = 26;              { UCS2 null terminated string }

  MAXLOGFLDTYPES     = 27;              { Number of logical fieldtypes }

{ Additional (non-BDE fieldtypes }
  fldUNICODE         = $1007;           { Unicode }
  fldINT8            = 28;              { 8 bit signed number as defined in alctypes.h }
  fldUINT8           = 29;              { Unsigned 8 bit integer (Byte) as defined in alctypes.h }
  fldSINGLE          = 27;              { 32 bit floating point }
  fldDATETIMEOFFSET  = 36;              { DatetimeOffset structure for DBExpress }

{ Sub Types (Logical) }

{ fldFLOAT subtype }

  fldstMONEY         = 21;              { Money }

{ fldBLOB subtypes }

  fldstMEMO          = 22;              { Text Memo }
  fldstBINARY        = 23;              { Binary data }
  fldstFMTMEMO       = 24;              { Formatted Text }
  fldstOLEOBJ        = 25;              { OLE object (Paradox) }
  fldstGRAPHIC       = 26;              { Graphics object }
  fldstDBSOLEOBJ     = 27;              { dBASE OLE object }
  fldstTYPEDBINARY   = 28;              { Typed Binary data }
  fldstACCOLEOBJ     = 30;              { Access OLE object }
  fldstWIDEMEMO      = 32;              { WideString Memo }
  fldstHMEMO         = 33;              { CLOB }
  fldstHBINARY       = 34;              { BLOB }
  fldstBFILE         = 36;              { BFILE }

{ fldZSTRING / fldWIDESTRING subtype }

  fldstPASSWORD      = 1;               { Password }
  fldstFIXED         = 31;              { CHAR type }
  fldstGUID          = 38;              { GUID }
  fldstORAINTERVAL   = 40;              { ORACLE INTERVAL }

{ fldINT32 subtype }

  fldstAUTOINC       = 29;

{ fldADT subtype }

  fldstADTNestedTable = 35;             { ADT for nested table (has no name) }

{ fldDATE subtype }
  fldstADTDATE       = 37;              { DATE (OCIDate) with in an ADT }

  fldstORATIMESTAMP  = 39;              { ORACLE TIMESTAMP }

type
  {$IFNDEF _D11UP_}
// ----------------------------------------------------------------------------
// partial imported from "DBXCommonTypes.pas":
// ----------------------------------------------------------------------------
  FLDVchk = (                           { Field Val Check type }
    fldvNOCHECKS,                       { Does not have explicit val checks }
    fldvHASCHECKS,                      { One or more val checks on the field }
    fldvUNKNOWN                         { Dont know at this time }
  );

  FLDRights = (                         { Field Rights }
    fldrREADWRITE,                      { Field can be Read/Written }
    fldrREADONLY,                       { Field is Read only }
    fldrNONE,                           { No Rights on this field }
    fldrUNKNOWN                         { Dont know at this time }
  );

  pCBType            = ^CBType;
  CBType = (                            { Call back type }
    cbGENERAL,                          { General purpose }
    cbRESERVED1,
    cbRESERVED2,
    cbINPUTREQ,                         { Input requested }
    cbRESERVED4,
    cbRESERVED5,
    cbBATCHRESULT,                      { Batch processing rslts }
    cbRESERVED7,
    cbRESTRUCTURE,                      { Restructure }
    cbRESERVED9,
    cbRESERVED10,
    cbRESERVED11,
    cbRESERVED12,
    cbRESERVED13,
    cbRESERVED14,
    cbRESERVED15,
    cbRESERVED16,
    cbRESERVED17,
    cbTABLECHANGED,                     { Table changed notification }
    cbRESERVED19,
    cbCANCELQRY,                        { Allow user to cancel Query }
    cbSERVERCALL,                       { Server Call }
    cbRESERVED22,
    cbGENPROGRESS,                      { Generic Progress report. }
    cbDBASELOGIN,                       { dBASE Login }
    cbDELAYEDUPD,                       { Delayed Updates }
    cbFIELDRECALC,                      { Field(s) recalculation }
    cbTRACE,                            { Trace }
    cbDBLOGIN,                          { Database login }
    cbDETACHNOTIFY,                     { DLL Detach Notification }
    cbNBROFCBS                          { Number of cbs }
  );

  CBRType = (                           { Call-back return type }
    cbrUSEDEF,                          { Take default action }
    cbrCONTINUE,                        { Continue }
    cbrABORT,                           { Abort the operation }
    cbrCHKINPUT,                        { Input given }
    cbrYES,                             { Take requested action }
    cbrNO,                              { Do not take requested action }
    cbrPARTIALASSIST,                   { Assist in completing the job }
    cbrSKIP,                            { Skip this operation }
    cbrRETRY                            { Retry this operation }
  );
  {$ENDIF}

  DBINAME32             = packed array [0..31] of AnsiChar; { holds a name }
  DBINAME128            = packed array [0..128] of WideChar; { holds a name }

  PFLDDesc30 = ^FLDDesc30;
  FLDDesc30 = packed record               { Field Descriptor }
    iFldNum         : Word;             { Field number (1..n) }
    szName          : DBINAME128;          { Field name }
    iFldType        : Word;             { Field type }
    iSubType        : Word;             { Field subtype (if applicable) }
    iUnits1         : SmallInt;         { Number of Chars, digits etc }
    iUnits2         : SmallInt;         { Decimal places etc. }
    iOffset         : Word;             { Offset in the record (computed) }
    iLen            : LongWord;             { Length in bytes (computed) }
    iNullOffset     : Word;             { For Null bits (computed) }
    efldvVchk       : FLDVchk;          { Field Has vcheck (computed) }
    efldrRights     : FLDRights;        { Field Rights (computed) }
    bCalcField      : WordBool;         { Is Calculated field (computed) }
    iUnUsed         : packed array [0..1] of Word;
  end;
  SQLFLDDesc30 = FLDDesc30;

  PFLDDesc25 = ^FLDDesc25;
  FLDDesc25 = packed record               { Field Descriptor }
    iFldNum         : Word;             { Field number (1..n) }
    szName          : DBINAME32;          { Field name }
    iFldType        : Word;             { Field type }
    iSubType        : Word;             { Field subtype (if applicable) }
    iUnits1         : SmallInt;         { Number of Chars, digits etc }
    iUnits2         : SmallInt;         { Decimal places etc. }
    iOffset         : Word;             { Offset in the record (computed) }
    iLen            : LongWord;             { Length in bytes (computed) }
    iNullOffset     : Word;             { For Null bits (computed) }
    efldvVchk       : FLDVchk;          { Field Has vcheck (computed) }
    efldrRights     : FLDRights;        { Field Rights (computed) }
    bCalcField      : WordBool;         { Is Calculated field (computed) }
    iUnUsed         : packed array [0..1] of Word;
  end;
  SQLFLDDesc25 = FLDDesc25;

  pObjAttrDesc30 = ^ObjAttrDesc30;
  ObjAttrDesc30 = packed record
    iFldNum    : Word;                  { Field id }
    pszAttributeName: PWideChar;        { Object attribute name }
  end;
  SQLObjAttrDesc30 = ObjAttrDesc30;

  pObjAttrDesc25 = ^ObjAttrDesc25;
  ObjAttrDesc25 = packed record
    iFldNum    : Word;                  { Field id }
    pszAttributeName: PAnsiChar;        { Object attribute name }
  end;
  SQLObjAttrDesc25 = ObjAttrDesc25;

  pObjTypeDesc30 = ^ObjTypeDesc30;
  ObjTypeDesc30 = packed record
    iFldNum    : Word;                  { Field id }
    szTypeName : DBINAME128;               { Object type name }
  end;
  SQLObjTypeDesc30 = ObjTypeDesc30;

  pObjTypeDesc25 = ^ObjTypeDesc25;
  ObjTypeDesc25 = packed record
    iFldNum    : Word;                  { Field id }
    szTypeName : DBINAME32;               { Object type name }
  end;
  SQLObjTypeDesc25 = ObjTypeDesc25;

  pObjParentDesc30 = ^ObjParentDesc30;
  ObjParentDesc30 = packed record
    iFldNum    : Word;                  { Field id }
    iParentFldNum : Word;               { Parent Field id }
  end;

  pObjParentDesc25 = ^ObjParentDesc25;
  ObjParentDesc25 = packed record
    iFldNum    : Word;                  { Field id }
    iParentFldNum : Word;               { Parent Field id }
  end;

  TInt32 = Integer;
  TDBXErrorCode  = TInt32;
  SQLResult      = TDBXErrorCode;

  TSQLDriverOption = (
    eDrvBlobSize, eDrvCallBack, eDrvCallBackInfo, eDrvRestrict,
    eDrvVersion, eDrvProductVersion);

  TSQLConnectionOption = (
    eConnAutoCommit, eConnBlockingMode, eConnBlobSize, eConnRoleName, //1..4
    eConnWaitOnLocks, eConnCommitRetain, eConnTxnIsoLevel, //5..7
    eConnNativeHandle, eConnServerVersion, eConnCallBack, eConnHostName, //8..11
    eConnDatabaseName, eConnCallBackInfo, eConnObjectMode, //12..14
    eConnMaxActiveComm, eConnServerCharSet, eConnSqlDialect, //15..17
    eConnRollbackRetain, eConnObjectQuoteChar, eConnConnectionName, //18..20
    eConnOSAuthentication, eConnSupportsTransaction, eConnMultipleTransaction, //21..23
    eConnServerPort,eConnOnLine, eConnTrimChar, eConnQualifiedName, //24..27
    eConnCatalogName, eConnSchemaName, eConnObjectName, eConnQuotedObjectName, //28..31
    eConnCustomInfo, eConnTimeOut, eConnConnectionString, eConnTDSPacketSize, //32..35
    eConnClientHostName, eConnClientAppName, eConnCompressed, eConnEncrypted, //36..39
    eConnPrepareSQL, eConnDecimalSeparator); //40..41

  TSQLCommandOption = (
    eCommRowsetSize, eCommBlobSize, eCommBlockRead, eCommBlockWrite,
    eCommParamCount, eCommNativeHandle, eCommCursorName, eCommStoredProc,
    eCommSQLDialect, eCommTransactionID, eCommPackageName, eCommTrimChar,
    eCommQualifiedName, eCommCatalogName, eCommSchemaName, eCommObjectName,
    eCommQuotedObjectName, eCommPrepareSQL, eCommDecimalSeparator);

  TSQLCursorOption = (eCurObjectAttrName, eCurObjectTypeName, eCurParentFieldID);

  TSQLMetaDataOption = (
    eMetaCatalogName, eMetaSchemaName, eMetaDatabaseName,
    eMetaDatabaseVersion, eMetaTransactionIsoLevel, eMetaSupportsTransaction,
    eMetaMaxObjectNameLength, eMetaMaxColumnsInTable, eMetaMaxColumnsInSelect,
    eMetaMaxRowSize, eMetaMaxSQLLength, eMetaObjectQuoteChar,
    eMetaSQLEscapeChar, eMetaProcSupportsCursor, eMetaProcSupportsCursors,
    eMetaSupportsTransactions, eMetaPackageName, eMetaDefaultSchemaName);

  TSQLObjectType = (
    eObjTypeDatabase, eObjTypeDataType, eObjTypeTable,
    eObjTypeView, eObjTypeSynonym, eObjTypeProcedure, eObjTypeUser,
    eObjTypeRole, eObjTypeUDT, eObjTypePackage);

  TTransIsolationLevel = (xilREADCOMMITTED, xilREPEATABLEREAD, xilDIRTYREAD, xilCUSTOM);

  pTTransactionDesc = ^TTransactionDesc;
  TTransactionDesc = packed record
    TransactionID    : LongWord;             { Transaction id }
    GlobalID         : LongWord;             { Global transaction id }
    IsolationLevel   : TTransIsolationLevel; {Transaction Isolation level}
    CustomIsolation  : LongWord;             { DB specific custom isolation }
  end;

  TSTMTParamType = (paramUNKNOWN, paramIN, paramOUT, paramINOUT, paramRET);

  { Function Result }
  TypedEnum      = Integer;
  SQLDATE        = Longint;
  SQLTIME        = Longint;

  pTRACECat = ^TRACECat;                { trace categories }
  TRACECat = TypedEnum;


  TSQLTraceFlag = (
    traceQPREPARE, traceQEXECUTE, traceERROR,
    traceSTMT, traceCONNECT, traceTRANSACT, traceBLOB, traceMISC, traceVENDOR,
    traceDATAIN, traceDATAOUT);

  TSQLTraceFlags = set of TSQLTraceFlag;

type

{ forward declarations }

  ISQLDriver = interface;

  ISQLConnection30 = interface;
  ISQLCommand30 = interface;
  ISQLCursor30 = interface;
  ISQLMetaData30 = interface;

  ISQLConnection25 = interface;
  ISQLCommand25 = interface;
  ISQLCursor25 = interface;
  ISQLMetaData25 = interface;


  ISQLConnection = interface;
  ISQLCommand = interface;
  ISQLCursor = interface;
  ISQLMetaData = interface;

{ Trace callback }

  TSQLCallbackEvent = function(
    CallType: TRACECat;
    CBInfo: Pointer): CBRType; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}

{ class Pointers }

  pSQLDriver     = ^ISQLDriver;
  pSQLConnection = ^ISQLConnection;
  pSQLCommand    = ^ISQLCommand;
  pSQLCursor     = ^ISQLCursor;

{ Common interface }

  ISQLCommon = interface
    ['{F0611EF3-6083-43F2-A37F-B72958032EE1}']
    //
    function SelfObj: TObject; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

{ Base interface }

  ISQLConnection = interface
  end;

  ISQLCommand = interface
  end;

  ISQLCursor = interface
  end;

  ISQLMetaData = interface
  end;

  ISQLDriver = interface
    ['{1E6C91FB-84B0-4E6D-AEC1-ABDF3939E300}']
    //
    function getSQLConnection(out pConn: ISQLConnection): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function SetOption(
               eDOption: TSQLDriverOption;
               PropValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eDOption: TSQLDriverOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out iLength: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

{ Ver 3.0 interfaces }

  ISQLConnection30 = interface(ISQLConnection)
    ['{27D27DD7-CE7C-40F8-8172-C8D4E6BBB23C}']
    //
    function connect(): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function connect(
               ServerName: PWideChar;
               UserName: PWideChar;
               Password: PWideChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function disconnect: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getSQLCommand(
               out pComm: ISQLCommand30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getSQLMetaData(
               out pMetaData: ISQLMetaData30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function SetOption(
               eConnectOption: TSQLConnectionOption;
               lValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eDOption: TSQLConnectionOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out iLength: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function beginTransaction(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function commit(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function rollback(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PWideChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
end;

  ISQLCommand30 = interface(ISQLCommand)
    ['{7C523682-5E3D-440C-882D-10BB2FFE6891}']
    //
    function SetOption(
              eSqlCommandOption: TSQLCommandOption;
              ulValue: Integer
              ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eSqlCommandOption: TSQLCommandOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out iLength: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function setParameter(
              ulParameter: Word ;
              ulChildPos: Word ;
              eParamType: TSTMTParamType ;
              uLogType: Word;
              uSubType: Word;
              iPrecision: Integer;
              iScale: Integer;
              iLength: LongWord ;
              pBuffer: Pointer;
              bIsNull: Integer // lInd
              ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getParameter(
               ParameterNumber: Word;
               ulChildPos: Word;
               Value: Pointer;
               iLength: Integer;
               var IsBlank: Integer
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function prepare(
               SQL: PWideChar;
               ParamCount: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function execute(
               var Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function executeImmediate(
               SQL: PWideChar;
               var Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getNextCursor(
               var Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getRowsAffected(
               var Rows: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function close: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PWideChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

  ISQLCursor30 = interface(ISQLCursor)
    ['{1B572CC4-0969-4374-A498-3BD4EAB2EFF2}']
    //
    function SetOption(
               eOption: TSQLCursorOption;
               PropValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eOption: TSQLCursorOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PWideChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnCount(
               var pColumns: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnNameLength(
               ColumnNumber: Word;
               var pLen: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
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
               var pLength: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnPrecision(
               ColumnNumber: Word;
               var piPrecision: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnScale(
               ColumnNumber: Word;
               var piScale: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isNullable(
               ColumnNumber: Word;
               var Nullable: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isAutoIncrement(
               ColumnNumber: Word;
               var AutoIncr: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isReadOnly(
               ColumnNumber: Word;
               var ReadOnly: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isSearchable(
               ColumnNumber: Word;
               var Searchable: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isBlobSizeExact(
               ColumnNumber: Word;
               var IsExact: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function next: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getString(
               ColumnNumber:
               Word; Value: PAnsiChar;
               var IsBlank: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getWideString(
               ColumnNumber: Word;
               Value: PWideChar;
               var IsBlank: LongBool
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
    function getInt64(
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
               var Length: LongWord;
               var IsBlank: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBlob(
               ColumnNumber: Word;
               Value: Pointer;
               var IsBlank: LongBool;
               Length: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

  ISQLMetaData30 = interface(ISQLMetaData)
    ['{5FE0B9AB-8986-48F7-9B78-CB75F4BB0795}']
    //
    function SetOption(
               eDOption: TSQLMetaDataOption;
               PropValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eDOption: TSQLMetaDataOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getObjectList(
               eObjType: TSQLObjectType;
               out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getTables(
               TableName: PWideChar;
               TableType: LongWord;
               out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedures(
               ProcedureName: PWideChar;
               ProcType: LongWord;
               out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumns(
               TableName: PWideChar;
               ColumnName: PWideChar;
               ColType: LongWord;
               Out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedureParams(
               ProcName: PWideChar;
               ParamName: PWideChar;
               out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getIndices(
               TableName: PWideChar;
               IndexType: LongWord;
               out Cursor: ISQLCursor30
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PWideChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

{ Ver 2.x interfaces }

  ISQLConnection25 = interface(ISQLConnection)
    ['{D9F468A4-B887-423D-8ACC-2385CCFA3724}']
    //
    function connect(
               ServerName: PAnsiChar;
               UserName: PAnsiChar;
               Password: PAnsiChar
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function disconnect: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getSQLCommand(
               out pComm: ISQLCommand25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getSQLMetaData(
               out pMetaData: ISQLMetaData25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function SetOption(
               eConnectOption: TSQLConnectionOption;
               lValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eDOption: TSQLConnectionOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function beginTransaction(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function commit(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function rollback(
               TranID: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PAnsiChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

  ISQLCommand25 = interface(ISQLCommand)
    ['{E0F02EBF-47F9-414E-9421-65EEEFAD9BD1}']
    //
    function SetOption(
               eSqlCommandOption: TSQLCommandOption;
               ulValue: Integer
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eSqlCommandOption: TSQLCommandOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function setParameter(
               ulParameter: Word ;
               ulChildPos: Word ;
               eParamType: TSTMTParamType ;
               uLogType: Word;
               uSubType: Word;
               iPrecision: Integer;
               iScale: Integer;
               Length: LongWord ;
               pBuffer: Pointer;
               bIsNull: Integer // lInd
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getParameter(
               ParameterNumber: Word;
               ulChildPos: Word;
               Value: Pointer;
               Length: Integer;
               var IsBlank: Integer
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function prepare(
               SQL: PAnsiChar;
               ParamCount: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function execute(
               var Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function executeImmediate(
               SQL: PAnsiChar;
               var Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getNextCursor(
               var Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getRowsAffected(
               var Rows: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function close: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PAnsiChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

  ISQLCursor25 = interface(ISQLCursor)
    ['{C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}']
    //
    function SetOption(
               eOption: TSQLCursorOption;
               PropValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eOption: TSQLCursorOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PAnsiChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnCount(
               var pColumns: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnNameLength(
               ColumnNumber: Word;
               var pLen: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnName(
               ColumnNumber: Word;
               pColumnName: PAnsiChar
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnType(
               ColumnNumber: Word;
               var puType: Word;
               var puSubType: Word
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function  getColumnLength(
                ColumnNumber: Word;
                var pLength: LongWord
                ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnPrecision(
               ColumnNumber: Word;
               var piPrecision: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumnScale(
               ColumnNumber: Word;
               var piScale: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isNullable(
               ColumnNumber: Word;
               var Nullable: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isAutoIncrement(
               ColumnNumber: Word;
               var AutoIncr: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isReadOnly(
               ColumnNumber: Word;
               var ReadOnly: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isSearchable(
               ColumnNumber: Word;
               var Searchable: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function isBlobSizeExact(
               ColumnNumber: Word;
               var IsExact: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function next: SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getString(
               ColumnNumber: Word;
               Value: PAnsiChar; // Pointer
               var IsBlank: LongBool
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
               var Length: LongWord;
               var IsBlank: LongBool
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getBlob(
               ColumnNumber: Word;
               Value: Pointer;
               var IsBlank: LongBool;
               Length: LongWord
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

  ISQLMetaData25 = interface(ISQLMetaData)
    ['{92E75E89-97B2-4B53-99B3-B67280A54075}']
    //
    function SetOption(
               eDOption: TSQLMetaDataOption;
               PropValue: LongInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function GetOption(
               eDOption: TSQLMetaDataOption;
               PropValue: Pointer;
               MaxLength: SmallInt;
               out Length: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getObjectList(
               eObjType: TSQLObjectType;
               out Cursor: ISQLCursor25):
               SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getTables(
               TableName: PAnsiChar;
               TableType: LongWord;
               out Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedures(
               ProcedureName: PAnsiChar;
               ProcType: LongWord;
               out Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getColumns(
               TableName: PAnsiChar;
               ColumnName: PAnsiChar;
               ColType: LongWord;
               Out Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getProcedureParams(
               ProcName: PAnsiChar;
               ParamName: PAnsiChar;
               out Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getIndices(
               TableName: PAnsiChar;
               IndexType: LongWord;
               out Cursor: ISQLCursor25
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessage(
               Error: PAnsiChar
               ): SQLResult; overload; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
    function getErrorMessageLen(
               out ErrorLen: SmallInt
               ): SQLResult; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
  end;

// ------------
// SqlExpr.pas:
// ------------

const

  SSelect         =   'select';               { Do not localize }
  SSelectStar     =   ' select * ';           { Do not localize }
  SSelectStarFrom =   ' select * from ';      { Do not localize }
  SSelectSpaces   =   ' select ';             { Do not localize }
  SWhere          =   ' where ';              { Do not localize }
  SAnd            =   ' and ';                { Do not localize }
  SOrderBy        =   ' order by ';           { Do not localize }
  SParam          =   '?';                    { Do not localize }
  DefaultCursor   =   0;
  HourGlassCursor =   -11;

{ Default Max BlobSize }

  DefaultMaxBlobSize = -1;   // values are in K; -1 means retrieve actual size

{ Default RowsetSize }

  DefaultRowsetSize = 20;

  TErrorMessageSize = 2048;

{ FieldType Mappings }

  FldTypeMap: TFieldMap = (
    fldUNKNOWN, fldZSTRING, fldINT16, fldINT32, fldUINT16, fldBOOL, // 0..5
    fldFLOAT, fldFLOAT, fldBCD, fldDATE, fldTIME, fldTIMESTAMP, fldBYTES, // 6..12
    fldVARBYTES, fldINT32, fldBLOB, fldBLOB, fldBLOB, fldBLOB, fldBLOB, // 13..19
    fldBLOB, fldBLOB, fldCURSOR, fldZSTRING, fldWIDESTRING, fldINT64, fldADT, // 20..26
    fldArray, fldREF, fldTABLE, fldBLOB, fldBLOB, fldUNKNOWN, fldUNKNOWN, // 27..33
    fldUNKNOWN, fldZSTRING, fldDATETIME, {$IF CompilerVersion >= 18.00}fldBCD{$ELSE}fldFMTBCD{$IFEND} // 33..37
    {$IFDEF _D10UP_}
    ,fldWIDESTRING, fldBLOB, fldDATETIME, fldZSTRING // 38..41
    {$ENDIF}
    {$IFDEF _D12UP_}
    ,fldINT32, fldUNKNOWN, fldUNKNOWN, fldFLOAT,  // 42..45
    fldUNKNOWN {ftConnection}, fldUNKNOWN {ftParams}, fldUNKNOWN {ftStream}//46..48
    {$ENDIF}
    {$IFDEF _D14UP_}
    ,fldUNKNOWN {ftTimeStampOffset}, fldUNKNOWN {ftObject}, fldUNKNOWN {ftSingle} // 49..51
    {$ENDIF}
    );

  FldSubTypeMap: array[TFieldType] of Word = (
    0, 0, 0, 0, 0, 0, 0, fldstMONEY, 0, 0, 0, 0, 0, 0, fldstAUTOINC, // 0..14
    fldstBINARY, fldstMEMO, fldstGRAPHIC, fldstFMTMEMO, fldstOLEOBJ, // 15..19
    fldstDBSOLEOBJ, fldstTYPEDBINARY, 0, fldstFIXED, 0, // 20..24
    0, 0, 0, 0, 0, fldstHBINARY, fldstHMEMO, 0, 0, 0, {fldstGUID}0, {fldDATETIME}0, 0 // 25..37
    {$IFDEF _D10UP_}
    ,fldstFIXED, fldstWIDEMEMO, fldstORATIMESTAMP, fldstORAINTERVAL // 38 ..41
    {$ENDIF}
    {$IFDEF _D12UP_}
    ,fldUINT32, fldUNKNOWN, fldUNKNOWN, fldFLOATIEEE, // 42..45
    fldUNKNOWN {ftConnection}, fldUNKNOWN {ftParams}, fldUNKNOWN {ftStream} //46..48
    {$ENDIF}
    {$IFDEF _D14UP_}
    ,fldUNKNOWN {ftTimeStampOffset}, fldUNKNOWN {ftObject}, fldUNKNOWN {ftSingle} // 49..51
    {$ENDIF}
  );

  DataTypeMap: array[0..MAXLOGFLDTYPES - 1] of TFieldType = (
    ftUnknown, ftString, ftDate, ftBlob, ftBoolean, ftSmallint,
    ftInteger, ftFloat, ftBCD, ftBytes, ftTime, ftDateTime,
    ftWord, ftInteger, ftUnknown, ftVarBytes, ftUnknown, ftCursor,
    ftLargeInt, ftLargeInt, ftADT, ftArray, ftReference, ftDataSet,
    ftTimeStamp, ftFMTBCD, ftWideString
  );

  BlobTypeMap: array[fldstMEMO..fldstBFILE] of TFieldType = (
    ftMemo, ftBlob, ftFmtMemo, ftParadoxOle, ftGraphic, ftDBaseOle,
    ftTypedBinary, ftBlob, ftBlob, ftBlob, {$IFDEF _D10UP_}ftWideMemo{$ELSE}ftBlob{$ENDIF}, ftOraClob, ftOraBlob,
    ftBlob, ftBlob);

type

{ Forward declarations }

  TLocaleCode = Integer;

  TSQLExceptionType = (exceptConnection, exceptCommand, exceptCursor, exceptMetaData, exceptUseLast);

  PSPParamDesc = ^SPParamDesc;
  SPParamDesc = packed record           { Stored Proc Descriptor }
    iParamNum       : Word;             { Field number (1..n) }
    szName          : WideString;       { Field name }
    iArgType        : TParamType;       { Field type }
    iDataType       : TFieldType;       { Field type }
    iUnits1         : SmallInt;         { Number of Chars, digits etc }
    iUnits2         : SmallInt;         { Decimal places etc. }
    iLen            : LongWord;         { Length in bytes  }
  end;
  SQLSPParamDesc = SPParamDesc;

  TConnectionUserType = (eUserMonitor, eUserDataSet);

{ TSQLConnection }

  TLocale = Pointer;

// ----------------------------------------------------------------------------
// partial imported from "DBXPlatform.pas", "DBXDynalink.pas", "DBXCommon.pas":
// ----------------------------------------------------------------------------

const
  MAX_VERSION_STRING_LENGTH = 128;

type
  TDBXHandle = Pointer;
  TPointer = Pointer;

  TDBXCommonHandle = TDBXHandle;
  TDBXTransactionHandle = TDBXHandle;
  TDBXDriverHandle = TDBXHandle;
  TDBXConnectionHandle = TDBXHandle;
  TDBXCommandHandle = TDBXHandle;
  TDBXMetaDataHandle = TDBXHandle;
  TDBXRowHandle = TDBXHandle;
  TDBXReaderHandle = TDBXHandle;
  TDBXWritableRowHandle = TDBXHandle;

  DBXCallbackHandle = TDBXHandle;

  //TInt32 = Integer;
  TDBXWideChars         = array of WideChar;
  TDBXInt32s            = array of Integer;

  TWideStringArray = array of WideString;
  //TDBXErrorCode = TInt32;
  TDBXType = TInt32;
  TDBXDate  = TInt32;
  TDBXTime  = TInt32;
  TDBXByteArray            = PByte;
  TDBXWideString           = PWideChar;
  TDBXAnsiString           = PChar;
  TDBXWideStringVar        = PWideChar;
  TDBXAnsiStringVar        = PAnsiChar;
  TDBXWideStringBuilder    = PWideChar;
  TDBXAnsiStringBuilder    = PAnsiChar;
  TDBXParameterDirection = TInt32;

{$UNDEF _USE_SQLEXPR_}

{$IFNDEF _D11UP_}
  {$DEFINE _USE_SQLEXPR_}
{$ENDIF}

{$IFDEF _USE_SQLEXPR_}
  procedure SQLExpr_RegisterDbXpressLib(GetClassProc: Pointer);
{$ENDIF}

implementation

{$IFDEF _USE_SQLEXPR_}

{$IFDEF MSWINDOWS}
uses
  SqlExpr;
{$ENDIF}

procedure SQLExpr_RegisterDbXpressLib(GetClassProc: Pointer);
begin
  {$IFDEF MSWINDOWS}
   SqlExpr.RegisterDbXpressLib(GetClassProc);
  {$ENDIF}
end;

{$ENDIF _USE_SQLEXPR_}

end.
