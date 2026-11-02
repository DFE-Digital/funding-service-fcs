##

Write-Host ("***Installing JBOSS Package***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

## Cleanup existing installed JBOSS

 . C:\Setup\Remove-JBOSS-Fuse.ps1

## Install Jboss

 . C:\Setup\Install-Jboss.ps1

##Add Jboss as service 
  
 . C:\Setup\Setup-JBOSS-AsService.ps1

##Setting up JBOSS Fabric

    Write-Host ("Waiting Jboss service to start JVM")
    Start-Sleep -s 60 
 . C:\Setup\Setup-Jboss-Fabric.ps1

Set-Location C:\


Write-Host ("###Finished Installing JBOSS Package###")