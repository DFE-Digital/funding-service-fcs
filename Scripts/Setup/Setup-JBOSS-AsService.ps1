
Write-Host ("***Setting up JBOSS as Service***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

Set-Location ("$JbossinstallDirectory$JBossSubFolderName\Bin")

      # Feature: Install Wrapper INSTALL
        Write-Host ("Feature: Install Wrapper INSTALL")
        $command = @'
cmd.exe /C client -h 127.0.0.1 "features:install wrapper"
'@
        Invoke-Expression -Command:$command

        Write-Host ("Power Nap")
        Start-Sleep -s 5

        Write-Host ("Installing Wrapper to install JBOSS as service")
        $command = @'
cmd.exe /C client -h 127.0.0.1 "wrapper:install -s AUTO_START -n KARAF -d Karaf"
'@
        Invoke-Expression -Command:$command

        
        ##Stopping all Java Processes
        Stop-Process -Name java*

        Write-Host ("Stopping JBOSS Session of root")
        $command = @'
        cmd.exe /C "admin stop root"
'@
        Invoke-Expression -Command:$command


        Write-Host ("Installing JBOSS Service")
        $command = @'
cmd.exe /C "KARAF-service.bat install"
'@
        Invoke-Expression -Command:$command


        ##Replace with Winsows reun service command
        Write-Host ("Starting KARAF JBOSS Service")
        Start-Service "KARAF"

Write-Host ("###Finished Setting up JBOSS as Service###")