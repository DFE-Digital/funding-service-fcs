##############################################################
#                                                            #
# Powershell Script to Deploy CRM Development Package        #
#                                                            #
# 1 - Creates Environment Variables for AT                   #
#                                                            #
##############################################################

[Environment]::SetEnvironmentVariable("DeploymentType", "AT", "User")
[Environment]::SetEnvironmentVariable("DiscoveryServer","fct-at.cloudapp.net","User")
[Environment]::SetEnvironmentVariable("CrmUrl", "http://fct-at.cloudapp.net" , "User")
[Environment]::SetEnvironmentVariable("CrmOrg", "AcceptanceTest", "User")
[Environment]::SetEnvironmentVariable("CrmOrgDisplayName", "Acceptance Test", "User")
[Environment]::SetEnvironmentVariable("SqlServerName", "FCT-AT", "User")
[Environment]::SetEnvironmentVariable("SSRSUrl","http://fct-at/ReportServer","User")


[Environment]::SetEnvironmentVariable("CrmUserName", "fctdev\fctmega", "User")
[Environment]::SetEnvironmentVariable("CrmPassword", "", "User")
[Environment]::SetEnvironmentVariable("UnPackageDirectory", "C:\Temp\", "User")