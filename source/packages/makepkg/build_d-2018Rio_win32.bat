@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpl,bpi,lib
@call build_x.cmd 26 delphi-2018(26)Rio\win32 dbxoodbc260 bpl -JL

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 26 delphi-2018(26)Rio\win32 dbxoodbc260_emb bpl

@goto :eof
