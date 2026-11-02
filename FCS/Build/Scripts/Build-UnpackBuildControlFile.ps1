param (
    [Parameter(Mandatory=$true)][String]$configuration,
    [Parameter(Mandatory=$true)][String]$buildRoot,
    [Parameter(Mandatory=$true)][String]$BCOverride
)

if ( $BCOverride -notmatch "\$\(BC_Override\)" ) {
    Write-Host "Found BC Override string, using that instead of files in version control"
    Write-Host $BCOverride
    $settings = @{ }
    $buildControl = ConvertFrom-Json $BCOverride
    $buildControl | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    
        $value = $buildControl.$_
        Write-Host "Setting ${_} to ${value}"
        $settings[$_] = $value
    }
}
else {
    $buildControlFolder = "${buildRoot}/Build/BuildControl"
    $buildControlFilePath = "${buildControlFolder}/BuildControl.json"
    Write-Host "Testing for ${buildControlFilePath} with configuration ${configuration}"
      
    if (! (Test-Path -PathType Leaf $buildControlFilePath)) {
        throw "Build Control file not found"
    }
      
    $settings = @{ }
    @($buildControlFilePath, "${buildControlFolder}/BuildControl.${configuration}.json") | ForEach-Object {
      
        Write-Host "Looking for $_"
        if (Test-Path -PathType Leaf $_) {
            Write-Host "Reading ${_}"
            $buildControl = Get-Content -Raw $_ | ConvertFrom-Json
      
            $buildControl | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
                $value = $buildControl.$_
                Write-Host "Setting ${_} to ${value}"
                $settings[$_] = $value
            }
        }
        else {
            Write-Host "$_ not found, skipping"
        }
    }
}
         
$settings.Keys | ForEach-Object {
    $name = "BC_" + $_
    $value = $settings[$_]
    Write-Host "Setting build variable ${name} to ${value}"
    Write-Host "##vso[task.setvariable variable=${name}]${value}" 
}
    
Write-Host 'Writing file to ArtifactsStagingDirectory'
$settings | ConvertTo-Json | Set-Content "${env:Build_ArtifactStagingDirectory}/BuildControl.json"
