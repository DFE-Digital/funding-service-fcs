Feature: MainstreamAPPS2324

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run123
Scenario: Ak002 Bulk load and approve a new Mainstream APPS2324 contract. NFA. Check docs. Check financials, CDA and feed 
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
    | APPS2324          |

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





    # Bulk load a new APPS2324 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/07/2023'
    
    # Bulk file
    And   there are no files prefixed '10017131' in the Sharepoint 'MAIN-2324-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2324 19072022163722 v3_Ak002' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2324 19072022163722 v3_Ak002' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2324 19072022163722 v3_Ak002' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2324 19072022163722 v3_Ak002' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2324 19072022163722 v3_Ak002.xlsx' exists in the Datafiles folder and UKPRN '10017131' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2324'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10017131_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2324-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017131_[ContractNo]_v1.pdf' in 'MAIN-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'Ak002.pdf'
 
 



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
    | 10017131 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017131 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 
 




    # NFA amendment and check doc parts

    # Change the date
    Given the override date is '28/07/2023'

    # Initiate non-financial amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017131 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017131 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the deliverables have all been created in CRM
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Check doc parts
    
    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017131' for FundingType 'MAIN' and period '2324'

    # Check the contents of the Appendices (SoF and FA. Only different between this and v1 is the version number)
    Then  the file named '10017131_[ContractNo]_v2.pdf' in Sharepoint location 'MAIN-2324-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017131 Co Ltd UKPRN: 10017131
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    """





    # Publish and approve the contract

    Given the override date is '29/07/2023'

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
    | 10017131 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017131 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10017131 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017131 | [ContractNo]   | 2               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 





#    # CDA
#
#    # Change the date
#    Given the override date is '02/08/2023'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version Ak002.csv'
#
#    #And   the following contracts are in the replicated CRM database
#    #| ContractNumber | ContractVersionNumber |
#    #| [ContractNo]   | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version                | Suffix |
#    | APPS2324              | Latest Version         | Ak002   |
#
#    Then  a report named 'CDA Latest Version Ak002.csv' is created

    # Check the contents of the CDA report
   # And   the following rows are present in the report
   # | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                          | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 8                 | 2022            | 2022/23       |              | 4946         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 9                 | 2022            | 2022/23       |              | 7137         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 10                | 2022            | 2022/23       |              | 6612         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 11                | 2022            | 2022/23       |              | 5201         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 12                | 2022            | 2022/23       |              | 7324         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 1                 | 2023            | 2022/23       |              | 8954         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 2                 | 2023            | 2022/23       |              | 6273         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 3                 | 2023            | 2022/23       |              | 6270         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 4                 | 2023            | 2023/24       |              | 4266         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 5                 | 2023            | 2023/24       |              | 2875         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 6                 | 2023            | 2023/24       |              | 6337         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
   # | APPS2324                | 10017131 | 10017131 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 7                 | 2023            | 2023/24       |              | 3804         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
   #
    # Tidy Up
 #  Given the override date is reset


    