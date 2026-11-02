$moduleName = "Microsoft.Xrm.Data.Powershell"
$moduleVersion = "2.8.1.3"

if (!(Get-Module -ListAvailable -Name $moduleName )) {
Write-host "Module Not found, installing now"
$moduleVersion
Install-Module -Name $moduleName -MinimumVersion $moduleVersion -Force
}
else
{
Write-host "Module Found"
}


$SolutionFilesFolder = "$PSScriptRoot\SolutionFiles"
$ManagedSolutionsFolder = "$SolutionFilesFolder\Managed"
$UnmanagedSolutionsFolder = "$SolutionFilesFolder\Unmanaged"
$SolutionPackager = "$PSScriptRoot\Tools\SolutionPackager.exe"
$solutionName = "CIBERSFAFCTSolution"
$solutionNameManaged = "CIBERSFAFCTSolution_managed"
$CrmUrl = "https://fcs-dev.crm4.dynamics.com"
$Configuration = "DAT"


$DeploymentAdminUsername = Get-Content Env:DeploymentAdminUsername$Configuration
$DeploymentAdminPassword = Get-Content Env:DeploymentAdminPassword$Configuration

$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$DeploymentAdminUsername", ($DeploymentAdminPassword | ConvertTo-SecureString -asPlainText -Force)
$CRMConn = Connect-CrmOnline  -Credential $cred -ServerUrl $CrmUrl

# Increase timeout for all connections to 5 minutes
Set-CrmConnectionTimeout -conn $CRMConn -TimeoutInSeconds 300

#$CRMConn = Get-CrmConnection `
#    -MaxCrmConnectionTimeOutMinutes 60 `
#    -ConnectionString "AuthType=Office365;UserName=$DeploymentAdminUsername;Password=$DeploymentAdminPassword;url=https://fcs-dev-at.crm4.dynamics.com" `
#    -Verbose

Export-CrmSolution -conn $CRMConn -SolutionName "$solutionName" -SolutionFilePath "$PSScriptRoot\Solutions\Unmanaged" -SolutionZipFileName "$solutionName.zip"
Export-CrmSolution -conn $CRMConn -SolutionName "$solutionName" -SolutionFilePath "$PSScriptRoot\Solutions\Managed" -SolutionZipFileName "$solutionNameManaged.zip" -Managed

Write-Host [(Get-Date)] "Solution Files Folder $SolutionFilesFolder"
Write-Host [(Get-Date)] "Solution Packager $SolutionPackager"

Get-ChildItem -LiteralPath "$PSScriptRoot\Solutions\Unmanaged" -Filter *.zip | `
ForEach-Object{
    $ArgumentsUnmanaged = "/action:Extract /zipfile:$PSScriptRoot\Solutions\Unmanaged\$_ /folder:$UnmanagedSolutionsFolder\$_ /packagetype:Unmanaged"
    Write-Host [(Get-Date)] "Arguments $ArgumentsUnmanaged"
    Start-Process -Wait $SolutionPackager $ArgumentsUnmanaged
}

Get-ChildItem -LiteralPath "$PSScriptRoot\Solutions\Managed" -Filter *.zip | `
ForEach-Object{
    $ArgumentsManaged = "/action:Extract /zipfile:$PSScriptRoot\Solutions\Managed\$_ /folder:$ManagedSolutionsFolder\$_ /packagetype:Managed"
    Write-Host [(Get-Date)] "Arguments $ArgumentsManaged"
    Start-Process -Wait $SolutionPackager $ArgumentsManaged
} 