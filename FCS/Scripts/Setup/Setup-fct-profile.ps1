Write-Host ("### create fct-profile ###")


. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

Set-Location ("$JbossinstallDirectory$JBossSubFolderName/Bin")

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-delete $FCTProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-create --parents jboss-fuse-minimal $FCTProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit --features mq-fabric $FCTProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit --features mq-fabric-camel $FCTProfileName'"
Invoke-Expression -Command:$command

$command = "& .\client.bat -h 127.0.0.1 'fabric:profile-edit --features camel-saxon $FCTProfileName'"
Invoke-Expression -Command:$command

Write-Host ("### fct-profile created ###")
