@if "%1" NEQ  "-p" @echo off

@del /Q version_pkg.inc dbxoodbc_ver.rc dbxoodbc_ver.res >nul 2>nul

@call make_ver.cmd -p
@call make_rc.cmd -p -i

@set compiler=%1
@if "%compiler%" == "" set compiler=?
@call make_res.cmd %compiler% -p
@if "%1" NEQ  "-p" @echo on

@del /Q ..\pkg\version_pkg.inc >nul 2>nul
@del /Q ..\pkg\dbxoodbc_ver.res >nul 2>nul

@move version_pkg.inc ..\pkg\ >nul 2>nul
@move dbxoodbc_ver.res ..\pkg\ >nul 2>nul
