{
  DBX4 Remastered - PostgreSQL Connection Helper
  Version: 4.2026.11.09.1
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
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);

function GetDirectPostgreSqlOdbcDriverName(): string;
function GetDirectPostgreSqlDriver(DirectOdbc: Boolean = True): string;

var
  psqlodbc_dll: string = 'psqlodbc.dll';
  psqlodbca_dll: string = 'psqlodbc30a.dll';
  psqlodbcw_dll: string = 'psqlodbc35w.dll';

implementation

function GetDirectPostgreSqlOdbcDriverName(): string;
begin
  Result := 'PostgreSQL Unicode';
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
    sConnectionString := 'DSN=' + dns_name + ';'
  else
    sConnectionString := 'DRIVER={' + GetDirectPostgreSqlOdbcDriverName + '};';

  if server <> '' then
    sConnectionString := sConnectionString + 'SERVER=' + server + ';'
  else
    sConnectionString := sConnectionString + 'SERVER=127.0.0.1;';

  if port <> '' then
    sConnectionString := sConnectionString + 'PORT=' + port + ';'
  else
    sConnectionString := sConnectionString + 'PORT=5432;';

  if database <> '' then
    sConnectionString := sConnectionString + 'DATABASE=' + database + ';';

  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

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
