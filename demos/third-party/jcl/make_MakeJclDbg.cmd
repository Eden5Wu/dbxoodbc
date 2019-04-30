@set compiler=%1
@if "%compiler%" == "" set compiler=11

@rem compiler:
@rem 6  - Delphi 6
@rem 7  - Delphi 7
@rem 9  - Delphi 2005 for Win32
@rem 10 - Delphi 2006 for Win32
@rem 11 - Delphi 2007 for Win32
@rem 12 - Delphi 2009 for Win32
@rem 14 - Delphi 2010 for Win32
@rem 15 - Delphi 2011 for Win32 (XE)
@rem 16 - Delphi 2012 for Win32 (XE2)

@..\..\..\cmd\make_prj %compiler% MakeJclDbg.dpr
