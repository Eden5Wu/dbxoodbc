@if "%1" NEQ  "-p" @echo off

@call set_version.bat -p

@echo\
@echo ***
@echo * build template version "version{template}.inc":
@echo ***
@echo\
@echo version    = %v1%.%v2%.%v3%.%v4%
@echo year       = %y%
@echo date       = %d%
@echo build-type = %b%
@echo\

@set t=
%dbx%\cmd\stm_replacer.exe -nc "-i=version{template}.inc" "-o=version.inc" -p=build_version.par
@echo\
%dbx%\cmd\stm_replacer.exe -nc "-i=%prj_pkg%\version_pkg{template}.inc" "-o=%prj_pkg%\version_pkg.inc" -p=build_version.par
@move %prj_pkg%\version_pkg.inc %prj_pkg%\..\pkg\ >nul 2>nul
@echo\

@if exist "version.inc" goto L_DONE

@echo ERROR: cannot make of "version.inc"
@exit

:L_DONE

@if "%1" NEQ  "-p" @echo on
@goto :eof
