Feature: MultiplyAgreements 36767

@AcceptanceTest @Withdrawn25072024
Scenario: A217 Bulk load a new MULT2223 contract. Publish and approve. NFA. Check docs, financials feed and CDA
    Given there are no allocations marked as Under Termination for UKPRN '10017217' 
    And   there are no terminated or closed allocations for UKPRN '10017217' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017217' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017217' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017217' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | MULT2223          |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 101085         |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017217' 
    And   there is no caseload advisor for UKPRN '10017217' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017217 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017217' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017217 Co Ltd' with UKPRN '10017217' and OrgId 'ORG0017217' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017217 | 117217 | 10017217 Co Ltd | 0              | Active                | Yes           | AA017217      | ?             | 10 Manor Walk          | Market Harborough      | Leicestershire         | ?                      | ?                      | ?                      | LE16 9PB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017217 |





    # Change the date
    Given the override date is '22/07/2022'

   # Bulk file
    And   there are no files prefixed '10017217' in the Sharepoint 'MULT-2223-Input-Appendices' folder
    And   there are no files prefixed 'MULT FY 2223 22072022151752 v3_A217' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MULT FY 2223 22072022151752 v3_A217' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MULT FY 2223 22072022151752 v3_A217' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MULT FY 2223 22072022151752 v3_A217' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MULT FY 2223 22072022151752 v3_A217.xlsx' exists in the Datafiles folder and UKPRN '10017217' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017217' for FundingType 'MULT' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017217_[ContractNo]_v1.pdf' in Sharepoint location 'MULT-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017217 Co Ltd UKPRN: 10017217
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_MULT]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Multiply £50,000 £0 £0 £0 £0 £0 £8,851 £7,333 £4,720 £6,484 £7,196 £6,792 £8,624
    Total Funding £50,000 £0 £0 £0 £0 £0 £8,851 £7,333 £4,720 £6,484 £7,196 £6,792 £8,624
    Multiply – [AllocRef_MULT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah Blah 
 #  """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017217_[ContractNo]_v1.pdf' in 'MULT-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A217v1.pdf'





    # Change the date
    Given the override date is '23/07/2022'

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
    | 10017217 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017217 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_MULT] | 101085           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName     | DeliverableDescription  | 
    | 10017217 | [ContractNo]   | 1               | [AllocRef_MULT] | 1               | 0                     | 50000.00     | 0             | 0        | Multiply            | ?                       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202209 | 8851.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202210 | 7333.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202211 | 4720.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202212 | 6484.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202301 | 7196.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202302 | 6792.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_MULT]  | 1               | 202303 | 8624.00      | 0             |





    # CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_MULT]    | 1               | 50000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8851.00  | 7333.00  | 4720.00  | 6484.00  | 7196.00  | 6792.00  | 8624.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017217 | [ContractNo]   | [AllocRef_MULT]    | 101085                   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 8851.00   | 7333.00   | 4720.00   | 6484.00   | 7196.00   | 6792.00   | 8624.00   | 
    
   
   


    # NFA

    # Execute a NON-FINANCIAL amendment on 22/23 Multiply contract and check docs

    # Change the date
    Given the override date is '21/08/2022'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced. No Funding Agreements.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017217 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017217 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017217 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017217' for FundingType 'MULT' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017217_[ContractNo]_v2.pdf' in Sharepoint location 'MULT-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017217 Co Ltd UKPRN: 10017217
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_MULT]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Multiply £50,000 £0 £0 £0 £0 £0 £8,851 £7,333 £4,720 £6,484 £7,196 £6,792 £8,624
    Total Funding £50,000 £0 £0 £0 £0 £0 £8,851 £7,333 £4,720 £6,484 £7,196 £6,792 £8,624
    Multiply – [AllocRef_MULT] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah Blah 
 #  """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017217_[ContractNo]_v2.pdf' in 'MULT-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A217v2.pdf'





    # Create and check the contents of the CDA report

    # Change the date
    Given the override date is '25/08/2022'

    # Delete old CDA report
    And   there is no CDA report named 'CDA Last Approved Version A217.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| [ContractNo]   | 1                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod  | Version               | Suffix |
    | MULT2223             | Last Approved Version | A217   |

    Then  a report named 'CDA Last Approved Version A217.csv' is created

    # Check the contents of the CDA report
    #And   the following rows are present in the report
    #| FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription   | Deliverable    | DeliverableParent   | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 4                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 101085            |                          |                   | Apr              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 5                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 101085            |                          |                   | May              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 6                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 101085            |                          |                   | Jun              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 7                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 101085            |                          |                   | Jul              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 8                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 101085            |                          |                   | Aug              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 9                 | 2022            | 2022/23       |              | 8851         |              | 0             |              | Yes                | 8851.00        |                  | 0.00                  | 0.00           | 8851.00         |             | No            |                   |        | 101085            |                          |                   | Sep              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 10                | 2022            | 2022/23       |              | 7333         |              | 0             |              | Yes                | 7333.00        |                  | 0.00                  | 0.00           | 7333.00         |             | No            |                   |        | 101085            |                          |                   | Oct              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 11                | 2022            | 2022/23       |              | 4720         |              | 0             |              | Yes                | 4720.00        |                  | 0.00                  | 0.00           | 4720.00         |             | No            |                   |        | 101085            |                          |                   | Nov              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 12                | 2022            | 2022/23       |              | 6484         |              | 0             |              | Yes                | 6484.00        |                  | 0.00                  | 0.00           | 6484.00         |             | No            |                   |        | 101085            |                          |                   | Dec              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 1                 | 2023            | 2022/23       |              | 7196         |              | 0             |              | Yes                | 7196.00        |                  | 0.00                  | 0.00           | 7196.00         |             | No            |                   |        | 101085            |                          |                   | Jan              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 2                 | 2023            | 2022/23       |              | 6792         |              | 0             |              | Yes                | 6792.00        |                  | 0.00                  | 0.00           | 6792.00         |             | No            |                   |        | 101085            |                          |                   | Feb              |
    #| MULT2223                | 10017217 | 10017217 Co Ltd             |               |                             | [AllocRef_MULT]          | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 1                     | Approved       | Approved                |                          | Multiply       |                     | 3                 | 2023            | 2022/23       |              | 8624         |              | 0             |              | Yes                | 8624.00        |                  | 0.00                  | 0.00           | 8624.00         |             | No            |                   |        | 101085            |                          |                   | Mar              |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Complete
Scenario: A218 Create and approve a new MULT2223 contract. Bulk amend and approve. PoP payment batch. CPSR. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017218' 
    And   there are no terminated or closed allocations for UKPRN '10017218' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017218' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017218' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017218' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | MULT-218      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | MULT-218      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | MULT2223          |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101085         |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MLT-218        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017218'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017218' 
    And   there is no caseload advisor for UKPRN '10017218' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017218 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017218' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017218 Co Ltd' with UKPRN '10017218' and OrgId 'ORG0017218' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017218 | 117218 | 10017218 Co Ltd | 0              | Active                | Yes           | AA017218      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017218 |





    # Change the date
    Given the override date is '01/03/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'MLT-218'
    And   there are no details in ContractManagement.CreatedContract for 'MLT-218'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017218 | 10017218 Co Ltd      | ESFA-218             | MLT-218        | 1                     | 01/04/2022        | 31/03/2023      | 18300.00      |                                       | Contract for Services                      | 2223   | New          | ORG0017218 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017218 | MLT-218        | MULT-218      | MULT              | MULT2223                | FY                      | 01/04/2022          | 31/03/2023        | 18300.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017218 | MLT-218        | MULT-218      | 1               | 0                     | 18300.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 615.00   | 590.00   | 3382.00  | 2409.00  | 645.00   | 2236.00  | 3130.00  | Multiply                                                                        | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MLT-218'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-218' and ContractNumber 'MLT-218' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'MLT-218' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017218 | MLT-218            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017218 | ESFA-218           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MLT-218' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MLT-218'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | MULT-218        | 101085           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                     | DeliverableDescription                                      | 
    | 10017218 | MLT-218        | 1               | MULT-218      | 1               | 0                     | 18300.00     | 0             | 0        | Multiply                                                                            | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MLT-218' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202204 | 1460.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202205 | 773.00       | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202206 | 116.00       | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202207 | 1104.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202208 | 1840.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202209 | 615.00       | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202210 | 590.00       | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202211 | 3382.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202212 | 2409.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202301 | 645.00       | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202302 | 2236.00      | 0             |
    | NewContractAllocationApproved     | MLT-218            | 1             | MULT-218         | 1               | 202303 | 3130.00      | 0             |





    # Bulk variation amendment
    
    # Change the date
    Given the override date is '23/08/2022'

    # Bulk file to amend contract and reduce funding to £0 during Apr-Aug
    And   there are no files prefixed '10017218' in the Sharepoint 'MULT-2223-Input-Appendices' folder
    And   there are no files prefixed 'MULT FY 2223 27072022133147 v3_A218' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MULT FY 2223 27072022133147 v3_A218' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MULT FY 2223 27072022133147 v3_A218' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MULT FY 2223 27072022133147 v3_A218' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MULT FY 2223 27072022133147 v3_A218.xlsx' exists in the Datafiles folder and UKPRN '10017218' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017218' for FundingType 'MULT' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017218' for FundingType 'MULT' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017218_MLT-218_v2.pdf' in Sharepoint location 'MULT-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017218 Co Ltd UKPRN: 10017218
    Master Contract Number: ESFA-218 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: MULT-218
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Multiply £36,000 £0 £0 £0 £0 £0 £8,462 £3,585 £5,122 £2,534 £2,481 £7,428 £6,388
    Total Funding £36,000 £0 £0 £0 £0 £0 £8,462 £3,585 £5,122 £2,534 £2,481 £7,428 £6,388
    Multiply – MULT-218 – Page 1 Ref (for internal use only):  MLT-218 v2
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah Blah 
 #  """


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MLT-218'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-218' and ContractNumber 'MLT-218' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'MLT-218' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017218 | MLT-218            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017218 | MLT-218            | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017218 | ESFA-218           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'MLT-218' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MLT-218'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | MULT-218        | 101085           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                     | DeliverableDescription                                      | 
    | 10017218 | MLT-218        | 2               | MULT-218      | 1               | 0                     | 36000.00     | 0             | 0        | Multiply                                                                            | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'MLT-218' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202204 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202205 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202206 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202207 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202208 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202209 | 8462.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202210 | 3585.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202211 | 5122.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202212 | 2534.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202301 | 2481.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202302 | 7428.00      | 0             |
    | AmendedContractAllocationApproved | MLT-218            | 2             | MULT-218         | 1               | 202303 | 6388.00      | 0             |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | MLT-218        | MULT-218           | 1               | 36000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8462.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | MLT-218        | MULT-218           | 1               | 41293.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 8462.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 

   # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | MLT-218        | MULT-218           | 1               | -5293.00  | 0.00     | ?        | ?        | ?        | ?        | -5293.00 | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | MLT-218        | MULT-218           | 1               | 36000.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 3169.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal    | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017218 | MLT-218        | MULT-218       | 101085               | 1460.00   | 773.00    | 116.00    | 1104.00   | 1840.00   | 3169.00   | 3585.00   | 5122.00   | 2534.00   | 2481.00   | 7428.00   | 6388.00   | 




#
#    # Payment Batch for MULT2223(PoP)
#
#    # Change the date
#    Given the override date is '02/09/2022 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'MULT2223' AccountingPaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | MULT-218                 | 202209 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | MULT2223                   | 202209               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | MULT2223                   | 202209               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'MULT2223' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A218.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'MULT2223' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | MULT                   | 2022          | 06             | 02          | ?       | MULT-218          | 3169.00         | PROFILE          | Multiply                           | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017218 | 101085     |
#
#
#
#
#
#    # Create Consolidated Payment Summary rpt
#   
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    When a Consolidated Payment Summary Report is created in Sharepoint for '12/09/2022'
#    
#    # Copy\Save a named Sharepoint file to a named folder\filename
# #  And  Sharepoint file '2022-09 Payments.xlsx' in 'Consolidated Payment Summary' is copied to 'Datafiles/Downloads' as 'A218_CPSR.xlsx'
#    
#    # Check the above report manually
#
#
#    # Tidy Up
#    Given the override date is reset
   
