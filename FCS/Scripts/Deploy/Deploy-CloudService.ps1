#Modified and simplified version of https://www.windowsazure.com/en-us/develop/net/common-tasks/continuous-delivery/

param
(
    [string]$ServiceName,
    [string]$PackageLocation,
    [string]$ConfigurationLocation,
    [string]$BuildNumber
)

$subscription = "Beta"
$subscriptionSettingsPath = "C:\PublishSettings\sfa_beta.publishsettings"
$service = $ServiceName
$storageAccount = "fctcorestorage"
$slot = "production"
$package = $PackageLocation
$configuration = $ConfigurationLocation
$timeStampFormat = "g"
$deploymentLabel = "$service - $BuildNumber"

Write-Output "Slot: $slot"
Write-Output "Subscription: $subscription"
Write-Output "SubscriptionSettingsPath: $subscriptionSettingsPath"
Write-Output "Service: $service"
Write-Output "Storage Account: $storageAccount"
Write-Output "Slot: $slot"
Write-Output "Package: $package"
Write-Output "Configuration: $configuration"

Write-Output "Running Azure Imports"
Import-Module Azure

Import-AzurePublishSettingsFile $subscriptionSettingsPath
Select-AzureSubscription -SubscriptionName $subscription

Set-AzureSubscription -CurrentStorageAccount $storageAccount -SubscriptionName $subscription
Set-AzureService -ServiceName $service -Label $deploymentLabel

function Publish()
{
  $deployment = Get-AzureDeployment -ServiceName $service -Slot $slot -ErrorVariable a -ErrorAction silentlycontinue 

  if ($a[0] -ne $null) {
    Write-Output "$(Get-Date -f $timeStampFormat) - No deployment is detected. Creating a new deployment. "
  }

  if ($deployment.Name -ne $null) {
    Write-Output "$(Get-Date -f $timeStampFormat) - Deployment exists in $servicename.  Upgrading deployment."
    UpgradeDeployment
  } else {
    CreateNewDeployment
  }
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
