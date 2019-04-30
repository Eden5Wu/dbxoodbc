@rem template: common.cmd
@echo off

rem Common options

  set UsePack=0
  set DEBUG=1
  set MAPFILE=1
  set JDBG=0
  set JDBG_LINK=0
  set JDBG_FILE=1
  set CleanDcc32Log=1
  set DEBUG_BATCH=1
  set TRACE_STACK_SOURCE=1

  set UserCOpt=-D_RELEASE_ -$B-,R-,O-,D+,L+,Y+
  if "%embedded%"=="1" set UserCOpt=%UserCOpt% -D_EMBEDDED_
  if "%tracking%"=="1" set UserCOpt=%UserCOpt% -D_TRACE_CALLS_
  if "%c_dbxoopt%" NEQ "" set UserCOpt=%UserCOpt% %c_dbxoopt%

rem Critical compiler search path options:
@if "%Platform%"=="kylix" set dbx=%dbx_crosskylix%

@rem @echo off
  rem
  rem for all projects
  rem
    if "%dbx%"=="" @set dbx=.%pd%..%pd%..%pd%..
    set UserLib=%dbx%%pd%source%pd%driver
    rem set UserLib=%UserLib%%vd%..

  rem
  rem for packages and user projects:
  rem
    set UserLib=%UserLib%%vd%%dbx%%pd%source%pd%packages

  rem
  rem { optional: } for user projects:
  rem
    rem set UserLib=%UserLib%%vd%%dbx%%pd%demos%pd%third-party%pd%jcl

rem set Include and Resource path

  set UserLibI=%UserLib%
  set UserLibR=%UserLib%

@echo on
