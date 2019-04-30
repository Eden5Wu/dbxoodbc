// CodeGear C++Builder
// Copyright (c) 1995, 2008 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxobjectparser.pas' rev: 20.00

#ifndef DbxobjectparserHPP
#define DbxobjectparserHPP

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
#include <Regexpr.hpp>	// Pascal unit
#include <Dbxopenodbcinterface.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxobjectparser
{
//-- type declarations -------------------------------------------------------
typedef DynamicArray<int> TArrayOfInteger;

typedef TArrayOfInteger *PArrayOfInteger;

typedef StaticArray<bool, 3> TArrayOf3Boolean;

struct TObjectNameTemplateInfo;
typedef TObjectNameTemplateInfo *PObjectNameTemplateInfo;

struct TObjectNameTemplateInfo
{
	
public:
	System::UnicodeString sName;
	System::AnsiString sRegExpr;
	System::AnsiString QuoteTemplate;
	TArrayOfInteger *RegexpMathesIndexes;
	System::AnsiString FullNameTemplate;
	System::AnsiString CatalogTemplate;
	System::AnsiString SchemaTemplate;
	System::AnsiString ObjectTemplate;
	TArrayOf3Boolean RequiredParts;
	bool OneDelimiter;
	TObjectNameTemplateInfo *NextTemplate;
	System::AnsiString fEmptyCatalogTemplate;
	System::AnsiString fEmptySchemaTemplate;
	System::AnsiString fEmptyObjectTemplate;
};


typedef DynamicArray<TObjectNameTemplateInfo> TArrayOfTObjectNameTemplateInfo;

typedef DynamicArray<Regexpr::TRegExpr*> TArrayOfTRegExpr;

class DELPHICLASS TObjectNameParser;
class PASCALIMPLEMENTATION TObjectNameParser : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TArrayOfTObjectNameTemplateInfo fObjectNameTemplateInfo;
	TArrayOfTRegExpr fRegExpr;
	
public:
	__fastcall TObjectNameParser(PObjectNameTemplateInfo AObjectNameTemplateInfo, const System::AnsiString DbQuote, const System::AnsiString sRegExpNew);
	__fastcall virtual ~TObjectNameParser(void);
	PObjectNameTemplateInfo __fastcall DecodeObjectFullName(System::AnsiString ObjectFullName, System::AnsiString &sCatalogName, System::AnsiString &sSchemaName, System::AnsiString &sObjectName);
	System::AnsiString __fastcall EncodeObjectFullName(System::AnsiString CatalogName, System::AnsiString SchemaName, System::AnsiString ObjectName, PObjectNameTemplateInfo pTemplateInfo = (void *)(0x0));
	System::AnsiString __fastcall GetQuotedObjectName(System::AnsiString ObjectName);
};


//-- var, const, procedure ---------------------------------------------------
static const ShortInt idxLength = 0x0;
static const ShortInt idxCatalog = 0x1;
static const ShortInt idxSchema = 0x2;
static const ShortInt idxObject = 0x3;
extern PACKAGE StaticArray<int, 10> DefaultMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo DefaultObjectNameTemplateInfo;
extern PACKAGE StaticArray<int, 13> SQLServerMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo SQLServerObjectNameTemplateInfo;
extern PACKAGE StaticArray<int, 7> OracleMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo OracleObjectNameTemplateInfo;
extern PACKAGE StaticArray<int, 7> InformixMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo InformixObjectNameTemplateInfo;
extern PACKAGE StaticArray<int, 6> TextMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo TextObjectNameTemplateInfo;
extern PACKAGE StaticArray<PObjectNameTemplateInfo, 30> DbmsObjectNameTemplateInfo;
extern PACKAGE PObjectNameTemplateInfo __fastcall GetDbmsObjectNameTemplateInfo(Dbxopenodbcinterface::TDbmsType DbmsType);

}	/* namespace Dbxobjectparser */
using namespace Dbxobjectparser;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxobjectparserHPP
