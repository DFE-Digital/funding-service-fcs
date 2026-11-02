#Feature656 Contract Data Load - New Contracts
@#Feature656_Contract_Data_Load__New_Contracts
@ImplementTheValidationRulesForContract 
Feature: Implement The Validation Rules for Contracts
		In order to create a new contract in the system from XLS file
	    Each record and on every tabs will be validated and reported

#CONTRACT LEVEL
@AcceptanceTest @Withdrawn20221104
Scenario: E001 Ensure error is thrown for a UKPRN which is not known to PIMS. (CBR001)
	Given an excel spreadsheet 'MAIN AY 1718 28032018084546 v2_E001.xlsx' exist at 'DataFiles\BusinessRules'
	And   UKPRN field 'A2' contains '10000000' on the 'Contract' tab of the excel spreadsheet
	And   the override date is '12/07/2017'
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 
	And   '[Contract] UKPRN is not a valid organisation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Contract] UKPRN is not a valid organisation' is displayed in field 'W2' on the 'Contract Allocation' tab of the result report
	And   '[Contract] UKPRN is not a valid organisation' is displayed in field 'N2' on the 'Deliverable' tab of the result report
#   And   Contract with UKPRN of '10000000' is not created in CRM
	And   no contracts exist in CRM for UKPRN '10000000'

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR002
Scenario: E002 Ensure error is thrown for an organisation with inactive status on the org service (CBR002)
	Given an excel spreadsheet 'AGE FY 1516 09042015090000 CBR002.xlsx' exist at 'DataFiles\BusinessRules'
	And   the override date is '12/05/2017'
	And UKPRN field 'A2' contains '10009987' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] UKPRN is not an active organisation' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] UKPRN is not an active organisation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] UKPRN is not an active organisation' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And the override date is reset

	##- Commented as In administration should not throw an error - Refer to  A428BulkImportValidationForProviderWithInAdministrationStatusWithoutAnError Bug - TFS 13701 
#@AcceptanceTest
#@NewDraftContracts @CBR002
#@Complete
#Scenario: Ensure error is thrown for an organisation in administration on the org service
#	Given an excel spreadsheet 'AGE FY 1516 09042015090000 CBR002P2.xlsx' exist at 'DataFiles\BusinessRules'
#	And UKPRN field 'A2' contains '88999992' on the 'Contract' tab of the excel spreadsheet
#	When the file for syntax validation is copied from the source location to the 'Input'
#	Then I should see a file for syntax validation success report
#	And a results report excel spreadsheet is generated in the storage 
#	And '[Contract] UKPRN is not an active organisation' is displayed in field 'J2' on the 'Contract' tab of the result report
#	And '[Contract] UKPRN is not an active organisation' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
#	And '[Contract] UKPRN is not an active organisation' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR003
Scenario: E007 Ensure error is thrown if CRM intent value on contract is not valid (CBR003)
	Given an excel spreadsheet 'MAIN AY 1516 09042015090000 CBR003.xlsx' exist at 'DataFiles\BusinessRules'
	And   the override date is '12/05/2017'
	And field  'F2' contains 'Non' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'New' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] CRM intent is not a valid value' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] CRM intent is not a valid value' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] CRM intent is not a valid value' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And the override date is reset

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR004
Scenario: E008 Ensure error is thrown if Contract type not valid (CBR004)
	Given an excel spreadsheet 'MAIN AY 1516 09042015090000 CBR004.xlsx' exist at 'DataFiles\BusinessRules'
	And   the override date is '12/05/2017'
	And field  'I2' contains 'CoccaColla' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] Contract Type is not a valid contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] Contract Type is not a valid contract' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] Contract Type is not a valid contract' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And the override date is reset

#ImplementTheValidationRulesForMasterAndContract @CBR005
#Ensure error is thrown if Contract type not valid for funding type

@AcceptanceTest @Withdrawn20221104
Scenario: A010 Check that CBR007 traps the creation of a subsequest contract in cases where it is not allowed 
    # This test also trips MBR003
    Given there are no allocations marked as Under Termination for UKPRN '10017010' 
    And   there are no terminated or closed allocations for UKPRN '10017010' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017010' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017010' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-010      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-AS1920     |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017010' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017010 Co Ltd' with UKPRN '10017010' and OrgId 'ORG0017010' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017010' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017010 | 117010 | 10017010 Co Ltd | 0              | Locked Restructure    | Yes           | AA017010      | ?             | 57a Bridge Street Row  | Chester                | ?                      | ?                      | ?                      | ?                      | CH1 1NW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017010 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017010 | 10017010 Co Ltd      | ESFA-010             | AEBP-010       | 1                     | 01/08/2019        | 31/07/2020      | 21710.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017010 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017010 | AEBP-010       | AEBA-010      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 21710.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017010 | AEBP-010       | AEBA-010      | 1               | 0                     | 21710.00  | 216.00   | 3260.00  | 548.00   | 1284.00  | 58.00    | 3735.00  | 2825.00  | 1852.00  | 88.00    | 1679.00  | 2573.00  | 3592.00  | Adult Skills Total Funding                                      | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '23/08/2019'

    # Bulk file
    And   there are no files prefixed '10017010' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 14102019163619 v3_E010' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 14102019163619 v3_E010' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 14102019163619 v3_E010' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 14102019163619 v3_E010.xlsx' exists in the Datafiles folder and UKPRN '10017010' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CBR007
    And   'A Contract already exists for the given UKPRN,  Period and dates specified' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR003
    And   'A Master Contract already exists for the given UKPRN and Period' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR007
Scenario: E012 Ensure error is thrown if CRM intent is not the same at all levels (CBR009)
	Given an excel spreadsheet 'MAIN AY 1516 09042015090000 CBR009.xlsx' exist at 'DataFiles\BusinessRules'
	And   the override date is '12/05/2017'
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'Amendment' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'I2' contains 'New' on the 'Deliverable' tab of the excel spreadsheet	
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] The CRM Intent must be New or New Amendment across the contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] The CRM Intent must be New or New Amendment across the contract' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] The CRM Intent must be New or New Amendment across the contract' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And the override date is reset

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR010
Scenario: E013 Ensure error is thrown if Start and end date are same for a contract (CBR010)
	Given an excel spreadsheet 'MAIN AY 1516 09042015090000 CBR010.xlsx' exist at 'DataFiles\BusinessRules'
	And   the override date is '12/05/2017'
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'C2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	And field  'D2' contains '01/08/2015' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then a results report excel spreadsheet is generated in the storage 
	And '[Contract] Start and end date cannot be the same for the Contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] Start and end date cannot be the same for the Contract' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] Start and end date cannot be the same for the Contract' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And field 'A2' Contract is not created in CRM
	And the override date is reset

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR011
Scenario: E014 Ensure error is thrown if CRM intent is New and there is a value in Amendment Type (CBR011)
	Given an excel spreadsheet 'MAIN AY 1516 09042015090000 CBR011.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '12/05/2017'
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'G2' contains 'Correction' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then a results report excel spreadsheet is generated in the storage 
	And '[Contract] AmendmentType is not as per expected data type' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] AmendmentType is not as per expected data type' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] AmendmentType is not as per expected data type' is displayed in field 'M2' on the 'Deliverable' tab of the result report
	And the override date is reset

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR013
Scenario: E015 Ensure error is thrown if CRM intent is New and a Contract number is specified (CBR013)
	Given an excel spreadsheet 'MAIN AY 1516 09042015130000 CBR013.xlsx' exist at 'DataFiles\BusinessRules'
	And the override date is '12/05/2017'
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'B2' contains 'MAIN-189' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
    And 'Failed' is displayed in field 'M2' on the 'Deliverable' tab of the result report file
	And '[Contract] A contract number cannot be specified when creating a new contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] A contract number cannot be specified when creating a new contract' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report
	And '[Contract] A contract number cannot be specified when creating a new contract' is displayed in field 'M2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20221104
@NewDraftContracts @CBR014
Scenario: E016 Ensure error is thrown where there are multiple records for the same UKPRN within same bulk file (CBR014)
	Given an excel spreadsheet 'MAIN AY 1516 09042015130000 CBR014.xlsx' exist at 'DataFiles\BusinessRules'
	And there are no files prefixed '10019204' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
	And the override date is '12/05/2017'
	And UKPRN field 'A2' contains '10019204' on the 'Contract' tab of the excel spreadsheet
	And UKPRN field 'A3' contains '10019204' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'New' on the 'Contract' tab of the excel spreadsheet
	And field  'F3' contains 'New' on the 'Contract' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] Multiple contracts exist for the given UKPRN within the file' is displayed in field 'J3' on the 'Contract' tab of the result report
	And field 'A2' Contract is not created in CRM
	And the override date is reset

