@AcceptanceTest
#Feature ID - 1194
@#Feature1194_Configure_Reference_Data_(LEP_&_UOP)
Feature: Configure Reference Data (LEP & UOP)
	

# USer Story - 1022 - Load LEP Data - (Configure in CRM)

Scenario: Load LEP Data - (Configure in CRM)
	Given that LEP organisation data exists
	When I upload the LEP data in CRM 
	Then these LEP Organisation are avaialbe in CRM
	| LEP Name                              | LEP Code | Organisation Category |
	| Cornwall and Isles of Scilly          | E37005   | LEP                   |
	| Heart of the South West               | E37016   | LEP                   |
	| York, North Yorkshire and East Riding | E37039   | LEP                   |
	| Stoke-on-Trent and Staffordshire      | E37032   | LEP                   |

# User Story - 1856 - Configure Uop reference data - (Configure in CRM)

@#Userstory1856_Configure_UoP_reference_data
Scenario: Load UoP Data Configure in CRM
	Given that UoP organisation data exists
	When I upload the UoP data in CRM 
	Then these UoP Organisation are avaialbe in CRM
	| UoP Name            | UoP Code | 
	| UoP - South West    | USW      |
	| UoP - West Midlands | UWM      |
	| UoP - North West    | UNW      | 
	| UoP - Kent & Sussex | UKS      |
