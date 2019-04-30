// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OdbcApi.pas' rev: 6.00

#ifndef OdbcApiHPP
#define OdbcApiHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DbxOpenOdbcFuncs.hpp>	// Pascal unit
#include <SyncObjs.hpp>	// Pascal unit
#include <SysConst.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <DbxOpenOdbcTypes.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Odbcapi
{
//-- type declarations -------------------------------------------------------
typedef char TSqlState[6];

typedef char *PSqlState;

typedef Byte *PSqlChar;

typedef int *PSqlInteger;

typedef void * *PSqlPointer;

typedef short *PSqlSmallint;

typedef Word *PSqlUSmallint;

typedef void * *PSqlHandle;

typedef void * *PSqlHEnv;

typedef void * *PSqlHDbc;

typedef void * *PSqlHStmt;

typedef void * *PSqlHDesc;

typedef Word *PUWord;

typedef int *PSqlUInteger;

typedef tagDATE_STRUCT *PSqlDateStruct;

typedef tagDATE_STRUCT  TSqlDateStruct;

typedef tagTIME_STRUCT *PSqlTimeStruct;

typedef tagTIME_STRUCT  TSqlTimeStruct;

typedef tagTIMESTAMP_STRUCT *POdbcTimestamp;

typedef tagTIMESTAMP_STRUCT  TOdbcTimestamp;

typedef SqlInterval ESqlInterval;

typedef tagSQL_YEAR_MONTH  TSqlYearMonth;

typedef tagSQL_DAY_SECOND  TSqlDaySecond;

typedef tagSQL_INTERVAL_STRUCT  TSqlInterval;

typedef wchar_t *PSqlWChar;

typedef short __stdcall (*TSQLAllocConnect)(void * EnvironmentHandle, void * &ConnectionHandle);

typedef short __stdcall (*TSQLAllocEnv)(void * &EnvironmentHandle);

typedef short __stdcall (*TSQLAllocHandle)(short HandleType, void * InputHandle, void * &OutputHandle);

typedef short __stdcall (*TSQLAllocStmt)(void * ConnectionHandle, void * &StatementHandle);

typedef short __stdcall (*TSQLBindCol)(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);

typedef short __stdcall (*TSQLBindParam)(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);

typedef short __stdcall (*TSQLCancel)(void * StatementHandle);

typedef short __stdcall (*TSQLCloseCursor)(void * StatementHandle);

typedef short __stdcall (*TSQLColAttribute)(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);

typedef short __stdcall (*TSQLColAttributeString)(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);

typedef short __stdcall (*TSQLColAttributeInt)(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);

typedef short __stdcall (*TSQLColumns)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);

typedef short __stdcall (*TSQLConnect)(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);

typedef short __stdcall (*TSQLCopyDesc)(void * SourceDescHandle, void * TargetDescHandle);

typedef short __stdcall (*TSQLDataSources)(void * EnvironmentHandle, Word Direction, Byte &ServerName, short BufferLength1, short &NameLength1, Byte &Description, short BufferLength2, short &NameLength2);

typedef short __stdcall (*TSQLDescribeCol)(void * StatementHandle, Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);

typedef short __stdcall (*TSQLDisconnect)(void * ConnectionHandle);

typedef short __stdcall (*TSQLEndTran)(short HandleType, void * Handle, short CompletionType);

typedef short __stdcall (*TSQLError)(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, Byte &Sqlstate, int &NativeError, Byte &MessageText, short BufferLength, short &TextLength);

typedef short __stdcall (*TSQLExecDirect)(void * StatementHandle, char * StatementText, int TextLength);

typedef short __stdcall (*TSQLExecute)(void * StatementHandle);

typedef short __stdcall (*TSQLFetch)(void * StatementHandle);

typedef short __stdcall (*TSQLFetchScroll)(void * StatementHandle, short FetchOrientation, int FetchOffset);

typedef short __stdcall (*TSQLFreeConnect)(void * ConnectionHandle);

typedef short __stdcall (*TSQLFreeEnv)(void * EnvironmentHandle);

typedef short __stdcall (*TSQLFreeHandle)(short HandleType, void * Handle);

typedef short __stdcall (*TSQLFreeStmt)(void * StatementHandle, Word Option);

typedef short __stdcall (*TSQLGetConnectAttr)(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);

typedef short __stdcall (*TSQLGetConnectOption)(void * ConnectionHandle, Word Option, void * Value);

typedef short __stdcall (*TSQLGetCursorName)(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);

typedef short __stdcall (*TSQLGetData)(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);

typedef short __stdcall (*TSQLGetDescField)(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);

typedef short __stdcall (*TSQLGetDescRec)(void * DescriptorHandle, short RecNumber, Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);

typedef short __stdcall (*TSQLGetDiagField)(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);

typedef short __stdcall (*TSQLGetDiagRec)(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);

typedef short __stdcall (*TSQLGetEnvAttr)(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);

typedef short __stdcall (*TSQLGetFunctions)(void * ConnectionHandle, Word FunctionId, Word &Supported);

typedef short __stdcall (*TSQLGetInfo)(void * ConnectionHandle, Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);

typedef short __stdcall (*TSQLGetInfoString)(void * ConnectionHandle, Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);

typedef short __stdcall (*TSQLGetInfoSmallint)(void * ConnectionHandle, Word InfoType, Word &InfoValue, short Ignored1, void * Ignored2);

typedef short __stdcall (*TSQLGetInfoInt)(void * ConnectionHandle, Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);

typedef short __stdcall (*TSQLGetStmtAttr)(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);

typedef short __stdcall (*TSQLGetStmtOption)(void * StatementHandle, Word Option, void * Value);

typedef short __stdcall (*TSQLGetTypeInfo)(void * StatementHandle, short DataType);

typedef short __stdcall (*TSQLNumResultCols)(void * StatementHandle, short &ColumnCount);

typedef short __stdcall (*TSQLParamData)(void * StatementHandle, void * &Value);

typedef short __stdcall (*TSQLPrepare)(void * StatementHandle, char * StatementText, int TextLength);

typedef short __stdcall (*TSQLPutData)(void * StatementHandle, void * Data, int StrLen_or_Ind);

typedef short __stdcall (*TSQLRowCount)(void * StatementHandle, int &RowCount);

typedef short __stdcall (*TSQLSetConnectAttr)(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);

typedef short __stdcall (*TSQLSetConnectOption)(void * ConnectionHandle, Word Option, int Value);

typedef short __stdcall (*TSQLSetCursorName)(void * StatementHandle, char * CursorName, short NameLength);

typedef short __stdcall (*TSQLSetDescField)(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);

typedef short __stdcall (*TSQLSetDescRec)(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);

typedef short __stdcall (*TSQLSetEnvAttr)(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);

typedef short __stdcall (*TSQLSetParam)(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);

typedef short __stdcall (*TSQLSetStmtAttr)(void * StatementHandle, int Attribute, void * Value, int StringLength);

typedef short __stdcall (*TSQLSetStmtOption)(void * StatementHandle, Word Option, int Value);

typedef short __stdcall (*TSQLSpecialColumns)(void * StatementHandle, Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Scope, Word Nullable);

typedef short __stdcall (*TSQLStatistics)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Unique, Word Reserved);

typedef short __stdcall (*TSQLTables)(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);

typedef short __stdcall (*TSQLTransact)(void * EnvironmentHandle, void * ConnectionHandle, Word CompletionType);

typedef short __stdcall (*TSQLDriverConnect)(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, Word fDriverCompletion);

typedef short __stdcall (*TSQLBrowseConnect)(void * HDbc, Byte &szConnStrIn, short cbConnStrIn, Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);

typedef short __stdcall (*TSQLBulkOperations)(void * StatementHandle, short Operation);

typedef short __stdcall (*TSQLColAttributes)(void * HStmt, Word icol, Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);

typedef short __stdcall (*TSQLColumnPrivileges)(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName, Byte &szColumnName, short cbColumnName);

typedef short __stdcall (*TSQLDescribeParam)(void * HStmt, Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);

typedef short __stdcall (*TSQLExtendedFetch)(void * HStmt, Word fFetchType, int irow, int &pcrow, Word &rgfRowStatus);

typedef short __stdcall (*TSQLForeignKeys)(void * HStmt, Byte &szPkCatalogName, short cbPkCatalogName, Byte &szPkSchemaName, short cbPkSchemaName, Byte &szPkTableName, short cbPkTableName, Byte &szFkCatalogName, short cbFkCatalogName, Byte &szFkSchemaName, short cbFkSchemaName, Byte &szFkTableName, short cbFkTableName);

typedef short __stdcall (*TSQLMoreResults)(void * HStmt);

typedef short __stdcall (*TSQLNativeSql)(void * HDbc, Byte &szSqlStrIn, int cbSqlStrIn, Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);

typedef short __stdcall (*TSQLNumParams)(void * HStmt, short &pcpar);

typedef short __stdcall (*TSQLParamOptions)(void * HStmt, int crow, int &pirow);

typedef short __stdcall (*TSQLPrimaryKeys)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);

typedef short __stdcall (*TSQLProcedureColumns)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);

typedef short __stdcall (*TSQLProcedures)(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);

typedef short __stdcall (*TSQLSetPos)(void * HStmt, Word irow, Word fOption, Word fLock);

typedef short __stdcall (*TSQLTablePrivileges)(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName);

typedef short __stdcall (*TSQLDrivers)(void * HEnv, Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);

typedef short __stdcall (*TSQLBindParameter)(void * HStmt, Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);

typedef short __stdcall (*TSQLAllocHandleStd)(short fHandleType, void * hInput, void * &phOutput);

typedef short __stdcall (*TSQLSetScrollOptions)(void * HStmt, Word fConcurrency, int crowKeyset, Word crowRowset);

typedef short __stdcall (*TTraceOpenLogFile)(wchar_t &_1, wchar_t &_2, int _3);

typedef short __stdcall (*TTraceCloseLogFile)(void);

typedef void __stdcall (*TTraceReturn)(short _1, short _2);

typedef int __stdcall (*TTraceVersion)(void);

typedef short __stdcall (*TTraceVSControl)(int _1);

typedef BOOL __stdcall (*TODBCSetTryWaitValue)(unsigned dwValue);

typedef int __stdcall (*TODBCGetTryWaitValue)(void);

#pragma pack(push, 1)
struct tagODBC_VS_ARGS
{
	GUID *PGuidEvent;
	unsigned dwFlags;
	union
	{
		struct 
		{
			wchar_t *wszCorrelation;
			char *szCorrelation;
			short RetCode2;
			
		};
		struct 
		{
			wchar_t *wszArg;
			char *szArg;
			short Retcode;
			
		};
		
	};
} ;
#pragma pack(pop)

typedef tagODBC_VS_ARGS  ODBC_VS_ARGS;

typedef tagODBC_VS_ARGS *PODBC_VS_ARGS;

typedef void __stdcall (*TFireVSDebugEvent)(tagODBC_VS_ARGS &Args);

class DELPHICLASS EOdbcApi;
class PASCALIMPLEMENTATION EOdbcApi : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EOdbcApi(const AnsiString Msg) : Sysutils::Exception(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EOdbcApi(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EOdbcApi(int Ident)/* overload */ : Sysutils::Exception(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EOdbcApi(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EOdbcApi(const AnsiString Msg, int AHelpContext) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EOdbcApi(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EOdbcApi(int Ident, int AHelpContext)/* overload */ : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EOdbcApi(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EOdbcApi(void) { }
	#pragma option pop
	
};


class DELPHICLASS EOdbcApiNotImplemented;
class PASCALIMPLEMENTATION EOdbcApiNotImplemented : public EOdbcApi 
{
	typedef EOdbcApi inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EOdbcApiNotImplemented(const AnsiString Msg) : EOdbcApi(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EOdbcApiNotImplemented(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EOdbcApi(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EOdbcApiNotImplemented(int Ident)/* overload */ : EOdbcApi(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EOdbcApiNotImplemented(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EOdbcApi(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EOdbcApiNotImplemented(const AnsiString Msg, int AHelpContext) : EOdbcApi(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EOdbcApiNotImplemented(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EOdbcApi(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EOdbcApiNotImplemented(int Ident, int AHelpContext)/* overload */ : EOdbcApi(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EOdbcApiNotImplemented(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EOdbcApi(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EOdbcApiNotImplemented(void) { }
	#pragma option pop
	
};


class DELPHICLASS TOdbcApiProxy;
class DELPHICLASS TOdbcApiIntfImpl;
class PASCALIMPLEMENTATION TOdbcApiIntfImpl : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
private:
	TOdbcApiProxy* fOdbcApiProxy;
	void __fastcall CheckAvailableProxy(void);
	
protected:
	int __fastcall SQL_LEN_DATA_AT_EXEC(int length);
	int __fastcall SQL_LEN_BINARY_ATTR(int length);
	int __fastcall SQL_FUNC_EXISTS(PUWord pfExists, Word uwAPI);
	short __fastcall SQL_POSITION_TO(void * HStmt, Word irow);
	short __fastcall SQL_LOCK_RECORD(void * HStmt, Word irow, Word fLock);
	short __fastcall SQL_REFRESH_RECORD(void * HStmt, Word irow, Word fLock);
	short __fastcall SQL_UPDATE_RECORD(void * HStmt, Word irow);
	short __fastcall SQL_DELETE_RECORD(void * HStmt, Word irow);
	short __fastcall SQL_ADD_RECORD(void * HStmt, Word irow);
	bool __fastcall SQLFunctionSupported(void * ConnectionHandle, Word FunctionId);
	short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle);
	short __fastcall SQLAllocEnv(void * &EnvironmentHandle);
	short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle);
	short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle);
	short __fastcall SQLBindCol(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLBindParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLCancel(void * StatementHandle);
	short __fastcall SQLCloseCursor(void * StatementHandle);
	short __fastcall SQLColAttribute(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);
	short __fastcall SQLColAttributeString(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);
	short __fastcall SQLColAttributeInt(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);
	short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);
	short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);
	short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle);
	short __fastcall SQLDataSources(void * EnvironmentHandle, Word Direction, Byte &ServerName, short BufferLength1, short &NameLength1, Byte &Description, short BufferLength2, short &NameLength2);
	short __fastcall SQLDescribeCol(void * StatementHandle, Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);
	short __fastcall SQLDisconnect(void * ConnectionHandle);
	short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType);
	short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, Byte &Sqlstate, int &NativeError, Byte &MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLExecute(void * StatementHandle);
	short __fastcall SQLFetch(void * StatementHandle);
	short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset);
	short __fastcall SQLFreeConnect(void * ConnectionHandle);
	short __fastcall SQLFreeEnv(void * EnvironmentHandle);
	short __fastcall SQLFreeHandle(short HandleType, void * Handle);
	short __fastcall SQLFreeStmt(void * StatementHandle, Word Option);
	short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);
	short __fastcall SQLGetConnectOption(void * ConnectionHandle, Word Option, void * Value);
	short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);
	short __fastcall SQLGetData(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);
	short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);
	short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetFunctions(void * ConnectionHandle, Word FunctionId, Word &Supported);
	short __fastcall SQLGetInfo(void * ConnectionHandle, Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);
	short __fastcall SQLGetInfoString(void * ConnectionHandle, Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);
	short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, Word InfoType, Word &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetInfoInt(void * ConnectionHandle, Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);
	short __fastcall SQLGetStmtOption(void * StatementHandle, Word Option, void * Value);
	short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType);
	short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount);
	short __fastcall SQLParamData(void * StatementHandle, void * &Value);
	short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind);
	short __fastcall SQLRowCount(void * StatementHandle, int &RowCount);
	short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetConnectOption(void * ConnectionHandle, Word Option, int Value);
	short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength);
	short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);
	short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);
	short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength);
	short __fastcall SQLSetStmtOption(void * StatementHandle, Word Option, int Value);
	short __fastcall SQLSpecialColumns(void * StatementHandle, Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Scope, Word Nullable);
	short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Unique, Word Reserved);
	short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);
	short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, Word CompletionType);
	short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, Word fDriverCompletion);
	short __fastcall SQLBrowseConnect(void * HDbc, Byte &szConnStrIn, short cbConnStrIn, Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);
	short __fastcall SQLBulkOperations(void * StatementHandle, short Operation);
	short __fastcall SQLColAttributes(void * HStmt, Word icol, Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);
	short __fastcall SQLColumnPrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName, Byte &szColumnName, short cbColumnName);
	short __fastcall SQLDescribeParam(void * HStmt, Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);
	short __fastcall SQLExtendedFetch(void * HStmt, Word fFetchType, int irow, int &pcrow, Word &rgfRowStatus);
	short __fastcall SQLForeignKeys(void * HStmt, Byte &szPkCatalogName, short cbPkCatalogName, Byte &szPkSchemaName, short cbPkSchemaName, Byte &szPkTableName, short cbPkTableName, Byte &szFkCatalogName, short cbFkCatalogName, Byte &szFkSchemaName, short cbFkSchemaName, Byte &szFkTableName, short cbFkTableName);
	short __fastcall SQLMoreResults(void * HStmt);
	short __fastcall SQLNativeSql(void * HDbc, Byte &szSqlStrIn, int cbSqlStrIn, Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);
	short __fastcall SQLNumParams(void * HStmt, short &pcpar);
	short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow);
	short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);
	short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);
	short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);
	short __fastcall SQLSetPos(void * HStmt, Word irow, Word fOption, Word fLock);
	short __fastcall SQLTablePrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName);
	short __fastcall SQLDrivers(void * HEnv, Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);
	short __fastcall SQLBindParameter(void * HStmt, Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);
	short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput);
	short __fastcall SQLSetScrollOptions(void * HStmt, Word fConcurrency, int crowKeyset, Word crowRowset);
	short __fastcall TraceOpenLogFile(wchar_t &_1, wchar_t &_2, int _3);
	short __fastcall TraceCloseLogFile(void);
	void __fastcall TraceReturn(short _1, short _2);
	int __fastcall TraceVersion(void);
	short __fastcall TraceVSControl(int _1);
	void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args);
	bool __fastcall ODBCSetTryWaitValue(unsigned dwValue);
	int __fastcall ODBCGetTryWaitValue(void);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TOdbcApiIntfImpl(void) : System::TInterfacedObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TOdbcApiIntfImpl(void) { }
	#pragma option pop
	
private:
	void *__IOdbcApi;	/* Odbcapi::IOdbcApi */
	
public:
	operator IOdbcApi*(void) { return (IOdbcApi*)&__IOdbcApi; }
	
};


__interface IOdbcApi;
typedef System::DelphiInterface<IOdbcApi> _di_IOdbcApi;
__interface INTERFACE_UUID("{6DA86068-0BC3-4BFC-B9FC-FF8FEC5CD106}") IOdbcApi  : public IInterface 
{
	
public:
	virtual int __fastcall SQL_LEN_DATA_AT_EXEC(int length) = 0 ;
	virtual int __fastcall SQL_LEN_BINARY_ATTR(int length) = 0 ;
	virtual int __fastcall SQL_FUNC_EXISTS(PUWord pfExists, Word uwAPI) = 0 ;
	virtual short __fastcall SQL_POSITION_TO(void * HStmt, Word irow) = 0 ;
	virtual short __fastcall SQL_LOCK_RECORD(void * HStmt, Word irow, Word fLock) = 0 ;
	virtual short __fastcall SQL_REFRESH_RECORD(void * HStmt, Word irow, Word fLock) = 0 ;
	virtual short __fastcall SQL_UPDATE_RECORD(void * HStmt, Word irow) = 0 ;
	virtual short __fastcall SQL_DELETE_RECORD(void * HStmt, Word irow) = 0 ;
	virtual short __fastcall SQL_ADD_RECORD(void * HStmt, Word irow) = 0 ;
	virtual bool __fastcall SQLFunctionSupported(void * ConnectionHandle, Word FunctionId) = 0 ;
	virtual short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle) = 0 ;
	virtual short __fastcall SQLAllocEnv(void * &EnvironmentHandle) = 0 ;
	virtual short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle) = 0 ;
	virtual short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle) = 0 ;
	virtual short __fastcall SQLBindCol(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLBindParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLCancel(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLCloseCursor(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLColAttribute(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr) = 0 ;
	virtual short __fastcall SQLColAttributeString(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute) = 0 ;
	virtual short __fastcall SQLColAttributeInt(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute) = 0 ;
	virtual short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4) = 0 ;
	virtual short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3) = 0 ;
	virtual short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle) = 0 ;
	virtual short __fastcall SQLDataSources(void * EnvironmentHandle, Word Direction, Byte &ServerName, short BufferLength1, short &NameLength1, Byte &Description, short BufferLength2, short &NameLength2) = 0 ;
	virtual short __fastcall SQLDescribeCol(void * StatementHandle, Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable) = 0 ;
	virtual short __fastcall SQLDisconnect(void * ConnectionHandle) = 0 ;
	virtual short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType) = 0 ;
	virtual short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, Byte &Sqlstate, int &NativeError, Byte &MessageText, short BufferLength, short &TextLength) = 0 ;
	virtual short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength) = 0 ;
	virtual short __fastcall SQLExecute(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLFetch(void * StatementHandle) = 0 ;
	virtual short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset) = 0 ;
	virtual short __fastcall SQLFreeConnect(void * ConnectionHandle) = 0 ;
	virtual short __fastcall SQLFreeEnv(void * EnvironmentHandle) = 0 ;
	virtual short __fastcall SQLFreeHandle(short HandleType, void * Handle) = 0 ;
	virtual short __fastcall SQLFreeStmt(void * StatementHandle, Word Option) = 0 ;
	virtual short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength) = 0 ;
	virtual short __fastcall SQLGetConnectOption(void * ConnectionHandle, Word Option, void * Value) = 0 ;
	virtual short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength) = 0 ;
	virtual short __fastcall SQLGetData(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength) = 0 ;
	virtual short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable) = 0 ;
	virtual short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength) = 0 ;
	virtual short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength) = 0 ;
	virtual short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength) = 0 ;
	virtual short __fastcall SQLGetFunctions(void * ConnectionHandle, Word FunctionId, Word &Supported) = 0 ;
	virtual short __fastcall SQLGetInfo(void * ConnectionHandle, Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr) = 0 ;
	virtual short __fastcall SQLGetInfoString(void * ConnectionHandle, Word InfoType, char * InfoValueString, short BufferLength, short &StringLength) = 0 ;
	virtual short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, Word InfoType, Word &InfoValue, short Ignored1, void * Ignored2) = 0 ;
	virtual short __fastcall SQLGetInfoInt(void * ConnectionHandle, Word InfoType, int &InfoValue, short Ignored1, void * Ignored2) = 0 ;
	virtual short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength) = 0 ;
	virtual short __fastcall SQLGetStmtOption(void * StatementHandle, Word Option, void * Value) = 0 ;
	virtual short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType) = 0 ;
	virtual short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount) = 0 ;
	virtual short __fastcall SQLParamData(void * StatementHandle, void * &Value) = 0 ;
	virtual short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength) = 0 ;
	virtual short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLRowCount(void * StatementHandle, int &RowCount) = 0 ;
	virtual short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength) = 0 ;
	virtual short __fastcall SQLSetConnectOption(void * ConnectionHandle, Word Option, int Value) = 0 ;
	virtual short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength) = 0 ;
	virtual short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength) = 0 ;
	virtual short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator) = 0 ;
	virtual short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength) = 0 ;
	virtual short __fastcall SQLSetParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind) = 0 ;
	virtual short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength) = 0 ;
	virtual short __fastcall SQLSetStmtOption(void * StatementHandle, Word Option, int Value) = 0 ;
	virtual short __fastcall SQLSpecialColumns(void * StatementHandle, Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Scope, Word Nullable) = 0 ;
	virtual short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Unique, Word Reserved) = 0 ;
	virtual short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4) = 0 ;
	virtual short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, Word CompletionType) = 0 ;
	virtual short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, Word fDriverCompletion) = 0 ;
	virtual short __fastcall SQLBrowseConnect(void * HDbc, Byte &szConnStrIn, short cbConnStrIn, Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut) = 0 ;
	virtual short __fastcall SQLBulkOperations(void * StatementHandle, short Operation) = 0 ;
	virtual short __fastcall SQLColAttributes(void * HStmt, Word icol, Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc) = 0 ;
	virtual short __fastcall SQLColumnPrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName, Byte &szColumnName, short cbColumnName) = 0 ;
	virtual short __fastcall SQLDescribeParam(void * HStmt, Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable) = 0 ;
	virtual short __fastcall SQLExtendedFetch(void * HStmt, Word fFetchType, int irow, int &pcrow, Word &rgfRowStatus) = 0 ;
	virtual short __fastcall SQLForeignKeys(void * HStmt, Byte &szPkCatalogName, short cbPkCatalogName, Byte &szPkSchemaName, short cbPkSchemaName, Byte &szPkTableName, short cbPkTableName, Byte &szFkCatalogName, short cbFkCatalogName, Byte &szFkSchemaName, short cbFkSchemaName, Byte &szFkTableName, short cbFkTableName) = 0 ;
	virtual short __fastcall SQLMoreResults(void * HStmt) = 0 ;
	virtual short __fastcall SQLNativeSql(void * HDbc, Byte &szSqlStrIn, int cbSqlStrIn, Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr) = 0 ;
	virtual short __fastcall SQLNumParams(void * HStmt, short &pcpar) = 0 ;
	virtual short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow) = 0 ;
	virtual short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName) = 0 ;
	virtual short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName) = 0 ;
	virtual short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName) = 0 ;
	virtual short __fastcall SQLSetPos(void * HStmt, Word irow, Word fOption, Word fLock) = 0 ;
	virtual short __fastcall SQLTablePrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName) = 0 ;
	virtual short __fastcall SQLDrivers(void * HEnv, Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr) = 0 ;
	virtual short __fastcall SQLBindParameter(void * HStmt, Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue) = 0 ;
	virtual short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput) = 0 ;
	virtual short __fastcall SQLSetScrollOptions(void * HStmt, Word fConcurrency, int crowKeyset, Word crowRowset) = 0 ;
	virtual short __fastcall TraceOpenLogFile(wchar_t &_1, wchar_t &_2, int _3) = 0 ;
	virtual short __fastcall TraceCloseLogFile(void) = 0 ;
	virtual void __fastcall TraceReturn(short _1, short _2) = 0 ;
	virtual int __fastcall TraceVersion(void) = 0 ;
	virtual short __fastcall TraceVSControl(int _1) = 0 ;
	virtual void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args) = 0 ;
	virtual bool __fastcall ODBCSetTryWaitValue(unsigned dwValue) = 0 ;
	virtual int __fastcall ODBCGetTryWaitValue(void) = 0 ;
};

class PASCALIMPLEMENTATION TOdbcApiProxy : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString fVendorLib;
	AnsiString fModuleName;
	int fApiRefCount;
	bool fLockLib;
	bool fSystemODBCManager;
	unsigned hModuleApi;
	AnsiString fModuleNameTrac;
	unsigned hModuleApiTrac;
	AnsiString fModuleNameInst;
	unsigned hModuleApiInst;
	int fOdbcDriverLevel;
	TOdbcApiIntfImpl* fOdbcApiImpl;
	_di_IOdbcApi fOdbcApiIntf;
	void __fastcall NotImplemented(const AnsiString sFuncName, int iLevel = 0x0);
	void __fastcall SetOdbcDriverLevel(int aOdbcDriverLevel);
	void __fastcall BeginLock(void);
	void __fastcall EndLock(void);
	
public:
	__fastcall virtual ~TOdbcApiProxy(void);
	System::_di_IInterface __fastcall GetOdbcApiIntf();
	__property bool SystemODBCManager = {read=fSystemODBCManager, default=0};
	__property int OdbcDriverLevel = {read=fOdbcDriverLevel, write=SetOdbcDriverLevel, nodefault};
	__property AnsiString VendorLib = {read=fVendorLib};
	__property AnsiString ModuleName = {read=fModuleName};
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
	/*         class method */ static int __fastcall SQL_LEN_DATA_AT_EXEC(TMetaClass* vmt, int length);
	/*         class method */ static int __fastcall SQL_LEN_BINARY_ATTR(TMetaClass* vmt, int length);
	/*         class method */ static int __fastcall SQL_FUNC_EXISTS(TMetaClass* vmt, PUWord pfExists, Word uwAPI);
	short __fastcall SQL_POSITION_TO(void * HStmt, Word irow);
	short __fastcall SQL_LOCK_RECORD(void * HStmt, Word irow, Word fLock);
	short __fastcall SQL_REFRESH_RECORD(void * HStmt, Word irow, Word fLock);
	short __fastcall SQL_UPDATE_RECORD(void * HStmt, Word irow);
	short __fastcall SQL_DELETE_RECORD(void * HStmt, Word irow);
	short __fastcall SQL_ADD_RECORD(void * HStmt, Word irow);
	bool __fastcall SQLFunctionSupported(void * ConnectionHandle, Word FunctionId);
	short __fastcall SQLAllocConnect(void * EnvironmentHandle, void * &ConnectionHandle);
	short __fastcall SQLAllocEnv(void * &EnvironmentHandle);
	short __fastcall SQLAllocHandle(short HandleType, void * InputHandle, void * &OutputHandle);
	short __fastcall SQLAllocStmt(void * ConnectionHandle, void * &StatementHandle);
	short __fastcall SQLBindCol(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLBindParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLCancel(void * StatementHandle);
	short __fastcall SQLCloseCursor(void * StatementHandle);
	short __fastcall SQLColAttribute(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, void * NumericAttributePtr);
	short __fastcall SQLColAttributeString(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, short &StringLength, void * NumericAttribute);
	short __fastcall SQLColAttributeInt(void * StatementHandle, Word ColumnNumber, Word FieldIdentifier, void * CharacterAttribute, short BufferLength, PSqlSmallint StringLength, int &NumericAttribute);
	short __fastcall SQLColumns(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * ColumnName, short NameLength4);
	short __fastcall SQLConnect(void * ConnectionHandle, char * ServerName, short NameLength1, char * UserName, short NameLength2, char * Authentication, short NameLength3);
	short __fastcall SQLCopyDesc(void * SourceDescHandle, void * TargetDescHandle);
	short __fastcall SQLDataSources(void * EnvironmentHandle, Word Direction, Byte &ServerName, short BufferLength1, short &NameLength1, Byte &Description, short BufferLength2, short &NameLength2);
	short __fastcall SQLDescribeCol(void * StatementHandle, Word ColumnNumber, char * ColumnName, short BufferLength, short &NameLength, short &DataType, int &ColumnSize, short &DecimalDigits, short &Nullable);
	short __fastcall SQLDisconnect(void * ConnectionHandle);
	short __fastcall SQLEndTran(short HandleType, void * Handle, short CompletionType);
	short __fastcall SQLError(void * EnvironmentHandle, void * ConnectionHandle, void * StatementHandle, Byte &Sqlstate, int &NativeError, Byte &MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLExecDirect(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLExecute(void * StatementHandle);
	short __fastcall SQLFetch(void * StatementHandle);
	short __fastcall SQLFetchScroll(void * StatementHandle, short FetchOrientation, int FetchOffset);
	short __fastcall SQLFreeConnect(void * ConnectionHandle);
	short __fastcall SQLFreeEnv(void * EnvironmentHandle);
	short __fastcall SQLFreeHandle(short HandleType, void * Handle);
	short __fastcall SQLFreeStmt(void * StatementHandle, Word Option);
	short __fastcall SQLGetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int BufferLength, PSqlInteger pStringLength);
	short __fastcall SQLGetConnectOption(void * ConnectionHandle, Word Option, void * Value);
	short __fastcall SQLGetCursorName(void * StatementHandle, char * CursorName, short BufferLength, short &NameLength);
	short __fastcall SQLGetData(void * StatementHandle, Word ColumnNumber, short TargetType, void * TargetValue, int BufferLength, PSqlInteger StrLen_or_Ind);
	short __fastcall SQLGetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetDescRec(void * DescriptorHandle, short RecNumber, Byte &Name, short BufferLength, short &StringLength, short &_Type, short &SubType, int &Length, short &Precision, short &Scale, short &Nullable);
	short __fastcall SQLGetDiagField(short HandleType, void * Handle, short RecNumber, short DiagIdentifier, void * DiagInfo, short BufferLength, short &StringLength);
	short __fastcall SQLGetDiagRec(short HandleType, void * Handle, short RecNumber, char * Sqlstate, int &NativeError, char * MessageText, short BufferLength, short &TextLength);
	short __fastcall SQLGetEnvAttr(void * EnvironmentHandle, int Attribute, void * Value, int BufferLength, int &StringLength);
	short __fastcall SQLGetFunctions(void * ConnectionHandle, Word FunctionId, Word &Supported);
	short __fastcall SQLGetInfo(void * ConnectionHandle, Word InfoType, void * InfoValuePtr, short BufferLength, void * StringLengthPtr);
	short __fastcall SQLGetInfoString(void * ConnectionHandle, Word InfoType, char * InfoValueString, short BufferLength, short &StringLength);
	short __fastcall SQLGetInfoSmallint(void * ConnectionHandle, Word InfoType, Word &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetInfoInt(void * ConnectionHandle, Word InfoType, int &InfoValue, short Ignored1, void * Ignored2);
	short __fastcall SQLGetStmtAttr(void * StatementHandle, int Attribute, void * Value, int BufferLength, PSqlInteger StringLength);
	short __fastcall SQLGetStmtOption(void * StatementHandle, Word Option, void * Value);
	short __fastcall SQLGetTypeInfo(void * StatementHandle, short DataType);
	short __fastcall SQLNumResultCols(void * StatementHandle, short &ColumnCount);
	short __fastcall SQLParamData(void * StatementHandle, void * &Value);
	short __fastcall SQLPrepare(void * StatementHandle, char * StatementText, int TextLength);
	short __fastcall SQLPutData(void * StatementHandle, void * Data, int StrLen_or_Ind);
	short __fastcall SQLRowCount(void * StatementHandle, int &RowCount);
	short __fastcall SQLSetConnectAttr(void * ConnectionHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetConnectOption(void * ConnectionHandle, Word Option, int Value);
	short __fastcall SQLSetCursorName(void * StatementHandle, char * CursorName, short NameLength);
	short __fastcall SQLSetDescField(void * DescriptorHandle, short RecNumber, short FieldIdentifier, void * Value, int BufferLength);
	short __fastcall SQLSetDescRec(void * DescriptorHandle, short RecNumber, short _Type, short SubType, int Length, short Precision, short Scale, void * Data, int &StringLength, int &Indicator);
	short __fastcall SQLSetEnvAttr(void * EnvironmentHandle, int Attribute, void * ValuePtr, int StringLength);
	short __fastcall SQLSetParam(void * StatementHandle, Word ParameterNumber, short ValueType, short ParameterType, int LengthPrecision, short ParameterScale, void * ParameterValue, int &StrLen_or_Ind);
	short __fastcall SQLSetStmtAttr(void * StatementHandle, int Attribute, void * Value, int StringLength);
	short __fastcall SQLSetStmtOption(void * StatementHandle, Word Option, int Value);
	short __fastcall SQLSpecialColumns(void * StatementHandle, Word IdentifierType, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Scope, Word Nullable);
	short __fastcall SQLStatistics(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, Word Unique, Word Reserved);
	short __fastcall SQLTables(void * StatementHandle, char * CatalogName, short NameLength1, char * SchemaName, short NameLength2, char * TableName, short NameLength3, char * TableType, short NameLength4);
	short __fastcall SQLTransact(void * EnvironmentHandle, void * ConnectionHandle, Word CompletionType);
	short __fastcall SQLDriverConnect(void * HDbc, HWND hwnd, char * szConnStrIn, short cbConnStrIn, char * szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut, Word fDriverCompletion);
	short __fastcall SQLBrowseConnect(void * HDbc, Byte &szConnStrIn, short cbConnStrIn, Byte &szConnStrOut, short cbConnStrOutMax, short &pcbConnStrOut);
	short __fastcall SQLBulkOperations(void * StatementHandle, short Operation);
	short __fastcall SQLColAttributes(void * HStmt, Word icol, Word fDescType, void * rgbDesc, short cbDescMax, short &pcbDesc, int &pfDesc);
	short __fastcall SQLColumnPrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName, Byte &szColumnName, short cbColumnName);
	short __fastcall SQLDescribeParam(void * HStmt, Word ipar, short &pfSqlType, int &pcbParamDef, short &pibScale, short &pfNullable);
	short __fastcall SQLExtendedFetch(void * HStmt, Word fFetchType, int irow, int &pcrow, Word &rgfRowStatus);
	short __fastcall SQLForeignKeys(void * HStmt, Byte &szPkCatalogName, short cbPkCatalogName, Byte &szPkSchemaName, short cbPkSchemaName, Byte &szPkTableName, short cbPkTableName, Byte &szFkCatalogName, short cbFkCatalogName, Byte &szFkSchemaName, short cbFkSchemaName, Byte &szFkTableName, short cbFkTableName);
	short __fastcall SQLMoreResults(void * HStmt);
	short __fastcall SQLNativeSql(void * HDbc, Byte &szSqlStrIn, int cbSqlStrIn, Byte &szSqlStr, int cbSqlStrMax, int &pcbSqlStr);
	short __fastcall SQLNumParams(void * HStmt, short &pcpar);
	short __fastcall SQLParamOptions(void * HStmt, int crow, int &pirow);
	short __fastcall SQLPrimaryKeys(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szTableName, short cbTableName);
	short __fastcall SQLProcedureColumns(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName, char * szColumnName, short cbColumnName);
	short __fastcall SQLProcedures(void * HStmt, char * szCatalogName, short cbCatalogName, char * szSchemaName, short cbSchemaName, char * szProcName, short cbProcName);
	short __fastcall SQLSetPos(void * HStmt, Word irow, Word fOption, Word fLock);
	short __fastcall SQLTablePrivileges(void * HStmt, Byte &szCatalogName, short cbCatalogName, Byte &szSchemaName, short cbSchemaName, Byte &szTableName, short cbTableName);
	short __fastcall SQLDrivers(void * HEnv, Word fDirection, char * szDriverDesc, short cbDriverDescMax, short &pcbDriverDesc, char * szDriverAttributes, short cbDrvrAttrMax, short &pcbDrvrAttr);
	short __fastcall SQLBindParameter(void * HStmt, Word ipar, short fParamType, short fCType, short fSqlType, int cbColDef, short ibScale, void * rgbValue, int cbValueMax, PSqlInteger pcbValue);
	short __fastcall SQLAllocHandleStd(short fHandleType, void * hInput, void * &phOutput);
	short __fastcall SQLSetScrollOptions(void * HStmt, Word fConcurrency, int crowKeyset, Word crowRowset);
	short __fastcall TraceOpenLogFile(wchar_t &_1, wchar_t &_2, int _3);
	short __fastcall TraceCloseLogFile(void);
	void __fastcall TraceReturn(short _1, short _2);
	int __fastcall TraceVersion(void);
	short __fastcall TraceVSControl(int _1);
	void __fastcall FireVSDebugEvent(tagODBC_VS_ARGS &Args);
	bool __fastcall ODBCSetTryWaitValue(unsigned dwValue);
	int __fastcall ODBCGetTryWaitValue(void);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TOdbcApiProxy(void) : System::TObject() { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
static const Shortint SQL_NULL_DATA = 0xffffffff;
static const Shortint SQL_DATA_AT_EXEC = 0xfffffffe;
static const Shortint SQL_SUCCESS = 0x0;
static const Shortint SQL_SUCCESS_WITH_INFO = 0x1;
static const Shortint SQL_NO_DATA = 0x64;
static const Shortint SQL_ERROR = 0xffffffff;
static const Shortint SQL_INVALID_HANDLE = 0xfffffffe;
static const Shortint SQL_STILL_EXECUTING = 0x2;
static const Shortint SQL_NEED_DATA = 0x63;
static const Shortint SQL_NTS = 0xfffffffd;
static const Shortint SQL_NTSL = 0xfffffffd;
static const Word SQL_MAX_MESSAGE_LENGTH = 0x200;
static const Shortint SQL_DATE_LEN = 0xa;
static const Shortint SQL_TIME_LEN = 0x8;
static const Shortint SQL_TIMESTAMP_LEN = 0x13;
static const Shortint SQL_HANDLE_ENV = 0x1;
static const Shortint SQL_HANDLE_DBC = 0x2;
static const Shortint SQL_HANDLE_STMT = 0x3;
static const Shortint SQL_HANDLE_DESC = 0x4;
static const Word SQL_ATTR_OUTPUT_NTS = 0x2711;
static const Word SQL_ATTR_AUTO_IPD = 0x2711;
static const Word SQL_ATTR_METADATA_ID = 0x271e;
static const Word SQL_ATTR_APP_ROW_DESC = 0x271a;
static const Word SQL_ATTR_APP_PARAM_DESC = 0x271b;
static const Word SQL_ATTR_IMP_ROW_DESC = 0x271c;
static const Word SQL_ATTR_IMP_PARAM_DESC = 0x271d;
static const Shortint SQL_ATTR_CURSOR_SCROLLABLE = 0xffffffff;
static const Shortint SQL_ATTR_CURSOR_SENSITIVITY = 0xfffffffe;
static const Shortint SQL_NONSCROLLABLE = 0x0;
static const Shortint SQL_SCROLLABLE = 0x1;
static const Word SQL_DESC_COUNT = 0x3e9;
static const Word SQL_DESC_TYPE = 0x3ea;
static const Word SQL_DESC_LENGTH = 0x3eb;
static const Word SQL_DESC_OCTET_LENGTH_PTR = 0x3ec;
static const Word SQL_DESC_PRECISION = 0x3ed;
static const Word SQL_DESC_SCALE = 0x3ee;
static const Word SQL_DESC_DATETIME_INTERVAL_CODE = 0x3ef;
static const Word SQL_DESC_NULLABLE = 0x3f0;
static const Word SQL_DESC_INDICATOR_PTR = 0x3f1;
static const Word SQL_DESC_DATA_PTR = 0x3f2;
static const Word SQL_DESC_NAME = 0x3f3;
static const Word SQL_DESC_UNNAMED = 0x3f4;
static const Word SQL_DESC_OCTET_LENGTH = 0x3f5;
static const Word SQL_DESC_ALLOC_TYPE = 0x44b;
static const Shortint SQL_DIAG_RETURNCODE = 0x1;
static const Shortint SQL_DIAG_NUMBER = 0x2;
static const Shortint SQL_DIAG_ROW_COUNT = 0x3;
static const Shortint SQL_DIAG_SQLSTATE = 0x4;
static const Shortint SQL_DIAG_NATIVE = 0x5;
static const Shortint SQL_DIAG_MESSAGE_TEXT = 0x6;
static const Shortint SQL_DIAG_DYNAMIC_FUNCTION = 0x7;
static const Shortint SQL_DIAG_CLASS_ORIGIN = 0x8;
static const Shortint SQL_DIAG_SUBCLASS_ORIGIN = 0x9;
static const Shortint SQL_DIAG_CONNECTION_NAME = 0xa;
static const Shortint SQL_DIAG_SERVER_NAME = 0xb;
static const Shortint SQL_DIAG_DYNAMIC_FUNCTION_CODE = 0xc;
static const Shortint SQL_DIAG_ALTER_DOMAIN = 0x3;
static const Shortint SQL_DIAG_ALTER_TABLE = 0x4;
static const Shortint SQL_DIAG_CALL = 0x7;
static const Shortint SQL_DIAG_CREATE_ASSERTION = 0x6;
static const Shortint SQL_DIAG_CREATE_CHARACTER_SET = 0x8;
static const Shortint SQL_DIAG_CREATE_COLLATION = 0xa;
static const Shortint SQL_DIAG_CREATE_DOMAIN = 0x17;
static const Shortint SQL_DIAG_CREATE_INDEX = 0xffffffff;
static const Shortint SQL_DIAG_CREATE_SCHEMA = 0x40;
static const Shortint SQL_DIAG_CREATE_TABLE = 0x4d;
static const Shortint SQL_DIAG_CREATE_TRANSLATION = 0x4f;
static const Shortint SQL_DIAG_CREATE_VIEW = 0x54;
static const Shortint SQL_DIAG_DELETE_WHERE = 0x13;
static const Shortint SQL_DIAG_DROP_ASSERTION = 0x18;
static const Shortint SQL_DIAG_DROP_CHARACTER_SET = 0x19;
static const Shortint SQL_DIAG_DROP_COLLATION = 0x1a;
static const Shortint SQL_DIAG_DROP_DOMAIN = 0x1b;
static const Shortint SQL_DIAG_DROP_INDEX = 0xfffffffe;
static const Shortint SQL_DIAG_DROP_SCHEMA = 0x1f;
static const Shortint SQL_DIAG_DROP_TABLE = 0x20;
static const Shortint SQL_DIAG_DROP_TRANSLATION = 0x21;
static const Shortint SQL_DIAG_DROP_VIEW = 0x24;
static const Shortint SQL_DIAG_DYNAMIC_DELETE_CURSOR = 0x26;
static const Shortint SQL_DIAG_DYNAMIC_UPDATE_CURSOR = 0x51;
static const Shortint SQL_DIAG_GRANT = 0x30;
static const Shortint SQL_DIAG_INSERT = 0x32;
static const Shortint SQL_DIAG_REVOKE = 0x3b;
static const Shortint SQL_DIAG_SELECT_CURSOR = 0x55;
static const Shortint SQL_DIAG_UNKNOWN_STATEMENT = 0x0;
static const Shortint SQL_DIAG_UPDATE_WHERE = 0x52;
static const Shortint SQL_UNKNOWN_TYPE = 0x0;
static const Shortint SQL_CHAR = 0x1;
static const Shortint SQL_NUMERIC = 0x2;
static const Shortint SQL_DECIMAL = 0x3;
static const Shortint SQL_INTEGER = 0x4;
static const Shortint SQL_SMALLINT = 0x5;
static const Shortint SQL_FLOAT = 0x6;
static const Shortint SQL_REAL = 0x7;
static const Shortint SQL_DOUBLE = 0x8;
static const Shortint SQL_DATETIME = 0x9;
static const Shortint SQL_VARCHAR = 0xc;
static const Shortint SQL_TYPE_DATE = 0x5b;
static const Shortint SQL_TYPE_TIME = 0x5c;
static const Shortint SQL_TYPE_TIMESTAMP = 0x5d;
static const Shortint SQL_UNSPECIFIED = 0x0;
static const Shortint SQL_INSENSITIVE = 0x1;
static const Shortint SQL_SENSITIVE = 0x2;
static const Shortint SQL_ALL_TYPES = 0x0;
static const Shortint SQL_DEFAULT = 0x63;
static const Shortint SQL_ARD_TYPE = 0xffffff9d;
static const Shortint SQL_CODE_DATE = 0x1;
static const Shortint SQL_CODE_TIME = 0x2;
static const Shortint SQL_CODE_TIMESTAMP = 0x3;
static const Shortint SQL_FALSE = 0x0;
static const Shortint SQL_TRUE = 0x1;
static const Shortint SQL_NO_NULLS = 0x0;
static const Shortint SQL_NULLABLE = 0x1;
static const Shortint SQL_NULLABLE_UNKNOWN = 0x2;
static const Shortint SQL_PRED_NONE = 0x0;
static const Shortint SQL_PRED_CHAR = 0x1;
static const Shortint SQL_PRED_BASIC = 0x2;
static const Shortint SQL_NAMED = 0x0;
static const Shortint SQL_UNNAMED = 0x1;
static const Shortint SQL_DESC_ALLOC_AUTO = 0x1;
static const Shortint SQL_DESC_ALLOC_USER = 0x2;
static const Shortint SQL_CLOSE = 0x0;
static const Shortint SQL_DROP = 0x1;
static const Shortint SQL_UNBIND = 0x2;
static const Shortint SQL_RESET_PARAMS = 0x3;
static const Shortint SQL_FETCH_NEXT = 0x1;
static const Shortint SQL_FETCH_FIRST = 0x2;
static const Shortint SQL_FETCH_LAST = 0x3;
static const Shortint SQL_FETCH_PRIOR = 0x4;
static const Shortint SQL_FETCH_ABSOLUTE = 0x5;
static const Shortint SQL_FETCH_RELATIVE = 0x6;
static const Shortint SQL_COMMIT = 0x0;
static const Shortint SQL_ROLLBACK = 0x1;
#define SQL_NULL_HENV (void *)(0x0)
#define SQL_NULL_HDBC (void *)(0x0)
#define SQL_NULL_HSTMT (void *)(0x0)
#define SQL_NULL_HDESC (void *)(0x0)
#define SQL_NULL_HANDLE (void *)(0x0)
static const Shortint SQL_SCOPE_CURROW = 0x0;
static const Shortint SQL_SCOPE_TRANSACTION = 0x1;
static const Shortint SQL_SCOPE_SESSION = 0x2;
static const Shortint SQL_PC_UNKNOWN = 0x0;
static const Shortint SQL_PC_NON_PSEUDO = 0x1;
static const Shortint SQL_PC_PSEUDO = 0x2;
static const Shortint SQL_ROW_IDENTIFIER = 0x1;
static const Shortint SQL_INDEX_UNIQUE = 0x0;
static const Shortint SQL_INDEX_ALL = 0x1;
static const Shortint SQL_INDEX_CLUSTERED = 0x1;
static const Shortint SQL_INDEX_HASHED = 0x2;
static const Shortint SQL_INDEX_OTHER = 0x3;
static const Shortint SQL_API_SQLALLOCCONNECT = 0x1;
static const Shortint SQL_API_SQLALLOCENV = 0x2;
static const Word SQL_API_SQLALLOCHANDLE = 0x3e9;
static const Shortint SQL_API_SQLALLOCSTMT = 0x3;
static const Shortint SQL_API_SQLBINDCOL = 0x4;
static const Word SQL_API_SQLBINDPARAM = 0x3ea;
static const Shortint SQL_API_SQLCANCEL = 0x5;
static const Word SQL_API_SQLCLOSECURSOR = 0x3eb;
static const Shortint SQL_API_SQLCOLATTRIBUTE = 0x6;
static const Shortint SQL_API_SQLCOLUMNS = 0x28;
static const Shortint SQL_API_SQLCONNECT = 0x7;
static const Word SQL_API_SQLCOPYDESC = 0x3ec;
static const Shortint SQL_API_SQLDATASOURCES = 0x39;
static const Shortint SQL_API_SQLDESCRIBECOL = 0x8;
static const Shortint SQL_API_SQLDISCONNECT = 0x9;
static const Word SQL_API_SQLENDTRAN = 0x3ed;
static const Shortint SQL_API_SQLERROR = 0xa;
static const Shortint SQL_API_SQLEXECDIRECT = 0xb;
static const Shortint SQL_API_SQLEXECUTE = 0xc;
static const Shortint SQL_API_SQLFETCH = 0xd;
static const Word SQL_API_SQLFETCHSCROLL = 0x3fd;
static const Shortint SQL_API_SQLFREECONNECT = 0xe;
static const Shortint SQL_API_SQLFREEENV = 0xf;
static const Word SQL_API_SQLFREEHANDLE = 0x3ee;
static const Shortint SQL_API_SQLFREESTMT = 0x10;
static const Word SQL_API_SQLGETCONNECTATTR = 0x3ef;
static const Shortint SQL_API_SQLGETCONNECTOPTION = 0x2a;
static const Shortint SQL_API_SQLGETCURSORNAME = 0x11;
static const Shortint SQL_API_SQLGETDATA = 0x2b;
static const Word SQL_API_SQLGETDESCFIELD = 0x3f0;
static const Word SQL_API_SQLGETDESCREC = 0x3f1;
static const Word SQL_API_SQLGETDIAGFIELD = 0x3f2;
static const Word SQL_API_SQLGETDIAGREC = 0x3f3;
static const Word SQL_API_SQLGETENVATTR = 0x3f4;
static const Shortint SQL_API_SQLGETFUNCTIONS = 0x2c;
static const Shortint SQL_API_SQLGETINFO = 0x2d;
static const Word SQL_API_SQLGETSTMTATTR = 0x3f6;
static const Shortint SQL_API_SQLGETSTMTOPTION = 0x2e;
static const Shortint SQL_API_SQLGETTYPEINFO = 0x2f;
static const Shortint SQL_API_SQLNUMRESULTCOLS = 0x12;
static const Shortint SQL_API_SQLPARAMDATA = 0x30;
static const Shortint SQL_API_SQLPREPARE = 0x13;
static const Shortint SQL_API_SQLPUTDATA = 0x31;
static const Shortint SQL_API_SQLROWCOUNT = 0x14;
static const Word SQL_API_SQLSETCONNECTATTR = 0x3f8;
static const Shortint SQL_API_SQLSETCONNECTOPTION = 0x32;
static const Shortint SQL_API_SQLSETCURSORNAME = 0x15;
static const Word SQL_API_SQLSETDESCFIELD = 0x3f9;
static const Word SQL_API_SQLSETDESCREC = 0x3fa;
static const Word SQL_API_SQLSETENVATTR = 0x3fb;
static const Shortint SQL_API_SQLSETPARAM = 0x16;
static const Word SQL_API_SQLSETSTMTATTR = 0x3fc;
static const Shortint SQL_API_SQLSETSTMTOPTION = 0x33;
static const Shortint SQL_API_SQLSPECIALCOLUMNS = 0x34;
static const Shortint SQL_API_SQLSTATISTICS = 0x35;
static const Shortint SQL_API_SQLTABLES = 0x36;
static const Shortint SQL_API_SQLTRANSACT = 0x17;
static const Shortint SQL_MAX_DRIVER_CONNECTIONS = 0x0;
static const Shortint SQL_MAXIMUM_DRIVER_CONNECTIONS = 0x0;
static const Shortint SQL_MAX_CONCURRENT_ACTIVITIES = 0x1;
static const Shortint SQL_MAXIMUM_CONCURRENT_ACTIVITIES = 0x1;
static const Shortint SQL_DATA_SOURCE_NAME = 0x2;
static const Shortint SQL_FETCH_DIRECTION = 0x8;
static const Shortint SQL_SERVER_NAME = 0xd;
static const Shortint SQL_SEARCH_PATTERN_ESCAPE = 0xe;
static const Shortint SQL_DBMS_NAME = 0x11;
static const Shortint SQL_DBMS_VER = 0x12;
static const Shortint SQL_ACCESSIBLE_TABLES = 0x13;
static const Shortint SQL_ACCESSIBLE_PROCEDURES = 0x14;
static const Shortint SQL_CURSOR_COMMIT_BEHAVIOR = 0x17;
static const Shortint SQL_DATA_SOURCE_READ_ONLY = 0x19;
static const Shortint SQL_DEFAULT_TXN_ISOLATION = 0x1a;
static const Shortint SQL_IDENTIFIER_CASE = 0x1c;
static const Shortint SQL_IDENTIFIER_QUOTE_CHAR = 0x1d;
static const Shortint SQL_MAX_COLUMN_NAME_LEN = 0x1e;
static const Shortint SQL_MAXIMUM_COLUMN_NAME_LENGTH = 0x1e;
static const Shortint SQL_MAX_CURSOR_NAME_LEN = 0x1f;
static const Shortint SQL_MAXIMUM_CURSOR_NAME_LENGTH = 0x1f;
static const Shortint SQL_MAX_SCHEMA_NAME_LEN = 0x20;
static const Shortint SQL_MAXIMUM_SCHEMA_NAME_LENGTH = 0x20;
static const Shortint SQL_MAX_CATALOG_NAME_LEN = 0x22;
static const Shortint SQL_MAXIMUM_CATALOG_NAME_LENGTH = 0x22;
static const Shortint SQL_MAX_TABLE_NAME_LEN = 0x23;
static const Shortint SQL_SCROLL_CONCURRENCY = 0x2b;
static const Shortint SQL_TXN_CAPABLE = 0x2e;
static const Shortint SQL_TRANSACTION_CAPABLE = 0x2e;
static const Shortint SQL_USER_NAME = 0x2f;
static const Shortint SQL_TXN_ISOLATION_OPTION = 0x48;
static const Shortint SQL_TRANSACTION_ISOLATION_OPTION = 0x48;
static const Shortint SQL_INTEGRITY = 0x49;
static const Shortint SQL_GETDATA_EXTENSIONS = 0x51;
static const Shortint SQL_NULL_COLLATION = 0x55;
static const Shortint SQL_ALTER_TABLE = 0x56;
static const Shortint SQL_ORDER_BY_COLUMNS_IN_SELECT = 0x5a;
static const Shortint SQL_SPECIAL_CHARACTERS = 0x5e;
static const Shortint SQL_MAX_COLUMNS_IN_GROUP_BY = 0x61;
static const Shortint SQL_MAXIMUM_COLUMNS_IN_GROUP_BY = 0x61;
static const Shortint SQL_MAX_COLUMNS_IN_INDEX = 0x62;
static const Shortint SQL_MAXIMUM_COLUMNS_IN_INDEX = 0x62;
static const Shortint SQL_MAX_COLUMNS_IN_ORDER_BY = 0x63;
static const Shortint SQL_MAXIMUM_COLUMNS_IN_ORDER_BY = 0x63;
static const Shortint SQL_MAX_COLUMNS_IN_SELECT = 0x64;
static const Shortint SQL_MAXIMUM_COLUMNS_IN_SELECT = 0x64;
static const Shortint SQL_MAX_COLUMNS_IN_TABLE = 0x65;
static const Shortint SQL_MAX_INDEX_SIZE = 0x66;
static const Shortint SQL_MAXIMUM_INDEX_SIZE = 0x66;
static const Shortint SQL_MAX_ROW_SIZE = 0x68;
static const Shortint SQL_MAXIMUM_ROW_SIZE = 0x68;
static const Shortint SQL_MAX_STATEMENT_LEN = 0x69;
static const Shortint SQL_MAXIMUM_STATEMENT_LENGTH = 0x69;
static const Shortint SQL_MAX_TABLES_IN_SELECT = 0x6a;
static const Shortint SQL_MAXIMUM_TABLES_IN_SELECT = 0x6a;
static const Shortint SQL_MAX_USER_NAME_LEN = 0x6b;
static const Shortint SQL_MAXIMUM_USER_NAME_LENGTH = 0x6b;
static const Shortint SQL_OJ_CAPABILITIES = 0x73;
static const Shortint SQL_OUTER_JOIN_CAPABILITIES = 0x73;
static const Word SQL_XOPEN_CLI_YEAR = 0x2710;
static const Word SQL_CURSOR_SENSITIVITY = 0x2711;
static const Word SQL_DESCRIBE_PARAMETER = 0x2712;
static const Word SQL_CATALOG_NAME = 0x2713;
static const Word SQL_COLLATION_SEQ = 0x2714;
static const Word SQL_MAX_IDENTIFIER_LEN = 0x2715;
static const Word SQL_MAXIMUM_IDENTIFIER_LENGTH = 0x2715;
static const Shortint SQL_AT_ADD_COLUMN = 0x1;
static const Shortint SQL_AT_DROP_COLUMN = 0x2;
static const Shortint SQL_AT_ADD_CONSTRAINT = 0x8;
static const Shortint SQL_AT_COLUMN_SINGLE = 0x20;
static const Shortint SQL_AT_ADD_COLUMN_DEFAULT = 0x40;
static const Byte SQL_AT_ADD_COLUMN_COLLATION = 0x80;
static const Word SQL_AT_SET_COLUMN_DEFAULT = 0x100;
static const Word SQL_AT_DROP_COLUMN_DEFAULT = 0x200;
static const Word SQL_AT_DROP_COLUMN_CASCADE = 0x400;
static const Word SQL_AT_DROP_COLUMN_RESTRICT = 0x800;
static const Word SQL_AT_ADD_TABLE_CONSTRAINT = 0x1000;
static const Word SQL_AT_DROP_TABLE_CONSTRAINT_CASCADE = 0x2000;
static const Word SQL_AT_DROP_TABLE_CONSTRAINT_RESTRICT = 0x4000;
static const Word SQL_AT_CONSTRAINT_NAME_DEFINITION = 0x8000;
static const int SQL_AT_CONSTRAINT_INITIALLY_DEFERRED = 0x10000;
static const int SQL_AT_CONSTRAINT_INITIALLY_IMMEDIATE = 0x20000;
static const int SQL_AT_CONSTRAINT_DEFERRABLE = 0x40000;
static const int SQL_AT_CONSTRAINT_NON_DEFERRABLE = 0x80000;
static const Shortint SQL_AM_NONE = 0x0;
static const Shortint SQL_AM_CONNECTION = 0x1;
static const Shortint SQL_AM_STATEMENT = 0x2;
static const Shortint SQL_CB_DELETE = 0x0;
static const Shortint SQL_CB_CLOSE = 0x1;
static const Shortint SQL_CB_PRESERVE = 0x2;
static const Shortint SQL_FD_FETCH_NEXT = 0x1;
static const Shortint SQL_FD_FETCH_FIRST = 0x2;
static const Shortint SQL_FD_FETCH_LAST = 0x4;
static const Shortint SQL_FD_FETCH_PRIOR = 0x8;
static const Shortint SQL_FD_FETCH_ABSOLUTE = 0x10;
static const Shortint SQL_FD_FETCH_RELATIVE = 0x20;
static const Shortint SQL_GD_ANY_COLUMN = 0x1;
static const Shortint SQL_GD_ANY_ORDER = 0x2;
static const Shortint SQL_IC_UPPER = 0x1;
static const Shortint SQL_IC_LOWER = 0x2;
static const Shortint SQL_IC_SENSITIVE = 0x3;
static const Shortint SQL_IC_MIXED = 0x4;
static const Shortint SQL_OJ_LEFT = 0x1;
static const Shortint SQL_OJ_RIGHT = 0x2;
static const Shortint SQL_OJ_FULL = 0x4;
static const Shortint SQL_OJ_NESTED = 0x8;
static const Shortint SQL_OJ_NOT_ORDERED = 0x10;
static const Shortint SQL_OJ_INNER = 0x20;
static const Shortint SQL_OJ_ALL_COMPARISON_OPS = 0x40;
static const Shortint SQL_SCCO_READ_ONLY = 0x1;
static const Shortint SQL_SCCO_LOCK = 0x2;
static const Shortint SQL_SCCO_OPT_ROWVER = 0x4;
static const Shortint SQL_SCCO_OPT_VALUES = 0x8;
static const Shortint SQL_TC_NONE = 0x0;
static const Shortint SQL_TC_DML = 0x1;
static const Shortint SQL_TC_ALL = 0x2;
static const Shortint SQL_TC_DDL_COMMIT = 0x3;
static const Shortint SQL_TC_DDL_IGNORE = 0x4;
static const Shortint SQL_TXN_READ_UNCOMMITTED = 0x1;
static const Shortint SQL_TRANSACTION_READ_UNCOMMITTED = 0x1;
static const Shortint SQL_TXN_READ_COMMITTED = 0x2;
static const Shortint SQL_TRANSACTION_READ_COMMITTED = 0x2;
static const Shortint SQL_TXN_REPEATABLE_READ = 0x4;
static const Shortint SQL_TRANSACTION_REPEATABLE_READ = 0x4;
static const Shortint SQL_TXN_SERIALIZABLE = 0x8;
static const Shortint SQL_TRANSACTION_SERIALIZABLE = 0x8;
static const Shortint SQL_NC_HIGH = 0x0;
static const Shortint SQL_NC_LOW = 0x1;
static const Shortint SQL_WCHAR = 0xfffffff8;
static const Shortint SQL_WVARCHAR = 0xfffffff7;
static const Shortint SQL_WLONGVARCHAR = 0xfffffff6;
static const Shortint SQL_C_WCHAR = 0xfffffff8;
static const Shortint SQL_SPEC_MAJOR = 0x3;
static const Shortint SQL_SPEC_MINOR = 0x33;
#define SQL_SPEC_STRING "03.51"
static const Shortint SQL_SQLSTATE_SIZE = 0x5;
static const Shortint SQL_MAX_DSN_LENGTH = 0x20;
static const Word SQL_MAX_OPTION_STRING_LENGTH = 0x100;
static const Shortint SQL_NO_DATA_FOUND = 0x64;
static const Shortint SQL_HANDLE_SENV = 0x5;
static const Byte SQL_ATTR_ODBC_VERSION = 0xc8;
static const Byte SQL_ATTR_CONNECTION_POOLING = 0xc9;
static const Byte SQL_ATTR_CP_MATCH = 0xca;
static const int SQL_CP_OFF = 0x0;
static const int SQL_CP_ONE_PER_DRIVER = 0x1;
static const int SQL_CP_ONE_PER_HENV = 0x2;
static const int SQL_CP_DEFAULT = 0x0;
static const int SQL_CP_STRICT_MATCH = 0x0;
static const int SQL_CP_RELAXED_MATCH = 0x1;
static const int SQL_CP_MATCH_DEFAULT = 0x0;
static const Shortint SQL_ACCESS_MODE = 0x65;
static const Shortint SQL_AUTOCOMMIT = 0x66;
static const Shortint SQL_LOGIN_TIMEOUT = 0x67;
static const Shortint SQL_OPT_TRACE = 0x68;
static const Shortint SQL_OPT_TRACEFILE = 0x69;
static const Shortint SQL_TRANSLATE_DLL = 0x6a;
static const Shortint SQL_TRANSLATE_OPTION = 0x6b;
static const Shortint SQL_TXN_ISOLATION = 0x6c;
static const Shortint SQL_CURRENT_QUALIFIER = 0x6d;
static const Shortint SQL_ODBC_CURSORS = 0x6e;
static const Shortint SQL_QUIET_MODE = 0x6f;
static const Shortint SQL_PACKET_SIZE = 0x70;
static const Shortint SQL_ATTR_ACCESS_MODE = 0x65;
static const Shortint SQL_ATTR_AUTOCOMMIT = 0x66;
static const Shortint SQL_ATTR_CONNECTION_TIMEOUT = 0x71;
static const Shortint SQL_ATTR_CURRENT_CATALOG = 0x6d;
static const Shortint SQL_ATTR_DISCONNECT_BEHAVIOR = 0x72;
static const Word SQL_ATTR_ENLIST_IN_DTC = 0x4b7;
static const Word SQL_ATTR_ENLIST_IN_XA = 0x4b8;
static const Shortint SQL_ATTR_LOGIN_TIMEOUT = 0x67;
static const Shortint SQL_ATTR_ODBC_CURSORS = 0x6e;
static const Shortint SQL_ATTR_PACKET_SIZE = 0x70;
static const Shortint SQL_ATTR_QUIET_MODE = 0x6f;
static const Shortint SQL_ATTR_TRACE = 0x68;
static const Shortint SQL_ATTR_TRACEFILE = 0x69;
static const Shortint SQL_ATTR_TRANSLATE_LIB = 0x6a;
static const Shortint SQL_ATTR_TRANSLATE_OPTION = 0x6b;
static const Shortint SQL_ATTR_TXN_ISOLATION = 0x6c;
static const Word SQL_ATTR_CONNECTION_DEAD = 0x4b9;
static const Shortint SQL_ATTR_ANSI_APP = 0x73;
static const Word SQL_CONNECT_OPT_DRVR_START = 0x3e8;
static const Shortint SQL_CONN_OPT_MAX = 0x70;
static const Shortint SQL_CONN_OPT_MIN = 0x65;
static const int SQL_MODE_READ_WRITE = 0x0;
static const int SQL_MODE_READ_ONLY = 0x1;
static const int SQL_MODE_DEFAULT = 0x0;
static const int SQL_AUTOCOMMIT_OFF = 0x0;
static const int SQL_AUTOCOMMIT_ON = 0x1;
static const int SQL_AUTOCOMMIT_DEFAULT = 0x1;
static const int SQL_LOGIN_TIMEOUT_DEFAULT = 0xf;
static const int SQL_OPT_TRACE_OFF = 0x0;
static const int SQL_OPT_TRACE_ON = 0x1;
static const int SQL_OPT_TRACE_DEFAULT = 0x0;
#define SQL_OPT_TRACE_FILE_DEFAULT "\\\\SQL.LOG"
static const int SQL_CUR_USE_IF_NEEDED = 0x0;
static const int SQL_CUR_USE_ODBC = 0x1;
static const int SQL_CUR_USE_DRIVER = 0x2;
static const int SQL_CUR_DEFAULT = 0x2;
static const int SQL_DB_RETURN_TO_POOL = 0x0;
static const int SQL_DB_DISCONNECT = 0x1;
static const int SQL_DB_DEFAULT = 0x0;
static const Shortint SQL_DTC_DONE = 0x0;
static const Shortint SQL_CD_TRUE = 0x1;
static const Shortint SQL_CD_FALSE = 0x0;
static const Shortint SQL_AA_TRUE = 0x1;
static const Shortint SQL_AA_FALSE = 0x0;
static const Shortint SQL_QUERY_TIMEOUT = 0x0;
static const Shortint SQL_MAX_ROWS = 0x1;
static const Shortint SQL_NOSCAN = 0x2;
static const Shortint SQL_MAX_LENGTH = 0x3;
static const Shortint SQL_ASYNC_ENABLE = 0x4;
static const Shortint SQL_BIND_TYPE = 0x5;
static const Shortint SQL_CURSOR_TYPE = 0x6;
static const Shortint SQL_CONCURRENCY = 0x7;
static const Shortint SQL_KEYSET_SIZE = 0x8;
static const Shortint SQL_ROWSET_SIZE = 0x9;
static const Shortint SQL_SIMULATE_CURSOR = 0xa;
static const Shortint SQL_RETRIEVE_DATA = 0xb;
static const Shortint SQL_USE_BOOKMARKS = 0xc;
static const Shortint SQL_GET_BOOKMARK = 0xd;
static const Shortint SQL_ROW_NUMBER = 0xe;
static const Shortint SQL_ATTR_ASYNC_ENABLE = 0x4;
static const Shortint SQL_ATTR_CONCURRENCY = 0x7;
static const Shortint SQL_ATTR_CURSOR_TYPE = 0x6;
static const Shortint SQL_ATTR_ENABLE_AUTO_IPD = 0xf;
static const Shortint SQL_ATTR_FETCH_BOOKMARK_PTR = 0x10;
static const Shortint SQL_ATTR_KEYSET_SIZE = 0x8;
static const Shortint SQL_ATTR_MAX_LENGTH = 0x3;
static const Shortint SQL_ATTR_MAX_ROWS = 0x1;
static const Shortint SQL_ATTR_NOSCAN = 0x2;
static const Shortint SQL_ATTR_PARAM_BIND_OFFSET_PTR = 0x11;
static const Shortint SQL_ATTR_PARAM_BIND_TYPE = 0x12;
static const Shortint SQL_ATTR_PARAM_OPERATION_PTR = 0x13;
static const Shortint SQL_ATTR_PARAM_STATUS_PTR = 0x14;
static const Shortint SQL_ATTR_PARAMS_PROCESSED_PTR = 0x15;
static const Shortint SQL_ATTR_PARAMSET_SIZE = 0x16;
static const Shortint SQL_ATTR_QUERY_TIMEOUT = 0x0;
static const Shortint SQL_ATTR_RETRIEVE_DATA = 0xb;
static const Shortint SQL_ATTR_ROW_BIND_OFFSET_PTR = 0x17;
static const Shortint SQL_ATTR_ROW_BIND_TYPE = 0x5;
static const Shortint SQL_ATTR_ROW_NUMBER = 0xe;
static const Shortint SQL_ATTR_ROW_OPERATION_PTR = 0x18;
static const Shortint SQL_ATTR_ROW_STATUS_PTR = 0x19;
static const Shortint SQL_ATTR_ROWS_FETCHED_PTR = 0x1a;
static const Shortint SQL_ATTR_ROW_ARRAY_SIZE = 0x1b;
static const Shortint SQL_ATTR_SIMULATE_CURSOR = 0xa;
static const Shortint SQL_ATTR_USE_BOOKMARKS = 0xc;
static const Shortint SQL_STMT_OPT_MAX = 0xe;
static const Shortint SQL_STMT_OPT_MIN = 0x0;
static const Shortint SQL_COLUMN_COUNT = 0x0;
static const Shortint SQL_COLUMN_NAME = 0x1;
static const Shortint SQL_COLUMN_TYPE = 0x2;
static const Shortint SQL_COLUMN_LENGTH = 0x3;
static const Shortint SQL_COLUMN_PRECISION = 0x4;
static const Shortint SQL_COLUMN_SCALE = 0x5;
static const Shortint SQL_COLUMN_DISPLAY_SIZE = 0x6;
static const Shortint SQL_COLUMN_NULLABLE = 0x7;
static const Shortint SQL_COLUMN_UNSIGNED = 0x8;
static const Shortint SQL_COLUMN_MONEY = 0x9;
static const Shortint SQL_COLUMN_UPDATABLE = 0xa;
static const Shortint SQL_COLUMN_AUTO_INCREMENT = 0xb;
static const Shortint SQL_COLUMN_CASE_SENSITIVE = 0xc;
static const Shortint SQL_COLUMN_SEARCHABLE = 0xd;
static const Shortint SQL_COLUMN_TYPE_NAME = 0xe;
static const Shortint SQL_COLUMN_TABLE_NAME = 0xf;
static const Shortint SQL_COLUMN_OWNER_NAME = 0x10;
static const Shortint SQL_COLUMN_QUALIFIER_NAME = 0x11;
static const Shortint SQL_COLUMN_LABEL = 0x12;
static const Shortint SQL_COLATT_OPT_MAX = 0x12;
static const Shortint SQL_COLATT_OPT_MIN = 0x0;
static const Shortint SQL_ATTR_READONLY = 0x0;
static const Shortint SQL_ATTR_WRITE = 0x1;
static const Shortint SQL_ATTR_READWRITE_UNKNOWN = 0x2;
static const Shortint SQL_UNSEARCHABLE = 0x0;
static const Shortint SQL_LIKE_ONLY = 0x1;
static const Shortint SQL_ALL_EXCEPT_LIKE = 0x2;
static const Shortint SQL_SEARCHABLE = 0x3;
static const Shortint SQL_PRED_SEARCHABLE = 0x3;
static const Shortint SQL_NO_TOTAL = 0xfffffffc;
static const Shortint SQL_COL_PRED_CHAR = 0x1;
static const Shortint SQL_COL_PRED_BASIC = 0x2;
static const Shortint SQL_IS_POINTER = 0xfffffffc;
static const Shortint SQL_IS_UINTEGER = 0xfffffffb;
static const Shortint SQL_IS_INTEGER = 0xfffffffa;
static const Shortint SQL_IS_USMALLINT = 0xfffffff9;
static const Shortint SQL_IS_SMALLINT = 0xfffffff8;
static const int SQL_PARAM_BIND_BY_COLUMN = 0x0;
static const int SQL_PARAM_BIND_TYPE_DEFAULT = 0x0;
static const int SQL_QUERY_TIMEOUT_DEFAULT = 0x0;
static const int SQL_MAX_ROWS_DEFAULT = 0x0;
static const int SQL_NOSCAN_OFF = 0x0;
static const int SQL_NOSCAN_ON = 0x1;
static const int SQL_NOSCAN_DEFAULT = 0x0;
static const int SQL_MAX_LENGTH_DEFAULT = 0x0;
static const int SQL_ASYNC_ENABLE_OFF = 0x0;
static const int SQL_ASYNC_ENABLE_ON = 0x1;
static const int SQL_ASYNC_ENABLE_DEFAULT = 0x0;
static const int SQL_BIND_BY_COLUMN = 0x0;
static const int SQL_BIND_TYPE_DEFAULT = 0x0;
static const Shortint SQL_CONCUR_READ_ONLY = 0x1;
static const Shortint SQL_CONCUR_LOCK = 0x2;
static const Shortint SQL_CONCUR_ROWVER = 0x3;
static const Shortint SQL_CONCUR_VALUES = 0x4;
static const Shortint SQL_CONCUR_DEFAULT = 0x1;
static const int SQL_CURSOR_FORWARD_ONLY = 0x0;
static const int SQL_CURSOR_KEYSET_DRIVEN = 0x1;
static const int SQL_CURSOR_DYNAMIC = 0x2;
static const int SQL_CURSOR_STATIC = 0x3;
static const int SQL_CURSOR_TYPE_DEFAULT = 0x0;
static const int SQL_ROWSET_SIZE_DEFAULT = 0x1;
static const int SQL_KEYSET_SIZE_DEFAULT = 0x0;
static const int SQL_SC_NON_UNIQUE = 0x0;
static const int SQL_SC_TRY_UNIQUE = 0x1;
static const int SQL_SC_UNIQUE = 0x2;
static const int SQL_RD_OFF = 0x0;
static const int SQL_RD_ON = 0x1;
static const int SQL_RD_DEFAULT = 0x1;
static const int SQL_UB_OFF = 0x0;
static const int SQL_UB_ON = 0x1;
static const int SQL_UB_DEFAULT = 0x0;
static const int SQL_UB_FIXED = 0x1;
static const int SQL_UB_VARIABLE = 0x2;
static const Shortint SQL_DESC_ARRAY_SIZE = 0x14;
static const Shortint SQL_DESC_ARRAY_STATUS_PTR = 0x15;
static const Shortint SQL_DESC_AUTO_UNIQUE_VALUE = 0xb;
static const Shortint SQL_DESC_BASE_COLUMN_NAME = 0x16;
static const Shortint SQL_DESC_BASE_TABLE_NAME = 0x17;
static const Shortint SQL_DESC_BIND_OFFSET_PTR = 0x18;
static const Shortint SQL_DESC_BIND_TYPE = 0x19;
static const Shortint SQL_DESC_CASE_SENSITIVE = 0xc;
static const Shortint SQL_DESC_CATALOG_NAME = 0x11;
static const Shortint SQL_DESC_CONCISE_TYPE = 0x2;
static const Shortint SQL_DESC_DATETIME_INTERVAL_PRECISION = 0x1a;
static const Shortint SQL_DESC_DISPLAY_SIZE = 0x6;
static const Shortint SQL_DESC_FIXED_PREC_SCALE = 0x9;
static const Shortint SQL_DESC_LABEL = 0x12;
static const Shortint SQL_DESC_LITERAL_PREFIX = 0x1b;
static const Shortint SQL_DESC_LITERAL_SUFFIX = 0x1c;
static const Shortint SQL_DESC_LOCAL_TYPE_NAME = 0x1d;
static const Shortint SQL_DESC_MAXIMUM_SCALE = 0x1e;
static const Shortint SQL_DESC_MINIMUM_SCALE = 0x1f;
static const Shortint SQL_DESC_NUM_PREC_RADIX = 0x20;
static const Shortint SQL_DESC_PARAMETER_TYPE = 0x21;
static const Shortint SQL_DESC_ROWS_PROCESSED_PTR = 0x22;
static const Shortint SQL_DESC_ROWVER = 0x23;
static const Shortint SQL_DESC_SCHEMA_NAME = 0x10;
static const Shortint SQL_DESC_SEARCHABLE = 0xd;
static const Shortint SQL_DESC_TYPE_NAME = 0xe;
static const Shortint SQL_DESC_TABLE_NAME = 0xf;
static const Shortint SQL_DESC_UNSIGNED = 0x8;
static const Shortint SQL_DESC_UPDATABLE = 0xa;
static const short SQL_DIAG_CURSOR_ROW_COUNT = 0xfffffb1f;
static const short SQL_DIAG_ROW_NUMBER = 0xfffffb20;
static const short SQL_DIAG_COLUMN_NUMBER = 0xfffffb21;
static const Shortint SQL_DATE = 0x9;
static const Shortint SQL_INTERVAL = 0xa;
static const Shortint SQL_TIME = 0xa;
static const Shortint SQL_TIMESTAMP = 0xb;
static const Shortint SQL_LONGVARCHAR = 0xffffffff;
static const Shortint SQL_BINARY = 0xfffffffe;
static const Shortint SQL_VARBINARY = 0xfffffffd;
static const Shortint SQL_LONGVARBINARY = 0xfffffffc;
static const Shortint SQL_BIGINT = 0xfffffffb;
static const Shortint SQL_TINYINT = 0xfffffffa;
static const Shortint SQL_BIT = 0xfffffff9;
static const Shortint SQL_GUID = 0xfffffff5;
static const Shortint SQL_CODE_YEAR = 0x1;
static const Shortint SQL_CODE_MONTH = 0x2;
static const Shortint SQL_CODE_DAY = 0x3;
static const Shortint SQL_CODE_HOUR = 0x4;
static const Shortint SQL_CODE_MINUTE = 0x5;
static const Shortint SQL_CODE_SECOND = 0x6;
static const Shortint SQL_CODE_YEAR_TO_MONTH = 0x7;
static const Shortint SQL_CODE_DAY_TO_HOUR = 0x8;
static const Shortint SQL_CODE_DAY_TO_MINUTE = 0x9;
static const Shortint SQL_CODE_DAY_TO_SECOND = 0xa;
static const Shortint SQL_CODE_HOUR_TO_MINUTE = 0xb;
static const Shortint SQL_CODE_HOUR_TO_SECOND = 0xc;
static const Shortint SQL_CODE_MINUTE_TO_SECOND = 0xd;
static const Shortint SQL_INTERVAL_YEAR = 0x65;
static const Shortint SQL_INTERVAL_MONTH = 0x66;
static const Shortint SQL_INTERVAL_DAY = 0x67;
static const Shortint SQL_INTERVAL_HOUR = 0x68;
static const Shortint SQL_INTERVAL_MINUTE = 0x69;
static const Shortint SQL_INTERVAL_SECOND = 0x6a;
static const Shortint SQL_INTERVAL_YEAR_TO_MONTH = 0x6b;
static const Shortint SQL_INTERVAL_DAY_TO_HOUR = 0x6c;
static const Shortint SQL_INTERVAL_DAY_TO_MINUTE = 0x6d;
static const Shortint SQL_INTERVAL_DAY_TO_SECOND = 0x6e;
static const Shortint SQL_INTERVAL_HOUR_TO_MINUTE = 0x6f;
static const Shortint SQL_INTERVAL_HOUR_TO_SECOND = 0x70;
static const Shortint SQL_INTERVAL_MINUTE_TO_SECOND = 0x71;
static const Shortint SQL_UNICODE = 0xfffffff8;
static const Shortint SQL_UNICODE_VARCHAR = 0xfffffff7;
static const Shortint SQL_UNICODE_LONGVARCHAR = 0xfffffff6;
static const Shortint SQL_UNICODE_CHAR = 0xfffffff8;
static const Shortint SQL_C_CHAR = 0x1;
static const Shortint SQL_C_LONG = 0x4;
static const Shortint SQL_C_SHORT = 0x5;
static const Shortint SQL_C_FLOAT = 0x7;
static const Shortint SQL_C_DOUBLE = 0x8;
static const Shortint SQL_C_NUMERIC = 0x2;
static const Shortint SQL_C_DEFAULT = 0x63;
static const Shortint SQL_SIGNED_OFFSET = 0xffffffec;
static const Shortint SQL_UNSIGNED_OFFSET = 0xffffffea;
static const Shortint SQL_C_DATE = 0x9;
static const Shortint SQL_C_TIME = 0xa;
static const Shortint SQL_C_TIMESTAMP = 0xb;
static const Shortint SQL_C_TYPE_DATE = 0x5b;
static const Shortint SQL_C_TYPE_TIME = 0x5c;
static const Shortint SQL_C_TYPE_TIMESTAMP = 0x5d;
static const Shortint SQL_C_INTERVAL_YEAR = 0x65;
static const Shortint SQL_C_INTERVAL_MONTH = 0x66;
static const Shortint SQL_C_INTERVAL_DAY = 0x67;
static const Shortint SQL_C_INTERVAL_HOUR = 0x68;
static const Shortint SQL_C_INTERVAL_MINUTE = 0x69;
static const Shortint SQL_C_INTERVAL_SECOND = 0x6a;
static const Shortint SQL_C_INTERVAL_YEAR_TO_MONTH = 0x6b;
static const Shortint SQL_C_INTERVAL_DAY_TO_HOUR = 0x6c;
static const Shortint SQL_C_INTERVAL_DAY_TO_MINUTE = 0x6d;
static const Shortint SQL_C_INTERVAL_DAY_TO_SECOND = 0x6e;
static const Shortint SQL_C_INTERVAL_HOUR_TO_MINUTE = 0x6f;
static const Shortint SQL_C_INTERVAL_HOUR_TO_SECOND = 0x70;
static const Shortint SQL_C_INTERVAL_MINUTE_TO_SECOND = 0x71;
static const Shortint SQL_C_BINARY = 0xfffffffe;
static const Shortint SQL_C_BIT = 0xfffffff9;
static const Shortint SQL_C_SBIGINT = 0xffffffe7;
static const Shortint SQL_C_UBIGINT = 0xffffffe5;
static const Shortint SQL_C_TINYINT = 0xfffffffa;
static const Shortint SQL_C_SLONG = 0xfffffff0;
static const Shortint SQL_C_SSHORT = 0xfffffff1;
static const Shortint SQL_C_STINYINT = 0xffffffe6;
static const Shortint SQL_C_ULONG = 0xffffffee;
static const Shortint SQL_C_USHORT = 0xffffffef;
static const Shortint SQL_C_UTINYINT = 0xffffffe4;
static const Shortint SQL_C_GUID = 0xfffffff5;
static const Shortint SQL_TYPE_NULL = 0x0;
static const Shortint SQL_C_VARBOOKMARK = 0xfffffffe;
static const Shortint SQL_NO_ROW_NUMBER = 0xffffffff;
static const Shortint SQL_NO_COLUMN_NUMBER = 0xffffffff;
static const Shortint SQL_ROW_NUMBER_UNKNOWN = 0xfffffffe;
static const Shortint SQL_COLUMN_NUMBER_UNKNOWN = 0xfffffffe;
static const Shortint SQL_DEFAULT_PARAM = 0xfffffffb;
static const Shortint SQL_IGNORE = 0xfffffffa;
static const Shortint SQL_COLUMN_IGNORE = 0xfffffffa;
static const Shortint SQL_LEN_DATA_AT_EXEC_OFFSET = 0xffffff9c;
static const Shortint SQL_LEN_BINARY_ATTR_OFFSET = 0xffffff9c;
static const Shortint SQL_PARAM_TYPE_UNKNOWN = 0x0;
static const Shortint SQL_PARAM_INPUT = 0x1;
static const Shortint SQL_PARAM_INPUT_OUTPUT = 0x2;
static const Shortint SQL_RESULT_COL = 0x3;
static const Shortint SQL_PARAM_OUTPUT = 0x4;
static const Shortint SQL_RETURN_VALUE = 0x5;
static const Shortint SQL_PARAM_TYPE_DEFAULT = 0x2;
static const Shortint SQL_SETPARAM_VALUE_MAX = 0xffffffff;
static const Shortint SQL_API_SQLALLOCHANDLESTD = 0x49;
static const Shortint SQL_API_SQLBULKOPERATIONS = 0x18;
static const Shortint SQL_API_SQLBINDPARAMETER = 0x48;
static const Shortint SQL_API_SQLBROWSECONNECT = 0x37;
static const Shortint SQL_API_SQLCOLATTRIBUTES = 0x6;
static const Shortint SQL_API_SQLCOLUMNPRIVILEGES = 0x38;
static const Shortint SQL_API_SQLDESCRIBEPARAM = 0x3a;
static const Shortint SQL_API_SQLDRIVERCONNECT = 0x29;
static const Shortint SQL_API_SQLDRIVERS = 0x47;
static const Shortint SQL_API_SQLEXTENDEDFETCH = 0x3b;
static const Shortint SQL_API_SQLFOREIGNKEYS = 0x3c;
static const Shortint SQL_API_SQLMORERESULTS = 0x3d;
static const Shortint SQL_API_SQLNATIVESQL = 0x3e;
static const Shortint SQL_API_SQLNUMPARAMS = 0x3f;
static const Shortint SQL_API_SQLPARAMOPTIONS = 0x40;
static const Shortint SQL_API_SQLPRIMARYKEYS = 0x41;
static const Shortint SQL_API_SQLPROCEDURECOLUMNS = 0x42;
static const Shortint SQL_API_SQLPROCEDURES = 0x43;
static const Shortint SQL_API_SQLSETPOS = 0x44;
static const Shortint SQL_API_SQLSETSCROLLOPTIONS = 0x45;
static const Shortint SQL_API_SQLTABLEPRIVILEGES = 0x46;
static const Shortint SQL_API_ALL_FUNCTIONS = 0x0;
static const Byte SQL_API_LOADBYORDINAL = 0xc7;
static const Word SQL_API_ODBC3_ALL_FUNCTIONS = 0x3e7;
static const Byte SQL_API_ODBC3_ALL_FUNCTIONS_SIZE = 0xfa;
static const Shortint SQL_INFO_FIRST = 0x0;
static const Shortint SQL_ACTIVE_CONNECTIONS = 0x0;
static const Shortint SQL_ACTIVE_STATEMENTS = 0x1;
static const Shortint SQL_DRIVER_HDBC = 0x3;
static const Shortint SQL_DRIVER_HENV = 0x4;
static const Shortint SQL_DRIVER_HSTMT = 0x5;
static const Shortint SQL_DRIVER_NAME = 0x6;
static const Shortint SQL_DRIVER_VER = 0x7;
static const Shortint SQL_ODBC_API_CONFORMANCE = 0x9;
static const Shortint SQL_ODBC_VER = 0xa;
static const Shortint SQL_ROW_UPDATES = 0xb;
static const Shortint SQL_ODBC_SAG_CLI_CONFORMANCE = 0xc;
static const Shortint SQL_ODBC_SQL_CONFORMANCE = 0xf;
static const Shortint SQL_PROCEDURES = 0x15;
static const Shortint SQL_CONCAT_NULL_BEHAVIOR = 0x16;
static const Shortint SQL_CURSOR_ROLLBACK_BEHAVIOR = 0x18;
static const Shortint SQL_EXPRESSIONS_IN_ORDERBY = 0x1b;
static const Shortint SQL_MAX_OWNER_NAME_LEN = 0x20;
static const Shortint SQL_MAX_PROCEDURE_NAME_LEN = 0x21;
static const Shortint SQL_MAX_QUALIFIER_NAME_LEN = 0x22;
static const Shortint SQL_MULT_RESULT_SETS = 0x24;
static const Shortint SQL_MULTIPLE_ACTIVE_TXN = 0x25;
static const Shortint SQL_OUTER_JOINS = 0x26;
static const Shortint SQL_OWNER_TERM = 0x27;
static const Shortint SQL_PROCEDURE_TERM = 0x28;
static const Shortint SQL_QUALIFIER_NAME_SEPARATOR = 0x29;
static const Shortint SQL_QUALIFIER_TERM = 0x2a;
static const Shortint SQL_SCROLL_OPTIONS = 0x2c;
static const Shortint SQL_TABLE_TERM = 0x2d;
static const Shortint SQL_CONVERT_FUNCTIONS = 0x30;
static const Shortint SQL_NUMERIC_FUNCTIONS = 0x31;
static const Shortint SQL_STRING_FUNCTIONS = 0x32;
static const Shortint SQL_SYSTEM_FUNCTIONS = 0x33;
static const Shortint SQL_TIMEDATE_FUNCTIONS = 0x34;
static const Shortint SQL_CONVERT_BIGINT = 0x35;
static const Shortint SQL_CONVERT_BINARY = 0x36;
static const Shortint SQL_CONVERT_BIT = 0x37;
static const Shortint SQL_CONVERT_CHAR = 0x38;
static const Shortint SQL_CONVERT_DATE = 0x39;
static const Shortint SQL_CONVERT_DECIMAL = 0x3a;
static const Shortint SQL_CONVERT_DOUBLE = 0x3b;
static const Shortint SQL_CONVERT_FLOAT = 0x3c;
static const Shortint SQL_CONVERT_INTEGER = 0x3d;
static const Shortint SQL_CONVERT_LONGVARCHAR = 0x3e;
static const Shortint SQL_CONVERT_NUMERIC = 0x3f;
static const Shortint SQL_CONVERT_REAL = 0x40;
static const Shortint SQL_CONVERT_SMALLINT = 0x41;
static const Shortint SQL_CONVERT_TIME = 0x42;
static const Shortint SQL_CONVERT_TIMESTAMP = 0x43;
static const Shortint SQL_CONVERT_TINYINT = 0x44;
static const Shortint SQL_CONVERT_VARBINARY = 0x45;
static const Shortint SQL_CONVERT_VARCHAR = 0x46;
static const Shortint SQL_CONVERT_LONGVARBINARY = 0x47;
static const Shortint SQL_ODBC_SQL_OPT_IEF = 0x49;
static const Shortint SQL_CORRELATION_NAME = 0x4a;
static const Shortint SQL_NON_NULLABLE_COLUMNS = 0x4b;
static const Shortint SQL_DRIVER_HLIB = 0x4c;
static const Shortint SQL_DRIVER_ODBC_VER = 0x4d;
static const Shortint SQL_LOCK_TYPES = 0x4e;
static const Shortint SQL_POS_OPERATIONS = 0x4f;
static const Shortint SQL_POSITIONED_STATEMENTS = 0x50;
static const Shortint SQL_BOOKMARK_PERSISTENCE = 0x52;
static const Shortint SQL_STATIC_SENSITIVITY = 0x53;
static const Shortint SQL_FILE_USAGE = 0x54;
static const Shortint SQL_COLUMN_ALIAS = 0x57;
static const Shortint SQL_GROUP_BY = 0x58;
static const Shortint SQL_KEYWORDS = 0x59;
static const Shortint SQL_OWNER_USAGE = 0x5b;
static const Shortint SQL_QUALIFIER_USAGE = 0x5c;
static const Shortint SQL_QUOTED_IDENTIFIER_CASE = 0x5d;
static const Shortint SQL_SUBQUERIES = 0x5f;
static const Shortint SQL_UNION = 0x60;
static const Shortint SQL_MAX_ROW_SIZE_INCLUDES_LONG = 0x67;
static const Shortint SQL_MAX_CHAR_LITERAL_LEN = 0x6c;
static const Shortint SQL_TIMEDATE_ADD_INTERVALS = 0x6d;
static const Shortint SQL_TIMEDATE_DIFF_INTERVALS = 0x6e;
static const Shortint SQL_NEED_LONG_DATA_LEN = 0x6f;
static const Shortint SQL_MAX_BINARY_LITERAL_LEN = 0x70;
static const Shortint SQL_LIKE_ESCAPE_CLAUSE = 0x71;
static const Shortint SQL_QUALIFIER_LOCATION = 0x72;
static const Shortint SQL_ACTIVE_ENVIRONMENTS = 0x74;
static const Shortint SQL_ALTER_DOMAIN = 0x75;
static const Shortint SQL_SQL_CONFORMANCE = 0x76;
static const Shortint SQL_DATETIME_LITERALS = 0x77;
static const Word SQL_ASYNC_MODE = 0x2725;
static const Shortint SQL_BATCH_ROW_COUNT = 0x78;
static const Shortint SQL_BATCH_SUPPORT = 0x79;
static const Shortint SQL_CATALOG_LOCATION = 0x72;
static const Shortint SQL_CATALOG_NAME_SEPARATOR = 0x29;
static const Shortint SQL_CATALOG_TERM = 0x2a;
static const Shortint SQL_CATALOG_USAGE = 0x5c;
static const Shortint SQL_CONVERT_WCHAR = 0x7a;
static const Shortint SQL_CONVERT_INTERVAL_DAY_TIME = 0x7b;
static const Shortint SQL_CONVERT_INTERVAL_YEAR_MONTH = 0x7c;
static const Shortint SQL_CONVERT_WLONGVARCHAR = 0x7d;
static const Shortint SQL_CONVERT_WVARCHAR = 0x7e;
static const Shortint SQL_CREATE_ASSERTION = 0x7f;
static const Byte SQL_CREATE_CHARACTER_SET = 0x80;
static const Byte SQL_CREATE_COLLATION = 0x81;
static const Byte SQL_CREATE_DOMAIN = 0x82;
static const Byte SQL_CREATE_SCHEMA = 0x83;
static const Byte SQL_CREATE_TABLE = 0x84;
static const Byte SQL_CREATE_TRANSLATION = 0x85;
static const Byte SQL_CREATE_VIEW = 0x86;
static const Byte SQL_DRIVER_HDESC = 0x87;
static const Byte SQL_DROP_ASSERTION = 0x88;
static const Byte SQL_DROP_CHARACTER_SET = 0x89;
static const Byte SQL_DROP_COLLATION = 0x8a;
static const Byte SQL_DROP_DOMAIN = 0x8b;
static const Byte SQL_DROP_SCHEMA = 0x8c;
static const Byte SQL_DROP_TABLE = 0x8d;
static const Byte SQL_DROP_TRANSLATION = 0x8e;
static const Byte SQL_DROP_VIEW = 0x8f;
static const Byte SQL_DYNAMIC_CURSOR_ATTRIBUTES1 = 0x90;
static const Byte SQL_DYNAMIC_CURSOR_ATTRIBUTES2 = 0x91;
static const Byte SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1 = 0x92;
static const Byte SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2 = 0x93;
static const Byte SQL_INDEX_KEYWORDS = 0x94;
static const Byte SQL_INFO_SCHEMA_VIEWS = 0x95;
static const Byte SQL_KEYSET_CURSOR_ATTRIBUTES1 = 0x96;
static const Byte SQL_KEYSET_CURSOR_ATTRIBUTES2 = 0x97;
static const Word SQL_MAX_ASYNC_CONCURRENT_STATEMENTS = 0x2726;
static const Byte SQL_ODBC_INTERFACE_CONFORMANCE = 0x98;
static const Byte SQL_PARAM_ARRAY_ROW_COUNTS = 0x99;
static const Byte SQL_PARAM_ARRAY_SELECTS = 0x9a;
static const Shortint SQL_SCHEMA_TERM = 0x27;
static const Shortint SQL_SCHEMA_USAGE = 0x5b;
static const Byte SQL_SQL92_DATETIME_FUNCTIONS = 0x9b;
static const Byte SQL_SQL92_FOREIGN_KEY_DELETE_RULE = 0x9c;
static const Byte SQL_SQL92_FOREIGN_KEY_UPDATE_RULE = 0x9d;
static const Byte SQL_SQL92_GRANT = 0x9e;
static const Byte SQL_SQL92_NUMERIC_VALUE_FUNCTIONS = 0x9f;
static const Byte SQL_SQL92_PREDICATES = 0xa0;
static const Byte SQL_SQL92_RELATIONAL_JOIN_OPERATORS = 0xa1;
static const Byte SQL_SQL92_REVOKE = 0xa2;
static const Byte SQL_SQL92_ROW_VALUE_CONSTRUCTOR = 0xa3;
static const Byte SQL_SQL92_STRING_FUNCTIONS = 0xa4;
static const Byte SQL_SQL92_VALUE_EXPRESSIONS = 0xa5;
static const Byte SQL_STANDARD_CLI_CONFORMANCE = 0xa6;
static const Byte SQL_STATIC_CURSOR_ATTRIBUTES1 = 0xa7;
static const Byte SQL_STATIC_CURSOR_ATTRIBUTES2 = 0xa8;
static const Byte SQL_AGGREGATE_FUNCTIONS = 0xa9;
static const Byte SQL_DDL_INDEX = 0xaa;
static const Byte SQL_DM_VER = 0xab;
static const Byte SQL_INSERT_STATEMENT = 0xac;
static const Byte SQL_CONVERT_GUID = 0xad;
static const Shortint SQL_UNION_STATEMENT = 0x60;
static const Word SQL_DTC_TRANSITION_COST = 0x6d6;
static const Shortint SQL_CVT_CHAR = 0x1;
static const Shortint SQL_CVT_NUMERIC = 0x2;
static const Shortint SQL_CVT_DECIMAL = 0x4;
static const Shortint SQL_CVT_INTEGER = 0x8;
static const Shortint SQL_CVT_SMALLINT = 0x10;
static const Shortint SQL_CVT_FLOAT = 0x20;
static const Shortint SQL_CVT_REAL = 0x40;
static const Byte SQL_CVT_DOUBLE = 0x80;
static const Word SQL_CVT_VARCHAR = 0x100;
static const Word SQL_CVT_LONGVARCHAR = 0x200;
static const Word SQL_CVT_BINARY = 0x400;
static const Word SQL_CVT_VARBINARY = 0x800;
static const Word SQL_CVT_BIT = 0x1000;
static const Word SQL_CVT_TINYINT = 0x2000;
static const Word SQL_CVT_BIGINT = 0x4000;
static const Word SQL_CVT_DATE = 0x8000;
static const int SQL_CVT_TIME = 0x10000;
static const int SQL_CVT_TIMESTAMP = 0x20000;
static const int SQL_CVT_LONGVARBINARY = 0x40000;
static const int SQL_CVT_INTERVAL_YEAR_MONTH = 0x80000;
static const int SQL_CVT_INTERVAL_DAY_TIME = 0x100000;
static const int SQL_CVT_WCHAR = 0x200000;
static const int SQL_CVT_WLONGVARCHAR = 0x400000;
static const int SQL_CVT_WVARCHAR = 0x800000;
static const int SQL_CVT_GUID = 0x1000000;
static const Shortint SQL_FN_CVT_CONVERT = 0x1;
static const Shortint SQL_FN_CVT_CAST = 0x2;
static const Shortint SQL_FN_STR_CONCAT = 0x1;
static const Shortint SQL_FN_STR_INSERT = 0x2;
static const Shortint SQL_FN_STR_LEFT = 0x4;
static const Shortint SQL_FN_STR_LTRIM = 0x8;
static const Shortint SQL_FN_STR_LENGTH = 0x10;
static const Shortint SQL_FN_STR_LOCATE = 0x20;
static const Shortint SQL_FN_STR_LCASE = 0x40;
static const Byte SQL_FN_STR_REPEAT = 0x80;
static const Word SQL_FN_STR_REPLACE = 0x100;
static const Word SQL_FN_STR_RIGHT = 0x200;
static const Word SQL_FN_STR_RTRIM = 0x400;
static const Word SQL_FN_STR_SUBSTRING = 0x800;
static const Word SQL_FN_STR_UCASE = 0x1000;
static const Word SQL_FN_STR_ASCII = 0x2000;
static const Word SQL_FN_STR_CHAR = 0x4000;
static const Word SQL_FN_STR_DIFFERENCE = 0x8000;
static const int SQL_FN_STR_LOCATE_2 = 0x10000;
static const int SQL_FN_STR_SOUNDEX = 0x20000;
static const int SQL_FN_STR_SPACE = 0x40000;
static const int SQL_FN_STR_BIT_LENGTH = 0x80000;
static const int SQL_FN_STR_CHAR_LENGTH = 0x100000;
static const int SQL_FN_STR_CHARACTER_LENGTH = 0x200000;
static const int SQL_FN_STR_OCTET_LENGTH = 0x400000;
static const int SQL_FN_STR_POSITION = 0x800000;
static const Shortint SQL_SSF_CONVERT = 0x1;
static const Shortint SQL_SSF_LOWER = 0x2;
static const Shortint SQL_SSF_UPPER = 0x4;
static const Shortint SQL_SSF_SUBSTRING = 0x8;
static const Shortint SQL_SSF_TRANSLATE = 0x10;
static const Shortint SQL_SSF_TRIM_BOTH = 0x20;
static const Shortint SQL_SSF_TRIM_LEADING = 0x40;
static const Byte SQL_SSF_TRIM_TRAILING = 0x80;
static const Shortint SQL_FN_NUM_ABS = 0x1;
static const Shortint SQL_FN_NUM_ACOS = 0x2;
static const Shortint SQL_FN_NUM_ASIN = 0x4;
static const Shortint SQL_FN_NUM_ATAN = 0x8;
static const Shortint SQL_FN_NUM_ATAN2 = 0x10;
static const Shortint SQL_FN_NUM_CEILING = 0x20;
static const Shortint SQL_FN_NUM_COS = 0x40;
static const Byte SQL_FN_NUM_COT = 0x80;
static const Word SQL_FN_NUM_EXP = 0x100;
static const Word SQL_FN_NUM_FLOOR = 0x200;
static const Word SQL_FN_NUM_LOG = 0x400;
static const Word SQL_FN_NUM_MOD = 0x800;
static const Word SQL_FN_NUM_SIGN = 0x1000;
static const Word SQL_FN_NUM_SIN = 0x2000;
static const Word SQL_FN_NUM_SQRT = 0x4000;
static const Word SQL_FN_NUM_TAN = 0x8000;
static const int SQL_FN_NUM_PI = 0x10000;
static const int SQL_FN_NUM_RAND = 0x20000;
static const int SQL_FN_NUM_DEGREES = 0x40000;
static const int SQL_FN_NUM_LOG10 = 0x80000;
static const int SQL_FN_NUM_POWER = 0x100000;
static const int SQL_FN_NUM_RADIANS = 0x200000;
static const int SQL_FN_NUM_ROUND = 0x400000;
static const int SQL_FN_NUM_TRUNCATE = 0x800000;
static const Shortint SQL_SNVF_BIT_LENGTH = 0x1;
static const Shortint SQL_SNVF_CHAR_LENGTH = 0x2;
static const Shortint SQL_SNVF_CHARACTER_LENGTH = 0x4;
static const Shortint SQL_SNVF_EXTRACT = 0x8;
static const Shortint SQL_SNVF_OCTET_LENGTH = 0x10;
static const Shortint SQL_SNVF_POSITION = 0x20;
static const Shortint SQL_FN_TD_NOW = 0x1;
static const Shortint SQL_FN_TD_CURDATE = 0x2;
static const Shortint SQL_FN_TD_DAYOFMONTH = 0x4;
static const Shortint SQL_FN_TD_DAYOFWEEK = 0x8;
static const Shortint SQL_FN_TD_DAYOFYEAR = 0x10;
static const Shortint SQL_FN_TD_MONTH = 0x20;
static const Shortint SQL_FN_TD_QUARTER = 0x40;
static const Byte SQL_FN_TD_WEEK = 0x80;
static const Word SQL_FN_TD_YEAR = 0x100;
static const Word SQL_FN_TD_CURTIME = 0x200;
static const Word SQL_FN_TD_HOUR = 0x400;
static const Word SQL_FN_TD_MINUTE = 0x800;
static const Word SQL_FN_TD_SECOND = 0x1000;
static const Word SQL_FN_TD_TIMESTAMPADD = 0x2000;
static const Word SQL_FN_TD_TIMESTAMPDIFF = 0x4000;
static const Word SQL_FN_TD_DAYNAME = 0x8000;
static const int SQL_FN_TD_MONTHNAME = 0x10000;
static const int SQL_FN_TD_CURRENT_DATE = 0x20000;
static const int SQL_FN_TD_CURRENT_TIME = 0x40000;
static const int SQL_FN_TD_CURRENT_TIMESTAMP = 0x80000;
static const int SQL_FN_TD_EXTRACT = 0x100000;
static const Shortint SQL_SDF_CURRENT_DATE = 0x1;
static const Shortint SQL_SDF_CURRENT_TIME = 0x2;
static const Shortint SQL_SDF_CURRENT_TIMESTAMP = 0x4;
static const Shortint SQL_FN_SYS_USERNAME = 0x1;
static const Shortint SQL_FN_SYS_DBNAME = 0x2;
static const Shortint SQL_FN_SYS_IFNULL = 0x4;
static const Shortint SQL_FN_TSI_FRAC_SECOND = 0x1;
static const Shortint SQL_FN_TSI_SECOND = 0x2;
static const Shortint SQL_FN_TSI_MINUTE = 0x4;
static const Shortint SQL_FN_TSI_HOUR = 0x8;
static const Shortint SQL_FN_TSI_DAY = 0x10;
static const Shortint SQL_FN_TSI_WEEK = 0x20;
static const Shortint SQL_FN_TSI_MONTH = 0x40;
static const Byte SQL_FN_TSI_QUARTER = 0x80;
static const Word SQL_FN_TSI_YEAR = 0x100;
static const Shortint SQL_CA1_NEXT = 0x1;
static const Shortint SQL_CA1_ABSOLUTE = 0x2;
static const Shortint SQL_CA1_RELATIVE = 0x4;
static const Shortint SQL_CA1_BOOKMARK = 0x8;
static const Shortint SQL_CA1_LOCK_NO_CHANGE = 0x40;
static const Byte SQL_CA1_LOCK_EXCLUSIVE = 0x80;
static const Word SQL_CA1_LOCK_UNLOCK = 0x100;
static const Word SQL_CA1_POS_POSITION = 0x200;
static const Word SQL_CA1_POS_UPDATE = 0x400;
static const Word SQL_CA1_POS_DELETE = 0x800;
static const Word SQL_CA1_POS_REFRESH = 0x1000;
static const Word SQL_CA1_POSITIONED_UPDATE = 0x2000;
static const Word SQL_CA1_POSITIONED_DELETE = 0x4000;
static const Word SQL_CA1_SELECT_FOR_UPDATE = 0x8000;
static const int SQL_CA1_BULK_ADD = 0x10000;
static const int SQL_CA1_BULK_UPDATE_BY_BOOKMARK = 0x20000;
static const int SQL_CA1_BULK_DELETE_BY_BOOKMARK = 0x40000;
static const int SQL_CA1_BULK_FETCH_BY_BOOKMARK = 0x80000;
static const Shortint SQL_CA2_READ_ONLY_CONCURRENCY = 0x1;
static const Shortint SQL_CA2_LOCK_CONCURRENCY = 0x2;
static const Shortint SQL_CA2_OPT_ROWVER_CONCURRENCY = 0x4;
static const Shortint SQL_CA2_OPT_VALUES_CONCURRENCY = 0x8;
static const Shortint SQL_CA2_SENSITIVITY_ADDITIONS = 0x10;
static const Shortint SQL_CA2_SENSITIVITY_DELETIONS = 0x20;
static const Shortint SQL_CA2_SENSITIVITY_UPDATES = 0x40;
static const Byte SQL_CA2_MAX_ROWS_SELECT = 0x80;
static const Word SQL_CA2_MAX_ROWS_INSERT = 0x100;
static const Word SQL_CA2_MAX_ROWS_DELETE = 0x200;
static const Word SQL_CA2_MAX_ROWS_UPDATE = 0x400;
static const Word SQL_CA2_MAX_ROWS_CATALOG = 0x800;
static const Word SQL_CA2_MAX_ROWS_AFFECTS_ALL = 0xf80;
static const Word SQL_CA2_CRC_EXACT = 0x1000;
static const Word SQL_CA2_CRC_APPROXIMATE = 0x2000;
static const Word SQL_CA2_SIMULATE_NON_UNIQUE = 0x4000;
static const Word SQL_CA2_SIMULATE_TRY_UNIQUE = 0x8000;
static const int SQL_CA2_SIMULATE_UNIQUE = 0x10000;
static const Shortint SQL_OAC_NONE = 0x0;
static const Shortint SQL_OAC_LEVEL1 = 0x1;
static const Shortint SQL_OAC_LEVEL2 = 0x2;
static const Shortint SQL_OSCC_NOT_COMPLIANT = 0x0;
static const Shortint SQL_OSCC_COMPLIANT = 0x1;
static const Shortint SQL_OSC_MINIMUM = 0x0;
static const Shortint SQL_OSC_CORE = 0x1;
static const Shortint SQL_OSC_EXTENDED = 0x2;
static const Shortint SQL_CB_NULL = 0x0;
static const Shortint SQL_CB_NON_NULL = 0x1;
static const Shortint SQL_SO_FORWARD_ONLY = 0x1;
static const Shortint SQL_SO_KEYSET_DRIVEN = 0x2;
static const Shortint SQL_SO_DYNAMIC = 0x4;
static const Shortint SQL_SO_MIXED = 0x8;
static const Shortint SQL_SO_STATIC = 0x10;
static const Shortint SQL_FD_FETCH_RESUME = 0x40;
static const Byte SQL_FD_FETCH_BOOKMARK = 0x80;
static const Shortint SQL_TXN_VERSIONING = 0x10;
static const Shortint SQL_CN_NONE = 0x0;
static const Shortint SQL_CN_DIFFERENT = 0x1;
static const Shortint SQL_CN_ANY = 0x2;
static const Shortint SQL_NNC_NULL = 0x0;
static const Shortint SQL_NNC_NON_NULL = 0x1;
static const Shortint SQL_NC_START = 0x2;
static const Shortint SQL_NC_END = 0x4;
static const Shortint SQL_FILE_NOT_SUPPORTED = 0x0;
static const Shortint SQL_FILE_TABLE = 0x1;
static const Shortint SQL_FILE_QUALIFIER = 0x2;
static const Shortint SQL_FILE_CATALOG = 0x2;
static const Shortint SQL_GD_BLOCK = 0x4;
static const Shortint SQL_GD_BOUND = 0x8;
static const Shortint SQL_PS_POSITIONED_DELETE = 0x1;
static const Shortint SQL_PS_POSITIONED_UPDATE = 0x2;
static const Shortint SQL_PS_SELECT_FOR_UPDATE = 0x4;
static const Shortint SQL_GB_NOT_SUPPORTED = 0x0;
static const Shortint SQL_GB_GROUP_BY_EQUALS_SELECT = 0x1;
static const Shortint SQL_GB_GROUP_BY_CONTAINS_SELECT = 0x2;
static const Shortint SQL_GB_NO_RELATION = 0x3;
static const Shortint SQL_GB_COLLATE = 0x4;
static const Shortint SQL_OU_DML_STATEMENTS = 0x1;
static const Shortint SQL_OU_PROCEDURE_INVOCATION = 0x2;
static const Shortint SQL_OU_TABLE_DEFINITION = 0x4;
static const Shortint SQL_OU_INDEX_DEFINITION = 0x8;
static const Shortint SQL_OU_PRIVILEGE_DEFINITION = 0x10;
static const Shortint SQL_SU_DML_STATEMENTS = 0x1;
static const Shortint SQL_SU_PROCEDURE_INVOCATION = 0x2;
static const Shortint SQL_SU_TABLE_DEFINITION = 0x4;
static const Shortint SQL_SU_INDEX_DEFINITION = 0x8;
static const Shortint SQL_SU_PRIVILEGE_DEFINITION = 0x10;
static const Shortint SQL_QU_DML_STATEMENTS = 0x1;
static const Shortint SQL_QU_PROCEDURE_INVOCATION = 0x2;
static const Shortint SQL_QU_TABLE_DEFINITION = 0x4;
static const Shortint SQL_QU_INDEX_DEFINITION = 0x8;
static const Shortint SQL_QU_PRIVILEGE_DEFINITION = 0x10;
static const Shortint SQL_CU_DML_STATEMENTS = 0x1;
static const Shortint SQL_CU_PROCEDURE_INVOCATION = 0x2;
static const Shortint SQL_CU_TABLE_DEFINITION = 0x4;
static const Shortint SQL_CU_INDEX_DEFINITION = 0x8;
static const Shortint SQL_CU_PRIVILEGE_DEFINITION = 0x10;
static const Shortint SQL_SQ_COMPARISON = 0x1;
static const Shortint SQL_SQ_EXISTS = 0x2;
static const Shortint SQL_SQ_IN = 0x4;
static const Shortint SQL_SQ_QUANTIFIED = 0x8;
static const Shortint SQL_SQ_CORRELATED_SUBQUERIES = 0x10;
static const Shortint SQL_U_UNION = 0x1;
static const Shortint SQL_U_UNION_ALL = 0x2;
static const Shortint SQL_BP_CLOSE = 0x1;
static const Shortint SQL_BP_DELETE = 0x2;
static const Shortint SQL_BP_DROP = 0x4;
static const Shortint SQL_BP_TRANSACTION = 0x8;
static const Shortint SQL_BP_UPDATE = 0x10;
static const Shortint SQL_BP_OTHER_HSTMT = 0x20;
static const Shortint SQL_BP_SCROLL = 0x40;
static const Shortint SQL_SS_ADDITIONS = 0x1;
static const Shortint SQL_SS_DELETIONS = 0x2;
static const Shortint SQL_SS_UPDATES = 0x4;
static const Shortint SQL_CV_CREATE_VIEW = 0x1;
static const Shortint SQL_CV_CHECK_OPTION = 0x2;
static const Shortint SQL_CV_CASCADED = 0x4;
static const Shortint SQL_CV_LOCAL = 0x8;
static const Shortint SQL_LCK_NO_CHANGE = 0x1;
static const Shortint SQL_LCK_EXCLUSIVE = 0x2;
static const Shortint SQL_LCK_UNLOCK = 0x4;
static const Shortint SQL_POS_POSITION = 0x1;
static const Shortint SQL_POS_REFRESH = 0x2;
static const Shortint SQL_POS_UPDATE = 0x4;
static const Shortint SQL_POS_DELETE = 0x8;
static const Shortint SQL_POS_ADD = 0x10;
static const Shortint SQL_QL_START = 0x1;
static const Shortint SQL_QL_END = 0x2;
static const Shortint SQL_AF_AVG = 0x1;
static const Shortint SQL_AF_COUNT = 0x2;
static const Shortint SQL_AF_MAX = 0x4;
static const Shortint SQL_AF_MIN = 0x8;
static const Shortint SQL_AF_SUM = 0x10;
static const Shortint SQL_AF_DISTINCT = 0x20;
static const Shortint SQL_AF_ALL = 0x40;
static const Shortint SQL_SC_SQL92_ENTRY = 0x1;
static const Shortint SQL_SC_FIPS127_2_TRANSITIONAL = 0x2;
static const Shortint SQL_SC_SQL92_INTERMEDIATE = 0x4;
static const Shortint SQL_SC_SQL92_FULL = 0x8;
static const Shortint SQL_DL_SQL92_DATE = 0x1;
static const Shortint SQL_DL_SQL92_TIME = 0x2;
static const Shortint SQL_DL_SQL92_TIMESTAMP = 0x4;
static const Shortint SQL_DL_SQL92_INTERVAL_YEAR = 0x8;
static const Shortint SQL_DL_SQL92_INTERVAL_MONTH = 0x10;
static const Shortint SQL_DL_SQL92_INTERVAL_DAY = 0x20;
static const Shortint SQL_DL_SQL92_INTERVAL_HOUR = 0x40;
static const Byte SQL_DL_SQL92_INTERVAL_MINUTE = 0x80;
static const Word SQL_DL_SQL92_INTERVAL_SECOND = 0x100;
static const Word SQL_DL_SQL92_INTERVAL_YEAR_TO_MONTH = 0x200;
static const Word SQL_DL_SQL92_INTERVAL_DAY_TO_HOUR = 0x400;
static const Word SQL_DL_SQL92_INTERVAL_DAY_TO_MINUTE = 0x800;
static const Word SQL_DL_SQL92_INTERVAL_DAY_TO_SECOND = 0x1000;
static const Word SQL_DL_SQL92_INTERVAL_HOUR_TO_MINUTE = 0x2000;
static const Word SQL_DL_SQL92_INTERVAL_HOUR_TO_SECOND = 0x4000;
static const Word SQL_DL_SQL92_INTERVAL_MINUTE_TO_SECOND = 0x8000;
static const Shortint SQL_CL_START = 0x1;
static const Shortint SQL_CL_END = 0x2;
static const Shortint SQL_BRC_PROCEDURES = 0x1;
static const Shortint SQL_BRC_EXPLICIT = 0x2;
static const Shortint SQL_BRC_ROLLED_UP = 0x4;
static const Shortint SQL_BS_SELECT_EXPLICIT = 0x1;
static const Shortint SQL_BS_ROW_COUNT_EXPLICIT = 0x2;
static const Shortint SQL_BS_SELECT_PROC = 0x4;
static const Shortint SQL_BS_ROW_COUNT_PROC = 0x8;
static const Shortint SQL_PARC_BATCH = 0x1;
static const Shortint SQL_PARC_NO_BATCH = 0x2;
static const Shortint SQL_PAS_BATCH = 0x1;
static const Shortint SQL_PAS_NO_BATCH = 0x2;
static const Shortint SQL_PAS_NO_SELECT = 0x3;
static const Shortint SQL_IK_NONE = 0x0;
static const Shortint SQL_IK_ASC = 0x1;
static const Shortint SQL_IK_DESC = 0x2;
static const Shortint SQL_IK_ALL = 0x3;
static const Shortint SQL_ISV_ASSERTIONS = 0x1;
static const Shortint SQL_ISV_CHARACTER_SETS = 0x2;
static const Shortint SQL_ISV_CHECK_CONSTRAINTS = 0x4;
static const Shortint SQL_ISV_COLLATIONS = 0x8;
static const Shortint SQL_ISV_COLUMN_DOMAIN_USAGE = 0x10;
static const Shortint SQL_ISV_COLUMN_PRIVILEGES = 0x20;
static const Shortint SQL_ISV_COLUMNS = 0x40;
static const Byte SQL_ISV_CONSTRAINT_COLUMN_USAGE = 0x80;
static const Word SQL_ISV_CONSTRAINT_TABLE_USAGE = 0x100;
static const Word SQL_ISV_DOMAIN_CONSTRAINTS = 0x200;
static const Word SQL_ISV_DOMAINS = 0x400;
static const Word SQL_ISV_KEY_COLUMN_USAGE = 0x800;
static const Word SQL_ISV_REFERENTIAL_CONSTRAINTS = 0x1000;
static const Word SQL_ISV_SCHEMATA = 0x2000;
static const Word SQL_ISV_SQL_LANGUAGES = 0x4000;
static const Word SQL_ISV_TABLE_CONSTRAINTS = 0x8000;
static const int SQL_ISV_TABLE_PRIVILEGES = 0x10000;
static const int SQL_ISV_TABLES = 0x20000;
static const int SQL_ISV_TRANSLATIONS = 0x40000;
static const int SQL_ISV_USAGE_PRIVILEGES = 0x80000;
static const int SQL_ISV_VIEW_COLUMN_USAGE = 0x100000;
static const int SQL_ISV_VIEW_TABLE_USAGE = 0x200000;
static const int SQL_ISV_VIEWS = 0x400000;
static const Shortint SQL_AD_CONSTRAINT_NAME_DEFINITION = 0x1;
static const Shortint SQL_AD_ADD_DOMAIN_CONSTRAINT = 0x2;
static const Shortint SQL_AD_DROP_DOMAIN_CONSTRAINT = 0x4;
static const Shortint SQL_AD_ADD_DOMAIN_DEFAULT = 0x8;
static const Shortint SQL_AD_DROP_DOMAIN_DEFAULT = 0x10;
static const Shortint SQL_AD_ADD_CONSTRAINT_INITIALLY_DEFERRED = 0x20;
static const Shortint SQL_AD_ADD_CONSTRAINT_INITIALLY_IMMEDIATE = 0x40;
static const Byte SQL_AD_ADD_CONSTRAINT_DEFERRABLE = 0x80;
static const Word SQL_AD_ADD_CONSTRAINT_NON_DEFERRABLE = 0x100;
static const Shortint SQL_CS_CREATE_SCHEMA = 0x1;
static const Shortint SQL_CS_AUTHORIZATION = 0x2;
static const Shortint SQL_CS_DEFAULT_CHARACTER_SET = 0x4;
static const Shortint SQL_CTR_CREATE_TRANSLATION = 0x1;
static const Shortint SQL_CA_CREATE_ASSERTION = 0x1;
static const Shortint SQL_CA_CONSTRAINT_INITIALLY_DEFERRED = 0x10;
static const Shortint SQL_CA_CONSTRAINT_INITIALLY_IMMEDIATE = 0x20;
static const Shortint SQL_CA_CONSTRAINT_DEFERRABLE = 0x40;
static const Byte SQL_CA_CONSTRAINT_NON_DEFERRABLE = 0x80;
static const Shortint SQL_CCS_CREATE_CHARACTER_SET = 0x1;
static const Shortint SQL_CCS_COLLATE_CLAUSE = 0x2;
static const Shortint SQL_CCS_LIMITED_COLLATION = 0x4;
static const Shortint SQL_CCOL_CREATE_COLLATION = 0x1;
static const Shortint SQL_CDO_CREATE_DOMAIN = 0x1;
static const Shortint SQL_CDO_DEFAULT = 0x2;
static const Shortint SQL_CDO_CONSTRAINT = 0x4;
static const Shortint SQL_CDO_COLLATION = 0x8;
static const Shortint SQL_CDO_CONSTRAINT_NAME_DEFINITION = 0x10;
static const Shortint SQL_CDO_CONSTRAINT_INITIALLY_DEFERRED = 0x20;
static const Shortint SQL_CDO_CONSTRAINT_INITIALLY_IMMEDIATE = 0x40;
static const Byte SQL_CDO_CONSTRAINT_DEFERRABLE = 0x80;
static const Word SQL_CDO_CONSTRAINT_NON_DEFERRABLE = 0x100;
static const Shortint SQL_CT_CREATE_TABLE = 0x1;
static const Shortint SQL_CT_COMMIT_PRESERVE = 0x2;
static const Shortint SQL_CT_COMMIT_DELETE = 0x4;
static const Shortint SQL_CT_GLOBAL_TEMPORARY = 0x8;
static const Shortint SQL_CT_LOCAL_TEMPORARY = 0x10;
static const Shortint SQL_CT_CONSTRAINT_INITIALLY_DEFERRED = 0x20;
static const Shortint SQL_CT_CONSTRAINT_INITIALLY_IMMEDIATE = 0x40;
static const Byte SQL_CT_CONSTRAINT_DEFERRABLE = 0x80;
static const Word SQL_CT_CONSTRAINT_NON_DEFERRABLE = 0x100;
static const Word SQL_CT_COLUMN_CONSTRAINT = 0x200;
static const Word SQL_CT_COLUMN_DEFAULT = 0x400;
static const Word SQL_CT_COLUMN_COLLATION = 0x800;
static const Word SQL_CT_TABLE_CONSTRAINT = 0x1000;
static const Word SQL_CT_CONSTRAINT_NAME_DEFINITION = 0x2000;
static const Shortint SQL_DI_CREATE_INDEX = 0x1;
static const Shortint SQL_DI_DROP_INDEX = 0x2;
static const Shortint SQL_DC_DROP_COLLATION = 0x1;
static const Shortint SQL_DD_DROP_DOMAIN = 0x1;
static const Shortint SQL_DD_RESTRICT = 0x2;
static const Shortint SQL_DD_CASCADE = 0x4;
static const Shortint SQL_DS_DROP_SCHEMA = 0x1;
static const Shortint SQL_DS_RESTRICT = 0x2;
static const Shortint SQL_DS_CASCADE = 0x4;
static const Shortint SQL_DCS_DROP_CHARACTER_SET = 0x1;
static const Shortint SQL_DA_DROP_ASSERTION = 0x1;
static const Shortint SQL_DT_DROP_TABLE = 0x1;
static const Shortint SQL_DT_RESTRICT = 0x2;
static const Shortint SQL_DT_CASCADE = 0x4;
static const Shortint SQL_DTR_DROP_TRANSLATION = 0x1;
static const Shortint SQL_DV_DROP_VIEW = 0x1;
static const Shortint SQL_DV_RESTRICT = 0x2;
static const Shortint SQL_DV_CASCADE = 0x4;
static const Shortint SQL_IS_INSERT_LITERALS = 0x1;
static const Shortint SQL_IS_INSERT_SEARCHED = 0x2;
static const Shortint SQL_IS_SELECT_INTO = 0x4;
static const int SQL_OIC_CORE = 0x1;
static const int SQL_OIC_LEVEL1 = 0x2;
static const int SQL_OIC_LEVEL2 = 0x3;
static const Shortint SQL_SFKD_CASCADE = 0x1;
static const Shortint SQL_SFKD_NO_ACTION = 0x2;
static const Shortint SQL_SFKD_SET_DEFAULT = 0x4;
static const Shortint SQL_SFKD_SET_NULL = 0x8;
static const Shortint SQL_SFKU_CASCADE = 0x1;
static const Shortint SQL_SFKU_NO_ACTION = 0x2;
static const Shortint SQL_SFKU_SET_DEFAULT = 0x4;
static const Shortint SQL_SFKU_SET_NULL = 0x8;
static const Shortint SQL_SG_USAGE_ON_DOMAIN = 0x1;
static const Shortint SQL_SG_USAGE_ON_CHARACTER_SET = 0x2;
static const Shortint SQL_SG_USAGE_ON_COLLATION = 0x4;
static const Shortint SQL_SG_USAGE_ON_TRANSLATION = 0x8;
static const Shortint SQL_SG_WITH_GRANT_OPTION = 0x10;
static const Shortint SQL_SG_DELETE_TABLE = 0x20;
static const Shortint SQL_SG_INSERT_TABLE = 0x40;
static const Byte SQL_SG_INSERT_COLUMN = 0x80;
static const Word SQL_SG_REFERENCES_TABLE = 0x100;
static const Word SQL_SG_REFERENCES_COLUMN = 0x200;
static const Word SQL_SG_SELECT_TABLE = 0x400;
static const Word SQL_SG_UPDATE_TABLE = 0x800;
static const Word SQL_SG_UPDATE_COLUMN = 0x1000;
static const Shortint SQL_SP_EXISTS = 0x1;
static const Shortint SQL_SP_ISNOTNULL = 0x2;
static const Shortint SQL_SP_ISNULL = 0x4;
static const Shortint SQL_SP_MATCH_FULL = 0x8;
static const Shortint SQL_SP_MATCH_PARTIAL = 0x10;
static const Shortint SQL_SP_MATCH_UNIQUE_FULL = 0x20;
static const Shortint SQL_SP_MATCH_UNIQUE_PARTIAL = 0x40;
static const Byte SQL_SP_OVERLAPS = 0x80;
static const Word SQL_SP_UNIQUE = 0x100;
static const Word SQL_SP_LIKE = 0x200;
static const Word SQL_SP_IN = 0x400;
static const Word SQL_SP_BETWEEN = 0x800;
static const Word SQL_SP_COMPARISON = 0x1000;
static const Word SQL_SP_QUANTIFIED_COMPARISON = 0x2000;
static const Shortint SQL_SRJO_CORRESPONDING_CLAUSE = 0x1;
static const Shortint SQL_SRJO_CROSS_JOIN = 0x2;
static const Shortint SQL_SRJO_EXCEPT_JOIN = 0x4;
static const Shortint SQL_SRJO_FULL_OUTER_JOIN = 0x8;
static const Shortint SQL_SRJO_INNER_JOIN = 0x10;
static const Shortint SQL_SRJO_INTERSECT_JOIN = 0x20;
static const Shortint SQL_SRJO_LEFT_OUTER_JOIN = 0x40;
static const Byte SQL_SRJO_NATURAL_JOIN = 0x80;
static const Word SQL_SRJO_RIGHT_OUTER_JOIN = 0x100;
static const Word SQL_SRJO_UNION_JOIN = 0x200;
static const Shortint SQL_SR_USAGE_ON_DOMAIN = 0x1;
static const Shortint SQL_SR_USAGE_ON_CHARACTER_SET = 0x2;
static const Shortint SQL_SR_USAGE_ON_COLLATION = 0x4;
static const Shortint SQL_SR_USAGE_ON_TRANSLATION = 0x8;
static const Shortint SQL_SR_GRANT_OPTION_FOR = 0x10;
static const Shortint SQL_SR_CASCADE = 0x20;
static const Shortint SQL_SR_RESTRICT = 0x40;
static const Byte SQL_SR_DELETE_TABLE = 0x80;
static const Word SQL_SR_INSERT_TABLE = 0x100;
static const Word SQL_SR_INSERT_COLUMN = 0x200;
static const Word SQL_SR_REFERENCES_TABLE = 0x400;
static const Word SQL_SR_REFERENCES_COLUMN = 0x800;
static const Word SQL_SR_SELECT_TABLE = 0x1000;
static const Word SQL_SR_UPDATE_TABLE = 0x2000;
static const Word SQL_SR_UPDATE_COLUMN = 0x4000;
static const Shortint SQL_SRVC_VALUE_EXPRESSION = 0x1;
static const Shortint SQL_SRVC_NULL = 0x2;
static const Shortint SQL_SRVC_DEFAULT = 0x4;
static const Shortint SQL_SRVC_ROW_SUBQUERY = 0x8;
static const Shortint SQL_SVE_CASE = 0x1;
static const Shortint SQL_SVE_CAST = 0x2;
static const Shortint SQL_SVE_COALESCE = 0x4;
static const Shortint SQL_SVE_NULLIF = 0x8;
static const Shortint SQL_SCC_XOPEN_CLI_VERSION1 = 0x1;
static const Shortint SQL_SCC_ISO92_CLI = 0x2;
static const Shortint SQL_US_UNION = 0x1;
static const Shortint SQL_US_UNION_ALL = 0x2;
static const Shortint SQL_DTC_ENLIST_EXPENSIVE = 0x1;
static const Shortint SQL_DTC_UNENLIST_EXPENSIVE = 0x2;
static const Shortint SQL_FETCH_FIRST_USER = 0x1f;
static const Shortint SQL_FETCH_FIRST_SYSTEM = 0x20;
static const Shortint SQL_ENTIRE_ROWSET = 0x0;
static const Shortint SQL_POSITION = 0x0;
static const Shortint SQL_REFRESH = 0x1;
static const Shortint SQL_UPDATE = 0x2;
static const Shortint SQL_DELETE = 0x3;
static const Shortint SQL_ADD = 0x4;
static const Shortint SQL_SETPOS_MAX_OPTION_VALUE = 0x4;
static const Shortint SQL_UPDATE_BY_BOOKMARK = 0x5;
static const Shortint SQL_DELETE_BY_BOOKMARK = 0x6;
static const Shortint SQL_FETCH_BY_BOOKMARK = 0x7;
static const Shortint SQL_LOCK_NO_CHANGE = 0x0;
static const Shortint SQL_LOCK_EXCLUSIVE = 0x1;
static const Shortint SQL_LOCK_UNLOCK = 0x2;
static const Shortint SQL_SETPOS_MAX_LOCK_VALUE = 0x2;
static const Shortint SQL_BEST_ROWID = 0x1;
static const Shortint SQL_ROWVER = 0x2;
static const Shortint SQL_PC_NOT_PSEUDO = 0x1;
static const Shortint SQL_QUICK = 0x0;
static const Shortint SQL_ENSURE = 0x1;
static const Shortint SQL_TABLE_STAT = 0x0;
static const char SQL_ALL_CATALOGS = '\x25';
static const char SQL_ALL_SCHEMAS = '\x25';
static const char SQL_ALL_TABLE_TYPES = '\x25';
static const Shortint SQL_DRIVER_NOPROMPT = 0x0;
static const Shortint SQL_DRIVER_COMPLETE = 0x1;
static const Shortint SQL_DRIVER_PROMPT = 0x2;
static const Shortint SQL_DRIVER_COMPLETE_REQUIRED = 0x3;
static const Shortint SQL_FETCH_BOOKMARK = 0x8;
static const Shortint SQL_ROW_SUCCESS = 0x0;
static const Shortint SQL_ROW_DELETED = 0x1;
static const Shortint SQL_ROW_UPDATED = 0x2;
static const Shortint SQL_ROW_NOROW = 0x3;
static const Shortint SQL_ROW_ADDED = 0x4;
static const Shortint SQL_ROW_ERROR = 0x5;
static const Shortint SQL_ROW_SUCCESS_WITH_INFO = 0x6;
static const Shortint SQL_ROW_PROCEED = 0x0;
static const Shortint SQL_ROW_IGNORE = 0x1;
static const Shortint SQL_PARAM_SUCCESS = 0x0;
static const Shortint SQL_PARAM_SUCCESS_WITH_INFO = 0x6;
static const Shortint SQL_PARAM_ERROR = 0x5;
static const Shortint SQL_PARAM_UNUSED = 0x7;
static const Shortint SQL_PARAM_DIAG_UNAVAILABLE = 0x1;
static const Shortint SQL_PARAM_PROCEED = 0x0;
static const Shortint SQL_PARAM_IGNORE = 0x1;
static const Shortint SQL_CASCADE = 0x0;
static const Shortint SQL_RESTRICT = 0x1;
static const Shortint SQL_SET_NULL = 0x2;
static const Shortint SQL_NO_ACTION = 0x3;
static const Shortint SQL_SET_DEFAULT = 0x4;
static const Shortint SQL_INITIALLY_DEFERRED = 0x5;
static const Shortint SQL_INITIALLY_IMMEDIATE = 0x6;
static const Shortint SQL_NOT_DEFERRABLE = 0x7;
static const Shortint SQL_PT_UNKNOWN = 0x0;
static const Shortint SQL_PT_PROCEDURE = 0x1;
static const Shortint SQL_PT_FUNCTION = 0x2;
#define SQL_ODBC_KEYWORDS "ABSOLUTE,ACTION,ADA,ADD,ALL,ALLOCATE,ALTER,AND,ANY,ARE,AS,"\
	"ASC,ASSERTION,AT,AUTHORIZATION,AVG,BEGIN,BETWEEN,BIT,BIT_L"\
	"ENGTH,BOTH,BY,CASCADE,CASCADED,CASE,CAST,CATALOG,CHAR,CHAR"\
	"_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE,CO"\
	"LLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAIN"\
	"T,CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,"\
	"CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,"\
	"CURRENT_USER,CURSOR,DATE,DAY,DEALLOCATE,DEC,DECIMAL,DECLAR"\
	"E,DEFAULT,DEFERRABLE,DEFERRED,DELETE,DESC,DESCRIBE,DESCRIP"\
	"TOR,DIAGNOSTICS,DISCONNECT,DISTINCT,DOMAIN,DOUBLE,DROP,ELS"\
	"E,END,END-EXEC,ESCAPE,EXCEPT,EXCEPTION,EXEC,EXECUTE,EXISTS"\
	",EXTERNAL,EXTRACT,FALSE,FETCH,FIRST,FLOAT,FOR,FOREIGN,FORT"\
	"RAN,FOUND,FROM,FULL,GET,GLOBAL,GO,GOTO,GRANT,GROUP,HAVING,"\
	"HOUR,IDENTITY,IMMEDIATE,IN,INCLUDE,INDEX,INDICATOR,INITIAL"\
	"LY,INNER,INPUT,INSENSITIVE,INSERT,INT,INTEGER,INTERSECT,IN"\
	"TERVAL,INTO,IS,ISOLATION,JOIN,KEY,LANGUAGE,LAST,LEADING,LE"\
	"FT,LEVEL,LIKE,LOCAL,LOWER,MATCH,MAX,MIN,MINUTE,MODULE,MONT"\
	"H,NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,NOT,NULL,NULLI"\
	"F,NUMERIC,OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,ORDER,OUT"\
	"ER,OUTPUT,OVERLAPS,PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISI"\
	"ON,PREPARE,PRESERVE,PRIMARY,PRIOR,PRIVILEGES,PROCEDURE,PUB"\
	"LIC,READ,REAL,REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,RO"\
	"LLBACK,ROWSSCHEMA,SCROLL,SECOND,SECTION,SELECT,SESSION,SES"\
	"SION_USER,SET,SIZE,SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,S"\
	"QLERROR,SQLSTATE,SQLWARNING,SUBSTRING,SUM,SYSTEM_USER,TABL"\
	"E,TEMPORARY,THEN,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MIN"\
	"UTE,TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRU"\
	"E,UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING,VALUE"\
	",VALUES,VARCHAR,VARYING,VIEW,WHEN,WHENEVER,WHERE,WITH,WORK"\
	",WRITE,YEAR,ZONE"
static const Shortint SQL_YEAR = 0x1;
static const Shortint SQL_MONTH = 0x2;
static const Shortint SQL_DAY = 0x3;
static const Shortint SQL_HOUR = 0x4;
static const Shortint SQL_MINUTE = 0x5;
static const Shortint SQL_SECOND = 0x6;
static const Shortint SQL_YEAR_TO_MONTH = 0x7;
static const Shortint SQL_DAY_TO_HOUR = 0x8;
static const Shortint SQL_DAY_TO_MINUTE = 0x9;
static const Shortint SQL_DAY_TO_SECOND = 0xa;
static const Shortint SQL_HOUR_TO_MINUTE = 0xb;
static const Shortint SQL_HOUR_TO_SECOND = 0xc;
static const Shortint SQL_MINUTE_TO_SECOND = 0xd;
static const Shortint SQL_DATABASE_NAME = 0x10;
static const Shortint SQL_FD_FETCH_PREV = 0x8;
static const Shortint SQL_FETCH_PREV = 0x4;
static const Shortint SQL_CONCUR_TIMESTAMP = 0x3;
static const Shortint SQL_SCCO_OPT_TIMESTAMP = 0x4;
static const Shortint SQL_CC_DELETE = 0x0;
static const Shortint SQL_CR_DELETE = 0x0;
static const Shortint SQL_CC_CLOSE = 0x1;
static const Shortint SQL_CR_CLOSE = 0x1;
static const Shortint SQL_CC_PRESERVE = 0x2;
static const Shortint SQL_CR_PRESERVE = 0x2;
static const Shortint SQL_FETCH_RESUME = 0x7;
static const Shortint SQL_SCROLL_FORWARD_ONLY = 0x0;
static const Shortint SQL_SCROLL_KEYSET_DRIVEN = 0xffffffff;
static const Shortint SQL_SCROLL_DYNAMIC = 0xfffffffe;
static const Shortint SQL_SCROLL_STATIC = 0xfffffffd;
static const Word TRACE_VERSION = 0x3e8;
static const Shortint TRACE_ON = 0x1;
static const Shortint TRACE_VS_EVENT_ON = 0x2;
static const Shortint ODBC_VS_FLAG_UNICODE_ARG = 0x1;
static const Shortint ODBC_VS_FLAG_UNICODE_COR = 0x2;
static const Shortint ODBC_VS_FLAG_RETCODE = 0x4;
static const Shortint ODBC_VS_FLAG_STOP = 0x8;
static const Shortint OdbcApi_NotImplemented_OdbcName = 0x0;
static const Shortint OdbcApi_NotImplemented_OdbcTrac = 0x1;
static const Shortint OdbcApi_NotImplemented_OdbcInst = 0x2;
static const short SQL_MSSQL_VARIANT = 0xffffff6a;
static const short SQL_MSSQL_XML = 0xffffff68;
static const Word SQL_IBMDB2_LONGDATA_COMPAT = 0x4e5;
static const Shortint SQL_IBMDB2_LD_COMPAT_NO = 0x0;
static const Shortint SQL_IBMDB2_LD_COMPAT_YES = 0x1;
static const short SQL_ORA_CURSOR_REF = 0xfffffe6d;
static const short SQL_ORA_CURSOR = 0xfffffe6c;
static const Shortint SQL_INFX_ADIAG_ISAM_ERROR = 0xd;
static const Shortint SQL_INFX_ADIAG_XA_ERROR = 0xe;
static const Word SQL_INFX_STMTOPT_START = 0x410;
static const Word SQL_INFX_GET_ROWID = 0x418;
static const Word SQL_INFX_GET_SERIAL_VALUE = 0x419;
static const Shortint INFX_FDNULLABLE = 0x1;
static const Shortint INFX_FDDISTINCT = 0x2;
static const Shortint INFX_FDDISTLVARCHAR = 0x4;
static const Shortint INFX_FDDISTBOOLEAN = 0x8;
static const Shortint INFX_FDDISTSIMP = 0x10;
static const Shortint INFX_FDCSTTYPE = 0x20;
static const Shortint INFX_FDNAMED = 0x40;
static const Shortint SQL_INFX_UDT_FIXED = 0xffffff9c;
static const Shortint SQL_INFX_UDT_VARYING = 0xffffff9b;
static const Shortint SQL_INFX_UDT_BLOB = 0xffffff9a;
static const Shortint SQL_INFX_UDT_CLOB = 0xffffff99;
static const Shortint SQL_INFX_UDT_LVARCHAR = 0xffffff98;
static const Shortint SQL_INFX_RC_ROW = 0xffffff97;
static const Shortint SQL_INFX_RC_COLLECTION = 0xffffff96;
static const Shortint SQL_INFX_RC_LIST = 0xffffff95;
static const Shortint SQL_INFX_RC_SET = 0xffffff94;
static const Shortint SQL_INFX_RC_MULTISET = 0xffffff93;
static const Shortint SQL_INFX_UNSUPPORTED = 0xffffff92;
static const Word SQL_INFX_OPT_LONGID = 0x8cb;
static const Word SQL_INFX_ATTR_LONGID = 0x8cb;
static const Word SQL_INFX_ATTR_LEAVE_TRAILING_SPACES = 0x8cc;
static const Word SQL_INFX_ATTR_DEFAULT_UDT_FETCH_TYPE = 0x8cd;
static const Word SQL_INFX_ATTR_ENABLE_SCROLL_CURSORS = 0x8ce;
static const Word SQL_INFX_ATTR_ENABLE_INSERT_CURSORS = 0x8cf;
static const Word SQL_INFX_ATTR_OPTIMIZE_AUTOCOMMIT = 0x8d0;
static const Word SQL_INFX_ATTR_ODBC_TYPES_ONLY = 0x8d1;
static const Word SQL_INFX_ATTR_FETCH_BUFFER_SIZE = 0x8d2;
static const Word SQL_INFX_ATTR_OPTOFC = 0x8d3;
static const Word SQL_INFX_ATTR_OPTMSG = 0x8d4;
static const Word SQL_INFX_ATTR_REPORT_KEYSET_CURSORS = 0x8d5;
static const Word SQL_INFX_ATTR_LO_AUTOMATIC = 0x8d6;
static const Word SQL_INFX_ATTR_AUTO_FREE = 0x8d7;
static const Word SQL_INFX_ATTR_DEFERRED_PREPARE = 0x8d9;
static const Word SQL_INFX_ATTR_FLAGS = 0x76c;
static const Word SQL_INFX_ATTR_EXTENDED_TYPE_CODE = 0x76d;
static const Word SQL_INFX_ATTR_EXTENDED_TYPE_NAME = 0x76e;
static const Word SQL_INFX_ATTR_EXTENDED_TYPE_OWNER = 0x76f;
static const Word SQL_INFX_ATTR_EXTENDED_TYPE_ALIGNMENT = 0x770;
static const Word SQL_INFX_ATTR_SOURCE_TYPE_CODE = 0x771;
static const Word SQL_INFX_VMB_CHAR_LEN = 0x915;
static const Word SQL_INFX_ATTR_VMB_CHAR_LEN = 0x915;
static const Word SQL_INFX_ATTR_MAX_FET_ARR_SIZE = 0x916;
static const Shortint SQL_INFX_VMB_CHAR_EXACT = 0x0;
static const Shortint SQL_INFX_VMB_CHAR_ESTIMATE = 0x1;
static const Shortint SQL_INFX_RC_NEXT = 0x1;
static const Shortint SQL_INFX_RC_PRIOR = 0x2;
static const Shortint SQL_INFX_RC_FIRST = 0x3;
static const Shortint SQL_INFX_RC_LAST = 0x4;
static const Shortint SQL_INFX_RC_ABSOLUTE = 0x5;
static const Shortint SQL_INFX_RC_RELATIVE = 0x6;
static const Shortint SQL_INFX_RC_CURRENT = 0x7;
static const Word SQL_INFX_LO_SPEC_LENGTH = 0x8ca;
static const Word SQL_INFX_LO_PTR_LENGTH = 0x8cb;
static const Word SQL_INFX_LO_STAT_LENGTH = 0x8cc;
static const Shortint INFX_LO_APPEND = 0x1;
static const Shortint INFX_LO_WRONLY = 0x2;
static const Shortint INFX_LO_RDONLY = 0x4;
static const Shortint INFX_LO_RDWR = 0x8;
static const Shortint INFX_LO_RANDOM = 0x20;
static const Shortint INFX_LO_SEQUENTIAL = 0x40;
static const Byte INFX_LO_FORWARD = 0x80;
static const Word INFX_LO_REVERSE = 0x100;
static const Word INFX_LO_BUFFER = 0x200;
static const Word INFX_LO_NOBUFFER = 0x400;
static const Shortint INFX_LO_DIRTY_READ = 0x10;
static const Word INFX_LO_NODIRTY_READ = 0x800;
static const Shortint INFX_LO_ATTR_LOG = 0x1;
static const Shortint INFX_LO_ATTR_NOLOG = 0x2;
static const Shortint INFX_LO_ATTR_DELAY_LOG = 0x4;
static const Shortint INFX_LO_ATTR_KEEP_LASTACCESS_TIME = 0x8;
static const Shortint INFX_LO_ATTR_NOKEEP_LASTACCESS_TIME = 0x10;
static const Shortint INFX_LO_ATTR_HIGH_INTEG = 0x20;
static const Shortint INFX_LO_ATTR_MODERATE_INTEG = 0x40;
static const Shortint INFX_LO_SEEK_SET = 0x0;
static const Shortint INFX_LO_SEEK_CUR = 0x1;
static const Shortint INFX_LO_SEEK_END = 0x2;
static const Word SQL_INFX_RESERVED_WORDS = 0x3f3;
static const Word SQL_INFX_PSEUDO_COLUMNS = 0x2b04;
static const Word SQL_INFX_FROM_RESERVED_WORDS = 0x2b05;
static const Word SQL_INFX_WHERE_CLAUSE_TERMINATORS = 0x2b06;
static const Word SQL_INFX_COLUMN_FIRST_CHARS = 0x2b07;
static const Word SQL_INFX_COLUMN_MIDDLE_CHARS = 0x2b08;
static const Word SQL_INFX_TABLE_FIRST_CHARS = 0x2b0a;
static const Word SQL_INFX_TABLE_MIDDLE_CHARS = 0x2b0b;
static const Word SQL_INFX_FAST_SPECIAL_COLUMNS = 0x2b0d;
static const Word SQL_INFX_ACCESS_CONFLICTS = 0x2b0e;
static const Word SQL_INFX_LOCKING_SYNTAX = 0x2b0f;
static const Word SQL_INFX_LOCKING_DURATION = 0x2b10;
static const Word SQL_INFX_RECORD_OPERATIONS = 0x2b11;
static const Word SQL_INFX_QUALIFIER_SYNTAX = 0x2b12;
extern PACKAGE AnsiString sysodbclib;
extern PACKAGE bool __fastcall SQL_SUCCEEDED(const short rc);
extern PACKAGE TOdbcApiProxy* __fastcall LoadOdbcDriverManager(char * LibraryName, bool UnicodePriority = false);
extern PACKAGE void __fastcall UnLoadOdbcDriverManager(TOdbcApiProxy* OdbcApi);

}	/* namespace Odbcapi */
using namespace Odbcapi;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OdbcApi
