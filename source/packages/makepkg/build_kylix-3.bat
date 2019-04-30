@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem make bpi
@rem hung: @call build_x.cmd k3 kylix-3 bpldbxoodbc60 so -JL
@rem make bpl
@call build_x.cmd k3 kylix-3 bpldbxoodbc60 so
@rem IDE alternative (embededed dbxoodbx.dll into package)
@set embedded=1
@call build_x.cmd k3 kylix-3 bpldbxoodbc60_emb so

@goto :eof
