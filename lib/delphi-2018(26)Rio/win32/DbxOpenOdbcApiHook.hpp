// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcApiHook.pas' rev: 33.00 (Windows)

#ifndef DbxopenodbcapihookHPP
#define DbxopenodbcapihookHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcapihook
{
//-- forward type declarations -----------------------------------------------
struct TImageImportDesc;
struct THintTable;
struct TIATListEntry;
struct TPatchRecord;
class DELPHICLASS TIATPatch;
struct TJumpInstruction;
//-- type declarations -------------------------------------------------------
typedef System::PPointer *PPPointer;

typedef void * *IndirectAddr;

typedef TImageImportDesc *PImageImportDesc;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TImageImportDesc
{
public:
	unsigned FuncNameList;
	unsigned TimeDateStamp;
	unsigned ForwarderChain;
	unsigned Name;
	unsigned FirstThunk;
};
#pragma pack(pop)


typedef THintTable *PHintTable;

#pragma pack(push,1)
struct DECLSPEC_DRECORD THintTable
{
public:
	unsigned FuncName;
};
#pragma pack(pop)


typedef TIATListEntry *PIATListEntry;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIATListEntry
{
public:
	void * *IAT;
	TIATListEntry *Next;
};
#pragma pack(pop)


typedef TPatchRecord *PPatchRecord;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPatchRecord
{
public:
	System::StaticArray<System::WideChar, 261> LibraryName;
	System::StaticArray<System::WideChar, 256> FunctionName;
	void *FunctionAddr;
	TIATListEntry *IATList;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TIATPatch : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	PPatchRecord operator[](int Index) { return this->Items[Index]; }
	
private:
	_RTL_CRITICAL_SECTION FLock;
	System::Classes::TList* FPatchList;
	bool FUnpatch;
	void __fastcall BuildIATPatchList(System::UnicodeString LibraryName, System::UnicodeString FunctionName, PIATListEntry &List);
	bool __fastcall CompareLibraryNames(System::UnicodeString Name1, System::UnicodeString Name2);
	void __fastcall EnumIATList(NativeUInt Module, System::UnicodeString LibraryName, System::UnicodeString FunctionName, PIATListEntry &List);
	bool __fastcall ListContainsIAT(PIATListEntry List, IndirectAddr IAT);
	System::WideChar * __fastcall NextFunctionName(System::WideChar * lpName);
	bool __fastcall UpdatePatch(PPatchRecord PatchRecord, void * FunctionAddress);
	bool __fastcall UpdateEntry(PIATListEntry Entry, void * FunctionAddress);
	
protected:
	int __fastcall GetCount();
	PPatchRecord __fastcall GetPatchRecord(int Index);
	bool __fastcall GetUnpatchOnFree();
	void __fastcall SetUnpatchOnFree(bool Value);
	
public:
	__fastcall TIATPatch();
	__fastcall virtual ~TIATPatch();
	void __fastcall Clear(bool Unpatch);
	void __fastcall Delete(int Index, bool Unpatch);
	PPatchRecord __fastcall Find(System::UnicodeString LibraryName, System::UnicodeString FunctionName);
	bool __fastcall Patch(System::UnicodeString LibraryName, System::UnicodeString FunctionName, void * NewFunction, /* out */ void * &OldFunction);
	void __fastcall Unpatch(System::UnicodeString LibraryName, System::UnicodeString FunctionName);
	__property int Count = {read=GetCount, nodefault};
	__property PPatchRecord Items[int Index] = {read=GetPatchRecord/*, default*/};
	__property bool UnpatchOnFree = {read=GetUnpatchOnFree, write=SetUnpatchOnFree, nodefault};
};

#pragma pack(pop)

typedef TJumpInstruction *PJumpInstruction;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TJumpInstruction
{
	
public:
	union
	{
		struct 
		{
			unsigned DW1;
			unsigned DW2;
		};
		struct 
		{
			System::Byte Code;
			unsigned Offset;
			System::Byte UnUsed;
		};
		
	};
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
static const System::Word MAX_LIBRARYNAME = System::Word(0x104);
static const System::Byte MAX_FUNCTIONNAME = System::Byte(0xff);
extern DELPHI_PACKAGE NativeInt __fastcall SizeOfCode(void * Code);
extern DELPHI_PACKAGE NativeInt __fastcall SizeOfProc(void * Proc);
extern DELPHI_PACKAGE NativeInt __fastcall SaveOldFunction(void * Proc, void * Old);
extern DELPHI_PACKAGE bool __fastcall HookCode(void * TargetProc, void * NewProc, void * &OldProc);
extern DELPHI_PACKAGE bool __fastcall HookProc(System::WideChar * lpModuleName, System::WideChar * lpProcName, void * NewProc, void * &OldProc);
extern DELPHI_PACKAGE bool __fastcall UnhookCode(void * OldProc);
extern DELPHI_PACKAGE void * __fastcall GetNativeAddr(void * Ptr);
extern DELPHI_PACKAGE bool __fastcall JumpFromCode(void * MSrc, void * MDest, PJumpInstruction SaveJump);
extern DELPHI_PACKAGE bool __fastcall RestoreSavedCode(void * MSrc, PJumpInstruction SaveJump);
extern DELPHI_PACKAGE bool __fastcall IsJumpFromCode(void * MSrc, void * MDest);
extern DELPHI_PACKAGE void * __fastcall GetVirtualMethodAddress(System::TClass AClass, int AIndex);
extern DELPHI_PACKAGE void * __fastcall SetVirtualMethodAddress(System::TClass AClass, int AIndex, void * NewAddress);
extern DELPHI_PACKAGE int __fastcall FindVirtualMethodIndex(System::TClass AClass, void * MethodAddr);
extern DELPHI_PACKAGE int __fastcall GetVirtualMethodOffset(System::TClass AClass, void * MethodAddr);
extern DELPHI_PACKAGE void * __fastcall FxtGetStubAddress(void * AStub, NativeInt OffsetE8 = (NativeInt)(0x0));
}	/* namespace Dbxopenodbcapihook */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCAPIHOOK)
using namespace Dbxopenodbcapihook;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcapihookHPP
