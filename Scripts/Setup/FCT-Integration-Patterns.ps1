. C:\Setup\Java-Script-Variables.ps1
Write-Host ("Created Variables")

Write-Host ("***Deployment of FCT-Integration-Patterns***")
Set-Location "$JbossinstallDirectory$JBossSubFolderName\bin"


Write-Host ("***Deployment of FCT-Integration-Patterns***")
$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:profile-create FCT-Integration-Patterns"
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:profile-edit -b mvn:uk.gov.bis.sfa.fct/FCT-Integration-Patterns/1.0.0-SNAPSHOT FCT-Integration-Patterns"
'@
Invoke-Expression -Command:$command

# Add any other feature that are required -
$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:profile-edit -f camel-cache FCT-Integration-Patterns"
'@
Invoke-Expression -Command:$command


# Create a container based on the custom and the medium esb profiles. The name of the fabric is root
$command = @'
cmd.exe /C client -h 127.0.0.1 "fabric:container-create-child --profile FCT-Integration-Patterns --profile jboss-fuse-medium root FCT-Integration-Patterns"
'@
Invoke-Expression -Command:$command

Write-Host ("***Finished deployment of FCT-Integration-Patterns***")