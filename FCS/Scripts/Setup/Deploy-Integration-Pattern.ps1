param
(
[Parameter (Mandatory=$True)] [string]$environment
)


$ProjectName = "FCT-Integration-Patterns"
$GroupId = "uk.gov.bis.sfa.fct"
$Version = "1.0.0-SNAPSHOT"

Write-Host ("***Deploying $ProjectName***")

. C:\Setup\Get-Environment-Variables.ps1

Write-Host ("Created Variables")


#Removing Existing Container
    Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

    Write-Host ("Removing existing Container for $ProjectName")

    $command = "& .\client.bat -h 127.0.0.1 'fabric:container-delete  -r $ProjectName-Container'"
    Invoke-Expression -Command:$command
#End Removing Existing Container


Set-Location $IntegrationPatternProjectFolder

Write-Host ("Building Package")
 . C:\Setup\Build-Project.ps1 $environment

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")


## create <profileName>

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-create $ProjectName'"
Invoke-Expression -Command:$command
## mvn:<groupid>/<artifactid>/<version> <profileName>

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -b mvn:$GroupId/$ProjectName/$Version $ProjectName' "
Invoke-Expression -Command:$command


# Add any other feature that are required -
$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit -f camel-cache $ProjectName'"
Invoke-Expression -Command:$command


# Create a container based on the custom and the medium esb profiles. The name of the fabric is root


$command = "& .\client.bat -h 127.0.0.1 'fabric:container-create-child --profile $ProjectName --profile jboss-fuse-medium root $ProjectName-Container'"
Invoke-Expression -Command:$command


Write-Host ("###End Deploying $ProjectName###")
