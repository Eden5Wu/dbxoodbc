@set lib=%1

@if "%lib%" == "" exit 1

@rem clean

@if "%clean%"=="0" goto L_CLEAN_DONE

@del /Q "%dbx%\lib\%lib%\*.dcu" 1>nul 2>nul
@del /Q "%dbx%\lib\%lib%\*.dpu" 1>nul 2>nul
@del /Q "%dbx%\lib\%lib%\*.obj" 1>nul 2>nul
@del /Q "%dbx%\lib\%lib%\*.o" 1>nul 2>nul
@del /Q "%dbx%\lib\%lib%\*.hpp" 1>nul 2>nul
:L_CLEAN_DONE

@rem move

@move ..\*.dcu "%dbx%\lib\%lib%" 1>nul 2>nul
@move ..\*.dpu "%dbx%\lib\%lib%" 1>nul 2>nul
@move ..\*.obj "%dbx%\lib\%lib%" 1>nul 2>nul
@move ..\*.o "%dbx%\lib\%lib%" 1>nul 2>nul
@move ..\*.hpp "%dbx%\lib\%lib%" 1>nul 2>nul
