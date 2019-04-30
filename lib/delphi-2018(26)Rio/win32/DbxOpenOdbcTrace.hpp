// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcTrace.pas' rev: 33.00 (Windows)

#ifndef DbxopenodbctraceHPP
#define DbxopenodbctraceHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <DbxOpenOdbcTypes.hpp>
#include <DbxOpenOdbcDbx3Types.hpp>
#include <DbxOpenOdbcInterface.hpp>
#include <OdbcApi.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbctrace
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef Dbxopenodbcdbx3types::pTTransactionDesc pTTransactionDescBase;

typedef Dbxopenodbcdbx3types::TSTMTParamType TSTMTParamTypeBase;

typedef Dbxopenodbcdbx3types::TSQLCursorOption TSQLCursorOptionBase;

typedef System::StaticArray<System::AnsiString, 6> Dbxopenodbctrace__1;

typedef System::StaticArray<System::AnsiString, 43> Dbxopenodbctrace__2;

typedef System::StaticArray<System::AnsiString, 18> Dbxopenodbctrace__3;

typedef System::StaticArray<System::AnsiString, 19> Dbxopenodbctrace__4;

typedef System::StaticArray<System::AnsiString, 5> Dbxopenodbctrace__5;

typedef System::StaticArray<System::AnsiString, 3> Dbxopenodbctrace__6;

typedef System::StaticArray<System::AnsiString, 29> Dbxopenodbctrace__7;

typedef System::StaticArray<System::AnsiString, 30> Dbxopenodbctrace__8;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Dbxopenodbctrace__1 cSQLDriverOption;
extern DELPHI_PACKAGE Dbxopenodbctrace__2 cSQLConnectionOption;
extern DELPHI_PACKAGE Dbxopenodbctrace__3 cSQLMetaDataOption;
extern DELPHI_PACKAGE Dbxopenodbctrace__4 cSQLCommandOption;
extern DELPHI_PACKAGE Dbxopenodbctrace__5 cSTMTParamType;
extern DELPHI_PACKAGE Dbxopenodbctrace__6 cSQLCursorOption;
extern DELPHI_PACKAGE Dbxopenodbctrace__7 cOdbcDriverType;
extern DELPHI_PACKAGE Dbxopenodbctrace__8 cDbmsType;
extern DELPHI_PACKAGE void __fastcall OutputDebugString(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall OutputDebugString(const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall OutputDebugString(const System::WideString S)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall BoolToStr(bool Value);
extern DELPHI_PACKAGE System::AnsiString __fastcall ValueToStr(const System::TVarRec *Value, const int Value_High);
extern DELPHI_PACKAGE void __fastcall LogEnterProc(const System::AnsiString ProcName, const System::AnsiString Params = System::AnsiString())/* overload */;
extern DELPHI_PACKAGE void __fastcall LogEnterProc(const System::AnsiString ProcName, const System::TVarRec *Params, const int Params_High)/* overload */;
extern DELPHI_PACKAGE void __fastcall LogInfoProc(const System::AnsiString Params = System::AnsiString())/* overload */;
extern DELPHI_PACKAGE void __fastcall LogInfoProc(const System::TVarRec *Params, const int Params_High)/* overload */;
extern DELPHI_PACKAGE void __fastcall LogExitProc(const System::AnsiString ProcName, const System::AnsiString ExitInfo = System::AnsiString())/* overload */;
extern DELPHI_PACKAGE void __fastcall LogExitProc(const System::AnsiString ProcName, const System::TVarRec *ExitInfo, const int ExitInfo_High)/* overload */;
extern DELPHI_PACKAGE void __fastcall LogExceptProc(const System::AnsiString ProcName, System::Sysutils::Exception* E, const System::AnsiString ExceptInfo = System::AnsiString())/* overload */;
extern DELPHI_PACKAGE void __fastcall LogExceptProc(const System::AnsiString ProcName, System::Sysutils::Exception* E, const System::TVarRec *ExceptInfo, const int ExceptInfo_High)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall GetTransactionDescStr(Dbxopenodbcdbx3types::pTTransactionDesc TranID);
}	/* namespace Dbxopenodbctrace */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCTRACE)
using namespace Dbxopenodbctrace;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbctraceHPP
