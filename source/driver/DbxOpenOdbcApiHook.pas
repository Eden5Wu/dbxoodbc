{
  Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.18
}
unit DbxOpenOdbcApiHook;

{$i DbxOpenOdbc.inc}

{$UNDEF _SUPPORTED_HOOK_}
{.$IFDEF MSWINDOWS} //todo: kylix test ??? //todo: osx test ???
  {$IFDEF CPUX86}
     {$DEFINE _SUPPORTED_HOOK_}
  {$ENDIF}
{.$ENDIF}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ELSE !MSWINDOWS}
  {$IFDEF _KYLIX_}
  Types, Libc,
  {$ELSE !_KYLIX_}
  {$IFDEF POSIX}
  Posix.SysMman, //Posix.Unistd, {Posix.Stdio, Posix.String_, {Posix.Pthread,}
  {$ENDIF}{$ENDIF}{$ENDIF}
  SysUtils,
  Classes;

//
// @@@ wasm:
//{------------------------------------------------------------------------------------------------------}
//
// http://wasm.ru/article.php?article=apihook_2
// http://wasm.ru/pub/21/files/advapihook.rar
//

type

{$IFDEF POSIX}
  DWORD = LongWord;
  PDWORD = ^DWORD;
{$ENDIF}

{$IFDEF _D16UP_}

{$ELSE !_D16UP_}

{$IFDEF FPC}
  NativeInt = PtrInt;
{$ELSE !FPC}
  {$IFDEF CPUX64}
  NativeInt = LongWord;
  NativeUInt = LongWord;
  {$ELSE}
  NativeInt = Integer;
  NativeUInt = Cardinal;
  {$ENDIF}
{$ENDIF !FPC}

  PNativeInt=^NativeInt;
  PPointer = ^Pointer;

{$ENDIF !_D16UP_}

  PPPointer = ^PPointer;

{$IFDEF _SUPPORTED_HOOK_}

{$IFDEF CPUX64}
//
// TODO: ...
//
{$ELSE !CPUX64}

{$IFDEF CPUX86}
function SizeOfCode(Code: Pointer): NativeInt;
function SizeOfProc(Proc: Pointer): NativeInt;
function SaveOldFunction(Proc: Pointer; Old: Pointer): NativeInt;
function HookCode(TargetProc, NewProc: Pointer; var OldProc: Pointer): Boolean;
function UnhookCode(OldProc: Pointer): Boolean;
function HookProc(lpModuleName, lpProcName: PChar; NewProc: Pointer; var OldProc: Pointer): Boolean;

//
//{------------------------------------------------------------------------------------------------------}
// @@@ wasm.
//

//
// Win32IAT:
//{------------------------------------------------------------------------------------------------------}
//
{$IFDEF MSWINDOWS}
//
// http://www.experts-exchange.com/Programming/Languages/Pascal/Delphi/Q_21709234.html
//
//   Unit        :  Win32IAT
//   Author      :  rllibby
//   Date        :  11.10.2005
//   Description :  Win32 process Import Address Table (IAT) patching class.
//                  This class allows patching of imported functions in all
//                  Windows versions.
type
  IndirectAddr      =  ^Pointer;
const
  MAX_LIBRARYNAME   =  MAX_PATH;
  MAX_FUNCTIONNAME  =  255;
type
  PImageImportDesc  =  ^TImageImportDesc;
  TImageImportDesc  =  packed record
     FuncNameList:  DWORD;
     TimeDateStamp: DWORD;
     ForwarderChain:DWORD;
     Name:          DWORD;
     FirstThunk:    DWORD;
  end;
  PHintTable        =  ^THintTable;
  THintTable        =  packed record
     FuncName:      DWORD;
  end;
  PIATListEntry     =  ^TIATListEntry;
  TIATListEntry     =  packed record
     IAT:           IndirectAddr;
     Next:          PIATListEntry;
  end;
  PPatchRecord      =  ^TPatchRecord;
  TPatchRecord       =  packed record
     LibraryName:   Array [0..MAX_LIBRARYNAME] of Char;
     FunctionName:  Array [0..MAX_FUNCTIONNAME] of Char;
     FunctionAddr:  Pointer;
     IATList:       PIATListEntry;
  end;
type
  TIATPatch         =  class(TObject)
  private
     // Private decalations
     FLock:         TRTLCriticalSection;
     FPatchList:    TList;
     FUnpatch:      Boolean;
     procedure      BuildIATPatchList(LibraryName, FunctionName: String; var List: PIATListEntry);
     function       CompareLibraryNames(Name1, Name2: String): Boolean;
     procedure      EnumIATList(Module: HMODULE; LibraryName, FunctionName: String; var List: PIATListEntry);
     function       ListContainsIAT(List: PIATListEntry; IAT: IndirectAddr): Boolean;
     function       NextFunctionName(lpName: PChar): PChar;
     function       UpdatePatch(PatchRecord: PPatchRecord; FunctionAddress: Pointer): Boolean;
     function       UpdateEntry(Entry: PIATListEntry; FunctionAddress: Pointer): Boolean;
  protected
     // Protected declarations
     function       GetCount: Integer;
     function       GetPatchRecord(Index: Integer): PPatchRecord;
     function       GetUnpatchOnFree: Boolean;
     procedure      SetUnpatchOnFree(Value: Boolean);
  public
     // Public declarations
     constructor    Create;
     destructor     Destroy; override;
     procedure      Clear(Unpatch: Boolean);
     procedure      Delete(Index: Integer; Unpatch: Boolean);
     function       Find(LibraryName, FunctionName: String): PPatchRecord;
     function       Patch(LibraryName, FunctionName: String; NewFunction: Pointer; out OldFunction: Pointer): Boolean;
     procedure      Unpatch(LibraryName, FunctionName: String);
     property       Count: Integer read GetCount;
     property       Items[Index: Integer]: PPatchRecord read GetPatchRecord; default;
     property       UnpatchOnFree: Boolean read GetUnpatchOnFree write SetUnpatchOnFree;
  end;
{$ENDIF MSWINDOWS}
//
//{------------------------------------------------------------------------------------------------------}
// Win32IAT.
//

// @@@ dbxoodbc @@@ : http://open-dbexpress.sourceforge.net/
//{------------------------------------------------------------------------------------------------------}
// {begin cut : dbxoodbc: Dbx23Fix.pas}
// *********************** RUNTIME PATCH ***********************

type
  PJumpInstruction = ^TJumpInstruction;
  TJumpInstruction = packed record
    case Byte of
      1: (
        Code: Byte; // jump instruction ($FF)
        Offset: DWord; // jump offset
        UnUsed: Byte;
        );
      2: (
        DW1: DWord;
        DW2: DWord;
        );
  end;

function GetNativeAddr(Ptr: Pointer): Pointer;
function JumpFromCode(MSrc, MDest: Pointer; SaveJump: PJumpInstruction): Boolean;
function RestoreSavedCode(MSrc: Pointer; SaveJump: PJumpInstruction): Boolean;
function IsJumpFromCode(MSrc, MDest: Pointer): Boolean;

//{------------------------------------------------------------------------------------------------------}
// {end cut : dbxoodbc: Dbx23Fix.pas}

{$ENDIF CPUX86}

{$ENDIF !CPUX64}

{$ENDIF _SUPPORTED_HOOK_}

function FxtGetStubAddress(AStub: Pointer; OffsetE8: NativeInt = 0): Pointer;

{ VMT low-level utilities }

{ Returns the address of virtual method of AClass with index AIndex }
function GetVirtualMethodAddress(AClass: TClass; AIndex: Integer): Pointer;
{ Updates VMT of AClass and sets the new method address of method with index AIndex }
function SetVirtualMethodAddress(AClass: TClass; AIndex: Integer;
  NewAddress: Pointer): Pointer;
{ Iterates through VMT of AClass and seeks for method MethodAddr }
function FindVirtualMethodIndex(AClass: TClass; MethodAddr: Pointer): Integer;
{ calculate virtualmethod offset }
function GetVirtualMethodOffset(AClass: TClass; MethodAddr: Pointer): Integer;

implementation

{$IFDEF _SUPPORTED_HOOK_}

{$IFDEF CPUX64}

// TODO: ...

{$ELSE !CPUX64}

{$IFDEF CPUX86}
//
// @@@ wasm:
//{------------------------------------------------------------------------------------------------------}
//

const
  Opcodes1: array[0..255] of Word =
  (
    $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $0000, $4211, $42E4,
    $2011, $20E4, $8401, $8C42, $0000, $0000, $4211, $42E4, $2011, $20E4,
    $8401, $8C42, $0000, $0000, $4211, $42E4, $2011, $20E4, $8401, $8C42,
    $0000, $0000, $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $8000,
    $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $8000, $4211, $42E4,
    $2011, $20E4, $8401, $8C42, $0000, $8000, $0211, $02E4, $0011, $00E4,
    $0401, $0C42, $0000, $8000, $6045, $6045, $6045, $6045, $6045, $6045,
    $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045,
    $0045, $0045, $0045, $0045, $0045, $0045, $0045, $0045, $6045, $6045,
    $6045, $6045, $6045, $6045, $6045, $6045, $0000, $8000, $00E4, $421A,
    $0000, $0000, $0000, $0000, $0C00, $2CE4, $0400, $24E4, $0000, $0000,
    $0000, $0000, $1400, $1400, $1400, $1400, $1400, $1400, $1400, $1400,
    $1400, $1400, $1400, $1400, $1400, $1400, $1400, $1400, $0510, $0DA0,
    $0510, $05A0, $0211, $02E4, $A211, $A2E4, $4211, $42E4, $2011, $20E4,
    $42E3, $20E4, $00E3, $01A0, $0000, $E046, $E046, $E046, $E046, $E046,
    $E046, $E046, $8000, $0000, $0000, $0000, $0000, $0000, $0000, $8000,
    $8101, $8142, $0301, $0342, $0000, $0000, $0000, $0000, $0401, $0C42,
    $0000, $0000, $8000, $8000, $0000, $0000, $6404, $6404, $6404, $6404,
    $6404, $6404, $6404, $6404, $6C45, $6C45, $6C45, $6C45, $6C45, $6C45,
    $6C45, $6C45, $4510, $45A0, $0800, $0000, $20E4, $20E4, $4510, $4DA0,
    $0000, $0000, $0800, $0000, $0000, $0400, $0000, $0000, $4110, $41A0,
    $4110, $41A0, $8400, $8400, $0000, $8000, $0008, $0008, $0008, $0008,
    $0008, $0008, $0008, $0008, $1400, $1400, $1400, $1400, $8401, $8442,
    $0601, $0642, $1C00, $1C00, $0000, $1400, $8007, $8047, $0207, $0247,
    $0000, $0000, $0000, $0000, $0000, $0000, $0008, $0008, $0000, $0000,
    $0000, $0000, $0000, $0000, $4110, $01A0
    );

  Opcodes2: array[0..255] of Word =
  (
    $0118, $0120, $20E4, $20E4, $FFFF, $0000, $0000, $0000, $0000, $0000,
    $FFFF, $FFFF, $FFFF, $0110, $0000, $052D, $003F, $023F, $003F, $023F,
    $003F, $003F, $003F, $023F, $0110, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF,
    $FFFF, $FFFF, $4023, $4023, $0223, $0223, $FFFF, $FFFF, $FFFF, $FFFF,
    $003F, $023F, $002F, $023F, $003D, $003D, $003F, $003F, $0000, $8000,
    $8000, $8000, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF,
    $FFFF, $FFFF, $FFFF, $FFFF, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4,
    $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4,
    $4227, $003F, $003F, $003F, $003F, $003F, $003F, $003F, $003F, $003F,
    $003F, $003F, $003F, $003F, $003F, $003F, $00ED, $00ED, $00ED, $00ED,
    $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
    $0065, $00ED, $04ED, $04A8, $04A8, $04A8, $00ED, $00ED, $00ED, $0000,
    $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $0265, $02ED, $1C00, $1C00,
    $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00,
    $1C00, $1C00, $1C00, $1C00, $4110, $4110, $4110, $4110, $4110, $4110,
    $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110,
    $0000, $0000, $8000, $02E4, $47E4, $43E4, $C211, $C2E4, $0000, $0000,
    $0000, $42E4, $47E4, $43E4, $0020, $20E4, $C211, $C2E4, $20E4, $42E4,
    $20E4, $22E4, $2154, $211C, $FFFF, $FFFF, $05A0, $42E4, $20E4, $20E4,
    $2154, $211C, $A211, $A2E4, $043F, $0224, $0465, $24AC, $043F, $8128,
    $6005, $6005, $6005, $6005, $6005, $6005, $6005, $6005, $FFFF, $00ED,
    $00ED, $00ED, $00ED, $00ED, $02ED, $20AC, $00ED, $00ED, $00ED, $00ED,
    $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
    $003F, $02ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
    $FFFF, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
    $00ED, $00ED, $00ED, $00ED, $00ED, $0000
    );

  Opcodes3: array[0..9] of array[0..15] of Word =
  (
    ($0510, $FFFF, $4110, $4110, $8110, $8110, $8110, $8110, $0510, $FFFF,
    $4110, $4110, $8110, $8110, $8110, $8110),
    ($0DA0, $FFFF, $41A0, $41A0, $81A0, $81A0, $81A0, $81A0, $0DA0, $FFFF,
    $41A0, $41A0, $81A0, $81A0, $81A0, $81A0),
    ($0120, $0120, $0120, $0120, $0120, $0120, $0120, $0120, $0036, $0036,
    $0030, $0030, $0036, $0036, $0036, $0036),
    ($0120, $FFFF, $0120, $0120, $0110, $0118, $0110, $0118, $0030, $0030,
    $0000, $0030, $0000, $0000, $0000, $0000),
    ($0120, $0120, $0120, $0120, $0120, $0120, $0120, $0120, $0036, $0036,
    $0036, $0036, $FFFF, $0000, $FFFF, $FFFF),
    ($0120, $FFFF, $0120, $0120, $FFFF, $0130, $FFFF, $0130, $0036, $0036,
    $0036, $0036, $0000, $0036, $0036, $0000),
    ($0128, $0128, $0128, $0128, $0128, $0128, $0128, $0128, $0236, $0236,
    $0030, $0030, $0236, $0236, $0236, $0236),
    ($0128, $FFFF, $0128, $0128, $0110, $FFFF, $0110, $0118, $0030, $0030,
    $0030, $0030, $0030, $0030, $FFFF, $FFFF),
    ($0118, $0118, $0118, $0118, $0118, $0118, $0118, $0118, $0236, $0236,
    $0030, $0236, $0236, $0236, $0236, $0236),
    ($0118, $FFFF, $0118, $0118, $0130, $0128, $0130, $0128, $0030, $0030,
    $0030, $0030, $0000, $0036, $0036, $FFFF)
    );

function SizeOfCode(Code: Pointer): NativeInt;
var
  Opcode: Word;
  Modrm: Byte;
  Fixed, AddressOveride: Boolean;
  Last, OperandOveride, Flags, Rm, Size, Extend: NativeInt;
begin
  try
    Last := NativeInt(Code);
    if Code <> nil then
    begin
      AddressOveride := False;
      Fixed := False;
      OperandOveride := 4;
      Extend := 0;
      repeat
        Opcode := Byte(Code^);
        Code := Pointer(NativeInt(NativeInt(Code) + 1));
        if Opcode = $66 then
          OperandOveride := 2
        else if Opcode = $67 then
          AddressOveride := True
        else if not ((Opcode and $E7) = $26) then
          if not (Opcode in [$64..$65]) then
            Fixed := True;
      until Fixed;
      if Opcode = $0F then
      begin
        Opcode := Byte(Code^);
        Flags := Opcodes2[Opcode];
        Opcode := Opcode + $0F00;
        Code := Pointer(NativeInt(NativeInt(Code) + 1));
      end
      else
        Flags := Opcodes1[Opcode];

      if ((Flags and $0038) <> 0) then
      begin
        Modrm := Byte(Code^);
        Rm := Modrm and $7;
        Code := Pointer(NativeInt(NativeInt(Code) + 1));

        case (Modrm and $C0) of
          $40: Size := 1;
          $80: if AddressOveride then
              Size := 2
            else
              Size := 4;
        else
          Size := 0;
        end;

        if not (((Modrm and $C0) <> $C0) and AddressOveride) then
        begin
          if (Rm = 4) and ((Modrm and $C0) <> $C0) then
            Rm := Byte(Code^) and $7;
          if ((Modrm and $C0 = 0) and (Rm = 5)) then
            Size := 4;
          Code := Pointer(NativeInt(NativeInt(Code) + Size));
        end;

        if ((Flags and $0038) = $0008) then
        begin
          case Opcode of
            $F6: Extend := 0;
            $F7: Extend := 1;
            $D8: Extend := 2;
            $D9: Extend := 3;
            $DA: Extend := 4;
            $DB: Extend := 5;
            $DC: Extend := 6;
            $DD: Extend := 7;
            $DE: Extend := 8;
            $DF: Extend := 9;
          end;
          if ((Modrm and $C0) <> $C0) then
            Flags := Opcodes3[Extend][(Modrm shr 3) and $7]
          else
            Flags := Opcodes3[Extend][((Modrm shr 3) and $7) + 8];
        end;

      end;
      case (Flags and $0C00) of
        $0400: Code := Pointer(NativeInt(NativeInt(Code) + 1));
        $0800: Code := Pointer(NativeInt(NativeInt(Code) + 2));
        $0C00: Code := Pointer(NativeInt(NativeInt(Code) + OperandOveride));
      else
        begin
          case Opcode of
            $9A, $EA: Code := Pointer(NativeInt(NativeInt(Code) + OperandOveride + 2));
            $C8: Code := Pointer(NativeInt(NativeInt(Code) + 3));
            $A0..$A3:
              begin
                if AddressOveride then
                  Code := Pointer(NativeInt(NativeInt(Code) + 2))
                else
                  Code := Pointer(NativeInt(NativeInt(Code) + 4));
              end;
          end;
        end;
      end;
    end;
    Result := NativeInt(Code) - Last;
  except
    Result := 0;
  end;
end;

function SizeOfProc(Proc: Pointer): NativeInt;
var
  Length: NativeInt;
begin
  Result := 0;
  repeat
    Length := SizeOfCode(Proc);
    Inc(Result, Length);
    if ((Length = 1) and (Byte(Proc^) = $C3)) then
      Break;
    Proc := Pointer(NativeInt(NativeInt(Proc) + Length));
  until Length = 0;
end;

function SaveOldFunction(Proc: Pointer; Old: Pointer): NativeInt;
var
  SaveSize, Size: NativeInt;
  Next: Pointer;
begin
  SaveSize := 0;
  Next := Proc;
  while SaveSize < 5 do
  begin
    Size := SizeOfCode(Next);
    Next := Pointer(NativeInt(NativeInt(Next) + Size));
    Inc(SaveSize, Size);
  end;
  {$IFDEF MSWINDOWS}
  CopyMemory(Old, Proc, SaveSize);
  {$ELSE}
  Move(Proc, Old, SaveSize);
  {$ENDIF}
  Byte(Pointer(NativeInt(NativeInt(Old) + SaveSize))^) := $E9;
  NativeInt(Pointer(NativeInt(NativeInt(Old) + SaveSize + 1))^) := NativeInt(NativeInt(Next) - NativeInt(Old) - SaveSize - 5);
  Result := SaveSize;
end;

function HookCode(TargetProc, NewProc: Pointer; var OldProc: Pointer): Boolean;
var
  Address: NativeInt;
  {$IFDEF MSWINDOWS}
  OldProtect: DWord;
  {$ENDIF}
  OldFunction: Pointer;
  Proc: Pointer;
begin
  Result := False;
  OldFunction := nil;
  try
    Proc := TargetProc;
    Address := NativeInt(NativeInt(NewProc) - NativeInt(Proc) - 5);
    GetMem(OldFunction, 255);
    {+}
    {$IFDEF MSWINDOWS}
    if not VirtualProtect(OldFunction, 255, PAGE_EXECUTE_READWRITE, OldProtect) then
      Abort;
    if not VirtualProtect(Proc, 255, PAGE_EXECUTE_READWRITE, OldProtect) then
      Abort;
    {$ELSE}
    {$IFDEF POSIX}
    if mprotect(OldFunction, 255, PROT_WRITE or PROT_EXEC) <> 0 then
      Abort;
    if mprotect(Proc, 255, PROT_WRITE or PROT_EXEC) <> 0 then
      Abort;
    {$ENDIF}
    {$ENDIF}
    {+.}
    NativeInt(OldFunction^) := NativeInt(Proc);
    //
    {$IFDEF CPUX86}
    Byte(Pointer(NativeInt(NativeInt(OldFunction) + 4))^) := SaveOldFunction(Proc, Pointer(NativeInt(NativeInt(OldFunction) + 5)));
    Byte(Proc^) := $E9;
    NativeInt(Pointer(NativeInt(NativeInt(Proc) + 1))^) := Address;
    {$ELSE CPUX86}
    ERROR_PLATFORM_NOT_SUPPORTED
    {$ENDIF}
    //
    {$IFDEF MSWINDOWS}
    VirtualProtect(Proc, 255, OldProtect, OldProtect);
    {+}
    FlushInstructionCache(GetCurrentProcess, Proc, 255);
    FlushInstructionCache(GetCurrentProcess, OldFunction, 255);
    {$ELSE}
    {$IFDEF POSIX}
    mprotect(Proc, 255, PROT_READ or PROT_EXEC);
    {$ENDIF}
    {$ENDIF}
    {+.}
    OldProc := Pointer(NativeInt(NativeInt(OldFunction) + 5));
  except
    if Assigned(OldFunction) then
      FreeMem(OldFunction);
    Exit;
  end;
  Result := True;
end;

function HookProc(lpModuleName, lpProcName: PChar; NewProc: Pointer; var OldProc: Pointer): Boolean;
var
  hModule: NativeInt;
  fnAdr: Pointer;
begin
  Result := False;
  hModule := GetModuleHandle(lpModuleName);
  if hModule = 0 then
    hModule := LoadLibrary(lpModuleName);
  if hModule = 0 then
    Exit;
  fnAdr := GetProcAddress(hModule, lpProcName);
  if fnAdr = nil then
    Exit;
  Result := HookCode(fnAdr, NewProc, OldProc);
end;

function UnhookCode(OldProc: Pointer): Boolean;
var
  {$IFDEF MSWINDOWS}
  OldProtect: DWord;
  {$ENDIF}
  Proc: Pointer;
  SaveSize, iProtect: NativeInt;
begin
  Result := True;
  if OldProc <> nil then
  try
    Proc := Pointer(NativeInt(Pointer(NativeInt(NativeInt(OldProc) - 5))^));
    SaveSize := Byte(Pointer(NativeInt(NativeInt(OldProc) - 1))^);
    {+}
    iProtect := SaveSize;
    if (iProtect < 5) then
      iProtect := 5
    else if (iProtect > 255) then
      iProtect := 255;
    {+.}
    {$IFDEF MSWINDOWS}
    VirtualProtect(Proc, {5}iProtect, PAGE_EXECUTE_READWRITE, OldProtect);
    {$ELSE}
    {$IFDEF POSIX}
    mprotect(Proc, iProtect, PROT_WRITE or PROT_EXEC);
    {$ENDIF}
    {$ENDIF}
    //
    {$IFDEF MSWINDOWS}
    CopyMemory(Proc, OldProc, SaveSize);
    {$ELSE}
    Move(OldProc, Proc, SaveSize);
    {$ENDIF}
    //
    {$IFDEF MSWINDOWS}
    VirtualProtect(Proc, {5}iProtect, OldProtect, OldProtect);
    {+}
    FlushInstructionCache(GetCurrentProcess, Proc, iProtect);
    {$ELSE}
    {$IFDEF POSIX}
    mprotect(Proc, iProtect, PROT_READ or PROT_EXEC);
    {$ENDIF}
    {$ENDIF}
    {+.}
    FreeMem(Pointer(NativeInt(NativeInt(OldProc) - 5)));
  except
    Result := False;
  end;
end;

//
//{------------------------------------------------------------------------------------------------------}
// @@@ wasm.
//

// @@@ dbxoodbc @@@ : http://open-dbexpress.sourceforge.net/
//{------------------------------------------------------------------------------------------------------}
// {begin cut : dbxoodbc: Dbx23Fix.pas}
// *********************** RUNTIME PATCH ***********************

const
  PAGE_RW_FLAG = {$IFDEF POSIX}PROT_READ or PROT_WRITE{$ELSE}PAGE_READWRITE{$ENDIF};

function GetNativeAddr(Ptr: Pointer): Pointer;
begin
  Result := Ptr;
  {$IFDEF CPUX86}
  if (PJumpInstruction(Result)^.Code = $FF) and // long jmp to package_address_5b
    (PJumpInstruction(NativeInt(Result) + 6)^.Code = $8B) and // mov
    (PJumpInstruction(NativeInt(Result) + 7)^.Code = $C0) {// eax,eax} then
    Result := PPPointer(NativeInt(Result) + 2)^^;
  {$ELSE CPUX86}
  ERROR_PLATFORM_NOT_SUPPORTED
  {$ENDIF}
end;

function JumpFromCode(MSrc, MDest: Pointer; SaveJump: PJumpInstruction): Boolean;
{$IFDEF MSWINDOWS}
var
  SaveFlagSrc: DWord;
{$ENDIF}
begin
  Result := False;
  if Assigned(SaveJump) then
    FillChar(SaveJump^, SizeOf(TJumpInstruction), 0);
  if MSrc = nil then
    Exit;
  if MSrc = MDest then
    Exit;
  MSrc := GetNativeAddr(MSrc);
  if MSrc = MDest then
    Exit;
  {$IFDEF MSWINDOWS}
  if VirtualProtect(MSrc, SizeOf(TJumpInstruction), PAGE_RW_FLAG, @SaveFlagSrc) then
  {$ELSE}
  {$IFDEF POSIX}
  if mprotect(MSrc, SizeOf(TJumpInstruction), PAGE_RW_FLAG) = 0 then
  {$ENDIF}
  {$ENDIF}
  try
    if Assigned(SaveJump) then
      SaveJump^ := PJumpInstruction(MSrc)^;
    with PJumpInstruction(MSrc)^ do
    begin
      {$IFDEF CPUX86}
      Code := $E9; // JMP SIZE = 5b
      Offset := NativeInt(MDest) - NativeInt(MSrc) - 5;
      {$ELSE CPUX86}
      ERROR_PLATFORM_NOT_SUPPORTED
      {$ENDIF}
    end;
    Result := True;
  finally
    {$IFDEF MSWINDOWS}
    VirtualProtect(MSrc, SizeOf(TJumpInstruction), SaveFlagSrc, @SaveFlagSrc);
    FlushInstructionCache(GetCurrentProcess, MSrc, SizeOf(TJumpInstruction));
    {$ELSE}
    {$IFDEF POSIX}
    mprotect(MSrc, SizeOf(TJumpInstruction), PROT_READ or PROT_EXEC);
    {$ENDIF}
    {$ENDIF}
  end;
end;

function RestoreSavedCode(MSrc: Pointer; SaveJump: PJumpInstruction): Boolean;
{$IFDEF MSWINDOWS}
var
  SaveFlagSrc: DWord;
{$ENDIF}
begin
  Result := False;
  if (SaveJump = nil) or (SaveJump.Code = 0) or (MSrc = nil) then
    Exit;
  MSrc := GetNativeAddr(MSrc);
  try
    {$IFDEF MSWINDOWS}
    if VirtualProtect(MSrc, SizeOf(TJumpInstruction), PAGE_RW_FLAG, @SaveFlagSrc) then
    {$ELSE}
    {$IFDEF POSIX}
    if mprotect(MSrc, SizeOf(TJumpInstruction), PAGE_RW_FLAG) = 0 then
    {$ENDIF}
    {$ENDIF}
    try
      PJumpInstruction(MSrc)^ := SaveJump^; // Restore Code
       // Clear Buffer
      FillChar(SaveJump, SizeOf(TJumpInstruction), 0);
    finally
      {$IFDEF MSWINDOWS}
      VirtualProtect(MSrc, SizeOf(TJumpInstruction), SaveFlagSrc, @SaveFlagSrc);
      FlushInstructionCache(GetCurrentProcess, MSrc, SizeOf(TJumpInstruction));
      {$ELSE}
      {$IFDEF POSIX}
      mprotect(MSrc, SizeOf(TJumpInstruction), PROT_READ or PROT_EXEC);
      {$ENDIF}
      {$ENDIF}
    end;
    Result := True;
  except
  end;
end;

function IsJumpFromCode(MSrc, MDest: Pointer): Boolean;
begin
  if (MSrc = nil) or (MDest = nil) then
    Result := False
  else
    with PJumpInstruction(MSrc)^ do
    begin
      {$IFDEF CPUX86}
      Result := (Code = $E9) and (NativeInt(Offset) = (NativeInt(MDest) - NativeInt(MSrc) - 5));
      {$ELSE CPUX86}
      ERROR_PLATFORM_NOT_SUPPORTED
      {$ENDIF}
    end;
end; { IsJumpFromCode }

//{------------------------------------------------------------------------------------------------------}
// {end cut : dbxoodbc: Dbx23Fix.pas}

//
// Win32IAT:
//{------------------------------------------------------------------------------------------------------}
//
{$IFDEF MSWINDOWS}

function TIATPatch.NextFunctionName(lpName: PChar): PChar;
begin
  // Skip to the next function name
  result:=StrEnd(lpName);

  // Check distance
  case Odd((result-lpName) mod 4) of
     // Push by 4
     False    :  Inc(result, 4);
     // Push by 3
     True     :  Inc(result, 3);
  end;
end;

function TIATPatch.ListContainsIAT(List: PIATListEntry; IAT: IndirectAddr): Boolean;
var  lpEntry:       PIATListEntry;
begin
  // Set default result
  result:=False;

  // Check list pointer
  if Assigned(List) then
  begin
     // Get list head
     lpEntry:=List;
     // Walk the list
     while Assigned(lpEntry) do
     begin
        // Check to see if the entry contains the IAT
        if (lpEntry^.IAT = IAT) then
        begin
           // Found the IAT in the list
           result:=True;
           // Done processing
           break;
        end;
        // Move to next entry
        lpEntry:=lpEntry^.Next;
     end;
  end;
end;

function TIATPatch.CompareLibraryNames(Name1, Name2: String): Boolean;
begin
  // Check names
  if (Length(Name1) > 0) and (Length(Name2) > 0) then
     // Extract the file names without extensions and compare with case
     result:=(CompareText(ChangeFileExt(ExtractFileName(Name1), EmptyStr), ChangeFileExt(ExtractFileName(Name2), EmptyStr)) = 0)
  else
     // One or both names are zero length
     result:=False;
end;

function TIATPatch.UpdateEntry(Entry: PIATListEntry; FunctionAddress: Pointer): Boolean;
var  dwProtect:     DWORD;
begin
  // Check IAT entry assignment
  if Assigned(Entry) then
  begin
     // Make sure we can modify the memory
     if VirtualProtect(Entry^.IAT, SizeOf(Pointer), PAGE_EXECUTE_READWRITE, dwProtect) then
     begin
        // Update the IAT entry with the function address
        Entry^.IAT^:=FunctionAddress;
        // Reset the memory protection
        VirtualProtect(Entry^.IAT, SizeOf(Pointer), dwProtect, dwProtect);
        // Flush the instruction cache
        FlushInstructionCache(GetCurrentProcess, nil, 0);
        // Success
        result:=True;
     end
     else
        // Failed to unprotect memory
        result:=False;
  end
  else
     // Failure
     result:=False;
end;

function TIATPatch.UpdatePatch(PatchRecord: PPatchRecord; FunctionAddress: Pointer): Boolean;
var  lpEntry:       PIATListEntry;
begin
  // Check patch record
  if Assigned(PatchRecord) then
  begin
     // Get first entry
     lpEntry:=PatchRecord^.IATList;
     // Walk the IAT entry list and update
     while Assigned(lpEntry) do
     begin
        // Update the entry
        UpdateEntry(lpEntry, FunctionAddress);
        // Get next entry
        lpEntry:=lpEntry^.Next;
     end;
     // Success
     result:=True;
  end
  else
     // Failure
     result:=False;
end;

procedure TIATPatch.EnumIATList(Module: HMODULE; LibraryName, FunctionName: String; var List: PIATListEntry);
var  lpNTHeaders:   PImageNtHeaders;
     lpDosHeader:   PImageDosHeader;
     lpImageDesc:   PImageImportDesc;
     lpHintTable:   PHintTable;
     lpEntry:       PIATListEntry;
     lpIAT:         IndirectAddr;
     lpszName:      PChar;
     dwEndDesc:     DWORD;
     dwLimit:       DWORD;
begin

  // Don't patch system modules on Win9x systems
  if (Module > 0) and (((GetVersion and $80000000) = 0) or (Module < $80000000)) then
  begin
     // Convert module pointer to DOS header
     lpDosHeader:=Pointer(Module);
     // Get the NT header
     lpNTHeaders:=Pointer(Integer(lpDosHeader) + lpDosHeader^._lfanew);
     // Get the max valid address size
     dwLimit:=DWORD(lpDosHeader) + lpNTHeaders^.OptionalHeader.SizeOfImage;
     // Handle the NT image imports
     with lpNTHeaders^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT] do
     begin
        // Get import entry description
        lpImageDesc:=Pointer(DWORD(lpDosHeader)+VirtualAddress);
        // Get ending point for description
        dwEndDesc:=lpImageDesc^.FirstThunk+Size;
     end;
     // Continue while the image description is still valid
     while (lpImageDesc^.Name > 0) and (lpImageDesc^.FirstThunk < dwEndDesc) and (lpImageDesc^.FirstThunk > 0) do
     begin
        // Get the libary name
        lpszName:=PChar(DWORD(lpDosHeader) + lpImageDesc^.Name);
        // Check against the passed library name
        if CompareLibraryNames(LibraryName, lpszName) then
        begin
           // Get the start of the import address table
           lpIAT:=Pointer(DWORD(lpDosHeader) + lpImageDesc^.FirstThunk);
           // Check the function name list
           if (lpImageDesc^.FuncNameList > 0) then
              // Used hint table
              lpHintTable:=Pointer(DWORD(lpDosHeader) + lpImageDesc^.FuncNameList)
           else
              // No hint table
              lpHintTable:=nil;
           // Iterate the IAT table
           while Assigned(lpIAT) and Assigned(lpIAT^)do
           begin
              // Check the function name hint table
              if Assigned(lpHintTable) then
              begin
                 // Check for valid name
                 if (DWORD(lpDosHeader) + lpHintTable^.FuncName + 2 > DWORD(lpDosHeader)) and
                    (DWORD(lpDosHeader) + lpHintTable^.FuncName + 2 < dwLimit) then
                    // Set name from hint
                    lpszName:=Pointer(DWORD(lpDosHeader) + lpHintTable^.FuncName + 2)
                 else
                    // Clear name
                    lpszName:=nil;
                 // Increment the name pointer table
                 Inc(lpHintTable);
              end
              else
                 // Get the function name
                 lpszName:=NextFunctionName(lpszName);
              // Check for assigned function name
              if Assigned(lpszName) then
              begin
                 // Check against passed name
                 if (StrIComp(PChar(FunctionName), lpszName) = 0) then
                 begin
                    // Check to see if this is already in the list
                    if not(ListContainsIAT(List, lpIAT)) then
                    begin
                       // Create new list entry
                       lpEntry:=AllocMem(SizeOf(TIATListEntry));
                       // Update the IAT entry address
                       lpEntry^.IAT:=lpIAT;
                       // Set next pointer
                       lpEntry^.Next:=List;
                       // Update the head of the list
                       List:=lpEntry;
                    end;
                 end;
              end;
              // Get the next import table entry
              Inc(lpIAT);
           end;
        end
        else
           // Enumerate the library
           EnumIATList(GetModuleHandle(lpszName), LibraryName, FunctionName, List);
        // Get the next import library description
        Inc(lpImageDesc);
     end;
  end;

end;

procedure TIATPatch.BuildIATPatchList(LibraryName, FunctionName: String; var List: PIATListEntry);
begin

  // Enum the IAT for the process
  EnumIATList(GetModuleHandle(nil), LibraryName, FunctionName, List);

  // If we are a library, then patch our IAT as well
  if IsLibrary then EnumIATList(HInstance, LibraryName, FunctionName, List);

end;

procedure TIATPatch.Unpatch(LibraryName, FunctionName: String);
var  lpPatch:       PPatchRecord;
     lpEntry:       PIATListEntry;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Attempt to find the matching patch record
     lpPatch:=Find(LibraryName, FunctionName);
     // Did we find the patch record?
     if Assigned(lpPatch) then
     begin
        // Remove from patch list
        FPatchList.Remove(lpPatch);
        // Resource protection
        try
           // Walk the IAT entries and reset them to their old function address
           while Assigned(lpPatch^.IATList) do
           begin
              // Get current IAT entry item
              lpEntry:=lpPatch^.IATList;
              // Move list head to next entry
              lpPatch^.IATList:=lpPatch^.IATList^.Next;
              // Unpatch the entry
              UpdateEntry(lpEntry, lpPatch^.FunctionAddr);
              // Free the memory for the entry
              FreeMem(lpEntry);
           end;
        finally
           // Free the patch record memory
           FreeMem(lpPatch);
        end;
     end;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

function TIATPatch.Patch(LibraryName, FunctionName: String; NewFunction: Pointer; out OldFunction: Pointer): Boolean;
var  lpPatch:       PPatchRecord;
     lpFunction:    Pointer;
     hLibrary:      HMODULE;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Clear old function pointer
     OldFunction:=nil;
     // Check parameters
     if (Length(LibraryName) > 0) and (Length(FunctionName) > 0) and Assigned(NewFunction) then
     begin
        // Determine if we already have a hook record for the library / function
        lpPatch:=Find(LibraryName, FunctionName);
        // Check patch record pointer
        if Assigned(lpPatch) then
        begin
           // Set old function pointer
           OldFunction:=lpPatch^.FunctionAddr;
           // Update the patch record with the new function pointer
           result:=UpdatePatch(lpPatch, NewFunction);
        end
        else
        begin
           // Attempt to get the module handle
           hLibrary:=GetModuleHandle(PChar(LibraryName));
           // Is the library loaded
           if (hLibrary = 0) then
              // Not loaded, so not statically bound, so we are not going to touch it
              result:=False
           else
           begin
              // Get the function address from the library. This address is returned from the
              // libraries EAT (export address table), and will not be modified by our IAT updates.
              lpFunction:=GetProcAddress(hLibrary, PChar(FunctionName));
              // Check function pointer
              if Assigned(lpFunction) then
              begin
                 // Allocate a new patch record
                 lpPatch:=AllocMem(SizeOf(TPatchRecord));
                 // Resource protection
                 try
                    // Set library name
                    StrPLCopy(@lpPatch^.LibraryName, ChangeFileExt(ExtractFileName(LibraryName), EmptyStr), MAX_LIBRARYNAME);
                    // Set the function name
                    StrPLCopy(@lpPatch^.FunctionName, FunctionName, MAX_FUNCTIONNAME);
                    // Set the function pointer
                    lpPatch^.FunctionAddr:=lpFunction;
                    // Set old function pointer
                    OldFunction:=lpPatch^.FunctionAddr;
                    // Build the IAT patch list
                    BuildIATPatchList(lpPatch^.LibraryName, FunctionName, lpPatch^.IATList);
                    // Update with the new function pointer
                    result:=UpdatePatch(lpPatch, NewFunction);
                 finally
                    // Add record to patch list
                    FPatchList.Add(lpPatch);
                 end;
              end
              else
                 // Failed to get the function address
                 result:=False;
           end;
        end;
     end
     else
        // Invalid parameters
        result:=False;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

function TIATPatch.Find(LibraryName, FunctionName: String): PPatchRecord;
var  dwIndex:       Integer;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Set default result
     result:=nil;
     // Walk the patch record list
     for dwIndex:=0 to Pred(FPatchList.Count) do
     begin
        // Check library names
        if CompareLibraryNames(PPatchRecord(FPatchList[dwIndex])^.LibraryName, LibraryName) then
        begin
           // Check function names
           if (CompareText(PPatchRecord(FPatchList[dwIndex])^.FunctionName, FunctionName) = 0) then
           begin
              // Found the record
              result:=FPatchList[dwIndex];
              // Done processing
              break;
           end;
        end;
     end;
  finally
     // Leave the critical section
     LeaveCriticalSection(FLock);
  end;

end;

procedure TIATPatch.Delete(Index: Integer; Unpatch: Boolean);
var  lpPatch:       PPatchRecord;
     lpEntry:       PIATListEntry;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Get the patch record at the given index
     lpPatch:=FPatchList[Index];
     // Resource protection
     try
        // Delete from the patch list
        FPatchList.Delete(Index);
        // Walk the IAT entries and reset them to their old function address
        while Assigned(lpPatch^.IATList) do
        begin
           // Get current IAT entry item
           lpEntry:=lpPatch^.IATList;
           // Move list head to next entry
           lpPatch^.IATList:=lpPatch^.IATList^.Next;
           // Unpatch the entry if required
           if Unpatch then UpdateEntry(lpEntry, lpPatch^.FunctionAddr);
           // Free the memory for the entry
           FreeMem(lpEntry);
        end;
     finally
        // Free the patch record memory
        FreeMem(lpPatch);
     end;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

procedure TIATPatch.Clear(Unpatch: Boolean);
var  lpPatch:       PPatchRecord;
     lpEntry:       PIATListEntry;
     dwIndex:       Integer;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Resource protection
     try
        // Walk the patch list
        for dwIndex:=0 to Pred(FPatchList.Count) do
        begin
           // Get the patch record
           lpPatch:=FPatchList[dwIndex];
           // Resource protection
           try
              // Walk the IAT entries and reset them to their old function address
              while Assigned(lpPatch^.IATList) do
              begin
                 // Get current IAT entry item
                 lpEntry:=lpPatch^.IATList;
                 // Move list head to next entry
                 lpPatch^.IATList:=lpPatch^.IATList^.Next;
                 // Unpatch the entry if required
                 if Unpatch then UpdateEntry(lpEntry, lpPatch^.FunctionAddr);
                 // Free the memory for the entry
                 FreeMem(lpEntry);
              end;
           finally
              // Free patch record
              FreeMem(lpPatch);
           end;
        end;
     finally
        // Clear the patch list
        FPatchList.Clear;
     end;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

function TIATPatch.GetPatchRecord(Index: Integer): PPatchRecord;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Return the patch record at the given index
     result:=FPatchList[Index];
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

function TIATPatch.GetUnpatchOnFree: Boolean;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Return the value
     result:=FUnpatch;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

procedure TIATPatch.SetUnpatchOnFree(Value: Boolean);
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Update the value
     FUnpatch:=Value;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

function TIATPatch.GetCount: Integer;
begin

  // Enter critical section
  EnterCriticalSection(FLock);

  // Resource protection
  try
     // Return the count of patch records
     result:=FPatchList.Count;
  finally
     // Leave critical section
     LeaveCriticalSection(FLock);
  end;

end;

constructor TIATPatch.Create;
begin

  // Perform inherited
  inherited Create;

  // Create critical section
  InitializeCriticalSection(FLock);

  // Create list for holding patch information
  FPatchList:=TList.Create;

  // Set default unpatch on free setting to false
  FUnpatch:=False;

end;

destructor TIATPatch.Destroy;
begin

  // Resource protection
  try
     // Resource protection
     try
        // Clear the patch list
        Clear(FUnpatch);
     finally
        // Free the patch list
        FPatchList.Free;
     end;
     // Delete the critical section
     DeleteCriticalSection(FLock);
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

{$ENDIF MSWINDOWS}
//
//{------------------------------------------------------------------------------------------------------}
// Win32IAT.
//

{$ENDIF CPUX86}

{$ENDIF !CPUX64}

{$ENDIF _SUPPORTED_HOOK_}

function GetVirtualMethodAddress(AClass: TClass; AIndex: Integer): Pointer;
var
  Table: PPointer;
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
end;

function SetVirtualMethodAddress(AClass: TClass; AIndex: Integer;
  NewAddress: Pointer): Pointer;
const
  PageSize = SizeOf(Pointer);
var
  Table: PPointer;
  {$IFDEF MSWINDOWS}
  SaveFlag: DWord;
  {$ENDIF}
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
  {$IFDEF MSWINDOWS}
  if VirtualProtect(Table, PageSize, PAGE_EXECUTE_READWRITE, @SaveFlag) then
  {$ELSE}
  {$IFDEF POSIX}
  if mprotect(Table, PageSize, PROT_WRITE or PROT_EXEC) = 0 then
  {$ENDIF}
  {$ENDIF}
  try
    Table^ := NewAddress;
  finally
    {$IFDEF MSWINDOWS}
    VirtualProtect(Table, PageSize, SaveFlag, @SaveFlag);
    FlushInstructionCache(GetCurrentProcess, Table, PageSize);
    {$ELSE}
    {$IFDEF POSIX}
    mprotect(Table, PageSize, PROT_READ or PROT_EXEC);
    {$ENDIF}
    {$ENDIF}
  end;
end;

function FindVirtualMethodIndex(AClass: TClass; MethodAddr: Pointer): Integer;
begin
  try
    for Result := 1 to 1000000 do
    begin
      if GetVirtualMethodAddress(AClass, Result) = MethodAddr then
        Exit;
    end;
    Result := -1;
  except
    Result := -1;
  end;
  {
  Result := 0;
  repeat
    Inc(Result);
  until (GetVirtualMethodAddress(AClass, Result) = MethodAddr);
  {}
end;

function GetVirtualMethodOffset(AClass: TClass; MethodAddr: Pointer): Integer;
begin
  Result := (FindVirtualMethodIndex(AClass, MethodAddr) - 1) * SizeOf(Pointer);
end;

function FxtGetStubAddress(AStub: Pointer; OffsetE8: NativeInt = 0): Pointer;
begin
  Inc(NativeInt(AStub), OffsetE8);
  if PByte(AStub)^ = $E8 then
  begin
    Inc(NativeInt(AStub));
    Result := Pointer(NativeInt(AStub) + SizeOf(Pointer) + PNativeInt(AStub)^);
  end
  else
    Result := nil;
end;

end.
