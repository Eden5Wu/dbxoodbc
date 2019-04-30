// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcUtils.pas' rev: 33.00 (Windows)

#ifndef DbxopenodbcutilsHPP
#define DbxopenodbcutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.AnsiStrings.hpp>
#include <System.Classes.hpp>
#include <Data.FmtBcd.hpp>
#include <DbxOpenOdbcTypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall FreeMemAndNil(void *MemPtr);
extern DELPHI_PACKAGE void __fastcall MaxSet(int &x, int n)/* overload */;
extern DELPHI_PACKAGE bool __fastcall MaxSet(int &x, int n, int max)/* overload */;
extern DELPHI_PACKAGE void __fastcall MaxSet(int &x, const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE bool __fastcall MaxSet(int &x, const System::AnsiString S, int max)/* overload */;
extern DELPHI_PACKAGE void __fastcall MaxSet(int &x, const System::WideString S)/* overload */;
extern DELPHI_PACKAGE bool __fastcall MaxSet(int &x, const System::WideString S, int max)/* overload */;
extern DELPHI_PACKAGE int __fastcall BCD2Str(char * pOut, const Data::Fmtbcd::TBcd &ABcd, char ADot = '\x2e', bool bExpFormat = false);
extern DELPHI_PACKAGE void __fastcall Str2BCD(char * PValue, unsigned ASize, Data::Fmtbcd::TBcd &ABcd, char ADot);
extern DELPHI_PACKAGE int __fastcall WideStringLengthFromStr(const char * S);
extern DELPHI_PACKAGE int __fastcall WideStringLengthFromStrings(System::Classes::TStrings* const L);
extern DELPHI_PACKAGE int __fastcall WCharFromChar(System::WideChar * WCharDest, int DestChars, const char * CharSource, int SrcBytes);
extern DELPHI_PACKAGE int __fastcall StringToWideChar(const System::AnsiString Source, System::WideChar * Dest, int DestChars);
extern DELPHI_PACKAGE int __fastcall StringToWStr(const System::AnsiString Source, System::WideChar * &Dest)/* overload */;
extern DELPHI_PACKAGE int __fastcall StringToWStr(const System::WideString Source, System::WideChar * &Dest)/* overload */;
extern DELPHI_PACKAGE int __fastcall StringsToWStr(System::Classes::TStrings* const L, System::WideChar * &Dest)/* overload */;
extern DELPHI_PACKAGE int __fastcall StrLenNil(const char * AStr);
extern DELPHI_PACKAGE unsigned __fastcall WStrLen(const System::WideChar * Str);
extern DELPHI_PACKAGE int __fastcall WStrComp(const System::WideChar * Str1, const System::WideChar * Str2);
extern DELPHI_PACKAGE int __fastcall WStrIComp(const System::WideChar * Str1, const System::WideChar * Str2);
extern DELPHI_PACKAGE int __fastcall WStrLComp(const System::WideChar * Str1, const System::WideChar * Str2, unsigned MaxLen);
extern DELPHI_PACKAGE int __fastcall WStrCopy(System::WideChar * Dest, const System::WideChar * Source)/* overload */;
extern DELPHI_PACKAGE int __fastcall WStrCopy(System::WideChar * Dest, const System::WideString Source)/* overload */;
extern DELPHI_PACKAGE System::WideChar * __fastcall WStrLCopy(System::WideChar * Dest, const System::WideChar * Source, unsigned MaxLen);
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const char * Source, char * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const System::WideChar * Source, System::WideChar * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const System::AnsiString Source, char * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const System::WideString Source, System::WideChar * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const System::AnsiString Source, char * &Dest, System::PInteger MaxLen)/* overload */;
extern DELPHI_PACKAGE int __fastcall StrBuffCopy(const System::WideString Source, System::WideChar * &Dest, System::PInteger MaxLen)/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const char * Source, /* out */ char * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const char * Source, /* out */ System::WideChar * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::AnsiString Source, /* out */ char * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideString Source, System::WideChar * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideChar * Source, /* out */ char * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideChar * Source, /* out */ System::WideChar * &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const char * Source, System::AnsiString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideChar * Source, System::AnsiString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const char * Source, System::WideString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideChar * Source, System::WideString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::AnsiString Source, System::AnsiString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideString Source, System::AnsiString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::AnsiString Source, System::WideString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE int __fastcall StrClone(const System::WideString Source, System::WideString &Dest, unsigned MaxLen = (unsigned)(0x0))/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrIsEmpty(const char * Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrIsEmpty(const System::WideChar * Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrIsEmpty(const System::AnsiString Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrIsEmpty(const System::WideString Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrNotEmpty(const char * Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrNotEmpty(const System::WideChar * Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrNotEmpty(const System::AnsiString Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrNotEmpty(const System::WideString Source)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StrPtrToString(const void * Source, bool bUnicode)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StrPtrToString(const char * Source)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StrPtrToString(const System::WideChar * Source)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const char * S1, const char * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideChar * S1, const System::WideChar * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const char * S1, const System::WideChar * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideChar * S1, const char * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::AnsiString S1, const System::AnsiString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideString S1, const System::WideString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::AnsiString S1, const System::WideString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideString S1, const System::AnsiString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const char * S1, const System::AnsiString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::AnsiString S1, const char * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideChar * S1, const System::WideString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrSameText(const System::WideString S1, const System::WideChar * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const char * S1, const char * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::WideChar * S1, const System::WideChar * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const char * S1, const System::WideChar * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::WideChar * S1, const char * S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::AnsiString S1, const System::AnsiString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::WideString S1, const System::WideString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::AnsiString S1, const System::WideString S2)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StrISameText(const System::WideString S1, const System::AnsiString S2)/* overload */;
extern DELPHI_PACKAGE char * __fastcall PAnsiCharParam(const char * P)/* overload */;
extern DELPHI_PACKAGE char * __fastcall PAnsiCharParam(const System::AnsiString P)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StrAnsiStringParam(const char * P)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StrAnsiStringParam(const System::AnsiString P)/* overload */;
extern DELPHI_PACKAGE System::WideString __fastcall ChangeFileExtW(const System::WideString FileName, const System::WideString Extension);
extern DELPHI_PACKAGE System::AnsiString __fastcall PIntToStr(System::PInteger AValue)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ArgStrNull(const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ArgStrNull(const System::UnicodeString S)/* overload */;
}	/* namespace Dbxopenodbcutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCUTILS)
using namespace Dbxopenodbcutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcutilsHPP
