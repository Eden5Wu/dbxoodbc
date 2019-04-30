@if "%1" NEQ  "-p" @echo off

@call env-init.cmd
@call %dbx%\driver\source\set_version.bat -p

@echo\
@echo ***
@echo * build template version "OdbcExplorVersion{template}.inc":
@echo ***
@echo\
@echo version    = %v1%.%v2%.%v3%.%v4%
@echo year       = %y%
@echo date       = %d%
@echo build-type = %b%
@echo\

@set t=
%dbx%\cmd\stm_replacer.exe -nc "-i=OdbcExplorVersion{template}.inc" "-o=OdbcExplorVersion.inc" -p=build_version.par
@echo\

@if exist "OdbcExplorVersion.inc" goto L_DONE

@echo ERROR: cannot make of "OdbcExplorVersion.inc"
exit

:L_DONE

@if "%1" NEQ  "-p" @echo on
@goto :eof
