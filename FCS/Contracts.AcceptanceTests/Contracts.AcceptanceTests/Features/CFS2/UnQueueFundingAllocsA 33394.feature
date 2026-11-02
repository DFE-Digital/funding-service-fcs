Feature: UnQueueFundingAllocsA 33394

@AcceptanceTest @Manual
@CFS
Scenario: A343 Import a 21/22 DADA FA. Release and approve. Import 21/22 FA amendment. Variation NFA 21/22. Release 21/22 FA and queue 

    # 1. Import and release DADA 21/22 FA > Approved 
    # 2. Import 21/22 FA 
    # 3. Variation NFA on 21/22. Contract v2 > Published
    # 4. Release 21/22 FA > Queued

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017343'
    And   there is no Funding Allocation data in CRM for UKPRN '10017343'
    And   there is no Contract, Task or Workflow data for UKPRN '10017343'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017343'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017343'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017343' in the Sharepoint 'DADA-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017343' 
    And   there is no caseload advisor for UKPRN '10017343' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017343 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017343' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017343 Co Ltd' with UKPRN '10017343' and OrgId 'ORG0017343' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017343 | 117343 | 10017343 Co Ltd | 0              | Active                | Yes           | AA017343      | ?             | 14 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017343 |





    # Stage 1: Import and release DADA 21/22 FA. Publish and approve contract v1
    
    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-2_0           | 2_0            | DADA                        | AY-2122            | 5621.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017343-2_0  | 2_0                    | DADA-AY-2122-Contract-Provider-10017343-2_0           | 10017343      | Furth        | 07HEP           | 5621.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017343-2_0  | DADA-001        | 5621.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017343-2_0  | DADA-001        | FY-2122              | October                | 2021              | 5621.00                   |
 
 
 
 
 
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
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 5621.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 5621.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | AY-2122 | DADA                        | 5621.00     | [CfS]           | ?                 | ?                                 |

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
    | Released          | 1               | 5621.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017343' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017343' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 5621.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | AY-2122 | DADA                        | 5621.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017343 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017343 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017343 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 5621.00       | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017343 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017343 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017343 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017343 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 5621.00         | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 5621.00   | 0.00     | 0.00     | 5621.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017343_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017343_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A343.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017343'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017343 - 10017343 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017343 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017343 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017343 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017343 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017343 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 5621.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | AY-2122 | DADA                        | 5621.00     | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017343 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 5621.00      | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |





    # Stage 2: Import 21/22 DADA FA amendment 

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/09/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-4_3           | 4_3            | DADA                        | AY-2122            | 6021.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017343-4_3  | 4_3                    | DADA-AY-2122-Contract-Provider-10017343-4_3           | 10017343      | Furth        | 07HEP           | 6021.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017343-4_3  | DADA-001        | 6021.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017343-4_3  | DADA-001        | FY-2122              | October                | 2021              | 6021.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/09/2021'

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
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-4_3             | 4_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 6021.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017343-4_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 6021.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-4_3             | 4_3            | AY-2122 | DADA                        | 6021.00     | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Stage 3: Issue a VARIATION NFA against v1 of the 21/22 > Awaiting Internal Approval

    # Change the date
    Given the override date is '12/09/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017343 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017343 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017343 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Awaiting Internal Approval'
    Given the contract sub-status is updated to 'Awaiting Internal Approval' on the latest version of contract '[ContractNo]'





    # Stage 4: Release the 21/22 DADA FA amendment > Queue

    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '22/09/2021'

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
    | Released          | 1               | 6021.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017343' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017343' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 




    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-4_3             | 4_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 6021.00     | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 22/09/2021 | [ContractNo]        |
    | 10017343 | 10017343 Co Ltd  | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 5621.00     | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-4_3             | 4_3            | AY-2122 | DADA                        | 6021.00     | [CfS2]          | InRelease         | Queued                            |
    | 10017343 | DADA-AY-2122-Contract-Provider-10017343-2_0             | 2_0            | AY-2122 | DADA                        | 5621.00     | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017343-4_3             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017343-2_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017343 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Internal Approval                | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017343 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017343 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A785a First part of data set up for manual test 

    # 1. Create and approve an EDSK contract with 16TR alloc
    # 2. Issue a VARIATION NFA against v1 > Awaiting Documentation

    Given there are no allocations marked as Under Termination for UKPRN '10017785' 
    And   there are no terminated or closed allocations for UKPRN '10017785' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017785' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017785' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017785' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-785      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-785      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-785       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017785'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017785' 
    And   there is no caseload advisor for UKPRN '10017785' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017785 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017785' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017785 Co Ltd' with UKPRN '10017785' and OrgId 'ORG0017785' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017785 | 117785 | 10017785 Co Ltd | 0              | Locked Restructure    | Yes           | AA017785      | ?             | 9 Portland Terrace     | Jesmond                | ?                      | ?                      | Newcastle-upon-Tyne    | Tyne & Wear            | NE2 1QQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017785 |





    # Part 1: Create and approve an EDSK contract with 16TR alloc

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-785'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-785'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017785 | 10017785 Co Ltd      | ESFA-785             | EDSK-785       | 1                     | 01/08/2021        | 31/07/2022      | 44838.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0017785 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017785 | EDSK-785       | 16TR-785      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 44838.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017785 | EDSK-785       | 16TR-785      | 1               | 0                     | 44838.00  | 29486.00  | 15352.00  | 3327.00  | 5714.00  | 3989.00  | 1761.00  | 3010.00  | 2961.00  | 4844.00  | 3880.00  | 3070.00  | 2550.00  | 3357.00  | 6375.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017785 | EDSK-785       | 16TR-785      | 2               | 1                     | 23042.00  | 13308.00  | 9734.00   | 1751.00  | 2675.00  | 2620.00  | 66.00    | 327.00   | 525.00   | 3633.00  | 1711.00  | 2793.00  | 2264.00  | 1133.00  | 3544.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017785 | EDSK-785       | 16TR-785      | 3               | 1                     | 21796.00  | 16178.00  | 5618.00   | 1576.00  | 3039.00  | 1369.00  | 1695.00  | 2683.00  | 2436.00  | 1211.00  | 2169.00  | 277.00   | 286.00   | 2224.00  | 2831.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-785       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-785'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-785' and actual ContractNumber 'EDSK-785'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-785' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017785 | EDSK-785           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017785 | ESFA-785           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 2: Issue a VARIATION NFA against v1 > Awaiting Documentation

    # Change the date
    Given the override date is '14/08/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-785' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017785 | EDSK-785           | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017785 | EDSK-785           | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017785 | ESFA-785           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Put dummy docs in Sharepoint ready for manual activity
    Given there are no files prefixed '10017785' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10017785' in the Sharepoint 'EDSK-2122-Input-Terms And Conditions' folder
    And   a file with filename '10017785_EDSK-785_v2.pdf' is created in 'EDSK-2122-Input-Appendices'
    And   a file with filename '10017785_EDSK-785_11.pdf' is created in 'EDSK-2122-Input-Terms And Conditions'

    
    # In CRM, progress Tasks then 'Initiate Manual Publish To Provider'

    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A785b Second part of data set up for manual test 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017785'
    And   there is no Funding Allocation data in CRM for UKPRN '10017785'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





    # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017785 | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2     | 1_2            | NMSS                        | AY-2122            | 62535.00          |
    | Contracting    | 10017785 | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6      | 1_6            | NFF                         | AS-2122            | 19549.00          |   
    | Contracting    | 10017785 | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4     | 4_4            | 1619                        | AS-2122            | 62111.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017785-1_2  | 1_2                    | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2     | 10017785      | Local        | 10LAU           | 62535.00                  |
    | NFF-AS-2122-10017785-1_6   | 1_6                    | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6      | 10017785      | Local        | 10LAU           | 19549.00                  |
    | 1619-AS-2122-10017785-4_4  | 4_4                    | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4     | 10017785      | Local        | 10LAU           | 62111.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | 27061.00         | Payment         |
    | NMSS-AY-2122-10017785-1_2  | NMSS-007        | 7358.00          | Payment         |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | 20993.00         | Payment         |
    | NMSS-AY-2122-10017785-1_2  | NMSS-010        | 7123.00          | Payment         |
    #
    | NFF-AS-2122-10017785-1_6   | NFF-001         | 4029.00          | Payment         |
    | NFF-AS-2122-10017785-1_6   | NFF-002         | 3636.00          | Payment         |
    | NFF-AS-2122-10017785-1_6   | NFF-004         | 11884.00         | Payment         |
    #
    | 1619-AS-2122-10017785-4_4  | 1619-003        | 7124.00          | Payment         |
    | 1619-AS-2122-10017785-4_4  | 1619-005        | 8713.00          | Payment         |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | 21124.00         | Payment         |
    | 1619-AS-2122-10017785-4_4  | 1619-013        | 9696.00          | Payment         |
    | 1619-AS-2122-10017785-4_4  | 1619-024        | 15454.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | September              | 2021              | 4853.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | November               | 2021              | 4554.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | December               | 2021              | 5451.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | February               | 2022              | 2759.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | April                  | 2022              | 3897.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-004        | FY-2122              | June                   | 2022              | 5547.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-007        | FY-2122              | September              | 2021              | 3367.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-007        | FY-2122              | July                   | 2022              | 3991.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | August                 | 2021              | 3899.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | October                | 2021              | 2472.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | December               | 2021              | 3813.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | March                  | 2022              | 2729.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | May                    | 2022              | 3044.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-009        | FY-2122              | June                   | 2022              | 5036.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-010        | FY-2122              | August                 | 2021              | 4053.00                   |
    | NMSS-AY-2122-10017785-1_2  | NMSS-010        | FY-2122              | May                    | 2022              | 3070.00                   |
    #
    | NFF-AS-2122-10017785-1_6   | NFF-001         | FY-2122              | April                  | 2022              | 4029.00                   |
    | NFF-AS-2122-10017785-1_6   | NFF-002         | FY-2122              | September              | 2021              | 3636.00                   |
    | NFF-AS-2122-10017785-1_6   | NFF-004         | FY-2122              | August                 | 2021              | 2984.00                   |
    | NFF-AS-2122-10017785-1_6   | NFF-004         | FY-2122              | December               | 2021              | 4052.00                   |
    | NFF-AS-2122-10017785-1_6   | NFF-004         | FY-2122              | July                   | 2022              | 4848.00                   |
    #
    | 1619-AS-2122-10017785-4_4  | 1619-003        | FY-2122              | October                | 2021              | 3952.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-003        | FY-2122              | July                   | 2022              | 3172.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-005        | FY-2122              | September              | 2021              | 3873.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-005        | FY-2122              | May                    | 2022              | 4840.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | August                 | 2021              | 3954.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | November               | 2021              | 3794.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | January                | 2022              | 2400.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | March                  | 2022              | 5519.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | April                  | 2022              | 3100.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-006        | FY-2122              | June                   | 2022              | 2357.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-013        | FY-2122              | September              | 2021              | 3360.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-013        | FY-2122              | March                  | 2022              | 3745.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-013        | FY-2122              | May                    | 2022              | 2591.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-024        | FY-2122              | October                | 2021              | 4836.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-024        | FY-2122              | February               | 2022              | 5766.00                   |
    | 1619-AS-2122-10017785-4_4  | 1619-024        | FY-2122              | April                  | 2022              | 4852.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017785 | 10017785 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 62535.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
    | 10017785 | 10017785 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6        | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 19549.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
    | 10017785 | 10017785 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4       | 4_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 62111.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6        | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 144195.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017785 | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2       | 1_2            | AY-2122 | NMSS                        | 62535.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017785 | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6        | 1_6            | AS-2122 | NFF                         | 19549.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017785 | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4       | 4_4            | AS-2122 | 1619                        | 62111.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017785 | 10017785 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthority-10017785-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | In Release        | Queued                  | 62535.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 05/07/2021 | EDSK-785            |
    | 10017785 | 10017785 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017785-1_6        | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued                  | 19549.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 05/07/2021 | EDSK-785            |
    | 10017785 | 10017785 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017785-4_4       | 4_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 62111.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 05/07/2021 | EDSK-785            |


    # Manually 'Confirm Receipt of Signed Contract' and check that FAs un-queue and contract v3 is created 


    # Tidy Up
    Given the override date is reset
    
