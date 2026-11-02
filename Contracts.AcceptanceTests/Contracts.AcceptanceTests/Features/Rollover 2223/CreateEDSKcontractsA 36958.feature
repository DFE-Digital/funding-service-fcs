Feature: CreateEDSKcontractsA 36958

@AcceptanceTest @Withdrawn25072024
@CFS
Scenario: A389 Import, release and approve a PSG funding allocation for 22/23 with deliverable 43. CofG_SPI. Provider Subtype = 'Special post 16 institution'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017389'
    And   there is no Funding Allocation data in CRM for UKPRN '10017389'
    And   there is no Contract, Task or Workflow data for UKPRN '10017389'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017389'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017389'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017389' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (SPI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017389' 
    And   there is no caseload advisor for UKPRN '10017389' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017389 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017389' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017389 Co Ltd' with UKPRN '10017389' and OrgId 'ORG0017389' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017389 | 117389 | 10017389 Co Ltd | 0              | Locked Restructure    | Yes           | AA017389      | ?             | 5 Spurway Parade       | Woodford Avenue        | ?                      | ?                      | Ilford                 | Essex                  | IG2 6UU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017389 |







    # Populate the stub with PSG (Special post 16 institution) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017389 | PSG-AY-2223-Contract-Provider-10017389-3_2            | 3_2            | PSG                         | AY-2223            | 13205.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PSG-AY-2223-10017389-3_2   | 3_2                    | PSG-AY-2223-Contract-Provider-10017389-3_2            | 10017389      | Other types                        | Special post 16 institution      | 13205.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2223-10017389-3_2   | TotalAllocation | 13205.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2223-10017389-3_2   | TotalAllocation | FY-2223              | November               | 2022              | 3367.00                   |
    | PSG-AY-2223-10017389-3_2   | TotalAllocation | FY-2223              | March                  | 2023              | 4265.00                   |
    | PSG-AY-2223-10017389-3_2   | TotalAllocation | FY-2223              | May                    | 2023              | 5573.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017389 | 10017389 Co Ltd  | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2223     | Scheduling        | Awaiting Release  | 13205.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_SPI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2223-Contract-Provider-10017389-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13205.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017389 | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | AY-2223 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

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
    When  I retrieve the latest contract details from CRM for provider '10017389' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017389' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017389 | 10017389 Co Ltd  | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2223     | Released          | Released          | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2223-Contract-Provider-10017389-3_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PSG-AY-2223-Contract-Provider-10017389-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017389 | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | AY-2223 | PSG                         | 13205.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2223-Contract-Provider-10017389-3_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017389 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017389 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017389 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 13205.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017389 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017389 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017389 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017389 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 13205.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Initial Payment) (NMSS)                                   |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017389_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017389 Co Ltd UKPRN: 10017389
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £7,632 £5,573 £13,205
    Total Funding for this contract: £13,205
    Summary of Funding – Page 1
    
    Agreement Type Specialist Post-16 Institution
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017389 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement
    [MasterContractNo]
    Number
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 1  (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017389 Co Ltd THE SECRETARY OF STATE FOR
    5 Spurway Parade EDUCATION
    Woodford Avenue DEPARTMENT FOR EDUCATION
    Ilford 20 GREAT SMITH STREET
    AND
    Essex LONDON
    IG2 6UU SW1P 3BT
    Company No: AA017389
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 1 (July 2022) Page 2
    EDSK Version 1 (July 2022) Page 71
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2022) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017389 Co Ltd UKPRN: 10017389
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Primary PE and Sport Premium £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
    Total Funding £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 1 (July 2022) – Page 1
    EDSK Schedule 9 Version 1 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017389_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A389.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017389'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017389 - 10017389 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017389 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017389 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017389 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017389_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017389 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017389 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017389 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017389 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017389 | 10017389 Co Ltd  | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2223     | Contract Approved | Contract Approved | 13205.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017389 | PSG-AY-2223-Contract-Provider-10017389-3_2              | 3_2            | AY-2223 | PSG                         | 13205.00    | [CofG_SPI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2223-Contract-Provider-10017389-3_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10017389 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 13205.00     | 0             | 0        |Primary PE and Sport Premium (Initial Payment) (NMSS)                                   | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Complete
@CFS
Scenario: A390 Import, release and approve a PP funding allocation for 22/23 with deliverable 140. CofG_College. Provider Subtype = 'Further education'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017390'
    And   there is no Funding Allocation data in CRM for UKPRN '10017390'
    And   there is no Contract, Task or Workflow data for UKPRN '10017390'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017390'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017390'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017390' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017390' 
    And   there is no caseload advisor for UKPRN '10017390' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017390 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017390' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017390 Co Ltd' with UKPRN '10017390' and OrgId 'ORG0017390' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017390 | 117390 | 10017390 Co Ltd | 0              | Active                | Yes           | AA017390      | ?             | 4 Arden Court          | Arden Road             | ?                      | ?                      | Alcester               | Warwickshire           | B49 6HN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017390 |







    # Populate the stub with PP (Further education) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017390 | PP-FY-2223-Contract-Provider-10017390-4_3             | 4_3            | PP                          | FY-2223            | 7540.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PP-FY-2223-10017390-4_3    | 4_3                    | PP-FY-2223-Contract-Provider-10017390-4_3             | 10017390      | Colleges                           | Further education                | 7540.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PP-FY-2223-10017390-4_3    | PP-001          | 7540.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PP-FY-2223-10017390-4_3    | PP-001          | FY-2223              | November               | 2022              | 4673.00                   |
    | PP-FY-2223-10017390-4_3    | PP-001          | FY-2223              | April                  | 2023              | 2867.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017390 | 10017390 Co Ltd  | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | PP                          | 16-19ED2223     | Scheduling        | Awaiting Release  | 7540.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2223-Contract-Provider-10017390-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 7540.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017390 | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | FY-2223 | PP                          | 7540.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

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
    | Released          | 1               | 7540.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017390' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017390' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017390 | 10017390 Co Ltd  | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | PP                          | 16-19ED2223     | Released          | Released          | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2223-Contract-Provider-10017390-4_3               | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PP-FY-2223-Contract-Provider-10017390-4_3               | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017390 | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | FY-2223 | PP                          | 7540.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PP-FY-2223-Contract-Provider-10017390-4_3               | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017390 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017390 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017390 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 7540.00       | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017390 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017390 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017390 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017390 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 7540.00         | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 7540.00   | 0.00     | 0.00     | 0.00     | 4673.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2867.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                                  |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017390_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017390 Co Ltd UKPRN: 10017390
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £4,673 £2,867 £7,540
    Total Funding for this contract: £7,540
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017390 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017390 Co Ltd THE SECRETARY OF STATE FOR
    4 Arden Court EDUCATION
    Arden Road DEPARTMENT FOR EDUCATION
    Alcester 20 GREAT SMITH STREET
    AND
    Warwickshire LONDON
    B49 6HN SW1P 3BT
    Company No: AA017390
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (November 2022) Page 2
    EDSK Version 3 (November 2022) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 10
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017390 Co Ltd UKPRN: 10017390
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Pupil Premium £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
    Total Funding £7,540 £0.00 £0.00 £0.00 £4,673.00 £0.00 £0.00 £0.00 £0.00 £2,867.00 £0.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (November 2022) – Page 1
    
    SCHEDULE 9: COLLEGE GOVERNANCE
    4.4 The College must obtain the written consent of the Secretary of State
    before entering into any new arrangements for Borrowing Money and for
    any amendment to such arrangements from 29 November 2022 and
    before entering into any amendment to arrangements for Borrowing
    Money that existed before 29 November 2022. Failure to do so will amount
    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
    37) will apply.
    EDSK Schedule 9 Version 3 (November 2022) – Page 2

    SCHEDULE 10: SUB-CONTRACTING
    EDSK Schedule 10 Version 3 (November 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017390_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A390.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017390'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017390 - 10017390 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017390 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017390 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017390 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017390_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017390 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017390 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017390 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017390 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017390 | 10017390 Co Ltd  | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | PP                          | 16-19ED2223     | Contract Approved | Contract Approved | 7540.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017390 | PP-FY-2223-Contract-Provider-10017390-4_3               | 4_3            | FY-2223 | PP                          | 7540.00     | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PP-FY-2223-Contract-Provider-10017390-4_3               | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10017390 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 7540.00      | 0             | 0        | Pupil Premium (NMSS)                                                  | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Complete
@CFS
Scenario: A391 Import, release and approve a 1619 funding allocation for 22/23 with five deliverables. CfS_ITP. Provider Subtype = 'Independent learning provider'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017391'
    And   there is no Funding Allocation data in CRM for UKPRN '10017391'
    And   there is no Contract, Task or Workflow data for UKPRN '10017391'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017391'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017391'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017391' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017391' 
    And   there is no caseload advisor for UKPRN '10017391' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017391 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017391' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017391 Co Ltd' with UKPRN '10017391' and OrgId 'ORG0017391' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017391 | 117391 | 10017391 Co Ltd | 0              | Active                | Yes           | AA017391      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017391 |







    # Populate the stub with 1619 (Independent learning provider) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017391 | 1619-AS-2223-Contract-Provider-10017391-1_2           | 1_2            | 1619                        | AS-2223            | 72374.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1619-AS-2223-10017391-1_2  | 1_2                    | 1619-AS-2223-Contract-Provider-10017391-1_2           | 10017391      | 16-19 provider                     | Independent learning provider    | 72374.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10017391-1_2  | 1619-001        | 14807.00         | Payment         |
    | 1619-AS-2223-10017391-1_2  | 1619-005        | 9009.00          | Payment         |
    | 1619-AS-2223-10017391-1_2  | 1619-006        | 15304.00         | Payment         |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | 26704.00         | Payment         |
    | 1619-AS-2223-10017391-1_2  | 1619-010        | 6550.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10017391-1_2  | 1619-001        | FY-2223              | November               | 2022              | 4779.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-001        | FY-2223              | February               | 2023              | 4309.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-001        | FY-2223              | June                   | 2023              | 5719.00                   |
    #
    | 1619-AS-2223-10017391-1_2  | 1619-005        | FY-2223              | September              | 2022              | 3252.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-005        | FY-2223              | July                   | 2023              | 5757.00                   |
    #
    | 1619-AS-2223-10017391-1_2  | 1619-006        | FY-2223              | September              | 2022              | 4215.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-006        | FY-2223              | November               | 2022              | 5112.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-006        | FY-2223              | April                  | 2023              | 2420.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-006        | FY-2223              | June                   | 2023              | 3557.00                   |
    #
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | August                 | 2022              | 3043.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | November               | 2022              | 5105.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | December               | 2022              | 5046.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | March                  | 2023              | 2284.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | April                  | 2023              | 5506.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-007        | FY-2223              | June                   | 2023              | 5720.00                   |
    #
    | 1619-AS-2223-10017391-1_2  | 1619-010        | FY-2223              | September              | 2022              | 2415.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-010        | FY-2223              | February               | 2023              | 2046.00                   |
    | 1619-AS-2223-10017391-1_2  | 1619-010        | FY-2223              | June                   | 2023              | 2089.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Contract for Services (ITP)             | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017391 | 10017391 Co Ltd  | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1619                        | 16-19ED2223     | Scheduling        | Awaiting Release  | 72374.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017391-1_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 72374.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017391 | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | AS-2223 | 1619                        | 72374.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 72374.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017391' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017391' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017391 | 10017391 Co Ltd  | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1619                        | 16-19ED2223     | Released          | Released          | 72374.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017391-1_2             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2223-Contract-Provider-10017391-1_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017391 | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | AS-2223 | 1619                        | 72374.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2223-Contract-Provider-10017391-1_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017391 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017391 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017391 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 72374.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017391 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017391 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017391 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017391 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 72374.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 14807.00  | 0.00     | 0.00     | 0.00     | 4779.00  | 0.00     | 0.00     | 4309.00  | 0.00     | 0.00     | 0.00     | 5719.00  | 0.00     | 16-19 Programme Funding                                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 9009.00   | 0.00     | 3252.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5757.00  | 16-19 Free Meals                                                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 15304.00  | 0.00     | 4215.00  | 0.00     | 5112.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2420.00  | 0.00     | 3557.00  | 0.00     | 16-19 High Needs Element 2                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 26704.00  | 3043.00  | 0.00     | 0.00     | 5105.00  | 5046.00  | 0.00     | 0.00     | 2284.00  | 5506.00  | 0.00     | 5720.00  | 0.00     | 16-19 Capacity and Delivery                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 6550.00   | 0.00     | 2415.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2046.00  | 0.00     | 0.00     | 0.00     | 2089.00  | 0.00     | Teacher's Pension Scheme 1619                                         |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017391_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017391 Co Ltd UKPRN: 10017391
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £41,606 £30,768 £72,374
    Total Funding for this contract: £72,374
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017391 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017391 Co Ltd THE SECRETARY OF STATE FOR
    10 St. Mary at Hill EDUCATION
    London DEPARTMENT FOR EDUCATION
    EC3R 8EE AND 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017391
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 2 (July 2022) Page 2

    Inadequate overall
    13.4 Where the Department is made aware that Ofsted has provisionally
    assessed the Services to be inadequate overall, the Department may, in
    its absolute discretion commence discussions with the Contractor and
    other relevant co-funding regulatory bodies where appropriate as part of
    considering what actions as specified in Clauses 13.5(a) to 13.5(e)
    inclusive may be taken.
    EDSK Version 2 (July 2022) Page 29

    23.1.7 The Contractor must update the course information with details of
    all of the Services funded by the Department to the course
    directory (Publish to the course directory
    (nationalcareers.service.gov.uk)). The Contractor must regularly
    review this information and keep it updated.
    EDSK Version 2 (July 2022) Page 43

    EDSK Version 2 (July 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2022) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017391 Co Ltd UKPRN: 10017391
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Programme Funding £14,807 £0.00 £0.00 £0.00 £4,779.00 £0.00 £0.00 £4,309.00 £0.00 £0.00 £0.00 £5,719.00 £0.00
    16-19 High Needs Element 2 £15,304 £0.00 £4,215.00 £0.00 £5,112.00 £0.00 £0.00 £0.00 £0.00 £2,420.00 £0.00 £3,557.00 £0.00
    16-19 Free Meals £9,009 £0.00 £3,252.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,757.00
    16-19 Capacity and Delivery £26,704 £3,043.00 £0.00 £0.00 £5,105.00 £5,046.00 £0.00 £0.00 £2,284.00 £5,506.00 £0.00 £5,720.00 £0.00
    Teacher's Pension Scheme 1619 £6,550 £0.00 £2,415.00 £0.00 £0.00 £0.00 £0.00 £2,046.00 £0.00 £0.00 £0.00 £2,089.00 £0.00
    Total Funding £72,374 £3,043.00 £9,882.00 £0.00 £14,996.00 £5,046.00 £0.00 £6,355.00 £2,284.00 £7,926.00 £0.00 £17,085.00 £5,757.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017391_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A391.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017391'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017391 - 10017391 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017391 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017391 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017391 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017391_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017391 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017391 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017391 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017391 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017391 | 10017391 Co Ltd  | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1619                        | 16-19ED2223     | Contract Approved | Contract Approved | 72374.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017391 | 1619-AS-2223-Contract-Provider-10017391-1_2             | 1_2            | AS-2223 | 1619                        | 72374.00    | [CfS_ITP]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017391-1_2             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10017391 | [ContractNo]   | 1               | [AllocRef_16ED]  | 20              | 0                     | 14807.00     | 0             | 0        | 16-19 Programme Funding                                               | ?                           |
    | 10017391 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 9009.00      | 0             | 0        | 16-19 Free Meals                                                      | ?                           |
    | 10017391 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 15304.00     | 0             | 0        | 16-19 High Needs Element 2                                            | ?                           |
    | 10017391 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 26704.00     | 0             | 0        | 16-19 Capacity and Delivery                                           | ?                           |
    | 10017391 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 6550.00      | 0             | 0        | Teacher's Pension Scheme 1619                                         | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

