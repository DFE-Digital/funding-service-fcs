param
(
[Parameter (Mandatory=$True)] [string] $MSBuildProjectDirectory,
[Parameter (Mandatory=$True)] [string] $ServerName,
[Parameter (Mandatory=$True)] [string] $JbossinstallDirectoryOnlocalMachine,
[Parameter (Mandatory=$True)] [string] $JavaInstallersShareLocation,
[Parameter (Mandatory=$True)] [string] $DeploymentUser,
[Parameter (Mandatory=$True)] [string] $DeploymentPassword,
[Parameter (Mandatory=$True)] [string] $JavaInstallersServer,
[Parameter (Mandatory=$True)] [string] $ZipFileName,
[Parameter (Mandatory=$True)] [string] $JBossSubFolderName
)

Write-Host ("***Installing JBOSS***")


<#
$MSBuildProjectDirectory="D:\Builds\10\FCT\Manmeet-TestMaven\src\Main\Scripts"
$ServerName = "fct-AT-fuse"
$JbossinstallDirectoryOnlocalMachine ="C:\Java\JBOSS Fuse"
$JavaInstallersShareLocation = "\\fct-ci-fuse-01\JavaInstalls"
$DeploymentUser = "CIDEV\tfsbuild"
$DeploymentPassword = ""
$JavaInstallersServer = "C:\JavaInstalls"
$ZipFileName = "jboss-fuse-full-6.1.0.redhat-379.zip"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"
#>

$JBossInstallerLocation = "$JavaInstallersServer\$ZipFileName"


Write-Host ("Created Variables")

#Change Env variable
#$Path= Invoke-Expression "$MSBuildProjectDirectory\Setup\JavaMSBuildScripts\Get-EnvironmentVariable.ps1 -ComputerName FCT-AT-FUSE -Name Path"
#$Path

$Credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $DeploymentUser, ($DeploymentPassword | ConvertTo-SecureString -asPlainText -Force)

Write-Host ("Creating Installation folder {0}" -f  $JavaInstallersServer)
Invoke-Command -ComputerName $ServerName -Credential $Credentials  -ScriptBlock {param($JbossinstallDirectory) New-Item -ItemType directory -Path $JbossinstallDirectory} -ArgumentList $JavaInstallersServer

# Mount the Network Share because of credential double hopping and to avoid doing CredSSP setup
# Install PowerShell modules
# Copy SQL installation folder
Invoke-Command -ComputerName $ServerName -SessionOption (New-PSSessionOption -SkipCACheck) `
               -Credential $Credentials `
    { param($JavaInstaller) `
      net use z: \\fct-ci-fuse-01\JavaInstalls /u:CIDEV\MMONGA ; `
      Copy-Item "z:\*" -Destination "$JavaInstaller\" -Recurse -Force; `      
    } `
     -ArgumentList $JavaInstallersServer

#Creating 
Write-Host ("Creating Installation folder {0}" -f  $JbossinstallDirectoryOnlocalMachine)
Invoke-Command -ComputerName $ServerName -Credential $Credentials  -ScriptBlock {param($JbossinstallDirectory) New-Item -ItemType directory -Path $JbossinstallDirectory} -ArgumentList $JbossinstallDirectoryOnlocalMachine

#Unzip Jboss
Invoke-Command -ComputerName $ServerName -Credential $Credentials -FilePath "$MSBuildProjectDirectory\Setup\JavaMSBuildScripts\unZipJBOSS.ps1" -ArgumentList $JBossInstallerLocation, $JbossinstallDirectoryOnlocalMachine

#Set-Location ("$JbossinstallDirectory$JBossSubFolderName")


#Setting Environment Variables 


   Write-Host ("Adding KARAF_HOME Environment Variable")
  Invoke-Command -ComputerName $ServerName -Credential $Credentials  -ScriptBlock { param($path) [System.Environment]::SetEnvironmentVariable("KARAF_HOME", $path, "Machine") } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName"

   Write-Host ("Adding KARAF_BASE Environment Variable")
   Invoke-Command -ComputerName $ServerName -Credential $Credentials  -ScriptBlock { param($path) [System.Environment]::SetEnvironmentVariable("KARAF_BASE", $path, "Machine") } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName"
 

    Write-Host ("Adding KARAF_DATA Environment Variable")
 
    Invoke-Command -ComputerName $ServerName -Credential $Credentials  -ScriptBlock { param($path) [System.Environment]::SetEnvironmentVariable("KARAF_DATA", "$path\data", "Machine") } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName"   
#Setting Environment Variables 

##Start JBOSS fuse

#Write-Host ("Adding JBOSS Password file")

Invoke-Command -ComputerName $ServerName -Credential $Credentials -ScriptBlock {param($FilePath) Add-Content ("$FilePath\etc\users.properties") "`nadmin = password,admin"} -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName"

#***Run Fuse***
#Start-Process -FilePath "$JbossinstallDirectory$JBossSubFolderName\bin\fuse.bat" -ArgumentList "server" 

$remotejob = Invoke-Command -ComputerName $ServerName -Credential $Credentials -ScriptBlock {param($FilePath) ."$FilePath\bin\fuse.bat" } -ArgumentList "$JbossinstallDirectoryOnlocalMachine$JBossSubFolderName" -AsJob
#$remotejob.StopJob()


#Write-Host ("Timer to wait for JBOSS to start")
Start-Sleep -s 60

Write-Host ("###Finished Installing JBOSS###")

   