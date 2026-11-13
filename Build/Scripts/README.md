# Unit test coverage

Use `Run-UnitTestCodeCoverage.ps1` to run the unit tests of a single solution and collect a local line-coverage report (optionally with an HTML report) before checking in changes. It works on any solution in the FCT repository.

## Prerequisites

- A solution (`.sln`) in the repository. Test projects are discovered from the solution: every project whose file name ends in `Test.csproj` or `Tests.csproj`.
- Build the solution first, or pass `-Build` to have the script clean and build it with the Visual Studio MSBuild located through `vswhere`.
- Install the `dotnet-coverage` global tool if it is not already available:

  ```powershell
  dotnet tool install --global dotnet-coverage
  ```

- Install Visual Studio with the .NET desktop build tools and test platform so `vstest.console.exe` is available.
- For `-Html`, install ReportGenerator:

  ```powershell
  dotnet tool install --global dotnet-reportgenerator-globaltool
  ```

## Run

From the repository root, pass the solution to analyse:

```powershell
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution CrossDomain.Integration\CrossDomain.Integration.B.sln
```

Typical full run (clean build, skip infrastructure-dependent tests, produce HTML):

```powershell
.\Build\Scripts\Run-UnitTestCodeCoverage.ps1 -Solution CrossDomain.Integration\CrossDomain.Integration.B.sln -Build -Html -ExcludeInfrastructureTests
```

Parameters:

| Parameter | Description |
|---|---|
| `-Solution` | Required. Path to the solution (absolute, or relative to the current directory). |
| `-Configuration` | Build configuration of the test assemblies. Default `Debug`. |
| `-OutputDirectory` | Where results are written. Default `<solution folder>\TestResults\UnitTestCoverage`. |
| `-Build` | Clean and build the solution before testing. |
| `-Html` | Also generate an HTML report; its full path is printed at the end. |
| `-TestFilter` | VSTest case filter. Default `TestCategory=UnitTest`. |
| `-ExcludeInfrastructureTests` | Excludes integration tests and categories that need external infrastructure (SQL, storage, etc.). |
| `-ListOnly` | List the test assemblies that would be used, without running tests. |

Coverage settings come from `CodeCoverage.runsettings` in the solution folder, falling back to `CrossDomain.Integration\CodeCoverage.runsettings`.

## Read the results

Outputs are written to the output directory:

- `html\index.html` - HTML report (with `-Html`).
- `unit-test-coverage.cobertura.xml` - Cobertura report.
- `dotnet-coverage.log` - collection log.

The script prints two percentages:

- **Unit-test production line coverage** counts distinct source lines in the repository, excluding test, generated, migration, and web-reference sources, and source outside the repository. This is the useful figure for tracking unit coverage of the solution's production code.
- **Raw Cobertura line coverage** is the percentage from the complete report, including any external sources in that report. Its denominator differs, so it may be lower.

Coverage is reported even if one or more tests fail, provided a report was generated. The script then exits with an error and points to the log; resolve test failures before relying on the figure. The production-source percentage is informational and is not currently enforced as a CI threshold.
