@set compiler=%1
@set subdir=%2
@set libext=%3
@set libname=%4
@if "%compiler%" == "" set compiler=11

@rem compiler:
@rem  6 - Delphi 6
@rem  7 - Delphi 7
@rem  9 - Delphi 2005 Win32
@rem 10 - Delphi 2006 Win32
@rem 11 - Delphi 2007 Win32
@rem 12 - Delphi 2009 Win32
@rem 14 - Delphi 2010 Win32
@rem 15 - Delphi 2011 XE Win32
@rem 16 - Delphi 2011 XE Win32
@rem -
@rem 16w64 - Delphi 2012 XE2 Win64
@rem 16osx - Delphi 2012 XE2 OSX 32

@set _make_driver_params_=%compiler% %subdir% %libext% %libname%

call _make_driver_debug.bat %_make_driver_params_%
@if "%ERROR_STATE%"=="1" exit
call _make_driver_release.bat %_make_driver_params_%
