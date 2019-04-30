// Borland C++ Builder
// Copyright (c) 1995, 2004 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Fastmm4.pas' rev: 6.00

#ifndef Fastmm4HPP
#define Fastmm4HPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Sysinit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fastmm4
{
//-- type declarations -------------------------------------------------------
typedef char *PByte;

typedef int NativeInt;

typedef unsigned NativeUInt;

typedef unsigned *PNativeUInt;

typedef int IntPtr;

typedef unsigned UIntPtr;

#pragma pack(push, 4)
struct TSmallBlockTypeState
{
	unsigned InternalBlockSize;
	unsigned UseableBlockSize;
	unsigned AllocatedBlockCount;
	unsigned ReservedAddressSpace;
} ;
#pragma pack(pop)

typedef TSmallBlockTypeState TSmallBlockTypeStates[56];

#pragma pack(push, 4)
struct TMemoryManagerState
{
	TSmallBlockTypeState SmallBlockTypeStates[56];
	unsigned AllocatedMediumBlockCount;
	unsigned TotalAllocatedMediumBlockSize;
	unsigned ReservedMediumBlockAddressSpace;
	unsigned AllocatedLargeBlockCount;
	unsigned TotalAllocatedLargeBlockSize;
	unsigned ReservedLargeBlockAddressSpace;
} ;
#pragma pack(pop)

struct TMemoryManagerUsageSummary
{
	unsigned AllocatedBytes;
	unsigned OverheadBytes;
	double EfficiencyPercentage;
} ;

#pragma option push -b-
enum TChunkStatus { csUnallocated, csAllocated, csReserved, csSysAllocated, csSysReserved };
#pragma option pop

typedef TChunkStatus TMemoryMap[65536];

#pragma option push -b-
enum TStringDataType { stUnknown, stAnsiString, stUnicodeString };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
#define FastMMVersion "4.99"
static const Shortint NumSmallBlockTypes = 0x38;
extern PACKAGE bool FullDebugModeScanMemoryPoolBeforeEveryOperation;
extern PACKAGE bool FullDebugModeRegisterAllAllocsAsExpectedMemoryLeak;
extern PACKAGE bool SuppressMessageBoxes;
extern PACKAGE TMetaClass* __fastcall DetectClassInstance(void * APointer);
extern PACKAGE void * __fastcall FastGetMem(int ASize);
extern PACKAGE int __fastcall FastFreeMem(void * APointer);
extern PACKAGE void * __fastcall FastReallocMem(void * APointer, int ANewSize);
extern PACKAGE void * __fastcall FastAllocMem(unsigned ASize);
extern PACKAGE TStringDataType __fastcall DetectStringData(void * APMemoryBlock, int AAvailableSpaceInBlock);
extern PACKAGE void __fastcall GetMemoryManagerState(TMemoryManagerState &AMemoryManagerState);
extern PACKAGE void __fastcall GetMemoryManagerUsageSummary(TMemoryManagerUsageSummary &AMemoryManagerUsageSummary);
extern PACKAGE void __fastcall GetMemoryMap(TChunkStatus * AMemoryMap);
extern PACKAGE System::THeapStatus __fastcall FastGetHeapStatus();
extern PACKAGE void __fastcall FreeAllMemory(void);
extern PACKAGE void __fastcall RunInitializationCode(void);

}	/* namespace Fastmm4 */
using namespace Fastmm4;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fastmm4
