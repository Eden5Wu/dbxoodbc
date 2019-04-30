@rem tested for Windows NT only

@rem @setlocal ENABLEEXTENSIONS

@set make_prj_ver=2012.07.13
@rem #
@rem # make_prj Version 2012.07.13
@rem # ======================
@rem # Description:
@rem # ======================
@rem # Compilation: Delphi/Delphi.Net/C++Builder" projects/modules/packages.
@rem # For working it is necessary get_regval.exe.
@rem # For show help run without parameters.
@rem #
@rem # Copyright (c) 1998-2012
@rem # by "Vadim V.Lopushansky" <pult@ukr.net>
@rem #

@rem params parsing:

@if "%1"=="" goto L_HELP

@if "%1" == "/C"  goto L_CLEAN
@if "%1" == "/c"  goto L_CLEAN
@if "%1" == "/CA" goto L_CLEAN
@if "%1" == "/ca" goto L_CLEAN
@goto L_CLEAR_SKIP

:L_CLEAN
@del dcc*.log >nul 2>nul
@del /Q *.tds *.lsp *.ejf *.drc *.~* >nul 2>nul
@rem @del /Q *.hpp >nul 2>nul
@del *.bpi >nul 2>nul
@del /Q *.map *.jdbg *.pdb *.rsm >nul 2>nul
@del /Q *.dcp *.dcpil *.dcu *.dpu *.dcuil *.lib *.bpi *.obj *.o *.a  >nul 2>nul
@rem @del /Q *.bpl *.dpl >nul 2>nul
@rem @del /Q *.dylib *.dll >nul 2>nul
@if "%1" NEQ "/CA" goto L_CLEAN_DONE
@if "%1" NEQ "/ca" goto L_CLEAN_DONE
@del /Q *.cfg *.dof *.dsk >nul 2>nul
:L_CLEAN_DONE
@goto L_EXIT

:L_CLEAR_SKIP
@set DVER=%1
@rem if exist "%1"
@if "%2" NEQ "" set Project=%2
@if "%Project%"=="" goto L_ERROR_PARAM
@set DBASE=%DVER%

@rem Calculate Project specified options file name (Extract File Name):

@set file_name=
@for /F "delims=" %%i in ("%Project%") do @set file_name=%%~ni

@rem Clear user Envinronments
@set dccilOpt=
@set bccilOpt=

@set UserLib=.
@set UserLibI=.
@set UserLibO=.
@set UserLibR=.
@set UserPack=
@set UserCOpt=.
@set DEBUG_BATCH=0
@set CleanDcc32Log=1
@set UsePack=0
@set DEBUG=0
@set MAPFILE=1
@set TRACE_STACK_SOURCE=1
@set JDBG=0
@set Fmx=0

@rem set platform variables:

@set COMMAND=
@set DELPHI_ROOTDIR=
@set KEY=HKCU
@set Platform=
@set DelphiName=
@set ide_name=
@set REGPATH=
@set DXVER=?
@set PLIB=
@set PREL=
@set plfm=w32

@set pd=\
@set vd=;

@if "%DVER%"=="17w32"  set DVER=17
@if "%DVER%"=="D17"    set DVER=17
@if "%DVER%"=="16w32"  set DVER=16
@if "%DVER%"=="D16"    set DVER=16
@if "%DVER%"=="D15"    set DVER=15
@if "%DVER%"=="D14"    set DVER=14
@if "%DVER%"=="D12"    set DVER=12
@if "%DVER%"=="D11"    set DVER=11
@if "%DVER%"=="D10"    set DVER=10
@if "%DVER%"=="D9"     set DVER=9
@if "%DVER%"=="D8"     set DVER=8
@if "%DVER%"=="D7"     set DVER=7
@if "%DVER%"=="K3"     set DVER=k3
@if "%DVER%"=="D6"     set DVER=6
@if "%DVER%"=="D5"     set DVER=5
@if "%DVER%"=="D4"     set DVER=4
@if "%DVER%"=="D3"     set DVER=3
@if "%DVER%"==""       set DVER=0

@if "%DVER%"=="17osx"  set DVER=17osx32
@if "%DVER%"=="16osx"  set DVER=16osx32
@if "%DVER%"=="15w"    set DVER="15"
@if "%DVER%"=="14w"    set DVER="14"
@if "%DVER%"=="14W"    set DVER="14"
@if "%DVER%"=="12w"    set DVER="12"
@if "%DVER%"=="12W"    set DVER="12"
@if "%DVER%"=="11w"    set DVER="11"
@if "%DVER%"=="11W"    set DVER="11"
@if "%DVER%"=="10w"    set DVER="10"
@if "%DVER%"=="10W"    set DVER="10"
@if "%DVER%"=="9w"     set DVER="9"
@if "%DVER%"=="9W"     set DVER="9"
@if "%DVER%"=="8"      set DVER=BDS
@if "%DVER%"=="bds"    set DVER=BDS

@if "%DVER%"=="11N"    goto L_SET_BDS
@if "%DVER%"=="11n"    goto L_SET_BDS
@if "%DVER%"=="10N"    goto L_SET_BDS
@if "%DVER%"=="10n"    goto L_SET_BDS
@if "%DVER%"=="9N"     goto L_SET_BDS
@if "%DVER%"=="9n"     goto L_SET_BDS
@if "%DVER%"=="D.Net1" goto L_SET_DNET1
@if "%DVER%"=="D.NET1" goto L_SET_DNET1
@if "%DVER%"=="d.net1" goto L_SET_DNET1
@if "%DVER%"=="BDS"    goto L_SET_BDS

@if "%DVER%"=="B3"     goto L_SET_BUILDER
@if "%DVER%"=="b3"     goto L_SET_BUILDER
@if "%DVER%"=="B4"     goto L_SET_BUILDER
@if "%DVER%"=="b4"     goto L_SET_BUILDER
@if "%DVER%"=="B5"     goto L_SET_BUILDER
@if "%DVER%"=="b5"     goto L_SET_BUILDER
@if "%DVER%"=="B6"     goto L_SET_BUILDER
@if "%DVER%"=="b6"     goto L_SET_BUILDER

@if "%DVER%" NEQ "17w64" goto L_17w64_Done
@set DVER=17
@set plfm=w64
@goto L_PLFM
:L_17w64_Done

@if "%DVER%" NEQ "17osx32" goto L_17osx32_Done
@set DVER=17
@set plfm=osx32
@goto L_PLFM
:L_17osx32_Done

@if "%DVER%" NEQ "16w64" goto L_16w64_Done
@set DVER=16
@set plfm=w64
@goto L_PLFM
:L_16w64_Done

@if "%DVER%" NEQ "16osx32" goto L_16osx32_Done
@set DVER=16
@set plfm=osx32
@rem @goto L_PLFM
:L_16osx32_Done

:L_PLFM

@if "%DVER%"=="k3" set plfm=linux

@set DXVER=%DVER%
@if "%DVER%"=="9"  set DXVER=09
@if "%DVER%"=="8"  set DXVER=08
@if "%DVER%"=="7"  set DXVER=07
@if "%DVER%"=="k3" set DXVER=06
@if "%DVER%"=="6"  set DXVER=06
@if "%DVER%"=="5"  set DXVER=05
@if "%DVER%"=="4"  set DXVER=04
@if "%DVER%"=="3"  set DXVER=03

@set Platform=DX
@if "%DVER%"=="k3" set Platform=kylix
@if "%Platform%"=="kylix" set pd=/
@if "%Platform%"=="kylix" set vd=:
@if "%Platform%"=="kylix" set DelphiName=CrossKylix
@if "%Platform%"=="kylix" goto L_PLATFORM_DONE

@set ide_name=RAD Studio
@set DelphiName=BDS
@set REGPATH=\Software\Embarcadero\BDS

@if %DVER% GEQ 12  if %DVER% LEQ 14 set REGPATH=\Software\CodeGear\BDS
@if %DVER% GEQ 8   if %DVER% LEQ 11 set REGPATH=\Software\Borland\BDS
@if %DVER% LEQ 7   set REGPATH=\Software\Borland\Delphi
@if %DVER% LEQ 7   set DelphiName=Delphi
@if %DVER% LEQ 7   set ide_name=Delphi %DVER%
@if %DVER% LEQ 5   set KEY=HKLM

@if %DVER% GEQ 9   set /a ide_name=2005-9+%DVER%
@if %DVER% ==  12  set /a ide_name+=1
@if %DVER% GEQ 9   set ide_name=RAD Studio %ide_name%

@set xe=
@if %DVER% GEQ 16   set /a xe=%DVER%-14
@if %DVER% GEQ 15   set ide_name=%ide_name% XE%xe%

@if %DVER% GEQ 14  set /a DVER-=1
@if %DVER% GEQ 9   set /a DVER-=6

@rem @echo ### "%ide_name%" REGPATH=($REG:%KEY%%REGPATH%\%DVER%.0\RootDir)

:L_PLATFORM_DONE
@goto L_SET_DONE

:L_SET_DNET1
@set Platform=D.Net1
@set DVER=1
@set KEY=HKLM
@set REGPATH=\Software\Borland\Delphi for .NET Preview
@set DelphiName=Delphi.Net
@goto L_SET_DONE

:L_SET_BDS
@set Platform=DELPHI_NET
@if "%DVER%"=="11N" set DVER=5
@if "%DVER%"=="11n" set DVER=5
@if "%DVER%"=="10N" set DVER=4
@if "%DVER%"=="10n" set DVER=4
@if "%DVER%"=="9N"  set DVER=3
@if "%DVER%"=="9n"  set DVER=3
@set KEY=HKCU
@set REGPATH=\Software\Borland\BDS
@set DelphiName=Delphi.Net
@goto L_SET_DONE

:L_SET_BUILDER
@set Platform=CB
@set REGPATH=\SOFTWARE\Borland\C++Builder
@if "%DVER%"=="B8"  set DVER=8
@if "%DVER%"=="B7"  set DVER=7
@if "%DVER%"=="B6"  set DVER=6
@if "%DVER%"=="B5"  set DVER=5
@if "%DVER%"=="B4"  set DVER=4
@if "%DVER%"=="B3"  set DVER=1
@set KEY=HKLM
@if %DVER% GEQ 6 set KEY=HKCU
@set DelphiName=C++Builder

:L_SET_DONE
@rem read compiler root directory from registry:

@if "%Platform%" NEQ "kylix" goto L_PATH_FROM_REG
:L_PATH_FOR_KYLIX
@if "%CROSSKYLIX_DIR%"=="" @set CROSSKYLIX_DIR=C:\delphi\tools\CrossKylix
@if "%CROSSKYLIX_LNX%"=="" @set CROSSKYLIX_LNX=/C/delphi/tools/CrossKylix
@set ide_name=CrossKylix
@rem @goto L_PATH_FROM_REG_DONE
@goto L_PATH_KYLIX

:L_PATH_FROM_REG
@rem for Windows NT only
@for /F "eol=; tokens=1,2,3,4* delims=" %%i in ('get_regval.exe %KEY% %REGPATH%\%DVER%.0 RootDir /p /s') do @set DELPHI_ROOTDIR=%%i
@if "%DELPHI_ROOTDIR%"=="" goto L_ERROR_DX_ROOTDIR

@rem for Windows 9X and NT
@rem get_regval.exe %KEY% "%REGPATH%\%DVER%.0" RootDir /p /s /set >getregval.bat
@rem set REGVAL=
@rem call getregval.bat
@rem set DELPHI_ROOTDIR=%REGVAL%
@rem del getregval.bat 2>nul
@rem if "%DELPHI_ROOTDIR%"=="" goto L_ERROR_DX_ROOTDIR
:L_PATH_FROM_REG_DONE

@rem define system envinronment path:

@if "%Platform%"=="DELPHI_NET" goto L_PATH_DELPHI_NET
@if "%Platform%"=="D.Net1" goto L_PATH_DNET1
@if "%Platform%"=="kylix" goto L_PATH_KYLIX
@set path=%DELPHI_ROOTDIR%\Bin\system32;%DELPHI_ROOTDIR%\Bin;%DELPHI_ROOTDIR%\Projects\Bpl;%path%
@goto L_PATH_DONE
:L_PATH_DNET1
:L_PATH_DELPHI_NET
@rem todo: .Net SDK Assemblies
@rem todo: BDS Shared Assemblies
@set path=%DELPHI_ROOTDIR%\Bin;%DELPHI_ROOTDIR%\Projects\Assemblies;%path%
@goto L_PATH_DONE
:L_PATH_KYLIX
@set path=%CROSSKYLIX_DIR%;%path%
@rem @goto L_PATH_DONE
:L_PATH_DONE

@rem Set User Envinronments

@rem if "%3"=="/c" if exist "%SystemRoot%\dx_common.cmd" if not exist "common.cmd" call call "%SystemRoot%\dx_common.cmd"
@if "%3"=="/c" if exist "%SystemRoot%\dx_common.cmd" call call "%SystemRoot%\dx_common.cmd"
@if exist "common.bat" call "common.bat"
@if exist "common.cmd" call "common.cmd"
@if exist "%file_name%.bat" call "%file_name%.bat"

@if "%UserLib%"==""    set UserLib=.
@if "%UserLibI%"==""   set UserLibI=.
@if "%UserLibO%"==""   set UserLibO=.
@if "%UserLibR%"==""   set UserLibR=.
@if "%UserCOpt%"=="."  set UserCOpt=

@set DBG=0
@if "%DEBUG%" == "1" set DBG=1
@if "%DEBUG%" NEQ "1" if "%TRACE_STACK_SOURCE%"=="1" set DBG=1

@rem define Library path:

@if "%Platform%"=="D.Net1" goto L_SRC_DNET
@if "%Platform%"=="DELPHI_NET" goto L_SRC_DELPHI_NET
@if "%Platform%"=="kylix" goto L_SRC_KYLIX
@set DLib=%UserLib%
@if "%DXVER%" NEQ "?" if %DXVER% GEQ 15 @(
  set PLIB=\win32
  if "%plfm%"=="w64" set PLIB=\win64
  if "%plfm%"=="osx32" set PLIB=\osx32
)
@set PLIB=lib%PLIB%
@if "%DXVER%" NEQ "?" if %DXVER% GEQ 15 set PREL=\release
@if .%DBG%==.1 set DLib=%UserLib%;%DELPHI_ROOTDIR%\%PLIB%\debug

@set DLib=%DLib%;%DELPHI_ROOTDIR%\%PLIB%%PREL%
@set DLib=%DLib%;%DELPHI_ROOTDIR%\imports
  @rem set DLib=%DLib%;%DELPHI_ROOTDIR%\ocx\servers
@set DLib=%DLib%;%DELPHI_ROOTDIR%\projects\bpl
@set DLib=%DLib%;%DELPHI_ROOTDIR%\source\toolsapi
  @rem set DLib=%DLib%;%DELPHI_ROOTDIR%\bin\system32
@if "%indy%" ==  "09" @set DLib=%DLib%;%DELPHI_ROOTDIR%\%PLIB%\indy9
@if "%indy%" NEQ "09" @set DLib=%DLib%;%DELPHI_ROOTDIR%\%PLIB%\indy10

@goto L_SRC_DONE

:L_SRC_DELPHI_NET
@set %UserLibI%=%UserLibI%;%DELPHI_ROOTDIR%\lib
@set %UserLibO%=%UserLibO%;%DELPHI_ROOTDIR%\lib
@set %UserLibR%=%UserLibR%;%DELPHI_ROOTDIR%\lib
@set DLib=%UserLib%
@if .%DBG%==.1 set DLib=%UserLib%;%DELPHI_ROOTDIR%\lib\debug
@set DLib=%DLib%;%DELPHI_ROOTDIR%\lib
@goto L_SRC_DONE
:L_SRC_DNET
@rem delphi .Net Preview:
@set %UserLibI%=%UserLibI%;%DELPHI_ROOTDIR%\units
@set %UserLibO%=%UserLibO%;%DELPHI_ROOTDIR%\units
@set %UserLibR%=%UserLibR%;%DELPHI_ROOTDIR%\units
@set DLib=%UserLib%;%DELPHI_ROOTDIR%\units
@goto L_SRC_DONE
:L_SRC_KYLIX
@set DLib=%UserLib%
@set DLib=%DLib%:%CROSSKYLIX_LNX%/libc
@if .%DBG%==.1 set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib/debug
@if .%DBG%==.1 if "%indy%"=="09" set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib/debug/indy9
@if .%DBG%==.1 if "%indy%" NEQ "09" set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib/debug/indy10
@set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib
@set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/imports
@set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/source/toolsapi
@if "%indy%"=="09" set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib/indy9
@if "%indy%" NEQ "09" set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/lib/indy10
@rem @set DLib=%DLib%:%CROSSKYLIX_LNX%/kylix/bin
@rem @goto L_SRC_DONE
:L_SRC_DONE

@rem Build:

@if "%Platform%"=="DELPHI_NET" goto L_BUILD_DNET
@if "%Platform%"=="D.Net1" goto L_BUILD_DNET
@if "%Platform%"=="CB" goto L_BUILD_BUILDER

@set t=
@if "%ide_name%" NEQ "" set t=; "%ide_name%"
@if "%Project%" NEQ "?" @echo %Project% - start make_prj, ver "%make_prj_ver%"%t%:
@set DCC_OPT=-$J+,R-,I-,Q-,Y-,B-,A+,W-,U-,T-,H+,X+,P+,V+,G+

@rem EQU, NEQ, LSS, LEQ, GTR, GEQ
@if %DXVER% GEQ 10 set DCC_OPT=--no-config %DCC_OPT%
@if %DXVER% GEQ 10 set DCC_OPT=%DCC_OPT% -W-SYMBOL_PLATFORM -W-UNIT_PLATFORM -W-GARBAGE
@if %DXVER% GEQ 16 set DCC_OPT=%DCC_OPT% -NSSystem;Winapi;System.Win;Data;Data.Win;BDE;Xml;Datasnap;Soap;Web;Web.Win
@if %DXVER% GEQ 16 if %Fmx%==0 set DCC_OPT=%DCC_OPT% -NSVcl;Vcl.Imaging;Vcl.Touch;Vcl.Shell;VclTee
@if %DXVER% GEQ 16 if %Fmx%==1 set DCC_OPT=%DCC_OPT% -NSFmx
@if %DXVER% GEQ 16 if %Fmx%==2 set DCC_OPT=%DCC_OPT% -NSVcl;Vcl.Imaging;Vcl.Touch;Vcl.Shell;VclTee;Fmx

@set dccPath=%DELPHI_ROOTDIR%\bin
@set dccName=dcc32
@if "%plfm%"=="w64" set dccName=dcc64
@if "%plfm%"=="osx32" set dccName=dccosx
@if "%Platform%"=="kylix" set dccName=ckdcc
@if "%Platform%"=="kylix" set dccPath=%CROSSKYLIX_DIR%

@set dccName=%dccName%.exe

@if "%DEBUG%"=="1"      set DCC_OPT=%DCC_OPT% -DDEBUG;_DEBUG_
@if "%DEBUG%"=="0"      set DCC_OPT=%DCC_OPT% -$D-
@rem ,$C-,O+
@if "%DEBUG%" NEQ "0"   set DCC_OPT=%DCC_OPT% -$D+,L+,Y+,C-,O-
@if "%MAPFILE%"=="1"    set DCC_OPT=%DCC_OPT% -GD
@if "%UserCOpt%" NEQ "" set DCC_OPT=%DCC_OPT% %UserCOpt%

@rem set DCC_OPT=-Q -M -B %DCC_OPT%
@set DCC_OPT=-M -B %DCC_OPT%
@rem System Unit Recompile:
@rem set DCC_OPT=-v %DCC_OPT%

@if "%UserLib%" NEQ "" set UserLib=%UserLib%%vd%

@if "%UserPack%" == "" goto L_USE_PACK_DX
@rem todo: ???: not supported -LU
@set DCC_OPT=%DCC_OPT% -LU%UserPack%
:L_USE_PACK_DX

@if "%Project%"=="?" goto L_EXIT
@set COMMAND=%dccName% %Project% %DCC_OPT% -U"%DLib%" -I"%DLib%" -R"%DLib%"
@call date/t>>dcc32.log
@call time/t>>dcc32.log
@echo %COMMAND%>>dcc32.log
@echo\>con
@echo %COMMAND%>con
@echo\>con
@"%dccPath%\%dccName%" %Project% %DCC_OPT% -U"%DLib%" -I"%DLib%" -R"%DLib%"
@rem @echo ERRORLEVEL=%ERRORLEVEL%
@echo %Project% - finish
@if "%ERRORLEVEL%" NEQ "0" goto L_ERROR
@if "%JDBG%"=="1" call MakeJclDbg.exe -J %Project%

@goto L_BUILD_DONE

:L_BUILD_DNET

@set dccilOpt=-m -nsBorland.Delphi.System -nsBorland.Delphi -nsBorland.Vcl -luSystem.Drawing -luSystem.Data -luSystem.Windows.Forms %dccilOpt%

@if "%Project%"=="?" goto L_EXIT
@if "%UserLibO%"=="." @set UserLibO=
@if "%UserLibO%" NEQ "" @set UserLibO=-o%UserLibO%
@set COMMAND=dccil %dccilOpt% %UserCOpt% %Project% -U"%DLib%" -I"%UserLibI%" -R"%UserLibR%" %UserLibO%
@echo ------------------------------------------------------------------------------------------>con
@echo COMMAND=%COMMAND%>con
@echo ------------------------------------------------------------------------------------------>con
@dccil %dccilOpt% %UserCOpt% %Project% -U"%DLib%" -I"%UserLibI%" -R"%UserLibR%" -o%UserLibO%
@if "%ERRORLEVEL%" NEQ "0" goto L_ERROR

@goto L_BUILD_DONE

:L_BUILD_BUILDER
@if "%DVER%"=="1" set DVER=3
@set BDFIX=
@if "%DVER%"=="3" set BDFIX=;VER110
@if "%DVER%"=="4" set BDFIX=;VER125
@if "%DVER%"=="5" set BDFIX=;VER130;BCB
@if "%DVER%"=="6" set BDFIX=;VER140;BCB

@set DCC_OPT=-$J+,R-,I-,Q-,Y-,B-,A+,W-,U-,T-,H+,X+,P+,V+

@if .%DBG%==.0          set DCC_OPT=%DCC_OPT%,D-,$C-,O+
@if .%DBG%==.1          set DCC_OPT=%DCC_OPT%,D+,L+,C-,O-
@if "%MAPFILE%"=="1"    set DCC_OPT=%DCC_OPT% -GD
@if "%UserCOpt%" NEQ "" set DCC_OPT=%DCC_OPT% %UserCOpt%

@set DCC_OPT=-JPHN %DCC_OPT%
@rem @set DCC_OPT=-M %DCC_OPT%
@rem System Unit Recompile
@rem set DCC_OPT=-v %DCC_OPT%

@if "%UserLib%" NEQ "" set UserLib=%UserLib%%vd%

@set UnitDir=%DELPHI_ROOTDIR%\lib\release;%DELPHI_ROOTDIR%\lib\obj;%DELPHI_ROOTDIR%\bin\lib;%DELPHI_ROOTDIR%\release
@set IncludeDir=%DELPHI_ROOTDIR%\include;%DELPHI_ROOTDIR%\include\vcl
@set ResourceDir=%IncludeDir%;%UnitDir%
@set UnitDir=%UserLib%%UnitDir%
@set IncludeDir=%UserLib%%UnitDir%

@if "%Project%"=="?" goto L_EXIT
@set COMMAND=dcc32.exe" -D_RTLDLL;USEPACKAGES%BDFIX% -U%UnitDir%  -I%IncludeDir% -R%ResourceDir% %Project% %DCC_OPT%
@echo ------------------------------------------------------------------------------------------>con
@echo "%DELPHI_ROOTDIR%\bin\dcc32.exe"  -D_RTLDLL;USEPACKAGES%BDFIX% -U%UnitDir%  -I%IncludeDir% -R%ResourceDir% %Project% %DCC_OPT% %bccOpt%>con
@echo ------------------------------------------------------------------------------------------>con
@"%DELPHI_ROOTDIR%\bin\dcc32.exe" -D_RTLDLL;USEPACKAGES%BDFIX% -U%UnitDir%  -I%IncludeDir% -R%ResourceDir% -M %Project% %DCC_OPT%
@if "%ERRORLEVEL%" NEQ "0" goto L_ERROR

:L_BUILD_DONE
@if "%CleanDcc32Log%"=="1" del dcc32.log >nul 2>nul

@echo Done.

@goto L_EXIT

:L_ERROR_DX_ROOTDIR
@set KEYSTR=HKEY_CURRENT_USER
@if "%ide_name%"=="" set ide_name=%DelphiName% %DVER%
@if "%KEY%"=="HKLM" set KEYSTR=HKEY_LOCAL_MACHIME
@echo ERROR:>con
@echo  Не смог найти "%ide_name%">con
@echo  Подробнее:>con
@echo    Cannot find registry path:>con
@echo       '%KEYSTR%%REGPATH%\%DVER%.0\RootDir'>con
@echo press any key to exit>con
@pause >nul
@goto L_EXIT

:L_HELP
@rem cls
@goto L_HELP_INFO
:L_ERROR_PARAM
@echo ERROR: (unknown parameters)>con
:L_HELP_INFO
@echo  make_prj Version %make_prj_ver%>con
@echo   "make_prj.cmd" - The utility of assembly/compilation of Delphi/Delphi.Net/C++ Builder/Kylix project/unit/package>con
@echo ---------------------------------------------------------------------------------------------->con
@echo Usage:>con
@echo   make_prj.cmd  "delphi-compiler"  "Project_Name|?" ["options"]>con
@echo Where:>con
@echo   [1] delphi-compiler:>con
@echo        16       - Delphi 2012 (XE2) for win32>con
@echo        16w64    - Delphi 2012 (XE2) for win64>con
@echo        16osx    - Delphi 2012 (XE2) for osx32>con
@echo        15       - Delphi 2011 (XE)  for win32>con
@echo        14       - Delphi 2010       for win32>con
@echo        12       - Delphi 2009       for win32>con
@echo        11       - Delphi 2007       for win32>con
@echo        11N      - Delphi 2007       for .net2>con
@echo        10       - Delphi 2006       for win32>con
@echo        10N      - Delphi 2006       for .net2>con
@echo        9        - Delphi 2005       for win32>con
@echo        9N       - Delphi 2005       for .net1>con
@echo        8        - Delphi 8          for .net1>con
@echo        BDS      - Delphi 8          for .net1>con
@echo        D.Net1   - Delphi            for .net1 preview>con
@echo        7        - Delphi 7          for win32>con
@echo        k3       - Kylix  3          for linux x86 ( CrossKylix: C:\delphi\tools\CrossKylix )>con
@echo        6        - Delphi 6          for win32>con
@echo        5        - Delphi 5          for win32>con
@echo        4        - Delphi 4          for win32>con
@echo        3        - Delphi 3          for win32>con
@echo\>con
@echo        B6       - C++ Builder 6     for win32>con
@echo        B5       - C++ Builder 5     for win32>con
@echo        B4       - C++ Builder 4     for win32>con
@echo        B3       - C++ Builder 3.5   for win32>con
@echo\>con
@echo        /C       - Clean - Cleaning of the current directory from: (dcu, obj, hpp, drc, ...)>con
@echo        /CA      - /C + Cleaning of the current directory from: "cfg, dof, dsk" Files>con
@echo\>con
@echo   [2] "Project_Name|?"  -  Name of the project/unit or ? for installation of environment variables only.>con
@echo\>con
@echo   [3] "Options":>con
@echo          /c  - To search common "%%SystemRoot%%\dx_common.cmd" describing for common options.>con
@echo\>con
@echo Examples:>con
@echo   make_prj.cmd 3 Project1.dpr>con
@echo   make_prj.cmd 6 Unit1.pas>con
@echo   make_prj.cmd B6 Unit1.pas>con
@echo   make_prj.cmd 9N my.module.pas>con
@echo   make_prj.cmd 16w64 DbxOpenOdbc.pas>con
@echo   make_prj.cmd 16osx DbxOpenOdbc.pas>con
@echo   make_prj.cmd k3 DbxOpenOdbc.pas>con
@echo   make_prj.cmd /C>con
@echo   make_prj.cmd D5 ?  - Only installation of environment variables>con
@echo   make_prj.cmd 6 project1.dpr /c - Originally to take adjustments from dx_common.cmd>con
@echo PS:>con
@echo   For working it is necessary "get_regval.exe">con
@echo ------------------------------------------------------------------------------------------>con
@goto L_EXIT

:L_ERROR

@if "%DEBUG_BATCH%"=="1" goto L_ERROR_LOG

@echo ------------------------------------------------------------------------------------------>con
@echo PATH=%path%>con
@echo ------------------------------------------------------------------------------------------>con
@echo Error (ERRORLEVEL="%ERRORLEVEL%").>con
@if "%UserLib%" NEQ "" if "%UserLib%" NEQ "." echo UserLib=%UserLib%>con
@if "%UserPack%" NEQ "" echo UserPack=%UserPack%>con
@echo ------------------------------------------------------------------------------------------>con
@echo command:>con
@echo %COMMAND%>con
@echo ------------------------------------------------------------------------------------------>con

:L_ERROR_LOG

@rem Clean Log File
@rem @if "%ERRORLEVEL%"=="0" if "%CleanDcc32Log%"=="1" del dcc32.log >nul 2>nul
@if "%CleanDcc32Log%"=="1" del dcc32.log >nul 2>nul

@echo ------------------------------------------------------------------------------------------>>dcc32.log
@set>>dcc32.log
@echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . >>dcc32.log
@echo Error (ERRORLEVEL="%ERRORLEVEL%").>>dcc32.log
@echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . >>dcc32.log
@echo PATH=%path%>>dcc32.log
@echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . >>dcc32.log
@echo Error (ERRORLEVEL="%ERRORLEVEL%").>>dcc32.log
@echo UserLib=%UserLib%>>dcc32.log
@echo UserPack=%UserPack%>>dcc32.log
@echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . >>dcc32.log
@echo command:>>dcc32.log
@echo %COMMAND%>>dcc32.log
@echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . >>dcc32.log

@if exist "error_handler.bat" call error_handler.bat
@if "%SKIP_ERROR%"=="1" goto L_EXIT

:L_ERROR_SKIPCMD
@rem @if "%FARHOME%" NEQ "" goto L_WAIT_2
@rem @echo Press Crtl+C to quit ... >con
@rem @ping -a -n 10 1.1.1.1 -w 10000>nul
@rem :L_WAIT_2
@echo !!! ERROR !!! Press any key to exit . . .>con
@pause >nul
@set errorlevel=1
@exit 1

:L_EXIT
