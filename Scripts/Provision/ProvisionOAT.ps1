#Funding Stream Config Cloud Service
New-AzureService -ServiceName "fct-fsc-oat" -Location "West Europe"

#Organisation Service Cloud Service
New-AzureService -ServiceName "fct-orgservice-oat" -Location "West Europe"

#NServiceBus role Cloud Service
New-AzureService -ServiceName "fct-servicebus-oat" -Location "West Europe"

#NServiceBus Web Jobs hosting shell - NEED TO CHANGE THE WEB HOSTING PLAN SKU FOR THIS (no support in powershell without switching to the retarded AzureResourceManager mode)
New-AzureWebsite "fct-webjobs-oat" -Location "West Europe"

$dbServver = New-AzureSqlDatabaseServer -Location "West Europe" -AdministratorLogin "" -AdministratorLoginPassword "" -Version "12.0"
$dbServerName = $dbServver.ServerName

New-AzureSqlDatabase -ServerName $dbServerName -DatabaseName "fct-servicebus-oat" -Edition "Premium" -MaxSizeGB 50
New-AzureSqlDatabase -ServerName $dbServerName -DatabaseName "fct-orgservice-oat" -Edition "Premium" -MaxSizeGB 50

#Service Bus Primary Key connection string: 
New-AzureSBNamespace -Name "fct-nservicebusoat" -Location "West Europe" -NamespaceType Messaging -CreateACSNamespace $false

New-AzureStorageAccount -StorageAccountName "fctappstorageoat" -Location "West Europe" -Type Standard_LRS
#Primary Account Key is: 
$storageContext = New-AzureStorageContext -StorageAccountName "fctappstorageoat" -StorageAccountKey (Get-AzureStorageKey -StorageAccountName "fctappstorageoat").Primary

New-AzureStorageContainer -Context $storageContext -Name "document-template" -Permission Off
New-AzureStorageContainer -Context $storageContext -Name "data-bus" -Permission Off
