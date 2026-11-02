Write-Host ("***Setting up JBOSS Fabric***")


. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

Set-Location ("$JbossinstallDirectory$JBossSubFolderName\Bin")

    # Create to default fabric
    Write-Host ("Create to default fabric")
    $command = 'cmd.exe /C client -h 127.0.0.1 "fabric:create -p fabric --wait-for-provisioning"'
    Invoke-Expression -Command:$command -WarningAction SilentlyContinue

    # Create the shared broker within the fabric
    Write-Host ("Create the shared broker within the fabric")
    $command = 'cmd.exe /C client -h 127.0.0.1 "fabric:mq-create --parent-profile mq-amq --create-container Shared-Queued MasterSlaveBroker"'
    Invoke-Expression -Command:$command -WarningAction SilentlyContinue

Write-Host ("###END Setting up JBOSS Fabric###")