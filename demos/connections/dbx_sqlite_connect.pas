{
  DBX4 Remastered - SQLite Connection Helper
  Version: 4.2026.11.10
}
unit dbx_sqlite_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure SQLiteConnect(SQLConnection: TSQLConnection;
  const db_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False
);

var
  sqlite3odbc_dll: string = 'sqlite3odbc.dll';

implementation

procedure SQLiteConnect(SQLConnection: TSQLConnection;
  const db_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;
  if (Trim(db_file_name) = '') and (Trim(dns_name) = '') then
    Exit;

  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
    sConnectionString := 'DRIVER={SQLite3 ODBC Driver};';

  if db_file_name <> '' then
    sConnectionString := sConnectionString + 'Database=' + Trim(db_file_name) + ';';

  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + Trim(UserName) + ';PWD=' + Password + ';';

  // SQLite robust defaults: enable wide chars, set busy timeout
  if Pos('Timeout=', AdditionalOptions) = 0 then
    sConnectionString := sConnectionString + 'Timeout=10000;';

  if Pos('NoWCHAR=', AdditionalOptions) = 0 then
    sConnectionString := sConnectionString + 'NoWCHAR=0;';

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
