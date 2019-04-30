// Borland C++ Builder
// Copyright (c) 1995, 2004 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbc3.pas' rev: 6.00

#ifndef Dbxopenodbc3HPP
#define Dbxopenodbc3HPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Dbxopenodbc.hpp>	// Pascal unit
#include <Dbxopenodbccallback.hpp>	// Pascal unit
#include <Dbxopenodbcutils.hpp>	// Pascal unit
#include <Dbxopenodbcfuncs.hpp>	// Pascal unit
#include <Dbxopenodbcdbx3types.hpp>	// Pascal unit
#include <Odbcapi.hpp>	// Pascal unit
#include <Dbxopenodbcinterface.hpp>	// Pascal unit
#include <Dbxopenodbctypes.hpp>	// Pascal unit
#include <Fmtbcd.hpp>	// Pascal unit
#include <Dsintf.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbc3
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSqlDriverOdbc3;
class PASCALIMPLEMENTATION TSqlDriverOdbc3 : public Dbxopenodbc::TSqlDriverOdbc 
{
	typedef Dbxopenodbc::TSqlDriverOdbc inherited;
	
protected:
	HIDESBASE int __stdcall getSQLConnection(/* out */ Dbxopenodbcdbx3types::_di_ISQLConnection &pConn);
	
public:
	__fastcall virtual TSqlDriverOdbc3(Odbcapi::TOdbcApiProxy* AOdbcApi, bool bIsUnicodeOdbcApi);
public:
	#pragma option push -w-inl
	/* TSqlDriverOdbc.Destroy */ inline __fastcall virtual ~TSqlDriverOdbc3(void) { }
	#pragma option pop
	
private:
	void *__ISQLDriver;	/* Dbxopenodbcdbx3types::ISQLDriver */
	
public:
	operator ISQLDriver*(void) { return (ISQLDriver*)&__ISQLDriver; }
	
};


class DELPHICLASS TSqlConnectionOdbc3;
class DELPHICLASS TSQLMetaDataOdbc3;
class PASCALIMPLEMENTATION TSQLMetaDataOdbc3 : public Dbxopenodbc::TSQLMetaDataOdbc 
{
	typedef Dbxopenodbc::TSQLMetaDataOdbc inherited;
	
protected:
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, int PropValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall getObjectList(Dbxopenodbcdbx3types::TSQLObjectType eObjType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getTables(WideChar * TableName, unsigned TableType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getProcedures(WideChar * ProcedureName, unsigned ProcType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getColumns(WideChar * TableName, WideChar * ColumnName, unsigned ColType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getProcedureParams(WideChar * ProcName, WideChar * ParamName, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getIndices(WideChar * TableName, unsigned IndexType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
public:
	#pragma option push -w-inl
	/* TSQLMetaDataOdbc.Create */ inline __fastcall TSQLMetaDataOdbc3(Dbxopenodbc::TSqlConnectionOdbc* AConnection, bool ASupportWideString) : Dbxopenodbc::TSQLMetaDataOdbc(AConnection, ASupportWideString) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSQLMetaDataOdbc.Destroy */ inline __fastcall virtual ~TSQLMetaDataOdbc3(void) { }
	#pragma option pop
	
private:
	void *__ISQLMetaData30;	/* Dbxopenodbcdbx3types::ISQLMetaData30 */
	
public:
	operator ISQLMetaData30*(void) { return (ISQLMetaData30*)&__ISQLMetaData30; }
	operator ISQLMetaData*(void) { return (ISQLMetaData*)&__ISQLMetaData30; }
	
};


class PASCALIMPLEMENTATION TSqlConnectionOdbc3 : public Dbxopenodbc::TSqlConnectionOdbc 
{
	typedef Dbxopenodbc::TSqlConnectionOdbc inherited;
	
protected:
	WideString fServerName;
	WideString fUserName;
	WideString fPassword;
	TSQLMetaDataOdbc3* fMetaDataReader;
	TSQLMetaDataOdbc3* __fastcall GetMetaDataReader(void);
	HIDESBASE int __stdcall connect(void)/* overload */;
	HIDESBASE int __stdcall connect(WideChar * ServerName, WideChar * UserName, WideChar * Password)/* overload */;
	HIDESBASE int __stdcall getSQLCommand(/* out */ Dbxopenodbcdbx3types::_di_ISQLCommand30 &pComm);
	HIDESBASE int __stdcall getSQLMetaData(/* out */ Dbxopenodbcdbx3types::_di_ISQLMetaData30 &pMetaData);
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eConnectOption, int lValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	
public:
	__fastcall virtual TSqlConnectionOdbc3(Dbxopenodbc::TSqlDriverOdbc* OwnerDbxDriver);
	__fastcall virtual ~TSqlConnectionOdbc3(void);
	__property TSQLMetaDataOdbc3* MetaDataReader = {read=GetMetaDataReader};
private:
	void *__ISQLConnection30;	/* Dbxopenodbcdbx3types::ISQLConnection30 */
	
public:
	operator ISQLConnection30*(void) { return (ISQLConnection30*)&__ISQLConnection30; }
	operator ISQLConnection*(void) { return (ISQLConnection*)&__ISQLConnection30; }
	
};


class DELPHICLASS TSqlCommandOdbc3;
class PASCALIMPLEMENTATION TSqlCommandOdbc3 : public Dbxopenodbc::TSqlCommandOdbc 
{
	typedef Dbxopenodbc::TSqlCommandOdbc inherited;
	
protected:
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, int ulValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall prepare(WideChar * SQL, Word ParamCount);
	HIDESBASE int __stdcall execute(Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall executeImmediate(WideChar * SQL, Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getNextCursor(Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
public:
	#pragma option push -w-inl
	/* TSqlCommandOdbc.Create */ inline __fastcall TSqlCommandOdbc3(Dbxopenodbc::TSqlConnectionOdbc* OwnerDbxConnection) : Dbxopenodbc::TSqlCommandOdbc(OwnerDbxConnection) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCommandOdbc.Destroy */ inline __fastcall virtual ~TSqlCommandOdbc3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCommand30;	/* Dbxopenodbcdbx3types::ISQLCommand30 */
	
public:
	operator ISQLCommand30*(void) { return (ISQLCommand30*)&__ISQLCommand30; }
	operator ISQLCommand*(void) { return (ISQLCommand*)&__ISQLCommand30; }
	
};


class DELPHICLASS TSqlCursorOdbc3;
class PASCALIMPLEMENTATION TSqlCursorOdbc3 : public Dbxopenodbc::TSqlCursorOdbc 
{
	typedef Dbxopenodbc::TSqlCursorOdbc inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
	int __stdcall getWideString(Word ColumnNumber, WideChar * Value, BOOL &IsBlank);
	int __stdcall getInt64(Word ColumnNumber, void * Value, BOOL &IsBlank);
public:
	#pragma option push -w-inl
	/* TSqlCursorOdbc.Create */ inline __fastcall TSqlCursorOdbc3(Dbxopenodbc::TSqlCommandOdbc* OwnerCommand) : Dbxopenodbc::TSqlCursorOdbc(OwnerCommand) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorOdbc.Destroy */ inline __fastcall virtual ~TSqlCursorOdbc3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataTables3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataTables3 : public Dbxopenodbc::TSqlCursorMetaDataTables 
{
	typedef Dbxopenodbc::TSqlCursorMetaDataTables inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataTables.Create */ inline __fastcall TSqlCursorMetaDataTables3(Dbxopenodbc::TSqlConnectionOdbc* AConnection, bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataTables(AConnection, ASupportWideString, OwnerMetaData) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorMetaDataTables.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataTables3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataColumns3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumns3 : public Dbxopenodbc::TSqlCursorMetaDataColumns 
{
	typedef Dbxopenodbc::TSqlCursorMetaDataColumns inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataColumns.Create */ inline __fastcall TSqlCursorMetaDataColumns3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataColumns(ASupportWideString, OwnerMetaData) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorMetaDataColumns.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataColumns3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataIndexes3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexes3 : public Dbxopenodbc::TSqlCursorMetaDataIndexes 
{
	typedef Dbxopenodbc::TSqlCursorMetaDataIndexes inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataIndexes.Create */ inline __fastcall TSqlCursorMetaDataIndexes3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataIndexes(ASupportWideString, OwnerMetaData) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexes3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataProcedures3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedures3 : public Dbxopenodbc::TSqlCursorMetaDataProcedures 
{
	typedef Dbxopenodbc::TSqlCursorMetaDataProcedures inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataProcedures.Create */ inline __fastcall TSqlCursorMetaDataProcedures3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataProcedures(ASupportWideString, OwnerMetaData) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorMetaDataProcedures.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataProcedures3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataProcedureParams3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedureParams3 : public Dbxopenodbc::TSqlCursorMetaDataProcedureParams 
{
	typedef Dbxopenodbc::TSqlCursorMetaDataProcedureParams inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataProcedureParams.Create */ inline __fastcall TSqlCursorMetaDataProcedureParams3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataProcedureParams(ASupportWideString, OwnerMetaData) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSqlCursorMetaDataProcedureParams.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataProcedureParams3(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	
};


typedef DynamicArray<AnsiString >  TArrayOfAnsiString;

typedef DynamicArray<WideString >  TArrayOfWideString;

class DELPHICLASS TDbxCommandParser;
class PASCALIMPLEMENTATION TDbxCommandParser : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	AnsiString fDbxCommand;
	int fParamCount;
	DynamicArray<AnsiString >  fParamNames;
	DynamicArray<WideString >  fParamValues;
	int fNextParamIndex;
	WideString __fastcall GetParam(AnsiString AName);
	
public:
	__fastcall TDbxCommandParser(WideString ADbxCmdText, bool CheckIsDbxCommand);
	/*         class method */ static bool __fastcall IsDbxCommand(TMetaClass* vmt, WideString ADbxCmdText)/* overload */;
	/*         class method */ static bool __fastcall IsDbxCommand(TMetaClass* vmt, WideChar * ADbxCmdText)/* overload */;
	/*         class method */ static bool __fastcall IsDbxCommand(TMetaClass* vmt, char * ADbxCmdText)/* overload */;
	/*         class method */ static bool __fastcall IsDbxCommand(TMetaClass* vmt, void * ADbxCmdText, bool AUnicode)/* overload */;
	__property AnsiString DbxCommand = {read=fDbxCommand};
	__property int ParamCount = {read=fParamCount, nodefault};
	__property WideString Params[AnsiString AName] = {read=GetParam};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDbxCommandParser(void) { }
	#pragma option pop
	
};


class DELPHICLASS TSqlCursorMetaDataEmpty;
class PASCALIMPLEMENTATION TSqlCursorMetaDataEmpty : public TSqlCursorMetaDataIndexes3 
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
public:
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection)/* overload */;
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection, const AnsiString * AColNames, const int AColNames_Size, const Word * AColTypes, const int AColTypes_Size)/* overload */;
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection, int AColCount)/* overload */;
	
protected:
	HIDESBASE int __stdcall getColumnCount(Word &pColumns);
	HIDESBASE int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen);
	HIDESBASE int __stdcall getColumnName(Word ColumnNumber, WideChar * pColumnName);
	HIDESBASE int __stdcall getColumnType(Word ColumnNumber, Word &puType, Word &puSubType);
	HIDESBASE int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength);
	HIDESBASE int __stdcall getColumnPrecision(Word ColumnNumber, short &piPrecision);
	HIDESBASE int __stdcall getColumnScale(Word ColumnNumber, short &piScale);
	HIDESBASE int __stdcall isNullable(Word ColumnNumber, BOOL &Nullable);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getDouble(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBcd(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getTimeStamp(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getTime(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getDate(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBytes(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBlobSize(Word ColumnNumber, unsigned &iLength, BOOL &IsBlank);
	HIDESBASE int __stdcall getBlob(Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned iLength);
	HIDESBASE int __stdcall getWideString(Word ColumnNumber, WideChar * Value, BOOL &IsBlank);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataEmpty(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataTablesDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataTablesDbx34 : public TSqlCursorMetaDataTables3 
{
	typedef TSqlCursorMetaDataTables3 inherited;
	
protected:
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	
public:
	__fastcall TSqlCursorMetaDataTablesDbx34(TSqlConnectionOdbc3* AConnection);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataTables.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataTablesDbx34(void) { }
	#pragma option pop
	
};


class DELPHICLASS TSqlCursorMetaDataColumnsDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumnsDbx34 : public TSqlCursorMetaDataColumns3 
{
	typedef TSqlCursorMetaDataColumns3 inherited;
	
protected:
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataColumnsDbx34(TSqlConnectionOdbc3* AConnection);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataColumns.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataColumnsDbx34(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataIndexesDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexesDbx34 : public TSqlCursorMetaDataIndexes3 
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
protected:
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataIndexesDbx34(TSqlConnectionOdbc3* AConnection);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexesDbx34(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	
};


class DELPHICLASS TSqlCursorMetaDataIndexColumnsDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexColumnsDbx34 : public TSqlCursorMetaDataIndexes3 
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
protected:
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataIndexColumnsDbx34(TSqlConnectionOdbc3* AConnection);
public:
	#pragma option push -w-inl
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexColumnsDbx34(void) { }
	#pragma option pop
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	
};


//-- var, const, procedure ---------------------------------------------------
#define DBX4_CMD_PREFIX "@DBX_"
#define DBX4_CMD_EMPTY_CURSOR "@DBX_@"
static const char DBX4_CMD_PARAM_DELIMITER = '\x1';
#define cfvp_Supported "dbxoodbc:dbx34"
#define cfvp_GetVersion "dbxoodbc:version"
#define cfvp_GetQuoteCharacter "dbxoodbc:GetQuoteCharacter"
#define cfvp_SetQuotationEnabled "dbxoodbc:SetQuotationEnabled"
#define cfvp_SetMetadataQueryBegin "dbxoodbc:MetadataQueryBegin"
#define cfvp_SetMetadataQueryEnd "dbxoodbc:MetadataQueryEnd"
#define cfvp_GetMetadataSupported "dbxoodbc:GetMetadataSupported"
#define csvp_SetVendorLib "SetVendorLib"
#define csvp_SetCustomString "SetCustomString"
extern PACKAGE Dbxopenodbcinterface::TOptionSwitches cConnectionOptionsDefault3[38];
extern PACKAGE int __stdcall getSQLDriverODBCW(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern PACKAGE int __stdcall getSQLDriverODBCWA(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);

}	/* namespace Dbxopenodbc3 */
using namespace Dbxopenodbc3;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbc3
