
Write-Host ("***Setting up JBOSS as Service***")

$ServerName = "fct-AT-fuse"
$JbossinstallDirectoryOnlocalMachine ="C:\Java\JBOSS Fuse"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"
$DeploymentUser = "CIDEV\tfsbuild"
$DeploymentPassword = ""
#$MSBuildProjectDirectory="D:\Builds\10\FCT\Manmeet-TestMaven\src\Main\Scripts"

$Cre = new-object -typename System.Management.Automation.PSCredential -argumentlist $DeploymentUser, ($DeploymentPassword | ConvertTo-SecureString -asPlainText -Force)

$Cre2 = new-object -typename System.Management.Automation.PSCredential -argumentlist "mmonga", ("" | ConvertTo-SecureString -asPlainText -Force)

# Feature: Install Wrapper INSTALL
        Write-Host ("Feature: Install Wrapper INSTALL")
#        $command = 'cmd.exe /C client -h 127.0.0.1 "features:install wrapper"'
#       Invoke-Expression -Command:$command

Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\client.bat" -h 127.0.0.1 "features:install wrapper" } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 

        Write-Host ("Power Nap")
        Start-Sleep -s 5

        Write-Host ("Installing Wrapper to install JBOSS as service")
#$command = 'cmd.exe /C client -h 127.0.0.1 "wrapper:install -s AUTO_START -n KARAF -d Karaf"'
#Invoke-Expression -Command:$command

Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\client.bat" -h 127.0.0.1 "wrapper:install -s AUTO_START -n KARAF -d Karaf" } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 
        
##Stopping all Java Processes
        
        $remotejob = Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {Stop-Process -Name java*}

        Write-Host ("Stopping JBOSS Session of root")
#$command = 'cmd.exe /C "admin stop root"'
#Invoke-Expression -Command:$command

Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\admin.bat" stop root } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 


        Write-Host ("Installing JBOSS Service")
#$command = 'cmd.exe /C "KARAF-service.bat install"'
#Invoke-Expression -Command:$command

Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\KARAF-service.bat" install } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 

##Replace with Winsows reun service command
        Write-Host ("Starting KARAF JBOSS Service")
#Start-Service "KARAF"
Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {Start-Service "KARAF"}

          Write-Host ("Waiting for JVM to start")
        Start-Sleep -s 60

Write-Host ("###Finished Setting up JBOSS as Service###")