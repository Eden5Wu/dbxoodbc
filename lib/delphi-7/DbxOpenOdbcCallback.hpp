// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcCallback.pas' rev: 6.00

#ifndef DbxOpenOdbcCallbackHPP
#define DbxOpenOdbcCallbackHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysUtils.hpp>	// Pascal unit
#include <SqlExpr.hpp>	// Pascal unit
#include <DB.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbccallback
{
//-- type declarations -------------------------------------------------------
typedef Sqlexpr::SQLTRACEDesc *TDBXTraceInfo;

//-- var, const, procedure ---------------------------------------------------
#pragma error Unsupported symbol type (23, DbxOpenOdbcCallback)
static const Shortint cTDBXTraceFlags_none = 0x0;
static const Shortint cTDBXTraceFlags_Prepare = 0x1;
static const Shortint cTDBXTraceFlags_Execute = 0x2;
static const Shortint cTDBXTraceFlags_Error = 0x4;
static const Shortint cTDBXTraceFlags_Command = 0x8;
static const Shortint cTDBXTraceFlags_Connect = 0x10;
static const Shortint cTDBXTraceFlags_Transact = 0x20;
static const Shortint cTDBXTraceFlags_Blob = 0x40;
static const Byte cTDBXTraceFlags_Misc = 0x80;
static const Word cTDBXTraceFlags_Vendor = 0x100;
static const Word cTDBXTraceFlags_Parameter = 0x200;
static const Word cTDBXTraceFlags_Reader = 0x400;
static const Word cTDBXTraceFlags_DriverLoad = 0x800;
static const Word cTDBXTraceFlags_MetaData = 0x1000;
static const Word cTDBXTraceFlags_Driver = 0x2000;
static const Word cTDBXTraceFlags_Custom = 0x4000;
extern PACKAGE int __fastcall GetTraceFlag(const Sqlexpr::pSQLTRACEDesc TraceInfo);
extern PACKAGE AnsiString __fastcall GetTraceFlagName(Word TraceFlag)/* overload */;
extern PACKAGE AnsiString __fastcall GetTraceFlagName(const Sqlexpr::pSQLTRACEDesc TraceInfo)/* overload */;
extern PACKAGE AnsiString __fastcall GetTraceMessage(const Sqlexpr::pSQLTRACEDesc TraceInfo);
extern PACKAGE void __fastcall DecodeTraceInfo(const Sqlexpr::pSQLTRACEDesc TraceInfo, int &TraceFlag, AnsiString &TraceFlagName, AnsiString &TraceMessage);

}	/* namespace Dbxopenodbccallback */
using namespace Dbxopenodbccallback;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxOpenOdbcCallback
