// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbc.pas' rev: 31.00 (Windows)

#ifndef DbxopenodbcHPP
#define DbxopenodbcHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Datasnap.DSIntf.hpp>
#include <Data.FmtBcd.hpp>
#include <DbxOpenOdbcTypes.hpp>
#include <OdbcApi.hpp>
#include <DbxOpenOdbcDbx3Types.hpp>
#include <DbxOpenOdbcInterface.hpp>
#include <DbxOpenOdbcFuncs.hpp>
#include <DbxOpenOdbcUtils.hpp>
#include <DbxObjectParser.hpp>
#include <DbxOpenOdbcCallback.hpp>
#include <System.Types.hpp>
#include <DbxOpenOdbcTrace.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EDbxErrorCustom;
class DELPHICLASS EDbxOdbcWarning;
class DELPHICLASS EDbxError;
class DELPHICLASS EDbxOdbcError;
class DELPHICLASS EDbxNotSupported;
class DELPHICLASS EDbxInvalidCall;
class DELPHICLASS EDbxInternalError;
class DELPHICLASS EDbxInvalidParam;
struct SQLTRACEDesc30;
struct SQLTRACEDesc25;
struct TDbxHStmtNode;
struct TDbxConStmt;
struct TDbxConStmtInfo;
class DELPHICLASS TDOSQLObject;
class DELPHICLASS TSqlDriverOdbc;
class DELPHICLASS TSqlConnectionOdbc;
class DELPHICLASS TSqlCommandOdbc;
class DELPHICLASS TSQLMetaDataOdbc;
class DELPHICLASS TSqlCursorOdbc;
class DELPHICLASS TMetaTable;
class DELPHICLASS TMetaColumn;
class DELPHICLASS TMetaIndexColumn;
class DELPHICLASS TMetaProcedure;
class DELPHICLASS TMetaProcedureParam;
class DELPHICLASS TSqlCursorMetaData;
class DELPHICLASS TSqlCursorMetaDataTables;
class DELPHICLASS TSqlCursorMetaDataColumns;
class DELPHICLASS TSqlCursorMetaDataIndexes;
class DELPHICLASS TSqlCursorMetaDataProcedures;
class DELPHICLASS TSqlCursorMetaDataProcedureParams;
struct TOdbcHostVarAddress;
struct TBlobChunkCollectionItem;
class DELPHICLASS TBlobChunkCollection;
class DELPHICLASS TOdbcBindCol;
struct TOdbcBindParamRec;
class DELPHICLASS TOdbcBindParam;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxErrorCustom : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxErrorCustom(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxErrorCustom(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxErrorCustom(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxErrorCustom(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxErrorCustom(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxErrorCustom(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxErrorCustom(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxErrorCustom(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxErrorCustom(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxErrorCustom(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxErrorCustom(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxErrorCustom(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxErrorCustom(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxOdbcWarning : public EDbxErrorCustom
{
	typedef EDbxErrorCustom inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxOdbcWarning(const System::UnicodeString Msg) : EDbxErrorCustom(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxOdbcWarning(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxErrorCustom(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcWarning(NativeUInt Ident)/* overload */ : EDbxErrorCustom(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcWarning(System::PResStringRec ResStringRec)/* overload */ : EDbxErrorCustom(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcWarning(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxErrorCustom(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcWarning(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxOdbcWarning(const System::UnicodeString Msg, int AHelpContext) : EDbxErrorCustom(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOdbcWarning(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxErrorCustom(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcWarning(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcWarning(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcWarning(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcWarning(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxOdbcWarning(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxError : public EDbxErrorCustom
{
	typedef EDbxErrorCustom inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxError(const System::UnicodeString Msg) : EDbxErrorCustom(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxErrorCustom(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxError(NativeUInt Ident)/* overload */ : EDbxErrorCustom(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxError(System::PResStringRec ResStringRec)/* overload */ : EDbxErrorCustom(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxErrorCustom(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxError(const System::UnicodeString Msg, int AHelpContext) : EDbxErrorCustom(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxErrorCustom(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxError(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxErrorCustom(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxErrorCustom(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxOdbcError : public EDbxError
{
	typedef EDbxError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxOdbcError(const System::UnicodeString Msg) : EDbxError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxOdbcError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcError(NativeUInt Ident)/* overload */ : EDbxError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOdbcError(System::PResStringRec ResStringRec)/* overload */ : EDbxError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOdbcError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxOdbcError(const System::UnicodeString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOdbcError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcError(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOdbcError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOdbcError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxOdbcError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxNotSupported : public EDbxError
{
	typedef EDbxError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxNotSupported(const System::UnicodeString Msg) : EDbxError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxNotSupported(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxNotSupported(NativeUInt Ident)/* overload */ : EDbxError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxNotSupported(System::PResStringRec ResStringRec)/* overload */ : EDbxError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxNotSupported(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxNotSupported(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxNotSupported(const System::UnicodeString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxNotSupported(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxNotSupported(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxNotSupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxNotSupported(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxNotSupported(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxNotSupported(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxInvalidCall : public EDbxError
{
	typedef EDbxError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxInvalidCall(const System::UnicodeString Msg) : EDbxError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxInvalidCall(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidCall(NativeUInt Ident)/* overload */ : EDbxError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidCall(System::PResStringRec ResStringRec)/* overload */ : EDbxError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidCall(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidCall(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxInvalidCall(const System::UnicodeString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInvalidCall(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidCall(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidCall(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidCall(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidCall(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxInvalidCall(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxInternalError : public EDbxError
{
	typedef EDbxError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxInternalError(const System::UnicodeString Msg) : EDbxError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxInternalError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInternalError(NativeUInt Ident)/* overload */ : EDbxError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInternalError(System::PResStringRec ResStringRec)/* overload */ : EDbxError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInternalError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInternalError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxInternalError(const System::UnicodeString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInternalError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInternalError(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInternalError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInternalError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInternalError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxInternalError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxInvalidParam : public EDbxError
{
	typedef EDbxError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxInvalidParam(const System::UnicodeString Msg) : EDbxError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxInvalidParam(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDbxError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidParam(NativeUInt Ident)/* overload */ : EDbxError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxInvalidParam(System::PResStringRec ResStringRec)/* overload */ : EDbxError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidParam(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxInvalidParam(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDbxError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxInvalidParam(const System::UnicodeString Msg, int AHelpContext) : EDbxError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxInvalidParam(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDbxError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidParam(NativeUInt Ident, int AHelpContext)/* overload */ : EDbxError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxInvalidParam(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDbxError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidParam(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxInvalidParam(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDbxError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxInvalidParam(void) { }
	
};

#pragma pack(pop)

typedef SQLTRACEDesc30 *pSQLTRACEDesc30;

#pragma pack(push,1)
struct DECLSPEC_DRECORD SQLTRACEDesc30
{
public:
	System::StaticArray<System::WideChar, 1024> pszTrace;
	int eTraceCat;
	int ClientData;
	System::Word uTotalMsgLen;
};
#pragma pack(pop)


typedef SQLTRACEDesc25 *pSQLTRACEDesc25;

#pragma pack(push,1)
struct DECLSPEC_DRECORD SQLTRACEDesc25
{
public:
	System::StaticArray<char, 1024> pszTrace;
	int eTraceCat;
	int ClientData;
	System::Word uTotalMsgLen;
};
#pragma pack(pop)


enum DECLSPEC_DENUM Dbxopenodbc__9 : unsigned char { hpWindows, hpLinux, hpMACOS, hpCLR, hp32Bit, hp64bit };

typedef System::Set<Dbxopenodbc__9, Dbxopenodbc__9::hpWindows, Dbxopenodbc__9::hp64bit> THostPlatform;

enum DECLSPEC_DENUM TConnectionOptionRestriction : unsigned char { cor_connection_off, cor_ActiveCursors0, cor_driver_off };

typedef System::Set<TConnectionOptionRestriction, TConnectionOptionRestriction::cor_connection_off, TConnectionOptionRestriction::cor_driver_off> TConnectionOptionsRestriction;

typedef System::StaticArray<TConnectionOptionsRestriction, 38> TConnectionOptionsRestrictions;

enum DECLSPEC_DENUM TBindMapDateTimeOdbcIndexes : unsigned char { biDate, biTime, biDateTime };

typedef System::StaticArray<int, 3> TBindMapDateTimeOdbc;

typedef TBindMapDateTimeOdbc *PBindMapDateTimeOdbc;

typedef System::Classes::TList TDbxConStmtList;

typedef TDbxHStmtNode *PDbxHStmtNode;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TDbxHStmtNode
{
public:
	void *HStmt;
	TDbxHStmtNode *fPrevDbxHStmtNode;
	TDbxHStmtNode *fNextDbxHStmtNode;
};
#pragma pack(pop)


typedef System::DynamicArray<TDbxHStmtNode> TArrayOfDbxHStmtNode;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TDbxConStmt
{
public:
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
	TArrayOfDbxHStmtNode fBucketDbxHStmtNodes;
};
#pragma pack(pop)


typedef TDbxConStmt *PDbxConStmt;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TDbxConStmtInfo
{
public:
	TDbxConStmt *fDbxConStmt;
	TDbxHStmtNode *fDbxHStmtNode;
};
#pragma pack(pop)


typedef TDbxConStmtInfo *PDbxConStmtInfo;

enum DECLSPEC_DENUM TDOSQLObjectType : unsigned char { otDOSQLUnknown, otDOSQLDriver, otDOSQLConnection, otDOSQLCommand, otDOSQLMetaData, otDOSQLCursor, otDOSQLCursorMetadata };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDOSQLObject : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
protected:
	TDOSQLObjectType FObjectType;
	System::TObject* __stdcall SelfObj(void);
	
public:
	__property TDOSQLObjectType ObjectType = {read=FObjectType, nodefault};
public:
	/* TObject.Create */ inline __fastcall TDOSQLObject(void) : System::TInterfacedObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDOSQLObject(void) { }
	
private:
	void *__ISQLCommon;	// Dbxopenodbcdbx3types::ISQLCommon 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {F0611EF3-6083-43F2-A37F-B72958032EE1}
	operator Dbxopenodbcdbx3types::_di_ISQLCommon()
	{
		Dbxopenodbcdbx3types::_di_ISQLCommon intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCommon*(void) { return (Dbxopenodbcdbx3types::ISQLCommon*)&__ISQLCommon; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlDriverOdbc : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
protected:
	Odbcapi::TOdbcApiProxy* fOdbcApi;
	bool fUnicodeOdbcApiPriority;
	bool fIsUnicodeOdbcApi;
	int fDrvBlobSizeLimitK;
	System::Classes::TStringList* fOdbcErrorLines;
	void *fhEnv;
	int fNativeErrorCode;
	Odbcapi::TSqlState fSqlStateChars;
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
	void __fastcall OdbcCheck(short CheckCode, const System::AnsiString OdbcFunctionName, short HandleType, void * Handle, PDbxConStmt DbxConStmt, TSqlConnectionOdbc* Connection = (TSqlConnectionOdbc*)(0x0), TSqlCommandOdbc* Command = (TSqlCommandOdbc*)(0x0), TSqlCursorOdbc* Cursor = (TSqlCursorOdbc*)(0x0), int maxErrorCount = 0x0, int eTraceCat = 0x0);
	int __stdcall getSQLConnection(/* out */ Dbxopenodbcdbx3types::_di_ISQLConnection &pConn);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLDriverOption eDOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLDriverOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	bool __stdcall GetOdbcDrivers(System::WideString &ADriverList);
	
public:
	__fastcall virtual TSqlDriverOdbc(Odbcapi::TOdbcApiProxy* AOdbcApi, bool bIsUnicodeOdbcApi);
	__fastcall virtual ~TSqlDriverOdbc(void);
	void __fastcall Drivers(System::Classes::TStrings* DriverList);
private:
	void *__ISqlDriverOdbc;	// Dbxopenodbcinterface::ISqlDriverOdbc 
	void *__ISQLDriver;	// Dbxopenodbcdbx3types::ISQLDriver 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C623831B-3006-41F1-B151-08FB9F0E8942}
	operator Dbxopenodbcinterface::_di_ISqlDriverOdbc()
	{
		Dbxopenodbcinterface::_di_ISqlDriverOdbc intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcinterface::ISqlDriverOdbc*(void) { return (Dbxopenodbcinterface::ISqlDriverOdbc*)&__ISqlDriverOdbc; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {1E6C91FB-84B0-4E6D-AEC1-ABDF3939E300}
	operator Dbxopenodbcdbx3types::_di_ISQLDriver()
	{
		Dbxopenodbcdbx3types::_di_ISQLDriver intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLDriver*(void) { return (Dbxopenodbcdbx3types::ISQLDriver*)&__ISQLDriver; }
	#endif
	
};

#pragma pack(pop)

typedef System::TMetaClass* TSqlDriverOdbcClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlConnectionOdbc : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
protected:
	System::Classes::TStringList* fConnectionErrorLines;
	TSqlDriverOdbc* fOwnerDbxDriver;
	System::_di_IInterface fOwnerDbxDriverNew;
	Dbxopenodbcdbx3types::TSQLCallbackEvent fDbxTraceCallbackEven;
	int fDbxTraceClientData;
	bool fConnected;
	bool fSafeMode;
	bool fConnectionClosed;
	int fConnBlobSizeLimitK;
	void *fhCon;
	System::Word fStatementPerConnection;
	System::Classes::TList* fDbxConStmtList;
	int fDbxConStmtActive;
	int fCon0SqlHStmt;
	TDbxConStmt *fCurrDbxConStmt;
	bool fWantQuotedTableName;
	bool fSupportsDbxQuotation;
	bool fDbxMetadataQueryMode;
	System::AnsiString fOdbcConnectString;
	System::AnsiString fOdbcConnectStringHidePassword;
	System::AnsiString fConnConnectionString;
	System::AnsiString fOdbcReturnedConnectString;
	System::Word fOdbcMaxColumnNameLen;
	System::Word fOdbcMaxCatalogNameLen;
	System::Word fOdbcMaxSchemaNameLen;
	System::Word fOdbcMaxTableNameLen;
	System::Word fOdbcMaxIdentifierLen;
	System::AnsiString fDbmsName;
	Dbxopenodbcinterface::TDbmsType fDbmsType;
	System::AnsiString fDbmsVersionString;
	int fDbmsVersionMajor;
	int fDbmsVersionMinor;
	int fDbmsVersionRelease;
	int fDbmsVersionBuild;
	System::AnsiString fOdbcDriverName;
	Dbxopenodbcinterface::TOdbcDriverType fOdbcDriverType;
	System::AnsiString fOdbcDriverVersionString;
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
	System::AnsiString fCurrentCatalog;
	char fQuoteChar;
	System::WideChar fQuoteCharW;
	int fAutoCommitMode;
	bool fSupportsTransaction;
	bool fSupportsNestedTransactions;
	bool fSupportsTransactionMetadata;
	System::AnsiString fCurrentSchema;
	Dbxopenodbcinterface::TConnectionOptions fConnectionOptions;
	Dbxopenodbcinterface::TConnectionOptions fConnectionOptionsDrv;
	int fBlobChunkSize;
	int fNetwrkPacketSize;
	System::AnsiString fQualifiedName;
	int fNativeErrorCode;
	Odbcapi::TSqlState fSqlStateChars;
	System::AnsiString fDbxCatalog;
	System::AnsiString fOdbcCatalogPrefix;
	System::AnsiString fDbmsVersion;
	TSqlCommandOdbc* fLastStoredProc;
	Dbxobjectparser::TObjectNameParser* fObjectNameParser;
	Dbxobjectparser::TObjectNameParser* fObjectNameParserShort;
	int fOdbcIsolationLevel;
	bool fSupportsBlockRead;
	int fSqlHStmtAllocated;
	bool fCursorPreserved;
	int fActiveCursors;
	int fRowsAffected;
	TBindMapDateTimeOdbc *fBindMapDateTimeOdbc;
	int fConnectionTimeout;
	int fNetworkTimeout;
	int fLockMode;
	int fMDCase;
	char fDecimalSeparator;
	bool fPrepareSQL;
	bool __fastcall FindFreeConnection(/* out */ TDbxConStmtInfo &DbxConStmtInfo, int MaxStatementsPerConnection, bool bMetadataRead = false, bool bOnlyPreservedCursors = false);
	void __fastcall AllocHStmt(/* out */ void * &HStmt, PDbxConStmtInfo aDbxConStmtInfo = (PDbxConStmtInfo)(0x0), bool bMetadataRead = false);
	void __fastcall CheckTransactionSupport(void);
	void __fastcall CheckDbmsTransactionSupport(void);
	void __fastcall SynchronizeInTransaction(TDbxConStmt &DbxConStmt);
	void __fastcall CloneOdbcConnection(/* out */ TDbxConStmtInfo &DbxConStmtInfo, bool bSynchronizeTransaction = true);
	void __fastcall FreeHStmt(/* out */ void * &HStmt, PDbxConStmtInfo aDbxConStmtInfo = (PDbxConStmtInfo)(0x0));
	int __fastcall GetMetaDataOption(Dbxopenodbcdbx3types::TSQLMetaDataOption eDOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	PDbxConStmt __fastcall GetCurrentDbxConStmt(void)/* overload */;
	PDbxConStmt __fastcall GetCurrentDbxConStmt(/* out */ void * &HStmt)/* overload */;
	void * __fastcall GetCurrentConnectionHandle(void);
	void __fastcall OdbcCheck(short OdbcCode, const System::AnsiString OdbcFunctionName, PDbxConStmt DbxConStmt, int TraceCat = 0x0);
	int __fastcall RetrieveDriverName(void);
	int __fastcall RetrieveDbmsOptions(void);
	System::AnsiString __fastcall GetCatalog(void * aHConStmt = (void *)(0x0));
	void __fastcall GetCurrentCatalog(void * aHConStmt = (void *)(0x0));
	void __fastcall TransactionCheck(const TDbxConStmtInfo &DbxConStmtInfo);
	void __fastcall ClearConnectionOptions(void);
	void __fastcall SetCurrentDbxConStmt(PDbxConStmt aDbxConStmt);
	bool __fastcall SetLoginTimeout(void * hCon, int TimeoutSeconds);
	bool __fastcall SetNetworkTimeout(void * hCon, int TimeoutSeconds);
	Dbxopenodbcinterface::PConnectionOptions __fastcall GetDefaultConnectionOptions(void);
	void * __fastcall DecodeObjectFullName(System::AnsiString ObjectFullName, System::AnsiString &sCatalogName, System::AnsiString &sSchemaName, System::AnsiString &sObjectName, bool bStoredProcSpace = false);
	System::AnsiString __fastcall EncodeObjectFullName(System::AnsiString CatalogName, System::AnsiString SchemaName, System::AnsiString ObjectName, bool AQuoted = true, void * pTemplateInfo = (void *)(0x0));
	System::AnsiString __fastcall GetQuotedObjectName(const System::AnsiString ObjectName, bool bStoredProcSpace = false, bool AQuoted = true);
	System::AnsiString __fastcall GetUnquotedName(const System::AnsiString Name)/* overload */;
	System::WideString __fastcall GetUnquotedName(const System::WideString Name)/* overload */;
	int __fastcall GetUnquotedNameLen(const System::AnsiString Name);
	bool __fastcall ObjectIsStoredProc(const System::AnsiString Name);
	void __fastcall CreateRegExpObjectNameParser(Dbxobjectparser::PObjectNameTemplateInfo AObjectNameTemplateInfo, const System::AnsiString DbQuote, const System::AnsiString sRegExpNew = System::AnsiString());
	void __fastcall ReleaseRegExpObjectNameParser(void);
	void __fastcall DbxCallBackSendMsg(int TraceCat, const System::AnsiString Msg);
	void __fastcall DbxCallBackSendMsgFmt(int TraceCat, const System::AnsiString FmtMsg, const System::TVarRec *FmtArgs, const int FmtArgs_High);
	void __fastcall DoDestroy(bool bReinit);
	void __fastcall CheckHCon(void);
	bool __fastcall SetVendorLib(System::UnicodeString AVendorLib, bool UnicodePriority, TSqlDriverOdbcClass SqlDriverClass = 0x0);
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
	System::AnsiString __stdcall GetDbmsName(void);
	Dbxopenodbcinterface::TDbmsType __stdcall GetDbmsType(void);
	System::AnsiString __stdcall GetDbmsVersionString(void);
	int __stdcall GetDbmsVersionMajor(void);
	int __stdcall GetDbmsVersionMinor(void);
	int __stdcall GetDbmsVersionRelease(void);
	int __stdcall GetDbmsVersionBuild(void);
	char * __stdcall GetLastOdbcSqlState(void);
	System::AnsiString __stdcall GetOdbcConnectString(void);
	void __stdcall GetOdbcConnectStrings(System::Classes::TStrings* ConnectStringList);
	System::AnsiString __stdcall GetOdbcDriverName(void);
	Dbxopenodbcinterface::TOdbcDriverType __stdcall GetOdbcDriverType(void);
	System::AnsiString __stdcall GetOdbcDriverVersionString(void);
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
	System::_di_IInterface __stdcall GetOdbcApiIntf(void);
	char __stdcall GetDecimalSeparator(void);
	
public:
	__fastcall virtual TSqlConnectionOdbc(TSqlDriverOdbc* OwnerDbxDriver);
	__fastcall virtual ~TSqlConnectionOdbc(void);
	__property System::AnsiString DbmsName = {read=fDbmsName};
	__property Dbxopenodbcinterface::TDbmsType DbmsType = {read=fDbmsType, nodefault};
	__property int DbmsVersionMajor = {read=fDbmsVersionMajor, nodefault};
	__property System::AnsiString DbmsVersionString = {read=fDbmsVersion};
	__property char * LastOdbcSqlState = {read=GetLastOdbcSqlState};
	__property System::AnsiString OdbcConnectString = {read=fOdbcConnectString};
	__property System::AnsiString OdbcDriverName = {read=fOdbcDriverName};
	__property Dbxopenodbcinterface::TOdbcDriverType OdbcDriverType = {read=fOdbcDriverType, nodefault};
	__property int OdbcDriverVersionMajor = {read=fOdbcDriverVersionMajor, nodefault};
	__property System::AnsiString OdbcDriverVersionString = {read=fOdbcDriverVersionString};
private:
	void *__ISqlConnectionOdbc;	// Dbxopenodbcinterface::ISqlConnectionOdbc 
	void *__ISQLConnection25;	// Dbxopenodbcdbx3types::ISQLConnection25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {136DD9D1-9B9C-4355-9AEF-959662CB095E}
	operator Dbxopenodbcinterface::_di_ISqlConnectionOdbc()
	{
		Dbxopenodbcinterface::_di_ISqlConnectionOdbc intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcinterface::ISqlConnectionOdbc*(void) { return (Dbxopenodbcinterface::ISqlConnectionOdbc*)&__ISqlConnectionOdbc; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {D9F468A4-B887-423D-8ACC-2385CCFA3724}
	operator Dbxopenodbcdbx3types::_di_ISQLConnection25()
	{
		Dbxopenodbcdbx3types::_di_ISQLConnection25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLConnection25*(void) { return (Dbxopenodbcdbx3types::ISQLConnection25*)&__ISQLConnection25; }
	#endif
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM Dbxopenodbc__31 : unsigned char { scsStmtBinded, scsStmtExecuted, scsIsCursor };

typedef System::Set<Dbxopenodbc__31, Dbxopenodbc__31::scsStmtBinded, Dbxopenodbc__31::scsIsCursor> TStmtCommandStatus;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCommandOdbc : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
protected:
	TSqlConnectionOdbc* fOwnerDbxConnection;
	TSqlDriverOdbc* fOwnerDbxDriver;
	int fCommandBlobSizeLimitK;
	int fCommandRowSetSize;
	bool fSupportsBlockRead;
	System::AnsiString fSql;
	System::AnsiString fSqlPrepared;
	System::WideString fSqlW;
	System::WideString fSqlPreparedW;
	void *fHStmt;
	System::Classes::TList* fOdbcParamList;
	unsigned fOdbcRowsAffected;
	bool fTrimChar;
	bool fExecutedOk;
	bool fPreparedOnly;
	bool fSupportsMixedFetch;
	int fStoredProc;
	System::AnsiString fStoredProcPackName;
	bool fStoredProcWithResult;
	System::AnsiString fCatalogName;
	System::AnsiString fSchemaName;
	int fIsMoreResults;
	TStmtCommandStatus fStmtStatus;
	TDbxConStmtInfo fDbxConStmtInfo;
	void __fastcall AddError(System::Sysutils::Exception* eError);
	void __fastcall OdbcCheck(short OdbcCode, const System::AnsiString OdbcFunctionName, int eTraceCat = 0x0);
	System::AnsiString __fastcall BuildStoredProcSQL(void);
	void __fastcall CloseStmt(bool bClearParams = true, bool bFreeStmt = true);
	void __fastcall ClearParams(void);
	void * __fastcall GetConnectionHandle(void);
	void __fastcall DoAllocateStmt(void);
	void __fastcall DoUnprepareStmt(void);
	short __fastcall DoSQLMoreResults(void);
	void __fastcall DoAllocateParams(System::Word ParamCount);
	void __fastcall DoExpandParams(System::Word ParamCount);
	int __fastcall DoPrepare(char * SQL, System::Word ParamCount, bool UpdateParams, bool bPrepareSQL, bool bUseUnicodeOdbc);
	int __fastcall DoExecute(Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor, bool bUseUnicodeOdbc);
	int __fastcall DoExecuteImmediate(char * SQL, Dbxopenodbcdbx3types::_di_ISQLCursor25 &Cursor, bool bUseUnicodeOdbc);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, int ulValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCommandOption eSqlCommandOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall setParameter(System::Word ulParameter, System::Word ulChildPos, Dbxopenodbcdbx3types::TSTMTParamType eParamType, System::Word uLogType, System::Word uSubType, int iPrecision, int iScale, unsigned iLength, void * pBuffer, int bIsNull);
	int __stdcall getParameter(System::Word ParameterNumber, System::Word ulChildPos, void * Value, int iLength, int &IsBlank);
	int __stdcall prepare(char * SQL, System::Word ParamCount);
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
	void *__ISqlCommandOdbc;	// Dbxopenodbcinterface::ISqlCommandOdbc 
	void *__ISQLCommand25;	// Dbxopenodbcdbx3types::ISQLCommand25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {136DD9D1-9B9C-4355-9AEF-959662CB095F}
	operator Dbxopenodbcinterface::_di_ISqlCommandOdbc()
	{
		Dbxopenodbcinterface::_di_ISqlCommandOdbc intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcinterface::ISqlCommandOdbc*(void) { return (Dbxopenodbcinterface::ISqlCommandOdbc*)&__ISqlCommandOdbc; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {E0F02EBF-47F9-414E-9421-65EEEFAD9BD1}
	operator Dbxopenodbcdbx3types::_di_ISQLCommand25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCommand25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCommand25*(void) { return (Dbxopenodbcdbx3types::ISQLCommand25*)&__ISQLCommand25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSQLMetaDataOdbc : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
protected:
	bool fSupportWideString;
	TSqlConnectionOdbc* fOwnerDbxConnection;
	System::Classes::TStringList* fMetaDataErrorLines;
	System::AnsiString fMetaSchemaName;
	System::AnsiString fMetaCatalogName;
	System::AnsiString fMetaPackName;
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
	void *__ISQLMetaData25;	// Dbxopenodbcdbx3types::ISQLMetaData25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {92E75E89-97B2-4B53-99B3-B67280A54075}
	operator Dbxopenodbcdbx3types::_di_ISQLMetaData25()
	{
		Dbxopenodbcdbx3types::_di_ISQLMetaData25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLMetaData25*(void) { return (Dbxopenodbcdbx3types::ISQLMetaData25*)&__ISQLMetaData25; }
	#endif
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TSqlCursorOdbc : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
	
private:
	typedef System::DynamicArray<short> _TSqlCursorOdbc__1;
	
	
protected:
	TSqlCommandOdbc* fOwnerCommand;
	TSqlConnectionOdbc* fOwnerDbxConnection;
	TSqlDriverOdbc* fOwnerDbxDriver;
	double fRowNo;
	void *fHStmt;
	short fOdbcNumCols;
	System::Classes::TList* fOdbcBindList;
	int fCursorFetchRowCount;
	void *fOdbcBindBuffer;
	int fOdbcBindBufferRowSize;
	_TSqlCursorOdbc__1 fOdbcRowsStatus;
	int fOdbcBindBufferPos;
	int fOdbcRowsFetched;
	bool fOdbcLateBoundsFound;
	bool fOdbcColumnsFetchConsecutively;
	void __fastcall BindResultSet(void);
	void __fastcall OdbcCheck(short OdbcCode, const System::AnsiString OdbcFunctionName, int maxErrorCount = 0x0);
	void __fastcall DoFetchLongData(TOdbcBindCol* aOdbcBindCol, bool bAllowFragmentation, int FirstChunkSize);
	void __fastcall FetchLongData(System::Word ColNo, bool bAllowFragmentation = false, int FirstChunkSize = 0x0);
	void __fastcall DoFetchLateBoundData(TOdbcBindCol* aOdbcBindCol);
	void __fastcall FetchLateBoundData(System::Word ColNo);
	void __fastcall CheckFetchCacheColumns(System::Word ColNoLimit);
	void __fastcall AddError(System::Sysutils::Exception* eError);
	void __fastcall ClearCursor(bool bFreeStmt = false);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	int __stdcall getColumnCount(System::Word &pColumns);
	int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen);
	int __stdcall getColumnName(System::Word ColumnNumber, char * pColumnName);
	int __stdcall getColumnType(System::Word ColumnNumber, System::Word &puType, System::Word &puSubType);
	int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength);
	int __stdcall getColumnPrecision(System::Word ColumnNumber, short &piPrecision);
	int __stdcall getColumnScale(System::Word ColumnNumber, short &piScale);
	int __stdcall isNullable(System::Word ColumnNumber, System::LongBool &Nullable);
	int __stdcall isAutoIncrement(System::Word ColumnNumber, System::LongBool &AutoIncr);
	int __stdcall isReadOnly(System::Word ColumnNumber, System::LongBool &ReadOnly);
	int __stdcall isSearchable(System::Word ColumnNumber, System::LongBool &Searchable);
	int __stdcall isBlobSizeExact(System::Word ColumnNumber, System::LongBool &IsExact);
	int __stdcall next(void);
	int __stdcall getString(System::Word ColumnNumber, char * Value, System::LongBool &IsBlank);
	int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getDouble(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBcd(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getTimeStamp(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getTime(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getDate(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBytes(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBlobSize(System::Word ColumnNumber, unsigned &iLength, System::LongBool &IsBlank);
	int __stdcall getBlob(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank, unsigned iLength);
	
public:
	__fastcall TSqlCursorOdbc(TSqlCommandOdbc* OwnerCommand);
	__fastcall virtual ~TSqlCursorOdbc(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TMetaTable : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::AnsiString fCat;
	System::AnsiString fSchema;
	System::AnsiString fTableName;
	System::AnsiString fQualifiedTableName;
	System::AnsiString fRemarks;
	System::WideString fWCat;
	System::WideString fWSchema;
	System::WideString fWTableName;
	System::WideString fWQualifiedTableName;
	System::WideString fWRemarks;
	int fTableType;
	TMetaIndexColumn* fPrimaryKeyColumn1;
	System::Classes::TList* fIndexColumnList;
	__fastcall TMetaTable(TSqlConnectionOdbc* SqlConnectionOdbc, char * Cat, char * Schema, char * TableName, int TableType, char * Remarks);
	__fastcall TMetaTable(TSqlConnectionOdbc* SqlConnectionOdbc, System::WideChar * Cat, System::WideChar * Schema, System::WideChar * TableName, int TableType, System::WideChar * Remarks);
	__fastcall virtual ~TMetaTable(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMetaColumn : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMetaTable* fMetaTable;
	short fOrdinalPosition;
	System::AnsiString fColumnName;
	System::AnsiString fTypeName;
	System::AnsiString fDefaultValue;
	System::AnsiString fRemarks;
	System::WideString fWColumnName;
	System::WideString fWTypeName;
	System::WideString fWDefaultValue;
	System::WideString fWRemarks;
	int fLength;
	int fPrecision;
	short fDecimalScale;
	short fDbxType;
	short fDbxSubType;
	short fDbxNullable;
	short fDbxColumnType;
	__fastcall TMetaColumn(char * ColumnName, short OrdinalPosition, char * TypeName, char * DefaultValue, char * Remarks);
	__fastcall TMetaColumn(System::WideChar * ColumnName, short OrdinalPosition, System::WideChar * TypeName, System::WideChar * DefaultValue, System::WideChar * Remarks);
	__fastcall virtual ~TMetaColumn(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMetaIndexColumn : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMetaTable* fMetaTable;
	System::AnsiString fCatName;
	System::AnsiString fSchemaName;
	System::AnsiString fTableName;
	System::AnsiString fIndexName;
	System::AnsiString fIndexColumnName;
	System::AnsiString fFilter;
	System::WideString fWCatName;
	System::WideString fWSchemaName;
	System::WideString fWTableName;
	System::WideString fWIndexName;
	System::WideString fWIndexColumnName;
	System::WideString fWFilter;
	short fColumnPosition;
	short fIndexType;
	char fSortOrder;
	__fastcall TMetaIndexColumn(TMetaTable* MetaTable, char * CatName, char * SchemaName, char * TableName, char * IndexName, char * IndexColumnName);
	__fastcall TMetaIndexColumn(TMetaTable* MetaTable, System::WideChar * CatName, System::WideChar * SchemaName, System::WideChar * TableName, System::WideChar * IndexName, char * IndexColumnName);
	__fastcall virtual ~TMetaIndexColumn(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMetaProcedure : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::AnsiString fCat;
	System::AnsiString fSchema;
	System::AnsiString fProcName;
	System::WideString fWCat;
	System::WideString fWSchema;
	System::WideString fWProcName;
	int fProcType;
	__fastcall TMetaProcedure(char * Cat, char * Schema, char * ProcName, int ProcType);
	__fastcall TMetaProcedure(System::WideChar * Cat, System::WideChar * Schema, System::WideChar * ProcName, int ProcType);
	__fastcall virtual ~TMetaProcedure(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMetaProcedureParam : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMetaProcedure* fMetaProcedure;
	System::AnsiString fParamName;
	System::AnsiString fDataTypeName;
	System::WideString fWParamName;
	System::WideString fWDataTypeName;
	Dbxopenodbcdbx3types::TSTMTParamType fParamType;
	short fDataType;
	short fDataSubtype;
	int fPrecision;
	short fScale;
	int fLength;
	short fNullable;
	short fPosition;
	__fastcall TMetaProcedureParam(char * ParamName);
	__fastcall TMetaProcedureParam(System::WideChar * ParamName);
	__fastcall virtual ~TMetaProcedureParam(void);
};

#pragma pack(pop)

typedef System::DynamicArray<System::AnsiString> TColumnNames;

typedef System::DynamicArray<System::Word> TColumnTypes;

typedef System::DynamicArray<int> TColumnPhLen;

typedef TColumnTypes TCursorColmnIndxs;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaData : public TDOSQLObject
{
	typedef TDOSQLObject inherited;
	
protected:
	System::Classes::TStringList* fSqlCursorErrorMsg;
	bool fSupportWideString;
	TSQLMetaDataOdbc* fOwnerMetaData;
	TSqlConnectionOdbc* fSqlConnectionOdbc;
	TSqlDriverOdbc* fSqlDriverOdbc;
	void *fHStmt;
	int fRowNo;
	int fColumnCount;
	TColumnNames fColumnNames;
	TColumnTypes fColumnTypes;
	TColumnPhLen fColumnPhLen;
	int fStrLenLimit;
	int fCursorColmnCount;
	TColumnTypes fCursorColmnIndxs;
	System::AnsiString fMetaCatalogName;
	System::AnsiString fMetaSchemaName;
	System::AnsiString fMetaTableName;
	void __fastcall OdbcCheck(short OdbcCode, const System::AnsiString OdbcFunctionName);
	void __fastcall ParseTableNameBase(char * TableName);
	void __fastcall ParseTableName(char * CatalogName, char * SchemaName, char * TableName);
	bool __fastcall DescribeAllocBindString(System::Word ColumnNo, char * &BindString, int &BindInd, bool bIgnoreError = false);
	bool __fastcall DescribeAllocBindWString(System::Word ColumnNo, System::WideChar * &BindString, int &BindInd, bool bIgnoreError = false);
	bool __fastcall BindInteger(System::Word ColumnNo, int &BindInteger, Odbcapi::PSqlInteger BindInd, bool bIgnoreError = false);
	bool __fastcall BindSmallint(System::Word ColumnNo, short &BindSmallint, Odbcapi::PSqlInteger PBindInd, bool bIgnoreError = false);
	void __fastcall ClearMetaData(void);
	bool __fastcall GetPhysColumnNumber(System::Word &ColumnNumber);
	bool __fastcall IsPhysColumnStringType(System::Word PhysColumnNumber);
	bool __fastcall IsPhysColumnWideStringType(System::Word PhysColumnNumber);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	System::AnsiString __fastcall DbgColumnName(System::Word ColumnNumber);
	System::AnsiString __fastcall DbgPhysColumnName(System::Word PhysColumnNumber);
	void __fastcall remap(System::Word iPhCursor, System::Word iPhSrc, const System::AnsiString sNewName = System::AnsiString(), int iNewType = 0x1, int iNewPhSize = 0x0);
	int __stdcall SetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, int PropValue);
	int __stdcall GetOption(Dbxopenodbcdbx3types::TSQLCursorOption eOption, void * PropValue, short MaxLength, /* out */ short &iLength);
	int __stdcall getErrorMessage(char * Error);
	int __stdcall getErrorMessageLen(/* out */ short &ErrorLen);
	int __stdcall getColumnCount(System::Word &pColumns);
	int __stdcall getColumnNameLength(System::Word ColumnNumber, System::Word &pLen);
	int __stdcall getColumnName(System::Word ColumnNumber, char * pColumnName);
	int __stdcall getColumnType(System::Word ColumnNumber, System::Word &puType, System::Word &puSubType);
	int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength);
	int __stdcall getColumnPrecision(System::Word ColumnNumber, short &piPrecision);
	int __stdcall getColumnScale(System::Word ColumnNumber, short &piScale);
	int __stdcall isNullable(System::Word ColumnNumber, System::LongBool &Nullable);
	int __stdcall isAutoIncrement(System::Word ColumnNumber, System::LongBool &AutoIncr);
	int __stdcall isReadOnly(System::Word ColumnNumber, System::LongBool &ReadOnly);
	int __stdcall isSearchable(System::Word ColumnNumber, System::LongBool &Searchable);
	int __stdcall isBlobSizeExact(System::Word ColumnNumber, System::LongBool &IsExact);
	int __stdcall next(void);
	int __stdcall getString(System::Word ColumnNumber, char * Value, System::LongBool &IsBlank);
	int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getDouble(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBcd(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getTimeStamp(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getTime(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getDate(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBytes(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	int __stdcall getBlobSize(System::Word ColumnNumber, unsigned &iLength, System::LongBool &IsBlank);
	int __stdcall getBlob(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank, unsigned iLength);
	int __stdcall getWideString(System::Word ColumnNumber, System::WideChar * Value, System::LongBool &IsBlank);
	int __stdcall getInt64(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	
public:
	__fastcall TSqlCursorMetaData(bool ASupportWideString, TSQLMetaDataOdbc* OwnerSqlMetaData);
	__fastcall virtual ~TSqlCursorMetaData(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaDataTables : public TSqlCursorMetaData
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	System::Classes::TList* fTableList;
	TMetaTable* fMetaTableCurrent;
	bool fMergeNames;
	void __fastcall FetchTables(char * SearchCat, char * SearchSchema, char * SearchTableName, unsigned SearchTableType, bool bUnicode);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	HIDESBASE int __stdcall getColumnLength(System::Word ColumnNumber, unsigned &pLength);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataTables(TSqlConnectionOdbc* AConnection, bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataTables(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaDataColumns : public TSqlCursorMetaData
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	System::Classes::TList* fTableList;
	System::Classes::TList* fColumnList;
	TMetaTable* fMetaTableCurrent;
	TMetaColumn* fMetaColumnCurrent;
	void __fastcall FetchColumns(char * SearchCatalogName, char * SearchSchemaName, char * SearchTableName, char * SearchColumnName, unsigned SearchColType);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataColumns(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataColumns(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaDataIndexes : public TSqlCursorMetaData
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	System::Classes::TList* fIndexList;
	System::Classes::TList* fTableList;
	TMetaIndexColumn* fCurrentIndexColumn;
	void __fastcall FetchIndexes(char * SearchCatalogName, char * SearchSchemaName, char * SearchTableName, char * SearchIndexName, unsigned SearchIndexType, bool FetchColumns);
	void __fastcall Clear(void);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataIndexes(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataIndexes(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedures : public TSqlCursorMetaData
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	System::Classes::TList* fProcList;
	TMetaProcedure* fMetaProcedureCurrent;
	void __fastcall FetchProcedures(char * ProcedureName, unsigned ProcType);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataProcedures(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataProcedures(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSqlCursorMetaDataProcedureParams : public TSqlCursorMetaData
{
	typedef TSqlCursorMetaData inherited;
	
protected:
	System::Classes::TList* fProcList;
	System::Classes::TList* fProcColumnList;
	TMetaProcedureParam* fMetaProcedureParamCurrent;
	void __fastcall FetchProcedureParams(char * SearchCatalogName, char * SearchSchemaName, char * SearchProcedureName, char * SearchParamName);
	virtual void __fastcall GetPhysColumnAnsiString(System::Word PhysColumnNumber, char * Value);
	virtual void __fastcall GetPhysColumnWideString(System::Word PhysColumnNumber, System::WideChar * Value);
	HIDESBASE int __stdcall getLong(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall getShort(System::Word ColumnNumber, void * Value, System::LongBool &IsBlank);
	HIDESBASE int __stdcall next(void);
	
public:
	__fastcall TSqlCursorMetaDataProcedureParams(bool ASupportWideString, TSQLMetaDataOdbc* OwnerMetaData);
	__fastcall virtual ~TSqlCursorMetaDataProcedureParams(void);
private:
	void *__ISQLCursor25;	// Dbxopenodbcdbx3types::ISQLCursor25 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {C9B633C4-E245-45DF-9AC0-A2CB1A783ADA}
	operator Dbxopenodbcdbx3types::_di_ISQLCursor25()
	{
		Dbxopenodbcdbx3types::_di_ISQLCursor25 intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcdbx3types::ISQLCursor25*(void) { return (Dbxopenodbcdbx3types::ISQLCursor25*)&__ISQLCursor25; }
	#endif
	
};

#pragma pack(pop)

typedef System::Byte SqlByte;

typedef System::Byte *PSqlByte;

typedef __int64 *PSqlBigInt;

typedef double *PSqlDouble;

typedef System::StaticArray<System::Byte, 256> TArrayOfBytes;

typedef TArrayOfBytes *PArrayOfBytes;

typedef System::StaticArray<System::Word, 129> TArrayOfWords;

typedef TArrayOfWords *PArrayOfWords;

struct DECLSPEC_DRECORD TOdbcHostVarAddress
{
	
public:
	union
	{
		struct 
		{
			TArrayOfWords *ptrWordsArray;
		};
		struct 
		{
			TArrayOfBytes *ptrBytesArray;
		};
		struct 
		{
			__int64 *ptrSqlBigInt;
		};
		struct 
		{
			System::Byte *ptrSqlByte;
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
			System::WideChar *ptrWideChar;
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
};


typedef TBlobChunkCollectionItem *PBlobChunkCollectionItem;

struct DECLSPEC_DRECORD TBlobChunkCollectionItem
{
public:
	char *Data;
	int Size;
	TBlobChunkCollectionItem *NextFragment;
};


class PASCALIMPLEMENTATION TBlobChunkCollection : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
protected:
	TBlobChunkCollectionItem *fFragments;
	TBlobChunkCollectionItem *fFragmentLast;
	__int64 fSize;
	__int64 __stdcall GetSize(void);
	void __stdcall Read(void * &Buffer);
	__int64 __stdcall ReadBlobToVariant(/* out */ System::Variant &Data);
	__int64 __stdcall ReadBlobToStream(Dbxopenodbcinterface::_di_ISequentialStream Stream);
	void __stdcall Clear(void);
	
public:
	__fastcall virtual ~TBlobChunkCollection(void);
	void __fastcall AddFragment(void * Data, int DataSize);
public:
	/* TObject.Create */ inline __fastcall TBlobChunkCollection(void) : System::TInterfacedObject() { }
	
private:
	void *__IBlobChunkCollection;	// Dbxopenodbcinterface::IBlobChunkCollection 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {A4A8C6A2-786D-4DF7-938D-BC9301232BC8}
	operator Dbxopenodbcinterface::_di_IBlobChunkCollection()
	{
		Dbxopenodbcinterface::_di_IBlobChunkCollection intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Dbxopenodbcinterface::IBlobChunkCollection*(void) { return (Dbxopenodbcinterface::IBlobChunkCollection*)&__IBlobChunkCollection; }
	#endif
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOdbcBindCol : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Word fOdbcColNo;
	System::AnsiString fColName;
	short fColNameSize;
	short fSqlType;
	int fColSize;
	short fColScale;
	short fNullable;
	int *fColValueSizePtr;
	int fColValueSizeLoc;
	System::Word fDbxType;
	System::Word fDbxSubType;
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

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOdbcBindParamRec
{
	
public:
	union
	{
		struct 
		{
			__int64 OdbcParamValueBigInt;
		};
		struct 
		{
			System::Byte OdbcParamValueBit;
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
			System::StaticArray<System::WideChar, 129> OdbcParamValueWideString;
		};
		struct 
		{
			System::StaticArray<char, 256> OdbcParamValueString;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOdbcBindParam : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Word fDbxType;
	System::Word fDbxSubType;
	System::Word fOdbcParamNumber;
	int fOdbcInputOutputType;
	short fOdbcParamCType;
	short fOdbcParamSqlType;
	int fOdbcParamCbColDef;
	short fOdbcParamIbScale;
	int fOdbcParamLenOrInd;
	void *fBuffer;
	TOdbcBindParamRec fValue;
	void *fBindData;
	int fBindOutputBufferLength;
	
public:
	__fastcall TOdbcBindParam(void);
	__fastcall virtual ~TOdbcBindParam(void);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define DbxOpenOdbcVersion L"3.2012.07.24 Dev"
extern DELPHI_PACKAGE Dbxopenodbcinterface::TConnectionOptions cConnectionOptionsDefault;
extern DELPHI_PACKAGE TConnectionOptionsRestrictions cConnectionOptionsRestrictions;
static const System::Int8 cConnectionTimeoutDefault = System::Int8(-1);
static const System::Word cBlobChunkSizeMin = System::Word(0x100);
static const int cBlobChunkSizeMax = int(0xfa000);
static const System::Word cBlobChunkSizeDefault = System::Word(0xa000);
static const System::Word cNetwrkPacketSizeDefault = System::Word(0x2000);
static const System::Word cNetwrkPacketSizeMin = System::Word(0x200);
static const System::Int8 coNetTimeoutDefault = System::Int8(-1);
static const System::Int8 cLockModeDefault = System::Int8(-1);
extern DELPHI_PACKAGE THostPlatform gHostPlatform;
extern DELPHI_PACKAGE TBindMapDateTimeOdbc cBindMapDateTimeOdbc2;
extern DELPHI_PACKAGE TBindMapDateTimeOdbc cBindMapDateTimeOdbc3;
static const System::Word dsMaxStringSize = System::Word(0x2000);
extern DELPHI_PACKAGE char cDecimalSeparatorDefault;
static const System::Word cOdbcReturnedConnectStringMax = System::Word(0x800);
static const System::Int8 cMaxBcdCharDigits = System::Int8(0x40);
static const System::Word cStatementPerConnectionBlockCount = System::Word(0x200);
static const System::Int8 cMaxCacheConnectionCount = System::Int8(0x10);
static const System::Int8 cMaxCacheNullConnectionCount = System::Int8(0x10);
static const System::Byte cOdbcMaxColumnNameLenDefault = System::Byte(0x80);
static const System::Byte cOdbcMaxTableNameLenDefault = System::Byte(0x80);
static const System::Word cOdbcMaxCatalogNameLenDefault = System::Word(0x400);
static const System::Word cOdbcMaxSchemaNameLenDefault = System::Word(0x400);
static const System::Byte cOdbcMaxIdentifierLenDefault = System::Byte(0x80);
static const System::Int8 DBX_SQL_NULL_DATA = System::Int8(0x64);
static const System::Byte DBX_DRIVER_ERROR = System::Byte(0xff);
static const System::Int8 SQL_SUCCESS = System::Int8(0x0);
static const System::Int8 eSQLSystemView = System::Int8(0x40);
extern DELPHI_PACKAGE bool IsDriverEmbedded;
extern DELPHI_PACKAGE int __stdcall getSQLDriverODBC(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern DELPHI_PACKAGE int __stdcall getSQLDriverODBCAW(char * sVendorLib, char * sResourceFile, /* out */ void *Obj);
extern DELPHI_PACKAGE void __fastcall CheckMaxLines(System::Classes::TStringList* List);
}	/* namespace Dbxopenodbc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBC)
using namespace Dbxopenodbc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcHPP
