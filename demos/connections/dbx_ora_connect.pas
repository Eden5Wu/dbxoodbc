{
  Version: 2010.07.15
}
unit dbx_ora_connect;

interface

uses
  Windows, SysUtils, Classes, Registry,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

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


function IsPresentedOracleDriver(): Boolean;
function IsPresentedMicrosoftOracleDriver(): Boolean;

var
  //oracle_dbxoodbc_driver_name: string = 'DbxWOracle'; // Delphi 2009: must correspond to name in "dbxdrivers.ini".

  // Look in registry: HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI
  cDriverName1: string = 'Oracle ODBC Driver';
  cDriverName2: string = 'Oracle in 10g';

implementation

uses
  DbxXXDrv; // { critical }

function OracleBuildConnection(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;

var
  sConnectionString, sDrv: string;
begin
  //Result := False;

  SQLConnection.Close;
  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;

  {$IF CompilerVersion < 17.50}
  SQLConnection.GetDriverFunc := 'getSQLDriverODBC';
  {$ELSE}
  SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
  //SQLConnection.GetDriverFunc := 'getSQLDriverODBCWA';
  {$IFEND}
  SQLConnection.LibraryName   := 'dbxoodbc.dll';
  SQLConnection.LoginPrompt := bLoginPrompt;

  if not bMicrosoftDriver then
  begin
    sConnectionString :=
        'UID=' + UserName
      + ';PWD=' + Password
      + ';DBQ=' + TnsName
      + ';DBA=W;APA=T;FEN=T;QTO=T;FRC=10;FDL=10;LOB=T;RST=T;FRL=F;MTS=T;CSR=T;PFC=10;TLO=0'
      + ';coLockMode=-1;coSchemFlt=1;coCatPrefix=UID';
    if bDirectOdbc then
      SQLConnection.VendorLib := 'sqora32.dll';
  end
  else
  begin
    sConnectionString :=
        'UID=' + UserName
      + ';PWD=' + Password
      + ';SERVER=' + TnsName
      + ';coLockMode=-1;coSchemFlt=1;coCatPrefix=UID';
    if bDirectOdbc then
      SQLConnection.VendorLib := 'msorcl32.dll';
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
    Values[TDBXPropertyNames.MetaDataPackageLoader] := //  == 'TDBXOpenODBCMetaDataCommandFactoryOracle'
      TDBXOpenODBCMetaDataCommandFactoryOracle.ClassName;

    //@d2007 critical
    Values[TDBXPropertyNames.DriverPackageLoader] := // 'TDBXDynalinkDriverLoaderOpenOdbc'
      TDBXDynalinkDriverLoaderOpenOdbc.ClassName;
    //@test
    //  SQLConnection.Params.Values[TDBXDynalinkPropertyNames.BlobSize] := '1'; // 'BlobSize'
    {$IFEND}
    // @dbx34.

    SQLConnection.Params.Values[TRIMCHAR] := 'True';     // 'Trim Char'
    SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20'; // 'RowsetSize'
    //SQLConnection.Params.Values[PREPARESQL] := 'False'; // 'Prepare SQL'
    //SQLConnection.Params.Values[SQLConnection.DriverName + ' TransIsolation'] := 'ReadCommited';
  end;

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + ';' + AdditionalOptions;

  if not bDirectOdbc then
  begin
    SQLConnection.VendorLib := 'odbc32.dll';
    if DNS_NAME <> '' then
      sConnectionString := 'DNS=' + DNS_NAME + ';' + sConnectionString
    else
    begin
      if not bMicrosoftDriver then
        sDrv := '{Oracle ODBC Driver}'
      else
        sDrv := '{Microsoft ODBC for Oracle}';
      sConnectionString := 'DRIVER=' + sDrv + ';' + sConnectionString;
    end;
  end;

  {$IF CompilerVersion > 14.01}
     {$IF CompilerVersion >= 18.50}
       // Delphi 2007 Up
       SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
       SQLConnection.Params.Values[CONNECTION_STRING] := sConnectionString;
       //if IsDbxDrvFixed then
       //  SQLConnection.Params.Values[CUSTOM_INFO] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
     {$ELSE}
       // Delphi 2006 .. Delphi 7
       SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
       SQLConnection.Params.Values[CUSTOM_INFO] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
     {$IFEND}
  {$ELSE}
     // Delphi 6
     if IsDbxDrvFixed then
     begin
       SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
       //SQLConnection.Params.Values['Custom String'] := string(cConnectionOptionsNames[coConnectionString]) + '=' + sConnectionString;
       SQLConnection.Params.Values['ConnectionString'] := sConnectionString;
     end
     else
     begin
       if Length(sConnectionString) > 255 then
         SetLength(sConnectionString, 255); // Buffer overflow AV protect :(
       SQLConnection.Params.Values[DATABASENAME_KEY] := sConnectionString;
     end;
  {$IFEND}

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
  if Result and (not SQLConnection.Connected) then
    SQLConnection.Open;
end;

function IsPresentedOracleDriver(): Boolean;
begin
  //Result := False;
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName1, False) and
        ValueExists('Driver') then
      begin
        Result := True;
        Exit;
      end
      else if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName2, False) and
        ValueExists('Driver') then
      begin
        Result := True;
        Exit;
      end;
    finally
      Free;
    end;
  except
  end;
  Result := FileExists('sqora32.dll');
end;

function IsPresentedMicrosoftOracleDriver(): Boolean;
begin
  Result := False;
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\Microsoft ODBC for Oracle', False) and
        ValueExists('Driver') then
      begin
         Result := True;
      end;
    finally
      Free;
    end;
  except
  end;
end;

end.
