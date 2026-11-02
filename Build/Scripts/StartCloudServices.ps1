param (
    [Parameter(Mandatory=$true)][String]$environmentName
)

$serviceNames = @(
    "fcs-worker-${environmentName}", 
    "fct-operations-${environmentName}", 
    "fct-operations-web-${environmentName}", 
    "fct-orgservice-${environmentName}", 
    "fct-servicebus-${environmentName}",
    "fct-services-${environmentName}"
)

$services = Get-AzureService `
    | Where-Object { $_.ServiceName -in $serviceNames } `
    | Where-Object { (Get-AzureRole -ServiceName $_.ServiceName -ErrorAction SilentlyContinue) -ne $null }

$services | ForEach-Object {
    $serviceName  = $_.ServiceName
    $started = $false
    $loopCount = 1

    while (!$started) {
        try {
            Write-Host "Attempt ${loopCount} starting ${serviceName} at $(get-date -Format 'yyyy-MM-dd HH:mm:ss')"
            Start-AzureService $serviceName -ErrorAction Stop
            Write-Host "Successfully called Start-AzureService for ${serviceName}"
            $started = $true
        }
        catch {
            Write-Host "Caught exception starting :" $serviceName
            Write-Host $_.Exception.Message
            if ($loopCount -gt 10) {
                throw "Maximum retry count exceeded while attempting to start ${serviceName}"
            }
            Start-Sleep -Seconds 30 | Out-Null 
            $loopCount++;
        }
    }
}

$started = $false
$loopCount = 1
while (!$started) {
    Write-Host "Attempt ${loopCount} testing for running at" (get-date -Format 'yyyy-MM-dd HH:mm:ss')
    $started = $true
    $services | ForEach-Object {
        $serviceName = $_.ServiceName
        if ($started) {
            try {
                Get-AzureRole -ServiceName $_.ServiceName -InstanceDetails -ErrorAction Stop | ForEach-Object {
                    if ($started -and $_.InstanceStatus -ne "ReadyRole") {
                        Write-Host ($_.ServiceName) is not yet ready
                        $started = $false
                    }
                }
            }
            catch {
                Write-Host "Caught Exception checking ${serviceName}"
                Write-Host $_.Exception.Message
                $started = $false
            }
        }
    }
    if (!$started) {
        if ($loopCount -gt 60) {
            throw "Maximum retry count exceeded while waiting for services to start, aborting"
        } 
        Start-Sleep -Seconds 10 | Out-Null 
        $loopCount++;
    }
}


Write-Host "All services now running at" (get-date -Format 'yyyy-MM-dd HH:mm:ss')
