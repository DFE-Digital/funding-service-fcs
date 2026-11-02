Feature: Crm Test User Connectivity

@AcceptanceTest @Complete
Scenario: T013 Tooling - Ensure connectivity to CRM as all test users
	Then we can connect to CRM as 'FCS1 Test'
	Then we can connect to CRM as 'FCS2 Test'
	Then we can connect to CRM as 'FCS9 Test'
