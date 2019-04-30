{ OdbcExplorDefines.inc }

{$D+,L+,B-,O-}

{.$DEFINE _DEBUG_}
{.$UNDEF _DEBUG_}

// DbxStaticLink
// Linking dbxoodbc driver statically.
{$define DbxStaticLink}

// _HexEditor_
// [http://www.torry.net/vcl/edits/diffedits/msthexedit.zip]
// [http://www.mirkes.de/en/delphi/vcls/hexedit.php]
// limitation: need create temporary file for binary data
{$define _HexEditor_}

// _SynEdit_
// [http://synedit.sourceforge.net]
// TODO: contained bug: not saved text to dataset
{$define _SynEdit_}

// _GraphicEx_
// Allow view many image formats.
// [http://www.delphi-gems.com/Graphics.php]
// Need change file "GraphicConfiguration.inc": need
//       enable: $define UseLZW for support GIF image format.
{$define _GraphicEx_}

// _kbm_compress_
// added convertion Binary field to "Compressed + Base64" field.
//   It enables to keep blob the data in chars fields (SQLite).
{.$define _kbm_compress_}

{$define _XPMan_} { AV information:

  D7, D9 - AV when closing app and connection is On.

  After move code from method TFormOdbcExplor.FormDestroy to
  method TFormOdbcExplor.FormClose - all work is fine !!!

  It bug is depend from use unit XPMan !!! After remove it unit not need
  to moving code ...
}

{$UNDEF _XPMENU_}
{.$DEFINE _XPMENU_}

{.$UNDEF  _CHECK_LEAKS_}
{.$DEFINE  _CHECK_LEAKS_} // nedd copy FastMM4Options.dbg.inc into FastMM4Options.inc

// _DBX_FIXES_
// Delphi Fixes for "procedure TCustomSQLDataSet.SetSchemaOption" in module "SqlExpr.pas";
// Access for limits of the buffer (damage of a code).

//{$define _DBX_FIXES_} // if use SqlExprFix.pas
