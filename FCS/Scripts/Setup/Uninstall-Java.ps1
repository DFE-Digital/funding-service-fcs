. C:\Setup\Get-Environment-Variables.ps1


$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

#uninstall Java
Write-Host ("Uninstalling Java 7 Update")
$Java7Update= Get-WmiObject -Class Win32_Product -Filter "Name like 'Java 7 Update%'"

$Java7Update.Uninstall()

Write-Host ("Uninstalling Java SE Development Kit 7")

$Java7SDK= Get-WmiObject -Class Win32_Product -Filter "Name like 'Java SE Development Kit 7%'"

$Java7SDK.Uninstall()

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Removing JAVA_HOME Environment Variable")
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $null, "Machine")

Write-Host ("Removing JDK from Path Environment Variable")   
[System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";$JDKInstallDir\bin",''), "Machine")

# Delete Maven
Write-Host ("Removing Maven")
Remove-Item $MavenInstallDirectory -Force -Recurse

# Delete JBOSS Fuse
Write-Host ("Removing JBOSS Fuse")
Remove-Item $JbossinstallDirectory -Force -Recurse

# Delete GRoovy 
Write-Host ("Removing JBOSS Fuse")
Remove-Item $GroovyInstallDirectory -Force -Recurse

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Removing GROOVY_HOME Environment Variable")
[System.Environment]::SetEnvironmentVariable("GROOVY_HOME", $null, "Machine")

Write-Host ("Removing GROOVY from Path Environment Variable")   
[System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";$GroovyInstallDirectory$GroovySubFolderName\bin",''), "Machine")