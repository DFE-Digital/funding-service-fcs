Feature: RevisedNew 33716

@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: A564 Create and release a 1619 FA on a 2122 EDSK contract. Publish then withdraw contract v1. Retrieve FA from withdrawn contract. Reinstate FA1. Import and park FA2. Withdraw FA1. Release FA2 to create Revised New contract v2. Publish and approve. Check CRM, PaaS and Feed.

    # 1. Create and release 1619 FA1
    # 2. Publish then withdraw contract v1 
    # 3. FA1 is now Scheduling\Returned to Scheduling
    # 4. Reinstate FA1 -> Scheduling\Awaiting Release and add to RG2
    # 5. Import FA2 to replace FA1
    # 6. FA2 is parked. (Awaiting Outcome of FA1)
    # 7. Withdraw FA1 which releases FA2 and puts it into RG2
    # 8. Release RG2 to create a Revised New contract v2   
    # 9. Publish and approve contract v2 
    
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017564'
    And   there is no Funding Allocation data in CRM for UKPRN '10017564'
    And   there is no Contract, Task or Workflow data for UKPRN '10017564'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017564'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017564'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017564' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017564' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017564 Co Ltd' with UKPRN '10017564' and OrgId 'ORG0017564' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017564' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017564 | 117564 | 10017564 Co Ltd | 0              | Active                | Yes           | AA017564      | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017564 |


    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

    # Load FundingAllocation.AllocationLineConfig (J144)
    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with 1619 (05ADC) data

    # Change the date 
    Given the override date is '26/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7           | 1_7            | 1619                        | AS-2021            | 2279.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017564-1_7  | 1_7                    | 1619-AS-2021-Contract-Provider-10017564-1_7           | 10017564      | Furth        | 05ADC           | 2279.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017564-1_7  | 1619-008        | 2279.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017564-1_7  | 1619-008        | FY-2021              | February               | 2021              | 2279.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '28/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 2279.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017564-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 2279.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | [CofG_College]  | ?                 | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '30/06/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 2279.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017564' for FundingType 'EDSK' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017564' for FundingType 'EDSK' and period '2021' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released          | Released          | 2279.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017564-1_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2021-Contract-Provider-10017564-1_7             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2021-Contract-Provider-10017564-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | [CofG_College]  | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017564-1_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017564 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017564 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017564 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 2279.00       | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017564 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017564 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017564 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017564 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 2279.00         | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 2279.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2279.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017564_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017564_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A564.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2020-06-30 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017564'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017564 - 10017564 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017564 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017564 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017564 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '02/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Withdraw the contract

    # Change the date 
    Given the override date is '04/07/2020'

    # Withdraw contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Veni vidi vici'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017564 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the CRM Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017564 | [MasterContractNo] | [ContractNo]   | 1                     | Withdrawal On Behalf Of Provider Successful | CRM Integration               | FCS2 TEST        | Document Management Team    | Withdrawn         | Withdrawn By Provider                        | FCS2 TEST             | Document Management Team  | Draft          | Withdrawal In Progress                       |
    | 10017564 | [MasterContractNo] | [ContractNo]   | 1                     | Withdraw On Behalf Of Provider              | FCS1 TEST                     | FCS2 TEST        | Document Management Team    | Draft             | Withdrawal In Progress                       | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                             |
    | Withdrawal On Behalf Of Provider Successful    | CRM Integration               | ?                                   |
    | Withdraw On Behalf Of Provider                 | FCS1 TEST                     | Veni vidi vici                      |

    # Check the state of a Release Group (J129)  (The FA has been removed from the RG)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 0               | 0.00            |

    # Write the value of the ReleaseGroupParameterName to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)   Set state to Scheduling\Returned to Scheduling. Disassociate FA from RG
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Returned to Scheduling  | 2279.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | ?               | ?                 | ?                     |

    # Note: The FA is in a state of 'Scheduling\Returned to Scheduling' and would need to be REINSTATED to change it to 'Scheduling\Awaiting Release'. 
    #   Only then does the system put the FA into a Release Group





    # Reinstate FA v1_7

    # Change the date 
    Given the override date is '06/07/2020'

    # Move FA from 'Return to Scheduling' to 'Awaiting Release' (J136)
    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation
    | FundingId                                      |
    | 1619-AS-2021-Contract-Provider-10017564-1_7    |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the value of the ReleaseGroupParameterName to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College] CofG_College2 = [CofG_College2]' is written to the Output window
    
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Awaiting Release        | 2279.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |
   
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | [CofG_College2] | ?                 | ?                                 |

    # Check the state of a Release Group (J129)  (The FA has been removed from the RG)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 2279.00         |





   # Populate the stub with a later version of the FA1619 (05ADC) data  (This is to replace v1_7)

    # Change the date 
    Given the override date is '08/07/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-2_1           | 2_1            | 1619                        | AS-2021            | 16530.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017564-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10017564-2_1           | 10017564      | Furth        | 05ADC           | 16530.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017564-2_1  | 1619-002        | 16530.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017564-2_1  | 1619-002        | FY-2021              | September              | 2020              | 5205.00                   |
    | 1619-AS-2021-10017564-2_1  | 1619-002        | FY-2021              | December               | 2020              | 2000.00                   |
    | 1619-AS-2021-10017564-2_1  | 1619-002        | FY-2021              | April                  | 2021              | 4676.00                   |
    | 1619-AS-2021-10017564-2_1  | 1619-002        | FY-2021              | June                   | 2021              | 4649.00                   |
 
 
 
 
 
    # Consume stub data 
 
    # Change the date 
    Given the override date is '10/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Awaiting Release        | 2279.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | AS-2021 | 1619                        | 16530.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | [CofG_College2] | ?                 | ?                                 |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 2279.00         |

     # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Withdraw FA v1_7  (This should allow v2_1 to come through into a second RG: CofG_College2)
    
    # Change the date 
    Given the override date is '12/07/2020'

    # Invoke process to withdraw the NMSS Funding Allocation from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2021-Contract-Provider-10017564-1_7  |     
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | AS-2021 | 1619                        | 16530.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | AS-2021 | 1619                        | 2279.00     | ?               | Withdrawn         | Withdrawn                         |
    
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Awaiting Release        | 16530.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2] |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-1_7             | 1_7            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Withdrawn          | Withdrawn               | 2279.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |

    
    
    

    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '14/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16530.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017564' for FundingType 'EDSK' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017564' for FundingType 'EDSK' and period '2021' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125)  Contract no and version no (v2) added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released          | Released          | 16530.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017564-2_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2021-Contract-Provider-10017564-2_1             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2021-Contract-Provider-10017564-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | AS-2021 | 1619                        | 16530.00    | [CofG_College2] | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo    | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017564-2_1             | [ContractNo]  | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017564 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017564 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                    | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017564 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017564 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 16530.00      | 2                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017564 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017564 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017564 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017564 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 16530.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 16530.00  | 0.00     | 5205.00  | 0.00     | 0.00     | 2000.00  | 0.00     | 0.00     | 0.00     | 4676.00  | 0.00     | 4649.00  | 0.00     | 16-19 Bursary Funds                                         |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017564_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017564_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A564.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2020-06-30 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017564'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017564 - 10017564 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017564 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '16/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '18/07/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017564 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017564 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider   | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017564 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017564 | 10017564 Co Ltd  | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Contract Approved | Contract Approved | 16530.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College2] |
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017564 | 1619-AS-2021-Contract-Provider-10017564-2_1             | 2_1            | AS-2021 | 1619                        | 16530.00    | [CofG_College2] | ContractApproved  | ContractApproved      |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017564-2_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017564 | [ContractNo]   | 2               | [AllocRef_16ED]  | 19              | 0                     | 16530.00     | 0             | 0        | 16-19 Bursary Funds                            | ?                           |


    # Tidy Up
    And   the override date is reset

