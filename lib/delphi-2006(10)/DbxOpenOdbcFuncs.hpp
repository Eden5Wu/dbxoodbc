// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbcfuncs.pas' rev: 10.00

#ifndef DbxopenodbcfuncsHPP
#define DbxopenodbcfuncsHPP

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
#include <Dbxopenodbctypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcfuncs
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const char cNullAnsiChar = '\x0';
static const WideChar cNullWideChar = WideChar(0x0);
extern PACKAGE char cNullAnsiCharBuf;
extern PACKAGE WideChar cNullWideCharBuf;
extern PACKAGE int DefaultSystemCodePage;
extern PACKAGE int __fastcall min(int v1, int v2);
extern PACKAGE int __fastcall max(int v1, int v2);
extern PACKAGE int __fastcall PosEx(const WideString SubStr, const WideString S, int Offset = 0x1)/* overload */;
extern PACKAGE AnsiString __fastcall AnsiToOEM(const AnsiString S);
extern PACKAGE AnsiString __fastcall OemToAnsi(const AnsiString S);
extern PACKAGE bool __fastcall LoadStringFromFileA(const AnsiString FileName, AnsiString &S);
extern PACKAGE bool __fastcall LoadStringFromFileW(const AnsiString FileName, WideString &S);
extern PACKAGE AnsiString __fastcall GetOptionValue(AnsiString &ConnectString, AnsiString OptionName, bool HideOption = false, bool TrimResult = true, bool bOneChar = false, const AnsiString HideTemplate = "");
extern PACKAGE void * __fastcall PointerOffset(void * Ptr, int Offset);
extern PACKAGE int __fastcall CompareMemory(void * Ptr1, void * Ptr2, unsigned N);
extern PACKAGE AnsiString __fastcall GetTemporaryFileName(const AnsiString FileNamePrefix = "dbx");
extern PACKAGE AnsiString __fastcall GetTemporaryFolder();
extern PACKAGE bool __fastcall PrepareFileNameAliases(WideString &FileName, const WideString AppFolder = L"", const WideString TempFolder = L"")/* overload */;
extern PACKAGE bool __fastcall PrepareFileNameAliases(AnsiString &FileName, const AnsiString AppFolder = "", const AnsiString TempFolder = "")/* overload */;
extern PACKAGE int __fastcall ArrScanByte(unsigned N, char * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanWord(unsigned N, WideChar * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanDWord(unsigned N, void * ArrPtr, unsigned Count);
extern PACKAGE int __fastcall ArrScanPointer(void * N, void * ArrPtr, unsigned Count);
extern PACKAGE char __fastcall ToAnsiChar(WideChar WC)/* overload */;
extern PACKAGE bool __fastcall ToAnsiChar(WideChar WC, char &AC)/* overload */;
extern PACKAGE int __fastcall PosChar(char AC, const AnsiString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(char AC, const WideString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(WideChar WC, const AnsiString Str)/* overload */;
extern PACKAGE int __fastcall PosChar(WideChar WC, const WideString Str)/* overload */;
extern PACKAGE int __fastcall PosCharEx(char AC, const AnsiString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(char AC, const WideString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(WideChar WC, const AnsiString Str, int Index)/* overload */;
extern PACKAGE int __fastcall PosCharEx(WideChar WC, const WideString Str, int Index)/* overload */;
extern PACKAGE WideString __fastcall DupeStringW(const WideString AText, int ACount);
extern PACKAGE AnsiString __fastcall DupeStringA(const AnsiString AText, int ACount);
extern PACKAGE AnsiString __fastcall DupeString(const AnsiString AText, int ACount);
extern PACKAGE void __fastcall DupeWideChar(const WideString AText, int ACount, WideChar * ADest);
extern PACKAGE void __fastcall DupeAnsiChar(const AnsiString AText, int ACount, char * ADest);
extern PACKAGE AnsiString __fastcall StringCharReplace(const AnsiString S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE AnsiString __fastcall StringCharReplace(const AnsiString S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE WideString __fastcall StringCharReplace(const WideString S, WideChar OldChar, WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE WideString __fastcall StringCharReplace(const WideString S, WideChar OldChar1, WideChar OldChar2, WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(AnsiString &S, char OldChar, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(AnsiString &S, char OldChar1, char OldChar2, char NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(WideString &S, WideChar OldChar, WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall StringCharModify(WideString &S, WideChar OldChar1, WideChar OldChar2, WideChar NewChar, bool ReplaceAll = true)/* overload */;
extern PACKAGE void __fastcall dbg(const AnsiString S)/* overload */;
extern PACKAGE void __fastcall dbg(const WideString S)/* overload */;
extern PACKAGE AnsiString __fastcall GetCompilerVersion();

}	/* namespace Dbxopenodbcfuncs */
using namespace Dbxopenodbcfuncs;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbcfuncs
