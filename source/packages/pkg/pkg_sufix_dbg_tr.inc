{ "pkg_sufix.inc: }
{------------------------------------------------------------------------------}

{$IFDEF CONDITIONALEXPRESSIONS}
{$IFDEF VER370} { ------------------------- Delphi 13 Florence (37) or higher }
  {$LIBSUFFIX '370_dbg_tr'}
{$ELSE}
{$IFDEF VER360} { ------------------------- Delphi 12 Athens (29) or higher }
  {$LIBSUFFIX '290_dbg_tr'}
{$ELSE}
{$IFDEF VER350} { ------------------------- Delphi 11 Alexandria (28) or higher }
  {$LIBSUFFIX '280_dbg_tr'}
{$ELSE}
{$IFDEF VER340} { ------------------------- Delphi 10.4 Sydney (27) or higher }
  {$LIBSUFFIX '270_dbg_tr'}
{$ELSE}
{$IFDEF VER330} { ------------------------- RAD Studio 2018 Rio (26) or higher }
  {.$LIBSUFFIX '2018Rio(330)[26]'}
  {$LIBSUFFIX '260_dbg_tr'}
{$ELSE}
	{$IFDEF VER320} { ------------------------- RAD Studio 2017 Tokyo (25) or higher }
	  {.$LIBSUFFIX '2017Tokyo(320)[25]'}
	  {$LIBSUFFIX '250_dbg_tr'}
	{$ELSE}
		{$IFDEF VER310} { ------------------------- RAD Studio 2016 Berlin (24) or higher }
		  {.$LIBSUFFIX '2016Berlin(310)[24]'}
		  {$LIBSUFFIX '240_dbg_tr'}
		{$ELSE}
		{$IFDEF VER300} { ------------------------- Delphi 10 Seattle (23) or higher }
		  {$LIBSUFFIX '230_dbg_tr'}
		{$ELSE}
		{$IFDEF VER290} { ------------------------- Delphi XE8 (22) or higher }
		  {$LIBSUFFIX '220_dbg_tr'}
		{$ELSE}
		{$IFDEF VER280} { ------------------------- Delphi XE7 (21) or higher }
		  {$LIBSUFFIX '210_dbg_tr'}
		{$ELSE}
		{$IFDEF VER270} { ------------------------- Delphi XE6 (20) or higher }
		  {$LIBSUFFIX '200_dbg_tr'}
		{$ELSE}
		{$IFDEF VER260} { ------------------------- Delphi XE5 (19) or higher }
		  {$LIBSUFFIX '190_dbg_tr'}
		{$ELSE}
		{$IFDEF VER250} { ------------------------- Delphi XE4 (18) or higher }
		  {$LIBSUFFIX '180_dbg_tr'}
		{$ELSE}
			{$IFDEF VER240} { ------------------------- RAD Studio 201? XE3 (17) or higher }
			  {.$LIBSUFFIX '201?xe3(240)[17]'}
			  {$LIBSUFFIX '170_dbg_tr'}
			{$ELSE}
				{$IFDEF VER230} { ------------------------- RAD Studio 2012 XE2 (16) or higher }
				  {.$LIBSUFFIX '2012xe2(230)[16]'}
				  {$LIBSUFFIX '160_dbg_tr'}
				{$ELSE}
				  {$IFDEF VER220} { ----------------------- RAD Studio 2011 XE (15) or higher  }
					{.$LIBSUFFIX '2011xe(220)[15]'}
					{$LIBSUFFIX '150_dbg_tr'}
				  {$ELSE}
					{$IFDEF VER210} { --------------------- RAD Studio 2010 (14) or higher     }
					  {.$LIBSUFFIX '2010(210)[14]'}
					  {$LIBSUFFIX '140_dbg_tr'}
					{$ELSE}
					  {$IFDEF VER200} { ------------------- RAD Studio 2009 (12) or higher     }
						{.$LIBSUFFIX '2009(200)[12]'}
						{$LIBSUFFIX '120_dbg_tr'}
					  {$ELSE}
						{$IFDEF VER185} { ----------------- RAD Studio 2007 (11) or higher     }
						  {.$LIBSUFFIX '2007(185)[11]'}
						  {$LIBSUFFIX '110_dbg_tr'}
						{$ELSE}
						  {$IFDEF VER180} { --------------- BDS 2006 (10) or higher            }
							{.$LIBSUFFIX '2006(180)[10]'}
							{$LIBSUFFIX '100_dbg_tr'}
						  {$ELSE}
							{$IFDEF VER170} { ------------- BDS 2005 (9) or higher             }
							  {.$LIBSUFFIX '2005(170)[9]'}
							  {$LIBSUFFIX '90_dbg_tr'}
							{$ELSE}
							  {$IFDEF VER150} { ----------- Delphi 7.0 or higher               }
								{.$LIBSUFFIX '7(150)[7]'}
								{$LIBSUFFIX '70_dbg_tr'}
							  {$ELSE}
								{$IFDEF VER145} { --------- Kylix 3.0 or higher                }
								  {.$LIBSUFFIX 'K3(145)[7]'}
								  {$LIBSUFFIX 'k3_dbg_tr'}
								{$ELSE}
								  {$IFDEF VER141} { ------- Kylix 2.0 or higher                }
									{.$LIBSUFFIX 'K2(141)[6]'}
									{$LIBSUFFIX 'k2_dbg_tr'}
								  {$ELSE}
									{$IFDEF VER140} { ----- Delphi 6.0 or higher               }
									  {.$LIBSUFFIX '6(140)[6]'}
									  {$LIBSUFFIX '60_dbg_tr'}
									{$ELSE}
									  {$LIBSUFFIX 'x_dbg_tr'}
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
	{$ENDIF}
	{$ENDIF}
{$ENDIF}
{$ELSE}
  ERR_COMPILER_NOT_SUPPORTED
{$ENDIF CONDITIONALEXPRESSIONS}

{------------------------------------------------------------------------------}
{ "pkg_sufix.inc. }
