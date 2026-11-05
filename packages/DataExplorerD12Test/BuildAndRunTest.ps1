param(
    [string]$BdsPath = $env:BDS,
    [string]$ConnStr = $env:DBXOODBC_TEST_CONN,
    [switch]$RunOnly
)

$ErrorActionPreference = 'Stop'

function Find-DelphiPath {
    param([string]$ExplicitPath)
    if ($ExplicitPath -and (Test-Path -LiteralPath $ExplicitPath)) {
        return $ExplicitPath
    }
    # Check environment variable BDS
    if ($env:BDS -and (Test-Path -LiteralPath $env:BDS)) {
        return $env:BDS
    }
    # Check common D12 Athens paths
    $candidatePaths = @(
        'C:\Program Files (x86)\Embarcadero\Studio\23.0',
        'D:\RADStudio\23.0',
        'D:\Embarcadero\Studio\23.0'
    )
    foreach ($path in $candidatePaths) {
        if (Test-Path -LiteralPath $path) {
            return $path
        }
    }
    # Try finding dcc32 from PATH
    $dccCmd = Get-Command dcc32.exe -ErrorAction SilentlyContinue
    if ($dccCmd) {
        return (Split-Path -Parent (Split-Path -Parent $dccCmd.Source))
    }
    return $null
}

$scriptDir = $PSScriptRoot
$outDir = Join-Path $scriptDir 'bin\Win32\Release'
$bldDir = Join-Path $scriptDir 'build\Win32\Release'

if (-not $RunOnly) {
    $delphiRoot = Find-DelphiPath $BdsPath
    if (-not $delphiRoot) {
        throw "Cannot locate Delphi installation directory. Please specify -BdsPath 'C:\Program Files (x86)\Embarcadero\Studio\23.0' or set BDS environment variable."
    }

    $dcc32 = Join-Path $delphiRoot 'bin\dcc32.exe'
    if (-not (Test-Path -LiteralPath $dcc32)) {
        throw "dcc32.exe not found at: $dcc32"
    }

    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Building DbxOpenOdbc D12 Test Package & Loader" -ForegroundColor Cyan
    Write-Host "  Delphi Root : $delphiRoot" -ForegroundColor Gray
    Write-Host "  Output Dir  : $outDir" -ForegroundColor Gray
    Write-Host "================================================================" -ForegroundColor Cyan

    New-Item -ItemType Directory -Path $outDir, $bldDir -Force | Out-Null

    Push-Location -LiteralPath $scriptDir
    try {
        # 1. Compile Package: DbxOpenOdbcDataExplorerD12Test.dpk
        Write-Host "`n[STEP 1] Compiling Package DbxOpenOdbcDataExplorerD12Test.dpk..." -ForegroundColor Yellow
        $libDir = Join-Path $delphiRoot 'lib\Win32\release'
        & $dcc32 -B -Q "-U$libDir" "-LE$outDir" "-LN$bldDir" "-N0$bldDir" 'DbxOpenOdbcDataExplorerD12Test.dpk'
        if ($LASTEXITCODE -ne 0) {
            throw "Package compilation failed with exit code $LASTEXITCODE"
        }
        $bplFile = Join-Path $outDir 'DbxOpenOdbcDataExplorerD12Test290.bpl'
        if (-not (Test-Path -LiteralPath $bplFile)) {
            throw "Expected BPL output not found: $bplFile"
        }
        Write-Host "[OK] Package compiled: $bplFile" -ForegroundColor Green

        # 2. Compile Loader: DataExplorerBplLoaderTest.dpr
        Write-Host "`n[STEP 2] Compiling Standalone Loader DataExplorerBplLoaderTest.dpr..." -ForegroundColor Yellow
        & $dcc32 -B -Q '-LUrtl;dbrtl;dbexpress' "-U$libDir" "-E$outDir" "-N0$bldDir" 'DataExplorerBplLoaderTest.dpr'
        if ($LASTEXITCODE -ne 0) {
            throw "Loader compilation failed with exit code $LASTEXITCODE"
        }
        $exeFile = Join-Path $outDir 'DataExplorerBplLoaderTest.exe'
        if (-not (Test-Path -LiteralPath $exeFile)) {
            throw "Expected Loader EXE output not found: $exeFile"
        }
        Write-Host "[OK] Loader compiled: $exeFile" -ForegroundColor Green

    } finally {
        Pop-Location
    }
}

# 3. Run Loader Test
$exePath = Join-Path $outDir 'DataExplorerBplLoaderTest.exe'
$bplPath = Join-Path $outDir 'DbxOpenOdbcDataExplorerD12Test290.bpl'

if (-not (Test-Path -LiteralPath $exePath)) {
    throw "Loader executable not found: $exePath. Please run without -RunOnly first."
}

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host "  Executing Standalone Dynamic Loader Test" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

if (-not $ConnStr) {
    Write-Host "[WARN] No connection string provided via -ConnStr or DBXOODBC_TEST_CONN." -ForegroundColor Yellow
    Write-Host "Running loader pre-checks and dynamic BPL registration test only..." -ForegroundColor Gray
}

Push-Location -LiteralPath $outDir
try {
    if ($ConnStr) {
        & ".\DataExplorerBplLoaderTest.exe" $bplPath $ConnStr
    } else {
        & ".\DataExplorerBplLoaderTest.exe" $bplPath
    }
} finally {
    Pop-Location
}

