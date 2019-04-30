// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcCallback.pas' rev: 22.00

#ifndef DbxopenodbccallbackHPP
#define DbxopenodbccallbackHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <DBXCommon.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbccallback
{
//-- type declarations -------------------------------------------------------
typedef Dbxcommon::TDBXTraceInfo TDBXTraceInfo;

//-- var, const, procedure ---------------------------------------------------
static const System::ShortInt cTDBXTraceFlags_none = 0x0;
static const System::ShortInt cTDBXTraceFlags_Prepare = 0x1;
static const System::ShortInt cTDBXTraceFlags_Execute = 0x2;
static const System::ShortInt cTDBXTraceFlags_Error = 0x4;
static const System::ShortInt cTDBXTraceFlags_Command = 0x8;
static const System::ShortInt cTDBXTraceFlags_Connect = 0x10;
static const System::ShortInt cTDBXTraceFlags_Transact = 0x20;
static const System::ShortInt cTDBXTraceFlags_Blob = 0x40;
static const System::Byte cTDBXTraceFlags_Misc = 0x80;
static const System::Word cTDBXTraceFlags_Vendor = 0x100;
static const System::Word cTDBXTraceFlags_Parameter = 0x200;
static const System::Word cTDBXTraceFlags_Reader = 0x400;
static const System::Word cTDBXTraceFlags_DriverLoad = 0x800;
static const System::Word cTDBXTraceFlags_MetaData = 0x1000;
static const System::Word cTDBXTraceFlags_Driver = 0x2000;
static const System::Word cTDBXTraceFlags_Custom = 0x4000;
extern PACKAGE int __fastcall GetTraceFlag(const Dbxcommon::TDBXTraceInfo &TraceInfo);
extern PACKAGE System::UnicodeString __fastcall GetTraceFlagName(System::Word TraceFlag)/* overload */;
extern PACKAGE System::UnicodeString __fastcall GetTraceFlagName(const Dbxcommon::TDBXTraceInfo &TraceInfo)/* overload */;
extern PACKAGE System::UnicodeString __fastcall GetTraceMessage(const Dbxcommon::TDBXTraceInfo &TraceInfo);
extern PACKAGE void __fastcall DecodeTraceInfo(const Dbxcommon::TDBXTraceInfo &TraceInfo, int &TraceFlag, System::UnicodeString &TraceFlagName, System::UnicodeString &TraceMessage);

}	/* namespace Dbxopenodbccallback */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Dbxopenodbccallback;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbccallbackHPP
