@del *.dcu *.dpu *.drc dcc*.log>nul 2>nul
@if "%1"=="-A" @del *.bpl *.dcp *.map *.jdbg>nul 2>nul

@goto :eof
