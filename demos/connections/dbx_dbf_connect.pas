{
  DBX4 Remastered - DBF / dBase Connection Helper
  Version: 4.2026.11.09.1
}
unit dbx_dbf_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

type
  TOdbcDbfDriverType = (
    odt_dbf_auto,
    odt_dbf_msjet,
    odt_dbf_msjet_foxpro,
    odt_dbf_merant,
    odt_dbf_intersolv
  );

procedure DBFConnect(SQLConnection: TSQLConnection;
  const dbf_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True;
  OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_msjet
);

procedure DBFConnectW(SQLConnection: TSQLConnection;
  const dbf_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True;
  OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_msjet
);

function GetDbfDriverName(OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_auto): string;
function GetDbfDriver(DirectOdbc: Boolean; OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_auto): string;
function IsPresentedDbfDriver(DirectOdbc: Boolean; OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_auto): Boolean;
function GetConnectinDefaultOptions(OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_auto): string;

const
  cDbfDefaultAdditionalOptions_MsJet: string = 'MaxBufferSize=4096;MaxScanRows=16;PageTimeout=17;ReadOnly=0;SafeTransactions=1;Threads=3;UserCommitSync=Yes;';

implementation

const
  cDriverName1 = 'Microsoft dBase Driver (*.dbf)';

procedure DBFConnectCustom(SQLConnection: TSQLConnection;
  dbf_file_name: string;
  dns_name: string;
  LoginPrompt: Boolean;
  UserName: string;
  Password: string;
  AdditionalOptions: string
);
var
  sConnectionString: string;
begin
  SQLConnection.Close;
  dbf_file_name := Trim(dbf_file_name);
  dns_name := Trim(dns_name);
  if (dbf_file_name = '') and (dns_name = '') then
    Exit;

  if FileExists(dbf_file_name) then
    dbf_file_name := ExtractFilePath(dbf_file_name);
  dbf_file_name := ExcludeTrailingPathDelimiter(dbf_file_name);

  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  UserName := Trim(UserName);
  if UserName = '' then
    LoginPrompt := False;
  SQLConnection.LoginPrompt := LoginPrompt;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';

  if dns_name <> '' then
    sConnectionString := 'DSN=' + dns_name + ';'
  else
    sConnectionString := 'DRIVER={' + cDriverName1 + '};';

  if dbf_file_name <> '' then
    sConnectionString := sConnectionString + 'DefaultDir=' + dbf_file_name + ';';
  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  sConnectionString := sConnectionString + 'DriverId=533;FIL=dBase 5.0;';
  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions = '' then
    sConnectionString := sConnectionString + cDbfDefaultAdditionalOptions_MsJet
  else
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

function GetDbfDriverName(OdbcDbfDriverType: TOdbcDbfDriverType): string;
begin
  Result := cDriverName1;
end;

function GetDbfDriver(DirectOdbc: Boolean; OdbcDbfDriverType: TOdbcDbfDriverType): string;
begin
  Result := 'odbc32.dll';
end;

function IsPresentedDbfDriver(DirectOdbc: Boolean; OdbcDbfDriverType: TOdbcDbfDriverType): Boolean;
begin
  Result := True;
end;

function GetConnectinDefaultOptions(OdbcDbfDriverType: TOdbcDbfDriverType): string;
begin
  Result := cDbfDefaultAdditionalOptions_MsJet;
end;

procedure DBFConnect(SQLConnection: TSQLConnection;
  const dbf_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True;
  OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_msjet
);
begin
  DBFConnectCustom(SQLConnection, dbf_file_name, dns_name, LoginPrompt, UserName, Password, AdditionalOptions);
end;

procedure DBFConnectW(SQLConnection: TSQLConnection;
  const dbf_file_name: string;
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bAnsiStringField: Boolean = False;
  bUnicodeOdbcApi: Boolean = True;
  OdbcDbfDriverType: TOdbcDbfDriverType = odt_dbf_msjet
);
begin
  DBFConnectCustom(SQLConnection, dbf_file_name, dns_name, LoginPrompt, UserName, Password, AdditionalOptions);
end;

end.
