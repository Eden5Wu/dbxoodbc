// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Regexpr.pas' rev: 21.00

#ifndef RegexprHPP
#define RegexprHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Regexpr
{
//-- type declarations -------------------------------------------------------
typedef char * PRegExprChar;

typedef System::AnsiString RegExprString;

typedef char REChar;

typedef char TREOp;

typedef char *PREOp;

typedef int TRENextOff;

typedef int *PRENextOff;

typedef int TREBracesArg;

typedef int *PREBracesArg;

typedef char __fastcall (__closure *TRegExprInvertCaseFunction)(const char Ch);

typedef Set<char, 0, 255>  TSetOfREChar;

typedef TSetOfREChar *PSetOfREChar;

class DELPHICLASS TRegExpr;
typedef System::UnicodeString __fastcall (__closure *TRegExprReplaceFunction)(TRegExpr* ARegExpr);

class PASCALIMPLEMENTATION TRegExpr : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	StaticArray<char *, 32> startp;
	StaticArray<char *, 32> endp;
	StaticArray<int, 10> LoopStack;
	int LoopStackIdx;
	char regstart;
	char reganch;
	char *regmust;
	int regmlen;
	TSetOfREChar FirstCharSet;
	char *reginput;
	char *fInputStart;
	char *fInputEnd;
	char *regparse;
	int regnpar;
	System::WideChar regdummy;
	char *regcode;
	int regsize;
	char *regexpbeg;
	bool fExprIsCompiled;
	char *programm;
	char *fExpression;
	char *fInputString;
	int fLastError;
	int fModifiers;
	int fCompModifiers;
	int fProgModifiers;
	System::AnsiString fSpaceChars;
	System::AnsiString fWordChars;
	TRegExprInvertCaseFunction fInvertCase;
	System::AnsiString fLineSeparators;
	bool fLinePairedSeparatorAssigned;
	char fLinePairedSeparatorHead;
	char fLinePairedSeparatorTail;
	Set<char, 0, 255>  fLineSeparatorsSet;
	void __fastcall InvalidateProgramm(void);
	bool __fastcall IsProgrammOk(void);
	System::AnsiString __fastcall GetExpression(void);
	void __fastcall SetExpression(const System::AnsiString s);
	System::AnsiString __fastcall GetModifierStr(void);
	__classmethod bool __fastcall ParseModifiersStr(const System::AnsiString AModifiers, int &AModifiersInt);
	void __fastcall SetModifierStr(const System::AnsiString AModifiers);
	bool __fastcall GetModifier(int AIndex);
	void __fastcall SetModifier(int AIndex, bool ASet);
	virtual void __fastcall Error(int AErrorID);
	bool __fastcall CompileRegExpr(char * exp);
	void __fastcall Tail(char * p, char * val);
	void __fastcall OpTail(char * p, char * val);
	char * __fastcall EmitNode(char op);
	void __fastcall EmitC(char b);
	void __fastcall InsertOperator(char op, char * opnd, int sz);
	char * __fastcall ParseReg(int paren, int &flagp);
	char * __fastcall ParseBranch(int &flagp);
	char * __fastcall ParsePiece(int &flagp);
	char * __fastcall ParseAtom(int &flagp);
	int __fastcall GetCompilerErrorPos(void);
	void __fastcall FillFirstCharSet(char * prog);
	int __fastcall regrepeat(char * p, int AMax);
	char * __fastcall regnext(char * p);
	bool __fastcall MatchPrim(char * prog);
	bool __fastcall ExecPrim(int AOffset);
	int __fastcall GetSubExprMatchCount(void);
	int __fastcall GetMatchPos(int Idx);
	int __fastcall GetMatchLen(int Idx);
	System::AnsiString __fastcall GetMatch(int Idx);
	System::AnsiString __fastcall GetInputString(void);
	void __fastcall SetInputString(const System::AnsiString AInputString);
	void __fastcall SetLineSeparators(const System::AnsiString AStr);
	void __fastcall SetLinePairedSeparator(const System::AnsiString AStr);
	System::AnsiString __fastcall GetLinePairedSeparator(void);
	
public:
	__fastcall TRegExpr(void);
	__fastcall virtual ~TRegExpr(void);
	__classmethod int __fastcall VersionMajor();
	__classmethod int __fastcall VersionMinor();
	__property System::AnsiString Expression = {read=GetExpression, write=SetExpression};
	__property System::AnsiString ModifierStr = {read=GetModifierStr, write=SetModifierStr};
	__property bool ModifierI = {read=GetModifier, write=SetModifier, index=1, nodefault};
	__property bool ModifierR = {read=GetModifier, write=SetModifier, index=2, nodefault};
	__property bool ModifierS = {read=GetModifier, write=SetModifier, index=3, nodefault};
	__property bool ModifierG = {read=GetModifier, write=SetModifier, index=4, nodefault};
	__property bool ModifierM = {read=GetModifier, write=SetModifier, index=5, nodefault};
	__property bool ModifierX = {read=GetModifier, write=SetModifier, index=6, nodefault};
	bool __fastcall Exec(const System::AnsiString AInputString)/* overload */;
	bool __fastcall Exec(void)/* overload */;
	bool __fastcall Exec(int AOffset)/* overload */;
	bool __fastcall ExecNext(void);
	bool __fastcall ExecPos(int AOffset = 0x1);
	__property System::AnsiString InputString = {read=GetInputString, write=SetInputString};
	System::AnsiString __fastcall Substitute(const System::AnsiString ATemplate);
	void __fastcall Split(System::AnsiString AInputStr, Classes::TStrings* APieces);
	System::AnsiString __fastcall Replace(System::AnsiString AInputStr, const System::AnsiString AReplaceStr, bool AUseSubstitution = false)/* overload */;
	System::AnsiString __fastcall Replace(System::AnsiString AInputStr, TRegExprReplaceFunction AReplaceFunc)/* overload */;
	System::AnsiString __fastcall ReplaceEx(System::AnsiString AInputStr, TRegExprReplaceFunction AReplaceFunc);
	__property int SubExprMatchCount = {read=GetSubExprMatchCount, nodefault};
	__property int MatchPos[int Idx] = {read=GetMatchPos};
	__property int MatchLen[int Idx] = {read=GetMatchLen};
	__property System::AnsiString Match[int Idx] = {read=GetMatch};
	int __fastcall LastError(void);
	virtual System::AnsiString __fastcall ErrorMsg(int AErrorID);
	__property int CompilerErrorPos = {read=GetCompilerErrorPos, nodefault};
	__property System::AnsiString SpaceChars = {read=fSpaceChars, write=fSpaceChars};
	__property System::AnsiString WordChars = {read=fWordChars, write=fWordChars};
	__property System::AnsiString LineSeparators = {read=fLineSeparators, write=SetLineSeparators};
	__property System::AnsiString LinePairedSeparator = {read=GetLinePairedSeparator, write=SetLinePairedSeparator};
	__classmethod char __fastcall InvertCaseFunction(const char Ch);
	__property TRegExprInvertCaseFunction InvertCase = {read=fInvertCase, write=fInvertCase};
	void __fastcall Compile(void);
};


class DELPHICLASS ERegExpr;
class PASCALIMPLEMENTATION ERegExpr : public Sysutils::Exception
{
	typedef Sysutils::Exception inherited;
	
public:
	int ErrorCode;
	int CompilerErrorPos;
public:
	/* Exception.Create */ inline __fastcall ERegExpr(const System::UnicodeString Msg) : Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ERegExpr(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall ERegExpr(int Ident)/* overload */ : Sysutils::Exception(Ident) { }
	/* Exception.CreateResFmt */ inline __fastcall ERegExpr(int Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall ERegExpr(const System::UnicodeString Msg, int AHelpContext) : Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ERegExpr(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ERegExpr(int Ident, int AHelpContext)/* overload */ : Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ERegExpr(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ERegExpr(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const ShortInt REOpSz = 0x1;
static const ShortInt RENextOffSz = 0x4;
static const ShortInt REBracesArgSz = 0x4;
static const WideChar EscChar = (WideChar)(0x5c);
extern PACKAGE bool RegExprModifierI;
extern PACKAGE bool RegExprModifierR;
extern PACKAGE bool RegExprModifierS;
extern PACKAGE bool RegExprModifierG;
extern PACKAGE bool RegExprModifierM;
extern PACKAGE bool RegExprModifierX;
extern PACKAGE System::AnsiString RegExprSpaceChars;
extern PACKAGE System::AnsiString RegExprWordChars;
extern PACKAGE System::AnsiString RegExprLineSeparators;
extern PACKAGE System::AnsiString RegExprLinePairedSeparator;
static const ShortInt NSUBEXP = 0x20;
static const Byte NSUBEXPMAX = 0xff;
static const int MaxBracesArg = 0x7ffffffe;
static const ShortInt LoopStackMax = 0xa;
static const ShortInt TinySetLen = 0x3;
extern PACKAGE TRegExprInvertCaseFunction RegExprInvertCaseFunction;
extern PACKAGE bool __fastcall ExecRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr);
extern PACKAGE void __fastcall SplitRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr, Classes::TStrings* APieces);
extern PACKAGE System::AnsiString __fastcall ReplaceRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr, const System::AnsiString AReplaceStr, bool AUseSubstitution = false);
extern PACKAGE System::AnsiString __fastcall QuoteRegExprMetaChars(const System::AnsiString AStr);
extern PACKAGE int __fastcall RegExprSubExpressions(const System::UnicodeString ARegExpr, Classes::TStrings* ASubExprs, bool AExtendedSyntax = false);

}	/* namespace Regexpr */
using namespace Regexpr;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// RegexprHPP
