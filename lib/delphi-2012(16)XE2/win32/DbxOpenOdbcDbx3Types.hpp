// CodeGear C++Builder
// Copyright (c) 1995, 2011 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcDbx3Types.pas' rev: 23.00 (Win32)

#ifndef Dbxopenodbcdbx3typesHPP
#define Dbxopenodbcdbx3typesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Data.DB.hpp>	// Pascal unit
#include <Data.DBCommon.hpp>	// Pascal unit
#include <Data.DBCommonTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcdbx3types
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<char, 32> DBINAME32;

typedef System::StaticArray<System::WideChar, 129> DBINAME128;

struct FLDDesc30;
typedef FLDDesc30 *PFLDDesc30;

#pragma pack(push,1)
struct DECLSPEC_DRECORD FLDDesc30
{
	
public:
	System::Word iFldNum;
	DBINAME128 szName;
	System::Word iFldType;
	System::Word iSubType;
	short iUnits1;
	short iUnits2;
	System::Word iOffset;
	unsigned iLen;
	System::Word iNullOffset;
	Data::Dbcommontypes::FLDVchk efldvVchk;
	Data::Dbcommontypes::FLDRights efldrRights;
	System::WordBool bCalcField;
	System::StaticArray<System::Word, 2> iUnUsed;
};
#pragma pack(pop)


typedef FLDDesc30 SQLFLDDesc30;

struct FLDDesc25;
typedef FLDDesc25 *PFLDDesc25;

#pragma pack(push,1)
struct DECLSPEC_DRECORD FLDDesc25
{
	
public:
	System::Word iFldNum;
	DBINAME32 szName;
	System::Word iFldType;
	System::Word iSubType;
	short iUnits1;
	short iUnits2;
	System::Word iOffset;
	unsigned iLen;
	System::Word iNullOffset;
	Data::Dbcommontypes::FLDVchk efldvVchk;
	Data::Dbcommontypes::FLDRights efldrRights;
	System::WordBool bCalcField;
	System::StaticArray<System::Word, 2> iUnUsed;
};
#pragma pack(pop)


typedef FLDDesc25 SQLFLDDesc25;

struct ObjAttrDesc30;
typedef ObjAttrDesc30 *pObjAttrDesc30;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjAttrDesc30
{
	
public:
	System::Word iFldNum;
	System::WideChar *pszAttributeName;
};
#pragma pack(pop)


typedef ObjAttrDesc30 SQLObjAttrDesc30;

struct ObjAttrDesc25;
typedef ObjAttrDesc25 *pObjAttrDesc25;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjAttrDesc25
{
	
public:
	System::Word iFldNum;
	char *pszAttributeName;
};
#pragma pack(pop)


typedef ObjAttrDesc25 SQLObjAttrDesc25;

struct ObjTypeDesc30;
typedef ObjTypeDesc30 *pObjTypeDesc30;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjTypeDesc30
{
	
public:
	System::Word iFldNum;
	DBINAME128 szTypeName;
};
#pragma pack(pop)


typedef ObjTypeDesc30 SQLObjTypeDesc30;

struct ObjTypeDesc25;
typedef ObjTypeDesc25 *pObjTypeDesc25;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjTypeDesc25
{
	
public:
	System::Word iFldNum;
	DBINAME32 szTypeName;
};
#pragma pack(pop)


typedef ObjTypeDesc25 SQLObjTypeDesc25;

struct ObjParentDesc30;
typedef ObjParentDesc30 *pObjParentDesc30;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjParentDesc30
{
	
public:
	System::Word iFldNum;
	System::Word iParentFldNum;
};
#pragma pack(pop)


struct ObjParentDesc25;
typedef ObjParentDesc25 *pObjParentDesc25;

#pragma pack(push,1)
struct DECLSPEC_DRECORD ObjParentDesc25
{
	
public:
	System::Word iFldNum;
	System::Word iParentFldNum;
};
#pragma pack(pop)


typedef int TInt32;

typedef int TDBXErrorCode;

typedef int SQLResult;

#pragma option push -b
enum TSQLDriverOption : unsigned int { eDrvBlobSize, eDrvCallBack, eDrvCallBackInfo, eDrvRestrict, eDrvVersion, eDrvProductVersion };
#pragma option pop

#pragma option push -b
enum TSQLConnectionOption : unsigned int { eConnAutoCommit, eConnBlockingMode, eConnBlobSize, eConnRoleName, eConnWaitOnLocks, eConnCommitRetain, eConnTxnIsoLevel, eConnNativeHandle, eConnServerVersion, eConnCallBack, eConnHostName, eConnDatabaseName, eConnCallBackInfo, eConnObjectMode, eConnMaxActiveComm, eConnServerCharSet, eConnSqlDialect, eConnRollbackRetain, eConnObjectQuoteChar, eConnConnectionName, eConnOSAuthentication, eConnSupportsTransaction, eConnMultipleTransaction, eConnServerPort, eConnOnLine, eConnTrimChar, eConnQualifiedName, eConnCatalogName, eConnSchemaName, eConnObjectName, eConnQuotedObjectName, eConnCustomInfo, eConnTimeOut, eConnConnectionString, eConnTDSPacketSize, eConnClientHostName, eConnClientAppName, eConnCompressed, 
	eConnEncrypted, eConnPrepareSQL, eConnDecimalSeparator };
#pragma option pop

#pragma option push -b
enum TSQLCommandOption : unsigned int { eCommRowsetSize, eCommBlobSize, eCommBlockRead, eCommBlockWrite, eCommParamCount, eCommNativeHandle, eCommCursorName, eCommStoredProc, eCommSQLDialect, eCommTransactionID, eCommPackageName, eCommTrimChar, eCommQualifiedName, eCommCatalogName, eCommSchemaName, eCommObjectName, eCommQuotedObjectName, eCommPrepareSQL, eCommDecimalSeparator };
#pragma option pop

#pragma option push -b
enum TSQLCursorOption : unsigned int { eCurObjectAttrName, eCurObjectTypeName, eCurParentFieldID };
#pragma option pop

#pragma option push -b
enum TSQLMetaDataOption : unsigned int { eMetaCatalogName, eMetaSchemaName, eMetaDatabaseName, eMetaDatabaseVersion, eMetaTransactionIsoLevel, eMetaSupportsTransaction, eMetaMaxObjectNameLength, eMetaMaxColumnsInTable, eMetaMaxColumnsInSelect, eMetaMaxRowSize, eMetaMaxSQLLength, eMetaObjectQuoteChar, eMetaSQLEscapeChar, eMetaProcSupportsCursor, eMetaProcSupportsCursors, eMetaSupportsTransactions, eMetaPackageName, eMetaDefaultSchemaName };
#pragma option pop

#pragma option push -b
enum TSQLObjectType : unsigned int { eObjTypeDatabase, eObjTypeDataType, eObjTypeTable, eObjTypeView, eObjTypeSynonym, eObjTypeProcedure, eObjTypeUser, eObjTypeRole, eObjTypeUDT, eObjTypePackage };
#pragma option pop

#pragma option push -b
enum TTransIsolationLevel : unsigned int { xilREADCOMMITTED, xilREPEATABLEREAD, xilDIRTYREAD, xilCUSTOM };
#pragma option pop

struct TTransactionDesc;
typedef TTransactionDesc *pTTransactionDesc;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTransactionDesc
{
	
public:
	unsigned TransactionID;
	unsigned GlobalID;
	TTransIsolationLevel IsolationLevel;
	unsigned CustomIsolation;
};
#pragma pack(pop)


#pragma option push -b
enum TSTMTParamType : unsigned int { paramUNKNOWN, paramIN, paramOUT, paramINOUT, paramRET };
#pragma option pop

typedef int TypedEnum;

typedef int SQLDATE;

typedef int SQLTIME;

typedef int *pTRACECat;

typedef int TRACECat;

#pragma option push -b
enum TSQLTraceFlag : unsigned int { traceQPREPARE, traceQEXECUTE, traceERROR, traceSTMT, traceCONNECT, traceTRANSACT, traceBLOB, traceMISC, traceVENDOR, traceDATAIN, traceDATAOUT };
#pragma option pop

typedef System::Set<TSQLTraceFlag, TSQLTraceFlag::traceQPREPARE, TSQLTraceFlag::traceDATAOUT>  TSQLTraceFlags;

typedef Data::Dbcommontypes::CBRType __stdcall (*TSQLCallbackEvent)(int CallType, void * CBInfo);

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
__interface  INTERFACE_UUID("{F0611EF3-6083-43F2-A37F-B72958032EE1}") ISQLCommon  : public System::IInterface 
{
	
public:
	virtual System::TObject* __stdcall SelfObj(void) = 0 ;
};

__interface ISQLConnection  : public System::IInterface 
{
	
};

__interface ISQLCommand  : public System::IInterface 
{
	
};

__interface ISQLCursor  : public System::IInterface 
{
	
};

__interface ISQLMetaData;
typedef System::DelphiInterface<ISQLMetaData> _di_ISQLMetaData;
__interface ISQLMetaData  : public System::IInterface 
{
	
};

__interface  INTERFACE_UUID("{1E6C91FB-84B0-4E6D-AEC1-ABDF3939E300}") ISQLDriver  : public System::IInterface 
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
	virtual int __stdcall connect(System::WideChar * ServerName, System::WideChar * UserName, System::WideChar * Password) = 0 /* overload */;
	virtual int __stdcall disconnect(void) = 0 ;
	virtual int __stdcall getSQLCommand(/* out */ _di_ISQLCommand30 &pComm) = 0 ;
	virtual int __stdcall getSQLMetaData(/* out */ _di_ISQLMetaData30 &pMetaData) = 0 ;
	virtual int __stdcall SetOption(TSQLConnectionOption eConnectOption, int lValue) = 0 ;
	virtual int __stdcall GetOption(TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength) = 0 ;
	virtual int __stdcall beginTransaction(unsigned TranID) = 0 ;
	virtual int __stdcall commit(unsigned TranID) = 0 ;
	virtual int __stdcall rollback(unsigned TranID) = 0 ;
	virtual int __stdcall getErrorMessage(System::WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface ISQLCursor30;
typedef System::DelphiInterface<ISQLCursor30> _di_ISQLCursor30;
__interface  INTERFACE_UUID("{7C523682-5E3D-440C-882D-10BB2FFE6891}") ISQLCommand30  : public ISQLCommand 
{
	
public:
	virtual int __stdcall SetOption(TSQLCommandOption eSqlCommandOption, int ulValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength) = 0 ;
	virtual int __stdcall setParameter(System::Word ulParameter, System::Word ulChildPos, TSTMTParamType eParamType, System::Word uLogType, System::Word uSubType, int iPrecision, int iScale, unsigned iLength, void * pBuffer, int bIsNull) = 0 ;
	virtual int __stdcall getParameter(System::Word ParameterNumber, System::Word ulChildPos, void * Value, int iLength, int &IsBlank) = 0 ;
	virtual int __stdcall prepare(System::WideChar * SQL, System::Word ParamCount) = 0 ;
	virtual int __stdcall execute(_di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall executeImmediate(System::WideChar * SQL, _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getNextCursor(_di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getRowsAffected(unsigned &Rows) = 0 ;
	virtual int __stdcall close(void) = 0 ;
	virtual int __stdcall getErrorMessage(System::WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
};

__interface  INTERFACE_UUID("{1B572CC4-0969-4374-A498-3BD4EAB2EFF2}") ISQLCursor30  : public ISQLCursor 
{
	
public:
	virtual int __stdcall SetOption(TSQLCursorOption eOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getErrorMessage(System::WideChar * Error) = 0 /* overload */;
	virtual int __stdcall getErrorMessageLen(/* out */ short &ErrorLen) = 0 ;
	virtual int __stdcall getColumnCount(System::Word &pColumns) = 0 ;
	virtual int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen) = 0 ;
	virtual int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName) = 0 ;
	virtual int __stdcall getColumnType(System::Word ColumnNumber, System::Word &puType, System::Word &puSubType) = 0 ;
	virtual int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength) = 0 ;
	virtual int __stdcall getColumnPrecision(System::Word ColumnNumber, short &piPrecision) = 0 ;
	virtual int __stdcall getColumnScale(System::Word ColumnNumber, short &piScale) = 0 ;
	virtual int __stdcall isNullable(System::Word ColumnNumber, BOOL &Nullable) = 0 ;
	virtual int __stdcall isAutoIncrement(System::Word ColumnNumber, BOOL &AutoIncr) = 0 ;
	virtual int __stdcall isReadOnly(System::Word ColumnNumber, BOOL &ReadOnly) = 0 ;
	virtual int __stdcall isSearchable(System::Word ColumnNumber, BOOL &Searchable) = 0 ;
	virtual int __stdcall isBlobSizeExact(System::Word ColumnNumber, BOOL &IsExact) = 0 ;
	virtual int __stdcall next(void) = 0 ;
	virtual int __stdcall getString(System::Word ColumnNumber, char * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getWideString(System::Word ColumnNumber, System::WideChar * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getLong(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getInt64(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDouble(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBcd(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTimeStamp(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTime(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDate(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBytes(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlobSize(System::Word ColumnNumber, unsigned &Length, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlob(System::Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned Length) = 0 ;
};

__interface  INTERFACE_UUID("{5FE0B9AB-8986-48F7-9B78-CB75F4BB0795}") ISQLMetaData30  : public ISQLMetaData 
{
	
public:
	virtual int __stdcall SetOption(TSQLMetaDataOption eDOption, int PropValue) = 0 ;
	virtual int __stdcall GetOption(TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &Length) = 0 ;
	virtual int __stdcall getObjectList(TSQLObjectType eObjType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getTables(System::WideChar * TableName, unsigned TableType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getProcedures(System::WideChar * ProcedureName, unsigned ProcType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getColumns(System::WideChar * TableName, System::WideChar * ColumnName, unsigned ColType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getProcedureParams(System::WideChar * ProcName, System::WideChar * ParamName, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getIndices(System::WideChar * TableName, unsigned IndexType, /* out */ _di_ISQLCursor30 &Cursor) = 0 ;
	virtual int __stdcall getErrorMessage(System::WideChar * Error) = 0 /* overload */;
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
	virtual int __stdcall setParameter(System::Word ulParameter, System::Word ulChildPos, TSTMTParamType eParamType, System::Word uLogType, System::Word uSubType, int iPrecision, int iScale, unsigned Length, void * pBuffer, int bIsNull) = 0 ;
	virtual int __stdcall getParameter(System::Word ParameterNumber, System::Word ulChildPos, void * Value, int Length, int &IsBlank) = 0 ;
	virtual int __stdcall prepare(char * SQL, System::Word ParamCount) = 0 ;
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
	virtual int __stdcall getColumnCount(System::Word &pColumns) = 0 ;
	virtual int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen) = 0 ;
	virtual int __stdcall getColumnName(System::Word ColumnNumber, char * pColumnName) = 0 ;
	virtual int __stdcall getColumnType(System::Word ColumnNumber, System::Word &puType, System::Word &puSubType) = 0 ;
	virtual int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength) = 0 ;
	virtual int __stdcall getColumnPrecision(System::Word ColumnNumber, short &piPrecision) = 0 ;
	virtual int __stdcall getColumnScale(System::Word ColumnNumber, short &piScale) = 0 ;
	virtual int __stdcall isNullable(System::Word ColumnNumber, BOOL &Nullable) = 0 ;
	virtual int __stdcall isAutoIncrement(System::Word ColumnNumber, BOOL &AutoIncr) = 0 ;
	virtual int __stdcall isReadOnly(System::Word ColumnNumber, BOOL &ReadOnly) = 0 ;
	virtual int __stdcall isSearchable(System::Word ColumnNumber, BOOL &Searchable) = 0 ;
	virtual int __stdcall isBlobSizeExact(System::Word ColumnNumber, BOOL &IsExact) = 0 ;
	virtual int __stdcall next(void) = 0 ;
	virtual int __stdcall getString(System::Word ColumnNumber, char * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getLong(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDouble(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBcd(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTimeStamp(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getTime(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getDate(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBytes(System::Word ColumnNumber, void * Value, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlobSize(System::Word ColumnNumber, unsigned &Length, BOOL &IsBlank) = 0 ;
	virtual int __stdcall getBlob(System::Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned Length) = 0 ;
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
enum TSQLExceptionType : unsigned int { exceptConnection, exceptCommand, exceptCursor, exceptMetaData, exceptUseLast };
#pragma option pop

struct SPParamDesc;
typedef SPParamDesc *PSPParamDesc;

#pragma pack(push,1)
struct DECLSPEC_DRECORD SPParamDesc
{
	
public:
	System::Word iParamNum;
	System::WideString szName;
	Data::Db::TParamType iArgType;
	Data::Db::TFieldType iDataType;
	short iUnits1;
	short iUnits2;
	unsigned iLen;
};
#pragma pack(pop)


typedef SPParamDesc SQLSPParamDesc;

#pragma option push -b
enum TConnectionUserType : unsigned int { eUserMonitor, eUserDataSet };
#pragma option pop

typedef void * TLocale;

typedef void * TDBXHandle;

typedef void * TPointer;

typedef void * TDBXCommonHandle;

typedef void * TDBXTransactionHandle;

typedef void * TDBXDriverHandle;

typedef void * TDBXConnectionHandle;

typedef void * TDBXCommandHandle;

typedef void * TDBXMetaDataHandle;

typedef void * TDBXRowHandle;

typedef void * TDBXReaderHandle;

typedef void * TDBXWritableRowHandle;

typedef void * DBXCallbackHandle;

typedef System::DynamicArray<System::WideChar> TDBXWideChars;

typedef System::DynamicArray<int> TDBXInt32s;

typedef System::DynamicArray<System::WideString> TWideStringArray;

typedef int TDBXType;

typedef int TDBXDate;

typedef int TDBXTime;

typedef System::PByte TDBXByteArray;

typedef System::WideChar * TDBXWideString;

typedef System::WideChar * TDBXAnsiString;

typedef System::WideChar * TDBXWideStringVar;

typedef char * TDBXAnsiStringVar;

typedef System::WideChar * TDBXWideStringBuilder;

typedef char * TDBXAnsiStringBuilder;

typedef int TDBXParameterDirection;

//-- var, const, procedure ---------------------------------------------------
#define DBXDRIVERVERSION30 L"3.0"
#define DBXPRODUCTVERSION30 L"3.0"
static const System::Int8 MAXNAMELEN = System::Int8(0x40);
static const System::Int8 NAMEBUFLEN = System::Int8(0x20);
static const System::Int8 SQL_ERROR = System::Int8(-1);
static const System::Int8 SQL_NULL_DATA = System::Int8(0x64);
static const System::Int8 DBXERR_NONE = System::Int8(0x0);
static const System::Int8 DBXERR_WARNING = System::Int8(0x1);
static const System::Int8 DBXERR_NOMEMORY = System::Int8(0x2);
static const System::Int8 DBXERR_INVALIDFLDTYPE = System::Int8(0x3);
static const System::Int8 DBXERR_INVALIDHNDL = System::Int8(0x4);
static const System::Int8 DBXERR_NOTSUPPORTED = System::Int8(0x5);
static const System::Int8 DBXERR_INVALIDTIME = System::Int8(0x6);
static const System::Int8 DBXERR_INVALIDXLATION = System::Int8(0x7);
static const System::Int8 DBXERR_OUTOFRANGE = System::Int8(0x8);
static const System::Int8 DBXERR_INVALIDPARAM = System::Int8(0x9);
static const System::Int8 DBXERR_EOF = System::Int8(0xa);
static const System::Int8 DBXERR_SQLPARAMNOTSET = System::Int8(0xb);
static const System::Int8 DBXERR_INVALIDUSRPASS = System::Int8(0xc);
static const System::Int8 DBXERR_INVALIDPRECISION = System::Int8(0xd);
static const System::Int8 DBXERR_INVALIDLEN = System::Int8(0xe);
static const System::Int8 DBXERR_INVALIDTXNISOLEVEL = System::Int8(0xf);
static const System::Int8 DBXERR_INVALIDTXNID = System::Int8(0x10);
static const System::Int8 DBXERR_DUPLICATETXNID = System::Int8(0x11);
static const System::Int8 DBXERR_DRIVERRESTRICTED = System::Int8(0x12);
static const System::Int8 DBXERR_LOCALTRANSACTIVE = System::Int8(0x13);
static const System::Int8 DBXERR_MULTIPLETRANSNOTENABLED = System::Int8(0x14);
static const System::Int8 DBXERR_CONNECTIONFAILED = System::Int8(0x15);
static const System::Int8 DBXERR_DRIVERINITFAILED = System::Int8(0x16);
static const System::Int8 DBXERR_OPTLOCKFAILED = System::Int8(0x17);
static const System::Int8 DBXERR_INVALIDREF = System::Int8(0x18);
static const System::Int8 DBXERR_NOTABLE = System::Int8(0x19);
static const System::Int8 DBXERR_MISSINGPARAMINSQL = System::Int8(0x1a);
static const System::Int8 DBXERR_NOTIMPLEMENT = System::Int8(0x1b);
static const System::Int8 DBXERR_DRIVERINCOMPATIBLE = System::Int8(0x1c);
static const System::Int8 DBXERR_NODATA = System::Int8(0x64);
static const System::Int8 DBX_MAXSTATICERRORS = System::Int8(0x64);
static const System::Byte MaxReservedStaticErrors = System::Byte(0xff);
static const System::Int8 DBXERR_SQLERROR = System::Int8(0x65);
static const System::Int8 trUNKNOWN = System::Int8(0x0);
static const System::Int8 trQPREPARE = System::Int8(0x1);
static const System::Int8 trQEXECUTE = System::Int8(0x2);
static const System::Int8 trERROR = System::Int8(0x4);
static const System::Int8 trSTMT = System::Int8(0x8);
static const System::Int8 trCONNECT = System::Int8(0x10);
static const System::Int8 trTRANSACT = System::Int8(0x20);
static const System::Int8 trBLOB = System::Int8(0x40);
static const System::Byte trMISC = System::Byte(0x80);
static const System::Word trVENDOR = System::Word(0x100);
static const System::Word trDATAIN = System::Word(0x200);
static const System::Word trDATAOUT = System::Word(0x400);
static const System::Int8 eSQLTable = System::Int8(0x1);
static const System::Int8 eSQLView = System::Int8(0x2);
static const System::Int8 eSQLSystemTable = System::Int8(0x4);
static const System::Int8 eSQLSynonym = System::Int8(0x8);
static const System::Int8 eSQLTempTable = System::Int8(0x10);
static const System::Int8 eSQLLocal = System::Int8(0x20);
static const System::Int8 eSQLProcedure = System::Int8(0x1);
static const System::Int8 eSQLFunction = System::Int8(0x2);
static const System::Int8 eSQLPackage = System::Int8(0x4);
static const System::Int8 eSQLSysProcedure = System::Int8(0x8);
static const System::Int8 eSQLRowId = System::Int8(0x1);
static const System::Int8 eSQLRowVersion = System::Int8(0x2);
static const System::Int8 eSQLAutoIncr = System::Int8(0x4);
static const System::Int8 eSQLDefault = System::Int8(0x8);
static const System::Int8 eSQLNonUnique = System::Int8(0x1);
static const System::Int8 eSQLUnique = System::Int8(0x2);
static const System::Int8 eSQLPrimaryKey = System::Int8(0x4);
static const System::Int8 fldUNKNOWN = System::Int8(0x0);
static const System::Int8 fldZSTRING = System::Int8(0x1);
static const System::Int8 fldDATE = System::Int8(0x2);
static const System::Int8 fldBLOB = System::Int8(0x3);
static const System::Int8 fldBOOL = System::Int8(0x4);
static const System::Int8 fldINT16 = System::Int8(0x5);
static const System::Int8 fldINT32 = System::Int8(0x6);
static const System::Int8 fldFLOAT = System::Int8(0x7);
static const System::Int8 fldBCD = System::Int8(0x8);
static const System::Int8 fldBYTES = System::Int8(0x9);
static const System::Int8 fldTIME = System::Int8(0xa);
static const System::Int8 fldTIMESTAMP = System::Int8(0xb);
static const System::Int8 fldUINT16 = System::Int8(0xc);
static const System::Int8 fldUINT32 = System::Int8(0xd);
static const System::Int8 fldFLOATIEEE = System::Int8(0xe);
static const System::Int8 fldVARBYTES = System::Int8(0xf);
static const System::Int8 fldLOCKINFO = System::Int8(0x10);
static const System::Int8 fldCURSOR = System::Int8(0x11);
static const System::Int8 fldINT64 = System::Int8(0x12);
static const System::Int8 fldUINT64 = System::Int8(0x13);
static const System::Int8 fldADT = System::Int8(0x14);
static const System::Int8 fldARRAY = System::Int8(0x15);
static const System::Int8 fldREF = System::Int8(0x16);
static const System::Int8 fldTABLE = System::Int8(0x17);
static const System::Int8 fldDATETIME = System::Int8(0x18);
static const System::Int8 fldFMTBCD = System::Int8(0x19);
static const System::Int8 fldWIDESTRING = System::Int8(0x1a);
static const System::Int8 MAXLOGFLDTYPES = System::Int8(0x1b);
static const System::Word fldUNICODE = System::Word(0x1007);
static const System::Int8 fldINT8 = System::Int8(0x1c);
static const System::Int8 fldUINT8 = System::Int8(0x1d);
static const System::Int8 fldSINGLE = System::Int8(0x1b);
static const System::Int8 fldDATETIMEOFFSET = System::Int8(0x24);
static const System::Int8 fldstMONEY = System::Int8(0x15);
static const System::Int8 fldstMEMO = System::Int8(0x16);
static const System::Int8 fldstBINARY = System::Int8(0x17);
static const System::Int8 fldstFMTMEMO = System::Int8(0x18);
static const System::Int8 fldstOLEOBJ = System::Int8(0x19);
static const System::Int8 fldstGRAPHIC = System::Int8(0x1a);
static const System::Int8 fldstDBSOLEOBJ = System::Int8(0x1b);
static const System::Int8 fldstTYPEDBINARY = System::Int8(0x1c);
static const System::Int8 fldstACCOLEOBJ = System::Int8(0x1e);
static const System::Int8 fldstWIDEMEMO = System::Int8(0x20);
static const System::Int8 fldstHMEMO = System::Int8(0x21);
static const System::Int8 fldstHBINARY = System::Int8(0x22);
static const System::Int8 fldstBFILE = System::Int8(0x24);
static const System::Int8 fldstPASSWORD = System::Int8(0x1);
static const System::Int8 fldstFIXED = System::Int8(0x1f);
static const System::Int8 fldstGUID = System::Int8(0x26);
static const System::Int8 fldstORAINTERVAL = System::Int8(0x28);
static const System::Int8 fldstAUTOINC = System::Int8(0x1d);
static const System::Int8 fldstADTNestedTable = System::Int8(0x23);
static const System::Int8 fldstADTDATE = System::Int8(0x25);
static const System::Int8 fldstORATIMESTAMP = System::Int8(0x27);
#define SSelect L"select"
#define SSelectStar L" select * "
#define SSelectStarFrom L" select * from "
#define SSelectSpaces L" select "
#define SWhere L" where "
#define SAnd L" and "
#define SOrderBy L" order by "
static const System::WideChar SParam = (System::WideChar)(0x3f);
static const System::Int8 DefaultCursor = System::Int8(0x0);
static const System::Int8 HourGlassCursor = System::Int8(-11);
static const System::Int8 DefaultMaxBlobSize = System::Int8(-1);
static const System::Int8 DefaultRowsetSize = System::Int8(0x14);
static const System::Word TErrorMessageSize = System::Word(0x800);
extern PACKAGE Data::Dbcommon::TFieldMap FldTypeMap;
extern PACKAGE System::StaticArray<System::Word, 52> FldSubTypeMap;
extern PACKAGE System::StaticArray<Data::Db::TFieldType, 27> DataTypeMap;
extern PACKAGE System::StaticArray<Data::Db::TFieldType, 15> BlobTypeMap;
static const System::Byte MAX_VERSION_STRING_LENGTH = System::Byte(0x80);

}	/* namespace Dbxopenodbcdbx3types */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCDBX3TYPES)
using namespace Dbxopenodbcdbx3types;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbcdbx3typesHPP
