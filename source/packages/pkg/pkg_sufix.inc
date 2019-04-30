{ "pkg_sufix.inc: }
{------------------------------------------------------------------------------}

{$IFDEF CONDITIONALEXPRESSIONS}
{$IFDEF VER330} { ------------------------- RAD Studio 2018 RIO (26) or higher }
  {.$LIBSUFFIX '2018Rio(330)[26]'}
  {$LIBSUFFIX '260'}
{$ELSE}
	{$IFDEF VER320} { ------------------------- RAD Studio 2017 Tokyo (25) or higher }
	  {.$LIBSUFFIX '2017Tokyo(320)[25]'}
	  {$LIBSUFFIX '250'}
	{$ELSE}
		{$IFDEF VER310} { ------------------------- RAD Studio 2016 Berlin (24) or higher }
		  {.$LIBSUFFIX '2016Berlin(310)[24]'}
		  {$LIBSUFFIX '240'}
		{$ELSE}
			{$IFDEF VER240} { ------------------------- RAD Studio 201? XE3 (17) or higher }
			  {.$LIBSUFFIX '201?xe3(240)[17]'}
			  {$LIBSUFFIX '170'}
			{$ELSE}
				{$IFDEF VER230} { ------------------------- RAD Studio 2012 XE2 (16) or higher }
				  {.$LIBSUFFIX '2012xe2(230)[16]'}
				  {$LIBSUFFIX '160'}
				{$ELSE}
				  {$IFDEF VER220} { ----------------------- RAD Studio 2011 XE (15) or higher  }
					{.$LIBSUFFIX '2011xe(220)[15]'}
					{$LIBSUFFIX '150'}
				  {$ELSE}
					{$IFDEF VER210} { --------------------- RAD Studio 2010 (14) or higher     }
					  {.$LIBSUFFIX '2010(210)[14]'}
					  {$LIBSUFFIX '140'}
					{$ELSE}
					  {$IFDEF VER200} { ------------------- RAD Studio 2009 (12) or higher     }
						{.$LIBSUFFIX '2009(200)[12]'}
						{$LIBSUFFIX '120'}
					  {$ELSE}
						{$IFDEF VER185} { ----------------- RAD Studio 2007 (11) or higher     }
						  {.$LIBSUFFIX '2007(185)[11]'}
						  {$LIBSUFFIX '110'}
						{$ELSE}
						  {$IFDEF VER180} { --------------- BDS 2006 (10) or higher            }
							{.$LIBSUFFIX '2006(180)[10]'}
							{$LIBSUFFIX '100'}
						  {$ELSE}
							{$IFDEF VER170} { ------------- BDS 2005 (9) or higher             }
							  {.$LIBSUFFIX '2005(170)[9]'}
							  {$LIBSUFFIX '90'}
							{$ELSE}
							  {$IFDEF VER150} { ----------- Delphi 7.0 or higher               }
								{.$LIBSUFFIX '7(150)[7]'}
								{$LIBSUFFIX '70'}
							  {$ELSE}
								{$IFDEF VER145} { --------- Kylix 3.0 or higher                }
								  {.$LIBSUFFIX 'K3(145)[7]'}
								  {$LIBSUFFIX 'k3'}
								{$ELSE}
								  {$IFDEF VER141} { ------- Kylix 2.0 or higher                }
									{.$LIBSUFFIX 'K2(141)[6]'}
									{$LIBSUFFIX 'k2'}
								  {$ELSE}
									{$IFDEF VER140} { ----- Delphi 6.0 or higher               }
									  {.$LIBSUFFIX '6(140)[6]'}
									  {$LIBSUFFIX '60'}
									{$ELSE}
									  {.$LIBSUFFIX 'x'}
									  ERR_COMPILER_UNKNOWN_PACKAGE_SUFIX
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
