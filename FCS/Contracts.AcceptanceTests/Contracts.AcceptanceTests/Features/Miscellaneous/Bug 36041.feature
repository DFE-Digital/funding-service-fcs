Feature: Bug 36041

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A654 Create and approve 1920 and 2021 EDSK contracts. Create a draft 21/22 EDSK contract. Import 21/22 FA and queue. Check CRM and PaaS (Live bug)
   
   # Part 1: Bulk create and approve a 1920 EDSK contract
   # Part 2: Bulk create and approve a 2021 EDSK contract
   # Part 3: Bulk create a draft 2122 EDSK contract at 'Internally Approved'
   # Part 4: Import and queue a 1416 Funding Allocation for 2122
    
    Given there are no allocations marked as Under Termination for UKPRN '10017654' 
    And   there are no terminated or closed allocations for UKPRN '10017654' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017654' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017654' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017654'
    And   there is no Funding Allocation data in CRM for UKPRN '10017654'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017654' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL1920     |

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
    
    
    
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017654' 
    And   there is no caseload advisor for UKPRN '10017654' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017654 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017654' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017654 Co Ltd' with UKPRN '10017654' and OrgId 'ORG0017654' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status     | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017654 | 117654 | 10017654 Co Ltd | 0              | Active     | Yes           | AA017654      | ?             | 1 Sycamore Road        | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5ED   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017654 |





    # Part 1: Bulk create and approve a 1920 EDSK contract
    
    # Change the date
    Given the override date is '01/07/2019'

    # Bulk 'New' file
    And   there are no files prefixed '10017654' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 13012022110432 v3_A654_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 13012022110432 v3_A654_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 13012022110432 v3_A654_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 13012022110432 v3_A654_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 13012022110432 v3_A654_1.xlsx' exists in the Datafiles folder and UKPRN '10017654' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '1920' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '1920'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017654 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017654 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AECA] | 2371175          | Jul-20 | Reconciliation |





    # Part 2: Bulk create and approve a 2021 EDSK contract
    
    # Change the date
    Given the override date is '01/07/2020'

    # Bulk 'New' file
    And   there are no files prefixed '10017654' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 13012022110433 v3_A654_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 13012022110433 v3_A654_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 13012022110433 v3_A654_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 13012022110433 v3_A654_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 13012022110433 v3_A654_2.xlsx' exists in the Datafiles folder and UKPRN '10017654' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017654 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017654 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AECA] | 2371175          | Jul-20 | Reconciliation |





    # Part 3: Bulk create a draft 2122 EDSK contract at 'Internally Approved'
    
    # Change the date
    Given the override date is '01/07/2021'

    # Bulk 'New' file
    And   there are no files prefixed '10017654' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 13012022110434 v3_A654_3' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 13012022110434 v3_A654_3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 13012022110434 v3_A654_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 13012022110434 v3_A654_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 13012022110434 v3_A654_3.xlsx' exists in the Datafiles folder and UKPRN '10017654' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2122'

    # Update the contract from 'Awaiting Documentation' to 'Internally Approved'
    Given the contract sub-status is updated to 'Internally Approved' on the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017654 | [ContractNo]       | 1                     | 0                        | Draft            | Internally Approved       | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017654 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |











    # Part 4: Import and queue a 1416 Funding Allocation for 2122

    # Populate the stub with 1416 (04AHC) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017654 | 1416-AY-2122-Contract-Provider-10017654-1_7           | 1_7            | 1416                        | AY-2122            | 25628.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017654-1_7  | 1_7                    | 1416-AY-2122-Contract-Provider-10017654-1_7           | 10017654      | Furth        | 04AHC           | 25628.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017654-1_7  | 1416-001        | 8366.00          | Payment         |
    | 1416-AY-2122-10017654-1_7  | 1416-002        | 7326.00          | Payment         |
    | 1416-AY-2122-10017654-1_7  | 1416-003        | 9936.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017654-1_7  | 1416-001        | FY-2122              | August                 | 2021              | 5000.00                   |
    | 1416-AY-2122-10017654-1_7  | 1416-001        | FY-2122              | May                    | 2022              | 3366.00                   |
    #
    | 1416-AY-2122-10017654-1_7  | 1416-002        | FY-2122              | August                 | 2021              | 2018.00                   |
    | 1416-AY-2122-10017654-1_7  | 1416-002        | FY-2122              | July                   | 2022              | 5308.00                   |
    #
    | 1416-AY-2122-10017654-1_7  | 1416-003        | FY-2122              | October                | 2021              | 2311.00                   |
    | 1416-AY-2122-10017654-1_7  | 1416-003        | FY-2122              | February               | 2022              | 4373.00                   |
    | 1416-AY-2122-10017654-1_7  | 1416-003        | FY-2122              | July                   | 2022              | 3252.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017654 | 10017654 Co Ltd  | 1416-AY-2122-Contract-Provider-10017654-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 25628.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 25628.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017654 | 1416-AY-2122-Contract-Provider-10017654-1_7             | 1_7            | AY-2122 | 1416                        | 25628.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 25628.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017654' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Write the following values to the output window
    And   message 'ContractNo = [ContractNo]' is written to the Output window
    
    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017654 | 10017654 Co Ltd  | 1416-AY-2122-Contract-Provider-10017654-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1416                        | 16-19ED2122     | In Release        | Queued                  | 25628.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | 05/08/2021 | [ContractNo]        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017654 | 1416-AY-2122-Contract-Provider-10017654-1_7             | 1_7            | AY-2122 | 1416                        | 25628.00    | [CofG_College]  | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-Provider-10017654-1_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'


    # Tidy Up
    Given the override date is reset

