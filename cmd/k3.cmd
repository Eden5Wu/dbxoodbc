@call acfg_crosskylix.bat

@rem @call make_prj.cmd k3 %1
@call make_prj.cmd k3 a.pas
@goto :eof

@set dcc=%CROSSKYLIX_DIR%\ckdcc.exe

@set libc=%CROSSKYLIX_LNX%/libc
@set kr=%CROSSKYLIX_LNX%/kylix
@set p=%kr%/lib/debug:%kr%/lib:%kr%/Imports:%kr%/Projects/Bpl:%kr%/Source/Toolsapi:%kr%/lib/Indy10

call %dcc% a.pas -U"%libc%:%p%" -I"%p%" -R"%p%"
@goto :eof
