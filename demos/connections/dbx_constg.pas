{
  Version: 2011.11.19
}
unit dbx_constg;

interface

uses
  Windows, SysUtils, Classes, SqlExpr;

procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; ConStorage: TStrings); overload;
procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; const ConStorageFile: string); overload;
function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  ConStorage: TStrings; MergeParams: Boolean = False): Boolean; overload;
function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  const ConStorageFile: string; MergeParams: Boolean = False): Boolean; overload;

function ConStorageVersion(): string;

implementation

uses
  IniFiles,
  DbxXXDrv; // { critical }

const
  BoolToStr: array[Boolean] of string = ('False', 'True');

//function HidePassword(const ConnectString: AnsiString; bAddDelim: Boolean = False): AnsiString;
//var
//  sTempl: AnsiString;
//begin
//  sTempl := '***';
//  if bAddDelim then
//    sTempl := sTempl + ';';
//  Result := ConnectString;
//  if GetOptionValue(Result, 'PWD',
//    {HideOption=}True,{TrimResult=}False, {bOneChar=}False, {HideTemplate=}sTempl) = cNullAnsiChar
//  then
//    GetOptionValue(Result, 'PASSWORD',
//    {HideOption=}True,{TrimResult=}False, {bOneChar=}False, {HideTemplate=}sTempl);
//end;
//PSWD PASSWORD UID USERID

procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; ConStorage: TStrings); overload;
begin
  if ConStorage = nil then
    Exit;
  ConStorage.Clear;
  ConStorage.Add('[Properties]');
  ConStorage.Add('DriverName=' + SQLConnection.DriverName);
  ConStorage.Add('LibraryName=' + SQLConnection.LibraryName);
  ConStorage.Add('GetDriverFunc=' + SQLConnection.GetDriverFunc);
  ConStorage.Add('VendorLib=' + SQLConnection.VendorLib);
  ConStorage.Add('LoginPrompt=' + BoolToStr[SQLConnection.LoginPrompt]);
  ConStorage.Add('');
  ConStorage.Add('[Params]');
  ConStorage.Add(Trim(SQLConnection.Params.Text)); // todo: save password to spesial crypted section
end;

procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; const ConStorageFile: string); overload;
var
  ConStorage: TStringList;
begin
  ConStorage := TStringList.Create;
  try
    SQLConnectionSaveProperties(SQLConnection, ConStorage);
    ConStorage.SaveToFile(ConStorageFile);
  finally
    ConStorage.Free;
  end;
end;

function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  ConStorage: TStrings; MergeParams: Boolean = False): Boolean; overload;
var
  ini: TMemIniFile;
  L: TStringList;
  i: Integer;
  N: string;
begin
  Result := False;
  if ConStorage = nil then
    Exit;
  L := nil;
  ini := TMemIniFile.Create('');
  try
    ini.SetStrings(ConStorage);
    L := TStringList.Create;
    ini.ReadSectionValues('Properties', L);
    SQLConnection.DriverName := L.Values['DriverName'];
    if SQLConnection.DriverName = '' then
      SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;
    SQLConnection.LibraryName := L.Values['LibraryName'];
    SQLConnection.GetDriverFunc := L.Values['GetDriverFunc'];
    SQLConnection.VendorLib := L.Values['VendorLib'];
    SQLConnection.LoginPrompt := SameText(L.Values['LoginPrompt'], 'True');
    //
    if not MergeParams then
    begin
      L.Clear;
      ini.ReadSectionValues('Params', L);
      SQLConnection.Params.Clear;
      SQLConnection.Params.Assign(L);
    end
    else
    begin
      for i := 0 to L.Count - 1 do
      begin
        N := L.Names[i];
        {$IF CompilerVersion >= 15.00}
        SQLConnection.Params.Values[N] := L.ValueFromIndex[i];
        {$ELSE}
        SQLConnection.Params.Values[N] := L.Values[N];
        {$IFEND}
      end;
    end;
    //
    Result := (SQLConnection.LibraryName <> '') and (SQLConnection.GetDriverFunc <> '');
  finally
    L.Free;
    ini.Free;
  end;
end;

function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  const ConStorageFile: string; MergeParams: Boolean = False): Boolean; overload;
var
  ConStorage: TStringList;
begin
  Result := False;
  if not FileExists(ConStorageFile) then
    Exit;
  ConStorage := TStringList.Create;
  try
    ConStorage.LoadFromFile(ConStorageFile);
    Result := SQLConnectionLoadProperties(SQLConnection, ConStorage, MergeParams);
  finally
    ConStorage.Free;
  end;
end;

{$warnings off}
function ConStorageVersion(): string;
begin
  Result := '';
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF Declared(CompilerVersion)}
    {$IF CompilerVersion = 14.01}
  Result := '-D6';
    {$IFEND}
    {$IF CompilerVersion = 14.10}
  Result := '-D6';
    {$IFEND}
    {$IF CompilerVersion = 14.50}
  Result := '-D7';
    {$IFEND}
    {$IF CompilerVersion = 15.00}
  Result := '-D7';
    {$IFEND}
    {$IF CompilerVersion = 17.00}
  Result := '-D2005';
    {$IFEND}
    {$IF CompilerVersion = 18.00}
  Result := '-D2006';
    {$IFEND}
    {$IF CompilerVersion = 18.50}
  Result := '-D2007';
    {$IFEND}
    {$IF CompilerVersion = 20.00}
  Result := '-D2009';
    {$IFEND}
    {$IF CompilerVersion = 21.00}
  Result := '-D2010';
    {$IFEND}
    {$IF CompilerVersion = 22.00}
  Result := '-D2011';
    {$IFEND}
    {$IF CompilerVersion = 23.00}
  Result := '-D2012';
    {$IFEND}
    {$IF CompilerVersion > 23.00}
  Result := '-DX';
    {$IFEND}
  {$IFEND} // of: $IF Declared(CompilerVersion)
{$ENDIF}
end;
{$warnings on}

end.
