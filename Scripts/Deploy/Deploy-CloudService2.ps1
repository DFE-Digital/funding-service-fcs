#Modified and simplified version of https://www.windowsazure.com/en-us/develop/net/common-tasks/continuous-delivery/

param
(
    [string]$ServiceName,
    [string]$PackageLocation,
    [string]$ConfigurationLocation,
    [string]$BuildNumber,
    [string]$BuildConfiguration,
    [bool]$NeverUpgrade = $false
)

switch ($BuildConfiguration)
{
    "DOAT"
    {
        $subscription = "SFA-FCS-PreProd"
        $subscriptionSettingsPath = "C:\PublishSettings\sfa_fct_prod.publishsettings"
        $storageAccount = "fcspreprodstorage"
        #$NeverUpgrade = $true
    }
    "OAT"
    {
        $subscription = "SFA-FCS-PreProd"
        $subscriptionSettingsPath = "C:\PublishSettings\sfa_fct_prod.publishsettings"
        $storageAccount = "fcspreprodstorage"
        #$NeverUpgrade = $true
    }
    "PS"
    {
        $subscription = "SFA-OpSup"
        $subscriptionSettingsPath = "C:\PublishSettings\sfa_fct_prod.publishsettings"
        $storageAccount = "fcsopsupstorage"
        #$NeverUpgrade = $true
    }
    "Release"
    {
        $subscription = "SFA-FCS-Prod"
        $subscriptionSettingsPath = "C:\PublishSettings\sfa_fct_prod.publishsettings"
        $storageAccount = "fcsprodstorage"
        #$NeverUpgrade = $true
    }
    default
    {
        $subscription = "Beta"
        $subscriptionSettingsPath = "C:\PublishSettings\sfa_beta.publishsettings"
        $storageAccount = "fctcorestorage"
    }
}

$service = $ServiceName
$slot = "production"
$package = $PackageLocation
$configuration = $ConfigurationLocation + "\ServiceConfiguration." + $BuildConfiguration + ".cscfg"
$timeStampFormat = "g"
$deploymentLabel = "$service - $BuildNumber"

Write-Output "Slot: $slot"
Write-Output "Subscription: $subscription"
Write-Output "SubscriptionSettingsPath: $subscriptionSettingsPath"
Write-Output "Service: $service"
Write-Output "Storage Account: $storageAccount"
Write-Output "Package: $package"
Write-Output "Configuration: $configuration"

Write-Output "Running Azure Imports"
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"

Import-AzurePublishSettingsFile $subscriptionSettingsPath
Select-AzureSubscription -SubscriptionName $subscription

Set-AzureSubscription -CurrentStorageAccount $storageAccount -SubscriptionName $subscription
Set-AzureService -ServiceName $service -Label $deploymentLabel

function Publish()
{
    $deployment = Get-AzureDeployment -ServiceName $service -Slot $slot -ErrorVariable a -ErrorAction silentlycontinue 

    if ($a[0] -ne $null)
    {
        Write-Output "$(Get-Date -f $timeStampFormat) - No deployment is detected. Creating a new deployment. "
    }

    if ($deployment.Name -ne $null -and $NeverUpgrade -eq $false)
    {
        Write-Output "$(Get-Date -f $timeStampFormat) - Deployment exists in $servicename.  Upgrading deployment."
        UpgradeDeployment
    }
    else
    {
        if($deployment.Name -ne $null)
        {
            DeleteDeployment
        }

        CreateNewDeployment
    }
}

function DeleteDeployment()
{
    Write-Progress -id 3 -activity "Deleting Deployment" -Status "In progress"
    Write-Output "$(Get-Date -f $timeStampFormat) - Deleting Deployment: In progress"

    Remove-AzureDeployment -Slot $slot -ServiceName $service -Force

    Write-Progress -id 3 -activity "Deleting Deployment" -completed -Status "Complete"
    Write-Output "$(Get-Date -f $timeStampFormat) - Deleting Deployment: Complete"
}

function CreateNewDeployment()
{
    Write-Progress -id 3 -activity "Creating New Deployment" -Status "In progress"
    Write-Output "$(Get-Date -f $timeStampFormat) - Creating New Deployment: In progress"

    $opstat = New-AzureDeployment -Slot $slot -Package $package -Configuration $configuration -label $deploymentLabel -ServiceName $service

    $completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
    $completeDeploymentID = $completeDeployment.deploymentid

    Write-Progress -id 3 -activity "Creating New Deployment" -completed -Status "Complete"
    Write-Output "$(Get-Date -f $timeStampFormat) - Creating New Deployment: Complete, Deployment ID: $completeDeploymentID"
}

function UpgradeDeployment()
{
    Write-Progress -id 3 -activity "Upgrading Deployment" -Status "In progress"
    Write-Output "$(Get-Date -f $timeStampFormat) - Upgrading Deployment: In progress"

    $setdeployment = Set-AzureDeployment -Upgrade -Slot $slot -Package $package -Configuration $configuration -label $deploymentLabel -ServiceName $service -Force

    $completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
    $completeDeploymentID = $completeDeployment.deploymentid

    Write-Progress -id 3 -activity "Upgrading Deployment" -completed -Status "Complete"
    Write-Output "$(Get-Date -f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID"
}

Write-Output "Create Azure Deployment"
Publish
