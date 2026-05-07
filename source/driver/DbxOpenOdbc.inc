{$IFNDEF DBXOPENODBC_INC}
{$DEFINE DBXOPENODBC_INC}

//
// Delphi Versions:
//

{ DbxOpenOdbc compiles under
 Delphi        V6.00, V6.01, V6.02, V7.00
 Kylix         V1(?), V2(?), V3(?)
 C++ Builder   V6(?)
}
{
CompilerVersion
(taken from http://www.blong.com/Tips/KylixTips.htm)
Delphi 5; Kylix 1; C++ Builder 5; or any earlier version: CompilerVersion NOT DEFINED
Delphi 6.00:   14.01
Delphi 6.01:   14.01
Delphi 6.02:   14.01
C++Builder 6:  14.01
Kylix 2:       14.10
Kylix 3:       14.50
Delphi 7:      15.00
}

{$UNDEF _KYLIX_}
{$UNDEF _K1UP_}
{$UNDEF _D6UP_}  // Delphi 6
{$UNDEF _K2UP_}
{$UNDEF _K3UP_}
{$UNDEF _D7UP_}  // Delphi 7
{$UNDEF _D9UP_}  // Delphi 2005
{$UNDEF _D10UP_} // Delphi 2006
{$UNDEF _D11UP_} // Delphi 2007
{$UNDEF _D12UP_} // Delphi 2009
{$UNDEF _D14UP_} // Delphi 2010
{$UNDEF _D15UP_} // Delphi 2011 XE
{$UNDEF _D16UP_} // Delphi 2012 XE2
{$UNDEF _D17UP_} // Delphi 2013 XE3
{$UNDEF _D18UP_} // Delphi XE4
{$UNDEF _D19UP_} // Delphi XE5
{$UNDEF _D20UP_} // Delphi XE6
{$UNDEF _D21UP_} // Delphi XE7
{$UNDEF _D22UP_} // Delphi XE8
{$UNDEF _D23UP_} // Delphi 10 Seattle
{$UNDEF _D24UP_} // Delphi 10.1 Berlin
{$UNDEF _D25UP_} // Delphi 10.2 Tokyo
{$UNDEF _D26UP_} // Delphi 10.3 Rio
{$UNDEF _D27UP_} // Delphi 10.4 Sydney
{$UNDEF _D28UP_} // Delphi 11 Alexandria
{$UNDEF _D29UP_} // Delphi 12 Athens
{$UNDEF _D37UP_} // Delphi 13 Florence

{$IFDEF CONDITIONALEXPRESSIONS}
  {$DEFINE _K1UP_}
  {$IF Declared(CompilerVersion)}
    {$IF CompilerVersion >= 14.01}
       // Delphi 6.00 and up
      {$DEFINE _D6UP_}
    {$IFEND}
    {$IF CompilerVersion >= 14.10}
      // Kylix 2 and up
      {$DEFINE _K2UP_}
    {$IFEND}
    {$IF CompilerVersion >= 14.50}
      // Kylix 3 and up
      // Kylix 3 supports something somewhere between D6 and D7
      {$DEFINE _K3UP_}
    {$IFEND}
    {$IF CompilerVersion >= 15.00}
      // Delphi 7.00 and up
      {$DEFINE _D7UP_}
    {$IFEND}
    {$IF CompilerVersion >= 17.00}
      // D9: Delphi 2005 and up
      {$DEFINE _D9UP_}
    {$IFEND}
    {$IF CompilerVersion >= 18.00}
      // D10: Delphi 2006 and up
      {$DEFINE _D10UP_}
    {$IFEND}
    {$IF CompilerVersion >= 18.50}
      // D11: Delphi 2007 and up
      {$DEFINE _D11UP_}
    {$IFEND}
    {$IF CompilerVersion >= 20.00}
      // D12: Delphi 2009 and up
      {$DEFINE _D12UP_}
    {$IFEND}
    {$IF CompilerVersion >= 21.0}
      // D14: Delphi 2010 and up
      {$DEFINE _D14UP_}
    {$IFEND}
    {$IF CompilerVersion >= 22.0}
      // D15: Delphi 2011 (XE) and up
      {$DEFINE _D15UP_}
    {$IFEND}
    {$IF CompilerVersion >= 23.0}
      // D16: Delphi 2012 (XE2) and up
      {$DEFINE _D16UP_}
    {$IFEND}
    {$IF CompilerVersion >= 24.0}
      // D17: Delphi 2013 (XE3) and up
      {$DEFINE _D17UP_}
    {$IFEND}
    {$IF CompilerVersion >= 25.0}
      // D18: Delphi XE4 and up
      {$DEFINE _D18UP_}
    {$IFEND}
    {$IF CompilerVersion >= 26.0}
      // D19: Delphi XE5 and up
      {$DEFINE _D19UP_}
    {$IFEND}
    {$IF CompilerVersion >= 27.0}
      // D20: Delphi XE6 and up
      {$DEFINE _D20UP_}
    {$IFEND}
    {$IF CompilerVersion >= 28.0}
      // D21: Delphi XE7 and up
      {$DEFINE _D21UP_}
    {$IFEND}
    {$IF CompilerVersion >= 29.0}
      // D22: Delphi XE8 and up
      {$DEFINE _D22UP_}
    {$IFEND}
    {$IF CompilerVersion >= 30.0}
      // D23: Delphi 10 Seattle and up
      {$DEFINE _D23UP_}
    {$IFEND}
    {$IF CompilerVersion >= 31.0}
      // D24: Delphi 10.1 Berlin and up
      {$DEFINE _D24UP_}
    {$IFEND}
    {$IF CompilerVersion >= 32.0}
      // D25: Delphi 10.2 Tokyo and up
      {$DEFINE _D25UP_}
    {$IFEND}
    {$IF CompilerVersion >= 33.0}
      // D26: Delphi 10.3 Rio and up
      {$DEFINE _D26UP_}
    {$IFEND}
    {$IF CompilerVersion >= 34.0}
      // D27: Delphi 10.4 Sydney and up
      {$DEFINE _D27UP_}
    {$IFEND}
    {$IF CompilerVersion >= 35.0}
      // D28: Delphi 11 Alexandria and up
      {$DEFINE _D28UP_}
    {$IFEND}
    {$IF CompilerVersion >= 36.0}
      // D29: Delphi 12 Athens and up
      {$DEFINE _D29UP_}
    {$IFEND}
    {$IF CompilerVersion >= 37.0}
      // D37: Delphi 13 Florence and up
      {$DEFINE _D37UP_}
    {$IFEND}

  {$IFEND} // of: $IF Declared(CompilerVersion)
{$ELSE}  // of: $IFDEF CONDITIONALEXPRESSIONS
  {$MESSAGE ERROR 'Compiler must be one of the following, or higher: Delphi 6; C++ Builder 6; Kylix 1'}
{$ENDIF}

//
// Platform defines
//

{$IFNDEF _D16UP_} // XE2
  {$DEFINE CPUX86}
  {$IFNDEF LINUX}{$IFNDEF MACOS}
    {/$DEFINE WIN32}
    {/$DEFINE WINDOWS}
    {$DEFINE MSWINDOWS}
  {$ENDIF}{$ENDIF}
  {$IFDEF LINUX}
    {$DEFINE _KYLIX_}
    {.$UNDEF POSIX}
    {$DEFINE POSIX}
  {$ENDIF}
{$ENDIF}

{$DEFINE _STDCALL_} // (stdcall, cdecl): dbx interface and callback call
{$IFDEF _D16UP_} // XE2
  {$IFDEF POSIX}
    {$UNDEF _STDCALL_}
  {$ENDIF}
{$ENDIF}

{$UNDEF PUREPASCAL}
{$IFNDEF CPUX86}
  {$DEFINE PUREPASCAL}
{$ENDIF}

//
// Compiler extensions
//

{$UNDEF _INLINE_}
{$IFDEF _D9UP_}
  {$DEFINE _INLINE_} // optional
{$ENDIF}

//
// Compiler options
//

// Desirable Compiler options
{$B-} // Full boolean eval off (i.e. Short-cicuit boolean eval)

//
// DBXOODBC
//

{$UNDEF DynamicOdbcImport}
{$DEFINE DynamicOdbcImport} // optional: It allows to use odbc libraries directly, passing odbc manager.

{$UNDEF UnloadApiCache}
{$IFDEF DynamicOdbcImport}
  {$DEFINE UnloadApiCache} // optional: allow reload odbc api library
{$ENDIF}

{$UNDEF _iOdbcApi_} // IOdbcApi Interface
{$DEFINE _iOdbcApi_} // optional: OdbcApi.pas implemented IOdbcApi interface.

{$UNDEF _DBX30_} // DBX 3.0
{.$IFDEF _D10UP_}
  {$DEFINE _DBX30_}  // optional
{.$ENDIF}

{$UNDEF _DBX40_} // DBX 4.0
//{$IFDEF _D11UP_}
//// todo:
//  {.$DEFINE _DBX40_}  // optional
//{$ENDIF}

{$UNDEF _DBXCB_} // DBX Callback
{$DEFINE _DBXCB_} // optional: callback support

//
// MEMORY
//

{$UNDEF _FASTMM_}
{$IFDEF CPUX86} { FastMM only for win32 }
//  {$IFNDEF _D15UP_}
    {.$DEFINE _FASTMM_} // optional
    {$IFDEF _D9UP_}
      {.$UNDEF _FASTMM_} // optional
    {$ENDIF}
//  {$ENDIF}
{$ENDIF}

{$ENDIF !DBXOPENODBC_INC}
