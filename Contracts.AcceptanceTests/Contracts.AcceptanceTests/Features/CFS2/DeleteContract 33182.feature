Feature: DeleteContract 33182

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
@CFS
Scenario: A709 Create and approve an EDSK2021 contract with 1619 FA alloc. NFA then Update Draft Amendment to add NMSS FA. Delete v2. Reinstate NMSS FA. Check CRM, PaaS and WF History
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017709'
    And   there is no Funding Allocation data in CRM for UKPRN '10017709'
    And   there is no Contract, Task or Workflow data for UKPRN '10017709'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017709'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017709'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017709' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017709' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017709 Co Ltd' with UKPRN '10017709' and OrgId 'ORG0017709' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017709' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017709 | 117709 | 10017709 Co Ltd | 0              | In Administration     | Yes           | AA017709      | ?             | 30 Silverdale Avenue   | Shadwell               | Leeds                  | ?                      | ?                      | ?                      | LS17 S52  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017709 |





    # Populate the stub with 1619 (06SDC) data

    # Change the date 
    Given the override date is '17/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017709 | 1619-AS-2122-Contract-Provider-10017709-2_0           | 2_0            | 1619                        | AS-2122            | 77604.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017709-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10017709-2_0           | 10017709      | Furth        | 06SDC           | 77604.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | 19114.00         | Payment         |
    | 1619-AS-2122-10017709-2_0  | 1619-003        | 10669.00         | Payment         |
    | 1619-AS-2122-10017709-2_0  | 1619-007        | 3544.00          | Payment         |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | 20164.00         | Payment         |
    | 1619-AS-2122-10017709-2_0  | 1619-024        | 24113.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | FY-2122              | August                 | 2021              | 4325.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | FY-2122              | November               | 2021              | 3513.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | FY-2122              | March                  | 2022              | 5949.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | FY-2122              | May                    | 2022              | 2642.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-002        | FY-2122              | July                   | 2022              | 2685.00                   |
    #
    | 1619-AS-2122-10017709-2_0  | 1619-003        | FY-2122              | October                | 2021              | 2682.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-003        | FY-2122              | January                | 2022              | 2997.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-003        | FY-2122              | May                    | 2022              | 4990.00                   |
    #
    | 1619-AS-2122-10017709-2_0  | 1619-007        | FY-2122              | April                  | 2022              | 3544.00                   |
    #
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | August                 | 2021              | 3088.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | November               | 2021              | 4771.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | December               | 2021              | 2661.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | February               | 2022              | 3115.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | April                  | 2022              | 2816.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-011        | FY-2122              | July                   | 2022              | 3713.00                   |
    #
    | 1619-AS-2122-10017709-2_0  | 1619-024        | FY-2122              | September              | 2021              | 5988.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-024        | FY-2122              | January                | 2022              | 2783.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-024        | FY-2122              | February               | 2022              | 5459.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-024        | FY-2122              | April                  | 2022              | 5433.00                   |
    | 1619-AS-2122-10017709-2_0  | 1619-024        | FY-2122              | July                   | 2022              | 4450.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '20/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 77604.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017709-2_0             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College1             |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College1]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 77604.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup     |
    | 10017709 | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | AS-2122 | 1619                        | 77604.00    | [CofG_College1]  |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College1]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '23/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College1]   |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College1]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 77604.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 77604.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    |
    | 10017709 | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | AS-2122 | 1619                        | 77604.00    | [CofG_College1] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017709-2_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College1]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017709 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 77604.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017709 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017709 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017709 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017709 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 77604.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 19114.00  | 4325.00  | 0.00     | 0.00     | 3513.00  | 0.00     | 0.00     | 0.00     | 5949.00  | 0.00     | 2642.00  | 0.00     | 2685.00  | 16-19 Bursary Funds                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 10669.00  | 0.00     | 0.00     | 2682.00  | 0.00     | 0.00     | 2997.00  | 0.00     | 0.00     | 0.00     | 4990.00  | 0.00     | 0.00     | Residential Bursary Fund                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 3544.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3544.00  | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 20164.00  | 3088.00  | 0.00     | 0.00     | 4771.00  | 2661.00  | 0.00     | 3115.00  | 0.00     | 2816.00  | 0.00     | 0.00     | 3713.00  | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 149             | 24113.00  | 0.00     | 5988.00  | 0.00     | 0.00     | 0.00     | 2783.00  | 5459.00  | 0.00     | 5433.00  | 0.00     | 0.00     | 4450.00  | 16-19 High Value Courses School and College Leavers Uplift|                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '26/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 77604.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy       | ?                         |





    # Execute a NON-FINANCIAL amendment to create a draft v2

    # Change the date
    Given the override date is '29/06/2021'

    # Issue a non-financial VARIATION amendment on v3 to create v4
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Populate the stub with NMSS (06SDC) data

    # Change the date
    Given the override date is '02/07/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4           | 1_4            | NMSS                        | AY-2122            | 61953.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017709-1_4  | 1_4                    | NMSS-AY-2122-Contract-Provider-10017709-1_4           | 10017709      | Furth        | 06SDC           | 61953.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017709-1_4  | NMSS-001        | 9849.00          | Payment         |
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | 20089.00         | Payment         |
    | NMSS-AY-2122-10017709-1_4  | NMSS-004        | 5804.00          | Payment         |
    | NMSS-AY-2122-10017709-1_4  | NMSS-007        | 17123.00         | Payment         |
    | NMSS-AY-2122-10017709-1_4  | NMSS-008        | 9088.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017709-1_4  | NMSS-001        | FY-2122              | December               | 2021              | 4099.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-001        | FY-2122              | July                   | 2022              | 5750.00                   |
    #
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | FY-2122              | October                | 2021              | 3576.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | FY-2122              | January                | 2022              | 3757.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | FY-2122              | February               | 2022              | 5338.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | FY-2122              | April                  | 2022              | 3533.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-003        | FY-2122              | June                   | 2022              | 3885.00                   |
    #
    | NMSS-AY-2122-10017709-1_4  | NMSS-004        | FY-2122              | June                   | 2022              | 5804.00                   |
    #
    | NMSS-AY-2122-10017709-1_4  | NMSS-007        | FY-2122              | October                | 2021              | 4558.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-007        | FY-2122              | November               | 2021              | 2550.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-007        | FY-2122              | February               | 2022              | 4575.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-007        | FY-2122              | May                    | 2022              | 5440.00                   |
    #
    | NMSS-AY-2122-10017709-1_4  | NMSS-008        | FY-2122              | January                | 2022              | 4592.00                   |
    | NMSS-AY-2122-10017709-1_4  | NMSS-008        | FY-2122              | May                    | 2022              | 4496.00                   |
 
    
    
    
    
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61953.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 61953.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    |
    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | AY-2122 | NMSS                        | 61953.00    | [CofG_College2] |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

 



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 61953.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released          | 61953.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    |
    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | AY-2122 | NMSS                        | 61953.00    | [CofG_College2] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4             | [ContractNo] | 2               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017709 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 139557.00     | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017709 Co Ltd  | Active | Document Management Team  | 61953.00               |
    | 10017709 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017709 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017709 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 139557.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 61953.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 19114.00  | 4325.00  | 0.00     | 0.00     | 3513.00  | 0.00     | 0.00     | 0.00     | 5949.00  | 0.00     | 2642.00  | 0.00     | 2685.00  | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 10669.00  | 0.00     | 0.00     | 2682.00  | 0.00     | 0.00     | 2997.00  | 0.00     | 0.00     | 0.00     | 4990.00  | 0.00     | 0.00     | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 3544.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3544.00  | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 20164.00  | 3088.00  | 0.00     | 0.00     | 4771.00  | 2661.00  | 0.00     | 3115.00  | 0.00     | 2816.00  | 0.00     | 0.00     | 3713.00  | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 149             | 24113.00  | 0.00     | 5988.00  | 0.00     | 0.00     | 0.00     | 2783.00  | 5459.00  | 0.00     | 5433.00  | 0.00     | 0.00     | 4450.00  | 16-19 High Value Courses School and College Leavers Uplift  |                          |
    #                                                     £77604.00
    | [ContractNo]   | [AllocRef_16ED] | 39              | 9849.00   | 0.00     | 0.00     | 0.00     | 0.00     | 4099.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5750.00  | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 20089.00  | 0.00     | 0.00     | 3576.00  | 0.00     | 0.00     | 3757.00  | 5338.00  | 0.00     | 3533.00  | 0.00     | 3885.00  | 0.00     | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 5804.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5804.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 17123.00  | 0.00     | 0.00     | 4558.00  | 2550.00  | 0.00     | 0.00     | 4575.00  | 0.00     | 0.00     | 5440.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 9088.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4592.00  | 0.00     | 0.00     | 0.00     | 4496.00  | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |
    #                                                     £61953.00
    
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Delete v2 and set the FA to 'Return to Scheduling' (33182)

    # Change the date 
    Given the override date is '11/07/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017709 | [ContractNo]   | 2                     | 1                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved            | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                   | False         | False               | 01/08/2021        | 31/07/2022      | ?             |   

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                      | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4    | Contract Deleted                | CRM Integration   | Scheduling         | Returned to Scheduling          | Released       | Released                        | ?                             |
   
    # Check the state of a Release Group (J129)  (No change to Release Group1)
    And   Release Group '[CofG_College1]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 77604.00        |

    # Check the state of a Release Group (J129)  (Disassociate NMSS FA fom Release Group2)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 0               | 0.00            |

    # Check the CRM Funding Allocations data  (Updated to reflect the contract deletion. Remove link to contract)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                      | FundingVersion | FundingType                | Period  | ContractType                               | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus              | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd         | NMSS-AY-2122-Contract-Provider-10017709-1_4    | 1_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)    | NMSS                        | 16-19ED2122     | Scheduling        | Returned to Scheduling | 61953.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)  (Remove link to Release Group)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                      | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4    | 1_4            | AY-2122 | NMSS                        | 61953.00    | ?            |





    # 33182 ends here. Scenario continues for 33228





    # Re-instate the NMSS Funding Allocation (33228)  (Substatus ... Return to Scheduling -> Awaiting Release) 

    # Change the date 
    Given the override date is '13/07/2021'

    # Move FA from 'Return to Scheduling' to 'Awaiting Release' (J136)
    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
    | FundingId                                      |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4    |

    # Check the CRM Funding Allocations data  (Change the sub-status to Awaiting Release)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61953.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |
    | 10017709 | 10017709 Co Ltd  | 1619-AS-2122-Contract-Provider-10017709-2_0             | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 77604.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                      | Action                         | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4    | Reinstate Awaiting Release     | CRM Integration   | Scheduling         | Awaiting Release                | Scheduling     | Reinstatement in Progress       | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4    | Reinstatement in Progress      | FCS8 TEST         | Scheduling         | Reinstatement in Progress       | Scheduling     | Returned to Scheduling          | ?                             |
    
    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Check PaaS FundingAllocation.FundingAllocation (J131) 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                    | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    |
    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4  | 1_4            | AY-2122 | NMSS                        | 61953.00    | [CofG_College3] |

    # Check the state of a Release Group (J129)  (A new release Group is created containing the NMSS FA)
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 61953.00        |
    




    # Execute a NON-FINANCIAL amendment on v1 again (to create a second draft v2.0)

    # Change the date
    Given the override date is '15/07/2021'

    # Issue a non-financial VARIATION amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    

    
    # Release the Release Group containing the reinstated FA

    # Change the date 
    Given the override date is '17/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College3]   |

    # Check the state of a Release Group (J129) 
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 61953.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017709' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017709 | 10017709 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released          | 61953.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    |
    | 10017709 | NMSS-AY-2122-Contract-Provider-10017709-1_4             | 1_4            | AY-2122 | NMSS                        | 61953.00    | [CofG_College3] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017709-1_4             | [ContractNo] | 2               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College3]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017709 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017709 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017709 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017709 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 139557.00     | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017709 Co Ltd  | Active | Document Management Team  | 61953.00               |
    | 10017709 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017709 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017709 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 139557.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 61953.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 19114.00  | 4325.00  | 0.00     | 0.00     | 3513.00  | 0.00     | 0.00     | 0.00     | 5949.00  | 0.00     | 2642.00  | 0.00     | 2685.00  | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 10669.00  | 0.00     | 0.00     | 2682.00  | 0.00     | 0.00     | 2997.00  | 0.00     | 0.00     | 0.00     | 4990.00  | 0.00     | 0.00     | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 3544.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3544.00  | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 20164.00  | 3088.00  | 0.00     | 0.00     | 4771.00  | 2661.00  | 0.00     | 3115.00  | 0.00     | 2816.00  | 0.00     | 0.00     | 3713.00  | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 149             | 24113.00  | 0.00     | 5988.00  | 0.00     | 0.00     | 0.00     | 2783.00  | 5459.00  | 0.00     | 5433.00  | 0.00     | 0.00     | 4450.00  | 16-19 High Value Courses School and College Leavers Uplift  |                          |
    #                                                     £77604.00
    | [ContractNo]   | [AllocRef_16ED] | 39              | 9849.00   | 0.00     | 0.00     | 0.00     | 0.00     | 4099.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5750.00  | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 20089.00  | 0.00     | 0.00     | 3576.00  | 0.00     | 0.00     | 3757.00  | 5338.00  | 0.00     | 3533.00  | 0.00     | 3885.00  | 0.00     | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 5804.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5804.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 17123.00  | 0.00     | 0.00     | 4558.00  | 2550.00  | 0.00     | 0.00     | 4575.00  | 0.00     | 0.00     | 5440.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 9088.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4592.00  | 0.00     | 0.00     | 0.00     | 4496.00  | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |
    #                                                     £61953.00

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Tidy Up
    And   the override date is reset
