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
    [string]$AadInstance,

	[Parameter(Mandatory=$True)]
    [string]$TenantId,

	[Parameter(Mandatory=$True)]
    [string]$AppKey,

	[Parameter(Mandatory=$True)]
    [string]$ClientId,

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
        #[PSCredential]$Cred,
        [string]$CrmUrl,
        [string]$CrmOrgName,
        [string]$PackageDirectory,
        [string]$PackageFile,
        [string]$ClientId,
        [string]$AppKey,
        [string]$AadInstance,
        [string]$TenantId

    )

	$moduleName = "Microsoft.Xrm.Data.Powershell"
	$moduleVersion = "2.8.1.3"

	if (!(Get-Module -ListAvailable -Name $moduleName )) {
		Write-host "Module Not found, installing now"
		$moduleVersion
		Install-Module -Name $moduleName -MinimumVersion $moduleVersion -Force -Scope CurrentUser
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

	Write-Host "Currentfolder is  $BuildDir\BuildScripts"
   # $CRMConn = Connect-CrmOnline  -Credential $cred -ServerUrl $CrmUrl
	#[Reflection.Assembly]::LoadFile("$BuildDir\BuildScripts\CRMOnlineHelper.dll")
	#$CrmOnlineConnection = New-Object CRMOnlineHelper.CrmOnlineConnection

	# OAUTH 
	Add-Type -Path "$BuildDir\..\..\..\packages\Microsoft.IdentityModel.Clients.ActiveDirectory.2.22.302111727\lib\net45\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
	Add-Type -Path "$BuildDir\..\..\..\packages\Microsoft.CrmSdk.CoreAssemblies.9.0.2.12\lib\net462\Microsoft.Xrm.Sdk.dll"
	Add-Type -Path "$BuildDir\..\..\..\packages\Microsoft.CrmSdk.XrmTooling.CoreAssembly.9.0.2.27\lib\net462\Microsoft.Xrm.Tooling.Connector.dll"
	Add-Type -Path "$BuildDir\..\..\..\packages\Microsoft.CrmSdk.CoreAssemblies.9.0.2.12\lib\net462\Microsoft.Crm.Sdk.Proxy.dll"
	Add-Type -Path "$BuildDir\..\..\..\packages\Microsoft.CrmSdk.Deployment.9.0.2.12\lib\net462\Microsoft.Xrm.Sdk.Deployment.dll"

	$authHookClass = @'
	using System;
	using System.Collections.Generic;
	using Microsoft.Xrm.Tooling.Connector;
	using Microsoft.IdentityModel.Clients.ActiveDirectory;

	public class AuthHook : Microsoft.Xrm.Tooling.Connector.IOverrideAuthHookWrapper 
	{
		string ClientId;
		string OrganizationUrl;
		string AadInstance;
		string TenantID;
		string AppKey;
		Dictionary<string, AuthenticationResult> accessTokens = new Dictionary<string, AuthenticationResult>();


		public AuthHook(string clientID, string organizationUrl, string aadInstance,  string tenantId, string appKey)
		{
			this.ClientId = clientID;
			this.OrganizationUrl = organizationUrl;
			this.AadInstance = aadInstance;
			this.TenantID = tenantId;
			this.AppKey = appKey;
		}


		public string GetAuthToken(Uri connectedUri) 
		{
			if (!this.accessTokens.ContainsKey(connectedUri.Host) || this.accessTokens[connectedUri.Host].ExpiresOn < (DateTime.Now))
			{
				var clientCred = new Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential(this.ClientId, this.AppKey);
				var authenticationContext = new Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext(this.AadInstance + this.TenantID);
				System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;
				var authResult = authenticationContext.AcquireToken(this.OrganizationUrl, clientCred);

				this.accessTokens.Remove(connectedUri.Host);
				this.accessTokens[connectedUri.Host] = authResult;       
			}
        
			return this.accessTokens[connectedUri.Host].AccessToken;        
		}
	}
'@


	Add-Type -Language CSharp -TypeDefinition $authHookClass `
		-ReferencedAssemblies @(`
			"$BuildDir\..\..\..\packages\Microsoft.IdentityModel.Clients.ActiveDirectory.2.22.302111727\lib\net45\Microsoft.IdentityModel.Clients.ActiveDirectory.dll", `
			"$BuildDir\..\..\..\packages\Microsoft.CrmSdk.CoreAssemblies.9.0.2.12\lib\net462\Microsoft.Xrm.Sdk.dll", `
			"$BuildDir\..\..\..\packages\Microsoft.CrmSdk.XrmTooling.CoreAssembly.9.0.2.27\lib\net462\Microsoft.Xrm.Tooling.Connector.dll", `
			"$BuildDir\..\..\..\packages\Microsoft.CrmSdk.CoreAssemblies.9.0.2.12\lib\net462\Microsoft.Crm.Sdk.Proxy.dll", `
			"$BuildDir\..\..\..\packages\Microsoft.CrmSdk.Deployment.9.0.2.12\lib\net462\Microsoft.Xrm.Sdk.Deployment.dll" )
   



	$authHook = [AuthHook]::new($ClientId, $CrmUrl, $AadInstance, $TenantId, $AppKey)
	[Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::AuthOverrideHook = $authHook
	$CrmServiceClient = [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::new([System.Uri]::new($CrmUrl + '/xrmservices/2011/organization.svc/web?SdkClientVersion=9.0.37.948'), $true)

	Write-Host "ClientId is"  $ClientId
	Write-Host "AppKey is"  $AppKey
	Write-Host "CrmUrl is"  $CrmUrl
	Write-Host "TenantId is"  $TenantId
	Write-Host "AadInstance is"  $AadInstance

	#$CrmServiceClient =$CrmOnlineConnection.GetCrmServiceClient($ClientId,$AppKey,$CrmUrl,$TenantId,$AadInstance)
	Write-Host "ConnectedOrgID is " $CrmServiceClient.ConnectedOrgId

	Write-host "Preparing to import"
    Import-CrmPackage `
    -Verbose `
    -PackageName $PackageFile `
    -PackageDirectory $PackageDirectory `
    -TimeOut '01:00:00' `
    -CrmConnection $CrmServiceClient `
	-EnabledAsyncForSolutionImport 

}


#$DeploymentAdminUsername = $env:DeploymentAdminUsernameDAT
#$DeploymentAdminPassword = $Pass
#Write-Host [(Get-Date)] "Credentials $DeploymentAdminUsername : $DeploymentAdminPassword"

#$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$DeploymentAdminUsername", ($DeploymentAdminPassword | ConvertTo-SecureString -asPlainText -Force)

# Pack solution files and place them in correct directory
$SolutionFilesFolder = "$BuildDir\Solutions"

New-Item -ItemType Directory -Force -Path $SolutionFilesFolder

Write-Host [(Get-Date)] "Solution Files Folder $SolutionFilesFolder"

Get-ChildItem -LiteralPath $SolutionFilesFolder\$ManagedSolution -Filter *.zip | `
ForEach-Object {
    $OutputFile = "$BuildDir\PkgFolder\Solutions\$_" -replace "_managed", ""
	Copy-item -force $SolutionFilesFolder\$ManagedSolution\$_ $OutputFile;
}

# Powershell File Moving - to allow the same package to be run with multiple ImportConfig Files - other option is to have two config packages
Copy-item -force "$BuildDir\PkgFolder\ImportConfigData.xml" "$BuildDir\PkgFolder\ImportConfig.xml";


#DeployCrmOrganizationData -Cred $Cred -CrmUrl $CrmUrl -CrmOrgName $OrganizationUniqueName -PackageDirectory $BuildDir -PackageFile $PackageFile
DeployCrmOrganizationData  -CrmUrl $CrmUrl -CrmOrgName $OrganizationUniqueName -PackageDirectory $BuildDir -PackageFile $PackageFile -ClientId $ClientId -AppKey $AppKey -AadInstance $AadInstance -TenantId $tenantId
