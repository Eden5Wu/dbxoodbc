{
  DBX4 Remastered - Firebird Connection Helper
  Version: 4.2026.11.10
}
unit dbx_firebird_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure FirebirdConnect(SQLConnection: TSQLConnection;
  const database_file: string;
  const server: string = '127.0.0.1';
  const port: string = '3050';
  const UserName: string = 'SYSDBA';
  const Password: string = 'masterkey';
  const CharSet: string = 'UTF8';
  const Dialect: string = '3';
  const ClientDll: string = '';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);

function GetInstalledFirebirdOdbcDriver: string;

implementation

function GetInstalledFirebirdOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..2] of string;
  I: Integer;
begin
  Drivers[0] := 'Firebird/InterBase(r) driver';
  Drivers[1] := 'Firebird ODBC Driver';
  Drivers[2] := 'InterBase ODBC Driver';

  Result := 'Firebird/InterBase(r) driver'; // Standard official Firebird ODBC driver name
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

procedure FirebirdConnect(SQLConnection: TSQLConnection;
  const database_file: string;
  const server: string = '127.0.0.1';
  const port: string = '3050';
  const UserName: string = 'SYSDBA';
  const Password: string = 'masterkey';
  const CharSet: string = 'UTF8';
  const Dialect: string = '3';
  const ClientDll: string = '';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);
var
  sConnectionString: string;
  sDriver: string;
  sDbName: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
  begin
    sDriver := GetInstalledFirebirdOdbcDriver;
    sConnectionString := 'DRIVER={' + sDriver + '};';
  end;

  // Build Firebird DBNAME (server/port:filepath or local filepath)
  if (server <> '') and not SameText(server, 'localhost') and not SameText(server, '127.0.0.1') then
  begin
    if port <> '' then
      sDbName := server + '/' + port + ':' + database_file
    else
      sDbName := server + ':' + database_file;
  end
  else
    sDbName := database_file;

  if sDbName <> '' then
    sConnectionString := sConnectionString + 'DBNAME=' + Trim(sDbName) + ';';

  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + Trim(UserName) + ';PWD=' + Password + ';';

  // CharacterSet=UTF8 is required to prevent (-104) Malformed string errors on multi-byte characters
  if CharSet <> '' then
    sConnectionString := sConnectionString + 'CHARSET=' + Trim(CharSet) + ';';

  // Dialect 3 supports BIGINT, TIMESTAMP, and native BOOLEAN
  if Dialect <> '' then
    sConnectionString := sConnectionString + 'DIALECT=' + Trim(Dialect) + ';';

  if ClientDll <> '' then
    sConnectionString := sConnectionString + 'CLIENT=' + Trim(ClientDll) + ';';

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

