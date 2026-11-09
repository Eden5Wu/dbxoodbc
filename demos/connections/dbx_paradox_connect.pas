{===============================================================================
  Open DBX4 ODBC Driver Remastered (dbx4odbc)
  Pure Native Delphi dbExpress (DBX4) Driver for ODBC (Win32 & Win64)
  File: dbx_paradox_connect.pas
  Description: Borland / Corel Paradox (.db) Connection Helper & Engineering Guide
  Version: 4.2026.11.10

  -----------------------------------------------------------------------------
  CRITICAL OPERATIONAL CONSTRAINTS & LIMITATIONS (必須注意的重要限制與邊界):
  -----------------------------------------------------------------------------

  1. Bitness Limitation (32-bit Win32 Only / 僅支援 Win32):
     - The official Microsoft Jet 4.0 Desktop Database Driver for Paradox
       ("Microsoft Paradox Driver (*.db )" backed by odpdx32.dll / odbcjt32.dll)
       exists EXCLUSIVELY as a 32-bit component in Windows (SysWOW64).
     - Microsoft NEVER released a 64-bit Paradox ODBC driver; the 64-bit Access
       Database Engine (ACE) completely dropped Paradox IISAM support.
     - CONSEQUENCE: Applications connecting to Paradox tables MUST be compiled
       with the Delphi 32-bit Windows target (Win32). Win64 targets will fail
       with [IM002] "Data source name not found".

  2. Directory-as-Database Paradigm (目錄即資料庫):
     - Paradox is a file-based engine without a centralized server daemon.
     - The directory path (passed to Dbq and DefaultDir) represents the DATABASE.
     - Each ".db" file inside that directory represents a single TABLE.
     - In SQL statements, query the table name without extension:
       e.g., to query "C:\Data\Legacy\customer.db", connect to "C:\Data\Legacy"
       and execute "SELECT * FROM customer".

  3. Driver Name Space Quirk (驅動程式名稱尾隨空格陷阱):
     - Microsoft registered the driver as "Microsoft Paradox Driver (*.db )"
       with a mandatory trailing space before the closing parenthesis.
     - Omitting this space (e.g. "(*.db)") causes ODBC Driver Manager to fail
       resolution with [IM002]. This unit handles this automatically.

  4. BDE Locking Conflict & Corruption Hazard (與 BDE 網路鎖衝突與毀損風險):
     - The Borland Database Engine (BDE) coordinates multi-user file access using
       "PDOXUSRS.NET" and "PARADOX.NET" lock files.
     - The Microsoft Jet ODBC driver uses its own distinct locking mechanism
       which is INCOMPATIBLE with the BDE lock manager.
     - WARNING: Concurrent write operations by both BDE applications and ODBC
       applications on the same Paradox folder will lead to table corruption or
       "Table is locked" deadlock exceptions.
     - RECOMMENDATION: For legacy database migration, access Paradox tables in
       exclusive or read-only mode, or export data in batches.

  5. Table Version Compatibility (表格版本與進階型別相容性):
     - Optimal compatibility is achieved with Paradox 3.x, 4.x, and 5.x tables.
     - Paradox 7.0+ tables utilizing advanced features (such as AutoIncrement
       fields, BCD high precision, or modified secondary index structures) may
       trigger "External database driver error" with the Microsoft Jet driver.

  -----------------------------------------------------------------------------
  USAGE EXAMPLE (使用範例):
  -----------------------------------------------------------------------------
  var
    Conn: TSQLConnection;
    Qry: TSQLQuery;
  begin
    Conn := TSQLConnection.Create(nil);
    Qry := TSQLQuery.Create(nil);
    try
      // Connect to folder containing .db files (e.g., C:\Data\Legacy)
      ParadoxConnect(Conn, 'C:\Data\Legacy', '5.X', '', True, False, True); // ReadOnly

      Qry.SQLConnection := Conn;
      Qry.SQL.Text := 'SELECT CustNo, Company, Phone FROM customer WHERE CustNo > 1000';
      Qry.Open;
      while not Qry.Eof do
      begin
        // Process data...
        Qry.Next;
      end;
    finally
      Qry.Free;
      Conn.Free;
    end;
  end;
===============================================================================}
unit dbx_paradox_connect;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Win.Registry,
  Data.SqlConst, Data.SqlExpr, DbxOpenOdbcDriver;

procedure ParadoxConnect(SQLConnection: TSQLConnection;
  const db_path_or_file: string;
  const paradox_version: string = '5.X';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);

function GetInstalledParadoxOdbcDriver: string;
function IsPresentedParadoxDriver: Boolean;

const
  // Notice the trailing space before closing parenthesis: standard Microsoft Jet driver name convention
  cDefaultParadoxDriverName = 'Microsoft Paradox Driver (*.db )';

implementation

function GetInstalledParadoxOdbcDriver: string;
var
  R: TRegistry;
  Drivers: array[0..2] of string;
  I: Integer;
begin
  Drivers[0] := 'Microsoft Paradox Driver (*.db )';
  Drivers[1] := 'Microsoft Paradox-Treiber (*.db )';
  Drivers[2] := 'Driver do Microsoft Paradox (*.db )';

  Result := cDefaultParadoxDriverName;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers') then
    begin
      for I := Low(Drivers) to High(Drivers) do
      begin
        if R.ValueExists(Drivers[I]) then
        begin
          Result := Drivers[I];
          Break;
        end;
      end;
    end;
  finally
    R.Free;
  end;
end;

function IsPresentedParadoxDriver: Boolean;
var
  R: TRegistry;
begin
  Result := False;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers') then
      Result := R.ValueExists(cDefaultParadoxDriverName);
  finally
    R.Free;
  end;
end;

procedure ParadoxConnect(SQLConnection: TSQLConnection;
  const db_path_or_file: string;
  const paradox_version: string = '5.X';
  const dns_name: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  ReadOnly: Boolean = False;
  const AdditionalOptions: string = ''
);
var
  sConnectionString: string;
  sDriver: string;
  sDir: string;
  sDriverId: string;
  sFilVer: string;
begin
  SQLConnection.Close;
  sDir := Trim(db_path_or_file);

  if (sDir = '') and (Trim(dns_name) = '') then
    Exit;

  // If a file path was passed (e.g. C:\Data\customer.db), extract directory
  if (sDir <> '') and FileExists(sDir) then
    sDir := ExtractFilePath(sDir);
  sDir := ExcludeTrailingPathDelimiter(sDir);

  SQLConnection.DriverName := sDbxOpenOdbcDriverName;
  SQLConnection.LoginPrompt := LoginPrompt;

  if dns_name <> '' then
    sConnectionString := 'DSN=' + Trim(dns_name) + ';'
  else
  begin
    sDriver := GetInstalledParadoxOdbcDriver;
    sConnectionString := 'DRIVER={' + sDriver + '};';
  end;

  if sDir <> '' then
    sConnectionString := sConnectionString + 'Dbq=' + sDir + ';DefaultDir=' + sDir + ';';

  // Determine DriverID based on Paradox table format
  sFilVer := UpperCase(Trim(paradox_version));
  if sFilVer = '3.X' then
    sDriverId := '533'
  else if sFilVer = '4.X' then
    sDriverId := '535'
  else
    sDriverId := '538'; // Standard default for 5.X, 7.X

  sConnectionString := sConnectionString + 'DriverID=' + sDriverId + ';';
  sConnectionString := sConnectionString + 'Fil=Paradox ' + Trim(paradox_version) + ';';

  if ReadOnly then
    sConnectionString := sConnectionString + 'ReadOnly=1;';

  if AdditionalOptions <> '' then
    sConnectionString := sConnectionString + AdditionalOptions;

  SQLConnection.Params.Clear;
  SQLConnection.Params.Values[TRIMCHAR] := 'True';
  SQLConnection.Params.Values[ROWSETSIZE_KEY] := '20';
  SQLConnection.Params.Values[DATABASENAME_KEY] := '?';
  SQLConnection.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := sConnectionString;

  SQLConnection.Open;
end;

end.
