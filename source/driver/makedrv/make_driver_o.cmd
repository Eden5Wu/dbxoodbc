@setlocal ENABLEEXTENSIONS

@call clean.cmd /f

@set compiler=%1
@set subdir=%2
@set libext=%3
@set libname=%4

@if "%subdir%"==""   set subdir=win32
@if "%libext%"==""   set libext=dll
@if "%libname%"==""  set libname=%prj%

@call env-init.cmd

@set t=%o%
@set o=x
@if "%t%" == "r" set o=r
@if "%t%" == "d" set o=d
@if "%o%" == "x" set o=r

@set out=%dbx%\lib\dbxoodbc_driver
@if not exist "%out%" set out=out
@rem @set out=out

@set ERROR_STATE=0
@set JDBG_LINK=0

@set path=makelib;%path%
@call make_driver.cmd %compiler% /%o% %subdir% %libext% %libname%

@if "%ERROR_STATE%"=="1" goto L_ERROR

@if not exist "%libname%.map" goto L_MAP_DONE
@rem @if "%JDBG_FILE%"=="1" call %dbx%\cmd\MakeJclDbg.exe -J %libname%.map
@rem @if "%JDBG_LINK%"=="1" call %dbx%\cmd\MakeJclDbg.exe -E %libname%.map
@call %dbx%\cmd\MakeJclDbg.exe -J %libname%.map
:L_MAP_DONE

@set p=
@if "%o%" == "d" set p=debug
@if "%o%" == "r" set p=release
@if "%p%" == "" goto L_CLEAN_DONE

@rem @echo out=%out%
@rem @echo p=%p%
@rem @echo subdir=%subdir%

@if exist "%out%\%subdir%\%p%"      @del /Q %out%\%subdir%\%p%\%libname%.* 1>nul 2>nul
@if not exist "%out%\%subdir%\%p%"  @md %out%\%subdir%\%p% 1>nul 2>nul

@if exist "%libname%.map"      move %libname%.map      %out%\%subdir%\%p%\ 1>nul
@if exist "%libname%.jdbg"     move %libname%.jdbg     %out%\%subdir%\%p%\ 1>nul
@if exist "%libname%.%libext%" move %libname%.%libext% %out%\%subdir%\%p%\ 1>nul

@goto L_CLEAN_DONE

:L_ERROR

:L_CLEAN_DONE
  @call clean.cmd

:L_EXIT
