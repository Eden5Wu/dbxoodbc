{
  DBX4 Remastered - PostgreSQL Connection Helper
  Version: 4.2026.11.10
}
unit dbx_postgresql_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure PostgreSQLConnect(SQLConnection: TSQLConnection;
  const database, server, port: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  ReadOnly: Boolean = False;
  const CharSet: string = 'UTF8';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);

function GetInstalledPostgreSqlOdbcDriver: string;
function GetDirectPostgreSqlOdbcDriverName: string;
function GetDirectPostgreSqlDriver(DirectOdbc: Boolean = True): string;

var
  psqlodbc_dll: string = 'psqlodbc.dll';
  psqlodbca_dll: string = 'psqlodbc30a.dll';
  psqlodbcw_dll: string = 'psqlodbc35w.dll';

implementation

function GetInstalledPostgreSqlOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..3] of string;
  I: Integer;
begin
  Drivers[0] := 'PostgreSQL Unicode';
  Drivers[1] := 'PostgreSQL Unicode(x64)';
  Drivers[2] := 'PostgreSQL ANSI';
  Drivers[3] := 'PostgreSQL ANSI(x64)';

  Result := 'PostgreSQL Unicode'; // Preferred standard driver
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

function GetDirectPostgreSqlOdbcDriverName: string;
begin
  Result := GetInstalledPostgreSqlOdbcDriver;
end;

function GetDirectPostgreSqlDriver(DirectOdbc: Boolean = True): string;
begin
  Result := 'odbc32.dll';
end;

procedure PostgreSQLConnect(SQLConnection: TSQLConnection;
  const database, server, port: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  ReadOnly: Boolean = False;
  const CharSet: string = 'UTF8';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
    sConnectionString := 'DRIVER={' + GetInstalledPostgreSqlOdbcDriver + '};';

  if server <> '' then
    sConnectionString := sConnectionString + 'SERVER=' + Trim(server) + ';'
  else
    sConnectionString := sConnectionString + 'SERVER=127.0.0.1;';

  if port <> '' then
    sConnectionString := sConnectionString + 'PORT=' + Trim(port) + ';'
  else
    sConnectionString := sConnectionString + 'PORT=5432;';

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
