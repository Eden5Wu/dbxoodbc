{$IFNDEF FASTMM4OPTIONS_INC}
{$DEFINE FASTMM4OPTIONS_INC}

{$INCLUDE DbxOpenOdbc_options.inc}

{$IFDEF _RELEASE_}
      {$INCLUDE FastMM4Options.rel.inc}
{$ELSE}
  {$IFDEF _MEMCHECK_}
      {$INCLUDE FastMM4Options.dbg.inc}
  {$ELSE}
    {$IFDEF _DEBUG_}
      {$INCLUDE FastMM4Options.dbg.inc}
    {$ELSE}
      {$INCLUDE FastMM4Options.rel.inc}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$ENDIF FASTMM4OPTIONS_INC}
