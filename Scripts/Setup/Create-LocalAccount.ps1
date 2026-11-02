Param(
    [Parameter(Mandatory=$true, HelpMessage="You must provide a name for the website.")]
    $AccountName,
    $AccountDescription,
    $AccountPassword = ""
    )

$computerOu = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

Write-Host -ForegroundColor Yellow "Creating $AccountDescription ..."
$fenergoService = $computerOu.Create("User", $AccountName)
$fenergoService.SetPassword($AccountPassword)
$fenergoService.SetInfo()
$fenergoService.FullName = $AccountDescription
$fenergoService.SetInfo()
$fenergoService.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
$fenergoService.SetInfo()
$fenergoService.Description = $AccountDescription
$fenergoService.SetInfo()