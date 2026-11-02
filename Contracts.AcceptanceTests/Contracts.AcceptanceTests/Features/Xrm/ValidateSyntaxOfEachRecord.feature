#Feature656 Contract Data Load - New Contracts
@#Feature656_Contract_Data_Load__New_Contracts

Feature:ValidateSyntaxOfEachRecord 
	In order to create a new contract in the system from XLS file
	Each record and on every tabs will be validated and reported

@AcceptanceTest @Withdrawn20221104
Scenario: E057 Ensure error is thrown if Mandatory data (UKPRN) is not present on any tabs (RSR001)
	Given an excel spreadsheet 'MAIN AY 1516 19032015143000 MissingUKPRN.xlsx' exist at 'DataFiles'
	And   there is no Contract, Task or Workflow data for UKPRN '89998884'
	And   there is no Contract, Task or Workflow data for UKPRN '89998885'
	And   there is no Contract, Task or Workflow data for UKPRN '89998886'

	# Change the date
	And   the override date is '23/08/2015'

	# Process the file
	When  the file for syntax validation is copied from the source location to the 'Input'
	And   the contract request service has finished processing valid records	
	Then  a new contract has been created in Crm for Valid records
	And   I should see a file for syntax validation success report 
	And   a results report excel spreadsheet is generated in the storage 

	# Note: This test does not generate an RSR001 message

	# Contract tab results
	And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
	    # RSR003 message
	And   '[Contract] UKPRN is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	    # RSR004 message
	And   '[Contract] UKPRN is not as per expected length as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   'Success' is displayed in field 'J3' on the 'Contract' tab of the result report
	And   'Success' is displayed in field 'J4' on the 'Contract' tab of the result report

	# Contract Allocation tab results
	And   'Operation has timed out. Please check if Contract has been created.' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And   'Success' is displayed in field 'R3' on the 'Contract Allocation' tab of the result report
	And   'Success' is displayed in field 'R4' on the 'Contract Allocation' tab of the result report

    # Deliverable tab results
	And   'Operation has timed out. Please check if Contract has been created.' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And   'Success' is displayed in field 'M14' on the 'Deliverable' tab of the result report
	And   'Success' is displayed in field 'M26' on the 'Deliverable' tab of the result report

	#Tidy up
	And   the override date is reset

@ValidateSyntaxOfEachRecord @RSR003
@AcceptanceTest
@Withdrawn20221104
Scenario: E058 Ensure error is thrown if Data types are incorrect (RSR003)
	Given an excel spreadsheet 'MAIN AY 1516 19032015143000 InvalidDataTypes.xlsx' exist at 'DataFiles'
	And the override date is '01/08/2015'
	And UKPRN field 'A2' contains 'AAAAAAAA' on the 'Contract' tab of the excel spreadsheet 
	And field 'C2' contains 'BBBBBB' on the 'Contract' tab of the excel spreadsheet 
	And field 'D2' contains 'CCCCCC' on the 'Contract' tab of the excel spreadsheet 
	And field 'F2' contains 'DDDDDD' on the 'Contract Allocation' tab of the excel spreadsheet 
	And field 'E2' contains 'EE' on the 'Deliverable' tab of the excel spreadsheet 
	And field 'G2' contains 'FFF' on the 'Deliverable' tab of the excel spreadsheet 
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] UKPRN is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] Contract Start Date is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] Contract End Date is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Period is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Value is not as per expected data type as specified in 'Bulk Import File Spec' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@ValidateSyntaxOfEachRecord @RSR004	
@AcceptanceTest
@Withdrawn20221104
Scenario: E025 Ensure error is thrown when there are fields with the incorrect length (RSR004)
	Given an excel spreadsheet '24+LOANS AY 1516 17022115090000 DataLengthsIncorrect.xlsx' exist at 'DataFiles'
	And the override date is '01/08/2015'
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] UKPRN is not as per expected length as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	#And '[Contract] ContractDescription is not as per expected length as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] UKPRN is not as per expected length as specified in 'Bulk Import File Specification'' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] UKPRN is not as per expected length as specified in 'Bulk Import File Specification'' is displayed in field 'M2' on the 'Deliverable' tab of the result report
		
@ValidateSyntaxOfEachRecord @RSR005
@AcceptanceTest
@Withdrawn20221104
Scenario: E026 Ensure error is thrown if an end date is before the start date on any tabs (RSR005)
	Given an excel spreadsheet '24+LOANS AY 1516 17022115090000 StartDateAfterEndDate.xlsx' exist at 'DataFiles'
	And the override date is '01/08/2015'
	And UKPRN field 'A2' contains '10000671' on the 'Contract' tab of the excel spreadsheet 
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] An end date cannot be before the start date' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] An end date cannot be before the start date' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report


  