@call env-init.cmd

del %prj_path%\D2007\*.dcu 2>nul
del %prj_path%\D2007\*.dpu 2>nul
del %prj_path%\DNULL08\*.dcu 2>nul
del %prj_path%\DNULL08\*.dpu 2>nul
del %prj_path%\DNULL11\*.dcu 2>nul
del %prj_path%\DNULL11\*.dpu 2>nul

@del %prj_path%\*.dcu 2>nul
@del %prj_path%\*.dpu 2>nul
@del %prj_path%\*.drc 2>nul
@del dcc32.log 2>nul

@del %prj_path%\project_*.~dsk 2>nul
@del %prj_path%\project_*.exe 2>nul
@del %prj_path%\project_*.map 2>nul
