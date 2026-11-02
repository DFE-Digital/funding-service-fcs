@#Feature572_Initiate_Bulk_Amendment_Creation
@InitiateBulkAmendmentCreation
Feature: InitiateBulkAmendmentCreation
	As an Allocations user
	I want to be able to bulk amend contracts that have already been approved in the system
	And apply validation rules
	And view the changes in CRM

@AcceptanceTest @Withdrawn20230118
@BulkAmendDraftContractsValidation
@DBR009
Scenario: E042 Ensure error is thrown if the Deliverable Description is not the same for each period (DBR009)
	Given The file 'ESF ESF 1420 17032016130000 BulkAmendmentValidationDBR009.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '10050000'
	And the override date is '12/12/2015'
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
@RSR003
@BulkAmendDraftContractsValidation
Scenario: E061 Attempt a contract amendment where the bulk import AmendmentType is neither Variation nor Notification: Fail RSR003
    Given a file named 'MAIN AY 1516 21052015090000 AmendmentTypeValidation.xlsx' exists in 'DataFiles\Release2'
    And   the override date is '12/12/2015'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a syntax report should exist in the Sharepoint Reports folder   
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract] AmendmentType is not as per expected data type as specified in 'Bulk Import File Specification'' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
@CBR014 @CABR003
@BulkAmendDraftContractsValidation
Scenario: E062 Validate rule CBR014/CABR003
	Given an excel spreadsheet 'MAIN AY 1516 27052015130000 BulkAmendmentValidation4.xlsx' exist at 'DataFiles\Release2'
	And the override date is '12/12/2015'
	And field 'F2' contains 'Amendment' on the 'Contract' tab of the excel spreadsheet
	And field 'F3' contains 'Amendment' on the 'Contract' tab of the excel spreadsheet
	And field 'A3' contains '91281270' on the 'Contract' tab of the excel spreadsheet
	And field 'A2' contains '91281270' on the 'Contract' tab of the excel spreadsheet
	And field 'A4' contains '91281251' on the 'Contract' tab of the excel spreadsheet
	And field 'A3' contains '91281251' on the 'Contract Allocation' tab of the excel spreadsheet
	And field 'F3' contains 'Amendments' on the 'Contract Allocation' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] Multiple contracts exist for the given UKPRN within the file' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract] Multiple contracts exist for the given UKPRN within the file' is displayed in field 'J3' on the 'Contract' tab of the result report
	And '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'J4' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
@BulkAmendDraftContractsValidation
@CBR004 @CBR010 @CABR004 @CABR007 @DBR001 @DBR003 @DBR008 @DBR009
Scenario: E063 Validate rule CBR004/CBR010/CABR004/CABR007/DBR001/DBR003/DBR008/DBR009/
    Given there are no allocations marked as Under Termination for UKPRN '10050000' 
    And   there are no terminated or closed allocations for UKPRN '10050000' 
    And   there is no Contract, Task or Workflow data for UKPRN '10050000' 

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10050000' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10050000 Co Ltd' with UKPRN '10050000' and OrgId 'ORG0050000' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10050000 | 150000 | 10050000 Co Ltd | 0              | In Administration     | Yes           | AA017358      | ?             | 71 Patrick Way         | ?                      | ?                      | ?                      | Aylesbury              | Buckinghamshire        | HP21 9XJ  |

    # Put DeliveryOrg data in the CRM Organisation table 
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10050000 | 150000 | 10050000 Co Ltd | In Administration     | AA017358      | 17358         | 71 Patrick Way         | ?                      | ?                      | ?                      | Aylesbury              | Buckinghamshire        | HP21 9XJ  |


    # Change the date
    Given the override date is '12/12/2015'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10050000 | 10050000 Co Ltd      | SFA-2015             | MAIN-3454      | 1                     | 01/08/2015        | 31/07/2016      | 24522.00      |                                    | Contract for Services | 1516   | New          | ORG0050000 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                     | CRMIntent    | DeliveryOrg |
    | 10050000 | MAIN-3454      | 16AP-1178     | MAIN              | AY1516                  | AY                      | 01/08/2015          | 31/07/2016        | 24522.00        |                                         |            |                                           | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription                     | CRMIntent    | DeliveryOrg |
    | 10050000 | MAIN-3454      | 16AP-1178     | 1               | 0                     | 24522.00  | 2918.00  | 2261.00  | 3249.00  | 284.00   | 2760.00  | 2735.00  | 1826.00  | 853.00   | 2790.00  | 680.00   | 1574.00  | 2592.00  | Apprenticeships Carry-In Total Funding     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-3454' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'SFA-2015' and actual ContractNumber 'MAIN-3454'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-3454' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10050000 | MAIN-3454          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2015        | 31/07/2016      | ?             |
    | 10050000 | SFA-2015           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2015        | 31/07/2016      | ?             |



    # Bulk import to test rules CBR004, CBR010, CABR004, CABR007, DBR001, DBR003, DBR008 and DBR009

    # Change the date
    Given the override date is '15/12/2015'

    And   there are no files prefixed 'MAIN AY 1516 14052015130000 BulkAmendmentValidation' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1516 14052015130000 BulkAmendmentValidation' in the Sharepoint 'Reports' folder
	
	And   The file 'MAIN AY 1516 14052015130000 BulkAmendmentValidation.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '10050000'
	
	When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

	And '[Contract] Contract Type is not a valid contract' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
	And '[Contract] Start and end date cannot be the same for the Contract' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
	And '[Contract] Start and end date cannot be the same for the Contract' is in Row '6' of the 'Results' Column on the 'Contract Allocation' tab of the result report

	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code' is displayed in field 'R6' on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be after the Contract end date' is in Row '2' of the 'Results' Column on the 'Contract Allocation' tab of the result report
	And '[Contract Allocation] Contract Allocation end date cannot be after the Contract end date' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
	
	And '[Deliverable] CRM intent is not a valid value' is displayed in field 'J5' on the 'Contract' tab of the result report
	And '[Deliverable] CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation' is displayed in field 'J5' on the 'Contract' tab of the result report
	And '[Deliverable] Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number' is displayed in field 'J5' on the 'Contract' tab of the result report


	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20221104
@RSR006
@BulkAmendDraftContractsValidation
Scenario: E059 Amend Contract Validation (RSR006) 
	Given an excel spreadsheet 'MAIN AY 1516 01062015120000 Amendment_RSR_006.xlsx' exist at 'DataFiles\Release2'
	And the override date is '12/12/2015'
	And field  'A2' contains '45181270' on the 'Contract' tab of the excel spreadsheet
	And field  'A3' contains '45181271' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'Amendment' on the 'Contract' tab of the excel spreadsheet
	And field  'F3' contains 'Amendment' on the 'Contract' tab of the excel spreadsheet
	And field  'F2' contains 'Delete Draft' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'F3' contains 'Delete Draft' on the 'Contract Allocation' tab of the excel spreadsheet
	And field  'I2' contains 'Delete Draft' on the 'Deliverable' tab of the excel spreadsheet
	And field  'I14' contains 'Amendment' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract Allocation] Cannot delete a Contract Allocation/ Deliverable if there is already an existing Approved Contract' is displayed in field 'J2' on the 'Contract' tab of the result report
	And '[Contract Allocation] Cannot delete a Contract Allocation/ Deliverable if there is already an existing Approved Contract' is displayed in field 'J3' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
Scenario: A065 Validate rules UDC013 and UDC014 against a 1920 AEBP contract
    Given there are no allocations marked as Under Termination for UKPRN '10017065' 
    And   there are no terminated or closed allocations for UKPRN '10017065' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017065' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017065' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-065      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-AS1920     |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017065' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017065 Co Ltd' with UKPRN '10017065' and OrgId 'ORG0017065' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017065' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017065 | 117065 | 10017065 Co Ltd | 0              | Deleted               | Yes           | AA017065      | ?             | 1 College Place        | Derby                  | ?                      | ?                      | ?                      | ?                      | DE1 3DY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017065 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017065 | 10017065 Co Ltd      | ESFA-065             | AEBP-065       | 1                     | 01/08/2019        | 31/07/2020      | 22630.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017065 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017065 | AEBP-065       | AEBA-065      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 22630.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017065 | AEBP-065       | AEBA-065      | 1               | 0                     | 22630.00  | 2452.00  | 1795.00  | 2783.00  | 3519.00  | 2294.00  | 2269.00  | 1360.00  | 387.00   | 2324.00  | 213.00   | 1108.00  | 2126.00  | Adult Skills Total Funding                                      | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '23/08/2019'

    # Bulk file Update Draft against a provider in CRM marked with a DELETED status
    And   there are no files prefixed '10017065' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 14102019132241 v3_E065' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 14102019132241 v3_E065' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 14102019132241 v3_E065' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 14102019132241 v3_E065.xlsx' exists in the Datafiles folder and UKPRN '10017065' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
#   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

   # UDC013
    And   '[Contract Allocation] UKPRN is not a active organisation therefore a new Contract Allocation cannot be created for the UKPRN' is displayed in field 'J2' on the 'Contract' tab of the result report

   # UDC014
    And   '[Deliverable] UKPRN is not a active organisation therefore a new Deliverable cannot be created for the UKPRN' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Tidy up
    And   the override date is reset

