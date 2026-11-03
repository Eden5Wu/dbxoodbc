{
  Delphi Open Source Native DBX4 Driver for ODBC (DBX4 Remastered)
  Version: 4.2026.11.02

  Copyright (c) 2001-2012 Edward Benson, Vadim V. Lopushansky
  Copyright (c) 2019-2026 Eden Wu (Native DBX4 Remastered Architecture)

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Repository:
    https://github.com/Eden5Wu/dbxoodbc

  Windows ODBC Driver Registry Paths:
    32-bit: HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI
    64-bit: HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI
}

================================================================================
 DBX4 Remastered (dbxoodbc v4.2026.11.02)
 Pure Native Delphi dbExpress (DBX4) Driver for ODBC (Win32 & Win64)
================================================================================

1. Overview
-----------
DBX4 Remastered is a complete, from-the-ground-up native DBX4 rewrite of the
Open-dbExpress ODBC driver (dbxoodbc) for modern Delphi (RAD Studio 10.x, 11,
12, 13+).

Key Highlights:
  * 100% Pure Pascal / Native DBX4 Architecture:
    Inherits directly from Data.DBXCommon (TDBXDriver, TDBXConnection,
    TDBXCommand, TDBXReader, TDBXRow).
  * Zero External DLLs Required:
    Completely eliminates legacy "dbxoodbc.dll", "dbxadapter30.dll", and
    invasive IAT/code hooks. Calls Windows native "odbc32.dll" directly.
  * Full Win32 & Win64 Native Support:
    Single clean codebase consisting of only 3 source files in "source/":
      - source/OdbcApi.pas
      - source/DbxOpenOdbcCore.pas
      - source/DbxOpenOdbcDriver.pas
  * Legacy 3.x Retirement:
    Version 3.x is archived under historical Git tags. Version 4+ is dedicated
    exclusively to the modern DBX4 architecture.


2. Directory Structure
----------------------
dbxoodbc/
├── source/               # Pure Pascal DBX4 core driver source (No external DLL)
│   ├── DbxOpenOdbcDriver.pas  # Driver registration & TDBXDriver / TDBXConnection classes
│   ├── DbxOpenOdbcCore.pas    # Command, metadata, cursor & dual-alias engine
│   └── OdbcApi.pas            # Native Direct ODBC 3.x API bindings (odbc32.dll)
├── ini/                  # Configuration templates
│   ├── dbxdrivers.ini         # Driver registration settings template
│   └── dbxconnections.ini     # Connection profiles template (MSSQL, Oracle, PG, etc.)
├── demos/                # Connection examples
│   └── connections/           # Ready-to-use sample connection units for various DBMS
├── tests/                # Automated verification suites
│   └── mvp_test/              # CLI / IDE test suite (validates DBX4 without DB)
├── clean.cmd             # Cleans temporary build artifacts (*.dcu, *.~*, *.identcache)
├── ChangesLog.Txt        # Version change history
├── ReadMe.Txt            # English documentation
└── ReadMe_TW.Txt         # Traditional Chinese documentation


3. Quick Start (Zero-Installation Runtime Usage)
------------------------------------------------
You do NOT need to install any BPL packages or deploy any external DBX DLLs!

Step 1: Add the "source/" directory to your project's Search Path (or add
        OdbcApi.pas, DbxOpenOdbcCore.pas, and DbxOpenOdbcDriver.pas directly
        to your project).

Step 2: Include "DbxOpenOdbcDriver" in your unit's uses clause:
        uses
          Data.DB, Data.SqlExpr, DbxOpenOdbcDriver;

Step 3: Configure TSQLConnection and open:
        SQLConnection1.DriverName := 'DbxOpenOdbc'; // or 'OpenOdbc'
        SQLConnection1.LoginPrompt := False;
        SQLConnection1.Params.Values['ConnectionString'] :=
          'DRIVER={SQL Server};Server=127.0.0.1;Database=master;Trusted_Connection=yes;';
        SQLConnection1.Open;


4. Connection String & Extended Parameters Guide
------------------------------------------------
4.1 Entry Points (Priority Order)
The driver reads the connection string from TSQLConnection.Params in the
following priority order:
  1) SQLConnection.Params.Values['ConnectionString']  (Recommended modern key)
  2) SQLConnection.Params.Values['Database']          (Standard DBX fallback)
  3) SQLConnection.Params.Values['Custom String']     (Legacy 3.x compatibility)

4.2 Dual-Mode Parsing: Native ODBC & ADO/OLEDB Auto-Translation
Although this driver communicates 100% natively with Windows ODBC (odbc32.dll)
without any COM/OLEDB overhead, it includes a built-in Smart Translator that
automatically converts ADO/OLEDB connection strings into native ODBC format:

  +-----------------------------------+----------------------------------------+
  | ADO / OLEDB Keyword               | Translated Native ODBC Keyword         |
  +-----------------------------------+----------------------------------------+
  | Provider=MSOLEDBSQL / SQLNCLI11.. | Driver={Best Installed SQL Driver}     |
  | Provider=SQLOLEDB                 | Driver={SQL Server}                    |
  | Data Source=... / Address=...     | Server=...                             |
  | Initial Catalog=...               | Database=...                           |
  | User ID=...                       | Uid=...                                |
  | Password=...                      | Pwd=...                                |
  | Integrated Security=SSPI          | Trusted_Connection=yes                 |
  | Application Name=...              | APP=... (Shown in SQL Server Profiler) |
  | Application_Name=...              | APP=... (Shown in SQL Server Profiler) |
  | Workstation ID=...                | WSID=... (Shown in Profiler HostName)  |
  +-----------------------------------+----------------------------------------+

  * Legacy 3.x "co*" options (e.g., coConnectionString=, coLockMode=,
    coCatPrefix=, coEnableUnicode=) are automatically stripped so native ODBC
    drivers do not reject unknown attributes.

4.3 Dynamic ODBC Driver Detection & Smart Fallback (SQLDriversW)
Different client machines may have different generations of Microsoft SQL Server
ODBC drivers installed. DBX4 Remastered queries the OS via SQLDriversW and
automatically resolves or falls back in the following priority order:
  1. Exact match if the requested driver/provider generation is installed.
  2. Automatic fallback chain (from newest to oldest installed driver):
     - ODBC Driver 18 for SQL Server
     - ODBC Driver 17 for SQL Server
     - ODBC Driver 13.1 / 13 / 11 for SQL Server
     - SQL Server Native Client 11.0 / 10.0 / SQL Native Client
     - SQL Server (Built-in Windows sqlsrv32.dll)
  * Note for ODBC Driver 18+: If Driver 18/19 is selected and
    "TrustServerCertificate=" is not explicitly specified, the driver
    automatically appends "TrustServerCertificate=yes;" to prevent SSL
    self-signed certificate connection failures.

4.4 Native Pass-Through & MSSQL Optimizations
  * All additional "Key=Value;" pairs appended to the connection string are
    passed directly (Pass-Through) to the underlying ODBC driver.
  * Useful MSSQL Extended Parameters:
    - Application Name=MyERP; (or APP=MyERP;)
      Immediately visible in SQL Server Profiler (ApplicationName column) and
      sys.dm_exec_sessions (program_name).
    - Workstation ID=POS_01; (or WSID=POS_01;)
      Immediately visible in SQL Server Profiler (HostName column).
    - TrustServerCertificate=yes;
      Trusts self-signed server certificates on modern SQL Server drivers.
    - ApplicationIntent=ReadOnly;
      Routes read-only workloads to AlwaysOn readable secondary replicas.
    - LoginTimeout=5;
      Sets connection login timeout in seconds.
  * Automatic MSSQL Optimizations:
    - MARS_Connection=yes (Enables Multiple Active Result Sets per connection)
    - Network=dbmssocn    (Enforces fast TCP/IP, bypassing slow Named Pipes)


5. Optional IDE Data Explorer Templates (ini/)
----------------------------------------------
If you wish to register DbxOpenOdbc in RAD Studio's dbxdrivers.ini and
dbxconnections.ini, refer to the ready-to-use templates in the "ini/" folder:
  - ini/dbxdrivers.ini
  - ini/dbxconnections.ini

For Traditional Chinese documentation, please see ReadMe_TW.Txt.
