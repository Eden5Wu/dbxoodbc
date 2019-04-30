// Borland C++ Builder
// Copyright (c) 1995, 2004 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbcasa.pas' rev: 6.00

#ifndef DbxopenodbcasaHPP
#define DbxopenodbcasaHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Sysutils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcasa
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
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
#endif	// Dbxopenodbcasa
