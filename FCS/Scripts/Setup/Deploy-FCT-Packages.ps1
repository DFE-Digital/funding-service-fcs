param
(
[Parameter (Mandatory=$True)] [string]$environment
)

Write-Host("***Deploying FCT Packages***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

# For each service do the following
# Create a profile for the custom code
Write-Host ("Deployment of Applications in JBOSS")


Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

. $SetupPowershellScriptLocation\Deploy-Integration-Pattern.ps1 $environment

. $SetupPowershellScriptLocation\Deploy-OrganisationService.ps1 $environment

. $SetupPowershellScriptLocation\Deploy-ContractRequestDataLoad.ps1 $environment

. $SetupPowershellScriptLocation\Deploy-ContractsDocumentGeneration.ps1 $environment

#End Create a profile for the custom code


Write-Host("Finished Deploying FCT Packages")


Set-Location ("C:\")

Write-Host("###Deploying FCT Packages###")