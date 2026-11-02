param
(
$MSBuildProjectDirectory
)

#$MSBuildProjectDirectory="D:\Builds\10\FCT\Manmeet-TestMaven\src\Main\Scripts"

$ServerName = "fct-AT-fuse"
$DeploymentUser = "CIDEV\mmonga"
$DeploymentPassword = ""

$JbossinstallDirectoryOnlocalMachine ="C:\Java\JBOSS Fuse"
$JavaInstallersShareLocation = "\\fct-ci-fuse-01\JavaInstalls"

$JavaInstallersServer = "C:\JavaInstalls"
$ZipFileName = "jboss-fuse-full-6.1.0.redhat-379.zip"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"


Invoke-Expression "& '$MSBuildProjectDirectory\Setup\JavaMSBuildScripts\Install-Jboss.ps1' -MSBuildProjectDirectory '$MSBuildProjectDirectory'' -ServerName '$ServerName' -JbossinstallDirectoryOnlocalMachine '$JbossinstallDirectoryOnlocalMachine' -JavaInstallersShareLocation '$JavaInstallersShareLocation' -DeploymentUser  '$DeploymentUser' -DeploymentPassword  '$DeploymentPassword' -JavaInstallersServer '$JavaInstallersServer' -ZipFileName '$ZipFileName' -JBossSubFolderName '$JBossSubFolderName'"