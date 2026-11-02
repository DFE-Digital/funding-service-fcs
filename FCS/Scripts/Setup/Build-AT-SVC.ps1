##########################
# Script Variables
##########################
$ServiceAccountPwd = "L3m0nad3!#"

$OrgSvcName = "Organization.OrganizationService"
$OrgSvcPort = 100
$OrgSvcAccount = "fctdev\orgsvc"

$ContDocSvcName = "CrossDomain.DocumentService"
$ContDocSvcPort = 101
$ContDocSvcAccount = "fctdev\contmgrsvc"

$CrmSvcName = "Contracts.CrmService"
$CrmSvcPort = 102
$CrmSvcAccount = "fctdev\crmsvc"


Write-Host -ForegroundColor Yellow "Creating $OrgSvcName web site and app pool ..."
Invoke-Expression "& '$PSScriptRoot\Create-Website.ps1' -SiteName $OrgSvcName -Port $OrgSvcPort $true $true -AppPoolAccount $OrgSvcAccount -AppPoolPassword $ServiceAccountPwd"

Write-Host -ForegroundColor Yellow "Creating $ContDocSvcName web site and app pool ..."
Invoke-Expression "& '$PSScriptRoot\Create-Website.ps1' -SiteName $ContDocSvcName -Port $ContDocSvcPort $true $true -AppPoolAccount $ContDocSvcAccount -AppPoolPassword $ServiceAccountPwd"

Write-Host -ForegroundColor Yellow "Creating $CrmSvcName web site and app pool ..."
Invoke-Expression "& '$PSScriptRoot\Create-Website.ps1' -SiteName $CrmSvcName -Port $CrmSvcPort $true $true -AppPoolAccount $CrmSvcAccount -AppPoolPassword $ServiceAccountPwd"
