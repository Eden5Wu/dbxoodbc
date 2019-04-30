// CodeGear C++Builder
// Copyright (c) 1995, 2011 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxObjectParser.pas' rev: 23.00 (Win32)

#ifndef DbxobjectparserHPP
#define DbxobjectparserHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <RegExpr.hpp>	// Pascal unit
#include <DbxOpenOdbcInterface.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxobjectparser
{
//-- type declarations -------------------------------------------------------
typedef System::DynamicArray<int> TArrayOfInteger;

typedef TArrayOfInteger *PArrayOfInteger;

typedef System::StaticArray<bool, 3> TArrayOf3Boolean;

struct TObjectNameTemplateInfo;
typedef TObjectNameTemplateInfo *PObjectNameTemplateInfo;

struct DECLSPEC_DRECORD TObjectNameTemplateInfo
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


typedef System::DynamicArray<TObjectNameTemplateInfo> TArrayOfTObjectNameTemplateInfo;

typedef System::DynamicArray<Regexpr::TRegExpr*> TArrayOfTRegExpr;

class DELPHICLASS TObjectNameParser;
#pragma pack(push,4)
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
	System::AnsiString __fastcall EncodeObjectFullName(System::AnsiString CatalogName, System::AnsiString SchemaName, System::AnsiString ObjectName, PObjectNameTemplateInfo pTemplateInfo = (PObjectNameTemplateInfo)(0x0));
	System::AnsiString __fastcall GetQuotedObjectName(System::AnsiString ObjectName);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 idxLength = System::Int8(0x0);
static const System::Int8 idxCatalog = System::Int8(0x1);
static const System::Int8 idxSchema = System::Int8(0x2);
static const System::Int8 idxObject = System::Int8(0x3);
extern PACKAGE System::StaticArray<int, 10> DefaultMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo DefaultObjectNameTemplateInfo;
extern PACKAGE System::StaticArray<int, 13> SQLServerMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo SQLServerObjectNameTemplateInfo;
extern PACKAGE System::StaticArray<int, 7> OracleMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo OracleObjectNameTemplateInfo;
extern PACKAGE System::StaticArray<int, 7> InformixMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo InformixObjectNameTemplateInfo;
extern PACKAGE System::StaticArray<int, 6> TextMathesIndexes;
extern PACKAGE TObjectNameTemplateInfo TextObjectNameTemplateInfo;
extern PACKAGE System::StaticArray<PObjectNameTemplateInfo, 30> DbmsObjectNameTemplateInfo;
extern PACKAGE PObjectNameTemplateInfo __fastcall GetDbmsObjectNameTemplateInfo(Dbxopenodbcinterface::TDbmsType DbmsType);

}	/* namespace Dbxobjectparser */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOBJECTPARSER)
using namespace Dbxobjectparser;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxobjectparserHPP
