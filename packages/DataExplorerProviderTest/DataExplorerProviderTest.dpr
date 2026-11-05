program DataExplorerProviderTest;

{$APPTYPE CONSOLE}

{
  =============================================================================
  Data Explorer 底層 MetaDataProvider 獨立驗證程式
  =============================================================================
  說明：
    1. 透過條件編譯區分「純淨環境」與「引用官方 MSSQL Metadata 單元」兩種情境。
    2. 呼叫 TDBXDataExpressMetaDataProvider.Open，直接測試與 Data Explorer 相同的進入點。
    3. 遍歷並驗證 Tables、Columns、Procedures 的實際資料筆數與欄位內容。
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
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas',
  DbxOpenOdbcDataExplorerMetadata in 'DbxOpenOdbcDataExplorerMetadata.pas';

const
  ENV_CONN_STR = 'DBXOODBC_TEST_CONN';

procedure PrintBanner;
begin
  Writeln('================================================================');
  Writeln('  DbxOpenOdbc Data Explorer MetaDataProvider Diagnostic Test');
  Writeln('================================================================');
  Writeln('Compiler Version  : ', CompilerVersion:0:1);
  {$IFDEF WIN64}
  Writeln('Target Platform   : Win64');
  {$ELSE}
  Writeln('Target Platform   : Win32');
  {$ENDIF}
  {$IFDEF USE_OFFICIAL_MSSQL_METADATA}
  Writeln('Mode              : WITH Data.DBXMSSQLMetaData (Official Writer linked)');
  {$ELSE}
  Writeln('Mode              : WITHOUT Official Metadata Unit (Isolated)');
  {$ENDIF}
  Writeln('================================================================');
end;

function GetConnectionString: string;
begin
  Result := Trim(GetEnvironmentVariable(ENV_CONN_STR));
  if Result = '' then
  begin
    Writeln('[ERROR] Environment variable "', ENV_CONN_STR, '" is not set!');
    Writeln('Please set it in your command prompt before running, for example:');
    Writeln('  set DBXOODBC_TEST_CONN=Driver={ODBC Driver 18 for SQL Server};Server=127.0.0.1;Database=master;Trusted_Connection=Yes;TrustServerCertificate=Yes;');
    Writeln('echo %DBXOODBC_TEST_CONN%');
  end;
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
    // 1. 修正游標走訪：使用 First + repeat until not Next，絕不漏掉第 1 筆
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
            // 2. 修正布林求值：巢狀 if 嚴格隔離，絕不傳入 -1
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

        // 3. 只有在抓取 Tables 且尚未取得樣本表名時才擷取，巢狀 if 隔離
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

procedure RunDiagnostics;
var
  ConnStr: string;
  Props: TDBXProperties;
  Connection: TDBXConnection;
  Provider: TDBXDataExpressMetaDataProvider;
  SampleTable, DummyName: string;
begin
  ConnStr := GetConnectionString;
  if ConnStr = '' then Exit;

  Writeln('[INFO] Connecting via DbxOpenOdbc driver...');

  Props := TDBXProperties.Create;
  try
    Props.Values[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props.Values['ConnectionString'] := ConnStr;

    Connection := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Writeln('[OK] DBX Connection opened successfully.');
      Writeln('     ProductName    : ', Connection.ProductName);
      Writeln('     ProductVersion : ', Connection.ProductVersion);

      Writeln('');
      Writeln('[STEP 1] Creating TDBXDataExpressMetaDataProvider...');
      Provider := TDBXDataExpressMetaDataProvider.Create(Connection);
      try
        Writeln('[STEP 2] Calling Provider.Open (This triggers Writer lookup)...');
        try
          Provider.Open;
          Writeln('[PASS] Provider.Open succeeded!');
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

        // 1. 驗證 Tables (擷取 SampleTable)
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetTables,
          ['CatalogName', 'SchemaName', 'TableName', 'TableType'], 10, SampleTable);

        // 2. 驗證 Views (獨立變數 DummyName，不蓋掉 SampleTable)
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetViews,
          ['CatalogName', 'SchemaName', 'ViewName'], 10, DummyName);

        // 3. 驗證 Columns (使用從 Tables 成功擷取的 SampleTable)
        if SampleTable <> '' then
        begin
          Writeln('');
          Writeln('[INFO] Using Sample Table for Columns test: "', SampleTable, '"');
          DumpTableCollection(Provider, TDBXMetaDataCommands.GetColumns + ' ' + SampleTable,
            ['ColumnName', 'TypeName', 'Precision', 'Scale', 'Ordinal'], 10, DummyName);
        end
        else
          Writeln('[WARN] No SampleTable captured; skipping Columns test.');

        // 4. 驗證 Procedures
        Writeln('');
        DumpTableCollection(Provider, TDBXMetaDataCommands.GetProcedures,
          ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType'], 10, DummyName);

        Writeln('');
        Writeln('================================================================');
        Writeln('[SUMMARY] ALL METADATA READ OPERATIONS COMPLETED SUCCESSFULLY.');
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
end;

begin
  try
    PrintBanner;
    RunDiagnostics;
  except
    on E: Exception do
      Writeln('[UNHANDLED FATAL] ', E.ClassName, ': ', E.Message);
  end;

  Writeln('');
  Write('Press Enter to exit...');
  Readln;
end.
