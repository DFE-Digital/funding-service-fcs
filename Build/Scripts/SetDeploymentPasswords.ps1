#$Env:BUILD_SOURCESDIRECTORY = "C:\OnPrem\FCT"
#$Env:BUILD_DEFINITIONNAME = "Dev CI to Live"
#$ENV:BuildConfiguration = "Release"
#$ENV:PasswordFileLocation = "C:\sfa-gov-uk\DevOps\FCS\Build Variables\Passwords.json"

$contents = ([System.IO.File]::ReadAllText($ENV:PasswordFileLocation) | ConvertFrom-Json)
$credentials = ($contents.Environments.where({$_.Environment -eq $ENV:BuildConfiguration})).Credentials

if ($credentials -eq $null) {
    throw "Credentials cannot be found for environment: '$ENV:BuildConfiguration'"
}

$crmIntegrationPassword = $credentials.CRMIntegration.Password
$crmIntegrationOAUTHAppKey = $credentials.CRMIntegration.OAUTHAppKey
$dasEngagementsKey = $credentials.DasEngagements.SecretKey
$paasDBPassword = $credentials.PaasDB.Password
$fctservicesDbPassword = $credentials.PaasDB.FctServices
$reportDeliveryPassword = $credentials.ReportDelivery.Password
$serviceBusKey = $credentials.ServiceBus.SharedAccessKey
$sharepointSecretKey = $credentials.SharePoint.SecretKey
$storageKey = $credentials.Storage.AccountKey
$paymentFileFtpPassword = $credentials.PaymentFilesFtpSite.FtpPassword
$paymentFileEncryptionPassword = $credentials.PaymentFilesFtpSite.PaymentFileEncryptionPassword
$svcFcsIntegritycheckerPassword = $credentials.IntegrityChecker.Password
$D365svcFcsIntegritycheckerPassword = $credentials.CRMReplicaDB.svcFCSIntegrityCheckerPassword
$CRMReplicaFcsAdminPassword = $credentials.CRMReplicaDB.FCSAdminPassword
$SLDAccountKey = $credentials.SLDClientSecret.AccountKey
$DCFundingClaimsAPIClientSecret = $credentials.DCFundingClaimsAPIClientSecret.OAUTHclientsecret
$CFSClientSecret = $credentials.CFSClientSecret.secret

$rootFolder = "$Env:BUILD_SOURCESDIRECTORY"

$publishFiles = (Get-ChildItem -Path "$rootFolder" -Filter "app.$ENV:BuildConfiguration.config" -Recurse) + 
                (Get-ChildItem -Path "$rootFolder" -Filter "web.$ENV:BuildConfiguration.config" -Recurse) 
 
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)

foreach ($publishFile in $publishFiles.FullName) {

    $fileContents = $null

    $reader = $null
    $reader = New-Object System.IO.StreamReader($publishFile)#, $Utf8NoBomEncoding)
    $fileContents = $reader.ReadToEnd() 
    $reader.Close()
   
    $newFileContents = $fileContents

    $newFileContents = $newFileContents.Replace("##CRMIntegrationPassword##", $crmIntegrationPassword) 
    $newFileContents = $newFileContents.Replace("##CrmIntegrationOAUTHAppKey##", $crmIntegrationOAUTHAppKey) 
    $newFileContents = $newFileContents.Replace("##DasEngagementsSecretKey##", $dasEngagementsKey)
    $newFileContents = $newFileContents.Replace("##PaaSDBPassword##", $paasDBPassword)
	$newFileContents = $newFileContents.Replace("##fct-servicesDbPassword##", $fctservicesDbPassword);
    $newFileContents = $newFileContents.Replace("##ReportDeliveryPassword##", $reportDeliveryPassword)
    $newFileContents = $newFileContents.Replace("##ServiceBusKey##", $serviceBusKey)
    $newFileContents = $newFileContents.Replace("##SharepointSecretKey##", $sharepointSecretKey)
    $newFileContents = $newFileContents.Replace("##StorageAccountKey##", $storageKey)
	$newFileContents = $newFileContents.Replace("##PaymentFileFtpPassword##", $paymentFileFtpPassword)
	$newFileContents = $newFileContents.Replace("##PaymentFileEncryptionPassword##", $paymentFileEncryptionPassword)
	$newFileContents = $newFileContents.Replace("##SvcFcsIntegrityCheckerPassword##", $svcFcsIntegritycheckerPassword)
	$newFileContents = $newFileContents.Replace("##D365SvcFcsIntegrityCheckerPassword##", $D365svcFcsIntegritycheckerPassword)
	$newFileContents = $newFileContents.Replace("##CRMReplicaFcsAdminPassword##", $CRMReplicaFcsAdminPassword)
    $newFileContents = $newFileContents.Replace("##SLDClientSecret##", $SLDAccountKey)
    $newFileContents = $newFileContents.Replace("##DCFundingClaimsAPIClientSecret##", $DCFundingClaimsAPIClientSecret)
    $newFileContents = $newFileContents.Replace("##CFSClientSecret##", $CFSClientSecret)

    if ($newFileContents.IndexOf('##') -gt -1) {
        throw "Incomplete substitution in $publishFile"
    }

    $bakFile = $publishFile + ".bak"
    if (Test-Path ($bakFile)) {
        Remove-Item ($bakFile)
    }

    [System.IO.File]::Move($publishFile, $bakFile)

    Write-Host "Updating $publishFile with secrets"

    $writer = $null
    $writer = New-Object System.IO.StreamWriter($publishFile, $false, $Utf8NoBomEncoding)
    
    $writer.write($newFileContents)#[$newFileContents.Count-1])
    $writer.Flush()
    $writer.Close()
}