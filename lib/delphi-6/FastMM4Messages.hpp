// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FastMM4Messages.pas' rev: 6.00

#ifndef FastMM4MessagesHPP
#define FastMM4MessagesHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fastmm4messages
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
#define FullDebugModeLibraryName32Bit "FastMM_FullDebugMode.dll"
#define FullDebugModeLibraryName64Bit "FastMM_FullDebugMode64.dll"
#define LogFileExtension "_MemoryManager_EventLog.txt"
#define CRLF "\r\n"
#define EventSeparator "--------------------------------"
#define UnknownClassNameMsg "Unknown"
#define MemoryDumpMsg "\r\n\r\nCurrent memory dump of 256 bytes starting at point"\
	"er address "
#define BlockScanLogHeader "Allocated block logged by LogAllocatedBlocksToFile. The si"\
	"ze is: "
#define ErrorMsgHeader "FastMM has detected an error during a "
#define GetMemMsg "GetMem"
#define FreeMemMsg "FreeMem"
#define ReallocMemMsg "ReallocMem"
#define BlockCheckMsg "free block scan"
#define OperationMsg " operation. "
#define BlockHeaderCorruptedMsg "The block header has been corrupted. "
#define BlockFooterCorruptedMsg "The block footer has been corrupted. "
#define FreeModifiedErrorMsg "FastMM detected that a block has been modified after being"\
	" freed. "
#define FreeModifiedDetailMsg "\r\n\r\nModified byte offsets (and lengths): "
#define DoubleFreeErrorMsg "An attempt has been made to free/reallocate an unallocated"\
	" block."
#define WrongMMFreeErrorMsg "An attempt has been made to free/reallocate a block that w"\
	"as allocated through a different FastMM instance. Check yo"\
	"ur memory manager sharing settings."
#define PreviousBlockSizeMsg "\r\n\r\nThe previous block size was: "
#define CurrentBlockSizeMsg "\r\n\r\nThe block size is: "
#define PreviousObjectClassMsg "\r\n\r\nThe block was previously used for an object of cla"\
	"ss: "
#define CurrentObjectClassMsg "\r\n\r\nThe block is currently used for an object of class"\
	": "
#define PreviousAllocationGroupMsg "\r\n\r\nThe allocation group was: "
#define PreviousAllocationNumberMsg "\r\n\r\nThe allocation number was: "
#define CurrentAllocationGroupMsg "\r\n\r\nThe allocation group is: "
#define CurrentAllocationNumberMsg "\r\n\r\nThe allocation number is: "
#define BlockErrorMsgTitle "Memory Error Detected"
#define VirtualMethodErrorHeader "FastMM has detected an attempt to call a virtual method on"\
	" a freed object. An access violation will now be raised in"\
	" order to abort the current operation."
#define InterfaceErrorHeader "FastMM has detected an attempt to use an interface of a fr"\
	"eed object. An access violation will now be raised in orde"\
	"r to abort the current operation."
#define BlockHeaderCorruptedNoHistoryMsg " Unfortunately the block header has been corrupted so no h"\
	"istory is available."
#define FreedObjectClassMsg "\r\n\r\nFreed object class: "
#define VirtualMethodName "\r\n\r\nVirtual method: "
#define VirtualMethodOffset "Offset +"
#define VirtualMethodAddress "\r\n\r\nVirtual method address: "
#define CurrentThreadIDMsg "\r\n\r\nThe current thread ID is 0x"
#define CurrentStackTraceMsg ", and the stack trace (return addresses) leading to this e"\
	"rror is:"
#define ThreadIDPrevAllocMsg "\r\n\r\nThis block was previously allocated by thread 0x"
#define ThreadIDAtAllocMsg "\r\n\r\nThis block was allocated by thread 0x"
#define ThreadIDAtFreeMsg "\r\n\r\nThe block was previously freed by thread 0x"
#define ThreadIDAtObjectAllocMsg "\r\n\r\nThe object was allocated by thread 0x"
#define ThreadIDAtObjectFreeMsg "\r\n\r\nThe object was subsequently freed by thread 0x"
#define StackTraceMsg ", and the stack trace (return addresses) at the time was:"
#define AlreadyInstalledMsg "FastMM4 is already installed."
#define AlreadyInstalledTitle "Already installed."
#define OtherMMInstalledMsg "FastMM4 cannot be installed since another third party memo"\
	"ry manager has already installed itself.\r\nIf you want to"\
	" use FastMM4, please make sure that FastMM4.pas is the ver"\
	"y first unit in the \"uses\"\r\nsection of your project's "\
	".dpr file."
#define OtherMMInstalledTitle "Cannot install FastMM4 - Another memory manager is already"\
	" installed"
#define MemoryAllocatedMsg "FastMM4 cannot install since memory has already been alloc"\
	"ated through the default memory manager.\r\nFastMM4.pas MU"\
	"ST be the first unit in your project's .dpr file, otherwis"\
	"e memory may be allocated\r\nthrough the default memory ma"\
	"nager before FastMM4 gains control. \r\n\r\nIf you are usi"\
	"ng an exception trapper like MadExcept (or any tool that m"\
	"odifies the unit initialization order),\r\ngo into its con"\
	"figuration page and ensure that the FastMM4.pas unit is in"\
	"itialized before any other unit."
#define MemoryAllocatedTitle "Cannot install FastMM4 - Memory has already been allocated"\
	""
#define LeakLogHeader "A memory block has been leaked. The size is: "
#define LeakMessageHeader "This application has leaked memory. "
#define SmallLeakDetail "The small block leaks are (excluding expected leaks regist"\
	"ered by pointer):\r\n"
#define LargeLeakDetail "The sizes of leaked medium and large blocks are (excluding"\
	" expected leaks registered by pointer): "
#define BytesMessage " bytes: "
#define AnsiStringBlockMessage "AnsiString"
#define UnicodeStringBlockMessage "UnicodeString"
#define LeakMessageFooter "\r\n\r\nNote: To obtain a log file containing detail on me"\
	"mory leaks, enable the \"FullDebugMode\" and \"LogMemoryLe"\
	"akDetailToFile\" conditional defines. To disable this memo"\
	"ry leak check, undefine \"EnableMemoryLeakReporting\".\r\n"\
	""
#define LeakMessageTitle "Memory Leak Detected"
#define InvalidOperationTitle "MM Operation after uninstall."
#define InvalidGetMemMsg "FastMM has detected a GetMem call after FastMM was uninsta"\
	"lled."
#define InvalidFreeMemMsg "FastMM has detected a FreeMem call after FastMM was uninst"\
	"alled."
#define InvalidReallocMemMsg "FastMM has detected a ReallocMem call after FastMM was uni"\
	"nstalled."
#define InvalidAllocMemMsg "FastMM has detected an AllocMem call after FastMM was unin"\
	"stalled."

}	/* namespace Fastmm4messages */
using namespace Fastmm4messages;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FastMM4Messages
