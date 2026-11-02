param (
    [Parameter(Mandatory = $true)][String]$migrationsFolder,
    [Parameter(Mandatory = $true)][String]$stageFolder,
    [Parameter(Mandatory = $true)][String]$filter,
    [Parameter(Mandatory = $true)][String]$configuration
)

Set-Location $migrationsFolder

Write-Host Running in (Get-Location)

#Copy-Item -Path "${StageFolder}/../EntityFramework.Migrate/migrate.exe" -Destination migrate.exe
Copy-Item -Path "${StageFolder}/../EntityFramework.Migrate/*" -Destination . -Recurse -Force

(Get-ChildItem | Where-Object { $_ -imatch $filter }).BaseName | ForEach-Object {
    write-host $_
    ./migrate.exe $_ /startupConfigurationFile=.\$configuration | Out-String | Set-Variable -name eferror
    write-host $eferror
    if ($eferror.Contains("ERROR:")) {
        Write-host "ERROR FOUND, ABORTING."
        exit 1
    }
}
