######################################################################################################################
#
# This script will actually deploy the entire thing to the MO environment so be carefull everytime you run this thing!
#
######################################################################################################################

Param(
	 [string]$ClientID,
	 [string]$AppKey
)

& $PSScriptRoot\..\BuildScripts\Deploy-FctCrmAppUser-Pipeline.ps1 -BuildDir "$PSScriptRoot\.." `
                                                  -Configuration "MO" `
                                                  -OrganizationUniqueName "MO" `
                                                  -OrganizationFriendlyName "MO" `
                                                  -CrmUrl "https://fcs-mo.crm4.dynamics.com" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -ClientId "$ClientID" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Unmanaged" 
