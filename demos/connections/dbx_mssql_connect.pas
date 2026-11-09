(*
  DBX4 Remastered - MS SQL Server Connection Helper
  Version: 4.2026.11.09.1

  This unit provides helper procedures for connecting to Microsoft SQL Server
  using the DBX4 native open-source driver (DbxOpenOdbc).

  Supported Connection Paradigms:

  1. Standard ODBC Connection String:
     SQLConn.DriverName := 'DbxOpenOdbc';
     SQLConn.Params.Values['ConnectionString'] :=
       'Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=ADBDEMOS;Uid=sa;Pwd=secret;';

  2. ADO / OLE DB Connection String (Auto-Translated!):
     SQLConn.DriverName := 'DbxOpenOdbc';
     SQLConn.Params.Values['Database'] :=
       'Provider=SQLOLEDB;Data Source=127.0.0.1;Initial Catalog=ADBDEMOS;User ID=sa;Password=secret;';

  3. Helper Procedure:
     MsSqlConnect(SQLConn, 0, '127.0.0.1', 'ADBDEMOS', 'sa', 'secret');
*)
unit dbx_mssql_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer = 0;
  const ServerName: string = '127.0.0.1';
  const DatabaseName: string = 'ADBDEMOS';
  const UserName: string = 'sa';
  const Password: string = '';
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
  ApplicationName: string = '';
  TrimFixedChar: Boolean = True;
  TrimVarChar: Boolean = False
);

function GetInstalledMsSqlOdbcDriver: string;
function GetDirectMsSqlDriver(ServerVersion: Integer = 0): string;
function GetLocalMsSqlServer(var ServerVersion: Integer; var Server: string): Boolean;

const
  sVendorLib_MSSQL_2000 = 'sqlsrv32.dll';
  sVendorLib_MSSQL_2005 = 'sqlncli.dll';
  sVendorLib_MSSQL_2009 = 'sqlncli10.dll';

implementation

function GetInstalledMsSqlOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..6] of string;
  I: Integer;
begin
  Drivers[0] := 'ODBC Driver 18 for SQL Server';
  Drivers[1] := 'ODBC Driver 17 for SQL Server';
  Drivers[2] := 'ODBC Driver 13 for SQL Server';
  Drivers[3] := 'ODBC Driver 11 for SQL Server';
  Drivers[4] := 'SQL Server Native Client 11.0';
  Drivers[5] := 'SQL Server Native Client 10.0';
  Drivers[6] := 'SQL Server';

  Result := 'ODBC Driver 17 for SQL Server'; // Reasonable modern default
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

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer = 0;
  const ServerName: string = '127.0.0.1';
  const DatabaseName: string = 'ADBDEMOS';
  const UserName: string = 'sa';
  const Password: string = '';
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
  ApplicationName: string = '';
  TrimFixedChar: Boolean = True;
  TrimVarChar: Boolean = False
);
var
  sConnectionString: string;
  sDriver: string;
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

  // Native Trim options
  if TrimFixedChar then
    SQLConnection.Params.Values['TrimFixedChar'] := 'True'
  else
    SQLConnection.Params.Values['TrimFixedChar'] := 'False';

  if TrimVarChar then
    SQLConnection.Params.Values['TrimVarChar'] := 'True'
  else
    SQLConnection.Params.Values['TrimVarChar'] := 'False';

  // Unicode support option
  if bUnicodeDbxDriver then
    SQLConnection.Params.Values['UseUnicode'] := 'True'
  else
    SQLConnection.Params.Values['UseUnicode'] := 'False';

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
    if (ServerVersion > 0) and (ServerVersion <= 2000) then
      sConnectionString := 'DRIVER={SQL Server};' + sConnectionString
    else
    begin
      sDriver := GetInstalledMsSqlOdbcDriver;
      sConnectionString := 'DRIVER={' + sDriver + '};' + sConnectionString;
      // ODBC Driver 18 defaults to Encrypt=Yes; ensure TrustServerCertificate=Yes for dev environments
      if SameText(sDriver, 'ODBC Driver 18 for SQL Server') and
         (Pos('TrustServerCertificate', sConnectionString) = 0) then
        sConnectionString := sConnectionString + ';TrustServerCertificate=Yes';
    end;
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
