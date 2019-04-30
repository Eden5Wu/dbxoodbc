// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcFuncs.pas' rev: 33.00 (Windows)

#ifndef DbxopenodbcfuncsHPP
#define DbxopenodbcfuncsHPP

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
#include <DbxOpenOdbcTypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcfuncs
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const char cNullAnsiChar = '\0';
static const System::WideChar cNullWideChar = (System::WideChar)(0x0);
extern DELPHI_PACKAGE char cNullAnsiCharBuf;
extern DELPHI_PACKAGE System::WideChar cNullWideCharBuf;
extern DELPHI_PACKAGE int __fastcall min(int v1, int v2);
extern DELPHI_PACKAGE int __fastcall max(int v1, int v2);
extern DELPHI_PACKAGE System::AnsiString __fastcall AnsiToOEM(const System::AnsiString S);
extern DELPHI_PACKAGE System::AnsiString __fastcall OemToAnsi(const System::AnsiString S);
extern DELPHI_PACKAGE bool __fastcall LoadStringFromFileA(const System::AnsiString FileName, System::AnsiString &S);
extern DELPHI_PACKAGE bool __fastcall LoadStringFromFileW(const System::UnicodeString FileName, System::WideString &S);
extern DELPHI_PACKAGE System::AnsiString __fastcall GetOptionValue(System::AnsiString &ConnectString, System::AnsiString OptionName, bool HideOption = false, bool TrimResult = true, bool bOneChar = false, const System::AnsiString HideTemplate = System::AnsiString());
extern DELPHI_PACKAGE void * __fastcall PointerOffset(void * Ptr, NativeInt Offset);
extern DELPHI_PACKAGE int __fastcall CompareMemory(void * Ptr1, void * Ptr2, unsigned N);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTemporaryFileName(const System::UnicodeString FileNamePrefix = L"dbx");
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTemporaryFolder();
extern DELPHI_PACKAGE bool __fastcall PrepareFileNameAliases(System::UnicodeString &FileName, const System::UnicodeString AppFolder = System::UnicodeString(), const System::UnicodeString TempFolder = System::UnicodeString())/* overload */;
extern DELPHI_PACKAGE bool __fastcall PrepareFileNameAliases(System::AnsiString &FileName, const System::AnsiString AppFolder = System::AnsiString(), const System::AnsiString TempFolder = System::AnsiString())/* overload */;
extern DELPHI_PACKAGE int __fastcall ArrScanByte(unsigned N, char * ArrPtr, unsigned Count);
extern DELPHI_PACKAGE int __fastcall ArrScanWord(unsigned N, System::WideChar * ArrPtr, unsigned Count);
extern DELPHI_PACKAGE int __fastcall ArrScanDWord(unsigned N, void * ArrPtr, unsigned Count);
extern DELPHI_PACKAGE int __fastcall ArrScanPointer(void * N, void * ArrPtr, unsigned Count);
extern DELPHI_PACKAGE char __fastcall ToAnsiChar(System::WideChar WC)/* overload */;
extern DELPHI_PACKAGE bool __fastcall ToAnsiChar(System::WideChar WC, char &AC)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosChar(char AC, const System::AnsiString Str)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosChar(char AC, const System::UnicodeString Str)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosChar(System::WideChar WC, const System::AnsiString Str)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosChar(System::WideChar WC, const System::UnicodeString Str)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosCharEx(char AC, const System::AnsiString Str, int Index)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosCharEx(char AC, const System::UnicodeString Str, int Index)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosCharEx(System::WideChar WC, const System::AnsiString Str, int Index)/* overload */;
extern DELPHI_PACKAGE NativeInt __fastcall PosCharEx(System::WideChar WC, const System::UnicodeString Str, int Index)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall DupeStringW(const System::UnicodeString AText, int ACount);
extern DELPHI_PACKAGE System::AnsiString __fastcall DupeStringA(const System::AnsiString AText, int ACount);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DupeString(const System::UnicodeString AText, int ACount);
extern DELPHI_PACKAGE void __fastcall DupeWideChar(const System::UnicodeString AText, int ACount, System::WideChar * ADest);
extern DELPHI_PACKAGE void __fastcall DupeAnsiChar(const System::AnsiString AText, int ACount, char * ADest);
extern DELPHI_PACKAGE System::AnsiString __fastcall StringCharReplace(const System::AnsiString S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall StringCharReplace(const System::AnsiString S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE System::WideString __fastcall StringCharReplace(const System::WideString S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE System::WideString __fastcall StringCharReplace(const System::WideString S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::UnicodeString &S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::UnicodeString &S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::AnsiString &S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::AnsiString &S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::WideString &S, System::WideChar OldChar, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall StringCharModify(System::WideString &S, System::WideChar OldChar1, System::WideChar OldChar2, System::WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern DELPHI_PACKAGE void __fastcall dbg(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall dbg(const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall dbg(const System::WideString S)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetCompilerVersion();
}	/* namespace Dbxopenodbcfuncs */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCFUNCS)
using namespace Dbxopenodbcfuncs;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcfuncsHPP
