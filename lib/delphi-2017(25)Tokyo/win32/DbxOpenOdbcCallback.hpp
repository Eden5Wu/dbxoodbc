// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcCallback.pas' rev: 32.00 (Windows)

#ifndef DbxopenodbccallbackHPP
#define DbxopenodbccallbackHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Data.DBXCommon.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbccallback
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef Data::Dbxcommon::TDBXTraceInfo TDBXTraceInfo;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 cTDBXTraceFlags_none = System::Int8(0x0);
static const System::Int8 cTDBXTraceFlags_Prepare = System::Int8(0x1);
static const System::Int8 cTDBXTraceFlags_Execute = System::Int8(0x2);
static const System::Int8 cTDBXTraceFlags_Error = System::Int8(0x4);
static const System::Int8 cTDBXTraceFlags_Command = System::Int8(0x8);
static const System::Int8 cTDBXTraceFlags_Connect = System::Int8(0x10);
static const System::Int8 cTDBXTraceFlags_Transact = System::Int8(0x20);
static const System::Int8 cTDBXTraceFlags_Blob = System::Int8(0x40);
static const System::Byte cTDBXTraceFlags_Misc = System::Byte(0x80);
static const System::Word cTDBXTraceFlags_Vendor = System::Word(0x100);
static const System::Word cTDBXTraceFlags_Parameter = System::Word(0x200);
static const System::Word cTDBXTraceFlags_Reader = System::Word(0x400);
static const System::Word cTDBXTraceFlags_DriverLoad = System::Word(0x800);
static const System::Word cTDBXTraceFlags_MetaData = System::Word(0x1000);
static const System::Word cTDBXTraceFlags_Driver = System::Word(0x2000);
static const System::Word cTDBXTraceFlags_Custom = System::Word(0x4000);
extern DELPHI_PACKAGE int __fastcall GetTraceFlag(const Data::Dbxcommon::TDBXTraceInfo &TraceInfo);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTraceFlagName(System::Word TraceFlag)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTraceFlagName(const Data::Dbxcommon::TDBXTraceInfo &TraceInfo)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTraceMessage(const Data::Dbxcommon::TDBXTraceInfo &TraceInfo);
extern DELPHI_PACKAGE void __fastcall DecodeTraceInfo(const Data::Dbxcommon::TDBXTraceInfo &TraceInfo, int &TraceFlag, System::UnicodeString &TraceFlagName, System::UnicodeString &TraceMessage);
}	/* namespace Dbxopenodbccallback */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCCALLBACK)
using namespace Dbxopenodbccallback;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbccallbackHPP
