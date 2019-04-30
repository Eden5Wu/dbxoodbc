// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcASA.pas' rev: 6.00

#ifndef DbxOpenOdbcASAHPP
#define DbxOpenOdbcASAHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcasa
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
#pragma error Unsupported symbol type (23, DbxOpenOdbcASA)
static const Word ASA_REGISTER_MESSAGE_CALLBACK = 0x770;
extern PACKAGE AnsiString AsaCallbackMessage;
extern PACKAGE Word WM_ASACALLBACK;
extern PACKAGE bool WM_ASACALLBACK_SUPPORTED;
extern PACKAGE int __stdcall ASA_MESSAGE_INIT(unsigned bWindow);
extern PACKAGE void __stdcall ASA_MESSAGE_CALLBACK(void * sqlca, char msg_type, int code, Word Len, char * msg);

}	/* namespace Dbxopenodbcasa */
using namespace Dbxopenodbcasa;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxOpenOdbcASA
