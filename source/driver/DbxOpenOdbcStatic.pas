{
  Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.15

  Copyright (c) 2001-2012 Vadim V.Lopushansky

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public License
  as published by the Free Software Foundation; either version 2.1
  of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Home Page:
    https://sourceforge.net/projects/open-dbexpress/
}
unit DbxOpenOdbcStatic;

{$include DbxOpenOdbc_options.inc}

{$UNDEF _HOOK_DLL_}
{$IFDEF MSWINDOWS}
  {$IFDEF CPUX86}
    {$DEFINE _HOOK_DLL_}
  {$ENDIF}
{$ENDIF}

{$UNDEF _DBX40_} { not implemented it }

interface

function IsStatic(): Boolean;

implementation

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$IF CompilerVersion > 30}
  AnsiStrings,
  {$ENDIF}
  {$ENDIF}
  {$IFDEF _KYLIX_}
  Types,
  {$ENDIF}
  DbxOpenOdbcTypes,
  DbxOpenOdbc,
  {$IFDEF _DBX30_}
  DbxOpenOdbc3,
  {$IFDEF _DBX40_}
  DbxOpenOdbc34i,
  {$ENDIF}
  {$ENDIF}
  {$IFDEF _ASA_MESSAGE_CALLBACK_}
  DbxOpenOdbcASA,
  {$ENDIF}
  {$IFDEF _HOOK_DLL_}
  DbxOpenOdbcApiHook,
  {$ENDIF}
  DbxOpenOdbcTrace,
  SysUtils;

{$IFNDEF _HOOK_DLL_}

function IsStatic(): Boolean;
begin
  Result := False;
end;

{$ELSE _HOOK_DLL_}

const
  dbxoodbc = 'dbxoodbc.dll';

var
  {.$IFDEF MSWINDOWS}
  IATPatch: TIATPatch =  nil;
  {.$ENDIF}
  DllHandle: HMODULE = 0;

function IsStatic(): Boolean;
begin
  Result := DllHandle <> 0;
end;

var
  _LoadLibraryA: function (lpLibFileName: PAnsiChar): HMODULE; stdcall;

function NewLoadLibraryA(lpLibFileName: PAnsiChar): HMODULE; stdcall;
begin
  if (DllHandle <> 0) and SameText(ExtractFileName(string({$IF CompilerVersion > 30}AnsiStrings.{$ENDIF}StrPas(lpLibFileName))), dbxoodbc) then
    Result := DllHandle
  else
    Result := _LoadLibraryA(lpLibFileName);
end;

var
  _LoadLibraryW: function(lpLibFileName: PWideChar): HMODULE; stdcall;

function NewLoadLibraryW(lpLibFileName: PWideChar): HMODULE; stdcall;
begin
  if (DllHandle <> 0) and SameText(ExtractFileName(WideString(lpLibFileName)), dbxoodbc) then
    Result := DllHandle
  else
    Result := _LoadLibraryW(lpLibFileName);
end;

var
  _FreeLibrary: function (hLibModule: HMODULE): BOOL; stdcall;

function NewFreeLibrary(hLibModule: HMODULE): BOOL; stdcall;
begin
  if (DllHandle = 0) or (hLibModule <> DllHandle) then
    Result := _FreeLibrary(hLibModule)
  else
    Result := True;
end;

var
  _GetProcAddress: function (hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;

function NewGetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;

  procedure LDoGetProcAddress;
  var
    S: AnsiString;
  begin
    try
      if Assigned(lpProcName) and (not IsBadReadPtr(lpProcName,1)) and (lpProcName^ <> #0) then
        S := AnsiString(UpperCase(Trim(string({$IF CompilerVersion > 30}AnsiStrings.{$ENDIF}StrPas(lpProcName)))))
      else
        S := '';
    except
      S := '';
    end;
    if S = '' then
    begin
      Result := nil;
      Exit;
    end;
    {$IFDEF _DBX40_}
    if S = 'DBXLOADER_GETDRIVER' then
    begin
      Result := @DBXLoader_GetDriver;
    end
    else
    // IDBXCommonHandle
    if S = 'DBXBASE_GETERRORMESSAGELENGTH' then
    begin
      Result := @DBXBase_GetErrorMessageLength;
    end
    else
    if S = 'DBXBASE_GETERRORMESSAGE' then
    begin
      Result := @DBXBase_GetErrorMessage;
    end
    else
    if S = 'DBXBASE_CLOSE' then
    begin
      Result := @DBXBase_Close;
    end
    else
    // IDBXDriverHandle
    if S = 'DBXDRIVER_CREATECONNECTION' then
    begin
      Result := @DBXDriver_CreateConnection;
    end
    else
    if S = 'DBXDRIVER_GETVERSION' then
    begin
      Result := @DBXDriver_GetVersion;
    end
    else
    if S = 'DBXCONNECTION_CONNECT' then
    begin
      Result := @DBXConnection_Connect;
    end
    else
    // IDBXConnectionHandle
    if S = 'DBXCONNECTION_DISCONNECT' then
    begin
      Result := @DBXConnection_Disconnect;
    end
    else
    if S = 'DBXCONNECTION_SETCALLBACKEVENT' then
    begin
      Result := @DBXConnection_SetCallbackEvent;
    end
    else
    if S = 'DBXCONNECTION_CREATECOMMAND' then
    begin
      Result := @DBXConnection_CreateCommand;
    end
    else
    if S = 'DBXCONNECTION_GETMETADATA' then
    begin
      Result := @DBXConnection_GetMetaData;
    end
    else
    if S = 'DBXCONNECTION_BEGINTRANSACTION' then
    begin
      Result := @DBXConnection_BeginTransaction;
    end
    else
    if S = 'DBXCONNECTION_COMMIT' then
    begin
      Result := @DBXConnection_Commit;
    end
    else
    if S = 'DBXCONNECTION_ROLLBACK' then
    begin
      Result := @DBXConnection_Rollback;
    end
    else
    if S = 'DBXCONNECTION_GETISOLATION' then
    begin
      Result := @DBXConnection_GetIsolation;
    end
    else
    if S = 'DBXCONNECTION_GETVENDORPROPERTY' then
    begin
      Result := @DBXConnection_GetVendorProperty;
    end
    else
    // TODO:
    // IDBXCommandHandle
    if S = 'DBXCOMMAND_CREATEPARAMETERROW' then Result := Pointer(1){@DBXCommand_CreateParameterRow} else
    if S = 'DBXCOMMAND_PREPARE' then Result := Pointer(1){@DBXCommand_Prepare} else
    if S = 'DBXCOMMAND_EXECUTE' then Result := Pointer(1){@DBXCommand_Execute} else
    if S = 'DBXCOMMAND_EXECUTEIMMEDIATE' then Result := Pointer(1){@DBXCommand_ExecuteImmediate} else
    if S = 'DBXCOMMAND_GETNEXTREADER' then Result := Pointer(1){@DBXCommand_GetNextReader} else
    if S = 'DBXCOMMAND_GETROWSAFFECTED' then Result := Pointer(1){@DBXCommand_GetRowsAffected} else
    if S = 'DBXCOMMAND_SETMAXBLOBSIZE' then Result := Pointer(1){@DBXCommand_SetMaxBlobSize} else
    if S = 'DBXCOMMAND_SETROWSETSIZE' then Result := Pointer(1){@DBXCommand_SetRowSetSize} else
    // IDBXReaderHandle
    if S = 'DBXREADER_GETCOLUMNCOUNT' then Result := Pointer(1){@DBXReader_GetColumnCount} else
    if S = 'DBXREADER_GETCOLUMNMETADATA' then Result := Pointer(1){@DBXReader_GetColumnMetadata} else
    if S = 'DBXREADER_NEXT' then Result := Pointer(1){@DBXReader_Next} else
    // IDBXRowHandle
    if S = 'DBXROW_GETSTRING' then Result := Pointer(1){@DBXRow_GetString} else
    if S = 'DBXROW_GETWIDESTRING' then Result := Pointer(1){@DBXRow_GetWideString} else
    if S = 'DBXROW_GETBOOLEAN' then Result := Pointer(1){@DBXRow_GetBoolean} else
    if S = 'DBXROW_GETINT16' then Result := Pointer(1){@DBXRow_GetInt16} else
    if S = 'DBXROW_GETINT32' then Result := Pointer(1){@DBXRow_GetInt32} else
    if S = 'DBXROW_GETINT64' then Result := Pointer(1){@DBXRow_GetInt64} else
    if S = 'DBXROW_GETDOUBLE' then Result := Pointer(1){@DBXRow_GetDouble} else
    if S = 'DBXROW_GETBCD' then Result := Pointer(1){@DBXRow_GetBcd} else
    if S = 'DBXROW_GETTIMESTAMP' then Result := Pointer(1){@DBXRow_GetTimeStamp} else
    if S = 'DBXROW_GETTIME' then Result := Pointer(1){@DBXRow_GetTime} else
    if S = 'DBXROW_GETDATE' then Result := Pointer(1){@DBXRow_GetDate} else
    if S = 'DBXROW_GETBYTES' then Result := Pointer(1){@DBXRow_GetBytes} else
    if S = 'DBXROW_GETFIXEDBYTES' then Result := Pointer(1){@DBXRow_GetFixedBytes} else
    if S = 'DBXROW_GETBYTELENGTH' then Result := Pointer(1){@DBXRow_GetByteLength} else
    if S = 'DBXROW_GETOBJECTTYPENAME' then Result := Pointer(1){@DBXRow_GetObjectTypeName} else
    if S = 'DBXPARAMETERROW_SETPARAMETERTYPE' then Result := Pointer(1){@DBXParameterRow_SetParameterType} else
    // IDBXWritableRowHandle
    if S = 'DBXWRITABLEROW_SETNULL' then Result := Pointer(1){@DBXWritableRow_SetNull} else
    if S = 'DBXWRITABLEROW_SETSTRING' then Result := Pointer(1){@DBXWritableRow_SetString} else
    if S = 'DBXWRITABLEROW_SETWIDESTRING' then Result := Pointer(1){@DBXWritableRow_SetWideString} else
    if S = 'DBXWRITABLEROW_SETBOOLEAN' then Result := Pointer(1){@DBXWritableRow_SetBoolean} else
    if S = 'DBXWRITABLEROW_SETINT16' then Result := Pointer(1){@DBXWritableRow_SetInt16} else
    if S = 'DBXWRITABLEROW_SETINT32' then Result := Pointer(1){@DBXWritableRow_SetInt32} else
    if S = 'DBXWRITABLEROW_SETINT64' then Result := Pointer(1){@DBXWritableRow_SetInt64} else
    if S = 'DBXWRITABLEROW_SETDOUBLE' then Result := Pointer(1){@DBXWritableRow_SetDouble} else
    if S = 'DBXWRITABLEROW_SETBCD' then Result := Pointer(1){@DBXWritableRow_SetBcd} else
    if S = 'DBXWRITABLEROW_SETTIMESTAMP' then Result := Pointer(1){@DBXWritableRow_SetTimeStamp} else
    if S = 'DBXWRITABLEROW_SETTIME' then Result := Pointer(1){@DBXWritableRow_SetTime} else
    if S = 'DBXWRITABLEROW_SETDATE' then Result := Pointer(1){@DBXWritableRow_SetDate} else
    if S = 'DBXWRITABLEROW_SETBYTES' then Result := Pointer(1){@DBXWritableRow_SetBytes} else
    {$ENDIF}
    {$IFDEF _DBX30_}
    if S = 'GETSQLDRIVERODBCW' then
    begin
      Result := @getSQLDriverODBCW;
    end
    else
    if S = 'GETSQLDRIVERODBCWA' then
    begin
      Result := @getSQLDriverODBCWA;
    end
    else
    {$ENDIF}
    if S = 'GETSQLDRIVERODBC' then
    begin
      Result := @getSQLDriverODBC;
    end
    else
    if S = 'GETSQLDRIVERODBCAW' then
    begin
      Result := @getSQLDriverODBCAW;
    end
    else
    {$IFDEF _ASA_MESSAGE_CALLBACK_}
    if S = 'ASA_MESSAGE_INIT' then
    begin
      Result := @ASA_MESSAGE_INIT;
    end
    else
    if S = 'ASA_MESSAGE_CALLBACK' then
    begin
      Result := @ASA_MESSAGE_CALLBACK;
    end
    else
    {$ENDIF}
      Result := nil;
  end;

begin
  // debug:
    {if Assigned(lpProcName) and (not IsBadReadPtr(lpProcName,1)) and (lpProcName^ <> #0) then
      dbg('   NewGetProcAddress:   "' + StrPas(lpProcName) + '"');{}
  // debug:
  if (DllHandle <> 0) and (DllHandle = hModule) then
  begin
    LDoGetProcAddress();
    if Assigned(Result) then
      Exit;
  end;
  Result := _GetProcAddress(hModule, lpProcName);
end;

procedure UnHookIAT_LoadLibrary();
begin
  {.$IFDEF MSWINDOWS}
  if Assigned(IATPatch) then
  begin
    DllHandle := 0;
    IsDriverEmbedded := False;
    //
    IATPatch.Clear(True);
    IATPatch.Free;
    IATPatch := nil;
  end
  else if Win32Platform = VER_PLATFORM_WIN32_NT then
  {.$ENDIF}
  begin
    DllHandle := 0;
    IsDriverEmbedded := False;
    //
    UnHookCode(@_LoadLibraryA);
    UnHookCode(@_LoadLibraryW);
    UnHookCode(@_FreeLibrary);
    UnHookCode(@_GetProcAddress);
  end;
end;

procedure HookIAT_LoadLibrary();
begin
  {.$IFDEF _DBX30_}
  {.$IFDEF MSWINDOWS}
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  {.$ENDIF}
  begin
    if HookProc(kernel32, 'LoadLibraryA', @NewLoadLibraryA, @_LoadLibraryA)
      and
      HookProc(kernel32, 'LoadLibraryW', @NewLoadLibraryW, @_LoadLibraryW)
      and
      HookProc(kernel32, 'FreeLibrary', @NewFreeLibrary, @_FreeLibrary)
      and
      HookProc(kernel32, 'GetProcAddress', @NewGetProcAddress, @_GetProcAddress)
    then
    begin
      //DllHandle := GetModuleHandle(kernel32);
      DllHandle := GetModuleHandle(nil);
      if IsStatic() then
      begin
        IsDriverEmbedded := True;
        Exit;
      end;
    end;
    UnHookIAT_LoadLibrary();
  end;
  {.$ENDIF}
  {.$IFDEF MSWINDOWS}
  IATPatch := TIATPatch.Create;
  if IATPatch.Patch(kernel32, 'LoadLibraryA', @NewLoadLibraryA, @_LoadLibraryA)
    and
    IATPatch.Patch(kernel32, 'LoadLibraryW', @NewLoadLibraryW, @_LoadLibraryW)
    and
    IATPatch.Patch(kernel32, 'FreeLibrary', @NewFreeLibrary, @_FreeLibrary)
    and
    IATPatch.Patch(kernel32, 'GetProcAddress', @NewGetProcAddress, @_GetProcAddress)
  then
  begin
    //DllHandle := GetModuleHandle(kernel32);
    DllHandle := GetModuleHandle(nil);
    if IsStatic() then
    begin
      IsDriverEmbedded := True;
      Exit;
    end;
  end;
  UnHookIAT_LoadLibrary();
  {.$ENDIF}
end;

initialization
  HookIAT_LoadLibrary();
  if IsDriverEmbedded then
    LogInfoProc(['** Is Driver Embedded    =', 'True'])
  else
    LogInfoProc(['** Is Driver Embedded    =', 'False']);
   //
finalization
  UnHookIAT_LoadLibrary();
{$ENDIF _HOOK_DLL_}
end.
