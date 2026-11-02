param (
    [Parameter(Mandatory=$true)][string]$sharedResourceGroup,
    [Parameter(Mandatory=$true)][string]$storageAccountName,
    [Parameter(Mandatory=$true)][string]$storageAccountRetentionDays
)

#Get the storage account in the variable
$StorageAccounts = Get-AzureRmStorageAccount -ResourceGroupName $sharedResourceGroup -Name $storageAccountName
 
#Get the Management key for the storage account
$key1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $StorageAccounts.ResourceGroupName -name $StorageAccounts.StorageAccountName)[0].value
 
#Get the Storage Context to access the Storage Container
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccounts.StorageAccountName -StorageAccountKey $key1
$storageContext | Set-AzureStorageServiceLoggingProperty -ServiceType Blob -LoggingOperations All -RetentionDays $storageAccountRetentionDays
$storageContext | Set-AzureStorageServiceLoggingProperty -ServiceType Table -LoggingOperations All -RetentionDays $storageAccountRetentionDays
$storageContext | Set-AzureStorageServiceMetricsProperty -MetricsType Hour -ServiceType Blob -MetricsLevel ServiceAndApi  -RetentionDays $storageAccountRetentionDays
