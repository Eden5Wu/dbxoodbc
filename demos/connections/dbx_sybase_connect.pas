{
  DBX4 Remastered - Sybase Connection Helper
  Version: 4.2026.11.05
}
unit dbx_sybase_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

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
  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if DNS_NAME <> '' then
    sConnectionString := 'DSN=' + DNS_NAME + ';'
  else
    sConnectionString := 'DRIVER={' + GetSybaseDriverName(SybaseServerType) + '};';

  if ServerName <> '' then
    sConnectionString := sConnectionString + 'ServerName=' + ServerName + ';';
  if DatabaseName <> '' then
    sConnectionString := sConnectionString + 'DBN=' + DatabaseName + ';';
  if UserName <> '' then
    sConnectionString := sConnectionString + 'UID=' + UserName + ';PWD=' + Password + ';';
  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

function GetSybaseDriver(SybaseServerType: TSybaseServerType): string;
begin
  Result := 'odbc32.dll';
end;

function IsPresentedSybaseDriver(SybaseServerType: TSybaseServerType): Boolean;
begin
  Result := True;
end;

function GetSybaseDriverName(SybaseServerType: TSybaseServerType): string;
begin
  case SybaseServerType of
    sstASE11: Result := 'Sybase System 11';
    sstASA8:  Result := 'Adaptive Server Anywhere 8.0';
    sstASA7:  Result := 'Adaptive Server Anywhere 7.0';
  else
    Result := 'Adaptive Server Anywhere 8.0';
  end;
end;

end.
