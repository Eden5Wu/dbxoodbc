program Project1;

  { Delphi 6/7/2005/2006/2007/2009/2010/2011(XE)/2012(XE2) }

uses
  {$IFDEF _MEMCHECK_}
  FastMM4,
  {$ENDIF}
  Windows, // for Delphi 2006 and DbxOpenOdbcStatic
  //ExceptDlg, { optional: trace exception calls stack }
  //MidasLib, { optional: Link ClientDataSet statically }
  DbxOpenOdbcStatic, //{ optional }
  DbxXXDrv, { critical }
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  //{$if CompilerVersion >= 18.50}
  //Application.MainFormOnTaskbar := True;
  //{$ifend}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
