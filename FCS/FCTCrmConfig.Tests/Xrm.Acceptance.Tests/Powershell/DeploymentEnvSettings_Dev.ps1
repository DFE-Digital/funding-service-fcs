##############################################################
#                                                            #
# Powershell Script to Deploy CRM Development Package        #
#                                                            #
# 1 - Creates Environment Variables for Dev                  #
#                                                            #
##############################################################

$Username = "fctdev\fctmega"
$PasswordPath = "C:\temp\securestring.txt"

[Environment]::SetEnvironmentVariable("CrmUserName", $Username, "User")
[Environment]::SetEnvironmentVariable("CrmPasswordPath", $PasswordPath, "User")
[Environment]::SetEnvironmentVariable("DeploymentType", "Dev", "User")
[Environment]::SetEnvironmentVariable("DiscoveryServer","CRM2013DEV","User")
[Environment]::SetEnvironmentVariable("CrmUrl", "http://fct-at.cloudapp.net" , "User")
[Environment]::SetEnvironmentVariable("CrmOrg", "AcceptanceTest", "User")
[Environment]::SetEnvironmentVariable("CrmOrgDisplayName", "FCT Package Test", "User")
[Environment]::SetEnvironmentVariable("SqlServerName", "CRM2013DEV", "User")
[Environment]::SetEnvironmentVariable("SSRSUrl","http://crm2013dev/reportserver","User")
[Environment]::SetEnvironmentVariable("PackageDirectory", "C:\Dev\FCT\FCTCrmConfig.ConfigPackage\FCTCrmConfig.ConfigPackage\bin\Debug\", "User")
[Environment]::SetEnvironmentVariable("PackageFile", "FCTCrmConfig.ConfigPackage.dll", "User")
[Environment]::SetEnvironmentVariable("UnpackagedSolutionsDirectory","C:\UnpackagedSolutionFiles","User")
[Environment]::SetEnvironmentVariable("PackagedSolutionsDirectory","C:\Dev\FCT\FCTCrmConfig.ConfigPackage\FCTCrmConfig.ConfigPackage\bin\Debug\PkgFolder\Solutions\","User")
[Environment]::SetEnvironmentVariable("ManagedProperty","Unmanaged","User")
[Environment]::SetEnvironmentVariable("SolutionPackagerPath","C:\Deployment\Tools\SolutionPackager.exe","User")
[Environment]::SetEnvironmentVariable("UnPackageDirectory", "C:\Temp\", "User")
