#Import-Module Ciber.Xrm.Ci.PowerShell.dll

Set-Location "C:\Dev\FCT\FCTCrmConfig.Tests\FCTCrmConfig.AcceptanceTests\Powershell"
Import-Module ".\Ciber.Xrm.Ci.PowerShell.dll"
 
$CrmUrl = [Environment]::GetEnvironmentVariable("CrmUrl","User")
$CrmOrg = [Environment]::GetEnvironmentVariable("CrmOrg","User")
$CrmUserName = [Environment]::GetEnvironmentVariable("CrmUserName","User")
$CrmPasswordPath = [Environment]::GetEnvironmentVariable("CrmPasswordPath","User")
$UnPackageDirectory = [Environment]::GetEnvironmentVariable("UnPackageDirectory","User")

$CrmUrl = $CrmUrl + "/" + $CrmOrg
#Write-Host $CrmUrl 

$secure_string = cat $CrmPasswordPath | ConvertTo-SecureString
$tempCredential = New-Object System.Management.Automation.PsCredential “None”, $secure_string
$password = $tempCredential.GetNetworkCredential().Password

#Write-Host $CrmUserName 
#Write-Host $password 

$solution = $UnPackageDirectory + "Default_1_0\"

#Export-XrmSolution -ConnectionString "Url=$CrmUrl; Username=$CrmUserName; Password=$password;" -SolutionName "Default_1_0" -OutputFolder $UnPackageDirectory
Expand-XrmSolution -SolutionFile c:\temp\Default_1_0.zip -OutputFolder $solution

