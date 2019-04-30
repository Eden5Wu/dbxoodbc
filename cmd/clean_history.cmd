@call :foreach_clean_history "%cd%"
@goto :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:foreach_clean_history folder filter
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@setlocal
@call set "folder=%%~1%%"
@set filter=__history
@rem call echo\  :parse folder "%folder%" ...
@for /F "eol= tokens=1,* delims=" %%i in ('dir "%folder%" /AD /B') do @(
  if "%%i"=="%filter%" (
    @call echo\remove: "%folder%\%%i"
    @rd  /s /q "%folder%\%%i" 2>nul
  ) else (
    call :foreach_clean_history "%folder%\%%i"
  )
)
@endlocal &@goto :eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
