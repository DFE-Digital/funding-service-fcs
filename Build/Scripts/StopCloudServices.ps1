param (
    [Parameter(Mandatory=$true)][String]$environmentName
)

$serviceNames = @(
    "fcs-worker-${environmentName}", 
    "fct-operations-${environmentName}", 
    "fct-operations-web-${environmentName}", 
    "fct-orgservice-${environmentName}", 
    "fct-servicebus-${environmentName}"
)

$services = Get-AzureService `
    | Where-Object { $_.ServiceName -in $serviceNames } `
    | Where-Object { (Get-AzureRole -ServiceName $_.ServiceName -ErrorAction SilentlyContinue) -ne $null }
    
$services | ForEach-Object {
    $serviceName  = $_.ServiceName
    $stopped = $false
    $loopCount = 1

    while (!$stopped) {
        try {
            Write-Host "Stopping" $serviceName
            Stop-AzureService $serviceName -ErrorAction Stop
            Write-Host "Successfully called Stop-AzureService for ${serviceName}"
            $stopped = $true
        }
        catch {
            Write-Host "Caught exception stopping :" $serviceName
            Write-Host $_.Exception.Message
            if ($loopCount -gt 10) {
                throw "Maximum retry count exceeded while attempting to stop ${serviceName}"
            }
            Start-Sleep -Seconds 30 | Out-Null
            $loopCount++;
        }
    }
}

$stopped = $false
$loopCount = 1
while (!$stopped) {
    Write-Host "Attempt ${loopCount} testing for stopped at" (get-date -Format 'yyyy-MM-dd HH:mm:ss')
    $stopped = $true
    $services | ForEach-Object {
        $serviceName = $_.ServiceName
        if ($stopped) {
            try {
                Get-AzureRole -ServiceName $_.ServiceName -InstanceDetails -ErrorAction Stop | ForEach-Object {
                    if ($stopped -and $_.InstanceStatus -ne "StoppedVM") {
                        Write-Host ($_.ServiceName) is not yet stopped
                        $stopped = $false
                    }
                }
            }
            catch {
                Write-Host "Caught Exception checking ${serviceName}"
                Write-Host $_.Exception.Message
                $stopped = $false
            }
        }
    }
    if (!$stopped) { 
        if ($loopCount -gt 60) {
            throw "Maximum retry count exceeded while waiting for services to stop, aborting"
        } 
        Start-Sleep -Seconds 10 | Out-Null 
        $loopCount++;
    }
}

Write-Host "All services now stopped at" (get-date -Format 'yyyy-MM-dd HH:mm:ss')
