{
  DBX4 Remastered - Oracle Connection Helper
  Version: 4.2026.11.02
}
unit dbx_ora_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

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
  cDriverName1: string = 'Oracle ODBC Driver';
  cDriverName2: string = 'Oracle in 10g';

implementation

function OracleBuildConnection(SQLConnection: TSQLConnection;
  const TnsName, UserName, Password: string;
  bMicrosoftDriver: Boolean = False;
  bDirectOdbc: Boolean = True;
  bLoginPrompt: Boolean = False;
  const DNS_NAME: string = '';
  const AdditionalOptions: string = ''
): Boolean;
var
  sConnectionString: string;
begin
  SQLConnection.Close;
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := bLoginPrompt;

  if not bMicrosoftDriver then
    sConnectionString := 'DRIVER={' + cDriverName1 + '};UID=' + UserName + ';PWD=' + Password + ';DBQ=' + TnsName
  else
    sConnectionString := 'DRIVER={Microsoft ODBC for Oracle};UID=' + UserName + ';PWD=' + Password + ';SERVER=' + TnsName;

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + DNS_NAME + ';' + sConnectionString;

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + ';' + AdditionalOptions;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

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
  if Result then
    SQLConnection.Open;
end;

function IsPresentedOracleDriver(): Boolean;
begin
  Result := True;
end;

function IsPresentedMicrosoftOracleDriver(): Boolean;
begin
  Result := True;
end;

end.
