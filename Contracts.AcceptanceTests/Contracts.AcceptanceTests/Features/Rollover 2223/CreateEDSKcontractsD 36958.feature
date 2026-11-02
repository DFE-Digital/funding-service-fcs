Feature: CreateEDSKcontractsD 36958

@AcceptanceTest @Withdrawn25072024
@CFS
Scenario: A383 Import a 1619ED2223 FA for a nonsense ProviderType and ProviderSubType for override UKPRN 10039859. CofG_Trust. Release and approve. Check docs, CRM, PaaS and Feed

    # 10039859 is an exception provider listed in the Provider Category Exceptions tab of the config spreadsheet
    # In 21/22, exception provider 10088193 was tested by A171. 
    # A383 is being added because 10039859 introduces a new Provider Category: Academy Trust 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10039859'
    And   there is no Funding Allocation data in CRM for UKPRN '10039859'
    And   there is no Contract, Task or Workflow data for UKPRN '10039859'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10039859'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10039859'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10039859' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (Trust)   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10039859' 
    And   there is no caseload advisor for UKPRN '10039859' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10039859 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10039859' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10039859 Co Ltd' with UKPRN '10039859' and OrgId 'ORG0017383' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10039859 | 139859 | 10039859 Co Ltd | 0              | Active                | Yes           | AA039859      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10039859 |







    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10039859 | 1619-AS-2223-Contract-Provider-10039859-3_7           | 3_7            | 1619                        | AS-2223            | 54147.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2223-10039859-3_7  | 3_7                    | 1619-AS-2223-Contract-Provider-10039859-3_7           | 10039859      | Nonsense       | Rubbish             | 54147.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10039859-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2223-10039859-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2223-10039859-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2223-10039859-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2223-10039859-3_7  | 1619-010        | 3011.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10039859-3_7  | 1619-002        | FY-2223              | October                | 2022              | 2488.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-002        | FY-2223              | March                  | 2023              | 4411.00                   |
    #
    | 1619-AS-2223-10039859-3_7  | 1619-005        | FY-2223              | October                | 2022              | 5280.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-005        | FY-2223              | January                | 2023              | 3784.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-005        | FY-2223              | February               | 2023              | 4270.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-005        | FY-2223              | May                    | 2023              | 5750.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-005        | FY-2223              | July                   | 2023              | 2374.00                   |
    #
    | 1619-AS-2223-10039859-3_7  | 1619-006        | FY-2223              | October                | 2022              | 4319.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-006        | FY-2223              | February               | 2023              | 4874.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-006        | FY-2223              | April                  | 2023              | 2145.00                   |
    #
    | 1619-AS-2223-10039859-3_7  | 1619-008        | FY-2223              | September              | 2022              | 3007.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-008        | FY-2223              | December               | 2022              | 4588.00                   |
    | 1619-AS-2223-10039859-3_7  | 1619-008        | FY-2223              | April                  | 2023              | 3846.00                   |
    #
    | 1619-AS-2223-10039859-3_7  | 1619-010        | FY-2223              | July                   | 2023              | 3011.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (Trust) | CofG_Trust                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_Trust = [CofG_Trust]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10039859 | 10039859 Co Ltd  | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (Trust)    | 1619                        | 16-19ED2223     | Scheduling        | Awaiting Release  | 54147.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_Trust]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10039859-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_Trust]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 54147.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10039859 | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | AS-2223 | 1619                        | 54147.00    | [CofG_Trust]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_Trust]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_Trust]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_Trust = [CofG_Trust]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_Trust]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 54147.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10039859' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10039859' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10039859 | 10039859 Co Ltd  | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (Trust)  | 1619                        | 16-19ED2223     | Released          | Released          | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_Trust]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10039859-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2223-Contract-Provider-10039859-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10039859 | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | AS-2223 | 1619                        | 54147.00    | [CofG_Trust]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2223-Contract-Provider-10039859-3_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_Trust]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10039859 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10039859 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10039859 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 54147.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (Trust)     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10039859 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10039859 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (Trust)     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10039859 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10039859 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 54147.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 6899.00   | 0.00     | 0.00     | 2488.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 21458.00  | 0.00     | 0.00     | 5280.00  | 0.00     | 0.00     | 3784.00  | 4270.00  | 0.00     | 0.00     | 5750.00  | 0.00     | 2374.00  | 16-19 Free Meals                                                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 11338.00  | 0.00     | 0.00     | 4319.00  | 0.00     | 0.00     | 0.00     | 4874.00  | 0.00     | 2145.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 11441.00  | 0.00     | 3007.00  | 0.00     | 0.00     | 4588.00  | 0.00     | 0.00     | 0.00     | 3846.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 3011.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3011.00  | Teacher's Pension Scheme 1619                                         |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10039859_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10039859 Co Ltd UKPRN: 10039859
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £37,021 £17,126 £54,147
    Total Funding for this contract: £54,147
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10039859 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10039859 Co Ltd THE SECRETARY OF STATE FOR
    96 West Yard EDUCATION
    Camden Lock Place DEPARTMENT FOR EDUCATION
    Chalk Farm Road 20 GREAT SMITH STREET
    AND
    London LONDON
    NW1 8AF SW1P 3BT
    Company No: AA039859
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (July 2022) Page 2
    EDSK Version 2 (July 2022) Page 73

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2022) – Page 10

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10039859 Co Ltd UKPRN: 10039859
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Bursary Funds £6,899 £0.00 £0.00 £2,488.00 £0.00 £0.00 £0.00 £0.00 £4,411.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Needs Element 2 £11,338 £0.00 £0.00 £4,319.00 £0.00 £0.00 £0.00 £4,874.00 £0.00 £2,145.00 £0.00 £0.00 £0.00
    16-19 Free Meals £21,458 £0.00 £0.00 £5,280.00 £0.00 £0.00 £3,784.00 £4,270.00 £0.00 £0.00 £5,750.00 £0.00 £2,374.00
    16-19 Advanced Maths Premium £11,441 £0.00 £3,007.00 £0.00 £0.00 £4,588.00 £0.00 £0.00 £0.00 £3,846.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £3,011 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,011.00
    Total Funding £54,147 £0.00 £3,007.00 £12,087.00 £0.00 £4,588.00 £3,784.00 £9,144.00 £4,411.00 £5,991.00 £5,750.00 £0.00 £5,385.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10039859_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A383.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10039859'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10039859 - 10039859 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10039859 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10039859 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10039859 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10039859_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10039859 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10039859 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





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
    | 10039859 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10039859 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10039859 | 10039859 Co Ltd  | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (Trust)    | 1619                        | 16-19ED2223     | Contract Approved | Contract Approved | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_Trust]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10039859 | 1619-AS-2223-Contract-Provider-10039859-3_7             | 3_7            | AS-2223 | 1619                        | 54147.00    | [CofG_Trust]    | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10039859-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10039859 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 6899.00      | 0             | 0        | 16-19 Bursary Funds                                                   | ?                           |
    | 10039859 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 21458.00     | 0             | 0        | 16-19 Free Meals                                                      | ?                           |
    | 10039859 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 11338.00     | 0             | 0        | 16-19 High Needs Element 2                                            | ?                           |
    | 10039859 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 11441.00     | 0             | 0        | 16-19 Advanced Maths Premium                                          | ?                           |
    | 10039859 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 3011.00      | 0             | 0        | Teacher's Pension Scheme 1619                                         | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn25072024
Scenario: A384 Bulk load an EDSK 22/23 contract with ALLB, 16-18TRN and AEBC-NSF allocs. CofG_Employer. Check docs, PaaS and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017384' 
    And   there are no terminated or closed allocations for UKPRN '10017384' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017384' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017384' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017384' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2223          |
    | 16-18TRN2223      |
    | AEBC-NSF2223      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017384'

    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017384' 
    And   there is no caseload advisor for UKPRN '10017384' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017384 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017384' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017384 Co Ltd' with UKPRN '10017384' and OrgId 'ORG0017384' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017384 | 117384 | 10017384 Co Ltd | 0              | Provider Under Change | Yes           | AA017384      | ?             | 3 St. Mary's Road      | Long Ditton            | Surrey                 | ?                      | ?                      | ?                      | KT6 5EU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017384 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file
    And   there are no files prefixed '10017384' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 21062022160503 v3_A384' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 21062022160503 v3_A384' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 21062022160503 v3_A384' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 21062022160503 v3_A384' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 21062022160503 v3_A384.xlsx' exists in the Datafiles folder and UKPRN '10017384' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017384' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017384' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017384_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017384 Co Ltd UKPRN: 10017384
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £21,156 £17,849 £39,005
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £29,897 £14,268 £44,165
    of which Level 3 Free Courses for Jobs £29,897 £14,268 £44,165
    16 to 18 Traineeships [AllocRef_16TR] £65,965 £23,672 £89,637
    Total Funding for this contract: £172,807
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Employers)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017384 Co Ltd
    Advanced Learner Loans
    Funding for ESFA-Funded Adult Education Budget
    16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE EMPLOYER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Employer on the Manage Your Education & Skills Funding Service between:
    10017384 Co Ltd THE SECRETARY OF STATE FOR
    3 St. Mary's Road EDUCATION
    Long Ditton DEPARTMENT FOR EDUCATION
    Surrey 20 GREAT SMITH STREET
    AND
    KT6 5EU LONDON
    SW1P 3BT
    Company No: AA017384
    Hereinafter called Hereinafter called
    the Employer the Department
    EDSK Version 2 (July 2022) Page 2
    1.4 Precedence of Documentation
    In the event of any inconsistency between the provisions of the Terms and
    Conditions and the Schedules, or between any of the Schedules, the
    conflict shall be resolved according to the following descending order of
    priority:
    1.4.1 the Terms and Conditions,
    1.4.2 Schedule 1 (the Specification);
    1.4.3 the remaining Schedules,
    for the avoidance of doubt, in the event of any inconsistency between this
    Agreement and the Funding Rules, this Agreement will take precedence.
    1.5 In relation to any provision in the Agreement, the Secretary of State may
    act through the Department for Education and / or its executive agency,
    ESFA. As such where the Agreement refers to the Department, both the
    Department for Education and the ESFA are entitled to act in accordance
    with; and / or benefit from; and / or enforce the relevant provision.
    1.6 Without prejudice to the position set out in Clause 1.5, the Department for
    Education will principally manage provider registers, the relationship with
    the Employer and any intervention. The ESFA will principally be
    responsible for allocations, payments, Agreement administration and
    assurance.
    EDSK Version 2 (July 2022) Page 73
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 9
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 7
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 2

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017384 Co Ltd UKPRN: 10017384
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £39,005 £869 £1,973 £6,612 £647 £529 £2,992 £3,555 £3,979 £2,705 £6,527 £901 £7,716
    Total Funding £39,005 £869 £1,973 £6,612 £647 £529 £2,992 £3,555 £3,979 £2,705 £6,527 £901 £7,716
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    Adult Education Budget
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017384 Co Ltd UKPRN: 10017384
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Level 3 Free Courses for Jobs £44,165 £7,874 £7,418 £2,949 £6,293 £2,099 £890 £295 £2,079 £4,679 £6,940 £2,269 £380
    Total Funding £44,165 £7,874 £7,418 £2,949 £6,293 £2,099 £890 £295 £2,079 £4,679 £6,940 £2,269 £380
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1


    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017384 Co Ltd UKPRN: 10017384
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £42,881 £5,285 £2,515 £2,875 £6,018 £2,430 £3,130 £5,253 £6,835 £2,090 £4,149 £2,196 £105
    16 to 18 Traineeships Bursary Funding £46,756 £4,266 £7,684 £7,494 £3,842 £1,007 £3,672 £1,516 £2,143 £6,103 £2,175 £3,894 £2,960
    Total Funding £89,637 £9,551 £10,199 £10,369 £9,860 £3,437 £6,802 £6,769 £8,978 £8,193 £6,324 £6,090 £3,065
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017384_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A384.pdf'

    
    
    
    
    # Publish and approve the contract
    
    # Change the date
    Given the override date is '05/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017384 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017384 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-23 | Reconciliation |
    | [AllocRef_16TR] | 2201300          | Jul-23 | Reconciliation |
    | [AllocRef_NSFC] | 100946           | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription   | 
    | 10017384 | [ContractNo]   | 1               | [AllocRef_16TR] | 1               | 0                     | 89637.00     | 0             | 0        | Total 16-18 Traineeships Funding               | ?                        |
    | 10017384 | [ContractNo]   | 1               | [AllocRef_16TR] | 2               | 1                     | 42881.00     | 0             | 0        | 16-18 Traineeships Programme Funding           | ?                        |
    | 10017384 | [ContractNo]   | 1               | [AllocRef_16TR] | 3               | 1                     | 46756.00     | 0             | 0        | 16-18 Traineeships Bursary Funding             | ?                        |
    | 10017384 | [ContractNo]   | 1               | [AllocRef_ALLB] | 1               | 0                     | 39005.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                        |
    | 10017384 | [ContractNo]   | 1               | [AllocRef_NSFC] | 1               | 0                     | 44165.00     | 0             | 0        | National Skills Fund Total Funding             | ?                        |
    | 10017384 | [ContractNo]   | 1               | [AllocRef_NSFC] | 2               | 1                     | 44165.00     | 0             | 0        | Level 3 Free Courses for Jobs                  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn25072024
Scenario: A090 Bulk load a new APPS2223 allocation on an EDSK contract. CofG_College. Check docs. Publish and approve. Check CRM, PaaS and feed. CDA
    Given there are no allocations marked as Under Termination for UKPRN '10017090' 
    And   there are no terminated or closed allocations for UKPRN '10017090' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017090' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017090' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017090' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2223          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017090'

    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017090' 
    And   there is no caseload advisor for UKPRN '10017090' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017090 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017090' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017090 Co Ltd' with UKPRN '10017090' and OrgId 'ORG0017090' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017090 | 117090 | 10017090 Co Ltd | 0              | Locked Restructure    | Yes           | AA017090      | ?             | 1 William Street       | ?                      | ?                      | ?                      | Windsor                | Berkshire              | SL4 1BB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017090 |





 #  # Bulk load a new APPS2223 alloc on an EDSK contract [CfS_ITP: fail to create contract. Red in log. Technical debt]
 #  
 #  # Change the date
 #  Given the override date is '22/07/2022'
 #  
 #  # Bulk file
 #  And   there are no files prefixed '10017090' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
 #  And   there are no files prefixed 'EDSK AY 2223 30062022162211 v3_A090' in the Sharepoint 'Input' folder
 #  And   there are no files prefixed 'EDSK AY 2223 30062022162211 v3_A090' in the Sharepoint 'Processing' folder
 #  And   there are no files prefixed 'EDSK AY 2223 30062022162211 v3_A090' in the Sharepoint 'Processed' folder
 #  And   there are no files prefixed 'EDSK AY 2223 30062022162211 v3_A090' in the Sharepoint 'Reports' folder
 #  And   spreadsheet 'EDSK AY 2223 30062022162211 v3_A090.xlsx' exists in the Datafiles folder and UKPRN '10017090' is present in cell 'A2' of the Contract tab
 #  When  the file is copied to the Sharepoint 'Input' folder 
 # #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
 #  Then  a syntax report showing file success should exist in the Sharepoint Reports folder
 #  And   the syntax report includes the phrase 'Success'
 #  And   a results report should exist in the Sharepoint Reports folder
 #  And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
 #  
 #  # CBR-005
 #  And   'Contract Type is not valid for this Funding Type and Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    
    
    
    
    # Bulk load a new APPS2223 alloc on an EDSK contract [CofG_College]
    
    # Change the date
    Given the override date is '23/07/2022'
    
    # Bulk file
    And   there are no files prefixed '10017090' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 30062022162212 v3_A090' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 30062022162212 v3_A090' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 30062022162212 v3_A090' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 30062022162212 v3_A090' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 30062022162212 v3_A090.xlsx' exists in the Datafiles folder and UKPRN '10017090' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017090' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017090' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017090_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017090 Co Ltd UKPRN: 10017090
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Apprenticeships Carry-In [AllocRef_APPS] £29,457 £14,987 £44,444
    Total Funding for this contract: £44,444
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017090 Co Ltd
    Funding for Apprenticeships Carry-In
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017090 Co Ltd THE SECRETARY OF STATE FOR
    1 William Street EDUCATION
    Windsor DEPARTMENT FOR EDUCATION
    Berkshire AND 20 GREAT SMITH STREET
    SL4 1BB LONDON
    SW1P 3BT
    Company No: AA017090
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (November 2022) Page 2
    EDSK Version 3 (November 2022) Page 74

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2022) – Page 11

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
    EDSK Schedule 2 – Apprenticeships Carry-In Version 1 (July 2022) – Page 1

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017090 Co Ltd UKPRN: 10017090
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Apprenticeships Carry-In £44,444 £1,595 £3,794 £5,097 £3,621 £2,210 £4,333 £5,514 £3,293 £3,229 £1,276 £7,136 £3,346
    Total Funding £44,444 £1,595 £3,794 £5,097 £3,621 £2,210 £4,333 £5,514 £3,293 £3,229 £1,276 £7,136 £3,346
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
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

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017090_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A090.pdf'
 
 



    # Publish and approve the contract

    Given the override date is '25/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017090 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017090 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017090 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 44444.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # NFA amendment and check doc parts

    # Change the date
    Given the override date is '28/07/2022'

    # Initiate non-financial amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017090 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017090 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017090 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the deliverables have all been created in CRM
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Check doc parts
    
    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017090' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017090' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (SoF only)
    Then  the file named '10017090_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    """

    # There shouldn't be a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """
    
    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # There shouldn't be a Funding Agreement
    And   the pdf file does not contain the following text
    """    
    Funding Agreement – Apprenticeships Carry-In
    """

    # There shouldn't be a Sch3 doc
    And   the pdf file does not contain the following text
    """     
    SCHEDULE 3: NOT USED
    """





    # CDA

    # Change the date
    Given the override date is '01/08/2022'

    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version A090.csv'

#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
    When  the following CDA report is run
    | FundingStreamPeriod   | Version                | Suffix |
    | APPS2223              | Last Approved Version  | A090   |

   Then  a report named 'CDA Last Approved Version A090.csv' is created
#
#    # Check the contents of the CDA report for d1
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                          | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 8                 | 2022            | 2022/23       |              | 1595         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 9                 | 2022            | 2022/23       |              | 3794         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 10                | 2022            | 2022/23       |              | 5097         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 11                | 2022            | 2022/23       |              | 3621         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 12                | 2022            | 2022/23       |              | 2210         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 1                 | 2023            | 2022/23       |              | 4333         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 2                 | 2023            | 2022/23       |              | 5514         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 3                 | 2023            | 2022/23       |              | 3293         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 4                 | 2023            | 2023/24       |              | 3229         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 5                 | 2023            | 2023/24       |              | 1276         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 6                 | 2023            | 2023/24       |              | 7136         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | APPS2223                | 10017090 | 10017090 Co Ltd             |               |                             | [AllocRef_APPS]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                               |                                                                 | 7                 | 2023            | 2023/24       |              | 3346         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |

   
    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Complete
Scenario: A091 Create and approve a new APPS2223 allocation on an EDSK contract. Consume ILR and APPS actuals. Payment batch. Check financials and feed. Consolidated Payment Summary Report
    Given there are no allocations marked as Under Termination for UKPRN '10017091' 
    And   there are no terminated or closed allocations for UKPRN '10017091' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017091' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017091' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017091' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-091      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-091      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2223          |

    ## Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 2240100        |
    #| 2240150        |
    #| 2240160        |
    #| 2240170        |
    #| 2340100        |
    #| 2340150        |
    #| 2340160        |
    #| 2340170        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-091       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017091'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017091' 
    And   there is no caseload advisor for UKPRN '10017091' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017091 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017091' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017091 Co Ltd' with UKPRN '10017091' and OrgId 'ORG0017091' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017091 | 117091 | 10017091 Co Ltd | 0              | Active                | Yes           | AA017091      | ?             | 32 Chobham Road        | Knaphill               | Woking                 | Surrey                 | ?                      | ?                      | GU21 2SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017091 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-091'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-091'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017091 | 10017091 Co Ltd      | ESFA-091             | EDSK-091       | 1                     | 01/08/2022        | 31/07/2023      | 23694.00      |                      | Conditions of Funding (Grant) (SPI)        | 2223   | New          | ORG0017091 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017091 | EDSK-091       | APPS-091      | APPS              | APPS2223                | AY                      | 01/08/2022          | 31/07/2023        | 23694.00        |           |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017091 | EDSK-091       | APPS-091      | 1               | 0                     | 23694.00  | 15101.00  | 8593.00   | 2232.00  | 1575.00  | 2563.00  | 3300.00  | 2074.00  | 2050.00  | 1140.00  | 167.00   | 2104.00  | 3695.00  | 888.00   | 1906.00  | Apprenticeships Carry-In Total Funding   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-091       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-091'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-091' and ContractNumber 'EDSK-091' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-091' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017091 | EDSK-091           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017091 | ESFA-091           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-091' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'EDSK-091'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-091        | 2240100          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
    | 10017091 | EDSK-091       | 1               | APPS-091      | 1               | 0                     | 23694.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-091' agree with the most recent entry for this contract in the ContractManagement feed





    # Add actuals to the contract for APPS2223

    # Change the date
    Given the override date is '04/10/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017091'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1152.44     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 652.95      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 267.34      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1388.87     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 1192.69     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 1288.59     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 641.25      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 774.72      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 462.41      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 347.53      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 610.04      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 1381.38     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 253.33      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 692.10      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 774.35      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 444.46      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 546.06      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 717.97      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1134.60     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 1200.19     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 119.44      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1026.10     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 675.39      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 132.24      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1209.94     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 244.60      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 1499.90     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1168.65     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 521.00      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 1000.63     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 714.20      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 828.62      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 182.45      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 842.20      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 861.70      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 319.46      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 859.86      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 310.13      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 1107.48     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1183.47     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 813.90      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 159.87      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1372.65     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 1294.73     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 909.75      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 333.41      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 1218.79     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 1006.08     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 176.44      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 681.12      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 482.25      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1245.91     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 116.27      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 633.65      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 258.58      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 565.09      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 964.14      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 623.81      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 1436.90     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 933.84      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1096.92     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 1058.42     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 784.20      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1288.55     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 992.89      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 240.19      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 8               | 0            | 1379.84     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 9               | 0            | 1228.74     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 10              | 0            | 541.04      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 22              | 0            | 1039.64     |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 23              | 0            | 999.82      |
    | APPS           | APPS65               | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 24              | 0            | 863.85      |
    #
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 900.50      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1116.89     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 451.22      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1010.19     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 1109.87     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 293.61      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1056.53     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 937.76      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 646.62      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 1274.89     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 1088.06     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 667.16      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 936.50      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 921.04      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 952.28      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 816.45      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202208 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 212.81      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 1469.57     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 324.23      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 1398.01     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1325.92     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 1106.98     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1231.88     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 965.43      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 302.49      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 290.67      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 290.50      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 310.41      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 454.98      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 1420.85     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 887.04      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 909.61      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 240.94      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202209 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 462.32      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 514.51      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 921.50      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 1072.43     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1316.47     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 856.34      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1333.27     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1475.35     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 1143.02     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 1420.77     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 1257.71     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 1398.86     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 1232.02     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 525.21      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 580.05      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1274.73     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 1425.63     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202210 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 830.66      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 154.88      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1426.74     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 490.05      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1226.00     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 953.00      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 430.02      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1037.40     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 262.44      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 758.26      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 820.44      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 797.52      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 1337.89     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 1014.50     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 1154.01     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1039.95     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 1431.27     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202211 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 1422.41     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 1016.20     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1345.72     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 1186.96     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 486.34      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 781.36      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 329.27      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1349.13     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 611.28      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 322.10      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 910.32      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 946.15      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 949.67      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 868.62      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 535.74      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1424.93     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 398.25      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202212 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 218.13      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 1351.41     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1335.30     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 945.01      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 894.21      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 1124.11     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1164.42     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 166.01      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 456.16      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 1313.40     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 121.10      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 872.27      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 358.42      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 1493.49     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 270.23      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 106.65      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 1159.91     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202301 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 1125.11     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 1217.13     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 890.73      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 883.42      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 277.38      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 741.90      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 521.65      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 724.98      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 699.71      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 1383.84     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 219.03      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 1313.25     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 243.65      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 575.79      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 1121.84     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 718.86      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 234.78      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202302 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 728.54      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 635.22      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1213.83     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 594.56      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1465.17     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 327.42      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 980.90      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 912.24      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 605.44      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 176.67      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 172.94      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 466.71      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 1100.18     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 168.01      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 322.33      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1398.40     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 115.61      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202303 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 840.19      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 1300.28     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1031.11     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 867.82      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1382.56     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 1426.26     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1343.94     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1007.02     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 881.91      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 727.36      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 593.12      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 951.99      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 1319.40     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 347.66      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 683.93      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1374.47     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 1117.37     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202304 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 907.61      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 892.50      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1033.45     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 236.25      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 1213.40     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 337.79      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 559.65      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1421.46     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 116.33      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 803.36      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 989.83      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 600.21      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 122.20      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 109.33      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 1251.17     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 1428.47     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 150.67      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202305 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 1234.21     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 195.64      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 787.75      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 1244.67     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 786.75      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 384.45      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1232.05     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1429.71     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 227.89      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 1022.29     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 1384.69     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 723.29      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 642.59      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 1041.82     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 685.21      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 894.32      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 661.69      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202306 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 1138.01     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 2               | 0            | 286.24      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 3               | 0            | 1372.42     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 4               | 0            | 333.79      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 5               | 0            | 552.49      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 6               | 0            | 100.37      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 7               | 0            | 1107.32     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 11              | 0            | 1147.20     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 12              | 0            | 1207.96     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 13              | 0            | 397.02      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 14              | 0            | 778.27      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 15              | 0            | 801.67      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 16              | 0            | 992.53      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 17              | 0            | 949.32      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 18              | 0            | 1153.38     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 19              | 0            | 930.42      |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 20              | 0            | 1394.13     |
    | ILR2223        | R02                  | ORG0017091     | CM             | 202307 | APPS2223                | APPS-091                 | ?          | 21              | 0            | 530.97      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2223' OrgId 'ORG0017091' and Collection 'R02' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2223' OrgId 'ORG0017091' and Collection 'APPS65' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered





    # Check Financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-091       | APPS-091           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 2               | 2370.07   | 900.50   | 1469.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 3               | 1441.12   | 1116.89  | 324.23   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 4               | 1849.23   | 451.22   | 1398.01  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 5               | 2336.11   | 1010.19  | 1325.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 6               | 2216.85   | 1109.87  | 1106.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 7               | 1525.49   | 293.61   | 1231.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 8               | 1793.69   | 1152.44  | 641.25   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 9               | 1427.67   | 652.95   | 774.72   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 10              | 729.75    | 267.34   | 462.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 11              | 2021.96   | 1056.53  | 965.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 12              | 1240.25   | 937.76   | 302.49   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 13              | 937.29    | 646.62   | 290.67   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 14              | 1565.39   | 1274.89  | 290.50   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 15              | 1398.47   | 1088.06  | 310.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 16              | 1122.14   | 667.16   | 454.98   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 17              | 2357.35   | 936.50   | 1420.85  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 18              | 1808.08   | 921.04   | 887.04   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 19              | 1861.89   | 952.28   | 909.61   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 20              | 1057.39   | 816.45   | 240.94   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 21              | 675.13    | 212.81   | 462.32   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 22              | 1736.40   | 1388.87  | 347.53   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 23              | 1802.73   | 1192.69  | 610.04   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-091       | APPS-091           | 24              | 2669.97   | 1288.59  | 1381.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-091       | APPS-091           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 2               | 2370.07   | 0.00     | 2370.07  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 3               | 1441.12   | 0.00     | 1441.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 4               | 1849.23   | 0.00     | 1849.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 5               | 2336.11   | 0.00     | 2336.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 6               | 2216.85   | 0.00     | 2216.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 7               | 1525.49   | 0.00     | 1525.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 8               | 1793.69   | 0.00     | 1793.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 9               | 1427.67   | 0.00     | 1427.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 10              | 729.75    | 0.00     | 729.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 11              | 2021.96   | 0.00     | 2021.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 12              | 1240.25   | 0.00     | 1240.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 13              | 937.29    | 0.00     | 937.29   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 14              | 1565.39   | 0.00     | 1565.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 15              | 1398.47   | 0.00     | 1398.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 16              | 1122.14   | 0.00     | 1122.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 17              | 2357.35   | 0.00     | 2357.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 18              | 1808.08   | 0.00     | 1808.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 19              | 1861.89   | 0.00     | 1861.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 20              | 1057.39   | 0.00     | 1057.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 21              | 675.13    | 0.00     | 675.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 22              | 1736.40   | 0.00     | 1736.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 23              | 1802.73   | 0.00     | 1802.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 24              | 2669.97   | 0.00     | 2669.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-091       | APPS-091           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 2               | -1773.01  | 0.00     | -1773.01 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 3               | -1078.08  | 0.00     | -1078.08 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 4               | -1383.37  | 0.00     | -1383.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 5               | -1747.60  | 0.00     | -1747.60 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 6               | -1658.38  | 0.00     | -1658.38 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 8               | -1341.83  | 0.00     | -1341.83 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 9               | -1068.01  | 0.00     | -1068.01 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 11              | -1512.59  | 0.00     | -1512.59 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 12              | -927.81   | 0.00     | -927.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 13              | -701.17   | 0.00     | -701.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 14              | -1171.04  | 0.00     | -1171.04 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 15              | -1046.17  | 0.00     | -1046.17 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 16              | -839.45   | 0.00     | -839.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 17              | -1763.49  | 0.00     | -1763.49 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 19              | -1392.85  | 0.00     | -1392.85 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 20              | -791.01   | 0.00     | -791.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 22              | -1298.97  | 0.00     | -1298.97 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 23              | -1348.59  | 0.00     | -1348.59 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-091       | APPS-091           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 2               | 597.06    | 0.00     | 597.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 3               | 363.04    | 0.00     | 363.04   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 4               | 465.86    | 0.00     | 465.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 5               | 588.51    | 0.00     | 588.51   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 6               | 558.47    | 0.00     | 558.47   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 7               | 1525.49   | 0.00     | 1525.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 8               | 451.86    | 0.00     | 451.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 9               | 359.66    | 0.00     | 359.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 10              | 729.75    | 0.00     | 729.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 11              | 509.37    | 0.00     | 509.37   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 12              | 312.44    | 0.00     | 312.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 13              | 236.12    | 0.00     | 236.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 14              | 394.35    | 0.00     | 394.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 15              | 352.30    | 0.00     | 352.30   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 16              | 282.69    | 0.00     | 282.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 17              | 593.86    | 0.00     | 593.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 18              | 1808.08   | 0.00     | 1808.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 19              | 469.04    | 0.00     | 469.04   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 20              | 266.38    | 0.00     | 266.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 21              | 675.13    | 0.00     | 675.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 22              | 437.43    | 0.00     | 437.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 23              | 454.14    | 0.00     | 454.14   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-091       | APPS-091           | 24              | 2669.97   | 0.00     | 2669.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017091 | EDSK-091       | APPS-091           | 2240100                  | 0.00      | 10213.38  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240150                  | 0.00      | 3221.36   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240160                  | 0.00      | 729.75    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240170                  | 0.00      | 1525.49   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340100                  | 0.00      | 13562.13  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340150                  | 0.00      | 3539.13   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340160                  | 0.00      | 2669.97   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340170                  | 0.00      | 2483.21   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017091 | EDSK-091       | APPS-091           | 2240100                  | 0.00      | -7640.44  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240150                  | 0.00      | -2409.84  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2240170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340100                  | 0.00      | -10145.58 | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340150                  | 0.00      | -2647.56  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017091 | EDSK-091       | APPS-091           | 2340170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





    # Payment Batch for APPS2223(PoA)

    # Change the date
    Given the override date is '10/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | APPS-091                 | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2223                   | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2223                   | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A091.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 10213.38        | RECONCILIATION   | 16-18 Apps                         | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240100    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 3221.36         | RECONCILIATION   | 16-18NonLevy Apps                  | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240150    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 729.75          | RECONCILIATION   | 16-18NonLevy AppsEmp               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240160    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 1525.49         | RECONCILIATION   | 16-18 Apps Tblz Emp                | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240170    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 13562.13        | RECONCILIATION   | 19+ Apps                           | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340100    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 3539.13         | RECONCILIATION   | 19+NonLevy Apps                    | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340150    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 2669.97         | RECONCILIATION   | 19+NonLevy AppsEmp                 | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340160    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | 2483.21         | RECONCILIATION   | 19+ Apps Tblz Emp                  | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340170    |
    #                                                                                                     £ 37944.42 
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | -7640.44        | CAPPING          | 16-18 Apps                         | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240100    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | -2409.84        | CAPPING          | 16-18NonLevy Apps                  | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2240150    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | -10145.58       | CAPPING          | 19+ Apps                           | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340100    |
    | APPS                   | 2022          | 06             | 10          | ?       | APPS-091          | -2647.56        | CAPPING          | 19+NonLevy Apps                    | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017091 | 2340150    |
    #                                                                                                     £ 22843.42



    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/10/2022'
    # Check the above report manually


    # Tidy Up
    Given the override date is reset

