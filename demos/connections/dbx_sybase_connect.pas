{
  Version: 2011.11.18
}
unit dbx_sybase_connect;

interface

uses
  Windows, SysUtils, Classes, Registry,
  {$IF CompilerVersion > 17.00}
  WideStrings,
  {$IFEND}
  DbxOpenOdbcInterface, SqlConst, SqlExpr;

type
  TSybaseServerType = (sstUnknown, sstASE11, sstASA8, sstASA7);

procedure SybaseConnect(SQLConnection: TSQLConnection;
  SybaseServerType: TSybaseServerType;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
);

function GetSybaseDriver(SybaseServerType: TSybaseServerType): string;
function IsPresentedSybaseDriver(SybaseServerType: TSybaseServerType): Boolean;
function GetSybaseDriverName(SybaseServerType: TSybaseServerType): string;

implementation

uses
  DbxXXDrv; // { critical }

// Adaptive Server Anywhere 8
//"Driver={Adaptive Server Anywhere 8.0};ServerName=abaci;DBN=abaci;UID=PSIREAD;PWD=READONLY;links=tcpip()"

// Sybase System 11
// DSN=PSI;UID=PSIREAD;PWD=HAUSER;SRVR=PSI;DB=PSI

procedure SybaseConnect(SQLConnection: TSQLConnection;
  SybaseServerType: TSybaseServerType;
  const ServerName, DatabaseName, UserName, Password: string;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
);

var
  sConnectionString: string;
begin
  SQLConnection.Close;

  SQLConnection.DriverName := {DbxXXDrv.pas}DbxOODBCDriverName;
  {$IF CompilerVersion < 17.50}
  SQLConnection.GetDriverFunc := 'getSQLDriverODBC';
  //SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
  {$ELSE}
  SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
  //SQLConnection.GetDriverFunc := 'getSQLDriverODBCWA';
  {$IFEND}
  SQLConnection.LibraryName := 'dbxoodbc.dll';
  sConnectionString :=
       'UID=' + UserName
    + ';PWD=' + Password;

  SQLConnection.LoginPrompt := LoginPrompt;

  if DirectOdbc then
  begin
    if SybaseServerType = sstUnknown then
      DirectOdbc := False;
    {
    els if DNS_NAME <> '' then
      DirectOdbc := False;
    {}
  end;
  if (SybaseServerType = sstUnknown) and (DNS_NAME = '') then
    raise Exception.Create('Undefined parameter DNS_NAME');

  if DirectOdbc then
    SQLConnection.VendorLib := 'odbc32.dll'
  else
    SQLConnection.VendorLib := GetSybaseDriver(SybaseServerType);

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
    if SybaseServerType in [sstASA8, sstASA7] then
      Values[TDBXPropertyNames.MetaDataPackageLoader] := //  == 'TDBXOpenODBCMetaDataCommandFactorySybaseASA'
        TDBXOpenODBCMetaDataCommandFactorySybaseASA.ClassName
    else
      Values[TDBXPropertyNames.MetaDataPackageLoader] := //  == 'TDBXOpenODBCMetaDataCommandFactorySybaseASE'
        TDBXOpenODBCMetaDataCommandFactorySybaseASE.ClassName;

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

  SQLConnection.Params.Values['Trim Char'] := 'True';
  SQLConnection.Params.Values['RowsetSize'] := '20';
  //SQLConnection.Params.Values[SQLConnection.DriverName + ' TransIsolation'] := 'ReadCommited';
  //SQLConnection.Params.Values['Prepare SQL'] := 'False';

  case SybaseServerType of
    sstUnknown, sstASE11:
      begin
        if ServerName <> '' then
          sConnectionString := sConnectionString + ';SRVR=' + ServerName;

        if DatabaseName <> '' then
          sConnectionString := sConnectionString + ';DB=' + DatabaseName;

        sConnectionString := sConnectionString + ';' + 'coCatPrefix=DB';
      end;
    sstASA7, sstASA8:
      begin
        if ServerName <> '' then
          sConnectionString := sConnectionString + ';ServerName=' + ServerName;

        if DatabaseName <> '' then
          sConnectionString := sConnectionString + ';DBN=' + DatabaseName;

        sConnectionString := sConnectionString + ';links=tcpip();' + 'coCatPrefix=DBN';
      end;
    else
      raise Exception.Create('Unsupported Sybase server type');
  end;

  if DirectOdbc then
  begin
    sConnectionString := 'DRIVER={' + GetSybaseDriverName(SybaseServerType) + '};' + sConnectionString;
  end
  else
  begin
    if DNS_NAME <> '' then
      sConnectionString := 'DNS=' + DNS_NAME + ';' + sConnectionString
    else
      sConnectionString := 'DRIVER={' + GetSybaseDriverName(SybaseServerType) + '};' + sConnectionString;
  end;

  //OutputDebugString(PAnsiChar('*** VendorLibrary: '+ SQLConnection.VendorLib));
  //OutputDebugString(PAnsiChar('*** ConnectionString: '+ sConnectionString));

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

function GetSybaseDriverName(SybaseServerType: TSybaseServerType): string;
begin
  case SybaseServerType of
    sstUnknown:
      Result := '';
    sstASE11:
      Result := 'Sybase System 11';
    sstASA8:
      Result := 'Adaptive Server Anywhere 8.0';
    sstASA7:
      Result := 'Adaptive Server Anywhere 7.0';
    else
      raise Exception.Create('Unsupported Sybase server type');
  end;
end;

function GetSybaseDriver(SybaseServerType: TSybaseServerType): string;
var
  sDriverName: string;
begin
  if SybaseServerType = sstUnknown then
  begin
    Result := 'odbc32.dll';
    Exit;
  end;
  Result := '';
  sDriverName := GetSybaseDriverName(SybaseServerType);
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\ODBC\ODBCINST.INI\' + sDriverName, False) and
        ValueExists('Driver') then
      begin
        Result := ReadString('Driver');
        // todo: expand env like %WINDIR%
        Exit;
      end;
    finally
      Free;
    end;
  except
    // access denied to HKEY_LOCAL_MACHINE
  end;
  case SybaseServerType of
    //sstUnknown:
    //  Result := 'odbc32.dll';
    sstASE11:
      Result := 'sysybnt.dll';
    sstASA8:
      Result := 'dbodbc8.dll';
    sstASA7:
      Result := 'dbodbc7.dll';
    else
      raise Exception.Create('Unsupported Sybase server type');
  end;
end;

function IsPresentedSybaseDriver(SybaseServerType: TSybaseServerType): Boolean;
begin
  Result := FileExists(GetSybaseDriver(SybaseServerType));
end;

end.
