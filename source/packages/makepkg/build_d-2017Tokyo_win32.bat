@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpl,bpi,lib
@call build_x.cmd 25 delphi-2017(25)Tokyo\win32 dbxoodbc250 bpl -JL

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 25 delphi-2017(25)TTokyo\win32 dbxoodbc250_emb bpl

@goto :eof
