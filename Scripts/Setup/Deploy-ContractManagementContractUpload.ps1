Write-Host ("***Deploying contractrequestdataload***")

. C:\Setup\Java-Script-Variables.ps1
Write-Host ("Created Variables")

Set-Location $ContractManagementContractUploadProjectFolder

Write-Host ("Building Package")
 . C:\Setup\Build-Project.ps1

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")


## create <profileName>

$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:profile-create contractmanagmentcontractupload
'@
Invoke-Expression -Command:$command
## mvn:<groupid>/<artifactid>/<version> <profileName>

$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:profile-edit -b mvn:sfa.fct.contracts/contractupload/1.0.0-SNAPSHOT contractmanagmentcontractupload"
'@
Invoke-Expression -Command:$command


# Create a container based on the custom and the medium esb profiles. The name of the fabric is root


$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:container-create-child --profile contractmanagmentcontractupload --profile jboss-fuse-medium root contractmanagmentcontractupload-Container"
'@
Invoke-Expression -Command:$command



Write-Host ("###End Deploying contractmanagmentcontractupload###")
