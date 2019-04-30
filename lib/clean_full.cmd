@set t=*
@del /Q /S %t%.dcu %t%.dpu %t%.obj %t%.o %t%.hpp 1>nul 2>nul

@set t=*dbxoodbc*
@del /Q /S %t%.dll %t%.bpl %t%.so %t%.dylib %t%.dcp %t%.map %t%.jdbg %t%.bpi %t%.lib %t%.a 1>nul 2>nul

@rem @del /Q /S *dbxoodbc*
