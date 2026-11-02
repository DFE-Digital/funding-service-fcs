Feature: FailedReleases 33557

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A086 Import and release a 2122 DADA FA then publish contract. Import a second DADA FA. Fail to release. Return to Awaiting Release. NFA. Release RG. Check CRM, PaaS and P&D
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017086'
    And   there is no Funding Allocation data in CRM for UKPRN '10017086'
    And   there is no Contract, Task or Workflow data for UKPRN '10017086'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017086'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017086'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017086' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017086' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017086 Co Ltd' with UKPRN '10017086' and OrgId 'ORG0017086' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017086' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017086 | 117086 | 10017086 Co Ltd | 0              | Active                | Yes           | AA017086      | ?             | 120 Vyse Street        | Hockley                | Birmingham             | ?                      | ?                      | ?                      | B18 6NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017086 |





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7           | 1_7            | DADA                        | AY-2122            | 5400.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017086-1_7  | 1_7                    | DADA-AY-2122-Contract-Provider-10017086-1_7           | 10017086      | Furth        | 07HEP           | 5400.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017086-1_7  | DADA-001        | 5400.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017086-1_7  | DADA-001        | FY-2122              | January                | 2022              | 2166.00                   |
    | DADA-AY-2122-10017086-1_7  | DADA-001        | FY-2122              | May                    | 2022              | 3234.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017086 | 10017086 Co Ltd  | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 5400.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 5400.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ?                 | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the value of the ReleaseGroupParameterName to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 5400.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017086' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017086' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017086 | 10017086 Co Ltd  | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 5400.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017086 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017086 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017086 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 5400.00       | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017086 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017086 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017086 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017086 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 5400.00         | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 5400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2166.00  | 0.00     | 0.00     | 0.00     | 3234.00  | 0.00     | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Remove all details from ContractManagement.CreatedContract for a contract
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
 #  And   there are no created contracts for this number '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-03 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017086'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017086 - 10017086 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017086 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017086 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017086 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '04/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Import a second FA while contract is draft. 
    #   v2_4 should park in PaaS awaiting the outcome of contract v1 (currently at Published to Provider)


    # Populate the stub with DADA (07HEP) data 

    # Change the date 
    Given the override date is '08/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-2_4           | 2_4            | DADA                        | AY-2122            | 19326.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017086-2_4  | 2_4                    | DADA-AY-2122-Contract-Provider-10017086-2_4           | 10017086      | Furth        | 07HEP           | 19326.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | 19326.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | August                 | 2021              | 3256.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | October                | 2021              | 2171.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | January                | 2022              | 2487.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | February               | 2022              | 4479.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | April                  | 2022              | 3565.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | July                   | 2022              | 3368.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '09/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
#   | 10017086 | DADA-AY-2122-Contract-Provider-10017086-2_4             | 2_4            | AY-2122 | DADA                        | 19326.00    | [CfS2]          | ?                 | ?                     |
#   | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ContractApproved  | ContractApproved      |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-2_4             | 2_4            | AY-2122 | DADA                        | 19326.00    | ?               | Parked            | AwaitingOutcome       |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ?                 | ?                     |
  
    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017086 | 10017086 Co Ltd  | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 5400.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |
    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Release Successful   | CRM Integration   | Released           | Released              | Scheduling     | Awaiting Release      | ?                     |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'





   # Import a third FA while contract is draft. 
   #   v3_1 should park in PaaS awaiting the coutcome of contract v1 (currently at Published to Provider) but supercede v2_4
   
   # Populate the stub with DADA (07HEP) data 

    # Change the date 
    Given the override date is '12/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017086-2_4  | 3_1                    | DADA-AY-2122-Contract-Provider-10017086-3_1           | 10017086      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | January                | 2022              | 4000.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | February               | 2022              | 5000.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | April                  | 2022              | 5000.00                   |
    | DADA-AY-2122-10017086-2_4  | DADA-001        | FY-2122              | July                   | 2022              | 6000.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '13/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#   | 10017086 | DADA-AY-2122-Contract-Provider-10017086-2_4             | 2_4            | AY-2122 | DADA                        | 19326.00    | [CfS2]          | ?                 | ?                                 |
#   | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ContractApproved  | ContractApproved                  |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-2_4             | 2_4            | AY-2122 | DADA                        | 19326.00    | ?               | Discarded         | Superseded                        |
    | 10017086 | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | AY-2122 | DADA                        | 5400.00     | [CfS]           | ?                 | ?                                 |
 
    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017086 | 10017086 Co Ltd  | DADA-AY-2122-Contract-Provider-10017086-1_7             | 1_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 5400.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |
    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Release Successful   | CRM Integration   | Released           | Released              | Scheduling     | Awaiting Release      | ?                     |
    | DADA-AY-2122-Contract-Provider-10017086-1_7             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Check Parked and Discarded report

    # Change the date
    Given the override date is '14/07/2021'

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated

    # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
    Then  the Parked and Discarded spreadsheet includes the following
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | CFSProviderType                      | CFSProviderSubType   |
    | Discarded | DADA-AY-2122-Contract-Provider-10017086-2_4          | 19326.00    | Discarded | Superseded                       | Furth                                | 07HEP                |
    | Parked    | DADA-AY-2122-Contract-Provider-10017086-3_1          | 20000.00    | Parked    | AwaitingOutcome                  | Furth                                | 07HEP                |


    # Tidy Up
    Given the override date is reset

