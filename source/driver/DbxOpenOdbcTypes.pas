{
  Part of Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.15

  Copyright (c) 2003-2012 by Vadim V.Lopushansky

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

unit DbxOpenOdbcTypes;

{$UNDEF _KYLIX_}
{$UNDEF _D7UP_}  // Delphi 7
{$UNDEF _D9UP_}  // Delphi 2005
{$UNDEF _D10UP_} // Delphi 2006
{$UNDEF _D11UP_} // Delphi 2007
{$UNDEF _D12UP_} // Delphi 2009
{$UNDEF _D14UP_} // Delphi 2010
{$UNDEF _D15UP_} // Delphi 2011 XE
{$UNDEF _D16UP_} // Delphi 2012 XE2

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.00} // Delphi 7 Up
    {$DEFINE _D7UP_}
  {$IFEND}
  {$IF CompilerVersion >= 17.00} // Delphi 2005 Up
    {$DEFINE _D9UP_}
  {$IFEND}
  {$IF CompilerVersion >= 18.00} // Delphi 2006 Up
    {$DEFINE _D10UP_}
  {$IFEND}
  {$IF CompilerVersion >= 18.50} // Delphi 2007 Up
    {$DEFINE _D11UP_}
  {$IFEND}
  {$IF CompilerVersion >= 20.00} // Delphi 2009 Up
    {$DEFINE _D12UP_}
  {$IFEND}
  {$IF CompilerVersion >= 21.00} // Delphi 2010 Up
    {$DEFINE _D14UP_}
  {$IFEND}
  {$IF CompilerVersion >= 22.00}
    // D15: Delphi 2011 (XE) and up
    {$DEFINE _D15UP_}
  {$IFEND}
  {$IF CompilerVersion >= 23.00}
    // D15: Delphi 2012 (XE2) and up
    {$DEFINE _D16UP_}
  {$IFEND}
{$ENDIF}

{$IFNDEF _D16UP_} // XE2
  {$DEFINE CPUX86}
  {$IFNDEF LINUX}{$IFNDEF MACOS}
    {/$DEFINE WIN32}
    {/$DEFINE WINDOWS}
    {$DEFINE MSWINDOWS}
  {$ENDIF}{$ENDIF}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
  {$ENDIF}
{$ENDIF}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFNDEF UNICODE}{$IFDEF LINUX}
  Types,
  {$ENDIF}{$ENDIF}
  SysUtils;

{$IFNDEF _KYLIX_}{$IFDEF POSIX}
type
  DWORD = LongWord;
  PDWORD = ^DWORD;
{$ENDIF}{$ENDIF}

{$IFNDEF _D16UP_}
type
  //
  // System
  //
  NativeInt = Integer;
  NativeUInt = Cardinal;
  PNativeInt=^NativeInt;
  PNativeUInt=^NativeUInt;
  //
  // Windows.pas
  //
  {$IFDEF MSWINDOWS}
  WPARAM = Longint;
  LPARAM = Longint;
  LRESULT = Longint;
  {$ENDIF}
{$ENDIF _D16UP_}

{$IFDEF UNICODE}
type
  UnicodeChar = Char;
{$ELSE}
type
  RawByteString = AnsiString;
  PRawByteString = ^RawByteString;
  UnicodeString = WideString;
  PUnicodeString=^UnicodeString;
  UnicodeChar = WideChar;
{$ENDIF}

implementation

end.
