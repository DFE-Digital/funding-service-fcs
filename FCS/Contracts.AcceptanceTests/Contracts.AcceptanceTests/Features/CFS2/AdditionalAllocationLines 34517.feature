Feature: AdditionalAllocationLines 34517

@AcceptanceTest @Manual
@CFS
Scenario: A166 Import and release NFF FA with new line for NFF-005. Publish and approve. Check docs, financials and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017166'
    And   there is no Funding Allocation data in CRM for UKPRN '10017166'
    And   there is no Contract, Task or Workflow data for UKPRN '10017166'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017166'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017166'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017166' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017166' 
    And   there is no caseload advisor for UKPRN '10017166' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017166 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017166' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017166 Co Ltd' with UKPRN '10017166' and OrgId 'ORG0017166' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017166 | 117166 | 10017166 Co Ltd | 0              | Active                | Yes           | AA017166      | ?             | 26 Linford Forum       | Rockingham Drive       | Linford Wood           | Central Milton Keynes  | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017166 |





    # Populate the stub with NFF (06SDC) data

    # Change the date 
    Given the override date is '01/09/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017166 | NFF-AS-2122-Contract-Provider-10017166-3_3            | 3_3            | NFF                         | AS-2122            | 40493.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10017166-3_3   | 3_3                    | NFF-AS-2122-Contract-Provider-10017166-3_3            | 10017166      | Furth        | 06SDC           | 40493.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10017166-3_3   | NFF-003         | 8069.00          | Payment         |
    | NFF-AS-2122-10017166-3_3   | NFF-004         | 5942.00          | Payment         |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | 26482.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10017166-3_3   | NFF-003         | FY-2122              | November               | 2021              | 3038.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-003         | FY-2122              | April                  | 2022              | 5031.00                   |
    #
    | NFF-AS-2122-10017166-3_3   | NFF-004         | FY-2122              | January                | 2022              | 5942.00                   |
    #
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | August                 | 2021              | 5162.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | November               | 2021              | 2229.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | December               | 2021              | 3025.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | March                  | 2022              | 5701.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | April                  | 2022              | 5674.00                   |
    | NFF-AS-2122-10017166-3_3   | NFF-005         | FY-2122              | July                   | 2022              | 4691.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/09/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017166 | 10017166 Co Ltd  | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 40493.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2122-Contract-Provider-10017166-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40493.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017166 | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | AS-2122 | NFF                         | 40493.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/09/2021'

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
    | Released          | 1               | 40493.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017166' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017166' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017166 | 10017166 Co Ltd  | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released          | Released          | 40493.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2122-Contract-Provider-10017166-3_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NFF-AS-2122-Contract-Provider-10017166-3_3              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-Provider-10017166-3_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017166 | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | AS-2122 | NFF                         | 40493.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2122-Contract-Provider-10017166-3_3              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017166 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017166 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017166 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40493.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017166 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017166 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017166 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017166 | [ContractNo]       | [AllocRef_16ED]  | ?                             | 40493.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED]| 89              | 8069.00   | 0.00     | 0.00     | 0.00     | 3038.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5031.00  | 0.00     | 0.00     | 0.00     | 16+ Factor Removal (DSG) SSF                                |                          |
    | [ContractNo]   | [AllocRef_16ED]| 119             | 5942.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5942.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Maths Centre for Excellence 1619                            |                          |
    | [ContractNo]   | [AllocRef_16ED]| 155             | 26482.00  | 5162.00  | 0.00     | 0.00     | 2229.00  | 3025.00  | 0.00     | 0.00     | 5701.00  | 5674.00  | 0.00     | 0.00     | 4691.00  | Employer Incentive Fund for T-level                         |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF, T&C, Sch1, Sch2, FA, Sch3)
    And   the file named '10017166_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017166 Co Ltd UKPRN: 10017166
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £25,097 £15,396 £40,493
    Total Funding for this contract: £40,493
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017166 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017166 Co Ltd THE SECRETARY OF STATE FOR
    26 Linford Forum EDUCATION
    Rockingham Drive DEPARTMENT FOR EDUCATION
    Linford Wood 20 GREAT SMITH STREET
    AND
    Central Milton Keynes LONDON
    MK14 6LY SW1P 3BT
    Company No: AA017166
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017166 Co Ltd UKPRN: 10017166
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16+ Factor Removal (DSG) SSF £8,069 £0.00 £0.00 £0.00 £3,038.00 £0.00 £0.00 £0.00 £0.00 £5,031.00 £0.00 £0.00 £0.00
    Maths Centre for Excellence 1619 £5,942 £0.00 £0.00 £0.00 £0.00 £0.00 £5,942.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Employer Incentive Fund for T-level £26,482 £5,162.00 £0.00 £0.00 £2,229.00 £3,025.00 £0.00 £0.00 £5,701.00 £5,674.00 £0.00 £0.00 £4,691.00
    Total Funding £40,493 £5,162.00 £0.00 £0.00 £5,267.00 £3,025.00 £5,942.00 £0.00 £5,701.00 £10,705.00 £0.00 £0.00 £4,691.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017166_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A166.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-09-05 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017166'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017166 - 10017166 Co Ltd Awaiting documentation  | [AllocRef_16ED]| Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017166 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017166 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017166 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract

    # Change the date 
    Given the override date is '07/09/2021'

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
    | 10017166 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017166 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017166 | 10017166 Co Ltd  | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved | 40493.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017166 | NFF-AS-2122-Contract-Provider-10017166-3_3              | 3_3            | AS-2122 | NFF                         | 40493.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NFF-AS-2122-Contract-Provider-10017166-3_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017166 | [ContractNo]   | 1               | [AllocRef_16ED]| 89              | 0                     | 8069.00      | 0             | 0        | 16+ Factor Removal (DSG) SSF                   | ?                           |
    | 10017166 | [ContractNo]   | 1               | [AllocRef_16ED]| 119             | 0                     | 5942.00      | 0             | 0        | Maths Centre for Excellence 1619               | ?                           |
    | 10017166 | [ContractNo]   | 1               | [AllocRef_16ED]| 155             | 0                     | 26482.00     | 0             | 0        | Employer Incentive Fund for T-level            | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A167 Import and release a 1619 FA with new line for 1619-025 (Schoo/08SSF) > Deliverable 146. Check docs, financials and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017167'
    And   there is no Funding Allocation data in CRM for UKPRN '10017167'
    And   there is no Contract, Task or Workflow data for UKPRN '10017167'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017167'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017167'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017167' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017167' 
    And   there is no caseload advisor for UKPRN '10017167' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017167 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017167' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017167 Co Ltd' with UKPRN '10017167' and OrgId 'ORG0017167' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017167 | 117167 | 10017167 Co Ltd | 0              | Active                | Yes           | AA017167      | ?             | 9 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017167 |





    # Populate the stub with 1619 (08SSF) data

    # Change the date 
    Given the override date is '01/09/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017167 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7  | 1_7            | 1619                        | AS-2122            | 27443.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017167-1_7  | 1_7                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7  | 10017167      | Schoo        | 08SSF           | 27443.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017167-1_7  | 1619-006        | 4753.00          | Payment         |
    | 1619-AS-2122-10017167-1_7  | 1619-011        | 11451.00         | Payment         |
    | 1619-AS-2122-10017167-1_7  | 1619-025        | 11239.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017167-1_7  | 1619-006        | FY-2122              | April                  | 2022              | 4753.00                   |
    #
    | 1619-AS-2122-10017167-1_7  | 1619-011        | FY-2122              | September              | 2021              | 2346.00                   |
    | 1619-AS-2122-10017167-1_7  | 1619-011        | FY-2122              | November               | 2021              | 3003.00                   |
    | 1619-AS-2122-10017167-1_7  | 1619-011        | FY-2122              | February               | 2022              | 3970.00                   |
    | 1619-AS-2122-10017167-1_7  | 1619-011        | FY-2122              | June                   | 2022              | 2132.00                   |
    #
    | 1619-AS-2122-10017167-1_7  | 1619-025        | FY-2122              | October                | 2021              | 3590.00                   |
    | 1619-AS-2122-10017167-1_7  | 1619-025        | FY-2122              | March                  | 2022              | 3119.00                   |
    | 1619-AS-2122-10017167-1_7  | 1619-025        | FY-2122              | June                   | 2022              | 4530.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/09/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017167 | 10017167 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 27443.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 27443.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017167 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | AS-2122 | 1619                        | 27443.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/09/2021'

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
    | Released          | 1               | 27443.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017167' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017167' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017167 | 10017167 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 27443.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017167 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | AS-2122 | 1619                        | 27443.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017167 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017167 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017167 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 27443.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017167 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017167 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017167 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017167 | [ContractNo]       | [AllocRef_16ED]  | ?                             | 27443.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED]| 22              | 4753.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4753.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED]| 51              | 11451.00  | 0.00     | 2346.00  | 0.00     | 3003.00  | 0.00     | 0.00     | 3970.00  | 0.00     | 0.00     | 0.00     | 2132.00  | 0.00     | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED]| 146             | 11239.00  | 0.00     | 0.00     | 3590.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3119.00  | 0.00     | 0.00     | 4530.00  | 0.00     | SSF Tuition Fund                                            |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017167_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017167 Co Ltd UKPRN: 10017167
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED]£16,028 £11,415 £27,443
    Total Funding for this contract: £27,443
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017167 Co Ltd
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
    acting through the Education and Skills Funding Agency
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 2 (July 2021) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017167 Co Ltd THE SECRETARY OF STATE FOR
    9 Merchants Place EDUCATION ACTING THROUGH
    Reading THE EDUCATION AND SKILLS
    Berkshire FUNDING AGENCY, AN
    RG1 1DP EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    Company No: AA017167 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (July 2021) Page 2
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017167 Co Ltd UKPRN: 10017167
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £4,753 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,753.00 £0.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £11,451 £0.00 £2,346.00 £0.00 £3,003.00 £0.00 £0.00 £3,970.00 £0.00 £0.00 £0.00 £2,132.00 £0.00
    SSF Tuition Fund £11,239 £0.00 £0.00 £3,590.00 £0.00 £0.00 £0.00 £0.00 £3,119.00 £0.00 £0.00 £4,530.00 £0.00
    Total Funding £27,443 £0.00 £2,346.00 £3,590.00 £3,003.00 £0.00 £0.00 £3,970.00 £3,119.00 £4,753.00 £0.00 £6,662.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017167_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A167.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017167'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017167 - 10017167 Co Ltd Awaiting documentation  | [AllocRef_16ED]| Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017167 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017167 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017167 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/09/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '09/09/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017167 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017167 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017167 | 10017167 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 27443.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_LA]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017167 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | 1_7            | AS-2122 | 1619                        | 27443.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017167-1_7    | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017167 | [ContractNo]   | 1               | [AllocRef_16ED]| 22              | 0                     | 4753.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017167 | [ContractNo]   | 1               | [AllocRef_16ED]| 51              | 0                     | 11451.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017167 | [ContractNo]   | 1               | [AllocRef_16ED]| 146             | 0                     | 11239.00     | 0             | 0        | SSF Tuition Fund                               | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A168 Import and release a 1619 FA with new line for 1619-025 (Furth/01GFE) > Deliverable 143. Check docs, financials and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017168'
    And   there is no Funding Allocation data in CRM for UKPRN '10017168'
    And   there is no Contract, Task or Workflow data for UKPRN '10017168'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017168'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017168'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017168' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017168' 
    And   there is no caseload advisor for UKPRN '10017168' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017168 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017168' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017168 Co Ltd' with UKPRN '10017168' and OrgId 'ORG0017168' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017168 | 117168 | 10017168 Co Ltd | 0              | Active                | Yes           | AA017168      | ?             | 372a Palatine Road     | Northenden             | ?                      | ?                      | Manchester             | Greater Manchester     | M22 4FZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017168 |





    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017168 | 1619-AS-2122-Contract-Provider-10017168-3_4           | 3_4            | 1619                        | AS-2122            | 45312.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017168-3_4  | 3_4                    | 1619-AS-2122-Contract-Provider-10017168-3_4           | 10017168      | Furth        | 01GFE           | 45312.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017168-3_4  | 1619-004        | 16217.00         | Payment         |
    | 1619-AS-2122-10017168-3_4  | 1619-024        | 2764.00          | Payment         |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | 26331.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017168-3_4  | 1619-004        | FY-2122              | September              | 2021              | 3674.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-004        | FY-2122              | November               | 2021              | 5084.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-004        | FY-2122              | April                  | 2022              | 4854.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-004        | FY-2122              | June                   | 2022              | 2605.00                   |
    #
    | 1619-AS-2122-10017168-3_4  | 1619-024        | FY-2122              | January                | 2022              | 2764.00                   |
    #
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | August                 | 2021              | 5136.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | October                | 2021              | 2204.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | January                | 2022              | 3000.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | March                  | 2022              | 5676.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | April                  | 2022              | 5649.00                   |
    | 1619-AS-2122-10017168-3_4  | 1619-025        | FY-2122              | July                   | 2022              | 4666.00                   |
 
 
 
 
 
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

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017168 | 10017168 Co Ltd  | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 45312.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017168-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 45312.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017168 | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | AS-2122 | 1619                        | 45312.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 45312.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017168' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017168' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017168 | 10017168 Co Ltd  | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 45312.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017168-3_4             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017168-3_4             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017168-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017168 | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | AS-2122 | 1619                        | 45312.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017168-3_4             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017168 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017168 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017168 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 45312.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017168 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017168 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017168 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017168 | [ContractNo]       | [AllocRef_16ED]  | ?                             | 45312.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 16217.00  | 0.00     | 3674.00  | 0.00     | 5084.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4854.00  | 0.00     | 2605.00  | 0.00     | Residential Support Scheme                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 149             | 2764.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2764.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Uplift  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 143             | 26331.00  | 5136.00  | 0.00     | 2204.00  | 0.00     | 0.00     | 3000.00  | 0.00     | 5676.00  | 5649.00  | 0.00     | 0.00     | 4666.00  | 16-19 Tuition Fund                                          |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF, T&C, Sch1, Sch2, FA, Sch3)
    And   the file named '10017168_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017168 Co Ltd UKPRN: 10017168
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £27,538 £17,774 £45,312
    Total Funding for this contract: £45,312
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017168 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE COLLEGE REPRESENTS AND WARRANTS THAT THE COLLEGE HAS READ
    AND UNDERSTOOD THIS AGREEMENT, THE COLLEGE AGREES TO BE BOUND
    BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT
    THIS AGREEMENT AND LEGALLY BIND THE COLLEGE.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 2 (July 2021) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017168 Co Ltd THE SECRETARY OF STATE FOR
    372a Palatine Road EDUCATION ACTING THROUGH
    Northenden THE EDUCATION AND SKILLS
    Manchester FUNDING AGENCY, AN
    Greater Manchester EXECUTIVE AGENCY OF THE
    AND
    M22 4FZ DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017168 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 2 (July 2021) Page 2
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017168 Co Ltd UKPRN: 10017168
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Residential Support Scheme £16,217 £0.00 £3,674.00 £0.00 £5,084.00 £0.00 £0.00 £0.00 £0.00 £4,854.00 £0.00 £2,605.00 £0.00
    16-19 High Value Courses School and College £2,764 £0.00 £0.00 £0.00 £0.00 £0.00 £2,764.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Leavers Uplift
    16-19 Tuition Fund £26,331 £5,136.00 £0.00 £2,204.00 £0.00 £0.00 £3,000.00 £0.00 £5,676.00 £5,649.00 £0.00 £0.00 £4,666.00
    Total Funding £45,312 £5,136.00 £3,674.00 £2,204.00 £5,084.00 £0.00 £5,764.00 £0.00 £5,676.00 £10,503.00 £0.00 £2,605.00 £4,666.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017168_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A168.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017168'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017168 - 10017168 Co Ltd Awaiting documentation  | [AllocRef_16ED]| Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017168 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017168 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017168 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017168 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017168 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017168 | 10017168 Co Ltd  | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 45312.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017168 | 1619-AS-2122-Contract-Provider-10017168-3_4             | 3_4            | AS-2122 | 1619                        | 45312.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017168-3_4             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017168 | [ContractNo]   | 1               | [AllocRef_16ED]| 85              | 0                     | 16217.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017168 | [ContractNo]   | 1               | [AllocRef_16ED]| 149             | 0                     | 2764.00      | 0             | 0        | 16-19 High Value Courses School and College Leavers Uplift| ?                           |
    | 10017168 | [ContractNo]   | 1               | [AllocRef_16ED]| 143             | 0                     | 26331.00     | 0             | 0        | 16-19 Tuition Fund                             | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A506 Import and release an NMSS FA for 2122 inc new deliverables 200 and 201. Checks docs. Approve. Check financials and Feed.

    #  Process an NMSS FA containing all 10 allocation lines including new lines for
    #    NMSS-009 Recovery Premium (d200) and NMSS-010 Tutoring Grant (d201)

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017506'
    And   there is no Funding Allocation data in CRM for UKPRN '10017506'
    And   there is no Contract, Task or Workflow data for UKPRN '10017506'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017506'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017506'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017506' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017506' 
    And   there is no caseload advisor for UKPRN '10017506' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017506 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017506' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017506 Co Ltd' with UKPRN '10017506' and OrgId 'ORG0017506' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017506 | 117506 | 10017506 Co Ltd | 0              | Active                | Yes           | AA017506      | ?             | 5 Chiswick High Road   | London                 | ?                      | ?                      | ?                      | ?                      | W4 5RG    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017506 |







    # Populate the stub with NMSS (03SFC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017506 | NMSS-AY-2122-Contract-Provider-10017506-1_7           | 1_7            | NMSS                        | AY-2122            | 171005.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017506-1_7  | 1_7                    | NMSS-AY-2122-Contract-Provider-10017506-1_7           | 10017506      | Furth        | 03SFC           | 171005.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | 28919.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | 24348.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-003        | 12266.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-004        | 3297.00          | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | 22620.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-006        | 12978.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | 22725.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | 21500.00         | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-009        | 3921.00          | Payment         |
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | 18431.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | September              | 2021              | 5044.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | October                | 2021              | 4847.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | December               | 2021              | 4376.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | February               | 2022              | 5787.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | April                  | 2022              | 5557.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-001        | FY-2122              | June                   | 2022              | 3308.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | September              | 2021              | 5787.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | November               | 2021              | 5146.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | December               | 2021              | 3068.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | March                  | 2022              | 4238.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | April                  | 2022              | 3666.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-002        | FY-2122              | June                   | 2022              | 2443.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-003        | FY-2122              | November               | 2021              | 2997.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-003        | FY-2122              | January                | 2022              | 3724.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-003        | FY-2122              | July                   | 2022              | 5545.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-004        | FY-2122              | November               | 2021              | 3297.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | FY-2122              | September              | 2021              | 4527.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | FY-2122              | November               | 2021              | 5596.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | FY-2122              | February               | 2022              | 2390.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | FY-2122              | May                    | 2022              | 5067.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-005        | FY-2122              | July                   | 2022              | 5040.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-006        | FY-2122              | October                | 2021              | 3589.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-006        | FY-2122              | December               | 2021              | 4315.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-006        | FY-2122              | May                    | 2022              | 5074.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | September              | 2021              | 2370.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | October                | 2021              | 5388.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | January                | 2022              | 4336.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | February               | 2022              | 2429.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | April                  | 2022              | 4149.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-007        | FY-2122              | June                   | 2022              | 4053.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | FY-2122              | September              | 2021              | 2424.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | FY-2122              | November               | 2021              | 5987.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | FY-2122              | February               | 2022              | 5175.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | FY-2122              | May                    | 2022              | 3610.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-008        | FY-2122              | June                   | 2022              | 4304.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-009        | FY-2122              | October                | 2021              | 3921.00                   |
    #
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | FY-2122              | September              | 2021              | 4859.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | FY-2122              | November               | 2021              | 2268.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | FY-2122              | March                  | 2022              | 2039.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | FY-2122              | April                  | 2022              | 3791.00                   |
    | NMSS-AY-2122-10017506-1_7  | NMSS-010        | FY-2122              | July                   | 2022              | 5474.00                   |
 
 
 
 
 
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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017506 | 10017506 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 171005.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017506-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 171005.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017506 | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | AY-2122 | NMSS                        | 171005.00   | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 171005.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017506' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017506' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017506 | 10017506 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released          | 171005.00   | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017506-1_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017506-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017506 | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | AY-2122 | NMSS                        | 171005.00   | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017506-1_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017506 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017506 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017506 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 171005.00     | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017506 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017506 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017506 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017506 | [ContractNo]       | [AllocRef_16ED]  | ?                             | 171005.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 28919.00  | 0.00     | 5044.00  | 4847.00  | 0.00     | 4376.00  | 0.00     | 5787.00  | 0.00     | 5557.00  | 0.00     | 3308.00  | 0.00     | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 24348.00  | 0.00     | 5787.00  | 0.00     | 5146.00  | 3068.00  | 0.00     | 0.00     | 4238.00  | 3666.00  | 0.00     | 2443.00  | 0.00     | SSF High Needs Element 2                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 12266.00  | 0.00     | 0.00     | 0.00     | 2997.00  | 0.00     | 3724.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5545.00  | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 3297.00   | 0.00     | 0.00     | 0.00     | 3297.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 22620.00  | 0.00     | 4527.00  | 0.00     | 5596.00  | 0.00     | 0.00     | 2390.00  | 0.00     | 0.00     | 5067.00  | 0.00     | 5040.00  | Primary PE and Sport Premium                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 12978.00  | 0.00     | 0.00     | 3589.00  | 0.00     | 4315.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5074.00  | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 22725.00  | 0.00     | 2370.00  | 5388.00  | 0.00     | 0.00     | 4336.00  | 2429.00  | 0.00     | 4149.00  | 0.00     | 4053.00  | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 21500.00  | 0.00     | 2424.00  | 0.00     | 5987.00  | 0.00     | 0.00     | 5175.00  | 0.00     | 0.00     | 3610.00  | 4304.00  | 0.00     | Pupil Premium (NMSS)                                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 200             | 3921.00   | 0.00     | 0.00     | 3921.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Recovery Premium                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 201             | 18431.00  | 0.00     | 4859.00  | 0.00     | 2268.00  | 0.00     | 0.00     | 0.00     | 2039.00  | 3791.00  | 0.00     | 0.00     | 5474.00  | Tutoring Grant                                              |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017506_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017506 Co Ltd UKPRN: 10017506
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £109,924 £61,081 £171,005
    Total Funding for this contract: £171,005
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017506 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017506 Co Ltd THE SECRETARY OF STATE FOR
    5 Chiswick High Road EDUCATION
    London DEPARTMENT FOR EDUCATION
    AND
    W4 5RG 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017506
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017506 Co Ltd UKPRN: 10017506
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Bursary Funds £12,266 £0.00 £0.00 £0.00 £2,997.00 £0.00 £3,724.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,545.00
    SSF High Needs Element 2 £24,348 £0.00 £5,787.00 £0.00 £5,146.00 £3,068.00 £0.00 £0.00 £4,238.00 £3,666.00 £0.00 £2,443.00 £0.00
    NMF Pre-16 Funding (NMSS) £28,919 £0.00 £5,044.00 £4,847.00 £0.00 £4,376.00 £0.00 £5,787.00 £0.00 £5,557.00 £0.00 £3,308.00 £0.00
    Pre-16 Universal Infant Free School Meals £3,297 £0.00 £0.00 £0.00 £3,297.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Primary PE and Sport Premium £22,620 £0.00 £4,527.00 £0.00 £5,596.00 £0.00 £0.00 £2,390.00 £0.00 £0.00 £5,067.00 £0.00 £5,040.00
    Teachers Pay Grant (NMSS) £12,978 £0.00 £0.00 £3,589.00 £0.00 £4,315.00 £0.00 £0.00 £0.00 £0.00 £5,074.00 £0.00 £0.00
    Teachers Pension Scheme (NMSS) £22,725 £0.00 £2,370.00 £5,388.00 £0.00 £0.00 £4,336.00 £2,429.00 £0.00 £4,149.00 £0.00 £4,053.00 £0.00
    Pupil Premium (NMSS) £21,500 £0.00 £2,424.00 £0.00 £5,987.00 £0.00 £0.00 £5,175.00 £0.00 £0.00 £3,610.00 £4,304.00 £0.00
    Recovery Premium £3,921 £0.00 £0.00 £3,921.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Tutoring Grant £18,431 £0.00 £4,859.00 £0.00 £2,268.00 £0.00 £0.00 £0.00 £2,039.00 £3,791.00 £0.00 £0.00 £5,474.00
    Total Funding £171,005 £0.00 £25,011.00 £17,745.00 £25,291.00 £11,759.00 £8,060.00 £15,781.00 £6,277.00 £17,163.00 £13,751.00 £14,108.00 £16,059.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017506_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A506.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017506'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017506 - 10017506 Co Ltd Awaiting documentation  | [AllocRef_16ED]| Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017506 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017506 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017506 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017506 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017506 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017506 | 10017506 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 171005.00   | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017506 | NMSS-AY-2122-Contract-Provider-10017506-1_7             | 1_7            | AY-2122 | NMSS                        | 171005.00   | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017506-1_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 12266.00     | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 24348.00     | 0             | 0        | SSF High Needs Element 2                       | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 28919.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                      | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 22620.00     | 0             | 0        | Primary PE and Sport Premium                   | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 3297.00      | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 12978.00     | 0             | 0        | Teachers Pay Grant (NMSS)                      | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 22725.00     | 0             | 0        | Teachers Pension Scheme (NMSS)                 | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 21500.00     | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 3921.00      | 0             | 0        | Recovery Premium                               | ?                           |
    | 10017506 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 18431.00     | 0             | 0        | Tutoring Grant                                 | ?                           |



    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 12266.00  | 0.00     | 0.00     | 0.00     | 2997.00  | 0.00     | 3724.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5545.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 15              | 24348.00  | 0.00     | 5787.00  | 0.00     | 5146.00  | 3068.00  | 0.00     | 0.00     | 4238.00  | 3666.00  | 0.00     | 2443.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 39              | 28919.00  | 0.00     | 5044.00  | 4847.00  | 0.00     | 4376.00  | 0.00     | 5787.00  | 0.00     | 5557.00  | 0.00     | 3308.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 43              | 22620.00  | 0.00     | 4527.00  | 0.00     | 5596.00  | 0.00     | 0.00     | 2390.00  | 0.00     | 0.00     | 5067.00  | 0.00     | 5040.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 49              | 3297.00   | 0.00     | 0.00     | 0.00     | 3297.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 118             | 12978.00  | 0.00     | 0.00     | 3589.00  | 0.00     | 4315.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5074.00  | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 135             | 22725.00  | 0.00     | 2370.00  | 5388.00  | 0.00     | 0.00     | 4336.00  | 2429.00  | 0.00     | 4149.00  | 0.00     | 4053.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 140             | 21500.00  | 0.00     | 2424.00  | 0.00     | 5987.00  | 0.00     | 0.00     | 5175.00  | 0.00     | 0.00     | 3610.00  | 4304.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 200             | 3921.00   | 0.00     | 0.00     | 3921.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 201             | 18431.00  | 0.00     | 4859.00  | 0.00     | 2268.00  | 0.00     | 0.00     | 0.00     | 2039.00  | 3791.00  | 0.00     | 0.00     | 5474.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 12266.00  | 0.00     | 0.00     | 0.00     | 2997.00  | 0.00     | 3724.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5545.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 15              | 24348.00  | 0.00     | 5787.00  | 0.00     | 5146.00  | 3068.00  | 0.00     | 0.00     | 4238.00  | 3666.00  | 0.00     | 2443.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 39              | 28919.00  | 0.00     | 5044.00  | 4847.00  | 0.00     | 4376.00  | 0.00     | 5787.00  | 0.00     | 5557.00  | 0.00     | 3308.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 43              | 22620.00  | 0.00     | 4527.00  | 0.00     | 5596.00  | 0.00     | 0.00     | 2390.00  | 0.00     | 0.00     | 5067.00  | 0.00     | 5040.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 49              | 3297.00   | 0.00     | 0.00     | 0.00     | 3297.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 118             | 12978.00  | 0.00     | 0.00     | 3589.00  | 0.00     | 4315.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5074.00  | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 135             | 22725.00  | 0.00     | 2370.00  | 5388.00  | 0.00     | 0.00     | 4336.00  | 2429.00  | 0.00     | 4149.00  | 0.00     | 4053.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 140             | 21500.00  | 0.00     | 2424.00  | 0.00     | 5987.00  | 0.00     | 0.00     | 5175.00  | 0.00     | 0.00     | 3610.00  | 4304.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 200             | 3921.00   | 0.00     | 0.00     | 3921.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 201             | 18431.00  | 0.00     | 4859.00  | 0.00     | 2268.00  | 0.00     | 0.00     | 0.00     | 2039.00  | 3791.00  | 0.00     | 0.00     | 5474.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 12266.00  | 0.00     | 0.00     | 0.00     | 2997.00  | 0.00     | 3724.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5545.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 15              | 24348.00  | 0.00     | 5787.00  | 0.00     | 5146.00  | 3068.00  | 0.00     | 0.00     | 4238.00  | 3666.00  | 0.00     | 2443.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 39              | 28919.00  | 0.00     | 5044.00  | 4847.00  | 0.00     | 4376.00  | 0.00     | 5787.00  | 0.00     | 5557.00  | 0.00     | 3308.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 43              | 22620.00  | 0.00     | 4527.00  | 0.00     | 5596.00  | 0.00     | 0.00     | 2390.00  | 0.00     | 0.00     | 5067.00  | 0.00     | 5040.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 49              | 3297.00   | 0.00     | 0.00     | 0.00     | 3297.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 118             | 12978.00  | 0.00     | 0.00     | 3589.00  | 0.00     | 4315.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5074.00  | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 135             | 22725.00  | 0.00     | 2370.00  | 5388.00  | 0.00     | 0.00     | 4336.00  | 2429.00  | 0.00     | 4149.00  | 0.00     | 4053.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 140             | 21500.00  | 0.00     | 2424.00  | 0.00     | 5987.00  | 0.00     | 0.00     | 5175.00  | 0.00     | 0.00     | 3610.00  | 4304.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 200             | 3921.00   | 0.00     | 0.00     | 3921.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 201             | 18431.00  | 0.00     | 4859.00  | 0.00     | 2268.00  | 0.00     | 0.00     | 0.00     | 2039.00  | 3791.00  | 0.00     | 0.00     | 5474.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    |
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 100610             | 0.00      | 4859.00   | 0.00      | 2268.00   | 0.00      | 0.00      | 0.00      | 2039.00   | 3791.00   | 0.00      | 0.00      | 5474.00   | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 101007             | 0.00      | 0.00      | 3921.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2206037            | 0.00      | 0.00      | 0.00      | 2997.00   | 0.00      | 3724.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 5545.00   | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2219120            | 0.00      | 5787.00   | 0.00      | 5146.00   | 3068.00   | 0.00      | 0.00      | 4238.00   | 3666.00   | 0.00      | 2443.00   | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2520500            | 0.00      | 5044.00   | 4847.00   | 0.00      | 4376.00   | 0.00      | 5787.00   | 0.00      | 5557.00   | 0.00      | 3308.00   | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2520900            | 0.00      | 4527.00   | 0.00      | 5596.00   | 0.00      | 0.00      | 2390.00   | 0.00      | 0.00      | 5067.00   | 0.00      | 5040.00   | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2521300            | 0.00      | 0.00      | 0.00      | 3297.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2601005            | 0.00      | 0.00      | 3589.00   | 0.00      | 4315.00   | 0.00      | 0.00      | 0.00      | 0.00      | 5074.00   | 0.00      | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2601008            | 0.00      | 2370.00   | 5388.00   | 0.00      | 0.00      | 4336.00   | 2429.00   | 0.00      | 4149.00   | 0.00      | 4053.00   | 0.00      | 
    | 10017506 | [ContractNo]   | [AllocRef_16ED]    | 2602000            | 0.00      | 2424.00   | 0.00      | 5987.00   | 0.00      | 0.00      | 5175.00   | 0.00      | 0.00      | 3610.00   | 4304.00   | 0.00      | 


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

