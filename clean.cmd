@rem call cmd\clean.cmd

@pushd demos
@call clean.cmd
@popd

@pushd source\driver
@call clean.cmd
@popd

@pushd source\packages
@call clean.cmd
@popd
