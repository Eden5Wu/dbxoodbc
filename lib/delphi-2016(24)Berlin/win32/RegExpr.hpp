// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'RegExpr.pas' rev: 31.00 (Windows)

#ifndef RegexprHPP
#define RegexprHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.AnsiStrings.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Regexpr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TRegExpr;
class DELPHICLASS ERegExpr;
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

typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> TSetOfREChar;

typedef TSetOfREChar *PSetOfREChar;

typedef System::UnicodeString __fastcall (__closure *TRegExprReplaceFunction)(TRegExpr* ARegExpr);

class PASCALIMPLEMENTATION TRegExpr : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::StaticArray<char *, 32> startp;
	System::StaticArray<char *, 32> endp;
	System::StaticArray<int, 10> LoopStack;
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
	System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> fLineSeparatorsSet;
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
	void __fastcall Split(System::AnsiString AInputStr, System::Classes::TStrings* APieces);
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


#pragma pack(push,4)
class PASCALIMPLEMENTATION ERegExpr : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	int ErrorCode;
	int CompilerErrorPos;
public:
	/* Exception.Create */ inline __fastcall ERegExpr(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ERegExpr(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall ERegExpr(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ERegExpr(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ERegExpr(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall ERegExpr(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall ERegExpr(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ERegExpr(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ERegExpr(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ERegExpr(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ERegExpr(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ERegExpr(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ERegExpr(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 REOpSz = System::Int8(0x1);
static const System::Int8 RENextOffSz = System::Int8(0x4);
static const System::Int8 REBracesArgSz = System::Int8(0x4);
static const System::WideChar EscChar = (System::WideChar)(0x5c);
extern DELPHI_PACKAGE bool RegExprModifierI;
extern DELPHI_PACKAGE bool RegExprModifierR;
extern DELPHI_PACKAGE bool RegExprModifierS;
extern DELPHI_PACKAGE bool RegExprModifierG;
extern DELPHI_PACKAGE bool RegExprModifierM;
extern DELPHI_PACKAGE bool RegExprModifierX;
extern DELPHI_PACKAGE System::AnsiString RegExprSpaceChars;
extern DELPHI_PACKAGE System::AnsiString RegExprWordChars;
extern DELPHI_PACKAGE System::AnsiString RegExprLineSeparators;
extern DELPHI_PACKAGE System::AnsiString RegExprLinePairedSeparator;
static const System::Int8 NSUBEXP = System::Int8(0x20);
static const System::Byte NSUBEXPMAX = System::Byte(0xff);
static const int MaxBracesArg = int(0x7ffffffe);
static const System::Int8 LoopStackMax = System::Int8(0xa);
static const System::Int8 TinySetLen = System::Int8(0x3);
extern DELPHI_PACKAGE TRegExprInvertCaseFunction RegExprInvertCaseFunction;
extern DELPHI_PACKAGE bool __fastcall ExecRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr);
extern DELPHI_PACKAGE void __fastcall SplitRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr, System::Classes::TStrings* APieces);
extern DELPHI_PACKAGE System::AnsiString __fastcall ReplaceRegExpr(const System::AnsiString ARegExpr, const System::AnsiString AInputStr, const System::AnsiString AReplaceStr, bool AUseSubstitution = false);
extern DELPHI_PACKAGE System::AnsiString __fastcall QuoteRegExprMetaChars(const System::AnsiString AStr);
extern DELPHI_PACKAGE int __fastcall RegExprSubExpressions(const System::UnicodeString ARegExpr, System::Classes::TStrings* ASubExprs, bool AExtendedSyntax = false);
}	/* namespace Regexpr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_REGEXPR)
using namespace Regexpr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// RegexprHPP
