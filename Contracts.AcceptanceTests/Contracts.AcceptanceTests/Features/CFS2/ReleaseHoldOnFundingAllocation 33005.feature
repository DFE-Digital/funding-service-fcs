Feature: ReleaseHoldOnFundingAllocation 33005

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A716  Import one CFS FA and put it on hold. (Release Group now empty). Release the hold. Add FA to Release Group. Release the Release Group. Check CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017716'
    And   there is no Funding Allocation data in CRM for UKPRN '10017716'
    And   there is no Contract, Task or Workflow data for UKPRN '10017716'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017716'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017716'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017716' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10017716' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017716' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017716 Co Ltd' with UKPRN '10017716' and OrgId 'ORG0017716' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017716' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017716 | 117716 | 10017716 Co Ltd | 0              | In Administration     | Yes           | AA017716      | ?             | 201 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017716 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017716 | 1619-AS-2122-Contract-Provider-10017716-1_1           | 1_1            | 1619                        | AS-2122            | 47136.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017716-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017716-1_1           | 10017716      | Furth        | 07HEP           | 47136.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | 25399.00         | Payment         |
    | 1619-AS-2122-10017716-1_1  | 1619-008        | 7284.00          | Payment         |
    | 1619-AS-2122-10017716-1_1  | 1619-009        | 3816.00          | Payment         |
    | 1619-AS-2122-10017716-1_1  | 1619-011        | 10637.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | August                 | 2021              | 4526.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | November               | 2021              | 3474.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | January                | 2022              | 5568.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | March                  | 2022              | 3286.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | April                  | 2022              | 3191.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-007        | FY-2122              | July                   | 2022              | 5354.00                   |
    #
    | 1619-AS-2122-10017716-1_1  | 1619-008        | FY-2122              | August                 | 2021              | 3928.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-008        | FY-2122              | May                    | 2022              | 3356.00                   |
    #
    | 1619-AS-2122-10017716-1_1  | 1619-009        | FY-2122              | June                   | 2022              | 3816.00                   |
    #
    | 1619-AS-2122-10017716-1_1  | 1619-011        | FY-2122              | August                 | 2021              | 5142.00                   |
    | 1619-AS-2122-10017716-1_1  | 1619-011        | FY-2122              | February               | 2022              | 5495.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10017716 | 10017716 Co Ltd  | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 47136.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 47136.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017716 | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | AS-2122 | 1619                        | 47136.00    | [CofG_HEI]   |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Put a Funding Allocation on hold (32922)
    
    # Change the date 
    Given the override date is '20/06/2021'
    
    # Invoke HOLD process (J130)
    When User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                      | Comments                    |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Infrastructure Change           | Director in Prison          |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the CRM Funding Allocations data
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017716 | 10017716 Co Ltd  | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Scheduling        | Held              | 47136.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | Infrastructure Change     |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 0               | 0.00            |

    # Check PaaS FundingAllocation.FundingAllocation (J131) (Funding Allocation has been disassociated from the Release Group)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017716 | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | AS-2122 | 1619                        | 47136.00    | ?            |





    # Release Hold on a Funding Allocation (33005)

    # Change the date 
    Given the override date is '22/06/2021'

    # Invoke process to release a held Funding Allocation (J133)
    When  User 'FCS8 TEST' opts to release the following held Funding Allocations using Workflow WF47
    | FundingId                                               |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Release from Hold               | CRM Integration   | Scheduling         | Awaiting Release                | Scheduling     | Release from Hold in Progress   | ?                             |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Release from Hold in Progress   | FCS8 TEST         | Scheduling         | Release from Hold in Progress   | Scheduling     | Held                            | ?                             |
    #
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the CRM Funding Allocations data
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017716 | 10017716 Co Ltd  | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 47136.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |


    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 47136.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017716 | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | AS-2122 | 1619                        | 47136.00    | [CofG_HEI]   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '24/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 47136.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017716' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017716' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10017716 | 10017716 Co Ltd  | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Released          | Released          | 47136.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017716-1_1             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Release from Hold               | CRM Integration   | Scheduling         | Awaiting Release                | Scheduling     | Release from Hold in Progress   | ?                             |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Release from Hold in Progress   | FCS8 TEST         | Scheduling         | Release from Hold in Progress   | Scheduling     | Held                            | ?                             |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Director in Prison            |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017716 | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | AS-2122 | 1619                        | 47136.00    | [CofG_HEI]   |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017716-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI] Master = [MasterContractNo] Contract = [MasterContractNo]' is written to the Output window

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017716 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017716 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017716 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 47136.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017716 Co Ltd  | Active | Document Management Team  |
    | 10017716 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017716 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017716 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 47136.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 25399.00  | 4526.00  | 0.00     | 0.00     | 3474.00  | 0.00     | 5568.00  | 0.00     | 3286.00  | 3191.00  | 0.00     | 0.00     | 5354.00  | 16-19 Capacity and Delivery                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 7284.00   | 3928.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3356.00  | 0.00     | 0.00     | 16-19 Advanced Maths Premium                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 136             | 3816.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3816.00  | 0.00     | 16-19 High Value Courses Premium               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 10637.00  | 5142.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5495.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence  |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017716_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017716_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A716.pdf'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017716 - 10017716 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017716 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '27/06/2021'

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
    | 10017716 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017716 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |
    | 10017716 | 10017716 Co Ltd  | 1619-AS-2122-Contract-Provider-10017716-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 47136.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017716 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 25399.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017716 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 7284.00      | 0             | 0        | 16-19 Advanced Maths Premium                   | ?                           |
    | 10017716 | [ContractNo]   | 1               | [AllocRef_16ED]  | 136             | 0                     | 3816.00      | 0             | 0        | 16-19 High Value Courses Premium               | ?                           |
    | 10017716 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 10637.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A717 Import two CFS FAs for different UKPRNs. Put one on hold. Release the Release Group. (RG now gone). Release the hold. Add FA to a new Release Group. Release the second Release Group. Check CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017717'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018717'
    And   there is no Funding Allocation data in CRM for UKPRN '10017717'
    And   there is no Funding Allocation data in CRM for UKPRN '10018717'
    And   there is no Contract, Task or Workflow data for UKPRN '10017717'
    And   there is no Contract, Task or Workflow data for UKPRN '10018717'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017717'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018717'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017717'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018717'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017717' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (SPI)     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017717' 
    And   there is no Organisation data for UKPRN '10018717' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017717 Co Ltd' with UKPRN '10017717' and OrgId 'ORG0017717' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018717 Co Ltd' with UKPRN '10018717' and OrgId 'ORG0018717' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017717' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017717 | 117717 | 10017717 Co Ltd | 0              | Locked Restructure    | Yes           | AA017717      | ?             | 29 London Road         | ?                      | ?                      | ?                      | High Wycombe           | Buckinghamshire        | HP11 1BJ  |
    | 10018717 | 118717 | 10018717 Co Ltd | 0              | In Administration     | Yes           | AA018717      | ?             | 2 Jenner Road          | Guildford              | Surrey                 | ?                      | ?                      | ?                      | GU1 3PL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017717 |
    | 10018717 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017717 | 1619-AS-2122-Contract-Provider-10017717-3_4           | 3_4            | 1619                        | AS-2122            | 91064.00          |
 
    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017717-3_4  | 3_4                    | 1619-AS-2122-Contract-Provider-10017717-3_4           | 10017717      | Furth        | 18ISP           | 91064.00                  |
 
    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017717-3_4  | 1619-001        | 19115.00         | Payment         |
    | 1619-AS-2122-10017717-3_4  | 1619-002        | 22868.00         | Payment         |
    | 1619-AS-2122-10017717-3_4  | 1619-005        | 12749.00         | Payment         |
    | 1619-AS-2122-10017717-3_4  | 1619-008        | 12157.00         | Payment         |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | 21255.00         | Payment         |
    | 1619-AS-2122-10017717-3_4  | 1619-020        | 2920.00          | Payment         |
 
    # Funding Allocation Profile Period (4)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017717-3_4  | 1619-001        | FY-2122              | August                 | 2021              | 4689.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-001        | FY-2122              | November               | 2021              | 5416.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-001        | FY-2122              | March                  | 2022              | 3236.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-001        | FY-2122              | July                   | 2022              | 5774.00                   |
    #
    | 1619-AS-2122-10017717-3_4  | 1619-002        | FY-2122              | August                 | 2021              | 4577.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-002        | FY-2122              | January                | 2022              | 5645.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-002        | FY-2122              | March                  | 2022              | 2440.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-002        | FY-2122              | April                  | 2022              | 5116.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-002        | FY-2122              | June                   | 2022              | 5090.00                   |
    #
    | 1619-AS-2122-10017717-3_4  | 1619-005        | FY-2122              | August                 | 2021              | 4048.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-005        | FY-2122              | December               | 2021              | 5320.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-005        | FY-2122              | June                   | 2022              | 3381.00                   |
    #
    | 1619-AS-2122-10017717-3_4  | 1619-008        | FY-2122              | November               | 2021              | 5776.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-008        | FY-2122              | December               | 2021              | 4008.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-008        | FY-2122              | July                   | 2022              | 2373.00                   |
    #
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | August                 | 2021              | 4286.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | October                | 2021              | 2139.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | December               | 2021              | 3516.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | February               | 2022              | 4446.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | May                    | 2022              | 3533.00                   |
    | 1619-AS-2122-10017717-3_4  | 1619-011        | FY-2122              | June                   | 2022              | 3335.00                   |
    #
    | 1619-AS-2122-10017717-3_4  | 1619-020        | FY-2122              | November               | 2021              | 2920.00                   |





    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018717 | 1619-AS-2122-Contract-Provider-10018717-2_1           | 2_1            | 1619                        | AS-2122            | 90136.00          |
 
    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10018717-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10018717-2_1           | 10018717      | Furth        | 18ISP           | 90136.00                  |
 
    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10018717-2_1  | 1619-001        | 16753.00         | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-003        | 3528.00          | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-005        | 12718.00         | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-007        | 7679.00          | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-008        | 17078.00         | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-010        | 18072.00         | Payment         |
    | 1619-AS-2122-10018717-2_1  | 1619-021        | 14308.00         | Payment         |
 
    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10018717-2_1  | 1619-001        | FY-2122              | October                | 2021              | 2611.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-001        | FY-2122              | December               | 2022              | 4465.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-001        | FY-2122              | March                  | 2022              | 5843.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-001        | FY-2122              | June                   | 2022              | 3834.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-003        | FY-2122              | January                | 2022              | 3528.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-005        | FY-2122              | August                 | 2021              | 3388.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-005        | FY-2122              | January                | 2022              | 3773.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-005        | FY-2122              | July                   | 2022              | 5557.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-007        | FY-2122              | January                | 2022              | 5426.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-007        | FY-2122              | July                   | 2022              | 2253.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-008        | FY-2122              | October                | 2021              | 4256.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-008        | FY-2122              | January                | 2022              | 2931.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-008        | FY-2122              | April                  | 2022              | 3968.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-008        | FY-2122              | May                    | 2022              | 5923.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-010        | FY-2122              | October                | 2021              | 2422.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-010        | FY-2122              | January                | 2022              | 3010.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-010        | FY-2122              | March                  | 2022              | 3122.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-010        | FY-2122              | May                    | 2022              | 3848.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-010        | FY-2122              | July                   | 2022              | 5670.00                   |
    #
    | 1619-AS-2122-10018717-2_1  | 1619-021        | FY-2122              | August                 | 2021              | 2291.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-021        | FY-2122              | January                | 2022              | 3461.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-021        | FY-2122              | April                  | 2022              | 2889.00                   |
    | 1619-AS-2122-10018717-2_1  | 1619-021        | FY-2122              | July                   | 2022              | 5667.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10017717 | 10017717 Co Ltd  | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 91064.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         |
    | 10018717 | 10018717 Co Ltd  | 1619-AS-2122-Contract-Provider-10018717-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 90136.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |
    | 1619-AS-2122-Contract-Provider-10018717-2_1             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 181200.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017717 | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | AS-2122 | 1619                        | 91064.00    | [CofG_SPI]   |
    | 10018717 | 1619-AS-2122-Contract-Provider-10018717-2_1             | 2_1            | AS-2122 | 1619                        | 90136.00    | [CofG_SPI]   |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Put a Funding Allocation on hold (32922)
    
    # Change the date 
    Given the override date is '20/06/2021'
    
    # Invoke HOLD process (J130)
    When User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                      | Comments                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Held by Allocations Team        | Sub judice                  |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the CRM Funding Allocations data
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10017717 | 10017717 Co Ltd  | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Scheduling        | Held              | 91064.00    | ?             | ?                 | CRM Integration  | CRM Integration  | Held by Allocations Team  |
    | 10018717 | 10018717 Co Ltd  | 1619-AS-2122-Contract-Provider-10018717-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 90136.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         |

    # Check the state of a Release Group in CRM (J129) (One removed, one remaining)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 90136.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131) (Held Funding Allocation has been disassociated from the Release Group)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017717 | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | AS-2122 | 1619                        | 91064.00    | ?            |
    | 10018717 | 1619-AS-2122-Contract-Provider-10018717-2_1             | 2_1            | AS-2122 | 1619                        | 90136.00    | [CofG_SPI]   |





    # Release the Release Group (32953)

    # Change the date 
    Given the override date is '23/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_SPI]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 90136.00        |





    # Release Hold on the Funding Allocation (33005) 
    #   This should create a second Release Group for CofG_SPI

    # Change the date 
    Given the override date is '25/06/2021'

    # Invoke process to release a held Funding Allocation (J133)
    When  User 'FCS8 TEST' opts to release the following held Funding Allocations using Workflow WF47
    | FundingId                                               |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Release from Hold               | CRM Integration   | Scheduling         | Awaiting Release                | Scheduling     | Release from Hold in Progress   | ?                             |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Release from Hold in Progress   | FCS8 TEST         | Scheduling         | Release from Hold in Progress   | Scheduling     | Held                            | ?                             |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the CRM Funding Allocations data
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                |
    | 10017717 | 10017717 Co Ltd  | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 91064.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         |

    # Capture the Release Group parameter value again (J127) (A second Release Group should have been created for CofG_SPI)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 91064.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131) 
    #   Funding Allocation has been linked to the new Release Group
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017717 | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | AS-2122 | 1619                        | 91064.00    | [CofG_SPI]   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '27/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_SPI]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 91064.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017717' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017717' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                |
    | 10017717 | 10017717 Co Ltd  | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Released          | Released          | 91064.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017717-3_4             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Release from Hold               | CRM Integration   | Scheduling         | Awaiting Release                | Scheduling     | Release from Hold in Progress   | ?                             |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Release from Hold in Progress   | FCS8 TEST         | Scheduling         | Release from Hold in Progress   | Scheduling     | Held                            | ?                             |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Sub judice                    |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017717 | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | AS-2122 | 1619                        | 91064.00    | [CofG_SPI]   |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017717-3_4             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017717 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017717 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017717 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 91064.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017717 Co Ltd  | Active | Document Management Team  |
    | 10017717 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017717 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017717 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 91064.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 32              | 19115.00  | 4689.00  | 0.00     | 0.00     | 5416.00  | 0.00     | 0.00     | 0.00     | 3236.00  | 0.00     | 0.00     | 0.00     | 5774.00  | 16-19 SPI Element 1                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 22868.00  | 4577.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5645.00  | 0.00     | 2440.00  | 5116.00  | 0.00     | 5090.00  | 0.00     | 16-19 Bursary Funds                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 12749.00  | 4048.00  | 0.00     | 0.00     | 0.00     | 5320.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3381.00  | 0.00     | 16-19 Free Meals                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 12157.00  | 0.00     | 0.00     | 0.00     | 5776.00  | 4008.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2373.00  | 16-19 Advanced Maths Premium                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 21255.00  | 4286.00  | 0.00     | 2139.00  | 0.00     | 3516.00  | 0.00     | 4446.00  | 0.00     | 0.00     | 3533.00  | 3335.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 2920.00   | 0.00     | 0.00     | 0.00     | 2920.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing          |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017717_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017717_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A717.pdf'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017717 - 10017717 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017717 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '28/06/2021'

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
    | 10017717 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017717 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                |
    | 10017717 | 10017717 Co Ltd  | 1619-AS-2122-Contract-Provider-10017717-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 91064.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 32              | 0                     | 19115.00     | 0             | 0        | 16-19 SPI Element 1                            | ?                           |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 22868.00     | 0             | 0        | 16-19 Bursary Funds                            | ?                           |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 12749.00     | 0             | 0        | 16-19 Free Meals                               | ?                           |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 12157.00     | 0             | 0        | 16-19 Advanced Maths Premium                   | ?                           |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 21255.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017717 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 2920.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |


    # Tidy Up
    And   the override date is reset

      