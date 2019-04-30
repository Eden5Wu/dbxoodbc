// (c) "Vadim V.Lopushansky"<pult@ukr.net>, Kiev 2007-2011 Year.

program stm_replacer.dpr;

{$APPTYPE CONSOLE}
{$B-}
//{$O-,D+}
{$O+,D-}

{-------------------------------------------------------------------------------------------------}

{$IFNDEF CONDITIONALEXPRESSIONS} // ifndef delphi_6_up:
{ Relocation info stripped from file. }
const
  IMAGE_FILE_RELOCS_STRIPPED = $0001;
{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
{$ENDIF}

{-------------------------------------------------------------------------------------------------
debug:
  run params:
    -nc "-i=Zune.Theme" "-o=Zune-fixed.Theme" "-t=%WinDir%SYSTEM32" "-v=%SystemRoot%\SYS
    -nc -i=Zune.Theme -o=Zune-fixed.Theme -p=theme_fix.par

  example "theme_fix.par":
--------------------------------------------------------------------
####################################################################
#
# Far manager template: ^G:
#  stm_replacer.exe -nc "-i=!.!" "-o=!.!" -p=theme_fix_templ.par
#
####################################################################
"-t=%WinDir%SYSTEM32" "-v=%SystemRoot%\SYSTEM32"
"-t=%WinDir%Resources" "-v=%SystemRoot%\Resources"
"-t=%WinDir%" "-v=%SystemRoot%"
"-t=C:\WINDOWS" "-v=%SystemRoot%"
"-t=C:\WINNT" "-v=%SystemRoot%"
#
# expand env "%WinDir%" to string "%SystemRoot%"
#
"-t=%SystemRoot%" "-v=%SystemRoot%" -env
--------------------------------------------------------------------
{-------------------------------------------------------------------------------------------------}

uses
  SysUtils, Windows, Classes;

{-------------------------------------------------------------------------------------------------}

const
  {**********************}
  cVersion = '2010.07.31';
  {**********************}
  cCmdLineSwitchChars = ['/', '-'];

{-------------------------------------------------------------------------------------------------}

var
  bIsError: Boolean = False;
  sFInput, sFOutput: string;
  sTemplateVarName: string = #0;
  sTemplateValue: string = #0;

{-------------------------------------------------------------------------------------------------}

function AnsiToOEM(const S: string): string; inline;
begin
  SetLength(Result, Length(S));
  if Length(S) > 0 then
  begin
    CharToOem(PChar(S), PChar(Result));
  end;
end;

{-------------------------------------------------------------------------------------------------}
procedure Logged_params();
var
  i: Integer;
  S, si: string;
begin
  S := '';
  for i := 1 to ParamCount do
  begin
    si := ParamStr(i);
    if Pos(' ', si) > 0 then
      si := '"' + si + '"';
    S := S + AnsiToOEM(si) + ' ';
  end;
  WriteLn('command line params: ', S);
end;
{-------------------------------------------------------------------------------------------------}

procedure Help(Phase, ExitCode: Integer; const sPhase: string = '');
  //--
  procedure DoHelp();
  begin
    WriteLn('');
    WriteLn('');
    WriteLn('stm_replacer.exe, version: ', cVersion);
    WriteLn('');
    WriteLn('----------------------------');
    WriteLn('Help: for stm_replacer.exe  :');
    WriteLn('----------------------------');
    WriteLn('');
    WriteLn('Usage as:');
    WriteLn('');
    WriteLn('  >stm_replacer.exe -i=input_file [-o=output_file] [-p=templates_file] -t=template_variable -v=template_value [-help] [-nc(no case)] [-lp(log par)]');
    WriteLn('');
    WriteLn('  -p supports parameters');
    WriteLn('       -t -v -nc');
    WriteLn('       -env (prepare envinronments)');
    WriteLn('       -env-val (prepare value envinronments)');
    WriteLn('');
    WriteLn('');
  end;
  //--
begin
  case Phase of
    0:
      begin
        DoHelp();
        Halt(ExitCode);
      end;
    1:
      begin
        WriteLn('');
        WriteLn('');
        WriteLn('----------------------------');
        WriteLn('Error: bad parameters.');
        WriteLn('----------------------------');
        DoHelp();
        Halt(ExitCode);
      end;
    2:
      begin
        WriteLn('');
        WriteLn('');
        WriteLn('----------------------------');
        WriteLn('Error: cannot read template from file: "', AnsiToOEM(sPhase), '".' );
        WriteLn('----------------------------');
        Halt(ExitCode);
      end;
    3:
      begin
        WriteLn('');
        WriteLn('');
        WriteLn('----------------------------');
        WriteLn('Error: cannot write result to file: "', AnsiToOEM(sPhase), '".' );
        WriteLn('----------------------------');
        Halt(ExitCode);
      end;
     else
       Halt(100);
  end; // of: case
end;

{-------------------------------------------------------------------------------------------------}

function FxtFindCmdLineSwitch(const Switch: string; IgnoreCase: Boolean = True;
  const Chars: TSysCharSet = cCmdLineSwitchChars): Boolean;
{
 examples:
   /SwitchName
   -SwitchName
   SwitchName
}
var
  i, iStartPos: Integer;
  S: string;
  bIsEmptyChars: Boolean;
begin
  if (ParamCount > 0) and (Switch <> '') then
  begin
    bIsEmptyChars := Chars = [];
    {+}// fix borland bug
    if not bIsEmptyChars then
      iStartPos := 2
    else
      iStartPos := 1;
    {+.}
    for i := 1 to ParamCount do
    begin
      S := ParamStr(i);
      if bIsEmptyChars or (S[1] in Chars) then
        if IgnoreCase then
        begin
          if (AnsiCompareText(Copy(S, iStartPos, Maxint), Switch) = 0) then
          begin
            Result := True;
            Exit;
          end;
        end
        else
        begin
          if (AnsiCompareStr(Copy(S, iStartPos, Maxint), Switch) = 0) then
          begin
            Result := True;
            Exit;
          end;
        end;
    end;
  end;
  Result := False;
end;

function FxtFindListLineSwitch(List: TStrings; const Switch: string; IgnoreCase: Boolean = True;
  const Chars: TSysCharSet = cCmdLineSwitchChars): Boolean;
var
  i, iStartPos: Integer;
  S: string;
  bIsEmptyChars: Boolean;
begin
  if (List <> nil) and (List.Count > 0) and (Switch <> '') then
  begin
    bIsEmptyChars := Chars = [];
    {+}// fix borland bug
    if not bIsEmptyChars then
      iStartPos := 2
    else
      iStartPos := 1;
    {+.}
    for i := 0 to List.Count - 1 do
    begin
      S := List[i];
      if bIsEmptyChars or (S[1] in Chars) then
        if IgnoreCase then
        begin
          if (AnsiCompareText(Copy(S, iStartPos, Maxint), Switch) = 0) then
          begin
            Result := True;
            Exit;
          end;
        end
        else
        begin
          if (AnsiCompareStr(Copy(S, iStartPos, Maxint), Switch) = 0) then
          begin
            Result := True;
            Exit;
          end;
        end;
    end;
  end;
  Result := False;
end;

{-------------------------------------------------------------------------------------------------}

function FxtFindCmdLineSwitchValue(const Switch: string; out SwitchValue: string;
  AllowEmptyValue: Boolean = False; IgnoreCase: Boolean = True; const Chars: TSysCharSet = cCmdLineSwitchChars): Boolean;
{
 examples:
   /SwitchName=Value
   -SwitchName=Value
   SwitchName=Value
}
var
  i, iPos, iStartPos: Integer;
  S: string;
  vSwitchName: string;
  bIsEmptyChars: Boolean;
begin
  if (ParamCount > 0) and (Switch <> '') then
  begin
    bIsEmptyChars := Chars = [];
    if not bIsEmptyChars then
      iStartPos := 3
    else
      iStartPos := 2;
    if IgnoreCase then
      vSwitchName := AnsiLowerCase(Switch)
    else
      vSwitchName := Switch;
    for i := 1 to ParamCount do
    begin
      S := ParamStr(i);
      if (Length(S) >= iStartPos) and (bIsEmptyChars or (S[1] in Chars)) then
      begin
        if IgnoreCase then
          S := AnsiLowerCase(S);
        if Chars = [] then
          S := Copy(S, 1, Length(S));
        iPos := Pos('=', S);
        if iPos >= iStartPos then
        begin
          if Trim(Copy(S, iStartPos - 1, iPos - iStartPos + 1)) = vSwitchName then
          begin
            SwitchValue := Copy(ParamStr(i), iPos + 1, Length(S) - iPos);
            if AllowEmptyValue then
              Result := True
            else
              Result := SwitchValue <> '';
            Exit;
          end;
        end;
      end;
    end;
  end;
  SwitchValue := #0;
  Result := False;
end;

function FxtFindListLineSwitchValue(List: TStrings; const Switch: string; out SwitchValue: string;
  AllowEmptyValue: Boolean = False; IgnoreCase: Boolean = True; const Chars: TSysCharSet = cCmdLineSwitchChars): Boolean;
{
 examples:
   /SwitchName=Value
   -SwitchName=Value
   SwitchName=Value
}
var
  i, iPos, iStartPos: Integer;
  S: string;
  vSwitchName: string;
  bIsEmptyChars: Boolean;
begin
  if (List <> nil) and (List.Count > 0) and (Switch <> '') then
  begin
    bIsEmptyChars := Chars = [];
    if not bIsEmptyChars then
      iStartPos := 3
    else
      iStartPos := 2;
    if IgnoreCase then
      vSwitchName := AnsiLowerCase(Switch)
    else
      vSwitchName := Switch;
    for i := 0 to List.Count - 1 do
    begin
      S := List[i];
      if (Length(S) >= iStartPos) and (bIsEmptyChars or (S[1] in Chars)) then
      begin
        if IgnoreCase then
          S := AnsiLowerCase(S);
        if Chars = [] then
          S := Copy(S, 1, Length(S));
        iPos := Pos('=', S);
        if iPos >= iStartPos then
        begin
          if Trim(Copy(S, iStartPos - 1, iPos - iStartPos + 1)) = vSwitchName then
          begin
            SwitchValue := Copy(List.Strings[i], iPos + 1, Length(S) - iPos);
            if AllowEmptyValue then
              Result := True
            else
              Result := SwitchValue <> '';
            Exit;
          end;
        end;
      end;
    end;
  end;
  SwitchValue := #0;
  Result := False;
end;

{-------------------------------------------------------------------------------------------------}

function FxtGetCmdLineSwitchValue(const Switch: string;
  AllowEmptyValue: Boolean = False; IgnoreCase: Boolean = True;
  const Chars: TSysCharSet = cCmdLineSwitchChars): string; inline;
begin
  FxtFindCmdLineSwitchValue(Switch, Result, AllowEmptyValue, IgnoreCase, Chars);
end;

function FxtGetListLineSwitchValue(List: TStrings; const Switch: string;
  AllowEmptyValue: Boolean = False; IgnoreCase: Boolean = True;
  const Chars: TSysCharSet = cCmdLineSwitchChars): string; inline;
begin
  FxtFindListLineSwitchValue(List, Switch, Result, AllowEmptyValue, IgnoreCase, Chars);
end;

{-------------------------------------------------------------------------------------------------}

function SaveStringToFile(const StringData, FileName: string): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if (FileName = '') then
    Exit;

  if FileExists(FileName) then
  begin
    SetFileAttributes(PAnsiChar(FileName), FILE_ATTRIBUTE_NORMAL);
    SysUtils.DeleteFile(FileName);
  end;

  fs := nil;
  try
    try
      fs := TFileStream.Create(FileName, fmCreate);
      if StringData <> '' then
        fs.Write(StringData[1], Length(StringData));
      Result := True;
    finally
      fs.Free;
    end;
  except
  end;
end;

{-------------------------------------------------------------------------------------------------}

function LoadStringFromFile(const FileName: string; var S: string): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if (FileName = '') then
    Exit;
  fs := nil;
  try
    try
      fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
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

{-------------------------------------------------------------------------------------------------}

{ JEDI: }

type
  PMultiSz = PChar;

procedure MultiSzToStrings(const Dest: TStrings; const Source: PMultiSz);
var
  P: PMultiSz;
begin
  Assert(Dest <> nil);
  Dest.BeginUpdate;
  try
    Dest.Clear;
    if Source <> nil then
    begin
      P := Source;
      while P^ <> #0 do
      begin
        Dest.Add(P);
        P := StrEnd(P);
        Inc(P);
      end;
    end;
  finally
    Dest.EndUpdate;
  end;
end;

procedure StrResetLength(var S: string); inline;
begin
  SetLength(S, StrLen(PChar(S)));
end;

function ExpandEnvironmentVar(var Value: string): Boolean;
var
  R: Integer;
  Expanded: string;
begin
  SetLength(Expanded, 1);
  R := ExpandEnvironmentStrings(PChar(Value), PChar(Expanded), 0);
  SetLength(Expanded, R);
  Result := ExpandEnvironmentStrings(PChar(Value), PChar(Expanded), R) <> 0;
  if Result then
  begin
    StrResetLength(Expanded);
    Value := Expanded;
  end;
end;

function GetEnvironmentVars(const Vars: TStrings; Expand: Boolean): Boolean; overload;
var
  Raw: PChar;
  Expanded: string;
  I: Integer;
begin
  Vars.BeginUpdate;
  try
    Vars.Clear;
    Raw := GetEnvironmentStrings;
    try
      MultiSzToStrings(Vars, Raw);
      Result := True;
    finally
      FreeEnvironmentStrings(Raw);
    end;
    if Expand then
    begin
      for I := 0 to Vars.Count - 1 do
      begin
        Expanded := Vars[I];
        if ExpandEnvironmentVar(Expanded) then
          Vars[I] := Expanded;
      end;
    end;
  finally
    Vars.EndUpdate;
  end;
end;

function GetEnvironmentVars(const Vars: TStrings): Boolean; overload;
begin
  Result := GetEnvironmentVars(Vars, True);
end;

{ JEDI. }

{-------------------------------------------------------------------------------------------------}

function DoStringReplace(var S: string; const OldPattern, NewPattern: string;
  Flags: TReplaceFlags): Integer;
var
  sResult, SearchStr, Patt, NewStr: string;
  Offset, iCount: Integer;
begin
  iCount := 0;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  sResult := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      sResult := sResult + NewStr;
      Break;
    end;
    sResult := sResult + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    inc(iCount);
    if not (rfReplaceAll in Flags) then
    begin
      sResult := sResult + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
  if iCount > 0 then
    S := sResult;
  Result := iCount;
end;

function SingleLineToParams(S: string): string; overload;
var
  {iL,} iR: Integer;
  //sP, sL: string;
  C, ChLast: Char;
  IsQuotation: Boolean;
begin
  Result := '';
  IsQuotation := False;
  //iL := 1;
  S := Trim(S) + ' ';
  ChLast := 'A';

  for iR := 1 to Length(S) do
  begin
    C := S[iR];
    case Byte(C) of
      0..32: { delimiter }
        begin
          if IsQuotation then
          begin
            {  }
          end
          else
          begin
            if ChLast = #13 then
              Continue;
            C := #13;
            //ChLast := #13;
          end;
        end;
      Byte('"'): { quotation }
        begin
          if IsQuotation then
          begin
            IsQuotation := False;
            C := #13;
          end
          else
          begin
            IsQuotation := True;
            Continue;
          end;
        end;
    end;

    Result := Result + C;
    if not IsQuotation then
      ChLast := C;
  end;
end;

procedure SingleLineToParams(S: string; L: TStrings); overload;
var
  i: Integer;
begin
  L.BeginUpdate;

  L.Clear;
  L.Text := SingleLineToParams(S);
  // compact
  for i:= L.Count - 1 downto 0 do
  begin
    S := Trim(L.Strings[i]);
    if S = '' then
      L.Delete(i);
  end;

  L.EndUpdate;
end;

var
  sParamsFile, sParamLines: string;

procedure DoMain();
var
  sBody, {sParams,} S, V: string;
  Flags: TReplaceFlags;
  iCount, iEnv, iLine: Integer;
  L, P, E{, T}: TStringList;
  bIgnoreCase: Boolean;
  //pEnv: PAnsiChar;
begin
  iCount := 0;
  //
  // load template
  //
  //if sFInput <> #0 then
  if not LoadStringFromFile(sFInput, sBody) then
    Help(2, 1, sFInput);
  //
  // prepare parameters
  //
  Flags := [rfReplaceAll];
  // ignore case
  bIgnoreCase := FxtFindCmdLineSwitch('nc');
  if bIgnoreCase then
    Include(Flags, rfIgnoreCase);
  if FxtFindCmdLineSwitch('lp') then
    Logged_params();
  //
  // handle template
  //
  //if sFInput <> #0 then
  if (sTemplateVarName <> #0) and (sTemplateValue <> #0) then
    Inc(iCount, DoStringReplace(sBody, sTemplateVarName, sTemplateValue, Flags));

  if sParamLines <> '' then
  begin
    E := TStringList.Create;
    //T := TStringList.Create;
    L := TStringList.Create;
    P := TStringList.Create;

    //pEnv := GetEnvironmentStringsA();
    //S := Trim(StrPas(pEnv));
    //FreeEnvironmentStrings(pEnv);
    //E.Text := S;
    GetEnvironmentVars(E);

    sParamLines := Trim(sParamLines);
    L.Text := sParamLines;
    //SingleLineToParams(sParamLines, L);

    for iLine := 0 to L.Count - 1 do
    begin
      S := Trim(L[iLine]);
      if (S = '') or (S[1] = '#') then
        Continue;
      //P.Text := S;
      SingleLineToParams(S, P);

      if not ( FxtFindListLineSwitchValue(P, 't', sTemplateVarName) and
        FxtFindListLineSwitchValue(P, 'v', sTemplateValue, {AllowEmptyValue:}True)
      ) then
        Continue;

      Flags := [rfReplaceAll];
      // ignore case
      if bIgnoreCase or FxtFindListLineSwitch(P, 'nc') then
        Include(Flags, rfIgnoreCase);

      if FxtFindListLineSwitch(P, 'env') then
      begin
        if (Length(sTemplateVarName) > 2) and (sTemplateVarName[1] = '%' )
          and (sTemplateVarName[Length(sTemplateVarName)] = '%')
        then
          sTemplateVarName := Copy(sTemplateVarName, 2, Length(sTemplateVarName) - 2);
        if sTemplateVarName = '' then
          Continue;
        V := #0;
        for iEnv := 0 to E.Count - 1 do
        begin
          S := E.Names[iEnv];
          if SameText(S, sTemplateVarName) then
          begin
            V := E.ValueFromIndex[iEnv];
            Break;
          end;
        end;
        if V = #0 then
          Continue; // skip rule (env ot found)
        sTemplateVarName := V;
      end;

      if FxtFindListLineSwitch(P, 'env-val') then
      begin
        if (Length(sTemplateValue) > 2) and (sTemplateValue[1] = '%' )
          and (sTemplateValue[Length(sTemplateValue)] = '%')
        then
          sTemplateValue := Copy(sTemplateValue, 2, Length(sTemplateValue) - 2);
        if sTemplateValue = '' then
          Continue;
        V := #0;
        for iEnv := 0 to E.Count - 1 do
        begin
          S := E.Names[iEnv];
          if SameText(S, sTemplateValue) then
          begin
            V := E.ValueFromIndex[iEnv];
            Break;
          end;
        end;
        if V <> #0 then
          sTemplateValue := V
        else
          sTemplateValue := '';
      end;

      Inc(iCount, DoStringReplace(sBody, sTemplateVarName, sTemplateValue, Flags));
    end;

    E.Free;
    //T.Free;
    L.Free;
    P.Free;
  end;

  //
  // save result to file
  //
  if ((iCount = 0) and SameText(sFOutput, sFInput))
    or (sFOutput = #0) or SaveStringToFile(sBody, sFOutput)
  then
    WriteLn('Done(', iCount, ').')
  else
    Help(3, 1, sFOutput);
end;

{-------------------------------------------------------------------------------------------------}
begin
  try
    if (ParamCount < 3) or (FxtFindCmdLineSwitch('help') or FxtFindCmdLineSwitch('h')) then
      Help(0, 0);
    // ---
    if FxtFindCmdLineSwitchValue('i', sFInput) and
      //FxtFindCmdLineSwitchValue('o', sFOutput) and
      ( (
        FxtFindCmdLineSwitchValue('t', sTemplateVarName) and
        FxtFindCmdLineSwitchValue('v', sTemplateValue, {AllowEmptyValue:}True) )
      or (
        FxtFindCmdLineSwitchValue('p', sParamsFile) and
        LoadStringFromFile(sParamsFile, sParamLines) and (Trim(sParamLines) <> '')
      )
    ) then
    begin
      FxtFindCmdLineSwitchValue('o', sFOutput);
      DoMain();
    end
    else
      Help(1, 1);
  except
    on e: Exception do
    begin
      WriteLn('ERROR: ' + e.Message);
      Halt(1);
    end;
  end;
end.
