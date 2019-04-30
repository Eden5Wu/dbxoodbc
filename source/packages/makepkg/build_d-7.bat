@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpi
@call build_x.cmd 7 delphi-7 dbxoodbc70 bpl -JL
@rem make bpl
@call build_x.cmd 7 delphi-7 dbxoodbc70 bpl

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 7 delphi-7 dbxoodbc70_emb bpl


@goto :eof
