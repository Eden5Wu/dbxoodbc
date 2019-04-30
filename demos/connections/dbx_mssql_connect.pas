{
  Version: 2010.07.15
}
unit dbx_mssql_connect;

interface

uses
  Windows, SysUtils, Classes, Registry, DBXDynalink,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  OSAuthentication: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = '';
  const LanguageName: string = '';
  // Allow use of DBX3
  bUnicodeDbxDriver: Boolean = False;
  // Allow or nor use of adbc unicode api
  bUnicodeODBCAPI: Boolean = False;
  // Allow or nor use of TWideStringField
  bAnsiFields: Boolean = True;
  bPrepareSQL: Boolean = True;
  ApplicationName: string = ''
);


function GetDirectMsSqlDriver(ServerVersion: Integer = 0): string;
function GetLocalMsSqlServer(var ServerVersion: Integer; var Server: string): Boolean;

const
  sVendorLib_MSSQL_2000 = 'sqlsrv32.dll';  // is present by default in Windows
  sVendorLib_MSSQL_2005 = 'sqlncli.dll';   // need install into PC
  sVendorLib_MSSQL_2009 = 'sqlncli10.dll'; // need install into PC

implementation

uses
  DbxXXDrv; // { critical }

//DSN=dsn_mssql;UID=user_name;PWD=mypassword;SERVER=server_name_or_ip;
//DATABASE=database_name;Trusted_Connection=Yes;APP=application_name;
//WSID=client_host_name;Network=DBMSSOCN

procedure MsSqlConnect(SQLConnection: TSQLConnection;
  ServerVersion: Integer;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  OSAuthentication: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = '';
  const LanguageName: string = '';
  bUnicodeDbxDriver: Boolean = False;
  bUnicodeODBCAPI: Boolean = False;
  bAnsiFields: Boolean = True;
  bPrepareSQL: Boolean = True;
  ApplicationName: string = ''
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;

  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;

  {$IF CompilerVersion < 17.50}
  if not bUnicodeODBCAPI then
    SQLConnection.GetDriverFunc := 'getSQLDriverODBC'
  else
    SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
  {$ELSE}
  if not bUnicodeDbxDriver then
  begin
    if not bUnicodeODBCAPI then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBC';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
    end;
  end
  else
  begin
    if bUnicodeODBCAPI then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCWA';
    end;
  end;
  {$IFEND}

  SQLConnection.LibraryName   := 'dbxoodbc.dll';

  if UserName = '' then
    OSAuthentication := True;

  if OSAuthentication then
  begin
    LoginPrompt := False;
    sConnectionString := 'Trusted_Connection=Yes';
  end
  else
  begin
    sConnectionString :=
        'UID=' + UserName
      + ';PWD=' + Password
  end;
  SQLConnection.LoginPrompt := LoginPrompt;

  SQLConnection.VendorLib := '';
  if DirectOdbc then
    SQLConnection.VendorLib := GetDirectMsSqlDriver(ServerVersion);
  if SQLConnection.VendorLib <> '' then
  begin
    if ServerVersion <= 2000 then
      SQLConnection.VendorLib := SQLConnection.VendorLib
       + ';' + sVendorLib_MSSQL_2005
       + ';' + sVendorLib_MSSQL_2009
    else if ServerVersion <= 2007 then
      SQLConnection.VendorLib := SQLConnection.VendorLib
       + ';' + sVendorLib_MSSQL_2009
       + ';' + sVendorLib_MSSQL_2000
    else
      SQLConnection.VendorLib := SQLConnection.VendorLib
       + ';' + sVendorLib_MSSQL_2005
       + ';' + sVendorLib_MSSQL_2000;
  end
  else
  begin
    if DirectOdbc then
      SQLConnection.VendorLib := sVendorLib_MSSQL_2009
        + ';' + sVendorLib_MSSQL_2005
        + ';' + sVendorLib_MSSQL_2000
        + ';' + 'odbc32.dll'
    else
      SQLConnection.VendorLib := 'odbc32.dll'
        + ';' + sVendorLib_MSSQL_2009
        + ';' + sVendorLib_MSSQL_2005
        + ';' + sVendorLib_MSSQL_2000;
    DirectOdbc := False;
  end;

  with SQLConnection.Params do
  begin
    Clear;
    // @dbx34:
    {$IF CompilerVersion >= 18.50} // Delphi 2007 Up

    //Text :=
    //  //'DriverUnit=DBXDynalink' + #13#10 +
    //  'DriverPackageLoader=TDBXDynalinkDriverLoader' + #13#10 +
    //  //'DriverPackageLoader=TDBXDynalinkDriverCommonLoader' + #13#10 +
    //  //'DriverPackage=DbxCommonDriver120.bpl' + #13#10 +
    //  //'LibraryName=dbxoodbc.dll' + #13#10 +
    //  //'GetDriverFunc=' + SQLConnection.GetDriverFunc + #13#10 +
    //  //'VendorLib=' + SQLConnection.VendorLib + #13#10 +
    //  '';

    // FOR IDE:
    //Values[TDBXPropertyNames.DriverName] := {DbxXXDrv.pas}DbxOODBCDriverName;

    // DBXOODBC: uses DbxXXDrv
    //
    //Values[TDBXPropertyNames.MetaDataPackageLoader] := // == 'TDBXOpenODBCMetaDataCommandFactory'
    //  TDBXOpenODBCMetaDataCommandFactory.ClassName;
    // or
    Values[TDBXPropertyNames.MetaDataPackageLoader] := //  == 'TDBXOpenODBCMetaDataCommandFactoryMSSQL'
      TDBXOpenODBCMetaDataCommandFactoryMSSQL.ClassName;

    //@d2007 critical
    Values[TDBXPropertyNames.DriverPackageLoader] := // 'TDBXDynalinkDriverLoaderOpenOdbc'
      TDBXDynalinkDriverLoaderOpenOdbc.ClassName;
    //@test
    //  SQLConnection.Params.Values[TDBXDynalinkPropertyNames.BlobSize] := '1'; // 'BlobSize'
    {$IFEND}
    // @dbx34.

    Values[TRIMCHAR] := 'True';     // 'Trim Char'
    Values[ROWSETSIZE_KEY] := '20'; // 'RowsetSize'
    if not bPrepareSQL then
      Values[PREPARESQL] := 'False'; // 'Prepare SQL'
    //Values[SQLConnection.DriverName + ' TransIsolation'] := 'ReadCommited';
  end;

  if (DNS_NAME = '') and (ServerName = '') then
    sConnectionString := sConnectionString + ';SERVER=127.0.0.1'
  else if ServerName <> '' then
    sConnectionString := sConnectionString + ';SERVER=' + ServerName;

  if DatabaseName <> '' then
    sConnectionString := sConnectionString + ';DATABASE=' + DatabaseName;

  if LanguageName <> '' then
    sConnectionString := sConnectionString + ';LANGUAGE=' + DatabaseName;

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + ';' + AdditionalOptions;

  sConnectionString := sConnectionString + ';' + 'coCatPrefix=DATABASE';

  if DirectOdbc then
  begin
    if ServerVersion <= 2000 then
        sConnectionString := 'DRIVER={SQL Server};' + sConnectionString
    else // 2005 UP
      sConnectionString := 'DRIVER={SQL Native Client};' + sConnectionString;
  end
  else
  begin
    if DNS_NAME <> '' then
      sConnectionString := 'DNS=' + DNS_NAME + ';' + sConnectionString
    else
    begin
      if ServerVersion <= 2000 then
        sConnectionString := 'DRIVER={SQL Server};' + sConnectionString
      else // 2005 UP
        sConnectionString := 'DRIVER={SQL Native Client};' + sConnectionString;
    end;
  end;

  //bAnsiFields
  if not bUnicodeDbxDriver then
  begin
    //
    // DBX2 not supported TWideStringField
    //
    //if not bAnsiFields then
    //  sConnectionString := sConnectionString + ';coEnableUnicode=1';
    sConnectionString := sConnectionString + ';coEnableUnicode=0';
  end
  else
  begin
    if not bAnsiFields then
      sConnectionString := sConnectionString + ';coEnableUnicode=1';
  end;
  if ApplicationName <> '' then
    sConnectionString := sConnectionString + ';APP=' + ApplicationName;
  {$IF CompilerVersion > 14.01}
     {$IF CompilerVersion >= 18.50}
       // Delphi 2007 Up
       SQLConnection.Params.Values[DATABASENAME_KEY]  := '?';
       SQLConnection.Params.Values[CONNECTION_STRING] := sConnectionString;
       //if IsDbxDrvFixed then
       //  SQLConnection.Params.Values[CUSTOM_INFO] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
     {$ELSE}
       // Delphi 2006 .. Delphi 7
       SQLConnection.Params.Values[DATABASENAME_KEY]  := '?';
       SQLConnection.Params.Values[CUSTOM_INFO] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
     {$IFEND}
  {$ELSE}
     // Delphi 6
     if IsDbxDrvFixed then
     begin
       SQLConnection.Params.Values[DATABASENAME_KEY]  := '?';
       //SQLConnection.Params.Values['Custom String'] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
       SQLConnection.Params.Values['ConnectionString'] := sConnectionString;
     end
     else
     begin
       if Length(sConnectionString) > 255 then
         SetLength(sConnectionString, 255); // Buffer overflow AV protect :(
       SQLConnection.Params.Values[DATABASENAME_KEY]  := sConnectionString;
     end;
  {$IFEND}

  SQLConnection.Params.Values[VENDORLIB_KEY] := SQLConnection.VendorLib;
  SQLConnection.Open;
end;

function GetDirectMsSqlDriver(ServerVersion: Integer): string;
begin
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if ServerVersion <= 2000 then
      begin
        if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\SQL Server', False) and
          ValueExists('Driver') then
        begin
          Result := Trim(ReadString('Driver'));
          // todo: expand env like %WINDIR%
          if FileExists(Result) then
            Exit;
        end;
        Result := sVendorLib_MSSQL_2000;
      end
      else { 2005, 2007 }
      begin
        if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\SQL Native Client', False) and
          ValueExists('Driver') then
        begin
          // todo: expand env like %WINDIR%
          Result := Trim(ReadString('Driver'));
          if FileExists(Result) then
            Exit;
        end;
      end; // of: case ServerVersion
    finally
      Free;
    end;
  except
  end;

  if ServerVersion <= 2000 then
    Result := sVendorLib_MSSQL_2000
  else if ServerVersion <= 2007 then
    Result := sVendorLib_MSSQL_2005
  else
    Result := sVendorLib_MSSQL_2009;
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
    //
    // 2005:
    //
    // "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL"
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
    //
    // 2000:
    //
    // "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\80\Tools\Service Manager"
    try
      if R.OpenKeyReadOnly('SOFTWARE\Microsoft\Microsoft SQL Server\80\Tools\Service Manager') then
      begin
        //Default
        Server := '127.0.0.1';
        ServerVersion := 2000;
        Result := True;
        Exit;
      end;
    except
    end;
    //.
  finally
    R.Free;
    vKeyNames.Free;
  end;
  Result := False
end;

end.
