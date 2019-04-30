@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpl,bpi,lib
@call build_x.cmd 16 delphi-2012(16)XE2\win32 dbxoodbc160 bpl -JL

@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd 16 delphi-2012(16)XE2\win32 dbxoodbc160_emb bpl

@goto :eof
