{
  Version: 2012.04.07
}
unit dbx_sqlite_connect;

interface

uses
  Windows, SysUtils, Classes, Registry,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

procedure SQLiteConnect(SQLConnection: TSQLConnection;
  const db_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = False;
  bAnsiStringField: Boolean = True
);

var
  sqlite3odbc_dll: string = 'sqlite3odbc.dll';

implementation

uses
  DbxXXDrv; // { critical }

//"Driver={SQLite3 ODBC Driver};Database=C:\temp\dbdemos.db;StepAPI=;SyncPragma=;NoTXN=;Timeout=;ShortNames=;LongNames=;NoCreat=;NoWCHAR=;FKSupport=;JournalMode=;LoadExt=;"

procedure SQLiteConnectCustom(SQLConnection: TSQLConnection;
  db_file_name: string;
  dns_name: string;
  DirectOdbc: Boolean;
  LoginPrompt: Boolean;
  UserName: string;
  Password: string;
  AdditionalOptions: string;
  bUnicodeOdbcApi: Boolean;
  bAnsiStringField: Boolean
);
var
  bUnicodeDriver: Boolean;
  sConnectionString: string;
begin
  SQLConnection.Close;

  db_file_name := Trim(db_file_name);
  dns_name := Trim(dns_name);

  if (db_file_name = '') and (dns_name = '') then
    Exit;

  //SQLConnection.TableScope := [tsTable];
  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;

  {$IF CompilerVersion >= 18.50} // Delphi 2007 Up
    bUnicodeDriver := True;
    if bUnicodeOdbcApi then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCWA';
    end;
  {$ELSE}
    bUnicodeDriver := False;
    if bUnicodeOdbcApi then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBC';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
    end;
  {$IFEND}
  SQLConnection.LibraryName := 'dbxoodbc.dll';

  UserName := Trim(UserName);
  if UserName = '' then
    LoginPrompt := False;

  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    DirectOdbc := False;

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
    //Values[TDBXPropertyNames.LibraryName] := 'dbxoodbc.dll';
    //Values[TDBXPropertyNames.GetDriverFunc] := SQLConnection.GetDriverFunc;
    // FOR IDE:
    //Values[TDBXPropertyNames.DriverName] := {DbxXXDrv.pas}DbxOODBCDriverName;
    //Values[TDBXPropertyNames.ProductName] := {DbxXXDrv.pas}DbxOODBCDriverProductName;
//@@@
    //Values[TDBXPropertyNames.MetaDataDisabled] := 'True'; // - disable all metadata supports

    // DBXOODBC: uses DbxXXDrv
    //
    //Values[TDBXPropertyNames.MetaDataPackageLoader] := // == 'TDBXOpenODBCMetaDataCommandFactory'
    //  TDBXOpenODBCMetaDataCommandFactory.ClassName;
    Values[TDBXPropertyNames.MetaDataPackageLoader] := // == 'TDBXOpenODBCMetaDataCommandFactorySQLite'
      TDBXOpenODBCMetaDataCommandFactorySQLite.ClassName;


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

  SQLConnection.VendorLib := 'odbc32.dll';
  if DirectOdbc then
    SQLConnection.VendorLib := sqlite3odbc_dll + ';' + SQLConnection.VendorLib;

  sConnectionString := '';

  if dns_name <> '' then
    sConnectionString := 'DSN=' + dns_name + ';'
  else
    sConnectionString := 'DRIVER={SQLite3 ODBC Driver};';

  if db_file_name <> '' then
  begin
    sConnectionString := sConnectionString
      + 'Database=' + db_file_name + ';';
  end;
  //if LoginPrompt then
  //  sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  AdditionalOptions := Trim(AdditionalOptions);
  if (AdditionalOptions <> '') and (sConnectionString <> ';') then
  begin
    if AdditionalOptions[1] = ';' then
      SetLength(sConnectionString, Length(sConnectionString)-1);
    sConnectionString := sConnectionString + AdditionalOptions;
    if sConnectionString[Length(sConnectionString)] <> ';' then
      sConnectionString := sConnectionString + ';';
  end;

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
       //outputdebugstring(pchar('### ### ###: '+SQLConnection.Params.Values[CUSTOM_INFO]));
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

procedure SQLiteConnect(SQLConnection: TSQLConnection;
  const db_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = False;
  bAnsiStringField: Boolean = True
);
begin
  SQLiteConnectCustom(SQLConnection, db_file_name, dns_name, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions,
    bUnicodeOdbcApi, bAnsiStringField);
end;

end.
