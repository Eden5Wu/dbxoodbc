// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxobjectparser.pas' rev: 11.00

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
typedef DynamicArray<int >  TArrayOfInteger;

typedef TArrayOfInteger *PArrayOfInteger;

typedef bool TArrayOf3Boolean[3];

struct TObjectNameTemplateInfo;
typedef TObjectNameTemplateInfo *PObjectNameTemplateInfo;

#pragma pack(push,4)
struct TObjectNameTemplateInfo
{
	
public:
	AnsiString sName;
	AnsiString sRegExpr;
	AnsiString QuoteTemplate;
	TArrayOfInteger *RegexpMathesIndexes;
	AnsiString FullNameTemplate;
	AnsiString CatalogTemplate;
	AnsiString SchemaTemplate;
	AnsiString ObjectTemplate;
	bool RequiredParts[3];
	bool OneDelimiter;
	TObjectNameTemplateInfo *NextTemplate;
	AnsiString fEmptyCatalogTemplate;
	AnsiString fEmptySchemaTemplate;
	AnsiString fEmptyObjectTemplate;
} ;
#pragma pack(pop)

typedef DynamicArray<TObjectNameTemplateInfo >  TArrayOfTObjectNameTemplateInfo;

typedef DynamicArray<Regexpr::TRegExpr* >  TArrayOfTRegExpr;

class DELPHICLASS TObjectNameParser;
class PASCALIMPLEMENTATION TObjectNameParser : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	DynamicArray<TObjectNameTemplateInfo >  fObjectNameTemplateInfo;
	DynamicArray<Regexpr::TRegExpr* >  fRegExpr;
	
public:
	__fastcall TObjectNameParser(PObjectNameTemplateInfo AObjectNameTemplateInfo, const AnsiString DbQuote, const AnsiString sRegExpNew);
	__fastcall virtual ~TObjectNameParser(void);
	PObjectNameTemplateInfo __fastcall DecodeObjectFullName(AnsiString ObjectFullName, AnsiString &sCatalogName, AnsiString &sSchemaName, AnsiString &sObjectName);
	AnsiString __fastcall EncodeObjectFullName(AnsiString CatalogName, AnsiString SchemaName, AnsiString ObjectName, PObjectNameTemplateInfo pTemplateInfo = (void *)(0x0));
	AnsiString __fastcall GetQuotedObjectName(AnsiString ObjectName);
};


//-- var, const, procedure ---------------------------------------------------
static const Shortint idxLength = 0x0;
static const Shortint idxCatalog = 0x1;
static const Shortint idxSchema = 0x2;
static const Shortint idxObject = 0x3;
extern PACKAGE int DefaultMathesIndexes[10];
extern PACKAGE TObjectNameTemplateInfo DefaultObjectNameTemplateInfo;
extern PACKAGE int SQLServerMathesIndexes[13];
extern PACKAGE TObjectNameTemplateInfo SQLServerObjectNameTemplateInfo;
extern PACKAGE int OracleMathesIndexes[7];
extern PACKAGE TObjectNameTemplateInfo OracleObjectNameTemplateInfo;
extern PACKAGE int InformixMathesIndexes[7];
extern PACKAGE TObjectNameTemplateInfo InformixObjectNameTemplateInfo;
extern PACKAGE int TextMathesIndexes[6];
extern PACKAGE TObjectNameTemplateInfo TextObjectNameTemplateInfo;
extern PACKAGE TObjectNameTemplateInfo *DbmsObjectNameTemplateInfo[30];
extern PACKAGE PObjectNameTemplateInfo __fastcall GetDbmsObjectNameTemplateInfo(Dbxopenodbcinterface::TDbmsType DbmsType);

}	/* namespace Dbxobjectparser */
using namespace Dbxobjectparser;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxobjectparser
