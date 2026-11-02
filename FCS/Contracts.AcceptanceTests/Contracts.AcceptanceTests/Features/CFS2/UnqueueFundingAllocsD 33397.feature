Feature: UnqueueFundingAllocsD 33397

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A938 Import and release CCF2122 FA. Approve. Request Contract Termination Initiation. Update CCF2122 FA and queue. Approve Termination Initiation. Auto-unqueue. Check CRM and PaaS.

    # 1. Import and release CCF 21/22 FA. Approve contract v1
    # 2. Request termination initiation approval of 21/22 contract  
    # 3. Release an update to the CCF 21/22 FA > queue
    # 4. Approve Termination Initiation. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017938'
    And   there is no Funding Allocation data in CRM for UKPRN '10017938'
    And   there is no Contract, Task or Workflow data for UKPRN '10017938'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017938'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017938'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017938' in the Sharepoint 'CCF-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017938' 
    And   there is no caseload advisor for UKPRN '10017938' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017938 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017938' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017938 Co Ltd' with UKPRN '10017938' and OrgId 'ORG0017938' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017938 | 117938 | 10017938 Co Ltd | 0              | Active                | Yes           | AA017938      | ?             | 4 Stuart Court         | Nether Street          | Finchley               | London                 | London                 | ?                      | N3 1JP    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017938 |





    # Part 1: Import and release CCF 21/22 FA. Approve contract v1

    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3            | 3_3            | CCF                         | FY-2122            | 25989.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017938-3_3   | 3_3                    | CCF-FY-2122-Contract-Provider-10017938-3_3            | 10017938      | Furth        | 07HEP           | 25989.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | 25989.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | May                    | 2021              | 5079.00                   |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | June                   | 2021              | 2147.00                   |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | September              | 2021              | 2943.00                   |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | November               | 2021              | 5619.00                   |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | December               | 2021              | 5592.00                   |
    | CCF-FY-2122-10017938-3_3   | CCF-001         | FY-2122              | February               | 2022              | 4609.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

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
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 25989.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 25989.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 25989.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017938' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017938' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 25989.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017938 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017938 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017938 | [ContractNo]       | College Collaboration Fund             | Contract      | Draft          | Awaiting Documentation  | 25989.00      | 1                     | 0                        | 01/04/2021        | 31/03/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | FY2122 | ?               | 10017938 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017938 | [MasterContractNo] | College Collaboration Fund             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/04/2021        | 31/03/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017938 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017938 | [ContractNo]       | [AllocRef_CCF]        | ?                             | 25989.00        | ?             | ?                | 01/04/2021 | 31/03/2022 | CCF           | CCF2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_CCF]  | 1               | 25989.00  | 0.00     | 5079.00  | 2147.00  | 0.00     | 0.00     | 2943.00  | 0.00     | 5619.00  | 5592.00  | 0.00     | 4609.00  | 0.00     | College Collaboration Fund (CCF)                            |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017938_[ContractNo]_v1.pdf' in Sharepoint location 'CCF-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017938_[ContractNo]_v1.pdf' in 'CCF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A938.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017938'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017938 - 10017938 Co Ltd Awaiting documentation  | [AllocRef_CCF]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017938 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017938 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017938 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017938 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017938 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved | 25989.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017938 | [ContractNo]   | 1               | [AllocRef_CCF]   | 1               | 0                     | 25989.00     | 0             | 0        | College Collaboration Fund (CCF)               | ?                           |





    # Part 2: Request termination initiation approval of 21/22 contract  

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 06/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_CCF]     | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017938 | [ContractNo]   | 1                     | 0                        | 06/10/2021                 | Notice from Agency           | ?                              | 06/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017938 | [ContractNo]  | [AllocRef_CCF]   | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017938'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017938 - 10017938 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017938 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017938 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Part 3: Release an update to the CCF 21/22 FA > queue

    # Change the date 
    Given the override date is '01/11/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-4_1            | 4_1            | CCF                         | FY-2122            | 26000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017938-4_1   | 4_1                    | CCF-FY-2122-Contract-Provider-10017938-4_1            | 10017938      | Furth        | 07HEP           | 26000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | 26000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | May                    | 2021              | 5090.00                   |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | June                   | 2021              | 2147.00                   |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | September              | 2021              | 2943.00                   |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | November               | 2021              | 5619.00                   |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | December               | 2021              | 5592.00                   |
    | CCF-FY-2122-10017938-4_1   | CCF-001         | FY-2122              | February               | 2022              | 4609.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/11/2021'

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
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 26000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 26000.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 26000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017938' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017938' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | In Release        | Queued                  | 26000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 05/11/2021 | [ContractNo]        |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 25989.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | InRelease         | Queued                            |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017938 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017938 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |





    # Part 4: Approve Termination Initiation. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date (This is ignored by CRM)
    Given the override date is '12/11/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017938' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |


    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017938 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017938 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                         | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017938 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released                | 26000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017938 | 10017938 Co Ltd  | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 25989.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017938 | CCF-FY-2122-Contract-Provider-10017938-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017938-4_1              | [ContractNo] | 2               | 0                  | Yes            |
    | CCF-FY-2122-Contract-Provider-10017938-3_3              | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A939 Import and release CCF2122 FA. Approve. Initiate Contract Modification. Update CCF2122 FA and queue. Reject Modification. Auto-unqueue. Check CRM and PaaS.

    # 1. Import and release CCF 21/22 FA. Approve contract v1
    # 2. Initiate Modification of 21/22 contract  
    # 3. Release an update to the CCF 21/22 FA > queue
    # 4. Reject Modification. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017939'
    And   there is no Funding Allocation data in CRM for UKPRN '10017939'
    And   there is no Contract, Task or Workflow data for UKPRN '10017939'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017939'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017939'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017939' in the Sharepoint 'CCF-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017939' 
    And   there is no caseload advisor for UKPRN '10017939' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017939 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017939' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017939 Co Ltd' with UKPRN '10017939' and OrgId 'ORG0017939' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017939 | 117939 | 10017939 Co Ltd | 0              | Active                | Yes           | AA017939      | ?             | 9 Gandalf Gardens East | Netherby-by-Fleet      | North London           | ?                      | ?                      | ?                      | N3 1JP    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017939 |





    # Part 1: Import and release CCF 21/22 FA. Approve contract v1

    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3            | 3_3            | CCF                         | FY-2122            | 25989.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017939-3_3   | 3_3                    | CCF-FY-2122-Contract-Provider-10017939-3_3            | 10017939      | Furth        | 07HEP           | 25989.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | 25989.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | May                    | 2021              | 5079.00                   |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | June                   | 2021              | 2147.00                   |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | September              | 2021              | 2943.00                   |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | November               | 2021              | 5619.00                   |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | December               | 2021              | 5592.00                   |
    | CCF-FY-2122-10017939-3_3   | CCF-001         | FY-2122              | February               | 2022              | 4609.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

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
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 25989.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 25989.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 25989.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017939' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017939' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 25989.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017939 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017939 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017939 | [ContractNo]       | College Collaboration Fund             | Contract      | Draft          | Awaiting Documentation  | 25989.00      | 1                     | 0                        | 01/04/2021        | 31/03/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | FY2122 | ?               | 10017939 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017939 | [MasterContractNo] | College Collaboration Fund             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/04/2021        | 31/03/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017939 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017939 | [ContractNo]       | [AllocRef_CCF]        | ?                             | 25989.00        | ?             | ?                | 01/04/2021 | 31/03/2022 | CCF           | CCF2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_CCF]  | 1               | 25989.00  | 0.00     | 5079.00  | 2147.00  | 0.00     | 0.00     | 2943.00  | 0.00     | 5619.00  | 5592.00  | 0.00     | 4609.00  | 0.00     | College Collaboration Fund (CCF)                            |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017939_[ContractNo]_v1.pdf' in Sharepoint location 'CCF-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017939_[ContractNo]_v1.pdf' in 'CCF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A939.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017939'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017939 - 10017939 Co Ltd Awaiting documentation  | [AllocRef_CCF]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017939 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017939 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017939 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017939 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017939 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved | 25989.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017939 | [ContractNo]   | 1               | [AllocRef_CCF]   | 1               | 0                     | 25989.00     | 0             | 0        | College Collaboration Fund (CCF)               | ?                           |





    # Part 2: Initiate Modification of 21/22 contract  

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017939 | [ContractNo]  | 1               | 0                  | 06/10/2021               | Removed from RoATP              | Reassessment of circumstances           |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017939 | [ContractNo]   | 1                     | 0                        | 06/10/2021               | 06/10/2021                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017939 | [ContractNo]  | [AllocRef_CCF]   | 1                     | 0                        | 06/10/2021                   | 06/10/2021        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017939'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017939 - 10017939 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017939 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017939 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Part 3: Release an update to the CCF 21/22 FA > queue

    # Change the date 
    Given the override date is '01/11/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-4_1            | 4_1            | CCF                         | FY-2122            | 26000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017939-4_1   | 4_1                    | CCF-FY-2122-Contract-Provider-10017939-4_1            | 10017939      | Furth        | 07HEP           | 26000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | 26000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | May                    | 2021              | 5090.00                   |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | June                   | 2021              | 2147.00                   |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | September              | 2021              | 2943.00                   |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | November               | 2021              | 5619.00                   |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | December               | 2021              | 5592.00                   |
    | CCF-FY-2122-10017939-4_1   | CCF-001         | FY-2122              | February               | 2022              | 4609.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/11/2021'

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
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 26000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 26000.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 26000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017939' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017939' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | In Release        | Queued                  | 26000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | 05/11/2021 | [ContractNo]        |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 25989.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | InRelease         | Queued                            |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017939 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017939 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |





    # Part 4: Reject Modification. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date - CRM ignores this
    Given the override date is '15/10/2020'

    # Clear out specific Notifications
    And   there are no notifications of type 'Contract Modification Rejected' 

    # Reject Modification using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Modification' specifying the reason as 'Technical misunderstanding'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017939 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017939 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017939 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | FY-2122 | CCF                         | 26000.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017939 | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | FY-2122 | CCF                         | 25989.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | [ContractNo] | 2               | 0                  | Yes            |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released                | 26000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017939 | 10017939 Co Ltd  | CCF-FY-2122-Contract-Provider-10017939-3_3              | 3_3            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 25989.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-4_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017939-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A287 Import and release DADA2122 FA. Approve. Initiate Contract Modification. Update DADA2122 FA and queue. Authorise Modification. Auto-unqueue. Check CRM and PaaS.

    # 1. Import and release DADA 21/22 FA. Approve contract v1
    # 2. Initiate Modification of 21/22 contract  
    # 3. Release an update to the DADA 21/22 FA > queue
    # 4. Authorise Modification. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017287'
    And   there is no Funding Allocation data in CRM for UKPRN '10017287'
    And   there is no Contract, Task or Workflow data for UKPRN '10017287'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017287'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017287'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017287' in the Sharepoint 'DADA-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017287' 
    And   there is no caseload advisor for UKPRN '10017287' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017287 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017287' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017287 Co Ltd' with UKPRN '10017287' and OrgId 'ORG0017287' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017287 | 117287 | 10017287 Co Ltd | 0              | Active                | Yes           | AA017287      | ?             | 16 Chaucer Grove       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017287 |





    # Part 1: Import and release DADA 21/22 FA. Approve contract v1
    
    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6           | 4_6            | DADA                        | AY-2122            | 28489.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017287-4_6  | 4_6                    | DADA-AY-2122-Contract-Provider-10017287-4_6           | 10017287      | Furth        | 07HEP           | 28489.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | 28489.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | September              | 2021              | 4829.00                   |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | October                | 2021              | 5898.00                   |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | January                | 2022              | 2692.00                   |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | February               | 2022              | 5369.00                   |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | May                    | 2022              | 5342.00                   |
    | DADA-AY-2122-10017287-4_6  | DADA-001        | FY-2122              | June                   | 2022              | 4359.00                   |
 
 
 
 
 
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
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 28489.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 28489.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | AY-2122 | DADA                        | 28489.00    | [CfS]           | ?                 | ?                                 |

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
    | Released          | 1               | 28489.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017287' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017287' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 28489.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | AY-2122 | DADA                        | 28489.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017287 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017287 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017287 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 28489.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017287 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017287 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017287 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017287 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 28489.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 28489.00  | 0.00     | 4829.00  | 5898.00  | 0.00     | 0.00     | 2692.00  | 5369.00  | 0.00     | 0.00     | 5342.00  | 4359.00  | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017287_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017287_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A287.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017287'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017287 - 10017287 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017287 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017287 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017287 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract

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
    | 10017287 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017287 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 28489.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | AY-2122 | DADA                        | 28489.00    | [CfS]           | ContractApproved  | ContractApproved                  |





    # Part 2: Initiate Modification of 21/22 contract  

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017287 | [ContractNo]  | 1               | 0                  | 06/10/2021               | Removed from RoATP              | Reassessment of circumstances           |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017287 | [ContractNo]   | 1                     | 0                        | 06/10/2021               | 06/10/2021                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017287 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 06/10/2021                   | 06/10/2021        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017287'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017287 - 10017287 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017287 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017287 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 3: Release an update to the DADA 21/22 FA > queue

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/11/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-5_1           | 5_1            | DADA                        | AY-2122            | 30000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017287-5_1  | 5_1                    | DADA-AY-2122-Contract-Provider-10017287-5_1           | 10017287      | Furth        | 07HEP           | 30000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | 30000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | September              | 2021              | 4829.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | October                | 2021              | 5898.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | January                | 2022              | 2692.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | February               | 2022              | 5369.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | May                    | 2022              | 5342.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | June                   | 2022              | 4359.00                   |
    | DADA-AY-2122-10017287-5_1  | DADA-001        | FY-2122              | July                   | 2022              | 1511.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/11/2021'

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
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 30000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 30000.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | AY-2122 | DADA                        | 30000.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2021'

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
    | Released          | 1               | 30000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017287' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017287' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 30000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 05/11/2021 | [ContractNo]        |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 28489.00    | [ContractNo   | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | AY-2122 | DADA                        | 30000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | AY-2122 | DADA                        | 28489.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 4: Authorise Modification. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date - CRM ignores this
    Given the override date is '08/11/2020'

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017287' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |


    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017287 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017287 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017287 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 30000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017287 | 10017287 Co Ltd  | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 28489.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-5_1             | 5_1            | AY-2122 | DADA                        | 30000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017287 | DADA-AY-2122-Contract-Provider-10017287-4_6             | 4_6            | AY-2122 | DADA                        | 28489.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017287-5_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017287-4_6             | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: A806 Import and release FAs for a Local Authority and 3 DelOrg. Import and park FAs. Delete contract. Withdraw FAs. Import FAs. NFA. Release RG > queue. Approve contract. Auto-unqueue. Check CRM and PaaS

    # 1. Import and release v1 FAs for the Local Authority and 3 Del Orgs > draft contract v1
    # 2. Import updated v2 FAs for the Local Authority and Del Orgs and add a 4th Del Org > Park Awaiting Outcome
    # 3. Delete draft contract v1. v1 FAs > Scheduling\Returned to Scheduling
    # 4. Withdraw both v1 FAs. Add v2 FAs to new RG then release > contract v1. Approve
    # 5. Import updated v3 FAs
    # 6. NFA > Published to Provider
    # 7. Release RG with v3 FAs > queue
    # 8. Approve contract v2. Auto-unqueue v3 FAs > contract v3

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017806'
    And   there is no Funding Allocation data in CRM for UKPRN '10017806'
    And   there is no Contract, Task or Workflow data for UKPRN '10017806'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017806'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017806'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017806' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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



    # Organisation and Advisors (Local Authority)
    Given there is no Organisation data in CRM for UKPRN '10017806' 
    And   there is no caseload advisor for UKPRN '10017806' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017806 | 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017806 Co Ltd' with UKPRN '10017806' and OrgId 'ORG0017806' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017806 | 117806 | Gawlish County Council | 0              | Active                | Yes           | AA017806      | ?             | 16 Chaucer Grove       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017806 |





    # Organisation and Advisors (DeliveryOrg 1)
    Given there is no Organisation data in CRM for UKPRN '10000350' 
    And   there is no caseload advisor for UKPRN '10000350' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000350 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000350 | 100350 | Arden College          | 0              | Active                | Yes           | AA000350      | ?             | 22 Albert Ave          | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000350 |





    # Organisation and Advisors (DeliveryOrg 2)
    Given there is no Organisation data in CRM for UKPRN '10000670' 
    And   there is no caseload advisor for UKPRN '10000670' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000670 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000670 | 100670 | Bexhill College        | 0              | Active                | Yes           | AA000670      | ?             | 9 Platters Road        | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000670 |





    # Organisation and Advisors (DeliveryOrg 3)
    Given there is no Organisation data in CRM for UKPRN '10000812' 
    And   there is no caseload advisor for UKPRN '10000812' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000812 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000812 | 100812 | Boston College         | 0              | Active                | Yes           | AA000812      | ?             | 101 Bayleaf Road       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000812 |





    # Organisation and Advisors (DeliveryOrg 4)
    Given there is no Organisation data in CRM for UKPRN '10000872' 
    And   there is no caseload advisor for UKPRN '10000872' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000872 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000872 | 100872 | Bridge College         | 0              | Active                | Yes           | AA000872      | ?             | 23 Avenue Road         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000872 |



    # Part 1: Import and release FA for the Local Authority and 3 Del Orgs > draft contract v1

    # Populate the stub with 1619 (10LAU) data (Local Authority 10017806)

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0     | 1_0            | 1619                        | AS-2122            | 5373.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017806-1_0  | 1_0                    | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0     | 10017806      | Local        | 10LAU           | 5373.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017806-1_0  | 1619-001        | 5373.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017806-1_0  | 1619-001        | FY-2122              | September              | 2021              | 5373.00                   |






    # Populate the stub with 1619 (08SSF) data (Delivery Orgs 10000350, 10000670 and 10000812)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2  | 1_2            | 1619                        | AS-2122            | 14765.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10000350-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2  | 10000350      | Schoo        | 08SSF           | 4246.00                   |
    | 1619-AS-2122-10000670-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2  | 10000670      | Schoo        | 08SSF           | 5050.00                   |
    | 1619-AS-2122-10000812-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2  | 10000812      | Schoo        | 08SSF           | 5469.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10000350-1_2  | 1619-004        | 4246.00          | Payment         |
    | 1619-AS-2122-10000670-1_2  | 1619-006        | 5050.00          | Payment         |
    | 1619-AS-2122-10000812-1_2  | 1619-024        | 5469.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10000350-1_2  | 1619-004        | FY-2122              | February               | 2022              | 4246.00                   |
    | 1619-AS-2122-10000670-1_2  | 1619-006        | FY-2122              | March                  | 2022              | 5050.00                   |
    | 1619-AS-2122-10000812-1_2  | 1619-024        | FY-2122              | December               | 2021              | 5469.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider               | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017806 | Gawlish County Council | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 14765.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017806 | Gawlish County Council | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 5373.00     | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 20138.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 20138.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017806' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017806' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) {F7} Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 14765.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 5373.00     | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | [ContractNo] | 1               | 0                  | Yes            |





    # Part 2: Import updated v2 FAs for the Local Authority and Del Orgs and add a 4th Del Org > Park Awaiting Outcome

    # Change the date
    Given the override date is '08/12/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (10LAU) data (Local Authority 10017806)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0     | 2_0            | 1619                        | AS-2122            | 10000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017806-2_0  | 2_0                    | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0     | 10017806      | Local        | 10LAU           | 10000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017806-2_0  | 1619-001        | 10000.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017806-2_0  | 1619-001        | FY-2122              | September              | 2021              | 5373.00                   |
    | 1619-AS-2122-10017806-2_0  | 1619-001        | FY-2122              | November               | 2021              | 4627.00                   |




    # Populate the stub with 1619 (08SSF) data (Delivery Orgs 10000350, 10000670, 10000812 and 10000872)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2  | 2_2            | 1619                        | AS-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10000350-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2  | 10000350      | Schoo        | 08SSF           | 4250.00                   |
    | 1619-AS-2122-10000670-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2  | 10000670      | Schoo        | 08SSF           | 5050.00                   |
    | 1619-AS-2122-10000812-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2  | 10000812      | Schoo        | 08SSF           | 5525.00                   |
    | 1619-AS-2122-10000872-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2  | 10000872      | Schoo        | 08SSF           | 5175.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10000350-2_2  | 1619-004        | 4250.00          | Payment         |
    | 1619-AS-2122-10000670-2_2  | 1619-006        | 5050.00          | Payment         |
    | 1619-AS-2122-10000812-2_2  | 1619-024        | 5525.00          | Payment         |
    | 1619-AS-2122-10000872-2_2  | 1619-021        | 5175.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10000350-2_2  | 1619-004        | FY-2122              | February               | 2022              | 4250.00                   |
    | 1619-AS-2122-10000670-2_2  | 1619-006        | FY-2122              | March                  | 2022              | 5050.00                   |
    | 1619-AS-2122-10000812-2_2  | 1619-024        | FY-2122              | December               | 2021              | 5525.00                   |
    | 1619-AS-2122-10000872-2_2  | 1619-021        | FY-2122              | September              | 2021              | 5175.00                   |




    # Consume stub data
 
    # Change the date 
    Given the override date is '09/12/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | [ContractNo] | 1               | 0                  | Yes            |





    # Part 3: Delete draft contract v1. v1 FAs > Scheduling\Returned to Scheduling

    # Change the date
    Given the override date is '12/12/2021'

    # Trigger WF28 in CRM to issue a delete request against v1 of the draft 21/22 contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017806 | [ContractNo]   | 1                     | 0                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 14765.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 5373.00     | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |


    
    
       
    # Part 4: Withdraw both v1 FAs. Add v2 FAs to new RG then release > contract v1. Approve

    # Change the date
    Given the override date is '13/12/2021'
    
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Test A806'
    | FundingId                                            |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2 |
    | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0    |

    # Capture the Release Group parameter value (J127)
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check the state of a Release Group (J129)  
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 30000.00        |
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Withdrawn         | Withdrawn                         |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '15/12/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA2]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 30000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017806' for FundingType 'EDSK' and period '2122'

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Withdrawn         | Withdrawn                         |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017806 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017806 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017806 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017806 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 5: Import updated v3 FAs

    # Change the date
    Given the override date is '08/01/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (10LAU) data (Local Authority 10017806)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0     | 3_0            | 1619                        | AS-2122            | 12500.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017806-3_0  | 3_0                    | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0     | 10017806      | Local        | 10LAU           | 12500.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017806-3_0  | 1619-001        | 12500.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017806-3_0  | 1619-001        | FY-2122              | September              | 2021              | 5373.00                   |
    | 1619-AS-2122-10017806-3_0  | 1619-001        | FY-2122              | November               | 2021              | 4627.00                   |
    | 1619-AS-2122-10017806-3_0  | 1619-001        | FY-2122              | December               | 2021              | 2500.00                   |




    # Populate the stub with 1619 (08SSF) data (Delivery Orgs 10000350, 10000670, 10000812 and 10000872)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2  | 3_2            | 1619                        | AS-2122            | 28000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10000350-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2  | 10000350      | Schoo        | 08SSF           | 6250.00                   |
    | 1619-AS-2122-10000670-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2  | 10000670      | Schoo        | 08SSF           | 7050.00                   |
    | 1619-AS-2122-10000812-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2  | 10000812      | Schoo        | 08SSF           | 7525.00                   |
    | 1619-AS-2122-10000872-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2  | 10000872      | Schoo        | 08SSF           | 7175.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10000350-3_2  | 1619-004        | 6250.00          | Payment         |
    | 1619-AS-2122-10000670-3_2  | 1619-006        | 7050.00          | Payment         |
    | 1619-AS-2122-10000812-3_2  | 1619-024        | 7525.00          | Payment         |
    | 1619-AS-2122-10000872-3_2  | 1619-021        | 7175.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10000350-3_2  | 1619-004        | FY-2122              | February               | 2022              | 6250.00                   |
    | 1619-AS-2122-10000670-3_2  | 1619-006        | FY-2122              | March                  | 2022              | 7050.00                   |
    | 1619-AS-2122-10000812-3_2  | 1619-024        | FY-2122              | December               | 2021              | 7525.00                   |
    | 1619-AS-2122-10000872-3_2  | 1619-021        | FY-2122              | September              | 2021              | 7175.00                   |




    # Consume stub data
 
    # Change the date 
    Given the override date is '09/01/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA3                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA3 = [CofG_LA3]' is written to the Output window
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2    | 3_2            | AS-2122 | 1619                        | 28000.00    | [CofG_LA3]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0       | 3_0            | AS-2122 | 1619                        | 12500.00    | [CofG_LA3]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Withdrawn         | Withdrawn                         |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | [ContractNo] | 1               | 0                  | Yes            |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 40500.00        |





    # Part 6: NFA > Published to Provider

    # Change the date 
    Given the override date is '12/01/2022'

    # Issue a non-financial amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017806 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017806 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017806 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017806 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider                     | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017806 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017806 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 7: Release RG with v3 FAs > queue

    # Change the date 
    Given the override date is '18/01/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA3]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA3 = [CofG_LA3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 40500.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017806' for FundingType 'EDSK' and period '2122'

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2    | 3_2            | AS-2122 | 1619                        | 28000.00    | [CofG_LA3]      | InRelease         | Queued                            |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0       | 3_0            | AS-2122 | 1619                        | 12500.00    | [CofG_LA3]      | InRelease         | Queued                            |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2    | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 28000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      | 18/01/2022 | [ContractNo]        |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0       | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 12500.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      | 18/01/2022 | [ContractNo]        |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 20000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 10000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 14765.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 5373.00     | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |




   
    # Part 8: Approve contract v2. Auto-unqueue v3 FAs > contract v3

    # Change the date 
    Given the override date is '22/01/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017806 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017806 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017806 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017806 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2    | 3_2            | AS-2122 | 1619                        | 28000.00    | [CofG_LA3]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0       | 3_0            | AS-2122 | 1619                        | 12500.00    | [CofG_LA3]      | ?                 | ?                                 |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | AS-2122 | 1619                        | 20000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | AS-2122 | 1619                        | 10000.00    | [CofG_LA2]      | ContractApproved  | ContractApproved                  |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017806 | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-3_2    | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 28000.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-3_0       | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 12500.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-2_2    | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 20000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-2_0       | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 10000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017806-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 14765.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017806 | Gawlish County Council  | 1619-AS-2122-Contract-LocalAuthority-10017806-1_0       | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 5373.00     | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |


    # Tidy Up
    Given the override date is reset

  