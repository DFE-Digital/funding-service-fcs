@#Feature1193_Load_Basic_Org_Data
Feature: Load Basic Org Data
	As an Allocations Manager, when contract data is being loaded via the contract service, 
	I want to retrieve key organisation data (Legal Name & Status) for a given UKPRN, 
	so that the organisation record can be loaded into in CRM.

# Now being tested in A178 

@AcceptanceTest @Withdrawn20201016
Scenario: B012 Ensure Organisation is not duplicated when it already exists in CRM system
	Given the following Organisations exist in CRM
	| UKPRN    | Name             | Status |
	| 10009995 | LEARNING LIMITED | Active |
	
	And the following Organisations exist in the FCT Organisation Service
	| UKPRN    | UPIN     | Name             | SequenceNumber | Status |
	| 10009995 | 10009995 | LEARNING LIMITED | 0              | Active |
	
	And Bulk Upload file 'MAIN AY 1516 10022015152601 10009995.xlsx' file exists at 'DataFiles' with a UKPRN '10009995'
	And the override date is '01/08/2015'
	
	When the file for syntax validation is copied from the source location to the 'Input'
	
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And UKPRN '10009995' is not duplicated in CRM
	And the override date is reset

	 