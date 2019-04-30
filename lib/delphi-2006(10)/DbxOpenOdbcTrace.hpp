// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbctrace.pas' rev: 10.00

#ifndef DbxopenodbctraceHPP
#define DbxopenodbctraceHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Dbxpress.hpp>	// Pascal unit
#include <Dbxopenodbcinterface.hpp>	// Pascal unit
#include <Odbcapi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbctrace
{
//-- type declarations -------------------------------------------------------
typedef Dbxpress::TTransactionDesc *pTTransactionDescBase;

typedef Dbxpress::TSTMTParamType TSTMTParamTypeBase;

typedef Dbxpress::TSQLCursorOption TSQLCursorOptionBase;

typedef AnsiString DbxOpenOdbcTrace__1[6];

typedef AnsiString DbxOpenOdbcTrace__2[43];

typedef AnsiString DbxOpenOdbcTrace__3[18];

typedef AnsiString DbxOpenOdbcTrace__4[19];

typedef AnsiString DbxOpenOdbcTrace__5[5];

typedef AnsiString DbxOpenOdbcTrace__6[3];

typedef AnsiString DbxOpenOdbcTrace__7[29];

typedef AnsiString DbxOpenOdbcTrace__8[30];

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE AnsiString cSQLDriverOption[6];
extern PACKAGE AnsiString cSQLConnectionOption[43];
extern PACKAGE AnsiString cSQLMetaDataOption[18];
extern PACKAGE AnsiString cSQLCommandOption[19];
extern PACKAGE AnsiString cSTMTParamType[5];
extern PACKAGE AnsiString cSQLCursorOption[3];
extern PACKAGE AnsiString cOdbcDriverType[29];
extern PACKAGE AnsiString cDbmsType[30];
extern PACKAGE void __fastcall OutputDebugString(const AnsiString S)/* overload */;
extern PACKAGE void __fastcall OutputDebugString(const WideString S)/* overload */;
extern PACKAGE AnsiString __fastcall BoolToStr(bool Value);
extern PACKAGE AnsiString __fastcall ValueToStr(System::TVarRec const * Value, const int Value_Size);
extern PACKAGE void __fastcall LogEnterProc(const AnsiString ProcName, const AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogEnterProc(const AnsiString ProcName, System::TVarRec const * Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogInfoProc(const AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogInfoProc(System::TVarRec const * Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogExitProc(const AnsiString ProcName, const AnsiString ExitInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExitProc(const AnsiString ProcName, System::TVarRec const * ExitInfo, const int ExitInfo_Size)/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const AnsiString ProcName, Sysutils::Exception* E, const AnsiString ExceptInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const AnsiString ProcName, Sysutils::Exception* E, System::TVarRec const * ExceptInfo, const int ExceptInfo_Size)/* overload */;
extern PACKAGE AnsiString __fastcall GetTransactionDescStr(Dbxpress::pTTransactionDesc TranID);

}	/* namespace Dbxopenodbctrace */
using namespace Dbxopenodbctrace;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbctrace
