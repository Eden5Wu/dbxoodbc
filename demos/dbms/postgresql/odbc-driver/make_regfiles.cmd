@call env-init.cmd

@set t=%cd%
@echo\>con
@echo   Driver Path=%t%>con
@echo\>con
@%dbx%\cmd\stm_replacer.exe -nc "-i=PostgreSQL_ODBC_Driver(ANSI){template}.regx" "-o=$a.reg" -p=replace.par -lp>nul
@%dbx%\cmd\stm_replacer.exe -nc "-i=PostgreSQL_ODBC_Driver(UNICODE){template}.regx" "-o=$u.reg" -p=replace.par -lp>nul
