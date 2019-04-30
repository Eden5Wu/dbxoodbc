// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx23fix.pas' rev: 10.00

#ifndef Dbx23fixHPP
#define Dbx23fixHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Dbclient.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Dbcommon.hpp>	// Pascal unit
#include <Dbxpress.hpp>	// Pascal unit
#include <Sqlexpr.hpp>	// Pascal unit
#include <Fmtbcd.hpp>	// Pascal unit
#include <Provider.hpp>	// Pascal unit
#include <Sqlconst.hpp>	// Pascal unit
#include <Variants.hpp>	// Pascal unit
#include <Dsintf.hpp>	// Pascal unit
#include <Dbconsts.hpp>	// Pascal unit
#include <Sqltimst.hpp>	// Pascal unit
#include <Maskutils.hpp>	// Pascal unit
#include <Midconst.hpp>	// Pascal unit
#include <Typinfo.hpp>	// Pascal unit

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
extern PACKAGE bool bFixedSqlExpr;
extern PACKAGE bool bFixedUnicode;

}	/* namespace Dbx23fix */
using namespace Dbx23fix;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx23fix
