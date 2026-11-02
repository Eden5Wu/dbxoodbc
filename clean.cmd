@echo off
rem DBX4 Remastered Clean Script
echo Cleaning temporary build files...
del /s /q /f *.~* >nul 2>&1
del /s /q /f *.dcu >nul 2>&1
del /s /q /f *.identcache >nul 2>&1
del /s /q /f *.dproj.local >nul 2>&1
del /s /q /f tests\mvp_test\Dbx4MvpTester.exe >nul 2>&1
echo Done.
