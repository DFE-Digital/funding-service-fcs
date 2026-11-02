$PackageDirectory = $Env:TF_BUILD_BINARIESDIRECTORY
$PackageFile = "FCTCrmConfig.ConfigPackage.dll"

$CrmServerName = "fct-ci-crm-01"
$CrmServer = "$CrmServerName.fctdev.local"
$DeploymentUser = "fctdev\CI-CRMDeployment"
$DeploymentPassword = ""
$DiscoveryServer = $CrmServer
$CrmUrl = "http://$CrmServer"
$CrmOrg = "ContinuousIntegration"
$DisplayName = "Continuous Integration"
$SqlServerName = $CrmServer
$SSRSUrl = "http://$CrmServer/ReportServer"

$BaseCurrencyCode = "GBP"
$BaseCurrencyName = "Pound Sterling"
$BaseCurrencySymbol = "£"
$BaseCurrencyPrecision = "2"

$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $DeploymentUser, ($DeploymentPassword | ConvertTo-SecureString -asPlainText -Force)

#Invoke-Command -ComputerName $CrmServerName -Credential $Cred -FilePath "$PSScriptRoot\Deploy-CrmOrganization.ps1" -ArgumentList $Cred, $CrmOrg, $DisplayName, $CrmServer, $CrmServer, $SSRSUrl, $True, $ComputerName, $BaseCurrencyCode, $BaseCurrencyName, $BaseCurrencySymbol, $BaseCurrencyPrecision
Invoke-Expression "& '$PSScriptRoot\Deploy-CrmOrganizationData.ps1' -Username $DeploymentUser -Password $DeploymentPassword -CrmUrl $CrmUrl -CrmOrgName $CrmOrg -PackageDirectory '$PackageDirectory' -PackageFile $PackageFile"
