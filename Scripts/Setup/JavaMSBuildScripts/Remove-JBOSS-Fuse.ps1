Write-Host ("***Removing JBOSS Fuse***")

$JbossinstallDirectoryOnlocalMachine ="C:\Java\JBOSS Fuse"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"
$JavaInstallersServer = "C:\JavaInstalls"
$JavaInstallersShareLocation = "\\fct-ci-fuse-01\JavaInstalls"
$DeploymentUser = "CIDEV\tfsbuild"
$DeploymentPassword = ""

$ServerName = "fct-AT-fuse"

$JBossInstallerLocation = "$JavaInstallersServer\jboss-fuse-full-6.1.0.redhat-379.zip"

Write-Host ("Created Variables")

$Path= Invoke-Expression "$MSBuildProjectDirectory\Setup\JavaMSBuildScripts\Get-EnvironmentVariable.ps1 -ComputerName $ServerName -Name Path"

$Cre = new-object -typename System.Management.Automation.PSCredential -argumentlist $DeploymentUser, ($DeploymentPassword | ConvertTo-SecureString -asPlainText -Force)

$Cre2 = new-object -typename System.Management.Automation.PSCredential -argumentlist "mmonga", ("" | ConvertTo-SecureString -asPlainText -Force)

#$isFolderExist= Test-Path $JbossinstallDirectory 
$isFolderExist = Invoke-Command -ComputerName $ServerName -Credential $Cre2  -ScriptBlock {param($FilePath) Test-Path $FilePath} -ArgumentList $JbossinstallDirectoryOnlocalMachine

if($isFolderExist -eq $true)
{
        #Set-Location ("$JbossinstallDirectory$JBossSubFolderName\Bin")
        
        Write-Host ("Stopping JBOSS Session of root")
        Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\admin.bat"  stop root } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 
        #$command ='cmd.exe /C "admin stop root"'
        #Invoke-Expression -Command:$command  -WarningAction SilentlyContinue

        
        #Stopping all Java instances
        Write-Host ("Stopping all Java instances")
        Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {Stop-Process -Name java* -Force } 
        #Stop-Process -Name java* -Force 

        ##Stopping Karaf JBOSS Windows service
        Write-Host ("Stopping Karaf JBOSS Windows service")
        Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {Stop-Service "KARAF"} 
        
       
        #UnInstalling JBOSS Service
        Write-Host ("UnInstalling JBOSS Service")
        Invoke-Command -ComputerName $ServerName -Credential $Cre2 -ScriptBlock {param($FilePath) ."$FilePath\bin\KARAF-service.bat"  remove } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" 
        #$command = 'cmd.exe /C "KARAF-service.bat remove"'
        #Invoke-Expression -Command:$command 

        Write-Host ("Power Nap")
        Start-Sleep -s 5 
                
   
       Write-Host ("Removing Existing JBOSS Installation")
       Invoke-Command -ComputerName $ServerName -Credential $Cre2  -ScriptBlock {param($FilePath) Remove-Item $FilePath -Force -Recurse} -ArgumentList $JbossinstallDirectoryOnlocalMachine
       #Remove-Item $JbossinstallDirectory -Force -Recurse

       $Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

       Write-Host ("Removing KARAF_HOME Environment Variable")
       Invoke-Command -ComputerName $ServerName -Credential $Cre2  -ScriptBlock {[System.Environment]::SetEnvironmentVariable("KARAF_HOME", $null, "Machine") } 
       #[System.Environment]::SetEnvironmentVariable("KARAF_HOME", $null, "Machine")

       Write-Host ("Removing KARAF_BASE Environment Variable")
       Invoke-Command -ComputerName $ServerName -Credential $Cre2  -ScriptBlock {[System.Environment]::SetEnvironmentVariable("KARAF_BASE", $null, "Machine") } 
 #      [System.Environment]::SetEnvironmentVariable("KARAF_BASE", $null, "Machine")

       Write-Host ("Removing KARAF_DATA Environment Variable")
       Invoke-Command -ComputerName $ServerName -Credential $Cre2  -ScriptBlock {[System.Environment]::SetEnvironmentVariable("KARAF_DATA", $null, "Machine") } 
#       [System.Environment]::SetEnvironmentVariable("KARAF_DATA", $null, "Machine")

       }

Write-Host ("###Finished Removing JBOSS Fuse###")