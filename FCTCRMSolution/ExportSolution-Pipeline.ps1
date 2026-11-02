$moduleName = "Microsoft.Xrm.Data.Powershell"
$moduleVersion = "2.8.1.3"

if (!(Get-Module -ListAvailable -Name $moduleName )) {
Write-host "Module Not found, installing now"
$moduleVersion
Install-Module -Name $moduleName -MinimumVersion $moduleVersion -Force
}
else
{
Write-host "Module Found"
}


$SolutionFilesFolder = "$PSScriptRoot\SolutionFiles"
$ManagedSolutionsFolder = "$SolutionFilesFolder\Managed"
$UnmanagedSolutionsFolder = "$SolutionFilesFolder\Unmanaged"
$SolutionPackager = "$PSScriptRoot\Tools\SolutionPackager.exe"
$solutionName = "CIBERSFAFCTSolution"
$solutionNameManaged = "CIBERSFAFCTSolution_managed"
$CrmUrl = "https://fcs-dev.crm4.dynamics.com"
$AadInstance = "https://login.microsoftonline.com/"
$TenantId = "educationgovuk.onmicrosoft.com"
$Configuration = "Dev"
$ClientId = Get-Content Env:DeploymentClientId$Configuration
$AppKey = Get-Content Env:DeploymentAppKey$Configuration
	# OAUTH 
	Add-Type -Path "$PSScriptRoot\Tools\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
	Add-Type -Path "$PSScriptRoot\Tools\Microsoft.Xrm.Sdk.dll"
	Add-Type -Path "$PSScriptRoot\Tools\Microsoft.Xrm.Tooling.Connector.dll"
	Add-Type -Path "$PSScriptRoot\Tools\Microsoft.Crm.Sdk.Proxy.dll"
	Add-Type -Path "$PSScriptRoot\Tools\Microsoft.Xrm.Sdk.Deployment.dll"

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
		"$PSScriptRoot\Tools\Microsoft.IdentityModel.Clients.ActiveDirectory.dll", `
		"$PSScriptRoot\Tools\Microsoft.Xrm.Sdk.dll", `
		"$PSScriptRoot\Tools\Microsoft.Xrm.Tooling.Connector.dll", `
		"$PSScriptRoot\Tools\Microsoft.Crm.Sdk.Proxy.dll", `
		"$PSScriptRoot\Tools\Microsoft.Xrm.Sdk.Deployment.dll" )
   
$authHook = [AuthHook]::new($ClientId, $CrmUrl, $AadInstance, $TenantId, $AppKey)
[Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::AuthOverrideHook = $authHook
$CrmServiceClient = [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::new([System.Uri]::new($CrmUrl + '/api/data/v9.1'), $true)

Write-Host "ClientId is"  $ClientId
Write-Host "AppKey is"  $AppKey
Write-Host "CrmUrl is"  $CrmUrl
Write-Host "TenantId is"  $TenantId
Write-Host "AadInstance is"  $AadInstance

#$CrmServiceClient =$CrmOnlineConnection.GetCrmServiceClient($ClientId,$AppKey,$CrmUrl,$TenantId,$AadInstance)
Write-Host "ConnectedOrgID is " $CrmServiceClient.ConnectedOrgId
# Increase timeout for all connections to 5 minutes
#Set-CrmConnectionTimeout -conn $CrmServiceClient -TimeoutInSeconds 300

Export-CrmSolution -conn $CrmServiceClient -SolutionName "$solutionName" -SolutionFilePath "$PSScriptRoot\Solutions\Unmanaged" -SolutionZipFileName "$solutionName.zip"
Export-CrmSolution -conn $CrmServiceClient -SolutionName "$solutionName" -SolutionFilePath "$PSScriptRoot\Solutions\Managed" -SolutionZipFileName "$solutionNameManaged.zip" -Managed

Write-Host [(Get-Date)] "Solution Files Folder $SolutionFilesFolder"
Write-Host [(Get-Date)] "Solution Packager $SolutionPackager"

Get-ChildItem -LiteralPath "$PSScriptRoot\Solutions\Unmanaged" -Filter *.zip | `
ForEach-Object{
    $ArgumentsUnmanaged = "/action:Extract /zipfile:$PSScriptRoot\Solutions\Unmanaged\$_ /folder:$UnmanagedSolutionsFolder\$_ /packagetype:Unmanaged"
    Write-Host [(Get-Date)] "Arguments $ArgumentsUnmanaged"
    Start-Process -Wait $SolutionPackager $ArgumentsUnmanaged
}

Get-ChildItem -LiteralPath "$PSScriptRoot\Solutions\Managed" -Filter *.zip | `
ForEach-Object{
    $ArgumentsManaged = "/action:Extract /zipfile:$PSScriptRoot\Solutions\Managed\$_ /folder:$ManagedSolutionsFolder\$_ /packagetype:Managed"
    Write-Host [(Get-Date)] "Arguments $ArgumentsManaged"
    Start-Process -Wait $SolutionPackager $ArgumentsManaged
} 