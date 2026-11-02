Feature: CreateMainstreamAPPS 36962 

@AcceptanceTest @Withdrawn25072024
@Long2Run @Long2Run123
Scenario: A131 Bulk load and approve a new Mainstream APPS2223 contract. NFA. Check docs. Check financials, CDA and feed 
    Given there are no allocations marked as Under Termination for UKPRN '10017131' 
    And   there are no terminated or closed allocations for UKPRN '10017131' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017131' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017131' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017131' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2223          |

    ## Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 2240100        |
    #| 2240150        |
    #| 2240160        |
    #| 2240170        |
    #| 2340100        |
    #| 2340150        |
    #| 2340160        |
    #| 2340170        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017131'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017131' 
    And   there is no caseload advisor for UKPRN '10017131' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017131 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017131' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017131 Co Ltd' with UKPRN '10017131' and OrgId 'ORG0017131' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017131 | 117131 | 10017131 Co Ltd | 0              | Active                | Yes           | AA017131      | ?             | 5 William Street       | ?                      | ?                      | Little Shame           | Windsor                | Berkshire              | SL4 1BB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017131 |





    # Bulk load a new APPS2223 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/07/2022'
    
    # Bulk file
    And   there are no files prefixed '10017131' in the Sharepoint 'MAIN-2223-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2223 04072022163722 v3_A131' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2223 04072022163722 v3_A131' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2223 04072022163722 v3_A131' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2223 04072022163722 v3_A131' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2223 04072022163722 v3_A131.xlsx' exists in the Datafiles folder and UKPRN '10017131' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2223'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10017131_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2223-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017131_[ContractNo]_v1.pdf' in 'MAIN-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A131.pdf'
 
 



    # Publish and approve the contract

    Given the override date is '25/07/2022'

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
    | 10017131 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017131 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 
 




    # NFA amendment and check doc parts

    # Change the date
    Given the override date is '28/07/2022'

    # Initiate non-financial amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017131 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017131 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the deliverables have all been created in CRM
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Check doc parts
    
    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2223'

    # Check the contents of the Appendices (SoF and FA. Only different between this and v1 is the version number)
    Then  the file named '10017131_[ContractNo]_v2.pdf' in Sharepoint location 'MAIN-2223-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    """





    # Publish and approve the contract

    Given the override date is '29/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017131 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017131 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017131 | [ContractNo]   | 2               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 





    # CDA

    # Change the date
    Given the override date is '02/08/2022'

    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version A131.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| [ContractNo]   | 2                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version                | Suffix |
    | APPS2223              | Latest Version         | A131   |

    Then  a report named 'CDA Latest Version A131.csv' is created

    # Check the contents of the CDA report
   # And   the following rows are present in the report
   # | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                          | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 8                 | 2022            | 2022/23       |              | 4946         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 9                 | 2022            | 2022/23       |              | 7137         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 10                | 2022            | 2022/23       |              | 6612         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 11                | 2022            | 2022/23       |              | 5201         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 12                | 2022            | 2022/23       |              | 7324         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 1                 | 2023            | 2022/23       |              | 8954         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 2                 | 2023            | 2022/23       |              | 6273         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 3                 | 2023            | 2022/23       |              | 6270         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 4                 | 2023            | 2023/24       |              | 4266         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 5                 | 2023            | 2023/24       |              | 2875         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 6                 | 2023            | 2023/24       |              | 6337         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
   # | APPS2223                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 7                 | 2023            | 2023/24       |              | 3804         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
   #
    # Tidy Up
 #  Given the override date is reset

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: A132 Create and approve a new Mainstream APPS2122 contract. Bulk load a new amendment APPS2223. Approve. Actuals. Payment Batch. Check CRM, financials, feed and Reports
    Given there are no allocations marked as Under Termination for UKPRN '10017132' 
    And   there are no terminated or closed allocations for UKPRN '10017132' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017132' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017132' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017132' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-132      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-132      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2122          |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 2240100        |
 #  | 2240150        |
 #  | 2240160        |
 #  | 2240170        |
 #  | 2340100        |
 #  | 2340150        |
 #  | 2340160        |
 #  | 2340170        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-132       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017132'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017132' 
    And   there is no caseload advisor for UKPRN '10017132' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017132 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017132' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017132 Co Ltd' with UKPRN '10017132' and OrgId 'ORG0017132' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017132 | 117132 | 10017132 Co Ltd | 0              | In Administration     | Yes           | AA017132      | ?             | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017132 |





    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'MAIN-132'
    And   there are no details in ContractManagement.CreatedContract for 'MAIN-132'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017132 | 10017132 Co Ltd      | ESFA-132             | MAIN-132       | 1                     | 01/08/2021        | 31/07/2022      | 26607.00      |                                       | Contract for Services                      | 2122   | New          | ORG0017132 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017132 | MAIN-132       | APPS-132      | APPS              | APPS2122                | AY                      | 01/08/2021          | 31/07/2022        | 26607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017132 | MAIN-132       | APPS-132      | 1               | 0                     | 26607.00  | 17886.00  | 8721.00   | 610.00   | 3624.00  | 2967.00  | 254.00   | 991.00   | 3466.00  | 3442.00  | 2532.00  | 1559.00  | 3496.00  | 1386.00  | 2280.00  | Apprenticeships Carry-In Total Funding                                          | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | MAIN-132       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-132'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-132' and ContractNumber 'MAIN-132' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-132' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017132 | MAIN-132           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017132 | ESFA-132           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MAIN-132' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-132'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-132        | 2240100          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017132 | MAIN-132       | 1               | APPS-132      | 1               | 0                     | 26607.00     | 0             | 0        | Apprenticeships Carry-In Total Funding                          | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MAIN-132' agree with the most recent entry for this contract in the ContractManagement feed





    # Bulk load a new amendment to add a Mainstream contract for APPS2223

    # Change the date
    Given the override date is '23/08/2022'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10017132' in the Sharepoint 'MAIN-2223-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2223 05072022132156 v3_A132' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2223 05072022132156 v3_A132' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2223 05072022132156 v3_A132' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2223 05072022132156 v3_A132' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2223 05072022132156 v3_A132.xlsx' exists in the Datafiles folder and UKPRN '10017132' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017132' for FundingType 'MAIN' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017132_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2223-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017132 Co Ltd UKPRN: 10017132
    Master Contract Number: ESFA-132
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Apprenticeships Carry-In [AllocRef_APPS] £42,930 £17,070 £60,000
    Total Funding for this contract: £60,000

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017132 Co Ltd UKPRN: 10017132
    Master Contract Number: ESFA-132 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Apprenticeships Carry-In £60,000 £5,685 £4,103 £6,014 £5,260 £5,377 £5,092 £5,886 £5,513 £2,521 £4,906 £2,313 £7,330
    Total Funding £60,000 £5,685 £4,103 £6,014 £5,260 £5,377 £5,092 £5,886 £5,513 £2,521 £4,906 £2,313 £7,330
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """


    # Change the date
    Given the override date is '26/08/2022'

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
    | 10017132 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    #
    | 10017132 | MAIN-132           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017132 | ESFA-132           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10017132 | [ContractNo]   | 1               | [AllocRef_APPS]  | 1               | 0                     | 60000.00     | 0             | 0        | Apprenticeships Carry-In Total Funding   | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Add actuals to the contract for APPS2223

    # Change the date
    Given the override date is '04/09/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017132'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 343.56      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 322.38      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 168.11      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 846.86      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 875.31      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 458.34      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 516.63      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 682.09      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 477.18      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 480.01      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 119.73      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 418.47      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 381.10      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 979.14      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 1139.69     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 1356.61     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 1322.71     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 1236.33     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1272.19     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 1396.93     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 238.20      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 730.41      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 418.21      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 224.05      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1311.28     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 997.86      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 705.86      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 641.13      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 769.94      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 842.12      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1262.28     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 454.26      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 1433.43     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 293.02      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 335.48      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 106.84      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1009.04     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 716.13      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 566.30      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 863.95      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 339.06      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 1072.13     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 610.19      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 546.70      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 797.59      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 126.17      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 1109.12     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 816.66      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 637.45      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 407.33      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 1213.47     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 810.21      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 1487.05     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 1317.87     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1053.89     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 922.87      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 1197.25     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 992.68      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 363.19      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 1343.76     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1038.26     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 1308.67     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 248.18      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 939.89      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 646.48      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 644.08      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 8               | 0            | 1111.61     |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 9               | 0            | 690.60      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 10              | 0            | 321.43      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 22              | 0            | 987.94      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 23              | 0            | 923.94      |
    | APPS           | APPS64               | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 24              | 0            | 471.91      |
    #
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 872.56      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 1399.35     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 845.33      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 390.89      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 1016.17     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 216.91      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1397.45     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 1070.04     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 722.26      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 418.13      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 385.36      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 1481.64     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 711.43      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 1328.71     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 969.41      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 1332.19     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202208 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 901.73      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 481.98      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 487.07      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 996.72      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 605.54      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 1428.29     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 624.87      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 403.19      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 476.49      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 894.32      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 1140.21     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 1066.90     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 606.24      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1492.51     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 933.27      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 1474.77     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 371.45      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202209 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 980.43      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 868.89      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 1219.81     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1430.61     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 1470.11     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 1348.43     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1285.47     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1270.89     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 787.48      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 231.61      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 479.97      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 1105.10     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 981.69      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 908.51      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 620.75      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 118.45      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 384.52      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202210 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 1121.26     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 868.77      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 1265.56     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1419.74     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 336.07      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 812.94      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 617.18      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 562.46      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 465.05      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 1104.46     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 857.21      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 1048.59     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 1338.07     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 241.23      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 1329.47     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 734.11      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 724.64      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202211 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 102.18      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 1034.63     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 1304.50     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 305.79      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 631.70      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 577.08      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1034.12     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 795.99      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 473.96      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 261.79      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 495.56      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 214.93      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 757.31      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1341.20     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 219.03      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 909.50      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 828.66      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202212 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 612.04      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 101.75      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 125.55      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1337.87     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 762.32      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 567.28      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 529.89      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 672.06      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 1468.09     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 1274.94     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 1482.08     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 140.07      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 640.36      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 179.15      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 456.30      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 1106.79     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 222.01      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202301 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 1338.85     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 413.31      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 1077.51     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1134.61     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 676.80      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 722.23      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1332.36     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1375.29     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 1489.08     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 1032.46     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 910.62      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 1463.69     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 904.29      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1295.54     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 745.15      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 438.75      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 493.10      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202302 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 737.05      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 1146.73     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 605.65      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 427.52      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 1378.48     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 1038.44     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1432.63     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 990.30      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 709.04      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 340.03      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 797.89      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 234.30      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 107.65      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1302.35     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 786.49      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 391.88      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 1014.73     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202303 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 391.62      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 1237.19     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 634.29      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1454.09     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 123.90      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 639.32      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1380.97     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1304.81     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 249.42      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 179.69      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 559.02      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 923.13      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 486.98      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1139.44     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 1412.54     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 114.32      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 808.28      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202304 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 1240.93     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 1061.94     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 254.54      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 672.34      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 1144.58     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 413.42      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1162.72     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1409.88     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 1495.81     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 418.30      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 1122.43     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 557.63      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 321.82      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 1482.39     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 1453.80     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 542.79      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 578.59      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202305 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 425.31      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 235.30      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 917.35      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1247.64     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 390.00      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 375.74      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 742.48      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 1382.95     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 101.99      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 1236.03     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 1322.90     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 307.85      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 278.78      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 401.11      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 891.26      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 961.90      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 589.26      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202306 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 1401.85     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 2               | 0            | 842.53      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 3               | 0            | 997.70      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 4               | 0            | 1163.07     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 5               | 0            | 786.85      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 6               | 0            | 1118.34     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 7               | 0            | 1027.84     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 11              | 0            | 249.92      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 12              | 0            | 744.39      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 13              | 0            | 141.37      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 14              | 0            | 621.75      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 15              | 0            | 629.08      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 16              | 0            | 1074.25     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 17              | 0            | 699.78      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 18              | 0            | 252.56      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 19              | 0            | 968.63      |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 20              | 0            | 1309.64     |
    | ILR2223        | R01                  | ORG0017132     | CM             | 202307 | APPS2223                | APPS-132                 | ?          | 21              | 0            | 781.46      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2223' OrgId 'ORG0017132' and Collection 'R01' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2223' OrgId 'ORG0017132' and Collection 'APPS64' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered



    # Check Financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
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

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2240100                  | 4524.30   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2240150                  | 665.94    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2240160                  | 168.11    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2240170                  | 216.91    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2340100                  | 8487.91   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2340150                  | 1722.17   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2340160                  | 458.34    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017132 | [ContractNo]   | [AllocRef_APPS]    | 2340170                  | 2230.44   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





    # Payment Batch for APPS2223(PoA)

    # Change the date
    Given the override date is '08/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2223' AccountingPaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_APPS]          | 202208 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2223                   | 202208               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2223                   | 202208               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2223' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A132.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2223' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 4524.30         | RECONCILIATION   | 16-18 Apps              | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2240100    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 665.94          | RECONCILIATION   | 16-18NonLevy Apps       | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2240150    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 168.11          | RECONCILIATION   | 16-18NonLevy AppsEmp    | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2240160    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 216.91          | RECONCILIATION   | 16-18 Apps Tblz Emp     | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2240170    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 8487.91         | RECONCILIATION   | 19+ Apps                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2340100    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 1722.17         | RECONCILIATION   | 19+NonLevy Apps         | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2340150    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 458.34          | RECONCILIATION   | 19+NonLevy AppsEmp      | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2340160    |
    | APPS                   | 2022          | 05             | 08          | ?       | [AllocRef_APPS]   | 2230.44         | RECONCILIATION   | 19+ Apps Tblz Emp       | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017132 | 2340170    |




    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/09/2022'
    # Check the above report manually


    # Tidy Up
 #  Given the override date is reset

