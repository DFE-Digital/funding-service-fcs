##### Java Install variables ######
$InstallerSource = "C:" 
$InstallTarget = "c:" 
$DeploymentSource =  "C:\Projects"
#JDK
$JDKInstallDir = "$InstallTarget\Java\JDK" # Just an example, of course
$JavaJDKInstallerLocation = "$InstallerSource\JavaInstalls\jdk-7u71-windows-x64.exe"

#Fuse
$JbossinstallDirectory = "$InstallTarget\Java\JBOSS Fuse"
$JBossInstallerLocation = "$InstallerSource\JavaInstalls\jboss-fuse-full-6.1.0.redhat-379.zip"
$JBossSubFolderName="\jboss-fuse-6.1.0.redhat-379"

#Maven
$MavenInstallDirectory = "$InstallTarget\Java\Maven"
$MavenSubFolderName = "\apache-maven-3.2.5"
$MavenInstallerLocation = "$InstallerSource\JavaInstalls\apache-maven-3.2.5-bin.zip"
$MavenRepositoryLocation = "$InstallTarget\.m2\repository"

#Groovy
$GroovyInstallDirectory ="$InstallTarget\Java\Groovy"
$GroovyInstallerLocation = "$InstallerSource\JavaInstalls\groovy-binary-2.3.9.zip"
$GroovySubFolderName="\groovy-2.3.9"


##Setup

$SetupPowershellScriptLocation = "C:\Setup"

##Deployment Variables

##Use this space to create variables for new projects and their file locations.
##Use the pattern as used by other projects below
$IntegrationPatternProjectFolder ="$DeploymentSource\FCT-Integration-Pattern"
$ContractRequestDataLoadProjectFolder ="$DeploymentSource\ContractRequest.DataLoad"
$OrganisationServiceProjectFolder="$DeploymentSource\OrganisationManagement.OrganisationService"
$ContractsDocumentGenerationProjectFolder ="$DeploymentSource\Contracts.DocumentGeneration"

$FCTProfileName = "FCT-fuse-min"