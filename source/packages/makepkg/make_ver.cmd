@if "%1" NEQ  "-p" @echo off

@call env-init.cmd -p
@call %dbx%\source\driver\set_version.bat -p

@echo\
@echo ***
@echo * build template version "version_pkg{template}.inc":
@echo ***
@echo\
@echo version    = %v1%.%v2%.%v3%.%v4%
@echo year       = %y%
@echo date       = %d%
@echo build-type = %b%
@echo\

@set t=
%dbx%\cmd\stm_replacer.exe -nc "-i=version_pkg{template}.inc" "-o=version_pkg.inc" -p=%dbx%\source\driver\makeres\build_version.par
@echo\

@if exist "version_pkg.inc" goto L_DONE

@echo ERROR: cannot make of "version_pkg.inc"
@exit

:L_DONE

@if "%1" NEQ  "-p" @echo on
@goto :eof
