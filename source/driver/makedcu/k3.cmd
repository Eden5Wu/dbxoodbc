@call env-init.cmd
@call %dbx%\cmd\ckdcc.cmd _build.pas
@del _build.dcu>nul 2>nul
@goto :eof
