Feature: ParkFundingAllocation 33239

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A561 Import and release a 1619 FA then import and park a second version of the same 1619 FA. Publish contract then import and park a third version of the FA. Approve contract then import a material then a non-material change. Discard latter. Approve contract. Auto-unpark FA. Check CRM, PaaS and P&D
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017561'
    And   there is no Funding Allocation data in CRM for UKPRN '10017561'
    And   there is no Contract, Task or Workflow data for UKPRN '10017561'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017561'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017561'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017561' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017561' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017561 Co Ltd' with UKPRN '10017561' and OrgId 'ORG0017561' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017561' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017561 | 117561 | 10017561 Co Ltd | 0              | Active                | Yes           | AA017561      | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017561 |





    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6           | 1_6            | 1619                        | AS-2122            | 42230.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017561-1_6  | 1_6                    | 1619-AS-2122-Contract-Provider-10017561-1_6           | 10017561      | Furth        | 01GFE           | 42230.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | 21435.00         | Payment         |
    | 1619-AS-2122-10017561-1_6  | 1619-007        | 4032.00          | Payment         |
    | 1619-AS-2122-10017561-1_6  | 1619-010        | 16763.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | August                 | 2021              | 2975.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | November               | 2021              | 3771.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | December               | 2021              | 2446.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | February               | 2022              | 2420.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | May                    | 2022              | 5438.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-006        | FY-2122              | July                   | 2022              | 4385.00                   |
    #
    | 1619-AS-2122-10017561-1_6  | 1619-007        | FY-2122              | November               | 2021              | 4032.00                   |
    #
    | 1619-AS-2122-10017561-1_6  | 1619-010        | FY-2122              | September              | 2021              | 2234.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-010        | FY-2122              | January                | 2022              | 2004.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-010        | FY-2122              | February               | 2022              | 3757.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-010        | FY-2122              | May                    | 2022              | 5439.00                   |
    | 1619-AS-2122-10017561-1_6  | 1619-010        | FY-2122              | July                   | 2022              | 3329.00                   |
 
 
 
 
 
    # Consume stub data for v1_6
 
    # Change the date 
    Given the override date is '04/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017561 | 10017561 Co Ltd  | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 42230.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 42230.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status      | SubStatus   |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College] | ?           | ?           |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release the Release Group containing v1_6 (32953)

    # Change the date 
    Given the override date is '06/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 42230.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017561' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017561' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)   Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup     |
    | 10017561 | 10017561 Co Ltd  | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 42230.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017561-1_6             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status      | SubStatus   |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College] | ?           | ?           |
 
    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017561 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017561 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017561 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 42230.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017561 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017561 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017561 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017561 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 42230.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 21435.00  | 2975.00  | 0.00     | 0.00     | 3771.00  | 2446.00  | 0.00     | 2420.00  | 0.00     | 0.00     | 5438.00  | 0.00     | 4385.00  | 16-19 High Needs Element 2                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 4032.00   | 0.00     | 0.00     | 0.00     | 4032.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 16763.00  | 0.00     | 2234.00  | 0.00     | 0.00     | 0.00     | 2004.00  | 3757.00  | 0.00     | 0.00     | 5439.00  | 0.00     | 3329.00  | Teacher's Pension Scheme 1619                  |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Populate the stub with v2_0 of the same 1619 (01GFE) FA for this provider

    # Change the date 
    Given the override date is '08/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-2_0           | 2_0            | 1619                        | AS-2122            | 69777.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017561-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10017561-2_0           | 10017561      | Furth        | 01GFE           | 69777.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | 15386.00         | Payment         |
    | 1619-AS-2122-10017561-2_0  | 1619-011        | 13279.00         | Payment         |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | 21379.00         | Payment         |
    | 1619-AS-2122-10017561-2_0  | 1619-020        | 19733.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | FY-2122              | August                 | 2021              | 4380.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | FY-2122              | January                | 2022              | 3568.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | FY-2122              | February               | 2022              | 2002.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | FY-2122              | April                  | 2022              | 2697.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-001        | FY-2122              | June                   | 2022              | 2739.00                   |
    #
    | 1619-AS-2122-10017561-2_0  | 1619-011        | FY-2122              | November               | 2021              | 3506.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-011        | FY-2122              | February               | 2022              | 4745.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-011        | FY-2122              | July                   | 2022              | 5028.00                   |
    #
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | September              | 2021              | 4356.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | November               | 2021              | 2962.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | January                | 2022              | 3144.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | February               | 2022              | 4725.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | May                    | 2022              | 2920.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-013        | FY-2122              | June                   | 2022              | 3272.00                   |
    #
    | 1619-AS-2122-10017561-2_0  | 1619-020        | FY-2122              | August                 | 2021              | 5153.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-020        | FY-2122              | December               | 2021              | 3315.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-020        | FY-2122              | March                  | 2022              | 5890.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-020        | FY-2122              | April                  | 2022              | 3230.00                   |
    | 1619-AS-2122-10017561-2_0  | 1619-020        | FY-2122              | July                   | 2022              | 2145.00                   |
 
 
 
 
 
    # Consume stub data for v2_0 and park the Funding Allocation
 
    # Change the date 
    Given the override date is '10/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)  Because v1.6 is at Draft/Awaiting Documentation, v2.0 is parked in PaaS
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status        | SubStatus          |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-2_0       | 2_0            | AS-2122 | 1619                        | 69777.00    | ?              | Parked        | AwaitingOutcome    |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6       | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College] | ?             | ?                  |





    
    # Publish the contract
    
    # Change the date 
    Given the override date is '12/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
    
    
    
    
    
    # Populate the stub with v4_4 of the same 1619 (01GFE) FA for this provider

    # Change the date 
    Given the override date is '14/07/2020'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-4_4           | 4_4            | 1619                        | AS-2122            | 83417.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017561-4_4  | 4_4                    | 1619-AS-2122-Contract-Provider-10017561-4_4           | 10017561      | Furth        | 01GFE           | 83417.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | 23496.00         | Payment         |
    | 1619-AS-2122-10017561-4_4  | 1619-004        | 3261.00          | Payment         |
    | 1619-AS-2122-10017561-4_4  | 1619-005        | 21236.00         | Payment         |
    | 1619-AS-2122-10017561-4_4  | 1619-009        | 13591.00         | Payment         |
    | 1619-AS-2122-10017561-4_4  | 1619-020        | 7847.00          | Payment         |
    | 1619-AS-2122-10017561-4_4  | 1619-021        | 13986.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | September              | 2021              | 5201.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | October                | 2021              | 2097.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | December               | 2021              | 2343.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | March                  | 2022              | 3481.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | May                    | 2022              | 5131.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-003        | FY-2122              | June                   | 2022              | 5243.00                   |
    #
    | 1619-AS-2122-10017561-4_4  | 1619-004        | FY-2122              | March                  | 2022              | 3261.00                   |
    #
    | 1619-AS-2122-10017561-4_4  | 1619-005        | FY-2122              | October                | 2021              | 4005.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-005        | FY-2122              | December               | 2021              | 4320.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-005        | FY-2122              | March                  | 2022              | 2311.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-005        | FY-2122              | May                    | 2022              | 5399.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-005        | FY-2122              | July                   | 2022              | 5201.00                   |
    #
    | 1619-AS-2122-10017561-4_4  | 1619-009        | FY-2122              | August                 | 2021              | 4394.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-009        | FY-2122              | December               | 2021              | 3240.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-009        | FY-2122              | March                  | 2022              | 2701.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-009        | FY-2122              | May                    | 2022              | 3256.00                   |
    #
    | 1619-AS-2122-10017561-4_4  | 1619-020        | FY-2122              | January                | 2022              | 2329.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-020        | FY-2122              | February               | 2022              | 5518.00                   |
    #
    | 1619-AS-2122-10017561-4_4  | 1619-021        | FY-2122              | October                | 2021              | 4573.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-021        | FY-2122              | January                | 2022              | 5369.00                   |
    | 1619-AS-2122-10017561-4_4  | 1619-021        | FY-2122              | April                  | 2022              | 4044.00                   |
 
 
 
 

    # Consume stub data for v4_4
 
    # Change the date 
    Given the override date is '16/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)  Because v1.6 is at Draft/Awaiting Documentation, v4_4 is also parked in PaaS
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status        | SubStatus          |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-4_4       | 4_4            | AS-2122 | 1619                        | 83417.00    | ?              | Parked        | AwaitingOutcome    |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-2_0       | 2_0            | AS-2122 | 1619                        | 69777.00    | ?              | Discarded     | Superseded         |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6       | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College] | ?             | ?                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017561 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider                     | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017561 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Scenario ends here for 33239 but continues for 33286





    # Populate the stub with non-material FA v5_1 (materially different to 1_6 which is not yet approved)
    
    # Change the date 
    Given the override date is '18/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-5_1           | 5_1            | 1619                        | AS-2122            | 42250.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017561-5_1  | 5_1                    | 1619-AS-2122-Contract-Provider-10017561-5_1           | 10017561      | Furth        | 01GFE           | 42250.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | 21435.00         | Payment         |
    | 1619-AS-2122-10017561-5_1  | 1619-007        | 4052.00          | Payment         |
    | 1619-AS-2122-10017561-5_1  | 1619-010        | 16763.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | August                 | 2021              | 2975.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | November               | 2021              | 3771.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | December               | 2021              | 2446.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | February               | 2022              | 2420.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | May                    | 2022              | 5438.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-006        | FY-2122              | July                   | 2022              | 4385.00                   |
    #
    | 1619-AS-2122-10017561-5_1  | 1619-007        | FY-2122              | November               | 2021              | 4052.00                   |
    #
    | 1619-AS-2122-10017561-5_1  | 1619-010        | FY-2122              | September              | 2021              | 2234.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-010        | FY-2122              | January                | 2022              | 2004.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-010        | FY-2122              | February               | 2022              | 3757.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-010        | FY-2122              | May                    | 2022              | 5439.00                   |
    | 1619-AS-2122-10017561-5_1  | 1619-010        | FY-2122              | July                   | 2022              | 3329.00                   |

 
 
 

    # Consume stub data. v5_1 is a material change to v1_6              
 
    # Change the date 
    Given the override date is '20/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)   Even though v5_1 is identical to v1_6 this is not a non-material change because the contract has not (yet) been approved
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status           | SubStatus          |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-5_1       | 5_1            | AS-2122 | 1619                        | 42250.00    | ?              | Parked           | AwaitingOutcome    |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-4_4       | 4_4            | AS-2122 | 1619                        | 83417.00    | ?              | Discarded        | Superseded         |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-2_0       | 2_0            | AS-2122 | 1619                        | 69777.00    | ?              | Discarded        | Superseded         |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6       | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College] | ?                | ?                  |





    # Publish and approve contract v1 to give it a contracting 'outcome'. 
    
    # Change the date 
    Given the override date is '22/07/2021'

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
    | 10017561 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017561 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

   
    
    
       
    # FA v1_6 updated to 'Contract Approved' in CRM and PaaS  

    # Check the CRM Funding Allocations data (J125)   Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup     |
    | 10017561 | 10017561 Co Ltd  | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 42230.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]   |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | Contract Approved    | CRM Integration   | Contract Approved  | Contract Approved     | Released       | Released              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus          |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College]  | ContractApproved  | ContractApproved   |
 
    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017561-1_6             | [ContractNo] | 1               | 0                  | Yes            |





    # FA v5_1 should now automatically 'un-park' and be added to Contract Control and to a new Release Group: [CofG_College2] 

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Check the CRM Funding Allocations data (J125)   
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup     |
    | 10017561 | 10017561 Co Ltd  | 1619-AS-2122-Contract-Provider-10017561-5_1             | 5_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 42250.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2]  |
 
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-5_1             | 5_1            | AS-2122 | 1619                        | 42250.00    | [CofG_College2] | ?                 | ?                     |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-4_4             | 4_4            | AS-2122 | 1619                        | 83417.00    | ?               | Discarded         | Superseded            |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-2_0             | 2_0            | AS-2122 | 1619                        | 69777.00    | ?               | Discarded         | Superseded            |
    | 10017561 | 1619-AS-2122-Contract-Provider-10017561-1_6             | 1_6            | AS-2122 | 1619                        | 42230.00    | [CofG_College]  | ContractApproved  | ContractApproved      |

   


    # Check Parked and Discarded report

    # Change the date
    Given the override date is '23/07/2021'

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated

    # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
    Then  the Parked and Discarded spreadsheet includes the following
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | CFSProviderType                      | CFSProviderSubType   |
    | Discarded | 1619-AS-2122-Contract-Provider-10017561-2_0          | 69777.00    | Discarded | Superseded                       | Furth                                | 01GFE                |
    | Discarded | 1619-AS-2122-Contract-Provider-10017561-4_4          | 83417.00    | Discarded | Superseded                       | Furth                                | 01GFE                |


    #Tidy Up
    Given the override date is reset
    
