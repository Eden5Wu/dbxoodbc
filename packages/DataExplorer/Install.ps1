<#
.SYNOPSIS
    Builds and installs (or uninstalls) the DBX4 Remastered Data Explorer package into RAD Studio.

.DESCRIPTION
    1. Locates RAD Studio IDE installations via pinned radstudio CLI (v1.0.4), Registry, or -BdsPath.
    2. Prompts user interactively if multiple RAD Studio versions coexist (supports -TargetVersion for CI).
    3. Automatically updates package DllSuffix in DbxOpenOdbcDataExplorer.dproj and DPK without static tables.
    4. Compiles DbxOpenOdbcDataExplorer<Suffix>.bpl via radstudio CLI (with automatic CE bds.exe fallback)
       or falls back to native command-line compilers (DCC/MSBuild).
    5. Backs up and safely updates RAD Studio's dbxdrivers.ini with DriverPackageLoader and MetaDataPackageLoader.
    6. Supports clean -Uninstall to remove DbxOpenOdbc entries.

.EXAMPLE
    .\Install.ps1
    .\Install.ps1 -TargetVersion "22.0"
    .\Install.ps1 -BdsPath "D:\RADStudio\22.0" -Verify
    .\Install.ps1 -Uninstall
#>
param(
    [string]$BdsPath = $env:BDS,
    [string]$TargetVersion = '',
    [string]$CliPath = '',
    [switch]$SkipCli,
    [string]$DbxIniDir = '',
    [ValidateSet('Win32', 'Win64', '')]
    [string]$Platform = '',
    [switch]$Verify,
    [switch]$IncludeSampleConnections,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

# Pinned Delphier/radstudio CLI v1.0.4 specification
$CLI_VERSION = '1.0.4'
$CLI_URL = 'https://github.com/Delphier/radstudio/releases/download/v1.0.4/radstudio-cli-1.0.4-x64.zip'
$CLI_ZIP_SHA256 = '4a5b165516b7f04b49f4570fa423458a224d941ce3fdb52fbd5cde7c36c09523'
$CLI_CACHE_DIR = Join-Path $env:LOCALAPPDATA 'dbxoodbc\tools\radstudio-1.0.4'

# ---------------------------------------------------------------------------
# Helper: Acquire and verify pinned Delphier/radstudio CLI
# ---------------------------------------------------------------------------
function Get-RadStudioCli {
    param(
        [string]$ExplicitPath,
        [switch]$DisableDownload
    )

    if ($DisableDownload) {
        Write-Host "[CLI] CLI disabled (-SkipCli); using native compiler toolchain." -ForegroundColor Cyan
        return $null
    }

    # 1. Check explicit path
    if ($ExplicitPath) {
        if (Test-Path -LiteralPath $ExplicitPath) {
            Write-Host "[CLI] Using explicitly specified CLI: $ExplicitPath" -ForegroundColor Cyan
            return (Resolve-Path -LiteralPath $ExplicitPath).Path
        }
        throw "Explicitly specified CLI path does not exist: $ExplicitPath"
    }

    # 2. Check local user cache
    $cachedExe = Join-Path $CLI_CACHE_DIR 'radstudio.exe'
    if (Test-Path -LiteralPath $cachedExe) {
        return $cachedExe
    }

    # 3. Check system PATH
    $cmd = Get-Command radstudio.exe -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "[CLI] Using system PATH CLI: $($cmd.Source)" -ForegroundColor Cyan
        return $cmd.Source
    }

    if ($DisableDownload) {
        Write-Host "[CLI] CLI download disabled; using native compiler fallback." -ForegroundColor Yellow
        return $null
    }

    # 4. Download pinned archive with SHA256 integrity verification
    Write-Host "[CLI] Downloading pinned radstudio CLI v$CLI_VERSION from official release..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $CLI_CACHE_DIR -Force | Out-Null

    $zipPath = Join-Path $CLI_CACHE_DIR "radstudio-cli-$CLI_VERSION-x64.zip"
    $tmpZipPath = Join-Path $CLI_CACHE_DIR "radstudio-cli-$CLI_VERSION-x64.zip.tmp"

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $CLI_URL -OutFile $tmpZipPath -UseBasicParsing -TimeoutSec 30

        # Validate ZIP SHA256 before extraction
        $actualHash = (Get-FileHash -LiteralPath $tmpZipPath -Algorithm SHA256).Hash.ToLower()
        if ($actualHash -ne $CLI_ZIP_SHA256.ToLower()) {
            Remove-Item -LiteralPath $tmpZipPath -Force -ErrorAction SilentlyContinue
            throw "SHA256 verification failed for downloaded CLI ZIP! Expected: $CLI_ZIP_SHA256, Actual: $actualHash"
        }

        # Atomic placement and extraction
        Move-Item -LiteralPath $tmpZipPath -Destination $zipPath -Force
        Expand-Archive -LiteralPath $zipPath -DestinationPath $CLI_CACHE_DIR -Force

        if (-not (Test-Path -LiteralPath $cachedExe)) {
            throw "Archive extraction completed but radstudio.exe was not found in: $CLI_CACHE_DIR"
        }

        Write-Host "[CLI] Successfully verified and cached radstudio CLI v$CLI_VERSION" -ForegroundColor Green
        return $cachedExe
    }
    catch {
        if (Test-Path -LiteralPath $tmpZipPath) {
            Remove-Item -LiteralPath $tmpZipPath -Force -ErrorAction SilentlyContinue
        }
        Write-Host "[WARN] Could not acquire pinned radstudio CLI ($($_.Exception.Message)). Falling back to native compilers." -ForegroundColor Yellow
        return $null
    }
}

# ---------------------------------------------------------------------------
# Helper: Detect installed RAD Studio environments
# ---------------------------------------------------------------------------
function Get-InstalledBdsEnvironments {
    param([string]$CliExecutable)

    $results = @()

    # Option A: Query via radstudio CLI if available
    if ($CliExecutable) {
        try {
            $jsonRaw = & $CliExecutable info --json 2>$null
            if ($LASTEXITCODE -eq 0 -and $jsonRaw) {
                $items = $jsonRaw | ConvertFrom-Json
                foreach ($item in $items) {
                    if ($item.root_dir -and (Test-Path -LiteralPath $item.root_dir)) {
                        $suffix = if ($item.package_version_number) { "$($item.package_version_number)" } else { '' }
                        if (-not $suffix -and $item.compiler_version) {
                            $cVer = [double]$item.compiler_version
                            $suffix = "$([int](($cVer - 7) * 10))"
                        }

                        $idePlat = if ($item.ide_platforms -contains 'Win64') { 'Win64' } else { 'Win32' }

                        $results += [PSCustomObject]@{
                            Source            = 'CLI'
                            Version           = "$($item.version)"
                            ProductVersion    = "$($item.product_version)"
                            Name              = "$($item.full_name)"
                            RootDir           = $item.root_dir.TrimEnd('\')
                            CompilerVersion   = "$($item.compiler_version)"
                            Suffix            = $suffix
                            IdePlatform       = $idePlat
                            SupportsCliBuild  = [bool]$item.supports_command_line_compilation
                        }
                    }
                }
                if ($results.Count -gt 0) { return $results }
            }
        } catch {
            Write-Host "[WARN] CLI query failed, falling back to Registry discovery." -ForegroundColor Yellow
        }
    }

    # Option B: Fallback to Windows Registry
    $hives = @('HKCU:\Software\Embarcadero\BDS', 'HKLM:\SOFTWARE\WOW6432Node\Embarcadero\BDS', 'HKLM:\SOFTWARE\Embarcadero\BDS')
    $seenRoots = @{}

    foreach ($hive in $hives) {
        if (-not (Test-Path -LiteralPath $hive)) { continue }
        Get-ChildItem -LiteralPath $hive -ErrorAction SilentlyContinue | ForEach-Object {
            $verKey = $_.PSChildName
            $regRoot = (Get-ItemProperty -LiteralPath $_.PSPath -Name 'RootDir' -ErrorAction SilentlyContinue).RootDir
            $regApp = (Get-ItemProperty -LiteralPath $_.PSPath -Name 'App' -ErrorAction SilentlyContinue).App

            if ($regRoot -and (Test-Path -LiteralPath $regRoot)) {
                $cleanRoot = $regRoot.TrimEnd('\')
                if ($seenRoots.ContainsKey($cleanRoot)) { return }
                $seenRoots[$cleanRoot] = $true

                # Calculate Suffix from BDS version: BDS 22.0 (D11) -> 280, BDS 23.0 (D12) -> 290
                $bdsNum = 0.0
                $suffix = ''
                if ([double]::TryParse($verKey, [ref]$bdsNum)) {
                    if ($bdsNum -ge 14.0) {
                        $suffix = "$([int](($bdsNum + 6) * 10))"
                    }
                }

                $dccPath = Join-Path $cleanRoot 'bin\dcc32.exe'
                $cVer = ''
                $canCli = $false
                if (Test-Path -LiteralPath $dccPath) {
                    $probe = & $dccPath --version 2>&1
                    $verOut = $probe | Select-String 'compiler version (\d+\.\d+)'
                    if ($verOut -and $verOut.Matches.Count -gt 0) {
                        $cVer = $verOut.Matches[0].Groups[1].Value
                        $suffix = "$([int](([double]$cVer - 7) * 10))"
                    }
                    $canCli = ($probe -notmatch 'does not support command line' -and $cVer -ne '')
                }

                $results += [PSCustomObject]@{
                    Source            = 'Registry'
                    Version           = $verKey
                    ProductVersion    = $verKey
                    Name              = "RAD Studio $verKey"
                    RootDir           = $cleanRoot
                    CompilerVersion   = $cVer
                    Suffix            = $suffix
                    IdePlatform       = 'Win32'
                    SupportsCliBuild  = $canCli
                }
            }
        }
    }

    return $results
}

# ---------------------------------------------------------------------------
# Helper: Synchronize project DllSuffix in DPROJ and DPK
# ---------------------------------------------------------------------------
function Sync-ProjectSuffix {
    param(
        [string]$ProjectDir,
        [string]$Suffix
    )

    $dprojPath = Join-Path $ProjectDir 'DbxOpenOdbcDataExplorer.dproj'
    $dpkPath = Join-Path $ProjectDir 'DbxOpenOdbcDataExplorer.dpk'

    if (-not (Test-Path -LiteralPath $dprojPath)) {
        throw "Project file missing: $dprojPath"
    }

    # 1. Update DllSuffix in DPROJ
    [xml]$dproj = Get-Content -LiteralPath $dprojPath -Raw
    $ns = [Xml.XmlNamespaceManager]::new($dproj.NameTable)
    $ns.AddNamespace('m', 'http://schemas.microsoft.com/developer/msbuild/2003')

    $suffixNode = $dproj.SelectSingleNode('//m:PropertyGroup/m:DllSuffix', $ns)
    if ($suffixNode) {
        $suffixNode.InnerText = $Suffix
    } else {
        $propGroup = $dproj.SelectSingleNode('//m:PropertyGroup[not(@Condition)]', $ns)
        $elem = $dproj.CreateElement('DllSuffix', 'http://schemas.microsoft.com/developer/msbuild/2003')
        $elem.InnerText = $Suffix
        $propGroup.AppendChild($elem)
    }
    $dproj.Save($dprojPath)

    # 2. Update LIBSUFFIX in DPK
    if (Test-Path -LiteralPath $dpkPath) {
        $dpkContent = Get-Content -LiteralPath $dpkPath -Raw
        $pattern = '(?i)\{\$LIBSUFFIX\s+''[^'']*''\}'
        $replacement = "{`$LIBSUFFIX '$Suffix'}"
        $newDpk = [regex]::Replace($dpkContent, $pattern, $replacement)
        $verifyPattern = '(?i)\{\$LIBSUFFIX\s+''' + [regex]::Escape($Suffix) + '''\}'
        if ($newDpk -notmatch $verifyPattern) {
            throw "Failed to update LIBSUFFIX to '$Suffix' in $dpkPath"
        }
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [IO.File]::WriteAllText($dpkPath, $newDpk, $utf8NoBom)
    }

    Write-Host "[PROJECT] Synchronized DllSuffix to '$Suffix' in DPROJ and DPK." -ForegroundColor Cyan
}

# ---------------------------------------------------------------------------
# Helper: Update or remove INI driver registration safely
# ---------------------------------------------------------------------------
function Set-IniDriverRegistration {
    param(
        [string]$IniFile,
        [string]$BplAbsolutePath,
        [bool]$RemoveOnly
    )

    $backupDir = Join-Path $PSScriptRoot 'build\ide-config-backup'
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupFile = Join-Path $backupDir ("dbxdrivers.$timestamp.ini")
    Copy-Item -LiteralPath $IniFile -Destination $backupFile -Force
    Write-Host "[INFO] Backed up dbxdrivers.ini to: $backupFile" -ForegroundColor Cyan

    $lines = [System.Collections.Generic.List[string]](Get-Content -LiteralPath $IniFile)
    $output = [System.Collections.Generic.List[string]]::new()

    $inInstalledDrivers = $false
    $installedDbxOpenOdbc = $false
    $installedOpenOdbc = $false
    $skipSection = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $trimmed = $line.Trim()

        if ($trimmed -match '^\[(.+)\]$') {
            $secName = $Matches[1]

            if ($inInstalledDrivers -and (-not $RemoveOnly)) {
                if (-not $installedDbxOpenOdbc) { $output.Add('DbxOpenOdbc=1') }
                if (-not $installedOpenOdbc) { $output.Add('OpenOdbc=1') }
            }

            $inInstalledDrivers = ($secName -ieq 'Installed Drivers')
            $skipSection = ($secName -ieq 'DbxOpenOdbc' -or $secName -ieq 'OpenOdbc')
            if ($skipSection) { continue }
            $output.Add($line)
            continue
        }

        if ($skipSection) { continue }

        if ($inInstalledDrivers) {
            if ($trimmed -match '(?i)^DbxOpenOdbc\s*=') {
                $installedDbxOpenOdbc = $true
                if ($RemoveOnly) { continue }
                $output.Add('DbxOpenOdbc=1')
                continue
            }
            if ($trimmed -match '(?i)^OpenOdbc\s*=') {
                $installedOpenOdbc = $true
                if ($RemoveOnly) { continue }
                $output.Add('OpenOdbc=1')
                continue
            }
        }

        $output.Add($line)
    }

    if ($inInstalledDrivers -and (-not $RemoveOnly)) {
        if (-not $installedDbxOpenOdbc) { $output.Add('DbxOpenOdbc=1') }
        if (-not $installedOpenOdbc) { $output.Add('OpenOdbc=1') }
    }

    if (-not $RemoveOnly) {
        if ($output.Count -gt 0 -and $output[$output.Count - 1].Trim() -ne '') {
            $output.Add('')
        }
        $output.Add('[DbxOpenOdbc]')
        $output.Add('DriverUnit=DbxOpenOdbcDriver')
        $output.Add("DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative,$BplAbsolutePath")
        $output.Add('MetaDataPackageLoader=TDBXOpenOdbcCustomMetaDataCommandFactory')
        $output.Add('ConnectionString=DRIVER={SQL Server};Server=127.0.0.1;Database=master;Trusted_Connection=yes;')
        $output.Add('Database=?')
        $output.Add('User_Name=')
        $output.Add('Password=')
        $output.Add('RowsetSize=20')
        $output.Add('BlobSize=-1')
        $output.Add('Trim Char=True')
        $output.Add('Custom String=')
        $output.Add('')
        $output.Add('[OpenOdbc]')
        $output.Add('DriverUnit=DbxOpenOdbcDriver')
        $output.Add("DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative,$BplAbsolutePath")
        $output.Add('MetaDataPackageLoader=TDBXOpenOdbcCustomMetaDataCommandFactory')
        $output.Add('ConnectionString=DRIVER={SQL Server};Server=127.0.0.1;Database=master;Trusted_Connection=yes;')
        $output.Add('Database=?')
        $output.Add('User_Name=')
        $output.Add('Password=')
        $output.Add('RowsetSize=20')
        $output.Add('BlobSize=-1')
        $output.Add('Trim Char=True')
        $output.Add('Custom String=')
    }

    [IO.File]::WriteAllLines($IniFile, $output, [System.Text.Encoding]::Default)
}

# ===========================================================================
# Main Installation Pipeline
# ===========================================================================

# 1. Resolve radstudio CLI tool (v1.0.4 pinned)
$cliExe = Get-RadStudioCli -ExplicitPath $CliPath -DisableDownload:$SkipCli

# 2. Discover installed RAD Studio environments
$envs = @(Get-InstalledBdsEnvironments -CliExecutable $cliExe)

# Filter for active modern environments (BDS >= 17.0 / Delphi 10+)
$modernEnvs = @($envs | Where-Object {
    $v = 0.0
    [double]::TryParse($_.Version, [ref]$v) -and ($v -ge 17.0)
})

if ($modernEnvs.Count -eq 0) {
    # If no modern envs found via filter, retain any valid envs
    $modernEnvs = @($envs)
}

if ($modernEnvs.Count -eq 0) {
    if ($BdsPath -and (Test-Path -LiteralPath $BdsPath)) {
        $modernEnvs = @([PSCustomObject]@{
            Version         = 'Custom'
            ProductVersion  = 'Custom'
            Name            = "Custom RAD Studio ($BdsPath)"
            RootDir         = $BdsPath.TrimEnd('\')
            CompilerVersion = ''
            Suffix          = '280'
            IdePlatform     = 'Win32'
            SupportsCliBuild= $true
        })
    } else {
        throw 'No RAD Studio installations were detected on this machine. Specify -BdsPath explicitly.'
    }
}

# 3. Select target environment (interactive prompt if multiple coexist)
$selectedEnv = $null

if ($TargetVersion) {
    $selectedEnv = $modernEnvs | Where-Object { $_.Version -eq $TargetVersion -or $_.ProductVersion -eq $TargetVersion } | Select-Object -First 1
    if (-not $selectedEnv) {
        throw "Specified -TargetVersion '$TargetVersion' was not found among installed environments."
    }
}
elseif ($BdsPath) {
    $cleanTarget = $BdsPath.TrimEnd('\')
    $selectedEnv = $modernEnvs | Where-Object { $_.RootDir -ieq $cleanTarget } | Select-Object -First 1
    if (-not $selectedEnv) {
        $selectedEnv = [PSCustomObject]@{
            Version         = 'Custom'
            ProductVersion  = 'Custom'
            Name            = "Custom RAD Studio ($cleanTarget)"
            RootDir         = $cleanTarget
            CompilerVersion = ''
            Suffix          = '280'
            IdePlatform     = 'Win32'
            SupportsCliBuild= $true
        }
    }
}
elseif (@($modernEnvs).Count -eq 1) {
    $selectedEnv = @($modernEnvs)[0]
}
else {
    $envCount = @($modernEnvs).Count
    # Interactive menu for multiple environments
    Write-Host "`n[RAD Studio Environment Selection]" -ForegroundColor Green
    Write-Host "Multiple RAD Studio installations detected:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $envCount; $i++) {
        $e = @($modernEnvs)[$i]
        Write-Host "  [$($i + 1)] $($e.Name) (Version: $($e.Version), Suffix: $($e.Suffix)) @ $($e.RootDir)"
    }
    $choice = Read-Host "Select target installation [1-$envCount] (default: 1)"
    $idx = 0
    if ($choice -match '^\d+$') {
        $val = [int]$choice
        if ($val -ge 1 -and $val -le $envCount) { $idx = $val - 1 }
    }
    $selectedEnv = @($modernEnvs)[$idx]
}

Write-Host "`n[TARGET] Selected: $($selectedEnv.Name)" -ForegroundColor Green
Write-Host "         Root Dir : $($selectedEnv.RootDir)"
Write-Host "         Suffix   : $($selectedEnv.Suffix)"

$bdsRoot = $selectedEnv.RootDir
$suffix = $selectedEnv.Suffix
if (-not $Platform) {
    $Platform = $selectedEnv.IdePlatform
}

# 4. Locate dbExpress INI directory
if (-not $DbxIniDir) {
    $studioVer = $selectedEnv.Version
    $candidates = @()
    if ($studioVer -and $studioVer -ne 'Custom') {
        $candidates += Join-Path $env:PUBLIC "Documents\Embarcadero\Studio\dbExpress\$studioVer"
        $candidates += "C:\Users\Public\Documents\Embarcadero\Studio\dbExpress\$studioVer"
    }
    $candidates += Get-ChildItem -Path (Join-Path $env:PUBLIC 'Documents\Embarcadero\Studio\dbExpress') -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending | ForEach-Object { $_.FullName }

    foreach ($cand in $candidates) {
        if ($cand -and (Test-Path -LiteralPath (Join-Path $cand 'dbxdrivers.ini'))) {
            $DbxIniDir = $cand
            break
        }
    }
}

if (-not $DbxIniDir -or -not (Test-Path -LiteralPath (Join-Path $DbxIniDir 'dbxdrivers.ini'))) {
    throw "Could not locate RAD Studio's dbxdrivers.ini. Please specify -DbxIniDir explicitly."
}

$driversIniPath = Join-Path $DbxIniDir 'dbxdrivers.ini'
Write-Host "         INI Path : $driversIniPath"

# 5. Handle -Uninstall
if ($Uninstall) {
    Set-IniDriverRegistration -IniFile $driversIniPath -BplAbsolutePath '' -RemoveOnly $true
    Write-Host "[OK] Uninstalled DbxOpenOdbc and OpenOdbc from: $driversIniPath" -ForegroundColor Green
    return
}

# 6. Synchronize project DllSuffix
Sync-ProjectSuffix -ProjectDir $PSScriptRoot -Suffix $suffix

# 7. Build the package
Write-Host "`n[BUILD] Building package for $Platform (Release)..." -ForegroundColor Cyan
$dprojPath = Join-Path $PSScriptRoot 'DbxOpenOdbcDataExplorer.dproj'
$outputDir = Join-Path $PSScriptRoot "bin\$Platform\Release"
$bplExpected = Join-Path $outputDir "DbxOpenOdbcDataExplorer$suffix.bpl"
$buildSuccess = $false

$isCommunityEdition = ($selectedEnv.SupportsCliBuild -eq $false)

if ($isCommunityEdition) {
    # -----------------------------------------------------------------------
    # Path CE: Community / Trial Edition (command-line compilation blocked)
    # -----------------------------------------------------------------------
    Write-Host "[BUILD] Community Edition (CE) detected: command-line compiling is restricted by Embarcadero." -ForegroundColor Yellow
    Write-Host "        Routing build to radstudio CLI background BDS engine..." -ForegroundColor Cyan
    Write-Host "        [NOTE] If IDE prompts 'Save changes to project?', choose Yes or save once in IDE to suppress future prompts." -ForegroundColor DarkYellow

    if ($cliExe -and $selectedEnv.ProductVersion -and $selectedEnv.ProductVersion -ne 'Custom') {
        try {
            Write-Host "[BUILD] Invoking radstudio CLI (bds mode) for $($selectedEnv.ProductVersion)..." -ForegroundColor Cyan
            & $cliExe $selectedEnv.ProductVersion bds $dprojPath -p $Platform -c Release --no-splash
            if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $bplExpected)) {
                $buildSuccess = $true
                Write-Host "[BUILD] radstudio CLI bds build succeeded." -ForegroundColor Green
            }
        } catch {
            Write-Host "[WARN] radstudio CLI bds build encountered an error: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[WARN] radstudio CLI is required for Community Edition automated builds but is not available." -ForegroundColor Yellow
    }
}
else {
    # -----------------------------------------------------------------------
    # Path Non-CE: Commercial editions (Pro / Enterprise / Architect)
    # -----------------------------------------------------------------------
    Write-Host "[BUILD] Commercial edition detected (command-line compilation supported)." -ForegroundColor Green
    Write-Host "        Using native DCC / Build.ps1 toolchain (fast, pure headless, zero IDE save dialogs)..." -ForegroundColor Cyan
    $buildScript = Join-Path $PSScriptRoot 'Build.ps1'
    try {
        & $buildScript -BdsPath $bdsRoot -Platform $Platform -Verify:$Verify
        if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $bplExpected)) {
            $buildSuccess = $true
            Write-Host "[BUILD] Native compiler build succeeded." -ForegroundColor Green
        }
    } catch {
        Write-Host "[WARN] Native compiler build encountered an error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# ---------------------------------------------------------------------------
# Fallback safety net: if the primary path was unsuccessful, try the other
# ---------------------------------------------------------------------------
if (-not $buildSuccess) {
    if ($isCommunityEdition) {
        Write-Host "[BUILD] Attempting fallback to native compiler (Build.ps1)..." -ForegroundColor Cyan
        $buildScript = Join-Path $PSScriptRoot 'Build.ps1'
        try {
            & $buildScript -BdsPath $bdsRoot -Platform $Platform -Verify:$Verify
            if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $bplExpected)) {
                $buildSuccess = $true
            }
        } catch {
            Write-Host "[WARN] Native compiler fallback failed: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        if ($cliExe -and $selectedEnv.ProductVersion -and $selectedEnv.ProductVersion -ne 'Custom') {
            Write-Host "[BUILD] Attempting fallback to radstudio CLI build engine..." -ForegroundColor Cyan
            try {
                & $cliExe $selectedEnv.ProductVersion build $dprojPath -p $Platform -c Release
                if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $bplExpected)) {
                    $buildSuccess = $true
                }
            } catch {
                Write-Host "[WARN] CLI build fallback failed: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    }
}

if (-not (Test-Path -LiteralPath $bplExpected)) {
    $legacyBpl = Join-Path $PSScriptRoot "bin\$suffix\$Platform\Release\DbxOpenOdbcDataExplorer$suffix.bpl"
    if (Test-Path -LiteralPath $legacyBpl) {
        $bplExpected = $legacyBpl
    }
}

if (-not $buildSuccess -or -not (Test-Path -LiteralPath $bplExpected)) {
    throw "Build failed to generate expected BPL: $bplExpected"
}

Write-Host "[OK] Successfully built: $bplExpected" -ForegroundColor Green

# 8. Register in dbxdrivers.ini
Set-IniDriverRegistration -IniFile $driversIniPath -BplAbsolutePath $bplExpected -RemoveOnly $false
Write-Host "[OK] Registered DbxOpenOdbc & OpenOdbc in: $driversIniPath" -ForegroundColor Green

# 9. IDE running check
$bdsProc = Get-Process -Name 'bds' -ErrorAction SilentlyContinue
if ($bdsProc) {
    Write-Host "`n[NOTE] RAD Studio (bds.exe) is currently running. Please restart the IDE to reload dbxdrivers.ini." -ForegroundColor Yellow
} else {
    Write-Host "`n[SUCCESS] Installation complete! Launch RAD Studio and open Data Explorer to access your ODBC databases." -ForegroundColor Green
}
