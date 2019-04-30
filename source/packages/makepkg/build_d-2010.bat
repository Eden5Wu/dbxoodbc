@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpl,bpi,lib
@call build_x.cmd 14 delphi-2010(14) dbxoodbc140 bpl -JL

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 14 delphi-2010(14) dbxoodbc140_emb bpl

@goto :eof
