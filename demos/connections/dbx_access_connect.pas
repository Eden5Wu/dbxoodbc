{
  DBX4 Remastered - MS Access Connection Helper
  Version: 4.2026.11.04
}
unit dbx_access_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure AccessConnect(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True
);

procedure AccessConnectW(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);

function GetAccessDriver(DirectOdbc: Boolean): string;
function IsPresentedAccessDriver(DirectOdbc: Boolean): Boolean;
function Is64BitWindows: Boolean;

const
  cAccessDefaultAdditionalOptions: string = 'MaxBufferSize=2048;PageTimeout=17;';

implementation

procedure AccessConnectCustom(SQLConnection: TSQLConnection;
  mdb_file_name: string;
  DNS_NAME: string;
  DirectOdbc: Boolean;
  LoginPrompt: Boolean;
  UserName: string;
  Password: string;
  AdditionalOptions: string
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;

  mdb_file_name := Trim(mdb_file_name);
  DNS_NAME := Trim(DNS_NAME);

  if (mdb_file_name = '') and (DNS_NAME = '') then
    Exit;

  SQLConnection.DriverName := sDbxOpenOdbcDriverName;

  UserName := Trim(UserName);
  if UserName = '' then
    LoginPrompt := False;
  SQLConnection.LoginPrompt := LoginPrompt;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + DNS_NAME + ';'
  else
  begin
    {$IFDEF WIN64}
    sConnectionString := 'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};';
    {$ELSE}
    sConnectionString := 'DRIVER={Microsoft Access Driver (*.mdb)};';
    {$ENDIF}
  end;

  if mdb_file_name <> '' then
    sConnectionString := sConnectionString + 'DBQ=' + mdb_file_name + ';';
  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions = '' then
    sConnectionString := sConnectionString + cAccessDefaultAdditionalOptions
  else
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

function GetAccessDriver(DirectOdbc: Boolean): string;
begin
  Result := 'odbc32.dll';
end;

function IsPresentedAccessDriver(DirectOdbc: Boolean): Boolean;
begin
  Result := True;
end;

procedure AccessConnect(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True
);
begin
  AccessConnectCustom(SQLConnection, mdb_file_name, DNS_NAME, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions);
end;

procedure AccessConnectW(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);
begin
  AccessConnectCustom(SQLConnection, mdb_file_name, DNS_NAME, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions);
end;

function Is64BitWindows: Boolean;
begin
  {$IFDEF WIN64}
  Result := True;
  {$ELSE}
  Result := TOSVersion.Architecture in [arIntelX64, arARM64];
  {$ENDIF}
end;

end.
