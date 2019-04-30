{ pkg_name_calc.inc }

{$IFNDEF _EMBEDDED_}
  {$IFNDEF _TRACE_CALLS_}
    dbxoodbc
  {$ELSE}
    dbxoodbc_dbg_tr
  {$ENDIF}
{$ELSE}
  {$IFNDEF _TRACE_CALLS_}
    dbxoodbc_emb
  {$ELSE}
    dbxoodbc_dbg_emb_tr
  {$ENDIF}
{$ENDIF}
