@if "%1" NEQ  "-p" @echo off

@del /Q ..\dbxoodbc.res ..\dbxoodbc_tracking.res ..\version.inc 1>nul 2>nul

@call make_ver.cmd -p
@call make_rc.cmd -p -i

@set compiler=%1
@if "%compiler%" == "" set compiler=?
@call make_res.cmd %compiler% -p

@move dbxoodbc.res ..\ 1>nul 2>nul
@move dbxoodbc_tracking.res ..\ 1>nul 2>nul
@move version.inc ..\ 1>nul 2>nul

@if "%1" NEQ  "-p" @echo on
