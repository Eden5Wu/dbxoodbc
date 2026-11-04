program DataExplorerLoaderTest;

{$APPTYPE CONSOLE}

// Intentionally do not link OdbcApi, DbxOpenOdbcCore or DbxOpenOdbcDriver.
// The host must obtain the driver by loading the package named in the INI.
uses
  Winapi.Windows,
  System.SysUtils,
  Data.DBXCommon,
  Data.DBXClassRegistry;

procedure Check(Condition: Boolean; const Message: string);
begin
  if not Condition then
    raise Exception.Create(Message);
end;

var
  Factory: TDBXIniFileConnectionFactory;
  Driver: TDBXDelegateDriver;
  Properties: TDBXProperties;
  Connection: TDBXConnection;
  DriverName: string;
  ReachedOdbc: Boolean;
begin
  try
    Check(ParamCount = 3, 'Usage: DataExplorerLoaderTest drivers.ini connections.ini package.bpl');
    Check(not TClassRegistry.GetClassRegistry.HasClass('TDBXOpenOdbcDriverLoaderNative'),
      'Custom loader must not be registered before loading the INI');
    Factory := TDBXIniFileConnectionFactory.Create;
    try
      Factory.DriversFile := ParamStr(1);
      Factory.ConnectionsFile := ParamStr(2);
      Factory.Open;
      for DriverName in ['DbxOpenOdbc', 'OpenOdbc'] do
      begin
        // Resolve the named driver without opening a network connection.
        Properties := Factory.GetDriverProperties(DriverName);
        Check(Properties <> nil, 'Missing INI driver: ' + DriverName);
      end;
      Driver := Factory.GetConnectionDriver('DbxOpenOdbc_DataExplorer_MSSQL');
      try
        Check(Driver <> nil, 'Could not resolve the driver through the connection INI');
      finally
        Driver.Free;
      end;
      Check(GetModuleHandle(PChar(ParamStr(3))) <> 0,
        'Expected driver BPL was not loaded');
      Check(TClassRegistry.GetClassRegistry.HasClass('TDBXOpenOdbcDriverLoaderNative'),
        'BPL did not register the custom loader');
      Writeln('[PASS] INI dynamically loaded ', ParamStr(3));

      for DriverName in ['DbxOpenOdbc', 'OpenOdbc'] do
      begin
        Properties := TDBXProperties.Create;
        try
          Properties[TDBXPropertyNames.DriverName] := DriverName;
          // Deliberately nonexistent driver: no server, credentials or database.
          Properties['ConnectionString'] := 'Driver={DbxOpenOdbc_Nonexistent_Test_Driver};';
          ReachedOdbc := False;
          try
            Connection := Factory.GetConnection(Properties);
            Connection.Free;
          except
            on E: Exception do
            begin
              if E.ClassName <> 'EOdbcError' then
                raise;
              ReachedOdbc := True;
            end;
          end;
          Check(ReachedOdbc, 'Expected a normal ODBC error for ' + DriverName);
          Writeln('[PASS] ', DriverName, ' reached ODBC without a loader access violation');
        finally
          Properties.Free;
        end;
      end;
      Writeln('[PASS] All loader checks completed');
      Flush(Output);
    finally
      Factory.Free;
    end;
  except
    on E: Exception do
    begin
      Writeln('[FAIL] ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
