param
(
[Parameter (Mandatory=$True)] [string] $JBossInstallerLocation,
[Parameter (Mandatory=$True)] [string] $InstallDirectory

)

$shell = new-object -com shell.application
$zip = $shell.Namespace($JBossInstallerLocation)
$destination = $shell.namespace($InstallDirectory)
Write-Host ("Unzipping JBOSS Fuse")

foreach($item in $zip.items())
{
    $destination.copyhere($item)
}