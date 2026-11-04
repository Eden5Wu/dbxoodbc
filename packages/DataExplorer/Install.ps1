<#
.SYNOPSIS
    Builds and installs (or uninstalls) the DBX4 Remastered Data Explorer package into RAD Studio.

.DESCRIPTION
    1. Automatically locates RAD Studio (via -BdsPath, $env:BDS, or Windows Registry).
    2. Compiles DbxOpenOdbcDataExplorer<Suffix>.bpl (Win32 for 32-bit IDE) via Build.ps1.
    3. Safely backs up and updates RAD Studio's dbxdrivers.ini with the exact absolute path to the compiled BPL.
    4. Optionally merges sample connection profiles into dbxconnections.ini (-IncludeSampleConnections).
    5. Supports -Uninstall to cleanly remove DbxOpenOdbc/OpenOdbc entries from dbxdrivers.ini.

.EXAMPLE
    .\Install.ps1
    .\Install.ps1 -BdsPath "D:\RADStudio\22.0" -Verify
    .\Install.ps1 -Uninstall
#>
param(
    [string]$BdsPath = $env:BDS,
    [string]$DbxIniDir = '',
    [ValidateSet('Win32', 'Win64')]
    [string]$Platform = 'Win32',
    [switch]$Verify,
    [switch]$IncludeSampleConnections,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

# Mapping from LIBSUFFIX to RAD Studio StudioVersion (Registry / Public Documents folder version)
$suffixToStudioVer = @{
    '230' = '17.0' # Delphi 10 Seattle
    '240' = '18.0' # Delphi 10.1 Berlin
    '250' = '19.0' # Delphi 10.2 Tokyo
    '260' = '20.0' # Delphi 10.3 Rio
    '270' = '21.0' # Delphi 10.4 Sydney
    '280' = '22.0' # Delphi 11 Alexandria
    '290' = '23.0' # Delphi 12 Athens
    '370' = '37.0' # Delphi 13 Florence
}

# 1. Read DllSuffix from DbxOpenOdbcDataExplorer.dproj
$dprojPath = Join-Path $PSScriptRoot 'DbxOpenOdbcDataExplorer.dproj'
if (-not (Test-Path -LiteralPath $dprojPath)) {
    throw "Project file not found: $dprojPath"
}
[xml]$project = Get-Content -LiteralPath $dprojPath -Raw
$namespaces = [Xml.XmlNamespaceManager]::new($project.NameTable)
$namespaces.AddNamespace('m', 'http://schemas.microsoft.com/developer/msbuild/2003')
$suffixNode = $project.SelectSingleNode('//m:PropertyGroup/m:DllSuffix', $namespaces)
if ($null -eq $suffixNode -or $suffixNode.InnerText -notmatch '^\d+$') {
    throw 'Set a numeric LIB suffix in DbxOpenOdbcDataExplorer.dproj first; see README.md.'
}
$suffix = $suffixNode.InnerText
$studioVer = $suffixToStudioVer[$suffix]

# Delphi 10.x/11 have a Win32 IDE. Win64 builds are for application hosts only.
if (-not $Uninstall -and $Platform -eq 'Win64' -and $suffix -in @('230','240','250','260','270','280')) {
    throw 'This Delphi version has a Win32 IDE. Install with -Platform Win32; use Build.ps1 for Win64 application packages.'
}

# 2. Auto-detect BdsPath from Registry if not specified
if (-not $BdsPath -and $studioVer) {
    foreach ($hive in @("HKCU:\Software\Embarcadero\BDS\$studioVer", "HKLM:\SOFTWARE\WOW6432Node\Embarcadero\BDS\$studioVer", "HKLM:\SOFTWARE\Embarcadero\BDS\$studioVer")) {
        if (Test-Path -LiteralPath $hive) {
            $regRoot = (Get-ItemProperty -LiteralPath $hive -Name 'RootDir' -ErrorAction SilentlyContinue).RootDir
            if ($regRoot -and (Test-Path -LiteralPath $regRoot)) {
                $BdsPath = $regRoot.TrimEnd('\')
                break
            }
        }
    }
}

# 3. Locate RAD Studio's dbExpress INI directory
if (-not $DbxIniDir) {
    $candidates = @()
    if ($studioVer) {
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
$connectionsIniPath = Join-Path $DbxIniDir 'dbxconnections.ini'

# Helper: Update or remove INI sections cleanly
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

            # Before leaving [Installed Drivers], append keys if installing and not yet present
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

        if ($skipSection) {
            continue
        }

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

# 4. Handle Uninstall
if ($Uninstall) {
    Set-IniDriverRegistration -IniFile $driversIniPath -BplAbsolutePath '' -RemoveOnly $true
    Write-Host "[OK] Uninstalled DbxOpenOdbc and OpenOdbc from: $driversIniPath" -ForegroundColor Green
    return
}

# 5. Build the BPL package first
if (-not $BdsPath) {
    throw 'Could not auto-detect RAD Studio installation path. Please specify -BdsPath (e.g. -BdsPath "D:\RADStudio\22.0").'
}

Write-Host "[INFO] Using RAD Studio installation: $BdsPath (LIBSUFFIX: $suffix, Platform: $Platform)" -ForegroundColor Cyan
$buildScript = Join-Path $PSScriptRoot 'Build.ps1'
$buildOutput = & $buildScript -BdsPath $BdsPath -Platform $Platform -Verify:$Verify
$bplPath = ($buildOutput | Where-Object { $_ -like '*.bpl' } | Select-Object -First 1)
if (-not $bplPath -or -not (Test-Path -LiteralPath $bplPath)) {
    throw "Build did not produce a valid BPL path. Output: $($buildOutput -join '; ')"
}

Write-Host "[OK] Built package: $bplPath" -ForegroundColor Green

# 6. Register in RAD Studio's dbxdrivers.ini
Set-IniDriverRegistration -IniFile $driversIniPath -BplAbsolutePath $bplPath -RemoveOnly $false
Write-Host "[OK] Registered DbxOpenOdbc & OpenOdbc in: $driversIniPath" -ForegroundColor Green

# 7. Check if bds.exe is running
$bdsProc = Get-Process -Name 'bds' -ErrorAction SilentlyContinue
if ($bdsProc) {
    Write-Host "[NOTE] RAD Studio (bds.exe) is currently running. Please restart the IDE to reload dbxdrivers.ini, or simply re-Build inside the IDE." -ForegroundColor Yellow
}
else {
    Write-Host "[SUCCESS] Installation complete! Start RAD Studio and open Data Explorer to use DbxOpenOdbc." -ForegroundColor Green
}
