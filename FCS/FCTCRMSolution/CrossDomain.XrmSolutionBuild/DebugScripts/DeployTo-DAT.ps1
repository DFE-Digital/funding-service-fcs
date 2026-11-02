######################################################################################################################
#
# This script will actually deploy the entire thing to the DAT environment so be careful everytime you run this thing!
#
######################################################################################################################

Param(
	 [string]$ClientID,
	 [string]$AppKey
)

& $PSScriptRoot\..\BuildScripts\Deploy-FctCrmAppUser-Pipeline.ps1 -BuildDir "$PSScriptRoot\.." `
                                                  -Configuration "AT" `
                                                  -OrganizationUniqueName "AcceptanceTestDev" `
                                                  -OrganizationFriendlyName "Acceptance Test" `
                                                  -CrmUrl "https://fcs-dev-at.crm4.dynamics.com" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -ClientId "$ClientID" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Unmanaged" 
                                                 

