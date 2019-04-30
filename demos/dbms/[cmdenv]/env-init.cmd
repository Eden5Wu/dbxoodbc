@set dbx=.\..\..\..\..
@set prj=%1
@set prj_ext=dpr
@set prj_path=.

@set compiler-def=11

@rem compiler:
@rem 6  - Delphi  6
@rem 7  - Delphi  7
@rem 9  - Delphi  9 Win32
@rem 9  - Delphi 2005 Win32
@rem 10 - Delphi 2006 Win32
@rem 11 - Delphi 2007 Win32
@rem 12 - Delphi 2009 Win32
@rem 14 - Delphi 2010 Win32
@rem 15 - Delphi 2011 Win32

@rem set cmdenv=%cd%
@set cmdenv=..\..\
@rem set path=%dbx%\cmd;%cmdenv%;%path%
@set path=%dbx%\cmd;%cmdenv%;%SystemRoot%;%SystemRoot%\system32

@if "%prj_path%" == "" set prj_path=.

@if "%compiler%" == "" set compiler=%compiler-def%
@if "%compiler%" == "" set compiler=11
