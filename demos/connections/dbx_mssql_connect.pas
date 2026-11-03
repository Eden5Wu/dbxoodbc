{
  DBX4 Remastered - MS SQL Server Connection Helper
  Version: 4.2026.11.02
}
unit dbx_mssql_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  OSAuthentication: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = '';
  const LanguageName: string = '';
  bUnicodeDbxDriver: Boolean = True;
  bUnicodeODBCAPI: Boolean = True;
  bAnsiFields: Boolean = False;
  bPrepareSQL: Boolean = True;
  ApplicationName: string = ''
);

function GetDirectMsSqlDriver(ServerVersion: Integer = 0): string;
function GetLocalMsSqlServer(var ServerVersion: Integer; var Server: string): Boolean;

const
  sVendorLib_MSSQL_2000 = 'sqlsrv32.dll';
  sVendorLib_MSSQL_2005 = 'sqlncli.dll';
  sVendorLib_MSSQL_2009 = 'sqlncli10.dll';

implementation

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  OSAuthentication: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = '';
  const LanguageName: string = '';
  bUnicodeDbxDriver: Boolean = True;
  bUnicodeODBCAPI: Boolean = True;
  bAnsiFields: Boolean = False;
  bPrepareSQL: Boolean = True;
  ApplicationName: string = ''
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;

  if UserName = '' then
    OSAuthentication := True;

  if OSAuthentication then
  begin
    LoginPrompt := False;
    sConnectionString := 'Trusted_Connection=Yes';
  end
  else
  begin
    sConnectionString := 'UID=' + UserName + ';PWD=' + Password;
  end;
  SQLConnection.LoginPrompt := LoginPrompt;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  if not bPrepareSQL then
    SQLConnection.Params.Values[PREPARESQL] := 'False';

  if (DNS_NAME = '') and (ServerName = '') then
    sConnectionString := sConnectionString + ';SERVER=127.0.0.1'
  else if ServerName <> '' then
    sConnectionString := sConnectionString + ';SERVER=' + ServerName;

  if DatabaseName <> '' then
    sConnectionString := sConnectionString + ';DATABASE=' + DatabaseName;

  if LanguageName <> '' then
    sConnectionString := sConnectionString + ';LANGUAGE=' + LanguageName;

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + ';' + AdditionalOptions;

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + DNS_NAME + ';' + sConnectionString
  else
  begin
    if ServerVersion <= 2000 then
      sConnectionString := 'DRIVER={SQL Server};' + sConnectionString
    else
      sConnectionString := 'DRIVER={SQL Server};' + sConnectionString;
  end;

  if ApplicationName <> '' then
    sConnectionString := sConnectionString + ';APP=' + ApplicationName;

  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

function GetDirectMsSqlDriver(ServerVersion: Integer): string;
begin
  Result := 'odbc32.dll';
end;

function GetLocalMsSqlServer(var ServerVersion: Integer; var Server: string): Boolean;
var
  R: TRegistry;
  S: string;
  vKeyNames: TStringList;
begin
  vKeyNames := nil;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    try
      if R.OpenKeyReadOnly('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL') then
      begin
        vKeyNames := TStringList.Create;
        R.GetValueNames(vKeyNames);
        if vKeyNames.Count > 0 then
        begin
          S := vKeyNames[0];
          Server := '127.0.0.1\' + S;
          ServerVersion := 2005;
          Result := True;
          Exit;
        end;
      end;
    except
    end;
  finally
    R.Free;
    vKeyNames.Free;
  end;
  Server := '127.0.0.1';
  ServerVersion := 2000;
  Result := False;
end;

end.
