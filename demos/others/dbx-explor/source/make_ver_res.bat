@if "%1" NEQ  "-p" @echo off

@call make_ver.cmd -p
@call make_rc.cmd -p -i

@set compiler=%1
@if "%compiler%" == "" set compiler=?
@call make_res.cmd %compiler% -p
@if "%1" NEQ  "-p" @echo on
