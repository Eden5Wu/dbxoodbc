{ "pkg_sufix.inc: }
{------------------------------------------------------------------------------}

{$IFDEF CONDITIONALEXPRESSIONS}
{$IFDEF VER230} { ------------------------- RAD Studio 2012 XE2 (16) or higher }
  {.$LIBSUFFIX '2012xe2(230)[16]'}
  {$LIBSUFFIX '160'}
{$ELSE}
  {$IFDEF VER220} { ----------------------- RAD Studio 2011 XE (15) or higher }
    {.$LIBSUFFIX '2011xe(220)[15]'}
    {$LIBSUFFIX '150'}
  {$ELSE}
    {$IFDEF VER210} { --------------------- RAD Studio 2010 (14) or higher }
      {.$LIBSUFFIX '2010(210)[14]'}
      {$LIBSUFFIX '140'}
    {$ELSE}
      {$IFDEF VER200} { ------------------- RAD Studio 2009 (12) or higher }
        {.$LIBSUFFIX '2009(200)[12]'}
        {$LIBSUFFIX '120'}
      {$ELSE}
        {$IFDEF VER185} { ----------------- RAD Studio 2007 (11) or higher }
          {.$LIBSUFFIX '2007(185)[11]'}
          {$LIBSUFFIX '110'}
        {$ELSE}
          {$IFDEF VER180} { --------------- BDS 2006 (10) or higher }
            {.$LIBSUFFIX '2006(180)[10]'}
            {$LIBSUFFIX '100'}
          {$ELSE}
            {$IFDEF VER170} { ------------- BDS 2005 (9) or higher }
              {.$LIBSUFFIX '2005(170)[9]'}
              {$LIBSUFFIX '90'}
            {$ELSE}
              {$IFDEF VER150} { ----------- Delphi 7.0 or higher }
                {.$LIBSUFFIX '7(150)[7]'}
                {$LIBSUFFIX '70'}
              {$ELSE}
                {$IFDEF VER145} { --------- Kylix 3.0 or higher }
                  {.$LIBSUFFIX 'K3(145)[7]'}
                  {$LIBSUFFIX 'k2'}
                {$ELSE}
                  {$IFDEF VER141} { ------- Kylix 2.0 or higher }
                    {.$LIBSUFFIX 'K2(141)[6]'}
                    {$LIBSUFFIX 'k1'}
                  {$ELSE}
                    {$IFDEF VER140} { ----- Delphi 6.0 or higher }
                      {.$LIBSUFFIX '6(140)[6]'}
                      {$LIBSUFFIX '60'}
                    {$ELSE}
                      {$LIBSUFFIX 'x'}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$ELSE}
  ERR_COMPILER_NOT_SUPPORTED
{$ENDIF CONDITIONALEXPRESSIONS}

{------------------------------------------------------------------------------}
{ "pkg_sufix.inc. }
