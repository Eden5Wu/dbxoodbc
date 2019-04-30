@set clean=0

@pushd ..\..\..\source\driver\makelib\
  @call build_dcu_d2018_rio_win64.cmd
@popd

@pushd ..\..\..\source\packages\makelib
  @call build_dcu_d2018_rio_win64.cmd
@popd
