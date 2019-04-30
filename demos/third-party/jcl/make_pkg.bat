@call clean.cmd -A
@call make_prj.cmd 6 jclmini.dpk
@if exist "jclmini60.map" call make_jdbg.cmd
@rem @call clean.cmd

@goto :eof
