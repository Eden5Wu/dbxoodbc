{
  DBX4 Remastered - Connection Properties Storage Helper
  Version: 4.2026.11.09.1
}
unit dbx_constg;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Data.SqlExpr;

procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; ConStorage: TStrings); overload;
procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; const ConStorageFile: string); overload;
function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  ConStorage: TStrings; MergeParams: Boolean = False): Boolean; overload;
function SQLConnectionLoadProperties(SQLConnection: TSQLConnection;
  const ConStorageFile: string; MergeParams: Boolean = False): Boolean; overload;

function ConStorageVersion(): string;

implementation

uses
  System.IniFiles,
  DbxOpenOdbcDriver;

const
  BoolToStr: array[Boolean] of string = ('False', 'True');

procedure SQLConnectionSaveProperties(SQLConnection: TSQLConnection; ConStorage: TStrings); overload;
begin
  if ConStorage = nil then
    Exit;
  ConStorage.Clear;
  ConStorage.Add('[Properties]');
  ConStorage.Add('DriverName=' + SQLConnection.DriverName);
  ConStorage.Add('LoginPrompt=' + BoolToStr[SQLConnection.LoginPrompt]);
  ConStorage.Add('');
  ConStorage.Add('[Params]');
  ConStorage.Add(Trim(SQLConnection.Params.Text));
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
      SQLConnection.DriverName := sDbxOpenOdbcDriverName;
    SQLConnection.LoginPrompt := SameText(L.Values['LoginPrompt'], 'True');

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
        SQLConnection.Params.Values[N] := L.ValueFromIndex[i];
      end;
    end;
    Result := SQLConnection.DriverName <> '';
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

function ConStorageVersion(): string;
begin
  Result := '-DBX4';
end;

end.
