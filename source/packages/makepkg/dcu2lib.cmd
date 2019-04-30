@set lib=%1

@if "%lib%" == "" exit 1

@rem move

@move ..\pkg\*.lib  "%lib%" 1>nul 2>nul
@move ..\pkg\*.a    "%lib%" 1>nul 2>nul

@move *.bpi   "%lib%" 1>nul 2>nul

@move *.bpl   "%lib%" 1>nul 2>nul
@move *.dylib "%lib%" 1>nul 2>nul
@move *.so    "%lib%" 1>nul 2>nul

@move *.dcp   "%lib%" 1>nul 2>nul
@move *.map   "%lib%" 1>nul 2>nul
@move *.jdbg  "%lib%" 1>nul 2>nul
