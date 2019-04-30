@setlocal ENABLEEXTENSIONS

@set compiler=%1
@set fmode=%2
@set subdir=%3
@set libext=%4
@set libname=%5

@call env-init.cmd

@if "%compiler%"=="/r" set compiler=
@if "%compiler%"=="/d" set compiler=
@if "%compiler%"=="/R" set compiler=
@if "%compiler%"=="/D" set compiler=

@if "%compiler%" == "" set compiler=11

@set f=%2
@if "%f%"=="" set f=%1
@set o=x
@if "%f%"=="/d" set o=d
@if "%f%"=="/r" set o=r
@if "%f%"=="/D" set o=d
@if "%f%"=="/R" set o=r

@set comon_file=common_simple.cmd
@if "%o%"=="d" set comon_file=common_debug.cmd
@if "%o%"=="r" set comon_file=common_release.cmd

@call %dbx%\cmd\make_prj.cmd %compiler% %prj_path%\%prj%.%prj_ext%
@set subdir=%3
@set libext=%4
@set libname=%5
