// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbxopenodbcapihook.pas' rev: 10.00

#ifndef DbxopenodbcapihookHPP
#define DbxopenodbcapihookHPP

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

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcapihook
{
//-- type declarations -------------------------------------------------------
typedef int NativeInt;

typedef unsigned NativeUInt;

typedef int *PNativeInt;

typedef void * *PPointer;

typedef PPointer *PPPointer;

typedef void * *IndirectAddr;

struct TImageImportDesc;
typedef TImageImportDesc *PImageImportDesc;

#pragma pack(push,1)
struct TImageImportDesc
{
	
public:
	unsigned FuncNameList;
	unsigned TimeDateStamp;
	unsigned ForwarderChain;
	unsigned Name;
	unsigned FirstThunk;
} ;
#pragma pack(pop)

struct THintTable;
typedef THintTable *PHintTable;

#pragma pack(push,1)
struct THintTable
{
	
public:
	unsigned FuncName;
} ;
#pragma pack(pop)

struct TIATListEntry;
typedef TIATListEntry *PIATListEntry;

#pragma pack(push,1)
struct TIATListEntry
{
	
public:
	void * *IAT;
	TIATListEntry *Next;
} ;
#pragma pack(pop)

struct TPatchRecord;
typedef TPatchRecord *PPatchRecord;

#pragma pack(push,1)
struct TPatchRecord
{
	
public:
	char LibraryName[261];
	char FunctionName[256];
	void *FunctionAddr;
	TIATListEntry *IATList;
} ;
#pragma pack(pop)

class DELPHICLASS TIATPatch;
class PASCALIMPLEMENTATION TIATPatch : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	PPatchRecord operator[](int Index) { return Items[Index]; }
	
private:
	_RTL_CRITICAL_SECTION FLock;
	Classes::TList* FPatchList;
	bool FUnpatch;
	void __fastcall BuildIATPatchList(AnsiString LibraryName, AnsiString FunctionName, PIATListEntry &List);
	bool __fastcall CompareLibraryNames(AnsiString Name1, AnsiString Name2);
	void __fastcall EnumIATList(unsigned Module, AnsiString LibraryName, AnsiString FunctionName, PIATListEntry &List);
	bool __fastcall ListContainsIAT(PIATListEntry List, IndirectAddr IAT);
	char * __fastcall NextFunctionName(char * lpName);
	bool __fastcall UpdatePatch(PPatchRecord PatchRecord, void * FunctionAddress);
	bool __fastcall UpdateEntry(PIATListEntry Entry, void * FunctionAddress);
	
protected:
	int __fastcall GetCount(void);
	PPatchRecord __fastcall GetPatchRecord(int Index);
	bool __fastcall GetUnpatchOnFree(void);
	void __fastcall SetUnpatchOnFree(bool Value);
	
public:
	__fastcall TIATPatch(void);
	__fastcall virtual ~TIATPatch(void);
	void __fastcall Clear(bool Unpatch);
	void __fastcall Delete(int Index, bool Unpatch);
	PPatchRecord __fastcall Find(AnsiString LibraryName, AnsiString FunctionName);
	bool __fastcall Patch(AnsiString LibraryName, AnsiString FunctionName, void * NewFunction, /* out */ void * &OldFunction);
	void __fastcall Unpatch(AnsiString LibraryName, AnsiString FunctionName);
	__property int Count = {read=GetCount, nodefault};
	__property PPatchRecord Items[int Index] = {read=GetPatchRecord/*, default*/};
	__property bool UnpatchOnFree = {read=GetUnpatchOnFree, write=SetUnpatchOnFree, nodefault};
};


struct TJumpInstruction;
typedef TJumpInstruction *PJumpInstruction;

#pragma pack(push,1)
struct TJumpInstruction
{
	
	union
	{
		struct 
		{
			unsigned DW1;
			unsigned DW2;
			
		};
		struct 
		{
			Byte Code;
			unsigned Offset;
			Byte UnUsed;
			
		};
		
	};
} ;
#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const Word MAX_LIBRARYNAME = 0x104;
static const Byte MAX_FUNCTIONNAME = 0xff;
extern PACKAGE int __fastcall SizeOfCode(void * Code);
extern PACKAGE int __fastcall SizeOfProc(void * Proc);
extern PACKAGE int __fastcall SaveOldFunction(void * Proc, void * Old);
extern PACKAGE bool __fastcall HookCode(void * TargetProc, void * NewProc, void * &OldProc);
extern PACKAGE bool __fastcall HookProc(char * lpModuleName, char * lpProcName, void * NewProc, void * &OldProc);
extern PACKAGE bool __fastcall UnhookCode(void * OldProc);
extern PACKAGE void * __fastcall GetNativeAddr(void * Ptr);
extern PACKAGE bool __fastcall JumpFromCode(void * MSrc, void * MDest, PJumpInstruction SaveJump);
extern PACKAGE bool __fastcall RestoreSavedCode(void * MSrc, PJumpInstruction SaveJump);
extern PACKAGE bool __fastcall IsJumpFromCode(void * MSrc, void * MDest);
extern PACKAGE void * __fastcall GetVirtualMethodAddress(TMetaClass* AClass, int AIndex);
extern PACKAGE void * __fastcall SetVirtualMethodAddress(TMetaClass* AClass, int AIndex, void * NewAddress);
extern PACKAGE int __fastcall FindVirtualMethodIndex(TMetaClass* AClass, void * MethodAddr);
extern PACKAGE int __fastcall GetVirtualMethodOffset(TMetaClass* AClass, void * MethodAddr);
extern PACKAGE void * __fastcall FxtGetStubAddress(void * AStub, int OffsetE8 = 0x0);

}	/* namespace Dbxopenodbcapihook */
using namespace Dbxopenodbcapihook;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbxopenodbcapihook
