Write-Host ("***Installing Maven***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")


#Remove-Item $MavenInstallDirectory -Force -Recurse

$isFolderExist= Test-Path $MavenInstallDirectory

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

if($isFolderExist -eq $true)
{  
    Write-Host ("Removing Existing Maven Installation")
    Remove-Item $MavenInstallDirectory -Force -Recurse

     Write-Host ("Removing M2_HOME Environment Variable")
   [System.Environment]::SetEnvironmentVariable("M2_HOME", $null, "Machine")

   Write-Host ("Removing Maven from Path Environment Variable")      
   [System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";$MavenInstallDirectory$MavenSubFolderName\bin",''), "Machine")
}

Write-Host ("Creating Installation folder {0}" -f  $MavenInstallDirectory)
New-Item -ItemType directory -Path $MavenInstallDirectory

 Write-Host ("Removing Maven from Path Environment Variable")   
 [System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";$MavenInstallDirectory$MavenSubFolderName\bin",''), "Machine")

Set-Location $MavenInstallDirectory
$shell = new-object -com shell.application

Write-Host ("Unzipping Maven")

$zip = $shell.Namespace($MavenInstallerLocation)
foreach($item in $zip.items())
{
    $shell.Namespace("$MavenInstallDirectory").copyhere($item)
}


Write-Host ("Adding Maven Repository location to settings.xml file")

 $MavenSystemXmlPathLocation = "$MavenInstallDirectory$MavenSubFolderName\conf\settings.xml"
 $xml = [xml](Get-Content $MavenSystemXmlPathLocation)

 $localRepositoryNode = $xml.CreateElement("localRepository")
 $localRepositoryNode.set_InnerText($MavenRepositoryLocation)
   
 $xml.settings.AppendChild($localRepositoryNode)

 $xml.Save($MavenSystemXmlPathLocation) 

 $Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Adding M2_HOME Environment Variable")
[System.Environment]::SetEnvironmentVariable("M2_HOME", "$MavenInstallDirectory$MavenSubFolderName", "Machine")

Write-Host ("Adding Maven from Path Environment Variable")   
[System.Environment]::SetEnvironmentVariable("PATH", $Path+";$MavenInstallDirectory$MavenSubFolderName\bin", "Machine")

Set-Location "C:\"


Write-Host ("###Finished Installing Maven###")