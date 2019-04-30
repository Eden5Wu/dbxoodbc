{
  Delphi / Kylix open source DbExpress driver for ODBC
  Version 3.2012.04.17

  Copyright (c) 2001-2012 Edward Benson

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  Project Home Page:
    https://sourceforge.net/projects/open-dbexpress/
}
library dbxoodbc;
// Library version of DbExpress Open Source Odbc Driver.

{$INCLUDE DbxOpenOdbc.inc}

uses
  {$IFDEF _FASTMM_}
  FastMM4,
  {$ENDIF }
  {$IFDEF _KYLIX_}
  ShareExcept,
  {$ENDIF }
  {$IFDEF _DBX30_}
  DbxOpenOdbc3,
  {$ENDIF }
  DbxOpenOdbc;

{$IFDEF MSWINDOWS}
  // Include Library information
  {$IFDEF _TRACE_CALLS_}
    {$R dbxoodbc_tracking.res}
  {$ELSE}
    {$R dbxoodbc.res}
  {$ENDIF}
{$ENDIF}

exports

(*
//
// DBX4 (exports):
//

{$IFDEF _DBX40_}
  DBXBase_GetErrorMessageLength,
  DBXBase_GetErrorMessage,
  DBXBase_Close,

  DBXRow_GetString,
  DBXRow_GetWideString,
  DBXRow_GetBoolean,
  DBXRow_GetInt16,
  DBXRow_GetInt32,
  DBXRow_GetInt64,
  DBXRow_GetDouble,
  DBXRow_GetBcd,
  DBXRow_GetTimeStamp,
  DBXRow_GetTime,
  DBXRow_GetDate,
  DBXRow_GetBytes,
  DBXRow_GetFixedBytes,
  DBXRow_GetByteLength,
  //DBXRow_GetBinary,

  DBXWritableRow_SetNull,
  DBXWritableRow_SetString,
  DBXWritableRow_SetWideString,
  DBXWritableRow_SetBoolean,
  DBXWritableRow_SetInt16,
  DBXWritableRow_SetInt32,
  DBXWritableRow_SetInt64,
  DBXWritableRow_SetDouble,
  DBXWritableRow_SetBcd,
  DBXWritableRow_SetTimeStamp,
  DBXWritableRow_SetTime,
  DBXWritableRow_SetDate,
  //DBXWritableRow_SetBinary,
  DBXWritableRow_SetBytes,
  DBXLoader_GetDriver,

  DBXDriver_CreateConnection,
  DBXDriver_GetVersion,

  DBXConnection_Connect,
  DBXConnection_Disconnect,
  DBXConnection_SetCallbackEvent,
  DBXConnection_CreateCommand,
  DBXConnection_GetMetaData,
  DBXConnection_BeginTransaction,
  DBXConnection_Commit,
  DBXConnection_Rollback,
  DBXConnection_GetIsolation,

  DBXCommand_CreateParameterRow,
  DBXCommand_Prepare,
  DBXCommand_Execute,
  DBXCommand_ExecuteImmediate,
  DBXCommand_GetNextReader,
  DBXCommand_GetRowsAffected,
  DBXCommand_SetMaxBlobSize,
  DBXCommand_SetRowSetSize,

  DBXParameterRow_SetParameterType,

  DBXReader_GetColumnCount,
  DBXReader_GetColumnMetadata,
  DBXReader_Next,
{$ENDIF _DBX40_}
//*)

//
// DBX3 (exports):
//

{$IFDEF _DBX30_}
  // priority unicode odbc api
  getSQLDriverODBCW,
  // priority ansi odbc api
  getSQLDriverODBCWA,
{$ENDIF _DBX30_}

//
// DBX2 (exports):
//

  // priority ansi odbc api
  getSQLDriverODBC,
  // priority unicode odbc api
  getSQLDriverODBCAW;

begin
  IsDriverEmbedded := False;
end.
