param
(
[Parameter (Mandatory=$True)] [string]$environment
)

$ProjectName = "contractrequestdataload"
$GroupId = "sfa.fct.contracts"
$Version = "1.0.0-SNAPSHOT"
$ProfileName = "contractrequestdataload-profile"

Write-Host ("***Deploying $ProjectName***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")


#Removing Existing Container
Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

Write-Host ("Removing existing Container for $ProjectName")

$command = "& .\client.bat -h 127.0.0.1 'fabric:container-delete  -r $ProjectName-Container'"
Invoke-Expression -Command:$command
#End Removing Existing Container

Set-Location $ContractRequestDataLoadProjectFolder

Write-Host ("Building Package")
. C:\Setup\Build-Project.ps1 $environment

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

## create <profileName>
$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-delete $ProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-create $ProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit --repositories file:/C://projects/crd-features.xml $ProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit --features poi-bundles $ProfileName'"
Invoke-Expression -Command:$command




## mvn:<groupid>/<artifactid>/<version> <profileName>


## dependency on poi
#$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.poi/3.9_2 $ProfileName'"


#Invoke-Expression -Command:$command

## end 

## dependency on poi-ooxml

#$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:org.apache.poi/poi-ooxml/3.11 $ProjectName'"
#Invoke-Expression -Command:$command

## end 

## dependency on poi-ooxml

#$command = "& .\client.bat -h 127.0.0.1 'features:install features.xml'"
#Invoke-Expression -Command:$command

## end 

## dependency on poi-ooxml

#$command = "& .\client.bat -h 127.0.0.1 'osgi:install wrap:mvn:org.apache.poi/poi-ooxml/3.11'"
#Invoke-Expression -Command:$command

## end 


## dependency on com.fasterxml.jackson.dataformat

$command ="& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:com.fasterxml.jackson.dataformat/jackson-dataformat-xml/2.5.0 $ProjectName' "
Invoke-Expression -Command:$command

#$command ="& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:com.fasterxml.jackson.core/jackson-annotations/2.5.0 $ProjectName' "
#Invoke-Expression -Command:$command

#$command ="& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:com.fasterxml.jackson.core/jackson-core/2.5.0 $ProjectName' "
#Invoke-Expression -Command:$command

## end 
$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:$GroupId/$ProjectName/$Version $ProfileName' "
Invoke-Expression -Command:$command

#$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:sfa.fct.contracts/"+$ProjectName+"/1.0.0-SNAPSHOT $ProjectName' "
#Invoke-Expression -Command:$command


# Create a container based on the custom and the medium esb profiles. The name of the fabric is root


$command = "& .\client.bat -h 127.0.0.1 'fabric:container-create-child --profile $ProfileName --profile $FCTProfileName root $ProjectName-Container'"
Invoke-Expression -Command:$command



Write-Host ("###End Deploying $ProjectName###")
