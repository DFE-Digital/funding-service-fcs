######################################################################################################################
#
# This script will actually deploy the entire thing to the AT environment so be careful everytime you run this thing!
#
######################################################################################################################

Param(
	 [string]$ClientID,
	 [string]$AppKey
)

& $PSScriptRoot\..\BuildScripts\Deploy-FctCrmAppUser-Pipeline.ps1 -BuildDir "$PSScriptRoot\.." `
                                                  -Configuration "AT" `
                                                  -OrganizationUniqueName "AcceptanceTest" `
                                                  -OrganizationFriendlyName "Acceptance Test" `
                                                  -CrmUrl "https://fcs-at.crm4.dynamics.com" `
												  -ClientId "$ClientID" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Unmanaged" 
