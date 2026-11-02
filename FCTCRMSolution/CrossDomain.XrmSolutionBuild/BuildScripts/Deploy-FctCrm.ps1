param
(
    [Parameter(Mandatory=$True)]
    [string]$BuildDir,

    [Parameter(Mandatory=$True)]
    [string]$Configuration,

    [Parameter(Mandatory=$False)]
    [string]$DeploymentServiceUrl,

    [Parameter(Mandatory=$False)]
    [string]$SqlServerName,

    [Parameter(Mandatory=$False)]
    [string]$SrsUrl,

    [Parameter(Mandatory=$False)]
    [string]$OrganizationUniqueName,

    [Parameter(Mandatory=$False)]
    [string]$OrganizationFriendlyName,

    [Parameter(Mandatory=$True)]
    [string]$CrmUrl,

	[Parameter(Mandatory=$True)]
    [string]$Pass,

    [Parameter()]
    [switch]$DropOrganization,

    [Parameter(Mandatory=$False)]
    [string]$ManagedSolution = "Managed",

    [Parameter(Mandatory=$False)]
    [bool]$SqmIsEnabled = $False,

    [Parameter(Mandatory=$False)]
    [string]$OrganizationBaseCurrencyCode = "GBP",

    [Parameter(Mandatory=$False)]
    [string]$OrganizationBaseCurrencyName = "Pound Sterling",

    [Parameter(Mandatory=$False)]
    [int]$OrganizationBaseCurrencyPrecision = 2,

    [Parameter(Mandatory=$False)]
    [string]$OrganizationBaseCurrencySymbol = "£",

    [Parameter(Mandatory=$False)]
    [string]$OrganizationBaseLanguageCode = "1033",

    [Parameter(Mandatory=$False)]
    [string]$SqlCollation = "Latin1_General_CI_AI",

    [Parameter(Mandatory=$False)]
    [string]$PackageFile = "FCTCrmConfig.ConfigPackage.dll"
)

function DeployCRMOrganizationData
{
    param
    (
        [PSCredential]$Cred,
        [string]$CrmUrl,
        [string]$CrmOrgName,
        [string]$PackageDirectory,
        [string]$PackageFile
    )

	$moduleName = "Microsoft.Xrm.Data.Powershell"
	$moduleVersion = "2.8.1.3"

	if (!(Get-Module -ListAvailable -Name $moduleName )) {
		Write-host "Module Not found, installing now"
		$moduleVersion
		Install-Module -Name $moduleName -MinimumVersion $moduleVersion -Force
	}
	else
	{
	    Write-host "Module found" $moduleName
		Import-Module $moduleName
	}

    # if (-not (Get-PSSnapin -Name Microsoft.Xrm.Tooling.PackageDeployment -ErrorAction SilentlyContinue))
    # {
        # try
        # {
            # Add-PSSnapin Microsoft.Xrm.Tooling.PackageDeployment -ErrorAction Stop
        # }
        # catch
        # {
             Import-Module "$BuildDir\Microsoft.Xrm.Tooling.PackageDeployment.Powershell.dll"
        # }
    # }

    $CRMConn = Connect-CrmOnline  -Credential $cred -ServerUrl $CrmUrl

	Write-host "Preparing to import"
    Import-CrmPackage `
    -Verbose `
    -PackageName $PackageFile `
    -PackageDirectory $PackageDirectory `
    -TimeOut '01:00:00' `
    -CrmConnection $CRMConn `
	-EnabledAsyncForSolutionImport 

}


$DeploymentAdminUsername = $env:DeploymentAdminUsernameDAT
$DeploymentAdminPassword = $Pass
Write-Host [(Get-Date)] "Credentials $DeploymentAdminUsername : $DeploymentAdminPassword"

$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$DeploymentAdminUsername", ($DeploymentAdminPassword | ConvertTo-SecureString -asPlainText -Force)

# Pack solution files and place them in correct directory
$SolutionFilesFolder = "$BuildDir\Solutions"

New-Item -ItemType Directory -Force -Path $SolutionFilesFolder

Write-Host [(Get-Date)] "Solution Files Folder  $SolutionFilesFolder"

Get-ChildItem -LiteralPath $SolutionFilesFolder\$ManagedSolution -Filter *.zip | `
ForEach-Object {
    $OutputFile = "$BuildDir\PkgFolder\Solutions\$_" -replace "_managed", ""
	Copy-item -force $SolutionFilesFolder\$ManagedSolution\$_ $OutputFile;
}

# Powershell File Moving - to allow the same package to be run with multiple ImportConfig Files - other option is to have two config packages
Copy-item -force "$BuildDir\PkgFolder\ImportConfigData.xml" "$BuildDir\PkgFolder\ImportConfig.xml";
DeployCrmOrganizationData -Cred $Cred -CrmUrl $CrmUrl -CrmOrgName $OrganizationUniqueName -PackageDirectory $BuildDir -PackageFile $PackageFile
