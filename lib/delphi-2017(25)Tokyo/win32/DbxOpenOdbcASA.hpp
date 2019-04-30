// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcASA.pas' rev: 32.00 (Windows)

#ifndef DbxopenodbcasaHPP
#define DbxopenodbcasaHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.AnsiStrings.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcasa
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Word ASA_REGISTER_MESSAGE_CALLBACK = System::Word(0x770);
extern DELPHI_PACKAGE System::AnsiString AsaCallbackMessage;
extern DELPHI_PACKAGE System::Word WM_ASACALLBACK;
extern DELPHI_PACKAGE bool WM_ASACALLBACK_SUPPORTED;
extern DELPHI_PACKAGE int __stdcall ASA_MESSAGE_INIT(NativeUInt bWindow);
extern DELPHI_PACKAGE void __stdcall ASA_MESSAGE_CALLBACK(void * sqlca, char msg_type, int code, System::Word Len, char * msg);
}	/* namespace Dbxopenodbcasa */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCASA)
using namespace Dbxopenodbcasa;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcasaHPP
