{
  Part of Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.05.18

  Copyright (c) 2010 by "Vadim V.Lopushansky" <pult@ukr.net>

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
unit DbxXXDrv;
//
// Useful references:
//
//
// Delphi QC:
//   http://qc.embarcadero.com/wc/qcmain.aspx?da=1
//
//
//
// Andy’s Delphi Tools:
//   VCL Fix Pack
//     http://andy.jgknet.de/blog/?page_id=288
//
//
// Andy’s Delphi Tools:
//   Midas Speed Fix
//     http://andy.jgknet.de/blog/?page_id=529
//
interface

{$IFDEF CONDITIONALEXPRESSIONS}

{$IF CompilerVersion >= 18.50}  // Delphi 2007 Up
uses
  Dbx34Drv, Dbx34DrvDbms;

type
  // aliases
  TDBXPropertyNames = Dbx34Drv.TDBXPropertyNames;
  TDBXDynalinkPropertyNames = Dbx34Drv.TDBXDynalinkPropertyNames;

  //
  // @D2007:
  //   SQLConnection.Params.Values[TDBXPropertyNames.DriverPackageLoader]  :=
  //
  TDBXDynalinkDriverLoaderOpenOdbc = Dbx34Drv.TDBXDynalinkDriverLoaderOpenOdbc;

  //
  // @Metadata Reader:
  //   SQLConnection.Params.Values[TDBXPropertyNames.MetaDataPackageLoader]  :=
  //
  TDBXOpenODBCMetaDataCommandFactory            = Dbx34Drv.TDBXOpenODBCMetaDataCommandFactory;
  //
  TDBXOpenODBCMetaDataCommandFactoryOracle      = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryOracle;
  TDBXOpenODBCMetaDataCommandFactoryMSSQL       = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryMSSQL;
  TDBXOpenODBCMetaDataCommandFactoryMySQL       = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryMySQL;
  TDBXOpenODBCMetaDataCommandFactorySybaseASA   = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactorySybaseASA;
  TDBXOpenODBCMetaDataCommandFactorySybaseASE   = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactorySybaseASE;
  TDBXOpenODBCMetaDataCommandFactoryDB2         = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryDB2;
  TDBXOpenODBCMetaDataCommandFactoryInformix    = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryInformix;
  TDBXOpenODBCMetaDataCommandFactoryDataStorage = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryDataStorage;
  TDBXOpenODBCMetaDataCommandFactoryFirebird    = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryFirebird;
  TDBXOpenODBCMetaDataCommandFactoryInterbase   = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryInterbase;
  TDBXOpenODBCMetaDataCommandFactorySQLite      = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactorySQLite;
  TDBXOpenODBCMetaDataCommandFactoryPostgreSQL  = Dbx34DrvDbms.TDBXOpenODBCMetaDataCommandFactoryPostgreSQL;

{$IFEND CompilerVersion >= 18.50}

const
  DbxOODBCDriverName = 'DbxOpenOdbc';
  DbxOODBCDriverProductName = DbxOODBCDriverName; // ProductName VendorProperty from "dbxoodbc.dll" (DbxOpenOdbc3.pas)
  DbxOODBCDriverLibname =
    {$IFDEF MSWINDOWS}
        'dbxoodbc.dll'       // MSWINDOWS
    {$ELSE}
      {$IFDEF MACOS}
        'libdbxoodbc.dylib'  // MACOS
      {$ELSE}
        'dbxoodbc.so'        // LINUX
      {$ENDIF}
    {$ENDIF}
  ;
  DbxOODBCDriverVendorLib =
    {$IFDEF MSWINDOWS}
        'odbc32.dll'              // MSWINDOWS
    {$ELSE}
      {$IFDEF MACOS}
        '/usr/lib/libiodbc.dylib' // MACOS
      {$ELSE}
        'libodbc.so'              // LINUX
      {$ENDIF}
    {$ENDIF}
  ;

  {$IF CompilerVersion <= 15.00}
  PREPARESQL         = 'Prepare SQL';
    {$IF CompilerVersion < 15.00}
  TRIMCHAR           = 'Trim Char';
    {$IFEND}
  {$IFEND}

function IsDbxDrvFixed: Boolean;

{$ENDIF CONDITIONALEXPRESSIONS}

implementation

uses
{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion <= 18.00}  // Delphi 2006 Down
  Dbx23Fix,
{$IFEND}
  {$IF CompilerVersion < 23.00}
  DbxDBFix,                     // Delphi 6 Up
  {$IFEND}
  SysUtils;

function IsDbxDrvFixed: Boolean;
begin
{$IF CompilerVersion >= 18.50}    // Delphi 2007 Up
  {$IF CompilerVersion >= 23.00}  // XE2 Up
  Result := True;
  {$ELSE}
  Result := {Dbx34Drv.pas}bIsDbx34Drv; // and {DbxDBFix.pas}bIsDbxDBFix;
  {$IFEND}
{$ELSE}                           // Delphi 2006 Down
  Result := {Dbx23Fix.pas}bFixedSqlExpr; //todo: kylix test ???
{$IFEND}

end;

{$ENDIF CONDITIONALEXPRESSIONS}
end.
