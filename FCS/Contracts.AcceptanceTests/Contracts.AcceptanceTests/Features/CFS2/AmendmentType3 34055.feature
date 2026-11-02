Feature: AmendmentType3 34055

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A165 Import and release 1619ED FAs on an EDSK2122 contract with a Delivery Org. Approve, amend, withdraw, delete FAs, reinstate. Delete contract. Various amendments. Check CRM and PaaS.

    #  1. Import FA v2_2 and release RG to create draft contract v1 (a)
    #  2. Publish and approve contract v1
    #  3. Import FA v2_6 and release RG to add Delivery Org 10027333 and create conract v2 (b)
    #  4. Publish and withdraw contract v2 (c)
    #  5. Reinstate and re-release FA v2_2 (d)
    #  6. Publish and approve contract v3 (e)
    #  7. Import and release FAs v3_2 and v3_6. Add -ve value funding line to v3_2 (-£600) and +ve value funding line to v3_6 (+£500) (f)
    #  8. Delete the draft contract amendment (g)
    #  9. Reinstate and release FA v3_2 (h)
    # 10. Delete the draft contract amendment and withdraw FA v3_2 and v3_6 (i)
    # 11. Import and release FAs v4_2 and v4_6 (j)


    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017165'
    And   there is no Funding Allocation data in CRM for UKPRN '10017165'
    And   there is no Contract, Task or Workflow data for UKPRN '10017165'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017165'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017165'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017165' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    
    # Remove all details from ContractManagement.CreatedContract for a contract
    And   there are no details in ContractManagement.CreatedContract for '[ContractNo]'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017165' 
    And   there is no caseload advisor for UKPRN '10017165' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017165 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017165' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017165 Co Ltd' with UKPRN '10017165' and OrgId 'ORG0017165' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017165 | 117165 | 10017165 Co Ltd | 0              | Active                | Yes           | AA017165      | ?             | 27 Belgrade Road       | Hampton                | Middlesex              | ?                      | ?                      | ?                      | TW12 2AZ  |
    | 10027333 | 127333 | 10027333 Co Ltd | 0              | Active                | Yes           | AA027333      | ?             | 14 School Lane         | Hampton                | Middlesex              | ?                      | ?                      | ?                      | TW12 2AZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017165 |
    | 10027333 |





    # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2     | 2_2            | 1619                        | AS-2122            | 64688.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017165-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2     | 10017165      | Local        | 10LAU           | 64688.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | 20409.00         | Payment         |
    | 1619-AS-2122-10017165-2_2  | 1619-007        | 19574.00         | Payment         |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | 24705.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | FY-2122              | October                | 2021              | 6000.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | FY-2122              | January                | 2022              | 2282.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | FY-2122              | March                  | 2022              | 2495.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | FY-2122              | April                  | 2022              | 5855.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-005        | FY-2122              | July                   | 2022              | 3777.00                   |
    #
    | 1619-AS-2122-10017165-2_2  | 1619-007        | FY-2122              | September              | 2021              | 4829.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-007        | FY-2122              | January                | 2022              | 4872.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-007        | FY-2122              | February               | 2022              | 4744.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-007        | FY-2122              | May                    | 2022              | 5129.00                   |
    #
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | August                 | 2021              | 2785.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | October                | 2021              | 4435.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | January                | 2022              | 4547.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | February               | 2022              | 5274.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | April                  | 2022              | 2032.00                   |
    | 1619-AS-2122-10017165-2_2  | 1619-011        | FY-2122              | June                   | 2022              | 5632.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2021'

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
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 64688.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64688.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2021'

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
    | Released          | 1               | 64688.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 64688.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017165 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64688.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017165 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017165 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017165 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017165 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 64688.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 20409.00  | 0.00     | 0.00     | 6000.00  | 0.00     | 0.00     | 2282.00  | 0.00     | 2495.00  | 5855.00  | 0.00     | 0.00     | 3777.00  | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 19574.00  | 0.00     | 4829.00  | 0.00     | 0.00     | 0.00     | 4872.00  | 4744.00  | 0.00     | 0.00     | 5129.00  | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 24705.00  | 2785.00  | 0.00     | 4435.00  | 0.00     | 0.00     | 4547.00  | 5274.00  | 0.00     | 2032.00  | 0.00     | 5632.00  | 0.00     | Alternative Completions - Sporting Excellence               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts (SoF, TaC, Sch1, Sch2, FA, Sch3ON)
    And   the file named '10017165_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £42,263 £22,425 £64,688
    Total Funding for this contract: £64,688
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017165 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017165 Co Ltd THE SECRETARY OF STATE FOR
    27 Belgrade Road
    EDUCATION
    Hampton
    DEPARTMENT FOR EDUCATION
    Middlesex
    20 GREAT SMITH STREET
    AND
    TW12 2AZ
    LONDON
    SW1P 3BT
    Company No: AA017165
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £20,409 £0.00 £0.00 £6,000.00 £0.00 £0.00 £2,282.00 £0.00 £2,495.00 £5,855.00 £0.00 £0.00 £3,777.00
    16-19 Capacity and Delivery £19,574 £0.00 £4,829.00 £0.00 £0.00 £0.00 £4,872.00 £4,744.00 £0.00 £0.00 £5,129.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £24,705 £2,785.00 £0.00 £4,435.00 £0.00 £0.00 £4,547.00 £5,274.00 £0.00 £2,032.00 £0.00 £5,632.00 £0.00
    Total Funding £64,688 £2,785.00 £4,829.00 £10,435.00 £0.00 £0.00 £11,701.00 £10,018.00 £2,495.00 £7,887.00 £5,129.00 £5,632.00 £3,777.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v1.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017165'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017165 - 10017165 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017165 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017165 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017165 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Part 2: Publish and approve contract v1

    # Change the date 
    Given the override date is '04/07/2021'

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
    | 10017165 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 64688.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_LA]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017165 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 20409.00     | 0             | 0        | 16-19 Free Meals                               | ?                           |
    | 10017165 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 19574.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017165 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 24705.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |





    # Part 3: Import FA v2_6 and release RG to add Delivery Org 10027333 and create contract v2 (b)

    # Change the date
    Given the override date is '05/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (08SSF) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6  | 2_6            | 1619                        | AS-2122            | 46737.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10027333-2_6  | 2_6                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6  | 10027333      | Schoo        | 08SSF           | 46737.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | 19039.00         | Payment         |
    | 1619-AS-2122-10027333-2_6  | 1619-006        | 4100.00          | Payment         |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | 23598.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | FY-2122              | August                 | 2021              | 3907.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | FY-2122              | December               | 2021              | 2000.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | FY-2122              | February               | 2022              | 3720.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | FY-2122              | May                    | 2022              | 3624.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-003        | FY-2122              | July                   | 2022              | 5788.00                   |
    #
    | 1619-AS-2122-10027333-2_6  | 1619-006        | FY-2122              | January                | 2022              | 4100.00                   |
    #
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | August                 | 2021              | 5160.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | November               | 2021              | 2569.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | January                | 2022              | 2339.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | February               | 2022              | 4092.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | May                    | 2022              | 5774.00                   |
    | 1619-AS-2122-10027333-2_6  | 1619-021        | FY-2122              | June                   | 2022              | 3664.00                   |
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '06/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA2                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 46737.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA2]        |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 46737.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '07/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA2]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 46737.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 46737.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA2]      |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Retrieve parameters from CRM 
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check that the Contract has been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017165 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 111425.00     | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2.TEST     | Conditions of Funding (Grant) (LA)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017165 Co Ltd  | Active | Document Management Team  | 46737.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017165 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 46737.00        | 10027333      | 10027333 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 19039.00  | 3907.00  | 0.00     | 0.00     | 0.00     | 2000.00  | 0.00     | 3720.00  | 0.00     | 0.00     | 3624.00  | 0.00     | 5788.00  | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 4100.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4100.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 23598.00  | 5160.00  | 0.00     | 0.00     | 2569.00  | 0.00     | 2339.00  | 4092.00  | 0.00     | 0.00     | 5774.00  | 3664.00  | 0.00     | Alternative Completions - Creative Sector                   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices for Delivery Org 10027333
    And   the file named '10017165_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10027333 Co Ltd [AllocRef_16ED] £27,887 £18,850 £46,737
    Total Funding for this contract: £111,425
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10027333 Co Ltd UKPRN: 10027333
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £4,100 £0.00 £0.00 £0.00 £0.00 £0.00 £4,100.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Residential Bursary Fund £19,039 £3,907.00 £0.00 £0.00 £0.00 £2,000.00 £0.00 £3,720.00 £0.00 £0.00 £3,624.00 £0.00 £5,788.00
    Alternative Completions - Creative Sector £23,598 £5,160.00 £0.00 £0.00 £2,569.00 £0.00 £2,339.00 £4,092.00 £0.00 £0.00 £5,774.00 £3,664.00 £0.00
    Total Funding £46,737 £9,067.00 £0.00 £0.00 £2,569.00 £2,000.00 £6,439.00 £7,812.00 £0.00 £0.00 £9,398.00 £3,664.00 £5,788.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v2.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-07 09:12:35.000 |





    # Part 4: Publish and withdraw contract v2 (c)

    # Change the date 
    Given the override date is '08/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A165'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |





    # Part 5: Reinstate and re-release FA v2_2 (d)

    # Change the date 
    Given the override date is '09/07/2021'

    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation                
    | FundingId                                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6  |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                        | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)  | CofG_LA3                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA3 = [CofG_LA3]' is written to the Output window

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 46737.00        |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA3]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 46737.00        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Retrieve parameters from CRM 
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check that the Contract has been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017165 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 111425.00     | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2.TEST     | Conditions of Funding (Grant) (LA)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017165 Co Ltd  | Active | Document Management Team  | 46737.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017165 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 46737.00        | 10027333      | 10027333 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 19039.00  | 3907.00  | 0.00     | 0.00     | 0.00     | 2000.00  | 0.00     | 3720.00  | 0.00     | 0.00     | 3624.00  | 0.00     | 5788.00  | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 4100.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4100.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 23598.00  | 5160.00  | 0.00     | 0.00     | 2569.00  | 0.00     | 2339.00  | 4092.00  | 0.00     | 0.00     | 5774.00  | 3664.00  | 0.00     | Alternative Completions - Creative Sector                   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices for Delivery Org 10027333 (Version number should have changed)
    And   the file named '10017165_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10027333 Co Ltd [AllocRef_16ED] £27,887 £18,850 £46,737
    Total Funding for this contract: £111,425
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10027333 Co Ltd UKPRN: 10027333
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £4,100 £0.00 £0.00 £0.00 £0.00 £0.00 £4,100.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Residential Bursary Fund £19,039 £3,907.00 £0.00 £0.00 £0.00 £2,000.00 £0.00 £3,720.00 £0.00 £0.00 £3,624.00 £0.00 £5,788.00
    Alternative Completions - Creative Sector £23,598 £5,160.00 £0.00 £0.00 £2,569.00 £0.00 £2,339.00 £4,092.00 £0.00 £0.00 £5,774.00 £3,664.00 £0.00
    Total Funding £46,737 £9,067.00 £0.00 £0.00 £2,569.00 £2,000.00 £6,439.00 £7,812.00 £0.00 £0.00 £9,398.00 £3,664.00 £5,788.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v3.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2021-07-09 09:12:35.000 |





    # Part 6: Publish and approve contract v3 (e)

    # Change the date 
    Given the override date is '10/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |





    # Part 7: Import FAs v3_2 and v3_6. Add -ve value funding line to v3_2 (-£600) and +ve value funding line to v3_6 (+£500) (f)

    # Change the date
    Given the override date is '11/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (10LAU) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2     | 3_2            | 1619                        | AS-2122            | 64088.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017165-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2     | 10017165      | Local        | 10LAU           | 64088.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017165-3_2  | 1619-004        | -600.00          | Payment         |
    | 1619-AS-2122-10017165-3_2  | 1619-005        | 20409.00         | Payment         |
    | 1619-AS-2122-10017165-3_2  | 1619-007        | 19574.00         | Payment         |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | 24705.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017165-3_2  | 1619-004        | FY-2122              | December               | 2021              | -225.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-004        | FY-2122              | June                   | 2022              | -375.00                   |
    #
    | 1619-AS-2122-10017165-3_2  | 1619-005        | FY-2122              | October                | 2021              | 6000.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-005        | FY-2122              | January                | 2022              | 2282.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-005        | FY-2122              | March                  | 2022              | 2495.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-005        | FY-2122              | April                  | 2022              | 5855.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-005        | FY-2122              | July                   | 2022              | 3777.00                   |
    #
    | 1619-AS-2122-10017165-3_2  | 1619-007        | FY-2122              | September              | 2021              | 4829.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-007        | FY-2122              | January                | 2022              | 4872.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-007        | FY-2122              | February               | 2022              | 4744.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-007        | FY-2122              | May                    | 2022              | 5129.00                   |
    #
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | August                 | 2021              | 2785.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | October                | 2021              | 4435.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | January                | 2022              | 4547.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | February               | 2022              | 5274.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | April                  | 2022              | 2032.00                   |
    | 1619-AS-2122-10017165-3_2  | 1619-011        | FY-2122              | June                   | 2022              | 5632.00                   |
 
 



    # Populate the stub with 1619 (08SSF) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6  | 3_6            | 1619                        | AS-2122            | 47237.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10027333-3_6  | 3_6                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6  | 10027333      | Schoo        | 08SSF           | 47237.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | 19039.00         | Payment         |
    | 1619-AS-2122-10027333-3_6  | 1619-006        | 4100.00          | Payment         |
    | 1619-AS-2122-10027333-3_6  | 1619-009        | 500.00           | Payment         |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | 23598.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | FY-2122              | August                 | 2021              | 3907.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | FY-2122              | December               | 2021              | 2000.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | FY-2122              | February               | 2022              | 3720.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | FY-2122              | May                    | 2022              | 3624.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-003        | FY-2122              | July                   | 2022              | 5788.00                   |
    #
    | 1619-AS-2122-10027333-3_6  | 1619-006        | FY-2122              | January                | 2022              | 4100.00                   |
    #
    | 1619-AS-2122-10027333-3_6  | 1619-009        | FY-2122              | January                | 2022              | 425.00                    |
    | 1619-AS-2122-10027333-3_6  | 1619-009        | FY-2122              | April                  | 2022              | 75.00                     |
    #
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | August                 | 2021              | 5160.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | November               | 2021              | 2569.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | January                | 2022              | 2339.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | February               | 2022              | 4092.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | May                    | 2022              | 5774.00                   |
    | 1619-AS-2122-10027333-3_6  | 1619-021        | FY-2122              | June                   | 2022              | 3664.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '12/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA4                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 111325.00       |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '13/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA4]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA4 = [CofG_LA4]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 111325.00       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 47237.00    | [ContractNo]  | 4                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA4]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 64088.00    | [ContractNo]  | 4                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA4]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | [CofG_LA4]      | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | [CofG_LA4]      | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    
    # Retrieve parameters from CRM for the Contracting Org (10017165)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017165'

    # Check the contents of the Appendices for the Contracting Org (10017165)
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10017165 Co Ltd [AllocRef_16ED] £42,038 £22,050 £64,088
    Total Funding for this contract: £111,325
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £20,409 £0.00 £0.00 £6,000.00 £0.00 £0.00 £2,282.00 £0.00 £2,495.00 £5,855.00 £0.00 £0.00 £3,777.00
    16-19 Capacity and Delivery £19,574 £0.00 £4,829.00 £0.00 £0.00 £0.00 £4,872.00 £4,744.00 £0.00 £0.00 £5,129.00 £0.00 £0.00
    Residential Support Scheme -£600 £0.00 £0.00 £0.00 £0.00 -£225.00 £0.00 £0.00 £0.00 £0.00 £0.00 -£375.00 £0.00
    Alternative Completions - Sporting Excellence £24,705 £2,785.00 £0.00 £4,435.00 £0.00 £0.00 £4,547.00 £5,274.00 £0.00 £2,032.00 £0.00 £5,632.00 £0.00
    Total Funding £64,088 £2,785.00 £4,829.00 £10,435.00 £0.00 -£225.00 £11,701.00 £10,018.00 £2,495.00 £7,887.00 £5,129.00 £5,257.00 £3,777.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v4
    """

    # Retrieve parameters from CRM for Delivery Org (10027333)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check the contents of the Appendices for Delivery Org 10027333 (Version number should have changed)
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10027333 Co Ltd [AllocRef_16ED] £28,312 £18,925 £47,237
    Total Funding for this contract: £111,325
    Summary of Funding – Page 1
       
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10027333 Co Ltd UKPRN: 10027333
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £4,100 £0.00 £0.00 £0.00 £0.00 £0.00 £4,100.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Residential Bursary Fund £19,039 £3,907.00 £0.00 £0.00 £0.00 £2,000.00 £0.00 £3,720.00 £0.00 £0.00 £3,624.00 £0.00 £5,788.00
    Alternative Completions - Creative Sector £23,598 £5,160.00 £0.00 £0.00 £2,569.00 £0.00 £2,339.00 £4,092.00 £0.00 £0.00 £5,774.00 £3,664.00 £0.00
    SSF High Value Courses Premium £500 £0.00 £0.00 £0.00 £0.00 £0.00 £425.00 £0.00 £0.00 £75.00 £0.00 £0.00 £0.00
    Total Funding £47,237 £9,067.00 £0.00 £0.00 £2,569.00 £2,000.00 £6,864.00 £7,812.00 £0.00 £75.00 £9,398.00 £3,664.00 £5,788.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v4
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v4.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v4a.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 4                     | 0                        | 2021-07-13 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 8: Delete the draft contract amendment (g)

    # Change the date
    Given the override date is '14/07/2021'

    # Trigger WF28 in CRM to issue a delete request against v4 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017165 | [ContractNo]   | 4                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |
  
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 47237.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 64088.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       |





    # Part 9: Reinstate and release FA v3_2 (h)

    # Change the date
    Given the override date is '15/07/2021'

    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation                
    | FundingId                                          |
    | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2  |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                        | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)  | CofG_LA5                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA5 = [CofG_LA5]' is written to the Output window

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 64088.00        |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA5]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 64088.00        |

    # Retrieve parameters from CRM for the Contracting Org (10017165)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017165'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 47237.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 64088.00    | [ContractNo]  | 4                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA5]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | [CofG_LA5]      | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.ReleaseGroup
    Then Release Group '[CofG_LA5]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    
    # Retrieve parameters from CRM for the Contracting Org (10017165)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017165'

    # Check the contents of the Appendices for the Contracting Org (10017165)
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10017165 Co Ltd [AllocRef_16ED] £42,038 £22,050 £64,088
    Total Funding for this contract: £110,825
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £20,409 £0.00 £0.00 £6,000.00 £0.00 £0.00 £2,282.00 £0.00 £2,495.00 £5,855.00 £0.00 £0.00 £3,777.00
    16-19 Capacity and Delivery £19,574 £0.00 £4,829.00 £0.00 £0.00 £0.00 £4,872.00 £4,744.00 £0.00 £0.00 £5,129.00 £0.00 £0.00
    Residential Support Scheme -£600 £0.00 £0.00 £0.00 £0.00 -£225.00 £0.00 £0.00 £0.00 £0.00 £0.00 -£375.00 £0.00
    Alternative Completions - Sporting Excellence £24,705 £2,785.00 £0.00 £4,435.00 £0.00 £0.00 £4,547.00 £5,274.00 £0.00 £2,032.00 £0.00 £5,632.00 £0.00
    Total Funding £64,088 £2,785.00 £4,829.00 £10,435.00 £0.00 -£225.00 £11,701.00 £10,018.00 £2,495.00 £7,887.00 £5,129.00 £5,257.00 £3,777.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v4
    """

    # Retrieve parameters from CRM for Delivery Org (10027333)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check the contents of the Appendices for Delivery Org 10027333 
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10027333 Co Ltd [AllocRef_16ED] £27,887 £18,850 £46,737
    Total Funding for this contract: £110,825
    Summary of Funding – Page 1
    """

    # There shouldn't be a Funding Agreement for the Delivery Org (10027333)
    And   the pdf file does not contain the following text
    """
    Contract Ref: [AllocRef_16ED]
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v4.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v4b.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 4                     | 0                        | 2021-07-15 09:12:35.000 |






    # Part 10: Delete the draft contract amendment and withdraw FA v3_2 and v3_6 (i)
    
    # Change the date
    Given the override date is '16/07/2021'    
    
    # Trigger WF28 in CRM to issue a delete request against v4 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017165 | [ContractNo]   | 4                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)    (This is a 'wait' to ensure CRM is ready before withdrawing the FAs)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 47237.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 64088.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       |

    # Check that the RG has been dis-associated from the FA in PaaS.   This is a 'wait' too.
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | ?               | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |





    # Change the date
    Given the override date is '17/07/2021'   

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Test A165'
    | FundingId                                              | 
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6   | 
    | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2      |

    # Check that the FA in PaaS is withdrawn

    # Check PaaS FundingAllocation.FundingAllocation (J131)   (Disassociate FA from RG and mark FA as withdrawn)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | ?               | Withdrawn         | Withdrawn                         |





    # Part 11: Import and release FAs v4_2 and v4_6 (j)

    # Change the date
    Given the override date is '18/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (10LAU) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-4_2     | 4_2            | 1619                        | AS-2122            | 63200.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017165-4_2  | 4_2                    | 1619-AS-2122-Contract-LocalAuthority-10017165-4_2     | 10017165      | Local        | 10LAU           | 63200.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | 18821.00         | Payment         |
    | 1619-AS-2122-10017165-4_2  | 1619-007        | 19574.00         | Payment         |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | 24805.00         | Payment         |
 
    # Funding Allocation Profile Period (Compared to v2_2, Oct of FundingLine 005 down by £1588 and Feb of FundingLine 011 up by £100)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | FY-2122              | October                | 2021              | 4412.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | FY-2122              | January                | 2022              | 2282.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | FY-2122              | March                  | 2022              | 2495.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | FY-2122              | April                  | 2022              | 5855.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-005        | FY-2122              | July                   | 2022              | 3777.00                   |
    #
    | 1619-AS-2122-10017165-4_2  | 1619-007        | FY-2122              | September              | 2021              | 4829.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-007        | FY-2122              | January                | 2022              | 4872.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-007        | FY-2122              | February               | 2022              | 4744.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-007        | FY-2122              | May                    | 2022              | 5129.00                   |
    #
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | August                 | 2021              | 2785.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | October                | 2021              | 4435.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | January                | 2022              | 4547.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | February               | 2022              | 5374.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | April                  | 2022              | 2032.00                   |
    | 1619-AS-2122-10017165-4_2  | 1619-011        | FY-2122              | June                   | 2022              | 5632.00                   |
 




    # Populate the stub with 1619 (08SSF) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-4_6  | 4_6            | 1619                        | AS-2122            | 46500.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10027333-4_6  | 4_6                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-4_6  | 10027333      | Schoo        | 08SSF           | 46500.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | 19039.00         | Payment         |
    | 1619-AS-2122-10027333-4_6  | 1619-006        | 4100.00          | Payment         |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | 23361.00         | Payment         |
 
    # Funding Allocation Profile Period (Compared to v2_6, Jan of FundingLine 021 down by £237)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | FY-2122              | August                 | 2021              | 3907.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | FY-2122              | December               | 2021              | 2000.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | FY-2122              | February               | 2022              | 3720.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | FY-2122              | May                    | 2022              | 3624.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-003        | FY-2122              | July                   | 2022              | 5788.00                   |
    #
    | 1619-AS-2122-10027333-4_6  | 1619-006        | FY-2122              | January                | 2022              | 4100.00                   |
    #
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | August                 | 2021              | 5160.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | November               | 2021              | 2569.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | January                | 2022              | 2102.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | February               | 2022              | 4092.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | May                    | 2022              | 5774.00                   |
    | 1619-AS-2122-10027333-4_6  | 1619-021        | FY-2122              | June                   | 2022              | 3664.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '19/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA6                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 109700.00       |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '20/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA6]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA6 = [CofG_LA6]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 109700.00       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-4_6    | 4_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 46500.00    | [ContractNo]  | 4                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA6]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-4_2       | 4_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 63200.00    | [ContractNo]  | 4                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA6]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 47237.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 64088.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 46737.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA3]      |
    | 10017165 | 10017165 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 64688.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-4_6    | 4_6            | AS-2122 | 1619                        | 46500.00    | [CofG_LA6]      | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-4_2       | 4_2            | AS-2122 | 1619                        | 63200.00    | [CofG_LA6]      | ?                 | ?                                 |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-3_6    | 3_6            | AS-2122 | 1619                        | 47237.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-3_2       | 3_2            | AS-2122 | 1619                        | 64088.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017165-2_6    | 2_6            | AS-2122 | 1619                        | 46737.00    | [CofG_LA3]      | ContractApproved  | ContractApproved                  |
    | 10017165 | 1619-AS-2122-Contract-LocalAuthority-10017165-2_2       | 2_2            | AS-2122 | 1619                        | 64688.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    
    # Retrieve parameters from CRM for the Contracting Org (10017165)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017165'

    # Check the contents of the Appendices for the Contracting Org (10017165)
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10017165 Co Ltd [AllocRef_16ED] £40,775 £22,425 £63,200
    Total Funding for this contract: £109,700
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £18,821 £0.00 £0.00 £4,412.00 £0.00 £0.00 £2,282.00 £0.00 £2,495.00 £5,855.00 £0.00 £0.00 £3,777.00
    16-19 Capacity and Delivery £19,574 £0.00 £4,829.00 £0.00 £0.00 £0.00 £4,872.00 £4,744.00 £0.00 £0.00 £5,129.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £24,805 £2,785.00 £0.00 £4,435.00 £0.00 £0.00 £4,547.00 £5,374.00 £0.00 £2,032.00 £0.00 £5,632.00 £0.00
    Total Funding £63,200 £2,785.00 £4,829.00 £8,847.00 £0.00 £0.00 £11,701.00 £10,118.00 £2,495.00 £7,887.00 £5,129.00 £5,632.00 £3,777.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v4
    """

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017165 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 109700.00     | 4                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2.TEST     | Conditions of Funding (Grant) (LA)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017165 Co Ltd  | Active | Document Management Team  | -1725.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017165 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 63200.00        | 10017165      | 10017165 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | -1488.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 18821.00  | 0.00     | 0.00     | 4412.00  | 0.00     | 0.00     | 2282.00  | 0.00     | 2495.00  | 5855.00  | 0.00     | 0.00     | 3777.00  | 16-19 Free Meals                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 19574.00  | 0.00     | 4829.00  | 0.00     | 0.00     | 0.00     | 4872.00  | 4744.00  | 0.00     | 0.00     | 5129.00  | 0.00     | 0.00     | 16-19 Capacity and Delivery                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 24805.00  | 2785.00  | 0.00     | 4435.00  | 0.00     | 0.00     | 4547.00  | 5374.00  | 0.00     | 2032.00  | 0.00     | 5632.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |


    # Retrieve parameters from CRM for Delivery Org (10027333)
    When  I retrieve the latest EFA contract details from CRM for provider '10017165' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10027333'

    # Check the contents of the Appendices for Delivery Org 10027333 (Version number should have changed)
    Then  the file named '10017165_[ContractNo]_v4.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017165 Co Ltd UKPRN: 10017165
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10027333 Co Ltd [AllocRef_16ED] £27,650 £18,850 £46,500
    Total Funding for this contract: £109,700
    Summary of Funding – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10027333 Co Ltd UKPRN: 10027333
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £4,100 £0.00 £0.00 £0.00 £0.00 £0.00 £4,100.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Residential Bursary Fund £19,039 £3,907.00 £0.00 £0.00 £0.00 £2,000.00 £0.00 £3,720.00 £0.00 £0.00 £3,624.00 £0.00 £5,788.00
    Alternative Completions - Creative Sector £23,361 £5,160.00 £0.00 £0.00 £2,569.00 £0.00 £2,102.00 £4,092.00 £0.00 £0.00 £5,774.00 £3,664.00 £0.00
    Total Funding £46,500 £9,067.00 £0.00 £0.00 £2,569.00 £2,000.00 £6,202.00 £7,812.00 £0.00 £0.00 £9,398.00 £3,664.00 £5,788.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v4
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017165_[ContractNo]_v4.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A165_v4c.pdf'

#   # Check that the Contract has been created correctly in CRM
#   And   the following Contracts exist in CRM
#   | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#   | 10017165 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 109700.00     | 4                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2.TEST     | Conditions of Funding (Grant) (LA)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017165 Co Ltd  | Active | Document Management Team  | -1725.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017165 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 46500.00        | 10027333      | 10027333 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | -237.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 19039.00  | 3907.00  | 0.00     | 0.00     | 0.00     | 2000.00  | 0.00     | 3720.00  | 0.00     | 0.00     | 3624.00  | 0.00     | 5788.00  | Residential Bursary Fund                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 4100.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4100.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 23361.00  | 5160.00  | 0.00     | 0.00     | 2569.00  | 0.00     | 2102.00  | 4092.00  | 0.00     | 0.00     | 5774.00  | 3664.00  | 0.00     | Alternative Completions - Creative Sector                   |                          |

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 4                     | 0                        | 2021-07-20 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017165 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                 | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider    | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017165 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                 | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017165 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    Given the override date is reset

