// CodeGear C++Builder
// Copyright (c) 1995, 2008 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbc3.pas' rev: 20.00

#ifndef Dbxopenodbc3HPP
#define Dbxopenodbc3HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Dsintf.hpp>	// Pascal unit
#include <Fmtbcd.hpp>	// Pascal unit
#include <Dbxopenodbctypes.hpp>	// Pascal unit
#include <Dbxopenodbcinterface.hpp>	// Pascal unit
#include <Odbcapi.hpp>	// Pascal unit
#include <Dbxopenodbcdbx3types.hpp>	// Pascal unit
#include <Dbxopenodbcfuncs.hpp>	// Pascal unit
#include <Dbxopenodbcutils.hpp>	// Pascal unit
#include <Dbxopenodbccallback.hpp>	// Pascal unit
#include <Dbxopenodbc.hpp>	// Pascal unit

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
	/* TSqlDriverOdbc.Destroy */ inline __fastcall virtual ~TSqlDriverOdbc3(void) { }
	
private:
	void *__ISQLDriver;	/* Dbxopenodbcdbx3types::ISQLDriver */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLDriver()
	{
		Dbxopenodbcdbx3types::_di_ISQLDriver intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLDriver*(void) { return (ISQLDriver*)&__ISQLDriver; }
	#endif
	
};


class DELPHICLASS TSqlConnectionOdbc3;
class DELPHICLASS TSQLMetaDataOdbc3;
class PASCALIMPLEMENTATION TSqlConnectionOdbc3 : public Dbxopenodbc::TSqlConnectionOdbc
{
	typedef Dbxopenodbc::TSqlConnectionOdbc inherited;
	
protected:
	System::WideString fServerName;
	System::WideString fUserName;
	System::WideString fPassword;
	TSQLMetaDataOdbc3* fMetaDataReader;
	TSQLMetaDataOdbc3* __fastcall GetMetaDataReader(void);
	HIDESBASE int __stdcall connect(void)/* overload */;
	HIDESBASE int __stdcall connect(System::WideChar * ServerName, System::WideChar * UserName, System::WideChar * Password)/* overload */;
	HIDESBASE int __stdcall getSQLCommand(/* out */ Dbxopenodbcdbx3types::_di_ISQLCommand30 &pComm);
	HIDESBASE int __stdcall getSQLMetaData(/* out */ Dbxopenodbcdbx3types::_di_ISQLMetaData30 &pMetaData);
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eConnectOption, int lValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	
public:
	__fastcall virtual TSqlConnectionOdbc3(Dbxopenodbc::TSqlDriverOdbc* OwnerDbxDriver);
	__fastcall virtual ~TSqlConnectionOdbc3(void);
	__property TSQLMetaDataOdbc3* MetaDataReader = {read=GetMetaDataReader};
private:
	void *__ISQLConnection30;	/* Dbxopenodbcdbx3types::ISQLConnection30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLConnection30()
	{
		Dbxopenodbcdbx3types::_di_ISQLConnection30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLConnection30*(void) { return (ISQLConnection30*)&__ISQLConnection30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLConnection()
	{
		Dbxopenodbcdbx3types::_di_ISQLConnection intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLConnection*(void) { return (ISQLConnection*)&__ISQLConnection30; }
	#endif
	
};


class DELPHICLASS TSqlCommandOdbc3;
class PASCALIMPLEMENTATION TSqlCommandOdbc3 : public Dbxopenodbc::TSqlCommandOdbc
{
	typedef Dbxopenodbc::TSqlCommandOdbc inherited;
	
protected:
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, int ulValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall prepare(System::WideChar * SQL, System::Word ParamCount);
	HIDESBASE int __stdcall execute(Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall executeImmediate(System::WideChar * SQL, Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getNextCursor(Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
public:
	/* TSqlCommandOdbc.Create */ inline __fastcall TSqlCommandOdbc3(Dbxopenodbc::TSqlConnectionOdbc* OwnerDbxConnection) : Dbxopenodbc::TSqlCommandOdbc(OwnerDbxConnection) { }
	/* TSqlCommandOdbc.Destroy */ inline __fastcall virtual ~TSqlCommandOdbc3(void) { }
	
private:
	void *__ISQLCommand30;	/* Dbxopenodbcdbx3types::ISQLCommand30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCommand30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCommand30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCommand30*(void) { return (ISQLCommand30*)&__ISQLCommand30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCommand()
	{
		Dbxopenodbcdbx3types::_di_ISQLCommand intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCommand*(void) { return (ISQLCommand*)&__ISQLCommand30; }
	#endif
	
};


class DELPHICLASS TSqlCursorOdbc3;
class PASCALIMPLEMENTATION TSqlCursorOdbc3 : public Dbxopenodbc::TSqlCursorOdbc
{
	typedef Dbxopenodbc::TSqlCursorOdbc inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
	int __stdcall getWideString(System::Word ColumnNumber, System::WideChar * Value, BOOL &IsBlank);
	int __stdcall getInt64(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
public:
	/* TSqlCursorOdbc.Create */ inline __fastcall TSqlCursorOdbc3(Dbxopenodbc::TSqlCommandOdbc* OwnerCommand) : Dbxopenodbc::TSqlCursorOdbc(OwnerCommand) { }
	/* TSqlCursorOdbc.Destroy */ inline __fastcall virtual ~TSqlCursorOdbc3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


class PASCALIMPLEMENTATION TSQLMetaDataOdbc3 : public Dbxopenodbc::TSQLMetaDataOdbc
{
	typedef Dbxopenodbc::TSQLMetaDataOdbc inherited;
	
protected:
	HIDESBASE int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, int PropValue);
	HIDESBASE int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	HIDESBASE int __stdcall getObjectList(Dbxopenodbcdbx3types::TSQLObjectType eObjType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getTables(System::WideChar * TableName, unsigned TableType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getProcedures(System::WideChar * ProcedureName, unsigned ProcType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getColumns(System::WideChar * TableName, System::WideChar * ColumnName, unsigned ColType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getProcedureParams(System::WideChar * ProcName, System::WideChar * ParamName, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getIndices(System::WideChar * TableName, unsigned IndexType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor30 &Cursor);
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
public:
	/* TSQLMetaDataOdbc.Create */ inline __fastcall TSQLMetaDataOdbc3(Dbxopenodbc::TSqlConnectionOdbc* AConnection, bool ASupportWideString) : Dbxopenodbc::TSQLMetaDataOdbc(AConnection, ASupportWideString) { }
	/* TSQLMetaDataOdbc.Destroy */ inline __fastcall virtual ~TSQLMetaDataOdbc3(void) { }
	
private:
	void *__ISQLMetaData30;	/* Dbxopenodbcdbx3types::ISQLMetaData30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLMetaData30()
	{
		Dbxopenodbcdbx3types::_di_ISQLMetaData30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLMetaData30*(void) { return (ISQLMetaData30*)&__ISQLMetaData30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLMetaData()
	{
		Dbxopenodbcdbx3types::_di_ISQLMetaData intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLMetaData*(void) { return (ISQLMetaData*)&__ISQLMetaData30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataTables3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataTables3 : public Dbxopenodbc::TSqlCursorMetaDataTables
{
	typedef Dbxopenodbc::TSqlCursorMetaDataTables inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
public:
	/* TSqlCursorMetaDataTables.Create */ inline __fastcall TSqlCursorMetaDataTables3(Dbxopenodbc::TSqlConnectionOdbc* AConnection, bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataTables(AConnection, ASupportWideString, OwnerMetaData) { }
	/* TSqlCursorMetaDataTables.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataTables3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataColumns3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumns3 : public Dbxopenodbc::TSqlCursorMetaDataColumns
{
	typedef Dbxopenodbc::TSqlCursorMetaDataColumns inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
public:
	/* TSqlCursorMetaDataColumns.Create */ inline __fastcall TSqlCursorMetaDataColumns3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataColumns(ASupportWideString, OwnerMetaData) { }
	/* TSqlCursorMetaDataColumns.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataColumns3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataIndexes3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexes3 : public Dbxopenodbc::TSqlCursorMetaDataIndexes
{
	typedef Dbxopenodbc::TSqlCursorMetaDataIndexes inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
public:
	/* TSqlCursorMetaDataIndexes.Create */ inline __fastcall TSqlCursorMetaDataIndexes3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataIndexes(ASupportWideString, OwnerMetaData) { }
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexes3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataProcedures3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedures3 : public Dbxopenodbc::TSqlCursorMetaDataProcedures
{
	typedef Dbxopenodbc::TSqlCursorMetaDataProcedures inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
public:
	/* TSqlCursorMetaDataProcedures.Create */ inline __fastcall TSqlCursorMetaDataProcedures3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataProcedures(ASupportWideString, OwnerMetaData) { }
	/* TSqlCursorMetaDataProcedures.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataProcedures3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataProcedureParams3;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedureParams3 : public Dbxopenodbc::TSqlCursorMetaDataProcedureParams
{
	typedef Dbxopenodbc::TSqlCursorMetaDataProcedureParams inherited;
	
protected:
	HIDESBASE int __stdcall getErrorMessage(System::WideChar * Error)/* overload */;
	HIDESBASE int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
public:
	/* TSqlCursorMetaDataProcedureParams.Create */ inline __fastcall TSqlCursorMetaDataProcedureParams3(bool ASupportWideString, Dbxopenodbc::TSQLMetaDataOdbc* OwnerMetaData) : Dbxopenodbc::TSqlCursorMetaDataProcedureParams(ASupportWideString, OwnerMetaData) { }
	/* TSqlCursorMetaDataProcedureParams.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataProcedureParams3(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor*(void) { return (ISQLCursor*)&__ISQLCursor30; }
	#endif
	
};


typedef DynamicArray<System::AnsiString> TArrayOfAnsiString;

typedef DynamicArray<System::WideString> TArrayOfWideString;

class DELPHICLASS TDbxCommandParser;
class PASCALIMPLEMENTATION TDbxCommandParser : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::UnicodeString fDbxCommand;
	int fParamCount;
	TArrayOfAnsiString fParamNames;
	TArrayOfWideString fParamValues;
	int fNextParamIndex;
	System::WideString __fastcall GetParam(System::AnsiString AName);
	
public:
	__fastcall TDbxCommandParser(System::WideString ADbxCmdText, bool CheckIsDbxCommand);
	__classmethod bool __fastcall IsDbxCommand(System::WideString ADbxCmdText)/* overload */;
	__classmethod bool __fastcall IsDbxCommand(System::WideChar * ADbxCmdText)/* overload */;
	__classmethod bool __fastcall IsDbxCommand(char * ADbxCmdText)/* overload */;
	__classmethod bool __fastcall IsDbxCommand(void * ADbxCmdText, bool AUnicode)/* overload */;
	__property System::UnicodeString DbxCommand = {read=fDbxCommand};
	__property int ParamCount = {read=fParamCount, nodefault};
	__property System::WideString Params[System::AnsiString AName] = {read=GetParam};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TDbxCommandParser(void) { }
	
};


class DELPHICLASS TSqlCursorMetaDataEmpty;
class PASCALIMPLEMENTATION TSqlCursorMetaDataEmpty : public TSqlCursorMetaDataIndexes3
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
public:
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection)/* overload */;
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection, System::AnsiString *AColNames, const int AColNames_Size, System::Word *AColTypes, const int AColTypes_Size)/* overload */;
	__fastcall TSqlCursorMetaDataEmpty(TSqlConnectionOdbc3* AConnection, int AColCount)/* overload */;
	
protected:
	HIDESBASE int __stdcall getColumnCount(System::Word &pColumns);
	HIDESBASE int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen);
	HIDESBASE int __stdcall getColumnName(System::Word ColumnNumber, System::WideChar * pColumnName);
	HIDESBASE int __stdcall getColumnType(System::Word ColumnNumber, System::Word &puType, System::Word &puSubType);
	HIDESBASE int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength);
	HIDESBASE int __stdcall getColumnPrecision(System::Word ColumnNumber, short &piPrecision);
	HIDESBASE int __stdcall getColumnScale(System::Word ColumnNumber, short &piScale);
	HIDESBASE int __stdcall isNullable(System::Word ColumnNumber, BOOL &Nullable);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getDouble(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBcd(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getTimeStamp(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getTime(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getDate(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBytes(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getBlobSize(System::Word ColumnNumber, unsigned &iLength, BOOL &IsBlank);
	HIDESBASE int __stdcall getBlob(System::Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned iLength);
	HIDESBASE int __stdcall getWideString(System::Word ColumnNumber, System::WideChar * Value, BOOL &IsBlank);
public:
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataEmpty(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataTablesDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataTablesDbx34 : public TSqlCursorMetaDataTables3
{
	typedef TSqlCursorMetaDataTables3 inherited;
	
protected:
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	
public:
	__fastcall TSqlCursorMetaDataTablesDbx34(TSqlConnectionOdbc3* AConnection);
public:
	/* TSqlCursorMetaDataTables.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataTablesDbx34(void) { }
	
};


class DELPHICLASS TSqlCursorMetaDataColumnsDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumnsDbx34 : public TSqlCursorMetaDataColumns3
{
	typedef TSqlCursorMetaDataColumns3 inherited;
	
protected:
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataColumnsDbx34(TSqlConnectionOdbc3* AConnection);
public:
	/* TSqlCursorMetaDataColumns.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataColumnsDbx34(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataIndexesDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexesDbx34 : public TSqlCursorMetaDataIndexes3
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
protected:
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataIndexesDbx34(TSqlConnectionOdbc3* AConnection);
public:
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexesDbx34(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	
};


class DELPHICLASS TSqlCursorMetaDataIndexColumnsDbx34;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexColumnsDbx34 : public TSqlCursorMetaDataIndexes3
{
	typedef TSqlCursorMetaDataIndexes3 inherited;
	
protected:
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaDataIndexColumnsDbx34(TSqlConnectionOdbc3* AConnection);
public:
	/* TSqlCursorMetaDataIndexes.Destroy */ inline __fastcall virtual ~TSqlCursorMetaDataIndexColumnsDbx34(void) { }
	
private:
	void *__ISQLCursor30;	/* Dbxopenodbcdbx3types::ISQLCursor30 */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	operator Dbxopenodbcdbx3types::_di_ISQLCursor30()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor30 intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator ISQLCursor30*(void) { return (ISQLCursor30*)&__ISQLCursor30; }
	#endif
	
};


//-- var, const, procedure ---------------------------------------------------
#define DBX4_CMD_PREFIX L"@DBX_"
#define DBX4_CMD_EMPTY_CURSOR L"@DBX_@"
static const WideChar DBX4_CMD_PARAM_DELIMITER = (WideChar)(0x1);
#define cfvp_Supported L"dbxoodbc:dbx34"
#define cfvp_GetVersion L"dbxoodbc:version"
#define cfvp_GetQuoteCharacter L"dbxoodbc:GetQuoteCharacter"
#define cfvp_SetQuotationEnabled L"dbxoodbc:SetQuotationEnabled"
#define cfvp_SetMetadataQueryBegin L"dbxoodbc:MetadataQueryBegin"
#define cfvp_SetMetadataQueryEnd L"dbxoodbc:MetadataQueryEnd"
#define cfvp_GetMetadataSupported L"dbxoodbc:GetMetadataSupported"
#define csvp_SetVendorLib L"SetVendorLib"
#define csvp_SetCustomString L"SetCustomString"
extern PACKAGE Dbxopenodbcinterface::TConnectionOptions cConnectionOptionsDefault3;
extern PACKAGE int __stdcall getSQLDriverODBCW(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern PACKAGE int __stdcall getSQLDriverODBCWA(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);

}	/* namespace Dbxopenodbc3 */
using namespace Dbxopenodbc3;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbc3HPP
