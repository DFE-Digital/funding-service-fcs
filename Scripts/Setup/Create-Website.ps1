Param(
    [Parameter(Mandatory=$true, HelpMessage="You must provide a name for the website.")]
    $SiteName,
    $Port="80",
    $UseAnonymous = $true,
    $Integrated = $true,
    $AppPoolAccount = $null,
    $AppPoolPassword = $null
    )

$WWWPath = "C:\inetpub\wwwroot"
$SitePath = "$WWWPath" + "\" + "$SiteName"
if (!(Test-Path $SitePath)) {
    Write-Host "Creating application directory ..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $SitePath
}
else
{
    Write-Host "Application directory already exists" -ForegroundColor White
}

$LogsPath = "C:\inetpub\logs\LogFiles"
$SiteLogsPath = "$LogsPath" + "\" + "$SiteName"
if (!(Test-Path $SiteLogsPath)) {
    Write-Host "Creating application logfiles directory ..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $SiteLogsPath
}
else
{
    Write-Host "Application logfiles directory already exists" -ForegroundColor White
}

Import-Module "WebAdministration" -ErrorAction Stop

$appPoolName = $SiteName
$appPoolPath = "IIS:\AppPools\$appPoolName"
if (!(Test-Path $appPoolPath -pathType container))
{
    Write-Host "Creating $SiteName application pool ..." -ForegroundColor Yellow
    $appPool = New-WebAppPool –Name $appPoolName -Force
    $appPool.Stop()

    if($AppPoolAccount)
    {
        $appPool.processModel.username = $AppPoolAccount
        $appPool.processModel.password = $AppPoolPassword
        $appPool.processModel.identityType = "SpecificUser"
    }
    else
    {
        $appPool.processModel.identityType = "NetworkService"
    }

    $appPool.managedRuntimeVersion = "v4.0"

    if($Integrated -eq $true)
    {
        $appPool.managedPipelineMode = 0
    }
    else
    {
        $appPool.managedPipelineMode = 1
    }

    $appPool | Set-Item
    $appPool.Start()
}
else
{
    Write-Host "$SiteName application pool already exists" -ForegroundColor White
}

Write-Host "Creating $SiteName website ..." -ForegroundColor Yellow
$webSite = New-Website –Name $SiteName -Port $Port -PhysicalPath $SitePath -ApplicationPool $appPoolName -Force
$webSite.logfile.directory = $SiteLogsPath
$webSite | Set-Item

if($UseAnonymous -eq $true)
{
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value true -location $SiteName
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/WindowsAuthentication -name enabled -value false -location $SiteName
}
else
{
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value false -location $SiteName
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/WindowsAuthentication -name enabled -value true -location $SiteName
}

Start-WebAppPool -Name $appPoolName
Start-WebSite $SiteName