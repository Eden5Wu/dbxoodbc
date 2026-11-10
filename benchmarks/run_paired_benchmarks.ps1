param(
    [string]$TargetScenario = "ALL"
)

Set-Location -LiteralPath 'd:\Source\[ComponentTest]\Database\OpenDbexpress\dbxoodbc\benchmarks'

$scenarios = @(
    "OILAPP_A",
    "OILAPP_B",
    "OILAPP_C1",
    "OILAPP_C2",
    "CDS_MEMO",
    "SCALAR",
    "MEMO",
    "WIDE",
    "S_REPORTS"
)

if ($TargetScenario -ne "ALL") {
    $scenarios = @($TargetScenario)
}

function Run-Scenario([string]$exe, [string]$scen) {
    $out = & $exe --bench $scen
    foreach ($line in $out) {
        if ($line -match "TIME_MS:([0-9\.]+)") {
            return [double]$matches[1]
        }
    }
    return 0.0
}

function Get-Median([double[]]$arr) {
    $sorted = $arr | Sort-Object
    $mid = [math]::Floor($sorted.Length / 2)
    if ($sorted.Length % 2 -eq 0) {
        return ($sorted[$mid - 1] + $sorted[$mid]) / 2.0
    } else {
        return $sorted[$mid]
    }
}

Write-Host "================================================================================"
Write-Host " EXECUTING PAIRED BENCHMARK SUITE (Alternating Order: Base/Uni vs Uni/Base)"
Write-Host "================================================================================"

foreach ($scen in $scenarios) {
    Write-Host ""
    Write-Host ">>> Testing Scenario: $scen <<<"

    # Warmup
    Write-Host "  [Warmup] Baseline..."
    $null = Run-Scenario ".\Bench_Base_Comp.exe" $scen
    Write-Host "  [Warmup] Unicode..."
    $null = Run-Scenario ".\Bench_Uni_Comp.exe" $scen

    $baseSamples = @()
    $uniSamples = @()

    # 4 Paired Rounds
    for ($r = 1; $r -le 4; $r++) {
        if ($r % 2 -eq 1) {
            # Base first
            $tBase = Run-Scenario ".\Bench_Base_Comp.exe" $scen
            Start-Sleep -Milliseconds 200
            $tUni = Run-Scenario ".\Bench_Uni_Comp.exe" $scen
            Start-Sleep -Milliseconds 200
        } else {
            # Uni first
            $tUni = Run-Scenario ".\Bench_Uni_Comp.exe" $scen
            Start-Sleep -Milliseconds 200
            $tBase = Run-Scenario ".\Bench_Base_Comp.exe" $scen
            Start-Sleep -Milliseconds 200
        }

        $baseSamples += $tBase
        $uniSamples += $tUni
        Write-Host ("  Round {0}: Base = {1,7:F1} ms | Uni = {2,7:F1} ms" -f $r, $tBase, $tUni)
    }

    $baseMedian = Get-Median $baseSamples
    $baseMin = ($baseSamples | Measure-Object -Minimum).Minimum
    $baseMax = ($baseSamples | Measure-Object -Maximum).Maximum
    $baseRange = $baseMax - $baseMin

    $uniMedian = Get-Median $uniSamples
    $uniMin = ($uniSamples | Measure-Object -Minimum).Minimum
    $uniMax = ($uniSamples | Measure-Object -Maximum).Maximum
    $uniRange = $uniMax - $uniMin

    $diffMs = $uniMedian - $baseMedian
    $diffPct = 0.0
    if ($baseMedian -gt 0) {
        $diffPct = ($diffMs / $baseMedian) * 100.0
    }

    Write-Host "  ----------------------------------------------------------------------------"
    Write-Host ("  [BASELINE] Median: {0,6:F1} ms | Min: {1,6:F1} ms | Max: {2,6:F1} ms | Range: {3,5:F1} ms" -f $baseMedian, $baseMin, $baseMax, $baseRange)
    Write-Host ("  [UNICODE ] Median: {0,6:F1} ms | Min: {1,6:F1} ms | Max: {2,6:F1} ms | Range: {3,5:F1} ms" -f $uniMedian, $uniMin, $uniMax, $uniRange)
    $sign = if ($diffMs -ge 0) { "+" } else { "" }
    Write-Host ("  [DIFF    ] Median Delta: {0}{1:F1} ms ({0}{2:F1}%)" -f $sign, $diffMs, $diffPct)
}

Write-Host ""
Write-Host "================================================================================"
Write-Host " ALL PAIRED BENCHMARKS COMPLETED"
Write-Host "================================================================================"

