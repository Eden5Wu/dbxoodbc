@set dbx=.\..\..\..
@set prj=dbxoodbc
@set prj_ext=dpr
@set prj_path=%dbx%\source\driver

@set compiler-def=11

@rem compiler:
@rem 6     - Delphi  6
@rem 7     - Delphi  7
@rem 9     - Delphi  9 Win32
@rem 9     - Delphi 2005 Win32
@rem 10    - Delphi 2006 Win32
@rem 11    - Delphi 2007 Win32
@rem 12    - Delphi 2009 Win32
@rem 14    - Delphi 2010 Win32
@rem 15    - Delphi 2011 Win32
@rem 16    - Delphi 2012 Win32
@rem 16w64 - Delphi 2012 Win64
@rem 16osx - Delphi 2012 OSX32

@set path=%dbx%\cmd;%path%

@if "%prj_path%" == "" set prj_path=.

@if "%compiler%" == "" set compiler=%compiler-def%
@if "%compiler%" == "" set compiler=11
