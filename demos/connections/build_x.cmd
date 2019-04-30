@set compiler=%1

@call env-init.cmd

@call %dbx%\cmd\make_prj.cmd %compiler% %prj_path%\%prj%.%prj_ext%
@del _build.dcu _build.dpu _build.obj _build.o>nul 2>nul
