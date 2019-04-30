{
  Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.15

  Copyright (c) 2001-2012 Vadim V.Lopushansky

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public License
  as published by the Free Software Foundation; either version 2.1
  of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Home Page:
    https://sourceforge.net/projects/open-dbexpress/
}
unit DbxOpenOdbcFuncs;

{$i DbxOpenOdbc.inc}

{$IF CompilerVersion >= 20.00}
  {$DEFINE _INLINE_}
{$IFEND}

{$R-}
{$O+}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF _KYLIX_}
  Types, Libc,
  {$ENDIF}
  {$IFNDEF _KYLIX_}{$IFDEF POSIX}
  Posix.Unistd, Posix.Stdio, Posix.String_, {Posix.Pthread,}
  {$ENDIF}{$ENDIF}
  SysUtils,
  //{$IFNDEF _D12UP_}
  //StrUtils,
  //{$ENDIF}
  {$IFDEF UNICODE}
  AnsiStrings,
  {$ENDIF}
  Classes,
  DbxOpenOdbcTypes;

//
// Match functions:
//
function min(v1, v2: Integer): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
function max(v1, v2: Integer): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}

//
// AnsiString/WideString constants:
//
const
  cNullAnsiChar = AnsiChar(#0);
  cNullWideChar = WideChar(#0);
  cNullAnsiCharBuf: AnsiChar = #0;
  cNullWideCharBuf: WideChar = #0;

{$IFNDEF _D7UP_}
function PosEx(const SubStr, S: AnsiString; Offset: Integer = 1): Integer; overload;
{$ENDIF}

{$IFNDEF _D9UP_}
function Pos(const substr, str: WideString): Integer; overload;
{$ENDIF}

{$IFNDEF _D11UP_}
function PosEx(const SubStr, S: WideString; Offset: Integer = 1): Integer; overload;
{$ENDIF}

function AnsiToOEM(const S: AnsiString): AnsiString;
function OemToAnsi(const S: AnsiString): AnsiString;

function LoadStringFromFileA(const FileName: AnsiString; var S: AnsiString): Boolean;
function LoadStringFromFileW(const FileName: string; var S: WideString): Boolean;

//
// Parse options in string
//
function GetOptionValue(var ConnectString: AnsiString; OptionName: AnsiString;
  HideOption: Boolean = False; TrimResult: Boolean = True;
  bOneChar: Boolean = False; const HideTemplate: AnsiString = #0): AnsiString;

function PointerOffset(Ptr: Pointer; Offset: NativeInt): Pointer; {$IFDEF _INLINE_} inline; {$ENDIF}

function CompareMemory(Ptr1, Ptr2: Pointer; N: Cardinal): Integer;

function GetTemporaryFileName(const FileNamePrefix: string = 'dbx'): string;
function GetTemporaryFolder(): string;

// *******************************************************************
//
// PrepareFileNameAliases(FileName, AppFolder, TempFolder): Boolean;
//
// examples:
//
//  PrepareFileNameAliases('$(APP)\#temp');
//  PrepareFileNameAliases('$(TEMP)\#temp');
//
//  MSWINDOWS:
//
//  PrepareFileNameAliases('$(WINDOWS)\system32\');
//  PrepareFileNameAliases('$(SYSTEM)\');
//
//  PrepareFileNameAliases('$(SHELL:WINDOWS)\system32\');
//  PrepareFileNameAliases('$(SHELL:SYSTEM)\');
//  PrepareFileNameAliases('$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\AppData)\');
//
//  PrepareFileNameAliases('$(DESKTOP)\');
//  PrepareFileNameAliases('$(MYDOCUMENTS)\myfile.doc');
//  PrepareFileNameAliases('$(MYPICTURES)\myfile.jpg');
//  PrepareFileNameAliases('$(MYVIDEO)\myfile.avi');
//  PrepareFileNameAliases('$(MYMUSIC)\myfile.mp3');
//  PrepareFileNameAliases('$(APPDATA)\');
//  PrepareFileNameAliases('$(LOCAL_APPDATA)\');
//  PrepareFileNameAliases('$(PROGRAM_FILES)\');
//  PrepareFileNameAliases('$(PROFILE)\');
//  PrepareFileNameAliases('$(ROGRAM_FILES_COMMON)\');
//  PrepareFileNameAliases('$(FAVORITES)\');
//  PrepareFileNameAliases('$(SHELL:RESOURCES)\');
//  PrepareFileNameAliases('$(SHELL:COMPUTERSNEARME)\');
//
function PrepareFileNameAliases(var FileName: UnicodeString; const AppFolder: UnicodeString = ''; const TempFolder: UnicodeString = ''): Boolean; overload;
function PrepareFileNameAliases(var FileName: AnsiString; const AppFolder: AnsiString = ''; const TempFolder: AnsiString = ''): Boolean; overload;

function ArrScanByte(N: LongWord; ArrPtr: PAnsiChar; Count: Cardinal): Integer;
function ArrScanWord(N: LongWord; ArrPtr: PWideChar; Count: Cardinal): Integer;
function ArrScanDWord(N: DWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function ArrScanPointer(N: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

function ToAnsiChar(WC: WideChar): AnsiChar; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
function ToAnsiChar(WC: WideChar; var AC: AnsiChar): Boolean; overload; {$IFDEF _INLINE_}inline;{$ENDIF}

function PosChar(AC: AnsiChar; const Str: AnsiString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
function PosChar(AC: AnsiChar; const Str: UnicodeString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
function PosChar(WC: WideChar; const Str: AnsiString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
function PosChar(WC: WideChar; const Str: UnicodeString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}

function PosCharEx(AC: AnsiChar; const Str: AnsiString; Index: Integer): NativeInt; overload;
function PosCharEx(AC: AnsiChar; const Str: UnicodeString; Index: Integer): NativeInt; overload;
function PosCharEx(WC: WideChar; const Str: AnsiString; Index: Integer): NativeInt; overload;
function PosCharEx(WC: WideChar; const Str: UnicodeString; Index: Integer): NativeInt; overload;

function DupeStringW(const AText: UnicodeString; ACount: Integer): UnicodeString;
function DupeStringA(const AText: AnsiString; ACount: Integer): AnsiString;

function DupeString(const AText: string; ACount: Integer): string; {$IFDEF _INLINE_}inline;{$ENDIF}

procedure DupeWideChar(const AText: UnicodeString; ACount: Integer; ADest: PWideChar);
procedure DupeAnsiChar(const AText: AnsiString; ACount: Integer; ADest: PAnsiChar);

function StringCharReplace(const S: AnsiString; OldChar, NewChar: AnsiChar; ReplaceAll: Boolean = True): AnsiString; overload;
function StringCharReplace(const S: AnsiString; OldChar1, OldChar2, NewChar: AnsiChar; ReplaceAll: Boolean = True): AnsiString; overload;

function StringCharReplace(const S: WideString; OldChar, NewChar: WideChar; ReplaceAll: Boolean = True): WideString; overload;
function StringCharReplace(const S: WideString; OldChar1, OldChar2, NewChar: WideChar; ReplaceAll: Boolean = True): WideString; overload;

procedure StringCharModify(var S: string; OldChar, NewChar: Char; ReplaceAll: Boolean = True); overload;
procedure StringCharModify(var S: string; OldChar1, OldChar2, NewChar: Char; ReplaceAll: Boolean = True); overload;

{$IFDEF UNICODE}
procedure StringCharModify(var S: AnsiString; OldChar, NewChar: AnsiChar; ReplaceAll: Boolean = True); overload;
procedure StringCharModify(var S: AnsiString; OldChar1, OldChar2, NewChar: AnsiChar; ReplaceAll: Boolean = True); overload;
{$ENDIF}

procedure StringCharModify(var S: WideString; OldChar, NewChar: WideChar; ReplaceAll: Boolean = True); overload;
procedure StringCharModify(var S: WideString; OldChar1, OldChar2, NewChar: WideChar; ReplaceAll: Boolean = True); overload;

{$IFDEF UNICODE}
procedure dbg(const S: string); {$IFDEF MSWINDOWS}{$IFDEF _INLINE_} inline; {$ENDIF}{$ENDIF} overload;
{$ENDIF}
procedure dbg(const S: AnsiString); {$IFDEF MSWINDOWS}{$IFDEF _INLINE_} inline; {$ENDIF}{$ENDIF} overload;
procedure dbg(const S: WideString); {$IFDEF MSWINDOWS}{$IFDEF _INLINE_} inline; {$ENDIF}{$ENDIF} overload;

function GetCompilerVersion(): string; {$IFDEF _INLINE_} inline; {$ENDIF}

{$IFNDEF UNICODE}
var
  DefaultSystemCodePage: Integer;
{$ENDIF}

(*{$IFDEF UNICODE}{$IFDEF POSIX}
procedure SetOemCodePage(CP: Longint);
procedure CharToOemA(AnsiStr, NativeStr: PAnsiChar; MaxLen: Integer = -1);
procedure OemToCharA(NativeStr, AnsiStr: PAnsiChar; MaxLen: Integer = -1);
{$ENDIF}{$ENDIF} // UNICODE, POSIX *)

implementation

{$IFDEF _D16UP_}
//
uses
  {$IFDEF MSWINDOWS}
  {PrepareFileNameAliases}
  ActiveX, ShlObj, Registry,
  {$ENDIF}
  System.IOUtils;
//
{$ELSE !_D16UP_}
//
{$IFDEF MSWINDOWS}
uses
  {PrepareFileNameAliases}
  ActiveX, ShlObj, Registry;
{$ENDIF}
//
{$ENDIF !_D16UP_}

{$IFOPT O-}
  {$UNDEF co_optimization}
{$ELSE}
  {$DEFINE co_optimization}
{$ENDIF}

{$IFOPT R-}
  {$UNDEF co_rangecheck}
{$ELSE}
  {$DEFINE co_rangecheck}
{$ENDIF}

//
// Match functions:
//
function min;//(v1, v2: Integer): Integer;
begin
  if v1 <= v2 then
    Result := v1
  else
    Result := v2;
end;

function max;//(v1, v2: Integer): Integer;
begin
  if v1 > v2 then
    Result := v1
  else
    Result := v2;
end;

{$IFNDEF _D7UP_}
(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function PosEx is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): Aleksandr Sharahov
 *
 * ***** END LICENSE BLOCK ***** *)
function PosEx(const SubStr, S: AnsiString; Offset: Integer = 1): Integer;
asm
       test  eax, eax
       jz    @Nil
       test  edx, edx
       jz    @Nil
       dec   ecx
       jl    @Nil

       push  esi
       push  ebx

       mov   esi, [edx-4]  //Length(Str)
       mov   ebx, [eax-4]  //Length(Substr)
       sub   esi, ecx      //effective length of Str
       add   edx, ecx      //addr of the first AnsiChar at starting position
       cmp   esi, ebx
       jl    @Past         //jump if EffectiveLength(Str)<Length(Substr)
       test  ebx, ebx
       jle   @Past         //jump if Length(Substr)<=0

       add   esp, -12
       add   ebx, -1       //Length(Substr)-1
       add   esi, edx      //addr of the terminator
       add   edx, ebx      //addr of the last AnsiChar at starting position
       mov   [esp+8], esi  //save addr of the terminator
       add   eax, ebx      //addr of the last AnsiChar of Substr
       sub   ecx, edx      //-@Str[Length(Substr)]
       neg   ebx           //-(Length(Substr)-1)
       mov   [esp+4], ecx  //save -@Str[Length(Substr)]
       mov   [esp], ebx    //save -(Length(Substr)-1)
       movzx ecx, byte ptr [eax] //the last AnsiChar of Substr

@Loop:
       cmp   cl, [edx]
       jz    @Test0
@AfterTest0:
       cmp   cl, [edx+1]
       jz    @TestT
@AfterTestT:
       add   edx, 4
       cmp   edx, [esp+8]
       jb   @Continue
@EndLoop:
       add   edx, -2
       cmp   edx, [esp+8]
       jb    @Loop
@Exit:
       add   esp, 12
@Past:
       pop   ebx
       pop   esi
@Nil:
       xor   eax, eax
       ret
@Continue:
       cmp   cl, [edx-2]
       jz    @Test2
       cmp   cl, [edx-1]
       jnz   @Loop
@Test1:
       add   edx,  1
@Test2:
       add   edx, -2
@Test0:
       add   edx, -1
@TestT:
       mov   esi, [esp]
       test  esi, esi
       jz    @Found
@AnsiString:
       movzx ebx, word ptr [esi+eax]
       cmp   bx, word ptr [esi+edx+1]
       jnz   @AfterTestT
       cmp   esi, -2
       jge   @Found
       movzx ebx, word ptr [esi+eax+2]
       cmp   bx, word ptr [esi+edx+3]
       jnz   @AfterTestT
       add   esi, 4
       jl    @AnsiString
@Found:
       mov   eax, [esp+4]
       add   edx, 2

       cmp   edx, [esp+8]
       ja    @Exit

       add   esp, 12
       add   eax, edx
       pop   ebx
       pop   esi
end;
{$ENDIF _D7UP_}

{$IFNDEF _D9UP_}
function Pos(const substr, str: WideString): Integer;
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in str or 0  }

        TEST    EAX,EAX
        JE      @@noWork

        TEST    EDX,EDX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX                         { Point ESI to substr           }
        MOV     EDI,EDX                         { Point EDI to s                }

        MOV     ECX,[EDI-4]                     { ECX = Length(s)               }
        SHR     ECX,1

        PUSH    EDI                             { remember s position to calculate index        }

        MOV     EDX,[ESI-4]                     { EDX = Length(substr)          }
        SHR     EDX,1

        DEC     EDX                             { EDX = Length(substr) - 1              }
        JS      @@fail                          { < 0 ? return 0                        }
        MOV     AX,[ESI]                        { AL = first char of substr             }
        ADD     ESI,2                           { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX                         { #positions in s to look at    }
                                                { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASW
        JNE     @@fail
        MOV     EBX,ECX                         { save outer loop counter               }
        PUSH    ESI                             { save outer loop substr pointer        }
        PUSH    EDI                             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSW
        POP     EDI                             { restore outer loop s pointer  }
        POP     ESI                             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX                         { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX                             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                             { restore pointer to first char of s    }
        MOV     EAX,EDI                         { EDI points of char after match        }
        SUB     EAX,EDX                         { the difference is the correct index   }
        SHR     EAX,1
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;
{$ENDIF _D9UP_}

{$IFNDEF _D11UP_} // todo: asm version
function PosEx(const SubStr, S: WideString; Offset: Integer = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    if Offset < 0 then
    begin
      Result := 0;
      exit;
    end;
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;
{$ENDIF}

(*{$IFDEF UNICODE}{$IFDEF POSIX}
var
  OemCodePage: Integer = -1;
  ANSIEncoding, OEMEncoding: TEncoding;

procedure SetOemCodePage(CP: Longint);
begin
  if OemCodePage <> Integer(CP) then
  begin
    OemCodePage := -1;
    FreeAndNil(OEMEncoding);
    OEMEncoding := TEncoding.GetEncoding(CP);
    OemCodePage := CP;
  end;
end;

procedure CharToOemA(AnsiStr, NativeStr: PAnsiChar; MaxLen: Integer = -1);
var
  Len: Cardinal;
  SrcBuff, DestBuff: TBytes;
begin
  if MaxLen < 0 then
    MaxLen := StrLen(AnsiStr);
  if MaxLen > 0 then
  begin
    Len := StrLen(AnsiStr);
    if Len > Cardinal(MaxLen) then
      Len := MaxLen;
    SetLength(SrcBuff, Len);
    Move(AnsiStr[0], SrcBuff[0], Len);
    DestBuff := TEncoding.Convert(ANSIEncoding, OEMEncoding, SrcBuff);
    Len := Length(DestBuff);
    if Len > Cardinal(MaxLen) then
      Len := MaxLen;
    Move(DestBuff[0], NativeStr^, Len);
    NativeStr[Len] := #0;
  end
  else if AnsiStr <> NativeStr then
    NativeStr[0] := #0;
end;

procedure OemToCharA(NativeStr, AnsiStr: PAnsiChar; MaxLen: Integer = -1);
var
  Len: Cardinal;
  SrcBuff, DestBuff: TBytes;
begin
  if MaxLen < 0 then
    MaxLen := StrLen(AnsiStr);
  if MaxLen > 0 then
  begin
    Len := StrLen(NativeStr);
    if Len > Cardinal(MaxLen) then
      Len := MaxLen;
    SetLength(SrcBuff, Len);
    Move(NativeStr[0], SrcBuff[0], Len);
    DestBuff := TEncoding.Convert(OEMEncoding, ANSIEncoding, SrcBuff);
    Len := Length(DestBuff);
    if Len > Cardinal(MaxLen) then
      Len := MaxLen;
    Move(DestBuff[0], AnsiStr^, Len);
    AnsiStr[Len] := #0;
  end
  else if AnsiStr <> NativeStr then
    NativeStr[0] := #0;
end;

{$ENDIF}{$ENDIF} // UNICODE, POSIX *)

function AnsiToOEM;//(const S: AnsiString): AnsiString;
begin
  {$IFDEF MSWINDOWS}
  SetLength(Result, Length(S));
  if Length(S) > 0 then
    CharToOemA(PAnsiChar(S), PAnsiChar(Result));
  {$ELSE}
    //{$IFDEF UNICODE}
    //SetLength(Result, Length(S));
    //if Length(S) > 0 then
    //  CharToOemA(PAnsiChar(S), PAnsiChar(Result), Length(S));
    //{$ELSE}
      Result := S;
    //{$ENDIF}
  {$ENDIF}
end;

function OemToAnsi;//(const S: AnsiString): AnsiString;
begin
  {$IFDEF MSWINDOWS}
  SetLength(Result, Length(S));
  if Length(S) > 0 then
    OemToCharA(PAnsiChar(S), PAnsiChar(Result));
  {$ELSE}
    //{$IFDEF UNICODE}
    //SetLength(Result, Length(S));
    //if Length(S) > 0 then
    //  OemToCharA(PAnsiChar(S), PAnsiChar(Result), Length(S));
    //{$ELSE}
      Result := S;
    //{$ENDIF}
  {$ENDIF}
end;

function LoadStringFromFileA;//(const FileName: AnsiString; var S: AnsiString): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if (Length(FileName) = 0) or (not FileExists(string(FileName))) then
    Exit;
  fs := nil;
  try
    try
      fs := TFileStream.Create(string(FileName), fmOpenRead or fmShareDenyNone);
      SetLength(S, fs.Size);
      if Length(S) > 0 then
        fs.Read(S[1], Length(S));
      Result := True;
    finally
      fs.Free;
    end;
  except
  end;
end;

function LoadStringFromFileW;//(const FileName: string; var S: WideString): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if (FileName = '') or (not FileExists(FileName)) then
    Exit;
  fs := nil;
  try
    try
      fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      SetLength(S, fs.Size div 2);
      if Length(S) > 0 then
      begin
        fs.Read(S[1], SizeOf(WideChar));
        if S[1] = #$FEFF then
        begin
          SetLength(S, Length(S) - 1);
          fs.Read(S[1], Length(S) * SizeOf(WideChar));
        end
        else
        begin
          fs.Position := 0;
        end;
        fs.Read(S[1], Length(S) * SizeOf(WideChar));
      end;
      Result := True;
    finally
      fs.Free;
    end;
  except
  end;
end;

//
// Parse options in string
//
function GetOptionValue(var ConnectString: AnsiString; OptionName: AnsiString;
  HideOption: Boolean = False; TrimResult: Boolean = True;
  bOneChar: Boolean = False; const HideTemplate: AnsiString = #0): AnsiString;
var
  pLeft, pRight: Integer;
  sLeft, sVal: AnsiString;
  sUprConnectString: AnsiString;
  cLeft, lRight, cLeftVal, cTmp, cRight: PAnsiChar;
  bIsValue: Boolean;
begin
  Result := #0; // when result is #0 then value not found, but if result='' then value is empty
  if (OptionName = '') or (Length(ConnectString) <= Length(OptionName)) then
    exit;
  OptionName := UpperCase(OptionName);
  sUprConnectString := UpperCase(ConnectString);
  // seek to option name
  cLeft := System.AnsiStrings.StrPos( PAnsiChar(sUprConnectString), PAnsiChar(OptionName) );
  if cLeft=nil then
    exit;
  lRight := PAnsiChar(@sUprConnectString[Length(sUprConnectString)]);// pointed to last symbol
  cTmp := #0;
  bIsValue := False;
  repeat
    begin
      // check right limitation
      cLeftVal := cLeft;
      inc(cLeftVal, Length(OptionName));// seek to last symbol in OptionName
      if NativeUInt(cLeftVal) > NativeUInt(lRight) then
        break;
      // seek to symbol '='
      while cLeftVal^<>#0 do
      begin
        if cLeftVal^='=' then
        begin
          inc(cLeftVal,2);
          bIsValue := True;
          break;
        end
        else
        if cLeftVal ^ in [#9, #10, #13, #32] then
          inc(cLeftVal)
        else
          break;
      end;
      if bIsValue then
      begin
        // search left delimiter ';' or start pos sUprConnectString:
        cTmp := cLeft-1;
        while cTmp >= PAnsiChar(sUprConnectString) do
        begin
          if cTmp^=';' then
            break
          else
          if cTmp^ in [#9, #10, #13, #32] then
            dec(cTmp)
          else
          begin
            bIsValue := False;
            break;
          end;
        end;
        if bIsValue then
          break;
      end;
      // seek to next same option name
      cLeft := System.AnsiStrings.StrPos( cLeftVal, PAnsiChar(OptionName) );
    end //of: repeat:
  until (cLeft=nil);
  if bIsValue then
  begin
    pLeft := NativeUInt(cLeft)-NativeUInt(PAnsiChar(sUprConnectString));
    sLeft := Copy(ConnectString, 1, pLeft - 1);
    pLeft := NativeUInt(cLeftVal)-NativeUInt(PAnsiChar(sUprConnectString));
    cRight := System.AnsiStrings.StrPos( cLeftVal, '=' );
    if cRight = nil then
    begin
      pRight := Length(sUprConnectString) + 1;
      cTmp := lRight;
    end
    else
    begin
      dec(cRight);
      while (cRight > cTmp) and (cRight^<>';') do
        dec(cRight);
      cTmp := cRight;
      pRight := NativeUInt(cRight) - NativeUInt(PAnsiChar(sUprConnectString)) + 1;
    end;
    sVal := Copy(ConnectString, pLeft, pRight - pLeft{ + 1});
    if HideOption then
    begin
      if HideTemplate = #0 then
      begin
        // remove options value and name
        if cTmp^=';' then
          inc(pRight);
        pLeft := Length(ConnectString) - pRight + 1;
        if (pLeft>0)and(sLeft<>'')and(sLeft[Length(sLeft)]<>';') then
          sLeft := sLeft + ';';
        ConnectString := sLeft + Copy(ConnectString, pRight, pLeft);
      end
      else // hide only value
      begin
        // replace value to template
        ConnectString :=
          Copy(ConnectString, 1, pLeft-1) +
          HideTemplate +
          Copy(ConnectString, pRight, Length(ConnectString) - pRight + 1);
      end;
    end;
    if TrimResult then
      Result := Trim(sVal)
    else
      Result := sVal;
    if bOneChar then
      Result := (Result+' ')[1];
  end;
end;

function PointerOffset(Ptr: Pointer; Offset: NativeInt): Pointer;
begin
  //{$IFDEF FPC}
  //Result := Pointer(NativeUInt(NativeUInt(Ptr) + Offset));
  //{$ELSE}
  Result := Pointer(NativeUInt(NativeInt(Ptr) + Offset));
  //{$ENDIF}
end;

function CompareMemory(Ptr1, Ptr2: Pointer; N: Cardinal): Integer;
{$IFDEF PUREPASCAL}
label
  L_SUCCESS;
type
  TByte4 = packed record
    b0, b1, b2, b3: Byte;
  end;
  PByte4 = ^TByte4;
var
  p1: PByte4 absolute Ptr1;
  p2: PByte4 absolute Ptr2;
  b1, b2: Byte;
  l: Cardinal;
begin
  if p1 = p2 then
    goto L_SUCCESS;
  l := n;
  //
  repeat
    if l = 0 then
      goto L_SUCCESS;
    b1 := p1^.b0; b2 := p2^.b0;
    if b1 <> b2 then
      break;
    Dec(l);
    //
    if l = 0 then
      goto L_SUCCESS;
    b1 := p1^.b1; b2 := p2^.b1;
    if b1 <> b2 then
      Break;
    Dec(l);
    //
    if l = 0 then
      goto L_SUCCESS;
    b1 := p1^.b2; b2 := p2^.b2;
    if b1 <> b2 then
      Break;
    Dec(l);
    //
    if l = 0 then
      goto L_SUCCESS;
    b1 := p1^.b3; b2 := p2^.b3;
    if b1 <> b2 then
      Break;

    Inc(p1);
    Inc(p2);
    Dec(l);
  until False;

  Result := b1 - b2;
  Exit;

L_SUCCESS:
  Result := 0;
end;
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
asm
        PUSH    EBX
        CMP     EAX,EDX
        JE      @@QUAL
@@LOOP:
        DEC     ECX
        JS      @@QUAL
        MOV     BL,BYTE PTR [EAX]
        MOV     BH,BYTE PTR [EDX]
        CMP     BL,BH
        JNE     @@NOT_EQUAL
        DEC     ECX
        JS      @@QUAL
        MOV     BL,BYTE PTR [EAX+1]
        MOV     BH,BYTE PTR [EDX+1]
        CMP     BL,BH
        JNE     @@NOT_EQUAL
        DEC     ECX
        JS      @@QUAL
        MOV     BL,BYTE PTR [EAX+2]
        MOV     BH,BYTE PTR [EDX+2]
        CMP     BL,BH
        JNE     @@NOT_EQUAL
        DEC     ECX
        JS      @@QUAL
        MOV     BL,BYTE PTR [EAX+3]
        MOV     BH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     BL,BH
        JE      @@LOOP
@@NOT_EQUAL:
        MOVZX   EAX,BL
        MOVZX   EDX,BH
        SUB     EAX,EDX
        POP     EBX
        RET
@@QUAL:
        XOR     EAX,EAX
        POP     EBX
end;
{$ELSE !CPUX86}
  ERROR: 'platform not supported'
{$ENDIF !CPUX86}
{$ENDIF !PUREPASCAL}

function GetTemporaryFileName(const FileNamePrefix: string = 'dbx'): string;
{$IFDEF MSWINDOWS}
var
  sTempPath, sTempFileName: string;
  iLen: Integer;
const
  WIN_MAX_PATH = 260;
begin
  Result := '';
  sTempPath := GetTemporaryFolder();
  iLen := Length(sTempPath) + 255;
  if iLen < WIN_MAX_PATH then
    iLen := WIN_MAX_PATH;
  SetLength(sTempFileName, iLen);
  FillChar(PChar(sTempFileName)^, Length(sTempFileName)*SizeOf(Char), #0);
  iLen := Windows.GetTempFileName(PChar(sTempPath), PChar(FileNamePrefix),
    0, PChar(sTempFileName));
  if iLen < 0 then
  begin
    iLen := Windows.GetTempFileName(PChar(sTempPath), nil,
      1, PChar(sTempFileName));
    if iLen < 0 then
    begin
      SetLength(sTempFileName, MAX_PATH);
      FillChar(PChar(sTempFileName)^, Length(sTempFileName)*SizeOf(Char), #0);
      iLen := Windows.GetTempFileName(PChar(sTempPath), nil,
        0, PChar(sTempFileName));
    end;
  end;
  if iLen > 0 then
    Result := StrPas(PChar(sTempFileName))
  else
{$IFDEF _D6UP_}
    RaiseLastOSError();
{$ELSE}
    RaiseLastWin32Error();
{$ENDIF}
end;
{$ELSE !MSWINDOWS}
{$IFDEF POSIX}
{$IFDEF _D16UP_}
begin
  Result := TPath.GetTempFileName;
  if Result = '' then
    Result := TPath.GetRandomFileName;
end;
{$ELSE}
var
  LTempPath: PAnsiChar;
begin
  { Obtain a temporary file name }
  LTempPath := tmpnam(nil);
  { Convert to UTF16 or leave blank on possible error }
  if LTempPath <> nil then
  {$IFNDEF _KYLIX_}
    Result := UTF8ToUnicodeString(LTempPath)
  {$ELSE}
    Result := Utf8ToAnsi(UTF8String(StrPas(LTempPath)))
  {$ENDIF}
  else
    Result := '';
end;
{$ENDIF}
{$ELSE !POSIX}
  ERROR: 'platform not supported'
  //Result := '';
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}

function GetTemporaryFolder(): string;
{$IFDEF MSWINDOWS}
var
  sTempPath: string;
  iLen: Integer;
begin
  Result := '';
  iLen := GetTempPath(0, nil);
  if iLen > 3 then
  begin
    SetLength(sTempPath, iLen);
    iLen := GetTempPath(iLen, PChar(sTempPath));
    SetLength(sTempPath, iLen);
    if iLen <= 3 then
      sTempPath := ''
    else if not DirectoryExists(sTempPath) then
    begin
      if not ForceDirectories(sTempPath) then
      begin
        iLen := Pos(PathDelim+'temp'+PathDelim, AnsiLowerCase(sTempPath) + PathDelim);
        if iLen > 2 then
        begin
          SetLength(sTempPath, iLen + Length('temp'));
          if (sTempPath <> '') and (sTempPath[Length(sTempPath)] <> PathDelim) then
            sTempPath := sTempPath + PathDelim;
          if not DirectoryExists(sTempPath) and (not ForceDirectories(sTempPath)) then
            sTempPath := '';
        end
        else
          sTempPath := '';
      end;
    end;
  end
  else
    sTempPath := '';
  if sTempPath = '' then
    sTempPath := ExtractFilePath(ParamStr(0));
  if (sTempPath <> '') and (sTempPath[Length(sTempPath)] <> PathDelim) then
    sTempPath := sTempPath + PathDelim;
  Result := sTempPath;
end;
{$ELSE !MSWINDOWS}
{$IFDEF POSIX}
{$IFDEF _D16UP_}
begin
  Result := TPath.GetTempPath;
  if Result = '' then
    Result := TPath.GetHomePath;
end;
{$ELSE}
const
  CEnvVars: array[0..2] of AnsiString = ('TMPDIR', 'TMP', 'TEMP'); // Do not localize
  CTmpDir = '/tmp'; // Do not localize
var
  LTempPathVar: PAnsiChar;
  I: Integer;
begin
  { Lookup env variables, in order: TMPDIR, TMP, TEMP }
  for I := Low(CEnvVars) to High(CEnvVars) do
  begin
    LTempPathVar := getenv(PAnsiChar(CEnvVars[I]));

    if (LTempPathVar <> nil) and (LTempPathVar^ <> #0) then
    begin
      { We have found our temporary path }
      Break;
    end;
  end;

  { Get the UTF16 value out of the UTF8 one. The last resort is to fallback to /tmp }
  if LTempPathVar <> nil then
  {$IFNDEF _KYLIX_}
    Result := UTF8ToUnicodeString(LTempPathVar)
  {$ELSE}
    Result := Utf8ToAnsi(UTF8String(StrPas(LTempPathVar)))
  {$ENDIF}
  else
    Result := CTmpDir;
end;
{$ENDIF}
{$ELSE !POSIX}
  ERROR: 'platform not supported'
  //Result := '';
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}

{$IFDEF MSWINDOWS}
{$IFNDEF _D11UP_}
//
// ShlObj.pas
//
const
  {$EXTERNALSYM CSIDL_DESKTOP}
  CSIDL_DESKTOP                       = $0000; { <desktop> }
  {$EXTERNALSYM CSIDL_INTERNET}
  CSIDL_INTERNET                      = $0001; { Internet Explorer (icon on desktop) }
  {$EXTERNALSYM CSIDL_PROGRAMS}
  CSIDL_PROGRAMS                      = $0002; { Start Menu\Programs }
  {$EXTERNALSYM CSIDL_CONTROLS}
  CSIDL_CONTROLS                      = $0003; { My Computer\Control Panel }
  {$EXTERNALSYM CSIDL_PRINTERS}
  CSIDL_PRINTERS                      = $0004; { My Computer\Printers }
  {$EXTERNALSYM CSIDL_PERSONAL}
  CSIDL_PERSONAL                      = $0005; { My Documents.  This is equivalent to CSIDL_MYDOCUMENTS in XP and above }
  {$EXTERNALSYM CSIDL_FAVORITES}
  CSIDL_FAVORITES                     = $0006; { <user name>\Favorites }
  {$EXTERNALSYM CSIDL_STARTUP}
  CSIDL_STARTUP                       = $0007; { Start Menu\Programs\Startup }
  {$EXTERNALSYM CSIDL_RECENT}
  CSIDL_RECENT                        = $0008; { <user name>\Recent }
  {$EXTERNALSYM CSIDL_SENDTO}
  CSIDL_SENDTO                        = $0009; { <user name>\SendTo }
  {$EXTERNALSYM CSIDL_BITBUCKET}
  CSIDL_BITBUCKET                     = $000a; { <desktop>\Recycle Bin }
  {$EXTERNALSYM CSIDL_STARTMENU}
  CSIDL_STARTMENU                     = $000b; { <user name>\Start Menu }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_MYDOCUMENTS}
  CSIDL_MYDOCUMENTS                   = $000c; { logical "My Documents" desktop icon }
  {$EXTERNALSYM CSIDL_MYMUSIC}
  CSIDL_MYMUSIC                       = $000d; { "My Music" folder }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_MYVIDEO}
  CSIDL_MYVIDEO                       = $000e; { "My Video" folder }
  {$EXTERNALSYM CSIDL_DESKTOPDIRECTORY}
  CSIDL_DESKTOPDIRECTORY              = $0010; { <user name>\Desktop }
  {$EXTERNALSYM CSIDL_DRIVES}
  CSIDL_DRIVES                        = $0011; { My Computer }
  {$EXTERNALSYM CSIDL_NETWORK}
  CSIDL_NETWORK                       = $0012; { Network Neighborhood (My Network Places) }
  {$EXTERNALSYM CSIDL_NETHOOD}
  CSIDL_NETHOOD                       = $0013; { <user name>\nethood }
  {$EXTERNALSYM CSIDL_FONTS}
  CSIDL_FONTS                         = $0014; { windows\fonts }
  {$EXTERNALSYM CSIDL_TEMPLATES}
  CSIDL_TEMPLATES                     = $0015;
  {$EXTERNALSYM CSIDL_COMMON_STARTMENU}
  CSIDL_COMMON_STARTMENU              = $0016; { All Users\Start Menu }
  {$EXTERNALSYM CSIDL_COMMON_PROGRAMS}
  CSIDL_COMMON_PROGRAMS               = $0017; { All Users\Start Menu\Programs }
  {$EXTERNALSYM CSIDL_COMMON_STARTUP}
  CSIDL_COMMON_STARTUP                = $0018; { All Users\Startup }
  {$EXTERNALSYM CSIDL_COMMON_DESKTOPDIRECTORY}
  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019; { All Users\Desktop }
  {$EXTERNALSYM CSIDL_APPDATA}
  CSIDL_APPDATA                       = $001a; { <user name>\Application Data }
  {$EXTERNALSYM CSIDL_PRINTHOOD}
  CSIDL_PRINTHOOD                     = $001b; { <user name>\PrintHood }
  {$EXTERNALSYM CSIDL_LOCAL_APPDATA}
  CSIDL_LOCAL_APPDATA                 = $001c; { <user name>\Local Settings\Application Data (non roaming) }
  {$EXTERNALSYM CSIDL_ALTSTARTUP}
  CSIDL_ALTSTARTUP                    = $001d; { non localized startup }
  {$EXTERNALSYM CSIDL_COMMON_ALTSTARTUP}
  CSIDL_COMMON_ALTSTARTUP             = $001e; { non localized common startup }
  {$EXTERNALSYM CSIDL_COMMON_FAVORITES}
  CSIDL_COMMON_FAVORITES              = $001f;
  {$EXTERNALSYM CSIDL_INTERNET_CACHE}
  CSIDL_INTERNET_CACHE                = $0020;
  {$EXTERNALSYM CSIDL_COOKIES}
  CSIDL_COOKIES                       = $0021;
  {$EXTERNALSYM CSIDL_HISTORY}
  CSIDL_HISTORY                       = $0022;
  {$EXTERNALSYM CSIDL_COMMON_APPDATA}
  CSIDL_COMMON_APPDATA                = $0023; { All Users\Application Data }
  {$EXTERNALSYM CSIDL_WINDOWS}
  CSIDL_WINDOWS                       = $0024; { GetWindowsDirectory() }
  {$EXTERNALSYM CSIDL_SYSTEM}
  CSIDL_SYSTEM                        = $0025; { GetSystemDirectory() }
  {$EXTERNALSYM CSIDL_PROGRAM_FILES}
  CSIDL_PROGRAM_FILES                 = $0026; { C:\Program Files }
  {$EXTERNALSYM CSIDL_MYPICTURES}
  CSIDL_MYPICTURES                    = $0027; { C:\Program Files\My Pictures }
  {$EXTERNALSYM CSIDL_PROFILE}
  CSIDL_PROFILE                       = $0028; { USERPROFILE }
  {$EXTERNALSYM CSIDL_SYSTEMX86}
  CSIDL_SYSTEMX86                     = $0029; { x86 system directory on RISC }
  {$EXTERNALSYM CSIDL_PROGRAM_FILESX86}
  CSIDL_PROGRAM_FILESX86              = $002a; { x86 C:\Program Files on RISC }
  {$EXTERNALSYM CSIDL_PROGRAM_FILES_COMMON}
  CSIDL_PROGRAM_FILES_COMMON          = $002b; { C:\Program Files\Common }
  {$EXTERNALSYM CSIDL_PROGRAM_FILES_COMMONX86}
  CSIDL_PROGRAM_FILES_COMMONX86       = $002c; { x86 C:\Program Files\Common on RISC }
  {$EXTERNALSYM CSIDL_COMMON_TEMPLATES}
  CSIDL_COMMON_TEMPLATES              = $002d; { All Users\Templates }
  {$EXTERNALSYM CSIDL_COMMON_DOCUMENTS}
  CSIDL_COMMON_DOCUMENTS              = $002e; { All Users\Documents }
  {$EXTERNALSYM CSIDL_COMMON_ADMINTOOLS}
  CSIDL_COMMON_ADMINTOOLS             = $002f; { All Users\Start Menu\Programs\Administrative Tools }
  {$EXTERNALSYM CSIDL_ADMINTOOLS}
  CSIDL_ADMINTOOLS                    = $0030; { <user name>\Start Menu\Programs\Administrative Tools }
  {$EXTERNALSYM CSIDL_CONNECTIONS}
  CSIDL_CONNECTIONS                   = $0031; { Network and Dial-up Connections }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_COMMON_MUSIC}
  CSIDL_COMMON_MUSIC                  = $0035; { All Users\My Music }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_COMMON_PICTURES}
  CSIDL_COMMON_PICTURES               = $0036; { All Users\My Pictures }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_COMMON_VIDEO}
  CSIDL_COMMON_VIDEO                  = $0037; { All Users\My Video }
  {$EXTERNALSYM CSIDL_RESOURCES}
  CSIDL_RESOURCES                     = $0038; { Resource Directory }
  {$EXTERNALSYM CSIDL_RESOURCES_LOCALIZED}
  CSIDL_RESOURCES_LOCALIZED           = $0039; { Localized Resource Directory }
  {$EXTERNALSYM CSIDL_COMMON_OEM_LINKS}
  CSIDL_COMMON_OEM_LINKS              = $003a; { Links to All Users OEM specific apps }
  { For Windows >= XP }
  {$EXTERNALSYM CSIDL_CDBURN_AREA}
  CSIDL_CDBURN_AREA                   = $003b; { USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning }
  {$EXTERNALSYM CSIDL_COMPUTERSNEARME}
  CSIDL_COMPUTERSNEARME               = $003d; { Computers Near Me (computered from Workgroup membership) }
  {$EXTERNALSYM CSIDL_PROFILES}
  CSIDL_PROFILES                      = $003e;

  {$EXTERNALSYM CSIDL_FLAG_CREATE}
  CSIDL_FLAG_CREATE                   = $8000; { combine with CSIDL_ value to force folder creation in SHGetFolderPath() }
  {$EXTERNALSYM CSIDL_FLAG_DONT_VERIFY}
  CSIDL_FLAG_DONT_VERIFY              = $4000; { combine with CSIDL_ value to return an unverified folder path }
  {$EXTERNALSYM CSIDL_FLAG_DONT_UNEXPAND}
  CSIDL_FLAG_DONT_UNEXPAND            = $2000; { combine with CSIDL_ value to avoid unexpanding environment variables }
  {$EXTERNALSYM CSIDL_FLAG_NO_ALIAS}
  CSIDL_FLAG_NO_ALIAS                 = $1000; { combine with CSIDL_ value to insure non-alias versions of the pidl }
  {$EXTERNALSYM CSIDL_FLAG_PER_USER_INIT}
  CSIDL_FLAG_PER_USER_INIT            = $0800; { combine with CSIDL_ value to indicate per-user init (eg. upgrade) }
  {$EXTERNALSYM CSIDL_FLAG_MASK}
  CSIDL_FLAG_MASK                     = $FF00; { mask for all possible flag values }

{$ENDIF _D11UP_}
{$ENDIF MSWINDOWS}

function PrepareFileNameAliases(var FileName: UnicodeString; const AppFolder: UnicodeString = ''; const TempFolder: UnicodeString = ''): Boolean; overload;
//
// examples:
//
//  PrepareFileNameAliases('$(APP)\#temp');
//  PrepareFileNameAliases('$(TEMP)\#temp');
//
//  MSWINDOWS:
//
//  PrepareFileNameAliases('$(WINDOWS)\system32\');
//  PrepareFileNameAliases('$(SYSTEM)\');
//
//  PrepareFileNameAliases('$(SHELL:WINDOWS)\system32\');
//  PrepareFileNameAliases('$(SHELL:SYSTEM)\');
//  PrepareFileNameAliases('$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\AppData)\');
//
//  PrepareFileNameAliases('$(DESKTOP)\');
//  PrepareFileNameAliases('$(MYDOCUMENTS)\myfile.doc');
//  PrepareFileNameAliases('$(MYPICTURES)\myfile.jpg');
//  PrepareFileNameAliases('$(MYVIDEO)\myfile.avi');
//  PrepareFileNameAliases('$(MYMUSIC)\myfile.mp3');
//  PrepareFileNameAliases('$(APPDATA)\');
//  PrepareFileNameAliases('$(LOCAL_APPDATA)\');
//  PrepareFileNameAliases('$(PROGRAM_FILES)\');
//  PrepareFileNameAliases('$(PROFILE)\');
//  PrepareFileNameAliases('$(ROGRAM_FILES_COMMON)\');
//  PrepareFileNameAliases('$(FAVORITES)\');
//  PrepareFileNameAliases('$(SHELL:RESOURCES)\');
//  PrepareFileNameAliases('$(SHELL:COMPUTERSNEARME)\');
//
type
  TGetValue = function(P: Pointer): UnicodeString;
  //
  function is_prepared_alias(const sAlias: string; GetValue: TGetValue; P: Pointer = nil): Boolean;
  var
    iLen: Integer;
    sWord: UnicodeString;
  begin
    Result := False;
    iLen := Length(sAlias);
    if (iLen > 0) and Assigned(GetValue)
      and SameText(Copy(FileName, 1, iLen), sAlias) then
    begin
      sWord := GetValue(P);
      if sWord <> '' then
      begin
        if sWord = #0 then
          sWord := '';
        Delete(FileName, 1, iLen);
        FileName := sWord + FileName;
        Result := True;
      end;
    end;
  end;
  //
  function is_prepared_alias_word(const sAlias: string; GetValue: TGetValue; P: Pointer = nil): Boolean;
  var
    iLen, iPos: Integer;
    sFileName, sWord: UnicodeString;
  begin
    Result := False;
    iLen := Length(sAlias);
    if (iLen > 0) and Assigned(GetValue)
      and SameText(Copy(FileName, 1, iLen), sAlias) then
    begin
      sFileName := FileName;
      Delete(sFileName, 1, iLen);
      iPos := Pos(')', sFileName);
      if iPos > 0 then
      begin
        sWord := Copy(sFileName, 1, iPos-1);
        sWord := GetValue(@sWord);
        if sWord <> '' then
        begin
          if sWord = #0 then
            sWord := '';
          Delete(sFileName, 1, iPos);
          FileName := sWord + sFileName;
          Result := True;
        end;
      end;
    end;
  end;
  //
  function GetValueAsWorkFolder(P: Pointer): UnicodeString;
  const
    WC_PATH_DELIMITER = WideChar(#$005C);
    WC_COLON = WideChar(#$003A);
  var
    iLen: Integer;
    //
    function ExtractFilePathW(const AFileName: UnicodeString): UnicodeString;
    begin
      iLen := Length(AFileName);
      if iLen > 0 then
      begin
        while (iLen > 0) and (AFileName[iLen] <> WC_PATH_DELIMITER) and (AFileName[iLen] <> WC_COLON) do
          Dec(iLen);
        SetString(Result, PWideChar(AFileName), iLen);
      end
      else
        Result := '';
    end;
    //
  begin
    if Assigned(P) then
      iLen := Length(PUnicodeString(P)^)
    else
      iLen := 0;
    if iLen > 0 then
      Result := PUnicodeString(P)^
    else
    begin
      Result := ExtractFilePathW(ParamStr(0));
      iLen := Length(Result);
    end;
    if (iLen > 0) and (Result[iLen] = PathDelim) then
      SetLength(Result, iLen - 1);
  end;
  //
  function GetValueAsTempFolder(P: Pointer): UnicodeString;
  var
    iLen: Integer;
  begin
    if Assigned(P) then
      iLen := Length(PUnicodeString(P)^)
    else
      iLen := 0;
    if iLen > 0 then
    begin
      Result := PUnicodeString(P)^;
      if not ForceDirectories(string(Result)) then
        iLen := 0;
    end;
    if iLen = 0 then
      Result := UnicodeString(GetTemporaryFolder());
    iLen := Length(Result);
    if (iLen > 0) and (Result[iLen] = PathDelim) then
      SetLength(Result, iLen - 1);
  end;
  //
  {$IFDEF MSWINDOWS}
  //
  function GetValueAsShellFolderKey(P: Pointer): UnicodeString;
  var
    SpecialFolder: Integer absolute P;
    ItemIDList: ShlObj.PItemIDList;
    Buffer: array[0..MAX_PATH - 1] of WideChar;
    malloc: {AciteX.}IMalloc;
    iLen: Integer;
  begin
    Result := '';
    if (SpecialFolder < 0) then
      Exit;
    if (SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR) then
    begin
      if SHGetPathFromIDListW(ItemIDList, Buffer) then
      begin
        Result := Buffer;
        iLen := Length(Result);
        if (iLen > 0) then
        begin
          if (Result[iLen] = PathDelim) then
            SetLength(Result, iLen - 1);
        end
        else
          Result := #0;
      end;
      if (SHGetMalloc(malloc) = NOERROR) and (malloc.DidAlloc(ItemIDList) > 0) then
        malloc.Free(ItemIDList);
      Exit;
    end;
    // reg: "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\"
    case SpecialFolder of
      {ShlObj.}CSIDL_DESKTOP:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Desktop)';
      {ShlObj.}CSIDL_MYDOCUMENTS:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Personal)';
      {ShlObj.}CSIDL_FAVORITES:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Favorites)';
      {ShlObj.}CSIDL_FONTS:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Fonts)';
      {ShlObj.}CSIDL_APPDATA:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\AppData)';
      {ShlObj.}CSIDL_LOCAL_APPDATA:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Local AppData)';
      {ShlObj.}CSIDL_INTERNET_CACHE:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Cache)';
      {ShlObj.}CSIDL_MYMUSIC:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\My Music)';
      {ShlObj.}CSIDL_MYVIDEO:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\My Video)';
      {ShlObj.}CSIDL_MYPICTURES:
        Result := '$(REG:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\My Pictures)';
    end;
    //
    if Result = '' then
      Exit;
    //
    if not PrepareFileNameAliases(Result) then
       Result := '';
    (*
    case SpecialFolder of
      {ShlObj.}CSIDL_MYDOCUMENTS, {ShlObj.}CSIDL_MYMUSIC, {ShlObj.}CSIDL_MYVIDEO, {ShlObj.}CSIDL_MYPICTURES:
      begin
        if (SHGetSpecialFolderLocation(0, {ShlObj.}CSIDL_PROFILE, ItemIDList) = NOERROR) then
        begin
          if SHGetPathFromIDListW(ItemIDList, Buffer) then
          begin
            Result := Buffer;
            iLen := Length(Result);
            if (iLen > 0) then
            begin
              if (Result[iLen] = PathDelim) then
                SetLength(Result, iLen - 1);
            end
            else
              Result := '';
          end;
          if (SHGetMalloc(malloc) = NOERROR) and (malloc.DidAlloc(ItemIDList) > 0) then
            malloc.Free(ItemIDList);
          if Result <> '' then
          begin
            case SpecialFolder of
              {ShlObj.}CSIDL_MYDOCUMENTS:
                Result := Result + '\My Documents';
              {ShlObj.}CSIDL_MYMUSIC:
                Result := Result + '\My Music';
              {ShlObj.}CSIDL_MYVIDEO:
                Result := Result + '\My Videos';
              {ShlObj.}CSIDL_MYPICTURES:
                Result := Result + '\My Pictures';
              else
                Result := '';
            end;
            if (Result <> '') and (not DirectoryExists(Result)) then
              Result := '';
          end;
        end;
      end;
    end;
    //*)
  end;
  //
  function GetValueAsSpecialWinFolder(P: Pointer): UnicodeString;
  var
    ID: PUnicodeString absolute P;
    SpecialFolder: Integer;
    ItemIDList: ShlObj.PItemIDList;
    Buffer: array[0..MAX_PATH - 1] of WideChar;
    malloc: IMalloc;
  begin
    Result := '';
    if Assigned(P) and (ID^ <> '') then
    begin
      SpecialFolder := -1;
      if SameText(ID^, 'DESKTOP') then
        SpecialFolder := {ShlObj.}CSIDL_DESKTOP
      else if SameText(ID^, 'MYDOCUMENTS') then
        SpecialFolder := {ShlObj.}CSIDL_MYDOCUMENTS
      else if SameText(ID^, 'FAVORITES') then
        SpecialFolder := {ShlObj.}CSIDL_FAVORITES
      else if SameText(ID^, 'MYMUSIC') then
        SpecialFolder := {ShlObj.}CSIDL_MYMUSIC
      else if SameText(ID^, 'MYVIDEO') then
        SpecialFolder := {ShlObj.}CSIDL_MYVIDEO
      else if SameText(ID^, 'RECYCLE') then
        SpecialFolder := {ShlObj.}CSIDL_BITBUCKET
      else if SameText(ID^, 'FONTS') then
        SpecialFolder := {ShlObj.}CSIDL_FONTS
      else if SameText(ID^, 'APPDATA') then
        SpecialFolder := {ShlObj.}CSIDL_APPDATA
      else if SameText(ID^, 'LOCAL_APPDATA') then
        SpecialFolder := {ShlObj.}CSIDL_LOCAL_APPDATA
      else if SameText(ID^, 'INTERNET_CACHE') then
        SpecialFolder := {ShlObj.}CSIDL_INTERNET_CACHE
      else if SameText(ID^, 'WINDOWS') then
        SpecialFolder := {ShlObj.}CSIDL_WINDOWS
      else if SameText(ID^, 'SYSTEM') then
        SpecialFolder := {ShlObj.}CSIDL_SYSTEM
      else if SameText(ID^, 'PROGRAM_FILES') then
        SpecialFolder := {ShlObj.}CSIDL_PROGRAM_FILES
      else if SameText(ID^, 'MYPICTURES') then
        SpecialFolder := {ShlObj.}CSIDL_MYPICTURES
      else if SameText(ID^, 'USERPROFILE') then
        SpecialFolder := {ShlObj.}CSIDL_PROFILE
      else if SameText(ID^, 'PROGRAM_FILES_COMMON') then
        SpecialFolder := {ShlObj.}CSIDL_PROGRAM_FILES_COMMON
      else if SameText(ID^, 'RESOURCES') then
        SpecialFolder := {ShlObj.}CSIDL_RESOURCES
      else if SameText(ID^, 'COMPUTERSNEARME') then
        SpecialFolder := {ShlObj.}CSIDL_COMPUTERSNEARME
      ;
      if (SpecialFolder >= 0) and (SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR) then
      begin
        if SHGetPathFromIDListW(ItemIDList, Buffer) then
        begin
          Result := Buffer;
          SpecialFolder := Length(Result);
          if (SpecialFolder > 0) then
          begin
            if (Result[SpecialFolder] = PathDelim) then
              SetLength(Result, SpecialFolder - 1);
          end
          else
            Result := #0;
        end;
        if (SHGetMalloc(malloc) = NOERROR) and (malloc.DidAlloc(ItemIDList) > 0) then
          malloc.Free(ItemIDList);
      end;
    end
  end;
  //
  function GetValueAsRegistry(P: Pointer): UnicodeString;
  var
    sID: UnicodeString;
    ID: HKEY;
    iLen: Integer;
    sRegP, sRegV: UnicodeString;

    function ExpandRegPathW(const sRegPathFull: UnicodeString; out P, V: UnicodeString): Boolean;
    var
      iLen, iPos: Cardinal;
    begin
      P := '';
      V := '';
      iLen := Length(sRegPathFull);
      Result := iLen > 0;
      if Result then
      begin
        iPos := iLen;
        while (iPos > 0) and (sRegPathFull[iPos] <> PathDelim) do
          Dec(iPos);
        SetString(P, PWideChar(sRegPathFull), iPos);
        V := Copy(sRegPathFull, iPos +1 , iLen - iPos);
        Result := True;
      end;
    end;

    function IsLeftKey(const sKey: UnicodeString; iKey: HKEY): Boolean;
    var
      iLen: Integer;
    begin
      iLen := Length(sKey);
      Result := SameText(Copy(sID, 1, iLen), sKey) and (Copy(sID, iLen + 1, 1) = PathDelim);
      if Result then
      begin
        ID := iKey;
        Delete(sID, 1, iLen + 1);
      end;
    end;

  begin
    Result := '';
    if P = nil then
      Exit;
    sID := PUnicodeString(P)^;
    SID := StringReplace(SID, '\\', ' ', [rfReplaceAll]);
    iLen := Length(sID);

    if Assigned(P) and (iLen > 0) then
    begin
      ID := 0;
      if (IsLeftKey('HKEY_CURRENT_USER', HKEY_CURRENT_USER)
        or IsLeftKey('HKCU', HKEY_CURRENT_USER)
        or IsLeftKey('HKEY_LOCAL_MACHINE', HKEY_LOCAL_MACHINE)
        or IsLeftKey('HKLM', HKEY_LOCAL_MACHINE)
        or IsLeftKey('HKEY_CLASSES_ROOT', HKEY_CLASSES_ROOT)
        or IsLeftKey('HKCR', HKEY_CLASSES_ROOT)
        or IsLeftKey('HKEY_USERS', HKEY_USERS)
        or IsLeftKey('HKU', HKEY_USERS)
        or IsLeftKey('HKEY_PERFORMANCE_DATA', HKEY_PERFORMANCE_DATA)
        or IsLeftKey('HKPD', HKEY_PERFORMANCE_DATA)
        or IsLeftKey('HKEY_CURRENT_CONFIG', HKEY_CURRENT_CONFIG)
        or IsLeftKey('HKCC', HKEY_CURRENT_CONFIG)
        or IsLeftKey('HKEY_DYN_DATA', HKEY_DYN_DATA)
        or IsLeftKey('HKDD', HKEY_DYN_DATA))
        and (ID <> 0) and ExpandRegPathW(sID, sRegP, sRegV) and (sRegP <> '') then
      begin
        with TRegistry.Create(KEY_READ) do
        try
          RootKey := ID;
          if OpenKeyReadOnly(sRegP) and ValueExists(sRegV) then
          begin
            Result := ReadString(sRegV);
            iLen := Length(Result);
            if (iLen > 0) then
            begin
             if (Result[iLen] = PathDelim) then
               SetLength(Result, iLen - 1);
            end
            else
              Result := #0;
          end;
        finally
          Free;
        end;
      end;
    end;
  end;
  {$ENDIF MSWINDOWS}
begin
  Result := (Length(FileName) <= 3) or ((FileName[1]<>'$') and (FileName[2]<>'(')
    and (Pos(')', FileName)<=3));
  if not Result then
  begin
    Result :=
      is_prepared_alias('$(APP)', @GetValueAsWorkFolder, @AppFolder)
      or is_prepared_alias('$(TEMP)', @GetValueAsTempFolder, @TempFolder)
      //
      {$IFDEF MSWINDOWS}
      or is_prepared_alias('$(WINDOWS)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_WINDOWS))
      or is_prepared_alias('$(SYSTEM)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_SYSTEM))
      or is_prepared_alias('$(APPDATA)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_APPDATA))
      or is_prepared_alias('$(LOCAL_APPDATA)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_LOCAL_APPDATA))
      or is_prepared_alias('$(PROFILE)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_PROFILE))
      or is_prepared_alias('$(MYDOCUMENTS)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_MYDOCUMENTS))
      or is_prepared_alias('$(MYPICTURES)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_MYPICTURES))
      or is_prepared_alias('$(MYVIDEO)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_MYVIDEO))
      or is_prepared_alias('$(MYMUSIC)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_MYMUSIC))
      or is_prepared_alias('$(DESKTOP)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_DESKTOP))
      or is_prepared_alias('$(PROGRAM_FILES)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_PROGRAM_FILES))
      or is_prepared_alias('$(PROGRAM_FILES_COMMON)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_PROGRAM_FILES_COMMON))
      or is_prepared_alias('$(FAVORITES)', @GetValueAsShellFolderKey, Pointer({ShlObj.}CSIDL_FAVORITES))
      //
      or is_prepared_alias_word('$(SHELL:', @GetValueAsSpecialWinFolder)
      or is_prepared_alias_word('$(REG:', @GetValueAsRegistry)
      {$ENDIF MSWINDOWS}
    ;
  end;
end;

function PrepareFileNameAliases(var FileName: AnsiString; const AppFolder: AnsiString = ''; const TempFolder: AnsiString = ''): Boolean; overload;
var
  wsFileName: UnicodeString;
begin
  wsFileName := UnicodeString(FileName);
  Result := PrepareFileNameAliases(wsFileName, UnicodeString(AppFolder), UnicodeString(TempFolder));
  if Result then
    FileName := AnsiString(wsFileName);
end;

{$O+}
{$R-}

function ArrScanByte(N: LongWord; ArrPtr: PAnsiChar; Count: Cardinal): Integer;
{$IFDEF CPUX86}
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASB
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}
begin
  if Assigned(ArrPtr) then
    for Result := 0 to Count-1 do
    begin
      if Byte(ArrPtr^) = Byte(N) then
        Exit;
      Inc(ArrPtr);
    end;
  Result := -1;
end;
{$ENDIF}

function ArrScanWord(N: LongWord; ArrPtr: PWideChar; Count: Cardinal): Integer;
{$IFDEF CPUX86}
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASW
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,1
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}
begin
  if Assigned(ArrPtr) then
    for Result := 0 to Count-1 do
    begin
      if Word(ArrPtr^) = Word(N) then
        Exit;
      Inc(ArrPtr);
    end;
  Result := -1;
end;
{$ENDIF}

function ArrScanDWord(N: DWord; ArrPtr: Pointer; Count: Cardinal): Integer;
{$IFDEF CPUX86}
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}
type
  PDWORD=^DWORD;
var
  TypedArrPtr: PDWORD absolute ArrPtr;
begin
  if Assigned(TypedArrPtr) then
    for Result := 0 to Count-1 do
    begin
      if TypedArrPtr^ = N then
        Exit;
      Inc(TypedArrPtr);
    end;
  Result := -1;
end;
{$ENDIF}

function ArrScanPointer(N: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
{$IFDEF CPUX86}
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}
var
  TypedArrPtr: PNativeUInt absolute ArrPtr;
begin
  if Assigned(TypedArrPtr) then
    for Result := 0 to Count-1 do
    begin
      if TypedArrPtr^ = NativeUInt(N) then
        Exit;
      Inc(TypedArrPtr);
    end;
  Result := -1;
end;
{$ENDIF}

function ToAnsiChar(WC: WideChar): AnsiChar; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  // Result := AnsiChar(WC); // - WideChar reduced to byte char
  if Word(WC) <= $FF then
    Result := AnsiChar(WC)
  else
  begin
    {$IFDEF MSWINDOWS}
    if WideCharToMultiByte(DefaultSystemCodePage, 0, @WC, 1, @Result, 1, nil, nil) <> 1 then
      Result := '?';
    {$ELSE}
      {$IF CompilerVersion >= 23.00} // 2012 XE2 (16)
      if LocaleCharsFromUnicode(DefaultSystemCodePage, 0, @WC, 1, @Result, 1, nil, nil) <> 1 then
        Result := '?';
      {$IFEND}
      {$IF CompilerVersion < 23.00}
        Result := AnsiString(WC)[1];
      {$IFEND}
    {$ENDIF}
  end;
end;

function ToAnsiChar(WC: WideChar; var AC: AnsiChar): Boolean; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  // Result := AnsiChar(WC); // - WideChar reduced to byte char
  if Word(WC) <= $FF then
  begin
    AC := AnsiChar(WC);
    Result := True;
  end
  else
  begin
    {$IFDEF MSWINDOWS}
    if WideCharToMultiByte(DefaultSystemCodePage, 0, @WC, 1, @AC, 1, nil, nil) <> 1 then
      AC := '?';
    {$ELSE}
      {$IF CompilerVersion >= 23.00} // 2012 XE2 (16)
      if LocaleCharsFromUnicode(DefaultSystemCodePage, 0, @WC, 1, @AC, 1, nil, nil) <> 1 then
        AC := '?';
      {$IFEND}
      {$IF CompilerVersion < 23.00}
        AC := AnsiString(WC)[1];
      {$IFEND}
    {$ENDIF}
    Result := AC <> '?';
  end;
end;

function PosChar(AC: AnsiChar; const Str: AnsiString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  Result := ArrScanByte(LongWord(AC), PAnsiChar(Str), Length(Str));
  if Result >= 0 then
    Inc(Result);
end;

function PosChar(AC: AnsiChar; const Str: UnicodeString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  Result := ArrScanWord(LongWord(WideString(AnsiString(AC))[1]), PWideChar(Str), Length(Str));
  if Result >= 0 then
    Inc(Result);
end;

function PosChar(WC: WideChar; const Str: AnsiString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  Result := ArrScanByte(LongWord(AnsiString(WideString(WC))[1]), PAnsiChar(Str), Length(Str));
  if Result >= 0 then
    Inc(Result);
end;

function PosChar(WC: WideChar; const Str: UnicodeString): NativeInt; overload; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  Result := ArrScanWord(LongWord(WC), PWideChar(Str), Length(Str));
  if Result >= 0 then
    Inc(Result);
end;

function PosCharEx(AC: AnsiChar; const Str: AnsiString; Index: Integer): NativeInt; overload;
begin
  if Index <= 0 then
    Index := 1
  else if Index > Length(Str) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ArrScanByte(LongWord(AC), PAnsiChar(@Str[Index]), Length(Str)-Index+1);
  if Result >= 0 then
    Inc(Result, Index);
end;

function PosCharEx(AC: AnsiChar; const Str: UnicodeString; Index: Integer): NativeInt; overload;
begin
  if Index <= 0 then
    Index := 1
  else if Index > Length(Str) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ArrScanWord(LongWord(WideString(AnsiString(AC))[1]), PWideChar(@Str[Index]), Length(Str)-Index+1);
  if Result >= 0 then
    Inc(Result, Index);
end;

function PosCharEx(WC: WideChar; const Str: AnsiString; Index: Integer): NativeInt; overload;
begin
  if Index <= 0 then
    Index := 1
  else if Index > Length(Str) then
  else if Index > Length(Str) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ArrScanByte(LongWord(AnsiString(WideString(WC))[1]), PAnsiChar(@Str[Index]), Length(Str)-Index+1);
  if Result >= 0 then
    Inc(Result, Index);
end;

function PosCharEx(WC: WideChar; const Str: UnicodeString; Index: Integer): NativeInt; overload;
begin
  if Index <= 0 then
    Index := 1
  else if Index > Length(Str) then
  else if Index > Length(Str) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ArrScanWord(LongWord(WC), PWideChar(@Str[Index]), Length(Str)-Index+1);
  if Result >= 0 then
    Inc(Result, Index);
end;

function DupeStringW(const AText: UnicodeString; ACount: Integer): UnicodeString;
var
  R: PWideChar; // Result buffer pointer
  S: PWideChar; // Source buffer pointer
  C: Integer;   // Source chars count
  D: Integer;   // Result buffer count dupes (of AText)
//{$IFDEF _WRITE_DBG_}
//  iWhileCount: Integer;
//  iDelta: NativeInt;
//{$ENDIF}
begin
  if ACount < 0  then
    ACount := 0;
  C := Length(AText);
  SetLength(Result, C * ACount);
  if ACount = 0  then
    Exit;
//{$IFDEF _WRITE_DBG_}
//  FillChar(Pointer(Result)^, ACount * C * SizeOf(WideChar), 0); // debug
//{$ENDIF}
  R := PWideChar(Result);
  Move(PWideChar(AText)^, R^, C * SizeOf(WideChar));
  Dec(ACount);
  if ACount = 0  then
    Exit;
  S := R;
  Inc(R, C);
  D := 1;
//{$IFDEF _WRITE_DBG_}
//  iWhileCount := 0;
//{$ENDIF}
  while ACount > 0 do
  begin
//{$IFDEF _WRITE_DBG_}
//    inc(iWhileCount);
//    // check memory overflow:
//    iDelta := (NativeUInt(Pointer(Result)) + Length(Result) * SizeOf(WideChar))
//      - (NativeUInt(R) + C * SizeOf(WideChar));
//    //Assert( iDelta >= 0 );
//    if iDelta < 0 then
//    begin
//      WriteLn('@: dupe error: memory overflow');
//      Assert(False, '@: dupe error: memory overflow');
//    end;
//{$ENDIF}
    Move(S^, R^, C * SizeOf(WideChar));
    Inc(R, C);
    Dec(ACount, D);
    Inc(D, D);
    if D < ACount then
      Inc(C, C)
    else if ACount > 0 then
      C := ACount * Length(AText);
  end;
//{$IFDEF _WRITE_DBG_}
//  writeln('@:While.Count=',iWhileCount);
//{$ENDIF}
end;

function DupeStringA(const AText: AnsiString; ACount: Integer): AnsiString;
var
  R: PAnsiChar; // Result buffer pointer
  S: PAnsiChar; // Source buffer pointer
  C: Integer;   // Source chars count
  D: Integer;   // Result buffer count dupes (of AText)
//{$IFDEF _WRITE_DBG_}
//  iWhileCount: Integer;
//  iDelta: NativeInt;
//{$ENDIF}
begin
  if ACount < 0  then
    ACount := 0;
  C := Length(AText);
  SetLength(Result, C * ACount);
  if ACount = 0  then
    Exit;
//{$IFDEF _WRITE_DBG_}
//  FillChar(Pointer(Result)^, ACount * C, 0); // debug
//{$ENDIF}
  R := PAnsiChar(Result);
  Move(PAnsiChar(AText)^, R^, C);
  Dec(ACount);
  if ACount = 0  then
    Exit;
  S := R;
  Inc(R, C);
  D := 1;
//{$IFDEF _WRITE_DBG_}
//  iWhileCount := 0;
//{$ENDIF}
  while ACount > 0 do
  begin
//{$IFDEF _WRITE_DBG_}
//    inc(iWhileCount);
//    // check memory overflow:
//    iDelta := (NativeUInt(Pointer(Result)) + Length(Result))
//      - (NativeUInt(R) + C);
//    //Assert( iDelta >= 0 );
//    if iDelta < 0 then
//    begin
//      WriteLn('@: dupe error: memory overflow');
//      Assert(False, '@: dupe error: memory overflow');
//    end;
//{$ENDIF}
    Move(S^, R^, C);
    Inc(R, C);
    Dec(ACount, D);
    Inc(D, D);
    if D < ACount then
      Inc(C, C)
    else if ACount > 0 then
      C := ACount * Length(AText);
  end;
//{$IFDEF _WRITE_DBG_}
//  writeln('@:While.Count=',iWhileCount);
//{$ENDIF}
end;

function DupeString(const AText: string; ACount: Integer): string; {$IFDEF _INLINE_}inline;{$ENDIF}
begin
  {$IFDEF UNICODE}
    Result := DupeStringW(AText, ACount);
  {$ELSE}
    Result := DupeStringA(AText, ACount);
  {$ENDIF}
end;

procedure DupeWideChar(const AText: UnicodeString; ACount: Integer; ADest: PWideChar);
var
  R: PWideChar; // Result buffer pointer
  S: PWideChar; // Source buffer pointer
  C: Integer;   // Source chars count
  D: Integer;   // Result buffer count dupes (of AText)
begin
  if ACount < 0  then
    ACount := 0;
  C := Length(AText);
  if ACount = 0  then
    Exit;
  R := ADest;
  Move(PWideChar(AText)^, R^, C * SizeOf(WideChar));
  Dec(ACount);
  if ACount = 0  then
    Exit;
  S := R;
  Inc(R, C);
  D := 1;
  while ACount > 0 do
  begin
    Move(S^, R^, C * SizeOf(WideChar));
    Inc(R, C);
    Dec(ACount, D);
    Inc(D, D);
    if D < ACount then
      Inc(C, C)
    else if ACount > 0 then
      C := ACount * Length(AText);
  end;
end;

procedure DupeAnsiChar(const AText: AnsiString; ACount: Integer; ADest: PAnsiChar);
var
  R: PAnsiChar; // Result buffer pointer
  S: PAnsiChar; // Source buffer pointer
  C: Integer;   // Source chars count
  D: Integer;   // Result buffer count dupes (of AText)
begin
  if ACount < 0  then
    ACount := 0;
  C := Length(AText);
  if ACount = 0  then
    Exit;
  R := ADest;
  Move(PAnsiChar(AText)^, R^, C);
  Dec(ACount);
  if ACount = 0  then
    Exit;
  S := R;
  Inc(R, C);
  D := 1;
  while ACount > 0 do
  begin
    Move(S^, R^, C);
    Inc(R, C);
    Dec(ACount, D);
    Inc(D, D);
    if D < ACount then
      Inc(C, C)
    else if ACount > 0 then
      C := ACount * Length(AText);
  end;
end;

function StringCharReplace(const S: AnsiString; OldChar, NewChar: AnsiChar; ReplaceAll: Boolean): AnsiString; overload;
var
  P: PAnsiChar;
  L, I: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    if ReplaceAll then
    begin
      SetString(Result, PAnsiChar(S), L);
      P := PAnsiChar(Result);
      while L > 0 do
      begin
        if P^ = OldChar then
          p^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      I := PosChar(OldChar, S);
      if I > 0 then
      begin
        SetString(Result, PAnsiChar(S), L);
        Result[I] := NewChar;
      end
      else
        Result := S;
    end;
  end
  else
    SetLength(Result, 0);
end;

function StringCharReplace(const S: AnsiString; OldChar1, OldChar2, NewChar: AnsiChar; ReplaceAll: Boolean): AnsiString; overload;
var
  P: PAnsiChar;
  L: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    SetString(Result, PAnsiChar(S), L);
    P := PAnsiChar(Result);
    if ReplaceAll then
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
        begin
          P^ := NewChar;
          Exit;
        end;
        Inc(P);
        Dec(L);
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

function StringCharReplace(const S: WideString; OldChar, NewChar: WideChar; ReplaceAll: Boolean): WideString; overload;
var
  P: PWideChar;
  L, I: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    if ReplaceAll then
    begin
      SetString(Result, PWideChar(S), L);
      P := PWideChar(Result);
      while L > 0 do
      begin
        if P^ = OldChar then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      I := PosChar(OldChar, S);
      if I > 0 then
      begin
        SetString(Result, PWideChar(S), L);
        Result[I] := NewChar;
      end
      else
        Result := S;
    end;
  end
  else
    SetLength(Result, 0);
end;

function StringCharReplace(const S: WideString; OldChar1, OldChar2, NewChar: WideChar; ReplaceAll: Boolean): WideString; overload;
var
  P: PWideChar;
  L: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    SetString(Result, PWideChar(S), L);
    P := PWideChar(Result);
    if ReplaceAll then
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
        begin
          P^ := NewChar;
          Exit;
        end;
        Inc(P);
        Dec(L);
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

procedure StringCharModify(var S: string; OldChar, NewChar: Char; ReplaceAll: Boolean = True); overload;
var
  P: PChar;
  L, I: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    if ReplaceAll then
    begin
      P := PChar(S);
      while L > 0 do
      begin
        if P^ = OldChar then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      I := PosChar(OldChar, S);
      if I > 0 then
        S[I] := NewChar;
    end;
  end;
end;

procedure StringCharModify(var S: string; OldChar1, OldChar2, NewChar: Char; ReplaceAll: Boolean = True); overload;
var
  P: PChar;
  L: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    P := PChar(S);
    if ReplaceAll then
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
        begin
          P^ := NewChar;
          Exit;
        end;
        Inc(P);
        Dec(L);
      end;
    end;
  end;
end;

{$IFDEF UNICODE}

procedure StringCharModify(var S: AnsiString; OldChar, NewChar: AnsiChar; ReplaceAll: Boolean = True); overload;
var
  P: PAnsiChar;
  L, I: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    if ReplaceAll then
    begin
      P := PAnsiChar(S);
      while L > 0 do
      begin
        if P^ = OldChar then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      I := PosChar(OldChar, S);
      if I > 0 then
        S[I] := NewChar;
    end;
  end;
end;

procedure StringCharModify(var S: AnsiString; OldChar1, OldChar2, NewChar: AnsiChar; ReplaceAll: Boolean = True); overload;
var
  P: PAnsiChar;
  L: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    P := PAnsiChar(S);
    if ReplaceAll then
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
        begin
          P^ := NewChar;
          Exit;
        end;
        Inc(P);
        Dec(L);
      end;
    end;
  end;
end;

{$ENDIF UNICODE}

procedure StringCharModify(var S: WideString; OldChar, NewChar: WideChar; ReplaceAll: Boolean = True); overload;
var
  P: PWideChar;
  L, I: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    if ReplaceAll then
    begin
      P := PWideChar(S);
      while L > 0 do
      begin
        if P^ = OldChar then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      I := PosChar(OldChar, S);
      if I > 0 then
        S[I] := NewChar;
    end;
  end;
end;

procedure StringCharModify(var S: WideString; OldChar1, OldChar2, NewChar: WideChar; ReplaceAll: Boolean = True); overload;
var
  P: PWideChar;
  L: Integer;
begin
  L := Length(S);
  if L > 0 then
  begin
    P := PWideChar(S);
    if ReplaceAll then
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
          P^ := NewChar;
        Inc(P);
        Dec(L);
      end;
    end
    else
    begin
      while L > 0 do
      begin
        if (P^ = OldChar1) or (P^ = OldChar2) then
        begin
          P^ := NewChar;
          Exit;
        end;
        Inc(P);
        Dec(L);
      end;
    end;
  end;
end;

{$IFNDEF co_optimization}
  {$O-}
{$ENDIF}

{$IFDEF co_rangecheck}
  {$R+}
{$ENDIF}

//function GetCurThreadInfoStr: string; {$IFDEF _INLINE_} inline; {$ENDIF}
//var
// tID: WORD;
//begin
//  tID := GetCurrentThreadID; // posix required unit: "Posix.Pthread"
//  if tID = MainThreadID then
//    Result := ':(    0) '
//  else
//    Result :=
//      //{$IFDEF POSIX}
//      //'['+Format('%10d',[DWORD(getpid)])+']' +
//      //{$ENDIF}
//      ':(' + Format('%5d',[tID]) + ') ';
//end;

{$IFDEF UNICODE}
procedure dbg(const S: string); overload;
{$IFDEF MSWINDOWS}
begin
  Windows.OutputDebugString(PChar({GetCurThreadInfoStr+}S));
end;
{$ELSE !MSWINDOWS}
var
  str: AnsiString;
begin
  //str := AnsiString(GetCurThreadInfoStr);
  //__write(stderr, str, Length(str));
  {$IFDEF _KYLIX_}
  str := AnsiString(S);
  __write(stderr, str, Length(str));
  //__write(stderr, EOL, Length(EOL));
  __write(stderr, PAnsiChar(#13#0), 1);
  {$ELSE}
  str := AnsiString(S);
  __write(STDERR_FILENO, PAnsiChar(str), Length(str));
  //str := AnsiString(#13);
  //__write(STDERR_FILENO, PAnsiChar(str), Length(str));
  __write(STDERR_FILENO, PAnsiChar(#13#0), 1);
  {$ENDIF}
end;
{$ENDIF !MSWINDOWS}
{$ENDIF UNICODE}

procedure dbg(const S: AnsiString); overload;
{$IFDEF MSWINDOWS}
begin
  Windows.OutputDebugStringA(PAnsiChar({AnsiString(GetCurThreadInfoStr)+}S));
end;
{$ELSE !MSWINDOWS}
//var
//  str: AnsiString;
begin
  //str := AnsiString(GetCurThreadInfoStr);
  //__write(stderr, str, Length(str));
  {$IFDEF _KYLIX_}
  __write(stderr, S, Length(S));
  //__write(stderr, EOL, Length(EOL));
  __write(stderr, #13#0, 1);
  {$ELSE}
  __write(STDERR_FILENO, PAnsiChar(S), Length(S));
  __write(STDERR_FILENO, PAnsiChar(#13#0), 1);
  {$ENDIF}
end;
{$ENDIF !MSWINDOWS}

procedure dbg(const S: WideString); overload;
{$IFDEF MSWINDOWS}
begin
  Windows.OutputDebugStringW(PWideChar({WideString(GetCurThreadInfoStr)+}S));
end;
{$ELSE !MSWINDOWS}
var
  str: AnsiString;
begin
  //str := AnsiString(GetCurThreadInfoStr);
  //__write(stderr, str, Length(str));
  str := AnsiString(S);
  {$IFDEF _KYLIX_}
  __write(stderr, str, Length(str));
  //__write(stderr, EOL, Length(EOL));
  __write(stderr, #13#0, 1);
  {$ELSE}
  __write(STDERR_FILENO, PAnsiChar(str), Length(str));
  //str := AnsiString(#13);
  //__write(STDERR_FILENO, PAnsiChar(str), Length(str));
  __write(STDERR_FILENO, PAnsiChar(#13#0), 1);
  {$ENDIF}
end;
{$ENDIF !MSWINDOWS}

{$warnings off}
function GetCompilerVersion(): string;
begin
  Result := '';
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF Declared(CompilerVersion)}
    {$IF CompilerVersion = 14.01}
  Result := '6';
    {$IFEND}
    {$IF CompilerVersion = 14.10}
  Result := '6';
    {$IFEND}
    {$IF CompilerVersion = 14.50}
  Result := '7';
    {$IFEND}
    {$IF CompilerVersion = 15.00}
  Result := '7';
    {$IFEND}
    {$IF CompilerVersion = 17.00}
  Result := '2005';
    {$IFEND}
    {$IF CompilerVersion = 18.00}
  Result := '2006';
    {$IFEND}
    {$IF CompilerVersion = 18.50}
  Result := '2007';
    {$IFEND}
    {$IF CompilerVersion = 20.00}
  Result := '2009';
    {$IFEND}
    {$IF CompilerVersion = 21.00}
  Result := '2010';
    {$IFEND}
    {$IF CompilerVersion = 22.00}
  Result := '2011';
    {$IFEND}
    {$IF CompilerVersion = 23.00}
  Result := '2012';
    {$IFEND}
    {$IF CompilerVersion > 23.00}
  Result := '2012u';
    {$IFEND}
  {$IFEND} // of: $IF Declared(CompilerVersion)
{$ENDIF}
  {$IFDEF BCB}
    Result := 'B' + Result;
  {$ELSE}
    Result := 'D' + Result;
  {$ENDIF}
end;
{$warnings on}

initialization
  {$IFNDEF UNICODE}{$IFDEF MSWINDIWS}
  DefaultSystemCodePage := GetACP;
  {$ENDIF}{$ENDIF}
  //
  (*{$IFDEF UNICODE}{$IFDEF POSIX}
  ANSIEncoding := TEncoding.ANSI.Clone;
  SetOemCodePage(866); // 866 - cyrilic console code page
finalization
  FreeAndNil(OEMEncoding);
  FreeAndNil(ANSIEncoding);
  {$ENDIF}{$ENDIF} // UNICODE, POSIX *)
end.
