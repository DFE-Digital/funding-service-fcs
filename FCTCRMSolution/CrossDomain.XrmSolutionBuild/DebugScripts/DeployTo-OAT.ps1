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
												  -Configuration "OAT" `
                                                  -OrganizationUniqueName "SkillsFundingAgency" `
                                                  -OrganizationFriendlyName "Skills Funding Agency" `
                                                  -CrmUrl "https://fcs-oat.crm4.dynamics.com" `
												  -AadInstance "https://login.microsoftonline.com/" `
												  -TenantId "educationgovuk.onmicrosoft.com" `
												  -ClientId "$ClientID" `
												  -AppKey "$AppKey" `
												  -ManagedSolution "Managed" 
                                                 