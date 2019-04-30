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

  set UserCOpt=-D_RELEASE_ -$R-,O+

rem Critical compiler search path options:

  rem
  rem for all projects
  rem
    set UserLib=%dbx%\driver\source
    rem set UserLib=%UserLib%;...

  rem
  rem for packages and user projects:
  rem
    set UserLib=%UserLib%;%dbx%\packages\source


  rem
  rem { optional: } for user projects:
  rem
    rem set UserLib=%UserLib%;%dbx%\demos\third-party\jcl

  if %DXVER% LSS 8  set UserLib=%UserLib%;%dbx%\packages\source\DNULL08
  if %DXVER% LSS 11 set UserLib=%UserLib%;%dbx%\packages\source\DNULL10
  if %DXVER% GEQ 11 set UserLib=%UserLib%;%dbx%\packages\source\DNULL11
  if %DXVER% LSS 12 set UserLib=%UserLib%;%dbx%\packages\source\D2007


rem set Include and Resource path

  set UserLibI=%UserLib%
  set UserLibR=%UserLib%

@echo on
