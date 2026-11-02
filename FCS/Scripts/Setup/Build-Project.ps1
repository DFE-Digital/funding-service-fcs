param
(
[Parameter (Mandatory=$True)] [string]$environment
)


Write-Host ("***Building in Maven**")

        $command ="& cmd.exe /C 'mvn clean -P $environment install'"

        Invoke-Expression -Command:$command  -WarningAction SilentlyContinue

Write-Host ("###Finished Building in Maven###")