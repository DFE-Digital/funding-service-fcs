Feature: OverrideProviderMapping 33280

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A171 Create and release a 1619ED FA for 10088193. Override ProviderType\SubType (Furth\02IPP) with College. Publish and approve. Amend. Override again. Publish and approve. . Check CRM, PaaS and Feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10088193'
    And   there is no Funding Allocation data in CRM for UKPRN '10088193'
    And   there is no Contract, Task or Workflow data for UKPRN '10088193'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10088193'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10088193'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10088193' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10088193' 
    And   there is no caseload advisor for UKPRN '10088193' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10088193 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10088193' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10088193 Co Ltd' with UKPRN '10088193' and OrgId 'ORG0088193' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10088193 | 188193 | 10088193 Co Ltd | 0              | Active                | Yes           | AA088193      | ?             | 26 The Forbury         | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 3EJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10088193 |





    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-1_3           | 1_3            | 1619                        | AS-2122            | 26806.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10088193-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10088193-1_3           | 10088193      | Furth        | 02IPP           | 26806.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10088193-1_3  | 1619-001        | 10555.00         | Payment         |
    | 1619-AS-2122-10088193-1_3  | 1619-006        | 7285.00          | Payment         |
    | 1619-AS-2122-10088193-1_3  | 1619-008        | 8966.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10088193-1_3  | 1619-001        | FY-2122              | August                 | 2021              | 4182.00                   |
    | 1619-AS-2122-10088193-1_3  | 1619-001        | FY-2122              | December               | 2021              | 2174.00                   |
    | 1619-AS-2122-10088193-1_3  | 1619-001        | FY-2122              | July                   | 2022              | 4199.00                   |
    #
    | 1619-AS-2122-10088193-1_3  | 1619-006        | FY-2122              | September              | 2021              | 4698.00                   |
    | 1619-AS-2122-10088193-1_3  | 1619-006        | FY-2122              | May                    | 2022              | 2587.00                   |
    #
    | 1619-AS-2122-10088193-1_3  | 1619-008        | FY-2122              | October                | 2021              | 4531.00                   |
    | 1619-AS-2122-10088193-1_3  | 1619-008        | FY-2122              | April                  | 2022              | 4435.00                   |
 
 
 
 
 
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
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 26806.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-1_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 26806.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | AS-2122 | 1619                        | 26806.00    | [CofG_College]  | ?                 | ?                                 |

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
    | Released          | 1               | 26806.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10088193' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10088193' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 26806.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-1_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10088193-1_3             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10088193-1_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | AS-2122 | 1619                        | 26806.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10088193-1_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10088193 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10088193 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10088193 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 26806.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10088193 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10088193 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10088193 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10088193 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 26806.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 10555.00  | 4182.00  | 0.00     | 0.00     | 0.00     | 2174.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4199.00  | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 7285.00   | 0.00     | 4698.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2587.00  | 0.00     | 0.00     | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 8966.00   | 0.00     | 0.00     | 4531.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4435.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that Contract Type has been overridden in the Appendix
    And   the file named '10088193_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10088193_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A171_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-05 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10088193'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10088193 - 10088193 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10088193 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10088193 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10088193 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10088193 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10088193 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 26806.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-1_3             | 1_3            | AS-2122 | 1619                        | 26806.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-1_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10088193 | [ContractNo]   | 1               | [AllocRef_16ED]  | 20              | 0                     | 10555.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10088193 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 7285.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10088193 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 8966.00      | 0             | 0        | 16-19 Advanced Maths Premium                   | ?                           |





    # Amend the contract and override the Contract Type again

    # Change the date
    Given the override date is '11/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Simulate a change in CofG_College template (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-07-10 12:00:00.000 | 



    # Populate the stub with 1619 (02IPP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-2_5           | 2_5            | 1619                        | AS-2122            | 27806.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10088193-2_5  | 2_5                    | 1619-AS-2122-Contract-Provider-10088193-2_5           | 10088193      | Furth        | 02IPP           | 27806.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10088193-2_5  | 1619-001        | 10555.00         | Payment         |
    | 1619-AS-2122-10088193-2_5  | 1619-006        | 8285.00          | Payment         |
    | 1619-AS-2122-10088193-2_5  | 1619-008        | 8966.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10088193-2_5  | 1619-001        | FY-2122              | August                 | 2021              | 4182.00                   |
    | 1619-AS-2122-10088193-2_5  | 1619-001        | FY-2122              | December               | 2021              | 2174.00                   |
    | 1619-AS-2122-10088193-2_5  | 1619-001        | FY-2122              | July                   | 2022              | 4199.00                   |
    #
    | 1619-AS-2122-10088193-2_5  | 1619-006        | FY-2122              | September              | 2021              | 4698.00                   |
    | 1619-AS-2122-10088193-2_5  | 1619-006        | FY-2122              | May                    | 2022              | 3587.00                   |
    #
    | 1619-AS-2122-10088193-2_5  | 1619-008        | FY-2122              | October                | 2021              | 4531.00                   |
    | 1619-AS-2122-10088193-2_5  | 1619-008        | FY-2122              | April                  | 2022              | 4435.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '13/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 27806.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 27806.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | AS-2122 | 1619                        | 27806.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '15/07/2021'

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
    | Released          | 1               | 27806.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10088193' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10088193' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 27806.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-2_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10088193-2_5             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10088193-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | AS-2122 | 1619                        | 27806.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10088193-2_5             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10088193 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10088193 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10088193 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10088193 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 27806.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2.TEST     | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10088193 Co Ltd  | Active | Document Management Team  | 1000.00                |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10088193 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 27806.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 1000.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                  | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 10555.00  | 4182.00  | 0.00     | 0.00     | 0.00     | 2174.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4199.00  | 16-19 Programme Funding          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 8285.00   | 0.00     | 4698.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3587.00  | 0.00     | 0.00     | 16-19 High Needs Element 2       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 8966.00   | 0.00     | 0.00     | 4531.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4435.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium     |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10088193_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10088193_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A171_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-15 09:12:35.000 |





    # Publish the contract

    # Change the date 
    Given the override date is '17/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '19/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10088193 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10088193 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10088193 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10088193 | 10088193 Co Ltd  | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 27806.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College2] |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10088193 | 1619-AS-2122-Contract-Provider-10088193-2_5             | 2_5            | AS-2122 | 1619                        | 27806.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10088193-2_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10088193 | [ContractNo]   | 2               | [AllocRef_16ED]  | 20              | 0                     | 10555.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10088193 | [ContractNo]   | 2               | [AllocRef_16ED]  | 22              | 0                     | 8285.00      | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10088193 | [ContractNo]   | 2               | [AllocRef_16ED]  | 914             | 0                     | 8966.00      | 0             | 0        | 16-19 Advanced Maths Premium                   | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: A172 Create and release a 1619ED FA for 10007477. Override ProviderType\SubType (N1618\16NPF) with ITP. Publish and approve. Check CRM, PaaS and CM Feed
    
    # Story 34357
       
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10007477'
    And   there is no Funding Allocation data in CRM for UKPRN '10007477'
    And   there is no Contract, Task or Workflow data for UKPRN '10007477'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10007477'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10007477'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10007477' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10007477' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10007477 Co Ltd' with UKPRN '10007477' and OrgId 'ORG0017172' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10007477' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10007477 | 007477 | 10007477 Co Ltd | 0              | In Administration     | Yes           | AA007477      | ?             | 72 Brackenwoods        | Necton                 | ?                      | ?                      | Swaffham               | Norfolk                | PE37 8EX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10007477 |





    # Populate the stub with data for ProviderType N1618 and ProviderSubType 16NPF

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10007477 | 1619-AS-2122-Contract-Provider-10007477-2_0           | 2_0            | 1619                        | AS-2122            | 13584.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10007477-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10007477-2_0           | 10007477      | N1618        | 16NPF           | 13584.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10007477-2_0  | 1619-007        | 13584.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10007477-2_0  | 1619-007        | FY-2122              | September              | 2021              | 4439.00                   |
    | 1619-AS-2122-10007477-2_0  | 1619-007        | FY-2122              | February               | 2022              | 5235.00                   |
    | 1619-AS-2122-10007477-2_0  | 1619-007        | FY-2122              | May                    | 2022              | 3910.00                   |
 
 
 
 
 
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
    | 10007477 | 10007477 Co Ltd  | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 13584.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10007477-2_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13584.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007477 | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | AS-2122 | 1619                        | 13584.00    | [CfS_ITP]       | ?                 | ?                                 |

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
    | Released          | 1               | 13584.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10007477' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10007477' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10007477 | 10007477 Co Ltd  | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 13584.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10007477-2_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10007477-2_0             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10007477-2_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007477 | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | AS-2122 | 1619                        | 13584.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10007477-2_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10007477 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10007477 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10007477 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 13584.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10007477 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10007477 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10007477 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10007477 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 13584.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 13584.00  | 0.00     | 4439.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5235.00  | 0.00     | 0.00     | 3910.00  | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10007477_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10007477 Co Ltd UKPRN: 10007477
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £9,674 £3,910 £13,584
    Total Funding for this contract: £13,584
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10007477 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10007477 Co Ltd THE SECRETARY OF STATE FOR
    72 Brackenwoods EDUCATION
    Necton DEPARTMENT FOR EDUCATION
    Swaffham 20 GREAT SMITH STREET
    AND
    Norfolk LONDON
    PE37 8EX SW1P 3BT
    Company No: AA007477
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
    Provider: 10007477 Co Ltd UKPRN: 10007477
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Capacity and Delivery £13,584 £0.00 £4,439.00 £0.00 £0.00 £0.00 £0.00 £5,235.00 £0.00 £0.00 £3,910.00 £0.00 £0.00
    Total Funding £13,584 £0.00 £4,439.00 £0.00 £0.00 £0.00 £0.00 £5,235.00 £0.00 £0.00 £3,910.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10007477_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A172.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10007477'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10007477 - 10007477 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10007477 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10007477 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10007477 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10007477 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10007477 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10007477 | 10007477 Co Ltd  | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 13584.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10007477 | 1619-AS-2122-Contract-Provider-10007477-2_0             | 2_0            | AS-2122 | 1619                        | 13584.00    | [CfS_ITP]       | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10007477-2_0             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10007477 | [ContractNo]   | 1               | [AllocRef_16ED]  | 112             | 0                     | 13584.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A173 Create and release an NMSS FA for 10016839. Override HEI(07HEP) with ITP. Publish and approve. Check CRM, PaaS and CM Feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10016839'
    And   there is no Funding Allocation data in CRM for UKPRN '10016839'
    And   there is no Contract, Task or Workflow data for UKPRN '10016839'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10016839'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10016839'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10016839' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10016839' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10016839 Co Ltd' with UKPRN '10016839' and OrgId 'ORG0016839' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10016839' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10016839 | 116839 | 10016839 Co Ltd | 0              | Active                | Yes           | AA016839      | ?             | 884 Plymouth Road      | ?                      | ?                      | ?                      | Slough                 | Berkshire              | SL1 4SH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10016839 |





    # Populate the stub 

    # Change the date 
    Given the override date is '15/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10016839 | NMSS-AY-2122-Contract-Provider-10016839-2_2           | 2_2            | NMSS                        | AY-2122            | 68230.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10016839-2_2  | 2_2                    | NMSS-AY-2122-Contract-Provider-10016839-2_2           | 10016839      | Furth        | 07HEP           | 68230.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | 19611.00         | Payment         |
    | NMSS-AY-2122-10016839-2_2  | NMSS-004        | 5533.00          | Payment         |
    | NMSS-AY-2122-10016839-2_2  | NMSS-005        | 14566.00         | Payment         |
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | 20000.00         | Payment         |
    | NMSS-AY-2122-10016839-2_2  | NMSS-008        | 8520.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | FY-2122              | October                | 2021              | 4548.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | FY-2122              | November               | 2021              | 3325.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | FY-2122              | March                  | 2022              | 5932.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | FY-2122              | May                    | 2022              | 2112.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-003        | FY-2122              | June                   | 2022              | 3694.00                   |
    #
    | NMSS-AY-2122-10016839-2_2  | NMSS-004        | FY-2122              | December               | 2021              | 5533.00                   |
    #
    | NMSS-AY-2122-10016839-2_2  | NMSS-005        | FY-2122              | November               | 2021              | 4481.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-005        | FY-2122              | December               | 2021              | 4423.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-005        | FY-2122              | July                   | 2022              | 5662.00                   |
    #
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | FY-2122              | August                 | 2021              | 3072.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | FY-2122              | December               | 2021              | 3937.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | FY-2122              | February               | 2022              | 3467.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | FY-2122              | April                  | 2022              | 4877.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-006        | FY-2122              | July                   | 2022              | 4647.00                   |
    #
    | NMSS-AY-2122-10016839-2_2  | NMSS-008        | FY-2122              | December               | 2021              | 4973.00                   |
    | NMSS-AY-2122-10016839-2_2  | NMSS-008        | FY-2122              | April                  | 2022              | 3547.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '18/07/2020'

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
    | 10016839 | 10016839 Co Ltd  | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 68230.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-Provider-10016839-2_2             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 68230.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10016839 | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | AY-2122 | NMSS                        | 68230.00    | [CfS_ITP]       | ?                 | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '21/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 68230.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10016839' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10016839' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10016839 | 10016839 Co Ltd  | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Released          | Released          | 68230.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10016839-2_2             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NMSS-AY-2122-Contract-Provider-10016839-2_2             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10016839-2_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10016839 | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | AY-2122 | NMSS                        | 68230.00    | [CfS_ITP]       | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10016839-2_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10016839 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10016839 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10016839 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 68230.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10016839 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10016839 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10016839 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10016839 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 68230.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 19611.00  | 0.00     | 0.00     | 4548.00  | 3325.00  | 0.00     | 0.00     | 0.00     | 5932.00  | 0.00     | 2112.00  | 3694.00  | 0.00     | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 5533.00   | 0.00     | 0.00     | 0.00     | 0.00     | 5533.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 14566.00  | 0.00     | 0.00     | 0.00     | 4481.00  | 4423.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5662.00  | Primary PE and Sport Premium (1)                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 20000.00  | 3072.00  | 0.00     | 0.00     | 0.00     | 3937.00  | 0.00     | 3467.00  | 0.00     | 4877.00  | 0.00     | 0.00     | 4647.00  | Teachers Pay Grant (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 8520.00   | 0.00     | 0.00     | 0.00     | 0.00     | 4973.00  | 0.00     | 0.00     | 0.00     | 3547.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Remove all details from ContractManagement.CreatedContract for a contract
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
 #  And   there are no created contracts for this number '[ContractNo]'






    # Publish the contract

    # Change the date 
    Given the override date is '24/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '27/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10016839 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10016839 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10016839 | 10016839 Co Ltd  | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 68230.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10016839 | NMSS-AY-2122-Contract-Provider-10016839-2_2             | 2_2            | AY-2122 | NMSS                        | 68230.00    | [CfS_ITP]       | ContractApproved  | ContractApproved      |
    
    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-Provider-10016839-2_2             | Contract Approved    | CRM Integration   | Contract Approved  | Contract Approved     | Released       | Released              | ?                     |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10016839 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 19611.00     | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10016839 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 5533.00      | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10016839 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 14566.00     | 0             | 0        | Primary PE and Sport Premium (1)                   | ?                           |
    | 10016839 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 20000.00     | 0             | 0        | Teachers Pay Grant (NMSS)                      | ?                           |
    | 10016839 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 8520.00      | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |


    # Tidy Up
    And   the override date is reset
