// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcTrace.pas' rev: 22.00

#ifndef DbxopenodbctraceHPP
#define DbxopenodbctraceHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <DbxOpenOdbcTypes.hpp>	// Pascal unit
#include <DbxOpenOdbcDbx3Types.hpp>	// Pascal unit
#include <DbxOpenOdbcInterface.hpp>	// Pascal unit
#include <OdbcApi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbctrace
{
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
extern PACKAGE Dbxopenodbctrace__1 cSQLDriverOption;
extern PACKAGE Dbxopenodbctrace__2 cSQLConnectionOption;
extern PACKAGE Dbxopenodbctrace__3 cSQLMetaDataOption;
extern PACKAGE Dbxopenodbctrace__4 cSQLCommandOption;
extern PACKAGE Dbxopenodbctrace__5 cSTMTParamType;
extern PACKAGE Dbxopenodbctrace__6 cSQLCursorOption;
extern PACKAGE Dbxopenodbctrace__7 cOdbcDriverType;
extern PACKAGE Dbxopenodbctrace__8 cDbmsType;
extern PACKAGE void __fastcall OutputDebugString(const System::UnicodeString S)/* overload */;
extern PACKAGE void __fastcall OutputDebugString(const System::AnsiString S)/* overload */;
extern PACKAGE void __fastcall OutputDebugString(const System::WideString S)/* overload */;
extern PACKAGE System::AnsiString __fastcall BoolToStr(bool Value);
extern PACKAGE System::AnsiString __fastcall ValueToStr(System::TVarRec const *Value, const int Value_Size);
extern PACKAGE void __fastcall LogEnterProc(const System::AnsiString ProcName, const System::AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogEnterProc(const System::AnsiString ProcName, System::TVarRec const *Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogInfoProc(const System::AnsiString Params = "")/* overload */;
extern PACKAGE void __fastcall LogInfoProc(System::TVarRec const *Params, const int Params_Size)/* overload */;
extern PACKAGE void __fastcall LogExitProc(const System::AnsiString ProcName, const System::AnsiString ExitInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExitProc(const System::AnsiString ProcName, System::TVarRec const *ExitInfo, const int ExitInfo_Size)/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const System::AnsiString ProcName, Sysutils::Exception* E, const System::AnsiString ExceptInfo = "")/* overload */;
extern PACKAGE void __fastcall LogExceptProc(const System::AnsiString ProcName, Sysutils::Exception* E, System::TVarRec const *ExceptInfo, const int ExceptInfo_Size)/* overload */;
extern PACKAGE System::AnsiString __fastcall GetTransactionDescStr(Dbxopenodbcdbx3types::pTTransactionDesc TranID);

}	/* namespace Dbxopenodbctrace */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Dbxopenodbctrace;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbctraceHPP
