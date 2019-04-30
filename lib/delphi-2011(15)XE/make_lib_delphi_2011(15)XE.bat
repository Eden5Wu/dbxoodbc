@set clean=0

@pushd ..\..\source\driver\makelib\
  @call build_dcu_d2011_xe.cmd
@popd

@pushd ..\..\source\packages\makelib
  @call build_dcu_d2011_xe.cmd
@popd
