{$IFNDEF _EMBEDDED_}
  {$IFNDEF _TRACE_CALLS_}
    {$DESCRIPTION 'Dbx OpenOdbc Driver Loader [#v1.#y.#m.#d]'}
  {$ELSE}
    {$DESCRIPTION 'Dbx OpenOdbc Driver Loader [#v1.#y.#m.#d] ( calls tracking )'}
  {$ENDIF}
{$ELSE}
  {$IFNDEF _TRACE_CALLS_}
    {$DESCRIPTION 'Dbx OpenOdbc Driver Loader [#v1.#y.#m.#d] ( embedded )'}
  {$ELSE}
    {$DESCRIPTION 'Dbx OpenOdbc Driver Loader [#v1.#y.#m.#d] ( embedded, calls tracking )'}
  {$ENDIF}
{$ENDIF}
