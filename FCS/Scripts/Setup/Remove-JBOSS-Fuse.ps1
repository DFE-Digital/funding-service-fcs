Write-Host ("***Removing JBOSS Fuse***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

$isFolderExist= Test-Path $JbossinstallDirectory

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

if($isFolderExist -eq $true)
{
        Set-Location ("$JbossinstallDirectory$JBossSubFolderName\Bin")
        
        Write-Host ("Stopping JBOSS Session of root")
        $command ='cmd.exe /C "admin stop root"'
        Invoke-Expression -Command:$command  -WarningAction SilentlyContinue

        
        #Stopping all Java instances
        Write-Host ("Stopping all Java instances")
        Stop-Process -Name java* -Force 

        ##Stopping Karaf JBOSS Windows service
        Write-Host ("Stopping Karaf JBOSS Windows service")
        Stop-Service "KARAF"

       
        #UnInstalling JBOSS Service
        Write-Host ("UnInstalling JBOSS Service")
        $command = 'cmd.exe /C "KARAF-service.bat remove"'
        Invoke-Expression -Command:$command 

        Write-Host ("Power Nap")
        Start-Sleep -s 5 

        Set-Location "C:\"

   
       Write-Host ("Removing Existing JBOSS Installation")
       Remove-Item $JbossinstallDirectory -Force -Recurse

       $Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

       Write-Host ("Removing KARAF_HOME Environment Variable")
       [System.Environment]::SetEnvironmentVariable("KARAF_HOME", $null, "Machine")

       Write-Host ("Removing KARAF_BASE Environment Variable")
       [System.Environment]::SetEnvironmentVariable("KARAF_BASE", $null, "Machine")

       Write-Host ("Removing KARAF_DATA Environment Variable")
       [System.Environment]::SetEnvironmentVariable("KARAF_DATA", $null, "Machine")

       }

Write-Host ("###Finished Removing JBOSS Fuse###")