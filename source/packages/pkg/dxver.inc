{ "dxver.inc": }
{------------------------------------------------------------------------------}
{$IFNDEF DXVER_INC}
{$DEFINE DXVER_INC}
//
{$IFNDEF FPC}
//
{$ifdef VER370} { ------------------------- Delphi 13 Florence (37) or higher }
  {$define _d37_}
  {$define _d2026_}
  {$define _dFlorence_}
  {$define _d37up_}
  {$define _d2026up_}
  {$define _dFlorenceup_}
{$else  !VER370}
{$ifdef VER360} { ------------------------- Delphi 12 Athens (29) or higher }
  {$define _d29_}
  {$define _d2023_}
  {$define _dAthens_}
  {$define _d29up_}
  {$define _d2023up_}
  {$define _dAthensup_}
{$else  !VER360}
{$ifdef VER350} { ------------------------- Delphi 11 Alexandria (28) or higher }
  {$define _d28_}
  {$define _d2021_}
  {$define _dAlexandria_}
  {$define _d28up_}
  {$define _d2021up_}
  {$define _dAlexandriaup_}
{$else  !VER350}
{$ifdef VER340} { ------------------------- Delphi 10.4 Sydney (27) or higher }
  {$define _d27_}
  {$define _d2020_}
  {$define _dSydney_}
  {$define _d27up_}
  {$define _d2020up_}
  {$define _dSydneyup_}
{$else  !VER340}
{$ifdef VER330} { ------------------------- Delphi 10.3 Rio (26) or higher }
  {$define _d26_}
  {$define _d2018_}
  {$define _dRio_}
  {$define _d26up_}
  {$define _d2018up_}
  {$define _dRioup_}
{$else  !VER330}
	{$ifdef VER320} { ------------------------- Delphi 10.2 Tokyo (25) or higher }
	  {$define _d25_}
	  {$define _d2017_}
	  {$define _dTokyo_}
	  {$define _d25up_}
	  {$define _d2017up_}
	  {$define _dTokyoup_}
	{$else  !VER320}
		{$ifdef VER310} { ------------------------- Delphi 10.1 Berlin (24) or higher }
		  {$define _d24_}
		  {$define _d2016_}
		  {$define _dBerlin_}
		  {$define _d24up_}
		  {$define _d2016up_}
		  {$define _dBerlinup_}
		{$else  !VER310}
		{$ifdef VER300} { ------------------------- Delphi 10 Seattle (23) or higher }
		  {$define _d23_}
		  {$define _d2015_}
		  {$define _dSeattle_}
		  {$define _d23up_}
		  {$define _d2015up_}
		  {$define _dSeattleup_}
		{$else  !VER300}
		{$ifdef VER290} { ------------------------- Delphi XE8 (22) or higher }
		  {$define _d22_}
		  {$define _d2015_}
		  {$define _dxe8_}
		  {$define _d22up_}
		  {$define _d2015up_}
		  {$define _dxe8up_}
		{$else  !VER290}
		{$ifdef VER280} { ------------------------- Delphi XE7 (21) or higher }
		  {$define _d21_}
		  {$define _d2014_}
		  {$define _dxe7_}
		  {$define _d21up_}
		  {$define _d2014up_}
		  {$define _dxe7up_}
		{$else  !VER280}
		{$ifdef VER270} { ------------------------- Delphi XE6 (20) or higher }
		  {$define _d20_}
		  {$define _d2014_}
		  {$define _dxe6_}
		  {$define _d20up_}
		  {$define _d2014up_}
		  {$define _dxe6up_}
		{$else  !VER270}
		{$ifdef VER260} { ------------------------- Delphi XE5 (19) or higher }
		  {$define _d19_}
		  {$define _d2013_}
		  {$define _dxe5_}
		  {$define _d19up_}
		  {$define _d2013up_}
		  {$define _dxe5up_}
		{$else  !VER260}
		{$ifdef VER250} { ------------------------- Delphi XE4 (18) or higher }
		  {$define _d18_}
		  {$define _d2013_}
		  {$define _dxe4_}
		  {$define _d18up_}
		  {$define _d2013up_}
		  {$define _dxe4up_}
		{$else  !VER250}
		{$ifdef VER240} { ------------------------- Delphi XE3 (17) or higher }
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
		{$endif !VER250}
		{$endif !VER260}
		{$endif !VER270}
		{$endif !VER280}
		{$endif !VER290}
		{$endif !VER300}
		{$endif !VER310}
		{$endif !VER320}
		{$endif !VER330}
		{$endif !VER340}
		{$endif !VER350}
		{$endif !VER360}
{$endif !VER370}
//
{$ELSE   FPC}
  ERR_FPC_COMPILER_NOT_SUPPORTED
{$ENDIF  FPC}
{------------------------------------------------------------------------------}
{$ifdef _d37up_}
  {$define _d2026up_}
  {$define _dFlorenceup_}
  {$define _d29up_}
{$endif}
{$ifdef _d29up_}
  {$define _d2023up_}
  {$define _dAthensup_}
  {$define _d28up_}
{$endif}
{$ifdef _d28up_}
  {$define _d2021up_}
  {$define _dAlexandriaup_}
  {$define _d27up_}
{$endif}
{$ifdef _d27up_}
  {$define _d2020up_}
  {$define _dSydneyup_}
  {$define _d26up_}
{$endif}
{$ifdef _d26up_}
  {$define _d2018up_}
  {$define _dRioup_}
  {$define _d25up_}
{$endif}
{$ifdef _d25up_}
  {$define _d2017up_}
  {$define _dTokyoup_}
  {$define _d24up_}
{$endif}
{$ifdef _d24up_}
  {$define _d2016up_}
  {$define _dBerlinup_}
  {$define _d23up_}
{$endif}
{$ifdef _d23up_}
  {$define _d2015up_}
  {$define _dSeattleup_}
  {$define _d22up_}
{$endif}
{$ifdef _d22up_}
  {$define _d2015up_}
  {$define _dxe8up_}
  {$define _d21up_}
{$endif}
{$ifdef _d21up_}
  {$define _d2014up_}
  {$define _dxe7up_}
  {$define _d20up_}
{$endif}
{$ifdef _d20up_}
  {$define _d2014up_}
  {$define _dxe6up_}
  {$define _d19up_}
{$endif}
{$ifdef _d19up_}
  {$define _d2013up_}
  {$define _dxe5up_}
  {$define _d18up_}
{$endif}
{$ifdef _d18up_}
  {$define _d2013up_}
  {$define _dxe4up_}
  {$define _d17up_}
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
