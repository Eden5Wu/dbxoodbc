// CodeGear C++Builder
// Copyright (c) 1995, 2008 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbcasa.pas' rev: 20.00

#ifndef DbxopenodbcasaHPP
#define DbxopenodbcasaHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcasa
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const Word ASA_REGISTER_MESSAGE_CALLBACK = 0x770;
extern PACKAGE System::AnsiString AsaCallbackMessage;
extern PACKAGE System::Word WM_ASACALLBACK;
extern PACKAGE bool WM_ASACALLBACK_SUPPORTED;
extern PACKAGE int __stdcall ASA_MESSAGE_INIT(unsigned bWindow);
extern PACKAGE void __stdcall ASA_MESSAGE_CALLBACK(void * sqlca, char msg_type, int code, System::Word Len, char * msg);

}	/* namespace Dbxopenodbcasa */
using namespace Dbxopenodbcasa;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcasaHPP
