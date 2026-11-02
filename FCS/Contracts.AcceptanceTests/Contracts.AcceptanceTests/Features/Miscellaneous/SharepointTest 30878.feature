Feature: SharepointTest 30878

@AcceptanceTest @Manual
Scenario: A081 Bulk load an NCS-2021 contract (to help with manual testing in Sharepoint)
    Given there are no allocations marked as Under Termination for UKPRN '10017081' 
    And   there are no terminated or closed allocations for UKPRN '10017081' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017081' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017081' 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2021         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017081'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017081' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017081 Co Ltd' with UKPRN '10017081' and OrgId 'ORG0017081' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017081' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017081 | 117081 | 10017081 Co Ltd | 0              | Active                | Yes           | AA017081      | ?             | 4 Buckingham Court     | Beaufort Park          | Woodlands              | Bristol                | ?                      | ?                      | BS32 4NF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017081 |




    # Bulk file
    And   there are no files prefixed '10017081' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 2021 19102020135317 v3_A081' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS FY 2021 19102020135317 v3_A081' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 2021 19102020135317 v3_A081' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 2021 19102020135317 v3_A081' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 2021 19102020135317 v3_A081.xlsx' exists in the Datafiles folder and UKPRN '10017081' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017081' for FundingType 'NCS' and period '2021'


    # Clear down Sharepoint for this provider
    Given there are no files prefixed '10017081' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed '10017081' in the Sharepoint 'NCS-2021-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017081' in the Sharepoint 'NCS-2021-Output-Merged Document' folder
    And   there are no files prefixed '10017081' in the Sharepoint 'NCS-2021-Output-Documents for Publication' folder

    # Set the sub-status to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Populate Sharepoint appropriately
    And   a file with filename '10017081_[ContractNo]_v1.pdf' is created in 'NCS-2021-Input-Appendices'
    And   a file with filename '10017081_[ContractNo]_v1.pdf' is created in 'NCS-2021-Output-Documents for Publication'


    # Tidy Up
    And   the override date is reset  
  
@AcceptanceTest @Manual
Scenario: A082 Create and approve an NCS-2021 contract then NFA (to help with manual testing in Sharepoint)
    Given there are no allocations marked as Under Termination for UKPRN '10017082' 
    And   there are no terminated or closed allocations for UKPRN '10017082' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017082' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017082' 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2021         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017082'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017082' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017082 Co Ltd' with UKPRN '10017082' and OrgId 'ORG0017082' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017082' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017082 | 117082 | 10017082 Co Ltd | 0              | Active                | Yes           | AA017082      | ?             | 29 Buckingham Lane     | Beaufort Park          | Woodlands              | Bristol                | ?                      | ?                      | BS32 4NF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017082 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017082 | 10017082 Co Ltd      | ESFA-082             | NCS-082        | 1                     | 01/04/2020        | 30/03/2021      | 72085.00      | West Midlands and Staffordshire       | Contract for Services                      | 2021   | New          | ORG0017082 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017082 | NCS-082        | NCSC-082      | NCS-C             | NCS-C2021               | FY                      | 01/04/2020          | 30/03/2021        | 72085.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017082 | NCS-082        | NCSC-082      | 1               | 0                     | 72085.00  | 4699.00  | 3994.00  | 7847.00  | 2935.00  | 4601.00  | 7758.00  | 7655.00  | 7966.00  | 6281.00  | 6652.00  | 4556.00  | 7141.00  | Total In The Community Funding                                  | New          |             | 
    | 10017082 | NCS-082        | NCSC-082      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017082 | NCS-082        | NCSC-082      | 2               | 1                     | 20533.00  | 563.00   | 1804.00  | 801.00   | 1092.00  | 2935.00  | 2090.00  | 1908.00  | 1473.00  | 2777.00  | 2565.00  | 484.00   | 2041.00  | Customer Satisfaction                                           | New          |             | 
    | 10017082 | NCS-082        | NCSC-082      | 3               | 1                     | 51552.00  | 4136.00  | 2190.00  | 7046.00  | 1843.00  | 1666.00  | 5668.00  | 5747.00  | 6493.00  | 3504.00  | 4087.00  | 4072.00  | 5100.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017082 | NCS-082        | NCSC-082      | 4               | 3                     | 23323.00  | 3400.00  | 119.00   | 3543.00  | 672.00   | 900.00   | 1952.00  | 3479.00  | 3583.00  | 554.00   | 1256.00  | 885.00   | 2980.00  | Career Management                                               | New          |             | 
    | 10017082 | NCS-082        | NCSC-082      | 5               | 3                     | 28229.00  | 736.00   | 2071.00  | 3503.00  | 1171.00  | 766.00   | 3716.00  | 2268.00  | 2910.00  | 2950.00  | 2831.00  | 3187.00  | 2120.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017082 | NCS-082        | NCSC-082      | 6               | 0        | 712     | 20       | 94       | 78       | 11       | 29       | 90       | 89       | 67       | 43       | 91       | 39       | 61       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NCS-082        | 1                     | 0                        | 2020-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-082' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-082'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-082' and actual ContractNumber 'NCS-082'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-082' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017082 | NCS-082            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 30/03/2021      | ?             |
    | 10017082 | ESFA-082           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 30/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-082'
    
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NCSC-082        | 2305310          | Mar-21 | Reconciliation |




    # Non-Financial Amendment
    
    # Change the date
    Given the override date is '01/08/2020'

    # Issue a non-financial amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NCS-082' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NCS-082' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM. (This is just a wait to give the NFA time to complete)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017082 | NCS-082            | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2020        | 30/03/2021      | Notification  |
 #  | 10017082 | NCS-082            | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2020        | 30/03/2021      | Variation     |
    | 10017082 | NCS-082            | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2020        | 30/03/2021      | ?             |
    | 10017082 | ESFA-082           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 30/03/2021      | ?             |




    # Clear down Sharepoint for this provider
    Given there are no files prefixed '10017082' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed '10017082' in the Sharepoint 'NCS-2021-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017082' in the Sharepoint 'NCS-2021-Output-Merged Document' folder
    And   there are no files prefixed '10017082' in the Sharepoint 'NCS-2021-Output-Documents for Publication' folder




#    # 1. Draft\Awaiting Documentation
#
#    Given the contract sub-status is updated to 'Awaiting Documentation' on the latest version of contract 'NCS-082'
#
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Input-Appendices'
#    And   a file with filename '10017082_NCS-082_77.pdf' is created in 'NCS-2021-Input-Terms And Conditions'
#   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Merged Document'
#   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Documents for Publication'
#
#    # Manually execute Document Merge then check Sharepoint




#    # 2. Draft\In Review
#
#    Given the contract sub-status is updated to 'In Review' on the latest version of contract 'NCS-082'
#
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Input-Appendices'
#   #And   a file with filename '10017082_NCS-082_77.pdf' is created in 'NCS-2021-Input-Terms And Conditions'
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Merged Document'
#   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Documents for Publication'
#
#    # Manually Release for Internal Approval then check Sharepoint




#    # 3. Draft\Awaiting Internal Approval
#
#    Given the contract sub-status is updated to 'Awaiting Internal Approval' on the latest version of contract 'NCS-082'
#
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Input-Appendices'
#   #And   a file with filename '10017082_NCS-082_77.pdf' is created in 'NCS-2021-Input-Terms And Conditions'
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Merged Document'
#   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Documents for Publication'
#
#    # Manually Confirm Internal Approval then check Sharepoint




    # 4. Draft\Internally Approved

    Given the contract sub-status is updated to 'Internally Approved' on the latest version of contract 'NCS-082'

    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Input-Appendices'
   #And   a file with filename '10017082_NCS-082_77.pdf' is created in 'NCS-2021-Input-Terms And Conditions'
    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Merged Document'
   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Documents for Publication'

    # Manually Publish to Provider then check Sharepoint




#    # 5. Draft\Published to Provider
#
#    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-082'
#
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Input-Appendices'
#   #And   a file with filename '10017082_NCS-082_77.pdf' is created in 'NCS-2021-Input-Terms And Conditions'
#   #And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Merged Document'
#    And   a file with filename '10017082_NCS-082_v2.pdf' is created in 'NCS-2021-Output-Documents for Publication'
#
#    # Approve then check Sharepoint


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Manual
Scenario: A082 Approval
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-082' and actual ContractNumber 'NCS-082'

