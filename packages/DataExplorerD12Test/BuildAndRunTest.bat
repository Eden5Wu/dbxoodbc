@echo off
setlocal

echo ================================================================
echo   DbxOpenOdbc D12 Test Package ^& Dynamic Loader Build/Run
echo ================================================================

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0BuildAndRunTest.ps1" %*

if errorlevel 1 (
    echo.
    echo [ERROR] Script execution failed!
    pause
    exit /b 1
)

endlocal
