
Write-Host ("***Installing JDK***")

. C:\Setup\Get-Environment-Variables.ps1
Write-Host ("Created Variables")




#$java =  Get-WmiObject -Class Win32_Product -Filter "Name like 'Java SE Development Kit 7%'" 

Write-Host ("Checking for installed Java version")
$JavaVersion = Get-WmiObject -Class Win32_Product -Filter "Name like 'Java SE Development Kit 7%'" | Select -Expand Version

$Path= [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host ("Installed Java version {0}" -f $JavaVersion)

 if ($JavaVersion -eq '1.7.0.710')
 {
 
    Write-Host ("Uninstalling Java 7 Update")
 
    $Java7Update= Get-WmiObject -Class Win32_Product -Filter "Name like 'Java 7 Update%'"

    $Java7Update.Uninstall()

    Write-Host ("Uninstalling Java SE Development Kit 7")

    $Java7SDK= Get-WmiObject -Class Win32_Product -Filter "Name like 'Java SE Development Kit 7%'"

    $Java7SDK.Uninstall()


    Write-Host ("Removing JAVA_HOME Environment Variable")
   [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $null, "Machine")

   Write-Host ("Removing JDK from Path Environment Variable")   
   [System.Environment]::SetEnvironmentVariable("PATH", $Path.Replace(";$JDKInstallDir\bin",''), "Machine")

 }
     
    Write-Host ("Installing JDK 7")
     $arguments = @(
	    '/s',
	    "/v/qn`" INSTALLDIR=\`"$JDKInstallDir\`" REBOOT=Supress IEXPLORER=0 MOZILLA=0 /L \`"install.log\`"`""
    )

    $proc = Start-Process $JavaJDKInstallerLocation -ArgumentList $arguments -Wait -PassThru
    if($proc.ExitCode -ne 0) {
	    Throw "ERROR" + $proc.ExitCode
    }
 
 $Path= [Environment]::GetEnvironmentVariable("PATH","Machine")
  
     Write-Host ("Setting Environment Variable")
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $JDKInstallDir, "Machine")

    Write-Host ("Adding JDK to Path Environment Variable")
    [System.Environment]::SetEnvironmentVariable("PATH", $Path+";$JDKInstallDir\bin", "Machine")

    
    Write-Host ("Finished Installing JDK")