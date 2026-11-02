param (
    [Parameter(Mandatory=$true)][String]$configuration,
    [Parameter(Mandatory=$true)][String]$stageFolder
)

$buildControlFilePath = "${stageFolder}/../BuildControl.json"
Write-Host "Testing for ${buildControlFilePath}"

if (! (Test-Path -PathType Leaf $buildControlFilePath)) {
    throw "Build Control file not found"
}

$settings = @{ }
@($buildControlFilePath, "${buildControlFolder}/BuildControl.${configuration}.json") | ForEach-Object {

    if (Test-Path -PathType Leaf $_) {

        Write-Host "Reading ${_}"
        $buildControl = Get-Content -Raw $_ | ConvertFrom-Json

        $buildControl | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {              

            $value = $buildControl.$_
            Write-Host "Setting ${_} to ${value}"
            $settings[$_] = $value
        }
    }
}

Write-Host "Read all files, now outputting to vso"

$settings.Keys | ForEach-Object {
    $name = "BC_" + $_
    $value = $settings[$_]
    Write-Host "Setting ${name} to ${value}"
    Write-Host "##vso[task.setvariable variable=${name}]${value}" 
}
