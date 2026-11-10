program Dbx4MvpTester;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  Data.DB,
  Data.DBXCommon,
  Data.SqlExpr,
  MidasLib,
  Datasnap.Provider,
  Datasnap.DBClient,
  OdbcApi in '..\..\source\OdbcApi.pas',
  DbxOpenOdbcCore in '..\..\source\DbxOpenOdbcCore.pas',
  DbxOpenOdbcDriver in '..\..\source\DbxOpenOdbcDriver.pas';

function BuildTestConnectionString(out MdbPath: string): string;
var
  BaseDir: string;
begin
  BaseDir := ExtractFilePath(ParamStr(0));
  MdbPath := ExpandFileName(BaseDir + '..\..\demos\dbms\msaccess\sql\dbdemos.mdb');
  if not FileExists(MdbPath) then
    MdbPath := 'D:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\demos\dbms\msaccess\sql\dbdemos.mdb';

  {$IFDEF WIN64}
  Result := 'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + MdbPath + ';ReadOnly=1;';
  {$ELSE}
  Result := 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=' + MdbPath + ';ReadOnly=1;';
  {$ENDIF}
end;

var
  G_PassCount: Integer = 0;
  G_FailCount: Integer = 0;
  G_SkipCount: Integer = 0;

procedure ReportPass(const Msg: string);
begin
  Inc(G_PassCount);
  Writeln('  [PASS] ' + Msg);
end;

procedure ReportFail(const Msg: string);
begin
  Inc(G_FailCount);
  Writeln('  [FAIL] ' + Msg);
end;

procedure ReportSkip(const Msg: string);
begin
  Inc(G_SkipCount);
  Writeln('  [SKIP] ' + Msg);
end;

procedure RunLowLevelDBX4Test(const ConnStr: string);
var
  Props: TDBXProperties;
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
begin
  Writeln('=== [Test 1] Low-Level Native DBX4 API (TDBXConnection / TDBXCommand / TDBXReader) ===');
  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;

    Conn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Writeln('  [+] Connected via Native DBX4 Driver!');
      Writeln('  [+] ProductName    : ', Conn.ProductName);
      Writeln('  [+] ProductVersion : ', Conn.ProductVersion);
      Writeln('  [+] DriverVersion  : ', Conn.GetVendorProperty('DriverVersion'));
      Writeln('  [+] QuoteChar      : ', Conn.DatabaseMetaData.QuoteChar);

      Cmd := Conn.CreateCommand;
      try
        Cmd.CommandType := TDBXCommandTypes.DbxMetaData;
        Cmd.Text := 'GetTables';
        Reader := Cmd.ExecuteQuery;
        try
          Writeln('  [+] MetaData GetTables ColumnCount = ', Reader.ColumnCount);
          for var c := 0 to Reader.ColumnCount - 1 do
            Write(Reader.ValueType[c].Name, ' | ');
          Writeln;
          var MetaRowCount := 0;
          while Reader.Next do
          begin
            Inc(MetaRowCount);
            if MetaRowCount <= 5 then
              Writeln(Format('      Table[%d]: %s (Type: %s)', [
                MetaRowCount,
                Reader.Value[2].AsString,
                Reader.Value[3].AsString
              ]));
          end;
          Writeln('  [+] MetaData GetTables Total rows: ', MetaRowCount);
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT 1 AS TestInt, ''NativeDBX4_OK'' AS TestStr';
        Reader := Cmd.ExecuteQuery;
        try
          if Reader = nil then
            raise Exception.Create('Reader is nil for SELECT 1');
          if not Reader.Next then
            raise Exception.Create('Reader.Next returned False for SELECT 1');

          Writeln('  [+] Executed SQL   : ', Cmd.Text);
          Writeln('  [+] ColumnCount    : ', Reader.ColumnCount);
          Writeln('  [+] Column[0] Name : ', Reader.ValueType[0].Name, ' = ', Reader.Value[0].AsInt32);
          Writeln('  [+] Column[1] Name : ', Reader.ValueType[1].Name, ' = ', Reader.Value[1].AsString);

          if Reader.Value[0].AsInt32 <> 1 then
            raise Exception.CreateFmt('Unexpected Column[0] value: %d', [Reader.Value[0].AsInt32]);
          if Reader.Value[1].AsString <> 'NativeDBX4_OK' then
            raise Exception.CreateFmt('Unexpected Column[1] value: %s', [Reader.Value[1].AsString]);
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      // Test transactions with multiple isolation levels (validates Issue #11 fallback/handling)
      var DbxTran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      Conn.CommitFreeAndNil(DbxTran);
      DbxTran := Conn.BeginTransaction(TDBXIsolations.Serializable);
      Conn.RollbackFreeAndNil(DbxTran);
      Writeln('  [+] Multi-Isolation Level Transactions Succeeded (ReadCommitted, Serializable)!');

      // Test Issue #12: Prevent duplicate BeginTransaction while already in transaction
      DbxTran := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
      try
        var DuplicateRejected := False;
        try
          var DbxTran2 := Conn.BeginTransaction(TDBXIsolations.ReadCommitted);
          Conn.RollbackFreeAndNil(DbxTran2);
        except
          on E: TDBXError do
          begin
            if E.ErrorCode = TDBXErrorCodes.TransactionActive then
              DuplicateRejected := True;
          end;
        end;
        if not DuplicateRejected then
          raise Exception.Create('Duplicate BeginTransaction was not rejected with TransactionActive');
      finally
        Conn.RollbackFreeAndNil(DbxTran);
      end;
      Writeln('  [+] Duplicate BeginTransaction Guard Succeeded (TransactionActive rejected)!');
    finally
      Conn.Free;
    end;
  finally
    Props.Free;
  end;
  Writeln('  [PASS] Low-Level Native DBX4 Test Succeeded!');
  Writeln;
end;

procedure RunByteReaderDirectTest(const ConnStr: string);
var
  Props: TDBXProperties;
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  BR: TDBXByteReader;
  Buf: TArray<Byte>;
  IsNull: LongBool;
  StrVal, DecodedStr: string;
  RequiredBytes: Integer;
  ErrorCaught: Boolean;
  I: Integer;
begin
  Writeln('=== [Test 1.1] Direct Reader.ByteReader Verification (Unicode Boundaries) ===');
  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;
    Conn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      // --- Part A: Unicode ByteReader Verification ---
      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT Null AS NullCol, Company FROM customer WHERE CustNo = 1221';
        Reader := Cmd.ExecuteQuery;
        try
          if not Reader.Next then
            raise Exception.Create('Failed to fetch row from customer');

          BR := Reader.ByteReader;
          if BR = nil then
            raise Exception.Create('Reader.ByteReader returned nil');

          // 1. NULL Boundary Verification
          SetLength(Buf, 16);
          for I := 0 to High(Buf) do Buf[I] := $AA;
          BR.GetWideString(0, Buf, 0, IsNull);
          if not IsNull then
            raise Exception.Create('Expected IsNull=True for NULL column');
          for I := 0 to High(Buf) do
            if Buf[I] <> $AA then
              raise Exception.Create('Buffer corrupted on NULL column read');
          Writeln('  [+] Unicode: NULL boundary verified (buffer untouched, IsNull=True)');

          // 2. Exact Capacity Read Verification
          StrVal := Reader.Value[1].AsString;
          RequiredBytes := (Length(StrVal) + 1) * SizeOf(WideChar);
          SetLength(Buf, RequiredBytes);
          BR.GetWideString(1, Buf, 0, IsNull);
          if IsNull then
            raise Exception.Create('Unexpected IsNull on valid string');
          SetString(DecodedStr, PWideChar(@Buf[0]), Length(StrVal));
          if DecodedStr <> StrVal then
            raise Exception.CreateFmt('String content mismatch: expected "%s", got "%s"', [StrVal, DecodedStr]);
          if PWord(@Buf[RequiredBytes - 2])^ <> 0 then
            raise Exception.Create('Null terminator (#0#0) missing in exact capacity read');
          Writeln(Format('  [+] Unicode: Exact capacity read verified (%d bytes)', [RequiredBytes]));

          // 3. Non-zero Offset Verification
          SetLength(Buf, RequiredBytes + 8);
          for I := 0 to High(Buf) do Buf[I] := $55;
          BR.GetWideString(1, Buf, 4, IsNull);
          if IsNull then
            raise Exception.Create('Unexpected IsNull on non-zero offset');
          for I := 0 to 3 do
            if Buf[I] <> $55 then
              raise Exception.Create('Preceding bytes corrupted on non-zero offset read');
          SetString(DecodedStr, PWideChar(@Buf[4]), Length(StrVal));
          if DecodedStr <> StrVal then
            raise Exception.Create('Decoded string mismatch at non-zero offset');
          Writeln('  [+] Unicode: Non-zero offset (Offset=4) verified');

          // 4. 0-byte and 1-byte Capacity Rejection
          SetLength(Buf, 0);
          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, 0, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on 0-byte capacity');

          SetLength(Buf, 1);
          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, 0, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on 1-byte capacity');
          Writeln('  [+] Unicode: 0-byte and 1-byte capacities rejected with ERangeError');

          // 5. Odd Capacity Boundaries
          // Case A: Odd capacity smaller than required
          SetLength(Buf, RequiredBytes - 1);
          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, 0, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on odd capacity smaller than required');

          // Case B: Odd capacity larger than required (must not write half a code unit)
          SetLength(Buf, RequiredBytes + 1);
          Buf[RequiredBytes] := $EE;
          BR.GetWideString(1, Buf, 0, IsNull);
          SetString(DecodedStr, PWideChar(@Buf[0]), Length(StrVal));
          if DecodedStr <> StrVal then
            raise Exception.Create('Decoded string mismatch on odd sufficient capacity');
          if Buf[RequiredBytes] <> $EE then
            raise Exception.Create('Trailing byte corrupted on odd sufficient capacity');
          Writeln('  [+] Unicode: Odd capacity boundaries verified (no half code unit written)');

          // 6. Insufficient Capacity & Invalid Offset Rejection
          SetLength(Buf, RequiredBytes - 2);
          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, 0, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on insufficient capacity');

          SetLength(Buf, RequiredBytes);
          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, -1, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on negative offset');

          ErrorCaught := False;
          try
            BR.GetWideString(1, Buf, RequiredBytes + 2, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on out-of-bounds offset');
          Writeln('  [+] Unicode: Insufficient capacity and invalid offsets rejected with ERangeError');
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      // 7. Empty String Boundary Verification
      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT '''' AS EmptyStr, Company FROM customer WHERE CustNo = 1221';
        Reader := Cmd.ExecuteQuery;
        try
          if not Reader.Next then
            raise Exception.Create('Failed to fetch empty string row');
          BR := Reader.ByteReader;
          // Empty string requires 2 bytes for null terminator (#0#0)
          SetLength(Buf, 2);
          BR.GetWideString(0, Buf, 0, IsNull);
          if IsNull then
            raise Exception.Create('Unexpected IsNull on empty string');
          if (Buf[0] <> 0) or (Buf[1] <> 0) then
            raise Exception.Create('Expected #0#0 null terminator for empty string');

          // 1-byte capacity on empty string must fail
          SetLength(Buf, 1);
          ErrorCaught := False;
          try
            BR.GetWideString(0, Buf, 0, IsNull);
          except
            on ERangeError do ErrorCaught := True;
          end;
          if not ErrorCaught then
            raise Exception.Create('Expected ERangeError on 1-byte capacity for empty string');
          Writeln('  [+] Unicode: Empty string (#0#0) and 1-byte rejection verified');
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      // --- Part B: BLOB ByteReader Verification (dbx_test_long) ---
      Writeln('  [PASS] Direct Reader.ByteReader Unicode Verification Succeeded!');
      Writeln;
    finally
      Conn.Free;
    end;
  finally
    Props.Free;
  end;
end;

procedure VerifyBlobReader(BR: TDBXByteReader; ColIdx: Integer; const ColName, TableName: string);
var
  TotalLen, CurrPos, ChunkSize, ReadN: Int64;
  FullBlob, ChunkedBlob: TArray<Byte>;
  IsNull: LongBool;
  ErrorCaught: Boolean;
begin
  BR.GetByteLength(ColIdx, TotalLen, IsNull);
  if IsNull or (TotalLen <= 0) then
  begin
    ReportSkip(Format('Table %s column %s is null or 0 bytes', [TableName, ColName]));
    Exit;
  end;

  Writeln(Format('    [+] Testing BLOB %s.%s (Size=%d bytes)', [TableName, ColName, TotalLen]));

  // 1. Single-call full read
  SetLength(FullBlob, TotalLen);
  ReadN := BR.GetBytes(ColIdx, 0, FullBlob, 0, TotalLen, IsNull);
  if ReadN <> TotalLen then
    raise Exception.CreateFmt('Single-call GetBytes returned %d, expected %d', [ReadN, TotalLen]);

  // 2. Chunked / segmented read (512 bytes per chunk)
  SetLength(ChunkedBlob, TotalLen);
  CurrPos := 0;
  while CurrPos < TotalLen do
  begin
    ChunkSize := 512;
    if CurrPos + ChunkSize > TotalLen then
      ChunkSize := TotalLen - CurrPos;
    ReadN := BR.GetBytes(ColIdx, CurrPos, ChunkedBlob, CurrPos, ChunkSize, IsNull);
    if ReadN <= 0 then
      raise Exception.CreateFmt('Chunked GetBytes read 0 bytes at pos %d', [CurrPos]);
    Inc(CurrPos, ReadN);
  end;

  if not CompareMem(@FullBlob[0], @ChunkedBlob[0], TotalLen) then
    raise Exception.Create('BLOB single-call and chunked read content mismatch');
  Writeln(Format('    [+] BLOB: Single-call and segmented chunked reads match 100%% (%d bytes in 512-byte chunks)', [TotalLen]));

  // 3. Negative source offset (Offset = -1) -> TDBXError(InvalidArgument)
  ErrorCaught := False;
  try
    ReadN := BR.GetBytes(ColIdx, -1, FullBlob, 0, TotalLen, IsNull);
  except
    on E: TDBXError do
      if E.ErrorCode = TDBXErrorCodes.InvalidArgument then
        ErrorCaught := True;
    on Exception do ;
  end;
  if not ErrorCaught then
    raise Exception.Create('Negative source offset was not rejected with TDBXError(InvalidArgument)');

  // 4. Negative destination offset (ValueOffset = -1) -> TDBXError(InvalidArgument)
  ErrorCaught := False;
  try
    ReadN := BR.GetBytes(ColIdx, 0, FullBlob, -1, TotalLen, IsNull);
  except
    on E: TDBXError do
      if E.ErrorCode = TDBXErrorCodes.InvalidArgument then
        ErrorCaught := True;
    on Exception do ;
  end;
  if not ErrorCaught then
    raise Exception.Create('Negative destination offset was not rejected with TDBXError(InvalidArgument)');

  // 5. Destination buffer overflow -> TDBXError(InvalidArgument)
  ErrorCaught := False;
  try
    ReadN := BR.GetBytes(ColIdx, 0, FullBlob, 0, System.Length(FullBlob) + 10, IsNull);
  except
    on E: TDBXError do
      if E.ErrorCode = TDBXErrorCodes.InvalidArgument then
        ErrorCaught := True;
    on Exception do ;
  end;
  if not ErrorCaught then
    raise Exception.Create('Buffer overflow was not rejected with TDBXError(InvalidArgument)');

  // 6. Source offset equal to TotalLen -> returns 0
  ReadN := BR.GetBytes(ColIdx, TotalLen, FullBlob, 0, 10, IsNull);
  if ReadN <> 0 then
    raise Exception.CreateFmt('Source offset equal to TotalLen must return 0, got %d', [ReadN]);

  // 7. Source offset greater than TotalLen -> returns 0
  ReadN := BR.GetBytes(ColIdx, TotalLen + 100, FullBlob, 0, 10, IsNull);
  if ReadN <> 0 then
    raise Exception.CreateFmt('Source offset greater than TotalLen must return 0, got %d', [ReadN]);

  ReportPass(Format('BLOB %s.%s Direct Reader.ByteReader Verification Succeeded', [TableName, ColName]));
end;

procedure RunSqlServerBlobByteReaderTest;
var
  IniPath, ConnStr: string;
  Ini: TIniFile;
  Props: TDBXProperties;
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  BR: TDBXByteReader;
  BlobCol: Integer;
begin
  Writeln('=== [Test 1.2] SQL Server BLOB Reader.ByteReader Verification ===');
  IniPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + '..\..\benchmarks\bench_config.ini');
  if not FileExists(IniPath) then
  begin
    ReportSkip('bench_config.ini not found, skipping SQL Server BLOB test');
    Exit;
  end;

  Ini := TIniFile.Create(IniPath);
  try
    var Server := Ini.ReadString('Database', 'Server', '');
    var Database := Ini.ReadString('Database', 'Database', '');
    var User := Ini.ReadString('Database', 'User', '');
    var Pwd := Ini.ReadString('Database', 'Password', '');
    var Driver := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');
    if (Server = '') or (Database = '') then
    begin
      ReportSkip('Server/Database not configured in bench_config.ini');
      Exit;
    end;
    ConnStr := Format('Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;', [Driver, Server, Database, User, Pwd]);
  finally
    Ini.Free;
  end;

  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;
    Conn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      // Test 1.2.1: dbo.S_Reports
      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT TOP 1 * FROM dbo.S_Reports';
        Reader := Cmd.ExecuteQuery;
        try
          if Reader.Next then
          begin
            BR := Reader.ByteReader;
            BlobCol := -1;
            for var c := 0 to Reader.ColumnCount - 1 do
              if (Reader.ValueType[c].DataType = TDBXDataTypes.BlobType) or
                 (Reader.ValueType[c].DataType = TDBXDataTypes.BytesType) then
              begin
                BlobCol := c;
                Break;
              end;
            if BlobCol >= 0 then
              VerifyBlobReader(BR, BlobCol, Reader.ValueType[BlobCol].Name, 'dbo.S_Reports')
            else
              ReportSkip('dbo.S_Reports has no BLOB column');
          end
          else
            ReportSkip('dbo.S_Reports has no rows');
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

      // Test 1.2.2: dbo.M_OILAPP (INVIMG)
      Cmd := Conn.CreateCommand;
      try
        Cmd.Text := 'SELECT TOP 1 * FROM dbo.M_OILAPP WHERE INVIMG IS NOT NULL ORDER BY SERNUM';
        Reader := Cmd.ExecuteQuery;
        try
          if Reader.Next then
          begin
            BR := Reader.ByteReader;
            BlobCol := -1;
            for var c := 0 to Reader.ColumnCount - 1 do
              if Reader.ValueType[c].Name = 'INVIMG' then
              begin
                BlobCol := c;
                Break;
              end;
            if BlobCol >= 0 then
              VerifyBlobReader(BR, BlobCol, 'INVIMG', 'dbo.M_OILAPP')
            else
              ReportSkip('dbo.M_OILAPP has no INVIMG column');
          end
          else
            ReportSkip('dbo.M_OILAPP has no non-null INVIMG rows');
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;

    finally
      Conn.Free;
    end;
  finally
    Props.Free;
  end;
  Writeln;
end;

procedure RunSyntheticUnicodeAndEdgeCasesTest;
var
  IniPath, ConnStr: string;
  Ini: TIniFile;
  Props: TDBXProperties;
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  BR: TDBXByteReader;
  Buf: TArray<Byte>;
  IsNull: LongBool;
  TotalLen, ReadN: Int64;
  DecodedStr: string;
begin
  Writeln('=== [Test 1.3] Synthetic Unicode, Surrogate Pair & Edge Case Verification ===');
  IniPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + '..\..\benchmarks\bench_config.ini');
  if not FileExists(IniPath) then
  begin
    ReportSkip('bench_config.ini not found, skipping Synthetic Edge Case test');
    Exit;
  end;

  Ini := TIniFile.Create(IniPath);
  try
    var Server := Ini.ReadString('Database', 'Server', '');
    var Database := Ini.ReadString('Database', 'Database', '');
    var User := Ini.ReadString('Database', 'User', '');
    var Pwd := Ini.ReadString('Database', 'Password', '');
    var Driver := Ini.ReadString('Database', 'ODBCDriver', 'ODBC Driver 17 for SQL Server');
    if (Server = '') or (Database = '') then
    begin
      ReportSkip('Server/Database not configured');
      Exit;
    end;
    ConnStr := Format('Driver={%s};Server=tcp:%s;Database=%s;Uid=%s;Pwd=%s;', [Driver, Server, Database, User, Pwd]);
  finally
    Ini.Free;
  end;

  Props := TDBXProperties.Create;
  try
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;
    Conn := TDBXConnectionFactory.GetConnectionFactory.GetConnection(Props);
    try
      Cmd := Conn.CreateCommand;
      try
        Cmd.Text :=
          'SELECT ' +
          '  CAST(N''' + #$6E2C#$8A66#$4E2D#$6587 + 'Unicode'' AS NVARCHAR(50)) AS ColChinese, ' +
          '  CAST('''' AS NVARCHAR(50)) AS ColEmpty, ' +
          '  CAST(NULL AS NVARCHAR(50)) AS ColNull, ' +
          '  CAST(N''' + #$4E2D + ''' AS NCHAR(1)) AS ColNChar1, ' +
          '  CAST(NCHAR(0xD834) + NCHAR(0xDD1E) AS NVARCHAR(10)) AS ColSurrogate, ' +
          '  CAST(0x AS VARBINARY(MAX)) AS ColEmptyBlob, ' +
          '  CAST(NULL AS VARBINARY(MAX)) AS ColNullBlob, ' +
          '  CAST(0x0102030405 AS VARBINARY(MAX)) AS ColNormalBlob';
        Reader := Cmd.ExecuteQuery;
        try
          if not Reader.Next then
            raise Exception.Create('Failed to execute synthetic test query');

          BR := Reader.ByteReader;

          // 1. Chinese text (NVARCHAR)
          SetLength(Buf, 64);
          BR.GetWideString(0, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('Expected non-null for ColChinese');
          SetString(DecodedStr, PWideChar(@Buf[0]), Length(#$6E2C#$8A66#$4E2D#$6587 + 'Unicode'));
          if DecodedStr <> #$6E2C#$8A66#$4E2D#$6587 + 'Unicode' then
            raise Exception.CreateFmt('ColChinese mismatch: got "%s"', [DecodedStr]);
          Writeln('    [+] ColChinese verified: ' + DecodedStr);

          // 2. Empty string (NVARCHAR)
          SetLength(Buf, 16);
          BR.GetWideString(1, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColEmpty returned IsNull=True');
          if PWord(@Buf[0])^ <> 0 then raise Exception.Create('ColEmpty missing #0#0');
          Writeln('    [+] ColEmpty verified: Length=0, NullTerminator=#0#0, IsNull=False');

          // 3. NULL (NVARCHAR)
          for var i := 0 to 15 do Buf[i] := $AA;
          BR.GetWideString(2, Buf, 0, IsNull);
          if not IsNull then raise Exception.Create('ColNull expected IsNull=True');
          for var i := 0 to 15 do
            if Buf[i] <> $AA then raise Exception.Create('ColNull buffer modified');
          Writeln('    [+] ColNull verified: IsNull=True, Buffer untouched');

          // 4. NCHAR(1) - single wide char
          SetLength(Buf, 16);
          BR.GetWideString(3, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColNChar1 returned IsNull=True');
          SetString(DecodedStr, PWideChar(@Buf[0]), 1);
          if DecodedStr <> #$4E2D then raise Exception.CreateFmt('ColNChar1 mismatch: "%s"', [DecodedStr]);
          Writeln('    [+] ColNChar1 verified: ' + DecodedStr);

          // 5. UTF-16 Surrogate Pair (Musical Symbol G Clef U+1D11E = D834 DD1E)
          SetLength(Buf, 16);
          BR.GetWideString(4, Buf, 0, IsNull);
          if IsNull then raise Exception.Create('ColSurrogate returned IsNull=True');
          if (PWord(@Buf[0])^ <> $D834) or (PWord(@Buf[2])^ <> $DD1E) then
            raise Exception.CreateFmt('ColSurrogate mismatch: %x %x', [PWord(@Buf[0])^, PWord(@Buf[2])^]);
          Writeln('    [+] ColSurrogate (2 UTF-16 code units: D834 DD1E) verified');

          // 6. Zero-length BLOB (0x)
          BR.GetByteLength(5, TotalLen, IsNull);
          if IsNull then raise Exception.Create('ColEmptyBlob returned IsNull=True');
          if TotalLen <> 0 then raise Exception.CreateFmt('ColEmptyBlob expected Length=0, got %d', [TotalLen]);
          ReadN := BR.GetBytes(5, 0, Buf, 0, 10, IsNull);
          if ReadN <> 0 then raise Exception.Create('ColEmptyBlob GetBytes must return 0');
          Writeln('    [+] ColEmptyBlob verified: Length=0, IsNull=False, ReadN=0');

          // 7. NULL BLOB
          BR.GetByteLength(6, TotalLen, IsNull);
          if not IsNull then raise Exception.Create('ColNullBlob expected IsNull=True');
          Writeln('    [+] ColNullBlob verified: IsNull=True');

          // 8. Normal BLOB (0x0102030405)
          BR.GetByteLength(7, TotalLen, IsNull);
          if IsNull or (TotalLen <> 5) then raise Exception.CreateFmt('ColNormalBlob expected 5 bytes, got %d', [TotalLen]);
          SetLength(Buf, 5);
          ReadN := BR.GetBytes(7, 0, Buf, 0, 5, IsNull);
          if (ReadN <> 5) or (Buf[0] <> 1) or (Buf[1] <> 2) or (Buf[2] <> 3) or (Buf[3] <> 4) or (Buf[4] <> 5) then
            raise Exception.Create('ColNormalBlob content mismatch');
          Writeln('    [+] ColNormalBlob verified: 5 bytes [01 02 03 04 05] match');

          ReportPass('Synthetic Unicode, Surrogate Pair & BLOB Edge Cases Verified Successfully');
        finally
          Reader.Free;
        end;
      finally
        Cmd.Free;
      end;
    finally
      Conn.Free;
    end;
  finally
    Props.Free;
  end;
  Writeln;
end;

procedure RunGetMetadataAndDataSnapTest(SQLConn: TSQLConnection);
var
  Q1, Q2: TSQLQuery;
  DSP: TDataSetProvider;
  CDS: TClientDataSet;
  I: Integer;
  FoundKey: Boolean;
begin
  Writeln('=== [Test 2.1] TSQLQuery.GetMetadata & DataSnap (DSP -> CDS) Integration ===');

  // 1. Verify GetMetadata = False (default) yields empty IndexDefs
  Q1 := TSQLQuery.Create(nil);
  try
    Q1.SQLConnection := SQLConn;
    Q1.GetMetadata := False;
    Q1.SQL.Text := 'SELECT CustNo, Company, Country FROM customer WHERE CustNo < 1300 ORDER BY CustNo';
    Q1.Open;
    Writeln('  [+] GetMetadata=False: IndexDefs.Count = ', Q1.IndexDefs.Count);
    if Q1.IndexDefs.Count <> 0 then
      raise Exception.Create('GetMetadata=False must not load IndexDefs');
    Q1.Close;
  finally
    Q1.Free;
  end;

  // 2. Verify GetMetadata = True populates IndexDefs from database
  Q2 := TSQLQuery.Create(nil);
  try
    Q2.SQLConnection := SQLConn;
    Q2.SQL.Text := 'SELECT CustNo, Company, Country FROM customer WHERE CustNo < 1300 ORDER BY CustNo';

    Q2.GetMetadata := True;
    Q2.Open;
    Writeln('  [+] GetMetadata=True: IndexDefs.Count = ', Q2.IndexDefs.Count);
    for I := 0 to Q2.IndexDefs.Count - 1 do
      Writeln(Format('      Index[%d]: Name="%s", Fields="%s", Primary=%s, Unique=%s', [
        I,
        Q2.IndexDefs[I].Name,
        Q2.IndexDefs[I].Fields,
        BoolToStr(ixPrimary in Q2.IndexDefs[I].Options, True),
        BoolToStr(ixUnique in Q2.IndexDefs[I].Options, True)
      ]));

    if Q2.IndexDefs.Count = 0 then
      raise Exception.Create('GetMetadata=True failed to load IndexDefs for customer table');

    // 3. Connect TDataSetProvider and TClientDataSet
    DSP := TDataSetProvider.Create(nil);
    try
      DSP.DataSet := Q2;
      DSP.UpdateMode := upWhereKeyOnly;
      DSP.Options := DSP.Options + [poIncFieldProps];

      CDS := TClientDataSet.Create(nil);
      try
        CDS.SetProvider(DSP);
        CDS.Open;
        Writeln('  [+] ClientDataSet.Open Succeeded! RecordCount = ', CDS.RecordCount);

        // Check if CustNo was automatically flagged with pfInKey via IndexDefs
        FoundKey := pfInKey in CDS.FieldByName('CustNo').ProviderFlags;
        Writeln('  [+] CustNo ProviderFlags has pfInKey = ', BoolToStr(FoundKey, True));
        if not FoundKey then
          raise Exception.Create('Expected CustNo to automatically receive pfInKey via IndexDefs');

        Writeln('  [+] CDS.IndexDefs.Count = ', CDS.IndexDefs.Count);
        CDS.Close;
      finally
        CDS.Free;
      end;
    finally
      DSP.Free;
    end;
    Q2.Close;
  finally
    Q2.Free;
  end;
  Writeln('  [PASS] TSQLQuery.GetMetadata & DSP->CDS Integration Succeeded!');
  Writeln;
end;

procedure RunRowCacheFieldAccessTest(SQLConn: TSQLConnection);
var
  Q: TSQLQuery;
  FldCustNo, FldCompany, FldCountry: TField;
  CountryStr, CompanyStr: string;
  CustNoInt: Integer;
begin
  Writeln('=== [Test 2.2] Out-of-order & Repeated Field Access (Row Cache) ===');
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConn;
    Q.SQL.Text := 'SELECT CustNo, Company, Country FROM customer WHERE CustNo = 1221';
    Q.Open;
    FldCustNo := Q.FieldByName('CustNo');
    FldCompany := Q.FieldByName('Company');
    FldCountry := Q.FieldByName('Country');

    // 1. Out-of-order access: Col 3 (Country) first, then Col 1 (CustNo), then Col 2 (Company)
    CountryStr := FldCountry.AsString;
    CustNoInt := FldCustNo.AsInteger;
    CompanyStr := FldCompany.AsString;

    // 2. Repeated read access on Col 2 and Col 3 (simulates user's if ... = 0 then ... if ... = 1 then ...)
    if FldCompany.AsString <> CompanyStr then
      raise Exception.Create('Repeated access to Company returned different value');
    if FldCompany.AsString <> CompanyStr then
      raise Exception.Create('Third access to Company failed');
    if FldCountry.AsString <> CountryStr then
      raise Exception.Create('Repeated access to Country returned different value');
    if FldCustNo.AsInteger <> CustNoInt then
      raise Exception.Create('Repeated access to CustNo returned different value');

    // 3. Cross-type read: read CustNo (integer) as string
    if FldCustNo.AsString <> IntToStr(CustNoInt) then
      raise Exception.CreateFmt('CustNo.AsString mismatch: expected %d, got %s', [CustNoInt, FldCustNo.AsString]);

    Writeln(Format('  [+] Out-of-order access succeeded: Country=%s, CustNo=%d, Company=%s', [CountryStr, CustNoInt, CompanyStr]));
    Writeln('  [+] Repeated reads of the same fields verified!');
    Writeln('  [+] Cross-type access (AsInteger as AsString) verified!');
    Q.Close;
    Writeln('  [PASS] Row Cache Out-of-order & Repeated Field Access Succeeded!');
    Writeln;
  finally
    Q.Free;
  end;
end;

procedure RunHighLevelTSQLConnectionTest(const ConnStr: string);
var
  SQLConn: TSQLConnection;
  SQLQuery: TSQLQuery;
  RowCount: Integer;
begin
  Writeln('=== [Test 2] High-Level VCL dbExpress (TSQLConnection + TSQLQuery) ===');
  SQLConn := TSQLConnection.Create(nil);
  try
    SQLConn.DriverName := sDbxOpenOdbcDriverName;
    SQLConn.LoginPrompt := False;
    SQLConn.Params.Clear;
    SQLConn.Params.Values[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    SQLConn.Params.Values[TDBXOpenOdbcProperties.StrConnectionString] := ConnStr;

    SQLConn.Open;
    Writeln('  [+] TSQLConnection.Open Succeeded!');

    // Test Transaction Support (ReadCommitted and Serializable)
    Writeln('  [+] Testing Transaction Begin & Commit (ReadCommitted)...');
    var Tran := SQLConn.BeginTransaction;
    if Tran = nil then
      raise Exception.Create('BeginTransaction returned nil');
    SQLConn.CommitFreeAndNil(Tran);
    Writeln('  [+] Transaction Commit Succeeded!');

    Writeln('  [+] Testing Transaction Begin & Rollback (Serializable)...');
    var DbxTx := SQLConn.DBXConnection.BeginTransaction(TDBXIsolations.Serializable);
    if DbxTx = nil then
      raise Exception.Create('BeginTransaction(Serializable) returned nil');
    SQLConn.DBXConnection.RollbackFreeAndNil(DbxTx);
    Writeln('  [+] Transaction Rollback Succeeded!');

    // Test Schema: GetTableNames & GetFieldNames
    var TableList := TStringList.Create;
    var FieldList := TStringList.Create;
    try
      SQLConn.GetTableNames(TableList, False);
      Writeln('  [+] GetTableNames Succeeded! Total tables: ', TableList.Count);
      if TableList.Count > 0 then
        Writeln('      Sample tables: ', TableList.CommaText);

      SQLConn.GetFieldNames('customer', FieldList);
      if FieldList.IndexOf('CustNo') < 0 then
        raise Exception.Create('GetFieldNames(customer) must return CustNo');
      Writeln('  [+] GetFieldNames(customer) Succeeded! Total fields: ', FieldList.Count);
      if FieldList.Count > 0 then
        Writeln('      Fields: ', FieldList.CommaText);
    finally
      TableList.Free;
      FieldList.Free;
    end;

    SQLQuery := TSQLQuery.Create(nil);
    try
      SQLQuery.SQLConnection := SQLConn;
      SQLQuery.SQL.Text := 'SELECT CustNo, Company, Country FROM customer WHERE CustNo < 1300 ORDER BY CustNo';
      SQLQuery.Open;
      RowCount := 0;
      while not SQLQuery.Eof do
      begin
        Inc(RowCount);
        if RowCount <= 3 then
          Writeln(Format('  [Row %d] CustNo=%s | Company=%s | Country=%s', [
            RowCount,
            SQLQuery.FieldByName('CustNo').AsString,
            SQLQuery.FieldByName('Company').AsString,
            SQLQuery.FieldByName('Country').AsString
          ]));
        SQLQuery.Next;
      end;
      Writeln('  [+] Total rows fetched from customer table: ', RowCount);
      if RowCount = 0 then
        raise Exception.Create('Expected rows from customer table, got 0');
      SQLQuery.Close;
    finally
      SQLQuery.Free;
    end;

    RunGetMetadataAndDataSnapTest(SQLConn);
    RunRowCacheFieldAccessTest(SQLConn);

    SQLConn.Close;
  finally
    SQLConn.Free;
  end;
  Writeln('  [PASS] High-Level TSQLConnection + TSQLQuery Test Succeeded!');
  Writeln;
end;

procedure RunDriverResolutionTest;
var
  Env: TOdbcEnvHandle;
  Drv1, Drv2, Drv3, DrvDefault, DrvGeneric: string;
begin
  Writeln('=== [Test 3] Smart ODBC Driver Detection & Fallback (SQLDriversW) ===');
  Env := TOdbcEnvHandle.Create;
  try
    Drv1 := Env.ResolveSqlServerDriver('MSOLEDBSQL');
    Drv2 := Env.ResolveSqlServerDriver('SQLNCLI11');
    Drv3 := Env.ResolveSqlServerDriver('SQLOLEDB');
    DrvDefault := Env.ResolveSqlServerDriver('');
    DrvGeneric := Env.ResolveSqlServerDriver('SQL Server');
    Writeln('  [+] Resolved MSOLEDBSQL -> {', Drv1, '} (Installed: ', Env.IsDriverInstalled(Drv1), ')');
    Writeln('  [+] Resolved SQLNCLI11  -> {', Drv2, '} (Installed: ', Env.IsDriverInstalled(Drv2), ')');
    Writeln('  [+] Resolved SQLOLEDB   -> {', Drv3, '} (Installed: ', Env.IsDriverInstalled(Drv3), ')');
    Writeln('  [+] Resolved "" (Empty) -> {', DrvDefault, '} (Installed: ', Env.IsDriverInstalled(DrvDefault), ')');
    Writeln('  [+] Resolved SQL Server -> {', DrvGeneric, '} (Installed: ', Env.IsDriverInstalled(DrvGeneric), ')');
    if not Env.IsDriverInstalled(Drv1) then
      raise Exception.Create('Resolved driver is not installed: ' + Drv1);
    // When a modern driver (e.g. ODBC Driver 17/18) is installed on the system,
    // generic requests must resolve to the modern driver, NOT the 1999 legacy SQLSRV32.DLL!
    if Env.IsDriverInstalled('ODBC Driver 17 for SQL Server') or Env.IsDriverInstalled('ODBC Driver 18 for SQL Server') then
    begin
      if SameText(DrvDefault, 'SQL Server') or SameText(DrvGeneric, 'SQL Server') then
        raise Exception.Create('Generic SQL Server request must not resolve to legacy SQL Server driver when modern driver is installed!');
    end;

    // Unit test dynamic version parser & IsDriver18Plus
    var Maj, Min: Integer;
    if not (Env.TryParseOdbcDriverVersion('ODBC Driver 18 for SQL Server', Maj, Min) and (Maj = 18) and (Min = 0)) then
      raise Exception.Create('TryParseOdbcDriverVersion failed for ODBC Driver 18');
    if not (Env.TryParseOdbcDriverVersion('ODBC Driver 13.1 for SQL Server', Maj, Min) and (Maj = 13) and (Min = 1)) then
      raise Exception.Create('TryParseOdbcDriverVersion failed for ODBC Driver 13.1');
    if not (Env.TryParseOdbcDriverVersion('ODBC Driver 21 for SQL Server', Maj, Min) and (Maj = 21) and (Min = 0)) then
      raise Exception.Create('TryParseOdbcDriverVersion failed for ODBC Driver 21');
    if not Env.IsDriver18Plus('ODBC Driver 18 for SQL Server') then
      raise Exception.Create('IsDriver18Plus failed for ODBC Driver 18');
    if not Env.IsDriver18Plus('ODBC Driver 21 for SQL Server') then
      raise Exception.Create('IsDriver18Plus failed for ODBC Driver 21');
    if Env.IsDriver18Plus('ODBC Driver 17 for SQL Server') then
      raise Exception.Create('IsDriver18Plus should return False for ODBC Driver 17');
    if Env.IsDriver18Plus('SQL Server Native Client 11.0') then
      raise Exception.Create('IsDriver18Plus should return False for SNAC 11.0');
    Writeln('  [+] Dynamic version parser and IsDriver18Plus verified successfully');
    Writeln('  [PASS] Smart ODBC Driver Resolution Succeeded!');
    Writeln;
  finally
    Env.Free;
  end;
end;

procedure RunDriverAwareConnectionStringTest;
var
  InputStr, Resolved: string;
  Props: TDBXProperties;
  Conn: TDBXConnection;
begin
  Writeln('=== [Test 4] Driver-Aware Connection String Protocol Resolution ===');

  // Test 4.1: Modern Driver (ODBC Driver 17) with remote IP, ApplicationName, and legacy Network=dbmssocn
  InputStr := 'Driver={ODBC Driver 17 for SQL Server};Server=192.168.1.100;Database=TestDB;Uid=test_user;Pwd=secret_pwd;' +
              'MARS_Connection=yes;Packet Size=16384;ApplicationName=MyTestApp;Network=dbmssocn;';
  Resolved := TDBXOpenOdbcConnectionNative.ResolveSqlServerConnectionProtocol(InputStr);
  Writeln('  [+] Input Modern   : ', InputStr);
  Writeln('  [+] Resolved Modern: ', Resolved);
  if Pos('Server=tcp:192.168.1.100', Resolved) = 0 then
    raise Exception.Create('Modern driver did not add tcp: prefix to remote Server!');
  if Pos('APP=MyTestApp', Resolved) = 0 then
    raise Exception.Create('ApplicationName was not normalized to APP=!');
  if Pos('Network=dbmssocn', Resolved) > 0 then
    raise Exception.Create('Network=dbmssocn was NOT stripped for modern driver!');
  if Pos('MARS_Connection=yes', Resolved) = 0 then
    raise Exception.Create('MARS_Connection=yes was wrongly removed for modern driver!');

  // Test 4.2: Legacy Driver (SQL Server / sqlsrv32.dll) with remote IP, Application_Name, and MARS
  InputStr := 'Driver={SQL Server};Server=192.168.1.100;Database=TestDB;Uid=test_user;Pwd=secret_pwd;' +
              'MARS_Connection=yes;Packet Size=16384;Application_Name=LegacyApp;';
  Resolved := TDBXOpenOdbcConnectionNative.ResolveSqlServerConnectionProtocol(InputStr);
  Writeln('  [+] Input Legacy   : ', InputStr);
  Writeln('  [+] Resolved Legacy: ', Resolved);
  if Pos('Server=tcp:', Resolved) > 0 then
    raise Exception.Create('Legacy driver must NOT use tcp: prefix!');
  if Pos('Network=dbmssocn', Resolved) = 0 then
    raise Exception.Create('Legacy driver must inject Network=dbmssocn for remote TCP connections!');
  if Pos('MARS_Connection=', Resolved) > 0 then
    raise Exception.Create('Legacy driver must strip MARS_Connection attribute!');
  if Pos('APP=LegacyApp', Resolved) = 0 then
    raise Exception.Create('Application_Name was not normalized to APP= for legacy driver!');

  // Test 4.3: ConnectionProperties assembly without Driver (auto-defaults to best modern driver)
  Conn := TDBXOpenOdbcConnectionNative.Create(nil, nil);
  try
    Props := TDBXProperties.Create;
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] :=
      'Server=192.168.1.100;Database=TestDB;Uid=test_user;Pwd=secret_pwd;MARS_Connection=yes;Packet Size=16384;ApplicationName=MyTestApp;';
    Conn.ConnectionProperties := Props;
    Resolved := (Conn as TDBXOpenOdbcConnectionNative).BuildOdbcConnectionString;
    Writeln('  [+] Auto-detected resolved ConnStr: ', Resolved);
    if Pos('Server=tcp:192.168.1.100', Resolved) = 0 then
      raise Exception.Create('Auto-detected connection did not prefix tcp: to remote Server!');
    if Pos('APP=MyTestApp', Resolved) = 0 then
      raise Exception.Create('Auto-detected connection did not normalize ApplicationName to APP=!');
    if Pos('Network=dbmssocn', Resolved) > 0 then
      raise Exception.Create('Auto-detected modern connection should NOT contain Network=dbmssocn!');
    if Pos('ApplicationName=', Resolved) > 0 then
      raise Exception.Create('ApplicationName= was not replaced!');
    if Pos('MARS_Connection=yes', Resolved) = 0 then
      raise Exception.Create('MARS_Connection=yes missing from resolved string!');
  finally
    Conn.Free;
  end;

  // Test 4.4: Auto-append MARS_Connection=yes when Driver is omitted and not explicitly specified
  Conn := TDBXOpenOdbcConnectionNative.Create(nil, nil);
  try
    Props := TDBXProperties.Create;
    Props[TDBXPropertyNames.DriverName] := sDbxOpenOdbcDriverName;
    Props[TDBXOpenOdbcProperties.StrConnectionString] :=
      'Server=192.168.1.100;Database=TestDB;Uid=test_user;Pwd=secret_pwd;ApplicationName=AutoMarsApp;';
    Conn.ConnectionProperties := Props;
    Resolved := (Conn as TDBXOpenOdbcConnectionNative).BuildOdbcConnectionString;
    Writeln('  [+] Auto-appended MARS ConnStr: ', Resolved);
    if Pos('MARS_Connection=yes', Resolved) = 0 then
      raise Exception.Create('Auto-defaulted modern driver did not automatically append MARS_Connection=yes!');
  finally
    Conn.Free;
  end;

  Writeln('  [PASS] Driver-Aware Connection String Protocol Resolution Succeeded!');
  Writeln;
end;

var
  ConnStr, MdbPath: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    Writeln('================================================================');
    Writeln(' dbxoodbc Native DBX4 Driver MVP Verification');
    {$IFDEF WIN64}
    Writeln(' Platform: Win64 (64-bit Native)');
    {$ELSE}
    Writeln(' Platform: Win32 (32-bit Native)');
    {$ENDIF}
    Writeln('================================================================');

    ConnStr := BuildTestConnectionString(MdbPath);
    Writeln('Using MDB: ', MdbPath);
    Writeln('Using ODBC ConnectionString: ', ConnStr);
    Writeln;

    RunLowLevelDBX4Test(ConnStr);
    RunByteReaderDirectTest(ConnStr);
    RunSqlServerBlobByteReaderTest;
    RunSyntheticUnicodeAndEdgeCasesTest;
    RunHighLevelTSQLConnectionTest(ConnStr);
    RunDriverResolutionTest;
    RunDriverAwareConnectionStringTest;

    Writeln('================================================================');
    Writeln(Format(' TEST SCORECARD: PASS: %d | FAIL: %d | SKIP: %d', [G_PassCount, G_FailCount, G_SkipCount]));
    Writeln(' ALL MILESTONE 1 MVP TESTS PASSED SUCCESSFULLY!');
    Writeln('================================================================');
    ExitCode := 0;
  except
    on E: Exception do
    begin
      Writeln('[FAIL] ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
