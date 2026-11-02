Feature: UnQueueFundingAllocs 33397

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A801 Import and release 1619 FA1. Publish and approve EDSK contract v1. Import 1619 FA2, NFF FA1 and NMSS FA1. NFA EDSK > Published v2. Release 1619 FA2 > Queued. Withdraw contract v2. Unqueue. Check CRM and PaaS

    # 1. Import and release 1619 FA (RG1)
    # 2. Publish and approve contract v1
    # 3. Import 1619 FA2, NMSS FA1 and NFF FA1 (RG2) but don't release 
    # 4. NFA on contract v1 to create draft contract v2
    # 5. Release RG2 > Queued
    # 6. Withdraw contract v2. Un-queue FAs and create draft contract v3

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017801'
    And   there is no Funding Allocation data in CRM for UKPRN '10017801'
    And   there is no Contract, Task or Workflow data for UKPRN '10017801'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017801'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017801'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017801' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017801' 
    And   there is no caseload advisor for UKPRN '10017801' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017801 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017801' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017801 Co Ltd' with UKPRN '10017801' and OrgId 'ORG0017801' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017801 | 117801 | 10017801 Co Ltd | 0              | Active                | Yes           | AA017801      | ?             | 55 High Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017801 |







    # Populate the stub with 1619 (03SFC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3           | 3_3            | 1619                        | AS-2122            | 64396.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017801-3_3  | 3_3                    | 1619-AS-2122-Contract-Provider-10017801-3_3           | 10017801      | Furth        | 03SFC           | 64396.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017801-3_3  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017801-3_3  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017801-3_3  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017801-3_3  | 1619-020        | 3679.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    #
    | 1619-AS-2122-10017801-3_3  | 1619-006        | FY-2122              | July                   | 2022              | 5777.00                   |
    #
    | 1619-AS-2122-10017801-3_3  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    #
    | 1619-AS-2122-10017801-3_3  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017801-3_3  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    #
    | 1619-AS-2122-10017801-3_3  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

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
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 64396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64396.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 64396.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017801' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017801' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017801 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017801 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017801 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64396.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017801 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017801 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017801 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017801 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 64396.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 20885.00  | 0.00     | 0.00     | 2914.00  | 5147.00  | 0.00     | 0.00     | 0.00     | 3513.00  | 0.00     | 3352.00  | 0.00     | 5959.00  | Residential Support Scheme                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 5777.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5777.00  | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 16920.00  | 0.00     | 0.00     | 2362.00  | 0.00     | 0.00     | 5962.00  | 4226.00  | 0.00     | 0.00     | 0.00     | 4370.00  | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 136             | 17135.00  | 0.00     | 3296.00  | 0.00     | 3819.00  | 0.00     | 0.00     | 0.00     | 4374.00  | 0.00     | 5646.00  | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 3679.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3679.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017801_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017801_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A801.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017801'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017801 - 10017801 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017801 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017801 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017801 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Part 2: Publish and approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

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
    | 10017801 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017801 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017801 | [ContractNo]   | 1               | [AllocRef_16ED]  | 85              | 0                     | 20885.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017801 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 5777.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017801 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 16920.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017801 | [ContractNo]   | 1               | [AllocRef_16ED]  | 136             | 0                     | 17135.00     | 0             | 0        | 16-19 High Value Courses Premium               | ?                           |
    | 10017801 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 3679.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |





    # Part 3: Import (but don't release) an amendment to the 1619 FA, an NMSS FA and a NFF FA

    # Populate the stub

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-4_1           | 4_1            | 1619                        | AS-2122            | 74396.00          |
    | Contracting    | 10017801 | NMSS-AY-2122-Contract-Provider-10017801-1_7           | 1_7            | NMSS                        | AY-2122            | 61688.00          |
    | Contracting    | 10017801 | NFF-AS-2122-Contract-Provider-10017801-2_7            | 2_7            | NFF                         | AS-2122            | 49119.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017801-4_1  | 4_1                    | 1619-AS-2122-Contract-Provider-10017801-4_1           | 10017801      | Furth        | 03SFC           | 74396.00                  |
    | NMSS-AY-2122-10017801-1_7  | 1_7                    | NMSS-AY-2122-Contract-Provider-10017801-1_7           | 10017801      | Furth        | 03SFC           | 61688.00                  |
    | NFF-AS-2122-10017801-2_7   | 2_7                    | NFF-AS-2122-Contract-Provider-10017801-2_7            | 10017801      | Furth        | 03SFC           | 49119.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017801-4_1  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017801-4_1  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017801-4_1  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017801-4_1  | 1619-020        | 13679.00         | Payment         |
    #
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | 20934.00         | Payment         |
    | NMSS-AY-2122-10017801-1_7  | NMSS-003        | 11150.00         | Payment         |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | 24246.00         | Payment         |
    | NMSS-AY-2122-10017801-1_7  | NMSS-010        | 5358.00          | Payment         |
    #
    | NFF-AS-2122-10017801-2_7   | NFF-001         | 13789.00         | Payment         |
    | NFF-AS-2122-10017801-2_7   | NFF-003         | 14320.00         | Payment         |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | 21010.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
    | 1619-AS-2122-10017801-4_1  | 1619-020        | FY-2122              | April                  | 2022              | 10000.00                  |
    #
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | FY-2122              | August                 | 2021              | 2651.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | FY-2122              | December               | 2021              | 5567.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | FY-2122              | March                  | 2022              | 5882.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | FY-2122              | May                    | 2022              | 3874.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-002        | FY-2122              | June                   | 2022              | 2960.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-003        | FY-2122              | September              | 2021              | 3389.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-003        | FY-2122              | February               | 2022              | 2406.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-003        | FY-2122              | July                   | 2022              | 5355.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | September              | 2021              | 2248.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | October                | 2021              | 5950.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | December               | 2021              | 2846.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | February               | 2022              | 3092.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | May                    | 2022              | 4230.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-007        | FY-2122              | July                   | 2022              | 5880.00                   |
    | NMSS-AY-2122-10017801-1_7  | NMSS-010        | FY-2122              | September              | 2021              | 5358.00                   |
    #
    | NFF-AS-2122-10017801-2_7   | NFF-001         | FY-2122              | October                | 2021              | 4966.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-001         | FY-2122              | December               | 2021              | 2578.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-001         | FY-2122              | April                  | 2022              | 3614.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-001         | FY-2122              | July                   | 2022              | 2631.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-003         | FY-2122              | September              | 2021              | 2294.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-003         | FY-2122              | December               | 2021              | 3464.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-003         | FY-2122              | February               | 2022              | 2892.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-003         | FY-2122              | June                   | 2022              | 5670.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | FY-2122              | August                 | 2021              | 4691.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | FY-2122              | November               | 2021              | 5076.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | FY-2122              | February               | 2022              | 3922.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | FY-2122              | May                    | 2022              | 3383.00                   |
    | NFF-AS-2122-10017801-2_7   | NFF-004         | FY-2122              | July                   | 2022              | 3938.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '16/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 74396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61688.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 49119.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017801-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017801-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NFF-AS-2122-Contract-Provider-10017801-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 185203.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017801 | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017801 | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 4: Issue an NFA against v1 of the contract and Publish (but don't approve)

    # Change the date
    Given the override date is '18/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017801 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017801 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017801 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Part 5: Release Release Group [CofG_College2]

    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '20/07/2021'

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
    | Released          | 3               | 185203.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017801' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017801' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | In Release        | Queued                  | 74396.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | In Release        | Queued                  | 49119.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017801 | 10017801 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | In Release        | Queued                  | 61688.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-Provider-10017801-4_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017801-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-Provider-10017801-2_7              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-Provider-10017801-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NMSS-AY-2122-Contract-Provider-10017801-1_7             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017801-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved  |
    | 10017801 | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017801 | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | InRelease         | Queued            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo    | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | [ContractNo]  | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'




    
    # Part 6: Withdraw contract v2. Un-queue FAs and create draft contract v3
 
    # Change the date 
    Given the override date is '01/08/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017801 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017801 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017801 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017801 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017801 | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    | 10017801 | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017801 | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017801-4_1             | [ContractNo] | 3               | 0                  | Yes            |
    | 1619-AS-2122-Contract-Provider-10017801-3_3             | [ContractNo] | 1               | 0                  | Yes            |
    | NFF-AS-2122-Contract-Provider-10017801-2_7              | [ContractNo] | 3               | 0                  | Yes            |
    | NMSS-AY-2122-Contract-Provider-10017801-1_7             | [ContractNo] | 3               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 74396.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | 1619-AS-2122-Contract-Provider-10017801-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | NFF-AS-2122-Contract-Provider-10017801-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released          | Released                | 49119.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017801 | 10017801 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017801-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released                | 61688.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20231002
@CFS 
Scenario: A656 Import and release a CCF2122 FA. Approve. Import a CCF2122 FA amendment. NFA. Release FA1. Queue. Reject at Awaiting Internal Approval. Unqueue. Check CRM and PaaS

    # 1. Import release a CCF2122 FA.
    # 2. Publish and approve > contract v1
    # 3. Import updated CCF2122 FA2 but don't release.
    # 4. NFA (Variation) > contract v2
    # 5. Release FA2 > Queue
    # 6. Draft contract version 'rejected' from 'Awaiting Internal Approval' back to 'In Review'

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017656'
    And   there is no Funding Allocation data in CRM for UKPRN '10017656'
    And   there is no Contract, Task or Workflow data for UKPRN '10017656'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017656'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017656'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017656' in the Sharepoint 'CCF-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017656' 
    And   there is no caseload advisor for UKPRN '10017656' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017656 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017656' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017656 Co Ltd' with UKPRN '10017656' and OrgId 'ORG0017656' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017656 | 117656 | 10017656 Co Ltd | 0              | Active                | Yes           | AA017656      | ?             | 26 The Forbury         | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 3EJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017656 |





    # Part 1: Import and release a CCF2122 FA
    
    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/04/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7            | 2_7            | CCF                         | FY-2122            | 3184.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017656-2_7   | 2_7                    | CCF-FY-2122-Contract-Provider-10017656-2_7            | 10017656      | Furth        | 07HEP           | 3184.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017656-2_7   | CCF-001         | 3184.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017656-2_7   | CCF-001         | FY-2122              | March                  | 2022              | 3184.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/04/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 3184.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 3184.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | FY-2122 | CCF                         | 3184.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/04/2021'

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
    | Released          | 1               | 3184.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017656' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017656' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 3184.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | FY-2122 | CCF                         | 3184.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017656 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017656 | [ContractNo]       | College Collaboration Fund             | Contract      | Draft          | Awaiting Documentation  | 3184.00       | 1                     | 0                        | 01/04/2021        | 31/03/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | FY2122 | ?               | 10017656 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017656 | [MasterContractNo] | College Collaboration Fund             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/04/2021        | 31/03/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017656 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017656 | [ContractNo]       | [AllocRef_CCF]        | ?                             | 3184.00         | ?             | ?                | 01/04/2021 | 31/03/2022 | CCF           | CCF2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableName                    | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_CCF]  | 1               | 3184.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3184.00  | College Collaboration Fund (CCF)   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017656_[ContractNo]_v1.pdf' in Sharepoint location 'CCF-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017656_[ContractNo]_v1.pdf' in 'CCF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A656.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017656'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017656 - 10017656 Co Ltd Awaiting documentation  | [AllocRef_CCF]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017656 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017656 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017656 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Part 2: Publish and approve contract v1

    # Change the date 
    Given the override date is '07/04/2021'

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
    | 10017656 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

#    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved | 3184.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | FY-2122 | CCF                         | 3184.00     | [CofG_College]  | ContractApproved  | ContractApproved                  |
#
#    # Check that the CRM Funding Allocation Workflow History includes an approval
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | CCF-FY-2122-Contract-Provider-10017656-2_7              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10017656 | [ContractNo]   | 1               | [AllocRef_CCF]   | 1               | 0                     | 3184.00      | 0             | 0        | College Collaboration Fund (CCF)               | ?                           |





    # Part 3: Import an update to the CCF2122 FA but don't release the Release Group

    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/05/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-3_4            | 3_4            | CCF                         | FY-2122            | 18779.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017656-3_4   | 3_4                    | CCF-FY-2122-Contract-Provider-10017656-3_4            | 10017656      | Furth        | 07HEP           | 18779.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017656-3_4   | CCF-001         | 18779.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017656-3_4   | CCF-001         | FY-2122              | June                   | 2021              | 5904.00                   |
    | CCF-FY-2122-10017656-3_4   | CCF-001         | FY-2122              | August                 | 2021              | 3451.00                   |
    | CCF-FY-2122-10017656-3_4   | CCF-001         | FY-2122              | December               | 2021              | 4931.00                   |
    | CCF-FY-2122-10017656-3_4   | CCF-001         | FY-2122              | March                  | 2022              | 4493.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/05/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 18779.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017656-3_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18779.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | FY-2122 | CCF                         | 18779.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 4: Issue an non-financial amendment to create contract v2

    # Change the date
    Given the override date is '16/05/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus          | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017656 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation     | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017656 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                   | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                          | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Create a dummy docs in Sharepoint
    Given there are no files prefixed '10017656' in the Sharepoint 'CCF-2122-Input-Appendices' folder
    And   there are no files prefixed '10017656' in the Sharepoint 'CCF-2122-Input-Terms And Conditions' folder
    And   a file with filename '10017656_[ContractNo]_v2.pdf' is created in 'CCF-2122-Input-Appendices'
    And   a file with filename '10017656_[ContractNo]_11.pdf' is created in 'CCF-2122-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017656' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

#    # Update the contract from 'Awaiting Documentation' to 'Awaiting Internal Approval'
#    Given the contract sub-status is updated to 'Awaiting Internal Approval' on the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017656'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017656 - 10017656 Co Ltd Please review the contract       | [ContractNo]   | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017656' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus          | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017656 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Internal Approval | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017656 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                   | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                          | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Part 5: Release RG2 > Queue

    # Change the date 
    Given the override date is '18/05/2021'

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
    | Released          | 1               | 18779.00        |

#    # Retrieve parameters from CRM 
#    When  I retrieve the latest contract details from CRM for provider '10017656' for FundingType 'CCF' and period '2122'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10017656' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)  FA has queued
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | In Release        | Queued                  | 18779.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 18/05/2021 | [ContractNo]        |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 3184.00     | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | CCF-FY-2122-Contract-Provider-10017656-3_4              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#    | CCF-FY-2122-Contract-Provider-10017656-3_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | FY-2122 | CCF                         | 18779.00    | [CofG_College2] | InRelease         | Queued                            |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | FY-2122 | CCF                         | 3184.00     | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017656-3_4              | [ContractNo] | 2               | 0                  | Yes            |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus           | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017656 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Internal Approval  | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017656 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                    | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                           | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

 



    # Part 6: Draft contract version 'rejected' from 'Awaiting Internal Approval' back to 'In Review'
    
    # Change the date
    Given the override date is '20/05/2021'
    
    # Manager rejects internal approval using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject' specifying the reason as 'Test A656'

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | FY-2122 | CCF                         | 18779.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017656 | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | FY-2122 | CCF                         | 3184.00     | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017656-3_4              | [ContractNo] | 2               | 1                  | Yes            |
    | CCF-FY-2122-Contract-Provider-10017656-2_7              | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released                | 18779.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017656 | 10017656 Co Ltd  | CCF-FY-2122-Contract-Provider-10017656-2_7              | 2_7            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 3184.00     | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017656 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017656 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017656 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017656 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |


     # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A802 Create and approve a DADA2021 contract. Import and release DADA2122 FA. Approve. Import 2122 FA amendment. NFA. Release 2122. Queue. Delete draft 2021. Unqueue. Check CRM and PaaS

    # 1. Create and approve a 20/21 DADA contract v1
    # 2. Import and release a 21/22 DADA FA. 
    # 3. Publish and approve 21/22 DADA contract v1
    # 4. Import but don't release an update to the 21/22 DADA FA
    # 5. NFA variation amendment on 20/21 DADA contract > v2
    # 6. Release 21/22 DADA FA > Queue
    # 7. Delete draft 20/21 DADA contract v2 and auto-unqueue 21/22 DADA FA 

    Given there are no allocations marked as Under Termination for UKPRN '10017802' 
    And   there are no terminated or closed allocations for UKPRN '10017802' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017802' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017802' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017802'
    And   there is no Funding Allocation data in CRM for UKPRN '10017802'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017802' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017802' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017802' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-802      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-802      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-802      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017802'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017802' 
    And   there is no caseload advisor for UKPRN '10017802' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017802 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017802' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017802 Co Ltd' with UKPRN '10017802' and OrgId 'ORG0017802' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017802 | 117802 | 10017802 Co Ltd | 0              | Active                | Yes           | AA017802      | ?             | 231a Union Street      | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017802 |





    # Part 1: Create and approve a DADA2021 contract > v1
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-802'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-802'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017802 | 10017802 Co Ltd      | ESFA-802             | DADAS-802      | 1                     | 01/08/2020        | 31/07/2021      | 5309.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017802 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017802 | DADAS-802      | DADA-802      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 5309.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017802 | DADAS-802      | DADA-802      | 1               | 0                     | 5309.00   | 2998.00   | 2311.00   | 0.00     | 2998.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2311.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-802'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-802' and actual ContractNumber 'DADAS-802'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-802' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release a 21/22 DADA FA

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-3_0           | 3_0            | DADA                        | AY-2122            | 5048.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017802-3_0  | 3_0                    | DADA-AY-2122-Contract-Provider-10017802-3_0           | 10017802      | Furth        | 07HEP           | 5048.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017802-3_0  | DADA-001        | 5048.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017802-3_0  | DADA-001        | FY-2122              | September              | 2021              | 5048.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 5048.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017802-3_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 5048.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | AY-2122 | DADA                        | 5048.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 5048.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017802' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017802' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 5048.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | AY-2122 | DADA                        | 5048.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017802-3_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017802 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 5048.00       | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017802 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017802 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017802 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017802 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 5048.00         | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 5048.00   | 0.00     | 5048.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017802_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017802_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A802.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |





    # Part 3: Publish and approve 21/22 DADA contract v1

    # Change the date 
    Given the override date is '07/07/2021'

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
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

 



    # Part 4: Import but don't release an update to the 21/22 DADA FA

    # Change the date
    Given the override date is '02/08/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Populate the stub with DADA (07HEP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-4_5           | 4_5            | DADA                        | AY-2122            | 15975.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017802-4_5  | 4_5                    | DADA-AY-2122-Contract-Provider-10017802-4_5           | 10017802      | Furth        | 07HEP           | 15975.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | 15975.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | FY-2122              | September              | 2021              | 2993.00                   |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | FY-2122              | December               | 2021              | 4676.00                   |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | FY-2122              | March                  | 2022              | 2566.00                   |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | FY-2122              | April                  | 2022              | 3020.00                   |
    | DADA-AY-2122-10017802-4_5  | DADA-001        | FY-2122              | July                   | 2022              | 2720.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15975.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15975.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | AY-2122 | DADA                        | 15975.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 5: NFA variation amendment on 20/21 DADA contract > v2

    # Change the date
    Given the override date is '08/08/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-802' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'In Review'
    Given the contract sub-status is updated to 'In Review' on the latest version of contract 'DADAS-802'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 2                     | 0                        | Draft            | In Review                                | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Release 21/22 DADA FA > Queue

    # Change the date
    Given the override date is '12/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 15975.00        |

#    # Retrieve parameters from CRM 
#    When  I retrieve the latest contract details from CRM for provider '10017802' for FundingType 'DADA' and period '2122'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10017802' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 2                     | 0                        | Draft            | In Review                                | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 15975.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 12/08/2021 | DADAS-802           |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 5048.00     | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | AY-2122 | DADA                        | 15975.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | AY-2122 | DADA                        | 5048.00     | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017802-4_5             | DADAS-802    | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017802-3_0             | [ContractNo] | 1               | 0                  | Yes            |
 
    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 7: Delete draft 20/21 DADA contract v2 and auto-unqueue 21/22 DADA FA 

    # Change the date
    Given the override date is '18/08/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of the draft 20/21 contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017802 | DADAS-802      | 2                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017802 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017802 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017802 | DADAS-802          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017802 | ESFA-802           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15975.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017802 | 10017802 Co Ltd  | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 5048.00     | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-4_5             | 4_5            | AY-2122 | DADA                        | 15975.00    | [CfS2]          | ?                 | ?                                 |
    | 10017802 | DADA-AY-2122-Contract-Provider-10017802-3_0             | 3_0            | AY-2122 | DADA                        | 5048.00     | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017802-4_5             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017802-3_0             | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset
      
