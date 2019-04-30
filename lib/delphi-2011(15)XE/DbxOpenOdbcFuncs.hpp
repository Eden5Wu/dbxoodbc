// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcFuncs.pas' rev: 22.00

#ifndef DbxopenodbcfuncsHPP
#define DbxopenodbcfuncsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <AnsiStrings.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <DbxOpenOdbcTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcfuncs
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const char cNullAnsiChar = '\0';
static const System::WideChar cNullWideChar = (System::WideChar)(0x0);
extern PACKAGE char cNullAnsiCharBuf;
extern PACKAGE System::WideChar cNullWideCharBuf;
extern PACKAGE int __fastcall min(int v1, int v2);
extern PACKAGE int __fastcall max(int v1, int v2);
extern PACKAGE System::AnsiString __fastcall AnsiToOEM(const System::AnsiString S);
extern PACKAGE System::AnsiString __fastcall OemToAnsi(const System::AnsiString S);
extern PACKAGE bool __fastcall LoadStringFromFileA(const System::AnsiString FileName, System::AnsiString &S);
extern PACKAGE bool __fastcall LoadStringFromFileW(const System::UnicodeString FileName, System::WideString &S);
extern PACKAGE System::AnsiString __fastcall GetOptionValue(System::AnsiString &ConnectString, System::AnsiString OptionName, bool HideOption = false, bool TrimResult = true, bool bOneChar = false, const System::AnsiString HideTemplate = "\x00");
extern PACKAGE void * __fastcall PointerOffset(void * Ptr, int Offset);
extern PACKAGE int __fastcall CompareMemory(void * Ptr1, void * Ptr2, unsigned N);
extern PACKAGE System::UnicodeString __fastcall GetTemporaryFileName(const System::UnicodeString FileNamePrefix = L"dbx");
extern PACKAGE System::UnicodeString __fastcall GetTemporaryFolder(void);
extern PACKAGE bool __fastcall PrepareFileNameAliases(System::UnicodeString &FileName, const System::UnicodeString AppFolder = L"", const System::UnicodeString TempFolder = L"")/* overload */;
extern PACKAGE bool __fastcall PrepareFileNameAliases(System::AnsiString &FileName, const System::AnsiString AppFolder = "", const System::AnsiString TempFolder = "")/* overload */;
extern PACKAGE int __fastcall ArrScanByte(unsigned N, char * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanWord(unsigned N, System::WideChar * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanDWord(unsigned N, void * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanPointer(void * N, void * ArrPtr, unsigned Count);
extern PACKAGE char __fastcall ToAnsiChar(System::WideChar WC)/* overload */;
extern PACKAGE bool __fastcall ToAnsiChar(System::WideChar WC, char &AC)/* overload */;
extern PACKAGE int __fastcall PosChar(char AC, const System::AnsiString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(char AC, const System::UnicodeString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(System::WideChar WC, const System::AnsiString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(System::WideChar WC, const System::UnicodeString Str)/* overload */;
extern PACKAGE int __fastcall PosCharEx(char AC, const System::AnsiString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(char AC, const System::UnicodeString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(System::WideChar WC, const System::AnsiString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(System::WideChar WC, const System::UnicodeString Str, int Index)/* overload */;
extern PACKAGE System::UnicodeString __fastcall DupeStringW(const System::UnicodeString AText, int ACount);
extern PACKAGE System::AnsiString __fastcall DupeStringA(const System::AnsiString AText, int ACount);
extern PACKAGE System::UnicodeString __fastcall DupeString(const System::UnicodeString AText, int ACount);
extern PACKAGE void __fastcall DupeWideChar(const System::UnicodeString AText, int ACount, System::WideChar * ADest);
extern PACKAGE void __fastcall DupeAnsiChar(const System::AnsiString AText, int ACount, char * ADest);
extern PACKAGE System::AnsiString __fastcall StringCharReplace(const System::AnsiString S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE System::AnsiString __fastcall StringCharReplace(const System::AnsiString S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE System::WideString __fastcall StringCharReplace(const System::WideString S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE System::WideString __fastcall StringCharReplace(const System::WideString S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::UnicodeString &S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::UnicodeString &S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::AnsiString &S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::AnsiString &S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::WideString &S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(System::WideString &S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall dbg(const System::UnicodeString S)/* overload */;
extern PACKAGE void __fastcall dbg(const System::AnsiString S)/* overload */;
extern PACKAGE void __fastcall dbg(const System::WideString S)/* overload */;
extern PACKAGE System::UnicodeString __fastcall GetCompilerVersion(void);

}	/* namespace Dbxopenodbcfuncs */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Dbxopenodbcfuncs;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcfuncsHPP
