{************************************************}
{                                                }
{               EurekaLog v 4.5                  }
{                 Include file                   }
{                                                }
{  Copyright (c) 2001 - 2003 by Fabio Dell'Aria  }
{                                                }
{************************************************}

//{$DEFINE EUREKALOG_DEMO}
{$DEFINE PROFESSIONAL}// Comment only for Standard version.

{$R-}// Disable Range-Checks.
{$Q-}// Disable Overflow-Checks.
{$W-}// Disable Stack-Frames generation.
{$B-}// Disable Complete-Boolean evaluation.
{$T-}// Disable Typed-Pointer generation.
{$U-}// Disable Safe-Divide generation.
{$J-}// Disable Assignable-Typed-Constant.
{$O+}// Activate Optimization.
{.$O-}
{$A+}// Activate Record-Field-Alignment.
{$X+}// Activate Extended-Syntax.
{$V+}// Activate Strict-Var-Strings.
{$P+}// Activate Open-Parameters.
{$H+}// Activate Huge-Strings.
{$C+}// Activate Assertions.
{$Z1}// Set MinEnumSize=1 byte.
{$D-}// Disable Debug-Infos generation (comment it ONLY for debug).
{.$D+,L+}

// Delphi DEFINE directives...

  // Clean up all usage directives:
    {$UNDEF Delphi3Up}
    {$UNDEF Delphi4Up}
    {$UNDEF Delphi5Up}
    {$UNDEF Delphi6Up}
    {$UNDEF Delphi7Up}
    {$UNDEF Delphi9Up}
    {$UNDEF Delphi10Up}
    {$UNDEF Delphi11Up}
    {$UNDEF Delphi3}
    {$UNDEF Delphi4}
    {$UNDEF Delphi5}
    {$UNDEF Delphi6}
    {$UNDEF Delphi7}
    {$UNDEF Delphi9}
    {$UNDEF Delphi10}
    {$UNDEF Delphi11}
    {$UNDEF Delphi12}
    {$UNDEF Delphi3Down}
    {$UNDEF Delphi4Down}
    {$UNDEF Delphi5Down}
    {$UNDEF Delphi6Down}
    {$UNDEF Delphi7Down}
    {$UNDEF Delphi9Down}
    {$UNDEF Delphi10Down}
    {$UNDEF Delphi11Down}
    {$UNDEF Delphi12Down}
    {$UNDEF Delphi14Down}
    {$UNDEF Delphi15Down}
    {$UNDEF Delphi16Down}
    {$UNDEF CBuilder}
    {$ObjExportAll Off}

// Experimental...
{$IFDEF VER125}// C++ Builder 4.0
  {$DEFINE VER120}// Simulate Delphi 4
{$ENDIF}

{$IFDEF VER100}// Delphi 3.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi3}
  {$DEFINE Delphi3Down}
  {$DEFINE Delphi4Down}
  {$DEFINE Delphi5Down}
  {$DEFINE Delphi6Down}
  {$DEFINE Delphi7Down}
{$ENDIF}

{$IFDEF VER120}// Delphi 4.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi4}
  {$DEFINE Delphi4Down}
  {$DEFINE Delphi5Down}
  {$DEFINE Delphi6Down}
  {$DEFINE Delphi7Down}
{$ENDIF}

{$IFDEF VER130}// Delphi 5.0 -CBuilder 5
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi5}
  {$DEFINE Delphi5Down}
  {$DEFINE Delphi6Down}
  {$DEFINE Delphi7Down}
{$ENDIF}

{$IFDEF VER140}// Delphi 6.0 - CBuilder 6
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi6}
  {$DEFINE Delphi6Down}
  {$DEFINE Delphi7Down}
{$ENDIF}

{$IFDEF VER150}// Delphi 7.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi7}
  {$DEFINE Delphi7Down}
{$ENDIF}

{$IFDEF VER170}// Delphi 9.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi9}
  {$DEFINE Delphi9Down}
{$ENDIF}

{$IFDEF VER180}// Delphi 10.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi10}
  {$DEFINE Delphi10Down}
{$ENDIF}

{$IFDEF VER185}// Delphi 11.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi11Up}
  {$DEFINE Delphi11}
  {$DEFINE Delphi11Down}
{$ENDIF}

{$IFDEF VER200}// Delphi 12.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi11Up}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi12Down}
{$ENDIF}

{$IFDEF VER210}// Delphi 14.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi11Up}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi14Down}
{$ENDIF}

{$IFDEF VER220}// Delphi 15.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi11Up}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi15Down}
{$ENDIF}

{$IFDEF VER230}// Delphi 16.0
  {$DEFINE Delphi3Up}
  {$DEFINE Delphi4Up}
  {$DEFINE Delphi5Up}
  {$DEFINE Delphi6Up}
  {$DEFINE Delphi7Up}
  {$DEFINE Delphi9Up}
  {$DEFINE Delphi10Up}
  {$DEFINE Delphi11Up}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi16Down}
{$ENDIF}

{$IFNDEF Delphi16Down}
  {$IFNDEF LINUX}
    {$DEFINE WIN32}
  {$ENDIF}
{$ENDIF}

// Disable "Special" Warnings Messages...

{$IFDEF Delphi6Up}
  {$WARN SYMBOL_PLATFORM OFF}// Disable General Platform Warning Messages.
  {$WARN UNIT_PLATFORM OFF}//   Disable Unit Platform Warning Messages.
  {$WARN UNIT_DEPRECATED OFF}// Disable Unit Deprecated Warning Messages.
  {$WARN SYMBOL_DEPRECATED OFF}// Disable Symbol Deprecated Warning Messages.
  {$IFDEF Delphi7Up}
    {$WARN UNSAFE_CODE OFF}// Disable Unsafe Code Warning Messages.
    {$WARN UNSAFE_TYPE OFF}// Disable Unsafe Type Warning Messages.
    {$WARN UNSAFE_CAST OFF}// Disable Unsafe TypeCast Warning Messages.
  {$ENDIF}
{$ENDIF}

{$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
{$ENDIF}
