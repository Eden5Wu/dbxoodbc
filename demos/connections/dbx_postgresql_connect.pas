{
  Version: 2012.04.10
}
unit dbx_postgresql_connect;

interface

uses
  Windows, SysUtils, Classes, Registry,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

procedure PostgreSQLConnect(SQLConnection: TSQLConnection;
  const database, server, port: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = True;
  bUnicodeOdbcApi: Boolean = False
);

function GetDirectPostgreSqlOdbcDriverName(): string;
function GetDirectPostgreSqlDriver(DirectOdbc: Boolean = True): string;

var
  psqlodbc_dll: string = 'psqlodbc.dll';
  psqlodbca_dll: string = 'psqlodbc30a.dll';
  psqlodbcw_dll: string = 'psqlodbc35w.dll';

implementation

uses
  DbxXXDrv; // { critical }

//DRIVER={PostgreSQL ODBC Driver(UNICODE)};DATABASE=dbdemos_utf8;SERVER=127.0.0.1;PORT=5432;UID=postgres;PWD=***
//DRIVER={PostgreSQL ODBC Driver(ANSI)};DATABASE=dbdemos_utf8;SERVER=127.0.0.1;PORT=5432;UID=postgres;PWD=***
//"Driver={PostgreSQL ODBC Driver(UNICODE)};DATABASE=dbdemos_win1250;SERVER=127.0.0.1;PORT=5432;UID=dba;PWD=1234;ReadOnly=0;Protocol=6.4;FakeOidIndex=0;ShowOidColumn=0;RowVersioning=0;ShowSystemTables=0;ConnSettings=;Fetch=100;Socket=4096;UnknownSizes=0;MaxVarcharSize=2048;MaxLongVarcharSize=8190;Debug=0;CommLog=0;Optimizer=1;Ksqo=1;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=0;BoolsAsChar=1;Parse=0;CancelAsFreeStmt=0;ExtraSysTablePrefixes=dd_;;LFConversion=1;UpdatableCursors=0;DisallowPremature=0;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=0;UseServerSidePrepare=0
//DSN=PostgreSQL30;DATABASE=dbdemos_utf8;SERVER=127.0.0.1;PORT=5432;UID=postgres;SSLmode=disable;ReadOnly=0;Protocol=7.4;FakeOidIndex=0;ShowOidColumn=0;RowVersioning=0;ShowSystemTables=0;ConnSettings=;Fetch=100;Socket=4096;UnknownSizes=0;MaxVarcharSize=255;MaxLongVarcharSize=8190;Debug=0;CommLog=0;Optimizer=0;Ksqo=1;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=0;BoolsAsChar=1;Parse=0;CancelAsFreeStmt=0;ExtraSysTablePrefixes=dd_;;LFConversion=1;UpdatableCursors=1;DisallowPremature=0;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=0;UseServerSidePrepare=0;LowerCaseIdentifier=0;GssAuthUseGSS=0;XaOpt=1
//DSN=PostgreSQL30;DATABASE=dbdemos_utf8;SERVER=127.0.0.1;PORT=5432;UID=postgres;PWD=***;SSLmode=disable;ReadOnly=0;Protocol=7.4-1;FakeOidIndex=0;ShowOidColumn=1;RowVersioning=0;ShowSystemTables=0;ConnSettings=;Fetch=100;Socket=4096;UnknownSizes=0;MaxVarcharSize=255;MaxLongVarcharSize=8190;Debug=1;CommLog=0;Optimizer=0;Ksqo=1;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=1;BoolsAsChar=0;Parse=0;CancelAsFreeStmt=0;ExtraSysTablePrefixes=dd_;;LFConversion=1;UpdatableCursors=1;DisallowPremature=0;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=0;UseServerSidePrepare=0;LowerCaseIdentifier=0;GssAuthUseGSS=0;XaOpt=1
//"Driver={PostgreSQL ODBC Driver};DATABASE=dbdemos_win1250;SERVER=127.0.0.1;PORT=5432;UID=dba;PWD=1234;ReadOnly=0;Protocol=6.4;FakeOidIndex=0;ShowOidColumn=0;RowVersioning=0;ShowSystemTables=0;ConnSettings=;Fetch=100;Socket=4096;UnknownSizes=0;MaxVarcharSize=2048;MaxLongVarcharSize=8190;Debug=0;CommLog=0;Optimizer=1;Ksqo=1;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=0;BoolsAsChar=1;Parse=0;CancelAsFreeStmt=0;ExtraSysTablePrefixes=dd_;;LFConversion=1;UpdatableCursors=0;DisallowPremature=0;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=0;UseServerSidePrepare=0
//
//[HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\PostgreSQL ODBC Driver(UNICODE)]
//"Driver"="C:\\programs\\dev\\db\\PostgreSQL\\odbc\\0900\\bin\\psqlodbc35w.dll"
//[HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\PostgreSQL ODBC Driver(ANSI)]
//"Driver"="C:\\programs\\dev\\db\\PostgreSQL\\odbc\\0900\\bin\\psqlodbc30a.dll"

function DoGetDirectPostgreSqlOdbcDriverName(AUnicodeDriver: Boolean): string;
var
  sReg0, sReg1, sReg2: string;
begin
  sReg0 := 'PostgreSQL ODBC Driver';
  if AUnicodeDriver then
  begin
    sReg1 := '(UNICODE)';
    sReg2 := '(ANSI)';
  end
  else
  begin
    sReg1 := '(ANSI)';
    sReg2 := '(UNICODE)';
  end;
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0 + sReg1, False) and
        ValueExists('Driver') then
      begin
        Result := sReg0 + sReg1;
        Exit;
      end;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0 + sReg2, False) and
        ValueExists('Driver') then
      begin
        Result := sReg0 + sReg2;
        Exit;
      end;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0, False) and
        ValueExists('Driver') then
      begin
        Result := sReg0;
        Exit;
      end;
    finally
      Free;
    end;
  except
  end;
  //
  if AUnicodeDriver then
    Result := sReg0 + sReg1
  else
    Result := sReg0 + sReg0;
end;

function DoGetDirectPostgreSqlDriver(AUnicodeDriver: Boolean): string;
var
  sReg0, sReg1, sReg2: string;
  sDll1, sDll2, sDll3: string;
begin
  try
    sReg0 := 'PostgreSQL ODBC Driver';
    //sDll0 := psqlodbc_dll;
    if AUnicodeDriver then
    begin
      sReg1 := '(UNICODE)';
      sReg2 := '(ANSI)';
      sDll1 := psqlodbcw_dll;
      sDll2 := psqlodbca_dll;
      sDll3 := psqlodbc_dll;
    end
    else
    begin
      sReg1 := '(ANSI)';
      sReg2 := '(UNICODE)';
      sDll1 := psqlodbca_dll;
      sDll2 := psqlodbc_dll;
      sDll3 := psqlodbcw_dll;
    end;
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0 + sReg1, False) and
        ValueExists('Driver') then
      begin
        Result := Trim(ReadString('Driver'));
        // todo: expand env like %WINDIR%
        if FileExists(Result) then
        begin
          Result := Result + ';' + sDll1 + ';' + sDll2 + ';' + sDll3 + ';odbc32.dll';
          Exit;
        end;
      end;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0 + sReg2, False) and
        ValueExists('Driver') then
      begin
        Result := Trim(ReadString('Driver'));
        // todo: expand env like %WINDIR%
        if FileExists(Result) then
        begin
          Result := Result + ';' + sDll1 + ';' + sDll2 + ';' + sDll3 + ';odbc32.dll';
          Exit;
        end;
      end;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sReg0, False) and
        ValueExists('Driver') then
      begin
        Result := Trim(ReadString('Driver'));
        // todo: expand env like %WINDIR%
        if FileExists(Result) then
        begin
          Result := Result + ';' + sDll1 + ';' + sDll2 + ';' + sDll3+ ';odbc32.dll';
          Exit;
        end;
      end;
    finally
      Free;
    end;
  except
  end;
  //
  Result := sDll1 + ';' + sDll2 + ';' + sDll3 + ';odbc32.dll';
end;

function IsUnicodeDriver(): Boolean;
begin
  {$IF CompilerVersion >= 18.50} // Delphi 2007 Up
  Result := True;
  {$ELSE}
  Result := False;
  {$IFEND}
end;

function GetDirectPostgreSqlOdbcDriverName(): string;
begin
  Result := DoGetDirectPostgreSqlOdbcDriverName(IsUnicodeDriver());
end;

function GetDirectPostgreSqlDriver(DirectOdbc: Boolean): string;
begin
  if DirectOdbc then
    Result := DoGetDirectPostgreSqlDriver(IsUnicodeDriver())
  else
    Result := 'odbc32.dll';
end;

function GetDriverFunc(AUnicodeOdbcApi: Boolean): string;
begin
  {$IF CompilerVersion >= 18.50} // Delphi 2007 Up
  if AUnicodeOdbcApi then
    Result := 'getSQLDriverODBCW'
  else
    Result := 'getSQLDriverODBCWA';
  {$ELSE}
  if AUnicodeOdbcApi then
    Result := 'getSQLDriverODBC'
  else
    Result := 'getSQLDriverODBCAW';
  {$IFEND}
end;

procedure PostgreSQLConnectCustom(SQLConnection: TSQLConnection;
  database, server, port: string;
  dns_name: string;
  DirectOdbc: Boolean;
  LoginPrompt: Boolean;
  UserName: string;
  Password: string;
  ReadOnly: Boolean;
  AdditionalOptions: string;
  bAnsiStringField: Boolean;
  bUnicodeOdbcApi: Boolean
);
var
  bUnicodeDriver: Boolean;
  sConnectionString: string;
begin
  SQLConnection.Close;

  database := Trim(database);
  dns_name := Trim(dns_name);

  if (database = '') and (dns_name = '') then
    Exit;

  //SQLConnection.TableScope := [tsTable];
  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;

  bUnicodeDriver := IsUnicodeDriver();
  SQLConnection.GetDriverFunc := GetDriverFunc(bUnicodeOdbcApi);

  SQLConnection.LibraryName := 'dbxoodbc.dll';

  UserName := Trim(UserName);
  //if UserName = '' then
  //  LoginPrompt := True;

  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    DirectOdbc := False;

  if DirectOdbc then
    SQLConnection.VendorLib := DoGetDirectPostgreSqlDriver(bUnicodeDriver)
  else
    SQLConnection.VendorLib := 'odbc32.dll';
  //outputdebugstring(pchar('VendorLib='+SQLConnection.VendorLib));

  with SQLConnection.Params do
  begin
    Clear;
    // @dbx34:
    {$IF CompilerVersion >= 18.50} // Delphi 2007 Up

    // DBXOODBC: uses DbxXXDrv
    //
    //Values[TDBXPropertyNames.MetaDataPackageLoader] := // == 'TDBXOpenODBCMetaDataCommandFactory'
    //  TDBXOpenODBCMetaDataCommandFactory.ClassName;
    Values[TDBXPropertyNames.MetaDataPackageLoader] := // == 'TDBXOpenODBCMetaDataCommandFactoryPostgreSQL'
      TDBXOpenODBCMetaDataCommandFactoryPostgreSQL.ClassName;
    //
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

  sConnectionString := '';

  if dns_name <> '' then
    sConnectionString := 'DSN=' + dns_name + ';'
  else
    sConnectionString := 'DRIVER={' + DoGetDirectPostgreSqlOdbcDriverName(bUnicodeDriver) + '};';

  if database <> '' then
  begin
    sConnectionString := sConnectionString
      + 'DATABASE=' + database + ';';
  end;
  if server <> '' then
  begin
    sConnectionString := sConnectionString
      + 'SERVER=' + server + ';';
  end;
  if port <> '' then
  begin
    sConnectionString := sConnectionString
      + 'PORT=' + port + ';';
  end;
  if UserName <> '' then
  begin
    sConnectionString := sConnectionString
      + 'UID=' + UserName
      + ';PWD=' + Password + ';';
  end;
  if ReadOnly then
  begin
    sConnectionString := sConnectionString
      + 'ReadOnly=1;';
  end;
  //if ShowSystemTables then
  //begin
  //  sConnectionString := sConnectionString
  //    + 'ShowSystemTables=1;';
  //end;
  //
  //sConnectionString := sConnectionString
  //  + 'UpdatableCursors=1;';
  //
  //sConnectionString := sConnectionString
  //  + 'UseServerSidePrepare=1;';
  //if LoginPrompt then
  //  sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions <> '' then
  begin
    sConnectionString := sConnectionString + AdditionalOptions;
    if sConnectionString[Length(sConnectionString)] <> ';' then
      sConnectionString := sConnectionString + ';';
  end;
  //
  if bUnicodeDriver then
  begin
    if bAnsiStringField then
      sConnectionString := sConnectionString + 'coEnableUnicode=0;';
  end
  else
  begin
    //
    // DBX2 not supported TWideStringField
    //
    //if not bAnsiStringField then
    //  sConnectionString := sConnectionString + ';coEnableUnicode=1;';

    sConnectionString := sConnectionString + 'coEnableUnicode=0;';
  end;
  //
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

  SQLConnection.Open;
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
  bAnsiStringField: Boolean = True;
  bUnicodeOdbcApi: Boolean = False
);
begin
  PostgreSQLConnectCustom(SQLConnection, database, server, port, dns_name, DirectOdbc,
    LoginPrompt, UserName, Password, ReadOnly, AdditionalOptions,
    bAnsiStringField, bUnicodeOdbcApi);
end;

end.
