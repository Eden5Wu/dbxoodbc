@echo Press any key to add PostgreSQL ODBC drivers registry entites >con
@echo   or press Ctrl+C to break ...>con
@pause>nul

@call make_regfiles.cmd

@call regedit.exe /s $a.reg
@call regedit.exe /s $u.reg

@del $a.reg>nul 2>nul
@del $u.reg>nul 2>nul

@echo Done.>con
