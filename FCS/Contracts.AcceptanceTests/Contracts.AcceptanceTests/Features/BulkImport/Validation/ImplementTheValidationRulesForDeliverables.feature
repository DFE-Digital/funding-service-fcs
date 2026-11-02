#Feature656 Contract Data Load  New Contracts
@#Feature656_Contract_Data_Load__New_Contracts

Feature: Implement The Validation Rules for Deliverables
		In order to create a new contract in the system from XLS file
	    Each record and on every tabs will be validated and reported

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR001
Scenario: E043 Ensure error is thrown if CRM intent value on Deliverable is not valid (DBR001)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR001.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'I2' contains 'Bew' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable]CRM intent is not a valid value' is displayed in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
	And '[Deliverable]CRM intent is not a valid value' is displayed in Row '2' of the 'Results' Column on the 'Contract Allocation' tab of the result report
	And '[Deliverable]CRM intent is not a valid value' is displayed in Row '2' of the 'Results' Column on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR002
Scenario: E044 Ensure error is thrown if Deliverable is not valid for Funding Stream Period (DBR002)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR002.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains '10019204' on the 'Deliverable' tab of the excel spreadsheet
	And field  'H2' contains '9' on the 'Deliverable' tab of the excel spreadsheet
	And field  'G2' contains '16-18 APPS' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Deliverable is not a valid deliverable for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverable is not a valid deliverable for the Funding Stream Period' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Deliverable is not a valid deliverable for the Funding Stream Period' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR004
Scenario: E045 Ensure error is thrown if Deliverable is not populated for each of the month of contract allocation (DBR004)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR004.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains '10019204' on the 'Deliverable' tab of the excel spreadsheet
	And field  'C2' contains '16-18 APPS' on the 'Deliverable' tab of the excel spreadsheet
	And field  'D2' contains '16-18 Apprenticeships Programme Funding' on the 'Deliverable' tab of the excel spreadsheet
	And field  'E2' contains '8' on the 'Deliverable' tab of the excel spreadsheet
	And field  'F2' contains '2015' on the 'Deliverable' tab of the excel spreadsheet
	And field  'H2' contains '2' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I2' contains 'New' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] A Deliverable must contain a period record for each month of the Contract Allocation in the Deliverable tab' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] A Deliverable must contain a period record for each month of the Contract Allocation in the Deliverable tab' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] A Deliverable must contain a period record for each month of the Contract Allocation in the Deliverable tab' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR005
Scenario: E046 Ensure error is thrown if Year and Period combination for the Deliverable fall outside the Contract Allocation start and end dates (DBR005)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR005.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'A2' contains '10019204' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'D2' contains '01/08/2015' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'E2' contains '30/07/2016' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'F2' contains '2014' on the 'Deliverable' tab of the excel spreadsheet
	And field  'F7' contains '2015' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M7' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M8' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M9' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M10' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M11' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M12' on the 'Deliverable' tab of the result report
	And '[Deliverable] Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates' is displayed in field 'M13' on the 'Deliverable' tab of the result report

#@AcceptanceTest1
#@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR006
#Scenario: Ensure error is thrown if Deliverable code is not a valid Deliverable
#	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR006.xlsx' exist at 'DataFiles\BusinessRules'
#	And field  'H2' contains '209' on the 'Deliverable' tab of the excel spreadsheet
#	And field  'H3' contains '209' on the 'Deliverable' tab of the excel spreadsheet
#	And field  'H4' contains '209' on the 'Deliverable' tab of the excel spreadsheet
#	When the file for syntax validation is copied from the source location to the 'Input'
#	Then I should see a file for syntax validation success report
#	And a results report excel spreadsheet is generated in the storage  
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'J2' on the 'Contract' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M2' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M3' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M4' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M5' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M6' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M7' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M8' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M9' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M10' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M11' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M12' on the 'Deliverable' tab of the result report
#	And '[Deliverable] Deliverable must be a valid Deliverable' is displayed in field 'M13' on the 'Deliverable' tab of the result report
#	And field 'A2' Contract is not created in CRM

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR007
Scenario: E047 Ensure error is thrown if multiple records for the same Deliverable Period for the same Deliverable for the same Funding Stream Code (DBR007)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR003.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'E2' contains '8' on the 'Deliverable' tab of the excel spreadsheet
	And field  'E3' contains '8' on the 'Deliverable' tab of the excel spreadsheet
	And field  'E4' contains '9' on the 'Deliverable' tab of the excel spreadsheet
	And field  'E5' contains '10' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation' is displayed in field 'M7' on the 'Deliverable' tab of the result report

@AcceptanceTest  @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR008
Scenario: E048 Ensure error is thrown if CRM intent is not the same for each deliverable of same funding stream code (DBR008)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR008.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And UKPRN field 'A2' contains '10019204' on the 'Contract' tab of the excel spreadsheet
	And field  'I2' contains 'New' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I3' contains 'New' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I4' contains 'Amendment' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I5' contains 'Amendment' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I6' contains 'Amendment' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I7' contains 'Amendment' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M7' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M8' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M9' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M10' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M11' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M12' on the 'Deliverable' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'M13' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR009
Scenario: E049 Ensure error is thrown if Deliverable Description is not the same for each deliverable of same funding stream code (DBR009)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR009.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'L2' contains 'Business Rules' on the 'Deliverable' tab of the excel spreadsheet
	And field  'L3' contains 'Validation Rules' on the 'Deliverable' tab of the excel spreadsheet
	And field  'L4' contains 'Business Rules' on the 'Deliverable' tab of the excel spreadsheet
	And field  'L5' contains 'Validation Rules' on the 'Deliverable' tab of the excel spreadsheet
	And field  'L6' contains 'Business Rules' on the 'Deliverable' tab of the excel spreadsheet
	And field  'L7' contains 'Business Rules' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M7' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M8' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M9' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M10' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M11' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M12' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'M13' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR010
Scenario: E017 Ensure error is thrown if Deliverable Unit Cost is not the same for each deliverable of same funding stream code (DBR010)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR010.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'K2' contains '20' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K3' contains '40' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K4' contains '40' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K5' contains '20' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K6' contains '20' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K7' contains '20' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
    And 'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'J2' on the 'Contract' tab of the result report
	And field 'A2' Contract is not created in CRM

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR013
Scenario: E052 Ensure error is thrown if Deliverable defined as value only also have value populated in volumes (DBR013)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR013.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'J2' contains '45000' on the 'Deliverable' tab of the excel spreadsheet
	And field  'E2' contains '8' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M7' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M8' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M9' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M10' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M11' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M12' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have Volumes populated for deliverable periods' is displayed in field 'M13' on the 'Deliverable' tab of the result report
	And field 'A2' Contract is not created in CRM

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR014
Scenario: E053 Ensure error is thrown if Deliverable defined as value only, and has value populated in unit cost (DBR014)
	Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR014.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '01/08/2015'
	And field  'G2' contains '81835' on the 'Deliverable' tab of the excel spreadsheet
	And field  'K2' contains '2' on the 'Deliverable' tab of the excel spreadsheet
	And the contract data is now removed for ukprn beginning with '10019204'
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage  
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M3' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M4' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M5' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M6' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M7' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M8' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M9' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M10' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M11' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M12' on the 'Deliverable' tab of the result report
	And '[Deliverable] Deliverables defined as Value only should not have a Unit Cost against a deliverable period' is displayed in field 'M13' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@ImplementTheValidationRulesForDeliverables @NewDraftContracts @DBR015
Scenario: E054 Ensure error is thrown if Deliverable Code is not a profile deliverable (DBR015)
    Given an excel spreadsheet 'MAIN AY 1516 08042015130000 DBR015.xlsx' exist at 'DataFiles\BusinessRules'
    And   the override date is '01/08/2015'
    And   field  'G2' contains '81835' on the 'Deliverable' tab of the excel spreadsheet
    And   field  'H2' contains '1' on the 'Deliverable' tab of the excel spreadsheet
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  I should see a file for syntax validation success report
    And   a results report excel spreadsheet is generated in the storage  
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M2' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M3' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M4' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M5' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M6' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M7' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M8' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M9' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M10' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M11' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M12' on the 'Deliverable' tab of the result report
    And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'M13' on the 'Deliverable' tab of the result report
  
