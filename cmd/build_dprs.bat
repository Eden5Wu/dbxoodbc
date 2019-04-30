@echo off

set compiler=11

rem compiler:
rem 6  - Delphi  6
rem 7  - Delphi  7
rem 9  - Delphi  9 Win32
rem 9  - Delphi 2005 Win32
rem 10 - Delphi 2006 Win32
rem 11 - Delphi 2007 Win32
rem 12 - Delphi 2009 Win32
rem 14 - Delphi 2010 Win32
rem 15 - Delphi 2011 Win32

if "%compiler%" == "" set compiler=11

rem call make_prj.cmd %compiler% stm_replacer.dpr
rem exit

call make_prj.cmd %compiler% get_date.dpr
call make_prj.cmd %compiler% get_regval.dpr
call make_prj.cmd %compiler% stm_replacer.dpr
call make_prj.cmd %compiler% trim_file.dpr

@echo on
