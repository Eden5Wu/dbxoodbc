@call ..\cmd\clean.cmd
@rem DataExplorer package compiler and IDE temporary files.
@for %%E in (dcu dcp obj lib bpi exp drc map jdbg rsm identcache stat dproj.local ~*) do @del /Q /F "%~dp0..\packages\DataExplorer\*.%%E" 1>nul 2>nul
@del /Q /F "%~dp0..\packages\DataExplorer\DbxOpenOdbcDataExplorer.res" "%~dp0..\packages\DataExplorer\DbxOpenOdbcDataExplorer.vrc" 1>nul 2>nul

@del /S /Q *.map *.jdbg 1>nul 2>nul

@del /S /Q .\dbms\*.exe 1>nul 2>nul
@del /S /Q .\dbms\third-party*.exe 1>nul 2>nul
@del /S /Q .\others\dbx-stress\*.exe 1>nul 2>nul

@pushd others\dbx-explor\source
@call clean.cmd -f
@popd
