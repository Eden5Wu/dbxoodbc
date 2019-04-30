@if "%1" NEQ  "-p" @echo off

@call env-init.cmd -p

@if "%2" == "" call %dbx%\source\driver\set_version.bat -p

@set R=%res_ver%
@if "%R%"=="" exit 1
@del %R%.rc 1>nul 2>nul

@echo\
@echo ***
@echo * build template resource "%R%{template}.rc":
@echo ***
@echo\
@echo version    = %v1%.%v2%.%v3%.%v4%
@echo year       = %y%
@echo date       = %d%
@echo build-type = %b%
@echo\

@set T=
%dbx%\cmd\stm_replacer.exe -nc "-i=%R%{template}.rc" "-o=%R%.rc" -p=%dbx%\source\driver\makeres\build_version.par
@echo\

@if exist "%R%.rc" goto L_DONE

@echo ERROR: not exist "%R%.rc"
exit 1

:L_DONE

@if "%1" NEQ  "-p" @echo on
@goto :eof
