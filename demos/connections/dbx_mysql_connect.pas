{
  DBX4 Remastered - MySQL & MariaDB Connection Helper
  Version: 4.2026.11.10
}
unit dbx_mysql_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure MySqlConnect(SQLConnection: TSQLConnection;
  const database: string;
  const server: string = '127.0.0.1';
  const port: string = '3306';
  const UserName: string = 'root';
  const Password: string = '';
  const CharSet: string = 'utf8mb4';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);

function GetInstalledMySqlOdbcDriver: string;

implementation

function GetInstalledMySqlOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..6] of string;
  I: Integer;
begin
  Drivers[0] := 'MySQL ODBC 9.0 Unicode Driver';
  Drivers[1] := 'MySQL ODBC 8.4 Unicode Driver';
  Drivers[2] := 'MySQL ODBC 8.0 Unicode Driver';
  Drivers[3] := 'MariaDB ODBC 3.2 Driver';
  Drivers[4] := 'MariaDB ODBC 3.1 Driver';
  Drivers[5] := 'MariaDB ODBC 3.0 Driver';
  Drivers[6] := 'MySQL ODBC 5.3 Unicode Driver';

  Result := 'MySQL ODBC 8.0 Unicode Driver'; // Reasonable modern baseline default
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

procedure MySqlConnect(SQLConnection: TSQLConnection;
  const database: string;
  const server: string = '127.0.0.1';
  const port: string = '3306';
  const UserName: string = 'root';
  const Password: string = '';
  const CharSet: string = 'utf8mb4';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);
var
  sConnectionString: string;
  sDriver: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
  begin
    sDriver := GetInstalledMySqlOdbcDriver;
    sConnectionString := 'DRIVER={' + sDriver + '};';
  end;

  if server <> '' then
    sConnectionString := sConnectionString + 'SERVER=' + Trim(server) + ';'
  else
    sConnectionString := sConnectionString + 'SERVER=127.0.0.1;';

  if port <> '' then
    sConnectionString := sConnectionString + 'PORT=' + Trim(port) + ';'
  else
    sConnectionString := sConnectionString + 'PORT=3306;';

  if database <> '' then
    sConnectionString := sConnectionString + 'DATABASE=' + Trim(database) + ';';

  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + Trim(UserName) + ';PWD=' + Password + ';';

  if CharSet <> '' then
    sConnectionString := sConnectionString + 'CHARSET=' + Trim(CharSet) + ';';

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

