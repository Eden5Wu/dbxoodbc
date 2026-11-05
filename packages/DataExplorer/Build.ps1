param(
    [string]$BdsPath = $env:BDS,
    [ValidateSet('Win32', 'Win64')]
    [string]$Platform = 'Win32',
    [switch]$Verify
)

$ErrorActionPreference = 'Stop'
if (-not $BdsPath) {
    throw 'Specify -BdsPath with your Delphi installation directory, or set BDS.'
}
$packageDir = $PSScriptRoot
[xml]$project = Get-Content -LiteralPath (Join-Path $packageDir 'DbxOpenOdbcDataExplorer.dproj') -Raw
$namespaces = [Xml.XmlNamespaceManager]::new($project.NameTable)
$namespaces.AddNamespace('m', 'http://schemas.microsoft.com/developer/msbuild/2003')
$suffixNode = $project.SelectSingleNode('//m:PropertyGroup/m:DllSuffix', $namespaces)
if ($null -eq $suffixNode -or $suffixNode.InnerText -notmatch '^\d+$') {
    throw 'Set a numeric LIB suffix in the package project first; see README.md.'
}
$suffix = $suffixNode.InnerText
$packageSource = Get-Content -LiteralPath (Join-Path $packageDir 'DbxOpenOdbcDataExplorer.dpk') -Raw
if ($packageSource -notmatch ('(?i)\{\$LIBSUFFIX\s+''' + $suffix + '''\}')) {
    throw 'The project DllSuffix and DPK LIBSUFFIX must match; see README.md.'
}
$compilerName = if ($Platform -eq 'Win64') { 'dcc64.exe' } else { 'dcc32.exe' }
$runtimeBin = if ($Platform -eq 'Win64') { 'bin64' } else { 'bin' }
$compiler = Join-Path $BdsPath ('bin\' + $compilerName)
$library = Join-Path $BdsPath ('lib\' + $Platform + '\release')
if (-not (Test-Path -LiteralPath $compiler) -or
    -not (Test-Path -LiteralPath (Join-Path $BdsPath ($runtimeBin + '\rtl' + $suffix + '.bpl')))) {
    throw "The Delphi installation must provide $Platform support and rtl$suffix.bpl. Check LIB suffix."
}

$outputDir = Join-Path $PSScriptRoot ("bin\$suffix\$Platform\Release")
$buildDir = Join-Path $PSScriptRoot ("build\$suffix\$Platform\Release")
New-Item -ItemType Directory -Path $outputDir,$buildDir -Force | Out-Null
Push-Location -LiteralPath $packageDir
try {
    & $compiler '-Q' '-B' ("-U$library") ("-LE$outputDir") ("-LN$buildDir") ("-N0$buildDir") 'DbxOpenOdbcDataExplorer.dpk'
    if ($LASTEXITCODE -ne 0) { throw 'Driver package compilation failed.' }
} finally {
    Pop-Location
}
$packageName = "DbxOpenOdbcDataExplorer$suffix.bpl"
$packagePath = Join-Path $outputDir $packageName
if (-not (Test-Path -LiteralPath $packagePath)) { throw "Expected output is missing: $packagePath" }
Write-Output $packagePath

if ($Verify) {
    & $compiler '-Q' '-B' '-LUrtl;dbrtl;dbexpress' ("-U$library") ("-E$outputDir") ("-N0$buildDir") (Join-Path $PSScriptRoot 'tests\DataExplorerLoaderTest.dpr')
    if ($LASTEXITCODE -ne 0) { throw 'Loader test compilation failed.' }
    # Use private fixtures so verification never changes user/IDE INI settings.
    $driversFile = Join-Path $buildDir 'dbxdrivers.ini'
    $connectionsFile = Join-Path $PSScriptRoot 'ini\dbxconnections.ini'
    $driverTemplate = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'ini\dbxdrivers.ini') -Raw
    $resolvedDriverConfig = [regex]::Replace($driverTemplate, 'DbxOpenOdbcDataExplorer\d*\.bpl', { param($m) $packagePath })
    [IO.File]::WriteAllText($driversFile, $resolvedDriverConfig)
    $originalPath = $env:PATH
    try {
        $env:PATH = $outputDir + ';' + (Join-Path $BdsPath $runtimeBin) + ';' + $originalPath
        & (Join-Path $outputDir 'DataExplorerLoaderTest.exe') $driversFile $connectionsFile $packageName
        if ($LASTEXITCODE -ne 0) { throw 'Loader verification failed.' }
    } finally {
        $env:PATH = $originalPath
    }
}
