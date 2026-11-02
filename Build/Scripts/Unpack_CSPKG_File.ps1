param (
    [Parameter(Mandatory=$true)][String]$package,
    [Parameter(Mandatory=$true)][String]$outputVariable,
    [Parameter(Mandatory=$false)][String]$jobName = ''
)

$ErrorActionPreference = "Stop"

$cspkg = Get-Item -Path $package

$cszip = $cspkg.FullName + ".zip"
$cspkgtemp = $env:AGENT_TEMPDIRECTORY + "/" + (New-Guid).ToString()

Write-Host Unpacking $cspkg.Name

Rename-Item $cspkg.FullName $cszip
Expand-Archive -Force -Path $cszip -DestinationPath $cspkgtemp
Rename-Item $cszip $cspkg.FullName

$cxxs = Get-ChildItem -Path $cspkgtemp -Filter "*.cssx"

Write-Host Unpacking $cxxs.Name

$cxxsZip = $cxxs.FullName + ".zip"
Rename-Item $cxxs.FullName $cxxsZip
Expand-Archive -Path $cxxsZip -DestinationPath $cxxs.FullName 

$appRoot = $env:AGENT_TEMPDIRECTORY + "/" + (New-Guid).ToString()
$jobDirectory = $appRoot 
if ($jobName -ne "") {$jobDirectory = $jobDirectory + "/app_data/jobs/continuous/" + $jobName}
New-Item -ItemType Directory -Path $jobDirectory

Move-Item ($cxxs.FullName + "/appRoot/*") $jobDirectory

Write-Host ("##vso[task.setvariable variable=" + $outputVariable + ";]" + $appRoot)
