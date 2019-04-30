// CodeGear C++Builder
// Copyright (c) 1995, 2011 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OdbcApi.pas' rev: 23.00 (Win32)

#ifndef OdbcapiHPP
#define OdbcapiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.AnsiStrings.hpp>	// Pascal unit
#include <DbxOpenOdbcTypes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.SysConst.hpp>	// Pascal unit
#include <System.SyncObjs.hpp>	// Pascal unit
#include <DbxOpenOdbcFuncs.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#include <sqltypes.h>
#include <sql.h>
#include <sqlext.h>
#include <sqlucode.h>


namespace Odbcapi
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<char, 6> TSqlState;

typedef char * PSqlState;

typedef System::Byte *PSqlChar;

typedef int *PSqlInteger;

typedef void * *PSqlPointer;

typedef short *PSqlSmallint;

typedef System::Word *PSqlUSmallint;

typedef void * *PSqlHandle;

typedef void * *PSqlHEnv;

typedef void * *PSqlHDbc;

typedef void * *PSqlHStmt;

typedef void * *PSqlHDesc;

typedef System::Word *PUWord;

typedef int *PSqlUInteger;

typedef tagDATE_STRUCT *PSqlDateStruct;

typedef tagDATE_STRUCT TSqlDateStruct;

typedef tagTIME_STRUCT *PSqlTimeStruct;

typedef tagTIME_STRUCT TSqlTimeStruct;

typedef tagTIMESTAMP_STRUCT *POdbcTimestamp;

typedef tagTIMESTAMP_STRUCT TOdbcTimestamp;

typedef SqlInterval ESqlInterval;

typedef tagSQL_YEAR_MONTH TSqlYearMonth;

typedef tagSQL_DAY_SECOND TSqlDaySecond;

typedef tagSQL_INTERVAL_STRUCT TSqlInterval;

typedef System::WideChar *PSqlWChar;

typedef short __stdcall (*TSQLAllocConnect)(void * EnvironmentHandle, void * &ConnectionHandle);

typedef short __stdcall (*TSQLAllocEnv)(void * &EnvironmentHandle);

typedef short __stdcall (*TSQLAllocHandle)(short HandleType, void * InputHandle, void * &OutputHandle);

typedef short __stdcall (*TSQLAllocStmt)(void * ConnectionHandle, void * &StatementHandle);

typedef short __stdcall (*TSQLBindCol)(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);

typedef short __stdcall (*TSQLBindParam)(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);

typedef short __stdcall (*TSQLCancel)(void * StatementHandle);

typedef short __stdcall (*TSQLCloseCursor)(void * StatementHandle);

typedef short __stdcall (*TSQLColAttribute)(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);

typedef short __stdcall (*TSQLColAttributeString)(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);

typedef short __stdcall (*TSQLColAttributeInt)(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);

typedef short __stdcall (*TSQLColumns)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);

typedef short __stdcall (*TSQLConnect)(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);

typedef short __stdcall (*TSQLCopyDesc)(void * SourceDescHandle, void * TargetDescHandle);

typedef short __stdcall (*TSQLDataSources)(void * EnvironmentHandle, System::Word Direction, System::Byte &ServerName, short BufferLength1, short &NameLength1, System::Byte &Description, short BufferLength2, short &NameLength2);

typedef short __stdcall (*TSQLDescribeCol)(void * StatementHandle, System::Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);

typedef short __stdcall (*TSQLDisconnect)(void * ConnectionHandle);

typedef short __stdcall (*TSQLEndTran)(short HandleType, void * Handle, short CompletionType);

typedef short __stdcall (*TSQLError)(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, System::Byte &Sqlstate, int &NativeError, System::Byte &MessageText, short BufferLength, short &TextLength);

typedef short __stdcall (*TSQLExecDirect)(void * StatementHandle, char * StatementText, int TextLength);

typedef short __stdcall (*TSQLExecute)(void * StatementHandle);

typedef short __stdcall (*TSQLFetch)(void * StatementHandle);

typedef short __stdcall (*TSQLFetchScroll)(void * StatementHandle, short FetchOrientation, int FetchOffset);

typedef short __stdcall (*TSQLFreeConnect)(void * ConnectionHandle);

typedef short __stdcall (*TSQLFreeEnv)(void * EnvironmentHandle);

typedef short __stdcall (*TSQLFreeHandle)(short HandleType, void * Handle);

typedef short __stdcall (*TSQLFreeStmt)(void * StatementHandle, System::Word Option);

typedef short __stdcall (*TSQLGetConnectAttr)(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);

typedef short __stdcall (*TSQLGetConnectOption)(void * ConnectionHandle, System::Word Option, void * Value);

typedef short __stdcall (*TSQLGetCursorName)(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);

typedef short __stdcall (*TSQLGetData)(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);

typedef short __stdcall (*TSQLGetDescField)(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);

typedef short __stdcall (*TSQLGetDescRec)(void * DescriptorHandle, short RecNumber, System::Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);

typedef short __stdcall (*TSQLGetDiagField)(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);

typedef short __stdcall (*TSQLGetDiagRec)(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);

typedef short __stdcall (*TSQLGetEnvAttr)(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);

typedef short __stdcall (*TSQLGetFunctions)(void * ConnectionHandle, System::Word FunctionId, System::Word &Supported);

typedef short __stdcall (*TSQLGetInfo)(void * ConnectionHandle, System::Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);

typedef short __stdcall (*TSQLGetInfoString)(void * ConnectionHandle, System::Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);

typedef short __stdcall (*TSQLGetInfoSmallint)(void * ConnectionHandle, System::Word InfoType, System::Word &InfoValue, short Ignored1, void * Ignored2);

typedef short __stdcall (*TSQLGetInfoInt)(void * ConnectionHandle, System::Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);

typedef short __stdcall (*TSQLGetStmtAttr)(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);

typedef short __stdcall (*TSQLGetStmtOption)(void * StatementHandle, System::Word Option, void * Value);

typedef short __stdcall (*TSQLGetTypeInfo)(void * StatementHandle, short DataType);

typedef short __stdcall (*TSQLNumResultCols)(void * StatementHandle, short &ColumnCount);

typedef short __stdcall (*TSQLParamData)(void * StatementHandle, void * &Value);

typedef short __stdcall (*TSQLPrepare)(void * StatementHandle, char * StatementText, int TextLength);

typedef short __stdcall (*TSQLPutData)(void * StatementHandle, void * Data, int StrLen_or_Ind);

typedef short __stdcall (*TSQLRowCount)(void * StatementHandle, int &RowCount);

typedef short __stdcall (*TSQLSetConnectAttr)(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);

typedef short __stdcall (*TSQLSetConnectOption)(void * ConnectionHandle, System::Word Option, int Value);

typedef short __stdcall (*TSQLSetCursorName)(void * StatementHandle, char * CursorName, short NameLength);

typedef short __stdcall (*TSQLSetDescField)(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);

typedef short __stdcall (*TSQLSetDescRec)(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);

typedef short __stdcall (*TSQLSetEnvAttr)(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);

typedef short __stdcall (*TSQLSetParam)(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);

typedef short __stdcall (*TSQLSetStmtAttr)(void * StatementHandle, int Attribute, void * Value, int StringLength);

typedef short __stdcall (*TSQLSetStmtOption)(void * StatementHandle, System::Word Option, int Value);

typedef short __stdcall (*TSQLSpecialColumns)(void * StatementHandle, System::Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Scope, System::Word Nullable);

typedef short __stdcall (*TSQLStatistics)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Unique, System::Word Reserved);

typedef short __stdcall (*TSQLTables)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);

typedef short __stdcall (*TSQLTransact)(void * EnvironmentHandle, void * ConnectionHandle, System::Word CompletionType);

typedef short __stdcall (*TSQLDriverConnect)(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, System::Word fDriverCompletion);

typedef short __stdcall (*TSQLBrowseConnect)(void * HDbc, System::Byte &szConnStrIn, short cbConnStrIn, System::Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);

typedef short __stdcall (*TSQLBulkOperations)(void * StatementHandle, short Operation);

typedef short __stdcall (*TSQLColAttributes)(void * HStmt, System::Word icol, System::Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);

typedef short __stdcall (*TSQLColumnPrivileges)(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName, System::Byte &szColumnName, short cbColumnName);

typedef short __stdcall (*TSQLDescribeParam)(void * HStmt, System::Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);

typedef short __stdcall (*TSQLExtendedFetch)(void * HStmt, System::Word fFetchType, int irow, int &pcrow, System::Word &rgfRowStatus);

typedef short __stdcall (*TSQLForeignKeys)(void * HStmt, System::Byte &szPkCatalogName, short cbPkCatalogName, System::Byte &szPkSchemaName, short cbPkSchemaName, System::Byte &szPkTableName, short cbPkTableName, System::Byte &szFkCatalogName, short cbFkCatalogName, System::Byte &szFkSchemaName, short cbFkSchemaName, System::Byte &szFkTableName, short cbFkTableName);

typedef short __stdcall (*TSQLMoreResults)(void * HStmt);

typedef short __stdcall (*TSQLNativeSql)(void * HDbc, System::Byte &szSqlStrIn, int cbSqlStrIn, System::Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);

typedef short __stdcall (*TSQLNumParams)(void * HStmt, short &pcpar);

typedef short __stdcall (*TSQLParamOptions)(void * HStmt, int crow, int &pirow);

typedef short __stdcall (*TSQLPrimaryKeys)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);

typedef short __stdcall (*TSQLProcedureColumns)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);

typedef short __stdcall (*TSQLProcedures)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);

typedef short __stdcall (*TSQLSetPos)(void * HStmt, System::Word irow, System::Word fOption, System::Word fLock);

typedef short __stdcall (*TSQLTablePrivileges)(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName);

typedef short __stdcall (*TSQLDrivers)(void * HEnv, System::Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);

typedef short __stdcall (*TSQLBindParameter)(void * HStmt, System::Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);

typedef short __stdcall (*TSQLAllocHandleStd)(short fHandleType, void * hInput, void * &phOutput);

typedef short __stdcall (*TSQLSetScrollOptions)(void * HStmt, System::Word fConcurrency, int crowKeyset, System::Word crowRowset);

typedef short __stdcall (*TTraceOpenLogFile)(System::WideChar &_1, System::WideChar &_2, int _3);

typedef short __stdcall (*TTraceCloseLogFile)(void);

typedef void __stdcall (*TTraceReturn)(short _1, short _2);

typedef int __stdcall (*TTraceVersion)(void);

typedef short __stdcall (*TTraceVSControl)(int _1);

typedef BOOL __stdcall (*TODBCSetTryWaitValue)(unsigned dwValue);

typedef int __stdcall (*TODBCGetTryWaitValue)(void);

#pragma pack(push,1)
struct DECLSPEC_DRECORD tagODBC_VS_ARGS
{
	
public:
	GUID *PGuidEvent;
	unsigned dwFlags;
	union
	{
		struct 
		{
			System::WideChar *wszCorrelation;
			char *szCorrelation;
			short RetCode2;
			
		};
		struct 
		{
			System::WideChar *wszArg;
			char *szArg;
			short Retcode;
			
		};
		
	};
};
#pragma pack(pop)


typedef tagODBC_VS_ARGS ODBC_VS_ARGS;

typedef tagODBC_VS_ARGS *PODBC_VS_ARGS;

typedef void __stdcall (*TFireVSDebugEvent)(tagODBC_VS_ARGS &Args);

class DELPHICLASS EOdbcApi;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EOdbcApi : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EOdbcApi(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EOdbcApi(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : System::Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EOdbcApi(int Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateResFmt */ inline __fastcall EOdbcApi(int Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EOdbcApi(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EOdbcApi(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOdbcApi(int Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOdbcApi(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EOdbcApi(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EOdbcApiNotImplemented;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EOdbcApiNotImplemented : public EOdbcApi
{
	typedef EOdbcApi inherited;
	
public:
	/* Exception.Create */ inline __fastcall EOdbcApiNotImplemented(const System::UnicodeString Msg) : EOdbcApi(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EOdbcApiNotImplemented(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EOdbcApi(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EOdbcApiNotImplemented(int Ident)/* overload */ : EOdbcApi(Ident) { }
	/* Exception.CreateResFmt */ inline __fastcall EOdbcApiNotImplemented(int Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EOdbcApi(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EOdbcApiNotImplemented(const System::UnicodeString Msg, int AHelpContext) : EOdbcApi(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EOdbcApiNotImplemented(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EOdbcApi(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOdbcApiNotImplemented(int Ident, int AHelpContext)/* overload */ : EOdbcApi(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOdbcApiNotImplemented(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EOdbcApi(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EOdbcApiNotImplemented(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TOdbcApiProxy;
class DELPHICLASS TOdbcApiIntfImpl;
__interface IOdbcApi;
typedef System::DelphiInterface<IOdbcApi> _di_IOdbcApi;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOdbcApiProxy : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::AnsiString fVendorLib;
	System::AnsiString fModuleName;
	int fApiRefCount;
	bool fLockLib;
	bool fSystemODBCManager;
	unsigned hModuleApi;
	System::AnsiString fModuleNameTrac;
	unsigned hModuleApiTrac;
	System::AnsiString fModuleNameInst;
	unsigned hModuleApiInst;
	int fOdbcDriverLevel;
	TOdbcApiIntfImpl* fOdbcApiImpl;
	_di_IOdbcApi fOdbcApiIntf;
	void __fastcall NotImplemented(const System::AnsiString sFuncName, int iLevel = 0x0);
	void __fastcall SetOdbcDriverLevel(int aOdbcDriverLevel);
	void __fastcall BeginLock(void);
	void __fastcall EndLock(void);
	
public:
	__fastcall virtual ~TOdbcApiProxy(void);
	System::_di_IInterface __fastcall GetOdbcApiIntf(void);
	__property bool SystemODBCManager = {read=fSystemODBCManager, default=0};
	__property int OdbcDriverLevel = {read=fOdbcDriverLevel, write=SetOdbcDriverLevel, nodefault};
	__property System::AnsiString VendorLib = {read=fVendorLib};
	__property System::AnsiString ModuleName = {read=fModuleName};
	TSQLAllocConnect SQLAllocConnectA;
	TSQLAllocEnv SQLAllocEnvA;
	TSQLAllocHandle SQLAllocHandleA;
	TSQLAllocStmt SQLAllocStmtA;
	TSQLBindCol SQLBindColA;
	TSQLBindParam SQLBindParamA;
	TSQLCancel SQLCancelA;
	TSQLCloseCursor SQLCloseCursorA;
	TSQLColAttribute SQLColAttributeA;
	TSQLColumns SQLColumnsA;
	TSQLConnect SQLConnectA;
	TSQLCopyDesc SQLCopyDescA;
	TSQLDataSources SQLDataSourcesA;
	TSQLDescribeCol SQLDescribeColA;
	TSQLDisconnect SQLDisconnectA;
	TSQLEndTran SQLEndTranA;
	TSQLError SQLErrorA;
	TSQLExecDirect SQLExecDirectA;
	TSQLExecute SQLExecuteA;
	TSQLFetch SQLFetchA;
	TSQLFetchScroll SQLFetchScrollA;
	TSQLFreeConnect SQLFreeConnectA;
	TSQLFreeEnv SQLFreeEnvA;
	TSQLFreeHandle SQLFreeHandleA;
	TSQLFreeStmt SQLFreeStmtA;
	TSQLGetConnectAttr SQLGetConnectAttrA;
	TSQLGetConnectOption SQLGetConnectOptionA;
	TSQLGetCursorName SQLGetCursorNameA;
	TSQLGetData SQLGetDataA;
	TSQLGetDescField SQLGetDescFieldA;
	TSQLGetDescRec SQLGetDescRecA;
	TSQLGetDiagField SQLGetDiagFieldA;
	TSQLGetDiagRec SQLGetDiagRecA;
	TSQLGetEnvAttr SQLGetEnvAttrA;
	TSQLGetFunctions SQLGetFunctionsA;
	TSQLGetInfo SQLGetInfoA;
	TSQLGetStmtAttr SQLGetStmtAttrA;
	TSQLGetStmtOption SQLGetStmtOptionA;
	TSQLGetTypeInfo SQLGetTypeInfoA;
	TSQLNumResultCols SQLNumResultColsA;
	TSQLParamData SQLParamDataA;
	TSQLPrepare SQLPrepareA;
	TSQLPutData SQLPutDataA;
	TSQLRowCount SQLRowCountA;
	TSQLSetConnectAttr SQLSetConnectAttrA;
	TSQLSetConnectOption SQLSetConnectOptionA;
	TSQLSetCursorName SQLSetCursorNameA;
	TSQLSetDescField SQLSetDescFieldA;
	TSQLSetDescRec SQLSetDescRecA;
	TSQLSetEnvAttr SQLSetEnvAttrA;
	TSQLSetParam SQLSetParamA;
	TSQLSetStmtAttr SQLSetStmtAttrA;
	TSQLSetStmtOption SQLSetStmtOptionA;
	TSQLSpecialColumns SQLSpecialColumnsA;
	TSQLStatistics SQLStatisticsA;
	TSQLTables SQLTablesA;
	TSQLTransact SQLTransactA;
	TSQLDriverConnect SQLDriverConnectA;
	TSQLBrowseConnect SQLBrowseConnectA;
	TSQLBulkOperations SQLBulkOperationsA;
	TSQLColAttributes SQLColAttributesA;
	TSQLColumnPrivileges SQLColumnPrivilegesA;
	TSQLDescribeParam SQLDescribeParamA;
	TSQLExtendedFetch SQLExtendedFetchA;
	TSQLForeignKeys SQLForeignKeysA;
	TSQLMoreResults SQLMoreResultsA;
	TSQLNativeSql SQLNativeSqlA;
	TSQLNumParams SQLNumParamsA;
	TSQLParamOptions SQLParamOptionsA;
	TSQLPrimaryKeys SQLPrimaryKeysA;
	TSQLProcedureColumns SQLProcedureColumnsA;
	TSQLProcedures SQLProceduresA;
	TSQLSetPos SQLSetPosA;
	TSQLTablePrivileges SQLTablePrivilegesA;
	TSQLDrivers SQLDriversA;
	TSQLBindParameter SQLBindParameterA;
	TSQLAllocHandleStd SQLAllocHandleStdA;
	TSQLSetScrollOptions SQLSetScrollOptionsA;
	TTraceOpenLogFile TraceOpenLogFileA;
	TTraceCloseLogFile TraceCloseLogFileA;
	TTraceReturn TraceReturnA;
	TTraceVersion TraceVersionA;
	TTraceVSControl TraceVSControlA;
	TFireVSDebugEvent FireVSDebugEventA;
	TODBCSetTryWaitValue ODBCSetTryWaitValueA;
	TODBCGetTryWaitValue ODBCGetTryWaitValueA;
	TSQLColAttribute SQLColAttributeW;
	TSQLColumns SQLColumnsW;
	TSQLConnect SQLConnectW;
	TSQLDataSources SQLDataSourcesW;
	TSQLDescribeCol SQLDescribeColW;
	TSQLError SQLErrorW;
	TSQLExecDirect SQLExecDirectW;
	TSQLGetConnectAttr SQLGetConnectAttrW;
	TSQLGetConnectOption SQLGetConnectOptionW;
	TSQLGetCursorName SQLGetCursorNameW;
	TSQLGetDescField SQLGetDescFieldW;
	TSQLGetDescRec SQLGetDescRecW;
	TSQLGetDiagField SQLGetDiagFieldW;
	TSQLGetDiagRec SQLGetDiagRecW;
	TSQLGetInfo SQLGetInfoW;
	TSQLGetStmtAttr SQLGetStmtAttrW;
	TSQLGetTypeInfo SQLGetTypeInfoW;
	TSQLPrepare SQLPrepareW;
	TSQLRowCount SQLRowCountW;
	TSQLSetConnectAttr SQLSetConnectAttrW;
	TSQLSetConnectOption SQLSetConnectOptionW;
	TSQLSetCursorName SQLSetCursorNameW;
	TSQLSetDescField SQLSetDescFieldW;
	TSQLSetStmtAttr SQLSetStmtAttrW;
	TSQLSpecialColumns SQLSpecialColumnsW;
	TSQLStatistics SQLStatisticsW;
	TSQLTables SQLTablesW;
	TSQLDriverConnect SQLDriverConnectW;
	TSQLBrowseConnect SQLBrowseConnectW;
	TSQLColAttributes SQLColAttributesW;
	TSQLColumnPrivileges SQLColumnPrivilegesW;
	TSQLForeignKeys SQLForeignKeysW;
	TSQLNativeSql SQLNativeSqlW;
	TSQLPrimaryKeys SQLPrimaryKeysW;
	TSQLProcedureColumns SQLProcedureColumnsW;
	TSQLProcedures SQLProceduresW;
	TSQLTablePrivileges SQLTablePrivilegesW;
	TSQLDrivers SQLDriversW;
	TSQLSetScrollOptions SQLSetScrollOptionsW;
	__classmethod int __fastcall SQL_LEN_DATA_AT_EXEC(int length);
	__classmethod int __fastcall SQL_LEN_BINARY_ATTR(int length);
	__classmethod int __fastcall SQL_FUNC_EXISTS(PUWord pfExists, System::Word uwAPI);
	short __fastcall SQL_POSITION_TO(void * HStmt, System::Word irow);
	short __fastcall SQL_LOCK_RECORD(void * HStmt, System::Word irow, System::Word fLock);
	short __fastcall SQL_REFRESH_RECORD(void * HStmt, System::Word irow, System::Word fLock);
	short __fastcall SQL_UPDATE_RECORD(void * HStmt, System::Word irow);
	short __fastcall SQL_DELETE_RECORD(void * HStmt, System::Word irow);
	short __fastcall SQL_ADD_RECORD(void * HStmt, System::Word irow);
	bool __fastcall SQLFunctionSupported(void * ConnectionHandle, System::Word FunctionId);
	short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle);
	short __fastcall SQLAllocEnv(void * &EnvironmentHandle);
	short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle);
	short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle);
	short __fastcall SQLBindCol(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLBindParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLCancel(void * StatementHandle);
	short __fastcall SQLCloseCursor(void * StatementHandle);
	short __fastcall SQLColAttribute(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);
	short __fastcall SQLColAttributeString(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);
	short __fastcall SQLColAttributeInt(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);
	short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);
	short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);
	short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle);
	short __fastcall SQLDataSources(void * EnvironmentHandle, System::Word Direction, System::Byte &ServerName, short BufferLength1, short &NameLength1, System::Byte &Description, short BufferLength2, short &NameLength2);
	short __fastcall SQLDescribeCol(void * StatementHandle, System::Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);
	short __fastcall SQLDisconnect(void * ConnectionHandle);
	short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType);
	short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, System::Byte &Sqlstate, int &NativeError, System::Byte &MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLExecute(void * StatementHandle);
	short __fastcall SQLFetch(void * StatementHandle);
	short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset);
	short __fastcall SQLFreeConnect(void * ConnectionHandle);
	short __fastcall SQLFreeEnv(void * EnvironmentHandle);
	short __fastcall SQLFreeHandle(short HandleType, void * Handle);
	short __fastcall SQLFreeStmt(void * StatementHandle, System::Word Option);
	short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);
	short __fastcall SQLGetConnectOption(void * ConnectionHandle, System::Word Option, void * Value);
	short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);
	short __fastcall SQLGetData(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, System::Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);
	short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);
	short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetFunctions(void * ConnectionHandle, System::Word FunctionId, System::Word &Supported);
	short __fastcall SQLGetInfo(void * ConnectionHandle, System::Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);
	short __fastcall SQLGetInfoString(void * ConnectionHandle, System::Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);
	short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, System::Word InfoType, System::Word &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetInfoInt(void * ConnectionHandle, System::Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);
	short __fastcall SQLGetStmtOption(void * StatementHandle, System::Word Option, void * Value);
	short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType);
	short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount);
	short __fastcall SQLParamData(void * StatementHandle, void * &Value);
	short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind);
	short __fastcall SQLRowCount(void * StatementHandle, int &RowCount);
	short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetConnectOption(void * ConnectionHandle, System::Word Option, int Value);
	short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength);
	short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);
	short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);
	short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength);
	short __fastcall SQLSetStmtOption(void * StatementHandle, System::Word Option, int Value);
	short __fastcall SQLSpecialColumns(void * StatementHandle, System::Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Scope, System::Word Nullable);
	short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Unique, System::Word Reserved);
	short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);
	short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, System::Word CompletionType);
	short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, System::Word fDriverCompletion);
	short __fastcall SQLBrowseConnect(void * HDbc, System::Byte &szConnStrIn, short cbConnStrIn, System::Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);
	short __fastcall SQLBulkOperations(void * StatementHandle, short Operation);
	short __fastcall SQLColAttributes(void * HStmt, System::Word icol, System::Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);
	short __fastcall SQLColumnPrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName, System::Byte &szColumnName, short cbColumnName);
	short __fastcall SQLDescribeParam(void * HStmt, System::Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);
	short __fastcall SQLExtendedFetch(void * HStmt, System::Word fFetchType, int irow, int &pcrow, System::Word &rgfRowStatus);
	short __fastcall SQLForeignKeys(void * HStmt, System::Byte &szPkCatalogName, short cbPkCatalogName, System::Byte &szPkSchemaName, short cbPkSchemaName, System::Byte &szPkTableName, short cbPkTableName, System::Byte &szFkCatalogName, short cbFkCatalogName, System::Byte &szFkSchemaName, short cbFkSchemaName, System::Byte &szFkTableName, short cbFkTableName);
	short __fastcall SQLMoreResults(void * HStmt);
	short __fastcall SQLNativeSql(void * HDbc, System::Byte &szSqlStrIn, int cbSqlStrIn, System::Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);
	short __fastcall SQLNumParams(void * HStmt, short &pcpar);
	short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow);
	short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);
	short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);
	short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);
	short __fastcall SQLSetPos(void * HStmt, System::Word irow, System::Word fOption, System::Word fLock);
	short __fastcall SQLTablePrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName);
	short __fastcall SQLDrivers(void * HEnv, System::Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);
	short __fastcall SQLBindParameter(void * HStmt, System::Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);
	short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput);
	short __fastcall SQLSetScrollOptions(void * HStmt, System::Word fConcurrency, int crowKeyset, System::Word crowRowset);
	short __fastcall TraceOpenLogFile(System::WideChar &_1, System::WideChar &_2, int _3);
	short __fastcall TraceCloseLogFile(void);
	void __fastcall TraceReturn(short _1, short _2);
	int __fastcall TraceVersion(void);
	short __fastcall TraceVSControl(int _1);
	void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args);
	bool __fastcall ODBCSetTryWaitValue(unsigned dwValue);
	int __fastcall ODBCGetTryWaitValue(void);
public:
	/* TObject.Create */ inline __fastcall TOdbcApiProxy(void) : System::TObject() { }
	
};

#pragma pack(pop)

__interface  INTERFACE_UUID("{6DA86068-0BC3-4BFC-B9FC-FF8FEC5CD106}") IOdbcApi  : public System::IInterface 
{
	
public:
	virtual int __fastcall SQL_LEN_DATA_AT_EXEC(int length) = 0 ;
	virtual int __fastcall SQL_LEN_BINARY_ATTR(int length) = 0 ;
	virtual int __fastcall SQL_FUNC_EXISTS(PUWord pfExists, System::Word uwAPI) = 0 ;
	virtual short __fastcall SQL_POSITION_TO(void * HStmt, System::Word irow) = 0 ;
	virtual short __fastcall SQL_LOCK_RECORD(void * HStmt, System::Word irow, System::Word fLock) = 0 ;
	virtual short __fastcall SQL_REFRESH_RECORD(void * HStmt, System::Word irow, System::Word fLock) = 0 ;
	virtual short __fastcall SQL_UPDATE_RECORD(void * HStmt, System::Word irow) = 0 ;
	virtual short __fastcall SQL_DELETE_RECORD(void * HStmt, System::Word irow) = 0 ;
	virtual short __fastcall SQL_ADD_RECORD(void * HStmt, System::Word irow) = 0 ;
	virtual bool __fastcall SQLFunctionSupported(void * ConnectionHandle, System::Word FunctionId) = 0 ;
	virtual short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle) = 0 ;
	virtual short __fastcall SQLAllocEnv(void * &EnvironmentHandle) = 0 ;
	virtual short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle) = 0 ;
	virtual short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle) = 0 ;
	virtual short __fastcall SQLBindCol(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLBindParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLCancel(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLCloseCursor(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLColAttribute(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr) = 0 ;
	virtual short __fastcall SQLColAttributeString(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute) = 0 ;
	virtual short __fastcall SQLColAttributeInt(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute) = 0 ;
	virtual short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4) = 0 ;
	virtual short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3) = 0 ;
	virtual short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle) = 0 ;
	virtual short __fastcall SQLDataSources(void * EnvironmentHandle, System::Word Direction, System::Byte &ServerName, short BufferLength1, short &NameLength1, System::Byte &Description, short BufferLength2, short &NameLength2) = 0 ;
	virtual short __fastcall SQLDescribeCol(void * StatementHandle, System::Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable) = 0 ;
	virtual short __fastcall SQLDisconnect(void * ConnectionHandle) = 0 ;
	virtual short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType) = 0 ;
	virtual short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, System::Byte &Sqlstate, int &NativeError, System::Byte &MessageText, short BufferLength, short &TextLength) = 0 ;
	virtual short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength) = 0 ;
	virtual short __fastcall SQLExecute(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLFetch(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset) = 0 ;
	virtual short __fastcall SQLFreeConnect(void * ConnectionHandle) = 0 ;
	virtual short __fastcall SQLFreeEnv(void * EnvironmentHandle) = 0 ;
	virtual short __fastcall SQLFreeHandle(short HandleType, void * Handle) = 0 ;
	virtual short __fastcall SQLFreeStmt(void * StatementHandle, System::Word Option) = 0 ;
	virtual short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength) = 0 ;
	virtual short __fastcall SQLGetConnectOption(void * ConnectionHandle, System::Word Option, void * Value) = 0 ;
	virtual short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength) = 0 ;
	virtual short __fastcall SQLGetData(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength) = 0 ;
	virtual short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, System::Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable) = 0 ;
	virtual short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength) = 0 ;
	virtual short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength) = 0 ;
	virtual short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength) = 0 ;
	virtual short __fastcall SQLGetFunctions(void * ConnectionHandle, System::Word FunctionId, System::Word &Supported) = 0 ;
	virtual short __fastcall SQLGetInfo(void * ConnectionHandle, System::Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr) = 0 ;
	virtual short __fastcall SQLGetInfoString(void * ConnectionHandle, System::Word InfoType, char * InfoValueString, short BufferLength, short &StringLength) = 0 ;
	virtual short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, System::Word InfoType, System::Word &InfoValue, short Ignored1, void * Ignored2) = 0 ;
	virtual short __fastcall SQLGetInfoInt(void * ConnectionHandle, System::Word InfoType, int &InfoValue, short Ignored1, void * Ignored2) = 0 ;
	virtual short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength) = 0 ;
	virtual short __fastcall SQLGetStmtOption(void * StatementHandle, System::Word Option, void * Value) = 0 ;
	virtual short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType) = 0 ;
	virtual short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount) = 0 ;
	virtual short __fastcall SQLParamData(void * StatementHandle, void * &Value) = 0 ;
	virtual short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength) = 0 ;
	virtual short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLRowCount(void * StatementHandle, int &RowCount) = 0 ;
	virtual short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength) = 0 ;
	virtual short __fastcall SQLSetConnectOption(void * ConnectionHandle, System::Word Option, int Value) = 0 ;
	virtual short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength) = 0 ;
	virtual short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength) = 0 ;
	virtual short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator) = 0 ;
	virtual short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength) = 0 ;
	virtual short __fastcall SQLSetParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength) = 0 ;
	virtual short __fastcall SQLSetStmtOption(void * StatementHandle, System::Word Option, int Value) = 0 ;
	virtual short __fastcall SQLSpecialColumns(void * StatementHandle, System::Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Scope, System::Word Nullable) = 0 ;
	virtual short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Unique, System::Word Reserved) = 0 ;
	virtual short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4) = 0 ;
	virtual short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, System::Word CompletionType) = 0 ;
	virtual short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, System::Word fDriverCompletion) = 0 ;
	virtual short __fastcall SQLBrowseConnect(void * HDbc, System::Byte &szConnStrIn, short cbConnStrIn, System::Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut) = 0 ;
	virtual short __fastcall SQLBulkOperations(void * StatementHandle, short Operation) = 0 ;
	virtual short __fastcall SQLColAttributes(void * HStmt, System::Word icol, System::Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc) = 0 ;
	virtual short __fastcall SQLColumnPrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName, System::Byte &szColumnName, short cbColumnName) = 0 ;
	virtual short __fastcall SQLDescribeParam(void * HStmt, System::Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable) = 0 ;
	virtual short __fastcall SQLExtendedFetch(void * HStmt, System::Word fFetchType, int irow, int &pcrow, System::Word &rgfRowStatus) = 0 ;
	virtual short __fastcall SQLForeignKeys(void * HStmt, System::Byte &szPkCatalogName, short cbPkCatalogName, System::Byte &szPkSchemaName, short cbPkSchemaName, System::Byte &szPkTableName, short cbPkTableName, System::Byte &szFkCatalogName, short cbFkCatalogName, System::Byte &szFkSchemaName, short cbFkSchemaName, System::Byte &szFkTableName, short cbFkTableName) = 0 ;
	virtual short __fastcall SQLMoreResults(void * HStmt) = 0 ;
	virtual short __fastcall SQLNativeSql(void * HDbc, System::Byte &szSqlStrIn, int cbSqlStrIn, System::Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr) = 0 ;
	virtual short __fastcall SQLNumParams(void * HStmt, short &pcpar) = 0 ;
	virtual short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow) = 0 ;
	virtual short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName) = 0 ;
	virtual short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName) = 0 ;
	virtual short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName) = 0 ;
	virtual short __fastcall SQLSetPos(void * HStmt, System::Word irow, System::Word fOption, System::Word fLock) = 0 ;
	virtual short __fastcall SQLTablePrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName) = 0 ;
	virtual short __fastcall SQLDrivers(void * HEnv, System::Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr) = 0 ;
	virtual short __fastcall SQLBindParameter(void * HStmt, System::Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue) = 0 ;
	virtual short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput) = 0 ;
	virtual short __fastcall SQLSetScrollOptions(void * HStmt, System::Word fConcurrency, int crowKeyset, System::Word crowRowset) = 0 ;
	virtual short __fastcall TraceOpenLogFile(System::WideChar &_1, System::WideChar &_2, int _3) = 0 ;
	virtual short __fastcall TraceCloseLogFile(void) = 0 ;
	virtual void __fastcall TraceReturn(short _1, short _2) = 0 ;
	virtual int __fastcall TraceVersion(void) = 0 ;
	virtual short __fastcall TraceVSControl(int _1) = 0 ;
	virtual void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args) = 0 ;
	virtual bool __fastcall ODBCSetTryWaitValue(unsigned dwValue) = 0 ;
	virtual int __fastcall ODBCGetTryWaitValue(void) = 0 ;
};

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOdbcApiIntfImpl : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
private:
	TOdbcApiProxy* fOdbcApiProxy;
	void __fastcall CheckAvailableProxy(void);
	
protected:
	int __fastcall SQL_LEN_DATA_AT_EXEC(int length);
	int __fastcall SQL_LEN_BINARY_ATTR(int length);
	int __fastcall SQL_FUNC_EXISTS(PUWord pfExists, System::Word uwAPI);
	short __fastcall SQL_POSITION_TO(void * HStmt, System::Word irow);
	short __fastcall SQL_LOCK_RECORD(void * HStmt, System::Word irow, System::Word fLock);
	short __fastcall SQL_REFRESH_RECORD(void * HStmt, System::Word irow, System::Word fLock);
	short __fastcall SQL_UPDATE_RECORD(void * HStmt, System::Word irow);
	short __fastcall SQL_DELETE_RECORD(void * HStmt, System::Word irow);
	short __fastcall SQL_ADD_RECORD(void * HStmt, System::Word irow);
	bool __fastcall SQLFunctionSupported(void * ConnectionHandle, System::Word FunctionId);
	short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle);
	short __fastcall SQLAllocEnv(void * &EnvironmentHandle);
	short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle);
	short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle);
	short __fastcall SQLBindCol(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLBindParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLCancel(void * StatementHandle);
	short __fastcall SQLCloseCursor(void * StatementHandle);
	short __fastcall SQLColAttribute(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);
	short __fastcall SQLColAttributeString(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);
	short __fastcall SQLColAttributeInt(void * StatementHandle, System::Word ColumnNumber, System::Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);
	short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);
	short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);
	short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle);
	short __fastcall SQLDataSources(void * EnvironmentHandle, System::Word Direction, System::Byte &ServerName, short BufferLength1, short &NameLength1, System::Byte &Description, short BufferLength2, short &NameLength2);
	short __fastcall SQLDescribeCol(void * StatementHandle, System::Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);
	short __fastcall SQLDisconnect(void * ConnectionHandle);
	short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType);
	short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, System::Byte &Sqlstate, int &NativeError, System::Byte &MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLExecute(void * StatementHandle);
	short __fastcall SQLFetch(void * StatementHandle);
	short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset);
	short __fastcall SQLFreeConnect(void * ConnectionHandle);
	short __fastcall SQLFreeEnv(void * EnvironmentHandle);
	short __fastcall SQLFreeHandle(short HandleType, void * Handle);
	short __fastcall SQLFreeStmt(void * StatementHandle, System::Word Option);
	short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);
	short __fastcall SQLGetConnectOption(void * ConnectionHandle, System::Word Option, void * Value);
	short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);
	short __fastcall SQLGetData(void * StatementHandle, System::Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, System::Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);
	short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);
	short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetFunctions(void * ConnectionHandle, System::Word FunctionId, System::Word &Supported);
	short __fastcall SQLGetInfo(void * ConnectionHandle, System::Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);
	short __fastcall SQLGetInfoString(void * ConnectionHandle, System::Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);
	short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, System::Word InfoType, System::Word &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetInfoInt(void * ConnectionHandle, System::Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);
	short __fastcall SQLGetStmtOption(void * StatementHandle, System::Word Option, void * Value);
	short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType);
	short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount);
	short __fastcall SQLParamData(void * StatementHandle, void * &Value);
	short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind);
	short __fastcall SQLRowCount(void * StatementHandle, int &RowCount);
	short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetConnectOption(void * ConnectionHandle, System::Word Option, int Value);
	short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength);
	short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);
	short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);
	short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetParam(void * StatementHandle, System::Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength);
	short __fastcall SQLSetStmtOption(void * StatementHandle, System::Word Option, int Value);
	short __fastcall SQLSpecialColumns(void * StatementHandle, System::Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Scope, System::Word Nullable);
	short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, System::Word Unique, System::Word Reserved);
	short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);
	short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, System::Word CompletionType);
	short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, System::Word fDriverCompletion);
	short __fastcall SQLBrowseConnect(void * HDbc, System::Byte &szConnStrIn, short cbConnStrIn, System::Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);
	short __fastcall SQLBulkOperations(void * StatementHandle, short Operation);
	short __fastcall SQLColAttributes(void * HStmt, System::Word icol, System::Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);
	short __fastcall SQLColumnPrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName, System::Byte &szColumnName, short cbColumnName);
	short __fastcall SQLDescribeParam(void * HStmt, System::Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);
	short __fastcall SQLExtendedFetch(void * HStmt, System::Word fFetchType, int irow, int &pcrow, System::Word &rgfRowStatus);
	short __fastcall SQLForeignKeys(void * HStmt, System::Byte &szPkCatalogName, short cbPkCatalogName, System::Byte &szPkSchemaName, short cbPkSchemaName, System::Byte &szPkTableName, short cbPkTableName, System::Byte &szFkCatalogName, short cbFkCatalogName, System::Byte &szFkSchemaName, short cbFkSchemaName, System::Byte &szFkTableName, short cbFkTableName);
	short __fastcall SQLMoreResults(void * HStmt);
	short __fastcall SQLNativeSql(void * HDbc, System::Byte &szSqlStrIn, int cbSqlStrIn, System::Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);
	short __fastcall SQLNumParams(void * HStmt, short &pcpar);
	short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow);
	short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);
	short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);
	short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);
	short __fastcall SQLSetPos(void * HStmt, System::Word irow, System::Word fOption, System::Word fLock);
	short __fastcall SQLTablePrivileges(void * HStmt, System::Byte &szCatalogName, short cbCatalogName, System::Byte &szSchemaName, short cbSchemaName, System::Byte &szTableName, short cbTableName);
	short __fastcall SQLDrivers(void * HEnv, System::Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);
	short __fastcall SQLBindParameter(void * HStmt, System::Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);
	short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput);
	short __fastcall SQLSetScrollOptions(void * HStmt, System::Word fConcurrency, int crowKeyset, System::Word crowRowset);
	short __fastcall TraceOpenLogFile(System::WideChar &_1, System::WideChar &_2, int _3);
	short __fastcall TraceCloseLogFile(void);
	void __fastcall TraceReturn(short _1, short _2);
	int __fastcall TraceVersion(void);
	short __fastcall TraceVSControl(int _1);
	void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args);
	bool __fastcall ODBCSetTryWaitValue(unsigned dwValue);
	int __fastcall ODBCGetTryWaitValue(void);
public:
	/* TObject.Create */ inline __fastcall TOdbcApiIntfImpl(void) : System::TInterfacedObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TOdbcApiIntfImpl(void) { }
	
private:
	void *__IOdbcApi;	/* IOdbcApi */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator _di_IOdbcApi()
	{
		_di_IOdbcApi intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator IOdbcApi*(void) { return (IOdbcApi*)&__IOdbcApi; }
	#endif
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 SQL_NULL_DATA = System::Int8(-1);
static const System::Int8 SQL_DATA_AT_EXEC = System::Int8(-2);
static const System::Int8 SQL_SUCCESS = System::Int8(0x0);
static const System::Int8 SQL_SUCCESS_WITH_INFO = System::Int8(0x1);
static const System::Int8 SQL_NO_DATA = System::Int8(0x64);
static const System::Int8 SQL_ERROR = System::Int8(-1);
static const System::Int8 SQL_INVALID_HANDLE = System::Int8(-2);
static const System::Int8 SQL_STILL_EXECUTING = System::Int8(0x2);
static const System::Int8 SQL_NEED_DATA = System::Int8(0x63);
static const System::Int8 SQL_NTS = System::Int8(-3);
static const System::Int8 SQL_NTSL = System::Int8(-3);
static const System::Word SQL_MAX_MESSAGE_LENGTH = System::Word(0x200);
static const System::Int8 SQL_DATE_LEN = System::Int8(0xa);
static const System::Int8 SQL_TIME_LEN = System::Int8(0x8);
static const System::Int8 SQL_TIMESTAMP_LEN = System::Int8(0x13);
static const System::Int8 SQL_HANDLE_ENV = System::Int8(0x1);
static const System::Int8 SQL_HANDLE_DBC = System::Int8(0x2);
static const System::Int8 SQL_HANDLE_STMT = System::Int8(0x3);
static const System::Int8 SQL_HANDLE_DESC = System::Int8(0x4);
static const System::Word SQL_ATTR_OUTPUT_NTS = System::Word(0x2711);
static const System::Word SQL_ATTR_AUTO_IPD = System::Word(0x2711);
static const System::Word SQL_ATTR_METADATA_ID = System::Word(0x271e);
static const System::Word SQL_ATTR_APP_ROW_DESC = System::Word(0x271a);
static const System::Word SQL_ATTR_APP_PARAM_DESC = System::Word(0x271b);
static const System::Word SQL_ATTR_IMP_ROW_DESC = System::Word(0x271c);
static const System::Word SQL_ATTR_IMP_PARAM_DESC = System::Word(0x271d);
static const System::Int8 SQL_ATTR_CURSOR_SCROLLABLE = System::Int8(-1);
static const System::Int8 SQL_ATTR_CURSOR_SENSITIVITY = System::Int8(-2);
static const System::Int8 SQL_NONSCROLLABLE = System::Int8(0x0);
static const System::Int8 SQL_SCROLLABLE = System::Int8(0x1);
static const System::Word SQL_DESC_COUNT = System::Word(0x3e9);
static const System::Word SQL_DESC_TYPE = System::Word(0x3ea);
static const System::Word SQL_DESC_LENGTH = System::Word(0x3eb);
static const System::Word SQL_DESC_OCTET_LENGTH_PTR = System::Word(0x3ec);
static const System::Word SQL_DESC_PRECISION = System::Word(0x3ed);
static const System::Word SQL_DESC_SCALE = System::Word(0x3ee);
static const System::Word SQL_DESC_DATETIME_INTERVAL_CODE = System::Word(0x3ef);
static const System::Word SQL_DESC_NULLABLE = System::Word(0x3f0);
static const System::Word SQL_DESC_INDICATOR_PTR = System::Word(0x3f1);
static const System::Word SQL_DESC_DATA_PTR = System::Word(0x3f2);
static const System::Word SQL_DESC_NAME = System::Word(0x3f3);
static const System::Word SQL_DESC_UNNAMED = System::Word(0x3f4);
static const System::Word SQL_DESC_OCTET_LENGTH = System::Word(0x3f5);
static const System::Word SQL_DESC_ALLOC_TYPE = System::Word(0x44b);
static const System::Int8 SQL_DIAG_RETURNCODE = System::Int8(0x1);
static const System::Int8 SQL_DIAG_NUMBER = System::Int8(0x2);
static const System::Int8 SQL_DIAG_ROW_COUNT = System::Int8(0x3);
static const System::Int8 SQL_DIAG_SQLSTATE = System::Int8(0x4);
static const System::Int8 SQL_DIAG_NATIVE = System::Int8(0x5);
static const System::Int8 SQL_DIAG_MESSAGE_TEXT = System::Int8(0x6);
static const System::Int8 SQL_DIAG_DYNAMIC_FUNCTION = System::Int8(0x7);
static const System::Int8 SQL_DIAG_CLASS_ORIGIN = System::Int8(0x8);
static const System::Int8 SQL_DIAG_SUBCLASS_ORIGIN = System::Int8(0x9);
static const System::Int8 SQL_DIAG_CONNECTION_NAME = System::Int8(0xa);
static const System::Int8 SQL_DIAG_SERVER_NAME = System::Int8(0xb);
static const System::Int8 SQL_DIAG_DYNAMIC_FUNCTION_CODE = System::Int8(0xc);
static const System::Int8 SQL_DIAG_ALTER_DOMAIN = System::Int8(0x3);
static const System::Int8 SQL_DIAG_ALTER_TABLE = System::Int8(0x4);
static const System::Int8 SQL_DIAG_CALL = System::Int8(0x7);
static const System::Int8 SQL_DIAG_CREATE_ASSERTION = System::Int8(0x6);
static const System::Int8 SQL_DIAG_CREATE_CHARACTER_SET = System::Int8(0x8);
static const System::Int8 SQL_DIAG_CREATE_COLLATION = System::Int8(0xa);
static const System::Int8 SQL_DIAG_CREATE_DOMAIN = System::Int8(0x17);
static const System::Int8 SQL_DIAG_CREATE_INDEX = System::Int8(-1);
static const System::Int8 SQL_DIAG_CREATE_SCHEMA = System::Int8(0x40);
static const System::Int8 SQL_DIAG_CREATE_TABLE = System::Int8(0x4d);
static const System::Int8 SQL_DIAG_CREATE_TRANSLATION = System::Int8(0x4f);
static const System::Int8 SQL_DIAG_CREATE_VIEW = System::Int8(0x54);
static const System::Int8 SQL_DIAG_DELETE_WHERE = System::Int8(0x13);
static const System::Int8 SQL_DIAG_DROP_ASSERTION = System::Int8(0x18);
static const System::Int8 SQL_DIAG_DROP_CHARACTER_SET = System::Int8(0x19);
static const System::Int8 SQL_DIAG_DROP_COLLATION = System::Int8(0x1a);
static const System::Int8 SQL_DIAG_DROP_DOMAIN = System::Int8(0x1b);
static const System::Int8 SQL_DIAG_DROP_INDEX = System::Int8(-2);
static const System::Int8 SQL_DIAG_DROP_SCHEMA = System::Int8(0x1f);
static const System::Int8 SQL_DIAG_DROP_TABLE = System::Int8(0x20);
static const System::Int8 SQL_DIAG_DROP_TRANSLATION = System::Int8(0x21);
static const System::Int8 SQL_DIAG_DROP_VIEW = System::Int8(0x24);
static const System::Int8 SQL_DIAG_DYNAMIC_DELETE_CURSOR = System::Int8(0x26);
static const System::Int8 SQL_DIAG_DYNAMIC_UPDATE_CURSOR = System::Int8(0x51);
static const System::Int8 SQL_DIAG_GRANT = System::Int8(0x30);
static const System::Int8 SQL_DIAG_INSERT = System::Int8(0x32);
static const System::Int8 SQL_DIAG_REVOKE = System::Int8(0x3b);
static const System::Int8 SQL_DIAG_SELECT_CURSOR = System::Int8(0x55);
static const System::Int8 SQL_DIAG_UNKNOWN_STATEMENT = System::Int8(0x0);
static const System::Int8 SQL_DIAG_UPDATE_WHERE = System::Int8(0x52);
static const System::Int8 SQL_UNKNOWN_TYPE = System::Int8(0x0);
static const System::Int8 SQL_CHAR = System::Int8(0x1);
static const System::Int8 SQL_NUMERIC = System::Int8(0x2);
static const System::Int8 SQL_DECIMAL = System::Int8(0x3);
static const System::Int8 SQL_INTEGER = System::Int8(0x4);
static const System::Int8 SQL_SMALLINT = System::Int8(0x5);
static const System::Int8 SQL_FLOAT = System::Int8(0x6);
static const System::Int8 SQL_REAL = System::Int8(0x7);
static const System::Int8 SQL_DOUBLE = System::Int8(0x8);
static const System::Int8 SQL_DATETIME = System::Int8(0x9);
static const System::Int8 SQL_VARCHAR = System::Int8(0xc);
static const System::Int8 SQL_TYPE_DATE = System::Int8(0x5b);
static const System::Int8 SQL_TYPE_TIME = System::Int8(0x5c);
static const System::Int8 SQL_TYPE_TIMESTAMP = System::Int8(0x5d);
static const System::Int8 SQL_UNSPECIFIED = System::Int8(0x0);
static const System::Int8 SQL_INSENSITIVE = System::Int8(0x1);
static const System::Int8 SQL_SENSITIVE = System::Int8(0x2);
static const System::Int8 SQL_ALL_TYPES = System::Int8(0x0);
static const System::Int8 SQL_DEFAULT = System::Int8(0x63);
static const System::Int8 SQL_ARD_TYPE = System::Int8(-99);
static const System::Int8 SQL_CODE_DATE = System::Int8(0x1);
static const System::Int8 SQL_CODE_TIME = System::Int8(0x2);
static const System::Int8 SQL_CODE_TIMESTAMP = System::Int8(0x3);
static const System::Int8 SQL_FALSE = System::Int8(0x0);
static const System::Int8 SQL_TRUE = System::Int8(0x1);
static const System::Int8 SQL_NO_NULLS = System::Int8(0x0);
static const System::Int8 SQL_NULLABLE = System::Int8(0x1);
static const System::Int8 SQL_NULLABLE_UNKNOWN = System::Int8(0x2);
static const System::Int8 SQL_PRED_NONE = System::Int8(0x0);
static const System::Int8 SQL_PRED_CHAR = System::Int8(0x1);
static const System::Int8 SQL_PRED_BASIC = System::Int8(0x2);
static const System::Int8 SQL_NAMED = System::Int8(0x0);
static const System::Int8 SQL_UNNAMED = System::Int8(0x1);
static const System::Int8 SQL_DESC_ALLOC_AUTO = System::Int8(0x1);
static const System::Int8 SQL_DESC_ALLOC_USER = System::Int8(0x2);
static const System::Int8 SQL_CLOSE = System::Int8(0x0);
static const System::Int8 SQL_DROP = System::Int8(0x1);
static const System::Int8 SQL_UNBIND = System::Int8(0x2);
static const System::Int8 SQL_RESET_PARAMS = System::Int8(0x3);
static const System::Int8 SQL_FETCH_NEXT = System::Int8(0x1);
static const System::Int8 SQL_FETCH_FIRST = System::Int8(0x2);
static const System::Int8 SQL_FETCH_LAST = System::Int8(0x3);
static const System::Int8 SQL_FETCH_PRIOR = System::Int8(0x4);
static const System::Int8 SQL_FETCH_ABSOLUTE = System::Int8(0x5);
static const System::Int8 SQL_FETCH_RELATIVE = System::Int8(0x6);
static const System::Int8 SQL_COMMIT = System::Int8(0x0);
static const System::Int8 SQL_ROLLBACK = System::Int8(0x1);
#define SQL_NULL_HENV (void *)(0)
#define SQL_NULL_HDBC (void *)(0)
#define SQL_NULL_HSTMT (void *)(0)
#define SQL_NULL_HDESC (void *)(0)
#define SQL_NULL_HANDLE (void *)(0)
static const System::Int8 SQL_SCOPE_CURROW = System::Int8(0x0);
static const System::Int8 SQL_SCOPE_TRANSACTION = System::Int8(0x1);
static const System::Int8 SQL_SCOPE_SESSION = System::Int8(0x2);
static const System::Int8 SQL_PC_UNKNOWN = System::Int8(0x0);
static const System::Int8 SQL_PC_NON_PSEUDO = System::Int8(0x1);
static const System::Int8 SQL_PC_PSEUDO = System::Int8(0x2);
static const System::Int8 SQL_ROW_IDENTIFIER = System::Int8(0x1);
static const System::Int8 SQL_INDEX_UNIQUE = System::Int8(0x0);
static const System::Int8 SQL_INDEX_ALL = System::Int8(0x1);
static const System::Int8 SQL_INDEX_CLUSTERED = System::Int8(0x1);
static const System::Int8 SQL_INDEX_HASHED = System::Int8(0x2);
static const System::Int8 SQL_INDEX_OTHER = System::Int8(0x3);
static const System::Int8 SQL_API_SQLALLOCCONNECT = System::Int8(0x1);
static const System::Int8 SQL_API_SQLALLOCENV = System::Int8(0x2);
static const System::Word SQL_API_SQLALLOCHANDLE = System::Word(0x3e9);
static const System::Int8 SQL_API_SQLALLOCSTMT = System::Int8(0x3);
static const System::Int8 SQL_API_SQLBINDCOL = System::Int8(0x4);
static const System::Word SQL_API_SQLBINDPARAM = System::Word(0x3ea);
static const System::Int8 SQL_API_SQLCANCEL = System::Int8(0x5);
static const System::Word SQL_API_SQLCLOSECURSOR = System::Word(0x3eb);
static const System::Int8 SQL_API_SQLCOLATTRIBUTE = System::Int8(0x6);
static const System::Int8 SQL_API_SQLCOLUMNS = System::Int8(0x28);
static const System::Int8 SQL_API_SQLCONNECT = System::Int8(0x7);
static const System::Word SQL_API_SQLCOPYDESC = System::Word(0x3ec);
static const System::Int8 SQL_API_SQLDATASOURCES = System::Int8(0x39);
static const System::Int8 SQL_API_SQLDESCRIBECOL = System::Int8(0x8);
static const System::Int8 SQL_API_SQLDISCONNECT = System::Int8(0x9);
static const System::Word SQL_API_SQLENDTRAN = System::Word(0x3ed);
static const System::Int8 SQL_API_SQLERROR = System::Int8(0xa);
static const System::Int8 SQL_API_SQLEXECDIRECT = System::Int8(0xb);
static const System::Int8 SQL_API_SQLEXECUTE = System::Int8(0xc);
static const System::Int8 SQL_API_SQLFETCH = System::Int8(0xd);
static const System::Word SQL_API_SQLFETCHSCROLL = System::Word(0x3fd);
static const System::Int8 SQL_API_SQLFREECONNECT = System::Int8(0xe);
static const System::Int8 SQL_API_SQLFREEENV = System::Int8(0xf);
static const System::Word SQL_API_SQLFREEHANDLE = System::Word(0x3ee);
static const System::Int8 SQL_API_SQLFREESTMT = System::Int8(0x10);
static const System::Word SQL_API_SQLGETCONNECTATTR = System::Word(0x3ef);
static const System::Int8 SQL_API_SQLGETCONNECTOPTION = System::Int8(0x2a);
static const System::Int8 SQL_API_SQLGETCURSORNAME = System::Int8(0x11);
static const System::Int8 SQL_API_SQLGETDATA = System::Int8(0x2b);
static const System::Word SQL_API_SQLGETDESCFIELD = System::Word(0x3f0);
static const System::Word SQL_API_SQLGETDESCREC = System::Word(0x3f1);
static const System::Word SQL_API_SQLGETDIAGFIELD = System::Word(0x3f2);
static const System::Word SQL_API_SQLGETDIAGREC = System::Word(0x3f3);
static const System::Word SQL_API_SQLGETENVATTR = System::Word(0x3f4);
static const System::Int8 SQL_API_SQLGETFUNCTIONS = System::Int8(0x2c);
static const System::Int8 SQL_API_SQLGETINFO = System::Int8(0x2d);
static const System::Word SQL_API_SQLGETSTMTATTR = System::Word(0x3f6);
static const System::Int8 SQL_API_SQLGETSTMTOPTION = System::Int8(0x2e);
static const System::Int8 SQL_API_SQLGETTYPEINFO = System::Int8(0x2f);
static const System::Int8 SQL_API_SQLNUMRESULTCOLS = System::Int8(0x12);
static const System::Int8 SQL_API_SQLPARAMDATA = System::Int8(0x30);
static const System::Int8 SQL_API_SQLPREPARE = System::Int8(0x13);
static const System::Int8 SQL_API_SQLPUTDATA = System::Int8(0x31);
static const System::Int8 SQL_API_SQLROWCOUNT = System::Int8(0x14);
static const System::Word SQL_API_SQLSETCONNECTATTR = System::Word(0x3f8);
static const System::Int8 SQL_API_SQLSETCONNECTOPTION = System::Int8(0x32);
static const System::Int8 SQL_API_SQLSETCURSORNAME = System::Int8(0x15);
static const System::Word SQL_API_SQLSETDESCFIELD = System::Word(0x3f9);
static const System::Word SQL_API_SQLSETDESCREC = System::Word(0x3fa);
static const System::Word SQL_API_SQLSETENVATTR = System::Word(0x3fb);
static const System::Int8 SQL_API_SQLSETPARAM = System::Int8(0x16);
static const System::Word SQL_API_SQLSETSTMTATTR = System::Word(0x3fc);
static const System::Int8 SQL_API_SQLSETSTMTOPTION = System::Int8(0x33);
static const System::Int8 SQL_API_SQLSPECIALCOLUMNS = System::Int8(0x34);
static const System::Int8 SQL_API_SQLSTATISTICS = System::Int8(0x35);
static const System::Int8 SQL_API_SQLTABLES = System::Int8(0x36);
static const System::Int8 SQL_API_SQLTRANSACT = System::Int8(0x17);
static const System::Int8 SQL_MAX_DRIVER_CONNECTIONS = System::Int8(0x0);
static const System::Int8 SQL_MAXIMUM_DRIVER_CONNECTIONS = System::Int8(0x0);
static const System::Int8 SQL_MAX_CONCURRENT_ACTIVITIES = System::Int8(0x1);
static const System::Int8 SQL_MAXIMUM_CONCURRENT_ACTIVITIES = System::Int8(0x1);
static const System::Int8 SQL_DATA_SOURCE_NAME = System::Int8(0x2);
static const System::Int8 SQL_FETCH_DIRECTION = System::Int8(0x8);
static const System::Int8 SQL_SERVER_NAME = System::Int8(0xd);
static const System::Int8 SQL_SEARCH_PATTERN_ESCAPE = System::Int8(0xe);
static const System::Int8 SQL_DBMS_NAME = System::Int8(0x11);
static const System::Int8 SQL_DBMS_VER = System::Int8(0x12);
static const System::Int8 SQL_ACCESSIBLE_TABLES = System::Int8(0x13);
static const System::Int8 SQL_ACCESSIBLE_PROCEDURES = System::Int8(0x14);
static const System::Int8 SQL_CURSOR_COMMIT_BEHAVIOR = System::Int8(0x17);
static const System::Int8 SQL_DATA_SOURCE_READ_ONLY = System::Int8(0x19);
static const System::Int8 SQL_DEFAULT_TXN_ISOLATION = System::Int8(0x1a);
static const System::Int8 SQL_IDENTIFIER_CASE = System::Int8(0x1c);
static const System::Int8 SQL_IDENTIFIER_QUOTE_CHAR = System::Int8(0x1d);
static const System::Int8 SQL_MAX_COLUMN_NAME_LEN = System::Int8(0x1e);
static const System::Int8 SQL_MAXIMUM_COLUMN_NAME_LENGTH = System::Int8(0x1e);
static const System::Int8 SQL_MAX_CURSOR_NAME_LEN = System::Int8(0x1f);
static const System::Int8 SQL_MAXIMUM_CURSOR_NAME_LENGTH = System::Int8(0x1f);
static const System::Int8 SQL_MAX_SCHEMA_NAME_LEN = System::Int8(0x20);
static const System::Int8 SQL_MAXIMUM_SCHEMA_NAME_LENGTH = System::Int8(0x20);
static const System::Int8 SQL_MAX_CATALOG_NAME_LEN = System::Int8(0x22);
static const System::Int8 SQL_MAXIMUM_CATALOG_NAME_LENGTH = System::Int8(0x22);
static const System::Int8 SQL_MAX_TABLE_NAME_LEN = System::Int8(0x23);
static const System::Int8 SQL_SCROLL_CONCURRENCY = System::Int8(0x2b);
static const System::Int8 SQL_TXN_CAPABLE = System::Int8(0x2e);
static const System::Int8 SQL_TRANSACTION_CAPABLE = System::Int8(0x2e);
static const System::Int8 SQL_USER_NAME = System::Int8(0x2f);
static const System::Int8 SQL_TXN_ISOLATION_OPTION = System::Int8(0x48);
static const System::Int8 SQL_TRANSACTION_ISOLATION_OPTION = System::Int8(0x48);
static const System::Int8 SQL_INTEGRITY = System::Int8(0x49);
static const System::Int8 SQL_GETDATA_EXTENSIONS = System::Int8(0x51);
static const System::Int8 SQL_NULL_COLLATION = System::Int8(0x55);
static const System::Int8 SQL_ALTER_TABLE = System::Int8(0x56);
static const System::Int8 SQL_ORDER_BY_COLUMNS_IN_SELECT = System::Int8(0x5a);
static const System::Int8 SQL_SPECIAL_CHARACTERS = System::Int8(0x5e);
static const System::Int8 SQL_MAX_COLUMNS_IN_GROUP_BY = System::Int8(0x61);
static const System::Int8 SQL_MAXIMUM_COLUMNS_IN_GROUP_BY = System::Int8(0x61);
static const System::Int8 SQL_MAX_COLUMNS_IN_INDEX = System::Int8(0x62);
static const System::Int8 SQL_MAXIMUM_COLUMNS_IN_INDEX = System::Int8(0x62);
static const System::Int8 SQL_MAX_COLUMNS_IN_ORDER_BY = System::Int8(0x63);
static const System::Int8 SQL_MAXIMUM_COLUMNS_IN_ORDER_BY = System::Int8(0x63);
static const System::Int8 SQL_MAX_COLUMNS_IN_SELECT = System::Int8(0x64);
static const System::Int8 SQL_MAXIMUM_COLUMNS_IN_SELECT = System::Int8(0x64);
static const System::Int8 SQL_MAX_COLUMNS_IN_TABLE = System::Int8(0x65);
static const System::Int8 SQL_MAX_INDEX_SIZE = System::Int8(0x66);
static const System::Int8 SQL_MAXIMUM_INDEX_SIZE = System::Int8(0x66);
static const System::Int8 SQL_MAX_ROW_SIZE = System::Int8(0x68);
static const System::Int8 SQL_MAXIMUM_ROW_SIZE = System::Int8(0x68);
static const System::Int8 SQL_MAX_STATEMENT_LEN = System::Int8(0x69);
static const System::Int8 SQL_MAXIMUM_STATEMENT_LENGTH = System::Int8(0x69);
static const System::Int8 SQL_MAX_TABLES_IN_SELECT = System::Int8(0x6a);
static const System::Int8 SQL_MAXIMUM_TABLES_IN_SELECT = System::Int8(0x6a);
static const System::Int8 SQL_MAX_USER_NAME_LEN = System::Int8(0x6b);
static const System::Int8 SQL_MAXIMUM_USER_NAME_LENGTH = System::Int8(0x6b);
static const System::Int8 SQL_OJ_CAPABILITIES = System::Int8(0x73);
static const System::Int8 SQL_OUTER_JOIN_CAPABILITIES = System::Int8(0x73);
static const System::Word SQL_XOPEN_CLI_YEAR = System::Word(0x2710);
static const System::Word SQL_CURSOR_SENSITIVITY = System::Word(0x2711);
static const System::Word SQL_DESCRIBE_PARAMETER = System::Word(0x2712);
static const System::Word SQL_CATALOG_NAME = System::Word(0x2713);
static const System::Word SQL_COLLATION_SEQ = System::Word(0x2714);
static const System::Word SQL_MAX_IDENTIFIER_LEN = System::Word(0x2715);
static const System::Word SQL_MAXIMUM_IDENTIFIER_LENGTH = System::Word(0x2715);
static const System::Int8 SQL_AT_ADD_COLUMN = System::Int8(0x1);
static const System::Int8 SQL_AT_DROP_COLUMN = System::Int8(0x2);
static const System::Int8 SQL_AT_ADD_CONSTRAINT = System::Int8(0x8);
static const System::Int8 SQL_AT_COLUMN_SINGLE = System::Int8(0x20);
static const System::Int8 SQL_AT_ADD_COLUMN_DEFAULT = System::Int8(0x40);
static const System::Byte SQL_AT_ADD_COLUMN_COLLATION = System::Byte(0x80);
static const System::Word SQL_AT_SET_COLUMN_DEFAULT = System::Word(0x100);
static const System::Word SQL_AT_DROP_COLUMN_DEFAULT = System::Word(0x200);
static const System::Word SQL_AT_DROP_COLUMN_CASCADE = System::Word(0x400);
static const System::Word SQL_AT_DROP_COLUMN_RESTRICT = System::Word(0x800);
static const System::Word SQL_AT_ADD_TABLE_CONSTRAINT = System::Word(0x1000);
static const System::Word SQL_AT_DROP_TABLE_CONSTRAINT_CASCADE = System::Word(0x2000);
static const System::Word SQL_AT_DROP_TABLE_CONSTRAINT_RESTRICT = System::Word(0x4000);
static const System::Word SQL_AT_CONSTRAINT_NAME_DEFINITION = System::Word(0x8000);
static const int SQL_AT_CONSTRAINT_INITIALLY_DEFERRED = int(0x10000);
static const int SQL_AT_CONSTRAINT_INITIALLY_IMMEDIATE = int(0x20000);
static const int SQL_AT_CONSTRAINT_DEFERRABLE = int(0x40000);
static const int SQL_AT_CONSTRAINT_NON_DEFERRABLE = int(0x80000);
static const System::Int8 SQL_AM_NONE = System::Int8(0x0);
static const System::Int8 SQL_AM_CONNECTION = System::Int8(0x1);
static const System::Int8 SQL_AM_STATEMENT = System::Int8(0x2);
static const System::Int8 SQL_CB_DELETE = System::Int8(0x0);
static const System::Int8 SQL_CB_CLOSE = System::Int8(0x1);
static const System::Int8 SQL_CB_PRESERVE = System::Int8(0x2);
static const System::Int8 SQL_FD_FETCH_NEXT = System::Int8(0x1);
static const System::Int8 SQL_FD_FETCH_FIRST = System::Int8(0x2);
static const System::Int8 SQL_FD_FETCH_LAST = System::Int8(0x4);
static const System::Int8 SQL_FD_FETCH_PRIOR = System::Int8(0x8);
static const System::Int8 SQL_FD_FETCH_ABSOLUTE = System::Int8(0x10);
static const System::Int8 SQL_FD_FETCH_RELATIVE = System::Int8(0x20);
static const System::Int8 SQL_GD_ANY_COLUMN = System::Int8(0x1);
static const System::Int8 SQL_GD_ANY_ORDER = System::Int8(0x2);
static const System::Int8 SQL_IC_UPPER = System::Int8(0x1);
static const System::Int8 SQL_IC_LOWER = System::Int8(0x2);
static const System::Int8 SQL_IC_SENSITIVE = System::Int8(0x3);
static const System::Int8 SQL_IC_MIXED = System::Int8(0x4);
static const System::Int8 SQL_OJ_LEFT = System::Int8(0x1);
static const System::Int8 SQL_OJ_RIGHT = System::Int8(0x2);
static const System::Int8 SQL_OJ_FULL = System::Int8(0x4);
static const System::Int8 SQL_OJ_NESTED = System::Int8(0x8);
static const System::Int8 SQL_OJ_NOT_ORDERED = System::Int8(0x10);
static const System::Int8 SQL_OJ_INNER = System::Int8(0x20);
static const System::Int8 SQL_OJ_ALL_COMPARISON_OPS = System::Int8(0x40);
static const System::Int8 SQL_SCCO_READ_ONLY = System::Int8(0x1);
static const System::Int8 SQL_SCCO_LOCK = System::Int8(0x2);
static const System::Int8 SQL_SCCO_OPT_ROWVER = System::Int8(0x4);
static const System::Int8 SQL_SCCO_OPT_VALUES = System::Int8(0x8);
static const System::Int8 SQL_TC_NONE = System::Int8(0x0);
static const System::Int8 SQL_TC_DML = System::Int8(0x1);
static const System::Int8 SQL_TC_ALL = System::Int8(0x2);
static const System::Int8 SQL_TC_DDL_COMMIT = System::Int8(0x3);
static const System::Int8 SQL_TC_DDL_IGNORE = System::Int8(0x4);
static const System::Int8 SQL_TXN_READ_UNCOMMITTED = System::Int8(0x1);
static const System::Int8 SQL_TRANSACTION_READ_UNCOMMITTED = System::Int8(0x1);
static const System::Int8 SQL_TXN_READ_COMMITTED = System::Int8(0x2);
static const System::Int8 SQL_TRANSACTION_READ_COMMITTED = System::Int8(0x2);
static const System::Int8 SQL_TXN_REPEATABLE_READ = System::Int8(0x4);
static const System::Int8 SQL_TRANSACTION_REPEATABLE_READ = System::Int8(0x4);
static const System::Int8 SQL_TXN_SERIALIZABLE = System::Int8(0x8);
static const System::Int8 SQL_TRANSACTION_SERIALIZABLE = System::Int8(0x8);
static const System::Int8 SQL_NC_HIGH = System::Int8(0x0);
static const System::Int8 SQL_NC_LOW = System::Int8(0x1);
static const System::Int8 SQL_WCHAR = System::Int8(-8);
static const System::Int8 SQL_WVARCHAR = System::Int8(-9);
static const System::Int8 SQL_WLONGVARCHAR = System::Int8(-10);
static const System::Int8 SQL_C_WCHAR = System::Int8(-8);
static const System::Int8 SQL_SPEC_MAJOR = System::Int8(0x3);
static const System::Int8 SQL_SPEC_MINOR = System::Int8(0x33);
#define SQL_SPEC_STRING L"03.51"
static const System::Int8 SQL_SQLSTATE_SIZE = System::Int8(0x5);
static const System::Int8 SQL_MAX_DSN_LENGTH = System::Int8(0x20);
static const System::Word SQL_MAX_OPTION_STRING_LENGTH = System::Word(0x100);
static const System::Int8 SQL_NO_DATA_FOUND = System::Int8(0x64);
static const System::Int8 SQL_HANDLE_SENV = System::Int8(0x5);
static const System::Byte SQL_ATTR_ODBC_VERSION = System::Byte(0xc8);
static const System::Byte SQL_ATTR_CONNECTION_POOLING = System::Byte(0xc9);
static const System::Byte SQL_ATTR_CP_MATCH = System::Byte(0xca);
static const int SQL_CP_OFF = int(0);
static const int SQL_CP_ONE_PER_DRIVER = int(1);
static const int SQL_CP_ONE_PER_HENV = int(2);
static const int SQL_CP_DEFAULT = int(0);
static const int SQL_CP_STRICT_MATCH = int(0);
static const int SQL_CP_RELAXED_MATCH = int(1);
static const int SQL_CP_MATCH_DEFAULT = int(0);
static const System::Int8 SQL_ACCESS_MODE = System::Int8(0x65);
static const System::Int8 SQL_AUTOCOMMIT = System::Int8(0x66);
static const System::Int8 SQL_LOGIN_TIMEOUT = System::Int8(0x67);
static const System::Int8 SQL_OPT_TRACE = System::Int8(0x68);
static const System::Int8 SQL_OPT_TRACEFILE = System::Int8(0x69);
static const System::Int8 SQL_TRANSLATE_DLL = System::Int8(0x6a);
static const System::Int8 SQL_TRANSLATE_OPTION = System::Int8(0x6b);
static const System::Int8 SQL_TXN_ISOLATION = System::Int8(0x6c);
static const System::Int8 SQL_CURRENT_QUALIFIER = System::Int8(0x6d);
static const System::Int8 SQL_ODBC_CURSORS = System::Int8(0x6e);
static const System::Int8 SQL_QUIET_MODE = System::Int8(0x6f);
static const System::Int8 SQL_PACKET_SIZE = System::Int8(0x70);
static const System::Int8 SQL_ATTR_ACCESS_MODE = System::Int8(0x65);
static const System::Int8 SQL_ATTR_AUTOCOMMIT = System::Int8(0x66);
static const System::Int8 SQL_ATTR_CONNECTION_TIMEOUT = System::Int8(0x71);
static const System::Int8 SQL_ATTR_CURRENT_CATALOG = System::Int8(0x6d);
static const System::Int8 SQL_ATTR_DISCONNECT_BEHAVIOR = System::Int8(0x72);
static const System::Word SQL_ATTR_ENLIST_IN_DTC = System::Word(0x4b7);
static const System::Word SQL_ATTR_ENLIST_IN_XA = System::Word(0x4b8);
static const System::Int8 SQL_ATTR_LOGIN_TIMEOUT = System::Int8(0x67);
static const System::Int8 SQL_ATTR_ODBC_CURSORS = System::Int8(0x6e);
static const System::Int8 SQL_ATTR_PACKET_SIZE = System::Int8(0x70);
static const System::Int8 SQL_ATTR_QUIET_MODE = System::Int8(0x6f);
static const System::Int8 SQL_ATTR_TRACE = System::Int8(0x68);
static const System::Int8 SQL_ATTR_TRACEFILE = System::Int8(0x69);
static const System::Int8 SQL_ATTR_TRANSLATE_LIB = System::Int8(0x6a);
static const System::Int8 SQL_ATTR_TRANSLATE_OPTION = System::Int8(0x6b);
static const System::Int8 SQL_ATTR_TXN_ISOLATION = System::Int8(0x6c);
static const System::Word SQL_ATTR_CONNECTION_DEAD = System::Word(0x4b9);
static const System::Int8 SQL_ATTR_ANSI_APP = System::Int8(0x73);
static const System::Word SQL_CONNECT_OPT_DRVR_START = System::Word(0x3e8);
static const System::Int8 SQL_CONN_OPT_MAX = System::Int8(0x70);
static const System::Int8 SQL_CONN_OPT_MIN = System::Int8(0x65);
static const int SQL_MODE_READ_WRITE = int(0);
static const int SQL_MODE_READ_ONLY = int(1);
static const int SQL_MODE_DEFAULT = int(0);
static const int SQL_AUTOCOMMIT_OFF = int(0);
static const int SQL_AUTOCOMMIT_ON = int(1);
static const int SQL_AUTOCOMMIT_DEFAULT = int(1);
static const int SQL_LOGIN_TIMEOUT_DEFAULT = int(15);
static const int SQL_OPT_TRACE_OFF = int(0);
static const int SQL_OPT_TRACE_ON = int(1);
static const int SQL_OPT_TRACE_DEFAULT = int(0);
#define SQL_OPT_TRACE_FILE_DEFAULT L"\\\\SQL.LOG"
static const int SQL_CUR_USE_IF_NEEDED = int(0);
static const int SQL_CUR_USE_ODBC = int(1);
static const int SQL_CUR_USE_DRIVER = int(2);
static const int SQL_CUR_DEFAULT = int(2);
static const int SQL_DB_RETURN_TO_POOL = int(0);
static const int SQL_DB_DISCONNECT = int(1);
static const int SQL_DB_DEFAULT = int(0);
static const System::Int8 SQL_DTC_DONE = System::Int8(0x0);
static const System::Int8 SQL_CD_TRUE = System::Int8(0x1);
static const System::Int8 SQL_CD_FALSE = System::Int8(0x0);
static const System::Int8 SQL_AA_TRUE = System::Int8(0x1);
static const System::Int8 SQL_AA_FALSE = System::Int8(0x0);
static const System::Int8 SQL_QUERY_TIMEOUT = System::Int8(0x0);
static const System::Int8 SQL_MAX_ROWS = System::Int8(0x1);
static const System::Int8 SQL_NOSCAN = System::Int8(0x2);
static const System::Int8 SQL_MAX_LENGTH = System::Int8(0x3);
static const System::Int8 SQL_ASYNC_ENABLE = System::Int8(0x4);
static const System::Int8 SQL_BIND_TYPE = System::Int8(0x5);
static const System::Int8 SQL_CURSOR_TYPE = System::Int8(0x6);
static const System::Int8 SQL_CONCURRENCY = System::Int8(0x7);
static const System::Int8 SQL_KEYSET_SIZE = System::Int8(0x8);
static const System::Int8 SQL_ROWSET_SIZE = System::Int8(0x9);
static const System::Int8 SQL_SIMULATE_CURSOR = System::Int8(0xa);
static const System::Int8 SQL_RETRIEVE_DATA = System::Int8(0xb);
static const System::Int8 SQL_USE_BOOKMARKS = System::Int8(0xc);
static const System::Int8 SQL_GET_BOOKMARK = System::Int8(0xd);
static const System::Int8 SQL_ROW_NUMBER = System::Int8(0xe);
static const System::Int8 SQL_ATTR_ASYNC_ENABLE = System::Int8(0x4);
static const System::Int8 SQL_ATTR_CONCURRENCY = System::Int8(0x7);
static const System::Int8 SQL_ATTR_CURSOR_TYPE = System::Int8(0x6);
static const System::Int8 SQL_ATTR_ENABLE_AUTO_IPD = System::Int8(0xf);
static const System::Int8 SQL_ATTR_FETCH_BOOKMARK_PTR = System::Int8(0x10);
static const System::Int8 SQL_ATTR_KEYSET_SIZE = System::Int8(0x8);
static const System::Int8 SQL_ATTR_MAX_LENGTH = System::Int8(0x3);
static const System::Int8 SQL_ATTR_MAX_ROWS = System::Int8(0x1);
static const System::Int8 SQL_ATTR_NOSCAN = System::Int8(0x2);
static const System::Int8 SQL_ATTR_PARAM_BIND_OFFSET_PTR = System::Int8(0x11);
static const System::Int8 SQL_ATTR_PARAM_BIND_TYPE = System::Int8(0x12);
static const System::Int8 SQL_ATTR_PARAM_OPERATION_PTR = System::Int8(0x13);
static const System::Int8 SQL_ATTR_PARAM_STATUS_PTR = System::Int8(0x14);
static const System::Int8 SQL_ATTR_PARAMS_PROCESSED_PTR = System::Int8(0x15);
static const System::Int8 SQL_ATTR_PARAMSET_SIZE = System::Int8(0x16);
static const System::Int8 SQL_ATTR_QUERY_TIMEOUT = System::Int8(0x0);
static const System::Int8 SQL_ATTR_RETRIEVE_DATA = System::Int8(0xb);
static const System::Int8 SQL_ATTR_ROW_BIND_OFFSET_PTR = System::Int8(0x17);
static const System::Int8 SQL_ATTR_ROW_BIND_TYPE = System::Int8(0x5);
static const System::Int8 SQL_ATTR_ROW_NUMBER = System::Int8(0xe);
static const System::Int8 SQL_ATTR_ROW_OPERATION_PTR = System::Int8(0x18);
static const System::Int8 SQL_ATTR_ROW_STATUS_PTR = System::Int8(0x19);
static const System::Int8 SQL_ATTR_ROWS_FETCHED_PTR = System::Int8(0x1a);
static const System::Int8 SQL_ATTR_ROW_ARRAY_SIZE = System::Int8(0x1b);
static const System::Int8 SQL_ATTR_SIMULATE_CURSOR = System::Int8(0xa);
static const System::Int8 SQL_ATTR_USE_BOOKMARKS = System::Int8(0xc);
static const System::Int8 SQL_STMT_OPT_MAX = System::Int8(0xe);
static const System::Int8 SQL_STMT_OPT_MIN = System::Int8(0x0);
static const System::Int8 SQL_COLUMN_COUNT = System::Int8(0x0);
static const System::Int8 SQL_COLUMN_NAME = System::Int8(0x1);
static const System::Int8 SQL_COLUMN_TYPE = System::Int8(0x2);
static const System::Int8 SQL_COLUMN_LENGTH = System::Int8(0x3);
static const System::Int8 SQL_COLUMN_PRECISION = System::Int8(0x4);
static const System::Int8 SQL_COLUMN_SCALE = System::Int8(0x5);
static const System::Int8 SQL_COLUMN_DISPLAY_SIZE = System::Int8(0x6);
static const System::Int8 SQL_COLUMN_NULLABLE = System::Int8(0x7);
static const System::Int8 SQL_COLUMN_UNSIGNED = System::Int8(0x8);
static const System::Int8 SQL_COLUMN_MONEY = System::Int8(0x9);
static const System::Int8 SQL_COLUMN_UPDATABLE = System::Int8(0xa);
static const System::Int8 SQL_COLUMN_AUTO_INCREMENT = System::Int8(0xb);
static const System::Int8 SQL_COLUMN_CASE_SENSITIVE = System::Int8(0xc);
static const System::Int8 SQL_COLUMN_SEARCHABLE = System::Int8(0xd);
static const System::Int8 SQL_COLUMN_TYPE_NAME = System::Int8(0xe);
static const System::Int8 SQL_COLUMN_TABLE_NAME = System::Int8(0xf);
static const System::Int8 SQL_COLUMN_OWNER_NAME = System::Int8(0x10);
static const System::Int8 SQL_COLUMN_QUALIFIER_NAME = System::Int8(0x11);
static const System::Int8 SQL_COLUMN_LABEL = System::Int8(0x12);
static const System::Int8 SQL_COLATT_OPT_MAX = System::Int8(0x12);
static const System::Int8 SQL_COLATT_OPT_MIN = System::Int8(0x0);
static const System::Int8 SQL_ATTR_READONLY = System::Int8(0x0);
static const System::Int8 SQL_ATTR_WRITE = System::Int8(0x1);
static const System::Int8 SQL_ATTR_READWRITE_UNKNOWN = System::Int8(0x2);
static const System::Int8 SQL_UNSEARCHABLE = System::Int8(0x0);
static const System::Int8 SQL_LIKE_ONLY = System::Int8(0x1);
static const System::Int8 SQL_ALL_EXCEPT_LIKE = System::Int8(0x2);
static const System::Int8 SQL_SEARCHABLE = System::Int8(0x3);
static const System::Int8 SQL_PRED_SEARCHABLE = System::Int8(0x3);
static const System::Int8 SQL_NO_TOTAL = System::Int8(-4);
static const System::Int8 SQL_COL_PRED_CHAR = System::Int8(0x1);
static const System::Int8 SQL_COL_PRED_BASIC = System::Int8(0x2);
static const System::Int8 SQL_IS_POINTER = System::Int8(-4);
static const System::Int8 SQL_IS_UINTEGER = System::Int8(-5);
static const System::Int8 SQL_IS_INTEGER = System::Int8(-6);
static const System::Int8 SQL_IS_USMALLINT = System::Int8(-7);
static const System::Int8 SQL_IS_SMALLINT = System::Int8(-8);
static const int SQL_PARAM_BIND_BY_COLUMN = int(0);
static const int SQL_PARAM_BIND_TYPE_DEFAULT = int(0);
static const int SQL_QUERY_TIMEOUT_DEFAULT = int(0);
static const int SQL_MAX_ROWS_DEFAULT = int(0);
static const int SQL_NOSCAN_OFF = int(0);
static const int SQL_NOSCAN_ON = int(1);
static const int SQL_NOSCAN_DEFAULT = int(0);
static const int SQL_MAX_LENGTH_DEFAULT = int(0);
static const int SQL_ASYNC_ENABLE_OFF = int(0);
static const int SQL_ASYNC_ENABLE_ON = int(1);
static const int SQL_ASYNC_ENABLE_DEFAULT = int(0);
static const int SQL_BIND_BY_COLUMN = int(0);
static const int SQL_BIND_TYPE_DEFAULT = int(0);
static const System::Int8 SQL_CONCUR_READ_ONLY = System::Int8(0x1);
static const System::Int8 SQL_CONCUR_LOCK = System::Int8(0x2);
static const System::Int8 SQL_CONCUR_ROWVER = System::Int8(0x3);
static const System::Int8 SQL_CONCUR_VALUES = System::Int8(0x4);
static const System::Int8 SQL_CONCUR_DEFAULT = System::Int8(0x1);
static const int SQL_CURSOR_FORWARD_ONLY = int(0);
static const int SQL_CURSOR_KEYSET_DRIVEN = int(1);
static const int SQL_CURSOR_DYNAMIC = int(2);
static const int SQL_CURSOR_STATIC = int(3);
static const int SQL_CURSOR_TYPE_DEFAULT = int(0);
static const int SQL_ROWSET_SIZE_DEFAULT = int(1);
static const int SQL_KEYSET_SIZE_DEFAULT = int(0);
static const int SQL_SC_NON_UNIQUE = int(0);
static const int SQL_SC_TRY_UNIQUE = int(1);
static const int SQL_SC_UNIQUE = int(2);
static const int SQL_RD_OFF = int(0);
static const int SQL_RD_ON = int(1);
static const int SQL_RD_DEFAULT = int(1);
static const int SQL_UB_OFF = int(0);
static const int SQL_UB_ON = int(1);
static const int SQL_UB_DEFAULT = int(0);
static const int SQL_UB_FIXED = int(1);
static const int SQL_UB_VARIABLE = int(2);
static const System::Int8 SQL_DESC_ARRAY_SIZE = System::Int8(0x14);
static const System::Int8 SQL_DESC_ARRAY_STATUS_PTR = System::Int8(0x15);
static const System::Int8 SQL_DESC_AUTO_UNIQUE_VALUE = System::Int8(0xb);
static const System::Int8 SQL_DESC_BASE_COLUMN_NAME = System::Int8(0x16);
static const System::Int8 SQL_DESC_BASE_TABLE_NAME = System::Int8(0x17);
static const System::Int8 SQL_DESC_BIND_OFFSET_PTR = System::Int8(0x18);
static const System::Int8 SQL_DESC_BIND_TYPE = System::Int8(0x19);
static const System::Int8 SQL_DESC_CASE_SENSITIVE = System::Int8(0xc);
static const System::Int8 SQL_DESC_CATALOG_NAME = System::Int8(0x11);
static const System::Int8 SQL_DESC_CONCISE_TYPE = System::Int8(0x2);
static const System::Int8 SQL_DESC_DATETIME_INTERVAL_PRECISION = System::Int8(0x1a);
static const System::Int8 SQL_DESC_DISPLAY_SIZE = System::Int8(0x6);
static const System::Int8 SQL_DESC_FIXED_PREC_SCALE = System::Int8(0x9);
static const System::Int8 SQL_DESC_LABEL = System::Int8(0x12);
static const System::Int8 SQL_DESC_LITERAL_PREFIX = System::Int8(0x1b);
static const System::Int8 SQL_DESC_LITERAL_SUFFIX = System::Int8(0x1c);
static const System::Int8 SQL_DESC_LOCAL_TYPE_NAME = System::Int8(0x1d);
static const System::Int8 SQL_DESC_MAXIMUM_SCALE = System::Int8(0x1e);
static const System::Int8 SQL_DESC_MINIMUM_SCALE = System::Int8(0x1f);
static const System::Int8 SQL_DESC_NUM_PREC_RADIX = System::Int8(0x20);
static const System::Int8 SQL_DESC_PARAMETER_TYPE = System::Int8(0x21);
static const System::Int8 SQL_DESC_ROWS_PROCESSED_PTR = System::Int8(0x22);
static const System::Int8 SQL_DESC_ROWVER = System::Int8(0x23);
static const System::Int8 SQL_DESC_SCHEMA_NAME = System::Int8(0x10);
static const System::Int8 SQL_DESC_SEARCHABLE = System::Int8(0xd);
static const System::Int8 SQL_DESC_TYPE_NAME = System::Int8(0xe);
static const System::Int8 SQL_DESC_TABLE_NAME = System::Int8(0xf);
static const System::Int8 SQL_DESC_UNSIGNED = System::Int8(0x8);
static const System::Int8 SQL_DESC_UPDATABLE = System::Int8(0xa);
static const short SQL_DIAG_CURSOR_ROW_COUNT = short(-1249);
static const short SQL_DIAG_ROW_NUMBER = short(-1248);
static const short SQL_DIAG_COLUMN_NUMBER = short(-1247);
static const System::Int8 SQL_DATE = System::Int8(0x9);
static const System::Int8 SQL_INTERVAL = System::Int8(0xa);
static const System::Int8 SQL_TIME = System::Int8(0xa);
static const System::Int8 SQL_TIMESTAMP = System::Int8(0xb);
static const System::Int8 SQL_LONGVARCHAR = System::Int8(-1);
static const System::Int8 SQL_BINARY = System::Int8(-2);
static const System::Int8 SQL_VARBINARY = System::Int8(-3);
static const System::Int8 SQL_LONGVARBINARY = System::Int8(-4);
static const System::Int8 SQL_BIGINT = System::Int8(-5);
static const System::Int8 SQL_TINYINT = System::Int8(-6);
static const System::Int8 SQL_BIT = System::Int8(-7);
static const System::Int8 SQL_GUID = System::Int8(-11);
static const System::Int8 SQL_CODE_YEAR = System::Int8(0x1);
static const System::Int8 SQL_CODE_MONTH = System::Int8(0x2);
static const System::Int8 SQL_CODE_DAY = System::Int8(0x3);
static const System::Int8 SQL_CODE_HOUR = System::Int8(0x4);
static const System::Int8 SQL_CODE_MINUTE = System::Int8(0x5);
static const System::Int8 SQL_CODE_SECOND = System::Int8(0x6);
static const System::Int8 SQL_CODE_YEAR_TO_MONTH = System::Int8(0x7);
static const System::Int8 SQL_CODE_DAY_TO_HOUR = System::Int8(0x8);
static const System::Int8 SQL_CODE_DAY_TO_MINUTE = System::Int8(0x9);
static const System::Int8 SQL_CODE_DAY_TO_SECOND = System::Int8(0xa);
static const System::Int8 SQL_CODE_HOUR_TO_MINUTE = System::Int8(0xb);
static const System::Int8 SQL_CODE_HOUR_TO_SECOND = System::Int8(0xc);
static const System::Int8 SQL_CODE_MINUTE_TO_SECOND = System::Int8(0xd);
static const System::Int8 SQL_INTERVAL_YEAR = System::Int8(0x65);
static const System::Int8 SQL_INTERVAL_MONTH = System::Int8(0x66);
static const System::Int8 SQL_INTERVAL_DAY = System::Int8(0x67);
static const System::Int8 SQL_INTERVAL_HOUR = System::Int8(0x68);
static const System::Int8 SQL_INTERVAL_MINUTE = System::Int8(0x69);
static const System::Int8 SQL_INTERVAL_SECOND = System::Int8(0x6a);
static const System::Int8 SQL_INTERVAL_YEAR_TO_MONTH = System::Int8(0x6b);
static const System::Int8 SQL_INTERVAL_DAY_TO_HOUR = System::Int8(0x6c);
static const System::Int8 SQL_INTERVAL_DAY_TO_MINUTE = System::Int8(0x6d);
static const System::Int8 SQL_INTERVAL_DAY_TO_SECOND = System::Int8(0x6e);
static const System::Int8 SQL_INTERVAL_HOUR_TO_MINUTE = System::Int8(0x6f);
static const System::Int8 SQL_INTERVAL_HOUR_TO_SECOND = System::Int8(0x70);
static const System::Int8 SQL_INTERVAL_MINUTE_TO_SECOND = System::Int8(0x71);
static const System::Int8 SQL_UNICODE = System::Int8(-8);
static const System::Int8 SQL_UNICODE_VARCHAR = System::Int8(-9);
static const System::Int8 SQL_UNICODE_LONGVARCHAR = System::Int8(-10);
static const System::Int8 SQL_UNICODE_CHAR = System::Int8(-8);
static const System::Int8 SQL_C_CHAR = System::Int8(0x1);
static const System::Int8 SQL_C_LONG = System::Int8(0x4);
static const System::Int8 SQL_C_SHORT = System::Int8(0x5);
static const System::Int8 SQL_C_FLOAT = System::Int8(0x7);
static const System::Int8 SQL_C_DOUBLE = System::Int8(0x8);
static const System::Int8 SQL_C_NUMERIC = System::Int8(0x2);
static const System::Int8 SQL_C_DEFAULT = System::Int8(0x63);
static const System::Int8 SQL_SIGNED_OFFSET = System::Int8(-20);
static const System::Int8 SQL_UNSIGNED_OFFSET = System::Int8(-22);
static const System::Int8 SQL_C_DATE = System::Int8(0x9);
static const System::Int8 SQL_C_TIME = System::Int8(0xa);
static const System::Int8 SQL_C_TIMESTAMP = System::Int8(0xb);
static const System::Int8 SQL_C_TYPE_DATE = System::Int8(0x5b);
static const System::Int8 SQL_C_TYPE_TIME = System::Int8(0x5c);
static const System::Int8 SQL_C_TYPE_TIMESTAMP = System::Int8(0x5d);
static const System::Int8 SQL_C_INTERVAL_YEAR = System::Int8(0x65);
static const System::Int8 SQL_C_INTERVAL_MONTH = System::Int8(0x66);
static const System::Int8 SQL_C_INTERVAL_DAY = System::Int8(0x67);
static const System::Int8 SQL_C_INTERVAL_HOUR = System::Int8(0x68);
static const System::Int8 SQL_C_INTERVAL_MINUTE = System::Int8(0x69);
static const System::Int8 SQL_C_INTERVAL_SECOND = System::Int8(0x6a);
static const System::Int8 SQL_C_INTERVAL_YEAR_TO_MONTH = System::Int8(0x6b);
static const System::Int8 SQL_C_INTERVAL_DAY_TO_HOUR = System::Int8(0x6c);
static const System::Int8 SQL_C_INTERVAL_DAY_TO_MINUTE = System::Int8(0x6d);
static const System::Int8 SQL_C_INTERVAL_DAY_TO_SECOND = System::Int8(0x6e);
static const System::Int8 SQL_C_INTERVAL_HOUR_TO_MINUTE = System::Int8(0x6f);
static const System::Int8 SQL_C_INTERVAL_HOUR_TO_SECOND = System::Int8(0x70);
static const System::Int8 SQL_C_INTERVAL_MINUTE_TO_SECOND = System::Int8(0x71);
static const System::Int8 SQL_C_BINARY = System::Int8(-2);
static const System::Int8 SQL_C_BIT = System::Int8(-7);
static const System::Int8 SQL_C_SBIGINT = System::Int8(-25);
static const System::Int8 SQL_C_UBIGINT = System::Int8(-27);
static const System::Int8 SQL_C_TINYINT = System::Int8(-6);
static const System::Int8 SQL_C_SLONG = System::Int8(-16);
static const System::Int8 SQL_C_SSHORT = System::Int8(-15);
static const System::Int8 SQL_C_STINYINT = System::Int8(-26);
static const System::Int8 SQL_C_ULONG = System::Int8(-18);
static const System::Int8 SQL_C_USHORT = System::Int8(-17);
static const System::Int8 SQL_C_UTINYINT = System::Int8(-28);
static const System::Int8 SQL_C_GUID = System::Int8(-11);
static const System::Int8 SQL_TYPE_NULL = System::Int8(0x0);
static const System::Int8 SQL_C_VARBOOKMARK = System::Int8(-2);
static const System::Int8 SQL_NO_ROW_NUMBER = System::Int8(-1);
static const System::Int8 SQL_NO_COLUMN_NUMBER = System::Int8(-1);
static const System::Int8 SQL_ROW_NUMBER_UNKNOWN = System::Int8(-2);
static const System::Int8 SQL_COLUMN_NUMBER_UNKNOWN = System::Int8(-2);
static const System::Int8 SQL_DEFAULT_PARAM = System::Int8(-5);
static const System::Int8 SQL_IGNORE = System::Int8(-6);
static const System::Int8 SQL_COLUMN_IGNORE = System::Int8(-6);
static const System::Int8 SQL_LEN_DATA_AT_EXEC_OFFSET = System::Int8(-100);
static const System::Int8 SQL_LEN_BINARY_ATTR_OFFSET = System::Int8(-100);
static const System::Int8 SQL_PARAM_TYPE_UNKNOWN = System::Int8(0x0);
static const System::Int8 SQL_PARAM_INPUT = System::Int8(0x1);
static const System::Int8 SQL_PARAM_INPUT_OUTPUT = System::Int8(0x2);
static const System::Int8 SQL_RESULT_COL = System::Int8(0x3);
static const System::Int8 SQL_PARAM_OUTPUT = System::Int8(0x4);
static const System::Int8 SQL_RETURN_VALUE = System::Int8(0x5);
static const System::Int8 SQL_PARAM_TYPE_DEFAULT = System::Int8(0x2);
static const System::Int8 SQL_SETPARAM_VALUE_MAX = System::Int8(-1);
static const System::Int8 SQL_API_SQLALLOCHANDLESTD = System::Int8(0x49);
static const System::Int8 SQL_API_SQLBULKOPERATIONS = System::Int8(0x18);
static const System::Int8 SQL_API_SQLBINDPARAMETER = System::Int8(0x48);
static const System::Int8 SQL_API_SQLBROWSECONNECT = System::Int8(0x37);
static const System::Int8 SQL_API_SQLCOLATTRIBUTES = System::Int8(0x6);
static const System::Int8 SQL_API_SQLCOLUMNPRIVILEGES = System::Int8(0x38);
static const System::Int8 SQL_API_SQLDESCRIBEPARAM = System::Int8(0x3a);
static const System::Int8 SQL_API_SQLDRIVERCONNECT = System::Int8(0x29);
static const System::Int8 SQL_API_SQLDRIVERS = System::Int8(0x47);
static const System::Int8 SQL_API_SQLEXTENDEDFETCH = System::Int8(0x3b);
static const System::Int8 SQL_API_SQLFOREIGNKEYS = System::Int8(0x3c);
static const System::Int8 SQL_API_SQLMORERESULTS = System::Int8(0x3d);
static const System::Int8 SQL_API_SQLNATIVESQL = System::Int8(0x3e);
static const System::Int8 SQL_API_SQLNUMPARAMS = System::Int8(0x3f);
static const System::Int8 SQL_API_SQLPARAMOPTIONS = System::Int8(0x40);
static const System::Int8 SQL_API_SQLPRIMARYKEYS = System::Int8(0x41);
static const System::Int8 SQL_API_SQLPROCEDURECOLUMNS = System::Int8(0x42);
static const System::Int8 SQL_API_SQLPROCEDURES = System::Int8(0x43);
static const System::Int8 SQL_API_SQLSETPOS = System::Int8(0x44);
static const System::Int8 SQL_API_SQLSETSCROLLOPTIONS = System::Int8(0x45);
static const System::Int8 SQL_API_SQLTABLEPRIVILEGES = System::Int8(0x46);
static const System::Int8 SQL_API_ALL_FUNCTIONS = System::Int8(0x0);
static const System::Byte SQL_API_LOADBYORDINAL = System::Byte(0xc7);
static const System::Word SQL_API_ODBC3_ALL_FUNCTIONS = System::Word(0x3e7);
static const System::Byte SQL_API_ODBC3_ALL_FUNCTIONS_SIZE = System::Byte(0xfa);
static const System::Int8 SQL_INFO_FIRST = System::Int8(0x0);
static const System::Int8 SQL_ACTIVE_CONNECTIONS = System::Int8(0x0);
static const System::Int8 SQL_ACTIVE_STATEMENTS = System::Int8(0x1);
static const System::Int8 SQL_DRIVER_HDBC = System::Int8(0x3);
static const System::Int8 SQL_DRIVER_HENV = System::Int8(0x4);
static const System::Int8 SQL_DRIVER_HSTMT = System::Int8(0x5);
static const System::Int8 SQL_DRIVER_NAME = System::Int8(0x6);
static const System::Int8 SQL_DRIVER_VER = System::Int8(0x7);
static const System::Int8 SQL_ODBC_API_CONFORMANCE = System::Int8(0x9);
static const System::Int8 SQL_ODBC_VER = System::Int8(0xa);
static const System::Int8 SQL_ROW_UPDATES = System::Int8(0xb);
static const System::Int8 SQL_ODBC_SAG_CLI_CONFORMANCE = System::Int8(0xc);
static const System::Int8 SQL_ODBC_SQL_CONFORMANCE = System::Int8(0xf);
static const System::Int8 SQL_PROCEDURES = System::Int8(0x15);
static const System::Int8 SQL_CONCAT_NULL_BEHAVIOR = System::Int8(0x16);
static const System::Int8 SQL_CURSOR_ROLLBACK_BEHAVIOR = System::Int8(0x18);
static const System::Int8 SQL_EXPRESSIONS_IN_ORDERBY = System::Int8(0x1b);
static const System::Int8 SQL_MAX_OWNER_NAME_LEN = System::Int8(0x20);
static const System::Int8 SQL_MAX_PROCEDURE_NAME_LEN = System::Int8(0x21);
static const System::Int8 SQL_MAX_QUALIFIER_NAME_LEN = System::Int8(0x22);
static const System::Int8 SQL_MULT_RESULT_SETS = System::Int8(0x24);
static const System::Int8 SQL_MULTIPLE_ACTIVE_TXN = System::Int8(0x25);
static const System::Int8 SQL_OUTER_JOINS = System::Int8(0x26);
static const System::Int8 SQL_OWNER_TERM = System::Int8(0x27);
static const System::Int8 SQL_PROCEDURE_TERM = System::Int8(0x28);
static const System::Int8 SQL_QUALIFIER_NAME_SEPARATOR = System::Int8(0x29);
static const System::Int8 SQL_QUALIFIER_TERM = System::Int8(0x2a);
static const System::Int8 SQL_SCROLL_OPTIONS = System::Int8(0x2c);
static const System::Int8 SQL_TABLE_TERM = System::Int8(0x2d);
static const System::Int8 SQL_CONVERT_FUNCTIONS = System::Int8(0x30);
static const System::Int8 SQL_NUMERIC_FUNCTIONS = System::Int8(0x31);
static const System::Int8 SQL_STRING_FUNCTIONS = System::Int8(0x32);
static const System::Int8 SQL_SYSTEM_FUNCTIONS = System::Int8(0x33);
static const System::Int8 SQL_TIMEDATE_FUNCTIONS = System::Int8(0x34);
static const System::Int8 SQL_CONVERT_BIGINT = System::Int8(0x35);
static const System::Int8 SQL_CONVERT_BINARY = System::Int8(0x36);
static const System::Int8 SQL_CONVERT_BIT = System::Int8(0x37);
static const System::Int8 SQL_CONVERT_CHAR = System::Int8(0x38);
static const System::Int8 SQL_CONVERT_DATE = System::Int8(0x39);
static const System::Int8 SQL_CONVERT_DECIMAL = System::Int8(0x3a);
static const System::Int8 SQL_CONVERT_DOUBLE = System::Int8(0x3b);
static const System::Int8 SQL_CONVERT_FLOAT = System::Int8(0x3c);
static const System::Int8 SQL_CONVERT_INTEGER = System::Int8(0x3d);
static const System::Int8 SQL_CONVERT_LONGVARCHAR = System::Int8(0x3e);
static const System::Int8 SQL_CONVERT_NUMERIC = System::Int8(0x3f);
static const System::Int8 SQL_CONVERT_REAL = System::Int8(0x40);
static const System::Int8 SQL_CONVERT_SMALLINT = System::Int8(0x41);
static const System::Int8 SQL_CONVERT_TIME = System::Int8(0x42);
static const System::Int8 SQL_CONVERT_TIMESTAMP = System::Int8(0x43);
static const System::Int8 SQL_CONVERT_TINYINT = System::Int8(0x44);
static const System::Int8 SQL_CONVERT_VARBINARY = System::Int8(0x45);
static const System::Int8 SQL_CONVERT_VARCHAR = System::Int8(0x46);
static const System::Int8 SQL_CONVERT_LONGVARBINARY = System::Int8(0x47);
static const System::Int8 SQL_ODBC_SQL_OPT_IEF = System::Int8(0x49);
static const System::Int8 SQL_CORRELATION_NAME = System::Int8(0x4a);
static const System::Int8 SQL_NON_NULLABLE_COLUMNS = System::Int8(0x4b);
static const System::Int8 SQL_DRIVER_HLIB = System::Int8(0x4c);
static const System::Int8 SQL_DRIVER_ODBC_VER = System::Int8(0x4d);
static const System::Int8 SQL_LOCK_TYPES = System::Int8(0x4e);
static const System::Int8 SQL_POS_OPERATIONS = System::Int8(0x4f);
static const System::Int8 SQL_POSITIONED_STATEMENTS = System::Int8(0x50);
static const System::Int8 SQL_BOOKMARK_PERSISTENCE = System::Int8(0x52);
static const System::Int8 SQL_STATIC_SENSITIVITY = System::Int8(0x53);
static const System::Int8 SQL_FILE_USAGE = System::Int8(0x54);
static const System::Int8 SQL_COLUMN_ALIAS = System::Int8(0x57);
static const System::Int8 SQL_GROUP_BY = System::Int8(0x58);
static const System::Int8 SQL_KEYWORDS = System::Int8(0x59);
static const System::Int8 SQL_OWNER_USAGE = System::Int8(0x5b);
static const System::Int8 SQL_QUALIFIER_USAGE = System::Int8(0x5c);
static const System::Int8 SQL_QUOTED_IDENTIFIER_CASE = System::Int8(0x5d);
static const System::Int8 SQL_SUBQUERIES = System::Int8(0x5f);
static const System::Int8 SQL_UNION = System::Int8(0x60);
static const System::Int8 SQL_MAX_ROW_SIZE_INCLUDES_LONG = System::Int8(0x67);
static const System::Int8 SQL_MAX_CHAR_LITERAL_LEN = System::Int8(0x6c);
static const System::Int8 SQL_TIMEDATE_ADD_INTERVALS = System::Int8(0x6d);
static const System::Int8 SQL_TIMEDATE_DIFF_INTERVALS = System::Int8(0x6e);
static const System::Int8 SQL_NEED_LONG_DATA_LEN = System::Int8(0x6f);
static const System::Int8 SQL_MAX_BINARY_LITERAL_LEN = System::Int8(0x70);
static const System::Int8 SQL_LIKE_ESCAPE_CLAUSE = System::Int8(0x71);
static const System::Int8 SQL_QUALIFIER_LOCATION = System::Int8(0x72);
static const System::Int8 SQL_ACTIVE_ENVIRONMENTS = System::Int8(0x74);
static const System::Int8 SQL_ALTER_DOMAIN = System::Int8(0x75);
static const System::Int8 SQL_SQL_CONFORMANCE = System::Int8(0x76);
static const System::Int8 SQL_DATETIME_LITERALS = System::Int8(0x77);
static const System::Word SQL_ASYNC_MODE = System::Word(0x2725);
static const System::Int8 SQL_BATCH_ROW_COUNT = System::Int8(0x78);
static const System::Int8 SQL_BATCH_SUPPORT = System::Int8(0x79);
static const System::Int8 SQL_CATALOG_LOCATION = System::Int8(0x72);
static const System::Int8 SQL_CATALOG_NAME_SEPARATOR = System::Int8(0x29);
static const System::Int8 SQL_CATALOG_TERM = System::Int8(0x2a);
static const System::Int8 SQL_CATALOG_USAGE = System::Int8(0x5c);
static const System::Int8 SQL_CONVERT_WCHAR = System::Int8(0x7a);
static const System::Int8 SQL_CONVERT_INTERVAL_DAY_TIME = System::Int8(0x7b);
static const System::Int8 SQL_CONVERT_INTERVAL_YEAR_MONTH = System::Int8(0x7c);
static const System::Int8 SQL_CONVERT_WLONGVARCHAR = System::Int8(0x7d);
static const System::Int8 SQL_CONVERT_WVARCHAR = System::Int8(0x7e);
static const System::Int8 SQL_CREATE_ASSERTION = System::Int8(0x7f);
static const System::Byte SQL_CREATE_CHARACTER_SET = System::Byte(0x80);
static const System::Byte SQL_CREATE_COLLATION = System::Byte(0x81);
static const System::Byte SQL_CREATE_DOMAIN = System::Byte(0x82);
static const System::Byte SQL_CREATE_SCHEMA = System::Byte(0x83);
static const System::Byte SQL_CREATE_TABLE = System::Byte(0x84);
static const System::Byte SQL_CREATE_TRANSLATION = System::Byte(0x85);
static const System::Byte SQL_CREATE_VIEW = System::Byte(0x86);
static const System::Byte SQL_DRIVER_HDESC = System::Byte(0x87);
static const System::Byte SQL_DROP_ASSERTION = System::Byte(0x88);
static const System::Byte SQL_DROP_CHARACTER_SET = System::Byte(0x89);
static const System::Byte SQL_DROP_COLLATION = System::Byte(0x8a);
static const System::Byte SQL_DROP_DOMAIN = System::Byte(0x8b);
static const System::Byte SQL_DROP_SCHEMA = System::Byte(0x8c);
static const System::Byte SQL_DROP_TABLE = System::Byte(0x8d);
static const System::Byte SQL_DROP_TRANSLATION = System::Byte(0x8e);
static const System::Byte SQL_DROP_VIEW = System::Byte(0x8f);
static const System::Byte SQL_DYNAMIC_CURSOR_ATTRIBUTES1 = System::Byte(0x90);
static const System::Byte SQL_DYNAMIC_CURSOR_ATTRIBUTES2 = System::Byte(0x91);
static const System::Byte SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1 = System::Byte(0x92);
static const System::Byte SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2 = System::Byte(0x93);
static const System::Byte SQL_INDEX_KEYWORDS = System::Byte(0x94);
static const System::Byte SQL_INFO_SCHEMA_VIEWS = System::Byte(0x95);
static const System::Byte SQL_KEYSET_CURSOR_ATTRIBUTES1 = System::Byte(0x96);
static const System::Byte SQL_KEYSET_CURSOR_ATTRIBUTES2 = System::Byte(0x97);
static const System::Word SQL_MAX_ASYNC_CONCURRENT_STATEMENTS = System::Word(0x2726);
static const System::Byte SQL_ODBC_INTERFACE_CONFORMANCE = System::Byte(0x98);
static const System::Byte SQL_PARAM_ARRAY_ROW_COUNTS = System::Byte(0x99);
static const System::Byte SQL_PARAM_ARRAY_SELECTS = System::Byte(0x9a);
static const System::Int8 SQL_SCHEMA_TERM = System::Int8(0x27);
static const System::Int8 SQL_SCHEMA_USAGE = System::Int8(0x5b);
static const System::Byte SQL_SQL92_DATETIME_FUNCTIONS = System::Byte(0x9b);
static const System::Byte SQL_SQL92_FOREIGN_KEY_DELETE_RULE = System::Byte(0x9c);
static const System::Byte SQL_SQL92_FOREIGN_KEY_UPDATE_RULE = System::Byte(0x9d);
static const System::Byte SQL_SQL92_GRANT = System::Byte(0x9e);
static const System::Byte SQL_SQL92_NUMERIC_VALUE_FUNCTIONS = System::Byte(0x9f);
static const System::Byte SQL_SQL92_PREDICATES = System::Byte(0xa0);
static const System::Byte SQL_SQL92_RELATIONAL_JOIN_OPERATORS = System::Byte(0xa1);
static const System::Byte SQL_SQL92_REVOKE = System::Byte(0xa2);
static const System::Byte SQL_SQL92_ROW_VALUE_CONSTRUCTOR = System::Byte(0xa3);
static const System::Byte SQL_SQL92_STRING_FUNCTIONS = System::Byte(0xa4);
static const System::Byte SQL_SQL92_VALUE_EXPRESSIONS = System::Byte(0xa5);
static const System::Byte SQL_STANDARD_CLI_CONFORMANCE = System::Byte(0xa6);
static const System::Byte SQL_STATIC_CURSOR_ATTRIBUTES1 = System::Byte(0xa7);
static const System::Byte SQL_STATIC_CURSOR_ATTRIBUTES2 = System::Byte(0xa8);
static const System::Byte SQL_AGGREGATE_FUNCTIONS = System::Byte(0xa9);
static const System::Byte SQL_DDL_INDEX = System::Byte(0xaa);
static const System::Byte SQL_DM_VER = System::Byte(0xab);
static const System::Byte SQL_INSERT_STATEMENT = System::Byte(0xac);
static const System::Byte SQL_CONVERT_GUID = System::Byte(0xad);
static const System::Int8 SQL_UNION_STATEMENT = System::Int8(0x60);
static const System::Word SQL_DTC_TRANSITION_COST = System::Word(0x6d6);
static const System::Int8 SQL_CVT_CHAR = System::Int8(0x1);
static const System::Int8 SQL_CVT_NUMERIC = System::Int8(0x2);
static const System::Int8 SQL_CVT_DECIMAL = System::Int8(0x4);
static const System::Int8 SQL_CVT_INTEGER = System::Int8(0x8);
static const System::Int8 SQL_CVT_SMALLINT = System::Int8(0x10);
static const System::Int8 SQL_CVT_FLOAT = System::Int8(0x20);
static const System::Int8 SQL_CVT_REAL = System::Int8(0x40);
static const System::Byte SQL_CVT_DOUBLE = System::Byte(0x80);
static const System::Word SQL_CVT_VARCHAR = System::Word(0x100);
static const System::Word SQL_CVT_LONGVARCHAR = System::Word(0x200);
static const System::Word SQL_CVT_BINARY = System::Word(0x400);
static const System::Word SQL_CVT_VARBINARY = System::Word(0x800);
static const System::Word SQL_CVT_BIT = System::Word(0x1000);
static const System::Word SQL_CVT_TINYINT = System::Word(0x2000);
static const System::Word SQL_CVT_BIGINT = System::Word(0x4000);
static const System::Word SQL_CVT_DATE = System::Word(0x8000);
static const int SQL_CVT_TIME = int(0x10000);
static const int SQL_CVT_TIMESTAMP = int(0x20000);
static const int SQL_CVT_LONGVARBINARY = int(0x40000);
static const int SQL_CVT_INTERVAL_YEAR_MONTH = int(0x80000);
static const int SQL_CVT_INTERVAL_DAY_TIME = int(0x100000);
static const int SQL_CVT_WCHAR = int(0x200000);
static const int SQL_CVT_WLONGVARCHAR = int(0x400000);
static const int SQL_CVT_WVARCHAR = int(0x800000);
static const int SQL_CVT_GUID = int(0x1000000);
static const System::Int8 SQL_FN_CVT_CONVERT = System::Int8(0x1);
static const System::Int8 SQL_FN_CVT_CAST = System::Int8(0x2);
static const System::Int8 SQL_FN_STR_CONCAT = System::Int8(0x1);
static const System::Int8 SQL_FN_STR_INSERT = System::Int8(0x2);
static const System::Int8 SQL_FN_STR_LEFT = System::Int8(0x4);
static const System::Int8 SQL_FN_STR_LTRIM = System::Int8(0x8);
static const System::Int8 SQL_FN_STR_LENGTH = System::Int8(0x10);
static const System::Int8 SQL_FN_STR_LOCATE = System::Int8(0x20);
static const System::Int8 SQL_FN_STR_LCASE = System::Int8(0x40);
static const System::Byte SQL_FN_STR_REPEAT = System::Byte(0x80);
static const System::Word SQL_FN_STR_REPLACE = System::Word(0x100);
static const System::Word SQL_FN_STR_RIGHT = System::Word(0x200);
static const System::Word SQL_FN_STR_RTRIM = System::Word(0x400);
static const System::Word SQL_FN_STR_SUBSTRING = System::Word(0x800);
static const System::Word SQL_FN_STR_UCASE = System::Word(0x1000);
static const System::Word SQL_FN_STR_ASCII = System::Word(0x2000);
static const System::Word SQL_FN_STR_CHAR = System::Word(0x4000);
static const System::Word SQL_FN_STR_DIFFERENCE = System::Word(0x8000);
static const int SQL_FN_STR_LOCATE_2 = int(0x10000);
static const int SQL_FN_STR_SOUNDEX = int(0x20000);
static const int SQL_FN_STR_SPACE = int(0x40000);
static const int SQL_FN_STR_BIT_LENGTH = int(0x80000);
static const int SQL_FN_STR_CHAR_LENGTH = int(0x100000);
static const int SQL_FN_STR_CHARACTER_LENGTH = int(0x200000);
static const int SQL_FN_STR_OCTET_LENGTH = int(0x400000);
static const int SQL_FN_STR_POSITION = int(0x800000);
static const System::Int8 SQL_SSF_CONVERT = System::Int8(0x1);
static const System::Int8 SQL_SSF_LOWER = System::Int8(0x2);
static const System::Int8 SQL_SSF_UPPER = System::Int8(0x4);
static const System::Int8 SQL_SSF_SUBSTRING = System::Int8(0x8);
static const System::Int8 SQL_SSF_TRANSLATE = System::Int8(0x10);
static const System::Int8 SQL_SSF_TRIM_BOTH = System::Int8(0x20);
static const System::Int8 SQL_SSF_TRIM_LEADING = System::Int8(0x40);
static const System::Byte SQL_SSF_TRIM_TRAILING = System::Byte(0x80);
static const System::Int8 SQL_FN_NUM_ABS = System::Int8(0x1);
static const System::Int8 SQL_FN_NUM_ACOS = System::Int8(0x2);
static const System::Int8 SQL_FN_NUM_ASIN = System::Int8(0x4);
static const System::Int8 SQL_FN_NUM_ATAN = System::Int8(0x8);
static const System::Int8 SQL_FN_NUM_ATAN2 = System::Int8(0x10);
static const System::Int8 SQL_FN_NUM_CEILING = System::Int8(0x20);
static const System::Int8 SQL_FN_NUM_COS = System::Int8(0x40);
static const System::Byte SQL_FN_NUM_COT = System::Byte(0x80);
static const System::Word SQL_FN_NUM_EXP = System::Word(0x100);
static const System::Word SQL_FN_NUM_FLOOR = System::Word(0x200);
static const System::Word SQL_FN_NUM_LOG = System::Word(0x400);
static const System::Word SQL_FN_NUM_MOD = System::Word(0x800);
static const System::Word SQL_FN_NUM_SIGN = System::Word(0x1000);
static const System::Word SQL_FN_NUM_SIN = System::Word(0x2000);
static const System::Word SQL_FN_NUM_SQRT = System::Word(0x4000);
static const System::Word SQL_FN_NUM_TAN = System::Word(0x8000);
static const int SQL_FN_NUM_PI = int(0x10000);
static const int SQL_FN_NUM_RAND = int(0x20000);
static const int SQL_FN_NUM_DEGREES = int(0x40000);
static const int SQL_FN_NUM_LOG10 = int(0x80000);
static const int SQL_FN_NUM_POWER = int(0x100000);
static const int SQL_FN_NUM_RADIANS = int(0x200000);
static const int SQL_FN_NUM_ROUND = int(0x400000);
static const int SQL_FN_NUM_TRUNCATE = int(0x800000);
static const System::Int8 SQL_SNVF_BIT_LENGTH = System::Int8(0x1);
static const System::Int8 SQL_SNVF_CHAR_LENGTH = System::Int8(0x2);
static const System::Int8 SQL_SNVF_CHARACTER_LENGTH = System::Int8(0x4);
static const System::Int8 SQL_SNVF_EXTRACT = System::Int8(0x8);
static const System::Int8 SQL_SNVF_OCTET_LENGTH = System::Int8(0x10);
static const System::Int8 SQL_SNVF_POSITION = System::Int8(0x20);
static const System::Int8 SQL_FN_TD_NOW = System::Int8(0x1);
static const System::Int8 SQL_FN_TD_CURDATE = System::Int8(0x2);
static const System::Int8 SQL_FN_TD_DAYOFMONTH = System::Int8(0x4);
static const System::Int8 SQL_FN_TD_DAYOFWEEK = System::Int8(0x8);
static const System::Int8 SQL_FN_TD_DAYOFYEAR = System::Int8(0x10);
static const System::Int8 SQL_FN_TD_MONTH = System::Int8(0x20);
static const System::Int8 SQL_FN_TD_QUARTER = System::Int8(0x40);
static const System::Byte SQL_FN_TD_WEEK = System::Byte(0x80);
static const System::Word SQL_FN_TD_YEAR = System::Word(0x100);
static const System::Word SQL_FN_TD_CURTIME = System::Word(0x200);
static const System::Word SQL_FN_TD_HOUR = System::Word(0x400);
static const System::Word SQL_FN_TD_MINUTE = System::Word(0x800);
static const System::Word SQL_FN_TD_SECOND = System::Word(0x1000);
static const System::Word SQL_FN_TD_TIMESTAMPADD = System::Word(0x2000);
static const System::Word SQL_FN_TD_TIMESTAMPDIFF = System::Word(0x4000);
static const System::Word SQL_FN_TD_DAYNAME = System::Word(0x8000);
static const int SQL_FN_TD_MONTHNAME = int(0x10000);
static const int SQL_FN_TD_CURRENT_DATE = int(0x20000);
static const int SQL_FN_TD_CURRENT_TIME = int(0x40000);
static const int SQL_FN_TD_CURRENT_TIMESTAMP = int(0x80000);
static const int SQL_FN_TD_EXTRACT = int(0x100000);
static const System::Int8 SQL_SDF_CURRENT_DATE = System::Int8(0x1);
static const System::Int8 SQL_SDF_CURRENT_TIME = System::Int8(0x2);
static const System::Int8 SQL_SDF_CURRENT_TIMESTAMP = System::Int8(0x4);
static const System::Int8 SQL_FN_SYS_USERNAME = System::Int8(0x1);
static const System::Int8 SQL_FN_SYS_DBNAME = System::Int8(0x2);
static const System::Int8 SQL_FN_SYS_IFNULL = System::Int8(0x4);
static const System::Int8 SQL_FN_TSI_FRAC_SECOND = System::Int8(0x1);
static const System::Int8 SQL_FN_TSI_SECOND = System::Int8(0x2);
static const System::Int8 SQL_FN_TSI_MINUTE = System::Int8(0x4);
static const System::Int8 SQL_FN_TSI_HOUR = System::Int8(0x8);
static const System::Int8 SQL_FN_TSI_DAY = System::Int8(0x10);
static const System::Int8 SQL_FN_TSI_WEEK = System::Int8(0x20);
static const System::Int8 SQL_FN_TSI_MONTH = System::Int8(0x40);
static const System::Byte SQL_FN_TSI_QUARTER = System::Byte(0x80);
static const System::Word SQL_FN_TSI_YEAR = System::Word(0x100);
static const System::Int8 SQL_CA1_NEXT = System::Int8(0x1);
static const System::Int8 SQL_CA1_ABSOLUTE = System::Int8(0x2);
static const System::Int8 SQL_CA1_RELATIVE = System::Int8(0x4);
static const System::Int8 SQL_CA1_BOOKMARK = System::Int8(0x8);
static const System::Int8 SQL_CA1_LOCK_NO_CHANGE = System::Int8(0x40);
static const System::Byte SQL_CA1_LOCK_EXCLUSIVE = System::Byte(0x80);
static const System::Word SQL_CA1_LOCK_UNLOCK = System::Word(0x100);
static const System::Word SQL_CA1_POS_POSITION = System::Word(0x200);
static const System::Word SQL_CA1_POS_UPDATE = System::Word(0x400);
static const System::Word SQL_CA1_POS_DELETE = System::Word(0x800);
static const System::Word SQL_CA1_POS_REFRESH = System::Word(0x1000);
static const System::Word SQL_CA1_POSITIONED_UPDATE = System::Word(0x2000);
static const System::Word SQL_CA1_POSITIONED_DELETE = System::Word(0x4000);
static const System::Word SQL_CA1_SELECT_FOR_UPDATE = System::Word(0x8000);
static const int SQL_CA1_BULK_ADD = int(0x10000);
static const int SQL_CA1_BULK_UPDATE_BY_BOOKMARK = int(0x20000);
static const int SQL_CA1_BULK_DELETE_BY_BOOKMARK = int(0x40000);
static const int SQL_CA1_BULK_FETCH_BY_BOOKMARK = int(0x80000);
static const System::Int8 SQL_CA2_READ_ONLY_CONCURRENCY = System::Int8(0x1);
static const System::Int8 SQL_CA2_LOCK_CONCURRENCY = System::Int8(0x2);
static const System::Int8 SQL_CA2_OPT_ROWVER_CONCURRENCY = System::Int8(0x4);
static const System::Int8 SQL_CA2_OPT_VALUES_CONCURRENCY = System::Int8(0x8);
static const System::Int8 SQL_CA2_SENSITIVITY_ADDITIONS = System::Int8(0x10);
static const System::Int8 SQL_CA2_SENSITIVITY_DELETIONS = System::Int8(0x20);
static const System::Int8 SQL_CA2_SENSITIVITY_UPDATES = System::Int8(0x40);
static const System::Byte SQL_CA2_MAX_ROWS_SELECT = System::Byte(0x80);
static const System::Word SQL_CA2_MAX_ROWS_INSERT = System::Word(0x100);
static const System::Word SQL_CA2_MAX_ROWS_DELETE = System::Word(0x200);
static const System::Word SQL_CA2_MAX_ROWS_UPDATE = System::Word(0x400);
static const System::Word SQL_CA2_MAX_ROWS_CATALOG = System::Word(0x800);
static const System::Word SQL_CA2_MAX_ROWS_AFFECTS_ALL = System::Word(0xf80);
static const System::Word SQL_CA2_CRC_EXACT = System::Word(0x1000);
static const System::Word SQL_CA2_CRC_APPROXIMATE = System::Word(0x2000);
static const System::Word SQL_CA2_SIMULATE_NON_UNIQUE = System::Word(0x4000);
static const System::Word SQL_CA2_SIMULATE_TRY_UNIQUE = System::Word(0x8000);
static const int SQL_CA2_SIMULATE_UNIQUE = int(0x10000);
static const System::Int8 SQL_OAC_NONE = System::Int8(0x0);
static const System::Int8 SQL_OAC_LEVEL1 = System::Int8(0x1);
static const System::Int8 SQL_OAC_LEVEL2 = System::Int8(0x2);
static const System::Int8 SQL_OSCC_NOT_COMPLIANT = System::Int8(0x0);
static const System::Int8 SQL_OSCC_COMPLIANT = System::Int8(0x1);
static const System::Int8 SQL_OSC_MINIMUM = System::Int8(0x0);
static const System::Int8 SQL_OSC_CORE = System::Int8(0x1);
static const System::Int8 SQL_OSC_EXTENDED = System::Int8(0x2);
static const System::Int8 SQL_CB_NULL = System::Int8(0x0);
static const System::Int8 SQL_CB_NON_NULL = System::Int8(0x1);
static const System::Int8 SQL_SO_FORWARD_ONLY = System::Int8(0x1);
static const System::Int8 SQL_SO_KEYSET_DRIVEN = System::Int8(0x2);
static const System::Int8 SQL_SO_DYNAMIC = System::Int8(0x4);
static const System::Int8 SQL_SO_MIXED = System::Int8(0x8);
static const System::Int8 SQL_SO_STATIC = System::Int8(0x10);
static const System::Int8 SQL_FD_FETCH_RESUME = System::Int8(0x40);
static const System::Byte SQL_FD_FETCH_BOOKMARK = System::Byte(0x80);
static const System::Int8 SQL_TXN_VERSIONING = System::Int8(0x10);
static const System::Int8 SQL_CN_NONE = System::Int8(0x0);
static const System::Int8 SQL_CN_DIFFERENT = System::Int8(0x1);
static const System::Int8 SQL_CN_ANY = System::Int8(0x2);
static const System::Int8 SQL_NNC_NULL = System::Int8(0x0);
static const System::Int8 SQL_NNC_NON_NULL = System::Int8(0x1);
static const System::Int8 SQL_NC_START = System::Int8(0x2);
static const System::Int8 SQL_NC_END = System::Int8(0x4);
static const System::Int8 SQL_FILE_NOT_SUPPORTED = System::Int8(0x0);
static const System::Int8 SQL_FILE_TABLE = System::Int8(0x1);
static const System::Int8 SQL_FILE_QUALIFIER = System::Int8(0x2);
static const System::Int8 SQL_FILE_CATALOG = System::Int8(0x2);
static const System::Int8 SQL_GD_BLOCK = System::Int8(0x4);
static const System::Int8 SQL_GD_BOUND = System::Int8(0x8);
static const System::Int8 SQL_PS_POSITIONED_DELETE = System::Int8(0x1);
static const System::Int8 SQL_PS_POSITIONED_UPDATE = System::Int8(0x2);
static const System::Int8 SQL_PS_SELECT_FOR_UPDATE = System::Int8(0x4);
static const System::Int8 SQL_GB_NOT_SUPPORTED = System::Int8(0x0);
static const System::Int8 SQL_GB_GROUP_BY_EQUALS_SELECT = System::Int8(0x1);
static const System::Int8 SQL_GB_GROUP_BY_CONTAINS_SELECT = System::Int8(0x2);
static const System::Int8 SQL_GB_NO_RELATION = System::Int8(0x3);
static const System::Int8 SQL_GB_COLLATE = System::Int8(0x4);
static const System::Int8 SQL_OU_DML_STATEMENTS = System::Int8(0x1);
static const System::Int8 SQL_OU_PROCEDURE_INVOCATION = System::Int8(0x2);
static const System::Int8 SQL_OU_TABLE_DEFINITION = System::Int8(0x4);
static const System::Int8 SQL_OU_INDEX_DEFINITION = System::Int8(0x8);
static const System::Int8 SQL_OU_PRIVILEGE_DEFINITION = System::Int8(0x10);
static const System::Int8 SQL_SU_DML_STATEMENTS = System::Int8(0x1);
static const System::Int8 SQL_SU_PROCEDURE_INVOCATION = System::Int8(0x2);
static const System::Int8 SQL_SU_TABLE_DEFINITION = System::Int8(0x4);
static const System::Int8 SQL_SU_INDEX_DEFINITION = System::Int8(0x8);
static const System::Int8 SQL_SU_PRIVILEGE_DEFINITION = System::Int8(0x10);
static const System::Int8 SQL_QU_DML_STATEMENTS = System::Int8(0x1);
static const System::Int8 SQL_QU_PROCEDURE_INVOCATION = System::Int8(0x2);
static const System::Int8 SQL_QU_TABLE_DEFINITION = System::Int8(0x4);
static const System::Int8 SQL_QU_INDEX_DEFINITION = System::Int8(0x8);
static const System::Int8 SQL_QU_PRIVILEGE_DEFINITION = System::Int8(0x10);
static const System::Int8 SQL_CU_DML_STATEMENTS = System::Int8(0x1);
static const System::Int8 SQL_CU_PROCEDURE_INVOCATION = System::Int8(0x2);
static const System::Int8 SQL_CU_TABLE_DEFINITION = System::Int8(0x4);
static const System::Int8 SQL_CU_INDEX_DEFINITION = System::Int8(0x8);
static const System::Int8 SQL_CU_PRIVILEGE_DEFINITION = System::Int8(0x10);
static const System::Int8 SQL_SQ_COMPARISON = System::Int8(0x1);
static const System::Int8 SQL_SQ_EXISTS = System::Int8(0x2);
static const System::Int8 SQL_SQ_IN = System::Int8(0x4);
static const System::Int8 SQL_SQ_QUANTIFIED = System::Int8(0x8);
static const System::Int8 SQL_SQ_CORRELATED_SUBQUERIES = System::Int8(0x10);
static const System::Int8 SQL_U_UNION = System::Int8(0x1);
static const System::Int8 SQL_U_UNION_ALL = System::Int8(0x2);
static const System::Int8 SQL_BP_CLOSE = System::Int8(0x1);
static const System::Int8 SQL_BP_DELETE = System::Int8(0x2);
static const System::Int8 SQL_BP_DROP = System::Int8(0x4);
static const System::Int8 SQL_BP_TRANSACTION = System::Int8(0x8);
static const System::Int8 SQL_BP_UPDATE = System::Int8(0x10);
static const System::Int8 SQL_BP_OTHER_HSTMT = System::Int8(0x20);
static const System::Int8 SQL_BP_SCROLL = System::Int8(0x40);
static const System::Int8 SQL_SS_ADDITIONS = System::Int8(0x1);
static const System::Int8 SQL_SS_DELETIONS = System::Int8(0x2);
static const System::Int8 SQL_SS_UPDATES = System::Int8(0x4);
static const System::Int8 SQL_CV_CREATE_VIEW = System::Int8(0x1);
static const System::Int8 SQL_CV_CHECK_OPTION = System::Int8(0x2);
static const System::Int8 SQL_CV_CASCADED = System::Int8(0x4);
static const System::Int8 SQL_CV_LOCAL = System::Int8(0x8);
static const System::Int8 SQL_LCK_NO_CHANGE = System::Int8(0x1);
static const System::Int8 SQL_LCK_EXCLUSIVE = System::Int8(0x2);
static const System::Int8 SQL_LCK_UNLOCK = System::Int8(0x4);
static const System::Int8 SQL_POS_POSITION = System::Int8(0x1);
static const System::Int8 SQL_POS_REFRESH = System::Int8(0x2);
static const System::Int8 SQL_POS_UPDATE = System::Int8(0x4);
static const System::Int8 SQL_POS_DELETE = System::Int8(0x8);
static const System::Int8 SQL_POS_ADD = System::Int8(0x10);
static const System::Int8 SQL_QL_START = System::Int8(0x1);
static const System::Int8 SQL_QL_END = System::Int8(0x2);
static const System::Int8 SQL_AF_AVG = System::Int8(0x1);
static const System::Int8 SQL_AF_COUNT = System::Int8(0x2);
static const System::Int8 SQL_AF_MAX = System::Int8(0x4);
static const System::Int8 SQL_AF_MIN = System::Int8(0x8);
static const System::Int8 SQL_AF_SUM = System::Int8(0x10);
static const System::Int8 SQL_AF_DISTINCT = System::Int8(0x20);
static const System::Int8 SQL_AF_ALL = System::Int8(0x40);
static const System::Int8 SQL_SC_SQL92_ENTRY = System::Int8(0x1);
static const System::Int8 SQL_SC_FIPS127_2_TRANSITIONAL = System::Int8(0x2);
static const System::Int8 SQL_SC_SQL92_INTERMEDIATE = System::Int8(0x4);
static const System::Int8 SQL_SC_SQL92_FULL = System::Int8(0x8);
static const System::Int8 SQL_DL_SQL92_DATE = System::Int8(0x1);
static const System::Int8 SQL_DL_SQL92_TIME = System::Int8(0x2);
static const System::Int8 SQL_DL_SQL92_TIMESTAMP = System::Int8(0x4);
static const System::Int8 SQL_DL_SQL92_INTERVAL_YEAR = System::Int8(0x8);
static const System::Int8 SQL_DL_SQL92_INTERVAL_MONTH = System::Int8(0x10);
static const System::Int8 SQL_DL_SQL92_INTERVAL_DAY = System::Int8(0x20);
static const System::Int8 SQL_DL_SQL92_INTERVAL_HOUR = System::Int8(0x40);
static const System::Byte SQL_DL_SQL92_INTERVAL_MINUTE = System::Byte(0x80);
static const System::Word SQL_DL_SQL92_INTERVAL_SECOND = System::Word(0x100);
static const System::Word SQL_DL_SQL92_INTERVAL_YEAR_TO_MONTH = System::Word(0x200);
static const System::Word SQL_DL_SQL92_INTERVAL_DAY_TO_HOUR = System::Word(0x400);
static const System::Word SQL_DL_SQL92_INTERVAL_DAY_TO_MINUTE = System::Word(0x800);
static const System::Word SQL_DL_SQL92_INTERVAL_DAY_TO_SECOND = System::Word(0x1000);
static const System::Word SQL_DL_SQL92_INTERVAL_HOUR_TO_MINUTE = System::Word(0x2000);
static const System::Word SQL_DL_SQL92_INTERVAL_HOUR_TO_SECOND = System::Word(0x4000);
static const System::Word SQL_DL_SQL92_INTERVAL_MINUTE_TO_SECOND = System::Word(0x8000);
static const System::Int8 SQL_CL_START = System::Int8(0x1);
static const System::Int8 SQL_CL_END = System::Int8(0x2);
static const System::Int8 SQL_BRC_PROCEDURES = System::Int8(0x1);
static const System::Int8 SQL_BRC_EXPLICIT = System::Int8(0x2);
static const System::Int8 SQL_BRC_ROLLED_UP = System::Int8(0x4);
static const System::Int8 SQL_BS_SELECT_EXPLICIT = System::Int8(0x1);
static const System::Int8 SQL_BS_ROW_COUNT_EXPLICIT = System::Int8(0x2);
static const System::Int8 SQL_BS_SELECT_PROC = System::Int8(0x4);
static const System::Int8 SQL_BS_ROW_COUNT_PROC = System::Int8(0x8);
static const System::Int8 SQL_PARC_BATCH = System::Int8(0x1);
static const System::Int8 SQL_PARC_NO_BATCH = System::Int8(0x2);
static const System::Int8 SQL_PAS_BATCH = System::Int8(0x1);
static const System::Int8 SQL_PAS_NO_BATCH = System::Int8(0x2);
static const System::Int8 SQL_PAS_NO_SELECT = System::Int8(0x3);
static const System::Int8 SQL_IK_NONE = System::Int8(0x0);
static const System::Int8 SQL_IK_ASC = System::Int8(0x1);
static const System::Int8 SQL_IK_DESC = System::Int8(0x2);
static const System::Int8 SQL_IK_ALL = System::Int8(0x3);
static const System::Int8 SQL_ISV_ASSERTIONS = System::Int8(0x1);
static const System::Int8 SQL_ISV_CHARACTER_SETS = System::Int8(0x2);
static const System::Int8 SQL_ISV_CHECK_CONSTRAINTS = System::Int8(0x4);
static const System::Int8 SQL_ISV_COLLATIONS = System::Int8(0x8);
static const System::Int8 SQL_ISV_COLUMN_DOMAIN_USAGE = System::Int8(0x10);
static const System::Int8 SQL_ISV_COLUMN_PRIVILEGES = System::Int8(0x20);
static const System::Int8 SQL_ISV_COLUMNS = System::Int8(0x40);
static const System::Byte SQL_ISV_CONSTRAINT_COLUMN_USAGE = System::Byte(0x80);
static const System::Word SQL_ISV_CONSTRAINT_TABLE_USAGE = System::Word(0x100);
static const System::Word SQL_ISV_DOMAIN_CONSTRAINTS = System::Word(0x200);
static const System::Word SQL_ISV_DOMAINS = System::Word(0x400);
static const System::Word SQL_ISV_KEY_COLUMN_USAGE = System::Word(0x800);
static const System::Word SQL_ISV_REFERENTIAL_CONSTRAINTS = System::Word(0x1000);
static const System::Word SQL_ISV_SCHEMATA = System::Word(0x2000);
static const System::Word SQL_ISV_SQL_LANGUAGES = System::Word(0x4000);
static const System::Word SQL_ISV_TABLE_CONSTRAINTS = System::Word(0x8000);
static const int SQL_ISV_TABLE_PRIVILEGES = int(0x10000);
static const int SQL_ISV_TABLES = int(0x20000);
static const int SQL_ISV_TRANSLATIONS = int(0x40000);
static const int SQL_ISV_USAGE_PRIVILEGES = int(0x80000);
static const int SQL_ISV_VIEW_COLUMN_USAGE = int(0x100000);
static const int SQL_ISV_VIEW_TABLE_USAGE = int(0x200000);
static const int SQL_ISV_VIEWS = int(0x400000);
static const System::Int8 SQL_AD_CONSTRAINT_NAME_DEFINITION = System::Int8(0x1);
static const System::Int8 SQL_AD_ADD_DOMAIN_CONSTRAINT = System::Int8(0x2);
static const System::Int8 SQL_AD_DROP_DOMAIN_CONSTRAINT = System::Int8(0x4);
static const System::Int8 SQL_AD_ADD_DOMAIN_DEFAULT = System::Int8(0x8);
static const System::Int8 SQL_AD_DROP_DOMAIN_DEFAULT = System::Int8(0x10);
static const System::Int8 SQL_AD_ADD_CONSTRAINT_INITIALLY_DEFERRED = System::Int8(0x20);
static const System::Int8 SQL_AD_ADD_CONSTRAINT_INITIALLY_IMMEDIATE = System::Int8(0x40);
static const System::Byte SQL_AD_ADD_CONSTRAINT_DEFERRABLE = System::Byte(0x80);
static const System::Word SQL_AD_ADD_CONSTRAINT_NON_DEFERRABLE = System::Word(0x100);
static const System::Int8 SQL_CS_CREATE_SCHEMA = System::Int8(0x1);
static const System::Int8 SQL_CS_AUTHORIZATION = System::Int8(0x2);
static const System::Int8 SQL_CS_DEFAULT_CHARACTER_SET = System::Int8(0x4);
static const System::Int8 SQL_CTR_CREATE_TRANSLATION = System::Int8(0x1);
static const System::Int8 SQL_CA_CREATE_ASSERTION = System::Int8(0x1);
static const System::Int8 SQL_CA_CONSTRAINT_INITIALLY_DEFERRED = System::Int8(0x10);
static const System::Int8 SQL_CA_CONSTRAINT_INITIALLY_IMMEDIATE = System::Int8(0x20);
static const System::Int8 SQL_CA_CONSTRAINT_DEFERRABLE = System::Int8(0x40);
static const System::Byte SQL_CA_CONSTRAINT_NON_DEFERRABLE = System::Byte(0x80);
static const System::Int8 SQL_CCS_CREATE_CHARACTER_SET = System::Int8(0x1);
static const System::Int8 SQL_CCS_COLLATE_CLAUSE = System::Int8(0x2);
static const System::Int8 SQL_CCS_LIMITED_COLLATION = System::Int8(0x4);
static const System::Int8 SQL_CCOL_CREATE_COLLATION = System::Int8(0x1);
static const System::Int8 SQL_CDO_CREATE_DOMAIN = System::Int8(0x1);
static const System::Int8 SQL_CDO_DEFAULT = System::Int8(0x2);
static const System::Int8 SQL_CDO_CONSTRAINT = System::Int8(0x4);
static const System::Int8 SQL_CDO_COLLATION = System::Int8(0x8);
static const System::Int8 SQL_CDO_CONSTRAINT_NAME_DEFINITION = System::Int8(0x10);
static const System::Int8 SQL_CDO_CONSTRAINT_INITIALLY_DEFERRED = System::Int8(0x20);
static const System::Int8 SQL_CDO_CONSTRAINT_INITIALLY_IMMEDIATE = System::Int8(0x40);
static const System::Byte SQL_CDO_CONSTRAINT_DEFERRABLE = System::Byte(0x80);
static const System::Word SQL_CDO_CONSTRAINT_NON_DEFERRABLE = System::Word(0x100);
static const System::Int8 SQL_CT_CREATE_TABLE = System::Int8(0x1);
static const System::Int8 SQL_CT_COMMIT_PRESERVE = System::Int8(0x2);
static const System::Int8 SQL_CT_COMMIT_DELETE = System::Int8(0x4);
static const System::Int8 SQL_CT_GLOBAL_TEMPORARY = System::Int8(0x8);
static const System::Int8 SQL_CT_LOCAL_TEMPORARY = System::Int8(0x10);
static const System::Int8 SQL_CT_CONSTRAINT_INITIALLY_DEFERRED = System::Int8(0x20);
static const System::Int8 SQL_CT_CONSTRAINT_INITIALLY_IMMEDIATE = System::Int8(0x40);
static const System::Byte SQL_CT_CONSTRAINT_DEFERRABLE = System::Byte(0x80);
static const System::Word SQL_CT_CONSTRAINT_NON_DEFERRABLE = System::Word(0x100);
static const System::Word SQL_CT_COLUMN_CONSTRAINT = System::Word(0x200);
static const System::Word SQL_CT_COLUMN_DEFAULT = System::Word(0x400);
static const System::Word SQL_CT_COLUMN_COLLATION = System::Word(0x800);
static const System::Word SQL_CT_TABLE_CONSTRAINT = System::Word(0x1000);
static const System::Word SQL_CT_CONSTRAINT_NAME_DEFINITION = System::Word(0x2000);
static const System::Int8 SQL_DI_CREATE_INDEX = System::Int8(0x1);
static const System::Int8 SQL_DI_DROP_INDEX = System::Int8(0x2);
static const System::Int8 SQL_DC_DROP_COLLATION = System::Int8(0x1);
static const System::Int8 SQL_DD_DROP_DOMAIN = System::Int8(0x1);
static const System::Int8 SQL_DD_RESTRICT = System::Int8(0x2);
static const System::Int8 SQL_DD_CASCADE = System::Int8(0x4);
static const System::Int8 SQL_DS_DROP_SCHEMA = System::Int8(0x1);
static const System::Int8 SQL_DS_RESTRICT = System::Int8(0x2);
static const System::Int8 SQL_DS_CASCADE = System::Int8(0x4);
static const System::Int8 SQL_DCS_DROP_CHARACTER_SET = System::Int8(0x1);
static const System::Int8 SQL_DA_DROP_ASSERTION = System::Int8(0x1);
static const System::Int8 SQL_DT_DROP_TABLE = System::Int8(0x1);
static const System::Int8 SQL_DT_RESTRICT = System::Int8(0x2);
static const System::Int8 SQL_DT_CASCADE = System::Int8(0x4);
static const System::Int8 SQL_DTR_DROP_TRANSLATION = System::Int8(0x1);
static const System::Int8 SQL_DV_DROP_VIEW = System::Int8(0x1);
static const System::Int8 SQL_DV_RESTRICT = System::Int8(0x2);
static const System::Int8 SQL_DV_CASCADE = System::Int8(0x4);
static const System::Int8 SQL_IS_INSERT_LITERALS = System::Int8(0x1);
static const System::Int8 SQL_IS_INSERT_SEARCHED = System::Int8(0x2);
static const System::Int8 SQL_IS_SELECT_INTO = System::Int8(0x4);
static const int SQL_OIC_CORE = int(1);
static const int SQL_OIC_LEVEL1 = int(2);
static const int SQL_OIC_LEVEL2 = int(3);
static const System::Int8 SQL_SFKD_CASCADE = System::Int8(0x1);
static const System::Int8 SQL_SFKD_NO_ACTION = System::Int8(0x2);
static const System::Int8 SQL_SFKD_SET_DEFAULT = System::Int8(0x4);
static const System::Int8 SQL_SFKD_SET_NULL = System::Int8(0x8);
static const System::Int8 SQL_SFKU_CASCADE = System::Int8(0x1);
static const System::Int8 SQL_SFKU_NO_ACTION = System::Int8(0x2);
static const System::Int8 SQL_SFKU_SET_DEFAULT = System::Int8(0x4);
static const System::Int8 SQL_SFKU_SET_NULL = System::Int8(0x8);
static const System::Int8 SQL_SG_USAGE_ON_DOMAIN = System::Int8(0x1);
static const System::Int8 SQL_SG_USAGE_ON_CHARACTER_SET = System::Int8(0x2);
static const System::Int8 SQL_SG_USAGE_ON_COLLATION = System::Int8(0x4);
static const System::Int8 SQL_SG_USAGE_ON_TRANSLATION = System::Int8(0x8);
static const System::Int8 SQL_SG_WITH_GRANT_OPTION = System::Int8(0x10);
static const System::Int8 SQL_SG_DELETE_TABLE = System::Int8(0x20);
static const System::Int8 SQL_SG_INSERT_TABLE = System::Int8(0x40);
static const System::Byte SQL_SG_INSERT_COLUMN = System::Byte(0x80);
static const System::Word SQL_SG_REFERENCES_TABLE = System::Word(0x100);
static const System::Word SQL_SG_REFERENCES_COLUMN = System::Word(0x200);
static const System::Word SQL_SG_SELECT_TABLE = System::Word(0x400);
static const System::Word SQL_SG_UPDATE_TABLE = System::Word(0x800);
static const System::Word SQL_SG_UPDATE_COLUMN = System::Word(0x1000);
static const System::Int8 SQL_SP_EXISTS = System::Int8(0x1);
static const System::Int8 SQL_SP_ISNOTNULL = System::Int8(0x2);
static const System::Int8 SQL_SP_ISNULL = System::Int8(0x4);
static const System::Int8 SQL_SP_MATCH_FULL = System::Int8(0x8);
static const System::Int8 SQL_SP_MATCH_PARTIAL = System::Int8(0x10);
static const System::Int8 SQL_SP_MATCH_UNIQUE_FULL = System::Int8(0x20);
static const System::Int8 SQL_SP_MATCH_UNIQUE_PARTIAL = System::Int8(0x40);
static const System::Byte SQL_SP_OVERLAPS = System::Byte(0x80);
static const System::Word SQL_SP_UNIQUE = System::Word(0x100);
static const System::Word SQL_SP_LIKE = System::Word(0x200);
static const System::Word SQL_SP_IN = System::Word(0x400);
static const System::Word SQL_SP_BETWEEN = System::Word(0x800);
static const System::Word SQL_SP_COMPARISON = System::Word(0x1000);
static const System::Word SQL_SP_QUANTIFIED_COMPARISON = System::Word(0x2000);
static const System::Int8 SQL_SRJO_CORRESPONDING_CLAUSE = System::Int8(0x1);
static const System::Int8 SQL_SRJO_CROSS_JOIN = System::Int8(0x2);
static const System::Int8 SQL_SRJO_EXCEPT_JOIN = System::Int8(0x4);
static const System::Int8 SQL_SRJO_FULL_OUTER_JOIN = System::Int8(0x8);
static const System::Int8 SQL_SRJO_INNER_JOIN = System::Int8(0x10);
static const System::Int8 SQL_SRJO_INTERSECT_JOIN = System::Int8(0x20);
static const System::Int8 SQL_SRJO_LEFT_OUTER_JOIN = System::Int8(0x40);
static const System::Byte SQL_SRJO_NATURAL_JOIN = System::Byte(0x80);
static const System::Word SQL_SRJO_RIGHT_OUTER_JOIN = System::Word(0x100);
static const System::Word SQL_SRJO_UNION_JOIN = System::Word(0x200);
static const System::Int8 SQL_SR_USAGE_ON_DOMAIN = System::Int8(0x1);
static const System::Int8 SQL_SR_USAGE_ON_CHARACTER_SET = System::Int8(0x2);
static const System::Int8 SQL_SR_USAGE_ON_COLLATION = System::Int8(0x4);
static const System::Int8 SQL_SR_USAGE_ON_TRANSLATION = System::Int8(0x8);
static const System::Int8 SQL_SR_GRANT_OPTION_FOR = System::Int8(0x10);
static const System::Int8 SQL_SR_CASCADE = System::Int8(0x20);
static const System::Int8 SQL_SR_RESTRICT = System::Int8(0x40);
static const System::Byte SQL_SR_DELETE_TABLE = System::Byte(0x80);
static const System::Word SQL_SR_INSERT_TABLE = System::Word(0x100);
static const System::Word SQL_SR_INSERT_COLUMN = System::Word(0x200);
static const System::Word SQL_SR_REFERENCES_TABLE = System::Word(0x400);
static const System::Word SQL_SR_REFERENCES_COLUMN = System::Word(0x800);
static const System::Word SQL_SR_SELECT_TABLE = System::Word(0x1000);
static const System::Word SQL_SR_UPDATE_TABLE = System::Word(0x2000);
static const System::Word SQL_SR_UPDATE_COLUMN = System::Word(0x4000);
static const System::Int8 SQL_SRVC_VALUE_EXPRESSION = System::Int8(0x1);
static const System::Int8 SQL_SRVC_NULL = System::Int8(0x2);
static const System::Int8 SQL_SRVC_DEFAULT = System::Int8(0x4);
static const System::Int8 SQL_SRVC_ROW_SUBQUERY = System::Int8(0x8);
static const System::Int8 SQL_SVE_CASE = System::Int8(0x1);
static const System::Int8 SQL_SVE_CAST = System::Int8(0x2);
static const System::Int8 SQL_SVE_COALESCE = System::Int8(0x4);
static const System::Int8 SQL_SVE_NULLIF = System::Int8(0x8);
static const System::Int8 SQL_SCC_XOPEN_CLI_VERSION1 = System::Int8(0x1);
static const System::Int8 SQL_SCC_ISO92_CLI = System::Int8(0x2);
static const System::Int8 SQL_US_UNION = System::Int8(0x1);
static const System::Int8 SQL_US_UNION_ALL = System::Int8(0x2);
static const System::Int8 SQL_DTC_ENLIST_EXPENSIVE = System::Int8(0x1);
static const System::Int8 SQL_DTC_UNENLIST_EXPENSIVE = System::Int8(0x2);
static const System::Int8 SQL_FETCH_FIRST_USER = System::Int8(0x1f);
static const System::Int8 SQL_FETCH_FIRST_SYSTEM = System::Int8(0x20);
static const System::Int8 SQL_ENTIRE_ROWSET = System::Int8(0x0);
static const System::Int8 SQL_POSITION = System::Int8(0x0);
static const System::Int8 SQL_REFRESH = System::Int8(0x1);
static const System::Int8 SQL_UPDATE = System::Int8(0x2);
static const System::Int8 SQL_DELETE = System::Int8(0x3);
static const System::Int8 SQL_ADD = System::Int8(0x4);
static const System::Int8 SQL_SETPOS_MAX_OPTION_VALUE = System::Int8(0x4);
static const System::Int8 SQL_UPDATE_BY_BOOKMARK = System::Int8(0x5);
static const System::Int8 SQL_DELETE_BY_BOOKMARK = System::Int8(0x6);
static const System::Int8 SQL_FETCH_BY_BOOKMARK = System::Int8(0x7);
static const System::Int8 SQL_LOCK_NO_CHANGE = System::Int8(0x0);
static const System::Int8 SQL_LOCK_EXCLUSIVE = System::Int8(0x1);
static const System::Int8 SQL_LOCK_UNLOCK = System::Int8(0x2);
static const System::Int8 SQL_SETPOS_MAX_LOCK_VALUE = System::Int8(0x2);
static const System::Int8 SQL_BEST_ROWID = System::Int8(0x1);
static const System::Int8 SQL_ROWVER = System::Int8(0x2);
static const System::Int8 SQL_PC_NOT_PSEUDO = System::Int8(0x1);
static const System::Int8 SQL_QUICK = System::Int8(0x0);
static const System::Int8 SQL_ENSURE = System::Int8(0x1);
static const System::Int8 SQL_TABLE_STAT = System::Int8(0x0);
static const System::WideChar SQL_ALL_CATALOGS = (System::WideChar)(0x25);
static const System::WideChar SQL_ALL_SCHEMAS = (System::WideChar)(0x25);
static const System::WideChar SQL_ALL_TABLE_TYPES = (System::WideChar)(0x25);
static const System::Int8 SQL_DRIVER_NOPROMPT = System::Int8(0x0);
static const System::Int8 SQL_DRIVER_COMPLETE = System::Int8(0x1);
static const System::Int8 SQL_DRIVER_PROMPT = System::Int8(0x2);
static const System::Int8 SQL_DRIVER_COMPLETE_REQUIRED = System::Int8(0x3);
static const System::Int8 SQL_FETCH_BOOKMARK = System::Int8(0x8);
static const System::Int8 SQL_ROW_SUCCESS = System::Int8(0x0);
static const System::Int8 SQL_ROW_DELETED = System::Int8(0x1);
static const System::Int8 SQL_ROW_UPDATED = System::Int8(0x2);
static const System::Int8 SQL_ROW_NOROW = System::Int8(0x3);
static const System::Int8 SQL_ROW_ADDED = System::Int8(0x4);
static const System::Int8 SQL_ROW_ERROR = System::Int8(0x5);
static const System::Int8 SQL_ROW_SUCCESS_WITH_INFO = System::Int8(0x6);
static const System::Int8 SQL_ROW_PROCEED = System::Int8(0x0);
static const System::Int8 SQL_ROW_IGNORE = System::Int8(0x1);
static const System::Int8 SQL_PARAM_SUCCESS = System::Int8(0x0);
static const System::Int8 SQL_PARAM_SUCCESS_WITH_INFO = System::Int8(0x6);
static const System::Int8 SQL_PARAM_ERROR = System::Int8(0x5);
static const System::Int8 SQL_PARAM_UNUSED = System::Int8(0x7);
static const System::Int8 SQL_PARAM_DIAG_UNAVAILABLE = System::Int8(0x1);
static const System::Int8 SQL_PARAM_PROCEED = System::Int8(0x0);
static const System::Int8 SQL_PARAM_IGNORE = System::Int8(0x1);
static const System::Int8 SQL_CASCADE = System::Int8(0x0);
static const System::Int8 SQL_RESTRICT = System::Int8(0x1);
static const System::Int8 SQL_SET_NULL = System::Int8(0x2);
static const System::Int8 SQL_NO_ACTION = System::Int8(0x3);
static const System::Int8 SQL_SET_DEFAULT = System::Int8(0x4);
static const System::Int8 SQL_INITIALLY_DEFERRED = System::Int8(0x5);
static const System::Int8 SQL_INITIALLY_IMMEDIATE = System::Int8(0x6);
static const System::Int8 SQL_NOT_DEFERRABLE = System::Int8(0x7);
static const System::Int8 SQL_PT_UNKNOWN = System::Int8(0x0);
static const System::Int8 SQL_PT_PROCEDURE = System::Int8(0x1);
static const System::Int8 SQL_PT_FUNCTION = System::Int8(0x2);
#define SQL_ODBC_KEYWORDS L"ABSOLUTE,ACTION,ADA,ADD,ALL,ALLOCATE,ALTER,AND,ANY,ARE,AS,"\
	L"ASC,ASSERTION,AT,AUTHORIZATION,AVG,BEGIN,BETWEEN,BIT,BIT_L"\
	L"ENGTH,BOTH,BY,CASCADE,CASCADED,CASE,CAST,CATALOG,CHAR,CHAR"\
	L"_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE,CO"\
	L"LLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAIN"\
	L"T,CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,"\
	L"CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,"\
	L"CURRENT_USER,CURSOR,DATE,DAY,DEALLOCATE,DEC,DECIMAL,DECLAR"\
	L"E,DEFAULT,DEFERRABLE,DEFERRED,DELETE,DESC,DESCRIBE,DESCRIP"\
	L"TOR,DIAGNOSTICS,DISCONNECT,DISTINCT,DOMAIN,DOUBLE,DROP,ELS"\
	L"E,END,END-EXEC,ESCAPE,EXCEPT,EXCEPTION,EXEC,EXECUTE,EXISTS"\
	L",EXTERNAL,EXTRACT,FALSE,FETCH,FIRST,FLOAT,FOR,FOREIGN,FORT"\
	L"RAN,FOUND,FROM,FULL,GET,GLOBAL,GO,GOTO,GRANT,GROUP,HAVING,"\
	L"HOUR,IDENTITY,IMMEDIATE,IN,INCLUDE,INDEX,INDICATOR,INITIAL"\
	L"LY,INNER,INPUT,INSENSITIVE,INSERT,INT,INTEGER,INTERSECT,IN"\
	L"TERVAL,INTO,IS,ISOLATION,JOIN,KEY,LANGUAGE,LAST,LEADING,LE"\
	L"FT,LEVEL,LIKE,LOCAL,LOWER,MATCH,MAX,MIN,MINUTE,MODULE,MONT"\
	L"H,NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,NOT,NULL,NULLI"\
	L"F,NUMERIC,OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,ORDER,OUT"\
	L"ER,OUTPUT,OVERLAPS,PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISI"\
	L"ON,PREPARE,PRESERVE,PRIMARY,PRIOR,PRIVILEGES,PROCEDURE,PUB"\
	L"LIC,READ,REAL,REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,RO"\
	L"LLBACK,ROWSSCHEMA,SCROLL,SECOND,SECTION,SELECT,SESSION,SES"\
	L"SION_USER,SET,SIZE,SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,S"\
	L"QLERROR,SQLSTATE,SQLWARNING,SUBSTRING,SUM,SYSTEM_USER,TABL"\
	L"E,TEMPORARY,THEN,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MIN"\
	L"UTE,TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRU"\
	L"E,UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING,VALUE"\
	L",VALUES,VARCHAR,VARYING,VIEW,WHEN,WHENEVER,WHERE,WITH,WORK"\
	L",WRITE,YEAR,ZONE"
static const System::Int8 SQL_YEAR = System::Int8(0x1);
static const System::Int8 SQL_MONTH = System::Int8(0x2);
static const System::Int8 SQL_DAY = System::Int8(0x3);
static const System::Int8 SQL_HOUR = System::Int8(0x4);
static const System::Int8 SQL_MINUTE = System::Int8(0x5);
static const System::Int8 SQL_SECOND = System::Int8(0x6);
static const System::Int8 SQL_YEAR_TO_MONTH = System::Int8(0x7);
static const System::Int8 SQL_DAY_TO_HOUR = System::Int8(0x8);
static const System::Int8 SQL_DAY_TO_MINUTE = System::Int8(0x9);
static const System::Int8 SQL_DAY_TO_SECOND = System::Int8(0xa);
static const System::Int8 SQL_HOUR_TO_MINUTE = System::Int8(0xb);
static const System::Int8 SQL_HOUR_TO_SECOND = System::Int8(0xc);
static const System::Int8 SQL_MINUTE_TO_SECOND = System::Int8(0xd);
static const System::Int8 SQL_DATABASE_NAME = System::Int8(0x10);
static const System::Int8 SQL_FD_FETCH_PREV = System::Int8(0x8);
static const System::Int8 SQL_FETCH_PREV = System::Int8(0x4);
static const System::Int8 SQL_CONCUR_TIMESTAMP = System::Int8(0x3);
static const System::Int8 SQL_SCCO_OPT_TIMESTAMP = System::Int8(0x4);
static const System::Int8 SQL_CC_DELETE = System::Int8(0x0);
static const System::Int8 SQL_CR_DELETE = System::Int8(0x0);
static const System::Int8 SQL_CC_CLOSE = System::Int8(0x1);
static const System::Int8 SQL_CR_CLOSE = System::Int8(0x1);
static const System::Int8 SQL_CC_PRESERVE = System::Int8(0x2);
static const System::Int8 SQL_CR_PRESERVE = System::Int8(0x2);
static const System::Int8 SQL_FETCH_RESUME = System::Int8(0x7);
static const System::Int8 SQL_SCROLL_FORWARD_ONLY = System::Int8(0x0);
static const System::Int8 SQL_SCROLL_KEYSET_DRIVEN = System::Int8(-1);
static const System::Int8 SQL_SCROLL_DYNAMIC = System::Int8(-2);
static const System::Int8 SQL_SCROLL_STATIC = System::Int8(-3);
static const System::Word TRACE_VERSION = System::Word(0x3e8);
static const System::Int8 TRACE_ON = System::Int8(0x1);
static const System::Int8 TRACE_VS_EVENT_ON = System::Int8(0x2);
static const System::Int8 ODBC_VS_FLAG_UNICODE_ARG = System::Int8(0x1);
static const System::Int8 ODBC_VS_FLAG_UNICODE_COR = System::Int8(0x2);
static const System::Int8 ODBC_VS_FLAG_RETCODE = System::Int8(0x4);
static const System::Int8 ODBC_VS_FLAG_STOP = System::Int8(0x8);
static const System::Int8 OdbcApi_NotImplemented_OdbcName = System::Int8(0x0);
static const System::Int8 OdbcApi_NotImplemented_OdbcTrac = System::Int8(0x1);
static const System::Int8 OdbcApi_NotImplemented_OdbcInst = System::Int8(0x2);
static const short SQL_MSSQL_VARIANT = short(-150);
static const short SQL_MSSQL_XML = short(-152);
static const System::Word SQL_IBMDB2_LONGDATA_COMPAT = System::Word(0x4e5);
static const System::Int8 SQL_IBMDB2_LD_COMPAT_NO = System::Int8(0x0);
static const System::Int8 SQL_IBMDB2_LD_COMPAT_YES = System::Int8(0x1);
static const short SQL_ORA_CURSOR_REF = short(-403);
static const short SQL_ORA_CURSOR = short(-404);
static const System::Int8 SQL_INFX_ADIAG_ISAM_ERROR = System::Int8(0xd);
static const System::Int8 SQL_INFX_ADIAG_XA_ERROR = System::Int8(0xe);
static const System::Word SQL_INFX_STMTOPT_START = System::Word(0x410);
static const System::Word SQL_INFX_GET_ROWID = System::Word(0x418);
static const System::Word SQL_INFX_GET_SERIAL_VALUE = System::Word(0x419);
static const System::Int8 INFX_FDNULLABLE = System::Int8(0x1);
static const System::Int8 INFX_FDDISTINCT = System::Int8(0x2);
static const System::Int8 INFX_FDDISTLVARCHAR = System::Int8(0x4);
static const System::Int8 INFX_FDDISTBOOLEAN = System::Int8(0x8);
static const System::Int8 INFX_FDDISTSIMP = System::Int8(0x10);
static const System::Int8 INFX_FDCSTTYPE = System::Int8(0x20);
static const System::Int8 INFX_FDNAMED = System::Int8(0x40);
static const System::Int8 SQL_INFX_UDT_FIXED = System::Int8(-100);
static const System::Int8 SQL_INFX_UDT_VARYING = System::Int8(-101);
static const System::Int8 SQL_INFX_UDT_BLOB = System::Int8(-102);
static const System::Int8 SQL_INFX_UDT_CLOB = System::Int8(-103);
static const System::Int8 SQL_INFX_UDT_LVARCHAR = System::Int8(-104);
static const System::Int8 SQL_INFX_RC_ROW = System::Int8(-105);
static const System::Int8 SQL_INFX_RC_COLLECTION = System::Int8(-106);
static const System::Int8 SQL_INFX_RC_LIST = System::Int8(-107);
static const System::Int8 SQL_INFX_RC_SET = System::Int8(-108);
static const System::Int8 SQL_INFX_RC_MULTISET = System::Int8(-109);
static const System::Int8 SQL_INFX_UNSUPPORTED = System::Int8(-110);
static const System::Word SQL_INFX_OPT_LONGID = System::Word(0x8cb);
static const System::Word SQL_INFX_ATTR_LONGID = System::Word(0x8cb);
static const System::Word SQL_INFX_ATTR_LEAVE_TRAILING_SPACES = System::Word(0x8cc);
static const System::Word SQL_INFX_ATTR_DEFAULT_UDT_FETCH_TYPE = System::Word(0x8cd);
static const System::Word SQL_INFX_ATTR_ENABLE_SCROLL_CURSORS = System::Word(0x8ce);
static const System::Word SQL_INFX_ATTR_ENABLE_INSERT_CURSORS = System::Word(0x8cf);
static const System::Word SQL_INFX_ATTR_OPTIMIZE_AUTOCOMMIT = System::Word(0x8d0);
static const System::Word SQL_INFX_ATTR_ODBC_TYPES_ONLY = System::Word(0x8d1);
static const System::Word SQL_INFX_ATTR_FETCH_BUFFER_SIZE = System::Word(0x8d2);
static const System::Word SQL_INFX_ATTR_OPTOFC = System::Word(0x8d3);
static const System::Word SQL_INFX_ATTR_OPTMSG = System::Word(0x8d4);
static const System::Word SQL_INFX_ATTR_REPORT_KEYSET_CURSORS = System::Word(0x8d5);
static const System::Word SQL_INFX_ATTR_LO_AUTOMATIC = System::Word(0x8d6);
static const System::Word SQL_INFX_ATTR_AUTO_FREE = System::Word(0x8d7);
static const System::Word SQL_INFX_ATTR_DEFERRED_PREPARE = System::Word(0x8d9);
static const System::Word SQL_INFX_ATTR_FLAGS = System::Word(0x76c);
static const System::Word SQL_INFX_ATTR_EXTENDED_TYPE_CODE = System::Word(0x76d);
static const System::Word SQL_INFX_ATTR_EXTENDED_TYPE_NAME = System::Word(0x76e);
static const System::Word SQL_INFX_ATTR_EXTENDED_TYPE_OWNER = System::Word(0x76f);
static const System::Word SQL_INFX_ATTR_EXTENDED_TYPE_ALIGNMENT = System::Word(0x770);
static const System::Word SQL_INFX_ATTR_SOURCE_TYPE_CODE = System::Word(0x771);
static const System::Word SQL_INFX_VMB_CHAR_LEN = System::Word(0x915);
static const System::Word SQL_INFX_ATTR_VMB_CHAR_LEN = System::Word(0x915);
static const System::Word SQL_INFX_ATTR_MAX_FET_ARR_SIZE = System::Word(0x916);
static const System::Int8 SQL_INFX_VMB_CHAR_EXACT = System::Int8(0x0);
static const System::Int8 SQL_INFX_VMB_CHAR_ESTIMATE = System::Int8(0x1);
static const System::Int8 SQL_INFX_RC_NEXT = System::Int8(0x1);
static const System::Int8 SQL_INFX_RC_PRIOR = System::Int8(0x2);
static const System::Int8 SQL_INFX_RC_FIRST = System::Int8(0x3);
static const System::Int8 SQL_INFX_RC_LAST = System::Int8(0x4);
static const System::Int8 SQL_INFX_RC_ABSOLUTE = System::Int8(0x5);
static const System::Int8 SQL_INFX_RC_RELATIVE = System::Int8(0x6);
static const System::Int8 SQL_INFX_RC_CURRENT = System::Int8(0x7);
static const System::Word SQL_INFX_LO_SPEC_LENGTH = System::Word(0x8ca);
static const System::Word SQL_INFX_LO_PTR_LENGTH = System::Word(0x8cb);
static const System::Word SQL_INFX_LO_STAT_LENGTH = System::Word(0x8cc);
static const System::Int8 INFX_LO_APPEND = System::Int8(0x1);
static const System::Int8 INFX_LO_WRONLY = System::Int8(0x2);
static const System::Int8 INFX_LO_RDONLY = System::Int8(0x4);
static const System::Int8 INFX_LO_RDWR = System::Int8(0x8);
static const System::Int8 INFX_LO_RANDOM = System::Int8(0x20);
static const System::Int8 INFX_LO_SEQUENTIAL = System::Int8(0x40);
static const System::Byte INFX_LO_FORWARD = System::Byte(0x80);
static const System::Word INFX_LO_REVERSE = System::Word(0x100);
static const System::Word INFX_LO_BUFFER = System::Word(0x200);
static const System::Word INFX_LO_NOBUFFER = System::Word(0x400);
static const System::Int8 INFX_LO_DIRTY_READ = System::Int8(0x10);
static const System::Word INFX_LO_NODIRTY_READ = System::Word(0x800);
static const System::Int8 INFX_LO_ATTR_LOG = System::Int8(0x1);
static const System::Int8 INFX_LO_ATTR_NOLOG = System::Int8(0x2);
static const System::Int8 INFX_LO_ATTR_DELAY_LOG = System::Int8(0x4);
static const System::Int8 INFX_LO_ATTR_KEEP_LASTACCESS_TIME = System::Int8(0x8);
static const System::Int8 INFX_LO_ATTR_NOKEEP_LASTACCESS_TIME = System::Int8(0x10);
static const System::Int8 INFX_LO_ATTR_HIGH_INTEG = System::Int8(0x20);
static const System::Int8 INFX_LO_ATTR_MODERATE_INTEG = System::Int8(0x40);
static const System::Int8 INFX_LO_SEEK_SET = System::Int8(0x0);
static const System::Int8 INFX_LO_SEEK_CUR = System::Int8(0x1);
static const System::Int8 INFX_LO_SEEK_END = System::Int8(0x2);
static const System::Word SQL_INFX_RESERVED_WORDS = System::Word(0x3f3);
static const System::Word SQL_INFX_PSEUDO_COLUMNS = System::Word(0x2b04);
static const System::Word SQL_INFX_FROM_RESERVED_WORDS = System::Word(0x2b05);
static const System::Word SQL_INFX_WHERE_CLAUSE_TERMINATORS = System::Word(0x2b06);
static const System::Word SQL_INFX_COLUMN_FIRST_CHARS = System::Word(0x2b07);
static const System::Word SQL_INFX_COLUMN_MIDDLE_CHARS = System::Word(0x2b08);
static const System::Word SQL_INFX_TABLE_FIRST_CHARS = System::Word(0x2b0a);
static const System::Word SQL_INFX_TABLE_MIDDLE_CHARS = System::Word(0x2b0b);
static const System::Word SQL_INFX_FAST_SPECIAL_COLUMNS = System::Word(0x2b0d);
static const System::Word SQL_INFX_ACCESS_CONFLICTS = System::Word(0x2b0e);
static const System::Word SQL_INFX_LOCKING_SYNTAX = System::Word(0x2b0f);
static const System::Word SQL_INFX_LOCKING_DURATION = System::Word(0x2b10);
static const System::Word SQL_INFX_RECORD_OPERATIONS = System::Word(0x2b11);
static const System::Word SQL_INFX_QUALIFIER_SYNTAX = System::Word(0x2b12);
extern PACKAGE System::AnsiString sysodbclib;
extern PACKAGE bool __fastcall SQL_SUCCEEDED(const short rc);
extern PACKAGE TOdbcApiProxy* __fastcall LoadOdbcDriverManager(char * LibraryName, bool UnicodePriority = false);
extern PACKAGE void __fastcall UnLoadOdbcDriverManager(TOdbcApiProxy* OdbcApi);

}	/* namespace Odbcapi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ODBCAPI)
using namespace Odbcapi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OdbcapiHPP
