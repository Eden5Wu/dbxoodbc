param(
    [string]$BdsPath = $env:BDS,
    [ValidateSet('Win32', 'Win64')]
    [string[]]$Platform = @('Win32', 'Win64')
)

$ErrorActionPreference = 'Stop'
if (-not $BdsPath) { throw 'Specify -BdsPath or set BDS.' }
if (-not $env:DBXOODBC_TEST_CONNECTION) {
    throw 'Set DBXOODBC_TEST_CONNECTION to a SQL Server test connection string.'
}
Push-Location -LiteralPath $PSScriptRoot
try {
    foreach ($target in $Platform) {
        $compilerName = if ($target -eq 'Win64') { 'dcc64.exe' } else { 'dcc32.exe' }
        $compiler = Join-Path $BdsPath ('bin\' + $compilerName)
        $library = Join-Path $BdsPath ('lib\' + $target + '\release')
        $source = (Resolve-Path -LiteralPath '..\..\source').ProviderPath
        $output = Join-Path $PSScriptRoot ('build\' + $target)
        [IO.Directory]::CreateDirectory($output) | Out-Null
        & $compiler '-Q' '-B' ("-U$library;$source") ("-E$output") ("-N0$output") 'RuntimeRegressionTester.dpr'
        if ($LASTEXITCODE -ne 0) { throw "$target compilation failed." }
        & (Join-Path $output 'RuntimeRegressionTester.exe')
        if ($LASTEXITCODE -ne 0) { throw "$target runtime regression failed." }
    }
} finally {
    Pop-Location
}
