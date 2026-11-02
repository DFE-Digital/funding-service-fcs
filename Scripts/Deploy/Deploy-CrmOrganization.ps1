param
(
    # required params
    [PSCredential]$Cred,
    [string]$Name,
    [string]$DisplayName,
    [string]$CrmServerName,
    [string]$SqlServerName,
    [string]$SSRSUrl,
    [string]$DropIfExists = $True,
    [string]$DiscoveryServer,

    # optional params (can accept nulls)
    [string]$BaseCurrencyCode,
    [string]$BaseCurrencyName,
    [string]$BaseCurrencySymbol,
    [string]$BaseCurrencyPrecision,
    [string]$BaseLanguageCode,
    [string]$SqlCollation,
    [string]$SQMOptIn,
    [string]$SysAdminName,
    [switch]$WaitForJob=$True
)

$CrmServerUrl = "http://$CrmServerName/XRMDeployment/2011/Deployment.svc"

$RemoveSnapInWhenDone = $False

Import-Module sqlps -DisableNameChecking

if (-not (Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

if ($DropIfExists -eq $True)
{
    $theOrg = Get-CrmOrganization -Name $Name -DWSServerURL $CrmServerUrl -Cred $Cred
    if ($theOrg)
    {
        Disable-CrmOrganization -Name $Name -DWSServerURL $CrmServerUrl -Cred $Cred
        Remove-CrmOrganization -Name $Name -DWSServerURL $CrmServerUrl -Cred $Cred

        # get the server object and view the databases
        $server = New-Object Microsoft.SqlServer.Management.Smo.Server($SqlServerName)

        $dbName = $Name + "_mscrm"

        Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
        $smo = New-Object Microsoft.SqlServer.Management.Smo.Server $SqlServerName

        # view the target database
        if ($server.databases[$dbName])
        {
            $smo.KillAllProcesses($dbName)

            # drop the database and view the databases again
            $server.databases[$dbName].Drop()
        }
    }
}

$opId = New-CrmOrganization -DisplayName $DisplayName -SqlServerName $SqlServerName -SrsUrl $SSRSUrl -Name $Name -DWSServerURL $CrmServerUrl -Cred $Cred -BaseCurrencyCode $BaseCurrencyCode -BaseCurrencyName $BaseCurrencyName -BaseCurrencySymbol $BaseCurrencySymbol -BaseCurrencyPrecision $BaseCurrencyPrecision -BaseLanguageCode $BaseLanguageCode -SqlCollation $SqlCollation -SQMOptIn $SQMOptIn -SysAdminName $SysAdminName

if ($opId)
{
    if($WaitForJob)
    {
        $opstatus = Get-CrmOperationStatus -OperationId $opid -DWSServerURL $CrmServerUrl -Cred $Cred
        while($opstatus.State -eq "Processing")
        {
            Start-Sleep -s 30
            $opstatus = Get-CrmOperationStatus -OperationId $opid -DWSServerURL $CrmServerUrl -Cred $Cred
        }

        if($opstatus.State -eq "Failed")
        {
            Throw ($opstatus.ProcessingError.Message)
        } 
    }
}

if($RemoveSnapInWhenDone)
{
    Remove-PSSnapin Microsoft.Crm.PowerShell
}
