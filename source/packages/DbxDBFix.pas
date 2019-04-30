{
  Part of Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.18

  Copyright (c) 2010 by "Vadim V.Lopushansky" <pult@ukr.net>

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
unit DbxDBFix;
//
// Delphi: 2011,2010,2009,2007,2006,7,6
//         //todo: kylix test ???
interface

//{$IFDEF CONDITIONALEXPRESSIONS}
//var
//  bIsDbxDBFix: Boolean = True;
//{$ENDIF}

implementation

//**************************************
//     zeroizing the directives
//**************************************

{$IF CompilerVersion < 15.00}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
    {$DEFINE POSIX}
  {$ENDIF}
{$IFEND}

{$UNDEF COMPILER_SUPPORTED}
{$UNDEF USE_API_HOOK}
{$UNDEF USE_SQLEXPR}
{$UNDEF USE_DBCLIENT}
{$UNDEF USE_VARIANTS}
{$UNDEF use_AStrLCopyLen}
{$UNDEF use_WStrLCopyLen}

{$UNDEF TFieldAccess}
{$UNDEF TFieldsAccess}
{$UNDEF TIntegerFieldAccess}
{$UNDEF TStringFieldAccess}
{$UNDEF TWideStringFieldAccess}
{$UNDEF TBlobFieldAccess}
{$UNDEF TDataSetAccess}
{$UNDEF TCustomClientDataSetAccess}

//
// {todo:}
//
// QC # 33757 - DBGRID: TField.OnChange causes a stack overflow in DBGrid
// QC # 2339  - TNumericField.GetAsBoolean -> TField.GetAsBoolean
// http://qc.embarcadero.com/wc/qcmain.aspx?d=8417
// http://qc.embarcadero.com/wc/qcmain.aspx?search=1&proj=10&kw=TDataSetProvider&plat=430
// http://qc.embarcadero.com/wc/qcmain.aspx?d=58681
// http://qc.embarcadero.com/wc/qcmain.aspx?d=58518
// http://qc.embarcadero.com/wc/qcmain.aspx?d=58473
// http://qc.embarcadero.com/wc/qcmain.aspx?d=58471
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=43200
// http://qc.embarcadero.com/wc/qcmain.aspx?d=58678
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=7872
// ?!http://qc.embarcadero.com/wc/qcmain.aspx?d=6318
// ?!http://qc.embarcadero.com/wc/qcmain.aspx?d=6317
// ?!http://qc.embarcadero.com/wc/qcmain.aspx?d=6315
// http://qc.embarcadero.com/wc/qcmain.aspx?d=80475
// 79959 81496
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=79105
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=78666
// !!! "SqlExpr.pas": http://qc.embarcadero.com/wc/qcmain.aspx?d=78188 //@D2011+
// BDCD: http://qc.embarcadero.com/wc/qcmain.aspx?d=78620
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=85143
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=79981
// ?http://qc.embarcadero.com/wc/qcmain.aspx?d=77698
// !http://qc.embarcadero.com/wc/qcmain.aspx?d=76005
// !?http://qc.embarcadero.com/wc/qcmain.aspx?d=73520
// http://qc.embarcadero.com/wc/qcmain.aspx?d=83954
// ... http://qc.embarcadero.com/wc/qcmain.aspx?search=1&proj=10&kw=TDataSetProvider&plat=430
// ... http://qc.embarcadero.com/wc/qcmain.aspx?se=1
//
// {todo.}
//

//
// QC # 27159 - ansistring: SetAsString, SetAsAnsiString
// buffer overflow in TStringField.SetAsString (TStringField.SetAsAnsiString)
{$UNDEF FIX_TSTRINGFIELD_SETASANSISTRING}
//
// QC # 69670
// Unable to create a lookup field that refers to an array field
{$UNDEF FIX_TFIELDS_FINDFIELD}
//
// QC # 69700
// TByteField is not registered by default
// Note: only for designtime
{$UNDEF FIX_REGISTERFIELDSPROC}
//
// QC # 70499
// Using wrongly sized TSmallIntField in stead of TIntegerField causes memory overwrite
{$UNDEF FIX_TINTEGERFIELD_GETISNULL}
//
// QC # 68658
// Invalid working with variants variables
{$UNDEF FIX_TBLOBFIELD_SETVARVALUE}
//
// QC # 73153
// TStringField.GetValue can return garbage data
{$UNDEF FIX_TSTRINGFIELD_GETVALUE}
//
// QC # 78620: fixed in studio 2010 build 14.0.3615.26342
// TBCDField.GetDataSize returns incorrect value
{$UNDEF FIX_TBCDFIELD_GETDATASIZE}
//
// QC # 86572
// TField.AssignValue() doesn't handle all possible types of TVarRec
{$UNDEF FIX_TFIELD_ASSIGNVALUE}
//
// QC # ?
// DataTypeMap for BCD
// zmars:
// https://sourceforge.net/projects/open-dbexpress/forums/forum/119358/topic/3490684
// TODO: it is necessary to elaborate official position
{$UNDEF FIX_SQLEXPR_DATATYPEMAP}
//
// QC # ?
// Buffer overflow in TDataSet.DataConvert with ftWideString
{$UNDEF FIX_TDATASET_DATACONVERT}
//
// QC # 74646
// Buffer overflow in TCustomClientDataSet.DataConvert with ftWideString
{$UNDEF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}
//
// QC # 22479
// When TWideStringField  Out  of  memory
{$UNDEF FIX_TWIDESTRINGFIELD_COPYDATA}
//
// QC # 3514, 11589
// TWideStringField.Value returns uninitialised buffer on null data
{$UNDEF FIX_TWIDESTRINGFIELD_GETASWIDESTRING}
//
// QC # 8837
// Memory leak in TWideStringField.GetAsVariant
{$UNDEF FIX_TWIDESTRINGFIELD_GETASVARIANT}
//
// QC # 8478
// TWideStringField.GetDataSize bug
{$UNDEF FIX_TWIDESTRINGFIELD_GETDATASIZE}

//**************************************
//     calculate the directives
//**************************************

{$IF CompilerVersion < 23.00}
  {$DEFINE CPUX86}
{$IFEND}

{$IFDEF CONDITIONALEXPRESSIONS} // Delphi 6 Up
  {$IF CompilerVersion < 23.00} // !!! NOT ANY FIXES FOR XE2 !!!
    {$IFDEF CPUX86}
      {.$IFNDEF POSIX}
        {$DEFINE COMPILER_SUPPORTED} { optional }
      {.$ENDIF}
    {$ENDIF}
  {$IFEND}
{$ENDIF CONDITIONALEXPRESSIONS}

{$IFDEF COMPILER_SUPPORTED}

{$IF CompilerVersion >= 18.50} // Delphi 2007 Up
  {$DEFINE FIX_SQLEXPR_DATATYPEMAP} { optional } //@D2011+
  {$IFDEF FIX_SQLEXPR_DATATYPEMAP}
    {$DEFINE USE_SQLEXPR}
  {$ENDIF}
{$IFEND}

// FIX_TSTRINGFIELD_SETASANSISTRING
{.$IF CompilerVersion < 2?.00} // Delphi ? Dwn
  {$DEFINE FIX_TSTRINGFIELD_SETASANSISTRING} { optional } //@D2011+
  {$IFDEF FIX_TSTRINGFIELD_SETASANSISTRING}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TStringFieldAccess}
  {$ENDIF}
{.$IFEND}

// FIX_TFIELDS_FINDFIELD
{$IF CompilerVersion <= 20.00} // Delphi 2009 Dwn
  {$DEFINE FIX_TFIELDS_FINDFIELD} { optional }
  {$IFDEF FIX_TFIELDS_FINDFIELD}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TFieldsAccess}
    {$DEFINE TFieldAccess}
  {$ENDIF}
{$IFEND}

// FIX_REGISTERFIELDSPROC
{$IF CompilerVersion = 20.00} // Delphi 2009
  {$DEFINE FIX_REGISTERFIELDSPROC} { optional }
{$IFEND}

// FIX_TINTEGERFIELD_GETISNULL
{$IF CompilerVersion <= 20.00} // Delphi 2009 Dwn
  {$DEFINE FIX_TINTEGERFIELD_GETISNULL} { optional }
  {$IFDEF FIX_TINTEGERFIELD_GETISNULL}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TFieldAccess}
    {$DEFINE TIntegerFieldAccess}
  {$ENDIF}
{$IFEND}

// FIX_TBLOBFIELD_SETVARVALUE
{$IF CompilerVersion <= 20.00} // Delphi 2009 Dwn
  {$DEFINE FIX_TBLOBFIELD_SETVARVALUE} { optional }
  {$IFDEF FIX_TBLOBFIELD_SETVARVALUE}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TBlobFieldAccess}
    {$DEFINE USE_VARIANTS}
  {$ENDIF}
{$IFEND}

// FIX_TSTRINGFIELD_GETVALUE
{.$IF CompilerVersion <= 20.00} // Delphi 2009 Dwn
  {$DEFINE FIX_TSTRINGFIELD_GETVALUE} { optional } //@D2011+
  {$IFDEF FIX_TSTRINGFIELD_GETVALUE}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TStringFieldAccess}
  {$ENDIF}
{.$IFEND}

// FIX_TFIELD_ASSIGNVALUE
{$IF CompilerVersion <= 21.00} // Delphi 2010 Dwn
  {$DEFINE FIX_TFIELD_ASSIGNVALUE} { optional }
  {$IFDEF FIX_TFIELD_ASSIGNVALUE}
    {$DEFINE USE_API_HOOK}
    {$DEFINE TFieldAccess}
  {$ENDIF}
{$IFEND}

// FIX_TDATASET_DATACONVERT
// FIX_TCUSTOMCLIENTDATASET_DATACONVERT
{$IF CompilerVersion >= 18.00} // Delphi 2006 Up
  {.$IF CompilerVersion <= 21.00} // Delphi 2010 Dwn
    {$DEFINE FIX_TDATASET_DATACONVERT} { optional } //@D2011+
  {.$IFEND}
  {.$IF CompilerVersion <= ?} // Delphi ? Dwn
  {$DEFINE FIX_TCUSTOMCLIENTDATASET_DATACONVERT} { optional } //@D2011+
  {.$IFEND}
  //
  {$IFDEF FIX_TDATASET_DATACONVERT}
      {$DEFINE USE_API_HOOK}
  {$ELSE}
    {$IFDEF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}
      {$DEFINE USE_API_HOOK}
    {$ENDIF}
  {$ENDIF}
  //
  {$IFDEF FIX_TDATASET_DATACONVERT}
    {$DEFINE TDataSetAccess}
  {$ENDIF}
  {$IFDEF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}
    {$DEFINE USE_DBCLIENT}
    {$DEFINE TCustomClientDataSetAccess}
    {$DEFINE use_WStrLCopyLen}
  {$ENDIF}
{$IFEND}

// FIX_TWIDESTRINGFIELD_COPYDATA
{$IF CompilerVersion >= 18.00} // Delphi 2006 Up
{$IF CompilerVersion < 20.00}  // Delphi 2009 Dwn
  {$DEFINE FIX_TWIDESTRINGFIELD_COPYDATA} { optional }
  //
  {$IFDEF FIX_TWIDESTRINGFIELD_COPYDATA}
      {$DEFINE USE_API_HOOK}
      {$DEFINE TWideStringFieldAccess}
  {$ENDIF}
{$IFEND}
{$IFEND}

// FIX_TWIDESTRINGFIELD_GETASWIDESTRING
{$IF CompilerVersion <= 17.00}  // Delphi 2005 Dwn
  {$DEFINE FIX_TWIDESTRINGFIELD_GETASWIDESTRING} { optional }
  //
  {$IFDEF FIX_TWIDESTRINGFIELD_GETASWIDESTRING}
      {$DEFINE USE_API_HOOK}
      {$DEFINE TWideStringFieldAccess}
  {$ENDIF}
{$IFEND}

// FIX_TWIDESTRINGFIELD_GETASVARIANT
{$IF CompilerVersion <= 17.00}  // Delphi 2005 Dwn
  {$DEFINE FIX_TWIDESTRINGFIELD_GETASVARIANT} { optional }
  //
  {$IFDEF FIX_TWIDESTRINGFIELD_GETASVARIANT}
      {$DEFINE USE_API_HOOK}
      {$DEFINE TWideStringFieldAccess}
  {$ENDIF}
{$IFEND}

// FIX_TWIDESTRINGFIELD_GETDATASIZE
{$IF CompilerVersion <= 17.00}  // Delphi 2005 Dwn
  {$DEFINE FIX_TWIDESTRINGFIELD_GETDATASIZE} { optional }
  //
  {$IFDEF FIX_TWIDESTRINGFIELD_GETDATASIZE}
      {$DEFINE USE_API_HOOK}
      {$DEFINE TWideStringFieldAccess}
  {$ENDIF}
{$IFEND}

{$ENDIF COMPILER_SUPPORTED}

{$IFDEF COMPILER_SUPPORTED}
uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ELSE}
  {$IFDEF _KYLIX_}
  Types, Libc,
  {$ELSE}
  {$IFDEF POSIX}
  //Posix.Unistd, Posix.String_,
  {$ENDIF}{$ENDIF}{$ENDIF}
  SysUtils, Classes,
  {$IFDEF USE_API_HOOK}
  DbxOpenOdbcApiHook,
  {$ENDIF}
  {$IFDEF USE_SQLEXPR}
  DSIntf, SqlExpr,
  {$ENDIF}
  {$IFDEF USE_DBCLIENT}
  DBClient,
  {$ENDIF}
  {$IFDEF USE_VARIANTS}
  Variants,
  {$ENDIF}
  {$IF CompilerVersion >= 17.00} // Delphi 2005 Up:
  WideStrUtils,
  {$IFEND}
  DB;
{$ENDIF COMPILER_SUPPORTED}

{$IFDEF COMPILER_SUPPORTED}

{$IFDEF use_WStrLCopyLen}
function WStrLCopyLen(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): Integer;
var
  Src : PWideChar;
begin
  Result := Integer(Dest);
  Src := Source;
  while (Src^ <> #$00) and (MaxLen > 0) do
  begin
    Dest^ := Src^;
    Inc(Src);
    Inc(Dest);
    Dec(MaxLen);
  end;
  Dest^ := #$00;
  Result := (Integer(Dest) - Result) div 2;
end;
{$ENDIF}

//{$IFDEF use_WStrLCopyLen}
//function AStrLCopyLen(Dest: PAnsiChar; const Source: PAnsiChar; MaxLen: Cardinal): Integer;
//var
//  Src : PAnsiChar;
//begin
//  Result := Integer(Dest);
//  Src := Source;
//  while (Src^ <> #0) and (MaxLen > 0) do
//  begin
//    Dest^ := Src^;
//    Inc(Src);
//    Inc(Dest);
//    Dec(MaxLen);
//  end;
//  Dest^ := #$00;
//  Result := (Integer(Dest) - Result);
//end;
//{$ENDIF}

{$IFDEF TFieldAccess}
type TFieldAccess = class(TField);
{$ENDIF}

{$IFDEF TFieldsAccess}
type TFieldsAccess = class(TFields);
{$ENDIF}

{$IFDEF TIntegerFieldAccess}
type TIntegerFieldAccess = class(TIntegerField);
{$ENDIF}

{$IFDEF TStringFieldAccess}
type TStringFieldAccess = class(TStringField);
{$ENDIF}

{$IFDEF TWideStringFieldAccess}
type TWideStringFieldAccess = class(TWideStringField);
{$ENDIF}

{$IFDEF TBlobFieldAccess}
type TBlobFieldAccess = class(TBlobField);
{$ENDIF}

{$IFDEF TDataSetAccess}
type TDataSetAccess = class(TDataSet);
{$ENDIF}

{$IFDEF TCustomClientDataSetAccess}
type TCustomClientDataSetAccess = class(TCustomClientDataSet);
{$ENDIF}

{$IFDEF FIX_TSTRINGFIELD_SETASANSISTRING} //@D2011+
var
  StringField_SetAsAnsiString: TJumpInstruction;
procedure FIX_TSTRINGFIELD_SETASANSISTRING(Self: TStringFieldAccess; const AValue: AnsiString);
var
  Len: Integer;
  PBuf: PAnsiChar;
  Temp: AnsiString;
  Buffer: array[0..dsMaxStringSize] of AnsiChar;
begin
  with Self do begin
  //
  if DataSize > SizeOf(Buffer) then
  begin
    //Len := StrLen(PAnsiChar(Value));
    Len := Length(AValue); // StrLCopy trimmed result when #0 will is discovered
    if Len > Size then
      Len := Size;
    SetLength(Temp, Len+1);
    PBuf := PAnsiChar(Temp);
  end else
  begin
    PBuf := Buffer;
    Len := Size;
  end;
  StrLCopy(PBuf, PAnsiChar(AValue), Len); // set PBuf[Len] to #0
  if Transliterate then
    DataSet.Translate(PBuf, PBuf, True);
  SetData(PBuf);
  //
  end;
end;
procedure INSTALL_FIX_TSTRINGFIELD_SETASANSISTRING(AInstall: Boolean);
var
  ASrc: Pointer;
begin
  {$IF CompilerVersion >= 20.050} // Delphi 2009 Up
  ASrc := GetNativeAddr(@TStringFieldAccess.SetAsAnsiString);
  {$ELSE}
  ASrc := GetNativeAddr(@TStringFieldAccess.SetAsString);
  {$IFEND}
  if AInstall then
    JumpFromCode(ASrc, @FIX_TSTRINGFIELD_SETASANSISTRING, @StringField_SetAsAnsiString)
  else
    RestoreSavedCode(ASrc, @StringField_SetAsAnsiString);
end;
{$ENDIF}

{$IFDEF FIX_TFIELDS_FINDFIELD}
type
  TFieldsAccess_Fields = class(TObject)
  private
    FList: TList;
  end;
var
  FieldAccess_FindField: TJumpInstruction;
function FIX_TFIELDS_FINDFIELD(Self: TFieldsAccess; const FieldName: string): TField;
var
  I, iFieldNameCmpLen: Integer;
  FList: TList;
begin
  FList := TFieldsAccess_Fields(Self).FList;
  with Self do begin
  //
  for I := 0 to FList.Count - 1 do
  begin
    Result := FList.Items[I];
    {$IF CompilerVersion >= 18.00} // Delphi 2006 Up
    if WideCompareText(Result.FieldName, FieldName) = 0 then Exit;
    {$ELSE}
    if AnsiCompareText(Result.FieldName, FieldName) = 0 then Exit;
    {$IFEND}
  end;
  // search in TObjectField
  I := FList.Count;
  if I > 0 then
  begin
    iFieldNameCmpLen := Length(FieldName);
    for I := 0 to I - 1 do
    begin
       Result := FList.Items[I];
      if (Result is TObjectField)
        //and (Pos(FieldName, Result.FieldName) = 1) then
        and (StrLIComp(PChar(string(FieldName)), PChar(string(Result.FieldName)), iFieldNameCmpLen) = 0) then
      begin
        Result := TObjectField(Result).Fields.FindField(FieldName);
        if Assigned(Result) then
           Exit;
      end;
    end;
  end;
  Result := nil;
  //
  end;
end;
procedure INSTALL_FIX_TFIELDS_FINDFIELD(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TFieldsAccess.FindField),
      @FIX_TFIELDS_FINDFIELD, @FieldAccess_FindField)
  else
    RestoreSavedCode( GetNativeAddr(@TFieldsAccess.FindField),
      @FieldAccess_FindField);
end;
{$ENDIF}

{$IFDEF FIX_TINTEGERFIELD_GETISNULL}
var
  IntegerField_GetIsNull: TJumpInstruction;
function FIX_TINTEGERFIELD_GETISNULL(Self: TFieldAccess): Boolean;
var
  L: Longint;
begin
  with Self do begin
  //
  //if TField(Self) is TIntegerField then
  if TField(Self).ClassType = TIntegerField then
  begin
    L := -1;
    Result := not TIntegerFieldAccess(Self).GetValue(L);
  end
  else
    Result := not GetData(nil);
  //
  end;
end;
procedure INSTALL_FIX_TINTEGERFIELD_GETISNULL(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TFieldAccess.GetIsNull),
      @FIX_TINTEGERFIELD_GETISNULL, @IntegerField_GetIsNull)
  else
    RestoreSavedCode( GetNativeAddr(@TFieldAccess.GetIsNull),
      @IntegerField_GetIsNull);
end;
{$ENDIF}

{$IFDEF FIX_TBLOBFIELD_SETVARVALUE}
var
  BlobField_SetVarValue: TJumpInstruction;
procedure FIX_TBLOBFIELD_SETVARVALUE(Self: TBlobFieldAccess; const AValue: Variant);
var
  Len: Integer;
  PBuf: Pointer;

  {$IF CompilerVersion <= 18.50}
  procedure TBlobField_SetData(Buffer: Pointer; Len: Integer);
  begin
    with Self do
    with DataSet.CreateBlobStream(Self, bmWrite) do
      try
        WriteBuffer(Buffer^, Len);
      finally
        Free;
      end;
  end;
  {$IFEND}

begin
  with Self do begin
  //
  if VarIsClear(AValue) or VarIsNull(AValue) then
    Clear
  else if VarIsArray(AValue) then
  begin
    PBuf := VarArrayLock(AValue);
    try
      Len := VarArrayHighBound(AValue, 1) + 1;
      {$IF CompilerVersion > 18.50}
      SetData(PBuf, Len);
      {$ELSE}
      TBlobField_SetData(PBuf, Len);
      {$IFEND}
    finally
      VarArrayUnlock(AValue);
    end;
  end
  else
  begin
    case VarType(AValue) of
      varString:
      {$IF CompilerVersion >= 20.00}
      SetAsAnsiString(AnsiString(AValue));
      {$ELSE}
      SetAsString(AnsiString(AValue));
      {$IFEND}
      {$IF CompilerVersion >= 20.00}
      varUString: SetAsString(string(AValue));
      {$IFEND}
      varOleStr:
      {$IF CompilerVersion >= 20.00}
        SetAsWideString(UnicodeString(AValue));
      {$ELSE}
        {$IF CompilerVersion > 17.00}
        SetAsWideString(AValue);
        {$ELSE}
        SetAsString(AnsiString(WideString(AValue)));
        {$IFEND}
      {$IFEND}
    else
      // All other variant types are converted to string before storing.
      SetAsString(VarToStr(AValue));
    end;
  end;
  //
  end;
end;
procedure INSTALL_FIX_TBLOBFIELD_SETVARVALUE(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TBlobFieldAccess.SetVarValue),
      @FIX_TBLOBFIELD_SETVARVALUE, @BlobField_SetVarValue)
  else
    RestoreSavedCode( GetNativeAddr(@TBlobFieldAccess.SetVarValue),
      @BlobField_SetVarValue);
end;
{$ENDIF}

{$IFDEF FIX_TSTRINGFIELD_GETVALUE} //@D2011+
var
  StringField_GetValue: TJumpInstruction;
function FIX_TSTRINGFIELD_GETVALUE(Self: TStringField; var AValue: AnsiString): Boolean;
var
  Len: Integer;
  Temp: AnsiString;
  PBuf: PAnsiChar;
  Buffer: array[0..dsMaxStringSize] of AnsiChar;
begin
  with Self do begin
  //
  Len := DataSize;
  if Len > SizeOf(Buffer) then
  begin
    SetLength(Temp, Len+1); // note: +1 is not required
    PBuf := PAnsiChar(Temp);
    Result := GetData(PBuf);
    if Result then
    begin
      PBuf[Size] := #0; // when GetData not returned trimmed data
      Len := StrLen(PBuf);
      SetLength(Temp, Len);
      PBuf := PAnsiChar(Temp);
    end;
  end
  else
  begin
    PBuf := @Buffer;
    Result := GetData(PBuf);
    //
    if Result then
      PBuf[Size] := #0; // when GetData not returned trimmed data
  end;
  if Result then
  begin
    if Transliterate and (PBuf <> nil) and (PBuf^ <> #0) then
      DataSet.Translate(PBuf, PBuf, False);
    AValue := PBuf;
  end;
  //
  end;
end;
procedure INSTALL_FIX_TSTRINGFIELD_GETVALUE(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TStringFieldAccess.GetValue),
      @FIX_TSTRINGFIELD_GETVALUE, @StringField_GetValue)
  else
    RestoreSavedCode( GetNativeAddr(@TStringFieldAccess.GetValue),
      @StringField_GetValue);
end;
{$ENDIF}

{$IFDEF FIX_TFIELD_ASSIGNVALUE}
type
  TField_AssignValue = procedure (Self: TField; const Value: TVarRec);
var
  Field_AssignValue: TField_AssignValue;
procedure FIX_TFIELD_ASSIGNVALUE(Self: TField; const AValue: TVarRec);
begin
  with AValue do
  begin
    case VType of
      vtPWideChar:
        Self.AsString := string(WideString(VPWideChar));
      {$IF CompilerVersion >= 18.00} // Delphi 2006 Up
      vtWideString:
        Self.AsWideString := WideString(VWideString);
      {$IFEND}
      //{$IF CompilerVersion >= 20.00}
      //vtUnicodeString:
      //  {$IFDEF UNICODE}
      //  Self.AsWideString := WideString(string(VUnicodeString));
      //  {$ELSE}
      //  Self.AsWideString := WideString(VUnicodeString);
      //  {$ENDIF}
      //{$IFEND CompilerVersion >= 20.00}
      else
        Field_AssignValue(Self, AValue);
    end;
  end;
end;
procedure INSTALL_FIX_TFIELD_ASSIGNVALUE(AInstall: Boolean);
begin
  if AInstall then
    HookCode(GetNativeAddr(@TFieldAccess.AssignValue), @FIX_TFIELD_ASSIGNVALUE, @Field_AssignValue)
  else
    UnhookCode(@Field_AssignValue);
end;
{$ENDIF}

{$IFDEF FIX_TWIDESTRINGFIELD_GETDATASIZE}
var
  WideStringField_GetDataSize: TJumpInstruction;
function FIX_TWIDESTRINGFIELD_GETDATASIZE(Self: TWideStringFieldAccess): Integer;
begin
  Result := (Self.Size + 1) * 2;
end;
procedure INSTALL_FIX_TWIDESTRINGFIELD_GETDATASIZE(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TWideStringFieldAccess.GetDataSize),
      @FIX_TWIDESTRINGFIELD_GETDATASIZE, @WideStringField_GetDataSize)
  else
    RestoreSavedCode( GetNativeAddr(@TWideStringFieldAccess.GetDataSize),
      @WideStringField_GetDataSize);
end;
{$ENDIF}

{$IFDEF FIX_TWIDESTRINGFIELD_GETASWIDESTRING}
var
  WideStringField_GetAsWideString: TJumpInstruction;
function FIX_TWIDESTRINGFIELD_GETASWIDESTRING(Self: TWideStringFieldAccess): WideString;
begin
  if not Self.GetData(@Result, False) then Result := '';
end;
procedure INSTALL_FIX_TWIDESTRINGFIELD_GETASWIDESTRING(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TWideStringFieldAccess.GetAsWideString),
      @FIX_TWIDESTRINGFIELD_GETASWIDESTRING, @WideStringField_GetAsWideString)
  else
    RestoreSavedCode( GetNativeAddr(@TWideStringFieldAccess.GetAsWideString),
      @WideStringField_GetAsWideString);
end;
{$ENDIF}

{$IFDEF FIX_TWIDESTRINGFIELD_GETASVARIANT} //@todo: not tested
var
  WideStringField_GetAsVariant: TJumpInstruction;
function FIX_TWIDESTRINGFIELD_GETASVARIANT(Self: TWideStringFieldAccess): Variant;
var
  S: WideString;
begin
  if Self.GetData(@S, False) then Result := S else Result := Null;
end;
procedure INSTALL_FIX_TWIDESTRINGFIELD_GETASVARIANT(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TWideStringFieldAccess.GetAsVariant),
      @FIX_TWIDESTRINGFIELD_GETASVARIANT, @WideStringField_GetAsVariant)
  else
    RestoreSavedCode( GetNativeAddr(@TWideStringFieldAccess.GetAsVariant),
      @WideStringField_GetAsVariant);
end;
{$ENDIF}

{$IFDEF FIX_TWIDESTRINGFIELD_COPYDATA} // D2006..D2009
var
  WideStringField_CopyData: TJumpInstruction;
procedure FIX_TWIDESTRINGFIELD_COPYDATA(Self: TWideStringField; Source, Dest: Pointer);
begin
  WStrCopy(PWideChar(Dest), PWideChar(Source));
end;
procedure INSTALL_FIX_TWIDESTRINGFIELD_COPYDATA(AInstall: Boolean);
begin
  if AInstall then
    JumpFromCode( GetNativeAddr(@TWideStringFieldAccess.CopyData),
      @FIX_TWIDESTRINGFIELD_COPYDATA, @WideStringField_CopyData)
  else
    RestoreSavedCode( GetNativeAddr(@TWideStringFieldAccess.CopyData),
      @WideStringField_CopyData);
end;
{$ENDIF}

{$IFDEF FIX_TDATASET_DATACONVERT}
type
  TDataSet_DataConvert = procedure (Self: TDataSet; Field: TField; Source, Dest: Pointer; ToNative: Boolean);
var
  DataSet_DataConvert: TDataSet_DataConvert;
procedure FIX_TDATASET_DATACONVERT(Self: TDataSet; Field: TField; Source, Dest: Pointer; ToNative: Boolean);
begin
  if Field.DataType in [ftWideString, ftFixedWideChar] then
  begin
      {+}
      //
      // OLD:
      //
      {
      WStrCopy(PWideChar(Dest), PWideChar(Source)); // ERROR - buffer is not contain #0 for last position
      {}
      //
      // NEW:
      //
      WStrLCopy(PWideChar(Dest), PWideChar(Source), Field.Size); //?: +1 in D2011; //D2011+
      {+.}
  end
  else
    DataSet_DataConvert(Self, Field, Source, Dest, ToNative);
end;

procedure INSTALL_FIX_TDATASET_DATACONVERT(AInstall: Boolean);
begin
  if AInstall then
    HookCode(GetNativeAddr(@TDataSetAccess.DataConvert), @FIX_TDATASET_DATACONVERT, @DataSet_DataConvert)
  else
    UnhookCode(@DataSet_DataConvert)
end;
{$ENDIF FIX_TDATASET_DATACONVERT}


{$IFDEF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}
type
  TCustomClientDataSet_DataConvert = procedure(Self: TDataSet; Field: TField; Source, Dest: Pointer; ToNative: Boolean);
var
  CustomClientDataSet_DataConvert: TCustomClientDataSet_DataConvert;
procedure FIX_TCUSTOMCLIENTDATASET_DATACONVERT(Self: TDataSet; Field: TField; Source, Dest: Pointer; ToNative: Boolean);
var
  {ByteLen,} StrLen: Integer;
begin
  if Field.DataType = ftWideString then
  begin
    if ToNative then
    begin
      {+}
      //
      // OLD: ERROR - buffer is not contain #0 for last position
      //
      {
      Word(Dest^) := WStrLen(PWideChar(Source))*2;
      Move(PWideChar(Source)^, (PWideChar(Dest)+1)^, Word(Dest^));
      {}
      //
      // NEW:
      //
      StrLen := WStrLCopyLen(PWideChar(PWideChar(Dest)+1), PWideChar(Source), Field.Size);
      Word(Dest^) := Word(StrLen * 2);
      {+.}
    end else
    begin
      {+}
      //
      // OLD: ERROR - buffer is not contain #0 for last position
      //
      {
      Len := Word(Source^);
      Move((PWideChar(Source)+1)^, PWideChar(Dest)^, Len);
      (PWideChar(Dest)+ (Len div 2))^ := #$00;
      {}
      //
      // NEW:
      //
      StrLen := Word(Source^) div 2;
      if StrLen > Field.Size then
        StrLen := Field.Size;
      {+.}
      StrLen := WStrLCopyLen(PWideChar(Dest), PWideChar(PWideChar(Source)+1), StrLen);
      (PWideChar(Dest)+ StrLen)^ := #$00;
      {+.}
    end;
  end else
    CustomClientDataSet_DataConvert(Self, Field, Source, Dest, ToNative);
end;

procedure INSTALL_FIX_TCUSTOMCLIENTDATASET_DATACONVERT(AInstall: Boolean);
begin
  if AInstall then
    HookCode(GetNativeAddr(@TCustomClientDataSetAccess.DataConvert), @FIX_TCUSTOMCLIENTDATASET_DATACONVERT, @CustomClientDataSet_DataConvert)
  else
    UnhookCode(@CustomClientDataSet_DataConvert);
end;
{$ENDIF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}

{$ENDIF COMPILER_SUPPORTED}

{$IFDEF COMPILER_SUPPORTED}

procedure INSTALL_FIXES(AInstall: Boolean);
begin
  {$IFDEF FIX_SQLEXPR_DATATYPEMAP} //@D2011+
  if AInstall then
  begin
    {.$WRITEABLECONST ON}
    TFieldType(Pointer(@DataTypeMap[{08}fldBCD])^) := ftBCD;
    TFieldType(Pointer(@DataTypeMap[{25}fldFMTBCD])^) := ftFMTBCD;
  end;
  {$ENDIF}

  {$IFDEF FIX_REGISTERFIELDSPROC}
  if Assigned(DB.RegisterFieldsProc) then
  begin
    RegisterFields([TLongWordField, TShortintField, TByteField, TExtendedField]);
  end;
  {$ENDIF}

  {$IFDEF FIX_TSTRINGFIELD_SETASANSISTRING}
  INSTALL_FIX_TSTRINGFIELD_SETASANSISTRING(AInstall);
  {$ENDIF}
  {$IFDEF FIX_TFIELDS_FINDFIELD}
  INSTALL_FIX_TFIELDS_FINDFIELD(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TINTEGERFIELD_GETISNULL}
  INSTALL_FIX_TINTEGERFIELD_GETISNULL(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TBLOBFIELD_SETVARVALUE}
  INSTALL_FIX_TBLOBFIELD_SETVARVALUE(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TSTRINGFIELD_GETVALUE}
  INSTALL_FIX_TSTRINGFIELD_GETVALUE(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TFIELD_ASSIGNVALUE}
  INSTALL_FIX_TFIELD_ASSIGNVALUE(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TWIDESTRINGFIELD_GETDATASIZE}
  INSTALL_FIX_TWIDESTRINGFIELD_GETDATASIZE(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TWIDESTRINGFIELD_GETASWIDESTRING}
  INSTALL_FIX_TWIDESTRINGFIELD_GETASWIDESTRING(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TWIDESTRINGFIELD_GETASVARIANT}
  INSTALL_FIX_TWIDESTRINGFIELD_GETASVARIANT(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TWIDESTRINGFIELD_COPYDATA}
  INSTALL_FIX_TWIDESTRINGFIELD_COPYDATA(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TDATASET_DATACONVERT}
  INSTALL_FIX_TDATASET_DATACONVERT(AInstall);
  {$ENDIF}

  {$IFDEF FIX_TCUSTOMCLIENTDATASET_DATACONVERT}
  INSTALL_FIX_TCUSTOMCLIENTDATASET_DATACONVERT(AInstall);
  {$ENDIF}
  //*)
end;

initialization
  INSTALL_FIXES(True);
finalization
  INSTALL_FIXES(False);
{$ENDIF COMPILER_SUPPORTED}
end.
