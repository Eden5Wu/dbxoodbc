@set compiler=%1

@call clean.cmd
@call env-init.cmd
@rem @set c_dbxoopt=-JPHNE

@call %dbx%\cmd\make_prj.cmd %compiler% %prj_path%\%prj%.%prj_ext%
@del /Q _build.dcu _build.dpu _build.hpp _build.obj _build.o >nul 2>nul
