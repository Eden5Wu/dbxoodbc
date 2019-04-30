// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbc.pas' rev: 6.00

#ifndef DbxOpenOdbcHPP
#define DbxOpenOdbcHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DbxOpenOdbcTrace.hpp>	// Pascal unit
#include <DbxOpenOdbcCallback.hpp>	// Pascal unit
#include <DbxObjectParser.hpp>	// Pascal unit
#include <DbxOpenOdbcUtils.hpp>	// Pascal unit
#include <DbxOpenOdbcFuncs.hpp>	// Pascal unit
#include <DbxOpenOdbcInterface.hpp>	// Pascal unit
#include <DbxOpenOdbcDbx3Types.hpp>	// Pascal unit
#include <OdbcApi.hpp>	// Pascal unit
#include <DbxOpenOdbcTypes.hpp>	// Pascal unit
#include <FMTBcd.hpp>	// Pascal unit
#include <DSIntf.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbc
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EDbxErrorCustom;
class PASCALIMPLEMENTATION EDbxErrorCustom : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxErrorCustom(const AnsiString Msg) : Sysutils::Exception(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxErrorCustom(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxErrorCustom(int Ident)/* overload */ : Sysutils::Exception(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxErrorCustom(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxErrorCustom(const AnsiString Msg, int AHelpContext) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxErrorCustom(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxErrorCustom(int Ident, int AHelpContext)/* overload */ : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxErrorCustom(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxErrorCustom(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxOdbcWarning;
class PASCALIMPLEMENTATION EDbxOdbcWarning : public EDbxErrorCustom 
{
	typedef EDbxErrorCustom inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxOdbcWarning(const AnsiString Msg) : EDbxErrorCustom(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxOdbcWarning(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxErrorCustom(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcWarning(int Ident)/* overload */ : EDbxErrorCustom(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcWarning(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxErrorCustom(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxOdbcWarning(const AnsiString Msg, int AHelpContext) : EDbxErrorCustom(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOdbcWarning(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxErrorCustom(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcWarning(int Ident, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcWarning(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxOdbcWarning(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxError;
class PASCALIMPLEMENTATION EDbxError : public EDbxErrorCustom 
{
	typedef EDbxErrorCustom inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxError(const AnsiString Msg) : EDbxErrorCustom(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxErrorCustom(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxError(int Ident)/* overload */ : EDbxErrorCustom(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxError(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxErrorCustom(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxError(const AnsiString Msg, int AHelpContext) : EDbxErrorCustom(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxErrorCustom(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxError(int Ident, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxError(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxOdbcError;
class PASCALIMPLEMENTATION EDbxOdbcError : public EDbxError 
{
	typedef EDbxError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxOdbcError(const AnsiString Msg) : EDbxError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxOdbcError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcError(int Ident)/* overload */ : EDbxError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcError(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxOdbcError(const AnsiString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOdbcError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcError(int Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcError(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxOdbcError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxNotSupported;
class PASCALIMPLEMENTATION EDbxNotSupported : public EDbxError 
{
	typedef EDbxError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxNotSupported(const AnsiString Msg) : EDbxError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxNotSupported(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxNotSupported(int Ident)/* overload */ : EDbxError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxNotSupported(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxNotSupported(const AnsiString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxNotSupported(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxNotSupported(int Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxNotSupported(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxNotSupported(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxInvalidCall;
class PASCALIMPLEMENTATION EDbxInvalidCall : public EDbxError 
{
	typedef EDbxError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxInvalidCall(const AnsiString Msg) : EDbxError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxInvalidCall(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidCall(int Ident)/* overload */ : EDbxError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidCall(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxInvalidCall(const AnsiString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInvalidCall(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidCall(int Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidCall(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxInvalidCall(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxInternalError;
class PASCALIMPLEMENTATION EDbxInternalError : public EDbxError 
{
	typedef EDbxError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxInternalError(const AnsiString Msg) : EDbxError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxInternalError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxInternalError(int Ident)/* overload */ : EDbxError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxInternalError(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxInternalError(const AnsiString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInternalError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxInternalError(int Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInternalError(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxInternalError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxInvalidParam;
class PASCALIMPLEMENTATION EDbxInvalidParam : public EDbxError 
{
	typedef EDbxError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxInvalidParam(const AnsiString Msg) : EDbxError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxInvalidParam(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : EDbxError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidParam(int Ident)/* overload */ : EDbxError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidParam(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : EDbxError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxInvalidParam(const AnsiString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInvalidParam(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : EDbxError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidParam(int Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidParam(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxInvalidParam(void) { }
	#pragma option pop
	
};


struct SQLTRACEDesc30;
typedef SQLTRACEDesc30 *pSQLTRACEDesc30;

#pragma pack(push, 1)
struct SQLTRACEDesc30
{
	WideChar pszTrace[1024];
	int eTraceCat;
	int ClientData;
	Word uTotalMsgLen;
} ;
#pragma pack(pop)

struct SQLTRACEDesc25;
typedef SQLTRACEDesc25 *pSQLTRACEDesc25;

#pragma pack(push, 1)
struct SQLTRACEDesc25
{
	char pszTrace[1024];
	int eTraceCat;
	int ClientData;
	Word uTotalMsgLen;
} ;
#pragma pack(pop)

#pragma option push -b-
enum DbxOpenOdbc__9 { hpWindows, hpLinux, hpMACOS, hpCLR, hp32Bit, hp64bit };
#pragma option pop

typedef Set<DbxOpenOdbc__9, hpWindows, hp64bit>  THostPlatform;

#pragma option push -b-
enum TConnectionOptionRestriction { cor_connection_off, cor_ActiveCursors0, cor_driver_off };
#pragma option pop

typedef Set<TConnectionOptionRestriction, cor_connection_off, cor_driver_off>  TConnectionOptionsRestriction;

typedef TConnectionOptionsRestriction TConnectionOptionsRestrictions[38];

#pragma option push -b-
enum TBindMapDateTimeOdbcIndexes { biDate, biTime, biDateTime };
#pragma option pop

typedef int TBindMapDateTimeOdbc[3];

typedef int *PBindMapDateTimeOdbc;

typedef TList TDbxConStmtList;
;

struct TDbxHStmtNode;
typedef TDbxHStmtNode *PDbxHStmtNode;

#pragma pack(push, 1)
struct TDbxHStmtNode
{
	void *HStmt;
	TDbxHStmtNode *fPrevDbxHStmtNode;
	TDbxHStmtNode *fNextDbxHStmtNode;
} ;
#pragma pack(pop)

typedef DynamicArray<TDbxHStmtNode >  TArrayOfDbxHStmtNode;

#pragma pack(push, 1)
struct TDbxConStmt
{
	void *fHCon;
	TDbxHStmtNode *fActiveDbxHStmtNodes;
	TDbxHStmtNode *fNullDbxHStmtNodes;
	int fSqlHStmtAllocated;
	int fActiveCursors;
	int fInTransaction;
	int fAutoCommitMode;
	int fRowsAffected;
	bool fOutOfDateCon;
	bool fDeadConnection;
	DynamicArray<TDbxHStmtNode >  fBucketDbxHStmtNodes;
} ;
#pragma pack(pop)

typedef TDbxConStmt *PDbxConStmt;

#pragma pack(push, 1)
struct TDbxConStmtInfo
{
	TDbxConStmt *fDbxConStmt;
	TDbxHStmtNode *fDbxHStmtNode;
} ;
#pragma pack(pop)

typedef TDbxConStmtInfo *PDbxConStmtInfo;

#pragma option push -b-
enum TDOSQLObjectType { otDOSQLUnknown, otDOSQLDriver, otDOSQLConnection, otDOSQLCommand, otDOSQLMetaData, otDOSQLCursor, otDOSQLCursorMetadata };
#pragma option pop

class DELPHICLASS TDOSQLObject;
class PASCALIMPLEMENTATION TDOSQLObject : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
protected:
	TDOSQLObjectType FObjectType;
	System::TObject* __stdcall SelfObj(void);
	
public:
	__property TDOSQLObjectType ObjectType = {read=FObjectType, nodefault};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDOSQLObject(void) : System::TInterfacedObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDOSQLObject(void) { }
	#pragma option pop
	
private:
	void *__ISQLCommon;	/* Dbxopenodbcdbx3types::ISQLCommon */
	
public:
	operator ISQLCommon*(void) { return (ISQLCommon*)&__ISQLCommon; }
	
};


class DELPHICLASS TSqlDriverOdbc;
class DELPHICLASS TSqlConnectionOdbc;
class DELPHICLASS TSqlCommandOdbc;
class DELPHICLASS TSqlCursorOdbc;
class PASCALIMPLEMENTATION TSqlDriverOdbc : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	Odbcapi::TOdbcApiProxy* fOdbcApi;
	bool fUnicodeOdbcApiPriority;
	bool fIsUnicodeOdbcApi;
	int fDrvBlobSizeLimitK;
	Classes::TStringList* fOdbcErrorLines;
	void *fhEnv;
	int fNativeErrorCode;
	char fSqlStateChars[6];
	unsigned fDbxDrvRestrict;
	bool fIgnoreErrors;
	int fDBXVersion;
	int fClientVersion;
	int fConnectionCount;
	bool fDriverIsUsed;
	void __fastcall AllocHCon(/* out */ void * &HCon);
	void __fastcall AllocHEnv(void);
	void __fastcall FreeHCon(void * &HCon, PDbxConStmt DbxConStmt, bool bIgnoreError = false);
	void __fastcall FreeHEnv(void);
	void __fastcall ClearFields(void);
	void __fastcall AssignFields(TSqlDriverOdbc* ASource);
	void __fastcall RetrieveOdbcErrorInfo(short CheckCode, short HandleType, void * Handle, PDbxConStmt DbxConStmt, TSqlConnectionOdbc* Connection, TSqlCommandOdbc* Command, TSqlCursorOdbc* Cursor = (TSqlCursorOdbc*)(0x0), int bClearErrorCount = 0x0, int maxErrorCount = 0x0, int eTraceCat = 0x0);
	void __fastcall OdbcCheck(short CheckCode, const AnsiString OdbcFunctionName, short HandleType, void * Handle, PDbxConStmt DbxConStmt, TSqlConnectionOdbc* Connection = (TSqlConnectionOdbc*)(0x0), TSqlCommandOdbc* Command = (TSqlCommandOdbc*)(0x0), TSqlCursorOdbc* Cursor = (TSqlCursorOdbc*)(0x0), int maxErrorCount = 0x0, int eTraceCat = 0x0);
	int __stdcall getSQLConnection(/* out */ Dbxopenodbcdbx3types::_di_ISQLConnection &pConn);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLDriverOption eDOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLDriverOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	bool __stdcall GetOdbcDrivers(WideString &ADriverList);
	
public:
	__fastcall virtual TSqlDriverOdbc(Odbcapi::TOdbcApiProxy* AOdbcApi, bool bIsUnicodeOdbcApi);
	__fastcall virtual ~TSqlDriverOdbc(void);
	void __fastcall Drivers(Classes::TStrings* DriverList);
private:
	void *__ISQLDriver;	/* Dbxopenodbcdbx3types::ISQLDriver */
	void *__ISqlDriverOdbc;	/* Dbxopenodbcinterface::ISqlDriverOdbc */
	
public:
	operator ISqlDriverOdbc*(void) { return (ISqlDriverOdbc*)&__ISqlDriverOdbc; }
	operator ISQLDriver*(void) { return (ISQLDriver*)&__ISQLDriver; }
	
};


typedef TMetaClass* TSqlDriverOdbcClass;

class PASCALIMPLEMENTATION TSqlConnectionOdbc : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	Classes::TStringList* fConnectionErrorLines;
	TSqlDriverOdbc* fOwnerDbxDriver;
	System::_di_IInterface fOwnerDbxDriverNew;
	Dbxopenodbcdbx3types::TSQLCallbackEvent fDbxTraceCallbackEven;
	int fDbxTraceClientData;
	bool fConnected;
	bool fSafeMode;
	bool fConnectionClosed;
	int fConnBlobSizeLimitK;
	void *fhCon;
	Word fStatementPerConnection;
	Classes::TList* fDbxConStmtList;
	int fDbxConStmtActive;
	int fCon0SqlHStmt;
	TDbxConStmt *fCurrDbxConStmt;
	bool fWantQuotedTableName;
	bool fSupportsDbxQuotation;
	bool fDbxMetadataQueryMode;
	AnsiString fOdbcConnectString;
	AnsiString fOdbcConnectStringHidePassword;
	AnsiString fConnConnectionString;
	AnsiString fOdbcReturnedConnectString;
	Word fOdbcMaxColumnNameLen;
	Word fOdbcMaxCatalogNameLen;
	Word fOdbcMaxSchemaNameLen;
	Word fOdbcMaxTableNameLen;
	Word fOdbcMaxIdentifierLen;
	AnsiString fDbmsName;
	Dbxopenodbcinterface::TDbmsType fDbmsType;
	AnsiString fDbmsVersionString;
	int fDbmsVersionMajor;
	int fDbmsVersionMinor;
	int fDbmsVersionRelease;
	int fDbmsVersionBuild;
	AnsiString fOdbcDriverName;
	Dbxopenodbcinterface::TOdbcDriverType fOdbcDriverType;
	AnsiString fOdbcDriverVersionString;
	int fOdbcDriverVersionMajor;
	int fOdbcDriverVersionMinor;
	int fOdbcDriverVersionRelease;
	int fOdbcDriverVersionBuild;
	int fOdbcDriverLevel;
	int fInTransaction;
	bool fSupportsCatalog;
	bool fSupportsSQLSTATISTICS;
	bool fSupportsSQLPRIMARYKEYS;
	bool fSupportsSchemaDML;
	bool fSupportsSchemaProc;
	bool fSupportsCatalogDML;
	bool fSupportsCatalogProc;
	bool fGetDataAnyColumn;
	AnsiString fCurrentCatalog;
	char fQuoteChar;
	WideChar fQuoteCharW;
	int fAutoCommitMode;
	bool fSupportsTransaction;
	bool fSupportsNestedTransactions;
	bool fSupportsTransactionMetadata;
	AnsiString fCurrentSchema;
	Dbxopenodbcinterface::TOptionSwitches fConnectionOptions[38];
	Dbxopenodbcinterface::TOptionSwitches fConnectionOptionsDrv[38];
	int fBlobChunkSize;
	int fNetwrkPacketSize;
	AnsiString fQualifiedName;
	int fNativeErrorCode;
	char fSqlStateChars[6];
	AnsiString fDbxCatalog;
	AnsiString fOdbcCatalogPrefix;
	AnsiString fDbmsVersion;
	TSqlCommandOdbc* fLastStoredProc;
	Dbxobjectparser::TObjectNameParser* fObjectNameParser;
	Dbxobjectparser::TObjectNameParser* fObjectNameParserShort;
	int fOdbcIsolationLevel;
	bool fSupportsBlockRead;
	int fSqlHStmtAllocated;
	bool fCursorPreserved;
	int fActiveCursors;
	int fRowsAffected;
	int *fBindMapDateTimeOdbc;
	int fConnectionTimeout;
	int fNetworkTimeout;
	int fLockMode;
	int fMDCase;
	char fDecimalSeparator;
	bool fPrepareSQL;
	bool __fastcall FindFreeConnection(/* out */ TDbxConStmtInfo &DbxConStmtInfo, int MaxStatementsPerConnection, bool bMetadataRead = false, bool bOnlyPreservedCursors = false);
	void __fastcall AllocHStmt(/* out */ void * &HStmt, PDbxConStmtInfo aDbxConStmtInfo = (void *)(0x0), bool bMetadataRead = false);
	void __fastcall CheckTransactionSupport(void);
	void __fastcall CheckDbmsTransactionSupport(void);
	void __fastcall SynchronizeInTransaction(TDbxConStmt &DbxConStmt);
	void __fastcall CloneOdbcConnection(/* out */ TDbxConStmtInfo &DbxConStmtInfo, bool bSynchronizeTransaction = true);
	void __fastcall FreeHStmt(/* out */ void * &HStmt, PDbxConStmtInfo aDbxConStmtInfo = (void *)(0x0));
	int __fastcall GetMetaDataOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	PDbxConStmt __fastcall GetCurrentDbxConStmt(void)/* overload */;
	PDbxConStmt __fastcall GetCurrentDbxConStmt(/* out */ void * &HStmt)/* overload */;
	void * __fastcall GetCurrentConnectionHandle(void);
	void __fastcall OdbcCheck(short OdbcCode, const AnsiString OdbcFunctionName, PDbxConStmt DbxConStmt, int TraceCat = 0x0);
	int __fastcall RetrieveDriverName(void);
	int __fastcall RetrieveDbmsOptions(void);
	AnsiString __fastcall GetCatalog(void * aHConStmt = (void *)(0x0));
	void __fastcall GetCurrentCatalog(void * aHConStmt = (void *)(0x0));
	void __fastcall TransactionCheck(const TDbxConStmtInfo &DbxConStmtInfo);
	void __fastcall ClearConnectionOptions(void);
	void __fastcall SetCurrentDbxConStmt(PDbxConStmt aDbxConStmt);
	bool __fastcall SetLoginTimeout(void * hCon, int TimeoutSeconds);
	bool __fastcall SetNetworkTimeout(void * hCon, int TimeoutSeconds);
	Dbxopenodbcinterface::PConnectionOptions __fastcall GetDefaultConnectionOptions(void);
	void * __fastcall DecodeObjectFullName(AnsiString ObjectFullName, AnsiString &sCatalogName, AnsiString &sSchemaName, AnsiString &sObjectName, bool bStoredProcSpace = false);
	AnsiString __fastcall EncodeObjectFullName(AnsiString CatalogName, AnsiString SchemaName, AnsiString ObjectName, bool AQuoted = true, void * pTemplateInfo = (void *)(0x0));
	AnsiString __fastcall GetQuotedObjectName(const AnsiString ObjectName, bool bStoredProcSpace = false, bool AQuoted = true);
	AnsiString __fastcall GetUnquotedName(const AnsiString Name)/* overload */;
	WideString __fastcall GetUnquotedName(const WideString Name)/* overload */;
	int __fastcall GetUnquotedNameLen(const AnsiString Name);
	bool __fastcall ObjectIsStoredProc(const AnsiString Name);
	void __fastcall CreateRegExpObjectNameParser(Dbxobjectparser::PObjectNameTemplateInfo AObjectNameTemplateInfo, const AnsiString DbQuote, const AnsiString sRegExpNew = "");
	void __fastcall ReleaseRegExpObjectNameParser(void);
	void __fastcall DbxCallBackSendMsg(int TraceCat, const AnsiString Msg);
	void __fastcall DbxCallBackSendMsgFmt(int TraceCat, const AnsiString FmtMsg, const System::TVarRec * FmtArgs, const int FmtArgs_Size);
	void __fastcall DoDestroy(bool bReinit);
	void __fastcall CheckHCon(void);
	bool __fastcall SetVendorLib(AnsiString AVendorLib, bool UnicodePriority, TMetaClass* SqlDriverClass = 0x0);
	int __stdcall connect(char * ServerName, char * UserName, char * Password);
	int __stdcall disconnect(void);
	int __stdcall getSQLCommand(/* out */ Dbxopenodbcdbx3types::_di_ISQLCommand25 &pComm);
	int __stdcall getSQLMetaData(/* out */ Dbxopenodbcdbx3types::_di_ISQLMetaData25 &pMetaData);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eConnectOption, int lValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLConnectionOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall beginTransaction(unsigned TranID);
	int __stdcall commit(unsigned TranID);
	int __stdcall rollback(unsigned TranID);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	AnsiString __stdcall GetDbmsName();
	Dbxopenodbcinterface::TDbmsType __stdcall GetDbmsType(void);
	AnsiString __stdcall GetDbmsVersionString();
	int __stdcall GetDbmsVersionMajor(void);
	int __stdcall GetDbmsVersionMinor(void);
	int __stdcall GetDbmsVersionRelease(void);
	int __stdcall GetDbmsVersionBuild(void);
	char * __stdcall GetLastOdbcSqlState(void);
	AnsiString __stdcall GetOdbcConnectString();
	void __stdcall GetOdbcConnectStrings(Classes::TStrings* ConnectStringList);
	AnsiString __stdcall GetOdbcDriverName();
	Dbxopenodbcinterface::TOdbcDriverType __stdcall GetOdbcDriverType(void);
	AnsiString __stdcall GetOdbcDriverVersionString();
	int __stdcall GetOdbcDriverVersionMajor(void);
	int __stdcall GetOdbcDriverVersionMinor(void);
	int __stdcall GetOdbcDriverVersionRelease(void);
	int __stdcall GetOdbcDriverVersionBuild(void);
	bool __stdcall GetCursorPreserved(void);
	bool __stdcall GetIsSystemODBCManager(void);
	int __stdcall GetOdbcDriverLevel(void);
	bool __stdcall GetSupportsSqlPrimaryKeys(void);
	int __stdcall GetStatementsPerConnection(void);
	void * __stdcall GetEnvironmentHandle(void);
	void * __stdcall GetConnectionHandle(void);
	System::_di_IInterface __stdcall GetOdbcApiIntf();
	char __stdcall GetDecimalSeparator(void);
	
public:
	__fastcall virtual TSqlConnectionOdbc(TSqlDriverOdbc* OwnerDbxDriver);
	__fastcall virtual ~TSqlConnectionOdbc(void);
	__property AnsiString DbmsName = {read=fDbmsName};
	__property Dbxopenodbcinterface::TDbmsType DbmsType = {read=fDbmsType, nodefault};
	__property int DbmsVersionMajor = {read=fDbmsVersionMajor, nodefault};
	__property AnsiString DbmsVersionString = {read=fDbmsVersion};
	__property char * LastOdbcSqlState = {read=GetLastOdbcSqlState};
	__property AnsiString OdbcConnectString = {read=fOdbcConnectString};
	__property AnsiString OdbcDriverName = {read=fOdbcDriverName};
	__property Dbxopenodbcinterface::TOdbcDriverType OdbcDriverType = {read=fOdbcDriverType, nodefault};
	__property int OdbcDriverVersionMajor = {read=fOdbcDriverVersionMajor, nodefault};
	__property AnsiString OdbcDriverVersionString = {read=fOdbcDriverVersionString};
private:
	void *__ISQLConnection25;	/* Dbxopenodbcdbx3types::ISQLConnection25 */
	void *__ISqlConnectionOdbc;	/* Dbxopenodbcinterface::ISqlConnectionOdbc */
	
public:
	operator ISqlConnectionOdbc*(void) { return (ISqlConnectionOdbc*)&__ISqlConnectionOdbc; }
	operator ISQLConnection25*(void) { return (ISQLConnection25*)&__ISQLConnection25; }
	
};


#pragma option push -b-
enum DbxOpenOdbc__31 { scsStmtBinded, scsStmtExecuted, scsIsCursor };
#pragma option pop

typedef Set<DbxOpenOdbc__31, scsStmtBinded, scsIsCursor>  TStmtCommandStatus;

class PASCALIMPLEMENTATION TSqlCommandOdbc : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	TSqlConnectionOdbc* fOwnerDbxConnection;
	TSqlDriverOdbc* fOwnerDbxDriver;
	int fCommandBlobSizeLimitK;
	int fCommandRowSetSize;
	bool fSupportsBlockRead;
	AnsiString fSql;
	AnsiString fSqlPrepared;
	WideString fSqlW;
	WideString fSqlPreparedW;
	void *fHStmt;
	Classes::TList* fOdbcParamList;
	unsigned fOdbcRowsAffected;
	bool fTrimChar;
	bool fExecutedOk;
	bool fPreparedOnly;
	bool fSupportsMixedFetch;
	int fStoredProc;
	AnsiString fStoredProcPackName;
	bool fStoredProcWithResult;
	AnsiString fCatalogName;
	AnsiString fSchemaName;
	int fIsMoreResults;
	TStmtCommandStatus fStmtStatus;
	#pragma pack(push, 1)
	TDbxConStmtInfo fDbxConStmtInfo;
	#pragma pack(pop)
	
	void __fastcall AddError(Sysutils::Exception* eError);
	void __fastcall OdbcCheck(short OdbcCode, const AnsiString OdbcFunctionName, int eTraceCat = 0x0);
	AnsiString __fastcall BuildStoredProcSQL();
	void __fastcall CloseStmt(bool bClearParams = true, bool bFreeStmt = true);
	void __fastcall ClearParams(void);
	void * __fastcall GetConnectionHandle(void);
	void __fastcall DoAllocateStmt(void);
	void __fastcall DoUnprepareStmt(void);
	short __fastcall DoSQLMoreResults(void);
	void __fastcall DoAllocateParams(Word ParamCount);
	void __fastcall DoExpandParams(Word ParamCount);
	int __fastcall DoPrepare(char * SQL, Word ParamCount, bool UpdateParams, bool bPrepareSQL, bool bUseUnicodeOdbc);
	int __fastcall DoExecute(Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor, bool bUseUnicodeOdbc);
	int __fastcall DoExecuteImmediate(char * SQL, Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor, bool bUseUnicodeOdbc);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, int ulValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall setParameter(Word ulParameter, Word ulChildPos, Dbxopenodbcdbx3types::TSTMTParamType eParamType, Word uLogType, Word uSubType, int iPrecision, int iScale, unsigned iLength, void * pBuffer, int bIsNull);
	int __stdcall getParameter(Word ParameterNumber, Word ulChildPos, void * Value, int iLength, int &IsBlank);
	int __stdcall prepare(char * SQL, Word ParamCount);
	int __stdcall execute(Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall ExecuteImmediate(char * SQL, Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getNextCursor(Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getRowsAffected(unsigned &Rows);
	int __stdcall close(void);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	void __stdcall Cancel(void);
	bool __stdcall SetLockTimeout(int TimeoutSeconds);
	int __stdcall GetLockTimeout(void);
	
public:
	__fastcall TSqlCommandOdbc(TSqlConnectionOdbc* OwnerDbxConnection);
	__fastcall virtual ~TSqlCommandOdbc(void);
	__property void * hOdbcStmt = {read=fHStmt};
	__property void * ConnectionHandle = {read=GetConnectionHandle};
private:
	void *__ISQLCommand25;	/* Dbxopenodbcdbx3types::ISQLCommand25 */
	void *__ISqlCommandOdbc;	/* Dbxopenodbcinterface::ISqlCommandOdbc */
	
public:
	operator ISqlCommandOdbc*(void) { return (ISqlCommandOdbc*)&__ISqlCommandOdbc; }
	operator ISQLCommand25*(void) { return (ISQLCommand25*)&__ISQLCommand25; }
	
};


class DELPHICLASS TSQLMetaDataOdbc;
class PASCALIMPLEMENTATION TSQLMetaDataOdbc : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	bool fSupportWideString;
	TSqlConnectionOdbc* fOwnerDbxConnection;
	Classes::TStringList* fMetaDataErrorLines;
	AnsiString fMetaSchemaName;
	AnsiString fMetaCatalogName;
	AnsiString fMetaPackName;
	int __stdcall DoGetTables(char * Cat, char * Schema, char * TableName, unsigned TableType, /* out */ void * &Cursor, bool bUnicode);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall getObjectList(Dbxopenodbcdbx3types::TSQLObjectType eObjType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getTables(char * TableName, unsigned TableType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getProcedures(char * ProcedureName, unsigned ProcType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getColumns(char * TableName, char * ColumnName, unsigned ColType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getProcedureParams(char * ProcName, char * ParamName, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getIndices(char * TableName, unsigned IndexType, /* out */ Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	
public:
	__fastcall TSQLMetaDataOdbc(TSqlConnectionOdbc* AConnection, bool ASupportWideString);
	__fastcall virtual ~TSQLMetaDataOdbc(void);
private:
	void *__ISQLMetaData25;	/* Dbxopenodbcdbx3types::ISQLMetaData25 */
	
public:
	operator ISQLMetaData25*(void) { return (ISQLMetaData25*)&__ISQLMetaData25; }
	
};


typedef DynamicArray<short >  DbxOpenOdbc__71;

class DELPHICLASS TOdbcBindCol;
class PASCALIMPLEMENTATION TSqlCursorOdbc : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	TSqlCommandOdbc* fOwnerCommand;
	TSqlConnectionOdbc* fOwnerDbxConnection;
	TSqlDriverOdbc* fOwnerDbxDriver;
	double fRowNo;
	void *fHStmt;
	short fOdbcNumCols;
	Classes::TList* fOdbcBindList;
	int fCursorFetchRowCount;
	void *fOdbcBindBuffer;
	int fOdbcBindBufferRowSize;
	DynamicArray<short >  fOdbcRowsStatus;
	int fOdbcBindBufferPos;
	int fOdbcRowsFetched;
	bool fOdbcLateBoundsFound;
	bool fOdbcColumnsFetchConsecutively;
	void __fastcall BindResultSet(void);
	void __fastcall OdbcCheck(short OdbcCode, const AnsiString OdbcFunctionName, int maxErrorCount = 0x0);
	void __fastcall DoFetchLongData(TOdbcBindCol* aOdbcBindCol, bool bAllowFragmentation, int FirstChunkSize);
	void __fastcall FetchLongData(Word ColNo, bool bAllowFragmentation = false, int FirstChunkSize = 0x0);
	void __fastcall DoFetchLateBoundData(TOdbcBindCol* aOdbcBindCol);
	void __fastcall FetchLateBoundData(Word ColNo);
	void __fastcall CheckFetchCacheColumns(Word ColNoLimit);
	void __fastcall AddError(Sysutils::Exception* eError);
	void __fastcall ClearCursor(bool bFreeStmt = false);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	int __stdcall getColumnCount(Word &pColumns);
	int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen);
	int __stdcall getColumnName(Word ColumnNumber, char * pColumnName);
	int __stdcall getColumnType(Word ColumnNumber, Word &puType, Word &puSubType);
	int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength);
	int __stdcall getColumnPrecision(Word ColumnNumber, short &piPrecision);
	int __stdcall getColumnScale(Word ColumnNumber, short &piScale);
	int __stdcall isNullable(Word ColumnNumber, BOOL &Nullable);
	int __stdcall isAutoIncrement(Word ColumnNumber, BOOL &AutoIncr);
	int __stdcall isReadOnly(Word ColumnNumber, BOOL &ReadOnly);
	int __stdcall isSearchable(Word ColumnNumber, BOOL &Searchable);
	int __stdcall isBlobSizeExact(Word ColumnNumber, BOOL &IsExact);
	int __stdcall next(void);
	int __stdcall getString(Word ColumnNumber, char * Value, BOOL &IsBlank);
	int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getDouble(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBcd(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getTimeStamp(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getTime(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getDate(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBytes(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBlobSize(Word ColumnNumber, unsigned &iLength, BOOL &IsBlank);
	int __stdcall getBlob(Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned iLength);
	
public:
	__fastcall TSqlCursorOdbc(TSqlCommandOdbc* OwnerCommand);
	__fastcall virtual ~TSqlCursorOdbc(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TMetaTable;
class DELPHICLASS TMetaIndexColumn;
class PASCALIMPLEMENTATION TMetaIndexColumn : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	TMetaTable* fMetaTable;
	AnsiString fCatName;
	AnsiString fSchemaName;
	AnsiString fTableName;
	AnsiString fIndexName;
	AnsiString fIndexColumnName;
	AnsiString fFilter;
	WideString fWCatName;
	WideString fWSchemaName;
	WideString fWTableName;
	WideString fWIndexName;
	WideString fWIndexColumnName;
	WideString fWFilter;
	short fColumnPosition;
	short fIndexType;
	char fSortOrder;
	__fastcall TMetaIndexColumn(TMetaTable* MetaTable, char * CatName, char * SchemaName, char * TableName, char * IndexName, char * IndexColumnName);
	__fastcall TMetaIndexColumn(TMetaTable* MetaTable, WideChar * CatName, WideChar * SchemaName, WideChar * TableName, WideChar * IndexName, char * IndexColumnName);
	__fastcall virtual ~TMetaIndexColumn(void);
};


class PASCALIMPLEMENTATION TMetaTable : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	AnsiString fCat;
	AnsiString fSchema;
	AnsiString fTableName;
	AnsiString fQualifiedTableName;
	AnsiString fRemarks;
	WideString fWCat;
	WideString fWSchema;
	WideString fWTableName;
	WideString fWQualifiedTableName;
	WideString fWRemarks;
	int fTableType;
	TMetaIndexColumn* fPrimaryKeyColumn1;
	Classes::TList* fIndexColumnList;
	__fastcall TMetaTable(TSqlConnectionOdbc* SqlConnectionOdbc, char * Cat, char * Schema, char * TableName, int TableType, char * Remarks);
	__fastcall TMetaTable(TSqlConnectionOdbc* SqlConnectionOdbc, WideChar * Cat, WideChar * Schema, WideChar * TableName, int TableType, WideChar * Remarks);
	__fastcall virtual ~TMetaTable(void);
};


class DELPHICLASS TMetaColumn;
class PASCALIMPLEMENTATION TMetaColumn : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	TMetaTable* fMetaTable;
	short fOrdinalPosition;
	AnsiString fColumnName;
	AnsiString fTypeName;
	AnsiString fDefaultValue;
	AnsiString fRemarks;
	WideString fWColumnName;
	WideString fWTypeName;
	WideString fWDefaultValue;
	WideString fWRemarks;
	int fLength;
	int fPrecision;
	short fDecimalScale;
	short fDbxType;
	short fDbxSubType;
	short fDbxNullable;
	short fDbxColumnType;
	__fastcall TMetaColumn(char * ColumnName, short OrdinalPosition, char * TypeName, char * DefaultValue, char * Remarks);
	__fastcall TMetaColumn(WideChar * ColumnName, short OrdinalPosition, WideChar * TypeName, WideChar * DefaultValue, WideChar * Remarks);
	__fastcall virtual ~TMetaColumn(void);
};


class DELPHICLASS TMetaProcedure;
class PASCALIMPLEMENTATION TMetaProcedure : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	AnsiString fCat;
	AnsiString fSchema;
	AnsiString fProcName;
	WideString fWCat;
	WideString fWSchema;
	WideString fWProcName;
	int fProcType;
	__fastcall TMetaProcedure(char * Cat, char * Schema, char * ProcName, int ProcType);
	__fastcall TMetaProcedure(WideChar * Cat, WideChar * Schema, WideChar * ProcName, int ProcType);
	__fastcall virtual ~TMetaProcedure(void);
};


class DELPHICLASS TMetaProcedureParam;
class PASCALIMPLEMENTATION TMetaProcedureParam : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	TMetaProcedure* fMetaProcedure;
	AnsiString fParamName;
	AnsiString fDataTypeName;
	WideString fWParamName;
	WideString fWDataTypeName;
	Dbxopenodbcdbx3types::TSTMTParamType fParamType;
	short fDataType;
	short fDataSubtype;
	int fPrecision;
	short fScale;
	int fLength;
	short fNullable;
	short fPosition;
	__fastcall TMetaProcedureParam(char * ParamName);
	__fastcall TMetaProcedureParam(WideChar * ParamName);
	__fastcall virtual ~TMetaProcedureParam(void);
};


typedef DynamicArray<AnsiString >  TColumnNames;

typedef DynamicArray<Word >  TColumnTypes;

typedef DynamicArray<int >  TColumnPhLen;

typedef DynamicArray<Word >  TCursorColmnIndxs;

class DELPHICLASS TSqlCursorMetaData;
class PASCALIMPLEMENTATION TSqlCursorMetaData : public TDOSQLObject 
{
	typedef TDOSQLObject inherited;
	
protected:
	Classes::TStringList* fSqlCursorErrorMsg;
	bool fSupportWideString;
	TSQLMetaDataOdbc* fOwnerMetaData;
	TSqlConnectionOdbc* fSqlConnectionOdbc;
	TSqlDriverOdbc* fSqlDriverOdbc;
	void *fHStmt;
	int fRowNo;
	int fColumnCount;
	DynamicArray<AnsiString >  fColumnNames;
	DynamicArray<Word >  fColumnTypes;
	DynamicArray<int >  fColumnPhLen;
	int fStrLenLimit;
	int fCursorColmnCount;
	DynamicArray<Word >  fCursorColmnIndxs;
	AnsiString fMetaCatalogName;
	AnsiString fMetaSchemaName;
	AnsiString fMetaTableName;
	void __fastcall OdbcCheck(short OdbcCode, const AnsiString OdbcFunctionName);
	void __fastcall ParseTableNameBase(char * TableName);
	void __fastcall ParseTableName(char * CatalogName, char * SchemaName, char * TableName);
	bool __fastcall DescribeAllocBindString(Word ColumnNo, char * &BindString, int &BindInd, bool bIgnoreError = false);
	bool __fastcall DescribeAllocBindWString(Word ColumnNo, WideChar * &BindString, int &BindInd, bool bIgnoreError = false);
	bool __fastcall BindInteger(Word ColumnNo, int &BindInteger, Odbcapi::PSqlInteger BindInd, bool bIgnoreError = false);
	bool __fastcall BindSmallint(Word ColumnNo, short &BindSmallint, Odbcapi::PSqlInteger PBindInd, bool bIgnoreError = false);
	void __fastcall ClearMetaData(void);
	bool __fastcall GetPhysColumnNumber(Word &ColumnNumber);
	bool __fastcall IsPhysColumnStringType(Word PhysColumnNumber);
	bool __fastcall IsPhysColumnWideStringType(Word PhysColumnNumber);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	AnsiString __fastcall DbgColumnName(Word ColumnNumber);
	AnsiString __fastcall DbgPhysColumnName(Word PhysColumnNumber);
	void __fastcall remap(Word iPhCursor, Word iPhSrc, const AnsiString sNewName = "", int iNewType = 0x1, int iNewPhSize = 0x0);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	int __stdcall getColumnCount(Word &pColumns);
	int __stdcall getColumnNameLength(Word ColumnNumber, Word &pLen);
	int __stdcall getColumnName(Word ColumnNumber, char * pColumnName);
	int __stdcall getColumnType(Word ColumnNumber, Word &puType, Word &puSubType);
	int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength);
	int __stdcall getColumnPrecision(Word ColumnNumber, short &piPrecision);
	int __stdcall getColumnScale(Word ColumnNumber, short &piScale);
	int __stdcall isNullable(Word ColumnNumber, BOOL &Nullable);
	int __stdcall isAutoIncrement(Word ColumnNumber, BOOL &AutoIncr);
	int __stdcall isReadOnly(Word ColumnNumber, BOOL &ReadOnly);
	int __stdcall isSearchable(Word ColumnNumber, BOOL &Searchable);
	int __stdcall isBlobSizeExact(Word ColumnNumber, BOOL &IsExact);
	int __stdcall next(void);
	int __stdcall getString(Word ColumnNumber, char * Value, BOOL &IsBlank);
	int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getDouble(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBcd(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getTimeStamp(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getTime(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getDate(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBytes(Word ColumnNumber, void * Value, BOOL &IsBlank);
	int __stdcall getBlobSize(Word ColumnNumber, unsigned &iLength, BOOL &IsBlank);
	int __stdcall getBlob(Word ColumnNumber, void * Value, BOOL &IsBlank, unsigned iLength);
	int __stdcall getWideString(Word ColumnNumber, WideChar * Value, BOOL &IsBlank);
	int __stdcall getInt64(Word ColumnNumber, void * Value, BOOL &IsBlank);
	
public:
	__fastcall TSqlCursorMetaData(bool ASupportWideString, TSQLMetaDataOdbc* OwnerSqlMetaData);
	__fastcall virtual ~TSqlCursorMetaData(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TSqlCursorMetaDataTables;
class PASCALIMPLEMENTATION TSqlCursorMetaDataTables : public TSqlCursorMetaData 
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	Classes::TList* fTableList;
	TMetaTable* fMetaTableCurrent;
	bool fMergeNames;
	void __fastcall FetchTables(char * SearchCat, char * SearchSchema, char * SearchTableName, unsigned SearchTableType, bool bUnicode);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	HIDESBASE int __stdcall getColumnLength(Word ColumnNumber, unsigned &pLength);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataTables(TSqlConnectionOdbc* AConnection, bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataTables(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TSqlCursorMetaDataColumns;
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumns : public TSqlCursorMetaData 
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	Classes::TList* fTableList;
	Classes::TList* fColumnList;
	TMetaTable* fMetaTableCurrent;
	TMetaColumn* fMetaColumnCurrent;
	void __fastcall FetchColumns(char * SearchCatalogName, char * SearchSchemaName, char * SearchTableName, char * SearchColumnName, unsigned SearchColType);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataColumns(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataColumns(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TSqlCursorMetaDataIndexes;
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexes : public TSqlCursorMetaData 
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	Classes::TList* fIndexList;
	Classes::TList* fTableList;
	TMetaIndexColumn* fCurrentIndexColumn;
	void __fastcall FetchIndexes(char * SearchCatalogName, char * SearchSchemaName, char * SearchTableName, char * SearchIndexName, unsigned SearchIndexType, bool FetchColumns);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataIndexes(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataIndexes(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TSqlCursorMetaDataProcedures;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedures : public TSqlCursorMetaData 
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	Classes::TList* fProcList;
	TMetaProcedure* fMetaProcedureCurrent;
	void __fastcall FetchProcedures(char * ProcedureName, unsigned ProcType);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataProcedures(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataProcedures(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


class DELPHICLASS TSqlCursorMetaDataProcedureParams;
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedureParams : public TSqlCursorMetaData 
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	Classes::TList* fProcList;
	Classes::TList* fProcColumnList;
	TMetaProcedureParam* fMetaProcedureParamCurrent;
	void __fastcall FetchProcedureParams(char * SearchCatalogName, char * SearchSchemaName, char * SearchProcedureName, char * SearchParamName);
	virtual void __fastcall GetPhysColumnAnsiString(Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(Word PhysColumnNumber, WideChar * Value);
	HIDESBASE int __stdcall getLong(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall getShort(Word ColumnNumber, void * Value, BOOL &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataProcedureParams(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataProcedureParams(void);
private:
	void *__ISQLCursor25;	/* Dbxopenodbcdbx3types::ISQLCursor25 */
	
public:
	operator ISQLCursor25*(void) { return (ISQLCursor25*)&__ISQLCursor25; }
	
};


typedef Byte SqlByte;

typedef Byte *PSqlByte;

typedef __int64 *PSqlBigInt;

typedef double *PSqlDouble;

typedef Byte TArrayOfBytes[256];

typedef Byte *PArrayOfBytes;

typedef Word TArrayOfWords[129];

typedef Word *PArrayOfWords;

#pragma pack(push, 4)
struct TOdbcHostVarAddress
{
	
	union
	{
		struct 
		{
			Word *ptrWordsArray;
			
		};
		struct 
		{
			Byte *ptrBytesArray;
			
		};
		struct 
		{
			__int64 *ptrSqlBigInt;
			
		};
		struct 
		{
			Byte *ptrSqlByte;
			
		};
		struct 
		{
			tagTIMESTAMP_STRUCT *ptrOdbcTimestamp;
			
		};
		struct 
		{
			tagTIME_STRUCT *ptrSqlTimeStruct;
			
		};
		struct 
		{
			tagDATE_STRUCT *ptrSqlDateStruct;
			
		};
		struct 
		{
			double *ptrSqlDouble;
			
		};
		struct 
		{
			short *ptrSqlSmallint;
			
		};
		struct 
		{
			int *ptrSqlInteger;
			
		};
		struct 
		{
			WideChar *ptrWideChar;
			
		};
		struct 
		{
			char *ptrAnsiChar;
			
		};
		struct 
		{
			void *Ptr;
			
		};
		
	};
} ;
#pragma pack(pop)

struct TBlobChunkCollectionItem;
typedef TBlobChunkCollectionItem *PBlobChunkCollectionItem;

#pragma pack(push, 4)
struct TBlobChunkCollectionItem
{
	char *Data;
	int Size;
	TBlobChunkCollectionItem *NextFragment;
} ;
#pragma pack(pop)

class DELPHICLASS TBlobChunkCollection;
class PASCALIMPLEMENTATION TBlobChunkCollection : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
protected:
	TBlobChunkCollectionItem *fFragments;
	TBlobChunkCollectionItem *fFragmentLast;
	__int64 fSize;
	__int64 __stdcall GetSize(void);
	void __stdcall Read(void * &Buffer);
	__int64 __stdcall ReadBlobToVariant(/* out */ Variant &Data);
	__int64 __stdcall ReadBlobToStream(Dbxopenodbcinterface::_di_ISequentialStream Stream);
	void __stdcall Clear(void);
	
public:
	__fastcall virtual ~TBlobChunkCollection(void);
	void __fastcall AddFragment(void * Data, int DataSize);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TBlobChunkCollection(void) : System::TInterfacedObject() { }
	#pragma option pop
	
private:
	void *__IBlobChunkCollection;	/* Dbxopenodbcinterface::IBlobChunkCollection */
	
public:
	operator IBlobChunkCollection*(void) { return (IBlobChunkCollection*)&__IBlobChunkCollection; }
	
};


class PASCALIMPLEMENTATION TOdbcBindCol : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	Word fOdbcColNo;
	AnsiString fColName;
	short fColNameSize;
	short fSqlType;
	int fColSize;
	short fColScale;
	short fNullable;
	int *fColValueSizePtr;
	int fColValueSizeLoc;
	Word fDbxType;
	Word fDbxSubType;
	short fOdbcHostVarType;
	int fOdbcHostVarSize;
	TOdbcHostVarAddress fOdbcHostVarAddress;
	int fOdbcHostVarChunkSize;
	bool fOdbcLateBound;
	bool fIsFetched;
	bool fIsBuffer;
	TBlobChunkCollection* fBlobChunkCollection;
	short fReadOnly;
	__fastcall TOdbcBindCol(void);
	__fastcall virtual ~TOdbcBindCol(void);
};


#pragma pack(push, 1)
struct TOdbcBindParamRec
{
	
	union
	{
		struct 
		{
			__int64 OdbcParamValueBigInt;
			
		};
		struct 
		{
			Byte OdbcParamValueBit;
			
		};
		struct 
		{
			tagTIMESTAMP_STRUCT OdbcParamValueTimeStamp;
			
		};
		struct 
		{
			tagTIME_STRUCT OdbcParamValueTime;
			
		};
		struct 
		{
			tagDATE_STRUCT OdbcParamValueDate;
			
		};
		struct 
		{
			double OdbcParamValueDouble;
			
		};
		struct 
		{
			short OdbcParamValueShort;
			
		};
		struct 
		{
			int OdbcParamValueInteger;
			
		};
		struct 
		{
			WideChar OdbcParamValueWideString[129];
			
		};
		struct 
		{
			char OdbcParamValueString[256];
			
		};
		
	};
} ;
#pragma pack(pop)

class DELPHICLASS TOdbcBindParam;
class PASCALIMPLEMENTATION TOdbcBindParam : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	Word fDbxType;
	Word fDbxSubType;
	Word fOdbcParamNumber;
	int fOdbcInputOutputType;
	short fOdbcParamCType;
	short fOdbcParamSqlType;
	int fOdbcParamCbColDef;
	short fOdbcParamIbScale;
	int fOdbcParamLenOrInd;
	void *fBuffer;
	#pragma pack(push, 1)
	TOdbcBindParamRec fValue;
	#pragma pack(pop)
	
	void *fBindData;
	int fBindOutputBufferLength;
	
public:
	__fastcall TOdbcBindParam(void);
	__fastcall virtual ~TOdbcBindParam(void);
};


//-- var, const, procedure ---------------------------------------------------
#pragma error Unsupported symbol type (23, DbxOpenOdbc)
#define DbxOpenOdbcVersion "3.2012.07.24 Dev"
extern PACKAGE Dbxopenodbcinterface::TOptionSwitches cConnectionOptionsDefault[38];
extern PACKAGE TConnectionOptionsRestriction cConnectionOptionsRestrictions[38];
static const Shortint cConnectionTimeoutDefault = 0xffffffff;
static const Word cBlobChunkSizeMin = 0x100;
static const int cBlobChunkSizeMax = 0xfa000;
static const Word cBlobChunkSizeDefault = 0xa000;
static const Word cNetwrkPacketSizeDefault = 0x2000;
static const Word cNetwrkPacketSizeMin = 0x200;
static const Shortint coNetTimeoutDefault = 0xffffffff;
static const Shortint cLockModeDefault = 0xffffffff;
extern PACKAGE THostPlatform gHostPlatform;
extern PACKAGE int cBindMapDateTimeOdbc2[3];
extern PACKAGE int cBindMapDateTimeOdbc3[3];
static const Word dsMaxStringSize = 0x2000;
extern PACKAGE char cDecimalSeparatorDefault;
static const Word cOdbcReturnedConnectStringMax = 0x800;
static const Shortint cMaxBcdCharDigits = 0x40;
static const Word cStatementPerConnectionBlockCount = 0x200;
static const Shortint cMaxCacheConnectionCount = 0x10;
static const Shortint cMaxCacheNullConnectionCount = 0x10;
static const Byte cOdbcMaxColumnNameLenDefault = 0x80;
static const Byte cOdbcMaxTableNameLenDefault = 0x80;
static const Word cOdbcMaxCatalogNameLenDefault = 0x400;
static const Word cOdbcMaxSchemaNameLenDefault = 0x400;
static const Byte cOdbcMaxIdentifierLenDefault = 0x80;
static const Shortint DBX_SQL_NULL_DATA = 0x64;
static const Byte DBX_DRIVER_ERROR = 0xff;
static const Shortint SQL_SUCCESS = 0x0;
static const Shortint eSQLSystemView = 0x40;
extern PACKAGE bool IsDriverEmbedded;
extern PACKAGE int __stdcall getSQLDriverODBC(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern PACKAGE int __stdcall getSQLDriverODBCAW(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern PACKAGE void __fastcall CheckMaxLines(Classes::TStringList* List);

}	/* namespace Dbxopenodbc */
using namespace Dbxopenodbc;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxOpenOdbc
