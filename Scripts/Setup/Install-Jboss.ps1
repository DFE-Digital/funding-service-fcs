Write-Host ("***Installing JBOSS***")


. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Creating Installation folder {0}" -f  $JbossinstallDirectory)
New-Item -ItemType directory -Path $JbossinstallDirectory

Set-Location $JbossinstallDirectory
$shell = new-object -com shell.application
$zip = $shell.Namespace($JBossInstallerLocation)

Write-Host ("Unzipping JBOSS Fuse")

foreach($item in $zip.items())
{
    $shell.Namespace("$JbossinstallDirectory").copyhere($item)
}


Set-Location ("$JbossinstallDirectory$JBossSubFolderName")

##Setting Environment Variables 

   Write-Host ("Adding KARAF_HOME Environment Variable")
   [System.Environment]::SetEnvironmentVariable("KARAF_HOME", "$JbossinstallDirectory$JBossSubFolderName", "Machine")

   Write-Host ("Adding KARAF_BASE Environment Variable")
   [System.Environment]::SetEnvironmentVariable("KARAF_BASE", "$JbossinstallDirectory$JBossSubFolderName", "Machine")

   Write-Host ("Adding KARAF_DATA Environment Variable")
   [System.Environment]::SetEnvironmentVariable("KARAF_DATA", "$JbossinstallDirectory$JBossSubFolderName\data", "Machine")
   
##Setting Environment Variables 

##Start JBOSS fuse

Write-Host ("Adding JBOSS Password file")

Add-Content ("$JbossinstallDirectory$JBossSubFolderName\etc\users.properties") "`nadmin = password,admin"

#***Run Fuse***
Start-Process -FilePath "$JbossinstallDirectory$JBossSubFolderName\bin\fuse.bat" -ArgumentList "server"

Write-Host ("Timer to wait for JBOSS to start")
Start-Sleep -s 60

Write-Host ("###Finished Installing JBOSS###")