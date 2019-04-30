@if "%2" NEQ  "-p" @echo off

@set compiler=%1
@if "%compiler%"=="?" set compiler=

@call env-init.cmd -p
@if "%res_ver%"=="" exit 1
@del %res_ver%.res 1>nul 2>nul

@echo @call %dbx%\cmd\make_prj.cmd %compiler% ?
@call %dbx%\cmd\make_prj.cmd %compiler% ?

@echo\
@echo ***
@echo * build resource "%%res_ver%%.rc":
@echo ***
@echo\

@rem brcc32.exe %prj_path%\%prj%.%prj_ext%
@rem @ren %prj%.RES %prj%.res 1>nul 2>nul

brcc32.exe %res_ver%.rc
@ren %res_ver%.RES %res_ver%.res 1>nul 2>nul

@echo\
@echo Done.
@echo\

@if "%2" NEQ  "-p" @echo on
