param
(
[Parameter (Mandatory=$True)] [string]$environment
)

## Fill up these details from POM File
$ProjectName = "contracts.documentgeneration" # Name of the project, Please make a note there should not be any white-space in there
$GroupId = "sfa.fct.contracts" # convention is sfa.fct.<Domain Name>, as we have it for .net assemblies
$Version = "1.0.0-SNAPSHOT" # version Number from POM file e.g. 1.0.0-SNAPSHOT

Write-Host ("***Deploying $ProjectName***")

# Modify the file below add a variable with folder location of the Source Package add <ProjectFolderPath>
# Example: $ContractRequestDataLoadProjectFolder
. C:\Setup\Get-Environment-Variables.ps1

Write-Host ("Created Variables")

#Removing Existing Container
    ##This section can be left as it is, no changes required
    Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

    Write-Host ("Removing existing Container for $ProjectName")

    $command = "& .\client.bat -h 127.0.0.1 'fabric:container-delete  -r $ProjectName-Container'"
    Invoke-Expression -Command:$command
#End Removing Existing Container


# Set location to folder path created above in . C:\Setup\Get-Environment-Variables.ps1
Set-Location $ContractsDocumentGenerationProjectFolder
##Example: Set-Location $ContractRequestDataLoadProjectFolder

##This can be left as it is, no changes required
Write-Host ("Building Package")
 . C:\Setup\Build-Project.ps1 $environment

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")


## create <profileName>

##This can be left as it is, no changes required
$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-create $ProjectName'"
Invoke-Expression -Command:$command

##This can be left as it is, no changes required
$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:$GroupId/$ProjectName/$Version $ProjectName' "
Invoke-Expression -Command:$command


##Add any specific features here if needed for example camel cache
#Example:
#$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -f camel-cache $ProjectName'"
#Invoke-Expression -Command:$command


# Create a container based on the custom and the medium esb profiles. The name of the fabric is root
$command = "& .\client.bat -h 127.0.0.1 'fabric:container-create-child --profile $ProjectName --profile jboss-fuse-medium root $ProjectName-Container'"
Invoke-Expression -Command:$command


Write-Host ("###End Deploying $ProjectName###")
