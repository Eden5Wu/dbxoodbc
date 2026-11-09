{
  DBX4 Remastered - Paradox (.db) Connection Helper
  Version: 4.2026.11.10

  Note on Bitness (Win32 vs Win64):
  The official Microsoft Jet 4.0 Paradox ODBC Driver ("Microsoft Paradox Driver (*.db )")
  is available exclusively as a 32-bit driver in Windows (SysWOW64).
  Microsoft did not include Paradox support in the 64-bit Access Database Engine (ACE).
  Therefore, applications connecting to Paradox tables should be compiled for Win32.
}
unit dbx_paradox_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure ParadoxConnect(SQLConnection: TSQLConnection;
  const db_path_or_file: string;
  const paradox_version: string = '5.X';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);

function GetInstalledParadoxOdbcDriver: string;
function IsPresentedParadoxDriver: Boolean;

const
  // Notice the trailing space before closing parenthesis: standard Microsoft Jet driver name convention
  cDefaultParadoxDriverName = 'Microsoft Paradox Driver (*.db )';

implementation

function GetInstalledParadoxOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..2] of string;
  I: Integer;
begin
  Drivers[0] := 'Microsoft Paradox Driver (*.db )';
  Drivers[1] := 'Microsoft Paradox-Treiber (*.db )';
  Drivers[2] := 'Driver do Microsoft Paradox (*.db )';

  Result := cDefaultParadoxDriverName;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers') then
    begin
      for I := Low(Drivers) to High(Drivers) do
      begin
        if R.ValueExists(Drivers[I]) then
        begin
          Result := Drivers[I];
          Break;
        end;
      end;
    end;
  finally
    R.Free;
  end;
end;

function IsPresentedParadoxDriver: Boolean;
var
  R: TRegistry;
begin
  Result := False;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers') then
      Result := R.ValueExists(cDefaultParadoxDriverName);
  finally
    R.Free;
  end;
end;

procedure ParadoxConnect(SQLConnection: TSQLConnection;
  const db_path_or_file: string;
  const paradox_version: string = '5.X';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);
var
  sConnectionString: string;
  sDriver: string;
  sDir: string;
  sDriverId: string;
  sFilVer: string;
begin
  SQLConnection.Close;
  sDir := Trim(db_path_or_file);

  if (sDir = '') and (Trim(dns_name) = '') then
    Exit;

  // If a file path was passed (e.g. C:\Data\customer.db), extract directory
  if (sDir <> '') and FileExists(sDir) then
    sDir := ExtractFilePath(sDir);
  sDir := ExcludeTrailingPathDelimiter(sDir);

  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
  begin
    sDriver := GetInstalledParadoxOdbcDriver;
    sConnectionString := 'DRIVER={' + sDriver + '};';
  end;

  if sDir <> '' then
    sConnectionString := sConnectionString + 'Dbq=' + sDir + ';DefaultDir=' + sDir + ';';

  // Determine DriverID based on Paradox table format
  sFilVer := UpperCase(Trim(paradox_version));
  if sFilVer = '3.X' then
    sDriverId := '533'
  else if sFilVer = '4.X' then
    sDriverId := '535'
  else
    sDriverId := '538'; // Standard default for 5.X, 7.X

  sConnectionString := sConnectionString + 'DriverID=' + sDriverId + ';';
  sConnectionString := sConnectionString + 'Fil=Paradox ' + Trim(paradox_version) + ';';

  if ReadOnly then
    sConnectionString := sConnectionString + 'ReadOnly=1;';

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

end.
