{ pkg_sufix_calc.inc }

{$IFNDEF _EMBEDDED_}
  {$IFNDEF _TRACE_CALLS_}
    {$i pkg_sufix.inc}
  {$ELSE}
    {$i pkg_sufix_dbg_tr.inc}
  {$ENDIF}
{$ELSE}
  {$IFNDEF _TRACE_CALLS_}
    {$i pkg_sufix_emb.inc}
  {$ELSE}
    {$i pkg_sufix_dbg_emb_tr.inc}
  {$ENDIF}
{$ENDIF}
