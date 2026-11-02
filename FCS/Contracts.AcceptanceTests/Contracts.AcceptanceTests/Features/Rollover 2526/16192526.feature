Feature: 16192526

@AcceptanceTest @Withdrawn20251024
@CFS
Scenario: S068 Import, release and approve a 1619 new funding allocation for 25/26. AA_College. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
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
    | EDSK            | AY2526        | 16-19ED2526  | Accountability Agreement (College)   |

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
    | 1619-AS-2526-10018068-3_7  | 3_7                    | 1619-AS-2526-Contract-Provider-10018068-3_7           | 10018068      | Colleges                           | Further education                | 40507.00                  |
 
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
    | EDSK            | AY2526        | 16-19ED2526  | Accountability Agreement (College)           | AA_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window


    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | Education & Skills Funding | AY2526  | Accountability Agreement (College)      | 1619                        | 16-19ED2526     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | AS-2526 | 1619                        | 40507.00    | [AA_College]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 40507.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018068' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018068' for FundingType 'EDSK' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | Education & Skills Funding | AY2526  | Accountability Agreement (College)      | 1619                        | 16-19ED2526     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2526-Contract-Provider-10018068-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | AS-2526 | 1619                        | 40507.00    | [AA_College]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2526-Contract-Provider-10018068-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018068 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018068 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018068 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Accountability Agreement (College)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018068 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018068 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Accountability Agreement (College)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018068 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018068 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | 1619ED        | 1619ED2526          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    #And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    #| ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | DeliverableName                                                       | DeliverableDescription   |
    #| [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    #| [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

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
#    Agreement Type Accountability Agreement (College)
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
#    EDSK Accountability Agreement (College)
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
#    EDSK Accountability Agreement (College)
#    Version 2 - July 2024 - Page 2
#    EDSK Accountability Agreement (College)
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
    | [ContractNo]   | 1                     | 0                        | 2025-07-05 09:12:35.000 |

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
    | 10018068 | 10018068 Co Ltd  | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | Education & Skills Funding | AY2526  | Accountability Agreement (College)      | 1619                        | 16-19ED2526     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018068 | 1619-AS-2526-Contract-Provider-10018068-3_7             | 3_7            | AS-2526 | 1619                        | 40507.00    | [AA_College]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10018068-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    ## Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '2' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    #| 10018068 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    #| 10018068 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |



    # Part 7c: Payment Batch for ASF2526

    # Change the date
    Given the override date is '04/08/2025 22:05'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2526' AccountingPaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_16ED]          | 202508 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2526	             | 202508               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2526	         	 | 202508               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2526' PaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S068_1619ED.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09





        # Part 10: Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '03/01/2023 10:00'

   Given there are no files prefixed '2025-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   When  a Consolidated Payment Summary Report is created in Sharepoint for '04/08/2025'
    # Check the above report manually

   Then wait '10' seconds

   





    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
