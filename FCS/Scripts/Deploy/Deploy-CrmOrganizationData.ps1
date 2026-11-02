param
(
    [string]$Username,
    [string]$Password,
    [string]$CrmUrl,
    [string]$CrmOrgName,
    [string]$PackageDirectory,
    [string]$PackageFile
)

$Cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList $Username, ($Password | ConvertTo-SecureString -asPlainText -Force)

$RemoveConnectorSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Xrm.Tooling.Connector -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Xrm.Tooling.Connector
    $RemoveSnapInWhenDone = $True
}

$RemovePackageDeploymentSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Xrm.Tooling.PackageDeployment -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Xrm.Tooling.PackageDeployment
    $RemovePackageDeploymentSnapInWhenDone = $True
}

$CRMConn = Get-CrmConnection -ServerUrl $CrmUrl -OrganizationName $CrmOrgName -Credential $Cred

Import-CrmPackage –CrmConnection $CRMConn –PackageDirectory $PackageDirectory –PackageName $PackageFile -Verbose
