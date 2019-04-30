@if "%dbx%"=="" set t=
@if "%dbx%" NEQ "" set t=%dbx%\cmd\
@if exist "%t%acfg_crosskylix.bat" call "%t%acfg_crosskylix.bat"

@call %CROSSKYLIX_DIR%\ckdcc.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
@goto :eof
