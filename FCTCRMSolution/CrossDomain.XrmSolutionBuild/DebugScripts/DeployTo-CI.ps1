######################################################################################################################
#
# This script will actually deploy the entire thing to the CI environment so be careful everytime you run this thing!
#
######################################################################################################################

Param(
	 [string]$ClientID,
	 [string]$AppKey
)

& $PSScriptRoot\..\BuildScripts\Deploy-FctCrmAppUser-Pipeline.ps1 -BuildDir "$PSScriptRoot\.." `
                                                  -Configuration "CI" `
                                                  -OrganizationUniqueName "ContinuousIntegration" `
                                                  -OrganizationFriendlyName "Continuous Integration" `
                                                  -CrmUrl "https://fcs-ci.crm4.dynamics.com" `
												  -ClientId "$ClientID" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Unmanaged"                                                                                                

