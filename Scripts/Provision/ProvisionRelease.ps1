#Funding Stream Config Cloud Service
New-AzureService -ServiceName "fct-fsc-release" -Location "West Europe"

#Organisation Service Cloud Service
New-AzureService -ServiceName "fct-orgservice-release" -Location "West Europe"

#NServiceBus role Cloud Service
New-AzureService -ServiceName "fct-servicebus-release" -Location "West Europe"

#NServiceBus Web Jobs hosting shell - NEED TO CHANGE THE WEB HOSTING PLAN SKU FOR THIS (no support in powershell without switching to the retarded AzureResourceManager mode)
New-AzureWebsite "fct-webjobs-release" -Location "West Europe"

$dbServver = New-AzureSqlDatabaseServer -Location "West Europe" -AdministratorLogin "" -AdministratorLoginPassword "" -Version "12.0"
$dbServerName = $dbServver.ServerName

New-AzureSqlDatabase -ServerName $dbServerName -DatabaseName "fct-servicebus-release" -Edition "Premium" -MaxSizeGB 50 
New-AzureSqlDatabase -ServerName $dbServerName -DatabaseName "fct-orgservice-release" -Edition "Premium" -MaxSizeGB 50

#Service Bus Primary Key connection string: 
New-AzureSBNamespace -Name "fct-nservicebus-release" -Location "West Europe" -NamespaceType Messaging -CreateACSNamespace $false

New-AzureStorageAccount -StorageAccountName "fctappstoragerelease" -Location "West Europe" -Type Standard_LRS
#Primary Account Key is: 
$storageContext = New-AzureStorageContext -StorageAccountName "fctappstoragerelease" -StorageAccountKey (Get-AzureStorageKey -StorageAccountName "fctappstoragerelease").Primary

New-AzureStorageContainer -Context $storageContext -Name "document-template" -Permission Off
New-AzureStorageContainer -Context $storageContext -Name "data-bus" -Permission Off
