@rem rundll32 %cd%\sqlite3odbc.dll,install quiet

@set d=%cd%
rundll32 %d%\sqlite3odbc.dll,uninstall
