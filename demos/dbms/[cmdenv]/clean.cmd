@call env-init.cmd

@call %dbx%\cmd\make_prj.cmd /c

@del /Q *.projdata 1>nul 2>nul
@del /Q *_MemoryManager_EventLog.txt 1>nul 2>nul
