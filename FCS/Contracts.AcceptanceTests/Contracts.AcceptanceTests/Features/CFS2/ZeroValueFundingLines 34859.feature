Feature: ZeroValueFundingLines 34859

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A648 Import and release a 1619 FA with zero-value and null-value lines. Publish and approve. Check CRM, docs, PaaS and Feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017648'
    And   there is no Funding Allocation data in CRM for UKPRN '10017648'
    And   there is no Contract, Task or Workflow data for UKPRN '10017648'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017648'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017648'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017648' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017648' 
    And   there is no caseload advisor for UKPRN '10017648' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017648 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017648' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017648 Co Ltd' with UKPRN '10017648' and OrgId 'ORG0017648' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017648 | 117648 | 10017648 Co Ltd | 0              | Active                | Yes           | AA017648      | ?             | 30 Silverdale Avenue   | Shadwell               | Leeds                  | ?                      | ?                      | ?                      | LS17 S52  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017648 |





    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017648 | 1619-AS-2122-Contract-Provider-10017648-1_3           | 1_3            | 1619                        | AS-2122            | 48947.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017648-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10017648-1_3           | 10017648      | Furth        | 01GFE           | 48947.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017648-1_3  | 1619-001        | 11489.00         | Payment         |
    | 1619-AS-2122-10017648-1_3  | 1619-005        | 18596.00         | Payment         |
    | 1619-AS-2122-10017648-1_3  | 1619-006        | 18862.00         | Payment         |
    # Zero-value Funding Line
    | 1619-AS-2122-10017648-1_3  | 1619-013        | 0.00             | Payment         |
    # Null-value Funding Line
    | 1619-AS-2122-10017648-1_3  | 1619-024        | ?                | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017648-1_3  | 1619-001        | FY-2122              | April                  | 2022              | 5479.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-001        | FY-2122              | June                   | 2022              | 6010.00                   |
    #
    | 1619-AS-2122-10017648-1_3  | 1619-005        | FY-2122              | October                | 2021              | 5495.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-005        | FY-2122              | January                | 2022              | 5195.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-005        | FY-2122              | March                  | 2022              | 2092.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-005        | FY-2122              | May                    | 2022              | 2338.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-005        | FY-2122              | July                   | 2022              | 3476.00                   |
    #
    | 1619-AS-2122-10017648-1_3  | 1619-006        | FY-2122              | September              | 2021              | 5924.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-006        | FY-2122              | January                | 2022              | 3472.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-006        | FY-2122              | February               | 2022              | 4952.00                   |
    | 1619-AS-2122-10017648-1_3  | 1619-006        | FY-2122              | May                    | 2022              | 4514.00                   |
    # Zero-value item
    | 1619-AS-2122-10017648-1_3  | 1619-013        | FY-2122              | September              | 2021              | 0.00                      |
    | 1619-AS-2122-10017648-1_3  | 1619-013        | FY-2122              | November               | 2021              | 0.00                      |
    | 1619-AS-2122-10017648-1_3  | 1619-013        | FY-2122              | February               | 2022              | 0.00                      |
    | 1619-AS-2122-10017648-1_3  | 1619-013        | FY-2122              | June                   | 2022              | 0.00                      |
    # Null-value items do not have Profile Period(s)
 
 
 
 
 
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
    | 10017648 | 10017648 Co Ltd  | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 48947.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017648-1_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 48947.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017648 | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | AS-2122 | 1619                        | 48947.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 48947.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017648' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017648' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017648 | 10017648 Co Ltd  | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 48947.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017648-1_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017648-1_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017648 | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | AS-2122 | 1619                        | 48947.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017648-1_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017648 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017648 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017648 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 48947.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017648 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017648 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017648 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017648 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 48947.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 11489.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5479.00  | 0.00     | 6010.00  | 0.00     | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 18596.00  | 0.00     | 0.00     | 5495.00  | 0.00     | 0.00     | 5195.00  | 0.00     | 2092.00  | 0.00     | 2338.00  | 0.00     | 3476.00  | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 18862.00  | 0.00     | 5924.00  | 0.00     | 0.00     | 0.00     | 3472.00  | 4952.00  | 0.00     | 0.00     | 4514.00  | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    # The following deliverable should not be present on the contract
 #  | [ContractNo]   | [AllocRef_16ED] | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Maintained Special SSF Bursary Support                      |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017648_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017648 Co Ltd UKPRN: 10017648
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £27,130 £21,817 £48,947
    Total Funding for this contract: £48,947
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017648 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017648 Co Ltd THE SECRETARY OF STATE FOR
    30 Silverdale Avenue EDUCATION
    Shadwell DEPARTMENT FOR EDUCATION
    Leeds AND 20 GREAT SMITH STREET
    LS17 S52 LONDON
    SW1P 3BT
    Company No: AA017648
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
    Provider: 10017648 Co Ltd UKPRN: 10017648
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £11,489 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,479.00 £0.00 £6,010.00 £0.00
    16-19 High Needs Element 2 £18,862 £0.00 £5,924.00 £0.00 £0.00 £0.00 £3,472.00 £4,952.00 £0.00 £0.00 £4,514.00 £0.00 £0.00
    16-19 Free Meals £18,596 £0.00 £0.00 £5,495.00 £0.00 £0.00 £5,195.00 £0.00 £2,092.00 £0.00 £2,338.00 £0.00 £3,476.00
    Total Funding £48,947 £0.00 £5,924.00 £5,495.00 £0.00 £0.00 £8,667.00 £4,952.00 £2,092.00 £5,479.00 £6,852.00 £6,010.00 £3,476.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # The following zero-value deliverable should not appear in the Funding Agreement

    And   the pdf file does not contain the following text
    """
    Maintained Special SSF Bursary Support £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017648_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A648.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-05 09:12:35.000 |





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
    | 10017648 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017648 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017648 | 10017648 Co Ltd  | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 48947.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017648 | 1619-AS-2122-Contract-Provider-10017648-1_3             | 1_3            | AS-2122 | 1619                        | 48947.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017648 | [ContractNo]   | 1               | [AllocRef_16ED]  | 20              | 0                     | 11489.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10017648 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 18596.00     | 0             | 0        | 16-19 Free Meals                               | ?                           |
    | 10017648 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 18862.00     | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
 #  | 10017648 | [ContractNo]   | 1               | [AllocRef_16ED]  | 18              | 0                     | 0.00         | 0             | 0        | Maintained Special SSF Bursary Support         | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A649 Import and release a 1619 FA. Publish. Withdraw. Import 1619 FA again with null-value and zero-value lines. Check CRM, docs and PaaS

    # 1. Import and release 1619 FA1_2. Publish contract v1
    # 2. Withdraw published contract v1
    # 3. Withdraw FA v1_2
    # 4. Import and release 1619 FA2_1. Amend 2 lines down to zero and add 2 new zero-value lines

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017649'
    And   there is no Funding Allocation data in CRM for UKPRN '10017649'
    And   there is no Contract, Task or Workflow data for UKPRN '10017649'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017649'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017649'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017649' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017649' 
    And   there is no caseload advisor for UKPRN '10017649' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017649 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017649' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017649 Co Ltd' with UKPRN '10017649' and OrgId 'ORG0017649' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017649 | 117649 | 10017649 Co Ltd | 0              | Active                | Yes           | AA017649      | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017649 |





    # Part 1: Import and release 1619 FA1. Publish contract v1

    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-1_2           | 1_2            | 1619                        | AS-2122            | 97740.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017649-1_2  | 1_2                    | 1619-AS-2122-Contract-Provider-10017649-1_2           | 10017649      | Furth        | 01GFE           | 97740.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017649-1_3  | 1619-001        | ?                | Payment         |
    | 1619-AS-2122-10017649-1_3  | 1619-002        | ?                | Payment         |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | 21271.00         | Payment         |
    | 1619-AS-2122-10017649-1_2  | 1619-010        | 8781.00          | Payment         |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | 22853.00         | Payment         |
    | 1619-AS-2122-10017649-1_2  | 1619-013        | 18132.00         | Payment         |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | 26703.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | FY-2122              | September              | 2021              | 4257.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | FY-2122              | November               | 2021              | 5326.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | FY-2122              | March                  | 2022              | 2121.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | FY-2122              | April                  | 2022              | 4797.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-003        | FY-2122              | June                   | 2022              | 4770.00                   |
    #
    | 1619-AS-2122-10017649-1_2  | 1619-010        | FY-2122              | December               | 2021              | 4249.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-010        | FY-2122              | March                  | 2022              | 4532.00                   |
    #
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | September              | 2021              | 3258.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | October                | 2021              | 2821.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | December               | 2021              | 2009.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | March                  | 2022              | 4445.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | May                    | 2022              | 5139.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-011        | FY-2122              | June                   | 2022              | 5181.00                   |
    #
    | 1619-AS-2122-10017649-1_2  | 1619-013        | FY-2122              | August                 | 2021              | 2090.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-013        | FY-2122              | January                | 2022              | 5007.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-013        | FY-2122              | February               | 2022              | 5322.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-013        | FY-2122              | April                  | 2022              | 3313.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-013        | FY-2122              | June                   | 2022              | 2400.00                   |
    #
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | September              | 2021              | 5991.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | November               | 2021              | 5692.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | December               | 2021              | 2589.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | February               | 2022              | 2835.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | April                  | 2022              | 3973.00                   |
    | 1619-AS-2122-10017649-1_2  | 1619-020        | FY-2122              | June                   | 2022              | 5623.00                   |
 
 
 
 
 
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
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 97740.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 97740.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | AS-2122 | 1619                        | 97740.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 97740.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017649' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017649' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 97740.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | AS-2122 | 1619                        | 97740.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017649-1_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017649 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017649 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017649 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 97740.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017649 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017649 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017649 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017649 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 97740.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 21271.00  | 0.00     | 4257.00  | 0.00     | 5326.00  | 0.00     | 0.00     | 0.00     | 2121.00  | 4797.00  | 0.00     | 4770.00  | 0.00     | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 8781.00   | 0.00     | 0.00     | 0.00     | 0.00     | 4249.00  | 0.00     | 0.00     | 4532.00  | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 22853.00  | 0.00     | 3258.00  | 2821.00  | 0.00     | 2009.00  | 0.00     | 0.00     | 4445.00  | 0.00     | 5139.00  | 5181.00  | 0.00     | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 18132.00  | 2090.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5007.00  | 5322.00  | 0.00     | 3313.00  | 0.00     | 2400.00  | 0.00     | Maintained Special SSF Bursary Support                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 26703.00  | 0.00     | 5991.00  | 0.00     | 5692.00  | 2589.00  | 0.00     | 2835.00  | 0.00     | 3973.00  | 0.00     | 5623.00  | 0.00     | Alternative Completions - Sea Fishing                       |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017649_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017649 Co Ltd UKPRN: 10017649
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £62,544 £35,196 £97,740
    Total Funding for this contract: £97,740
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017649 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017649 Co Ltd THE SECRETARY OF STATE FOR
    39 Halstead Road EDUCATION
    Earls Colne DEPARTMENT FOR EDUCATION
    Colchester 20 GREAT SMITH STREET
    AND
    Essex LONDON
    CO6 2NL SW1P 3BT
    Company No: AA017649
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
    Provider: 10017649 Co Ltd UKPRN: 10017649
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Maintained Special SSF Bursary Support £18,132 £2,090.00 £0.00 £0.00 £0.00 £0.00 £5,007.00 £5,322.00 £0.00 £3,313.00 £0.00 £2,400.00 £0.00
    Residential Bursary Fund £21,271 £0.00 £4,257.00 £0.00 £5,326.00 £0.00 £0.00 £0.00 £2,121.00 £4,797.00 £0.00 £4,770.00 £0.00
    Alternative Completions - Sporting Excellence £22,853 £0.00 £3,258.00 £2,821.00 £0.00 £2,009.00 £0.00 £0.00 £4,445.00 £0.00 £5,139.00 £5,181.00 £0.00
    Alternative Completions - Sea Fishing £26,703 £0.00 £5,991.00 £0.00 £5,692.00 £2,589.00 £0.00 £2,835.00 £0.00 £3,973.00 £0.00 £5,623.00 £0.00
    Teacher's Pension Scheme 1619 £8,781 £0.00 £0.00 £0.00 £0.00 £4,249.00 £0.00 £0.00 £4,532.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £97,740 £2,090.00 £13,506.00 £2,821.00 £11,018.00 £8,847.00 £5,007.00 £8,157.00 £11,098.00 £12,083.00 £5,139.00 £17,974.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017649_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A649v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the Atom feed 
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
    And   a file with filename '10017649_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table





    # Part 2: Withdraw published contract v1

    # Withdraw a Published Contract version

    # Change the date 
    Given the override date is '11/07/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test 10017649' by 'FCS2 Test'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    And   User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Test A165'
    | FundingId                                              | 
    | 1619-AS-2122-Contract-Provider-10017649-1_2            | 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | AS-2122 | 1619                        | 97740.00    | ?               | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 97740.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 3: Withdraw FA v1_2

    # Change the date 
    Given the override date is '13/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017649-1_2  | 


    # Check that the FA in PaaS and CRM is showing as withdrawn

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | AS-2122 | 1619                        | 97740.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-1_2             | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 97740.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |


    # Check the state of a Release Group (J129) 
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 0               | 0.00            |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017649 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017649 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 4: Import and release 1619 FA2_1. Amend 2 lines down to zero and add 2 new zero-value lines

    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-2_1           | 2_1            | 1619                        | AS-2122            | 70850.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017649-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10017649-2_1           | 10017649      | Furth        | 01GFE           | 70850.00                  |
 
    # Funding Allocation Line (aka Deliverable) (Lines 010 and 013 amended down to zero. Lines 021 and 024 are 'new' zero-values lines)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    # Null-value lines
    | 1619-AS-2122-10017649-2_1  | 1619-001        | ?                | Payment         |
    | 1619-AS-2122-10017649-2_1  | 1619-002        | ?                | Payment         |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | 21280.00         | Payment         |
    # Line reduced to zero
    | 1619-AS-2122-10017649-2_1  | 1619-010        | 0.00             | Payment         |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | 22860.00         | Payment         |
    # Line reduced to zero
    | 1619-AS-2122-10017649-2_1  | 1619-013        | 0.00             | Payment         |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | 26710.00         | Payment         |
    # Two 'new' zero value lines 
    | 1619-AS-2122-10017649-2_1  | 1619-021        | 0.00             | Payment         |
    | 1619-AS-2122-10017649-2_1  | 1619-024        | 0.00             | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | FY-2122              | September              | 2021              | 4257.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | FY-2122              | November               | 2021              | 5326.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | FY-2122              | March                  | 2022              | 2130.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | FY-2122              | April                  | 2022              | 4797.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-003        | FY-2122              | June                   | 2022              | 4770.00                   |
    # Line reduced to zero
    | 1619-AS-2122-10017649-2_1  | 1619-010        | FY-2122              | December               | 2021              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-010        | FY-2122              | March                  | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | September              | 2021              | 3258.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | October                | 2021              | 2828.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | December               | 2021              | 2009.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | March                  | 2022              | 4445.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | May                    | 2022              | 5139.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-011        | FY-2122              | June                   | 2022              | 5181.00                   |
    # Line reduced to zero
    | 1619-AS-2122-10017649-2_1  | 1619-013        | FY-2122              | August                 | 2021              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-013        | FY-2122              | January                | 2022              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-013        | FY-2122              | February               | 2022              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-013        | FY-2122              | April                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-013        | FY-2122              | June                   | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | September              | 2021              | 5998.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | November               | 2021              | 5692.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | December               | 2021              | 2589.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | February               | 2022              | 2835.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | April                  | 2022              | 3973.00                   |
    | 1619-AS-2122-10017649-2_1  | 1619-020        | FY-2122              | June                   | 2022              | 5623.00                   |
    # Two 'new' zero-value lines
    | 1619-AS-2122-10017649-2_1  | 1619-021        | FY-2122              | November               | 2021              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-021        | FY-2122              | January                | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017649-2_1  | 1619-024        | FY-2122              | February               | 2022              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-024        | FY-2122              | May                    | 2022              | 0.00                      |
    | 1619-AS-2122-10017649-2_1  | 1619-024        | FY-2122              | July                   | 2022              | 0.00                      |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

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
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 70850.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 70850.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-2_1             | 2_1            | AS-2122 | 1619                        | 70850.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/08/2021'

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
    | Released          | 1               | 70850.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017649' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017649' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017649 | 10017649 Co Ltd  | 1619-AS-2122-Contract-Provider-10017649-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 70850.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017649 | 1619-AS-2122-Contract-Provider-10017649-2_1             | 2_1            | AS-2122 | 1619                        | 70850.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017649-2_1             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017649 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017649 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017649 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017649 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 70850.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017649 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017649 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017649 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017649 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 70850.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM - without the £zero deliverables
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 33              | 21280.00  | 0.00     | 4257.00  | 0.00     | 5326.00  | 0.00     | 0.00     | 0.00     | 2130.00  | 4797.00  | 0.00     | 4770.00  | 0.00     | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 51              | 22860.00  | 0.00     | 3258.00  | 2828.00  | 0.00     | 2009.00  | 0.00     | 0.00     | 4445.00  | 0.00     | 5139.00  | 5181.00  | 0.00     | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Maintained Special SSF Bursary Support                      |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 52              | 26710.00  | 0.00     | 5998.00  | 0.00     | 5692.00  | 2589.00  | 0.00     | 2835.00  | 0.00     | 3973.00  | 0.00     | 5623.00  | 0.00     | Alternative Completions - Sea Fishing                       |                          |
    # The following two deliverables should not be present on contract v2
 #  | [ContractNo]   | [AllocRef_16ED]    | 53              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector                   |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 149             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Uplift  |                          |



    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
     Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017649_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017649 Co Ltd UKPRN: 10017649
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £41,367 £29,483 £70,850
    Total Funding for this contract: £70,850
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017649 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017649 Co Ltd THE SECRETARY OF STATE FOR
    39 Halstead Road EDUCATION
    Earls Colne DEPARTMENT FOR EDUCATION
    Colchester 20 GREAT SMITH STREET
    AND
    Essex LONDON
    CO6 2NL SW1P 3BT
    Company No: AA017649
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
    Provider: 10017649 Co Ltd UKPRN: 10017649
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Residential Bursary Fund £21,280 £0.00 £4,257.00 £0.00 £5,326.00 £0.00 £0.00 £0.00 £2,130.00 £4,797.00 £0.00 £4,770.00 £0.00
    Alternative Completions - Sporting Excellence £22,860 £0.00 £3,258.00 £2,828.00 £0.00 £2,009.00 £0.00 £0.00 £4,445.00 £0.00 £5,139.00 £5,181.00 £0.00
    Alternative Completions - Sea Fishing £26,710 £0.00 £5,998.00 £0.00 £5,692.00 £2,589.00 £0.00 £2,835.00 £0.00 £3,973.00 £0.00 £5,623.00 £0.00
    Total Funding £70,850 £0.00 £13,513.00 £2,828.00 £11,018.00 £4,598.00 £0.00 £2,835.00 £6,575.00 £8,770.00 £5,139.00 £15,574.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # The following two zero-value deliverables (53 & 149) should not appear in the Funding Agreement

    And   the pdf file does not contain the following text
    """
    Alternative Completions - Creative Sector £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    """

    And   the pdf file does not contain the following text
    """
    16-19 High Value Courses School and College £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017649_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A649v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-08-05 09:12:35.000 |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A652 Import and release 1416 FAs for Delivery Orgs with zero-value lines. Check CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017652'
    And   there is no Funding Allocation data in CRM for UKPRN '10017652'
    And   there is no Contract, Task or Workflow data for UKPRN '10017652'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017652'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017652'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017652' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017652' 
    And   there is no Organisation data in CRM for UKPRN '10000747' 
    And   there is no Organisation data in CRM for UKPRN '10000794' 
    And   there is no caseload advisor for UKPRN '10017652' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017652 | 
    | 10000747 |
    | 10000794 |
    
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017652' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Lancashire CC' with UKPRN '10017652' and OrgId 'ORG0017652' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017652 | 117652 | Lancashire CC   | 0              | Active                | Yes           | AA017652      | ?             | 9 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Lancashire             | OL4 7DJ   |
    | 10000747 | 100747 | Blackburn Coll  | 0              | Active                | Yes           | AA000747      | ?             | 7 Watermill Lane       | Upper Dogton           | Wallington             | ?                      | ?                      | Lancashire             | BL6 7AH   |
    | 10000794 | 100794 | Bolton College  | 0              | Active                | Yes           | AA000794      | ?             | 28 Battersby Bldgs     | Lower Battersby        | Leatherbarrow          | ?                      | ?                      | Lancashire             | BO2 8AJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017652 |
    | 10000747 |
    | 10000794 |




    # Populate the stub with 1416 data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation for Local Authority and two Delivery Orgs (D\Orgs have zero-value lines)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017652 | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2     | 1_2            | 1416                        | AY-2122            | 24241.00          |
    | Contracting    | 10017652 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2  | 1_2            | 1416                        | AY-2122            | 46443.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017652-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2     | 10017652      | Local        | 10LAU           | 24241.00                  |
    | 1416-AY-2122-10000747-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2  | 10000747      | Schoo        | 08SSF           | 15409.00                  |
    | 1416-AY-2122-10000794-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2  | 10000794      | Schoo        | 08SSF           | 31034.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017652-1_2  | 1416-001        | 9479.00          | Payment         |
    | 1416-AY-2122-10017652-1_2  | 1416-002        | 6169.00          | Payment         |
    | 1416-AY-2122-10017652-1_2  | 1416-003        | 8593.00          | Payment         |
    #
    | 1416-AY-2122-10000747-1_2  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10000747-1_2  | 1416-002        | 13033.00         | Payment         |
    | 1416-AY-2122-10000747-1_2  | 1416-003        | 2376.00          | Payment         |
    #
    | 1416-AY-2122-10000794-1_2  | 1416-001        | 13264.00         | Payment         |
    | 1416-AY-2122-10000794-1_2  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10000794-1_2  | 1416-003        | 17770.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017652-1_2  | 1416-001        | FY-2122              | September              | 2021              | 2524.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-001        | FY-2122              | February               | 2022              | 4618.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-001        | FY-2122              | April                  | 2022              | 2337.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-002        | FY-2122              | November               | 2021              | 2550.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 3619.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-003        | FY-2122              | November               | 2021              | 3300.00                   |
    | 1416-AY-2122-10017652-1_2  | 1416-003        | FY-2122              | May                    | 2022              | 5293.00                   |
    #
    | 1416-AY-2122-10000747-1_2  | 1416-001        | FY-2122              | January                | 2022              | 0.00                      |
    | 1416-AY-2122-10000747-1_2  | 1416-002        | FY-2122              | November               | 2021              | 5726.00                   |
    | 1416-AY-2122-10000747-1_2  | 1416-002        | FY-2122              | January                | 2022              | 2932.00                   |
    | 1416-AY-2122-10000747-1_2  | 1416-002        | FY-2122              | April                  | 2022              | 4375.00                   |
    | 1416-AY-2122-10000747-1_2  | 1416-003        | FY-2122              | November               | 2021              | 2376.00                   |
    #
    | 1416-AY-2122-10000794-1_2  | 1416-001        | FY-2122              | October                | 2021              | 3034.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-001        | FY-2122              | December               | 2021              | 5812.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-001        | FY-2122              | June                   | 2022              | 4418.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1416-AY-2122-10000794-1_2  | 1416-003        | FY-2122              | October                | 2021              | 5208.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-003        | FY-2122              | January                | 2022              | 3541.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-003        | FY-2122              | April                  | 2022              | 4540.00                   |
    | 1416-AY-2122-10000794-1_2  | 1416-003        | FY-2122              | June                   | 2022              | 4481.00                   |

 
 
 

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
    | 10017652 | Lancashire CC    | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 24241.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
    | 10017652 | Lancashire CC    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 46443.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
     
    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 70684.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017652 | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2       | 1_2            | AY-2122 | 1416                        | 24241.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017652 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2    | 1_2            | AY-2122 | 1416                        | 46443.00    | [CofG_LA]       | ?                 | ?                                 |





    # Release the Release Group

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 2               | 70684.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017652' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017652' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017652 | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2       | 1_2            | AY-2122 | 1416                        | 24241.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017652 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2    | 1_2            | AY-2122 | 1416                        | 46443.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-LocalAuthority-10017652-1_2       | [ContractNo] | 1               | 0                  | Yes            |
    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017652-1_2    | [ContractNo] | 1               | 0                  | Yes            |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017652_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
  
    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017652 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017652 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





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
    | 10017652 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017652 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM
    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Retrieve parameters from CRM for the contracting Org: 10017652 
    When  I retrieve the latest EFA contract details from CRM for provider '10017652' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017652' 

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    Then  the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 9479.00   | 0.00     | 2524.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4618.00  | 0.00     | 2337.00  | 0.00     | 0.00     | 0.00     | 14-16 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 6169.00   | 0.00     | 0.00     | 0.00     | 2550.00  | 0.00     | 0.00     | 0.00     | 3619.00  | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 8593.00   | 0.00     | 0.00     | 0.00     | 3300.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5293.00  | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
 #  | [ContractNo]   | [AllocRef_16ED]    | 25              | 13033.00  | 0.00     | 0.00     | 0.00     | 5726.00  | 0.00     | 2932.00  | 0.00     | 0.00     | 4375.00  | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 2376.00   | 0.00     | 0.00     | 0.00     | 2376.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
 #  | [ContractNo]   | [AllocRef_16ED]    | 24              | 13264.00  | 0.00     | 0.00     | 3034.00  | 0.00     | 5812.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4418.00  | 0.00     | 14-16 Programme Funding                                     |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 17770.00  | 0.00     | 0.00     | 5208.00  | 0.00     | 0.00     | 3541.00  | 0.00     | 0.00     | 4540.00  | 0.00     | 4481.00  | 0.00     | 14-16 Service Child Premium                                 |                          |



    # Retrieve parameters from CRM for Delivery Org1: 10000747 
    When  I retrieve the latest EFA contract details from CRM for provider '10017652' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10000747' 

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    Then  the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
 #  | [ContractNo]   | [AllocRef_16ED]    | 24              | 9479.00   | 0.00     | 2524.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4618.00  | 0.00     | 2337.00  | 0.00     | 0.00     | 0.00     | 14-16 Programme Funding                                     |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 25              | 6169.00   | 0.00     | 0.00     | 0.00     | 2550.00  | 0.00     | 0.00     | 0.00     | 3619.00  | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 8593.00   | 0.00     | 0.00     | 0.00     | 3300.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5293.00  | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 13033.00  | 0.00     | 0.00     | 0.00     | 5726.00  | 0.00     | 2932.00  | 0.00     | 0.00     | 4375.00  | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 2376.00   | 0.00     | 0.00     | 0.00     | 2376.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
 #  | [ContractNo]   | [AllocRef_16ED]    | 24              | 13264.00  | 0.00     | 0.00     | 3034.00  | 0.00     | 5812.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4418.00  | 0.00     | 14-16 Programme Funding                                     |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 17770.00  | 0.00     | 0.00     | 5208.00  | 0.00     | 0.00     | 3541.00  | 0.00     | 0.00     | 4540.00  | 0.00     | 4481.00  | 0.00     | 14-16 Service Child Premium                                 |                          |



    # Retrieve parameters from CRM for Delivery Org2: 10000794 
    When  I retrieve the latest EFA contract details from CRM for provider '10017652' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10000794' 

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    Then  the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
 #  | [ContractNo]   | [AllocRef_16ED]    | 24              | 9479.00   | 0.00     | 2524.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4618.00  | 0.00     | 2337.00  | 0.00     | 0.00     | 0.00     | 14-16 Programme Funding                                     |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 25              | 6169.00   | 0.00     | 0.00     | 0.00     | 2550.00  | 0.00     | 0.00     | 0.00     | 3619.00  | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 8593.00   | 0.00     | 0.00     | 0.00     | 3300.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5293.00  | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
 #  | [ContractNo]   | [AllocRef_16ED]    | 25              | 13033.00  | 0.00     | 0.00     | 0.00     | 5726.00  | 0.00     | 2932.00  | 0.00     | 0.00     | 4375.00  | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium                                         |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 111             | 2376.00   | 0.00     | 0.00     | 0.00     | 2376.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Service Child Premium                                 |                          |
    #
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 13264.00  | 0.00     | 0.00     | 3034.00  | 0.00     | 5812.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4418.00  | 0.00     | 14-16 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 17770.00  | 0.00     | 0.00     | 5208.00  | 0.00     | 0.00     | 3541.00  | 0.00     | 0.00     | 4540.00  | 0.00     | 4481.00  | 0.00     | 14-16 Service Child Premium                                 |                          |



    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A653 Import and release 1416 FAs for Delivery Orgs with zero-value Funding Allocs. Check CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017653'
    And   there is no Funding Allocation data in CRM for UKPRN '10017653'
    And   there is no Contract, Task or Workflow data for UKPRN '10017653'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017653'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017653'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017653' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017653' 
    And   there is no Organisation data in CRM for UKPRN '10000614' 
    And   there is no Organisation data in CRM for UKPRN '10000662' 
    And   there is no caseload advisor for UKPRN '10017653' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017653 | 
    | 10000614 |
    | 10000662 |
    
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017653' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Merseyside CC' with UKPRN '10017653' and OrgId 'ORG0017653' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017653 | 117653 | Merseyside CC   | 0              | Active                | Yes           | AA017653      | ?             | 2 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Merseyside             | OL4 7DJ   |
    | 10000614 | 100614 | Whiteover Coll  | 0              | Active                | Yes           | AA000614      | ?             | 9 Watermill Lane       | Upper Dogton           | Wallington             | ?                      | ?                      | Merseyside             | BL6 7AH   |
    | 10000662 | 100662 | Hooton College  | 0              | Active                | Yes           | AA000662      | ?             | 15 Battersby Bldgs     | Lower Battersby        | Leatherbarrow          | ?                      | ?                      | Merseyside             | BO2 8AJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017653 |
    | 10000614 |
    | 10000662 |




    # Populate the stub with 1416 data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation for Local Authority and two Delivery Orgs (D\Orgs have zero-value lines)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017653 | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2     | 1_2            | 1416                        | AY-2122            | 24241.00          |
    | Contracting    | 10017653 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2  | 1_2            | 1416                        | AY-2122            | 46443.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017653-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2     | 10017653      | Local        | 10LAU           | 24241.00                  |
    | 1416-AY-2122-10000614-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2  | 10000614      | Schoo        | 08SSF           | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2  | 10000662      | Schoo        | 08SSF           | 0.00                      |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017653-1_2  | 1416-001        | 9479.00          | Payment         |
    | 1416-AY-2122-10017653-1_2  | 1416-002        | 6169.00          | Payment         |
    | 1416-AY-2122-10017653-1_2  | 1416-003        | 8593.00          | Payment         |
    #
    | 1416-AY-2122-10000614-1_2  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10000614-1_2  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10000614-1_2  | 1416-003        | 0.00             | Payment         |
    #
    | 1416-AY-2122-10000662-1_2  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10000662-1_2  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10000662-1_2  | 1416-003        | 0.00             | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017653-1_2  | 1416-001        | FY-2122              | September              | 2021              | 2524.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-001        | FY-2122              | February               | 2022              | 4618.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-001        | FY-2122              | April                  | 2022              | 2337.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-002        | FY-2122              | November               | 2021              | 2550.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 3619.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-003        | FY-2122              | November               | 2021              | 3300.00                   |
    | 1416-AY-2122-10017653-1_2  | 1416-003        | FY-2122              | May                    | 2022              | 5293.00                   |
    #
    | 1416-AY-2122-10000614-1_2  | 1416-001        | FY-2122              | January                | 2022              | 0.00                      |
    | 1416-AY-2122-10000614-1_2  | 1416-002        | FY-2122              | November               | 2021              | 0.00                      |
    | 1416-AY-2122-10000614-1_2  | 1416-002        | FY-2122              | January                | 2022              | 0.00                      |
    | 1416-AY-2122-10000614-1_2  | 1416-002        | FY-2122              | April                  | 2022              | 0.00                      |
    | 1416-AY-2122-10000614-1_2  | 1416-003        | FY-2122              | November               | 2021              | 0.00                      |
    #
    | 1416-AY-2122-10000662-1_2  | 1416-001        | FY-2122              | October                | 2021              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-001        | FY-2122              | December               | 2021              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-001        | FY-2122              | June                   | 2022              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-003        | FY-2122              | October                | 2021              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-003        | FY-2122              | January                | 2022              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-003        | FY-2122              | April                  | 2022              | 0.00                      |
    | 1416-AY-2122-10000662-1_2  | 1416-003        | FY-2122              | June                   | 2022              | 0.00                      |

 
 
 

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
    | 10017653 | Merseyside CC    | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 24241.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
 #  | 10017653 | Merseyside CC    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 46443.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
     
    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 24241.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017653 | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2       | 1_2            | AY-2122 | 1416                        | 24241.00    | [CofG_LA]       | ?                 | ?                                 |
 #  | 10017653 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2    | 1_2            | AY-2122 | 1416                        | 46443.00    | [CofG_LA]       | ?                 | ?                                 |





    # Release the Release Group

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 24241.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017653' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017653' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017653 | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2       | 1_2            | AY-2122 | 1416                        | 24241.00    | [CofG_LA]       | ?                 | ?                                 |
 #  | 10017653 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2    | 1_2            | AY-2122 | 1416                        | 46443.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-LocalAuthority-10017653-1_2       | [ContractNo] | 1               | 0                  | Yes            |
 #  | 1416-AY-2122-Contract-LocalAuthoritySsf-10017653-1_2    | [ContractNo] | 1               | 0                  | Yes            |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017653_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
  
    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017653 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017653 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





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
    | 10017653 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017653 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Retrieve parameters from CRM for the contracting Org: 10017653 
    When  I retrieve the latest contract details from CRM for provider '10017653' for FundingType 'EDSK' and period '2122'

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    Then  the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                  | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 9479.00   | 0.00     | 2524.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4618.00  | 0.00     | 2337.00  | 0.00     | 0.00     | 0.00     | 14-16 Programme Funding          |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 6169.00   | 0.00     | 0.00     | 0.00     | 2550.00  | 0.00     | 0.00     | 0.00     | 3619.00  | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium              |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 8593.00   | 0.00     | 0.00     | 0.00     | 3300.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5293.00  | 0.00     | 0.00     | 14-16 Service Child Premium      |                          |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

