@call ..\cmd\clean.cmd
@del /S /Q *.map *.jdbg 1>nul 2>nul

@del /S /Q .\dbms\*.exe 1>nul 2>nul
@del /S /Q .\dbms\third-party*.exe 1>nul 2>nul
@del /S /Q .\others\dbx-stress\*.exe 1>nul 2>nul

@pushd others\dbx-explor\source
@call clean.cmd -f
@popd
