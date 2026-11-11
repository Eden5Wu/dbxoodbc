unit DbxOpenOdbcPool;

{===============================================================================
 Open DBX4 ODBC Driver Remastered (dbx4odbc)
 Pure Native Delphi dbExpress (DBX4) Driver for ODBC (Win32 & Win64)
 File: DbxOpenOdbcPool.pas
 Description: Native Thread-Safe Connection Pool with Multi-DBMS Dialect Isolation
 ===============================================================================}

{$B-}
{$R-}

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  System.Generics.Collections,
  System.DateUtils,
  Data.DBXCommon,
  Data.DBXPlatform,
  OdbcApi,
  DbxOpenOdbcDialects,
  DbxOpenOdbcCore;

type
  TOdbcPoolConfig = record
    Enabled: Boolean;
    OdbcDriverPooling: Boolean;
    MaxPoolSize: Integer;
    MinPoolSize: Integer;
    ConnectionTimeoutSec: Integer;
    ConnectionLifetimeSec: Integer;
    ValidateOnBorrow: Boolean;
    class function FromProperties(const AProps: TDBXProperties; const AConnStr: string): TOdbcPoolConfig; static;
  end;

  TOdbcPooledConnection = class
  private
    FHandle: TOdbcConnectionHandle;
    FCreatedTime: TDateTime;
    FLastUsedTime: TDateTime;
  public
    constructor Create(AHandle: TOdbcConnectionHandle);
    destructor Destroy; override;
    procedure DetachHandle;
    property Handle: TOdbcConnectionHandle read FHandle;
    property CreatedTime: TDateTime read FCreatedTime;
    property LastUsedTime: TDateTime read FLastUsedTime write FLastUsedTime;
  end;

  TOdbcSubPool = class
  private
    FLock: TCriticalSection;
    FKey: string;
    FEnv: TOdbcEnvHandle;
    FIdleList: TList<TOdbcPooledConnection>;
    FActiveCount: Integer;
    FMaxPoolSize: Integer;
    FMinPoolSize: Integer;
    FConnectionTimeoutSec: Integer;
    FConnectionLifetimeSec: Integer;
    FValidateOnBorrow: Boolean;
    function GetIdleCount: Integer;
  public
    constructor Create(const AKey: string; AEnv: TOdbcEnvHandle;
      const AConfig: TOdbcPoolConfig);
    destructor Destroy; override;

    function Acquire(out AHandle: TOdbcConnectionHandle): Boolean;
    procedure Release(AHandle: TOdbcConnectionHandle);
    procedure Clear;

    property Key: string read FKey;
    property ActiveCount: Integer read FActiveCount;
    property IdleCount: Integer read GetIdleCount;
  end;

  TOdbcConnectionPool = class
  private
    FLock: TCriticalSection;
    FPools: TObjectDictionary<string, TOdbcSubPool>;
    function NormalizeKey(const AConnStr: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    function AcquireConnection(const AConnStr: string;
      const AConfig: TOdbcPoolConfig; AEnv: TOdbcEnvHandle;
      out AHandle: TOdbcConnectionHandle): Boolean;
    procedure ReleaseConnection(const AConnStr: string; AHandle: TOdbcConnectionHandle);
    procedure Clear;
    function GetPoolStats(const AConnStr: string; out ActiveCount, IdleCount: Integer): Boolean;
  end;

implementation

{ TOdbcPoolConfig }

class function TOdbcPoolConfig.FromProperties(const AProps: TDBXProperties;
  const AConnStr: string): TOdbcPoolConfig;
var
  Val, BackendVal, UpperConnStr: string;
begin
  Result.Enabled := False;
  Result.OdbcDriverPooling := False;
  Result.MaxPoolSize := 50;
  Result.MinPoolSize := 0;
  Result.ConnectionTimeoutSec := 30;
  Result.ConnectionLifetimeSec := 300;
  Result.ValidateOnBorrow := True;

  UpperConnStr := UpperCase(AConnStr);

  // 1. Pooling Enabled & Backend Check
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pooling']);
    if Val = '' then Val := Trim(AProps.Values['Pool']);
    if Val = '' then Val := Trim(AProps.Values['ConnectionPooling']);
    BackendVal := Trim(AProps.Values['Pool.Backend']);
    if BackendVal = '' then BackendVal := Trim(AProps.Values['OdbcPooling']);
  end
  else
  begin
    Val := '';
    BackendVal := '';
  end;

  if SameText(Val, 'Odbc') or SameText(Val, 'DriverManager') or
     SameText(BackendVal, 'Odbc') or SameText(BackendVal, 'DriverManager') or
     SameText(BackendVal, 'True') or (Pos('POOLING=ODBC', UpperConnStr) > 0) then
  begin
    Result.OdbcDriverPooling := True;
    Result.Enabled := False;
    Exit;
  end;

  if Val <> '' then
    Result.Enabled := SameText(Val, 'True') or (Val = '1') or SameText(Val, 'Yes') or SameText(Val, 'Custom') or SameText(Val, 'Native')
  else
  begin
    Result.Enabled := (Pos('POOLING=TRUE', UpperConnStr) > 0) or
                      (Pos('POOLING=1', UpperConnStr) > 0) or
                      (Pos('POOLING=YES', UpperConnStr) > 0);
  end;

  if not Result.Enabled then
    Exit;

  // 2. MaxPoolSize
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pool.MaxPoolSize']);
    if Val = '' then Val := Trim(AProps.Values['MaxPoolSize']);
    if Val = '' then Val := Trim(AProps.Values['MaxConnections']);
    if Val = '' then Val := Trim(AProps.Values['Max Connection']);
  end
  else
    Val := '';

  if Val <> '' then
    Result.MaxPoolSize := StrToIntDef(Val, 50);
  if Result.MaxPoolSize <= 0 then
    Result.MaxPoolSize := 50;

  // 3. MinPoolSize
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pool.MinPoolSize']);
    if Val = '' then Val := Trim(AProps.Values['MinPoolSize']);
    if Val = '' then Val := Trim(AProps.Values['MinConnections']);
  end
  else
    Val := '';

  if Val <> '' then
    Result.MinPoolSize := StrToIntDef(Val, 0);
  if Result.MinPoolSize < 0 then
    Result.MinPoolSize := 0;

  // 4. ConnectionTimeout
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pool.ConnectionTimeout']);
    if Val = '' then Val := Trim(AProps.Values['ConnectionTimeout']);
    if Val = '' then Val := Trim(AProps.Values['ConnectTimeout']);
  end
  else
    Val := '';

  if Val <> '' then
    Result.ConnectionTimeoutSec := StrToIntDef(Val, 30);
  if Result.ConnectionTimeoutSec <= 0 then
    Result.ConnectionTimeoutSec := 30;

  // 5. ConnectionLifetime
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pool.ConnectionLifetime']);
    if Val = '' then Val := Trim(AProps.Values['ConnectionLifetime']);
  end
  else
    Val := '';

  if Val <> '' then
    Result.ConnectionLifetimeSec := StrToIntDef(Val, 300);

  // 6. ValidateOnBorrow
  if AProps <> nil then
  begin
    Val := Trim(AProps.Values['Pool.ValidateOnBorrow']);
    if Val = '' then Val := Trim(AProps.Values['ValidateOnBorrow']);
  end
  else
    Val := '';

  if Val <> '' then
    Result.ValidateOnBorrow := not (SameText(Val, 'False') or (Val = '0') or SameText(Val, 'No'))
  else
    Result.ValidateOnBorrow := True;
end;

{ TOdbcPooledConnection }

constructor TOdbcPooledConnection.Create(AHandle: TOdbcConnectionHandle);
begin
  inherited Create;
  FHandle := AHandle;
  FCreatedTime := Now;
  FLastUsedTime := FCreatedTime;
end;

destructor TOdbcPooledConnection.Destroy;
begin
  if FHandle <> nil then
  begin
    FHandle.Disconnect;
    FreeAndNil(FHandle);
  end;
  inherited;
end;

procedure TOdbcPooledConnection.DetachHandle;
begin
  FHandle := nil;
end;

{ TOdbcSubPool }

constructor TOdbcSubPool.Create(const AKey: string; AEnv: TOdbcEnvHandle;
  const AConfig: TOdbcPoolConfig);
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FKey := AKey;
  FEnv := AEnv;
  FIdleList := TList<TOdbcPooledConnection>.Create;
  FActiveCount := 0;
  FMaxPoolSize := AConfig.MaxPoolSize;
  FMinPoolSize := AConfig.MinPoolSize;
  FConnectionTimeoutSec := AConfig.ConnectionTimeoutSec;
  FConnectionLifetimeSec := AConfig.ConnectionLifetimeSec;
  FValidateOnBorrow := AConfig.ValidateOnBorrow;
end;

destructor TOdbcSubPool.Destroy;
begin
  Clear;
  FreeAndNil(FIdleList);
  FreeAndNil(FLock);
  inherited;
end;

procedure TOdbcSubPool.Clear;
var
  Index: Integer;
begin
  FLock.Enter;
  try
    for Index := 0 to FIdleList.Count - 1 do
      FIdleList[Index].Free;
    FIdleList.Clear;
  finally
    FLock.Leave;
  end;
end;

function TOdbcSubPool.GetIdleCount: Integer;
begin
  FLock.Enter;
  try
    Result := FIdleList.Count;
  finally
    FLock.Leave;
  end;
end;

function TOdbcSubPool.Acquire(out AHandle: TOdbcConnectionHandle): Boolean;
var
  StartTime: Cardinal;
  WaitMs: Cardinal;
  PooledConn: TOdbcPooledConnection;
  IsDead: Boolean;
  ShouldCreate: Boolean;
begin
  AHandle := nil;
  StartTime := TThread.GetTickCount;
  WaitMs := Cardinal(FConnectionTimeoutSec) * 1000;

  while True do
  begin
    ShouldCreate := False;
    FLock.Enter;
    try
      // 1. Check idle list for reusable healthy connection
      while FIdleList.Count > 0 do
      begin
        PooledConn := FIdleList[FIdleList.Count - 1];
        FIdleList.Delete(FIdleList.Count - 1);

        // Check lifetime expiration
        if (FConnectionLifetimeSec > 0) and
           (SecondsBetween(Now, PooledConn.CreatedTime) > FConnectionLifetimeSec) then
        begin
          PooledConn.Free;
          Continue;
        end;

        // Check socket health / dead connection
        IsDead := False;
        if FValidateOnBorrow then
        begin
          if PooledConn.Handle.IsConnectionDead then
            IsDead := True
          else if not PooledConn.Handle.Ping then
            IsDead := True;
        end;

        if IsDead then
        begin
          PooledConn.Free;
          Continue;
        end;

        // Healthy pooled connection successfully acquired!
        AHandle := PooledConn.Handle;
        PooledConn.DetachHandle;
        PooledConn.Free;
        Inc(FActiveCount);
        Exit(True);
      end;

      // 2. If no idle connection, can we create a new physical connection?
      if FActiveCount < FMaxPoolSize then
      begin
        Inc(FActiveCount);
        ShouldCreate := True;
      end;
    finally
      FLock.Leave;
    end;

    // 3. Create new connection outside lock to avoid blocking other threads during TCP handshake
    if ShouldCreate then
    begin
      try
        AHandle := TOdbcConnectionHandle.Create(FEnv, False);
        AHandle.Connect(FKey);
        Exit(True);
      except
        FLock.Enter;
        try
          Dec(FActiveCount);
        finally
          FLock.Leave;
        end;
        raise;
      end;
    end;

    // 4. Pool exhausted: wait with timeout
    if (TThread.GetTickCount - StartTime) >= WaitMs then
      raise TDBXError.Create(TDBXErrorCodes.ConnectionFailed,
        Format('Connection pool exhausted: reached MaxPoolSize (%d) for connection string "%s" (timeout %d s)',
          [FMaxPoolSize, FKey, FConnectionTimeoutSec]));

    Sleep(10);
  end;
end;

procedure TOdbcSubPool.Release(AHandle: TOdbcConnectionHandle);
begin
  if (AHandle = nil) or (not AHandle.Connected) then
  begin
    FLock.Enter;
    try
      if FActiveCount > 0 then
        Dec(FActiveCount);
    finally
      FLock.Leave;
    end;
    FreeAndNil(AHandle);
    Exit;
  end;

  // 1. Clean up active uncommitted transaction
  if AHandle.InTransaction then
  begin
    try
      AHandle.Rollback;
    except
      AHandle.Disconnect;
      FreeAndNil(AHandle);
      FLock.Enter;
      try
        if FActiveCount > 0 then Dec(FActiveCount);
      finally
        FLock.Leave;
      end;
      Exit;
    end;
  end;

  // 2. Multi-DBMS Dialect Session Reset (e.g., MSSQL sp_reset_connection, Oracle package reset)
  if AHandle.Dialect <> nil then
  begin
    try
      AHandle.Dialect.ResetSession(AHandle.HDbc);
    except
      AHandle.Disconnect;
      FreeAndNil(AHandle);
      FLock.Enter;
      try
        if FActiveCount > 0 then Dec(FActiveCount);
      finally
        FLock.Leave;
      end;
      Exit;
    end;
  end;

  // 3. Return to idle list under lock
  FLock.Enter;
  try
    if FActiveCount > 0 then
      Dec(FActiveCount);

    if FIdleList.Count < FMaxPoolSize then
      FIdleList.Add(TOdbcPooledConnection.Create(AHandle))
    else
    begin
      AHandle.Disconnect;
      FreeAndNil(AHandle);
    end;
  finally
    FLock.Leave;
  end;
end;

{ TOdbcConnectionPool }

constructor TOdbcConnectionPool.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FPools := TObjectDictionary<string, TOdbcSubPool>.Create([doOwnsValues]);
end;

destructor TOdbcConnectionPool.Destroy;
begin
  Clear;
  FreeAndNil(FPools);
  FreeAndNil(FLock);
  inherited;
end;

function TOdbcConnectionPool.NormalizeKey(const AConnStr: string): string;
begin
  Result := Trim(AConnStr);
  while (Result <> '') and (Result[Length(Result)] = ';') do
    Delete(Result, Length(Result), 1);
end;

function TOdbcConnectionPool.AcquireConnection(const AConnStr: string;
  const AConfig: TOdbcPoolConfig; AEnv: TOdbcEnvHandle;
  out AHandle: TOdbcConnectionHandle): Boolean;
var
  Key: string;
  SubPool: TOdbcSubPool;
begin
  Key := NormalizeKey(AConnStr);

  FLock.Enter;
  try
    if not FPools.TryGetValue(Key, SubPool) then
    begin
      SubPool := TOdbcSubPool.Create(Key, AEnv, AConfig);
      FPools.Add(Key, SubPool);
    end;
  finally
    FLock.Leave;
  end;

  Result := SubPool.Acquire(AHandle);
end;

procedure TOdbcConnectionPool.ReleaseConnection(const AConnStr: string;
  AHandle: TOdbcConnectionHandle);
var
  Key: string;
  SubPool: TOdbcSubPool;
begin
  if AHandle = nil then
    Exit;

  Key := NormalizeKey(AConnStr);

  FLock.Enter;
  try
    FPools.TryGetValue(Key, SubPool);
  finally
    FLock.Leave;
  end;

  if SubPool <> nil then
    SubPool.Release(AHandle)
  else
  begin
    AHandle.Disconnect;
    AHandle.Free;
  end;
end;

procedure TOdbcConnectionPool.Clear;
begin
  FLock.Enter;
  try
    FPools.Clear;
  finally
    FLock.Leave;
  end;
end;

function TOdbcConnectionPool.GetPoolStats(const AConnStr: string;
  out ActiveCount, IdleCount: Integer): Boolean;
var
  Key: string;
  SubPool: TOdbcSubPool;
begin
  ActiveCount := 0;
  IdleCount := 0;
  Key := NormalizeKey(AConnStr);

  FLock.Enter;
  try
    Result := FPools.TryGetValue(Key, SubPool);
    if Result and (SubPool <> nil) then
    begin
      ActiveCount := SubPool.ActiveCount;
      IdleCount := SubPool.IdleCount;
    end;
  finally
    FLock.Leave;
  end;
end;

end.
