Feature: Add1416FundingLinesToEDSK 35129 37584

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A636 Import and release a 1416 FA for an EDSK2122 contract. Check docs, CRM, PaaS, financials and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017636'
    And   there is no Funding Allocation data in CRM for UKPRN '10017636'
    And   there is no Contract, Task or Workflow data for UKPRN '10017636'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017636'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017636'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017636' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017636' 
    And   there is no caseload advisor for UKPRN '10017636' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017636 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017636' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017636 Co Ltd' with UKPRN '10017636' and OrgId 'ORG0017636' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017636 | 117636 | 10017636 Co Ltd | 0              | Provider Under Change | Yes           | AA017636      | ?             | 20 Shepherds Road      | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 7HX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017636 |







    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017636 | 1416-AY-2122-Contract-Provider-10017636-2_1           | 2_1            | 1416                        | AY-2122            | 58982.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017636-2_1  | 2_1                    | 1416-AY-2122-Contract-Provider-10017636-2_1           | 10017636      | Furth        | 02IPP           | 58982.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017636-2_1  | 1416-001        | 12001.00         | Payment         |
    | 1416-AY-2122-10017636-2_1  | 1416-002        | 21613.00         | Payment         |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | 25368.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017636-2_1  | 1416-001        | FY-2122              | August                 | 2021              | 4960.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-001        | FY-2122              | December               | 2021              | 4901.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-001        | FY-2122              | July                   | 2022              | 2140.00                   |
    #
    | 1416-AY-2122-10017636-2_1  | 1416-002        | FY-2122              | October                | 2021              | 4148.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-002        | FY-2122              | January                | 2022              | 2925.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-002        | FY-2122              | March                  | 2022              | 5532.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-002        | FY-2122              | May                    | 2022              | 5714.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-002        | FY-2122              | June                   | 2022              | 3294.00                   |
    #
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | September              | 2021              | 3368.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | November               | 2021              | 4917.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | January                | 2022              | 2395.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | February               | 2022              | 5959.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | May                    | 2022              | 5147.00                   |
    | 1416-AY-2122-10017636-2_1  | 1416-003        | FY-2122              | July                   | 2022              | 3582.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017636 | 10017636 Co Ltd  | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 58982.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2122-Contract-Provider-10017636-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 58982.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017636 | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | AY-2122 | 1416                        | 58982.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 58982.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017636' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017636' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017636 | 10017636 Co Ltd  | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Released          | Released          | 58982.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2122-Contract-Provider-10017636-2_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1416-AY-2122-Contract-Provider-10017636-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017636 | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | AY-2122 | 1416                        | 58982.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-Provider-10017636-2_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017636 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017636 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017636 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 58982.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017636 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017636 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017636 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017636 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 58982.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 14-16 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 14-16 Pupil Premium                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 14-16 Service Child Premium                                 |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017636_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017636 Co Ltd UKPRN: 10017636
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £39,105 £19,877 £58,982
    Total Funding for this contract: £58,982
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017636 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017636 Co Ltd THE SECRETARY OF STATE FOR
    20 Shepherds Road EDUCATION
    Watford DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    WD1 7HX LONDON
    SW1P 3BT
    Company No: AA017636
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017636 Co Ltd UKPRN: 10017636
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    14-16 Programme Funding £12,001 £4,960.00 £0.00 £0.00 £0.00 £4,901.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,140.00
    14-16 Pupil Premium £21,613 £0.00 £0.00 £4,148.00 £0.00 £0.00 £2,925.00 £0.00 £5,532.00 £0.00 £5,714.00 £3,294.00 £0.00
    14-16 Service Child Premium £25,368 £0.00 £3,368.00 £0.00 £4,917.00 £0.00 £2,395.00 £5,959.00 £0.00 £0.00 £5,147.00 £0.00 £3,582.00
    Total Funding £58,982 £4,960.00 £3,368.00 £4,148.00 £4,917.00 £4,901.00 £5,320.00 £5,959.00 £5,532.00 £0.00 £10,861.00 £3,294.00 £5,722.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    EDSK Schedule 9 Version 2 (July 2021) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017636_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A636.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017636'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017636 - 10017636 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017636 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017636 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017636 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
 #  And   a file with filename '10017636_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
 #  And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
 #  And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.




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
    | 10017636 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017636 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017636 | 10017636 Co Ltd  | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Contract Approved | Contract Approved | 58982.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017636 | 1416-AY-2122-Contract-Provider-10017636-2_1             | 2_1            | AY-2122 | 1416                        | 58982.00    | [CfS_ITP]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2122-Contract-Provider-10017636-2_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017636 | [ContractNo]   | 1               | [AllocRef_16ED]  | 24              | 0                     | 12001.00     | 0             | 0        | 14-16 Programme Funding                        | ?                           |
    | 10017636 | [ContractNo]   | 1               | [AllocRef_16ED]  | 25              | 0                     | 21613.00     | 0             | 0        | 14-16 Pupil Premium                            | ?                           |
    | 10017636 | [ContractNo]   | 1               | [AllocRef_16ED]  | 111             | 0                     | 25368.00     | 0             | 0        | 14-16 Service Child Premium                    | ?                           |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    |
    | 10017636 | [ContractNo]   | [AllocRef_16ED]    | 2203020            | 4960.00   | 0.00      | 0.00      | 0.00      | 4901.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2140.00   | 
    | 10017636 | [ContractNo]   | [AllocRef_16ED]    | 2203021            | 0.00      | 0.00      | 4148.00   | 0.00      | 0.00      | 2925.00   | 0.00      | 5532.00   | 0.00      | 5714.00   | 3294.00   | 0.00      | 
    | 10017636 | [ContractNo]   | [AllocRef_16ED]    | 2203022            | 0.00      | 3368.00   | 0.00      | 4917.00   | 0.00      | 2395.00   | 5959.00   | 0.00      | 0.00      | 5147.00   | 0.00      | 3582.00   | 


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table


@AcceptanceTest @Withdrawn25072024
@CFS
Scenario: S014 Import and release a 1416 FA for an EDSK2223 contract. Check docs, CRM, PaaS, financials and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017014'
    And   there is no Funding Allocation data in CRM for UKPRN '10017014'
    And   there is no Contract, Task or Workflow data for UKPRN '10017014'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017014'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017014'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017014' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017014' 
    And   there is no caseload advisor for UKPRN '10017014' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017014 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017014' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017014 Co Ltd' with UKPRN '10017014' and OrgId 'ORG0017014' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017014 | 117014 | 10017014 Co Ltd | 0              | Provider Under Change | Yes           | AA017014      | ?             | 20 Shepherds Road      | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 7HX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017014 |







    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017014 | 1416-AY-2223-Contract-Provider-10017014-2_1           | 2_1            | 1416                        | AY-2223            | 58982.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2223-10017014-2_1  | 2_1                    | 1416-AY-2223-Contract-Provider-10017014-2_1           | 10017014      | Furth        | 02IPP           | 58982.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2223-10017014-2_1  | 1416-001        | 12001.00         | Payment         |
    | 1416-AY-2223-10017014-2_1  | 1416-002        | 21613.00         | Payment         |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | 25368.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2223-10017014-2_1  | 1416-001        | FY-2223              | August                 | 2022              | 4960.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-001        | FY-2223              | December               | 2022              | 4901.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-001        | FY-2223              | July                   | 2023              | 2140.00                   |
    #
    | 1416-AY-2223-10017014-2_1  | 1416-002        | FY-2223              | October                | 2022              | 4148.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-002        | FY-2223              | January                | 2023              | 2925.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-002        | FY-2223              | March                  | 2023              | 5532.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-002        | FY-2223              | May                    | 2023              | 5714.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-002        | FY-2223              | June                   | 2023              | 3294.00                   |
    #
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | September              | 2022              | 3368.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | November               | 2022              | 4917.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | January                | 2023              | 2395.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | February               | 2023              | 5959.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | May                    | 2023              | 5147.00                   |
    | 1416-AY-2223-10017014-2_1  | 1416-003        | FY-2223              | July                   | 2023              | 3582.00                   |
 
 
 
 
 
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
    | 10017014 | 10017014 Co Ltd  | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1416                        | 16-19ED2223     | Scheduling        | Awaiting Release  | 58982.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2223-Contract-Provider-10017014-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 58982.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017014 | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | AY-2223 | 1416                        | 58982.00    | [CfS_ITP]       | ?                 | ?                                 |

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
    | Released          | 1               | 58982.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017014' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017014' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017014 | 10017014 Co Ltd  | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1416                        | 16-19ED2223     | Released          | Released          | 58982.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2223-Contract-Provider-10017014-2_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1416-AY-2223-Contract-Provider-10017014-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017014 | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | AY-2223 | 1416                        | 58982.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2223-Contract-Provider-10017014-2_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017014 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017014 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 58982.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017014 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017014 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017014 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017014 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 58982.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 14-16 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 14-16 Pupil Premium                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 14-16 Service Child Premium                                 |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017014_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017014 Co Ltd UKPRN: 10017014
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £39,105 £19,877 £58,982
    Total Funding for this contract: £58,982
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017014 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017014 Co Ltd THE SECRETARY OF STATE FOR
    20 Shepherds Road EDUCATION
    Watford DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    WD1 7HX LONDON
    SW1P 3BT
    Company No: AA017014
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 2 (July 2022) Page 2
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
    Provider: 10017014 Co Ltd UKPRN: 10017014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    14-16 Programme Funding £12,001 £4,960.00 £0.00 £0.00 £0.00 £4,901.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,140.00
    14-16 Pupil Premium £21,613 £0.00 £0.00 £4,148.00 £0.00 £0.00 £2,925.00 £0.00 £5,532.00 £0.00 £5,714.00 £3,294.00 £0.00
    14-16 Service Child Premium £25,368 £0.00 £3,368.00 £0.00 £4,917.00 £0.00 £2,395.00 £5,959.00 £0.00 £0.00 £5,147.00 £0.00 £3,582.00
    Total Funding £58,982 £4,960.00 £3,368.00 £4,148.00 £4,917.00 £4,901.00 £5,320.00 £5,959.00 £5,532.00 £0.00 £10,861.00 £3,294.00 £5,722.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017014_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S014.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017014'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017014 - 10017014 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017014 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017014 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017014 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
 #  And   a file with filename '10017014_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
 #  And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
 #  And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.




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
    | 10017014 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017014 | 10017014 Co Ltd  | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | Education & Skills Funding | AY2223  | Contract for Services (ITP)              | 1416                        | 16-19ED2223     | Contract Approved | Contract Approved | 58982.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017014 | 1416-AY-2223-Contract-Provider-10017014-2_1             | 2_1            | AY-2223 | 1416                        | 58982.00    | [CfS_ITP]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1416-AY-2223-Contract-Provider-10017014-2_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017014 | [ContractNo]   | 1               | [AllocRef_16ED]  | 24              | 0                     | 12001.00     | 0             | 0        | 14-16 Programme Funding                        | ?                           |
    | 10017014 | [ContractNo]   | 1               | [AllocRef_16ED]  | 25              | 0                     | 21613.00     | 0             | 0        | 14-16 Pupil Premium                            | ?                           |
    | 10017014 | [ContractNo]   | 1               | [AllocRef_16ED]  | 111             | 0                     | 25368.00     | 0             | 0        | 14-16 Service Child Premium                    | ?                           |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 12001.00  | 4960.00  | 0.00     | 0.00     | 0.00     | 4901.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2140.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 21613.00  | 0.00     | 0.00     | 4148.00  | 0.00     | 0.00     | 2925.00  | 0.00     | 5532.00  | 0.00     | 5714.00  | 3294.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 25368.00  | 0.00     | 3368.00  | 0.00     | 4917.00  | 0.00     | 2395.00  | 5959.00  | 0.00     | 0.00     | 5147.00  | 0.00     | 3582.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017014 | [ContractNo]   | [AllocRef_16ED]    | 2203020            | 4960.00   | 0.00      | 0.00      | 0.00      | 4901.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2140.00   | 
    | 10017014 | [ContractNo]   | [AllocRef_16ED]    | 2203021            | 0.00      | 0.00      | 4148.00   | 0.00      | 0.00      | 2925.00   | 0.00      | 5532.00   | 0.00      | 5714.00   | 3294.00   | 0.00      | 
    | 10017014 | [ContractNo]   | [AllocRef_16ED]    | 2203022            | 0.00      | 3368.00   | 0.00      | 4917.00   | 0.00      | 2395.00   | 5959.00   | 0.00      | 0.00      | 5147.00   | 0.00      | 3582.00   | 


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

