@rem BUILDING DEBUG AND RELEASE VERSION WITH USAGE OF COMPILER DELPHI 6 WIN32

@rem note: -JL not supported(ignored)

@call build_x.cmd 16w64 delphi-2012(16)XE2\win64 dbxoodbc160 bpl -JL
@goto :eof
