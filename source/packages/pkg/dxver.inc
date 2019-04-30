{ "dxver.inc": }
{------------------------------------------------------------------------------}
{$IFNDEF DXVER_INC}
{$DEFINE DXVER_INC}
//
{$IFNDEF FPC}
//
{$ifdef VER330} { ------------------------- RAD Studio 2017 Tokyo (25) or higher }
  {$define _d26_}
  {$define _d2018_}
  {$define _dRio_}
  {$define _d26up_}
  {$define _d2018up_}
  {$define _dRioup_}
{$else  !VER260}
	{$ifdef VER320} { ------------------------- RAD Studio 2017 Tokyo (25) or higher }
	  {$define _d25_}
	  {$define _d2017_}
	  {$define _dTokyo_}
	  {$define _d25up_}
	  {$define _d2017up_}
	  {$define _dTokyoup_}
	{$else  !VER250}
		{$ifdef VER310} { ------------------------- RAD Studio 2016 Berlin (24) or higher }
		  {$define _d24_}
		  {$define _d2016_}
		  {$define _dBerlin_}
		  {$define _d24up_}
		  {$define _d2016up_}
		  {$define _dBerlinup_}
		{$else  !VER240}
		{$ifdef VER240} { ------------------------- RAD Studio 2013 XE3 (17) or higher }
		  {$define _d17_}
		  {$define _d2013_}
		  {$define _dxe3_}
		  {$define _d17up_}
		  {$define _d2013up_}
		  {$define _dxe3up_}
		{$else  !VER240}
		{$ifdef VER230} { ------------------------- RAD Studio 2012 XE2 (16) or higher }
		  {$define _d16_}
		  {$define _d2012_}
		  {$define _dxe2_}
		  {$define _d16up_}
		  {$define _d2012up_}
		  {$define _dxe2up_}
		{$else  !VER230}
		  {$ifdef VER220} { ----------------------- RAD Studio 2011 XE (15) or higher  }
			{$define _d15_}
			{$define _d2011_}
			{$define _dxe_}
			{$define _d15up_}
			{$define _d2011up_}
			{$define _dxeup_}
		  {$else  !VER220}
			{$ifdef VER210} { --------------------- RAD Studio 2010 (14) or higher     }
			  {$define _d14_}
			  {$define _d2010_}
			  {$define _d14up_}
			  {$define _d2010up_}
			{$else  !VER210}
			  {$ifdef VER200} { ------------------- RAD Studio 2009 (12) or higher     }
				{$define _d12_}
				{$define _d2009_}
				{$define _d12up_}
				{$define _d2009up_}
			  {$else  !VER200}
				{$ifdef VER185} { ----------------- RAD Studio 2007 (11) or higher     }
				  {$define _d11_}
				  {$define _d2007_}
				  {$define _d11up_}
				  {$define _d2007up_}
				{$else  !VER185}
				  {$ifdef VER180} { --------------- BDS 2006 (10) or higher            }
					{$define _d10_}
					{$define _d2006_}
					{$define _d10up_}
					{$define _d2006up_}
				  {$else  !VER180}
					{$ifdef VER170} { ------------- BDS 2005 (9) or higher             }
					  {$define _d9_}
					  {$define _d2005_}
					  {$define _d9up_}
					  {$define _d2005up_}
					{$else  !VER170}
					  {$ifdef VER150} { ----------- Delphi 7.0 or higher               }
						{$define _d7_}
						{$define _d7up_}
					  {$else  !VER150}
						{$ifdef VER145} { --------- Kylix 3.0 or higher                }
						  {$define _kylix_}
						  {$define _k3_}
						  {$define _k3up_}
						{$else  !VER145}
						  {$ifdef VER141} { ------- Kylix 2.0 or higher                }
							{$define _kylix_}
							{$define _k2_}
							{$define _k2up_}
						  {$else  !VER141}
							{$ifdef VER140} { ----- Delphi 6.0 or higher               }
							  {$define _d6_}
							  {$define _d6up_}
							{$else  !VER140}
							  {$IFDEF CONDITIONALEXPRESSIONS}
		  {$define _d16up_}
							  {$ELSE}
		  ERR_COMPILER_NOT_SUPPORTED
							  {$ENDIF}
							{$endif !VER140}
						  {$endif !VER141}
						{$endif !VER145}
					  {$endif !VER150}
					{$endif !VER170}
				  {$endif !VER180}
				{$endif !VER185}
			  {$endif !VER200}
			{$endif !VER210}
		  {$endif !VER220}
		{$endif !VER230}
		{$endif !VER240}
		{$endif !VER310}
	{$endif !VER320}
{$endif !VER330}
//
{$ELSE   FPC}
  ERR_FPC_COMPILER_NOT_SUPPORTED
{$ENDIF  FPC}
{------------------------------------------------------------------------------}
{$ifdef _d26up_}
  {$define _d2018up_}
  {$define _dRioup_}
  {$define _d26up_}
{$endif}
{$ifdef _d25up_}
  {$define _d2017up_}
  {$define _dTokyoup_}
  {$define _d25up_}
{$endif}
{$ifdef _d24up_}
  {$define _d2016up_}
  {$define _dBerlinup_}
  {$define _d24up_}
{$endif}
{$ifdef _d17up_}
  {$define _d2013up_}
  {$define _dxe3up_}
  {$define _d16up_}
{$endif}
{$ifdef _d16up_}
  {$define _d2012up_}
  {$define _dxe2up_}
  {$define _d15up_}
{$endif}
{$ifdef _d15up_}
  {$define _d2011up_}
  {$define _dxeup_}
  {$define _d14up_}
{$endif}
{$ifdef _d14up_}
  {$define _d2010up_}
  {$define _d12up_}
{$endif}
{$ifdef _d12up_}
  {$define _d2009up_}
  {$define _d11up_}
{$endif}
{$ifdef _d11up_}
  {$define _d2007up_}
  {$define _d10up_}
{$endif}
{$ifdef _d10up_}
  {$define _d2006up_}
  {$define _d9up_}
{$endif}
{$ifdef _d9up_}
  {$define _d2005up_}
  {$define _d7up_}
{$endif}
{$ifdef _d7up_}
  {$define _k2up_}
{$endif}
{$ifdef _k2up_}
  {$define _k1up_}
{$endif}
{$ifdef _k1up_}
  {$define _d6up_}
{$endif}
{------------------------------------------------------------------------------}
{$ifdef _d16up_}
  //
  //
{$else !_d16up_}
  //
  {$define CPUX86}
  //
  {$ifdef LINUX}
    {$define _KYLIX_}
  {$else     MSWINDOWS}
    {$define MSWINDOWS}
    {$define WIN32}
  {$endif  MSWINDOWS}
  //
{$endif !_d16up_}
//
{$ENDIF DXVER_INC}
{------------------------------------------------------------------------------}
{ "dxver.inc". }
