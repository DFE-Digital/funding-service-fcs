Feature: ImportActuals
	In order to calculate payments
	As the FCS system
	I want to import summarised actuals from DCFS

@mytag
Scenario: Import Actuals
	Given approved contract abc123 version 1
	And summarised actuals
	When the summarised actuals import process is invoked
	Then summarised actuals are imported into FCS
