{
  Version: 2010.08.08
}
unit dbx_access_connect;

interface

uses
  Windows, SysUtils, Classes, Registry, DBXDynalink,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

procedure AccessConnect(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = False;
  bAnsiStringField: Boolean = True;
  bUnicodeDriver: Boolean = False
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
  cAccessDefaultAdditionalOptions: string = 'MaxBufferSize=2048;PageTimeout=17;coSafeMode=1;coBlobFragmntns=1';

implementation

uses
  DbxXXDrv; // { critical }

// DRIVER={Microsoft Access Driver (*.mdb)};DBQ=C:\CVS\D_10\dbxoodbc\dbExprStress\dbstress.mdb;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=17;coSafeMode=1;coBlobFragmntns=1

procedure AccessConnectCustom(SQLConnection: TSQLConnection;
  mdb_file_name: string;
  DNS_NAME: string;
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

  mdb_file_name := Trim(mdb_file_name);
  DNS_NAME := Trim(DNS_NAME);

  if (mdb_file_name = '') and (DNS_NAME = '') then
    Exit;

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
  SQLConnection.LibraryName   := 'dbxoodbc.dll';

  UserName := Trim(UserName);
  if UserName = '' then
    LoginPrompt := False;

  SQLConnection.LoginPrompt := LoginPrompt;

  if DNS_NAME <> '' then
    DirectOdbc := False;

  SQLConnection.VendorLib := GetAccessDriver(DirectOdbc);
  if DirectOdbc and (SQLConnection.VendorLib = '') then
  begin
    DirectOdbc := False;
    SQLConnection.VendorLib := GetAccessDriver(DirectOdbc);
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

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + mdb_file_name + ';'
  else
    sConnectionString := 'DRIVER={Microsoft Access Driver (*.mdb)};';
  //if not DirectOdbc then
  //  sConnectionString := 'DRIVER={Microsoft Access Driver (*.mdb)};';

  if mdb_file_name <> '' then
    sConnectionString := sConnectionString + 'DBQ=' + mdb_file_name + ';';
  if LoginPrompt then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  sConnectionString := sConnectionString + 'DriverId=25;FIL=MS Access;';
  // optional:
  sConnectionString := sConnectionString + 'coEmptyStrParam=1;'; // allow update empty string '' as NULL
  // optional.

  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions = '' then
    sConnectionString := sConnectionString + cAccessDefaultAdditionalOptions
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

  SQLConnection.Params.Values[VENDORLIB_KEY] := SQLConnection.VendorLib;

  SQLConnection.Open;
end;

function GetAccessDriver(DirectOdbc: Boolean): string;
const
  cDriverName = 'Microsoft Access Driver (*.mdb)';
begin
  if DirectOdbc then
  begin
    try
      with TRegistry.Create(KEY_READ) do
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if Is64BitWindows then
        begin
          if OpenKey('SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\' + cDriverName, False) and
            ValueExists('Driver') then
          begin
            Result := ReadString('Driver');
            if not FileExists(Result) then
            begin
              // todo: expand env like %WINDIR%
              Result := 'odbcjt32.dll';
            end;
            Exit;
          end;
        end else
        begin
          if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + cDriverName, False) and
            ValueExists('Driver') then
          begin
            Result := ReadString('Driver');
            if not FileExists(Result) then
            begin
              // todo: expand env like %WINDIR%
              Result := 'odbcjt32.dll';
            end;
            Exit;
          end;
        end;
      finally
        Free;
      end;
    except
      // access denied to HKEY_LOCAL_MACHINE
      Result := 'odbcjt32.dll';
      Exit;
    end;
  end;
  Result := 'odbc32.dll';
end;

function IsPresentedAccessDriver(DirectOdbc: Boolean): Boolean;
var
  S: string;
begin
  S := GetAccessDriver(DirectOdbc);
  Result := (S <> '') and FileExists(S);
end;

procedure AccessConnect;//(SQLConnection: TSQLConnection;
//  const mdb_file_name: string;
//  const DNS_NAME: string = '';
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
  AccessConnectCustom(SQLConnection, mdb_file_name, DNS_NAME, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions,
    bAnsiStringField, bUnicodeOdbcApi, bUnicodeDriver);
end;

procedure AccessConnectW;//(SQLConnection: TSQLConnection;
//  const mdb_file_name: string;
//  const DNS_NAME: string = '';
//  DirectOdbc: Boolean = True;
//  LoginPrompt: Boolean = False;
//  UserName: string = '';
//  Password: string = '';
//  const AdditionalOptions: string = '';
//  bAnsiStringField: Boolean = False;
//  bUnicodeOdbcApi: Boolean = True
//);
begin
  AccessConnectCustom(SQLConnection, mdb_file_name, DNS_NAME, DirectOdbc,
    LoginPrompt, UserName, Password, AdditionalOptions,
    bAnsiStringField, bUnicodeOdbcApi, {bUnicodeDriver} True);
end;


function Is64BitWindows: Boolean;
type
  TIsWow64Process = function(hProcess: THandle; var Wow64Process: BOOL): BOOL;
    stdcall;
var
  DLLHandle: THandle;
  pIsWow64Process: TIsWow64Process;
  IsWow64: BOOL;
begin
  Result := False;
  DllHandle := LoadLibrary('kernel32.dll');
  if DLLHandle <> 0 then begin
    pIsWow64Process := GetProcAddress(DLLHandle, 'IsWow64Process');
    Result := Assigned(pIsWow64Process)
      and pIsWow64Process(GetCurrentProcess, IsWow64) and IsWow64;
    FreeLibrary(DLLHandle);
  end;
end;

end.
