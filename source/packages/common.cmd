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
    set UserLib=.
    set UserLib=%UserLib%%vd%.%pd%..%pd%driver

  rem
  rem for packages and user projects:
  rem
    rem set UserLib=%UserLib%%vd%%dbx%%pd%source%pd%packages


  rem @if %DXVER% LSS 12 set UserLib=%UserLib%%vd%D2007

rem set Include and Resource path

  set UserLibI=%UserLib%
  set UserLibR=%UserLib%

@echo on
