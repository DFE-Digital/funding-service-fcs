Feature: QueueFundingAllocations 33387

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A579 Import and release 1619 FA1. Publish and approve EDSK contract v1. Import 1619 FA2, NFF FA1 and NMSS FA1. NFA EDSK > Published v2. Release 1619 FA2 > Queued. NFF FA2 > Parked. Approve. Check CRM and PaaS

    # 1. Import and release 1619 FA (RG1)
    # 2. Publish and approve contract v1
    # 3. Import 1619 FA2, NMSS FA1 and NFF FA1 (RG2) but don't release 
    # 4. NFA on contract v1 to create draft contract v2
    # 5. Release RG2 > Queued
    # 6. Import NFF FA2 > Parked\Awaiting Outcome
    # 7. Publish and approve contract v2. Unqueue queued FAs
    # 8. Publish and approve contract v3. Release parked FA

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017579'
    And   there is no Funding Allocation data in CRM for UKPRN '10017579'
    And   there is no Contract, Task or Workflow data for UKPRN '10017579'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017579'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017579'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017579' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017579' 
    And   there is no caseload advisor for UKPRN '10017579' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017579 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017579' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017579 Co Ltd' with UKPRN '10017579' and OrgId 'ORG0017579' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017579 | 117579 | 10017579 Co Ltd | 0              | Active                | Yes           | AA017579      | ?             | 55 High Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017579 |





    # Part 1: Import and release 1619 FA (RG1)

    # Populate the stub with 1619 (03SFC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3           | 3_3            | 1619                        | AS-2122            | 64396.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017579-3_3  | 3_3                    | 1619-AS-2122-Contract-Provider-10017579-3_3           | 10017579      | Furth        | 03SFC           | 64396.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-020        | 3679.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-006        | FY-2122              | July                   | 2022              | 5777.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
 
 
 
 
 
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
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 64396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64396.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017579 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64396.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017579 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017579 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017579 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017579 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 64396.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

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
#    And   the file named '10017579_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017579_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A579.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017579'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017579 - 10017579 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Part 2: Publish and approve contract v1

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
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 85              | 0                     | 20885.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 5777.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 16920.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 136             | 0                     | 17135.00     | 0             | 0        | 16-19 High Value Courses Premium               | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 3679.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |





    # Part 3: Import 1619 FA2, NMSS FA1 and NFF FA1 (RG2) but don't release 

    # Populate the stub

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1           | 4_1            | 1619                        | AS-2122            | 74396.00          |
    | Contracting    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7           | 1_7            | NMSS                        | AY-2122            | 61688.00          |
    | Contracting    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7            | 2_7            | NFF                         | AS-2122            | 49119.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017579-4_1  | 4_1                    | 1619-AS-2122-Contract-Provider-10017579-4_1           | 10017579      | Furth        | 03SFC           | 74396.00                  |
    | NMSS-AY-2122-10017579-1_7  | 1_7                    | NMSS-AY-2122-Contract-Provider-10017579-1_7           | 10017579      | Furth        | 03SFC           | 61688.00                  |
    | NFF-AS-2122-10017579-2_7   | 2_7                    | NFF-AS-2122-Contract-Provider-10017579-2_7            | 10017579      | Furth        | 03SFC           | 49119.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | 13679.00         | Payment         |
    #
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | 20934.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | 11150.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | 24246.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-010        | 5358.00          | Payment         |
    #
    | NFF-AS-2122-10017579-2_7   | NFF-001         | 13789.00         | Payment         |
    | NFF-AS-2122-10017579-2_7   | NFF-003         | 14320.00         | Payment         |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | 21010.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | FY-2122              | April                  | 2022              | 10000.00                  |
    #
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | August                 | 2021              | 2651.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | December               | 2021              | 5567.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | March                  | 2022              | 5882.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | May                    | 2022              | 3874.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | June                   | 2022              | 2960.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | September              | 2021              | 3389.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | February               | 2022              | 2406.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | July                   | 2022              | 5355.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | September              | 2021              | 2248.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | October                | 2021              | 5950.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | December               | 2021              | 2846.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | February               | 2022              | 3092.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | May                    | 2022              | 4230.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | July                   | 2022              | 5880.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-010        | FY-2122              | September              | 2021              | 5358.00                   |
    #
    | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | October                | 2021              | 4966.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | December               | 2021              | 2578.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | April                  | 2022              | 3614.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | July                   | 2022              | 2631.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | September              | 2021              | 2294.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | December               | 2021              | 3464.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | February               | 2022              | 2892.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | June                   | 2022              | 5670.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | August                 | 2021              | 4691.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | November               | 2021              | 5076.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | February               | 2022              | 3922.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | May                    | 2022              | 3383.00                   |
    | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | July                   | 2022              | 3938.00                   |

 
 
 
 
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
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 74396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61688.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 49119.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NFF-AS-2122-Contract-Provider-10017579-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 185203.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 4: NFA on contract v1 to create draft contract v2
    
    # Change the date
    Given the override date is '18/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Part 5: Release RG2 > Queued

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
    When  I retrieve the latest contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | In Release        | Queued                  | 74396.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | In Release        | Queued                  | 49119.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | In Release        | Queued                  | 61688.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-Provider-10017579-2_7              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-Provider-10017579-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved  |
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | InRelease         | Queued            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo    | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo]  | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 6: Import NFF FA2 > Parked\Awaiting Outcome
    
    # Populate the stub

    # Change the date 
    Given the override date is '22/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1            | 3_1            | NFF                         | AS-2122            | 40416.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10017579-3_1   | 3_1                    | NFF-AS-2122-Contract-Provider-10017579-3_1            | 10017579      | Furth        | 03SFC           | 40416.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | 12838.00         | Payment         |
    | NFF-AS-2122-10017579-3_1   | NFF-002         | 3744.00          | Payment         |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | 23834.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | September              | 2021              | 3240.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | January                | 2022              | 3043.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | February               | 2022              | 2572.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | June                   | 2022              | 3983.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-002         | FY-2122              | September              | 2021              | 3744.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | August                 | 2021              | 3970.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | November               | 2021              | 5038.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | March                  | 2022              | 5834.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | April                  | 2022              | 4509.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | June                   | 2022              | 4483.00                   |
 
 
 
 
 
    # Consume stub data.  NFF v3_1 is Parked\Awaiting Outcome
 
    # Change the date 
    Given the override date is '23/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued                            |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | InRelease         | Queued                            |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | InRelease         | Queued                            |





    # Start of 33394 (Un-queue)

    
    # Part 7: Publish and approve contract v2. Unqueue queued FAs
 
    # Change the date 
    Given the override date is '01/08/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status                | SubStatus              | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released              | Released               | 74396.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved     | Contract Approved      | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released              | Released               | 49119.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released              | Released               | 61688.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | [ContractNo] | 3               | 0                  | Yes            |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |
    #
    | NFF-AS-2122-Contract-Provider-10017579-2_7              | [ContractNo] | 3               | 0                  | Yes            |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | [ContractNo] | 3               | 0                  | Yes            |





    # Part 8: Publish and approve contract v3. Release parked FA
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40416.00        |


    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 74396.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release        | 40416.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_College3] | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved       | 49119.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved       | 61688.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | [ContractNo] | 3               | 0                  | Yes            |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |
    #
    | NFF-AS-2122-Contract-Provider-10017579-2_7              | [ContractNo] | 3               | 0                  | Yes            |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | [ContractNo] | 3               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A579x Similar to A579 but without NFF 2_7

    # 1. Import and release 1619 FA (RG1)
    # 2. Publish and approve contract v1
    # 3. Import 1619 FA2 and NMSS FA1 (RG2) but don't release 
    # 4. NFA on contract v1 to create draft contract v2
    # 5. Release RG2 > Queued
    # 6. Import NFF FA > Scheduling\Awaiting Release 
    # 7. Publish and approve contract v2. Unqueue queued FAs
    # 8. Publish and approve contract v3. 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017579'
    And   there is no Funding Allocation data in CRM for UKPRN '10017579'
    And   there is no Contract, Task or Workflow data for UKPRN '10017579'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017579'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017579'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017579' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017579' 
    And   there is no caseload advisor for UKPRN '10017579' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017579 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017579' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017579 Co Ltd' with UKPRN '10017579' and OrgId 'ORG0017579' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017579 | 117579 | 10017579 Co Ltd | 0              | Active                | Yes           | AA017579      | ?             | 55 High Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017579 |







    # Populate the stub with 1619 (03SFC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3           | 3_3            | 1619                        | AS-2122            | 64396.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017579-3_3  | 3_3                    | 1619-AS-2122-Contract-Provider-10017579-3_3           | 10017579      | Furth        | 03SFC           | 64396.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017579-3_3  | 1619-020        | 3679.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-006        | FY-2122              | July                   | 2022              | 5777.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017579-3_3  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    #
    | 1619-AS-2122-10017579-3_3  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
 
 
 
 
 
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
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 64396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64396.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017579 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64396.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017579 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017579 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017579 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017579 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 64396.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

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
#    And   the file named '10017579_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017579_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A579.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017579'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017579 - 10017579 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017579 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 85              | 0                     | 20885.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 5777.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 16920.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 136             | 0                     | 17135.00     | 0             | 0        | 16-19 High Value Courses Premium               | ?                           |
    | 10017579 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 3679.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |





    # Stage 2. Import (but don't release) an amendment to the 1619 FA and an NMSS FA

    # Populate the stub

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1           | 4_1            | 1619                        | AS-2122            | 74396.00          |
    | Contracting    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7           | 1_7            | NMSS                        | AY-2122            | 61688.00          |
 #  | Contracting    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7            | 2_7            | NFF                         | AS-2122            | 49119.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017579-4_1  | 4_1                    | 1619-AS-2122-Contract-Provider-10017579-4_1           | 10017579      | Furth        | 03SFC           | 74396.00                  |
    | NMSS-AY-2122-10017579-1_7  | 1_7                    | NMSS-AY-2122-Contract-Provider-10017579-1_7           | 10017579      | Furth        | 03SFC           | 61688.00                  |
 #  | NFF-AS-2122-10017579-2_7   | 2_7                    | NFF-AS-2122-Contract-Provider-10017579-2_7            | 10017579      | Furth        | 03SFC           | 49119.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | 17135.00         | Payment         |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | 13679.00         | Payment         |
    #
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | 20934.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | 11150.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | 24246.00         | Payment         |
    | NMSS-AY-2122-10017579-1_7  | NMSS-010        | 5358.00          | Payment         |
    #
 #  | NFF-AS-2122-10017579-2_7   | NFF-001         | 13789.00         | Payment         |
 #  | NFF-AS-2122-10017579-2_7   | NFF-003         | 14320.00         | Payment         |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | 21010.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
    | 1619-AS-2122-10017579-4_1  | 1619-020        | FY-2122              | April                  | 2022              | 10000.00                  |
    #
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | August                 | 2021              | 2651.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | December               | 2021              | 5567.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | March                  | 2022              | 5882.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | May                    | 2022              | 3874.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-002        | FY-2122              | June                   | 2022              | 2960.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | September              | 2021              | 3389.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | February               | 2022              | 2406.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-003        | FY-2122              | July                   | 2022              | 5355.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | September              | 2021              | 2248.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | October                | 2021              | 5950.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | December               | 2021              | 2846.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | February               | 2022              | 3092.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | May                    | 2022              | 4230.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-007        | FY-2122              | July                   | 2022              | 5880.00                   |
    | NMSS-AY-2122-10017579-1_7  | NMSS-010        | FY-2122              | September              | 2021              | 5358.00                   |
    #
 #  | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | October                | 2021              | 4966.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | December               | 2021              | 2578.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | April                  | 2022              | 3614.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-001         | FY-2122              | July                   | 2022              | 2631.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | September              | 2021              | 2294.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | December               | 2021              | 3464.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | February               | 2022              | 2892.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-003         | FY-2122              | June                   | 2022              | 5670.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | August                 | 2021              | 4691.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | November               | 2021              | 5076.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | February               | 2022              | 3922.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | May                    | 2022              | 3383.00                   |
 #  | NFF-AS-2122-10017579-2_7   | NFF-004         | FY-2122              | July                   | 2022              | 3938.00                   |

 
 
 
 
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
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 74396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61688.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |
 #  | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 49119.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
 #  | NFF-AS-2122-Contract-Provider-10017579-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 136084.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |
 #  | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Issue an NFA against v1 of the contract and Publish (but don't approve)

    # Change the date
    Given the override date is '18/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Stage 3. Release Release Group [CofG_College2]

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
    | Released          | 2               | 136084.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017579' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | In Release        | Queued                  | 74396.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
 #  | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | In Release        | Queued                  | 49119.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | In Release        | Queued                  | 61688.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
 #  | NFF-AS-2122-Contract-Provider-10017579-2_7              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
 #  | NFF-AS-2122-Contract-Provider-10017579-2_7              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved  |
 #  | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | InRelease         | Queued            |
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | InRelease         | Queued            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo    | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo]  | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Stage 3. Import an NFF FA and Park Awaiting Outcome (of the contract)
    
    # Populate the stub

    # Change the date 
    Given the override date is '22/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1            | 3_1            | NFF                         | AS-2122            | 40416.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10017579-3_1   | 3_1                    | NFF-AS-2122-Contract-Provider-10017579-3_1            | 10017579      | Furth        | 03SFC           | 40416.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | 12838.00         | Payment         |
    | NFF-AS-2122-10017579-3_1   | NFF-002         | 3744.00          | Payment         |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | 23834.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | September              | 2021              | 3240.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | January                | 2022              | 3043.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | February               | 2022              | 2572.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-001         | FY-2122              | June                   | 2022              | 3983.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-002         | FY-2122              | September              | 2021              | 3744.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | August                 | 2021              | 3970.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | November               | 2021              | 5038.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | March                  | 2022              | 5834.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | April                  | 2022              | 4509.00                   |
    | NFF-AS-2122-10017579-3_1   | NFF-005         | FY-2122              | June                   | 2022              | 4483.00                   |
 
 
 
 
 
    # Consume stub data. > Scheduling\Awaiting Release
 
    # Change the date 
    Given the override date is '23/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued                            |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | [CofG_College3] | ?                 | ?                                 |
 #  | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | InRelease         | Queued                            |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | InRelease         | Queued                            |





    # Start of 33394 (Un-queue)
    
    # Publish and approve contract v2
 
    # Change the date 
    Given the override date is '01/08/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status                | SubStatus              | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released              | Released               | 74396.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved     | Contract Approved      | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    #
 #  | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released              | Released               | 49119.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released              | Released               | 61688.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | [CofG_College3] | ?                 | ?                                 |
 #  | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |


    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | [ContractNo] | 3               | 0                  | Yes            |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |
    #
 #  | NFF-AS-2122-Contract-Provider-10017579-2_7              | [ContractNo] | 3               | 0                  | Yes            |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | [ContractNo] | 3               | 0                  | Yes            |





    # Publish and approve contract v3
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017579 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017579 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017579 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40416.00        |


    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 74396.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017579 | 10017579 Co Ltd  | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release        | 40416.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_College3] | ?          | ?                   |
 #  | 10017579 | 10017579 Co Ltd  | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved       | 49119.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    #
    | 10017579 | 10017579 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved       | 61688.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |
    | 10017579 | 1619-AS-2122-Contract-Provider-10017579-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NFF-AS-2122-Contract-Provider-10017579-3_1              | 3_1            | AS-2122 | NFF                         | 40416.00    | [CofG_College3] | ?                 | ?                                 |
 #  | 10017579 | NFF-AS-2122-Contract-Provider-10017579-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |
    #
    | 10017579 | NMSS-AY-2122-Contract-Provider-10017579-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017579-4_1             | [ContractNo] | 3               | 0                  | Yes            |
    | 1619-AS-2122-Contract-Provider-10017579-3_3             | [ContractNo] | 1               | 0                  | Yes            |
    #
 #  | NFF-AS-2122-Contract-Provider-10017579-2_7              | [ContractNo] | 3               | 0                  | Yes            |
    #
    | NMSS-AY-2122-Contract-Provider-10017579-1_7             | [ContractNo] | 3               | 0                  | Yes            |



    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A286 Import and release 1619 FA1. Publish and approve EDSK contract v1. Import 1619 FA2. NFA EDSK > Published v2. Release 1619 FA2 > Queued. Check CRM and PaaS

    # 1. Import and release 1619 FA (RG1)
    # 2. Publish and approve contract v1
    # 3. Import 1619 FA (RG2) but don't release 
    # 4. NFA on contract v1 to create draft contract v2
    # 5. Release RG2 > Queued
    # 6. Import NFF FA2 > Parked\Awaiting Outcome

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10024286'
    And   there is no Funding Allocation data in CRM for UKPRN '10024286'
    And   there is no Contract, Task or Workflow data for UKPRN '10024286'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10024286'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10024286'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10024286' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10024286' 
    And   there is no caseload advisor for UKPRN '10024286' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10024286 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10024286' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10024286 Co Ltd' with UKPRN '10024286' and OrgId 'ORG0024286' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10024286 | 124286 | 10024286 Co Ltd | 0              | Active                | Yes           | AA024286      | ?             | 55 High Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10024286 |







    # Populate the stub with 1619 (03SFC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-3_3           | 3_3            | 1619                        | AS-2122            | 64396.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10024286-3_3  | 3_3                    | 1619-AS-2122-Contract-Provider-10024286-3_3           | 10024286      | Furth        | 03SFC           | 64396.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10024286-3_3  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10024286-3_3  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10024286-3_3  | 1619-009        | 24135.00         | Payment         |
    | 1619-AS-2122-10024286-3_3  | 1619-020        | 3679.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    #
    | 1619-AS-2122-10024286-3_3  | 1619-006        | FY-2122              | July                   | 2022              | 5777.00                   |
    #
    | 1619-AS-2122-10024286-3_3  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    #
    | 1619-AS-2122-10024286-3_3  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10024286-3_3  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    #
    | 1619-AS-2122-10024286-3_3  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
 
 
 
 
 
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
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 64396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64396.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10024286' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10024286' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10024286 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10024286 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10024286 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64396.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10024286 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10024286 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10024286 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10024286 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 64396.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 20885.00  | 0.00     | 0.00     | 2914.00  | 5147.00  | 0.00     | 0.00     | 0.00     | 3513.00  | 0.00     | 3352.00  | 0.00     | 5959.00  | Residential Support Scheme                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 5777.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5777.00  | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 16920.00  | 0.00     | 0.00     | 2362.00  | 0.00     | 0.00     | 5962.00  | 4226.00  | 0.00     | 0.00     | 0.00     | 4370.00  | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 136             | 24135.00  | 0.00     | 3296.00  | 0.00     | 3819.00  | 0.00     | 0.00     | 0.00     | 4374.00  | 0.00     | 5646.00  | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 3679.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3679.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10024286_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10024286_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A286.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10024286'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10024286 - 10024286 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10024286 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10024286 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10024286 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10024286 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10024286 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 64396.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10024286 | [ContractNo]   | 1               | [AllocRef_16ED]  | 85              | 0                     | 20885.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10024286 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 5777.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10024286 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 16920.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10024286 | [ContractNo]   | 1               | [AllocRef_16ED]  | 136             | 0                     | 24135.00     | 0             | 0        | 16-19 High Value Courses Premium               | ?                           |
    | 10024286 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 3679.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |





    # Stage 2. Import (but don't release) an amendment to the 1619 FA

    # Populate the stub

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-4_1           | 4_1            | 1619                        | AS-2122            | 74396.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10024286-4_1  | 4_1                    | 1619-AS-2122-Contract-Provider-10024286-4_1           | 10024286      | Furth        | 03SFC           | 74396.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | 20885.00         | Payment         |
    | 1619-AS-2122-10024286-4_1  | 1619-006        | 5777.00          | Payment         |
    | 1619-AS-2122-10024286-4_1  | 1619-007        | 16920.00         | Payment         |
    | 1619-AS-2122-10024286-4_1  | 1619-009        | 24135.00         | Payment         |
    | 1619-AS-2122-10024286-4_1  | 1619-020        | 13679.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | FY-2122              | October                | 2021              | 2914.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | FY-2122              | November               | 2021              | 5147.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | FY-2122              | March                  | 2022              | 3513.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | FY-2122              | May                    | 2022              | 3352.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-004        | FY-2122              | July                   | 2022              | 5959.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-007        | FY-2122              | October                | 2021              | 2362.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-007        | FY-2122              | January                | 2022              | 5962.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-007        | FY-2122              | February               | 2022              | 4226.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-007        | FY-2122              | June                   | 2022              | 4370.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-009        | FY-2122              | September              | 2021              | 3296.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-009        | FY-2122              | November               | 2021              | 3819.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-009        | FY-2122              | March                  | 2022              | 4374.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-009        | FY-2122              | May                    | 2022              | 5646.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-020        | FY-2122              | February               | 2022              | 3679.00                   |
    | 1619-AS-2122-10024286-4_1  | 1619-020        | FY-2122              | April                  | 2022              | 10000.00                  |
 
 
 

 
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
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 74396.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10024286-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 74396.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | ?                 | ?                                 |
    | 10024286 | NMSS-AY-2122-Contract-Provider-10024286-1_7             | 1_7            | AY-2122 | NMSS                        | 61688.00    | [CofG_College2] | ?                 | ?                                 |
    | 10024286 | NFF-AS-2122-Contract-Provider-10024286-2_7              | 2_7            | AS-2122 | NFF                         | 49119.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Issue an NFA against v1 of the contract and Publish (but don't approve)

    # Change the date
    Given the override date is '18/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10024286 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10024286 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10024286 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Stage 3. Release Release Group [CofG_College2]

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
    | Released          | 1               | 74396.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10024286' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10024286' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | In Release        | Queued                  | 74396.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 20/07/2021 | [ContractNo]        |
    | 10024286 | 10024286 Co Ltd  | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64396.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-Provider-10024286-4_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10024286-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus         |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-4_1             | 4_1            | AS-2122 | 1619                        | 74396.00    | [CofG_College2] | InRelease         | Queued            |
    | 10024286 | 1619-AS-2122-Contract-Provider-10024286-3_3             | 3_3            | AS-2122 | 1619                        | 64396.00    | [CofG_College]  | ContractApproved  | ContractApproved  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo    | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10024286-3_3             | [ContractNo]  | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

