@echo off

@call env-init.cmd

@set comp_root=.\third-party

@set comp_jcl=..\..\third-party\jcl

@set comp_compress=%comp_root%\COMPRESS
@set comp_graphicex=%comp_root%\GraphicEx
@set comp_hexedit=%comp_root%\HexEdit
@set comp_synedit=%comp_root%\SynEdit
@set comp_xpmenu=%comp_root%\XPMenu

@rem Common options

  @set UsePack=0
  @set DEBUG=1
  @set MAPFILE=1
  @set CleanDcc32Log=1
  @set DEBUG_BATCH=1
  @set TRACE_STACK_SOURCE=1

  @set UserLib=%dbx%\driver\source;%dbx%\packages\source

  @rem @set UserLib=%UserLib%;fixes

  if %DXVER% LSS 8  set UserLib=%UserLib%;%dbx%\packages\source\2005Dwn
  if %DXVER% LSS 11 set UserLib=%UserLib%;%dbx%\packages\source\2006Dwn
  if %DXVER% LSS 12 set UserLib=%UserLib%;%dbx%\packages\source\2007Dwn
  if %DXVER% GEQ 11 set UserLib=%UserLib%;%dbx%\packages\source\2007Up

  set UserLib=D%DXVER%;%UserLib%

  @set UserLib=%UserLib%;%comp_jcl%
  @set UserLib=%UserLib%;%comp_compress%
  @set UserLib=%UserLib%;%comp_graphicex%
  @set UserLib=%UserLib%;%comp_hexedit%
  @set UserLib=%UserLib%;%comp_synedit%
  @set UserLib=%UserLib%;%comp_xpmenu%

  @set UserLibI=%UserLib%
  @set UserLibR=%UserLib%

  @set UserCOpt=-D_DEBUG_ -$R-,O-,D+,L+

@set T=dcc_options%destination%.cmd
@if exist "%T%" call "%T%"
