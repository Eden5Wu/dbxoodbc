@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpl,bpi,lib
@call build_x.cmd 24 delphi-2016(24)Berlin\win32 dbxoodbc240 bpl -JL

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 24 delphi-2016(24)Berlin\win32 dbxoodbc240_emb bpl

@goto :eof
