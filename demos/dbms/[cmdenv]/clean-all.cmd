@call ..\..\[cmdenv]\clean.cmd

@if "%prj%"=="" goto :eof

@del %prj%*.exe >nul 2>nul
@del %prj%*.map >nul 2>nul
@del %prj%*.jdbg >nul 2>nul
