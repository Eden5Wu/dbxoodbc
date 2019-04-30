// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FastMM4.pas' rev: 33.00 (Windows)

#ifndef Fastmm4HPP
#define Fastmm4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fastmm4
{
//-- forward type declarations -----------------------------------------------
struct TSmallBlockTypeState;
struct TMemoryManagerState;
struct TMemoryManagerUsageSummary;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TSmallBlockTypeState
{
public:
	unsigned InternalBlockSize;
	unsigned UseableBlockSize;
	NativeUInt AllocatedBlockCount;
	NativeUInt ReservedAddressSpace;
};


typedef System::StaticArray<TSmallBlockTypeState, 56> TSmallBlockTypeStates;

struct DECLSPEC_DRECORD TMemoryManagerState
{
public:
	TSmallBlockTypeStates SmallBlockTypeStates;
	unsigned AllocatedMediumBlockCount;
	NativeUInt TotalAllocatedMediumBlockSize;
	NativeUInt ReservedMediumBlockAddressSpace;
	unsigned AllocatedLargeBlockCount;
	NativeUInt TotalAllocatedLargeBlockSize;
	NativeUInt ReservedLargeBlockAddressSpace;
};


struct DECLSPEC_DRECORD TMemoryManagerUsageSummary
{
public:
	NativeUInt AllocatedBytes;
	NativeUInt OverheadBytes;
	double EfficiencyPercentage;
};


enum DECLSPEC_DENUM TChunkStatus : unsigned char { csUnallocated, csAllocated, csReserved, csSysAllocated, csSysReserved };

typedef System::StaticArray<TChunkStatus, 65536> TMemoryMap;

enum DECLSPEC_DENUM TStringDataType : unsigned char { stUnknown, stAnsiString, stUnicodeString };

//-- var, const, procedure ---------------------------------------------------
#define FastMMVersion L"4.99"
static const System::Int8 NumSmallBlockTypes = System::Int8(0x38);
extern DELPHI_PACKAGE bool FullDebugModeScanMemoryPoolBeforeEveryOperation;
extern DELPHI_PACKAGE bool FullDebugModeRegisterAllAllocsAsExpectedMemoryLeak;
extern DELPHI_PACKAGE bool SuppressMessageBoxes;
extern DELPHI_PACKAGE System::TClass __fastcall DetectClassInstance(void * APointer);
extern DELPHI_PACKAGE void * __fastcall FastGetMem(NativeInt ASize);
extern DELPHI_PACKAGE int __fastcall FastFreeMem(void * APointer);
extern DELPHI_PACKAGE void * __fastcall FastReallocMem(void * APointer, NativeInt ANewSize);
extern DELPHI_PACKAGE void * __fastcall FastAllocMem(NativeInt ASize);
extern DELPHI_PACKAGE TStringDataType __fastcall DetectStringData(void * APMemoryBlock, NativeInt AAvailableSpaceInBlock);
extern DELPHI_PACKAGE void __fastcall GetMemoryManagerState(TMemoryManagerState &AMemoryManagerState);
extern DELPHI_PACKAGE void __fastcall GetMemoryManagerUsageSummary(TMemoryManagerUsageSummary &AMemoryManagerUsageSummary);
extern DELPHI_PACKAGE void __fastcall GetMemoryMap(TMemoryMap &AMemoryMap);
extern DELPHI_PACKAGE System::THeapStatus __fastcall FastGetHeapStatus();
extern DELPHI_PACKAGE void __fastcall FreeAllMemory();
extern DELPHI_PACKAGE void __fastcall RunInitializationCode();
}	/* namespace Fastmm4 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FASTMM4)
using namespace Fastmm4;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fastmm4HPP
