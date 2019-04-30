@set clean=0

@pushd ..\..\..\source\driver\makelib\
  @call build_dcu_d2012_xe2_osx32.cmd
@popd

@pushd ..\..\..\source\packages\makelib
  @call build_dcu_d2012_xe2_osx32.cmd
@popd
