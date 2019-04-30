// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FastMM4.pas' rev: 22.00

#ifndef Fastmm4HPP
#define Fastmm4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fastmm4
{
//-- type declarations -------------------------------------------------------
typedef int NativeInt;

typedef unsigned NativeUInt;

typedef unsigned *PNativeUInt;

typedef int IntPtr;

typedef unsigned UIntPtr;

struct DECLSPEC_DRECORD TSmallBlockTypeState
{
	
public:
	unsigned InternalBlockSize;
	unsigned UseableBlockSize;
	unsigned AllocatedBlockCount;
	unsigned ReservedAddressSpace;
};


typedef System::StaticArray<TSmallBlockTypeState, 56> TSmallBlockTypeStates;

struct DECLSPEC_DRECORD TMemoryManagerState
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


struct DECLSPEC_DRECORD TMemoryManagerUsageSummary
{
	
public:
	unsigned AllocatedBytes;
	unsigned OverheadBytes;
	double EfficiencyPercentage;
};


#pragma option push -b-
enum TChunkStatus { csUnallocated, csAllocated, csReserved, csSysAllocated, csSysReserved };
#pragma option pop

typedef System::StaticArray<TChunkStatus, 65536> TMemoryMap;

#pragma option push -b-
enum TStringDataType { stUnknown, stAnsiString, stUnicodeString };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
#define FastMMVersion L"4.99"
static const System::ShortInt NumSmallBlockTypes = 0x38;
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
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Fastmm4;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fastmm4HPP
