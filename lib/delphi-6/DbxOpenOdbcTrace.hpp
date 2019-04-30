// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcTrace.pas' rev: 6.00

#ifndef DbxOpenOdbcTraceHPP
#define DbxOpenOdbcTraceHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <OdbcApi.hpp>	// Pascal unit
#include <DbxOpenOdbcInterface.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

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
extern PACKAGE AnsiString __fastcall ValueToStr(const System::TVarRec * Value, const int Value_Size);
extern PACKAGE void __fastcall LogEnterProc(const AnsiString ProcName, const AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogEnterProc(const AnsiString ProcName, const System::TVarRec * Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogInfoProc(const AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogInfoProc(const System::TVarRec * Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogExitProc(const AnsiString ProcName, const AnsiString ExitInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExitProc(const AnsiString ProcName, const System::TVarRec * ExitInfo, const int ExitInfo_Size)/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const AnsiString ProcName, Sysutils::Exception* E, const AnsiString ExceptInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const AnsiString ProcName, Sysutils::Exception* E, const System::TVarRec * ExceptInfo, const int ExceptInfo_Size)/* overload */;
extern PACKAGE AnsiString __fastcall GetTransactionDescStr(Dbxpress::pTTransactionDesc TranID);

}	/* namespace Dbxopenodbctrace */
using namespace Dbxopenodbctrace;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxOpenOdbcTrace
