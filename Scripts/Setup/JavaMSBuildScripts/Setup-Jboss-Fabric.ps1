Write-Host ("***Setting up JBOSS Fabric***")


$ServerName = "fct-AT-fuse"
$JbossinstallDirectoryOnlocalMachine ="C:\Java\JBOSS Fuse"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"
$DeploymentUser = "CIDEV\tfsbuild"
$DeploymentPassword = ""

#$MSBuildProjectDirectory="D:\Builds\10\FCT\Manmeet-TestMaven\src\Main\Scripts"

$Cre = new-object -typename System.Management.Automation.PSCredential -argumentlist $DeploymentUser, ($DeploymentPassword | ConvertTo-SecureString -asPlainText -Force)

$Cre2 = new-object -typename System.Management.Automation.PSCredential -argumentlist "mmonga", ("" | ConvertTo-SecureString -asPlainText -Force)

    # Create to default fabric
    Write-Host ("Create to default fabric")
#$command = 'cmd.exe /C client -h 127.0.0.1 "fabric:create -p fabric --wait-for-provisioning"'
 #   Invoke-Expression -Command:$command -WarningAction SilentlyContinue

Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\client.bat" -h 127.0.0.1 "fabric:create -p fabric --wait-for-provisioning" } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 

    # Create the shared broker within the fabric
    Write-Host ("Create the shared broker within the fabric")
  #  $command = 'cmd.exe /C client -h 127.0.0.1 "fabric:mq-create --parent-profile mq-amq --create-container Shared-Queued MasterSlaveBroker"'
   # Invoke-Expression -Command:$command -WarningAction SilentlyContinue
Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\client.bat" -h 127.0.0.1 "fabric:mq-create --parent-profile mq-amq --create-container Shared-Queued MasterSlaveBroker" } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 

Write-Host ("###END Setting up JBOSS Fabric###")