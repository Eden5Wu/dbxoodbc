// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx23Fix.pas' rev: 6.00

#ifndef Dbx23FixHPP
#define Dbx23FixHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <TypInfo.hpp>	// Pascal unit
#include <MidConst.hpp>	// Pascal unit
#include <MaskUtils.hpp>	// Pascal unit
#include <SqlTimSt.hpp>	// Pascal unit
#include <DBConsts.hpp>	// Pascal unit
#include <DSIntf.hpp>	// Pascal unit
#include <Variants.hpp>	// Pascal unit
#include <SqlConst.hpp>	// Pascal unit
#include <Provider.hpp>	// Pascal unit
#include <FMTBcd.hpp>	// Pascal unit
#include <SqlExpr.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <DBCommon.hpp>	// Pascal unit
#include <DB.hpp>	// Pascal unit
#include <DBClient.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbx23fix
{
//-- type declarations -------------------------------------------------------
typedef TSQLStoredProc TSQLStoredProcBase;
;

class DELPHICLASS TSQLStoredProc;
class PASCALIMPLEMENTATION TSQLStoredProc : public Sqlexpr::TSQLStoredProc 
{
	typedef Sqlexpr::TSQLStoredProc inherited;
	
public:
	virtual void __fastcall PrepareStatement(void);
public:
	#pragma option push -w-inl
	/* TSQLStoredProc.Create */ inline __fastcall virtual TSQLStoredProc(Classes::TComponent* AOwner) : Sqlexpr::TSQLStoredProc(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TCustomSQLDataSet.Destroy */ inline __fastcall virtual ~TSQLStoredProc(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
#pragma error Unsupported symbol type (23, Dbx23Fix)
extern PACKAGE bool bFixedSqlExpr;
extern PACKAGE bool bFixedUnicode;

}	/* namespace Dbx23fix */
using namespace Dbx23fix;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx23Fix
