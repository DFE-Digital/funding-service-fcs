<#
.SYNOPSIS
Runs tests for the test projects of a Visual Studio solution and collects Cobertura coverage.

.DESCRIPTION
Pass any .sln in the FCT repository. The script reads the solution, selects the test projects
(project names ending in Test/Tests/UnitTests), locates their built assemblies for the chosen configuration,
and runs them with dotnet-coverage using the CodeCoverage.runsettings found next to the solution
(falling back to CrossDomain.Integration\CodeCoverage.runsettings). Reports are written under
<solution folder>\TestResults\UnitTestCoverage unless -OutputDirectory is given.
It also prints distinct in-repository production line coverage, excluding test, generated, and migration sources,
alongside the raw Cobertura percentage. Use -Build to clean and build the solution first.

.EXAMPLE
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution .\CrossDomain.Integration\CrossDomain.Integration.B.sln

.EXAMPLE
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution .\PaymentsGateway\PaymentsGateway.sln -Configuration Release

.EXAMPLE
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution .\CrossDomain.Integration\CrossDomain.Integration.B.sln -ListOnly

.EXAMPLE
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution .\CrossDomain.Integration\CrossDomain.Integration.B.sln -Build -Html -ExcludeInfrastructureTests
Builds the solution, runs every test except integration/exploratory/data-fix categories,
and writes an HTML report to <OutputDirectory>\html.
#>
[CmdletBinding()]
param(
    # Path to the .sln whose test projects should be run (absolute, or relative to the current directory).
    [Parameter(Mandatory = $true)]
    [string]$Solution,
    [string]$Configuration = "Debug",
    [string]$OutputDirectory,
    [switch]$ListOnly,
    # Clean and build the solution with Visual Studio MSBuild before running tests.
    [switch]$Build,
    # Generate an HTML report (production assemblies only) with ReportGenerator.
    [switch]$Html,
    # Run all tests except categories that need live infrastructure, instead of only TestCategory=UnitTest.
    [switch]$ExcludeInfrastructureTests,
    [string]$TestFilter = "TestCategory=UnitTest"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$integrationRoot = Join-Path $repositoryRoot "CrossDomain.Integration"

if (-not (Test-Path -LiteralPath $Solution -PathType Leaf)) {
    throw "Solution file was not found: '$Solution'."
}

$solutionPath = (Resolve-Path -LiteralPath $Solution).Path
$solutionRoot = Split-Path -Parent $solutionPath
$settingsPath = Join-Path $solutionRoot "CodeCoverage.runsettings"
if (-not (Test-Path $settingsPath)) {
    $settingsPath = Join-Path $integrationRoot "CodeCoverage.runsettings"
}

if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $solutionRoot "TestResults\UnitTestCoverage"
}

$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)

if ($ExcludeInfrastructureTests) {
    $excludedCategories = @(
        "IntegrationTest", "IntegrationTest_NA", "IntegrationTestWIP", "DocGenIntegration", "TechnicalExploration", "TechnicalExploration_Das",
        "DataDependent", "DataDependentExploratoryDAT", "Tooling", "Exploratory"
    )
    # DataFix_* categories (DataFix_R10a, DataFix_LiveFix, ...) are matched by prefix so new ones are excluded automatically.
    $TestFilter = "FullyQualifiedName!~IntegrationTests&TestCategory!~DataFix&" +
        (($excludedCategories | ForEach-Object { "TestCategory!=$_" }) -join "&")
}

if ($Build) {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    $msbuild = if (Test-Path $vswhere) {
        # Prefer Visual Studio 2022 (17.x): these legacy solutions need its Azure/.NET Framework tooling.
        $found = & $vswhere -latest -version "[17.0,18.0)" -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe" | Select-Object -First 1
        if (-not $found) {
            $found = & $vswhere -latest -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe" | Select-Object -First 1
        }
        $found
    }
    if (-not $msbuild) {
        throw "MSBuild.exe was not found (vswhere). Install Visual Studio with MSBuild."
    }

    Write-Host "Cleaning and building $solutionPath ($Configuration)..."
    & $msbuild $solutionPath /restore /t:Clean /m /v:q /nologo "/p:Configuration=$Configuration"
    if ($LASTEXITCODE -ne 0) { throw "MSBuild clean failed with exit code $LASTEXITCODE." }
    & $msbuild $solutionPath /restore /t:Build /m /v:q /nologo "/p:Configuration=$Configuration"
    if ($LASTEXITCODE -ne 0) { throw "MSBuild build failed with exit code $LASTEXITCODE." }
}

$testProjects = @(
    Select-String -Path $solutionPath -Pattern '^Project\("\{[^}]+\}"\)\s*=\s*"[^"]*",\s*"([^"]+\.csproj)"' |
        ForEach-Object { Join-Path $solutionRoot $_.Matches[0].Groups[1].Value } |
        Where-Object { (Split-Path -Leaf $_) -match '(?i)Tests?\.csproj$' -and (Test-Path $_) } |
        Sort-Object -Unique
)

$assemblies = @(
    foreach ($projectFile in $testProjects) {
        $projectDirectory = Split-Path -Parent $projectFile
        $assemblyName = ([xml](Get-Content -LiteralPath $projectFile)).Project.PropertyGroup.AssemblyName |
            Where-Object { $_ } | Select-Object -First 1
        if (-not $assemblyName) {
            $assemblyName = [System.IO.Path]::GetFileNameWithoutExtension($projectFile)
        }

        $outputPath = Join-Path $projectDirectory "bin\$Configuration"
        $assembly = Get-ChildItem -Path $outputPath -File -Filter "$assemblyName.dll" -Recurse -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($assembly) {
            $assembly
        }
        else {
            Write-Warning "Built assembly not found for $(Split-Path -Leaf $projectFile) under '$outputPath'. Build it first (or use -Build)."
        }
    }
)

if ($assemblies.Count -eq 0) {
    throw "No built test assemblies were found for '$solutionPath' (configuration '$Configuration'). Build the solution first or use -Build."
}

Write-Host "Found $($assemblies.Count) test assemblies:"
$assemblies | ForEach-Object { Write-Host "  $($_.FullName)" }

if ($ListOnly) {
    return
}

$coverageCommand = Get-Command "dotnet-coverage" -ErrorAction SilentlyContinue
if (-not $coverageCommand) {
    throw "dotnet-coverage was not found. Install it with: dotnet tool install --global dotnet-coverage"
}

$vstestPath = Get-Command "vstest.console.exe" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty Source

if (-not $vstestPath) {
    $visualStudioRoots = @(
        (Join-Path $env:ProgramFiles "Microsoft Visual Studio"),
        (Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio")
    )

    foreach ($visualStudioRoot in $visualStudioRoots) {
        if (-not (Test-Path $visualStudioRoot)) {
            continue
        }

        $vstest = Get-ChildItem -Path $visualStudioRoot -Recurse -File -Filter "vstest.console.exe" -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match "\\CommonExtensions\\Microsoft\\TestWindow\\vstest\.console\.exe$" } |
            Select-Object -First 1

        if ($vstest) {
            $vstestPath = $vstest.FullName
            break
        }
    }
}

if (-not $vstestPath) {
    throw "vstest.console.exe was not found. Install Visual Studio with the .NET desktop build tools and test platform."
}

if (-not (Test-Path $settingsPath)) {
    throw "Coverage settings file was not found: '$settingsPath'."
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$reportPath = Join-Path $OutputDirectory "unit-test-coverage.cobertura.xml"
$logPath = Join-Path $OutputDirectory "dotnet-coverage.log"
$resultsPath = Join-Path $OutputDirectory "TestResults"
New-Item -ItemType Directory -Path $resultsPath -Force | Out-Null

$usedDriveNames = @(Get-PSDrive -PSProvider FileSystem | ForEach-Object { $_.Name })
$mappedDrive = $null
foreach ($candidateDrive in @("Z", "Y", "X", "W", "V", "U", "T", "S", "R", "Q", "P", "O", "N")) {
    if ($usedDriveNames -contains $candidateDrive) {
        continue
    }

    $driveName = "$candidateDrive`:"
    & subst.exe $driveName $repositoryRoot
    if ($LASTEXITCODE -eq 0 -and (Test-Path "$driveName\")) {
        $mappedDrive = $driveName
        break
    }
}

if (-not $mappedDrive) {
    throw "Could not create a temporary short drive mapping for '$repositoryRoot'. Free a drive letter from Z: through N: and try again."
}

$shortRepositoryRoot = "$mappedDrive\"
$shortAssemblies = @(
    $assemblies | ForEach-Object {
        $relativePath = $_.FullName.Substring($repositoryRoot.Length).TrimStart("\")
        Join-Path $shortRepositoryRoot $relativePath
    }
)
$shortSettingsPath = Join-Path $shortRepositoryRoot $settingsPath.Substring($repositoryRoot.Length).TrimStart("\")

$vstestArguments = @(
    $shortAssemblies
    "/TestCaseFilter:$TestFilter"
    "/ResultsDirectory:$resultsPath"
    "/Logger:Console;Verbosity=normal"
)

Push-Location $shortRepositoryRoot
try {
    & $coverageCommand.Source collect `
        --settings $shortSettingsPath `
        --output $reportPath `
        --output-format cobertura `
        --log-file $logPath `
        --log-level Info `
        $vstestPath @vstestArguments

    $testExitCode = $LASTEXITCODE
    if (-not (Test-Path $reportPath)) {
        throw "Coverage collection did not produce a report. See '$logPath'."
    }

    if ($Html) {
        $htmlPath = Join-Path $OutputDirectory "html"
        $reportGeneratorArguments = @(
            "-reports:$reportPath"
            "-targetdir:$htmlPath"
            "-reporttypes:Html;MarkdownSummaryGithub;TextSummary"
            "-assemblyfilters:-*Tests;-*UnitTests*;-FluentAssertions*;-MessagePack*;-NServiceBus.*;-Polly;-TestApiCore"
            "-classfilters:-*.Migrations.*;-*.Migrations"
    "-filefilters:-*.Designer.cs;-*.g.cs;-*.generated.cs;-*\Web References\*;-*Tests\*;-*Test\*;-*Migrations\*;-*Migration\*"
        )

        $reportGeneratorDll = Get-ChildItem -Path (Join-Path $env:USERPROFILE ".dotnet\tools\.store\dotnet-reportgenerator-globaltool") -Recurse -Filter "ReportGenerator.dll" -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match "\\net(8|9|10)" } |
            Select-Object -First 1

        if ($reportGeneratorDll) {
            & dotnet $reportGeneratorDll.FullName @reportGeneratorArguments
        }
        elseif (Get-Command "reportgenerator" -ErrorAction SilentlyContinue) {
            & reportgenerator @reportGeneratorArguments
        }
        else {
            Write-Warning "ReportGenerator not found; skipping HTML. Install: dotnet tool install --global dotnet-reportgenerator-globaltool"
        }
    }
}
finally {
    Pop-Location
    & subst.exe $mappedDrive /d
}

$coverageXml = New-Object System.Xml.XmlDocument
$coverageXml.Load($reportPath)
$repositoryRootPrefix = [System.IO.Path]::GetFullPath($repositoryRoot).TrimEnd("\") + "\"
$lineHitsByFile = @{}

foreach ($class in $coverageXml.SelectNodes("//class")) {
    $sourceFile = $class.GetAttribute("filename")
    if ([string]::IsNullOrWhiteSpace($sourceFile)) {
        continue
    }

    if ([System.IO.Path]::IsPathRooted($sourceFile)) {
        $sourcePath = [System.IO.Path]::GetFullPath($sourceFile)
        $mappedDrivePrefix = "$mappedDrive\"
        if ($mappedDrive -and $sourcePath.StartsWith($mappedDrivePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            $sourcePath = Join-Path $repositoryRoot $sourcePath.Substring($mappedDrivePrefix.Length)
        }
    }
    else {
        $sourcePath = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot $sourceFile))
    }

    $sourcePath = $sourcePath.Replace("/", "\")
    if (-not $sourcePath.StartsWith($repositoryRootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        continue
    }

    $relativeSourcePath = $sourcePath.Substring($repositoryRootPrefix.Length)
    if ($relativeSourcePath -match "(?i)(^|\\)[^\\]*(?:Tests?|Migrations?)(\\|$)|\.Designer\.cs$|\.g\.cs$|\.generated\.cs$|(^|\\)Web References(\\|$)") {
        continue
    }

    if (-not $lineHitsByFile.ContainsKey($sourcePath)) {
        $lineHitsByFile[$sourcePath] = @{}
    }

    $fileLineHits = $lineHitsByFile[$sourcePath]
    foreach ($line in $class.SelectNodes("./lines/line")) {
        $lineNumber = 0
        $hits = 0
        if (-not [int]::TryParse($line.GetAttribute("number"), [ref]$lineNumber)) {
            continue
        }
        [void][int]::TryParse($line.GetAttribute("hits"), [ref]$hits)

        if (-not $fileLineHits.ContainsKey($lineNumber) -or $hits -gt $fileLineHits[$lineNumber]) {
            $fileLineHits[$lineNumber] = $hits
        }
    }
}

$coveredProductionLines = 0
$totalProductionLines = 0
foreach ($fileLineHits in $lineHitsByFile.Values) {
    foreach ($hits in $fileLineHits.Values) {
        $totalProductionLines++
        if ($hits -gt 0) {
            $coveredProductionLines++
        }
    }
}

if ($totalProductionLines -eq 0) {
    throw "No in-repository production source lines were found in '$reportPath'."
}

$productionLineCoverage = 100.0 * $coveredProductionLines / $totalProductionLines
$rawLineCoverage = 100.0 * [double]$coverageXml.DocumentElement.GetAttribute("line-rate")
Write-Host "Coverage report: $reportPath"
if ($Html) {
    Write-Host "HTML report: $(Join-Path $htmlPath 'index.html')"
}
Write-Host ("Unit-test production line coverage (in-repository; tests, generated files, and migrations excluded): {0:N2}% ({1:N0} / {2:N0} lines)" -f $productionLineCoverage, $coveredProductionLines, $totalProductionLines)
Write-Host ("Raw Cobertura line coverage (all included sources): {0:N2}%" -f $rawLineCoverage)
if ($testExitCode -ne 0) {
    throw "VSTest returned exit code $testExitCode. The coverage report was generated, but one or more tests failed. See '$logPath'."
}
