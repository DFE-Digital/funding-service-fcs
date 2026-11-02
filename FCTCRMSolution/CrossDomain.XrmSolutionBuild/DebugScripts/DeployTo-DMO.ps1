######################################################################################################################
#
# This script will actually deploy the entire thing to the DMO environment so be careful everytime you run this thing!
#
######################################################################################################################

Param(
	 [string]$ClientID,
	 [string]$AppKey
)

& $PSScriptRoot\..\BuildScripts\Deploy-FctCrmAppUser-Pipeline.ps1 -BuildDir "$PSScriptRoot\.." `
												  -Configuration "DMO" `
                                                  -OrganizationUniqueName "TrainingDev" `
                                                  -OrganizationFriendlyName "TrainingDev" `
                                                  -CrmUrl "https://fcs-dev-mo.crm4.dynamics.com" `
												  -ClientId "$ClientID" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Managed" 
                                                 