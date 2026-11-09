{
  DBX4 Remastered - Oracle Connection Helper
  Version: 4.2026.11.10
}
unit dbx_ora_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

function OracleBuildConnection(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;

function OracleConnect(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;

function GetInstalledOracleOdbcDriver: string;
function IsPresentedOracleDriver: Boolean;
function IsPresentedMicrosoftOracleDriver: Boolean;

var
  cDriverName1: string = 'Oracle in OraClient19Home1';
  cDriverName2: string = 'Oracle ODBC Driver';

implementation

function GetInstalledOracleOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..5] of string;
  I: Integer;
begin
  Drivers[0] := 'Oracle in OraClient19Home1';
  Drivers[1] := 'Oracle in OraClient21Home1';
  Drivers[2] := 'Oracle in OraClient12Home1';
  Drivers[3] := 'Oracle in OraClient11g_home1';
  Drivers[4] := 'Oracle in InstantClient';
  Drivers[5] := 'Oracle ODBC Driver';

  Result := 'Oracle in OraClient19Home1'; // Modern default
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

function OracleBuildConnection(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;
var
  sConnectionString: string;
  sDriver: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := bLoginPrompt;

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + Trim(DNS_NAME) + ';'
  else if bMicrosoftDriver then
    sConnectionString := 'DRIVER={Microsoft ODBC for Oracle};SERVER=' + Trim(TnsName) + ';'
  else
  begin
    sDriver := GetInstalledOracleOdbcDriver;
    sConnectionString := 'DRIVER={' + sDriver + '};DBQ=' + Trim(TnsName) + ';';
  end;

  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + Trim(UserName) + ';PWD=' + Password + ';';

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  // Oracle SchemaOverride prevents full data dictionary scans across SYS/SYSTEM tables
  if (UserName <> '') and (SQLConnection.Params.Values['SchemaOverride'] = '') then
    SQLConnection.Params.Values['SchemaOverride'] := '%.' + UpperCase(Trim(UserName));

  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  Result := True;
end;

function OracleConnect(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;
begin
  Result := OracleBuildConnection(SQLConnection, TnsName, UserName, Password,
    bMicrosoftDriver, bDirectOdbc, bLoginPrompt, DNS_NAME, AdditionalOptions);
  if Result then
    SQLConnection.Open;
end;

function IsPresentedOracleDriver: Boolean;
begin
  Result := True;
end;

function IsPresentedMicrosoftOracleDriver: Boolean;
begin
  Result := True;
end;

end.
