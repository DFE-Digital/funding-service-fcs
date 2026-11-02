@#Feature656_Contract_Data_Load__New_Contracts

Feature: Implement The Validation Rules for Master Contracts
		In order to create a new contract in the system from XLS file
	    Each record and on every tabs will be validated and reported

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForMasterContracts @NewDraftContracts @RSR002
	Scenario: E018 Bulk load a new 1516 Mainstream contract with an OLASS allocation. Fail CABR-006: Mandatory UoP Code is missing
	Given a file named 'MAIN AY 1516 19032015090000 OLASSmissingUOP.xlsx' exists in 'DataFiles'
	And   the override date is '01/08/2015'
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 

	# CABR-006
	And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'M2' on the 'Deliverable' tab of the result report

#MASTER CONTRACT LEVEL
@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForMasterContracts @NewDraftContracts @MBR001
@NewAmendment
Scenario: E019 Ensure error is thrown if CRM intent is 'New Amendment' and the Master Contract Ref is not populated. Fail MBR-001: Mandatory Master Contract number is missing
	Given a file named 'MAIN AY 1516 08042015130000 MBR001.xlsx' exists in 'DataFiles\BusinessRules'
	And   the override date is '01/08/2015'
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 

	# MBR-001
	And   '[Contract] A valid Master Contract number must be specified if the CRM Intent is 'New Amendment'' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Contract] A valid Master Contract number must be specified if the CRM Intent is 'New Amendment'' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And   '[Contract] A valid Master Contract number must be specified if the CRM Intent is 'New Amendment'' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForMasterContracts @NewDraftContracts @MBR002
Scenario: E021 Ensure error is thrown if CRM intent is 'New' and a Master Contract Ref is populated (MBR002)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 MBR002.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'E2' contains 'SFA-1097' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] A Master Contract number cannot be specified when creating a new Master Contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] A Master Contract number cannot be specified when creating a new Master Contract' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] A Master Contract number cannot be specified when creating a new Master Contract' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForMasterContracts @NewDraftContracts @MBR004
Scenario: E023 Ensure error is thrown if deliverable record is not populated on the spreadsheet (MBR004)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 MBR004.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains '10019201' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	And field  'D2' contains '31/07/2016' on the 'Contract' tab of the excel spreadsheet
	And field  'A2' contains '10019201' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'D2' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'F2' contains 'New' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'A2' contains '' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] A Master Contract must contain 'Master Contract', 'Contract', 'Contract Allocation' and Deliverables' details in order to be created' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] A Master Contract must contain 'Master Contract', 'Contract', 'Contract Allocation' and Deliverables' details in order to be created' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForMasterContracts @NewDraftContracts @MBR004
Scenario: E024 Ensure error is thrown if allocation record is not populated on the spreadsheet (MBR004)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 MBR004P2.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '23/08/2015'
	And field  'A2' contains '10019201' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	And field  'D2' contains '31/07/2016' on the 'Contract' tab of the excel spreadsheet
	And field  'A2' contains '' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'A2' contains '' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] A Master Contract must contain 'Master Contract', 'Contract', 'Contract Allocation' and Deliverables' details in order to be created' is displayed in field 'J2' on the 'Contract' tab of the result report
