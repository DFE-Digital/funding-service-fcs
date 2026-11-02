Feature: UnParkFundingAllocation 33286

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A563 Import v1 of 1619 FA then approve 2122 EDSK contract. Import FAs for v2, v3 and v4. Withdraw v2. Import v5. Withdraw v5. Check CRM and PaaS 

    # Story 33286, Acceptance Criteria F2(5)
    # 1. Import FA1 and add to RG1
    # 2. Release RG1 to create contract v1 then publish and approve
    # 3. Import FA2 and add to RG2
    # 4. Import FA3 and park in PaaS, AwaitingOutcome
    # 5. Import FA4 (same as FA1). FA3 is Discarded\Superseded. FA4 is Parked\AwaitingOutcome
    # 6. Withdraw FA2. FA4 is Discarded\NonMaterialUpdate
    # 7. Import FA5 and add to RG3
    # 8. Withdraw FA5

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017563'
    And   there is no Funding Allocation data in CRM for UKPRN '10017563'
    And   there is no Contract, Task or Workflow data for UKPRN '10017563'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017563'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017563'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017563' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017563' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017563 Co Ltd' with UKPRN '10017563' and OrgId 'ORG0017563' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017563' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017563 | 117563 | 10017563 Co Ltd | 0              | Provider Under Change | Yes           | AA017563      | ?             | 1 Christies Warehouse  | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017563 |





    # Step 1.  Create and Approve contract 


    # Populate the stub with 1619 (01GFE) data for v1_1

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1           | 1_1            | 1619                        | AS-2122            | 22646.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017563-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017563-1_1           | 10017563      | Furth        | 01GFE           | 22646.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | 22646.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | FY-2122              | September              | 2021              | 4970.00                   |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | FY-2122              | November               | 2021              | 4842.00                   |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | FY-2122              | February               | 2022              | 5227.00                   |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | FY-2122              | April                  | 2022              | 4073.00                   |
    | 1619-AS-2122-10017563-1_1  | 1619-002        | FY-2122              | July                   | 2022              | 3534.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2021'

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
    | 10017563 | 10017563 Co Ltd  | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 22646.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 22646.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ?                 | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 22646.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017563' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017563' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017563 | 10017563 Co Ltd  | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 22646.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017563-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017563 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017563 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017563 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 22646.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017563 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017563 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017563 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017563 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 22646.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 22646.00  | 0.00     | 4970.00  | 0.00     | 4842.00  | 0.00     | 0.00     | 5227.00  | 0.00     | 4073.00  | 0.00     | 0.00     | 3534.00  | 16-19 Bursary Funds                                         |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Remove all details from ContractManagement.CreatedContract for a contract
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
 #  And   there are no created contracts for this number '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-03 09:12:35.000 |





    # Publish the contract

    # Change the date 
    Given the override date is '04/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '05/07/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017563 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017563 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017563 | 10017563 Co Ltd  | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 22646.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |




    # Step 2.  Import v2_2


    # Populate the stub with 1619 (01GFE) data for v2_2

    # Change the date 
    Given the override date is '06/07/2020'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2           | 2_2            | 1619                        | AS-2122            | 22600.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017563-2_2  | 2_2                    | 1619-AS-2122-Contract-Provider-10017563-2_2           | 10017563      | Furth        | 01GFE           | 22600.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | 22600.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | FY-2122              | September              | 2021              | 4970.00                   |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | FY-2122              | November               | 2021              | 4800.00                   |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | FY-2122              | February               | 2022              | 5227.00                   |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | FY-2122              | April                  | 2022              | 4073.00                   |
    | 1619-AS-2122-10017563-2_2  | 1619-002        | FY-2122              | July                   | 2022              | 3530.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '07/07/2021'

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
    | 10017563 | 10017563 Co Ltd  | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 22600.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 22600.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | [CofG_College2] | ?                 | ?                     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |





    # Step 3 Import v3_3


    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '08/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3           | 3_3            | 1619                        | AS-2122            | 22500.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017563-3_3  | 3_3                    | 1619-AS-2122-Contract-Provider-10017563-3_3           | 10017563      | Furth        | 01GFE           | 22500.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | 22500.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | FY-2122              | September              | 2021              | 4970.00                   |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | FY-2122              | November               | 2021              | 4800.00                   |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | FY-2122              | February               | 2022              | 5127.00                   |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | FY-2122              | April                  | 2022              | 4073.00                   |
    | 1619-AS-2122-10017563-3_3  | 1619-002        | FY-2122              | July                   | 2022              | 3530.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '09/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3             | 3_3            | AS-2122 | 1619                        | 22500.00    | ?               | Parked            | AwaitingOutcome       |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | [CofG_College2] | ?                 | ?                     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |





    # Step 4.  Import v4_4 and Discard v3_3


    # Populate the stub with 1619 (01GFE) data for v4_4 (same as 1_1)

    # Change the date 
    Given the override date is '10/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-4_4           | 4_4            | 1619                        | AS-2122            | 22646.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017563-4_4  | 4_4                    | 1619-AS-2122-Contract-Provider-10017563-4_4           | 10017563      | Furth        | 01GFE           | 22646.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | 22646.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | FY-2122              | September              | 2021              | 4970.00                   |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | FY-2122              | November               | 2021              | 4842.00                   |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | FY-2122              | February               | 2022              | 5227.00                   |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | FY-2122              | April                  | 2022              | 4073.00                   |
    | 1619-AS-2122-10017563-4_4  | 1619-002        | FY-2122              | July                   | 2022              | 3534.00                   |

 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '11/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-4_4             | 4_4            | AS-2122 | 1619                        | 22646.00    | ?               | Parked            | AwaitingOutcome       |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3             | 3_3            | AS-2122 | 1619                        | 22500.00    | ?               | Discarded         | Superseded            |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | [CofG_College2] | ?                 | ?                     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |





    # Steps 5/6


    # Withdraw v2_2

    # Change the date 
    Given the override date is '12/07/2021'

    # Invoke process to withdraw the NMSS Funding Allocation from Contract Control, leaving the 1619 FA in Scheduling (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                      | 
    | 1619-AS-2122-Contract-Provider-10017563-2_2    | 

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-4_4             | 4_4            | AS-2122 | 1619                        | 22646.00    | ?               | Discarded         | NonMaterialUpdate     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3             | 3_3            | AS-2122 | 1619                        | 22500.00    | ?               | Discarded         | Superseded            |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | ?               | Withdrawn         | Withdrawn             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |





    # Step 7

    # Populate the stub with 1619 (01GFE) data for v5_5

    # Change the date 
    Given the override date is '13/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-5_5           | 5_5            | 1619                        | AS-2122            | 10000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017563-5_5  | 5_5                    | 1619-AS-2122-Contract-Provider-10017563-5_5           | 10017563      | Furth        | 01GFE           | 10000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | 10000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | FY-2122              | September              | 2021              | 2250.00                   |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | FY-2122              | November               | 2021              | 1750.00                   |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | FY-2122              | February               | 2022              | 1000.00                   |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | FY-2122              | April                  | 2022              | 2250.00                   |
    | 1619-AS-2122-10017563-5_5  | 1619-002        | FY-2122              | July                   | 2022              | 2750.00                   |

 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '14/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-5_5             | 5_5            | AS-2122 | 1619                        | 10000.00    | [CofG_College3] | ?                 | ?                     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-4_4             | 4_4            | AS-2122 | 1619                        | 22646.00    | ?               | Discarded         | NonMaterialUpdate     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3             | 3_3            | AS-2122 | 1619                        | 22500.00    | ?               | Discarded         | Superseded            |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | ?               | Withdrawn         | Withdrawn             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |





    # Step 8  


    # Withdraw v5_5

    # Change the date 
    Given the override date is '15/07/2021'

    # Invoke process to withdraw the NMSS Funding Allocation from Contract Control, leaving the 1619 FA in Scheduling (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                      | 
    | 1619-AS-2122-Contract-Provider-10017563-5_5    | 

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-5_5             | 5_5            | AS-2122 | 1619                        | 10000.00    | ?               | Withdrawn         | Withdrawn             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-4_4             | 4_4            | AS-2122 | 1619                        | 22646.00    | ?               | Discarded         | NonMaterialUpdate     |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-3_3             | 3_3            | AS-2122 | 1619                        | 22500.00    | ?               | Discarded         | Superseded            |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-2_2             | 2_2            | AS-2122 | 1619                        | 22600.00    | ?               | Withdrawn         | Withdrawn             |
    | 10017563 | 1619-AS-2122-Contract-Provider-10017563-1_1             | 1_1            | AS-2122 | 1619                        | 22646.00    | [CofG_College]  | ContractApproved  | ContractApproved      |


    # Tidy Up
    And   the override date is reset


