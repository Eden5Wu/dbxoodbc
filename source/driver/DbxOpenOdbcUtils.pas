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
unit DbxOpenOdbcUtils;

{$i DbxOpenOdbc_options.inc}

{$IF CompilerVersion >= 20.00}
  {$DEFINE _INLINE_}
{$IFEND}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF _KYLIX_}
  Types, Libc,
  {$ENDIF}
  {$IFNDEF _KYLIX_}{$IFDEF POSIX}
  Posix.String_,
  {$ENDIF}{$ENDIF}
  SysUtils,
  {$IFDEF UNICODE}
  AnsiStrings,
  {$ELSE}
  StrUtils,
  {$ENDIF}
  Classes,
  FMTBcd,
  DbxOpenOdbcTypes;

{$IFNDEF UNICODE}
var
  DefaultSystemCodePage: Integer;
{$ENDIF}

//
// Memory Allocation
//
//function  DbxAllocMem(Size: Cardinal): Pointer;
//procedure DbxFreeMem(P: Pointer);
//procedure DbxFreeMemAndNil(var P);
procedure FreeMemAndNil(var MemPtr); {$IFDEF _INLINE_} inline; {$ENDIF}

//
// Match Functions:
//
procedure MaxSet(var x: Integer; n: Integer); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  MaxSet(var x: Integer; n, max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
procedure MaxSet(var x: Integer; const S: AnsiString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  MaxSet(var x: Integer; const S: AnsiString; max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
procedure MaxSet(var x: Integer; const S: WideString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  MaxSet(var x: Integer; const S: WideString; max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

//
// BCD Functions:
//
function BCD2Str(pOut: PAnsiChar; const ABcd: TBcd; ADot: AnsiChar = '.';
  bExpFormat: Boolean = False): integer;

procedure Str2BCD(PValue: PAnsiChar; ASize: LongWord; var ABcd: TBcd; ADot: AnsiChar);

//
// AnsiString/WideString functions:
//
function  WideStringLengthFromStr(const S: PAnsiChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
function  WideStringLengthFromStrings(const L: TStrings): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
function  WCharFromChar(WCharDest: PWideChar; DestChars: Integer; const CharSource: PAnsiChar; SrcBytes: Integer): Integer; {$IFNDEF _KYLIX_}{$IFDEF _INLINE_} inline; {$ENDIF}{$ENDIF}
function  StringToWideChar(const Source: AnsiString; Dest: PWideChar; DestChars: Integer): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StringToWStr(const Source: AnsiString; var Dest: PWideChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF} overload;
function  StringToWStr(const Source: WideString; var Dest: PWideChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF} overload;
function  StringsToWStr(const L: TStrings; var Dest: PWideChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrLenNil(const AStr: PAnsiChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
//function  StrCompNil(const Str1, Str2: PAnsiChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}

function  WStrLen(const Str: PWideChar): Cardinal;
function  WStrComp(const Str1, Str2: PWideChar): Integer;
function  WStrIComp(const Str1, Str2: PWideChar): Integer;
function  WStrLComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;

function  WStrCopy(Dest: PWideChar; const Source: PWideChar): Integer; overload;
function  WStrCopy(Dest: PWideChar; const Source: WideString): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  WStrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;

function  StrBuffCopy(const Source: PAnsiChar; var Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
function  StrBuffCopy(const Source: PWideChar; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
function  StrBuffCopy(const Source: AnsiString; var Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
function  StrBuffCopy(const Source: WideString; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
function  StrBuffCopy(const Source: AnsiString; var Dest: PAnsiChar; MaxLen: PInteger): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrBuffCopy(const Source: WideString; var Dest: PWideChar; MaxLen: PInteger): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrClone(const Source: PAnsiChar; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PAnsiChar; out Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PWideChar; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PWideChar; out Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

// -
//function  StrClone(const Source: AnsiString; out Dest: PWideChar; MaxLen: LongInt = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: AnsiString; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
// -
//function  StrClone(const Source: WideString; var Dest: PAnsiChar; MaxLen: LongInt = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: WideString; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrClone(const Source: PAnsiChar; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PWideChar; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PAnsiChar; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: PWideChar; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrClone(const Source: AnsiString; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: WideString; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: AnsiString; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrClone(const Source: WideString; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrIsEmpty(const Source: PAnsiChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrIsEmpty(const Source: PWideChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrIsEmpty(const Source: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrIsEmpty(const Source: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrNotEmpty(const Source: PAnsiChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrNotEmpty(const Source: PWideChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrNotEmpty(const Source: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrNotEmpty(const Source: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

//procedure StrFree(var Source: PAnsiChar); overload;
//procedure StrFree(var Source: PWideChar); overload;
//
//procedure StrFree(var Source: AnsiString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
//procedure StrFree(var Source: WideString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrPtrToString(const Source: Pointer; bUnicode: Boolean): AnsiString; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrPtrToString(const Source: PAnsiChar): AnsiString; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrPtrToString(const Source: PWideChar): AnsiString; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrSameText(const S1, S2: PAnsiChar): Boolean; overload;
function  StrSameText(const S1, S2: PWideChar): Boolean; overload;
function  StrSameText(const S1: PAnsiChar; const S2: PWideChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: PWideChar; const S2: PAnsiChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrSameText(const S1, S2: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1, S2: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: AnsiString; const S2: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: WideString; const S2: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrSameText(const S1: PAnsiChar; const S2: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: AnsiString; const S2: PAnsiChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: PWideChar; const S2: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrSameText(const S1: WideString; const S2: PWideChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrISameText(const S1, S2: PAnsiChar): Boolean; overload;
function  StrISameText(const S1, S2: PWideChar): Boolean; overload;
function  StrISameText(const S1: PAnsiChar; const S2: PWideChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrISameText(const S1: PWideChar; const S2: PAnsiChar): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrISameText(const S1, S2: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrISameText(const S1, S2: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrISameText(const S1: AnsiString; const S2: WideString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrISameText(const S1: WideString; const S2: AnsiString): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  PAnsiCharParam(const P: PAnsiChar): PAnsiChar; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  PAnsiCharParam(const P: AnsiString): PAnsiChar; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  StrAnsiStringParam(const P: PAnsiChar): AnsiString; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
function  StrAnsiStringParam(const P: AnsiString): AnsiString; overload; {$IFDEF _INLINE_} inline; {$ENDIF}

function  ChangeFileExtW(const FileName, Extension: WideString): WideString;

function  PIntToStr(AValue: PInteger): AnsiString; {$IFDEF _INLINE_} inline; {$ENDIF} overload;

function  ArgStrNull(const S: AnsiString): string; {$IFDEF _INLINE_} inline; {$ENDIF} overload;
{$IFDEF _D12UP_}
function  ArgStrNull(const S: string): string; {$IFDEF _INLINE_} inline; {$ENDIF} overload;
{$ENDIF}
//
// AnsiString functions:
//
{$IFNDEF _D12UP_}
  {$IFDEF _D9UP_}
  var
    AnsiPos: function (const Substr, S: AnsiString): Integer = Pos;
  {$ELSE}
  function AnsiPos(const Substr, S: AnsiString): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
  {$ENDIF}
{$ENDIF}

implementation

uses
  DbxOpenOdbcFuncs, DbxOpenOdbcTrace;

//
// Memory Allocation
//
//function DbxAllocMem(Size: Cardinal): Pointer;
//begin
//  {$IFDEF _D11_UP_}
//  Result := SysGetMem(Size);
//  {$ELSE}
//  System.GetMem(Result, Size);
//  {$ENDIF}
//end;
//
//procedure DbxFreeMem(P: Pointer);
//begin
//  if Assigned(P)then
//  begin
//    {$IFDEF _TRACE_CALLS_}
//    try
//    //  LogEnterProc('FreeMemAndNil(' + '$'+IntToHex(NativeUInt(ptr), 9) + ')' );
//    //try
//    {$ENDIF _TRACE_CALLS_}
//
//      {$IFDEF _D11_UP_}
//      SysFreeMem(P);
//      {$ELSE}
//      System.FreeMem(P);
//      {$ENDIF}
//
//    {$IFDEF _TRACE_CALLS_}
//    except
//      on e:Exception do
//      begin
//        LogExceptProc(AnsiString('DbxFreeMem(' + '$'+IntToHex(NativeUInt(P), 9) + ')'), e);
//        raise;
//      end;
//    end;
//    //finally LogExitProc('FreeMemAndNil'); end;
//    {$ENDIF}
//  end;
//end;
//
//procedure DbxFreeMemAndNil(var P);
//var
//  ptr: Pointer;
//begin
//  if Pointer(P) <> nil then
//  begin
//    ptr := Pointer(P);
//    {$IFDEF _DEBUG_}
//    //dbg('$'+IntToHex(NativeUInt(ptr), 9));
//    {$ENDIF}
//    Pointer(P) := nil;
//    DbxFreeMem(ptr);
//  end;
//end;

procedure FreeMemAndNil(var MemPtr); {$IFDEF _INLINE_} inline; {$ENDIF}
var
  ptr: Pointer;
begin
  if Pointer(MemPtr) <> nil then
  begin
    ptr := Pointer(MemPtr);
    {$IFDEF _TRACE_CALLS_}
    try
    //{$R+}
    //  LogEnterProc('FreeMemAndNil(' + '$'+IntToHex(NativeUInt(ptr), 9) + ')' );
    //{$IFDEF RANGECHECKS_OFF}{$R-}{$ENDIF}
    //try
    {$ENDIF _TRACE_CALLS_}
      //{$IFDEF _DEBUG_}
      //dbg('$'+IntToHex(NativeUInt(ptr), 9));
      //{$ENDIF}
      Pointer(MemPtr) := nil;
      FreeMem(ptr);
    {$IFDEF _TRACE_CALLS_}
    except
      on e: Exception do
      begin
        LogExceptProc(AnsiString('FreeMemAndNil(' + '$'+IntToHex(NativeUInt(ptr), 9) + ')'), e);
        raise;
      end;
    end;
    //finally LogExitProc('FreeMemAndNil'); end;
    {$ENDIF}
  end;
end;

//
// Match Functions:
//
procedure MaxSet(var x: Integer; n: Integer); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  if x < n then
    x := n;
end;

function MaxSet(var x: Integer; n, max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  if x < n then
  begin
    Result := n <= max;
    if Result then
      x := n;
  end
  else
    Result := True;
end;

procedure MaxSet(var x: Integer; const S: AnsiString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  MaxSet(x, Length(S));
end;

function MaxSet(var x: Integer; const S: AnsiString; max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  Result := MaxSet(x, Length(S), max);
end;

procedure MaxSet(var x: Integer; const S: WideString); overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  MaxSet(x, Length(S));
end;

function MaxSet(var x: Integer; const S: WideString; max: Integer): Boolean; overload; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  Result := MaxSet(x, Length(S), max);
end;

//
// BCD Functions:
//
{$IFDEF _D9UP_}{$REGION 'COMMENTS'}{$ENDIF}
//
// QC : 6169:
//
//  BcdToStr can have results with a different separator.
//  BcdToStr uses for a separator '.', and used by it FractionToStr
//  uses global DecimalSeparator.
//
{$IFDEF _D9UP_}{$ENDREGION}{$ENDIF}
//
function BCD2Str(pOut: PAnsiChar; const ABcd: TBcd; ADot: AnsiChar = '.';
  bExpFormat: Boolean = False): integer; //{$IFDEF _INLINE_} inline; {$ENDIF}
// returned result length
var
  iLoop, iNumDigits, iWasDigitCount, iExp: Integer;
  cVal: Byte;
  iSignSpecialPlaces : Byte;
begin
  {$IFDEF _TRACE_CALLS_}try{$ENDIF _TRACE_CALLS_}
  Result := integer(pOut);
  //Debug: PAnsiChar(Result)
  {
  if ADot in ['0'..'9', '+', '-', 'E', 'e'] then
    ADot := cDecimalSeparatorDefault;
  }
  iSignSpecialPlaces := ABcd.SignSpecialPlaces;
  if bExpFormat then
  begin
    iExp := iSignSpecialPlaces and 63;
    bExpFormat := iExp > 0;
    if bExpFormat then
      iSignSpecialPlaces := iSignSpecialPlaces and not 63;
  end
  else
    iExp := 0;

  // First, is the number negative?
  if (iSignSpecialPlaces and (1 shl 7)) <> 0 then
  begin
    pOut^ := '-';
    Inc(pOut);
  end;

  // Now, loop through the whole part of the bcd number
  // use lower 6 bits of iSignSpecialPlaces.
  iWasDigitCount := 0;
  iNumDigits := ABcd.Precision - (iSignSpecialPlaces and 63);
  for iLoop := 0 to iNumDigits - 1 do
  begin
    if (iLoop mod 2) <> 0 then
      // lower 4 bits only
      cVal := (ABcd.Fraction[(iLoop - 1 ) div 2] and 15) + Ord('0')
    else
      // upper 4 bits only
      cVal := (ABcd.Fraction[iLoop div 2] shr 4) + Ord('0');

    // This little test is used to strip leading '0' chars:

    //if not bZero then
    if (cVal <> Ord('0')) or (iWasDigitCount > 0) then
    begin
      pOut^ := AnsiChar(Chr(cVal));
      Inc(pOut);
      inc(iWasDigitCount);
    end;
  end;

  // If no data is stored yet, add a leading '0'.
  if iWasDigitCount = 0 then begin
    pOut^ := '0';
    Inc(pOut);
    iExp := 0;
  end;

  if not bExpFormat then
  begin

    pOut^ := ADot;
    Inc(pOut);

    iWasDigitCount := 0;
    for iLoop := iNumDigits to ABcd.Precision - 1 do begin
      if iLoop mod 2 <> 0 then
        // lower 4 bits only
        pOut^ := AnsiChar(Chr((ABcd.Fraction[(iLoop - 1) div  2] and 15) + Ord('0')))
      else
        // upper 4 bits only
        pOut^ := AnsiChar(Chr((ABcd.Fraction[iLoop div 2] shr 4) + Ord('0')));
      Inc(pOut);
      Inc(iWasDigitCount);
    end;

    // If trailing char is decimal point, add a '0'.

    if (pOut - 1)^ = ADot then
    begin
      Dec(pOut);
    end
    else
    begin
      // Right trim '0' chars
      while (iWasDigitCount > 0) and ((pOut - 1)^ = '0') do
      begin
        Dec(pOut);
        Dec(iWasDigitCount);
      end;
    end;

  end
  else // if bExpFormat then
  begin

    // Right trim '0' chars
    while ((pOut - 1)^ = '0') and (iWasDigitCount > 1) do
    begin
      Dec(iWasDigitCount);
      Dec(pOut);
      Dec(iExp);
    end;

    if iExp > 0 then
    begin
      // '-E'
      pOut^ := '-';
      Inc(pOut);
      pOut^ := 'E';
      Inc(pOut);

      System.AnsiStrings.StrCopy(pOut, PAnsiChar(AnsiString(IntToStr(iExp))));
      if iExp < 10 then
        Inc(pOut)
      else
        Inc(pOut, 2);
    end;
  end;

  pOut^ := cNullAnsiChar;

  // ASize:
  Result := Integer(pOut) - Result; { with #0 }

  {$IFDEF _TRACE_CALLS_}
  except
    on e: Exception do
    begin
      LogExceptProc('BCD2Str', e);
      raise;
    end;
  end;
  {$ENDIF}
end;

{$IFDEF PUREPASCAL}

function TryStr2Int(const S: AnsiString; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(string(S), Value, E);
  Result := E = 0;
end;

function TryStr2Bcd(const AValue: AnsiString; var ABcd: TBcd; ADot: AnsiChar): Boolean;
const
  cSpaceChars = [' ', #6, #10, #13, #14];
var
  Negative: Boolean;
  PStr: PAnsiChar;
  DecimalPos, Exp: Integer;
  Pos: Byte;
begin
  FillChar(ABcd, SizeOf(ABcd), #0);
  PStr := @AValue[1];
  while CharInSet(PStr^, cSpaceChars) do
    Inc(PStr);
  Negative := PStr^ = '-';
  if Negative or (PStr^ = '+') then
    Inc(PStr);
  // Skip leading 0s;
  while PStr^ = '0' do
    Inc(PStr);

  Pos := 0;
  DecimalPos := -1;
  while PStr^ <> cNullAnsiChar do
  begin
    if PStr^ = ADot then
    begin
      if DecimalPos <> -1 then
        Exit(False);
      if Pos = 0 then
        Inc(Pos);
      DecimalPos := Pos;
      Inc(PStr);
    end;
    if CharInSet(PStr^, cSpaceChars) or CharInSet(PStr^, ['E', 'e']) then
      Break;

    if (PStr^ < '0') or (PStr^ > '9') then
      Exit(False);

    if (Pos = 64) and (DecimalPos = -1) then
      Exit(False); // Too many digits

    if Pos < 64 then
    begin
      if (Pos and 1) = 0 then
        ABcd.Fraction[Pos div 2] := Byte(Ord(PStr^) - Ord('0')) * $10
      else
        ABcd.Fraction[Pos div 2] := (ABcd.Fraction[Pos div 2] and $F0) + Byte(Ord(PStr^) - Ord('0'));
      Inc(Pos);
    end;
    Inc(PStr);
  end;

  // Scientific notation
  if CharInSet(PStr^, ['E', 'e']) then   // Most typical situation: X.XXEYYY. DecimalPos = 1
  begin
    if not TryStr2Int(PAnsiChar(@PStr[1]), Exp) then
      Exit(False);
    if DecimalPos < 0 then
    begin
      DecimalPos := Pos;
      Inc(Pos);
    end;
    if Exp < 0 then
    begin
      begin
        if DecimalPos < -Exp then
        begin
          ABcd.Precision := Pos;
          ABcd.SignSpecialPlaces := Pos -1;
          Exp := Pos - Exp;
          Pos := Pos - DecimalPos;
          if Exp > MaxFMTBcdFractionSize then
          begin
            dec(Pos,  Exp - MaxFMTBcdFractionSize);
            DecimalPos := Exp - MaxFMTBcdFractionSize;
            Exp := MaxFMTBcdFractionSize;
          end;
          if not NormalizeBcd(ABcd, ABcd, Exp, Pos) then
            Exit(False);
          Pos := Exp;
        end
        else
          Inc(DecimalPos, Exp);
      end;
    end
    else
    begin
      inc(DecimalPos, Exp);
      if DecimalPos > Pos then
      begin
        Pos := DecimalPos;
        DecimalPos := -1;
      end;
    end;

  end else
  begin
    while CharInSet(PStr^, cSpaceChars) do
      Inc(PStr);
    if PStr^ <> cNullAnsiChar then
      Exit(False);
  end;

  if Pos = 0 then
  begin
    ABcd.Precision := 10;
    ABcd.SignSpecialPlaces := 2;
  end
  else
  begin
    if Pos > 64 then
      Exit(False);
    ABcd.Precision := Pos;
    if DecimalPos = -1 then
      ABcd.SignSpecialPlaces := 0
    else
      ABcd.SignSpecialPlaces := Pos - DecimalPos;
    // Because it's easier to shift bytes than nibbles,
    // Always make it an even precision, add a 0 if needed
    if (Pos and 1) = 1 then
    begin
      Inc(ABcd.Precision);
      Inc(ABcd.SignSpecialPlaces);
    end;

    if Negative then
      ABcd.SignSpecialPlaces := ABcd.SignSpecialPlaces or $80;
  end;
  Result := True;
end;

procedure Str2BCD(PValue: PAnsiChar; ASize: LongWord; var ABcd: TBcd; ADot: AnsiChar);
var
  AValue: AnsiString;
begin
  if (PValue^ = '0') and ((ASize = 1) or ((PValue + 1)^ = cNullAnsiChar)) or
     (PValue^ = cNullAnsiChar) then
  begin
    FillChar(ABcd, SizeOf(ABcd), #0);
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;
  //
  StrClone(PValue, AValue, Cardinal(ASize));
  if not TryStr2Bcd(AValue, ABcd, ADot) then
  begin
    FillChar(ABcd, SizeOf(ABcd), #0);
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
  end;
end;

{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}

procedure Str2BCD(PValue: PAnsiChar; ASize: LongWord; var ABcd: TBcd; ADot: AnsiChar);
var
  lNeg, lDec: Boolean;
  DecimalPos: LongWord;
  pTmp: PAnsiChar;
begin
  {$IFDEF _TRACE_CALLS_}try{$ENDIF _TRACE_CALLS_}
  FillChar(ABcd.Fraction, SizeOf(ABcd.Fraction), 0);
  if (PValue^ = '0') and ((ASize = 1) or ((PValue + 1)^ = cNullAnsiChar)) or
     (PValue^ = cNullAnsiChar) then
  begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  {
  if ADot in ['0'..'9', '+', '-', 'E', 'e'] then
    ADot := cDecimalSeparatorDefault;
  }
  DecimalPos := 0;
  lDec := False;
  while DecimalPos < ASize do
  begin
    {+}
    //if PValue[DecimalPos] = ADot then begin
    if not (PValue[DecimalPos] in ['0'..'9', '-', '+', ' ']) then
    {+.}
    begin
      ADot := PValue[DecimalPos];
      lDec := True;
      Break;
    end;
    Inc(DecimalPos);
  end;
  if DecimalPos = ASize then
    DecimalPos := 0;

  { Strip leading whitespace }
  while (PValue^ <= ' ') or (PValue^ = '0') do begin
    Inc(PValue);
    Dec(ASize);
    if DecimalPos > 0 then
      Dec(DecimalPos);
  end;

  { Strip trailing whitespace }
  pTmp := PValue + ASize - 1;
  while pTmp^ <= ' ' do begin
    pTmp^ := cNullAnsiChar;
    Dec(pTmp);
  end;

  { Is the number negative? }
  if PValue^ = '-' then begin
    lNeg := True;
    if DecimalPos > 0 then
      Dec(DecimalPos);
    Inc(PValue);
    Dec(ASize);
  end
  else begin
    lNeg := False;
    if PValue^ = '+' then begin
      if DecimalPos > 0 then
        Dec(DecimalPos);
      Inc(PValue);
      Dec(ASize);
    end;
  end;

  { Clear structure }
  if PValue^ = '0' then begin
    Inc(PValue);  // '0.' scenario
    Dec(ASize);
    if DecimalPos > 0 then
      Dec(DecimalPos);
  end;

  if ASize > 66 then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  asm
      // From bytes to nibbles, both left aligned
      PUSH    ESI
      PUSH    EDI
      PUSH    EBX
      MOV     ESI, PValue       // move PValue to ESI
      MOV     EDI, ABcd      // move pTo to EDI
      ADD     EDI, OFFSET TBcd.Fraction
      MOV     ECX, ASize     // store count in ECX
      MOV     DL,0           // Flag: when to store
      CLD
@@1:  LODSB                  // moves [ESI] into al
      CMP     AL, ADot
      JE      @@4
      SUB     AL, '0'
      CMP     DL, 0
      JNE     @@2
      SHL     AL, 4
      MOV     AH, AL
      JMP     @@3
@@2:  OR      AL, AH         // takes AH and ors in AL
      STOSB                  // always moves AL into [EDI]
@@3:  NOT     dl             // flip all bits
@@4:  DEC     ECX            // LOOP @@1, decrements cx and checks if it's 0
      JNE     @@1
      CMP     DL, 0          // are any bytes left unstored?
      JE      @@5
      MOV     AL, AH         // if so, move to al
      STOSB                  // and store to [EDI]
@@5:  POP     EBX
      POP     EDI
      POP     ESI
  end;

  if lDec then begin
    ABcd.Precision := Byte(ASize - 1);
    if lNeg then
      ABcd.SignSpecialPlaces := (1 shl 7) + Byte(ASize - DecimalPos - 1)
    else
      ABcd.SignSpecialPlaces := (0 shl 7) + Byte(ASize - DecimalPos - 1);
  end
  else begin
    ABcd.Precision := Byte(ASize);
    if lNeg then
      ABcd.SignSpecialPlaces := (1 shl 7)
    else
      ABcd.SignSpecialPlaces := (0 shl 7);
  end;
  {$IFDEF _TRACE_CALLS_}
  except
    on e: Exception do
    begin
      LogExceptProc('Str2BCD', e);
      raise;
    end;
  end;
  {$ENDIF}
end;

{$ELSE !CPUX86}
  ERROR: 'platform not supported'
{$ENDIF !CPUX86}
{$ENDIF !PUREPASCAL}

//
// AnsiString/WideString functions:
//
function WideStringLengthFromStr;//(const S: PAnsiChar): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  Result := Length(WideString(System.AnsiStrings.StrPas(S)));
end;

function WideStringLengthFromStrings;//(const L: TStrings): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  if L.Count > 0 then
    Result := Length(WideString(L.Text))
  else
    Result := 0;
end;

{$IFDEF _KYLIX_}
const
  LC_CTYPE    = 0;
  _NL_CTYPE_CODESET_NAME = LC_CTYPE shl 16 + 14;

type
  TCharacterSizeProc = function(P: Pointer; MaxLen: Integer): Integer;

function nl_langinfo(item: integer): pchar; cdecl;
  external libcmodulename name 'nl_langinfo';

function iconv_open(ToCode: PChar; FromCode: PChar): Integer; cdecl;
  external libcmodulename name 'iconv_open';

function iconv_close(cd: Integer): Integer; cdecl;
  external libcmodulename name 'iconv_close';

 function iconv(cd: Integer; var InBuf; var InBytesLeft: Integer; var OutBuf; var OutBytesLeft: Integer): Integer; cdecl;
  external libcmodulename name 'iconv';

function mblen(const S: PChar; N: LongWord): Integer; cdecl;
  external libcmodulename name 'mblen';

function BufConvert0(pDest: PWideChar; DestChars: Integer;
                     pSrc: PAnsiChar; SrcBytes: Integer): Integer;
begin
  if (DestChars > 0) and (SrcBytes > 0) then
  begin
    if DestChars > SrcBytes then
      SrcBytes := DestChars;
    Result := SrcBytes * SizeOf(WideChar);
    while SrcBytes > 0 do
    begin
      pDest^ := WideChar(pSrc^);
      Inc(pDest);
      Inc(pSrc);
      Dec(SrcBytes);
    end;
  end
  else
  begin
    if (DestChars >= 0) or (SrcBytes <= 0) then
      Result := 0
    else
      Result := -1;
  end;
end;

function BufConvert(var Dest;     DestBytes: Integer;
                    const Source; SrcBytes: Integer;
                    context: Integer;
                    DestCharSize: Integer;
                    SourceCharSize: TCharacterSizeProc): Integer;
const
  E2BIG = 7;
  EINVAL = 22;
  EILSEQ = 84;
const
  UnknownCharIndicator = '?';
var
  SrcBytesLeft, DestBytesLeft, Zero: Integer;
  s, d, pNil: Pointer;
  LastError: Integer;
  cs: Integer;
begin
  Result := -1;
  //
  // Make copies of parameters. iconv modifies param pointers.
  DestBytesLeft := DestBytes;
  SrcBytesLeft := SrcBytes;
  s := Pointer(Source);
  d := Pointer(Dest);
  //
  while True do
  begin
    Result := iconv(context, s, SrcBytesLeft, d, DestBytesLeft);
    if Result <> -1 then
      Break
    else
    begin
      LastError := GetLastError;
      if (LastError = E2BIG) and (SrcBytesLeft > 0) and (DestBytesLeft > 0) then
        Continue;
      //
      if (LastError <> EINVAL) and (LastError <> EILSEQ) then
        //LocaleConversionError;
        raise Exception.Create('Locale Conversion Error');
      pNil := nil;
      Zero := 0;
      iconv(context, pNil, Zero, pNil, Zero); // Reset state of context
      //
      // Invalid input character in conversion stream.
      // Skip input character and write '?' to output stream.
      // The glibc iconv() implementation also returns EILSEQ
      // for a valid input character that cannot be converted
      // into the requested codeset.
      cs := SourceCharSize(s, SrcBytesLeft);
      Inc(Cardinal(s), cs);
      Dec(SrcBytesLeft, cs);
      //
      //Assert(DestCharSize in [1, 2]);
      case DestCharSize of
        1:
          begin
            PChar(d)^ := UnknownCharIndicator;
            Inc(PChar(d));
            Dec(DestBytesLeft, SizeOf(Char));
          end;
        2:
          begin
            PWideChar(d)^ := UnknownCharIndicator;
            Inc(PWideChar(d));
            Dec(DestBytesLeft, SizeOf(WideChar));
          end;
      end;
    end;
  end;
  if Result <> -1 then
    Result := DestBytes - DestBytesLeft;
end;

function CharacterSizeLocaleChar(P: Pointer; MaxLen: Integer): Integer;
begin
  //Assert(Assigned(P));
  Result := mblen(P, MaxLen);
  if Result <= 0 then
  begin
    mblen(nil, 0);
    Result := SizeOf(Char);
  end;
end;

var
  IconvContext: Integer = -1;
{$ENDIF _KYLIX_}

function WCharFromChar;//(WCharDest: PWideChar; DestChars: Integer; const CharSource: PAnsiChar; SrcBytes: Integer): Integer; {$IFNDEF _KYLIX_}{$IFDEF _INLINE_} inline; {$ENDIF}{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := MultiByteToWideChar(DefaultSystemCodePage, 0, CharSource, SrcBytes, WCharDest, DestChars);
  {$ELSE}
    {$IFDEF UNICODE}
    Result := UnicodeFromLocaleChars(DefaultSystemCodePage, 0, CharSource, SrcBytes, WCharDest, DestChars);
    {$ELSE} // KYLIX:
    if (DestChars <> 0) and (SrcBytes <> 0) then
    begin
      if IconvContext <> -1 then
        Result := BufConvert(WCharDest, DestChars * SizeOf(WideChar), CharSource, SrcBytes,
          IconvContext, 2, CharacterSizeLocaleChar)
      else
        //raise Exception.Create('Locale Conversion Error');
        Result := BufConvert0(WCharDest, DestChars, CharSource, SrcBytes);
      if Result <> -1 then
        Result := Result div SizeOf(WideChar);
    end
    else
      Result := 0;
    {$ENDIF}
  {$ENDIF}
end;

function StringToWideChar;//(const Source: AnsiString; Dest: PWideChar; DestChars: Integer): Integer; {$IFDEF _INLINE_} inline; {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := MultiByteToWideChar(DefaultSystemCodePage, {Flags}0,
    {CharSource:}PAnsiChar(Source), {SrcBytes:}Length(Source), Dest, DestChars);
  {$ELSE}
    {$IFDEF UNICODE}
    Result := UnicodeFromLocaleChars(DefaultSystemCodePage, 0, PAnsiChar(Source), Length(Source), Dest, DestChars);
    {$ELSE}
    Result := WCharFromChar(Dest, DestChars, PAnsiChar(Source), Length(Source));
    {$ENDIF}
  {$ENDIF}
  if Result > 0 then
    Dest[Result] := cNullWideChar
  else
    Dest^ := cNullWideChar;
end;

function StringToWStr(const Source: AnsiString; var Dest: PWideChar): Integer; overload;
begin
  Result := Length(Source);
  if Result > 0 then
  begin
    Result := WCharFromChar(Dest, {DestCharCount}Result, PAnsiChar(Source), {SrcBytes}Result);
    Dest[Result] := cNullWideChar;
  end
  else
  begin
    Dest^ := cNullWideChar;
    Result := 0;
  end;
end;

function StringToWStr(const Source: WideString; var Dest: PWideChar): Integer; overload;
begin
  Result := StringToWStr(AnsiString(Source), Dest);
end;

function StringsToWStr(const L: TStrings; var Dest: PWideChar): Integer; overload;
begin
  if L.Count > 0 then
    Result := StringToWStr(L.Text, Dest)
  else
  begin
    Dest^ := cNullWideChar;
    Result := 0;
  end;
end;

function StrLenNil(const AStr: PAnsiChar): Integer;
begin
  if AStr = nil then
    Result := 0
  else
    Result := System.AnsiStrings.StrLen(AStr);
end;

//function StrCompNil(const Str1, Str2: PAnsiChar): Integer;
//begin
//  if (Str1 = nil) then
//  begin
//    if (str2 = nil) then
//      Result := 0
//    else
//      Result := -1
//  end
//  else
//  if (str2 = nil) then
//     Result := 1
//  else
//    Result := StrComp(str1, str2);
//end;

function WStrLen;//(const Str: PWideChar): Cardinal;
{$IFDEF PUREPASCAL}
var
  P : PWideChar;
begin
  P := Str;
  while (P^ <> #0) do
    Inc(P);
  Result := P - Str;
end;
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
asm
  {Check the first byte}
  cmp word ptr [eax], 0
  je @ZeroLength
  {Get the negative of the string start in edx}
  mov edx, eax
  neg edx
@ScanLoop:
  mov cx, [eax]
  add eax, 2
  test cx, cx
  jnz @ScanLoop
  lea eax, [eax + edx - 2]
  shr eax, 1
  ret
@ZeroLength:
  xor eax, eax
end;
{$ELSE !CPUX86}
  ERROR: 'platform not supported'
{$ENDIF !CPUX86}
{$ENDIF !PUREPASCAL}

function WStrComp(const Str1, Str2: PWideChar): Integer;
var
  P1, P2: PWideChar;
  C1, C2: WideChar;
begin
  P1 := Str1;
  P2 := Str2;
  while True do
  begin
    C1 := P1^;
    C2 := P2^;

    if (C1 <> C2) or (C1 = #0) then
    begin
      Result := Ord(C1) - Ord(C2);
      Exit;
    end;

    Inc(P1);
    Inc(P2);
  end;
end;

function WStrIComp(const Str1, Str2: PWideChar): Integer;
var
  P1, P2: PWideChar;
  C1, C2: WideChar;
begin
  P1 := Str1;
  P2 := Str2;
  while True do
  begin
    C1 := P1^;
    C2 := P2^;

    case C1 of
      'a'..'z':
        C1 := WideChar(Word(C1) xor $0020);
    end;

    case C2 of
      'a'..'z':
        C2 := WideChar(Word(C2) xor $0020);
    end;

    if (C1 <> C2) or (C1 = #0) then
    begin
      Result := Ord(C1) - Ord(C2);
      Exit;
    end;

    Inc(P1);
    Inc(P2);
  end;
end;

function WStrLComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;
var
  P1, P2: PWideChar;
  I: Cardinal;
  C1, C2: WideChar;
begin
  P1 := Str1;
  P2 := Str2;
  I := 0;
  while I < MaxLen do
  begin
    C1 := P1^;
    C2 := P2^;

    if (C1 <> C2) or (C1 = #0) then
    begin
      Result := Ord(C1) - Ord(C2);
      Exit;
    end;

    Inc(P1);
    Inc(P2);
    Inc(I);
  end;
  Result := 0;
end;

function WStrCopy(Dest: PWideChar; const Source: PWideChar): Integer; overload;
//var
//  D: Integer absolute Dest;
//  S: Integer absolute Source;
//  R: Integer absolute Result;
begin
  Result := WStrLen(Source);
  // AV Check:
  //if (R > 0) and ( ((D>=S)and(D<(S+R))) or (((D+R)>S)and((D+R)<(S+R))) ) then
  //begin
  //  Result := 0;
  //end
  //else
  Move(PAnsiChar(Source)^, Dest^, (Result + 1) * SizeOf(WideChar));
end;

function WStrCopy(Dest: PWideChar; const Source: WideString): Integer; overload;
begin
  Result := WStrCopy(Dest, PWideChar(Source));
end;

function WStrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;
var
  Src : PWideChar;
begin
  Result := Dest;
  Src := Source;
  while (Src^ <> #$00) and (MaxLen > 0) do
  begin
    Dest^ := Src^;
    Inc(Src);
    Inc(Dest);
    Dec(MaxLen);
  end;
  Dest^ := #$00;
end;

function StrBuffCopy(const Source: PAnsiChar; var Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Dest) and StrNotEmpty(Source) then
  begin
    Result := System.AnsiStrings.StrLen(Source);
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := 0; //MaxLen;
  end
  else
    Result := 0;
  if Result > 0 then
  begin
    Move(Source^, Dest^, Result);
    Dest[Result] := cNullAnsiChar;
  end
  else if Assigned(Dest) then
    Dest^ := cNullAnsiChar;
end;

function StrBuffCopy(const Source: PWideChar; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Dest) and StrNotEmpty(Source) then
  begin
    Result := WStrLen(Source);
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := 0; //MaxLen;
  end
  else
    Result := 0;
  if Result > 0 then
  begin
    Move(Source^, Dest^, Result * SizeOf(WideChar));
    Dest[Result] := cNullWideChar;
  end
  else if Assigned(Dest) then
    Dest^ := cNullWideChar;
end;

function StrBuffCopy(const Source: AnsiString; var Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Dest) and StrNotEmpty(Source) then
  begin
    Result := Length(Source);
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := 0; //MaxLen;
  end
  else
    Result := 0;
  if Result > 0 then
  begin
    Move(PansiChar(Source)^, Dest^, Result);
    Dest[Result] := cNullAnsiChar;
  end
  else if Assigned(Dest) then
    Dest^ := cNullAnsiChar;
end;

function StrBuffCopy(const Source: WideString; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Dest) and StrNotEmpty(Source) then
  begin
    Result := Length(Source);
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := 0; //MaxLen;
  end
  else
    Result := 0;
  if Result > 0 then
  begin
    Move(PAnsiChar(PWideChar(Source))^, Dest^, Result * SizeOf(WideChar));
    Dest[Result] := cNullWideChar;
  end
  else if Assigned(Dest) then
    Dest^ := cNullWideChar;
end;

function StrBuffCopy(const Source: AnsiString; var Dest: PAnsiChar; MaxLen: PInteger): Integer; overload;
var
  AMaxLen: Cardinal;
begin
  if Assigned(MaxLen) and (MaxLen^ > 0) then
    AMaxLen := Cardinal(MaxLen^)
  else
    AMaxLen := 0;
  Result := StrBuffCopy(Source, Dest, AMaxLen);
end;

function StrBuffCopy(const Source: WideString; var Dest: PWideChar; MaxLen: PInteger): Integer; overload;
var
  AMaxLen: Cardinal;
begin
  if Assigned(MaxLen) and (MaxLen^ > 0) then
    AMaxLen := Cardinal(MaxLen^)
  else
    AMaxLen := 0;
  Result := StrBuffCopy(Source, Dest, AMaxLen);
end;

function StrClone(const Source: PAnsiChar; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if (Source = nil) or (Source^ = cNullAnsiChar) then
    Result := 0
  else
    Result := System.AnsiStrings.StrLen(Source);
  if Result = 0 then
  begin
    Dest := nil;
  end
  else
  begin
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := MaxLen;
    Dest := AllocMem(Result + 2);
    //StrCopy(Dest, Source);
    Move(Source^, Dest^, Result);
    Dest[Result] := cNullAnsiChar;
  end;
end;

function StrClone(const Source: PAnsiChar; out Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if (Source = nil) or (Source^ = cNullAnsiChar) then
    Result := 0
  else
    Result := System.AnsiStrings.StrLen(Source);
  if Result = 0 then
  begin
    Dest := nil;
  end
  else
  begin
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := MaxLen;
    Pointer(Dest) := AllocMem((Result + 2) * SizeOf(WideChar)); // * 4
    Result := WCharFromChar(Dest, {DestCharCount}Result, Source, {SrcBytes}Result);
    Dest[Result] := cNullWideChar;
  end;
end;

function StrClone(const Source: AnsiString; out Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  Result := Length(Source);
  if (Result = 0) or (Source[1] = cNullAnsiChar) then
    Dest := nil
  else
  begin
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := MaxLen;
    Pointer(Dest) := AllocMem((Result + 2) * SizeOf(WideChar)); // * 4
    Result := WCharFromChar(Dest, {DestCharCount}Result, PAnsiChar(Source), {SrcBytes}Result);
    Dest[Result] := cNullWideChar;
  end;
end;

function StrClone(const Source: AnsiString; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  Result := Length(Source);
  if (Result = 0) or (Source[1] = cNullAnsiChar) then
    Dest := nil
  else
  begin
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := MaxLen;
    Dest := AllocMem(Result + 2);
    Move(PAnsiChar(Source)^, Dest^, Result);
    Dest[Result] := cNullAnsiChar;
  end;
end;

function StrClone(const Source: WideString; var Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  Result := StrClone(PAnsiChar(AnsiString(Source)), Dest, MaxLen);
end;

function StrClone(const Source: WideString; var Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  Result := StrClone(PWideChar(Source), Dest, MaxLen);
end;

function StrClone(const Source: PWideChar; out Dest: PAnsiChar; MaxLen: Cardinal = 0): Integer; overload;
var
  S: AnsiString;
begin
  if (Source = nil) or (Source^ = cNullWideChar) then
  begin
    Dest := nil;
    Result := 0;
  end
  else
  begin
    S := AnsiString(WideString(Source));
    Result := Length(S);
    if Result > 0 then
    begin
      if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
        Result := MaxLen;
      Dest := AllocMem(Result + 2);
      Move(PAnsiChar(Source)^, Dest^, Result);
      Dest[Result] := cNullAnsiChar;
    end
    else
      Dest := nil;
  end;
end;

function StrClone(const Source: PWideChar; out Dest: PWideChar; MaxLen: Cardinal = 0): Integer; overload;
begin
  if (Source = nil) or (Source^ = cNullWideChar) then
  begin
    Dest := nil;
    Result := 0;
  end
  else
  begin
    Result := WStrLen(Source);
    if (MaxLen > 0) and (MaxLen < Cardinal(Result)) then
      Result := MaxLen;
    Pointer(Dest) := AllocMem((Result + 2) * SizeOf(WideChar));
    Move(PAnsiChar(Source)^, Dest^, Result * SizeOf(WideChar));
    Dest[Result] := cNullWideChar;
  end;
end;

function StrClone(const Source: PAnsiChar; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Source) and (Source^ <> cNullAnsiChar) then
  begin
    Dest := System.AnsiStrings.StrPas(Source);
    if (MaxLen > 0) and (Maxlen < Cardinal(Length(Dest))) then
      SetLength(Dest, MaxLen);
    Result := Length(Dest);
  end
  else
  begin
    SetLength(Dest, 0);
    Result := 0;
  end;
end;

function StrClone(const Source: PWideChar; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Source) and (Source^ <> cNullWideChar) then
  begin
    Dest := AnsiString(WideString(Source));
    if (MaxLen > 0) and (Maxlen < Cardinal(Length(Dest))) then
      SetLength(Dest, MaxLen);
    Result := Length(Dest);
  end
  else
  begin
    SetLength(Dest, 0);
    Result := 0
  end;
end;

function StrClone(const Source: PAnsiChar; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Source) and (Source^ <> cNullAnsiChar) then
  begin
    Dest := WideString(System.AnsiStrings.StrPas(Source));
    if (MaxLen > 0) and (Maxlen < Cardinal(Length(Dest))) then
      SetLength(Dest, MaxLen);
  end
  else
    SetLength(Dest, 0);
  Result := Length(Dest);
end;

function StrClone(const Source: PWideChar; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if Assigned(Source) and (Source^ <> cNullWideChar) then
  begin
    Dest := WideString(Source);
    if (MaxLen > 0) and (Maxlen < Cardinal(Length(Dest))) then
      SetLength(Dest, MaxLen);
  end
  else
    SetLength(Dest, 0);
  Result := Length(Dest);
end;

function StrClone(const Source: AnsiString; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if MaxLen = 0 then
    Dest := AnsiString(Source)
  else
    Dest := Copy(Source, 1, MaxLen);
  Result := Length(Dest);
end;

function StrClone(const Source: WideString; var Dest: AnsiString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if MaxLen = 0 then
    Dest := AnsiString(Source)
  else
    Dest := AnsiString(Copy(Source, 1, MaxLen));
  Result := Length(Dest);
end;

function StrClone(const Source: AnsiString; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if MaxLen = 0 then
    Dest := WideString(Source)
  else
    Dest := WideString(Copy(Source, 1, MaxLen));
  Result := Length(Dest);
end;

function StrClone(const Source: WideString; var Dest: WideString; MaxLen: Cardinal = 0): Integer; overload;
begin
  if MaxLen = 0 then
    Dest := Source
  else
    Dest := Copy(Source, 1, MaxLen);
  Result := Length(Dest);
end;

function StrIsEmpty(const Source: PAnsiChar): Boolean; overload;
begin
  Result := (Source = nil) or (Source^ = cNullAnsiChar);
end;

function StrIsEmpty(const Source: PWideChar): Boolean; overload;
begin
  Result := (Source = nil) or (Source^ = cNullWideChar);
end;

function StrIsEmpty(const Source: AnsiString): Boolean; overload;
begin
  Result := (Length(Source) = 0) or (Source[1] = cNullAnsiChar);
end;

function StrIsEmpty(const Source: WideString): Boolean; overload;
begin
  Result := (Length(Source) = 0) or (Source[1] = cNullWideChar);
end;

function StrNotEmpty(const Source: PAnsiChar): Boolean; overload;
begin
  Result := Assigned(Source) and (Source^ <> cNullAnsiChar);
end;

function StrNotEmpty(const Source: PWideChar): Boolean; overload;
begin
  Result := Assigned(Source) and (Source^ <> cNullWideChar);
end;

function StrNotEmpty(const Source: AnsiString): Boolean; overload;
begin
  Result := (Length(Source) > 0) and (Source[1] <> cNullAnsiChar);;
end;

function StrNotEmpty(const Source: WideString): Boolean; overload;
begin
  Result := (Length(Source) > 0) and (Source[1] <> cNullWideChar);;
end;

//procedure StrFree(var Source: PAnsiChar); overload;
//begin
//  if Assigned(Source) then
//  begin
//    FreeMem(Source);
//    Source := nil;
//  end;
//end;
//
//procedure StrFree(var Source: PWideChar); overload;
//begin
//  if Assigned(Source) then
//  begin
//    FreeMem(Source);
//    Source := nil;
//  end;
//end;
//
//procedure StrFree(var Source: AnsiString); overload;
//begin
//  SetLength(Source, 0);
//end;
//
//procedure StrFree(var Source: WideString); overload;
//begin
//  SetLength(Source, 0);
//end;

function StrPtrToString(const Source: Pointer; bUnicode: Boolean): AnsiString; overload;
begin
  if bUnicode then
    Result := AnsiString(WideString(PWideChar(Source)))
  else
    Result := System.AnsiStrings.StrPas(PAnsiChar(Source));
end;

function StrPtrToString(const Source: PAnsiChar): AnsiString; overload;
begin
  if (Source = nil) or (Source^ = cNullAnsiCHar) then
    Result := ''
  else
    Result := System.AnsiStrings.StrPas(Source);
end;

function StrPtrToString(const Source: PWideChar): AnsiString; overload;
begin
  if (Source = nil) or (Source^ = cNullWideCHar) then
    Result := ''
  else
    Result := AnsiString(WideString(Source));
end;


// Str Compare:

function StrSameText(const S1, S2: PAnsiChar): Boolean; overload;
begin
  if S1 = nil then
  begin
    if S2 = nil then
      Result := True
    else
      Result := False
  end
  else
  if S2 = nil then
     Result := False
  else
    Result := System.AnsiStrings.StrComp(S1, S2) = 0;
end;

function StrSameText(const S1, S2: PWideChar): Boolean; overload;
begin
  if S1 = nil then
  begin
    if S2 = nil then
      Result := True
    else
      Result := False
  end
  else
  if S2 = nil then
     Result := False
  else
    Result := WStrComp(S1, S2) = 0;
end;

function StrSameText(const S1: PAnsiChar; const S2: PWideChar): Boolean; overload;
begin
  if Assigned(S2) then
    Result := StrSameText(S1, PAnsiChar(AnsiString(WideString(S2))))
  else
    Result := StrSameText(S1, PAnsiChar(nil));
end;

function StrSameText(const S1: PWideChar; const S2: PAnsiChar): Boolean; overload;
begin
  if Assigned(S1) then
    Result := StrSameText(PAnsiChar(AnsiString(WideString(S1))), S2)
  else
    Result := StrSameText(PAnsiChar(nil), S2);
end;

function StrSameText(const S1, S2: AnsiString): Boolean; overload;
begin
  Result := S1 = S2;
end;

function StrSameText(const S1, S2: WideString): Boolean; overload;
begin
  Result := S1 = S2;
end;

function StrSameText(const S1: AnsiString; const S2: WideString): Boolean; overload;
begin
  Result := S1 = AnsiString(S2);
end;

function StrSameText(const S1: WideString; const S2: AnsiString): Boolean; overload;
begin
  Result := AnsiString(S1) = S2;
end;

function StrSameText(const S1: PAnsiChar; const S2: AnsiString): Boolean; overload;
begin
  Result := StrSameText(S1, PAnsiChar(S2));
end;

function StrSameText(const S1: AnsiString; const S2: PAnsiChar): Boolean; overload;
begin
  Result := StrSameText(PAnsiChar(S1), S2);
end;

function StrSameText(const S1: PWideChar; const S2: WideString): Boolean; overload;
begin
  Result := StrSameText(S1, PWideChar(S2));
end;

function StrSameText(const S1: WideString; const S2: PWideChar): Boolean; overload;
begin
  Result := StrSameText(PWideChar(S1), S2);
end;

// Str Compare.

// Str ICompare:

function StrISameText(const S1, S2: PAnsiChar): Boolean; overload;
begin
  if S1 = nil then
  begin
    if S2 = nil then
      Result := True
    else
      Result := False
  end
  else
  if S2 = nil then
     Result := False
  else
    Result := System.AnsiStrings.StrIComp(S1, S2) = 0;
end;

function StrISameText(const S1, S2: PWideChar): Boolean; overload;
begin
  if S1 = nil then
  begin
    if S2 = nil then
      Result := True
    else
      Result := False
  end
  else
  if S2 = nil then
     Result := False
  else
    Result := WStrIComp(S1, S2) = 0;
end;

function StrISameText(const S1: PAnsiChar; const S2: PWideChar): Boolean; overload;
begin
  if Assigned(S2) then
    Result := StrISameText(S1, PAnsiChar(AnsiString(WideString(S2))))
  else
    Result := StrISameText(S1, PAnsiChar(nil));
end;

function StrISameText(const S1: PWideChar; const S2: PAnsiChar): Boolean; overload;
begin
  if Assigned(S1) then
    Result := StrISameText(PAnsiChar(AnsiString(WideString(S1))), S2)
  else
    Result := StrISameText(PAnsiChar(nil), S2);
end;

function StrISameText(const S1, S2: AnsiString): Boolean; overload;
begin
  Result := AnsiCompareText(S1, S2) = 0;
end;

function StrISameText(const S1, S2: WideString): Boolean; overload;
begin
  Result := WideCompareText(S1, S2) = 0;
end;

function StrISameText(const S1: AnsiString; const S2: WideString): Boolean; overload;
begin
  Result := AnsiCompareText(S1, AnsiString(S2)) = 0;
end;

function StrISameText(const S1: WideString; const S2: AnsiString): Boolean; overload;
begin
  Result := AnsiCompareText(AnsiString(S1), S2) = 0;
end;

function PAnsiCharParam(const P: PAnsiChar): PAnsiChar; overload;
begin
  Result := P;
  if Assigned(Result) and (Result^ = cNullAnsiChar) then
    Result := nil;
end;

function PAnsiCharParam(const P: AnsiString): PAnsiChar; overload;
begin
  Result := PAnsiCharParam(PAnsiChar(P));
end;

function StrAnsiStringParam(const P: PAnsiChar): AnsiString; overload;
begin
  if Assigned(P) and (P^ <> cNullAnsiChar) then
    Result := System.AnsiStrings.StrPas(P)
  else
    Result := '';
end;

function StrAnsiStringParam(const P: AnsiString): AnsiString; overload;
begin
  if (Length(P) > 0) and (P[1] <> cNullAnsiChar) then
    Result := P
  else
    Result := '';
end;

// Str ICompare.

function ChangeFileExtW;//(const FileName, Extension: WideString): WideString;
{$IFDEF UNICODE}
begin
  Result := WideString(ChangeFileExt(string(FileName), string(Extension)));
end;
{$ELSE}
var
  I: Integer;
begin
  Result := FileName;
  for I := Length(Result) downto 1 do
  begin
    if Result[i] = WideChar('.') then
    begin
      SetLength(Result, i - 1);
      Break;
    end;
  end;
  Result := Result + Extension;
end;
{$ENDIF}

function PIntToStr(AValue: PInteger): AnsiString;
begin
  if Assigned(AValue) then
    Result := AnsiString(IntToStr(AValue^))
  else
    Result := '';
end;

function ArgStrNull(const S: AnsiString): string;
begin
  if S = cNullAnsiChar then
    Result := ''
  else
    Result := string(S);
end;

{$IFDEF _D12UP_}
function ArgStrNull(const S: string): string;
begin
  if S = cNullWideChar then
    Result := ''
  else
    Result := S;
end;
{$ENDIF}

//
// AnsiString functions:
//
{$IFNDEF _D12UP_}
  {$IFNDEF _D9UP_}
  function AnsiPos;//(const Substr, S: AnsiString): Integer;
  begin
    Result := Pos(Substr, S);
  end;
  {$ENDIF}
{$ENDIF}

initialization
  {$IFNDEF UNICODE}{$IFDEF MSWINDOWS}
  DefaultSystemCodePage := GetACP;
  {$ENDIF}{$ENDIF}
  {$IFDEF _KYLIX_}
  IconvContext := iconv_open('UNICODELITTLE', nl_langinfo(_NL_CTYPE_CODESET_NAME));
  //if IconvContext = -1 then
    //Halt(234); // == LocaleConversionError;
    //raise Exception.Create('Locale Conversion Error');
finalization
  if IconvContext <> -1 then
    iconv_close(IconvContext);
  {$ENDIF _KYLIX_}
end.
