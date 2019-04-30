@if "%1" NEQ  "-p" @echo off

@call env-init.cmd -p

@set y=
@set m=
@set d=
@set h=

@rem ------ calculate datetime variables: ------
@set ty=
@set td=
@set tm=
@set th=
@for /F "eol=; tokens=1,2,3,4,5,6,* delims=-: " %%i in ('%dbx%\cmd\get_date.exe /t') do @(
  set ty=%%i
  set tm=%%j
  set td=%%k
  set th=%%l
)
@if "%ty%"=="" set ty=0
@if "%tm%"=="" set tm=%ty%
@if "%td%"=="" set td=%ty%
@if "%th%"=="" set th=%ty%

@if "%y%" == "" set y=%ty%
@if "%m%" == "" set m=%tm%
@if "%d%" == "" set d=%td%
@if "%h%" == "" set h=%th%
:L_DATE_DONE
@rem debug:
@rem echo d=%d%
@rem echo m=%m%
@rem echo y=%y%
@rem echo h=%h%
@rem ------ calculate datetime variables . ------

@rem ------------------ define version variables : ------------------------

@rem  major version number ( == dbx version )
@set v1=3

@rem  minor version number ( == year )
@set v2=%y%

@rem  release version number ( == month )
  @rem remove leading 0
@set a=%m%
@set a=%a:~0,-1%
@set b=%m%
@set b=%b:~1,1%
@if .%a% == .0  set v3=%b%
@if .%a% neq .0 set /a v3=%m%

@rem  build version number ( == day )
  @rem remove leading 0
@set a=%d%
@set a=%a:~0,-1%
@set b=%d%
@set b=%b:~1,1%
@if .%a% == .0  set v4=%b%
@if .%a% neq .0 set /a v4=%d%

@rem echo v3=%v3%
@rem echo v4=%v4%

@rem  build type ( == Release/RC/Dev/Beta/Alpha )
@set b=Dev

@set i=%prj%{template}
@set o=%prj%

@rem ------------------ define version variables . ------------------------



@if "%1" NEQ  "-p" @echo on
