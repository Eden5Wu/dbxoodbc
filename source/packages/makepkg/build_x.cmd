@if "%1"=="" exit 1
@if "%2"=="" exit 2

@call clean.cmd
@call env-init.cmd

@pushd %dbx%\source\driver
@call clean.cmd
@popd

@set c_ver=%1
@set c_prj=%prj%
@set c_out=%2
@set c_map=%3

@if "%c_map%"=="" set c_map=%c_prj%
@set c_ext=%4
@set c_opt=%5
@if "%c_opt%"=="-" set c_opt=
@set c_dbg=%6
@if "%c_dbg%"=="" set c_dbg=0

@if "%c_ext%"=="" set c_ext=bpl

@echo\
@echo *****************
@echo * build package *
@echo *****************
@echo\

@set c_dbxoopt=

@rem -@set c_dbxoopt=-JPHNE

@rem + d6,7: bpi; 2007: bpl,lib,bpi   osx: a,bpi win64:-
@rem @set c_dbxoopt=-JPHNE -JL

@rem * d6,7: bpi; 2007: bpl,lib,bpi   osx: a,bpi win64:-
@rem @set c_dbxoopt=-JL

@if "%c_opt%" NEQ "" set c_dbxoopt=%c_opt% %dbxoodbc_compiler_options%
@call %dbx_win%\cmd\make_prj.cmd %c_ver% %prj_path%\%c_prj%.%prj_ext%

@rem drop desingonly dcp file
@del *_*.dcp >nul 2>nul
@rem @del *_dbg_*.dcp >nul 2>nul

@set map=%c_map%.map
@if exist "%map%" call %dbx_win%\cmd\MakeJclDbg.exe -J "%map%"

@if "%c_dbg%" NEQ "0" goto :eof

@call dcu2lib.cmd %dbx_win%\lib\%c_out%

@call clean.cmd
@pushd %dbx_win%\source\driver
@call clean.cmd
@popd
