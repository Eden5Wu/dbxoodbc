@set clean=0

@pushd ..\..\source\driver\makelib\
  @call build_dcu_d-6.cmd
@popd

@pushd ..\..\source\packages\makelib
  @call build_dcu_d-6.cmd
@popd
