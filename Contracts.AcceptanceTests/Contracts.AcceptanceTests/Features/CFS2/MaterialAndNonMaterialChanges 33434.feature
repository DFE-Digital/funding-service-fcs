Feature: MaterialAndNonMaterialChanges 33434

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A562 Import and release an NMSS FA to create a 2122 EDSK contract. Publish and approve. Import non-material change FA then a material change FA. Check PaaS and CRM
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017562'
    And   there is no Funding Allocation data in CRM for UKPRN '10017562'
    And   there is no Contract, Task or Workflow data for UKPRN '10017562'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017562'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017562'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017562' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017562' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017562 Co Ltd' with UKPRN '10017562' and OrgId 'ORG0017562' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017562' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017562 | 117562 | 10017562 Co Ltd | 0              | Locked Restructure    | Yes           | AA017562      | ?             | 2 Jenner Road          | Guildford              | Surrey                 | ?                      | ?                      | ?                      | GU1 3PL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017562 |





    # Populate the stub with NMSS (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-4_4           | 4_4            | NMSS                        | AY-2122            | 72461.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017562-4_4  | 4_4                    | NMSS-AY-2122-Contract-Provider-10017562-4_4           | 10017562      | Furth        | 02IPP           | 72461.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | 24400.00         | Payment         |
    | NMSS-AY-2122-10017562-4_4  | NMSS-003        | 10807.00         | Payment         |
    | NMSS-AY-2122-10017562-4_4  | NMSS-004        | 11848.00         | Payment         |
    | NMSS-AY-2122-10017562-4_4  | NMSS-005        | 3409.00          | Payment         |
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | 21997.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | September              | 2021              | 5293.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | October                | 2021              | 2703.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | January                | 2022              | 2473.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | February               | 2022              | 4225.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | May                    | 2022              | 5908.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-002        | FY-2122              | June                   | 2022              | 3798.00                   |
    #
    | NMSS-AY-2122-10017562-4_4  | NMSS-003        | FY-2122              | October                | 2021              | 2625.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-003        | FY-2122              | February               | 2022              | 3693.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-003        | FY-2122              | June                   | 2022              | 4489.00                   |
    #
    | NMSS-AY-2122-10017562-4_4  | NMSS-004        | FY-2122              | September              | 2021              | 2043.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-004        | FY-2122              | January                | 2022              | 3010.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-004        | FY-2122              | April                  | 2022              | 4111.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-004        | FY-2122              | June                   | 2022              | 2684.00                   |
    #
    | NMSS-AY-2122-10017562-4_4  | NMSS-005        | FY-2122              | November               | 2021              | 3409.00                   |
    #
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | FY-2122              | August                 | 2021              | 2610.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | FY-2122              | December               | 2021              | 4159.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | FY-2122              | March                  | 2022              | 5638.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | FY-2122              | May                    | 2022              | 5201.00                   |
    | NMSS-AY-2122-10017562-4_4  | NMSS-006        | FY-2122              | June                   | 2022              | 4389.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup   |
    | 10017562 | 10017562 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 72461.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]      |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-Provider-10017562-4_4             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 72461.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status              | SubStatus            |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | AY-2122 | NMSS                        | 72461.00    | [CfS_ITP]      | ?                   | ?                    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease' 





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 72461.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017562' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017562' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017562 | 10017562 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Released          | Released          | 72461.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status      | SubStatus         |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | AY-2122 | NMSS                        | 72461.00    | [CfS_ITP]      | ?           | ?                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017562-4_4             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017562 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017562 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017562 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 72461.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017562 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017562 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017562 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017562 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 72461.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 24400.00  | 0.00     | 5293.00  | 2703.00  | 0.00     | 0.00     | 2473.00  | 4225.00  | 0.00     | 0.00     | 5908.00  | 3798.00  | 0.00     | SSF High Needs Element 2                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 10807.00  | 0.00     | 0.00     | 2625.00  | 0.00     | 0.00     | 0.00     | 3693.00  | 0.00     | 0.00     | 0.00     | 4489.00  | 0.00     | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 11848.00  | 0.00     | 2043.00  | 0.00     | 0.00     | 0.00     | 3010.00  | 0.00     | 0.00     | 4111.00  | 0.00     | 2684.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 3409.00   | 0.00     | 0.00     | 0.00     | 3409.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Primary PE and Sport Premium (1)                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 21997.00  | 2610.00  | 0.00     | 0.00     | 0.00     | 4159.00  | 0.00     | 0.00     | 5638.00  | 0.00     | 5201.00  | 4389.00  | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Remove all details from ContractManagement.CreatedContract for a contract
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
 #  And   there are no created contracts for this number '[ContractNo]'





    # Publish the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017562 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017562 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017562 | 10017562 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 72461.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017562 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 24400.00     | 0             | 0        | SSF High Needs Element 2                       | ?                           |
    | 10017562 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 10807.00     | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10017562 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 11848.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10017562 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 3409.00      | 0             | 0        | Primary PE and Sport Premium (1)                   | ?                           |
    | 10017562 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 21997.00     | 0             | 0        | Teachers Pay Grant (NMSS)                      | ?                           |




   
    # Populate the stub with NMSS (02IPP) data again  (Other than the version number, this FA is identical to v4_4 so is a NON-MATERIAL change)

    # Change the date 
    Given the override date is '13/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-5_2           | 5_2            | NMSS                        | AY-2122            | 72461.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017562-5_2  | 5_2                    | NMSS-AY-2122-Contract-Provider-10017562-5_2           | 10017562      | Furth        | 02IPP           | 72461.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | 24400.00         | Payment         |
    | NMSS-AY-2122-10017562-5_2  | NMSS-003        | 10807.00         | Payment         |
    | NMSS-AY-2122-10017562-5_2  | NMSS-004        | 11848.00         | Payment         |
    | NMSS-AY-2122-10017562-5_2  | NMSS-005        | 3409.00          | Payment         |
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | 21997.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | September              | 2021              | 5293.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | October                | 2021              | 2703.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | January                | 2022              | 2473.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | February               | 2022              | 4225.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | May                    | 2022              | 5908.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-002        | FY-2122              | June                   | 2022              | 3798.00                   |
    #
    | NMSS-AY-2122-10017562-5_2  | NMSS-003        | FY-2122              | October                | 2021              | 2625.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-003        | FY-2122              | February               | 2022              | 3693.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-003        | FY-2122              | June                   | 2022              | 4489.00                   |
    #
    | NMSS-AY-2122-10017562-5_2  | NMSS-004        | FY-2122              | September              | 2021              | 2043.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-004        | FY-2122              | January                | 2022              | 3010.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-004        | FY-2122              | April                  | 2022              | 4111.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-004        | FY-2122              | June                   | 2022              | 2684.00                   |
    #
    | NMSS-AY-2122-10017562-5_2  | NMSS-005        | FY-2122              | November               | 2021              | 3409.00                   |
    #
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | FY-2122              | August                 | 2021              | 2610.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | FY-2122              | December               | 2021              | 4159.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | FY-2122              | March                  | 2022              | 5638.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | FY-2122              | May                    | 2022              | 5201.00                   |
    | NMSS-AY-2122-10017562-5_2  | NMSS-006        | FY-2122              | June                   | 2022              | 4389.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '15/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status              | SubStatus            |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-5_2             | 5_2            | AY-2122 | NMSS                        | 72461.00    | ?              | Discarded           | NonMaterialUpdate    |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | AY-2122 | NMSS                        | 72461.00    | [CfS_ITP]      | ContractApproved    | ContractApproved     |





    # Populate the stub with NMSS (02IPP) data again  (The value of this FA is £1 less than v4_4 (and v5_2) so is a MATERIAL change)

    # Change the date 
    Given the override date is '17/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-6_1           | 6_1            | NMSS                        | AY-2122            | 72460.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017562-6_1  | 6_1                    | NMSS-AY-2122-Contract-Provider-10017562-6_1           | 10017562      | Furth        | 02IPP           | 72460.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | 24400.00         | Payment         |
    | NMSS-AY-2122-10017562-6_1  | NMSS-003        | 10807.00         | Payment         |
    | NMSS-AY-2122-10017562-6_1  | NMSS-004        | 11848.00         | Payment         |
    | NMSS-AY-2122-10017562-6_1  | NMSS-005        | 3408.00          | Payment         |
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | 21997.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | September              | 2021              | 5293.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | October                | 2021              | 2703.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | January                | 2022              | 2473.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | February               | 2022              | 4225.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | May                    | 2022              | 5908.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-002        | FY-2122              | June                   | 2022              | 3798.00                   |
    #
    | NMSS-AY-2122-10017562-6_1  | NMSS-003        | FY-2122              | October                | 2021              | 2625.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-003        | FY-2122              | February               | 2022              | 3693.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-003        | FY-2122              | June                   | 2022              | 4489.00                   |
    #
    | NMSS-AY-2122-10017562-6_1  | NMSS-004        | FY-2122              | September              | 2021              | 2043.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-004        | FY-2122              | January                | 2022              | 3010.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-004        | FY-2122              | April                  | 2022              | 4111.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-004        | FY-2122              | June                   | 2022              | 2684.00                   |
    #
    | NMSS-AY-2122-10017562-6_1  | NMSS-005        | FY-2122              | November               | 2021              | 3408.00                   |
    #
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | FY-2122              | August                 | 2021              | 2610.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | FY-2122              | December               | 2021              | 4159.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | FY-2122              | March                  | 2022              | 5638.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | FY-2122              | May                    | 2022              | 5201.00                   |
    | NMSS-AY-2122-10017562-6_1  | NMSS-006        | FY-2122              | June                   | 2022              | 4389.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '19/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status              | SubStatus            |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-6_1             | 6_1            | AY-2122 | NMSS                        | 72460.00    | [CfS_ITP2]     | ?                   | ?                    |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-5_2             | 5_2            | AY-2122 | NMSS                        | 72461.00    | ?              | Discarded           | NonMaterialUpdate    |
    | 10017562 | NMSS-AY-2122-Contract-Provider-10017562-4_4             | 4_4            | AY-2122 | NMSS                        | 72461.00    | [CfS_ITP]      | ContractApproved    | ContractApproved     |

    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                     | FundingVersion | FundingType                | Period  | ContractType                 | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup       |
    | 10017562 | 10017562 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017562-6_1   | 6_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 72460.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP2]         |
  
    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 72460.00        |

     # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease' 


    # Tidy Up
    And   the override date is reset


