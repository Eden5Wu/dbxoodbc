@echo Press any key to remove PostgreSQL ODBC drivers registry entites >con
@echo   or press Ctrl+C to break ...>con
@pause>nul
@call regedit.exe /s uninstall.regx

@echo\>con
@echo Done.>con
