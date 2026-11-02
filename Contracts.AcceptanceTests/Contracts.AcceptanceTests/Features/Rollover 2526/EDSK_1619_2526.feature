


Feature: EDSK2526_1619ED

@AcceptanceTest @Complete
@CFS
Scenario: S062 Import, release and approve a UIFSM funding allocation for 25/26. CofG_HEI. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018062'
    And   there is no Funding Allocation data in CRM for UKPRN '10018062'
    And   there is no Contract, Task or Workflow data for UKPRN '10018062'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018062'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018062'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018062' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018062' 
    And   there is no caseload advisor for UKPRN '10018062' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018062 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018062' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018062 Co Ltd' with UKPRN '10018062' and OrgId 'ORG0018062' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018062 | 118062 | 10018062 Co Ltd | 0              | Active                | Yes           | AA118062      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018062 |





    # Populate the stub with UIFSM (Higher education institutions) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018062 | UIFSM-AY-2526-Contract-Provider-10018062-3_7          | 3_7            | UIFSM                       | AY-2526            | 40507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2526-10018062-3_7 | 3_7                    | UIFSM-AY-2526-Contract-Provider-10018062-3_7          | 10018062      | Universities                       | Higher education institutions    | 40507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | 28311.00         | Payment         |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-002       | 12196.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | August                 | 2025              | 4572.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | November               | 2025              | 4888.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | January                | 2026              | 2879.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | February               | 2026              | 4904.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | April                  | 2026              | 5769.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-001       | FY-2526              | July                   | 2026              | 5299.00                   |
    #                                                   
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-002       | FY-2526              | August                 | 2025              | 2735.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-002       | FY-2526              | February               | 2026              | 5684.00                   |
    | UIFSM-AY-2526-10018062-3_7 | UIFSM-002       | FY-2526              | May                    | 2026              | 3777.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018062 | 10018062 Co Ltd  | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2526     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_HEI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018062 | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | AY-2526 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 40507.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018062' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018062' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018062 | 10018062 Co Ltd  | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2526     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018062 | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | AY-2526 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018062 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018062 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018062 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018062 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018062 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018062 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    #  Check the contents of the Appendices
#    And   the file named '10018062_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018062 Co Ltd UKPRN: 10018062
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
#    Total Funding for this contract: £40,507
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (HEI)
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018062 Co Ltd
#    Funding for 16 to 19 Education
#    ACCEPTANCE BY THE PROVIDER
#    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
#    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
#    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
#    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
#    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018062 Co Ltd THE SECRETARY OF STATE FOR
#    102 Handside Lane EDUCATION
#    Welwyn Garden City DEPARTMENT FOR EDUCATION
#    AL8 6SY LONDON
#    SW1P 3BT
#    Company No: AA118062
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 2
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 59
#
#
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 - July 2024 - Page 1
#   
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#    
#
#    SCHEDULE 3: PAYMENT
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018062 Co Ltd UKPRN: 10018062
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
#    Payment)
#    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
#    Payment)
#    Total Funding £40,507 £7,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299
#    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#  
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018062_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018062_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018062'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018062 - 10018062 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018062 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018062_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018062 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018062 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018062 | 10018062 Co Ltd  | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2526     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018062 | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | 3_7            | AY-2526 | UIFSM                       | 40507.00    | [CofG_HEI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2526-Contract-Provider-10018062-3_7            | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018062 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    | 10018062 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: S063 Import, release and approve an NMSS funding allocation for 25/26 with all seven deliverables. CofG_NMSS. Provider Subtype = 'Non-maintained special school'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018063'
    And   there is no Funding Allocation data in CRM for UKPRN '10018063'
    And   there is no Contract, Task or Workflow data for UKPRN '10018063'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018063'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018063'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018063' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (NMSS)    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018063' 
    And   there is no caseload advisor for UKPRN '10018063' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018063 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018063' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018063 Co Ltd' with UKPRN '10018063' and OrgId 'ORG0018063' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018063 | 118063 | 10018063 Co Ltd | 0              | Active                | Yes           | AA018063      | ?             | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018063 |







    # Populate the stub with NMSS (Non-maintained special school) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018063 | NMSS-AY-2526-Contract-Provider-10018063-4_1           | 4_1            | NMSS                        | AY-2526            | 46449.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NMSS-AY-2526-10018063-4_1  | 4_1                    | NMSS-AY-2526-Contract-Provider-10018063-4_1           | 10018063      | Special schools                    | Non-maintained special school    | 46449.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2526-10018063-4_1  | NMSS-001        | 15198.00         | Payment         |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | 19843.00         | Payment         |
    | NMSS-AY-2526-10018063-4_1  | NMSS-003        | 2920.00          | Payment         |
    | NMSS-AY-2526-10018063-4_1  | NMSS-012        | 8488.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2526-10018063-4_1  | NMSS-001        | FY-2526              | September              | 2025              | 4581.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-001        | FY-2526              | January                | 2026              | 2060.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-001        | FY-2526              | February               | 2026              | 2684.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-001        | FY-2526              | May                    | 2026              | 5873.00                   |
    #
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | August                 | 2025              | 2112.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | November               | 2025              | 2668.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | January                | 2026              | 3940.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | March                  | 2026              | 2000.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | April                  | 2026              | 5942.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-002        | FY-2526              | June                   | 2026              | 3181.00                   |
    #
    | NMSS-AY-2526-10018063-4_1  | NMSS-003        | FY-2526              | February               | 2025              | 2920.00                   |
    #
    | NMSS-AY-2526-10018063-4_1  | NMSS-012        | FY-2526              | November               | 2025              | 2069.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-012        | FY-2526              | December               | 2025              | 2726.00                   |
    | NMSS-AY-2526-10018063-4_1  | NMSS-012        | FY-2526              | July                   | 2026              | 3693.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018063 | 10018063 Co Ltd  | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2526     | Scheduling        | Awaiting Release  | 46449.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2526-Contract-Provider-10018063-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 46449.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018063 | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | AY-2526 | NMSS                        | 46449.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_NMSS]       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 46449.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018063' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018063' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018063 | 10018063 Co Ltd  | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2526     | Released          | Released          | 46449.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2526-Contract-Provider-10018063-4_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2526-Contract-Provider-10018063-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018063 | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | AY-2526 | NMSS                        | 46449.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2526-Contract-Provider-10018063-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018063 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018063 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018063 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 46449.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018063 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018063 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018063 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018063 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 46449.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                                   | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 39              | 15198.00  | 0.00     | 4581.00  | 0.00     | 0.00     | 0.00     | 2060.00  | 2684.00  | 0.00     | 0.00     | 5873.00  | 0.00     | 0.00     | NMF Pre-16 Funding (NMSS)                                                         |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 15              | 19843.00  | 2112.00  | 0.00     | 0.00     | 2668.00  | 0.00     | 3940.00  | 0.00     | 2000.00  | 5942.00  | 0.00     | 3181.00  | 0.00     | SSF High Needs Element 2 (NMSS)                                                   |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 13              | 2920.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2920.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                                                 |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 200             | 14248.00  | 0.00     | 5388.00  | 0.00     | 0.00     | 2524.00  | 0.00     | 0.00     | 3112.00  | 0.00     | 0.00     | 0.00     | 3224.00  | Recovery Premium (NMSS)                                                           |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 201             | 8488.00   | 0.00     | 0.00     | 0.00     | 2069.00  | 2726.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3693.00  | Tutoring Grant (NMSS)                                                             |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 936             | 13407.00  | 0.00     | 5498.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3522.00  | 0.00     | 0.00     | 0.00     | 4387.00  | 0.00     | Teachers' Pay Additional Grant (NMSS)                                             |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 937             | 17031.00  | 0.00     | 0.00     | 3621.00  | 5202.00  | 0.00     | 0.00     | 4459.00  | 0.00     | 0.00     | 3749.00  | 0.00     | 0.00     | HTPP High Needs Funding (NMSS)                                                    |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#    # Check the deliverable count in CRM
#    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#    # check the contents of the appendices
    #Then the file named '10001013_[contractno]_v1.pdf' in sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#     And   the file named '10018063_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#   """
#   SUMMARY OF FUNDING 2024/25
#   Organisation Name: 10018063 Co Ltd UKPRN: 10018063
#   Master Contract Number: [MasterContractNo]
#   Allocation
#   Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#   16 to 19 Education [AllocRef_16ED] £61,086 £30,049 £91,135
#   Total Funding for this contract: £91,135
#   Summary of Funding – Page 1
#
#   Agreement Type Non-Maintained Special Schools (NMSS)
#   Funding Period 1 August 2024 to 31 July 2025
#   Between the Secretary of State for Education
#   And 10018063 Co Ltd
#   Funding for 16 to 19 Education
#   Master Agreement Number [MasterContractNo]
#   ACCEPTANCE BY THE NMSS
#   SIGNED FOR AND ON BEHALF OF
#   THE SECRETARY OF STATE FOR EDUCATION
#   by David Withey, Chief Executive of the Education and Skills Funding Agency    
#   EDSK Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 1
#   This Agreement is made on the date the Agreement is digitally signed by the
#   NMSS on the Manage Your Education & Skills Funding Service between:
#   10018063 Co Ltd THE SECRETARY OF STATE FOR
#   EDSK Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 2
#   EDSK Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 50
#   
#   SCHEDULE 1: DEFINITIONS
#   Schedule 1
#   Version 1 – July 2024 – Page 1
#   Schedule 1
#   Version 1 – July 2024 – Page 11
#
#   
#   SCHEDULE 2: SPECIFICATION & MONITORING
#   Schedule 2: Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 1
#   Schedule 2: Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 9
#
#   SCHEDULE 3: PAYMENT
#   Schedule 3: Non-Maintained Special Schools (NMSS)
#   Version 1 – July 2024 – Page 1
#   
#   16 TO 19 EDUCATION
#   Funding Agreement – 16 to 19 Education
#   Provider: 10018063 Co Ltd UKPRN: 10018063
#   Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#   Contract Ref: [AllocRef_16ED]
#   Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#   SSF Bursary Funds £2,920 £0 £0 £0 £0 £0 £0 £2,920 £0 £0 £0 £0 £0
#   SSF High Needs Element 2 £19,843 £2,112 £0 £0 £2,668 £0 £3,940 £0 £2,000 £5,942 £0 £3,181 £0
#   NMF Pre-16 Funding £15,198 £0 £4,581 £0 £0 £0 £2,060 £2,684 £0 £0 £5,873 £0 £0
#   Recovery Premium £13,407 £0 £5,498 £0 £0 £0 £0 £3,522 £0 £0 £0 £4,387 £0
#   Tutoring Grant £17,031 £0 £0 £3,621 £5,202 £0 £0 £4,459 £0 £0 £3,749 £0 £0
#   Teachers' Pay Additional Grant £14,248 £0 £5,388 £0 £0 £2,524 £0 £0 £3,112 £0 £0 £0 £3,224
#   HTPP High Needs Funding £8,488 £0 £0 £0 £2,069 £2,726 £0 £0 £0 £0 £0 £0 £3,693
#   Total Funding £91,135 £2,112 £15,467 £3,621 £9,939 £5,250 £6,000 £13,585 £5,112 £5,942 £9,622 £7,568 £6,917
#   16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#   
#   SCHEDULE 4: SECURITY & DEPARTMENT POLICIES
#   Schedule 4
#   Version 1 – July 2024 – Page 1
#
#   SCHEDULE 5: EXIT ARRANGEMENTS
#   Schedule 5
#   Version 1 – July 2024 – Page 1
#   
#   """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018063_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018063_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018063'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018063 - 10018063 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018063 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018063 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018063 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018063_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018063 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018063 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018063 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018063 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018063 | 10018063 Co Ltd  | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2526     | Contract Approved | Contract Approved | 46449.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018063 | NMSS-AY-2526-Contract-Provider-10018063-4_1             | 4_1            | AY-2526 | NMSS                        | 46449.00    | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2526-Contract-Provider-10018063-4_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '7' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15198.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                                                   | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 19843.00     | 0             | 0        | SSF High Needs Element 2 (NMSS)                                             | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 2920.00      | 0             | 0        | SSF Bursary Funds                                                           | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 14248.00     | 0             | 0        | Recovery Premium (NMSS)                                                     | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 8488.00      | 0             | 0        | Tutoring Grant (NMSS)                                                       | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 936             | 0                     | 13407.00     | 0             | 0        | Teachers' Pay Additional Grant (NMSS)                                       | ?                           |
#    | 10018063 | [ContractNo]   | 1               | [AllocRef_16ED]  | 937             | 0                     | 17031.00     | 0             | 0        | HTPP High Needs Funding (NMSS)                                              | ?                           |
#
#

    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: S064 Import, release and approve a PSG funding allocation for 25/26 with deliverable 43. CofG_SPI. Provider Subtype = 'Special post 16 institution'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018064'
    And   there is no Funding Allocation data in CRM for UKPRN '10018064'
    And   there is no Contract, Task or Workflow data for UKPRN '10018064'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018064'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018064'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018064' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (SPI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018064' 
    And   there is no caseload advisor for UKPRN '10018064' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018064 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018064' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018064 Co Ltd' with UKPRN '10018064' and OrgId 'ORG0018064' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018064 | 118064 | 10018064 Co Ltd | 0              | Locked Restructure    | Yes           | AA018064      | ?             | 5 Spurway Parade       | Woodford Avenue        | ?                      | ?                      | Ilford                 | Essex                  | IG2 6UU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018064 |







    # Populate the stub with PSG (Special post 16 institution) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018064 | PSG-AY-2526-Contract-Provider-10018064-3_2            | 3_2            | PSG                         | AY-2526            | 13205.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PSG-AY-2526-10018064-3_2   | 3_2                    | PSG-AY-2526-Contract-Provider-10018064-3_2            | 10018064      | Other types                        | Special post 16 institution      | 13205.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2526-10018064-3_2   | PSG-001         | 12205.00         | Payment         |
    | PSG-AY-2526-10018064-3_2   | PSG-002         | 1000.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2526-10018064-3_2   | PSG-001 | FY-2526              | November               | 2025              | 3367.00                   |
    | PSG-AY-2526-10018064-3_2   | PSG-001 | FY-2526              | March                  | 2026              | 8838.00                   |
    | PSG-AY-2526-10018064-3_2   | PSG-002 | FY-2526              | May                    | 2026              | 1000.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018064 | 10018064 Co Ltd  | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2526     | Scheduling        | Awaiting Release  | 13205.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_SPI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2526-Contract-Provider-10018064-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13205.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018064 | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | AY-2526 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_SPI]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 13205.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018064' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018064' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018064 | 10018064 Co Ltd  | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2526     | Released          | Released          | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2526-Contract-Provider-10018064-3_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PSG-AY-2526-Contract-Provider-10018064-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018064 | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | AY-2526 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2526-Contract-Provider-10018064-3_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018064 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018064 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018064 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 13205.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018064 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018064 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018064 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018064 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 13205.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 43              | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Initial Payment) (NMSS)                 |                          |
#
    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    #Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
#    And   the file named '10018064_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018064 Co Ltd UKPRN: 10018064
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £7,632 £5,573 £13,205
#    Total Funding for this contract: £13,205
#    Summary of Funding – Page 1
#    
#    Agreement Type Specialist Post-16 Institution
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018064 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement
##    [MasterContractNo]
#    Number
#    ACCEPTANCE BY THE PROVIDER
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Specialist Post-16 Institution
#    Version 1 – July 2024 – Page 1    
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#            
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 1 – July 2024 – Page 1
#    Schedule 1
#    Version 1 – July 2024 – Page 13
#
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#
#    
#    SCHEDULE 3: PAYMENT
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018064 Co Ltd UKPRN: 10018064
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Primary PE and Sport Premium (1) £13,205 £0 £0 £0 £3,367 £0 £0 £0 £4,265 £0 £5,573 £0 £0
#    Total Funding £13,205 £0 £0 £0 £3,367 £0 £0 £0 £4,265 £0 £5,573 £0 £0
#    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 1 – July 2024 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 1 – July 2024 – Page 1
#
#    SCHEDULE 6: EXIT ARRANGEMENTS
#    Schedule 6
#    Version 1 – July 2024 – Page 1
#
#    SCHEDULE 7: SUBCONTRACTING
#    Schedule 7
#    Version 1 – July 2024 – Page 1
#
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018064_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018064_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018064'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018064 - 10018064 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018064 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018064 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018064 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


    




    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

   ## Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
   #And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018064_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018064 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018064 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |




    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018064 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018064 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018064 | 10018064 Co Ltd  | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2526     | Contract Approved | Contract Approved | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018064 | PSG-AY-2526-Contract-Provider-10018064-3_2              | 3_2            | AY-2526 | PSG                         | 13205.00    | [CofG_SPI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2526-Contract-Provider-10018064-3_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018064 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 12205.00     | 0             | 0        | Primary PE and Sport Premium (Initial Payment) (NMSS)                 | ?                           |
    | 10018064 | [ContractNo]   | 1               | [AllocRef_16ED]  | 938             | 0                     | 1000.00      | 0             | 0        | Primary PE and Sport Premium (Final Payment) (NMSS)                   | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    
@AcceptanceTest @Complete
@CFS
Scenario: S065 Import, release and approve a PP funding allocation for 25/26 with deliverable 140. AA_College. Provider Subtype = 'Further education'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018065'
    And   there is no Funding Allocation data in CRM for UKPRN '10018065'
    And   there is no Contract, Task or Workflow data for UKPRN '10018065'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018065'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018065'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018065' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Accountability Agreement (College)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018065' 
    And   there is no caseload advisor for UKPRN '10018065' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018065 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018065' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018065 Co Ltd' with UKPRN '10018065' and OrgId 'ORG0018065' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018065 | 118065 | 10018065 Co Ltd | 0              | Active                | Yes           | AA018065      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018065 |







    # Populate the stub with PP (Further education) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018065 | PP-FY-2526-Contract-Provider-10018065-4_3             | 4_3            | PP                          | FY-2526            | 7540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PP-FY-2526-10018065-4_3    | 4_3                    | PP-FY-2526-Contract-Provider-10018065-4_3             | 10018065      | Colleges                           | Further education                | 7540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PP-FY-2526-10018065-4_3    | PP-001          | 7540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PP-FY-2526-10018065-4_3    | PP-001          | FY-2526              | November               | 2025              | 4673.00                   |
    | PP-FY-2526-10018065-4_3    | PP-001          | FY-2526              | April                  | 2026              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Accountability Agreement (College)      | AA_College                |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018065 | 10018065 Co Ltd  | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | Education & Skills Funding | AY2526  | Accountability Agreement (College)       | PP                          | 16-19ED2526     | Scheduling        | Awaiting Release  | 7540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2526-Contract-Provider-10018065-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 7540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018065 | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | FY-2526 | PP                          | 7540.00     | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 7540.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018065' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018065' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018065 | 10018065 Co Ltd  | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | Education & Skills Funding | AY2526  | Accountability Agreement (College)       | PP                          | 16-19ED2526     | Released          | Released          | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2526-Contract-Provider-10018065-4_3               | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PP-FY-2526-Contract-Provider-10018065-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018065 | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | FY-2526 | PP                          | 7540.00     | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PP-FY-2526-Contract-Provider-10018065-4_3               | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018065 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018065 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018065 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 7540.00       | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018065 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018065 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018065 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018065 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 7540.00         | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 7540.00   | 0.00     | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
#    And   the file named '10018065_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018065 Co Ltd UKPRN: 10018065
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £4,673 £2,867 £7,540
#    Total Funding for this contract: £7,540
#    Summary of Funding – Page 1
#    
#    Agreement Type Accountability Agreement (Colleges)
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018065 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement Number [MasterContractNo]
#    ACCEPTANCE BY THE COLLEGE
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    Accountability Agreement (Colleges)
#    Version 2 – July 2024 – Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    College on the Manage Your Education & Skills Funding Service between:
#    10018065 Co Ltd THE SECRETARY OF STATE 
#    4 Arden Court FOR EDUCATION
#    Arden Road DEPARTMENT FOR
#    Alcester EDUCATION
#    AND
#    Warwickshire 20 GREAT SMITH STREET
#    B49 6HN LONDON
#    SW1P 3BT
#    Company No: AA018065
#    Hereinafter called Hereinafter called
#    the College the Department
#    Accountability Agreement (Colleges)
#    Version 2 – July 2024 – Page 2
#    
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 – July 2024 – Page 1
#    
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#
#    SCHEDULE 3: PAYMENT
#    Schedule 3: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#
#    
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018065 Co Ltd UKPRN: 10018065
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Pupil Premium £7,540 £0 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
#    Total Funding £7,540 £0 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
#    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 6: EXIT ARRANGEMENTS
#    Schedule 6
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 7: COLLEGE GOVERNANCE
#    Schedule 7
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 8: SUBCONTRACTING
#    Schedule 8
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 9: NATIONAL SKILLS PRIORITIES
#    Schedule 9
#    Version 2 – July 2024 – Page 1
#
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018065_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018065_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018065'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018065 - 10018065 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018065 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018065 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018065 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018065_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018065 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018065 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018065 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018065 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    #And   the following Funding Allocations data is present in CRM
    #| UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    #| 10018065 | 10018065 Co Ltd  | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | Education & Skills Funding | AY2526  | Accountability Agreement (College)  	    | PP                          | 16-19ED2526     | Contract Approved | Contract Approved | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018065 | PP-FY-2526-Contract-Provider-10018065-4_3               | 4_3            | FY-2526 | PP                          | 7540.00     | [AA_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2526-Contract-Provider-10018065-4_3               | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018065 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 7540.00      | 0             | 0        | Pupil Premium (NMSS)                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: S066 Import, release and approve a NFF funding allocation for 25/26 with deliverable 931. Contract for Services (ITP). Provider Subtype = 'Independent learning provider'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018066'
    And   there is no Funding Allocation data in CRM for UKPRN '10018066'
    And   there is no Contract, Task or Workflow data for UKPRN '10018066'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018066'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018066'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018066' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Contract for Services (ITP)			   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018066' 
    And   there is no caseload advisor for UKPRN '10018066' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018066 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018066' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018066 Co Ltd' with UKPRN '10018066' and OrgId 'ORG0018066' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018066 | 108066 | 10018066 Co Ltd | 0              | Active                | Yes           | AA008066      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018066 |







    # Populate the stub with NFF (Independent learning provider) data test

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018066 | NFF-AS-2526-Contract-Provider-10018066-1_0            | 1_0            | NFF                         | AS-2526            | 8540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NFF-AS-2526-10018066-1_0   | 1_0                    | NFF-AS-2526-Contract-Provider-10018066-1_0            | 10018066      | 16-19 provider                     | Independent learning provider    | 8540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2526-10018066-1_0   | NFF-001         | 8540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2526-10018066-1_0   | NFF-001         | FY-2526              | August	               | 2025              | 1000.00                   |
    | NFF-AS-2526-10018066-1_0   | NFF-001         | FY-2526              | November               | 2025              | 4673.00                   |
    | NFF-AS-2526-10018066-1_0   | NFF-001         | FY-2526              | April                  | 2026              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Contract for Services (ITP)			   | Cfs_ITP	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs_ITP = [Cfs_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018066 | 10018066 Co Ltd  | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | Education & Skills Funding | AY2526  | Contract for Services (ITP)			   | NFF                         | 16-19ED2526     | Scheduling        | Awaiting Release  | 8540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs_ITP]    	 | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2526-Contract-Provider-10018066-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018066 | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | AS-2526 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Cfs_ITP]		    |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs_ITP = [Cfs_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[Cfs_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 8540.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018066' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018066' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018066 | 10018066 Co Ltd  | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | Education & Skills Funding | AY2526  | Contract for Services (ITP)			   | NFF                         | 16-19ED2526     | Released          | Released          | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs_ITP]	   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2526-Contract-Provider-10018066-1_0              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2526-Contract-Provider-10018066-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018066 | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | AS-2526 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2526-Contract-Provider-10018066-1_0              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018066 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018066 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018066 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 8540.00       | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Contract for Services (ITP)   | ?         | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018066 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018066 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Contract for Services (ITP)   | ?         | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018066 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018066 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 8540.00         | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26  | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 931             | 8540.00   | 1000.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00    | 0.00     | Cadets Vocational Programme                                           |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
#    And   the file named '10018066_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018066 Co Ltd UKPRN: 10018066
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £5,673 £2,867 £8,540
#    Total Funding for this contract: £8,540
#    Summary of Funding – Page 1
#    
#    Agreement Type Contract for Services
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018066 Co Ltd
#    Funding for 16 to 19 Education
#    Master Contract Number [MasterContractNo]
#    ACCEPTANCE BY THE CONTRACTOR
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Contract for Services
#    Version 2 - July 2024 - Page 1
#    This Contract is made on the date the Contract is digitally signed by the
#    Contractor on the Manage Your Education & Skills Funding Service between:
#    10018066 Co Ltd THE SECRETARY OF STATE FOR
#    4 Arden Court EDUCATION
#    Arden Road DEPARTMENT FOR EDUCATION
#    Alcester 20 GREAT SMITH STREET
#    AND
#    Warwickshire LONDON
#    B49 6HN SW1P 3BT
#    Company No: AA008066
#    Hereinafter called Hereinafter called
#    the Contractor the Department
#    EDSK Contract for Services
#    Version 2 – July 2024 – Page 2
#    
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 – July 2024 – Page 1
#
#    
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#
#    
#    SCHEDULE 3: PAYMENT
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018066 Co Ltd UKPRN: 10018066
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Cadets Vocational Programme £8,540 £1,000 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
#    Total Funding £8,540 £1,000 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0    
#    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 4: CHANGE CONTROL PROCEDURE
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 5: CONTRACTOR’S RESPONSE/PROPOSALS
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 6: TUPE
#    Schedule 6
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 7: UK GDPR/DATA PROTECTION
#    Schedule 7
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 8: SECURITY & DEPARTMENT POLICIES
#    Schedule 8
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 9: EXIT ARRANGEMENTS
#    Schedule 9
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 10: SUBCONTRACTING
#    Schedule 10
#    Version 2 – July 2024 – Page 1
#
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018066_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018066_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018066'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018066 - 10018066 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018066 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018066 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018066 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018066_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018066 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018066 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018066 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018066 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018066 | 10018066 Co Ltd  | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | Education & Skills Funding | AY2526  | Contract for Services (ITP)			   | NFF                         | 16-19ED2526     | Contract Approved | Contract Approved | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs_ITP]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018066 | NFF-AS-2526-Contract-Provider-10018066-1_0              | 1_0            | AS-2526 | NFF                         | 8540.00     | [Cfs_ITP]		  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2526-Contract-Provider-10018066-1_0              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018066 | [ContractNo]   | 1               | [AllocRef_16ED]  | 931             | 0                     | 8540.00      | 0             | 0        | Cadets Vocational Programme                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: S067 Import, release and approve a 1416 funding allocation for 24/25 with deliverables 24, 25 and 111. Cofg(LA). Provider Subtype = '06SDC'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018067'
    And   there is no Funding Allocation data in CRM for UKPRN '10018067'
    And   there is no Contract, Task or Workflow data for UKPRN '10018067'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018067'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018067'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018067' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (LA)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018067' 
    And   there is no caseload advisor for UKPRN '10018067' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018067 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018067' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018067 Co Ltd' with UKPRN '10018067' and OrgId 'ORG0018067' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018067 | 108067 | 10018067 Co Ltd | 0              | Active                | Yes           | AA001017      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018067 |





    # Populate the stub with 1416 (Furth) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018067 | 1416-AY-2526-Contract-Provider-10018067-3_7           | 3_7            | 1416                        | AY-2526            | 50507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1416-AY-2526-10018067-3_7  | 3_7                    | 1416-AY-2526-Contract-Provider-10018067-3_7 	      | 10018067      | Local authority		               | Local authority				  | 50507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | 28311.00         | Payment         |
    | 1416-AY-2526-10018067-3_7  | 1416-002        | 12196.00         | Payment         |
    | 1416-AY-2526-10018067-3_7  | 1416-003        | 10000.00         | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | August                 | 2025              | 4572.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | November               | 2025              | 4888.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | January                | 2026              | 2879.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | February               | 2026              | 4904.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | April                  | 2026              | 5769.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-001        | FY-2526              | July                   | 2026              | 5299.00                   |
    #
    | 1416-AY-2526-10018067-3_7  | 1416-002        | FY-2526              | August                 | 2025              | 2735.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-002        | FY-2526              | February               | 2026              | 5684.00                   |
    | 1416-AY-2526-10018067-3_7  | 1416-002        | FY-2526              | May                    | 2026              | 3777.00                   |
    #
    | 1416-AY-2526-10018067-3_7  | 1416-003        | FY-2526              | August                 | 2025              | 10000.00                  |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (LA)      | CofG(LA)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018067 | 10018067 Co Ltd  | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2526     | Scheduling        | Awaiting Release  | 50507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2526-Contract-Provider-10018067-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG(LA)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018067 | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | AY-2526 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '06/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG(LA)]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG(LA)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 50507.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018067' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018067' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018067 | 10018067 Co Ltd  | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2526     | Released          | Released          | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2526-Contract-Provider-10018067-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1416-AY-2526-Contract-Provider-10018067-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018067 | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | AY-2526 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2526-Contract-Provider-10018067-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018067 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018067 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018067 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 50507.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018067 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018067 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018067 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018067 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 50507.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 24              | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | 14-16 Programme Funding    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 25              | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | 14-16 Pupil Premium        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 111             | 10000.00  | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00	  | 0.00     | 0.00     | 0.00	   | 0.00     | 0.00     | 14-16 Service Child Premium|                          |


    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

##    # Check the contents of the Appendices
#    And   the file named '10001017_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018067 Co Ltd UKPRN: 10018067
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £35,662 £14,845 £50,507
#    Total Funding for this contract: £50,507
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (Local Authorities)
#    st st
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018067 Co Ltd
#    Funding for 16 to 19 Education
#    ACCEPTANCE BY THE PROVIDER
#    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
#    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
#    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
#    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
#    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2024 - Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018067 Co Ltd THE SECRETARY OF STATE FOR
#    102 Handside Lane EDUCATION
#    Welwyn Garden City DEPARTMENT FOR EDUCATION
#    Hertfordshire 20 GREAT SMITH STREET
#    AND
#    AL8 6SY LONDON
#    SW1P 3BT
#    Company No: AA001017
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2024 - Page 2
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2024 - Page 60
#
#
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 - July 2024 - Page 1
#    Schedule 1
#    Version 2 - July 2024 - Page 15
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#
#    SCHEDULE 3: PAYMENT
#    Schedule 3: 16 to 19 Education
#    Version 1 – July 2024 – Page 1   
#
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018067 Co Ltd UKPRN: 10018067
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    14-16 Programme Funding £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
#    14-16 Pupil Premium £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
#    14-16 Service Child Premium £10,000 £10,000 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0
#    Total Funding £50,507 £17,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299    
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#   
#    """
#
    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018067_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018067_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018067'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018067 - 10018067 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018067 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018067 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018067 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018067_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018067 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018067 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018067 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018067 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018067 | 10018067 Co Ltd  | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2526     | Contract Approved | Contract Approved | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018067 | 1416-AY-2526-Contract-Provider-10018067-3_7             | 3_7            | AY-2526 | 1416                        | 50507.00    | [CofG(LA)]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2526-Contract-Provider-10018067-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '2' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10018067 | [ContractNo]   | 1               | [AllocRef_16ED]  | 24              | 0                     | 28311.00     | 0             | 0        | 14-16 Programme Funding    | ?                           |
#    | 10018067 | [ContractNo]   | 1               | [AllocRef_16ED]  | 25              | 0                     | 12196.00     | 0             | 0        | 14-16 Pupil Premium	      | ?                           |
#    | 10018067 | [ContractNo]   | 1               | [AllocRef_16ED]  | 111             | 0                     | 10000.00     | 0             | 0        | 14-16 Service Child Premium| ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



@AcceptanceTest @Withdrawn20251024
@CFS
Scenario: S068 Import, release and approve a 1619 new funding allocation for 25/26. CofG_HEI. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018068'
    And   there is no Funding Allocation data in CRM for UKPRN '10018068'
    And   there is no Contract, Task or Workflow data for UKPRN '10018068'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018068'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018068'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018068' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018068' 
    And   there is no caseload advisor for UKPRN '10018068' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018068 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018068' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018068 Co Ltd' with UKPRN '10018068' and OrgId 'ORG0018068' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018068 | 118068 | 10018068 Co Ltd | 0              | Active                | Yes           | AA118068      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018068 |





    # Populate the stub with 1619 (Higher education institutions) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7           | 3_7            | 1619                        | AS-2526            | 40507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1619-AS-2526-10018068-3_7  | 3_7                    | 1619-AS-2526-Contract-Provider-10018068-3_7           | 10018068      | Universities                       | Higher education institutions    | 40507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | 28311.00         | Payment         |
    | 1619-AS-2526-10018068-3_7 | 1619-002       | 12196.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | August                 | 2025              | 4572.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | November               | 2025              | 4888.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | January                | 2026              | 2879.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | February               | 2026              | 4904.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | April                  | 2026              | 5769.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-001       | FY-2526              | July                   | 2026              | 5299.00                   |
    #                                                   
    | 1619-AS-2526-10018068-3_7 | 1619-002       | FY-2526              | August                 | 2025              | 2735.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-002       | FY-2526              | February               | 2026              | 5684.00                   |
    | 1619-AS-2526-10018068-3_7 | 1619-002       | FY-2526              | May                    | 2026              | 3777.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7            | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | 1619                       | 16-19ED2526     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_HEI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7            | 3_7            | AY-2526 | 1619                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 40507.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018068' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018068' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7            | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | 1619                       | 16-19ED2526     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7            | 3_7            | AY-2526 | 1619                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018068 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018068 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018068 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018068 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018068 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018068 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018068 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    #  Check the contents of the Appendices
#    And   the file named '10018068_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2024/25
#    Organisation Name: 10018068 Co Ltd UKPRN: 10018068
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
#    Total Funding for this contract: £40,507
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (HEI)
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018068 Co Ltd
#    Funding for 16 to 19 Education
#    ACCEPTANCE BY THE PROVIDER
#    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
#    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
#    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
#    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
#    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018068 Co Ltd THE SECRETARY OF STATE FOR
#    102 Handside Lane EDUCATION
#    Welwyn Garden City DEPARTMENT FOR EDUCATION
#    AL8 6SY LONDON
#    SW1P 3BT
#    Company No: AA118068
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 2
#    EDSK Conditions of Funding (Grant) (HEI)
#    Version 2 - July 2024 - Page 59
#
#
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 - July 2024 - Page 1
#   
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    Schedule 2: 16 to 19 Education
#    Version 1 – July 2024 – Page 1
#    
#
#    SCHEDULE 3: PAYMENT
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018068 Co Ltd UKPRN: 10018068
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
#    Payment)
#    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
#    Payment)
#    Total Funding £40,507 £7,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299
#    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#  
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018068_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018068_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018068'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018068 - 10018068 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018068 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018068 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018068 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018068_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018068 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018068 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018068 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018068 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (HEI)      | 1619                       | 16-19ED2526     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | AY-2526 | 1619                       | 40507.00    | [CofG_HEI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018068 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    | 10018068 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
