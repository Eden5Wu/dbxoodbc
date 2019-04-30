{
  Version: 2010.07.15
}
unit dbx_excel_connect;

interface

uses
  Windows, SysUtils, Classes, Registry,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

procedure ExcelConnect(SQLConnection: TSQLConnection;
  const xls_file_name: string;
  const dns_name: string = '';
  bAutoCreate: Boolean = True;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = False;
  bAnsiStringField: Boolean = True;
  bUnicodeDriver: Boolean = False
);

procedure ExcelConnectW(SQLConnection: TSQLConnection;
  const xls_file_name: string;
  const dns_name: string = '';
  bAutoCreate: Boolean = True;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True
);

function GetExcelDriverName: string;
function GetExcelDriver(DirectOdbc: Boolean): string;
function IsPresentedExcelDriver(DirectOdbc: Boolean): Boolean;

const
  cExcelDefaultAdditionalOptions: string = 'MaxBufferSize=4096;MaxScanRows=16;PageTimeout=17;ReadOnly=0;SafeTransactions=1;Threads=3;UserCommitSync=Yes;coCatPrefix=DBQ';
  // FIL=excel 8.0;UID=admin;
//var
//  excel_dbxoodbc_driver_name: string = 'DbxWMSJetExcel'; // Delphi 2009: must correspond to name in "dbxdrivers.ini".

implementation

uses
  DbxXXDrv; // { critical }

(*********************************
 *** Excel Connection Strings ***:
 *********************************

 Excel:OdbcExplor:Connection String:
   VendorLib=odbcjt32.dll;DRIVER={Microsoft Excel Driver (*.xls)};DBQ=..\DBMS\EXCEL\dbdemos.xls;DefaultDir=..\DBMS\EXCEL;DriverId=790;MaxBufferSize=4096;PageTimeout=17;;ReadOnly=0;SafeTransactions=1;Threads=3;UserCommitSync=Yes;coCatPrefix=DBQ
   DBQ=..\DBMS\EXCEL\dbdemos.xls;DefaultDir=..\DBMS\EXCEL;Driver={Driver do Microsoft Excel(*.xls)};DriverId=790;FIL=excel 8.0;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\MS Excel.dsn;MaxBufferSize=4096;MaxScanRows=16;PageTimeout=17;ReadOnly=0;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;

 Excel:OLEDB:ODBC: Connection String:
   rsConnString_MSODBCExcel = 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="'
     + 'DRIVER=Microsoft Excel Driver (*.xls);CREATE_DB=%s;DBQ=%s;DefaultDir=%s;DriverId=790;'
     + 'FIL=excel 8.0;MaxBufferSize=2048;PageTimeout=5;ReadOnly=0;"';

*********************************)

const
  // Look in registry: HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI
  cDriverName1 = 'Microsoft Excel Driver (*.xls)';
  cDriverName2 = 'Microsoft Excel-Treiber (*.xls)';

procedure ExcelConnectCustom(SQLConnection: TSQLConnection;
  xls_file_name: string;
  dns_name: string;
  bAutoCreate: Boolean;
  DirectOdbc: Boolean;
  LoginPrompt: Boolean;
  UserName: string;
  Password: string;
  AdditionalOptions: string;
  bAnsiStringField: Boolean;
  bUnicodeOdbcApi: Boolean;
  bUnicodeDriver: Boolean
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;

  xls_file_name := Trim(xls_file_name);
  dns_name := Trim(dns_name);

  if (xls_file_name = '') and (dns_name = '') then
    Exit;

  SQLConnection.TableScope := [tsTable];

  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;
  if bUnicodeDriver then
  begin
    if bUnicodeOdbcApi then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCWA';
    end;
  end
  else
  begin
    if not bUnicodeOdbcApi then
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBC';
    end
    else
    begin
      SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
    end;
  end;
  SQLConnection.LibraryName := 'dbxoodbc.dll';

  UserName := Trim(UserName);
  if UserName = '' then
    LoginPrompt := False;

  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    DirectOdbc := False;

  SQLConnection.VendorLib := GetExcelDriver(DirectOdbc);
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

  if DirectOdbc and (SQLConnection.VendorLib = '') then
  begin
    DirectOdbc := False;
    SQLConnection.VendorLib := GetExcelDriver(DirectOdbc);
  end;

  sConnectionString := '';

  if dns_name <> '' then
    sConnectionString := 'DSN=' + xls_file_name + ';'
  else
    sConnectionString := 'DRIVER={' + GetExcelDriverName + '};';

  if xls_file_name <> '' then
  begin
    if bAutoCreate and not FileExists(xls_file_name) then
      sConnectionString := sConnectionString + 'CREATE_DB=' + xls_file_name + ';';
    sConnectionString := sConnectionString + 'DBQ=' + xls_file_name + ';'
      + 'DefaultDir=' + ExtractFilePath(xls_file_name) + ';';
  end;
  if LoginPrompt then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  sConnectionString := sConnectionString + 'DriverId=790;';

  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions = '' then
    sConnectionString := sConnectionString + cExcelDefaultAdditionalOptions
  else
    sConnectionString := sConnectionString + AdditionalOptions;

  if bUnicodeDriver then
  begin
    if bAnsiStringField then
      sConnectionString := sConnectionString + ';coEnableUnicode=0;';
  end
  else
  begin
    //
    // DBX2 not supported TWideStringField
    //
    //if not bAnsiStringField then
    //  sConnectionString := sConnectionString + ';coEnableUnicode=1;';

    sConnectionString := sConnectionString + ';coEnableUnicode=0;';
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

  SQLConnection.Open;
end;

function GetExcelDriver(DirectOdbc: Boolean): string;
begin
  if DirectOdbc then
  begin
    try
      with TRegistry.Create(KEY_READ) do
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName1, False) and
          ValueExists('Driver') then
        begin
          Result := ReadString('Driver');
          Exit;
        end
        else if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName2, False) and
          ValueExists('Driver') then
        begin
          Result := ReadString('Driver');
          Exit;
        end;
      finally
        Free;
        if not FileExists(Result) then
        begin
          // todo: expand env like %WINDIR%
          Result := 'odbcjt32.dll';
        end;
      end;
    except
      // Access denied to HKEY_LOCAL_MACHINE
      Result := 'odbcjt32.dll';
      Exit;
    end;
  end;
  Result := 'odbc32.dll';
end;

function GetExcelDriverName: string;
begin
  begin
    try
      with TRegistry.Create(KEY_READ) do
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName1, False) and
          ValueExists('Driver') then
        begin
          Result := cDriverName1;
          Exit;
        end
        else if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName2, False) and
          ValueExists('Driver') then
        begin
          Result := cDriverName2;
          Exit;
        end;
      finally
        Free;
      end;
    except
      // Access denied to HKEY_LOCAL_MACHINE
      Result := cDriverName1;
      Exit;
    end;
  end;
  Result := cDriverName1;
end;

function IsPresentedExcelDriver(DirectOdbc: Boolean): Boolean;
var
  S: string;
begin
  S := GetExcelDriver(DirectOdbc);
  Result := (S <> '') and FileExists(S);
end;

procedure ExcelConnect;//(SQLConnection: TSQLConnection;
//  const xls_file_name: string;
//  const dns_name: string = '';
//  bAutoCreate: Boolean = True;
//  DirectOdbc: Boolean = True;
//  LoginPrompt: Boolean = False;
//  UserName: string = '';
//  Password: string = '';
//  const AdditionalOptions: string = '';
//  bUnicodeOdbcApi: Boolean = False;
//  bAnsiStringField: Boolean = True;
//  bUnicodeDriver: Boolean = False
//);
begin
  ExcelConnectCustom(SQLConnection, xls_file_name, dns_name, bAutoCreate, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions,
    bAnsiStringField, bUnicodeOdbcApi, bUnicodeDriver);
end;

procedure ExcelConnectW;//(SQLConnection: TSQLConnection;
//  const xls_file_name: string;
//  const dns_name: string = '';
//  bAutoCreate: Boolean = True;
//  DirectOdbc: Boolean = True;
//  LoginPrompt: Boolean = False;
//  UserName: string = '';
//  Password: string = '';
//  const AdditionalOptions: string = '';
//  bAnsiStringField: Boolean = False;
//  bUnicodeOdbcApi: Boolean = True
//);
begin
  ExcelConnectCustom(SQLConnection, xls_file_name, dns_name, bAutoCreate, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions,
    bAnsiStringField, bUnicodeOdbcApi, {bUnicodeDriver} True);
end;

end.
