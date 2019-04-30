unit _build;

interface

uses
  {$IFDEF MSWINDOWS}
  {$IFDEF WIN32}
  FastMM4,
  FastMM4Messages,
  {$ENDIF}{$ENDIF}
  DbxOpenOdbcTypes,
  DbxOpenOdbcDbx3Types,
  DbxOpenOdbcInterface,
  OdbcApi,
  DbxOpenOdbcUtils,
  DbxOpenOdbcFuncs,
  DbxOpenOdbc,
  DbxOpenOdbc3,
  DbxOpenOdbcTrace,
  //{$IFDEF MSWINDOWS}
  //{$IFDEF WIN32}
  DbxOpenOdbcStatic,
  //{$ENDIF}{$ENDIF}
  SysUtils;

implementation

end.
