Feature: CreateEDSKContracts 39177



@AcceptanceTest @Withdrawn20251024
@CFS
Scenario: S028 Import, release and approve a UIFSM funding allocation for 23/24 with deliverables 934 and 935. CofG_HEI. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018028'
    And   there is no Funding Allocation data in CRM for UKPRN '10018028'
    And   there is no Contract, Task or Workflow data for UKPRN '10018028'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018028'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018028'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018028' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018028' 
    And   there is no caseload advisor for UKPRN '10018028' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018028 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018028' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018028 Co Ltd' with UKPRN '10018028' and OrgId 'ORG0018028' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018028 | 118028 | 10018028 Co Ltd | 0              | Active                | Yes           | AA018028      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018028 |





    # Populate the stub with UIFSM (Higher education institutions) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018028 | UIFSM-AY-2324-Contract-Provider-10018028-3_7          | 3_7            | UIFSM                       | AY-2324            | 40507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2324-10018028-3_7 | 3_7                    | UIFSM-AY-2324-Contract-Provider-10018028-3_7          | 10018028      | Universities                       | Higher education institutions    | 40507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | 28311.00         | Payment         |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-002       | 12196.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | August                 | 2023              | 4572.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | November               | 2023              | 4888.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | January                | 2024              | 2879.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | February               | 2024              | 4904.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | April                  | 2024              | 5769.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-001       | FY-2324              | July                   | 2024              | 5299.00                   |
    #
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-002       | FY-2324              | August                 | 2023              | 2735.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-002       | FY-2324              | February               | 2024              | 5684.00                   |
    | UIFSM-AY-2324-10018028-3_7 | UIFSM-002       | FY-2324              | May                    | 2024              | 3777.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018028 | 10018028 Co Ltd  | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2324     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_HEI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018028 | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | AY-2324 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018028' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018028' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018028 | 10018028 Co Ltd  | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2324     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018028 | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | AY-2324 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018028 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018028 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018028 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018028 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018028 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018028 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018028 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10018028_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018028 Co Ltd UKPRN: 10018028
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
    Total Funding for this contract: £40,507
    Summary of Funding – Page 1
    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10018028 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
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
    EDSK Version 3 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10018028 Co Ltd THE SECRETARY OF STATE FOR
    102 Handside Lane EDUCATION
    Welwyn Garden City DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    AL8 6SY LONDON
    SW1P 3BT
    Company No: AA018028
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2023) Page 2
    EDSK Version 3 (September 2023) Page 76

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 HEI (July 2023) – Page 10

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
    16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10018028 Co Ltd UKPRN: 10018028
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572 £0 £0 £4,888 £0 £2,879 £4,904 £0 £5,769 £0 £0 £5,299
    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735 £0 £0 £0 £0 £0 £5,684 £0 £0 £3,777 £0 £0
    Total Funding £40,507 £7,307 £0 £0 £4,888 £0 £2,879 £10,588 £0 £5,769 £3,777 £0 £5,299
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2023) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2023) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2023) – Page 1

    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    PROCESSING, PERSONAL DATA AND DATA SUBJECTS
    EDSK Schedule 6 Version 2 (July 2023) – Page 2

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2023) – Page 8

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2023) – Page 5

    SCHEDULE 9: SUB-CONTRACTING
    EDSK Schedule 9 Version 2 (July 2023) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018028_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018028_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018028'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018028 - 10018028 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018028 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018028 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018028 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018028_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018028 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018028 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018028 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018028 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018028 | 10018028 Co Ltd  | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2324     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018028 | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | 3_7            | AY-2324 | UIFSM                       | 40507.00    | [CofG_HEI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2324-Contract-Provider-10018028-3_7            | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018028 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    | 10018028 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



@AcceptanceTest @Complete
@CFS
Scenario: S029 Import, release and approve an NMSS funding allocation for 23/24 with all seven deliverables. CofG_NMSS. Provider Subtype = 'Non-maintained special school'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018029'
    And   there is no Funding Allocation data in CRM for UKPRN '10018029'
    And   there is no Contract, Task or Workflow data for UKPRN '10018029'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018029'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018029'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018029' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (NMSS)    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018029' 
    And   there is no caseload advisor for UKPRN '10018029' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018029 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018029' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018029 Co Ltd' with UKPRN '10018029' and OrgId 'ORG0018029' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018029 | 118029 | 10018029 Co Ltd | 0              | Active                | Yes           | AA018029      | ?             | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018029 |







    # Populate the stub with NMSS (Non-maintained special school) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018029 | NMSS-AY-2324-Contract-Provider-10018029-4_1           | 4_1            | NMSS                        | AY-2324            | 91135.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NMSS-AY-2324-10018029-4_1  | 4_1                    | NMSS-AY-2324-Contract-Provider-10018029-4_1           | 10018029      | Special schools                    | Non-maintained special school    | 91135.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2324-10018029-4_1  | NMSS-001        | 15198.00         | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | 19843.00         | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-003        | 2920.00          | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-006        | 14248.00         | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-007        | 8488.00          | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-009        | 13407.00         | Payment         |
    | NMSS-AY-2324-10018029-4_1  | NMSS-010        | 17031.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2324-10018029-4_1  | NMSS-001        | FY-2324              | September              | 2023              | 4581.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-001        | FY-2324              | January                | 2024              | 2060.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-001        | FY-2324              | February               | 2024              | 2684.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-001        | FY-2324              | May                    | 2024              | 5873.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | August                 | 2023              | 2112.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | November               | 2023              | 2668.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | January                | 2024              | 3940.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | March                  | 2024              | 2000.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | April                  | 2024              | 5942.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-002        | FY-2324              | June                   | 2024              | 3181.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-003        | FY-2324              | February               | 2024              | 2920.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-006        | FY-2324              | September              | 2023              | 5388.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-006        | FY-2324              | December               | 2023              | 2524.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-006        | FY-2324              | March                  | 2024              | 3112.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-006        | FY-2324              | July                   | 2024              | 3224.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-007        | FY-2324              | November               | 2023              | 2069.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-007        | FY-2324              | December               | 2023              | 2726.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-007        | FY-2324              | July                   | 2024              | 3693.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-009        | FY-2324              | September              | 2023              | 5498.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-009        | FY-2324              | February               | 2024              | 3522.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-009        | FY-2324              | June                   | 2024              | 4387.00                   |
    #
    | NMSS-AY-2324-10018029-4_1  | NMSS-010        | FY-2324              | October                | 2023              | 3621.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-010        | FY-2324              | November               | 2023              | 5202.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-010        | FY-2324              | February               | 2024              | 4459.00                   |
    | NMSS-AY-2324-10018029-4_1  | NMSS-010        | FY-2324              | May                    | 2024              | 3749.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018029 | 10018029 Co Ltd  | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Scheduling        | Awaiting Release  | 91135.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10018029-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 91135.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018029 | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | AY-2324 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018029' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018029' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018029 | 10018029 Co Ltd  | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Released          | Released          | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10018029-4_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2324-Contract-Provider-10018029-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018029 | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | AY-2324 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2324-Contract-Provider-10018029-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018029 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018029 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 91135.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018029 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018029 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018029 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018029 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 91135.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15198.00  | 0.00     | 4581.00  | 0.00     | 0.00     | 0.00     | 2060.00  | 2684.00  | 0.00     | 0.00     | 5873.00  | 0.00     | 0.00     | NMF Pre-16 Funding (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 19843.00  | 2112.00  | 0.00     | 0.00     | 2668.00  | 0.00     | 3940.00  | 0.00     | 2000.00  | 5942.00  | 0.00     | 3181.00  | 0.00     | SSF High Needs Element 2 (NMSS)                                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 2920.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2920.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 14248.00  | 0.00     | 5388.00  | 0.00     | 0.00     | 2524.00  | 0.00     | 0.00     | 3112.00  | 0.00     | 0.00     | 0.00     | 3224.00  | Teachers Pay Grant (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 8488.00   | 0.00     | 0.00     | 0.00     | 2069.00  | 2726.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3693.00  | Teachers Pension Scheme (NMSS)                                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 200             | 13407.00  | 0.00     | 5498.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3522.00  | 0.00     | 0.00     | 0.00     | 4387.00  | 0.00     | Recovery Premium (NMSS)                                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 201             | 17031.00  | 0.00     | 0.00     | 3621.00  | 5202.00  | 0.00     | 0.00     | 4459.00  | 0.00     | 0.00     | 3749.00  | 0.00     | 0.00     | Tutoring Grant (NMSS)                                                 |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#    # check the contents of the appendices
    #Then the file named '10018029_[contractno]_v1.pdf' in sharepoint location 'edsk-2324-input-appendices' contains the following lines in order
      And   the file named '10018029_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018029 Co Ltd UKPRN: 10018029
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    16 to 19 Education [AllocRef_16ED] £61,086 £30,049 £91,135
    Total Funding for this contract: £91,135
    Summary of Funding – Page 1

    Agreement Type Non-Maintained Special Schools (NMSS)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10018029 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE NMSS
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency    
    EDSK NMSS Version 2 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    NMSS on the Manage Your Education & Skills Funding Service between:
    10018029 Co Ltd THE SECRETARY OF STATE FOR
    7a Deans Court EDUCATION
    Bicester DEPARTMENT FOR EDUCATION
    Oxon 20 GREAT SMITH STREET
    AND
    Oxfordshire LONDON
    OX6 7XZ SW1P 3BT
    Company No: AA018029
    Hereinafter called Hereinafter called
    the NMSS the Department
    EDSK NMSS Version 2 (September 2023) Page 2
    EDSK NMSS Version 2 (September 2023) Page 59
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 2 (November 2023) – Page 1
    EDSK Schedule 1 – NMSS Version 2 (November 2023) – Page 11
    
    SCHEDULE 2: PAYMENT
    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
    EDSK Schedule 2 – NMSS Version 1 (July 2023) – Page 1
    
    16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10018029 Co Ltd UKPRN: 10018029
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    SSF Bursary Funds £2,920 £0 £0 £0 £0 £0 £0 £2,920 £0 £0 £0 £0 £0
    SSF High Needs Element 2 £19,843 £2,112 £0 £0 £2,668 £0 £3,940 £0 £2,000 £5,942 £0 £3,181 £0
    NMF Pre-16 Funding £15,198 £0 £4,581 £0 £0 £0 £2,060 £2,684 £0 £0 £5,873 £0 £0
    Teachers Pay Grant £14,248 £0 £5,388 £0 £0 £2,524 £0 £0 £3,112 £0 £0 £0 £3,224
    Teachers Pension Scheme £8,488 £0 £0 £0 £2,069 £2,726 £0 £0 £0 £0 £0 £0 £3,693
    Recovery Premium £13,407 £0 £5,498 £0 £0 £0 £0 £3,522 £0 £0 £0 £4,387 £0
    Tutoring Grant £17,031 £0 £0 £3,621 £5,202 £0 £0 £4,459 £0 £0 £3,749 £0 £0
    Total Funding £91,135 £2,112 £15,467 £3,621 £9,939 £5,250 £6,000 £13,585 £5,112 £5,942 £9,622 £7,568 £6,917
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 - NMSS Version 1 (July 2023) – Page 1
    
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018029_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018029_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018029'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018029 - 10018029 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018029 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018029 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018029 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018029_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018029 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018029 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018029 | 10018029 Co Ltd  | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Contract Approved | Contract Approved | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018029 | NMSS-AY-2324-Contract-Provider-10018029-4_1             | 4_1            | AY-2324 | NMSS                        | 91135.00    | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10018029-4_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15198.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                                             | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 19843.00     | 0             | 0        | SSF High Needs Element 2 (NMSS)                                       | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 2920.00      | 0             | 0        | SSF Bursary Funds                                                     | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 14248.00     | 0             | 0        | Teachers Pay Grant (NMSS)                                             | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 8488.00      | 0             | 0        | Teachers Pension Scheme (NMSS)                                        | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 13407.00     | 0             | 0        | Recovery Premium (NMSS)                                               | ?                           |
    | 10018029 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 17031.00     | 0             | 0        | Tutoring Grant (NMSS)                                                 | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

  @AcceptanceTest @Inprogress
@CFS
Scenario: S030 Import, release and approve a PSG funding allocation for 23/24 with deliverable 43. CofG_SPI. Provider Subtype = 'Special post 16 institution'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018030'
    And   there is no Funding Allocation data in CRM for UKPRN '10018030'
    And   there is no Contract, Task or Workflow data for UKPRN '10018030'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018030'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018030'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018030' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (SPI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018030' 
    And   there is no caseload advisor for UKPRN '10018030' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018030 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018030' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018030 Co Ltd' with UKPRN '10018030' and OrgId 'ORG0018030' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018030 | 118030 | 10018030 Co Ltd | 0              | Locked Restructure    | Yes           | AA018030      | ?             | 5 Spurway Parade       | Woodford Avenue        | ?                      | ?                      | Ilford                 | Essex                  | IG2 6UU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018030 |







    # Populate the stub with PSG (Special post 16 institution) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018030 | PSG-AY-2324-Contract-Provider-10018030-3_2            | 3_2            | PSG                         | AY-2324            | 13205.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PSG-AY-2324-10018030-3_2   | 3_2                    | PSG-AY-2324-Contract-Provider-10018030-3_2            | 10018030      | Other types                        | Special post 16 institution      | 13205.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2324-10018030-3_2   | PSG-001 | 13205.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2324-10018030-3_2   | PSG-001 | FY-2324              | November               | 2023              | 3367.00                   |
    | PSG-AY-2324-10018030-3_2   | PSG-001 | FY-2324              | March                  | 2024              | 4265.00                   |
    | PSG-AY-2324-10018030-3_2   | PSG-001 | FY-2324              | May                    | 2024              | 5573.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018030 | 10018030 Co Ltd  | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Scheduling        | Awaiting Release  | 13205.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_SPI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10018030-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13205.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018030 | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | AY-2324 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018030' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018030' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018030 | 10018030 Co Ltd  | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Released          | Released          | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10018030-3_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PSG-AY-2324-Contract-Provider-10018030-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018030 | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | AY-2324 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2324-Contract-Provider-10018030-3_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018030 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018030 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018030 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 13205.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018030 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018030 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018030 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018030 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 13205.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Initial Payment) (NMSS)                                   |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#    # Check the contents of the Appendices
#    And   the file named '10018030_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2023/24
#    Organisation Name: 10018030 Co Ltd UKPRN: 10018030
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
#    16 to 19 Education [AllocRef_16ED] £7,632 £5,573 £13,205
#    Total Funding for this contract: £13,205
#    Summary of Funding – Page 1
#    
#    Agreement Type Specialist Post-16 Institution
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And 10018030 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement
#    [MasterContractNo]
#    Number
#    ACCEPTANCE BY THE PROVIDER
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Version 1  (July 2023) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018030 Co Ltd THE SECRETARY OF STATE FOR
#    5 Spurway Parade EDUCATION
#    Woodford Avenue DEPARTMENT FOR EDUCATION
#    Ilford 20 GREAT SMITH STREET
#    AND
#    Essex LONDON
#    IG2 6UU SW1P 3BT
#    Company No: AA018030
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Version 1 (July 2023) Page 2
#    EDSK Version 1 (July 2023) Page 71
#    
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2023) – Page 1
#    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2023) – Page 12
#
#    SCHEDULE 2: PAYMENT
#    16-19 EDUCATION PAYMENT
#    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
#    
#    SCHEDULE 2 – 16 TO 19 EDUCATION
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018030 Co Ltd UKPRN: 10018030
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Primary PE and Sport Premium £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
#    Total Funding £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
#    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 3 Version 1 (July 2023) – Page 1
#    EDSK Schedule 9 Version 1 (July 2023) – Page 5
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018030_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018030_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018030'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018030 - 10018030 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018030 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018030 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018030 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018030_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018030 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018030 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018030 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018030 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018030 | 10018030 Co Ltd  | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Contract Approved | Contract Approved | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018030 | PSG-AY-2324-Contract-Provider-10018030-3_2              | 3_2            | AY-2324 | PSG                         | 13205.00    | [CofG_SPI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10018030-3_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018030 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 13205.00     | 0             | 0        | Primary PE and Sport Premium (Initial Payment) (NMSS)                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table




@AcceptanceTest @Withdrawn_16Jan2026
@CFS
Scenario: S031 Import, release and approve a PP funding allocation for 23/24 with deliverable 140. AA_College. Provider Subtype = 'Further education'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018031'
    And   there is no Funding Allocation data in CRM for UKPRN '10018031'
    And   there is no Contract, Task or Workflow data for UKPRN '10018031'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018031'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018031'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018031' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Accountability Agreement (College)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018031' 
    And   there is no caseload advisor for UKPRN '10018031' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018031 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018031' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018031 Co Ltd' with UKPRN '10018031' and OrgId 'ORG0018031' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018031 | 118031 | 10018031 Co Ltd | 0              | Active                | Yes           | AA018031      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018031 |







    # Populate the stub with PP (Further education) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018031 | PP-FY-2324-Contract-Provider-10018031-4_3             | 4_3            | PP                          | FY-2324            | 7540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PP-FY-2324-10018031-4_3    | 4_3                    | PP-FY-2324-Contract-Provider-10018031-4_3             | 10018031      | Colleges                           | Further education                | 7540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PP-FY-2324-10018031-4_3    | PP-001          | 7540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PP-FY-2324-10018031-4_3    | PP-001          | FY-2324              | November               | 2023              | 4673.00                   |
    | PP-FY-2324-10018031-4_3    | PP-001          | FY-2324              | April                  | 2024              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Accountability Agreement (College)	   | AA_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018031 | 10018031 Co Ltd  | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | Education & Skills Funding | AY2324  | Accountability Agreement (College)	   | PP                          | 16-19ED2324     | Scheduling        | Awaiting Release  | 7540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2324-Contract-Provider-10018031-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 7540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018031 | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | FY-2324 | PP                          | 7540.00     | [AA_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018031' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018031' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018031 | 10018031 Co Ltd  | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | Education & Skills Funding | AY2324  | Accountability Agreement (College)  | PP                          | 16-19ED2324     | Released          | Released          | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2324-Contract-Provider-10018031-4_3               | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PP-FY-2324-Contract-Provider-10018031-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018031 | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | FY-2324 | PP                          | 7540.00     | [AA_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PP-FY-2324-Contract-Provider-10018031-4_3               | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018031 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018031 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 7540.00       | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018031 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018031 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Accountability Agreement (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018031 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018031 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 7540.00         | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 7540.00   | 0.00     | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10018031_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2023/23
#    Organisation Name: 10018031 Co Ltd UKPRN: 10018031
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2023/23 Total
#    16 to 19 Education [AllocRef_16ED] £4,673 £2,867 £7,540
#    Total Funding for this contract: £7,540
#    Summary of Funding – Page 1
#    
#    Agreement Type Conditions of Funding (Grant) (Colleges)
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And 10018031 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement Number [MasterContractNo]
#    ACCEPTANCE BY THE COLLEGE
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Version 3 (November 2023) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    College on the Manage Your Education & Skills Funding Service between:
#    10018031 Co Ltd THE SECRETARY OF STATE FOR
#    4 Arden Court EDUCATION
#    Arden Road DEPARTMENT FOR EDUCATION
#    Alcester 20 GREAT SMITH STREET
#    AND
#    Warwickshire LONDON
#    B49 6HN SW1P 3BT
#    Company No: AA018031
#    Hereinafter called Hereinafter called
#    the College the Department
#    EDSK Version 3 (November 2023) Page 2
#    EDSK Version 3 (November 2023) Page 74
#    
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2023) – Page 1
#    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2023) – Page 10
#    
#    SCHEDULE 2: PAYMENT
#    16-19 EDUCATION PAYMENT
#    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
#    
#    SCHEDULE 2 – 16 TO 19 EDUCATION
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018031 Co Ltd UKPRN: 10018031
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Pupil Premium £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
#    Total Funding £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
#    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 3 Version 3 (November 2023) – Page 1
#    
#    SCHEDULE 9: COLLEGE GOVERNANCE
#    4.4 The College must obtain the written consent of the Secretary of State
#    before entering into any new arrangements for Borrowing Money and for
#    any amendment to such arrangements from 29 November 2023 and
#    before entering into any amendment to arrangements for Borrowing
#    Money that existed before 29 November 2023. Failure to do so will amount
#    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
#    37) will apply.
#    EDSK Schedule 9 Version 3 (November 2023) – Page 2
#
#    SCHEDULE 10: SUB-CONTRACTING
#    EDSK Schedule 10 Version 3 (November 2023) – Page 5
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018031_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S031.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018031'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018031 - 10018031 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018031 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018031 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018031 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018031_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018031 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018031 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018031 | 10018031 Co Ltd  | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | Education & Skills Funding | AY2324  | Accountability Agreement (College)  | PP                          | 16-19ED2324     | Contract Approved | Contract Approved | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018031 | PP-FY-2324-Contract-Provider-10018031-4_3               | 4_3            | FY-2324 | PP                          | 7540.00     | [AA_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2324-Contract-Provider-10018031-4_3               | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018031 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 7540.00      | 0             | 0        | Pupil Premium (NMSS)                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Complete
@CFS
Scenario: S032 Import, release and approve a NFF funding allocation for 23/24 with deliverable 931. Contract for Services (ITP). Provider Subtype = 'Independent learning provider'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018032'
    And   there is no Funding Allocation data in CRM for UKPRN '10018032'
    And   there is no Contract, Task or Workflow data for UKPRN '10018032'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018032'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018032'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018032' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Contract for Services (ITP)			   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018032' 
    And   there is no caseload advisor for UKPRN '10018032' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018032 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018032' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018032 Co Ltd' with UKPRN '10018032' and OrgId 'ORG0018032' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018032 | 118032 | 10018032 Co Ltd | 0              | Active                | Yes           | AA018032      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018032 |







    # Populate the stub with NFF (Independent learning provider) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018032 | NFF-AS-2324-Contract-Provider-10018032-1_0            | 1_0            | NFF                         | AS-2324            | 8540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NFF-AS-2324-10018032-1_0   | 1_0                    | NFF-AS-2324-Contract-Provider-10018032-1_0            | 10018032      | 16-19 provider                     | Independent learning provider    | 8540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2324-10018032-1_0   | NFF-001         | 8540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2324-10018032-1_0   | NFF-001         | FY-2324              | August	               | 2023              | 1000.00                   |
    | NFF-AS-2324-10018032-1_0   | NFF-001         | FY-2324              | November               | 2023              | 4673.00                   |
    | NFF-AS-2324-10018032-1_0   | NFF-001         | FY-2324              | April                  | 2024              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Contract for Services (ITP)			   | Cfs_ITP	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs_ITP = [Cfs_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018032 | 10018032 Co Ltd  | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | Education & Skills Funding | AY2324  | Contract for Services (ITP)			   | NFF                         | 16-19ED2324     | Scheduling        | Awaiting Release  | 8540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs_ITP]    	 | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2324-Contract-Provider-10018032-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018032 | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | AS-2324 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018032' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018032' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018032 | 10018032 Co Ltd  | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | Education & Skills Funding | AY2324  | Contract for Services (ITP)			   | NFF                         | 16-19ED2324     | Released          | Released          | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs_ITP]	   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2324-Contract-Provider-10018032-1_0              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2324-Contract-Provider-10018032-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018032 | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | AS-2324 | NFF                         | 8540.00     | [Cfs_ITP]		  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2324-Contract-Provider-10018032-1_0              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018032 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018032 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018032 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 8540.00       | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Contract for Services (ITP)   | ?         | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018032 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018032 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Contract for Services (ITP)   | ?         | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018032 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018032 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 8540.00         | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 931             | 8540.00   | 1000.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Cadets Vocational Programme                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10018032_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2023/23
#    Organisation Name: 10018032 Co Ltd UKPRN: 10018032
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2023/23 Total
#    16 to 19 Education [AllocRef_16ED] £4,673 £2,867 £7,540
#    Total Funding for this contract: £7,540
#    Summary of Funding – Page 1
#    
#    Agreement Type Conditions of Funding (Grant) (16-19 provider)
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And 10018032 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement Number [MasterContractNo]
#    ACCEPTANCE BY THE COLLEGE
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Version 3 (November 2023) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    College on the Manage Your Education & Skills Funding Service between:
#    10018032 Co Ltd THE SECRETARY OF STATE FOR
#    4 Arden Court EDUCATION
#    Arden Road DEPARTMENT FOR EDUCATION
#    Alcester 20 GREAT SMITH STREET
#    AND
#    Warwickshire LONDON
#    B49 6HN SW1P 3BT
#    Company No: AA018032
#    Hereinafter called Hereinafter called
#    the College the Department
#    EDSK Version 3 (November 2023) Page 2
#    EDSK Version 3 (November 2023) Page 74
#    
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2023) – Page 1
#    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2023) – Page 10
#    
#    SCHEDULE 2: PAYMENT
#    16-19 EDUCATION PAYMENT
#    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
#    
#    SCHEDULE 2 – 16 TO 19 EDUCATION
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018032 Co Ltd UKPRN: 10018032
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Pupil Premium £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
#    Total Funding £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
#    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 3 Version 3 (November 2023) – Page 1
#    
#    SCHEDULE 9: COLLEGE GOVERNANCE
#    4.4 The College must obtain the written consent of the Secretary of State
#    before entering into any new arrangements for Borrowing Money and for
#    any amendment to such arrangements from 29 November 2023 and
#    before entering into any amendment to arrangements for Borrowing
#    Money that existed before 29 November 2023. Failure to do so will amount
#    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
#    37) will apply.
#    EDSK Schedule 9 Version 3 (November 2023) – Page 2
#
#    SCHEDULE 10: SUB-CONTRACTING
#    EDSK Schedule 10 Version 3 (November 2023) – Page 5
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018032_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018032_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018032'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018032 - 10018032 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018032 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018032 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018032 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018032_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018032 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018032 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018032 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018032 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018032 | 10018032 Co Ltd  | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | Education & Skills Funding | AY2324  | Contract for Services (ITP)			   | NFF                         | 16-19ED2324     | Contract Approved | Contract Approved | 8540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs_ITP]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018032 | NFF-AS-2324-Contract-Provider-10018032-1_0              | 1_0            | AS-2324 | NFF                         | 8540.00     | [Cfs_ITP]		  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2324-Contract-Provider-10018032-1_0              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10018032 | [ContractNo]   | 1               | [AllocRef_16ED]  | 931             | 0                     | 8540.00      | 0             | 0        | Cadets Vocational Programme                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


    
@AcceptanceTest @Complete
@CFS
Scenario: S033 Import, release and approve a 1416 funding allocation for 23/24 with deliverables 24, 25 and 111. AA(College). Provider Subtype = '06SDC'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018033'
    And   there is no Funding Allocation data in CRM for UKPRN '10018033'
    And   there is no Contract, Task or Workflow data for UKPRN '10018033'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018033'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018033'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018033' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (LA)	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018033' 
    And   there is no caseload advisor for UKPRN '10018033' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018033 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018033' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018033 Co Ltd' with UKPRN '10018033' and OrgId 'ORG0018033' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018033 | 118033 | 10018033 Co Ltd | 0              | Active                | Yes           | AA018033      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018033 |





    # Populate the stub with 1416 (Furth) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018033 | 1416-AY-2324-Contract-Provider-10018033-3_7           | 3_7            | 1416                        | AY-2324            | 50507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1416-AY-2324-10018033-3_7  | 3_7                    | 1416-AY-2324-Contract-Provider-10018033-3_7 	      | 10018033      | Local authority		               | Local authority							  | 50507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | 28311.00         | Payment         |
    | 1416-AY-2324-10018033-3_7  | 1416-002        | 12196.00         | Payment         |
    | 1416-AY-2324-10018033-3_7  | 1416-003        | 10000.00         | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | August                 | 2023              | 4572.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | November               | 2023              | 4888.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | January                | 2024              | 2879.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | February               | 2024              | 4904.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | April                  | 2024              | 5769.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-001        | FY-2324              | July                   | 2024              | 5299.00                   |
    #
    | 1416-AY-2324-10018033-3_7  | 1416-002        | FY-2324              | August                 | 2023              | 2735.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-002        | FY-2324              | February               | 2024              | 5684.00                   |
    | 1416-AY-2324-10018033-3_7  | 1416-002        | FY-2324              | May                    | 2024              | 3777.00                   |
    #
    | 1416-AY-2324-10018033-3_7  | 1416-003        | FY-2324              | August                 | 2023              | 10000.00                  |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (LA)      | CofG(LA)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(LA) = [CofG(LA)]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018033 | 10018033 Co Ltd  | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2324     | Scheduling        | Awaiting Release  | 50507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2324-Contract-Provider-10018033-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG(LA)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018033 | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | AY-2324 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    When  I retrieve the latest contract details from CRM for provider '10018033' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018033' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018033 | 10018033 Co Ltd  | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2324     | Released          | Released          | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2324-Contract-Provider-10018033-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1416-AY-2324-Contract-Provider-10018033-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018033 | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | AY-2324 | 1416                        | 50507.00    | [CofG(LA)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2324-Contract-Provider-10018033-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG(LA)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018033 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018033 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018033 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 50507.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018033 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018033 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (LA)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018033 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018033 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 50507.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 24              | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | 14-16 Programme Funding    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 25              | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | 14-16 Pupil Premium        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 111             | 10000.00  | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00	  | 0.00     | 0.00     | 0.00	   | 0.00     | 0.00     | 14-16 Service Child Premium|                          |


    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10018028_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2023/24
#    Organisation Name: 10018033 Co Ltd UKPRN: 10018033
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
#    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
#    Total Funding for this contract: £40,507
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (LA)
#    st st
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And 10018033 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement Number [MasterContractNo]
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
#    EDSK Version 1 (April 2023) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018033 Co Ltd THE SECRETARY OF STATE FOR
#    102 Handside Lane EDUCATION
#    Welwyn Garden City DEPARTMENT FOR EDUCATION
#    Hertfordshire AND 20 GREAT SMITH STREET
#    AL8 6SY LONDON
#    SW1P 3BT
#    Company No: AA018033
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Version 1 (April 2023) Page 2
#    EDSK Version 1 (April 2023) Page 77
#
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    EDSK Schedule 1 – 16 to 19 Education Version 1 HEI (July 2023) – Page 10
#
#    SCHEDULE 2: PAYMENT
#    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
#    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
#    SCHEDULE 2 – 16 TO 19 EDUCATION
#    Funding Agreement – 16 to 19 Education
#    Provider: 10018033 Co Ltd UKPRN: 10018033
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572.00 £0.00 £0.00 £4,888.00 £0.00 £2,879.00 £4,904.00 £0.00 £5,769.00 £0.00 £0.00 £5,299.00
#    Payment)
#    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,684.00 £0.00 £0.00 £3,777.00 £0.00 £0.00
#    Payment)
#    Total Funding £40,507 £7,307.00 £0.00 £0.00 £4,888.00 £0.00 £2,879.00 £10,588.00 £0.00 £5,769.00 £3,777.00 £0.00 £5,299.00
#    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 3 Version 1 (April 2023) – Page 1
#
#    SCHEDULE 4: NOT USED
#    EDSK Schedule 4 Version 1 (April 2023) – Page 1
#
#    SCHEDULE 5: NOT USED
#    EDSK Schedule 5 Version 1 (April 2023) – Page 1
#
#    SCHEDULE 6: UK GDPR AND DATA PROTECTION
#    PROCESSING, PERSONAL DATA AND DATA SUBJECTS
#    EDSK Schedule 6 Version 1 (April 2023) – Page 2
#
#    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
#    EDSK Schedule 7 Version 1 (April 2023) – Page 8
#
#    SCHEDULE 8: EXIT ARRANGEMENTS
#    EDSK Schedule 8 Version 1 (April 2023) – Page 5
#
#    SCHEDULE 9: SUB-CONTRACTING
#    EDSK Schedule 9 Version 1 (April 2023) – Page 5    
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018033_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018033_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018033'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018033 - 10018033 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018033 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018033 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018033 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018033_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018033 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018033 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018033 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018033 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018033 | 10018033 Co Ltd  | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2324     | Contract Approved | Contract Approved | 50507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG(LA)]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018033 | 1416-AY-2324-Contract-Provider-10018033-3_7             | 3_7            | AY-2324 | 1416                        | 50507.00    | [CofG(LA)]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2324-Contract-Provider-10018033-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '2' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10018033 | [ContractNo]   | 1               | [AllocRef_16ED]  | 24              | 0                     | 28311.00     | 0             | 0        | 14-16 Programme Funding    | ?                           |
#    | 10018033 | [ContractNo]   | 1               | [AllocRef_16ED]  | 25              | 0                     | 12196.00     | 0             | 0        | 14-16 Pupil Premium	      | ?                           |
#    | 10018033 | [ContractNo]   | 1               | [AllocRef_16ED]  | 111             | 0                     | 10000.00     | 0             | 0        | 14-16 Service Child Premium| ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

