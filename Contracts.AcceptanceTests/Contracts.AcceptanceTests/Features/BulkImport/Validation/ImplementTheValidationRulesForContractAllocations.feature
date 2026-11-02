#Feature656 Contract Data Load - New Contracts
@#Feature656_Contract_Data_Load__New_Contracts

Feature: Implement The Validation Rules for Contract Allocations
		In order to create a new contract in the system from XLS file
	    Each record and on every tabs will be validated and reported

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR001
Scenario: E027 Ensure error is thrown if Period type is not valid for funding stream code on allocation (CABR001)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR001.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains 'MAIN' on the 'Control Sheet' tab of the excel spreadsheet
	And field  'B2' contains 'AY' on the 'Control Sheet' tab of the excel spreadsheet
	And field  'G2' contains 'EOF' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Period type specified is not valid for the specified funding stream' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Period type specified is not valid for the specified funding stream' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Period type specified is not valid for the specified funding stream' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR002
Scenario: E028 Ensure error is thrown if Period is not valid for funding stream code on allocation (CABR002)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR002.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'G2' contains 'AGE' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Period specified is not valid for the specified funding stream' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Period specified is not valid for the specified funding stream' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Period specified is not valid for the specified funding stream' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	
@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR003
Scenario: E029 Ensure error is thrown if CRM intent value on allocation is not valid (CABR003)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR003.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'F2' contains 'Nan' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR004
Scenario: E030 Ensure error is thrown if there is more than one allocation of the same funding stream code (CABR004)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR004.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains '10019204' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'D2' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'G2' contains '16-18 APPS' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'A3' contains '10019204' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'D3' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E3' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'G3' contains '16-18 APPS' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'R3' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And field 'A2' Contract is not created in CRM
	And field 'A3' Contract is not created in CRM

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR005
Scenario: E031 Ensure error is thrown if LEP on allocation is not a valid LEP (CABR005)
	Given an excel spreadsheet 'ESF ESF 1420 08042015130000 CABR005.xlsx' exist at 'DataFiles\BusinessRules'
	And field  'I2' contains 'B47001' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] LEP must be a valid LEP' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] LEP must be a valid LEP' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] LEP must be a valid LEP' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR007
Scenario: E033 Ensure error is thrown if Contract Allocation end date is after Contract end date (CABR007)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR007.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'D2' contains '25/07/2016' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Contract Allocation end date cannot be after the Contract end date' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be after the Contract end date' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be after the Contract end date' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR008
Scenario: E034 Ensure error is thrown if Contract Allocation end date is before Contract start date (CABR008)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR008.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/07/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Contract Allocation end date cannot be before the Contract start date' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be before the Contract start date' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be before the Contract start date' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR009
Scenario: E035 Ensure error is thrown if Contract Allocation start date is before Contract start date (CABR009)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR009.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/07/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Contract Allocation start date cannot be before the Contract start date' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Contract Allocation start date cannot be before the Contract start date' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation start date cannot be before the Contract start date' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR010
Scenario: E036 Ensure error is thrown if Contract Allocation start date is after Contract end date (CABR010)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR010.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/08/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '31/08/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	And field  'D2' contains '31/07/2016' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Contract Allocation start date cannot be after the Contract end date' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Contract Allocation start date cannot be after the Contract end date' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation start date cannot be after the Contract end date' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR011
Scenario: E037 Ensure error is thrown if Contract Allocation start and end date is the same (CABR011)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR011.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'D2' contains '01/08/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '01/08/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	And field  'D2' contains '31/07/2016' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Start and end date cannot be the same for the Contract Allocation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Start and end date cannot be the same for the Contract Allocation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Start and end date cannot be the same for the Contract Allocation' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And field 'A2' Contract is not created in CRM

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR012
Scenario: E038 Ensure error is thrown if Start and end date are not specified for ESF (CABR012)
	Given an excel spreadsheet 'ESF ESF 1420 08042015130000 CABR012.xlsx' exist at 'DataFiles\BusinessRules'
	And field  'D2' contains '' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'A2' contains 'ESF' on the 'Control Sheet' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Start and End date for the Contract Allocation must be specified for ESF, EOP and EOF funding types' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Start and End date for the Contract Allocation must be specified for ESF, EOP and EOF funding types' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Start and End date for the Contract Allocation must be specified for ESF, EOP and EOF funding types' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR014
Scenario: E041 Ensure error is thrown if CRM Intent is 'New', and Contract Allocation number is populated (CABR014)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR014.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'F2' contains 'New' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'C2' contains '16AP-2041' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] A Contract Allocation number cannot be specified when creating a new Contract Allocation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] A Contract Allocation number cannot be specified when creating a new Contract Allocation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] A Contract Allocation number cannot be specified when creating a new Contract Allocation' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR015
Scenario: E042 Ensure error is thrown if Funding Stream Code not valid for funding type (CABR015)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 CABR015.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And   field  'G2' contains 'ESF' on the 'Contract Allocation' tab of the excel spreadsheet
	And   field  'A2' contains 'MAIN' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'B2' contains 'AY' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'C2' contains '1516' on the 'Control Sheet' tab of the excel spreadsheet
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR015
Scenario: E081 Ensure error is thrown if Funding Stream Code not valid for funding type and funding period (CABR015)
	Given an excel spreadsheet 'MAIN AY 1718 22042016155603 CABR015.xlsx' exist at 'DataFiles\BusinessRules'
	And   field  'G2' contains '24+ ALLBC' on the 'Contract Allocation' tab of the excel spreadsheet
	And   field  'A2' contains 'MAIN' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'B2' contains 'AY' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'C2' contains '1718' on the 'Control Sheet' tab of the excel spreadsheet
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'W2' on the 'Contract Allocation' tab of the result report
	And   '[Contract Allocation] Funding Stream Period is not valid for the Funding Type Period' is displayed in field 'N2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForContractAllocations @NewDraftContracts @CABR015
Scenario: E082 Ensure no errors are thrown if Funding Stream Code is valid for funding type and funding period (CABR015)
	Given there is no Contract, Task or Workflow data for UKPRN '10019204'

	# Change the date
	And the override date is '12/12/2017'

	And   an excel spreadsheet 'MAIN AY 1718 12042016155603 CABR015.xlsx' exist at 'DataFiles\BusinessRules'
	And   field  'G2' contains '16-18 APPS' on the 'Contract Allocation' tab of the excel spreadsheet
	And   field  'A2' contains 'MAIN' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'B2' contains 'AY' on the 'Control Sheet' tab of the excel spreadsheet
	And   field  'C2' contains '1718' on the 'Control Sheet' tab of the excel spreadsheet
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   all contracts have been successful