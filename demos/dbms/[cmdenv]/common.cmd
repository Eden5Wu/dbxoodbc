@rem template: common.cmd

@echo off

rem Common options

  set UsePack=0
  set DEBUG=1
  set MAPFILE=1
  set JDBG=0
  set JDBG_LINK=0
  set JDBG_FILE=0
  set CleanDcc32Log=1
  set DEBUG_BATCH=1
  set TRACE_STACK_SOURCE=1

  set UserCOpt=-$R-,O+
  rem if "%DEBUG%" == "0" set UserCOpt=-D_RELEASE_ %UserCOpt%
  rem if "%DEBUG%" == "1" set UserCOpt=-D_DEBUG_ %UserCOpt%
  rem set UserCOpt=-D_RELEASE_ %UserCOpt%
  rem set UserCOpt=-D_DEBUG_ %UserCOpt%
  rem set UserCOpt=-D_DEBUG_;_TRACE_CALLS_ %UserCOpt%

  if "%memcheck%" == "1" set UserCOpt=%UserCOpt% -D_MEMCHECK_
  if "%trace%" == "1" set UserCOpt=%UserCOpt% -D_DEBUG_;_TRACE_CALLS_

rem Critical compiler search path options:

  rem
  rem for all projects
  rem
    set UserLib=%dbx%\source\driver
    rem set UserLib=%UserLib%;...

  rem
  rem for packages and user projects:
  rem
    set UserLib=%UserLib%;%dbx%\source\packages;%dbx%\demos\connections

  rem
  rem { optional: } for user projects:
  rem
    set UserLib=%UserLib%;%dbx%\demos\third-party\jcl

  if %DXVER% LSS 8  set UserLib=%dbx%\source\packages\2005Dwn;%UserLib%
  if %DXVER% LSS 11 set UserLib=%dbx%\source\packages\2006Dwn;%UserLib%
  if %DXVER% LSS 12 set UserLib=%dbx%\source\packages\2007Dwn;%UserLib%
  if %DXVER% GEQ 11 set UserLib=%dbx%\source\packages\2007Up;%UserLib%

  set UserLib=D%DXVER%;%UserLib%
  rem set>set.txt

rem set Include and Resource path

  set UserLibI=%UserLib%
  set UserLibR=%UserLib%

@echo on
