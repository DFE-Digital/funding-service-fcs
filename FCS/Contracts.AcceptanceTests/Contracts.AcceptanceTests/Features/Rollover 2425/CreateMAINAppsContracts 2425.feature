Feature: CreateMAINAppsContracts 2425


@AcceptanceTest @InProgress
@Long2Run @Long2Run123
Scenario: S048 Bulk load and approve a new Mainstream APPS2425 contract. NFA. Check docs. Check financials, CDA and feed 
    Given there are no allocations marked as Under Termination for UKPRN '10018048' 
    And   there are no terminated or closed allocations for UKPRN '10018048' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018048' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018048' 
 

     # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018048' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-048      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-048      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2425          |



    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-048       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018048'





    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018048' 
    And   there is no caseload advisor for UKPRN '10018048' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018048 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018048' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018048 Co Ltd' with UKPRN '10018048' and OrgId 'ORG0018048' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018048 | 118048 | 10018048 Co Ltd | 0              | Active                | Yes           | AA018048      | ?             | 5 William Street       | ?                      | ?                      | Little Shame           | Windsor                | Berkshire              | SL4 1BB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018048 |



    
    # Change the date
    Given the override date is '01/07/2024'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'MAIN-048'
    And   there are no details in ContractManagement.CreatedContract for 'MAIN-048'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018048 | 10018048 Co Ltd      | ESFA-048             | MAIN-048       | 1                     | 01/08/2024        | 31/07/2025      | 26607.00      |                                       | Contract for Services                      | 2425   | New          | ORG0018048 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018048 | MAIN-048       | APPS-048      | APPS              | APPS2425                | AY                      | 01/08/2024          | 31/07/2025        | 26607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10018048 | MAIN-048       | APPS-048      | 1               | 0                     | 26607.00  | 17886.00  | 8721.00   | 610.00   | 3624.00  | 2967.00  | 254.00   | 991.00   | 3466.00  | 3442.00  | 2532.00  | 1559.00  | 3496.00  | 1386.00  | 2280.00  | Apprenticeships Carry-In Total Funding                                          | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | MAIN-048       | 1                     | 0                        | 2024-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-048'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber 'MAIN-048' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-048' and ContractNumber 'MAIN-048' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-048' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018048 | MAIN-048           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018048 | ESFA-048           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-048' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number 'MAIN-048'
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-048'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | APPS-048        | 2240100          | Jul-25 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10018048 | MAIN-048       | 1               | APPS-048      | 1               | 0                     | 26607.00     | 0             | 0        | Apprenticeships Carry-In Total Funding                          | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    #Then  the details in CRM for version '1' of contract 'MAIN-048' agree with the most recent entry for this contract in the ContractManagement feed
#
#



    # Bulk load a new APPS2425 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/07/2023'
    
    # Bulk file
    And   there are no files prefixed '10018048' in the Sharepoint 'MAIN-2324-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2324 04072023163722 v3_S022' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2324 04072023163722 v3_S022' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2324 04072023163722 v3_S022' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2324 04072023163722 v3_S022' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2324 04072023163722 v3_S022.xlsx' exists in the Datafiles folder and UKPRN '10018048' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018048' for FundingType 'MAIN' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018048' for FundingType 'MAIN' and period '2324'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10018022_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2324-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018048 Co Ltd UKPRN: 10018048
    Master Contract Number: ESFA-048
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999
    Funding Agreement Apprenticeships Carry-In
    Provider: 10018048 Co Ltd UKPRN: 10018048
    Master Contract Number: ESFA-048 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Page 1 of 1 of this Funding Agreement
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018022_[ContractNo]_v1.pdf' in 'MAIN-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S048.pdf'
 
 


    # Publish and approve the contract

    Given the override date is '25/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018048 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    #
    | 10018048 | MAIN-048           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018048 | ESFA-048           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | [AllocRef_APPS] | 2240100          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
#    | 10018048 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-048' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 
 


    # Part 5: Add 23/24 actuals and check financials in CRM and PaaS

    
    # Add actuals to the contract for APPS2425

    # Change the date
    Given the override date is '04/09/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018048'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber        | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 343.56      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 322.38      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 168.11      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 846.86      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 875.31      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 458.34      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 516.63      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 682.09      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 477.18      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 480.01      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 119.73      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 418.47      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 381.10      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 979.14      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1139.69     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 1356.61     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1322.71     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1236.33     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1272.19     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1396.93     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 238.20      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 730.41      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 418.21      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 224.05      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1311.28     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 997.86      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 705.86      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 641.13      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 769.94      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 842.12      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1262.28     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 454.26      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1433.43     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 293.02      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 335.48      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 106.84      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1009.04     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 716.13      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 566.30      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 863.95      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 339.06      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1072.13     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 610.19      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 546.70      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 797.59      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 126.17      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1109.12     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 816.66      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 637.45      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 407.33      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1213.47     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 810.21      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1487.05     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1317.87     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1053.89     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 922.87      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1197.25     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 992.68      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 363.19      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1343.76     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1038.26     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1308.67     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 248.18      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 939.89      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 646.48      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 644.08      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1111.61     |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 690.60      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 321.43      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 987.94      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 923.94      |
    | APPS           | APPS76               | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 471.91      |
    #
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202308 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202309 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202310 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202311 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202312 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202401 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202402 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202403 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202404 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202405 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202406 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2324        | R01                  | ORG0018048     | CM             | 202407 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |



    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

#    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2425' OrgId 'ORG0018048' and Collection 'R01' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2425' OrgId 'ORG0018048' and Collection 'APPS76' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#


    # Check Financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



     # Payment Batch for APPS2425(PoA)

    # Change the date
    Given the override date is '08/09/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2425' AccountingPaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_APPS]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2425                   | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2425                   | 202308               | Completed |


    # Tidy Up
   Given the override date is reset
