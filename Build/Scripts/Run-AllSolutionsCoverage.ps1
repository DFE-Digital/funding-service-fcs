<#
.SYNOPSIS
Finds every solution in the FCT repository that has unit-test projects, runs Run-UnitTestCodeCoverage.ps1 on each, and writes a combined HTML summary.

.DESCRIPTION
Open this file in the PowerShell ISE and press F5, or run it from a prompt. Each solution's own HTML report
is produced by Run-UnitTestCodeCoverage.ps1; this script links them from one summary page.

.PARAMETER RepositoryRoot
Root of the FCT repository. Defaults to two folders above this script.

.PARAMETER Configuration
Build configuration of the test assemblies. Default: Debug.

.PARAMETER SolutionPath
Explicit list of solution files to run (absolute, or relative to the current folder or RepositoryRoot). When supplied, discovery, Include and Exclude are skipped.

.PARAMETER Include
Wildcard patterns matched against the solution path; only matching solutions run. Default: all.

.PARAMETER Exclude
Wildcard patterns matched against the solution path; matching solutions are skipped.

.PARAMETER Build
Clean and build each solution before testing.

.PARAMETER IncludeInfrastructureTests
Do not exclude integration and infrastructure-dependent tests (excluded by default).

.PARAMETER NoOpen
Do not open the summary page when finished.

.EXAMPLE
.\Build\Scripts\Run-AllSolutionsCoverage.ps1 -Build

.EXAMPLE
.\Build\Scripts\Run-AllSolutionsCoverage.ps1 -Include *CrossDomain.Integration* -Exclude *Acceptance*
#>
[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$Configuration = "Debug",
    [string[]]$SolutionPath = @(),
    [string[]]$Include = @("*"),
    [string[]]$Exclude = @(),
    [switch]$Build,
    [switch]$IncludeInfrastructureTests,
    [switch]$NoOpen
)

$ErrorActionPreference = "Stop"

$SolutionPath = @($SolutionPath | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
$Include = @($Include | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
$Exclude = @($Exclude | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
$scriptDirectory = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$coverageScript = Join-Path $scriptDirectory "Run-UnitTestCodeCoverage.ps1"
if (-not (Test-Path $coverageScript)) {
    throw "Run-UnitTestCodeCoverage.ps1 was not found next to this script ($scriptDirectory)."
}

if (-not $RepositoryRoot) {
    $RepositoryRoot = (Resolve-Path (Join-Path $scriptDirectory "..\..")).Path
}
$RepositoryRoot = (Resolve-Path $RepositoryRoot).Path

$summaryDirectory = Join-Path $RepositoryRoot "TestResults\AllSolutionsCoverage"
New-Item -ItemType Directory -Path $summaryDirectory -Force | Out-Null

$skipFolders = '\\(bin|obj|packages|node_modules|\.git|\.vs|TestResults)\\'
$solutions = @(
    if ($SolutionPath.Count -gt 0) {
        foreach ($entry in $SolutionPath) {
            $candidate = if (Test-Path $entry) { $entry } else { Join-Path $RepositoryRoot $entry }
            if (-not (Test-Path $candidate)) {
                $found = Get-ChildItem -Path $RepositoryRoot -Filter (Split-Path -Leaf $entry) -Recurse -File | Where-Object { $_.FullName -notmatch $skipFolders } | Select-Object -First 1
                if (-not $found) { throw "Solution '$entry' was not found." }
                $candidate = $found.FullName
            }
            Get-Item (Resolve-Path $candidate).Path
        }
    }
    else { Get-ChildItem -Path $RepositoryRoot -Filter *.sln -Recurse -File |
        Where-Object { $_.FullName -notmatch $skipFolders } |
        Where-Object {
            $path = $_.FullName
            ($Include | Where-Object { $path -like $_ }) -and -not ($Exclude | Where-Object { $path -like $_ })
        } |
        Where-Object { (Get-Content $_.FullName -Raw) -match '(?im)^Project\(.*?Tests?\.csproj"' } |
        Sort-Object FullName }
)

if ($solutions.Count -eq 0) {
    throw "No solutions with unit-test projects were found under '$RepositoryRoot'."
}

Write-Host "Found $($solutions.Count) solution(s) with test projects:" -ForegroundColor Cyan
$solutions | ForEach-Object { Write-Host "  $($_.FullName.Substring($RepositoryRoot.Length).TrimStart('\'))" }

$results = @()
foreach ($solution in $solutions) {
    $relative = $solution.FullName.Substring($RepositoryRoot.Length).TrimStart('\')
    Write-Host ""
    Write-Host "=== $relative ===" -ForegroundColor Cyan

    $arguments = @{
        Solution      = $solution.FullName
        Configuration = $Configuration
        Html          = $true
    }
    if ($Build) { $arguments.Build = $true }
    if (-not $IncludeInfrastructureTests) { $arguments.ExcludeInfrastructureTests = $true }

    $logPath = Join-Path $summaryDirectory ("{0}.log" -f ($solution.BaseName))
    $status = "Completed"
    $exitCode = 0
    $lines = New-Object System.Collections.Generic.List[string]
    try {
        $global:LASTEXITCODE = 0
        $ErrorActionPreference = "Continue"
        $childArguments = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $coverageScript, "-Solution", $solution.FullName, "-Configuration", $Configuration, "-Html")
        if ($Build) { $childArguments += "-Build" }
        if (-not $IncludeInfrastructureTests) { $childArguments += "-ExcludeInfrastructureTests" }
        & powershell.exe @childArguments 2>&1 | ForEach-Object {
            $text = $_.ToString()
            Write-Host $text
            $lines.Add($text)
        }
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = "Stop"
        if ($exitCode -ne 0) { $status = "Tests failed" }
    }
    catch {
        $ErrorActionPreference = "Stop"
        $status = if ($_.Exception.Message -like "VSTest returned exit code*") { "Tests failed" } else { "Error: $($_.Exception.Message.Split("`n")[0])" }
        $lines.Add($status)
        Write-Warning $status
    }
    $lines | Set-Content -Path $logPath -Encoding UTF8

    $text = $lines -join "`n"
    $coverage = [regex]::Match($text, 'production line coverage[^:]*:\s*([\d.]+)%\s*\(([\d,]+)\s*/\s*([\d,]+)\s*lines\)')
    $total = [regex]::Match($text, 'Total tests:\s*(\d+)')
    $passed = [regex]::Match($text, '(?m)^\s*Passed:\s*(\d+)')
    $failed = [regex]::Match($text, '(?m)^\s*Failed:\s*(\d+)')
    $htmlReport = [regex]::Match($text, '(?m)^HTML report:\s*(.+?)\s*$')
    $reportSource = if ($htmlReport.Success) { $htmlReport.Groups[1].Value } else { $null }
    $publishedReport = $null
    if ($reportSource -and (Test-Path $reportSource)) {
        $target = Join-Path $summaryDirectory ("reports\{0}" -f $solution.BaseName)
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        New-Item -ItemType Directory -Path $target -Force | Out-Null
        Copy-Item -Path (Join-Path (Split-Path -Parent $reportSource) '*') -Destination $target -Recurse -Force
        $publishedReport = "reports/{0}/index.html" -f $solution.BaseName
    }

    $results += [pscustomobject]@{
        Solution = $relative
        Status   = $status
        Tests    = if ($total.Success) { [int]$total.Groups[1].Value } else { $null }
        Passed   = if ($passed.Success) { [int]$passed.Groups[1].Value } else { $null }
        Failed   = if ($failed.Success) { [int]$failed.Groups[1].Value } else { 0 }
        Coverage = if ($coverage.Success) { [double]$coverage.Groups[1].Value } else { $null }
        Covered  = if ($coverage.Success) { [int]($coverage.Groups[2].Value -replace ',', '') } else { $null }
        Lines    = if ($coverage.Success) { [int]($coverage.Groups[3].Value -replace ',', '') } else { $null }
        Report   = $publishedReport
        Log      = $logPath
    }
}

$encode = { param($value) [System.Net.WebUtility]::HtmlEncode([string]$value) }
$rows = foreach ($result in ($results | Sort-Object Solution)) {
    $coverageText = if ($null -ne $result.Coverage) { "{0:N2}%" -f $result.Coverage } else { "-" }
    $linesText = if ($null -ne $result.Lines) { "{0:N0} / {1:N0}" -f $result.Covered, $result.Lines } else { "-" }
    $reportLink = if ($result.Report) { "<a class=""govuk-link"" href=""$($result.Report)"">View report<span class=""govuk-visually-hidden""> for $(& $encode $result.Solution)</span></a>" } else { "-" }
    $statusTag = if ($result.Status -eq "Completed") { "govuk-tag--green" } elseif ($result.Status -eq "Tests failed") { "govuk-tag--red" } else { "govuk-tag--orange" }
    $logLink = "<a class=""govuk-link"" href=""$(Split-Path -Leaf $result.Log)"">View log<span class=""govuk-visually-hidden""> for $(& $encode $result.Solution)</span></a>"
    "<tr class=""govuk-table__row""><th scope=""row"" class=""govuk-table__header"">$(& $encode $result.Solution)</th><td class=""govuk-table__cell""><strong class=""govuk-tag $statusTag"">$(& $encode $result.Status)</strong></td><td class=""govuk-table__cell govuk-table__cell--numeric"">$($result.Tests)</td><td class=""govuk-table__cell govuk-table__cell--numeric"">$($result.Passed)</td><td class=""govuk-table__cell govuk-table__cell--numeric"">$($result.Failed)</td><td class=""govuk-table__cell govuk-table__cell--numeric"">$coverageText</td><td class=""govuk-table__cell govuk-table__cell--numeric"">$linesText</td><td class=""govuk-table__cell"">$reportLink</td><td class=""govuk-table__cell"">$logLink</td></tr>"
}

$totalCovered = ($results | Where-Object { $null -ne $_.Covered } | Measure-Object Covered -Sum).Sum
$totalLines = ($results | Where-Object { $null -ne $_.Lines } | Measure-Object Lines -Sum).Sum
$overall = if ($totalLines) { "{0:N2}%" -f (100.0 * $totalCovered / $totalLines) } else { "-" }

$summaryPath = Join-Path $summaryDirectory "index.html"
@"
<!DOCTYPE html>
<html lang="en" class="govuk-template"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>FCT unit test coverage</title>
<style>
.govuk-template { background: #f3f2f1; }
body { margin: 0; font-family: "GDS Transport", arial, sans-serif; font-size: 19px; line-height: 1.32; color: #0b0c0c; background: #fff; -webkit-font-smoothing: antialiased; }
.govuk-header { background: #0b0c0c; color: #fff; padding: 10px 0; border-bottom: 10px solid #1d70b8; }
.govuk-header__title { font-size: 24px; font-weight: 700; margin: 0; }
.govuk-width-container { max-width: 1100px; margin: 0 auto; padding: 0 30px; }
.govuk-main-wrapper { padding: 40px 0; }
.govuk-heading-xl { font-size: 48px; line-height: 1.1; font-weight: 700; margin: 0 0 30px; }
.govuk-heading-m { font-size: 24px; font-weight: 700; margin: 30px 0 15px; }
.govuk-body { margin: 0 0 20px; }
.govuk-link { color: #1d70b8; } .govuk-link:hover { color: #003078; } .govuk-link:focus { background: #fd0; color: #0b0c0c; outline: 3px solid transparent; box-shadow: 0 -2px #fd0, 0 4px #0b0c0c; text-decoration: none; }
.govuk-inset-text { border-left: 10px solid #b1b4b6; padding: 15px; margin: 30px 0; }
.govuk-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
.govuk-table__header, .govuk-table__cell { padding: 10px 20px 10px 0; border-bottom: 1px solid #b1b4b6; text-align: left; vertical-align: top; font-size: 16px; }
.govuk-table__header { font-weight: 700; }
.govuk-table__cell--numeric { text-align: right; font-variant-numeric: tabular-nums; }
th.govuk-table__header.govuk-table__cell--numeric { text-align: right; }
.govuk-tag { display: inline-block; padding: 2px 8px; font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }
.govuk-tag--green { color: #005a30; background: #cce2d8; } .govuk-tag--red { color: #942514; background: #f6d7d2; } .govuk-tag--orange { color: #6e3619; background: #fcd6c3; }
.govuk-visually-hidden { position: absolute; width: 1px; height: 1px; margin: 0; padding: 0; overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; }
.govuk-skip-link { position: absolute; left: -9999px; } .govuk-skip-link:focus { left: 0; background: #fd0; padding: 10px; color: #0b0c0c; }
.govuk-footer { background: #f3f2f1; border-top: 1px solid #b1b4b6; padding: 25px 0; font-size: 16px; }
</style></head>
<body>
<a href="#main-content" class="govuk-skip-link">Skip to main content</a>
<header class="govuk-header" role="banner"><div class="govuk-width-container"><p class="govuk-header__title">FCT</p></div></header>
<div class="govuk-width-container">
<main class="govuk-main-wrapper" id="main-content" role="main">
<h1 class="govuk-heading-xl">Unit test coverage</h1>
<div class="govuk-inset-text">Overall production line coverage: <strong>$overall</strong><br>Sum of solutions; shared code is counted once per solution.</div>
<p class="govuk-body">Generated $(Get-Date -Format 'd MMMM yyyy, HH:mm'). Configuration: $Configuration.</p>
<h2 class="govuk-heading-m">Coverage by solution</h2>
<table class="govuk-table">
<caption class="govuk-visually-hidden">Unit test results and production line coverage for each solution</caption>
<thead class="govuk-table__head"><tr class="govuk-table__row"><th scope="col" class="govuk-table__header">Solution</th><th scope="col" class="govuk-table__header">Status</th><th scope="col" class="govuk-table__header govuk-table__cell--numeric">Tests</th><th scope="col" class="govuk-table__header govuk-table__cell--numeric">Passed</th><th scope="col" class="govuk-table__header govuk-table__cell--numeric">Failed</th><th scope="col" class="govuk-table__header govuk-table__cell--numeric">Line coverage</th><th scope="col" class="govuk-table__header govuk-table__cell--numeric">Lines covered / total</th><th scope="col" class="govuk-table__header">Report</th><th scope="col" class="govuk-table__header">Log</th></tr></thead>
<tbody class="govuk-table__body">
$($rows -join "`n")
</tbody></table>
</main></div>
<footer class="govuk-footer"><div class="govuk-width-container">Generated by Run-AllSolutionsCoverage.ps1</div></footer>
</body></html>
"@ | Set-Content -Path $summaryPath -Encoding UTF8
Write-Host ""
$results | Select-Object Solution, Status, Tests, Failed, @{ n = "Coverage %"; e = { $_.Coverage } } | Format-Table -AutoSize | Out-String | Write-Host
Write-Host "Summary report: $summaryPath" -ForegroundColor Green

if (-not $NoOpen) {
    Start-Process $summaryPath
}
