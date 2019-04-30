@rem template: common.cmd
@setlocal ENABLEEXTENSIONS

@rem Common options

  @set UsePack=0
  @set DEBUG=0
  @set MAPFILE=1
  @set JDBG=0
  @set JDBG_LINK=0
  @set JDBG_FILE=0
  @set CleanDcc32Log=1
  @set DEBUG_BATCH=1
  @set TRACE_STACK_SOURCE=1

  @set UserCOpt=-D_RELEASE_;AttemptToUseSharedMM -$R-,O+,D+,L+,Y+

@rem Critical compiler search path options:

  @rem
  @rem for all projects
  @rem
    @if "%Platform%" NEQ "kylix" @set UserLib=%dbx%\driver\source
    @if "%Platform%" == "kylix" @set UserLib=%dbx%/driver/source
    @rem set UserLib=%UserLib%;...

  @rem
  @rem for packages and user projects:
  @rem
    @rem set UserLib=%UserLib%;%dbx%\driver\packages\source


  @rem
  @rem { optional: } for user projects:
  @rem
    @rem set UserLib=%UserLib%;%dbx%\demos\third-party\jcl

@rem set Include and Resource path

  @set UserLibI=%UserLib%
  @set UserLibR=%UserLib%
