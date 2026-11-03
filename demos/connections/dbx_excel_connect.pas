{
  DBX4 Remastered - MS Excel Connection Helper
  Version: 4.2026.11.02
}
unit dbx_excel_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure ExcelConnect(SQLConnection: TSQLConnection;
  const xls_file_name: string;
  const dns_name: string = '';
  bAutoCreate: Boolean = True;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True
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
  cExcelDefaultAdditionalOptions: string = 'MaxBufferSize=4096;MaxScanRows=16;PageTimeout=17;ReadOnly=0;SafeTransactions=1;Threads=3;UserCommitSync=Yes;';

implementation

const
  cDriverName1 = 'Microsoft Excel Driver (*.xls)';

procedure ExcelConnectCustom(SQLConnection: TSQLConnection;
  xls_file_name: string;
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
  xls_file_name := Trim(xls_file_name);
  dns_name := Trim(dns_name);
  if (xls_file_name = '') and (dns_name = '') then
    Exit;

  SQLConnection.TableScope := [tsTable];
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

  if xls_file_name <> '' then
    sConnectionString := sConnectionString + 'DBQ=' + xls_file_name + ';DefaultDir=' + ExtractFilePath(xls_file_name) + ';';
  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';

  sConnectionString := sConnectionString + 'DriverId=790;';
  AdditionalOptions := Trim(AdditionalOptions);
  if AdditionalOptions = '' then
    sConnectionString := sConnectionString + cExcelDefaultAdditionalOptions
  else
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

function GetExcelDriver(DirectOdbc: Boolean): string;
begin
  Result := 'odbc32.dll';
end;

function GetExcelDriverName: string;
begin
  Result := cDriverName1;
end;

function IsPresentedExcelDriver(DirectOdbc: Boolean): Boolean;
begin
  Result := True;
end;

procedure ExcelConnect(SQLConnection: TSQLConnection;
  const xls_file_name: string;
  const dns_name: string = '';
  bAutoCreate: Boolean = True;
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = True;
  bAnsiStringField: Boolean = False;
  bUnicodeDriver: Boolean = True
);
begin
  ExcelConnectCustom(SQLConnection, xls_file_name, dns_name, LoginPrompt, UserName, Password, AdditionalOptions);
end;

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
begin
  ExcelConnectCustom(SQLConnection, xls_file_name, dns_name, LoginPrompt, UserName, Password, AdditionalOptions);
end;

end.
