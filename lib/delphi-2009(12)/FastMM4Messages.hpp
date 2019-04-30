// CodeGear C++Builder
// Copyright (c) 1995, 2008 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Fastmm4messages.pas' rev: 20.00

#ifndef Fastmm4messagesHPP
#define Fastmm4messagesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fastmm4messages
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
#define FullDebugModeLibraryName32Bit L"FastMM_FullDebugMode.dll"
#define FullDebugModeLibraryName64Bit L"FastMM_FullDebugMode64.dll"
#define LogFileExtension L"_MemoryManager_EventLog.txt"
#define CRLF L"\r\n"
#define EventSeparator L"--------------------------------"
#define UnknownClassNameMsg L"Unknown"
#define MemoryDumpMsg L"\r\n\r\nCurrent memory dump of 256 bytes starting at point"\
	"er address "
#define BlockScanLogHeader L"Allocated block logged by LogAllocatedBlocksToFile. The si"\
	"ze is: "
#define ErrorMsgHeader L"FastMM has detected an error during a "
#define GetMemMsg L"GetMem"
#define FreeMemMsg L"FreeMem"
#define ReallocMemMsg L"ReallocMem"
#define BlockCheckMsg L"free block scan"
#define OperationMsg L" operation. "
#define BlockHeaderCorruptedMsg L"The block header has been corrupted. "
#define BlockFooterCorruptedMsg L"The block footer has been corrupted. "
#define FreeModifiedErrorMsg L"FastMM detected that a block has been modified after being"\
	" freed. "
#define FreeModifiedDetailMsg L"\r\n\r\nModified byte offsets (and lengths): "
#define DoubleFreeErrorMsg L"An attempt has been made to free/reallocate an unallocated"\
	" block."
#define WrongMMFreeErrorMsg L"An attempt has been made to free/reallocate a block that w"\
	"as allocated through a different FastMM instance. Check yo"\
	"ur memory manager sharing settings."
#define PreviousBlockSizeMsg L"\r\n\r\nThe previous block size was: "
#define CurrentBlockSizeMsg L"\r\n\r\nThe block size is: "
#define PreviousObjectClassMsg L"\r\n\r\nThe block was previously used for an object of cla"\
	"ss: "
#define CurrentObjectClassMsg L"\r\n\r\nThe block is currently used for an object of class"\
	": "
#define PreviousAllocationGroupMsg L"\r\n\r\nThe allocation group was: "
#define PreviousAllocationNumberMsg L"\r\n\r\nThe allocation number was: "
#define CurrentAllocationGroupMsg L"\r\n\r\nThe allocation group is: "
#define CurrentAllocationNumberMsg L"\r\n\r\nThe allocation number is: "
#define BlockErrorMsgTitle L"Memory Error Detected"
#define VirtualMethodErrorHeader L"FastMM has detected an attempt to call a virtual method on"\
	" a freed object. An access violation will now be raised in"\
	" order to abort the current operation."
#define InterfaceErrorHeader L"FastMM has detected an attempt to use an interface of a fr"\
	"eed object. An access violation will now be raised in orde"\
	"r to abort the current operation."
#define BlockHeaderCorruptedNoHistoryMsg L" Unfortunately the block header has been corrupted so no h"\
	"istory is available."
#define FreedObjectClassMsg L"\r\n\r\nFreed object class: "
#define VirtualMethodName L"\r\n\r\nVirtual method: "
#define VirtualMethodOffset L"Offset +"
#define VirtualMethodAddress L"\r\n\r\nVirtual method address: "
#define CurrentThreadIDMsg L"\r\n\r\nThe current thread ID is 0x"
#define CurrentStackTraceMsg L", and the stack trace (return addresses) leading to this e"\
	"rror is:"
#define ThreadIDPrevAllocMsg L"\r\n\r\nThis block was previously allocated by thread 0x"
#define ThreadIDAtAllocMsg L"\r\n\r\nThis block was allocated by thread 0x"
#define ThreadIDAtFreeMsg L"\r\n\r\nThe block was previously freed by thread 0x"
#define ThreadIDAtObjectAllocMsg L"\r\n\r\nThe object was allocated by thread 0x"
#define ThreadIDAtObjectFreeMsg L"\r\n\r\nThe object was subsequently freed by thread 0x"
#define StackTraceMsg L", and the stack trace (return addresses) at the time was:"
#define AlreadyInstalledMsg L"FastMM4 is already installed."
#define AlreadyInstalledTitle L"Already installed."
#define OtherMMInstalledMsg L"FastMM4 cannot be installed since another third party memo"\
	"ry manager has already installed itself.\r\nIf you want to"\
	" use FastMM4, please make sure that FastMM4.pas is the ver"\
	"y first unit in the \"uses\"\r\nsection of your project's "\
	".dpr file."
#define OtherMMInstalledTitle L"Cannot install FastMM4 - Another memory manager is already"\
	" installed"
#define MemoryAllocatedMsg L"FastMM4 cannot install since memory has already been alloc"\
	"ated through the default memory manager.\r\nFastMM4.pas MU"\
	"ST be the first unit in your project's .dpr file, otherwis"\
	"e memory may be allocated\r\nthrough the default memory ma"\
	"nager before FastMM4 gains control. \r\n\r\nIf you are usi"\
	"ng an exception trapper like MadExcept (or any tool that m"\
	"odifies the unit initialization order),\r\ngo into its con"\
	"figuration page and ensure that the FastMM4.pas unit is in"\
	"itialized before any other unit."
#define MemoryAllocatedTitle L"Cannot install FastMM4 - Memory has already been allocated"\
	""
#define LeakLogHeader L"A memory block has been leaked. The size is: "
#define LeakMessageHeader L"This application has leaked memory. "
#define SmallLeakDetail L"The small block leaks are (excluding expected leaks regist"\
	"ered by pointer):\r\n"
#define LargeLeakDetail L"The sizes of leaked medium and large blocks are (excluding"\
	" expected leaks registered by pointer): "
#define BytesMessage L" bytes: "
#define AnsiStringBlockMessage L"AnsiString"
#define UnicodeStringBlockMessage L"UnicodeString"
#define LeakMessageFooter L"\r\n\r\nNote: To obtain a log file containing detail on me"\
	"mory leaks, enable the \"FullDebugMode\" and \"LogMemoryLe"\
	"akDetailToFile\" conditional defines. To disable this memo"\
	"ry leak check, undefine \"EnableMemoryLeakReporting\".\r\n"\
	""
#define LeakMessageTitle L"Memory Leak Detected"
#define InvalidOperationTitle L"MM Operation after uninstall."
#define InvalidGetMemMsg L"FastMM has detected a GetMem call after FastMM was uninsta"\
	"lled."
#define InvalidFreeMemMsg L"FastMM has detected a FreeMem call after FastMM was uninst"\
	"alled."
#define InvalidReallocMemMsg L"FastMM has detected a ReallocMem call after FastMM was uni"\
	"nstalled."
#define InvalidAllocMemMsg L"FastMM has detected an AllocMem call after FastMM was unin"\
	"stalled."

}	/* namespace Fastmm4messages */
using namespace Fastmm4messages;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fastmm4messagesHPP
