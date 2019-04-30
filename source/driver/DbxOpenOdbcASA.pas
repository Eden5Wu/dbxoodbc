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
unit DbxOpenOdbcASA;

{$DEFINE _STDCALL_}
{$IF CompilerVersion >= 23.00}
  {$IFDEF POSIX}
    {$UNDEF _STDCALL_}
  {$ENDIF}
{$IFEND}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IF CompilerVersion >= 24}
  AnsiStrings,
  {$IFEND}
  SysUtils;

//
// SYBASE ASA API:
//
const
  ASA_REGISTER_MESSAGE_CALLBACK = 1904;

// SYBASE ASA API.

var
  AsaCallbackMessage: AnsiString = 'WM_ASA_MESSAGE'; // NEED FOR GENERATION WM_ASACALLBACK
  WM_ASACALLBACK: Word; // WINDOWS MESSAGE ID
  WM_ASACALLBACK_SUPPORTED: Boolean; // INITIALIZED IN CONNECTION (TSqlConnectionOdbc.RetrieveDriverName)

function ASA_MESSAGE_INIT(bWindow: THandle): Integer; {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}
procedure ASA_MESSAGE_CALLBACK(sqlca: Pointer; msg_type: AnsiChar; code: LongInt; Len: Word; msg: PAnsiChar); {$IFDEF _STDCALL_} stdcall; {$ELSE} cdecl; {$ENDIF}

exports
  ASA_MESSAGE_INIT, ASA_MESSAGE_CALLBACK;

implementation

uses
  DbxOpenOdbc;

var
  aWindow: THandle = 0;

function ASA_MESSAGE_INIT(bWindow: THandle): Integer;
begin
  aWindow := bWindow;
  Result := Integer(WM_ASACALLBACK_SUPPORTED);
end;

procedure ASA_MESSAGE_CALLBACK(sqlca: Pointer; msg_type: AnsiChar; code: LongInt; Len: Word; msg: PAnsiChar);
{$IFDEF MSWINDOWS}
var
  S: AnsiString;
begin
  if aWindow <> 0 then
  begin
    S := '';
    if len > 0 then
      S := AnsiStrings.StrPas(msg);
    SendMessage(aWindow, WM_ASACALLBACK, WPARAM(@S), LPARAM(msg_type));
  end;
end;
{$ELSE !MSWINDOWS}
begin
  { empty }
end;
{$ENDIF !MSWINDOWS}

{$IFDEF MSWINDOWS}
initialization
  WM_ASACALLBACK := RegisterWindowMessageA(PAnsiChar(AsaCallbackMessage));
{$ENDIF}
end.
