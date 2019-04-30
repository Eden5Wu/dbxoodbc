@call clean_full.cmd

@pushd lib
@call clean_full.cmd
@popd

@del /S demos\others\dbx-explor*.exe>nul 2>nul
