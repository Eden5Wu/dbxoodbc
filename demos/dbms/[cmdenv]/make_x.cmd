@rem if "%1"=="" goto L_ERROR
@rem if "%2"=="" goto L_ERROR

@if "%3" == "-m1" set memcheck=1
@if "%4" == "-m1" set memcheck=1

@if "%3" == "-tr1" set trace=1
@if "%4" == "-tr1" set trace=1

@set compiler=%1
@call env-init.cmd

call %dbx%\cmd\make_prj.cmd %compiler% %prj_path%\%prj%.%prj_ext%

@set prj_sufix=%2
@if "%prj_sufix%" == "" set prj_sufix=tmp

@del %prj%_%prj_sufix%.exe 1>nul 2>nul
@del %prj%_%prj_sufix%.map 1>nul 2>nul
@ren %prj%.exe %prj%_%prj_sufix%.exe
@if exist %prj%.map ren %prj%.map %prj%_%prj_sufix%.map

@goto :eof

:L_ERROR

@echo ERROR: parameters is not defined
@exit
