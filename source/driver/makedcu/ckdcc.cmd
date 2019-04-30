@if "%1"=="" goto :eof
@cd makedcu
@call env-init.cmd
@call %dbx%\cmd\ckdcc.cmd ..\%1
@goto :eof
