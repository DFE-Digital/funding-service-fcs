Feature: AmendmentsVAR2 33229

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A783 Import and release 1619ED 2122 FA1. Approve contract v1. Import and release FA2. Withdraw contract. Import and park FA3. Withdraw FA2. Release FA3
    
    # 1. FA v1_1 imported and released. Contract v1 created and approved
    # 2. FA v2_1 imported and released. Contract amended > v2
    # 3. Publish and withdraw contract v2
    # 4. FA v3_1 imported > 'Parked\Awaiting Outcome'
    # 5. Reinstate FA2 > 'Scheduling\Awaiting Release'
    # 6. Withdraw FA v2_1 
    # 7. Release RG with FA v3_1. Contract v1 amended to v3
    # 8. Publish and Approve contract  v3

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017783'
    And   there is no Funding Allocation data in CRM for UKPRN '10017783'
    And   there is no Contract, Task or Workflow data for UKPRN '10017783'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017783'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017783'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017783' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017783' 
    And   there is no caseload advisor for UKPRN '10017783' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017783 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017783' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017783 Co Ltd' with UKPRN '10017783' and OrgId 'ORG0017783' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017783 | 117783 | 10017783 Co Ltd | 0              | Active                | Yes           | AA017783      | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017783 |





    # Populate the stub with 1619 (06SDC) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1           | 1_1            | 1619                        | AS-2122            | 36664.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017783-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017783-1_1           | 10017783      | Furth        | 06SDC           | 36664.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017783-1_1  | 1619-008        | 12641.00         | Payment         |
    | 1619-AS-2122-10017783-1_1  | 1619-013        | 2447.00          | Payment         |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | 21576.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017783-1_1  | 1619-008        | FY-2122              | August                 | 2021              | 2412.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-008        | FY-2122              | January                | 2022              | 2557.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-008        | FY-2122              | April                  | 2022              | 5062.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-008        | FY-2122              | June                   | 2022              | 2610.00                   |
    #
    | 1619-AS-2122-10017783-1_1  | 1619-013        | FY-2122              | October                | 2021              | 2447.00                   |
    #
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | August                 | 2021              | 5656.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | November               | 2021              | 3407.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | January                | 2022              | 5090.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | March                  | 2022              | 2980.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | May                    | 2022              | 2371.00                   |
    | 1619-AS-2122-10017783-1_1  | 1619-021        | FY-2122              | June                   | 2022              | 2072.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '04/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 36664.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 36664.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '06/07/2021'

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
    | Released          | 1               | 36664.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017783' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017783' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 36664.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017783-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017783 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 36664.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017783 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017783 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017783 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017783 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 36664.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 12641.00  | 2412.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2557.00  | 0.00     | 0.00     | 5062.00  | 0.00     | 2610.00  | 0.00     | 16-19 Advanced Maths Premium                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 2447.00   | 0.00     | 0.00     | 2447.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Maintained Special SSF Bursary Support                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 21576.00  | 5656.00  | 0.00     | 0.00     | 3407.00  | 0.00     | 5090.00  | 0.00     | 2980.00  | 0.00     | 2371.00  | 2072.00  | 0.00     | Alternative Completions - Creative Sector                   |                          |

    # Contract status is now at 'Awaiting Documentation'





    # Publish and approve the contract

    # Change the date 
    Given the override date is '08/07/2021'

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
    | 10017783 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 36664.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)            | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | ?                         | Draft          | ?                                            |





    # Step 2: Populate the stub with 1619 (06SDC) data again
    
    # Change the date
    Given the override date is '10/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1           | 2_1            | 1619                        | AS-2122            | 33823.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017783-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10017783-2_1           | 10017783      | Furth        | 06SDC           | 33823.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | 18443.00         | Payment         |
    | 1619-AS-2122-10017783-2_1  | 1619-013        | 2378.00          | Payment         |
    | 1619-AS-2122-10017783-2_1  | 1619-021        | 13002.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | FY-2122              | September              | 2021              | 4943.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | FY-2122              | November               | 2021              | 3618.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | FY-2122              | March                  | 2022              | 4654.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | FY-2122              | April                  | 2022              | 2609.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-008        | FY-2122              | July                   | 2022              | 2619.00                   |
    #
    | 1619-AS-2122-10017783-2_1  | 1619-013        | FY-2122              | July                   | 2022              | 2378.00                   |
    #
    | 1619-AS-2122-10017783-2_1  | 1619-021        | FY-2122              | August                 | 2021              | 2947.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-021        | FY-2122              | January                | 2022              | 5725.00                   |
    | 1619-AS-2122-10017783-2_1  | 1619-021        | FY-2122              | April                  | 2022              | 4330.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '12/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 33823.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017783-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 33823.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '14/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 33823.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017783' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 33823.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017783-2_1             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017783 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 33823.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | 1               | 10017783 Co Ltd  | Active | Document Management Team  | -2841.00               |
    | 10017783 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017783 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017783 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 33823.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | -2841.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 2378.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2378.00  | Maintained Special SSF Bursary Support      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 13002.00  | 2947.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5725.00  | 0.00     | 0.00     | 4330.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 18443.00  | 0.00     | 4943.00  | 0.00     | 3618.00  | 0.00     | 0.00     | 0.00     | 4654.00  | 2609.00  | 0.00     | 0.00     | 2619.00  | 16-19 Advanced Maths Premium                |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Step 3: Publish then withdraw contract v2

    # Change the date 
    Given the override date is '16/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test A783' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | ?               | ?                 | ?                                 |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1           | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 33823.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1           | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 36664.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 2                     | Withdrawal On Behalf Of Provider Successful | CRM Integration               | FCS2 TEST        | Document Management Team    | Withdrawn         | Withdrawn By Provider                        | FCS2 TEST             | Document Management Team  | Draft          | Withdrawal In Progress                       |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 2                     | Withdraw On Behalf Of Provider              | FCS2 TEST                     | FCS2 TEST        | Document Management Team    | Draft             | Withdrawal In Progress                       | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)            | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | ?                         | Draft          | ?                                            |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '2' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Withdrawal On Behalf Of Provider Successful    | CRM Integration               | ?                                    |
    | Withdraw On Behalf Of Provider                 | FCS2 TEST                     | Test A783                            |
    | Record Imported (Task generated)               | CRM Integration               | ?                                    |





    # Step 4: FA v3_1 imported > 'Parked Awaiting Outcome'

    # Change the date
    Given the override date is '18/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (06SDC) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-3_1           | 3_1            | 1619                        | AS-2122            | 39293.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017783-3_1  | 3_1                    | 1619-AS-2122-Contract-Provider-10017783-3_1           | 10017783      | Furth        | 06SDC           | 39293.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017783-3_1  | 1619-008        | 14154.00         | Payment         |
    | 1619-AS-2122-10017783-3_1  | 1619-013        | 12897.00         | Payment         |
    | 1619-AS-2122-10017783-3_1  | 1619-021        | 12242.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017783-3_1  | 1619-008        | FY-2122              | September              | 2021              | 4517.00                   |
    | 1619-AS-2122-10017783-3_1  | 1619-008        | FY-2122              | February               | 2022              | 5788.00                   |
    | 1619-AS-2122-10017783-3_1  | 1619-008        | FY-2122              | May                    | 2022              | 3849.00                   |
    #
    | 1619-AS-2122-10017783-3_1  | 1619-013        | FY-2122              | June                   | 2022              | 12897.00                  |
    #
    | 1619-AS-2122-10017783-3_1  | 1619-021        | FY-2122              | October                | 2021              | 2243.00                   |
    | 1619-AS-2122-10017783-3_1  | 1619-021        | FY-2122              | December               | 2021              | 4476.00                   |
    | 1619-AS-2122-10017783-3_1  | 1619-021        | FY-2122              | April                  | 2022              | 2842.00                   |
    | 1619-AS-2122-10017783-3_1  | 1619-021        | FY-2122              | May                    | 2022              | 2681.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '20/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-3_1             | 3_1            | AS-2122 | 1619                        | 39293.00    | ?               | Parked            | Awaiting Outcome                  |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | ?               | ?                 | ?                                 |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1           | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 33823.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1           | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 36664.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |





    # Step 5: Reinstate FA2. Scheduling\Returned to Scheduling > Scheduling\Awaiting Release

    # Change the date 
    Given the override date is '22/07/2021'

    # Move FA from 'Return to Scheduling' to 'Awaiting Release' (J136)
    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation
    | FundingId                                      |
    | 1619-AS-2122-Contract-Provider-10017783-2_1    |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the state of a Release Group (J129) 
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 33823.00        |
    
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1           | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 33823.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1           | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 36664.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-3_1             | 3_1            | AS-2122 | 1619                        | 39293.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |





    # Step 6: FA v2_1 is withdrawn

    # Change the date
    Given the override date is '24/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017783-2_1  | 

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-3_1             | 3_1            | AS-2122 | 1619                        | 39293.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-2_1             | 2_1            | AS-2122 | 1619                        | 33823.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017783 | 1619-AS-2122-Contract-Provider-10017783-1_1             | 1_1            | AS-2122 | 1619                        | 36664.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-3_1           | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 39293.00    | ?             | ?                 | CRM Integration  | CRM Integration      |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-2_1           | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 33823.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017783 | 10017783 Co Ltd  | 1619-AS-2122-Contract-Provider-10017783-1_1           | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 36664.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Check the state of a Release Group (J129) 
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 39293.00        |





    # Step 7: Release RG with FA v3_1. Contract v1 amended to v3

    # Change the date 
    Given the override date is '26/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College3]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the state of a Release Group (J129) 
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 39293.00        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017783 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 39293.00      | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017783 Co Ltd  | Active | Document Management Team  | 2629.00                |

    # Check that the Contract Allocation has been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017783 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 39293.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 2629.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 12897.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12897.00 | 0.00     | Maintained Special SSF Bursary Support      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 12242.00  | 0.00     | 0.00     | 2243.00  | 0.00     | 4476.00  | 0.00     | 0.00     | 0.00     | 2842.00  | 2681.00  | 0.00     | 0.00     | Alternative Completions - Creative Sector   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 14154.00  | 0.00     | 4517.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5788.00  | 0.00     | 0.00     | 3849.00  | 0.00     | 0.00     | 16-19 Advanced Maths Premium                |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Workflow History
    Then  the Workflow History for version '3' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017783 | [MasterContractNo] | [ContractNo]   | 3                     | Record Imported (Task generated)            | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | ?                         | Draft          | ?                                            |





    # Step 8: Publish and Approve contract  v3

    # Change the date 
    Given the override date is '27/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017783_[ContractNo]_v3.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '29/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017783 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017783 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017783 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    And   the override date is reset
                      
