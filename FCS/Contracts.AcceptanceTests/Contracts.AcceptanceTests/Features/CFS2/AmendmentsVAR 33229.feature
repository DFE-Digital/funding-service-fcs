Feature: AmendmentsVAR 33229

@AcceptanceTest @Withdrawn20230118
@CFS
Scenario: A780 Import and release a 1619ED FA. Publish and approve EDSK2122 contract. Import and release 1619 FA to amend EDSK2122 contract. Check docs, CRM PaaS and CM feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017780'
    And   there is no Funding Allocation data in CRM for UKPRN '10017780'
    And   there is no Contract, Task or Workflow data for UKPRN '10017780'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017780'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017780'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017780' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017780' 
    And   there is no caseload advisor for UKPRN '10017780' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017780 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017780' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017780 Co Ltd' with UKPRN '10017780' and OrgId 'ORG0017780' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017780 | 117780 | 10017780 Co Ltd | 0              | In Administration     | Yes           | AA017780      | ?             | 76 Moorfield Road      | Denham Green           | ?                      | ?                      | Uxbridge               | Middlesex              | UB9 5NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017780 |





    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-1_1           | 1_1            | 1619                        | AS-2122            | 28599.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017780-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017780-1_1           | 10017780      | Furth        | 02IPP           | 28599.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017780-1_1  | 1619-001        | 14399.00         | Payment         |
    | 1619-AS-2122-10017780-1_1  | 1619-002        | 14200.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017780-1_1  | 1619-001        | FY-2122              | October                | 2021              | 2570.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-001        | FY-2122              | November               | 2021              | 3569.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-001        | FY-2122              | April                  | 2022              | 3510.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-001        | FY-2122              | June                   | 2022              | 4750.00                   |
    #
    | 1619-AS-2122-10017780-1_1  | 1619-002        | FY-2122              | August                 | 2021              | 2331.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-002        | FY-2122              | November               | 2021              | 2341.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-002        | FY-2122              | March                  | 2022              | 4435.00                   |
    | 1619-AS-2122-10017780-1_1  | 1619-002        | FY-2122              | July                   | 2022              | 5093.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 28599.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017780-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 28599.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | AS-2122 | 1619                        | 28599.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

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
    | Released          | 1               | 28599.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017780' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017780' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 28599.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | AS-2122 | 1619                        | 28599.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017780-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017780 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017780 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017780 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 28599.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017780 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017780 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017780 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017780 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 28599.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName               | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 14399.00  | 0.00     | 0.00     | 2570.00  | 3569.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3510.00  | 0.00     | 4750.00  | 0.00     | 16-19 Programme Funding       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 14200.00  | 2331.00  | 0.00     | 0.00     | 2341.00  | 0.00     | 0.00     | 0.00     | 4435.00  | 0.00     | 0.00     | 0.00     | 5093.00  | 16-19 Bursary Funds           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF, T&C, Sch1, FA, Sch2, Sch3)
    And   the file named '10017780_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017780 Co Ltd UKPRN: 10017780
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £15,246 £13,353 £28,599
    Total Funding for this contract: £28,599
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017780 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017780 Co Ltd THE SECRETARY OF STATE FOR
    76 Moorfield Road EDUCATION
    Denham Green DEPARTMENT FOR EDUCATION
    Uxbridge 20 GREAT SMITH STREET
    AND
    Middlesex LONDON
    UB9 5NF SW1P 3BT
    Company No: AA017780
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017780 Co Ltd UKPRN: 10017780
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £14,399 £0.00 £0.00 £2,570.00 £3,569.00 £0.00 £0.00 £0.00 £0.00 £3,510.00 £0.00 £4,750.00 £0.00
    16-19 Bursary Funds £14,200 £2,331.00 £0.00 £0.00 £2,341.00 £0.00 £0.00 £0.00 £4,435.00 £0.00 £0.00 £0.00 £5,093.00
    Total Funding £28,599 £2,331.00 £0.00 £2,570.00 £5,910.00 £0.00 £0.00 £0.00 £4,435.00 £3,510.00 £0.00 £4,750.00 £5,093.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017780_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A780v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017780'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017780 - 10017780 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017780 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017780 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017780 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017780 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017780 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 28599.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-1_1             | 1_1            | AS-2122 | 1619                        | 28599.00    | [CfS_ITP]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017780-1_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017780 | [ContractNo]   | 1               | [AllocRef_16ED]  | 20              | 0                     | 14399.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10017780 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 14200.00     | 0             | 0        | 16-19 Bursary Funds                            | ?                           |





    # Amend the contract 

    # Change the date
    Given the override date is '12/12/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |




    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '14/12/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-2_2           | 2_2            | 1619                        | AS-2122            | 34974.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017780-2_2  | 2_2                    | 1619-AS-2122-Contract-Provider-10017780-2_2           | 10017780      | Furth        | 02IPP           | 34974.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017780-2_2  | 1619-001        | 19013.00         | Payment         |
    | 1619-AS-2122-10017780-2_2  | 1619-002        | 15961.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017780-2_2  | 1619-001        | FY-2122              | October                | 2021              | 5731.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-001        | FY-2122              | November               | 2021              | 2766.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-001        | FY-2122              | April                  | 2022              | 5784.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-001        | FY-2122              | June                   | 2022              | 4732.00                   |
    #
    | 1619-AS-2122-10017780-2_2  | 1619-002        | FY-2122              | August                 | 2021              | 3252.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-002        | FY-2122              | November               | 2021              | 3567.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-002        | FY-2122              | March                  | 2022              | 5559.00                   |
    | 1619-AS-2122-10017780-2_2  | 1619-002        | FY-2122              | July                   | 2022              | 3583.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '16/12/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 34974.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP2]        |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017780-2_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 34974.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | AS-2122 | 1619                        | 34974.00    | [CfS_ITP2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '18/12/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP2]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 34974.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017780' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017780' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 34974.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP2]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | AS-2122 | 1619                        | 34974.00    | [CfS_ITP2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017780-2_2             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017780 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017780 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017780 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017780 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 34974.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017780 Co Ltd  | Active | Document Management Team  | 6375.00                |
    | 10017780 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017780 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017780 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 34974.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 6375.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName              | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 15961.00  | 3252.00  | 0.00     | 0.00     | 3567.00  | 0.00     | 0.00     | 0.00     | 5559.00  | 0.00     | 0.00     | 0.00     | 3583.00  | 16-19 Bursary Funds          |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 19013.00  | 0.00     | 0.00     | 5731.00  | 2766.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5784.00  | 0.00     | 4732.00  | 0.00     | 16-19 Programme Funding      |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF, FA)
    And   the file named '10017780_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017780 Co Ltd UKPRN: 10017780
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £20,875 £14,099 £34,974
    Total Funding for this contract: £34,974
    Summary of Funding – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017780 Co Ltd UKPRN: 10017780
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £19,013 £0.00 £0.00 £5,731.00 £2,766.00 £0.00 £0.00 £0.00 £0.00 £5,784.00 £0.00 £4,732.00 £0.00
    16-19 Bursary Funds £15,961 £3,252.00 £0.00 £0.00 £3,567.00 £0.00 £0.00 £0.00 £5,559.00 £0.00 £0.00 £0.00 £3,583.00
    Total Funding £34,974 £3,252.00 £0.00 £5,731.00 £6,333.00 £0.00 £0.00 £0.00 £5,559.00 £5,784.00 £0.00 £4,732.00 £3,583.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # There should not be a Terms and Conditions doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """
    
    # There should not be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """
    
    # There should not be a Sch2 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """
    
    # There should not be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017780_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A780v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-12-18 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017780'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017780 - 10017780 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |





    # Publish the contract

    # Change the date 
    Given the override date is '20/12/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '22/12/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017780 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017780 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                 | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017780 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017780 | 10017780 Co Ltd  | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 34974.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP2]      |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017780 | 1619-AS-2122-Contract-Provider-10017780-2_2             | 2_2            | AS-2122 | 1619                        | 34974.00    | [CfS_ITP2]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017780-2_2             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                  | DeliverableDescription      |
    | 10017780 | [ContractNo]   | 2               | [AllocRef_16ED]  | 20              | 0                     | 19013.00     | 0             | 0        | 16-19 Programme Funding          | ?                           |
    | 10017780 | [ContractNo]   | 2               | [AllocRef_16ED]  | 19              | 0                     | 15961.00     | 0             | 0        | 16-19 Bursary Funds              | ?                           |


    # Tidy Up
    And   the override date is reset 