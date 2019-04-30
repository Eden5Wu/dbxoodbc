@call env-init.cmd

@del /Q %prj_path%\*.dcu 1>nul 2>nul
@del /Q %prj_path%\*.dpu 1>nul 2>nul
@del /Q %prj_path%\*.obj 1>nul 2>nul
@del /Q %prj_path%\*.o 1>nul 2>nul
@del /Q %prj_path%\*.hpp 1>nul 2>nul
@del /Q %prj_path%\*.drc 1>nul 2>nul
@del /Q %prj_path%\dcc*.log 1>nul 2>nul

@del /Q /S *.drc 1>nul 2>nul
@del /Q /S dcc*.log 1>nul 2>nul

@if "%1" == "/f" (
  del common.cmd 1>nul 2>nul
  del dbxoodbc.jdbg 1>nul 2>nul
  del dbxoodbc.map 1>nul 2>nul
  del dbxoodbc.dll 1>nul 2>nul
  del dbxoodbc.dylib 1>nul 2>nul
)
