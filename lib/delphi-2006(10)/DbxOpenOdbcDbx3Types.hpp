// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbcdbx3types.pas' rev: 10.00

#ifndef Dbxopenodbcdbx3typesHPP
#define Dbxopenodbcdbx3typesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Dbcommon.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcdbx3types
{
//-- type declarations -------------------------------------------------------
#pragma option push -b
enum FLDVchk { fldvNOCHECKS, fldvHASCHECKS, fldvUNKNOWN };
#pragma option pop

#pragma option push -b
enum FLDRights { fldrREADWRITE, fldrREADONLY, fldrNONE, fldrUNKNOWN };
#pragma option pop

#pragma option push -b
enum CBType { cbGENERAL, cbRESERVED1, cbRESERVED2, cbINPUTREQ, cbRESERVED4, cbRESERVED5, cbBATCHRESULT, cbRESERVED7, cbRESTRUCTURE, cbRESERVED9, cbRESERVED10, cbRESERVED11, cbRESERVED12, cbRESERVED13, cbRESERVED14, cbRESERVED15, cbRESERVED16, cbRESERVED17, cbTABLECHANGED, cbRESERVED19, cbCANCELQRY, cbSERVERCALL, cbRESERVED22, cbGENPROGRESS, cbDBASELOGIN, cbDELAYEDUPD, cbFIELDRECALC, cbTRACE, cbDBLOGIN, cbDETACHNOTIFY, cbNBROFCBS };
#pragma option pop

typedef CBType *pCBType;

#pragma option push -b
enum CBRType { cbrUSEDEF, cbrCONTINUE, cbrABORT, cbrCHKINPUT, cbrYES, cbrNO, cbrPARTIALASSIST, cbrSKIP, cbrRETRY };
#pragma option pop

typedef char DBINAME32[32];

typedef WideChar DBINAME128[129];

struct FLDDesc30;
typedef FLDDesc30 *PFLDDesc30;

#pragma pack(push,1)
struct FLDDesc30
{
	
public:
	Word iFldNum;
	WideChar szName[129];
	Word iFldType;
	Word iSubType;
	short iUnits1;
	short iUnits2;
	Word iOffset;
	unsigned iLen;
	Word iNullOffset;
	FLDVchk efldvVchk;
	FLDRights efldrRights;
	Word bCalcField;
	Word iUnUsed[2];
} ;
#pragma pack(pop)

typedef FLDDesc30  SQLFLDDesc30;

struct FLDDesc25;
typedef FLDDesc25 *PFLDDesc25;

#pragma pack(push,1)
struct FLDDesc25
{
	
public:
	Word iFldNum;
	char szName[32];
	Word iFldType;
	Word iSubType;
	short iUnits1;
	short iUnits2;
	Word iOffset;
	unsigned iLen;
	Word iNullOffset;
	FLDVchk efldvVchk;
	FLDRights efldrRights;
	Word bCalcField;
	Word iUnUsed[2];
} ;
#pragma pack(pop)

typedef FLDDesc25  SQLFLDDesc25;

struct ObjAttrDesc30;
typedef ObjAttrDesc30 *pObjAttrDesc30;

#pragma pack(push,1)
struct ObjAttrDesc30
{
	
public:
	Word iFldNum;
	WideChar *pszAttributeName;
} ;
#pragma pack(pop)

typedef ObjAttrDesc30  SQLObjAttrDesc30;

struct ObjAttrDesc25;
typedef ObjAttrDesc25 *pObjAttrDesc25;

#pragma pack(push,1)
struct ObjAttrDesc25
{
	
public:
	Word iFldNum;
	char *pszAttributeName;
} ;
#pragma pack(pop)

typedef ObjAttrDesc25  SQLObjAttrDesc25;

struct ObjTypeDesc30;
typedef ObjTypeDesc30 *pObjTypeDesc30;

#pragma pack(push,1)
struct ObjTypeDesc30
{
	
public:
	Word iFldNum;
	WideChar szTypeName[129];
} ;
#pragma pack(pop)

typedef ObjTypeDesc30  SQLObjTypeDesc30;

struct ObjTypeDesc25;
typedef ObjTypeDesc25 *pObjTypeDesc25;

#pragma pack(push,1)
struct ObjTypeDesc25
{
	
public:
	Word iFldNum;
	char szTypeName[32];
} ;
#pragma pack(pop)

typedef ObjTypeDesc25  SQLObjTypeDesc25;

struct ObjParentDesc30;
typedef ObjParentDesc30 *pObjParentDesc30;

#pragma pack(push,1)
struct ObjParentDesc30
{
	
public:
	Word iFldNum;
	Word iParentFldNum;
} ;
#pragma pack(pop)

struct ObjParentDesc25;
typedef ObjParentDesc25 *pObjParentDesc25;

#pragma pack(push,1)
struct ObjParentDesc25
{
	
public:
	Word iFldNum;
	Word iParentFldNum;
} ;
#pragma pack(pop)

typedef int TInt32;

typedef int TDBXErrorCode;

typedef int SQLResult;

#pragma option push -b
enum TSQLDriverOption { eDrvBlobSize, eDrvCallBack, eDrvCallBackInfo, eDrvRestrict, eDrvVersion, eDrvProductVersion };
#pragma option pop

#pragma option push -b
enum TSQLConnectionOption { eConnAutoCommit, eConnBlockingMode, eConnBlobSize, eConnRoleName, eConnWaitOnLocks, eConnCommitRetain, eConnTxnIsoLevel, eConnNativeHandle, eConnServerVersion, eConnCallBack, eConnHostName, eConnDatabaseName, eConnCallBackInfo, eConnObjectMode, eConnMaxActiveComm, eConnServerCharSet, eConnSqlDialect, eConnRollbackRetain, eConnObjectQuoteChar, eConnConnectionName, eConnOSAuthentication, eConnSupportsTransaction, eConnMultipleTransaction, eConnServerPort, eConnOnLine, eConnTrimChar, eConnQualifiedName, eConnCatalogName, eConnSchemaName, eConnObjectName, eConnQuotedObjectName, eConnCustomInfo, eConnTimeOut, eConnConnectionString, eConnTDSPacketSize, eConnClientHostName, eConnClientAppName, eConnCompressed, eConnEncrypted, eConnPrepareSQL, eConnDecimalSeparator };
#pragma option pop

#pragma option push -b
enum TSQLCommandOption { eCommRowsetSize, eCommBlobSize, eCommBlockRead, eCommBlockWrite, eCommParamCount, eCommNativeHandle, eCommCursorName, eCommStoredProc, eCommSQLDialect, eCommTransactionID, eCommPackageName, eCommTrimChar, eCommQualifiedName, eCommCatalogName, eCommSchemaName, eCommObjectName, eCommQuotedObjectName, eCommPrepareSQL, eCommDecimalSeparator };
#pragma option pop

#pragma option push -b
enum TSQLCursorOption { eCurObjectAttrName, eCurObjectTypeName, eCurParentFieldID };
#pragma option pop

#pragma option push -b
enum TSQLMetaDataOption { eMetaCatalogName, eMetaSchemaName, eMetaDatabaseName, eMetaDatabaseVersion, eMetaTransactionIsoLevel, eMetaSupportsTransaction, eMetaMaxObjectNameLength, eMetaMaxColumnsInTable, eMetaMaxColumnsInSelect, eMetaMaxRowSize, eMetaMaxSQLLength, eMetaObjectQuoteChar, eMetaSQLEscapeChar, eMetaProcSupportsCursor, eMetaProcSupportsCursors, eMetaSupportsTransactions, eMetaPackageName, eMetaDefaultSchemaName };
#pragma option pop

#pragma option push -b
enum TSQLObjectType { eObjTypeDatabase, eObjTypeDataType, eObjTypeTable, eObjTypeView, eObjTypeSynonym, eObjTypeProcedure, eObjTypeUser, eObjTypeRole, eObjTypeUDT, eObjTypePackage };
#pragma option pop

#pragma option push -b
enum TTransIsolationLevel { xilREADCOMMITTED, xilREPEATABLEREAD, xilDIRTYREAD, xilCUSTOM };
#pragma option pop

struct TTransactionDesc;
typedef TTransactionDesc *pTTransactionDesc;

#pragma pack(push,1)
struct TTransactionDesc
{
	
public:
	unsigned TransactionID;
	unsigned GlobalID;
	TTransIsolationLevel IsolationLevel;
	unsigned CustomIsolation;
} ;
#pragma pack(pop)

#pragma option push -b
enum TSTMTParamType { paramUNKNOWN, paramIN, paramOUT, paramINOUT, paramRET };
#pragma option pop

typedef int TypedEnum;

typedef int SQLDATE;

typedef int SQLTIME;

typedef int *pTRACECat;

typedef int TRACECat;

#pragma option push -b
enum TSQLTraceFlag { traceQPREPARE, traceQEXECUTE, traceERROR, traceSTMT, traceCONNECT, traceTRANSACT, traceBLOB, traceMISC, traceVENDOR, traceDATAIN, traceDATAOUT };
#pragma option pop

typedef Set<TSQLTraceFlag, traceQPREPARE, traceDATAOUT>  TSQLTraceFlags;

typedef CBRType __stdcall (*TSQLCallbackEvent)(int CallType, void * CBInfo);

__interface ISQLDriver;
typedef System::DelphiInterface<ISQLDriver> _di_ISQLDriver;
typedef _di_ISQLDriver *pSQLDriver;

__interface ISQLConnection;
typedef System::DelphiInterface<ISQLConnection> _di_ISQLConnection;
typedef _di_ISQLConnection *pSQLConnection;

__interface ISQLCommand;
typedef System::DelphiInterface<ISQLCommand> _di_ISQLCommand;
typedef _di_ISQLCommand *pSQLCommand;

__interface ISQLCursor;
typedef System::DelphiInterface<ISQLCursor> _di_ISQLCursor;
typedef _di_ISQLCursor *pSQLCursor;

__interface ISQLCommon;
typedef System::DelphiInterface<ISQLCommon> _di_ISQLCommon;
__interface  INTERFACE_UUID("{F0611EF3-6083-43F2-A37F-B72958032EE1}") ISQLCommon  : public IInterface 
{
	
public:
	virtual System::TObject* __stdcall SelfObj(void) = 0 ;
};

__interface ISQLConnection  : public IInterface 
{
	
};

__interface ISQLCommand  : public IInterface 
{
	
};

__interface ISQLCursor  : public IInterface 
{
	
};

__interface ISQLMetaData;
typedef System::DelphiInterface<ISQLMetaData> _di_ISQLMetaData;
__interface ISQLMetaData  : public IInterface 
{
	
};

__interface  INTERFACE_UUID("{1E6C91FB-84B0-4E6D-AEC1-ABDF3939E300}") ISQLDriver  : public IInterface 
{
	
public:
	virtual int __stdcall getSQLConnection(/* out */ _di_ISQLConnection &pConn) = 0 ;
	virtual int __stdcall SetOption(TSQLDriverOption eDOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLDriverOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength) = 0 ;
};

__interface ISQLConnection30;
typedef System::DelphiInterface<ISQLConnection30> _di_ISQLConnection30;
__interface ISQLCommand30;
typedef System::DelphiInterface<ISQLCommand30> _di_ISQLCommand30;
__interface ISQLMetaData30;
typedef System::DelphiInterface<ISQLMetaData30> _di_ISQLMetaData30;
__interface  INTERFACE_UUID("{27D27DD7-CE7C-40F8-8172-C8D4E6BBB23C}") ISQLConnection30  : public ISQLConnection 
{
	
public:
	virtual int __stdcall connect(void) = 0 /* overload */;
	virtual int __stdcall connect(WideChar * ServerName, WideChar * UserName, WideChar * Password) = 0 /* overload */;
	virtual int __stdcall disconnect(void) = 0 ;
	virtual int __stdcall getSQLCommand(/* out */ _di_ISQLCommand30 &pComm) = 0 ;
	virtual int __stdcall getSQLMetaData(/* out */ _di_ISQLMetaData30 &pMetaData) = 0 ;
	virtual int __stdcall SetOption(TSQLConnectionOption eConnectOption, int lValue) = 0 ;
	virtual int __stdcall GetOption(TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength) = 0 ;
	virtual int __stdcall beginTransaction(unsigned TranID) = 0 ;
	virtual int __stdcall commit(unsigned TranID) = 0 ;
	virtual int __stdcall rollback(unsigned TranID) = 0 ;
	virtual int __stdcall getErrorMessage(WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface ISQLCursor30;
typedef System::DelphiInterface<ISQLCursor30> _di_ISQLCursor30;
__interface  INTERFACE_UUID("{7C523682-5E3D-440C-882D-10BB2FFE6891}") ISQLCommand30  : public ISQLCommand 
{
	
public:
	virtual int __stdcall SetOption(TSQLCommandOption eSqlCommandOption, int ulValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength) = 0 ;
	virtual int __stdcall setParameter(Word ulParameter, Word ulChildPos, TSTMTParamType eParamType, Word uLogType, Word uSubType, int iPrecision, int iScale, unsigned iLength, void * pBuffer, int bIsNull) = 0 ;
	virtual int __stdcall getParameter(Word ParameterNumber, Word ulChildPos, void * Value, int iLength, int &IsBlank) = 0 ;
	virtual int __stdcall prepare(WideChar * SQL, Word ParamCount) = 0 ;
	virtual int __stdcall execute(_di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall executeImmediate(WideChar * SQL, _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getNextCursor(_di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getRowsAffected(unsigned &Rows) = 0 ;
	virtual int __stdcall close(void) = 0 ;
	virtual int __stdcall getErrorMessage(WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface  INTERFACE_UUID("{1B572CC4-0969-4374-A498-3BD4EAB2EFF2}") ISQLCursor30  : public ISQLCursor 
{
	
public:
	virtual int __stdcall SetOption(TSQLCursorOption eOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getErrorMessage(WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
	virtual int __stdcall getColumnCount(Word &pColumns) = 0 ;
	virtual int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen) = 0 ;
	virtual int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName) = 0 ;
	virtual int __stdcall getColumnType(Word ColumnNumber, Word &puType, Word &puSubType) = 0 ;
	virtual int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength) = 0 ;
	virtual int __stdcall getColumnPrecision(Word ColumnNumber, short &piPrecision) = 0 ;
	virtual int __stdcall getColumnScale(Word ColumnNumber, short &piScale) = 0 ;
	virtual int __stdcall isNullable(Word ColumnNumber, BOOL &Nullable) = 0 ;
	virtual int __stdcall isAutoIncrement(Word ColumnNumber, BOOL &AutoIncr) = 0 ;
	virtual int __stdcall isReadOnly(Word ColumnNumber, BOOL &ReadOnly) = 0 ;
	virtual int __stdcall isSearchable(Word ColumnNumber, BOOL &Searchable) = 0 ;
	virtual int __stdcall isBlobSizeExact(Word ColumnNumber, BOOL &IsExact) = 0 ;
	virtual int __stdcall next(void) = 0 ;
	virtual int __stdcall getString(Word ColumnNumber, char * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getWideString(Word ColumnNumber, WideChar * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getInt64(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDouble(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBcd(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTimeStamp(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTime(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDate(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBytes(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlobSize(Word ColumnNumber, unsigned &Length, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlob(Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned Length) = 0 ;
};

__interface  INTERFACE_UUID("{5FE0B9AB-8986-48F7-9B78-CB75F4BB0795}") ISQLMetaData30  : public ISQLMetaData 
{
	
public:
	virtual int __stdcall SetOption(TSQLMetaDataOption eDOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getObjectList(TSQLObjectType eObjType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getTables(WideChar * TableName, unsigned TableType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getProcedures(WideChar * ProcedureName, unsigned ProcType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getColumns(WideChar * TableName, WideChar * ColumnName, unsigned ColType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getProcedureParams(WideChar * ProcName, WideChar * ParamName, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getIndices(WideChar * TableName, unsigned IndexType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getErrorMessage(WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface ISQLConnection25;
typedef System::DelphiInterface<ISQLConnection25> _di_ISQLConnection25;
__interface ISQLCommand25;
typedef System::DelphiInterface<ISQLCommand25> _di_ISQLCommand25;
__interface ISQLMetaData25;
typedef System::DelphiInterface<ISQLMetaData25> _di_ISQLMetaData25;
__interface  INTERFACE_UUID("{D9F468A4-B887-423D-8ACC-2385CCFA3724}") ISQLConnection25  : public ISQLConnection 
{
	
public:
	virtual int __stdcall connect(char * ServerName, char * UserName, char * Password) = 0 ;
	virtual int __stdcall disconnect(void) = 0 ;
	virtual int __stdcall getSQLCommand(/* out */ _di_ISQLCommand25 &pComm) = 0 ;
	virtual int __stdcall getSQLMetaData(/* out */ _di_ISQLMetaData25 &pMetaData) = 0 ;
	virtual int __stdcall SetOption(TSQLConnectionOption eConnectOption, int lValue) = 0 ;
	virtual int __stdcall GetOption(TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall beginTransaction(unsigned TranID) = 0 ;
	virtual int __stdcall commit(unsigned TranID) = 0 ;
	virtual int __stdcall rollback(unsigned TranID) = 0 ;
	virtual int __stdcall getErrorMessage(char * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface ISQLCursor25;
typedef System::DelphiInterface<ISQLCursor25> _di_ISQLCursor25;
__interface  INTERFACE_UUID("{E0F02EBF-47F9-414E-9421-65EEEFAD9BD1}") ISQLCommand25  : public ISQLCommand 
{
	
public:
	virtual int __stdcall SetOption(TSQLCommandOption eSqlCommandOption, int ulValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall setParameter(Word ulParameter, Word ulChildPos, TSTMTParamType eParamType, Word uLogType, Word uSubType, int iPrecision, int iScale, unsigned Length, void * pBuffer, int bIsNull) = 0 ;
	virtual int __stdcall getParameter(Word ParameterNumber, Word ulChildPos, void * Value, int Length, int &IsBlank) = 0 ;
	virtual int __stdcall prepare(char * SQL, Word ParamCount) = 0 ;
	virtual int __stdcall execute(_di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall executeImmediate(char * SQL, _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getNextCursor(_di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getRowsAffected(unsigned &Rows) = 0 ;
	virtual int __stdcall close(void) = 0 ;
	virtual int __stdcall getErrorMessage(char * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface  INTERFACE_UUID("{C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}") ISQLCursor25  : public ISQLCursor 
{
	
public:
	virtual int __stdcall SetOption(TSQLCursorOption eOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getErrorMessage(char * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
	virtual int __stdcall getColumnCount(Word &pColumns) = 0 ;
	virtual int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen) = 0 ;
	virtual int __stdcall getColumnName(Word ColumnNumber, char * pColumnName) = 0 ;
	virtual int __stdcall getColumnType(Word ColumnNumber, Word &puType, Word &puSubType) = 0 ;
	virtual int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength) = 0 ;
	virtual int __stdcall getColumnPrecision(Word ColumnNumber, short &piPrecision) = 0 ;
	virtual int __stdcall getColumnScale(Word ColumnNumber, short &piScale) = 0 ;
	virtual int __stdcall isNullable(Word ColumnNumber, BOOL &Nullable) = 0 ;
	virtual int __stdcall isAutoIncrement(Word ColumnNumber, BOOL &AutoIncr) = 0 ;
	virtual int __stdcall isReadOnly(Word ColumnNumber, BOOL &ReadOnly) = 0 ;
	virtual int __stdcall isSearchable(Word ColumnNumber, BOOL &Searchable) = 0 ;
	virtual int __stdcall isBlobSizeExact(Word ColumnNumber, BOOL &IsExact) = 0 ;
	virtual int __stdcall next(void) = 0 ;
	virtual int __stdcall getString(Word ColumnNumber, char * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDouble(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBcd(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTimeStamp(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTime(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDate(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBytes(Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlobSize(Word ColumnNumber, unsigned &Length, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlob(Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned Length) = 0 ;
};

__interface  INTERFACE_UUID("{92E75E89-97B2-4B53-99B3-B67280A54075}") ISQLMetaData25  : public ISQLMetaData 
{
	
public:
	virtual int __stdcall SetOption(TSQLMetaDataOption eDOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getObjectList(TSQLObjectType eObjType, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getTables(char * TableName, unsigned TableType, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getProcedures(char * ProcedureName, unsigned ProcType, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getColumns(char * TableName, char * ColumnName, unsigned ColType, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getProcedureParams(char * ProcName, char * ParamName, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getIndices(char * TableName, unsigned IndexType, /* out */ _di_ISQLCursor25 &Cursor) = 0 ;
	virtual int __stdcall getErrorMessage(char * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

typedef int TLocaleCode;

#pragma option push -b
enum TSQLExceptionType { exceptConnection, exceptCommand, exceptCursor, exceptMetaData, exceptUseLast };
#pragma option pop

struct SPParamDesc;
typedef SPParamDesc *PSPParamDesc;

#pragma pack(push,1)
struct SPParamDesc
{
	
public:
	Word iParamNum;
	WideString szName;
	Db::TParamType iArgType;
	Db::TFieldType iDataType;
	short iUnits1;
	short iUnits2;
	unsigned iLen;
} ;
#pragma pack(pop)

typedef SPParamDesc  SQLSPParamDesc;

#pragma option push -b
enum TConnectionUserType { eUserMonitor, eUserDataSet };
#pragma option pop

typedef void *TLocale;

typedef void *TDBXHandle;

typedef void *TPointer;

typedef void *TDBXCommonHandle;

typedef void *TDBXTransactionHandle;

typedef void *TDBXDriverHandle;

typedef void *TDBXConnectionHandle;

typedef void *TDBXCommandHandle;

typedef void *TDBXMetaDataHandle;

typedef void *TDBXRowHandle;

typedef void *TDBXReaderHandle;

typedef void *TDBXWritableRowHandle;

typedef void *DBXCallbackHandle;

typedef DynamicArray<WideChar >  TDBXWideChars;

typedef DynamicArray<int >  TDBXInt32s;

typedef DynamicArray<WideString >  TWideStringArray;

typedef int TDBXType;

typedef int TDBXDate;

typedef int TDBXTime;

typedef Byte *TDBXByteArray;

typedef WideChar *TDBXWideString;

typedef char *TDBXAnsiString;

typedef WideChar *TDBXWideStringVar;

typedef char *TDBXAnsiStringVar;

typedef WideChar *TDBXWideStringBuilder;

typedef char *TDBXAnsiStringBuilder;

typedef int TDBXParameterDirection;

//-- var, const, procedure ---------------------------------------------------
#define DBXDRIVERVERSION30 "3.0"
#define DBXPRODUCTVERSION30 "3.0"
static const Shortint MAXNAMELEN = 0x40;
static const Shortint NAMEBUFLEN = 0x20;
static const Shortint SQL_ERROR = -1;
static const Shortint SQL_NULL_DATA = 0x64;
static const Shortint DBXERR_NONE = 0x0;
static const Shortint DBXERR_WARNING = 0x1;
static const Shortint DBXERR_NOMEMORY = 0x2;
static const Shortint DBXERR_INVALIDFLDTYPE = 0x3;
static const Shortint DBXERR_INVALIDHNDL = 0x4;
static const Shortint DBXERR_NOTSUPPORTED = 0x5;
static const Shortint DBXERR_INVALIDTIME = 0x6;
static const Shortint DBXERR_INVALIDXLATION = 0x7;
static const Shortint DBXERR_OUTOFRANGE = 0x8;
static const Shortint DBXERR_INVALIDPARAM = 0x9;
static const Shortint DBXERR_EOF = 0xa;
static const Shortint DBXERR_SQLPARAMNOTSET = 0xb;
static const Shortint DBXERR_INVALIDUSRPASS = 0xc;
static const Shortint DBXERR_INVALIDPRECISION = 0xd;
static const Shortint DBXERR_INVALIDLEN = 0xe;
static const Shortint DBXERR_INVALIDTXNISOLEVEL = 0xf;
static const Shortint DBXERR_INVALIDTXNID = 0x10;
static const Shortint DBXERR_DUPLICATETXNID = 0x11;
static const Shortint DBXERR_DRIVERRESTRICTED = 0x12;
static const Shortint DBXERR_LOCALTRANSACTIVE = 0x13;
static const Shortint DBXERR_MULTIPLETRANSNOTENABLED = 0x14;
static const Shortint DBXERR_CONNECTIONFAILED = 0x15;
static const Shortint DBXERR_DRIVERINITFAILED = 0x16;
static const Shortint DBXERR_OPTLOCKFAILED = 0x17;
static const Shortint DBXERR_INVALIDREF = 0x18;
static const Shortint DBXERR_NOTABLE = 0x19;
static const Shortint DBXERR_MISSINGPARAMINSQL = 0x1a;
static const Shortint DBXERR_NOTIMPLEMENT = 0x1b;
static const Shortint DBXERR_DRIVERINCOMPATIBLE = 0x1c;
static const Shortint DBXERR_NODATA = 0x64;
static const Shortint DBX_MAXSTATICERRORS = 0x64;
static const Byte MaxReservedStaticErrors = 0xff;
static const Shortint DBXERR_SQLERROR = 0x65;
static const Shortint trUNKNOWN = 0x0;
static const Shortint trQPREPARE = 0x1;
static const Shortint trQEXECUTE = 0x2;
static const Shortint trERROR = 0x4;
static const Shortint trSTMT = 0x8;
static const Shortint trCONNECT = 0x10;
static const Shortint trTRANSACT = 0x20;
static const Shortint trBLOB = 0x40;
static const Byte trMISC = 0x80;
static const Word trVENDOR = 0x100;
static const Word trDATAIN = 0x200;
static const Word trDATAOUT = 0x400;
static const Shortint eSQLTable = 0x1;
static const Shortint eSQLView = 0x2;
static const Shortint eSQLSystemTable = 0x4;
static const Shortint eSQLSynonym = 0x8;
static const Shortint eSQLTempTable = 0x10;
static const Shortint eSQLLocal = 0x20;
static const Shortint eSQLProcedure = 0x1;
static const Shortint eSQLFunction = 0x2;
static const Shortint eSQLPackage = 0x4;
static const Shortint eSQLSysProcedure = 0x8;
static const Shortint eSQLRowId = 0x1;
static const Shortint eSQLRowVersion = 0x2;
static const Shortint eSQLAutoIncr = 0x4;
static const Shortint eSQLDefault = 0x8;
static const Shortint eSQLNonUnique = 0x1;
static const Shortint eSQLUnique = 0x2;
static const Shortint eSQLPrimaryKey = 0x4;
static const Shortint fldUNKNOWN = 0x0;
static const Shortint fldZSTRING = 0x1;
static const Shortint fldDATE = 0x2;
static const Shortint fldBLOB = 0x3;
static const Shortint fldBOOL = 0x4;
static const Shortint fldINT16 = 0x5;
static const Shortint fldINT32 = 0x6;
static const Shortint fldFLOAT = 0x7;
static const Shortint fldBCD = 0x8;
static const Shortint fldBYTES = 0x9;
static const Shortint fldTIME = 0xa;
static const Shortint fldTIMESTAMP = 0xb;
static const Shortint fldUINT16 = 0xc;
static const Shortint fldUINT32 = 0xd;
static const Shortint fldFLOATIEEE = 0xe;
static const Shortint fldVARBYTES = 0xf;
static const Shortint fldLOCKINFO = 0x10;
static const Shortint fldCURSOR = 0x11;
static const Shortint fldINT64 = 0x12;
static const Shortint fldUINT64 = 0x13;
static const Shortint fldADT = 0x14;
static const Shortint fldARRAY = 0x15;
static const Shortint fldREF = 0x16;
static const Shortint fldTABLE = 0x17;
static const Shortint fldDATETIME = 0x18;
static const Shortint fldFMTBCD = 0x19;
static const Shortint fldWIDESTRING = 0x1a;
static const Shortint MAXLOGFLDTYPES = 0x1b;
static const Word fldUNICODE = 0x1007;
static const Shortint fldINT8 = 0x1c;
static const Shortint fldUINT8 = 0x1d;
static const Shortint fldSINGLE = 0x1b;
static const Shortint fldDATETIMEOFFSET = 0x24;
static const Shortint fldstMONEY = 0x15;
static const Shortint fldstMEMO = 0x16;
static const Shortint fldstBINARY = 0x17;
static const Shortint fldstFMTMEMO = 0x18;
static const Shortint fldstOLEOBJ = 0x19;
static const Shortint fldstGRAPHIC = 0x1a;
static const Shortint fldstDBSOLEOBJ = 0x1b;
static const Shortint fldstTYPEDBINARY = 0x1c;
static const Shortint fldstACCOLEOBJ = 0x1e;
static const Shortint fldstWIDEMEMO = 0x20;
static const Shortint fldstHMEMO = 0x21;
static const Shortint fldstHBINARY = 0x22;
static const Shortint fldstBFILE = 0x24;
static const Shortint fldstPASSWORD = 0x1;
static const Shortint fldstFIXED = 0x1f;
static const Shortint fldstGUID = 0x26;
static const Shortint fldstORAINTERVAL = 0x28;
static const Shortint fldstAUTOINC = 0x1d;
static const Shortint fldstADTNestedTable = 0x23;
static const Shortint fldstADTDATE = 0x25;
static const Shortint fldstORATIMESTAMP = 0x27;
#define SSelect "select"
#define SSelectStar " select * "
#define SSelectStarFrom " select * from "
#define SSelectSpaces " select "
#define SWhere " where "
#define SAnd " and "
#define SOrderBy " order by "
static const char SParam = '\x3f';
static const Shortint DefaultCursor = 0x0;
static const Shortint HourGlassCursor = -11;
static const Shortint DefaultMaxBlobSize = -1;
static const Shortint DefaultRowsetSize = 0x14;
static const Word TErrorMessageSize = 0x800;
extern PACKAGE Byte FldTypeMap[42];
extern PACKAGE Word FldSubTypeMap[42];
extern PACKAGE Db::TFieldType DataTypeMap[27];
extern PACKAGE Db::TFieldType BlobTypeMap[15];
static const Byte MAX_VERSION_STRING_LENGTH = 0x80;
extern PACKAGE void __fastcall SQLExpr_RegisterDbXpressLib(void * GetClassProc);

}	/* namespace Dbxopenodbcdbx3types */
using namespace Dbxopenodbcdbx3types;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbcdbx3types
