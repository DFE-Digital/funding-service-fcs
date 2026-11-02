Feature: AmendmentType 34055

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A163 Inject and release NLG2122 FA. Approve. Amend and approve 3x (Increase, reduction and no-change in financials) All amendments are type: Variation
    
    # 1. Import FA v2_0 to create draft contract v1
    # 2. Publish and approve contract v1
    # 3. Import FA v3_1 with funding LESS THAN that on FA v2_0 to create draft contract v2 (Variation)
    # 4. Publish and approve contract v2
    # 5. Import FA v4_2 with funding EQUAL TO that on FA v3_1 to create draft contract v3 (Variation)
    # 6. Publish and approve contract v3
    # 7. Import FA v5_3 with funding GREATER THAN that on FA v4_2 to create draft contract v4 (Variation)
    # 8. Publish and approve contract v4  
    
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017163'
    And   there is no Funding Allocation data in CRM for UKPRN '10017163'
    And   there is no Contract, Task or Workflow data for UKPRN '10017163'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017163'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017163'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017163' in the Sharepoint 'NLG-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017163' 
    And   there is no caseload advisor for UKPRN '10017163' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017163 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017163' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017163 Co Ltd' with UKPRN '10017163' and OrgId 'ORG0017163' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017163 | 117163 | 10017163 Co Ltd | 0              | Active                | Yes           | AA017163      | ?             | 31 North House         | North Street           | Carshalton             | Surrey                 | ?                      | ?                      | SM5 2HW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017163 |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-2_0            | 2_0            | NLG                         | AS-2122            | 16650.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017163-2_0   | 2_0                    | NLG-AS-2122-Contract-Provider-10017163-2_0            | 10017163      | Furth        | 02IPP           | 16650.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017163-2_0   | NLG-001         | 16650.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017163-2_0   | NLG-001         | FY-2122              | September              | 2021              | 3294.00                   |
    | NLG-AS-2122-10017163-2_0   | NLG-001         | FY-2122              | January                | 2022              | 4363.00                   |
    | NLG-AS-2122-10017163-2_0   | NLG-001         | FY-2122              | March                  | 2022              | 5159.00                   |
    | NLG-AS-2122-10017163-2_0   | NLG-001         | FY-2122              | June                   | 2022              | 3834.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 16650.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-2_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16650.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | AS-2122 | NLG                         | 16650.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16650.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017163' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017163' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 16650.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-2_0              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017163-2_0              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017163-2_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | AS-2122 | NLG                         | 16650.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017163-2_0              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017163 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 16650.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017163 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017163 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017163 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017163 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 16650.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 16650.00  | 0.00     | 3294.00  | 0.00     | 0.00     | 0.00     | 4363.00  | 0.00     | 5159.00  | 0.00     | 0.00     | 3834.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017163_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017163_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A163_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017163'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017163 - 10017163 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017163 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Step 2: Publish and approve contract v1

    # Change the date 
    Given the override date is '05/07/2021'

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
    | 10017163 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 16650.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-2_0              | 2_0            | AS-2122 | NLG                         | 16650.00    | [NLG]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-2_0              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017163 | [ContractNo]   | 1               | [AllocRef_NLG]   | 116             | 0                     | 16650.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |





    # Step 3: Import FA v3_1 with funding LESS THAN that on FA v2_0 to create contract v2 (Variation)
    
    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '06/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-3_1            | 3_1            | NLG                         | AS-2122            | 16600.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017163-3_1   | 3_1                    | NLG-AS-2122-Contract-Provider-10017163-3_1            | 10017163      | Furth        | 02IPP           | 16600.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017163-3_1   | NLG-001         | 16600.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017163-3_1   | NLG-001         | FY-2122              | September              | 2021              | 3294.00                   |
    | NLG-AS-2122-10017163-3_1   | NLG-001         | FY-2122              | January                | 2022              | 4363.00                   |
    | NLG-AS-2122-10017163-3_1   | NLG-001         | FY-2122              | March                  | 2022              | 5109.00                   |
    | NLG-AS-2122-10017163-3_1   | NLG-001         | FY-2122              | June                   | 2022              | 3834.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '07/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 16600.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG2]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-3_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16600.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | AS-2122 | NLG                         | 16600.00    | [NLG2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG2 = [NLG2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16600.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017163' for FundingType 'NLG' and period '2122'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 16600.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG2]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-3_1              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017163-3_1              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017163-3_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | AS-2122 | NLG                         | 16600.00    | [NLG2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017163-3_1              | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017163 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 16600.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017163 Co Ltd  | Active | Document Management Team  | -50.00                 |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017163 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 16600.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | -50.00                   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 16600.00  | 0.00     | 3294.00  | 0.00     | 0.00     | 0.00     | 4363.00  | 0.00     | 5109.00  | 0.00     | 0.00     | 3834.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017163_[ContractNo]_v2.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017163_[ContractNo]_v2.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A163_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017163'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017163 - 10017163 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017163 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Step 4: Publish and approve contract v2

    # Change the date 
    Given the override date is '09/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 16600.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [NLG2]          |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-3_1              | 3_1            | AS-2122 | NLG                         | 16600.00    | [NLG2]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-3_1              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017163 | [ContractNo]   | 2               | [AllocRef_NLG]   | 116             | 0                     | 16600.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |





    # Step 5: Import FA v4_2 with funding EQUAL TO that on FA v3_1 to create contract v3 (Variation) 
    
    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '10/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-4_2            | 4_2            | NLG                         | AS-2122            | 16600.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017163-4_2   | 4_2                    | NLG-AS-2122-Contract-Provider-10017163-4_2            | 10017163      | Furth        | 02IPP           | 16600.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017163-4_2   | NLG-001         | 16600.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017163-4_2   | NLG-001         | FY-2122              | October                | 2021              | 3294.00                   |
    | NLG-AS-2122-10017163-4_2   | NLG-001         | FY-2122              | January                | 2022              | 4363.00                   |
    | NLG-AS-2122-10017163-4_2   | NLG-001         | FY-2122              | March                  | 2022              | 5109.00                   |
    | NLG-AS-2122-10017163-4_2   | NLG-001         | FY-2122              | June                   | 2022              | 3834.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '11/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG3                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 16600.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG3]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-4_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16600.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | AS-2122 | NLG                         | 16600.00    | [NLG3]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG3]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '12/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG3]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG3 = [NLG3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16600.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017163' for FundingType 'NLG' and period '2122'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 16600.00    | [ContractNo]  | 3                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG3]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-4_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017163-4_2              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017163-4_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | AS-2122 | NLG                         | 16600.00    | [NLG3]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017163-4_2              | [ContractNo] | 3               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG3]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017163 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 16600.00      | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017163 Co Ltd  | Active | Document Management Team  | 0.00                   |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017163 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 16600.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | 0.00                     |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 16600.00  | 0.00     | 0.00     | 3294.00  | 0.00     | 0.00     | 4363.00  | 0.00     | 5109.00  | 0.00     | 0.00     | 3834.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017163_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017163_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A163.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2021-07-12 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract '[ContractNo]' for provider '10017163'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017163 - 10017163 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '3' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017163 | [MasterContractNo] | [ContractNo]   | 3                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Step 6: Publish and approve contract v3

    # Change the date 
    Given the override date is '13/07/2021'

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
    | 10017163 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 16600.00    | [ContractNo]  | 3                 | CRM Integration       | CRM Integration           | ?                         | [NLG3]          |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-4_2              | 4_2            | AS-2122 | NLG                         | 16600.00    | [NLG3]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-4_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '3' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017163 | [ContractNo]   | 3               | [AllocRef_NLG]   | 116             | 0                     | 16600.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |





    # Step 7: Import FA v5_3 with the funding GREATER THAN that on FA v4_2 to create contract v4 (Variation)

    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '14/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-5_3            | 5_3            | NLG                         | AS-2122            | 17600.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017163-5_3   | 5_3                    | NLG-AS-2122-Contract-Provider-10017163-5_3            | 10017163      | Furth        | 02IPP           | 17600.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017163-5_3   | NLG-001         | 17600.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017163-5_3   | NLG-001         | FY-2122              | October                | 2021              | 4294.00                   |
    | NLG-AS-2122-10017163-5_3   | NLG-001         | FY-2122              | January                | 2022              | 4363.00                   |
    | NLG-AS-2122-10017163-5_3   | NLG-001         | FY-2122              | March                  | 2022              | 5109.00                   |
    | NLG-AS-2122-10017163-5_3   | NLG-001         | FY-2122              | June                   | 2022              | 3834.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '15/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG4                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 17600.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG4]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-5_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 17600.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | AS-2122 | NLG                         | 17600.00    | [NLG4]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG4]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '16/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG4]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG4 = [NLG4]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 17600.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017163' for FundingType 'NLG' and period '2122'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 17600.00    | [ContractNo]  | 4                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG4]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-5_3              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017163-5_3              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017163-5_3              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | AS-2122 | NLG                         | 17600.00    | [NLG4]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017163-5_3              | [ContractNo] | 4               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG4]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017163 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 17600.00      | 4                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017163 Co Ltd  | Active | Document Management Team  | 1000.00                |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017163 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 17600.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | 1000.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 16600.00  | 0.00     | 0.00     | 4294.00  | 0.00     | 0.00     | 4363.00  | 0.00     | 5109.00  | 0.00     | 0.00     | 3834.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017163_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017163_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A163.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 4                     | 0                        | 2021-07-16 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '4' of contract '[ContractNo]' for provider '10017163'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017163 - 10017163 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '4' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017163 | [MasterContractNo] | [ContractNo]   | 4                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Step 8: Publish and approve contract v4  

    # Change the date 
    Given the override date is '17/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '4'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017163 | [ContractNo]       | 4                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 3                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017163 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017163 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017163 | 10017163 Co Ltd  | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 17600.00    | [ContractNo]  | 4                 | CRM Integration       | CRM Integration           | ?                         | [NLG4]          |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017163 | NLG-AS-2122-Contract-Provider-10017163-5_3              | 5_3            | AS-2122 | NLG                         | 17600.00    | [NLG4]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017163-5_3              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '4' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017163 | [ContractNo]   | 4               | [AllocRef_NLG]   | 116             | 0                     | 17600.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |


    # Tidy Up
    And   the override date is reset

