Feature: CreateEDSKContracts 2425

@AcceptanceTest @Complete
@CFS
Scenario: AK012 Import, release and approve a UIFSM funding allocation for 24/25. CofG_HEI. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001012'
    And   there is no Funding Allocation data in CRM for UKPRN '10001012'
    And   there is no Contract, Task or Workflow data for UKPRN '10001012'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001012'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001012'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001012' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001012' 
    And   there is no caseload advisor for UKPRN '10001012' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001012 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001012' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001012 Co Ltd' with UKPRN '10001012' and OrgId 'ORG0011012' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001012 | 101012 | 10001012 Co Ltd | 0              | Active                | Yes           | AA011012      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001012 |





    # Populate the stub with UIFSM (Higher education institutions) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001012 | UIFSM-AY-2425-Contract-Provider-10001012-3_7          | 3_7            | UIFSM                       | AY-2425            | 40507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2425-10001012-3_7 | 3_7                    | UIFSM-AY-2425-Contract-Provider-10001012-3_7          | 10001012      | Universities                       | Higher education institutions    | 40507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | 28311.00         | Payment         |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-002       | 12196.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | August                 | 2024              | 4572.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | November               | 2024              | 4888.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | January                | 2025              | 2879.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | February               | 2025              | 4904.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | April                  | 2025              | 5769.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-001       | FY-2425              | July                   | 2025              | 5299.00                   |
    #                                                   
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-002       | FY-2425              | August                 | 2024              | 2735.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-002       | FY-2425              | February               | 2025              | 5684.00                   |
    | UIFSM-AY-2425-10001012-3_7 | UIFSM-002       | FY-2425              | May                    | 2025              | 3777.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001012 | 10001012 Co Ltd  | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2425     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_HEI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001012 | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | AY-2425 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10001012' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001012' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001012 | 10001012 Co Ltd  | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2425     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001012 | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | AY-2425 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001012 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001012 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001012 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001012 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001012 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001012 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001012 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    #  Check the contents of the Appendices
    And   the file named '10001012_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10001012 Co Ltd UKPRN: 10001012
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
    Total Funding for this contract: £40,507
    Summary of Funding – Page 1
    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10001012 Co Ltd
    Funding for 16 to 19 Education
    ACCEPTANCE BY THE PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Conditions of Funding (Grant) (HEI)
    Version 2 - July 2024 - Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10001012 Co Ltd THE SECRETARY OF STATE FOR
    102 Handside Lane EDUCATION
    Welwyn Garden City DEPARTMENT FOR EDUCATION
    AL8 6SY LONDON
    SW1P 3BT
    Company No: AA011012
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Conditions of Funding (Grant) (HEI)
    Version 2 - July 2024 - Page 2
    EDSK Conditions of Funding (Grant) (HEI)
    Version 2 - July 2024 - Page 59


    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 - July 2024 - Page 1
   
    SCHEDULE 2: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1
    

    SCHEDULE 3: PAYMENT
    Funding Agreement – 16 to 19 Education
    Provider: 10001012 Co Ltd UKPRN: 10001012
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
    Payment)
    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
    Payment)
    Total Funding £40,507 £7,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 2 – July 2024 – Page 1

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 2 – July 2024 – Page 1
  
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10001012_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001012_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001012'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001012 - 10001012 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001012 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001012 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001012 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001012_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001012 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001012 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001012 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001012 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001012 | 10001012 Co Ltd  | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2425     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001012 | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | 3_7            | AY-2425 | UIFSM                       | 40507.00    | [CofG_HEI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2425-Contract-Provider-10001012-3_7            | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10001012 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    | 10001012 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



@AcceptanceTest @Complete
@CFS
Scenario: AK013 Import, release and approve an NMSS funding allocation for 24/25 with all seven deliverables. CofG_NMSS. Provider Subtype = 'Non-maintained special school'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001013'
    And   there is no Funding Allocation data in CRM for UKPRN '10001013'
    And   there is no Contract, Task or Workflow data for UKPRN '10001013'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001013'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001013'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001013' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (NMSS)    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001013' 
    And   there is no caseload advisor for UKPRN '10001013' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001013 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001013' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001013 Co Ltd' with UKPRN '10001013' and OrgId 'ORG0001013' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001013 | 101013 | 10001013 Co Ltd | 0              | Active                | Yes           | AA001013      | ?             | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001013 |







    # Populate the stub with NMSS (Non-maintained special school) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001013 | NMSS-AY-2425-Contract-Provider-10001013-4_1           | 4_1            | NMSS                        | AY-2425            | 91135.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NMSS-AY-2425-10001013-4_1  | 4_1                    | NMSS-AY-2425-Contract-Provider-10001013-4_1           | 10001013      | Special schools                    | Non-maintained special school    | 91135.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2425-10001013-4_1  | NMSS-001        | 15198.00         | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | 19843.00         | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-003        | 2920.00          | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-011        | 14248.00         | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-012        | 8488.00          | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-009        | 13407.00         | Payment         |
    | NMSS-AY-2425-10001013-4_1  | NMSS-010        | 17031.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2425-10001013-4_1  | NMSS-001        | FY-2425              | September              | 2024              | 4581.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-001        | FY-2425              | January                | 2025              | 2060.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-001        | FY-2425              | February               | 2025              | 2684.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-001        | FY-2425              | May                    | 2025              | 5873.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | August                 | 2024              | 2112.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | November               | 2024              | 2668.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | January                | 2025              | 3940.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | March                  | 2025              | 2000.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | April                  | 2025              | 5942.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-002        | FY-2425              | June                   | 2025              | 3181.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-003        | FY-2425              | February               | 2025              | 2920.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-011        | FY-2425              | September              | 2024              | 5388.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-011        | FY-2425              | December               | 2024              | 2524.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-011        | FY-2425              | March                  | 2025              | 3112.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-011        | FY-2425              | July                   | 2025              | 3224.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-012        | FY-2425              | November               | 2024              | 2069.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-012        | FY-2425              | December               | 2024              | 2726.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-012        | FY-2425              | July                   | 2025              | 3693.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-009        | FY-2425              | September              | 2024              | 5498.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-009        | FY-2425              | February               | 2025              | 3522.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-009        | FY-2425              | June                   | 2025              | 4387.00                   |
    #
    | NMSS-AY-2425-10001013-4_1  | NMSS-010        | FY-2425              | October                | 2024              | 3621.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-010        | FY-2425              | November               | 2024              | 5202.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-010        | FY-2425              | February               | 2025              | 4459.00                   |
    | NMSS-AY-2425-10001013-4_1  | NMSS-010        | FY-2425              | May                    | 2025              | 3749.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001013 | 10001013 Co Ltd  | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 91135.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2425-Contract-Provider-10001013-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 91135.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001013 | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | AY-2425 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    | Released          | 1               | 91135.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10001013' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001013' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001013 | 10001013 Co Ltd  | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2425     | Released          | Released          | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2425-Contract-Provider-10001013-4_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2425-Contract-Provider-10001013-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001013 | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | AY-2425 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2425-Contract-Provider-10001013-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001013 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001013 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 91135.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001013 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001013 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001013 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001013 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 91135.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

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
    #Then the file named '10001013_[contractno]_v1.pdf' in sharepoint location 'edsk-2425-input-appendices' contains the following lines in order
     And   the file named '10001013_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
   """
   SUMMARY OF FUNDING 2024/25
   Organisation Name: 10001013 Co Ltd UKPRN: 10001013
   Master Contract Number: [MasterContractNo]
   Allocation
   Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
   16 to 19 Education [AllocRef_16ED] £61,086 £30,049 £91,135
   Total Funding for this contract: £91,135
   Summary of Funding – Page 1

   Agreement Type Non-Maintained Special Schools (NMSS)
   Funding Period 1 August 2024 to 31 July 2025
   Between the Secretary of State for Education
   And 10001013 Co Ltd
   Funding for 16 to 19 Education
   Master Agreement Number [MasterContractNo]
   ACCEPTANCE BY THE NMSS
   SIGNED FOR AND ON BEHALF OF
   THE SECRETARY OF STATE FOR EDUCATION
   by David Withey, Chief Executive of the Education and Skills Funding Agency    
   EDSK Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 1
   This Agreement is made on the date the Agreement is digitally signed by the
   NMSS on the Manage Your Education & Skills Funding Service between:
   10001013 Co Ltd THE SECRETARY OF STATE FOR
   EDSK Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 2
   EDSK Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 50
   
   SCHEDULE 1: DEFINITIONS
   Schedule 1
   Version 1 – July 2024 – Page 1
   Schedule 1
   Version 1 – July 2024 – Page 11

   
   SCHEDULE 2: SPECIFICATION & MONITORING
   Schedule 2: Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 1
   Schedule 2: Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 9

   SCHEDULE 3: PAYMENT
   Schedule 3: Non-Maintained Special Schools (NMSS)
   Version 1 – July 2024 – Page 1
   
   16 TO 19 EDUCATION
   Funding Agreement – 16 to 19 Education
   Provider: 10001013 Co Ltd UKPRN: 10001013
   Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
   Contract Ref: [AllocRef_16ED]
   Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
   SSF Bursary Funds £2,920 £0 £0 £0 £0 £0 £0 £2,920 £0 £0 £0 £0 £0
   SSF High Needs Element 2 £19,843 £2,112 £0 £0 £2,668 £0 £3,940 £0 £2,000 £5,942 £0 £3,181 £0
   NMF Pre-16 Funding £15,198 £0 £4,581 £0 £0 £0 £2,060 £2,684 £0 £0 £5,873 £0 £0
   Recovery Premium £13,407 £0 £5,498 £0 £0 £0 £0 £3,522 £0 £0 £0 £4,387 £0
   Tutoring Grant £17,031 £0 £0 £3,621 £5,202 £0 £0 £4,459 £0 £0 £3,749 £0 £0
   Teachers' Pay Additional Grant £14,248 £0 £5,388 £0 £0 £2,524 £0 £0 £3,112 £0 £0 £0 £3,224
   HTPP High Needs Funding £8,488 £0 £0 £0 £2,069 £2,726 £0 £0 £0 £0 £0 £0 £3,693
   Total Funding £91,135 £2,112 £15,467 £3,621 £9,939 £5,250 £6,000 £13,585 £5,112 £5,942 £9,622 £7,568 £6,917
   16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
   
   SCHEDULE 4: SECURITY & DEPARTMENT POLICIES
   Schedule 4
   Version 1 – July 2024 – Page 1

   SCHEDULE 5: EXIT ARRANGEMENTS
   Schedule 5
   Version 1 – July 2024 – Page 1
   
   """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10001013_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001013_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001013'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001013 - 10001013 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001013 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001013 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001013 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001013_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001013 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001013 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001013 | 10001013 Co Ltd  | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2425     | Contract Approved | Contract Approved | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001013 | NMSS-AY-2425-Contract-Provider-10001013-4_1             | 4_1            | AY-2425 | NMSS                        | 91135.00    | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2425-Contract-Provider-10001013-4_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '7' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15198.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                                                   | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 19843.00     | 0             | 0        | SSF High Needs Element 2 (NMSS)                                             | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 2920.00      | 0             | 0        | SSF Bursary Funds                                                           | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 14248.00     | 0             | 0        | Recovery Premium (NMSS)                                                     | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 8488.00      | 0             | 0        | Tutoring Grant (NMSS)                                                       | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 936             | 0                     | 13407.00     | 0             | 0        | Teachers' Pay Additional Grant (NMSS)                                       | ?                           |
#    | 10001013 | [ContractNo]   | 1               | [AllocRef_16ED]  | 937             | 0                     | 17031.00     | 0             | 0        | HTPP High Needs Funding (NMSS)                                              | ?                           |
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
Scenario: AK014 Import, release and approve a PSG funding allocation for 24/25 with deliverable 43. CofG_SPI. Provider Subtype = 'Special post 16 institution'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001014'
    And   there is no Funding Allocation data in CRM for UKPRN '10001014'
    And   there is no Contract, Task or Workflow data for UKPRN '10001014'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001014'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001014'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001014' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (SPI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001014' 
    And   there is no caseload advisor for UKPRN '10001014' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001014 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001014' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001014 Co Ltd' with UKPRN '10001014' and OrgId 'ORG0001014' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001014 | 101014 | 10001014 Co Ltd | 0              | Locked Restructure    | Yes           | AA001014      | ?             | 5 Spurway Parade       | Woodford Avenue        | ?                      | ?                      | Ilford                 | Essex                  | IG2 6UU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001014 |







    # Populate the stub with PSG (Special post 16 institution) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001014 | PSG-AY-2425-Contract-Provider-10001014-3_2            | 3_2            | PSG                         | AY-2425            | 13205.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PSG-AY-2425-10001014-3_2   | 3_2                    | PSG-AY-2425-Contract-Provider-10001014-3_2            | 10001014      | Other types                        | Special post 16 institution      | 13205.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2425-10001014-3_2   | PSG-001 | 13205.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2425-10001014-3_2   | PSG-001 | FY-2425              | November               | 2024              | 3367.00                   |
    | PSG-AY-2425-10001014-3_2   | PSG-001 | FY-2425              | March                  | 2025              | 4265.00                   |
    | PSG-AY-2425-10001014-3_2   | PSG-001 | FY-2425              | May                    | 2025              | 5573.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001014 | 10001014 Co Ltd  | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2425     | Scheduling        | Awaiting Release  | 13205.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_SPI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2425-Contract-Provider-10001014-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13205.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001014 | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | AY-2425 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10001014' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001014' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001014 | 10001014 Co Ltd  | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2425     | Released          | Released          | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2425-Contract-Provider-10001014-3_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PSG-AY-2425-Contract-Provider-10001014-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001014 | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | AY-2425 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2425-Contract-Provider-10001014-3_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001014 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001014 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 13205.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001014 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001014 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001014 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001014 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 13205.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Initial Payment) (NMSS)                                   |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10001014_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10001014 Co Ltd UKPRN: 10001014
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £7,632 £5,573 £13,205
    Total Funding for this contract: £13,205
    Summary of Funding – Page 1
    
    Agreement Type Specialist Post-16 Institution
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10001014 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement
    [MasterContractNo]
    Number
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Specialist Post-16 Institution
    Version 1 – July 2024 – Page 1    
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
            
    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 1 – July 2024 – Page 1
    Schedule 1
    Version 1 – July 2024 – Page 13


    SCHEDULE 2: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    
    SCHEDULE 3: PAYMENT
    Funding Agreement – 16 to 19 Education
    Provider: 10001014 Co Ltd UKPRN: 10001014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Primary PE and Sport Premium (1) £13,205 £0 £0 £0 £3,367 £0 £0 £0 £4,265 £0 £5,573 £0 £0
    Total Funding £13,205 £0 £0 £0 £3,367 £0 £0 £0 £4,265 £0 £5,573 £0 £0
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 1 – July 2024 – Page 1

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 1 – July 2024 – Page 1

    SCHEDULE 6: EXIT ARRANGEMENTS
    Schedule 6
    Version 1 – July 2024 – Page 1

    SCHEDULE 7: SUBCONTRACTING
    Schedule 7
    Version 1 – July 2024 – Page 1



    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10001014_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001014_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001014'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001014 - 10001014 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001014 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001014 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001014 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001014_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001014 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001014 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001014 | 10001014 Co Ltd  | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2425     | Contract Approved | Contract Approved | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001014 | PSG-AY-2425-Contract-Provider-10001014-3_2              | 3_2            | AY-2425 | PSG                         | 13205.00    | [CofG_SPI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2425-Contract-Provider-10001014-3_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10001014 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 13205.00     | 0             | 0        | Primary PE and Sport Premium (Initial Payment) (NMSS)                                   | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



@AcceptanceTest @Complete
@CFS
Scenario: AK015 Import, release and approve a PP funding allocation for 24/25 with deliverable 140. AA_College. Provider Subtype = 'Further education'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001015'
    And   there is no Funding Allocation data in CRM for UKPRN '10001015'
    And   there is no Contract, Task or Workflow data for UKPRN '10001015'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001015'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001015'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001015' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (College)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001015' 
    And   there is no caseload advisor for UKPRN '10001015' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001015 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001015' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001015 Co Ltd' with UKPRN '10001015' and OrgId 'ORG0001015' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001015 | 101015 | 10001015 Co Ltd | 0              | Active                | Yes           | AA001015      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001015 |







    # Populate the stub with PP (Further education) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001015 | PP-FY-2425-Contract-Provider-10001015-4_3             | 4_3            | PP                          | FY-2425            | 7540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PP-FY-2425-10001015-4_3    | 4_3                    | PP-FY-2425-Contract-Provider-10001015-4_3             | 10001015      | Colleges                           | Further education                | 7540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PP-FY-2425-10001015-4_3    | PP-001          | 7540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PP-FY-2425-10001015-4_3    | PP-001          | FY-2425              | November               | 2024              | 4673.00                   |
    | PP-FY-2425-10001015-4_3    | PP-001          | FY-2425              | April                  | 2025              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (College)      | AA_College                     |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001015 | 10001015 Co Ltd  | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | Education & Skills Funding | AY2425  | Accountability Agreement (College)     	   | PP                          | 16-19ED2425     | Scheduling        | Awaiting Release  | 7540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2425-Contract-Provider-10001015-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 7540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001015 | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | FY-2425 | PP                          | 7540.00     | [AA_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10001015' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001015' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001015 | 10001015 Co Ltd  | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | Education & Skills Funding | AY2425  | Accountability Agreement (College)       | PP                          | 16-19ED2425     | Released          | Released          | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2425-Contract-Provider-10001015-4_3               | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PP-FY-2425-Contract-Provider-10001015-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001015 | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | FY-2425 | PP                          | 7540.00     | [AA_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PP-FY-2425-Contract-Provider-10001015-4_3               | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001015 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001015 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001015 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 7540.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001015 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001015 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001015 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001015 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 7540.00         | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 7540.00   | 0.00     | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10001015_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10001015 Co Ltd UKPRN: 10001015
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £4,673 £2,867 £7,540
    Total Funding for this contract: £7,540
    Summary of Funding – Page 1
    
    Agreement Type Accountability Agreement (Colleges)
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10001015 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Accountability Agreement (Colleges)
    Version 2 – July 2024 – Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10001015 Co Ltd THE SECRETARY OF STATE 
    4 Arden Court FOR EDUCATION
    Arden Road DEPARTMENT FOR
    Alcester EDUCATION
    AND
    Warwickshire 20 GREAT SMITH STREET
    B49 6HN LONDON
    SW1P 3BT
    Company No: AA001015
    Hereinafter called Hereinafter called
    the College the Department
    Accountability Agreement (Colleges)
    Version 2 – July 2024 – Page 2
    
    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 – July 2024 – Page 1
    
    SCHEDULE 2: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    SCHEDULE 3: PAYMENT
    Schedule 3: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    
    Funding Agreement – 16 to 19 Education
    Provider: 10001015 Co Ltd UKPRN: 10001015
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Pupil Premium £7,540 £0 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
    Total Funding £7,540 £0 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 2 – July 2024 – Page 1

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 2 – July 2024 – Page 1

    SCHEDULE 6: EXIT ARRANGEMENTS
    Schedule 6
    Version 2 – July 2024 – Page 1

    SCHEDULE 7: COLLEGE GOVERNANCE
    Schedule 7
    Version 2 – July 2024 – Page 1

    SCHEDULE 8: SUBCONTRACTING
    Schedule 8
    Version 2 – July 2024 – Page 1

    SCHEDULE 9: NATIONAL SKILLS PRIORITIES
    Schedule 9
    Version 2 – July 2024 – Page 1

    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10001015_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001015_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001015'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001015 - 10001015 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001015 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001015 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001015 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001015_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001015 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001015 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001015 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001015 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    #And   the following Funding Allocations data is present in CRM
    #| UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    #| 10001015 | 10001015 Co Ltd  | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | Education & Skills Funding | AY2425  | Accountability Agreement (College)  | PP                          | 16-19ED2425     | Contract Approved | Contract Approved | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001015 | PP-FY-2425-Contract-Provider-10001015-4_3               | 4_3            | FY-2425 | PP                          | 7540.00     | [AA_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2425-Contract-Provider-10001015-4_3               | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10001015 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 7540.00      | 0             | 0        | Pupil Premium (NMSS)                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: AK016 Import, release and approve a NFF funding allocation for 24/25 with deliverable 931. Contract for Services (ITP). Provider Subtype = 'Independent learning provider'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001016'
    And   there is no Funding Allocation data in CRM for UKPRN '10001016'
    And   there is no Contract, Task or Workflow data for UKPRN '10001016'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001016'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001016'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001016' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Contract for Services (ITP)			   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001016' 
    And   there is no caseload advisor for UKPRN '10001016' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001016 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001016' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001016 Co Ltd' with UKPRN '10001016' and OrgId 'ORG0001016' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001016 | 101016 | 10001016 Co Ltd | 0              | Active                | Yes           | AA001016      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001016 |







    # Populate the stub with NFF (Independent learning provider) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001016 | NFF-AS-2425-Contract-Provider-10001016-1_0            | 1_0            | NFF                         | AS-2425            | 8540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NFF-AS-2425-10001016-1_0   | 1_0                    | NFF-AS-2425-Contract-Provider-10001016-1_0            | 10001016      | 16-19 provider                     | Independent learning provider    | 8540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2425-10001016-1_0   | NFF-001         | 8540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2425-10001016-1_0   | NFF-001         | FY-2425              | August	               | 2024              | 1000.00                   |
    | NFF-AS-2425-10001016-1_0   | NFF-001         | FY-2425              | November               | 2024              | 4673.00                   |
    | NFF-AS-2425-10001016-1_0   | NFF-001         | FY-2425              | April                  | 2025              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Contract for Services (ITP)			   | Cfs_ITP	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs_ITP = [Cfs_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001016 | 10001016 Co Ltd  | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | Education & Skills Funding | AY2425  | Contract for Services (ITP)			   | NFF                         | 16-19ED2425     | Scheduling        | Awaiting Release  | 8540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs_ITP]    	 | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2425-Contract-Provider-10001016-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001016 | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | AS-2425 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10001016' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001016' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001016 | 10001016 Co Ltd  | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | Education & Skills Funding | AY2425  | Contract for Services (ITP)			   | NFF                         | 16-19ED2425     | Released          | Released          | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs_ITP]	   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2425-Contract-Provider-10001016-1_0              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2425-Contract-Provider-10001016-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001016 | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | AS-2425 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2425-Contract-Provider-10001016-1_0              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001016 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001016 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 8540.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services (ITP)   | ?         | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001016 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001016 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services (ITP)   | ?         | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001016 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001016 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 8540.00         | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 931             | 8540.00   | 1000.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Cadets Vocational Programme                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10001016_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10001016 Co Ltd UKPRN: 10001016
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £5,673 £2,867 £8,540
    Total Funding for this contract: £8,540
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10001016 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Contract for Services
    Version 2 - July 2024 - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10001016 Co Ltd THE SECRETARY OF STATE FOR
    4 Arden Court EDUCATION
    Arden Road DEPARTMENT FOR EDUCATION
    Alcester 20 GREAT SMITH STREET
    AND
    Warwickshire LONDON
    B49 6HN SW1P 3BT
    Company No: AA001016
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Contract for Services
    Version 2 – July 2024 – Page 2
    
    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 – July 2024 – Page 1

    
    SCHEDULE 2: SPECIFICATION & MONITORING
    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    
    SCHEDULE 3: PAYMENT
    Funding Agreement – 16 to 19 Education
    Provider: 10001016 Co Ltd UKPRN: 10001016
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Cadets Vocational Programme £8,540 £1,000 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0
    Total Funding £8,540 £1,000 £0 £0 £4,673 £0 £0 £0 £0 £2,867 £0 £0 £0    
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 4: CHANGE CONTROL PROCEDURE
    Schedule 4
    Version 2 – July 2024 – Page 1

    SCHEDULE 5: CONTRACTOR’S RESPONSE/PROPOSALS
    Schedule 5
    Version 2 – July 2024 – Page 1

    SCHEDULE 6: TUPE
    Schedule 6
    Version 2 – July 2024 – Page 1

    SCHEDULE 7: UK GDPR/DATA PROTECTION
    Schedule 7
    Version 2 – July 2024 – Page 1

    SCHEDULE 8: SECURITY & DEPARTMENT POLICIES
    Schedule 8
    Version 2 – July 2024 – Page 1

    SCHEDULE 9: EXIT ARRANGEMENTS
    Schedule 9
    Version 2 – July 2024 – Page 1

    SCHEDULE 10: SUBCONTRACTING
    Schedule 10
    Version 2 – July 2024 – Page 1






    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10001016_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001016_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001016'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001016 - 10001016 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001016 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001016 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001016 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001016_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001016 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001016 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001016 | 10001016 Co Ltd  | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | Education & Skills Funding | AY2425  | Contract for Services (ITP)			   | NFF                         | 16-19ED2425     | Contract Approved | Contract Approved | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs_ITP]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001016 | NFF-AS-2425-Contract-Provider-10001016-1_0              | 1_0            | AS-2425 | NFF                         | 8540.00     | [Cfs_ITP]		  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2425-Contract-Provider-10001016-1_0              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10001016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 931             | 0                     | 8540.00      | 0             | 0        | Cadets Vocational Programme                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    
@AcceptanceTest @Complete
@CFS
Scenario: AK017 Import, release and approve a 1416 funding allocation for 24/25 with deliverables 24, 25 and 111. Cofg(LA). Provider Subtype = '06SDC'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001017'
    And   there is no Funding Allocation data in CRM for UKPRN '10001017'
    And   there is no Contract, Task or Workflow data for UKPRN '10001017'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001017'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001017'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001017' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (LA)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001017' 
    And   there is no caseload advisor for UKPRN '10001017' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001017 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001017' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001017 Co Ltd' with UKPRN '10001017' and OrgId 'ORG0001017' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001017 | 101017 | 10001017 Co Ltd | 0              | Active                | Yes           | AA001017      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001017 |





    # Populate the stub with 1416 (Furth) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7           | 3_7            | 1416                        | AY-2425            | 50507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1416-AY-2425-10001017-3_7  | 3_7                    | 1416-AY-2425-Contract-Provider-10001017-3_7 	      | 10001017      | Local authority		               | Local authority							  | 50507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | 28311.00         | Payment         |
    | 1416-AY-2425-10001017-3_7  | 1416-002        | 12196.00         | Payment         |
    | 1416-AY-2425-10001017-3_7  | 1416-003        | 10000.00         | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | August                 | 2024              | 4572.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | November               | 2024              | 4888.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | January                | 2025              | 2879.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | February               | 2025              | 4904.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | April                  | 2025              | 5769.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-001        | FY-2425              | July                   | 2025              | 5299.00                   |
    #
    | 1416-AY-2425-10001017-3_7  | 1416-002        | FY-2425              | August                 | 2024              | 2735.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-002        | FY-2425              | February               | 2025              | 5684.00                   |
    | 1416-AY-2425-10001017-3_7  | 1416-002        | FY-2425              | May                    | 2025              | 3777.00                   |
    #
    | 1416-AY-2425-10001017-3_7  | 1416-003        | FY-2425              | August                 | 2024              | 10000.00                  |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (LA)      | CofG(LA)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001017 | 10001017 Co Ltd  | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 50507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG(LA)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | AY-2425 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10001017' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001017' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001017 | 10001017 Co Ltd  | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2425     | Released          | Released          | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | AY-2425 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2425-Contract-Provider-10001017-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001017 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10001017 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 50507.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001017 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10001017 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001017 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10001017 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 50507.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 24              | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | 14-16 Programme Funding    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 25              | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | 14-16 Pupil Premium        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 111             | 10000.00  | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00	  | 0.00     | 0.00     | 0.00	   | 0.00     | 0.00     | 14-16 Service Child Premium|                          |


    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
    And   the file named '10001017_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10001017 Co Ltd UKPRN: 10001017
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £35,662 £14,845 £50,507
    Total Funding for this contract: £50,507
    Summary of Funding – Page 1
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    st st
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10001017 Co Ltd
    Funding for 16 to 19 Education
    ACCEPTANCE BY THE PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Conditions of Funding (Grant) (Local Authorities)
    Version 2 - July 2024 - Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10001017 Co Ltd THE SECRETARY OF STATE FOR
    102 Handside Lane EDUCATION
    Welwyn Garden City DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    AL8 6SY LONDON
    SW1P 3BT
    Company No: AA001017
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Conditions of Funding (Grant) (Local Authorities)
    Version 2 - July 2024 - Page 2
    EDSK Conditions of Funding (Grant) (Local Authorities)
    Version 2 - July 2024 - Page 60


    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 - July 2024 - Page 1
    Schedule 1
    Version 2 - July 2024 - Page 15

    SCHEDULE 2: SPECIFICATION & MONITORING
    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    SCHEDULE 3: PAYMENT
    Schedule 3: 16 to 19 Education
    Version 1 – July 2024 – Page 1   

    Funding Agreement – 16 to 19 Education
    Provider: 10001017 Co Ltd UKPRN: 10001017
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    14-16 Programme Funding £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
    14-16 Pupil Premium £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
    14-16 Service Child Premium £10,000 £10,000 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Total Funding £50,507 £17,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299    

    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 2 – July 2024 – Page 1

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 2 – July 2024 – Page 1
   
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10001017_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001017_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001017'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10001017 - 10001017 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10001017 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10001017 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10001017 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10001017_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001017 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10001017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001017 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10001017 | 10001017 Co Ltd  | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2425     | Contract Approved | Contract Approved | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | AY-2425 | 1416                        | 50507.00    | [CofG(LA)]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '2' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10001017 | [ContractNo]   | 1               | [AllocRef_16ED]  | 24              | 0                     | 28311.00     | 0             | 0        | 14-16 Programme Funding    | ?                           |
#    | 10001017 | [ContractNo]   | 1               | [AllocRef_16ED]  | 25              | 0                     | 12196.00     | 0             | 0        | 14-16 Pupil Premium	      | ?                           |
#    | 10001017 | [ContractNo]   | 1               | [AllocRef_16ED]  | 111             | 0                     | 10000.00     | 0             | 0        | 14-16 Service Child Premium| ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Complete
@CFS
Scenario: S623 Import a 1619ED2425(for exception providers) FA for a nonsense ProviderType and ProviderSubType for override UKPRN 10007623. LA AA. Release and approve. Check docs, CRM, PaaS and Feed

    # 10007623 is an exception provider listed in the Provider Category Exceptions tab of the config spreadsheet
    # In 21/22, exception provider 10088193 was tested by A171. 
    # In 22/23, exception provider 10039859 was tested by A383. 
    # S800 is being added because 10007623 introduces a new Provider Category: LA AA 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10007623'
    And   there is no Funding Allocation data in CRM for UKPRN '10007623'
    And   there is no Contract, Task or Workflow data for UKPRN '10007623'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10007623'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10007623'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10007623' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (LA)           |


    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10007623' 
    And   there is no caseload advisor for UKPRN '10007623' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10007623 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10007623' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10007623 Co Ltd' with UKPRN '10007623' and OrgId 'ORG0007623' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10007623 | 107623 | 10007623 Co Ltd | 0              | Active                | Yes           | AA007623      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10007623 |




    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10007623 | 1619-AS-2425-Contract-Provider-10007623-3_7           | 3_7            | 1619                        | AS-2425            | 54147.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2425-10007623-3_7  | 3_7                    | 1619-AS-2425-Contract-Provider-10007623-3_7           | 10007623      | Nonsense       | Rubbish             | 54147.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2425-10007623-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2425-10007623-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2425-10007623-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2425-10007623-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2425-10007623-3_7  | 1619-010        | 3011.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2425-10007623-3_7  | 1619-002        | FY-2425              | October                | 2024              | 2488.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-002        | FY-2425              | March                  | 2025              | 4411.00                   |
    #
    | 1619-AS-2425-10007623-3_7  | 1619-005        | FY-2425              | October                | 2024              | 5280.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-005        | FY-2425              | January                | 2025              | 3784.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-005        | FY-2425              | February               | 2025              | 4270.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-005        | FY-2425              | May                    | 2025              | 5750.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-005        | FY-2425              | July                   | 2025              | 2374.00                   |
    #
    | 1619-AS-2425-10007623-3_7  | 1619-006        | FY-2425              | October                | 2024              | 4319.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-006        | FY-2425              | February               | 2025              | 4874.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-006        | FY-2425              | April                  | 2025              | 2145.00                   |
    #
    | 1619-AS-2425-10007623-3_7  | 1619-008        | FY-2425              | September              | 2024              | 3007.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-008        | FY-2425              | December               | 2024              | 4588.00                   |
    | 1619-AS-2425-10007623-3_7  | 1619-008        | FY-2425              | April                  | 2025              | 3846.00                   |
    #
    | 1619-AS-2425-10007623-3_7  | 1619-010        | FY-2425              | July                   | 2025              | 3011.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (LA)         | AA_LA                     |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_LA = [AA_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10007623 | 10007623 Co Ltd  | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)            | 1619                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 54147.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_LA]      	 | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10007623-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 54147.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007623 | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [AA_LA]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_LA]           |

    Then wait '60' seconds

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_LA = [AA_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 54147.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10007623' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10007623' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10007623 | 10007623 Co Ltd  | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)          | 1619                        | 16-19ED2425     | Released          | Released          | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_LA]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10007623-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2425-Contract-Provider-10007623-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007623 | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [AA_LA]         | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2425-Contract-Provider-10007623-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10007623 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10007623 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#
#    Given the override date is '06/07/2024'
#    And   a file with filename '10007623_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Input-Appendices'
#    And  the contract sub-status is updated to 'Awaiting Documentation' on the latest version of contract '[ContractNo]'
#    And the TaskOwner is updated to 'Document Management Team' on the latest version of contract '[ContractNo]'


    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10007623 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 54147.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10007623 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10007623 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10007623 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10007623 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 54147.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 6899.00   | 0.00     | 0.00     | 2488.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 21458.00  | 0.00     | 0.00     | 5280.00  | 0.00     | 0.00     | 3784.00  | 4270.00  | 0.00     | 0.00     | 5750.00  | 0.00     | 2374.00  | 16-19 Free Meals                                                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 11338.00  | 0.00     | 0.00     | 4319.00  | 0.00     | 0.00     | 0.00     | 4874.00  | 0.00     | 2145.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 11441.00  | 0.00     | 3007.00  | 0.00     | 0.00     | 4588.00  | 0.00     | 0.00     | 0.00     | 3846.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 3011.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3011.00  | Teacher's Pension Scheme 1619                                         |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
    # Check the contents of the Appendices
    And   the file named '10007623_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10007623 Co Ltd UKPRN: 10007623
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    16 to 19 Education [AllocRef_16ED] £37,021 £17,126 £54,147
    Total Funding for this contract: £54,147
    Summary of Funding – Page 1
    Agreement Type Accountability Agreement (Local Authorities)
    st st
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10007623 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement
    [MasterContractNo]
    Number
    ACCEPTANCE BY THE PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Accountability Agreement (Local Authorities)
    Version 2 – July 2024 – Page 1
    TERMS AND CONDITIONS
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10007623 Co Ltd
    THE SECRETARY OF STATE FOR
    96 West Yard
    EDUCATION
    Camden Lock Place
    DEPARTMENT FOR EDUCATION
    Chalk Farm Road
    AND
    20 GREAT SMITH STREET
    London
    LONDON
    NW1 8AF
    SW1P 3BT
    Company No: AA007623
    Hereinafter called Hereinafter called
    the Provider the Department
    Accountability Agreement (Local Authorities)
    Version 2 – July 2024 – Page 2


    Accountability Agreement (Local Authorities)
    Version 2 – July 2024 – Page 58

    Schedule 1
    Version 2 – July 2024 – Page 1

    Schedule 1
    Version 2 – July 2024 – Page 14

    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 1

    Schedule 2: 16 to 19 Education
    Version 1 – July 2024 – Page 9


    Schedule 3: 16 to 19 Education
    Version 1 – July 2024 – Page 1


    16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10007623 Co Ltd UKPRN: 10007623
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    16-19 Bursary Funds £6,899 £0 £0 £2,488 £0 £0 £0 £0 £4,411 £0 £0 £0 £0
    16-19 High Needs Element 2 £11,338 £0 £0 £4,319 £0 £0 £0 £4,874 £0 £2,145 £0 £0 £0
    16-19 Free Meals £21,458 £0 £0 £5,280 £0 £0 £3,784 £4,270 £0 £0 £5,750 £0 £2,374
    16-19 Advanced Maths Premium £11,441 £0 £3,007 £0 £0 £4,588 £0 £0 £0 £3,846 £0 £0 £0
    Teacher's Pension Scheme 1619 £3,011 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £3,011
    Total Funding £54,147 £0 £3,007 £12,087 £0 £4,588 £3,784 £9,144 £4,411 £5,991 £5,750 £0 £5,385
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    Schedule 4
    Version 2 – July 2024 – Page 2

    Schedule 5
    Version 2 – July 2024 – Page 8

    Schedule 6
    Version 2 – July 2024 – Page 5

    Schedule 7
    Version 2 – July 2024 – Page 5

    Schedule 8
    Version 2 – July 2024 – Page 1
    """







    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10007623_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10007623_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10007623'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10007623 - 10007623 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10007623 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10007623 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10007623 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10007623_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10007623 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10007623 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10007623 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10007623 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10007623 | 10007623 Co Ltd  | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)            | 1619                        | 16-19ED2425     | Contract Approved | Contract Approved | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_LA]  | ?    | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007623 | 1619-AS-2425-Contract-Provider-10007623-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [AA_LA]         | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10007623-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10007623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 6899.00      | 0             | 0        | 16-19 Bursary Funds                                                   | ?                           |
    | 10007623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 21458.00     | 0             | 0        | 16-19 Free Meals                                                      | ?                           |
    | 10007623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 11338.00     | 0             | 0        | 16-19 High Needs Element 2                                            | ?                           |
    | 10007623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 11441.00     | 0             | 0        | 16-19 Advanced Maths Premium                                          | ?                           |
    | 10007623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 3011.00      | 0             | 0        | Teacher's Pension Scheme 1619                                         | ?                           |



    
#    
#    # Payment Batch for 1619ED2425(PoP)
#
#    # Change the date
#    Given the override date is '03/10/2024 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2425' AccountingPaymentPeriod '202307' CensusEndDate '03/10/2024' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_16ED]          | 202310 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 1619ED2425                 | 202310               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 1619ED2425                 | 202310               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202307' CensusEndDate '03/10/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S800.xml'
#
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202305' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | NLG                    | 2024          | 05             | 02          | ?       | [AllocRef_16ED]           | 562.00          | PROFILE          | Principals Ref Group               | 2024-08-18 | 2024-08-01   | 2025-07-31 | ?              | 10018034 | 2208100    |
##    | NLG                    | 2024          | 05             | 02          | ?       | [AllocRef_16ED]           | 448.00          | PROFILE          | NationalLeadrs of FE               | 2024-08-18 | 2024-08-01   | 2025-07-31 | ?              | 10018034 | 2208200    |
##    | NLG                    | 2024          | 05             | 02          | ?       | [AllocRef_16ED]           | 25.00           | PROFILE          | Isles of Scilly                    | 2024-08-18 | 2024-08-01   | 2025-07-31 | ?              | 10018034 | 2202070    |
##
#
#
#    
#   #  Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2024-10 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '04/10/2024'
#    # Check the above report manually
#
#    
#   

    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


     @AcceptanceTest @Hold
@Long2Run @Long2Run67
Scenario: AK019 Bulk load a EDSK 2425 contract with CofG(Trust) contract type for  1619ED2425 allocs. Check docs.Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10001019' 
    And   there are no terminated or closed allocations for UKPRN '10001019' 
    And   there is no Contract, Task or Workflow data for UKPRN '10001019' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001019' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10001019' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2425     |
   
   
    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2425_2024-08-01.docx                  | 2025-02-20 10:00:00.000 |
    | EDSK2425_S3_AEB_AA_LA_2024-08-01.docx        | 2025-02-20 10:00:00.000 |
    | EDSK2425_S3_AEB_AA_COLLEGE_2024-08-01.docx   | 2025-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_AA_LA_2024-08-01.docx        | 2025-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_AA_COLLEGE_2024-08-01.docx   | 2025-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_COFG_2024-08-01.docx         | 2025-02-20 10:00:00.000 |
    | EDSK2425_S1_AEB_COFG_2024-08-01.docx         | 2025-02-20 10:00:00.000 |
 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10001019'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001019' 
    And   there is no caseload advisor for UKPRN '10001019' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001019 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001019' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001019 Co Ltd' with UKPRN '10001019' and OrgId 'ORG0001019' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001019 | 001019 | 10001019 Co Ltd | 0              | In Administration     | Yes           | AA001019      | ?             | 96 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Drewsbury                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001019 |





    # Change the date
    Given the override date is '01/06/2024'

    # Bulk file
    And   there are no files prefixed '10001019' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2425 19022022105948 v3_AK019' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2425 19022022105948 v3_AK019' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2425 19022022105948 v3_AK019' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2425 19022022105948 v3_AK019' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2425 19022022105948 v3_AK019.xlsx' exists in the Datafiles folder and UKPRN '10001019' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10001019' for FundingType 'EDSK' and period '2425'

 #place code here
    
   
  

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10001019_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK019_v1.pdf'

    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001019 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001019 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-06-01 09:12:35.000 |


    
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated


    | DocumentTemplateName	                          | UploadTimestamp         |
    | FA_EDSK2425_2024-08-01.docx                  | 2024-02-20 10:00:00.000 |
    | EDSK2425_S3_AEB_AA_LA_2024-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2425_S3_AEB_AA_COLLEGE_2024-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_AA_LA_2024-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_AA_COLLEGE_2024-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2425_S2_AEB_COFG_2024-08-01.docx         | 2024-02-20 10:00:00.000 |
    | EDSK2425_S1_AEB_COFG_2024-08-01.docx         | 2024-02-20 10:00:00.000 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2024'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001019 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10001019 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10001019 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10001019' for FundingType 'EDSK' and period '2425'

    #place code here
   
  
    # Save a copy of the output
    Then  Sharepoint file '10001019_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK019_v2.pdf'

    #Then stop





    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '01/08/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


          Given there is no CDA report named 'CDA Latest Version AK019.csv'

And   the following ADF Pipeline run
    Then  the contracts are in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber |
    | [ContractNo]   | 2                    |

    When  the following CDA report is run
    | FundingStreamPeriod     | Version               | Suffix |
    | 1619ED2425              | Latest Version        | AK019   |
    
    Then  a report named 'CDA Latest Version AK019.csv' is created




   # Part 9: Payment Batch for 1619ED2425

    # Change the date
    Given the override date is '02/08/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2425' AccountingPaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_16ED]          | 202408 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2425      		     | 202408               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2425           	     | 202408               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '1619ED2425' AccountingPaymentPeriod '202405' and CensusEndDate '02/08/2024'




@AcceptanceTest @Complete
@CFS
Scenario: S054 Create and release a 1619 Funding Allocation with 2 schools. Publish and approve contract. NFA. Import 1619 FA with 3 schools and unchanged versions
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018054'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018055'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018056'

    And   there is no Funding Allocation data in CRM for UKPRN '10018054'
    And   there is no Funding Allocation data in CRM for UKPRN '10018055'
    And   there is no Funding Allocation data in CRM for UKPRN '10018056'

    And   there is no Contract, Task or Workflow data for UKPRN '10018054'
    And   there is no Contract, Task or Workflow data for UKPRN '10018055'
    And   there is no Contract, Task or Workflow data for UKPRN '10018056'

    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018054'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018054'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018054' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (LA)	   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018054' 
    Given there is no Organisation data for UKPRN '10018055'
    Given there is no Organisation data for UKPRN '10018056' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018054 Co Ltd' with UKPRN '10018054' and OrgId 'ORG0018054' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018055 Co Ltd' with UKPRN '10018055' and OrgId 'ORG0018054' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018056 Co Ltd' with UKPRN '10018056' and OrgId 'ORG0018054' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                    | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018054 | 118054 | Tumpton County Council  | 0              | Active   | Yes           | AA018054      | ?             | 28 Stainburn Avenue    | Moortown               | Leeds                  | ?                      | ?                      | ?                      | LS17 6PG  |
    | 10018055 | 118055 | Chase Community School  | 0              | Active   | Yes           | AA018055      | ?             | 58 Greystone Road      | Antrim                 | ?                      | ?                      | ?                      | ?                      | BT41 1JZ  |
    | 10018056 | 118056 | Chigwell School         | 0              | Active   | Yes           | AA018056      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018054 |
    | 10018055 |
    | 10018056 |





    # Populate the stub with 1619 (10LAU) funding data for the Local Authority

    # Change the date 
    Given the override date is '02/07/2024'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018054 | 1619-AS-2425-Contract-LocalAuthority-10018054-1_7     | 1_7            | 1619                        | AS-2425            | 9581.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2425-10018054-1_7  | 1_7                    | 1619-AS-2425-Contract-LocalAuthority-10018054-1_7     | 10018054      | Local        | 10LAU           | 9581.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2425-10018054-1_7  | 1619-026        | 8581.00          | Payment         |
    | 1619-AS-2425-10018054-1_7  | 1619-027        | 1000.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2425-10018054-1_7  | 1619-026        | FY-2425              | October                | 2024              | 3893.00                   |
    | 1619-AS-2425-10018054-1_7  | 1619-026        | FY-2425              | April                  | 2025              | 4688.00                   |
    | 1619-AS-2425-10018054-1_7  | 1619-027        | FY-2425              | October                | 2024              | 500.00                   |
    | 1619-AS-2425-10018054-1_7  | 1619-027        | FY-2425              | April                  | 2025              | 500.00                   |
 
 
 
 
 
    # Populate the stub with 1619 (08SSF) funding data for two schools

    # Funding Allocation 
    Given the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018054 | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_1  | 2_1            | 1619                        | AS-2425            | 24191.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2425-10018055-2_5  | 2_5                    | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_1  | 10018055      | Schoo        | 08SSF           | 15673.00                  |
    | 1619-AS-2425-10018056-2_6  | 2_6                    | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_1  | 10018056      | Schoo        | 08SSF           | 8518.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2425-10018055-2_5  | 1619-026        | 13673.00         | Payment         |
    | 1619-AS-2425-10018055-2_5  | 1619-027        | 1000.00          | Payment         |

    | 1619-AS-2425-10018056-2_6  | 1619-027        | 6518.00          | Payment         |
    | 1619-AS-2425-10018056-2_6  | 1619-026        | 1000.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2425-10018055-2_5  | 1619-026        | FY-2425              | October                | 2024              | 3867.00                   |
    | 1619-AS-2425-10018055-2_5  | 1619-026        | FY-2425              | February               | 2025              | 5860.00                   |
    | 1619-AS-2425-10018055-2_5  | 1619-026        | FY-2425              | July                   | 2025              | 4946.00                   |
    | 1619-AS-2425-10018055-2_5  | 1619-027        | FY-2425              | October                | 2024              | 500.00                   |
    | 1619-AS-2425-10018055-2_5  | 1619-027        | FY-2425              | February               | 2025              | 300.00                   |
    | 1619-AS-2425-10018055-2_5  | 1619-027        | FY-2425              | July                   | 2025              | 200.00                   |
    #
    | 1619-AS-2425-10018056-2_6  | 1619-027        | FY-2425              | August                 | 2024              | 2577.00                   |
    | 1619-AS-2425-10018056-2_6  | 1619-027        | FY-2425              | March                  | 2025              | 2791.00                   |
    | 1619-AS-2425-10018056-2_6  | 1619-027        | FY-2425              | April                  | 2025              | 2150.00                   |
    | 1619-AS-2425-10018056-2_6  | 1619-026        | FY-2425              | August                 | 2024              | 500.00                   |
    | 1619-AS-2425-10018056-2_6  | 1619-026        | FY-2425              | March                  | 2025              | 400.00                   |
    | 1619-AS-2425-10018056-2_6  | 1619-026        | FY-2425              | April                  | 2025              | 100.00                   |

 
#
#
#
#    # Populate the stub with 1619 (10LAU) funding data for the Local Authority once more - with updated FundingId version and updated ProviderFundingId version (and with different financials)
#
#    # Funding Allocation 
#    Given the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10018054 | 1619-AS-2425-Contract-LocalAuthority-10018054-3_3     | 3_3            | 1619                        | AS-2425            | 9999.00           |
# 
#    # Provider Funding Allocation
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2425-10018054-3_3  | 3_3                    | 1619-AS-2425-Contract-LocalAuthority-10018054-3_3     | 10018054      | Local        | 10LAU           | 9999.00                   |
# 
#    # Funding Allocation Line (aka Deliverable)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2425-10018054-3_3  | 1619-024        | 9999.00          | Payment         |
# 
#    # Funding Allocation Profile Period
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2425-10018054-3_3  | 1619-024        | FY-2425              | October                | 2020              | 3893.00                   |
#    | 1619-AS-2425-10018054-3_3  | 1619-024        | FY-2425              | April                  | 2425              | 4688.00                   |
#    | 1619-AS-2425-10018054-3_3  | 1619-024        | FY-2425              | June                   | 2425              | 1418.00                   |
#
# 
# 
# 
# 
#    # Populate the stub with 1619 (08SSF) funding data for the two schools once more - with updated FundingId version but the same ProviderFundingId versions
#
#    # Funding Allocation 
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10018054 | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_2  | 2_2            | 1619                        | AS-2425            | 22191.00          |
# 
#    # Provider Funding Allocation
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2425-10018055-2_5  | 2_5                    | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_2  | 10018055      | Schoo        | 08SSF           | 14673.00                  |
#    | 1619-AS-2425-10018056-2_6  | 2_6                    | 1619-AS-2425-Contract-LocalAuthoritySsf-10018054-2_2  | 10018056      | Schoo        | 08SSF           | 7518.00                   |
# 
#    # Funding Allocation Line (aka Deliverable)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2425-10018055-2_5  | 1619-004        | 14673.00         | Payment         |
#    | 1619-AS-2425-10018056-2_6  | 1619-003        | 7518.00          | Payment         |
# 
#    # Funding Allocation Profile Period
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2425-10018055-2_5  | 1619-004        | FY-2425              | October                | 2020              | 3867.00                   |
#    | 1619-AS-2425-10018055-2_5  | 1619-004        | FY-2425              | February               | 2425              | 5860.00                   |
#    | 1619-AS-2425-10018055-2_5  | 1619-004        | FY-2425              | July                   | 2425              | 4946.00                   |
#    #
#    | 1619-AS-2425-10018056-2_6  | 1619-003        | FY-2425              | August                 | 2020              | 2577.00                   |
#    | 1619-AS-2425-10018056-2_6  | 1619-003        | FY-2425              | March                  | 2425              | 2791.00                   |
#    | 1619-AS-2425-10018056-2_6  | 1619-003        | FY-2425              | April                  | 2425              | 2150.00                   |
#
# 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '04/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Conditions of Funding (Grant) (LA)      | CofG(LA)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    ## Check the CRM Funding Allocations data (J125)
    #Then  the following Funding Allocations data is present in CRM
    #| UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    #| 10001017 | 10001017 Co Ltd  | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 50507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(LA)]      | ?          | ?                   |

    ## Check the CRM Funding Allocation Workflow History data
    #And   the following Funding Allocation Workflow History data is present in CRM
    #| FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    #| 1416-AY-2425-Contract-Provider-10001017-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CofG(LA)]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 50507.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | AY-2425 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
#




#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window
#
#    # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
#    | 10001018 | 10001018 Co Ltd  | 1619-AS-2425-Contract-Provider-10001018-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)            | 1619                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 54147.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_LA]      | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2425-Contract-Provider-10001018-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[AA_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 54147.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001018 | 1619-AS-2425-Contract-Provider-10001018-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [AA_LA]    | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
#
#
#    


    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG(LA)]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    ## Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[CofG(LA)]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 9581.00         |

#    # Retrieve parameters from CRM 
#    When  I retrieve the latest contract details from CRM for provider '10001017' for FundingType 'EDSK' and period '2425'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10001017' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 
#
#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10001017 | 10001017 Co Ltd  | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | Education & Skills Funding | AY2425  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2425     | Released          | Released          | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(LA)]      | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#    | 1416-AY-2425-Contract-Provider-10001017-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001017 | 1416-AY-2425-Contract-Provider-10001017-3_7             | 3_7            | AY-2425 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.Contract
#    And   the following Funding Allocations and Contracts are linked in PaaS
#    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
#    | 1416-AY-2425-Contract-Provider-10001017-3_7             | [ContractNo] | 1               | 0                  | Yes            |
#
#    # Check PaaS FundingAllocation.ReleaseGroup
#    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10001017 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10001017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10001017 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 50507.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001017 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10001017 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001017 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10001017 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 50507.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 24              | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | 14-16 Programme Funding    |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 25              | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | 14-16 Pupil Premium        |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 111             | 10000.00  | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00	  | 0.00     | 0.00     | 0.00	   | 0.00     | 0.00     | 14-16 Service Child Premium|                          |
#
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#    # Check the deliverable count in CRM
#    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#



#
#    # Release a Release Group (32953)
#
#    # Change the date 
#    Given the override date is '04/07/2024'
#
#    # Release Funding Allocations from Contract Control (J128)
#   #When  a request is triggered to release the following Release Groups together
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [AA_LA]           |
#
#    Then wait '60' seconds
#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup AA_LA = [AA_LA]' is written to the Output window
#
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[AA_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 54147.00        |
#
#    # Retrieve parameters from CRM 
#    When  I retrieve the latest contract details from CRM for provider '10001018' for FundingType 'EDSK' and period '2425'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10001018' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 
#
#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10001018 | 10001018 Co Ltd  | 1619-AS-2425-Contract-Provider-10001018-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)          | 1619                        | 16-19ED2425     | Released          | Released          | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_LA]         | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2425-Contract-Provider-10001018-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#    | 1619-AS-2425-Contract-Provider-10001018-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001018 | 1619-AS-2425-Contract-Provider-10001018-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [AA_LA]         | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.Contract
#    And   the following Funding Allocations and Contracts are linked in PaaS
#    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
#    | 1619-AS-2425-Contract-Provider-10001018-3_7             | [ContractNo] | 1               | 0                  | Yes            |
#
#    # Check PaaS FundingAllocation.ReleaseGroup
#    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10001018 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10001018 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
##
##    Given the override date is '06/07/2024'
##    And   a file with filename '10001800_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Input-Appendices'
##    And  the contract sub-status is updated to 'Awaiting Documentation' on the latest version of contract '[ContractNo]'
##    And the TaskOwner is updated to 'Document Management Team' on the latest version of contract '[ContractNo]'
#
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10001018 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 54147.00      | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001018 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10001018 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001018 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10001018 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 54147.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                                       | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 19              | 6899.00   | 0.00     | 0.00     | 2488.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                                   |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 31              | 21458.00  | 0.00     | 0.00     | 5280.00  | 0.00     | 0.00     | 3784.00  | 4270.00  | 0.00     | 0.00     | 5750.00  | 0.00     | 2374.00  | 16-19 Free Meals                                                      |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 22              | 11338.00  | 0.00     | 0.00     | 4319.00  | 0.00     | 0.00     | 0.00     | 4874.00  | 0.00     | 2145.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                            |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 914             | 11441.00  | 0.00     | 3007.00  | 0.00     | 0.00     | 4588.00  | 0.00     | 0.00     | 0.00     | 3846.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                          |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 125             | 3011.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3011.00  | Teacher's Pension Scheme 1619                                         |                          |
#

    # Tidy Up
    Given the override date is reset

#    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
#    And   there is no data in the ContractRequest.FundingAllocationRelease table 
#
#    # Clear down FundingAllocation.BulkUploadStatus (J148)
#    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Hold
@Long2Run @Long2Run123
Scenario: AK033 Create 19-24 Traineeships contracts linked by Master for 20/21, 21/22 , 22/23, 23/24 and 24/25. Bulk load a NewAmendment for 25/26. Approve. Check docs, CRM and Feed 

    # 1. Create and approve 20/21 contract
    # 2. Create and approve 21/22 contract linked to 20/21 by Master
    # 3. Create and approve 22/23 contract linked to  Master
    # 4. Create and approve 23/24 contract linked to  Master
    # 5. Create and approve 24/25 contract linked to  Master
    # 6. Bulk load 'New Amendment' for 25/26. Publish and approve
    # Check docs, CRM and Feed

    Given there are no allocations marked as Under Termination for UKPRN '10010033' 
    And   there are no terminated or closed allocations for UKPRN '10010033' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010033' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010033' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010033' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-221      |
    | 19TR-221      |
    | 19TL-2211      |
    | 19TR-2211      |
    | 19TL-2212      |
    | 19TR-2212      |
    | 19TL-2213      |
    | 19TR-2213      |
    | 19TR-2214      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-221      |
    | 19TR-221      |
    | 19TL-2211      |
    | 19TR-2211      |
    | 19TL-2212      |
    | 19TR-2212      |
    | 19TL-2213      |
    | 19TR-2213      |
    | 19TR-2214      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2021    |
    | 19TRN2020-LS2021  |
    | 19TRN2020-2122    |
    | 19TRN2020-2223    |
    | 19TRN2020-2324    |
    | 19TRN2020-2526    |


    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010033'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-221     | 1                     | 0                        |
    | 19TR20-2201    | 1                     | 0                        |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010033' 
    And   there is no caseload advisor for UKPRN '10010033' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010033 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010033' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010033 Co Ltd' with UKPRN '10010033' and OrgId 'ORG0010033' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010033 | 110033 | 10010033 Co Ltd | 0              | Active                | Yes           | AA010033      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010033 |


    




    # Part 1: Create and approve 20/21 contract
    
    # Change the date
    Given the override date is '01/01/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-020'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-221'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010033 | 10010033 Co Ltd      | DFE-221             | 19TR20-221     | 1                     | 01/02/2021        | 31/07/2021      | 22463.00      |                                       | Contract for Services                      | 2021   | New          | ORG0010033 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-221     | 19TL-221      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 10876.00        |                                         |            |                                                             | New          |             |
    | 10010033 | 19TR20-221     | 19TR-221      | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 11587.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-221     | 19TL-221      | 1               | 0                     | 10876.00  | 1746.00  | 1089.00  | 2077.00  | 2813.00  | 1588.00  | 1563.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 
    | 10010033 | 19TR20-221     | 19TR-221      | 1               | 0                     | 11587.00  | 2038.00  | 1065.00  | 3002.00  | 892.00   | 1786.00  | 2804.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-221     | 1                     | 0                        | 2021-01-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-221'
#
#    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '19TR20-221' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-221' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | 19TR20-221         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10010033 | DFE-221           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-221' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-221'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-221        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-221        | 2355875          | Jul-21 | Reconciliation |

    Then wait '10' seconds

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10010033 | 19TR20-221     | 1               | 19TL-221      | 1               | 0                     | 10876.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding                | ?                                                           |
    | 10010033 | 19TR20-221     | 1               | 19TR-221      | 1               | 0                     | 11587.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-221' agree with the most recent entry for this contract in the ContractManagement feed

## Part 2: Create and approve 21/22 contract linked to 20/21 by Master
#
#    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-2211'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010033 | 10010033 Co Ltd      | DFE-221             | 19TR20-2211    | 1                     | 01/08/2021        | 31/07/2022      | 44392.00      |                                       | Contract for Services                      | 2122   | New          | ORG0018033 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2211    | 19TR-2211     | 19TRN2020         | 19TRN2020-2122          | AY                      | 01/08/2021          | 31/07/2022        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2211    | 19TR-2211     | 1               | 0                     | 44392.00  | 29439.00  | 14953.00  | 5969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010033 | 19TR20-2211    | 19TR-2211     | 4               | 1                     | 20345.00  | 15336.00  | 5009.00   | 3328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010033 | 19TR20-2211    | 19TR-2211     | 5               | 1                     | 24047.00  | 14103.00  | 9944.00   | 2641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-2211    | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-2211'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '19TR20-2211' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-2211' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | 19TR20-2211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010033 | DFE-221           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2211' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-2211'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-2211       | 100934           | Jul-22 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10010033 | 19TR20-2211    | 1               | 19TR-2211     | 1               | 0                     | 44392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
    | 10010033 | 19TR20-2211    | 1               | 19TR-2211     | 4               | 1                     | 20345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
    | 10010033 | 19TR20-2211    | 1               | 19TR-2211     | 5               | 1                     | 24047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2211' agree with the most recent entry for this contract in the ContractManagement feed

    
## Part 3: Create and approve 22/23 contract linked to Master
#
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-2212'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010033 | 10010033 Co Ltd      | DFE-221             | 19TR20-2212    | 1                     | 01/08/2022        | 31/07/2023      | 46392.00      |                                       | Contract for Services                      | 2223   | New          | ORG0018033 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2212    | 19TR-2212     | 19TRN2020         | 19TRN2020-2223          | AY                      | 01/08/2022          | 31/07/2023        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2212    | 19TR-2212     | 1               | 0                     | 46392.00  | 29439.00  | 14953.00  | 7969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010033 | 19TR20-2212    | 19TR-2212     | 4               | 1                     | 21345.00  | 15336.00  | 5009.00   | 4328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010033 | 19TR20-2212    | 19TR-2212     | 5               | 1                     | 25047.00  | 14103.00  | 9944.00   | 3641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-2212    | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-2212'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '19TR20-2212' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-2212' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | 19TR20-2212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010033 | 19TR20-2211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010033 | DFE-221           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2212' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-2212'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-2212       | 100934           | Jul-23 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
   Then  the Legal Contract CM feed contains the following '3' deliverables
   | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
   | 10010033 | 19TR20-2212    | 1               | 19TR-2212     | 1               | 0                     | 46392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
   | 10010033 | 19TR20-2212    | 1               | 19TR-2212     | 4               | 1                     | 21345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
   | 10010033 | 19TR20-2212    | 1               | 19TR-2212     | 5               | 1                     | 25047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

   # Test CRM details against same in ContractManagement feed (30447)
   Then  the details in CRM for version '1' of contract '19TR20-2212' agree with the most recent entry for this contract in the ContractManagement feed




    

    # Part 4: Create and approve 23/24 contract linked to Master

    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-1213'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010033 | 10010033 Co Ltd      | DFE-221             | 19TR20-2213    | 1                     | 01/08/2023        | 31/07/2024      | 46392.00      |                                       | Contract for Services                      | 2324   | New          | ORG0010033 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2213    | 19TR-2213     | 19TRN2020         | 19TRN2020-2324          | AY                      | 01/08/2023          | 31/07/2024        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2213    | 19TR-2213     | 1               | 0                     | 48392.00  | 29439.00  | 14953.00  | 9969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010033 | 19TR20-2213    | 19TR-2213     | 4               | 1                     | 22345.00  | 15336.00  | 5009.00   | 5328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010033 | 19TR20-2213    | 19TR-2213     | 5               | 1                     | 26047.00  | 14103.00  | 9944.00   | 4641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-2213    | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-2213'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '19TR20-2213' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-2213' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | 19TR20-2213        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10010033 | 19TR20-2212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010033 | 19TR20-2211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010033 | DFE-221            | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2213' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-2213'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-2213       | 2355800           | Jul-24 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10010033 | 19TR20-2213    | 1               | 19TR-2213     | 1               | 0                     | 48392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
    | 10010033 | 19TR20-2213    | 1               | 19TR-2213     | 4               | 1                     | 22345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
    | 10010033 | 19TR20-2213    | 1               | 19TR-2213     | 5               | 1                     | 26047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2213' agree with the most recent entry for this contract in the ContractManagement feed




        # Part 4: Create and approve 24/25 contract linked to Master

    # Change the date
    Given the override date is '01/07/2024'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-221'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-2214'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010033 | 10010033 Co Ltd      | DFE-221             | 19TR20-2214    | 1                     | 01/08/2024        | 31/07/2025      | 46392.00      |                                       | Contract for Services                      | 2425   | New          | ORG0010033 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2214    | 19TR-2214     | 19TRN2020         | 19TRN2020-2425          | AY                      | 01/08/2024          | 31/07/2025        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010033 | 19TR20-2214    | 19TR-2214     | 1               | 0                     | 48392.00  | 29439.00  | 14953.00  | 9969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-25 Traineeships Total Funding     | New          |             | 
    | 10010033 | 19TR20-2214    | 19TR-2214     | 4               | 1                     | 22345.00  | 15336.00  | 5009.00   | 5328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-25 Traineeships                   | New          |             | 
    | 10010033 | 19TR20-2214    | 19TR-2214     | 5               | 1                     | 26047.00  | 14103.00  | 9944.00   | 4641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-25 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-2214    | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-2214'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '19TR20-2214' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-2214' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | 19TR20-2214        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010033 | 19TR20-2213        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10010033 | 19TR20-2212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010033 | 19TR20-2211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010033 | DFE-221            | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2214' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-2214'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-2214       | 2355800           | Jul-25 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10010033 | 19TR20-2214    | 1               | 19TR-2214     | 1               | 0                     | 48392.00     | 0             | 0        | 19-25 Traineeships Total Funding         | ?                         |
    | 10010033 | 19TR20-2214    | 1               | 19TR-2214     | 4               | 1                     | 22345.00     | 0             | 0        | 19-25 Traineeships                       | ?                         |
    | 10010033 | 19TR20-2214    | 1               | 19TR-2214     | 5               | 1                     | 26047.00     | 0             | 0        | 19-25 Traineeships Learner Support       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-2214' agree with the most recent entry for this contract in the ContractManagement feed

    
       
#
#
#
#


#        # Part 4: Bulk load 'New Amendment' for 25/26. Publish and approve
#
#    # Change the date
    Given the override date is '01/07/2025'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10010033' in the Sharepoint '19TRN2020-2526-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2526 17072023092059 v3_Ak033' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2526 17072023092059 v3_Ak033' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2526 17072023092059 v3_Ak033' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2526 17072023092059 v3_Ak033' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2526 17072023092059 v3_Ak033.xlsx' exists in the Datafiles folder and UKPRN '10010033' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010033' for FundingType '19TRN2020' and period '2526' and Delivery Organisation 'ORG0010033'
    When  I retrieve the latest contract details from CRM for provider '10010033' for FundingType '19TRN2020' and period '2526'

#Check the contents of the Appendices (SoF, TAC, Sch1, Sch2, FA, Sch3ON)
   #Then  the file named '10010033_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2526-Input-Appendices' contains the following lines in order
#Then  the file named '10010033_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2526-Input-Appendices' contains the following lines in order
#   """
#   SUMMARY OF FUNDING
#   Organisation Name: 10010033 Co Ltd UKPRN: 10010033
#   Master Contract Number: DFE-221
#   Allocation
#   1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
#   19 to 25 Traineeships - 2020 Procurement 19TR-121 £3,103 £8,484 £11,587
#   19 to 25 Traineeships - 2020 Procurement - Learner Support 19TL-121 £2,835 £8,041 £10,876
#   Total: £22,463
#   Allocation
#   1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
#   19 to 25 Traineeships - 2020 Procurement 19TR-1211 £29,439 £14,953 £44,392
#   of which Learner Support £14,103 £9,944 £25,047
#   Total: £44,392
#   Allocation
#   1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
#   19 to 25 Traineeships - 2020 Procurement 19TR-1212 £31,439 £14,953 £46,392
#   of which Learner Support £15,103 £9,944 £26,047
#   Total: £46,392
#
#   Allocation
#   1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 25 Apr 25 - Jul 25 Total
#   19 to 25 Traineeships - 2020 Procurement 19TR-1213 £33,439 £14,953 £48,392
#   of which Learner Support £16,103 £9,944 £26,047
#   Total: £48,392
#   1 August 2024 to 31 July 2025 Contract Ref Aug 25 - Mar 26 Apr 26 - Jul 26 Total
#   19 to 25 Traineeships - 2020 Procurement [AllocRef_19TR] £65,351 £28,397 £93,748
#   of which Learner Support £42,187 £17,495 £59,682
#   Total: £93,748
#
#   Total Funding for this contract: £255,387
#   Summary of Funding – Page 1
#   Agreement Type Contract for Services
#   Funding for 19 to 25 Traineeships
#   Master Contract Number DFE-221
#   This Contract is made on the date the Contract is digitally signed by the
#   Contractor on the Manage Your Education & Skills Funding Service between:
#   10010033 Co Ltd THE SECRETARY OF STATE FOR
#   345 The Meadway EDUCATION
#   Tilehurst DEPARTMENT FOR EDUCATION
#   Reading 20 GREAT SMITH STREET
#   AND
#   Berkshire LONDON
#   RG30 4NU SW1P 3BT
#   Company No: AA010021
#   Hereinafter called Hereinafter called
#   the Contractor the Department
#   19 to 25 Traineeships
#   Version 6 – July 2024 – Page 2
#   19 to 25 Traineeships
#   Version 6 – July 2024 – Page 77
#
#   SCHEDULE 1: SPECIFICATION & MONITORING
#   19 TO 25-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
#   TRAINEESHIPS SPECIFICATION
#   19 to 25 Traineeships Schedule 1
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 1
#   Version 5 – July 2024 – Page 13
#
#   SCHEDULE 2: PAYMENT
#   19 to 25 Traineeships Schedule 2
#   Version 6 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 2
#   Version 6 – July 2024 – Page 2
#
#   SCHEDULE 2
#   Funding Agreement – 19 to 25 Traineeships - 2020 Procurement
#   Provider: 10010033 Co Ltd UKPRN: 10010033
#   Master Contract Number: DFE-121 Start Date: 01/08/2024 End Date: 31/07/2025
#   Contract Ref: [AllocRef_19TR]
#   Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#   19 to 25 Traineeships - 2020 Procurement £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141
#   of which Learner Support £59,682 £353 £3,771 £5,692 £7,880 £5,045 £7,710 £5,555 £6,181 £2,190 £374 £7,933 £6,998
#   Total Funding £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141
#
#   SCHEDULE 3: CHANGE CONTROL PROCEDURE
#   19 to 25 Traineeships Schedule 3
#   Version 5 – July 2024 – Page 1
#   
#   SCHEDULE 4: TUPE
#   19 to 25 Traineeships Schedule 4
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 4
#   Version 5 – July 2024 – Page 21
#   
#   SCHEDULE 5: UK GDPR AND DATA PROTECTION
#   19 to 25 Traineeships Schedule 5
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 5
#   Version 5 – July 2024 – Page 2
#   
#   SCHEDULE 6: SECURITY & DEPARTMENT POLICIES
#   19 to 25 Traineeships Schedule 6
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 6
#   Version 5 – July 2024 – Page 8
#   
#   SCHEDULE 7: EXIT ARRANGEMENTS
#   19 to 25 Traineeships Schedule 7
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 7
#   Version 5 – July 2024 – Page 5
#   
#   SCHEDULE 8: SUBCONTRACTING
#   19 to 25 Traineeships Schedule 8
#   Version 5 – July 2024 – Page 1
#   19 to 25 Traineeships Schedule 8
#   Version 5 – July 2024 – Page 5
#   
#   SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
#   19 to 25 Traineeships Schedule 9
#   Version 5 – July 2024 – Page 1
#
#   """
#
#
#

    

    


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010033_[ContractNo]_v1.pdf' in '19TRN2020-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK033.pdf'

    # Display Sharepoint filename
    And   message '10010033_[ContractNo]_v1.pdf' is written to the Output window


    # Publish and approve

    # Change the date
    Given the override date is '04/09/2025'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-221' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010033 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10010033 | 19TR20-2214        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010033 | 19TR20-2213	    | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
	| 10010033 | 19TR20-2212	    | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010033 | 19TR20-2211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010033 | DFE-221            | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-26 | Reconciliation |

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '3' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription     | 
#    | 10010033 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 0                     | 93748.00     | 0             | 0        | 19-25 Traineeships Total Funding      | ?                          |
#    | 10010033 | [ContractNo]   | 1               | [AllocRef_19TR] | 4               | 1                     | 34066.00     | 0             | 0        | 19-25 Traineeships                    | ?                          |
#    | 10010033 | [ContractNo]   | 1               | [AllocRef_19TR] | 5               | 1                     | 59682.00     | 0             | 0        | 19-25 Traineeships Learner Support    | ?                          |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

   
    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93748.00  | 1726.00  | 4485.00  | 12605.00 | 9985.00  | 5674.00  | 14878.00 | 6895.00  | 9103.00  | 2479.00  | 610.00   | 14167.00 | 11141.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 34066.00  | 1373.00  | 714.00   | 6913.00  | 2105.00  | 629.00   | 7168.00  | 1340.00  | 2922.00  | 289.00   | 236.00   | 6234.00  | 4143.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 59682.00  | 353.00   | 3771.00  | 5692.00  | 7880.00  | 5045.00  | 7710.00  | 5555.00  | 6181.00  | 2190.00  | 374.00   | 7933.00  | 6998.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    
    # Tidy up
    Given the override date is reset
  
   

    # Part 7: Add 23/25 actuals and check financials in CRM and PaaS

    # Add actuals to the contract for 19TRN2020-2324

    # Change the date
    Given the override date is '04/07/2025'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010033'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2023
     And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 574.70      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 458.03      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 929.43      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 947.96      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1203.59     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 674.97      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202508 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 530.40      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 452.25      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 581.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 430.54      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 407.05      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1204.67     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1239.75     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202509 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 1272.68     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 993.75      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 417.79      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 993.24      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 1396.04     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 284.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1374.80     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202510 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 695.78      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 1130.28     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 1118.83     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 323.91      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 1055.75     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1240.86     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1278.10     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202511 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 1185.53     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 1015.18     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 292.31      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 1396.98     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 571.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1441.15     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1074.04     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202512 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 685.44      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 617.93      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 379.70      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 1088.52     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 464.05      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 878.34      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1122.23     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202601 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 852.22      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 511.65      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 532.00      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 584.39      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 1258.76     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 725.45      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 902.85      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202602 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 497.53      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 1254.74     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 593.77      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 791.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 1412.58     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 828.04      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.11     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202603 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 870.40      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 766.41      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 558.56      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 475.86      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 889.60      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1260.86     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.56     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202604 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 800.47      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 947.59      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 803.99      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 263.33      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 1284.04     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 572.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 264.12      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202605 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 939.64      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 1147.53     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 617.47      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 286.17      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 716.34      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 1351.41     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 466.33      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202606 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 920.55      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 2               | 0            | 1082.79     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 3               | 0            | 1255.81     |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 6               | 0            | 554.48      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 7               | 0            | 314.63      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 8               | 0            | 487.52      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 9               | 0            | 593.15      |
    | ILR2526        | R03                  | ORG0010033     | CM             | 202607 | 19TRN2020-2526          | [AllocRef_19TR]          | ?          | 10              | 0            | 1450.22     |
                                                                                                                   
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26  | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93,748.00 | 1726.00  | 4485.00  | 12605.00 | 9985.00  | 5674.00  | 14878.00 | 6895.00  | 9103.00  | 2479.00  | 610.00   | 14167.00 | 11141.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 34066.00  | 1373.00  | 714.00   | 6913.00  | 2105.00  | 629.00   | 7168.00  | 1340.00  | 2922.00  | 289.00   | 236.00   | 6234.00  | 4143.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 59682.00  | 353.00   | 3771.00  | 5692.00  | 7880.00  | 5045.00  | 7710.00  | 5555.00  | 6181.00  | 2190.00  | 374.00   | 7933.00  | 6998.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26  | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26  | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26  | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-25    | Sep-25    | Oct-25    | Nov-25    | Dec-25    | Jan-26    | Feb-26    | Mar-26    | Apr-26    | May-26    | Jun-26    | Jul-26   | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 100932                   | 929.43    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 100933                   | 947.96    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 100934                   | 1203.59   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 100935                   | 674.97    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 100936                   | 530.40    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 2355800                  | 574.70    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10010033 | [ContractNo]   | [AllocRef_19TR]    | 2355860                  | 458.03    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



   



    # Tidy Up
    Given the override date is reset 