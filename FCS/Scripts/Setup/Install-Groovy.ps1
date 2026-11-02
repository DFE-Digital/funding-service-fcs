Write-Host ("Installing Groovy")

. C:\Setup\Java-Script-Variables.ps1
Write-Host ("Created Variables")

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

$isFolderExist= Test-Path $GroovyInstallDirectory

if($isFolderExist -eq $true)
{
    Set-Location c:\
   Write-Host ("Removing Existing Groovy Installation")
   Remove-Item $GroovyInstallDirectory -Force -Recurse

   Write-Host ("Removing GROOVY_HOME Environment Variable")
   [System.Environment]::SetEnvironmentVariable("GROOVY_HOME", $null, "Machine")
   
  
   #Removing Groovy from Environment Path
   Write-Host ("Removing GROOVY from Path Environment Variable")   
  
   [System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";"+$GroovyInstallDirectory+"$GroovySubFolderName\bin",''), "Machine")

   #  [System.Environment]::SetEnvironmentVariable("PATH", "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;", "Machine")

}

Write-Host ("Creating Installation folder {0}" -f  $GroovyInstallDirectory)
New-Item -ItemType directory -Path $GroovyInstallDirectory

Set-Location $GroovyInstallDirectory
$shell = new-object -com shell.application
$zip = $shell.Namespace($GroovyInstallerLocation)

Write-Host ("Unzipping Groovy Fuse")

foreach($item in $zip.items())
{

    $shell.Namespace("$GroovyInstallDirectory").copyhere($item)
}

Write-Host ("Adding GROOVY_HOME Environment Variable")
[System.Environment]::SetEnvironmentVariable("GROOVY_HOME", $GroovyInstallDirectory+$GroovySubFolderName, "Machine")

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Adding GROOVY to Path Environment Variable")
[System.Environment]::SetEnvironmentVariable("PATH", $Path+";"+$GroovyInstallDirectory+"$GroovySubFolderName\bin", "Machine")

#Start-Job -Name JBoss-Fuse -ScriptBlock {Set-Location ($GroovyInstallDirectory+"jboss-fuse-6.1.0.redhat-379;.\bin\fuse.bat")}

Set-Location c:\

Write-Host ("Finished Installing Groovy")