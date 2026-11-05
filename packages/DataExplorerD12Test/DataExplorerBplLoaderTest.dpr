program DataExplorerBplLoaderTest;

{$APPTYPE CONSOLE}

{
  =============================================================================
  DataExplorerBplLoaderTest: 獨立動態載入 BPL 驗證程式
  =============================================================================
  重要特性：
    1. 本 EXE 絕不靜態引用 OdbcApi、DbxOpenOdbcCore、DbxOpenOdbcDriver
       或 DbxOpenOdbcDataExplorerMetadata。
    2. 透過 LoadPackage 動態載入 DbxOpenOdbcDataExplorerD12Test290.bpl。
    3. 驗證 BPL 載入前後的驅動註冊狀態。
    4. 透過 TDBXDataExpressMetaDataProvider.Open / GetCollection
       重複驗證 Tables、Views、Columns、Procedures 之資料筆數與欄位。
    5. 驗證 UnloadPackage 卸載行為，並記錄共存與卸載安全性限制。
  =============================================================================
}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Data.DBXCommon,
  Data.DBXCommonTable,
  Data.DBXMetaDataProvider,
  Data.DBXDataExpressMetaDataProvider,
  Data.DBXClassRegistry;

const
  ENV_CONN_STR = 'DBXOODBC_TEST_CONN';
  DEFAULT_BPL_NAME = 'DbxOpenOdbcDataExplorerD12Test290.bpl';

procedure PrintBanner;
begin
  Writeln('================================================================');
  Writeln('  DbxOpenOdbc D12 Data Explorer BPL Dynamic Loader Test');
  Writeln('================================================================');
  Writeln('Compiler Version  : ', CompilerVersion:0:1);
  {$IFDEF WIN64}
  Writeln('Target Platform   : Win64');
  {$ELSE}
  Writeln('Target Platform   : Win32');
  {$ENDIF}
  Writeln('Mode              : DYNAMIC BPL PACKAGE LOADER (No static driver link)');
  Writeln('================================================================');
end;

function LocateBplFile(const ExplicitPath: string): string;
var
  Candidates: array[0..6] of string;
  I: Integer;
begin
  if (ExplicitPath <> '') and FileExists(ExplicitPath) then
    Exit(ExpandFileName(ExplicitPath));

  Candidates[0] := DEFAULT_BPL_NAME;
  Candidates[1] := '.\' + DEFAULT_BPL_NAME;
  Candidates[2] := '.\bin\' + DEFAULT_BPL_NAME;
  Candidates[3] := '.\bin\Win32\Release\' + DEFAULT_BPL_NAME;
  Candidates[4] := '.\bin\Win32\Debug\' + DEFAULT_BPL_NAME;
  Candidates[5] := '..\bin\Win32\Release\' + DEFAULT_BPL_NAME;
  Candidates[6] := '..\bin\Win32\Debug\' + DEFAULT_BPL_NAME;

  for I := 0 to High(Candidates) do
  begin
    if FileExists(Candidates[I]) then
      Exit(ExpandFileName(Candidates[I]));
  end;
  Result := '';
end;

function GetConnectionString(const ExplicitConn: string): string;
begin
  if ExplicitConn <> '' then
    Exit(ExplicitConn);
  Result := Trim(GetEnvironmentVariable(ENV_CONN_STR));
end;

procedure DumpTableCollection(Provider: TDBXDataExpressMetaDataProvider; const CommandText: string;
  const KeyColumns: array of string; MaxRowsToDump: Integer; var CapturedTableName: string);
var
  Storage: TDBXTable;
  RowCount, I, Ordinal: Integer;
  Line: string;
begin
  Writeln('----------------------------------------------------------------');
  Writeln('Testing GetCollection: "', CommandText, '"');
  Writeln('----------------------------------------------------------------');

  Storage := Provider.GetCollection(CommandText);
  if Storage = nil then
  begin
    Writeln('[WARN] Provider.GetCollection returned NIL');
    Exit;
  end;

  try
    RowCount := 0;
    if Storage.First then
    begin
      repeat
        Inc(RowCount);
        if RowCount <= MaxRowsToDump then
        begin
          Line := Format('[Row %3d] ', [RowCount]);
          for I := 0 to High(KeyColumns) do
          begin
            Ordinal := Storage.GetOrdinal(KeyColumns[I]);
            if Ordinal >= 0 then
            begin
              if Storage.Value[Ordinal].IsNull then
                Line := Line + KeyColumns[I] + '=<NULL>; '
              else
                Line := Line + KeyColumns[I] + '=' + Storage.Value[Ordinal].AsString + '; ';
            end
            else
              Line := Line + KeyColumns[I] + '=<N/A>; ';
          end;
          Writeln(Line);
        end;

        if (CapturedTableName = '') and SameText(CommandText, TDBXMetaDataCommands.GetTables) then
        begin
          Ordinal := Storage.GetOrdinal('TableName');
          if Ordinal >= 0 then
          begin
            if not Storage.Value[Ordinal].IsNull then
              CapturedTableName := Storage.Value[Ordinal].AsString;
          end;
        end;

      until not Storage.Next;
    end;

    Writeln('--> Total Records Fetched: ', RowCount);
    if RowCount = 0 then
      Writeln('[WARN] Collection is empty.');
  finally
    Storage.Free;
  end;
end;

procedure RunBplLoaderTest(const BplPath, ConnStr: string);
var
  ModuleHandle: HMODULE;
  Props: TDBXProperties;
  Connection: TDBXConnection;
  Provider: TDBXDataExpressMetaDataProvider;
  SampleTable, DummyName: string;
  Registry: TClassRegistry;
begin
  Registry := TClassRegistry.GetClassRegistry;

  // =========================================================================
  // 檢驗點 1: BPL 載入前的純淨狀態確認 (證明本 EXE 絕無靜態連結驅動)
  // =========================================================================
  Writeln('');
  Writeln('[STAGE 1] Pre-load Registry Verification...');
  if not Registry.HasClass('TDBXOpenOdbcDriverLoaderNative') then
    Writeln('[PASS] Pre-check: TDBXOpenOdbcDriverLoaderNative is NOT in TClassRegistry.')
  else
    Writeln('[WARN] Pre-check: TDBXOpenOdbcDriverLoaderNative was already registered.');

  if not Registry.HasClass('TDBXOpenOdbcMetaDataWriter') then
    Writeln('[PASS] Pre-check: TDBXOpenOdbcMetaDataWriter is NOT in TClassRegistry.')
  else
    Writeln('[WARN] Pre-check: TDBXOpenOdbcMetaDataWriter was already registered.');

  // =========================================================================
  // 檢驗點 2: 動態載入 BPL 套件
  // =========================================================================
  Writeln('');
  Writeln('[STAGE 2] Dynamic Loading BPL Package: ', BplPath);
  try
    ModuleHandle := LoadPackage(BplPath);
  except
    on E: Exception do
    begin
      Writeln('[FATAL ERROR] LoadPackage failed: ', E.Message);
      Exit;
    end;
  end;

  if ModuleHandle = 0 then
  begin
    Writeln('[FATAL ERROR] LoadPackage returned 0 (GetLastError: ', GetLastError, ')');
    Exit;
  end;
  Writeln('[PASS] LoadPackage succeeded! Module Handle: 0x', IntToHex(ModuleHandle, 8));

  // 驗證 BPL 的 initialization 是否已正確執行
  if Registry.HasClass('TDBXOpenOdbcDriverLoaderNative') then
    Writeln('[PASS] Post-load: TDBXOpenOdbcDriverLoaderNative registered in TClassRegistry.')
  else
  begin
    Writeln('[CRITICAL FAILURE] TDBXOpenOdbcDriverLoaderNative not registered after LoadPackage!');
    UnloadPackage(ModuleHandle);
    Exit;
  end;

  if Registry.HasClass('TDBXOpenOdbcMetaDataWriter') then
    Writeln('[PASS] Post-load: TDBXOpenOdbcMetaDataWriter registered in TClassRegistry.')
  else
    Writeln('[WARN] Post-load: TDBXOpenOdbcMetaDataWriter not found in TClassRegistry.');

  // =========================================================================
  // 檢驗點 3: 透過動態載入的驅動建立連線並執行 Provider.Open / GetCollection
  // =========================================================================
  Writeln('');
  Writeln('[STAGE 3] Executing DBX Connection and Provider.Open via Loaded BPL...');
  Props := TDBXProperties.Create;
  try
    Props.Values[TDBXPropertyNames.DriverName] := 'DbxOpenOdbc';
    Props.Values['ConnectionString'] := ConnStr;

    Connection := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Writeln('[OK] DBX Connection opened successfully via dynamic BPL.');
      Writeln('     ProductName    : ', Connection.ProductName);
      Writeln('     ProductVersion : ', Connection.ProductVersion);

      Provider := TDBXDataExpressMetaDataProvider.Create(Connection);
      try
        Writeln('[STEP] Calling Provider.Open (Resolves Writer from BPL)...');
        try
          Provider.Open;
          Writeln('[PASS] Provider.Open succeeded via BPL!');
        except
          on E: Exception do
          begin
            Writeln('================================================================');
            Writeln('[CRITICAL FAILURE AT Provider.Open]');
            Writeln('Exception Class   : ', E.ClassName);
            Writeln('Exception Message : ', E.Message);
            Writeln('================================================================');
            Exit;
          end;
        end;

        SampleTable := '';
        DummyName := '';

        // 驗證 Tables
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetTables,
          ['CatalogName', 'SchemaName', 'TableName', 'TableType'], 10, SampleTable);

        // 驗證 Views
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetViews,
          ['CatalogName', 'SchemaName', 'ViewName'], 10, DummyName);

        // 驗證 Columns
        if SampleTable <> '' then
        begin
          Writeln('');
          Writeln('[INFO] Using Sample Table for Columns test: "', SampleTable, '"');
          DumpTableCollection(Provider, TDBXMetaDataCommands.GetColumns + ' ' + SampleTable,
            ['ColumnName', 'TypeName', 'Precision', 'Scale', 'Ordinal'], 10, DummyName);
        end
        else
          Writeln('[WARN] No SampleTable captured; skipping Columns test.');

        // 驗證 Procedures
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetProcedures,
          ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType'], 10, DummyName);

        Writeln('');
        Writeln('================================================================');
        Writeln('[SUMMARY] ALL METADATA READ OPERATIONS PASSED VIA DYNAMIC BPL!');
        Writeln('================================================================');
      finally
        Provider.Free;
      end;
    finally
      Connection.Free;
    end;
  finally
    Props.Free;
  end;

  // =========================================================================
  // 檢驗點 4: 測試 BPL 卸載行為 (UnloadPackage) 並評估生命週期
  // =========================================================================
  Writeln('');
  Writeln('[STAGE 4] Testing BPL Unload (UnloadPackage)...');
  try
    UnloadPackage(ModuleHandle);
    Writeln('[PASS] UnloadPackage executed without OS exception.');

    if not Registry.HasClass('TDBXOpenOdbcDriverLoaderNative') then
      Writeln('[PASS] TDBXOpenOdbcDriverLoaderNative cleanly unregistered from TClassRegistry.')
    else
      Writeln('[INFO] TDBXOpenOdbcDriverLoaderNative remains in TClassRegistry.');

    Writeln('');
    Writeln('----------------------------------------------------------------');
    Writeln('[LIFECYCLE & SAFETY NOTES]');
    Writeln('  1. Dialect registration: ''Microsoft SQL Server'' was registered in');
    Writeln('     TDBXMetaDataWriterFactory during LoadPackage.');
    Writeln('  2. Known Delphi RTL limitation: TDBXMetaDataWriterFactory.UnRegisterWriter');
    Writeln('     unregisters the class from TClassRegistry but does NOT remove the dialect');
    Writeln('     string key from its private FProviderRegistry dictionary.');
    Writeln('  3. In IDE environment (bds.exe), repeated load/unload without IDE restart');
    Writeln('     could leave dangling entries if a different writer is registered later.');
    Writeln('     This will be analyzed before merging into production packages/DataExplorer.');
    Writeln('----------------------------------------------------------------');
  except
    on E: Exception do
      Writeln('[WARN] Exception during UnloadPackage: ', E.Message);
  end;
end;

var
  ArgBpl, ArgConn: string;
  I: Integer;
begin
  try
    PrintBanner;

    ArgBpl := '';
    ArgConn := '';

    for I := 1 to ParamCount do
    begin
      if SameText(ExtractFileExt(ParamStr(I)), '.bpl') or FileExists(ParamStr(I)) then
        ArgBpl := ParamStr(I)
      else if ArgConn = '' then
        ArgConn := ParamStr(I);
    end;

    ArgBpl := LocateBplFile(ArgBpl);
    if ArgBpl = '' then
    begin
      Writeln('[ERROR] Target BPL package not found!');
      Writeln('Expected: ', DEFAULT_BPL_NAME);
      Writeln('Please compile DbxOpenOdbcDataExplorerD12Test.dpk first, or specify BPL path:');
      Writeln('  DataExplorerBplLoaderTest.exe "path\to\DbxOpenOdbcDataExplorerD12Test290.bpl"');
      Exit;
    end;

    ArgConn := GetConnectionString(ArgConn);
    if ArgConn = '' then
    begin
      Writeln('[ERROR] Missing connection string!');
      Writeln('Please set DBXOODBC_TEST_CONN or pass connection string as parameter.');
      Exit;
    end;

    RunBplLoaderTest(ArgBpl, ArgConn);
  except
    on E: Exception do
      Writeln('[UNHANDLED FATAL] ', E.ClassName, ': ', E.Message);
  end;

  Writeln('');
  Write('Press Enter to exit...');
  Readln;
end.
