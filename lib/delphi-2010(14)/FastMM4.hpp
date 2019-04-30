// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Fastmm4.pas' rev: 21.00

#ifndef Fastmm4HPP
#define Fastmm4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fastmm4
{
//-- type declarations -------------------------------------------------------
typedef int NativeInt;

typedef unsigned NativeUInt;

typedef unsigned *PNativeUInt;

typedef int IntPtr;

typedef unsigned UIntPtr;

struct TSmallBlockTypeState
{
	
public:
	unsigned InternalBlockSize;
	unsigned UseableBlockSize;
	unsigned AllocatedBlockCount;
	unsigned ReservedAddressSpace;
};


typedef StaticArray<TSmallBlockTypeState, 56> TSmallBlockTypeStates;

struct TMemoryManagerState
{
	
public:
	TSmallBlockTypeStates SmallBlockTypeStates;
	unsigned AllocatedMediumBlockCount;
	unsigned TotalAllocatedMediumBlockSize;
	unsigned ReservedMediumBlockAddressSpace;
	unsigned AllocatedLargeBlockCount;
	unsigned TotalAllocatedLargeBlockSize;
	unsigned ReservedLargeBlockAddressSpace;
};


struct TMemoryManagerUsageSummary
{
	
public:
	unsigned AllocatedBytes;
	unsigned OverheadBytes;
	double EfficiencyPercentage;
};


#pragma option push -b-
enum TChunkStatus { csUnallocated, csAllocated, csReserved, csSysAllocated, csSysReserved };
#pragma option pop

typedef StaticArray<TChunkStatus, 65536> TMemoryMap;

#pragma option push -b-
enum TStringDataType { stUnknown, stAnsiString, stUnicodeString };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
#define FastMMVersion L"4.99"
static const ShortInt NumSmallBlockTypes = 0x38;
extern PACKAGE bool FullDebugModeScanMemoryPoolBeforeEveryOperation;
extern PACKAGE bool FullDebugModeRegisterAllAllocsAsExpectedMemoryLeak;
extern PACKAGE bool SuppressMessageBoxes;
extern PACKAGE System::TClass __fastcall DetectClassInstance(void * APointer);
extern PACKAGE void * __fastcall FastGetMem(int ASize);
extern PACKAGE int __fastcall FastFreeMem(void * APointer);
extern PACKAGE void * __fastcall FastReallocMem(void * APointer, int ANewSize);
extern PACKAGE void * __fastcall FastAllocMem(unsigned ASize);
extern PACKAGE TStringDataType __fastcall DetectStringData(void * APMemoryBlock, int AAvailableSpaceInBlock);
extern PACKAGE void __fastcall GetMemoryManagerState(TMemoryManagerState &AMemoryManagerState);
extern PACKAGE void __fastcall GetMemoryManagerUsageSummary(TMemoryManagerUsageSummary &AMemoryManagerUsageSummary);
extern PACKAGE void __fastcall GetMemoryMap(TChunkStatus *AMemoryMap);
extern PACKAGE System::THeapStatus __fastcall FastGetHeapStatus(void);
extern PACKAGE void __fastcall FreeAllMemory(void);
extern PACKAGE void __fastcall RunInitializationCode(void);

}	/* namespace Fastmm4 */
using namespace Fastmm4;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fastmm4HPP
