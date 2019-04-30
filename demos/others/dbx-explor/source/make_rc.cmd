@if "%1" NEQ  "-p" @echo off

@if "%2" NEQ "" goto L_START

@call env-init.cmd
@call %dbx%\driver\source\set_version.bat -p

:L_START

@del %prj%.rc 1>nul 2>nul

@echo\
@echo ***
@echo * build template resource "%i%":
@echo ***
@echo\
@echo version    = %v1%.%v2%.%v3%.%v4%
@echo year       = %y%
@echo date       = %d%
@echo build-type = %b%
@echo\

@set t=
%dbx%\cmd\stm_replacer.exe -nc "-i=%i%.rc" "-o=%o%.rc" -p=build_version.par
@echo\
@set t= debug ( calls tracking )
%dbx%\cmd\stm_replacer.exe -nc "-i=%i%.rc" "-o=%o%_debug.rc" -p=build_version.par
@echo\

@if exist "%prj%.rc" goto L_DONE

@echo ERROR: not exist "%prj%.rc"
exit

:L_DONE

@if "%1" NEQ  "-p" @echo on
@goto :eof
