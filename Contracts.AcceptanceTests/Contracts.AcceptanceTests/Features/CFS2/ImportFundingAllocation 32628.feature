Feature: ImportFundingAllocation 32628

@AcceptanceTest @Withdrawn20210512
@CFS
Scenario: A519 Import and release a 1619ED CFS Funding Allocation with five Funding Allocation Lines and full CFS code mapping. Check CRM contract details
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017519'
    And   there is no Funding Allocation data in CRM for UKPRN '10017519'
    And   there is no Contract, Task or Workflow data for UKPRN '10017519'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017519'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017519'
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017519' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10017519' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017519' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017519 Co Ltd' with UKPRN '10017519' and OrgId 'ORG0017519' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017519' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017519 | 117519 | 10017519 Co Ltd | 0              | Active                | Yes           | AA017519      | ?             | 14 Elmfield West       | Millbrook Rd West      | ?                      | ?                      | Southampton            | Hampshire              | SO15 1JA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017519 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017519 | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | 1619                        | AS-2021            | 46890.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017519-4_4  | 4_4                    | 1619-AS-2021-Contract-Provider-10017519-4_4 | 10017519      | Furth        | 03SFC           | 46890.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017519-4_4  | 1619-005        | 3881.00          | Payment         |
    | 1619-AS-2021-10017519-4_4  | 1619-010        | 5313.00          | Payment         |
    | 1619-AS-2021-10017519-4_4  | 1619-011        | 3908.00          | Payment         |
    | 1619-AS-2021-10017519-4_4  | 1619-020        | 9301.00          | Payment         |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | 24487.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017519-4_4  | 1619-005        | FY-2021              | August                 | 2020              | 3881.00                   |
    #
    | 1619-AS-2021-10017519-4_4  | 1619-010        | FY-2021              | September              | 2020              | 2721.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-010        | FY-2021              | July                   | 2021              | 2592.00                   |
    #
    | 1619-AS-2021-10017519-4_4  | 1619-011        | FY-2021              | March                  | 2021              | 3908.00                   |
    #
    | 1619-AS-2021-10017519-4_4  | 1619-020        | FY-2021              | December               | 2020              | 3740.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-020        | FY-2021              | April                  | 2021              | 5561.00                   |
    #
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | September              | 2020              | 3774.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | November               | 2020              | 4639.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | December               | 2020              | 4169.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | February               | 2021              | 5580.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | May                    | 2021              | 4287.00                   |
    | 1619-AS-2021-10017519-4_4  | 1619-021        | FY-2021              | July                   | 2021              | 2038.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017519 | 10017519 Co Ltd  | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 46890.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10017519-4_4       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Capture the EDSK [ReleaseGroup] parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017519 | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | AS-2021 | 1619                        | 46890.00    | [CofG_College] |





    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Check the state of the EDSK Release Group (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 46890.00        |

    # Release EDSK Funding Allocations from Contract Control (J128) 
   #When  a request is triggered to release the Funding Allocations in Release Group '[ReleaseGroup]'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CofG_College]   |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017519' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017519 | 10017519 Co Ltd  | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released          | Released          | 46890.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017519 | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | AS-2021 | 1619                        | 46890.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017519-4_4       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017519 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017519 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017519 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 46890.00      | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017519 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 46890.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                | DeliverableDescription  |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 3881.00   | 3881.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                               |                         |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 5313.00   | 0.00     | 2721.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2592.00  | Teacher's Pension Scheme 1619                  |                         |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 3908.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3908.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence  |                         |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 9301.00   | 0.00     | 0.00     | 0.00     | 0.00     | 3740.00  | 0.00     | 0.00     | 0.00     | 5561.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing          |                         |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 24487.00  | 0.00     | 3774.00  | 0.00     | 4639.00  | 4169.00  | 0.00     | 5580.00  | 0.00     | 0.00     | 4287.00  | 0.00     | 2038.00  | Alternative Completions - Creative Sector      |                         |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017519 - 10017519 Co Ltd Awaiting documentation  | [AllocRef_16ED  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017519 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date
    Given the override date is '26/06/2021'

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
    | 10017519 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017519 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017519 | 10017519 Co Ltd  | 1619-AS-2021-Contract-Provider-10017519-4_4       | 4_4            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Contract Approved | Contract Approved | 46890.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      | 
    | 10017519 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 3881.00      | 0             | 0        | 16-19 Free Meals                               | ?                           |
    | 10017519 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 5313.00      | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017519 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 3908.00      | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017519 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 9301.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |
    | 10017519 | [ContractNo]   | 1               | [AllocRef_16ED]  | 53              | 0                     | 24487.00     | 0             | 0        | Alternative Completions - Creative Sector      | ?                           |





#    # Attempt to release the Release Group a second time. Check CRM Notification
#
#    # Release EDSK Funding Allocations from Contract Control (J128) 
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup     |
#    | [CofG_College]   |
#
#    # Check that a NOTIFICATION has been created explaining why the release failed
#   #And   there are notifications of type 'Contract Closure Failed' owned by the 'Lead Manager Team' as follows
#   #And   there are notifications of type 'Contract Closure Failed' owned by the user 'FCS1 Test' as follows
#    Then  there is '1' notification of type 'Release Rejected' owned by user 'CRM Integration' which matches the following
#    | Status | NotificationName                   | NotificationText                                                                                                                         |
#    | New    | Release Rejected - [CofG_College]  | Release of [CofG_College] has been rejected because it has either been released before or has no Funding Allocations associated with it  |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
@CFS
Scenario: A520 Import and release an NLG CFS Funding Allocation with several NLG Funding Allocation Lines and full CFS code mapping. Check CRM contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017520'
    And   there is no Funding Allocation data in CRM for UKPRN '10017520'
    And   there is no Contract, Task or Workflow data for UKPRN '10017520'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017520' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType              |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant        |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017520' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017520 Co Ltd' with UKPRN '10017520' and OrgId 'ORG0017520' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017520' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017520 | 117520 | 10017520 Co Ltd | 0              | Provider Under Change | Yes           | AA017520      | ?             | 214 Manchester Road    | ?                      | ?                      | ?                      | Altrincham             | Cheshire               | WA14 5LU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017520 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017520 | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | NLG                         | AS-2021            | 18318.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017520-3_6   | 3_6                    | NLG-AS-2021-Contract-Provider-10017520-3_6  | 10017520      | Furth        | 05ADC           | 18318.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017520-3_6   | NLG-001         | 5216.00          | Payment         |
    | NLG-AS-2021-10017520-3_6   | NLG-002         | 13102.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017520-3_6   | NLG-001         | FY-2021              | November               | 2020              | 5216.00                   |
    #
    | NLG-AS-2021-10017520-3_6   | NLG-002         | FY-2021              | October                | 2020              | 2477.00                   |
    | NLG-AS-2021-10017520-3_6   | NLG-002         | FY-2021              | November               | 2020              | 3989.00                   |
    | NLG-AS-2021-10017520-3_6   | NLG-002         | FY-2021              | April                  | 2021              | 2391.00                   |
    | NLG-AS-2021-10017520-3_6   | NLG-002         | FY-2021              | May                    | 2021              | 4245.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017520 | 10017520 Co Ltd  | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 18318.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Capture the [ReleaseGroup] parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |    
      
    # Check the CRM Funding Allocation Workflow History data
    Then    the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | NLG-AS-2021-Contract-Provider-10017520-3_6        | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10017520 | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | AS-2021 | NLG                         | 18318.00    |

    # Check the state of the NLG Release Group (J129)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18318.00        |





    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    ## Release from Contract Control\Scheduling
    #When  a request is triggered to release the following Funding Allocations from Contract Control
    #| FundingId                                         |
    #| NLG-AS-2021-Contract-Provider-10017520-3_6        |
    
    # Capture the NLG [ReleaseGroup] parameter value (J127)
   #Given the Release Group for the following Contracting Profile has been saved
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType             | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant       | NLG                       |
    
    # Check the state of the NLG Release Group (J129)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18318.00        |

    # Release NLG Funding Allocations from Contract Control (J128) 
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [NLG]            |
    
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017520' for FundingType 'NLG' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017520 | 10017520 Co Ltd  | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 18318.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | NLG-AS-2021-Contract-Provider-10017520-3_6        | Release Successful   | CRM Integration   | Released           | Released              | In Release     | Release in Progress   |
    | NLG-AS-2021-Contract-Provider-10017520-3_6        | Initiate Release     | CRM Integration   | In Release         | Release in Progress   | Scheduling     | Awaiting Release      |
    | NLG-AS-2021-Contract-Provider-10017520-3_6        | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       |
    | 10017520 | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | AS-2021 | NLG                         | 18318.00    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2021-Contract-Provider-10017520-3_6        | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017520 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017520 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017520 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 18318.00      | Non-learning Grant                        | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017520 | [ContractNo]   | [AllocRef_NLG]  | NLG               | AY                      | 01/08/2020          | 31/07/2021        | 18318.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                   | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 13102.00  | 0.00     | 0.00     | 2477.00  | 3989.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2391.00  | 4245.00  | 0.00     | 0.00     | Principals Reference Group (PRG)                  |                       |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 5216.00   | 0.00     | 0.00     | 0.00     | 5216.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Isles of Scilly: Boarding and Accommodation Grant |                       |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017520_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017520 Co Ltd UKPRN: 10017520
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Principals Reference Group (PRG) £13,102 £0 £0 £2,477 £3,989 £0 £0 £0 £0 £2,391 £4,245 £0 £0
    Isles of Scilly: Boarding and Accommodation Grant £5,216 £0 £0 £0 £5,216 £0 £0 £0 £0 £0 £0 £0 £0
    Total Funding £18,318 £0 £0 £2,477 £9,205 £0 £0 £0 £0 £2,391 £4,245 £0 £0
    20/21 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017520_[ContractNo]_v1.pdf' in 'NLG-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A520.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017520 - 10017520 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017520 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date
    Given the override date is '26/06/2021'

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
    | 10017520 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017520 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017520 | 10017520 Co Ltd  | NLG-AS-2021-Contract-Provider-10017520-3_6        | 3_6            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Contract Approved | Contract Approved | 18318.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                   | DeliverableDescription      | 
    | 10017520 | [ContractNo]   | 1               | [AllocRef_NLG]   | 101             | 0                     | 13102.00     | 0             | 0        | Principals Reference Group (PRG)                  | ?                           |
    | 10017520 | [ContractNo]   | 1               | [AllocRef_NLG]   | 116             | 0                     | 5216.00      | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
@CFS
Scenario: A521 Import and release a 1619ED CFS Funding Allocation with several NMSS Funding Allocation Lines and full CFS code mapping. Check CRM contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017521'
    And   there is no Funding Allocation data in CRM for UKPRN '10017521'
    And   there is no Contract, Task or Workflow data for UKPRN '10017521'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017521' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                   |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)    |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017521' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017521 Co Ltd' with UKPRN '10017521' and OrgId 'ORG0017521' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017521' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017521 | 117521 | 10017521 Co Ltd | 0              | Active                | Yes           | AA017521      | ?             | 116a High Street       | ?                      | ?                      | ?                      | Hoddesdon              | Hertfordshire          | EN11 8HD  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017521 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017521 | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | NMSS                        | AY-2021            | 18282.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10017521-1_0  | 1_0                    | NMSS-AY-2021-Contract-Provider-10017521-1_0 | 10017521      | Furth        | 02IPP           | 18282.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10017521-1_0  | NMSS-002        | 9254.00          | Payment         |
    | NMSS-AY-2021-10017521-1_0  | NMSS-003        | 9028.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10017521-1_0  | NMSS-002        | FY-2021              | September              | 2020              | 4675.00                   |
    | NMSS-AY-2021-10017521-1_0  | NMSS-002        | FY-2021              | May                    | 2021              | 4579.00                   |
    #
    | NMSS-AY-2021-10017521-1_0  | NMSS-003        | FY-2021              | October                | 2020              | 4116.00                   |
    | NMSS-AY-2021-10017521-1_0  | NMSS-003        | FY-2021              | March                  | 2021              | 4912.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017521 | 10017521 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | NMSS                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 18282.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Capture the NLG [ReleaseGroup] parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                 | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)  | CfS                       |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | NMSS-AY-2021-Contract-Provider-10017521-1_0       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017521 | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | AY-2021 | NMSS                        | 18282.00    | [CfS]          |

    # Check the state of the EDSK Release Group (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18282.00        |





    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release EDSK Funding Allocations from Contract Control (J128) 
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CfS]            |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017521' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017521 | 10017521 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | NMSS                        | 16-19ED2021     | Released          | Released          | 18282.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | NMSS-AY-2021-Contract-Provider-10017521-1_0       | Release Successful   | CRM Integration   | Released           | Released              | In Release     | Release in Progress   |
    | NMSS-AY-2021-Contract-Provider-10017521-1_0       | Initiate Release     | CRM Integration   | In Release         | Release in Progress   | Scheduling     | Awaiting Release      |
    | NMSS-AY-2021-Contract-Provider-10017521-1_0       | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017521 | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | AY-2021 | NMSS                        | 18282.00    | [CfS]          |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2021-Contract-Provider-10017521-1_0       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017521 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017521 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017521 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 18282.00      | Contract for Services (ITP)               | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017521 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 18282.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 9254.00   | 0.00     | 4675.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4579.00  | 0.00     | 0.00     | SSF High Needs Element 2    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 9028.00   | 0.00     | 0.00     | 4116.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4912.00  | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017521 - 10017521 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017521 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date
    Given the override date is '26/06/2021'

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
    | 10017521 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017521 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017521 | 10017521 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017521-1_0       | 1_0            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | NMSS                        | 16-19ED2021     | Contract Approved | Contract Approved | 18282.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                | DeliverableDescription      | 
    | 10017521 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 9254.00      | 0             | 0        | SSF High Needs Element 2       | ?                           |
    | 10017521 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 9028.00      | 0             | 0        | SSF Bursary Funds              | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
Scenario: A522 Import and release a 1619ED CFS Funding Allocation with a PSG Funding Allocation Line and full CFS code mapping. Check CRM contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017522'
    And   there is no Funding Allocation data in CRM for UKPRN '10017522'
    And   there is no Contract, Task or Workflow data for UKPRN '10017522'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017522'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017522'
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017522' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                       |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)        |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017522' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017522 Co Ltd' with UKPRN '10017522' and OrgId 'ORG0017522' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017522' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017522 | 117522 | 10017522 Co Ltd | 0              | Active                | Yes           | AA017522      | ?             | 2 Grenville Buildings  | 12 Cherry Street       | ?                      | ?                      | Birmingham             | West Midlands          | B2 5AR    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017522 |





    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017522 | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | PSG                         | AY-2021            | 24221.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | PSG-AY-2021-10017522-2_4   | 2_4                    | PSG-AY-2021-Contract-Provider-10017522-2_4  | 10017522      | Furth        | 02IPP           | 24221.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | 24221.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | September              | 2020              | 2614.00                   |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | October                | 2020              | 5803.00                   |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | December               | 2020              | 4238.00                   |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | March                  | 2021              | 3870.00                   |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | May                    | 2021              | 3912.00                   |
    | PSG-AY-2021-10017522-2_4   | PSG-001         | FY-2021              | June                   | 2021              | 3784.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017522 | 10017522 Co Ltd  | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | PSG                         | 16-19ED2021     | Scheduling        | Awaiting Release  | 24221.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Capture the EDSK [ReleaseGroup] parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                 | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)  | CofG_ITP                  |
    
    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | PSG-AY-2021-Contract-Provider-10017522-2_4        | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017522 | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | AY-2021 | PSG                         | 24221.00    | [CofG_ITP]     |





    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Check the state of the EDSK Release Group (J129)
    Then  Release Group '[CofG_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 24221.00        |

    # Release EDSK Funding Allocations from Contract Control (J128) 
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CofG_ITP]       |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017522' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017522 | 10017522 Co Ltd  | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | PSG                         | 16-19ED2021     | Released          | Released          | 24221.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | PSG-AY-2021-Contract-Provider-10017522-2_4        | Release Successful   | CRM Integration   | Released           | Released              | In Release     | Release in Progress   |
    | PSG-AY-2021-Contract-Provider-10017522-2_4        | Initiate Release     | CRM Integration   | In Release         | Release in Progress   | Scheduling     | Awaiting Release      |
    | PSG-AY-2021-Contract-Provider-10017522-2_4        | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017522 | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | AY-2021 | PSG                         | 24221.00    | [CofG_ITP]     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2021-Contract-Provider-10017522-2_4        | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017522 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017522 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017522 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 24221.00      | Contract for Services (ITP)               | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017522 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 24221.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                 | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 24221.00  | 0.00     | 2614.00  | 5803.00  | 0.00     | 4238.00  | 0.00     | 0.00     | 3870.00  | 0.00     | 3912.00  | 3784.00  | 0.00     | Primary PE and Sport Premium    |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017522 - 10017522 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017522 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date
    Given the override date is '28/06/2021'

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
    | 10017522 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017522 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017522 | 10017522 Co Ltd  | PSG-AY-2021-Contract-Provider-10017522-2_4        | 2_4            | Education & Skills Funding | AY2021  | Contract for Services (ITP)              | PSG                         | 16-19ED2021     | Contract Approved | Contract Approved | 24221.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                | DeliverableDescription      | 
    | 10017522 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 24221.00     | 0             | 0        | Primary PE and Sport Premium   | ?                           |





#    # Attempt to release the Release Group a second time. Check CRM Notification
#
#    # Release EDSK Funding Allocations from Contract Control (J128) 
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup     |
#    | [CofG_ITP]       |
#
#    # Check that a NOTIFICATION has been created explaining why the release failed
#   #And   there are notifications of type 'Contract Closure Failed' owned by the 'Lead Manager Team' as follows
#   #And   there are notifications of type 'Contract Closure Failed' owned by the user 'FCS1 Test' as follows
#    Then  there is '1' notification of type 'Release Rejected' owned by user 'CRM Integration' which matches the following
#    | Status | NotificationName                   | NotificationText                                                                                                                     |
#    | New    | Release Rejected - [CofG_ITP]      | Release of [CofG_ITP] has been rejected because it has either been released before or has no Funding Allocations associated with it  |


   # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211216
@CFS
Scenario: A531 Import and release a 2122 DADAS CFS Funding Allocation with a DADA Funding Allocation Line and full CFS code mapping. Check CRM contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017531'
    And   there is no Funding Allocation data in CRM for UKPRN '10017531'
    And   there is no Contract, Task or Workflow data for UKPRN '10017531'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017531' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017531 Co Ltd' with UKPRN '10017531' and OrgId 'ORG0017531' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017531' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017531 | 117531 | 10017531 Co Ltd | 0              | Active                | Yes           | AA017531      | ?             | 18 Miles Road          | Clifton                | Bristol                | ?                      | ?                      | ?                      | BS8 2JW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017531 |





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017531 | DADA-AY-2122-Contract-Provider-10017531-4_2           | 4_2            | DADA                        | AY-2122            | 24136.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017531-4_2  | 4_2                    | DADA-AY-2122-Contract-Provider-10017531-4_2           | 10017531      | Furth        | 07HEP           | 24136.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | 24136.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | FY-2122              | October                | 2021              | 4030.00                   |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | FY-2122              | December               | 2021              | 5099.00                   |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | FY-2122              | March                  | 2022              | 5894.00                   |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | FY-2122              | May                    | 2022              | 4570.00                   |
    | DADA-AY-2122-10017531-4_2  | DADA-001        | FY-2122              | June                   | 2022              | 4543.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017531 | 10017531 Co Ltd  | DADA-AY-2122-Contract-Provider-10017531-4_2             | 4_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 24136.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | DADA-AY-2122-Contract-Provider-10017531-4_2             | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017531 | DADA-AY-2122-Contract-Provider-10017531-4_2             | 4_2            | AY-2122 | DADA                        | 24136.00    | [CfS]           | ?                 | ?                                 |





    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '20/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 24136.00        |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017531' for FundingType 'DADA' and period '2122'

    # Check the CRM Funding Allocations data (J125) (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017531 | 10017531 Co Ltd  | DADA-AY-2122-Contract-Provider-10017531-4_2       | 4_2            | Dance and Drama Awards       | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released           | Released                | 24136.00    | DADAS-1950    | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | DADA-AY-2122-Contract-Provider-10017531-4_2       | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | DADA-AY-2122-Contract-Provider-10017531-4_2       | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | DADA-AY-2122-Contract-Provider-10017531-4_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017531 | DADA-AY-2122-Contract-Provider-10017531-4_2             | 4_2            | AY-2122 | DADA                        | 24136.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017531-4_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017531 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017531 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017531 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 24136.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017531 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017531 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017531 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017531 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 24136.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 24136.00  | 0.00     | 0.00     | 4030.00  | 0.00     | 5099.00  | 0.00     | 0.00     | 5894.00  | 0.00     | 4570.00  | 4543.00  | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017531_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017531 Co Ltd UKPRN: 10017531
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £15,023 £9,113 £24,136
    Total: £24,136
    Total Funding for this contract: £24,136
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017531 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number [MasterContractNo]
    DaDA Version 1 (July 2021) Page 1
    
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017531 Co Ltd THE SECRETARY OF STATE FOR
    18 Miles Road EDUCATION ACTING THROUGH
    Clifton THE EDUCATION AND SKILLS
    Bristol FUNDING AGENCY, AN
    BS8 2JW EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    Company No: AA017531 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 1 (July 2021) Page 2
    DaDA Version 1 (July 2021) Page 76

    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 Version 1 (July 2021) – Page 4
    
    SCHEDULE 1: ANNEX 1
    DANCE AND DRAMA AWARD SCHEME (DaDA) INSTITUTION GUIDE TO
    SCHEME RULES AND INCOME ASSESSMENT
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 47
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017531 Co Ltd UKPRN: 10017531
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £24,136 £0 £0 £4,030 £0 £5,099 £0 £0 £5,894 £0 £4,570 £4,543 £0
    Total Funding £24,136 £0 £0 £4,030 £0 £5,099 £0 £0 £5,894 £0 £4,570 £4,543 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017531_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A531.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017531 - 10017531 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017531 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017531 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017531 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017531 | 10017531 Co Ltd  | DADA-AY-2122-Contract-Provider-10017531-4_2       | 4_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 24136.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017531 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 24136.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
@CFS
Scenario: A532 Import and release two 1619 FA's (1619 and NMSS) to create an EDSK2021 contract with full CFS code mapping. Check CRM, docs, contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017532'
    And   there is no Funding Allocation data in CRM for UKPRN '10017532'
    And   there is no Contract, Task or Workflow data for UKPRN '10017532'
    
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017532' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10017532' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017532' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017532 Co Ltd' with UKPRN '10017532' and OrgId 'ORG0017532' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017532' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017532 | 117532 | 10017532 Co Ltd | 0              | Locked Restructure    | Yes           | AA017532      | ?             | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017532 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017532 | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | 1619                        | AS-2021            | 39697.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017532-4_6  | 4_6                    | 1619-AS-2021-Contract-Provider-10017532-4_6 | 10017532      | Furth        | 04AHC           | 39697.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017532-4_6  | 1619-003        | 5735.00          | Payment         |
    | 1619-AS-2021-10017532-4_6  | 1619-010        | 8508.00          | Payment         |
    | 1619-AS-2021-10017532-4_6  | 1619-013        | 6272.00          | Payment         |
    | 1619-AS-2021-10017532-4_6  | 1619-021        | 19182.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017532-4_6  | 1619-003        | FY-2021              | October                | 2020              | 5735.00                   |
    #
    | 1619-AS-2021-10017532-4_6  | 1619-010        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-010        | FY-2021              | January                | 2021              | 2745.00                   |
    #
    | 1619-AS-2021-10017532-4_6  | 1619-013        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-013        | FY-2021              | October                | 2020              | 3849.00                   |
    #
    | 1619-AS-2021-10017532-4_6  | 1619-021        | FY-2021              | June                   | 2021              | 4271.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-021        | FY-2021              | April                  | 2021              | 4501.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-021        | FY-2021              | February               | 2021              | 3091.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-021        | FY-2021              | December               | 2020              | 3561.00                   |
    | 1619-AS-2021-10017532-4_6  | 1619-021        | FY-2021              | October                | 2020              | 3758.00                   |





    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017532 | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | NMSS                        | AY-2021            | 29863.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10017532-3_0  | 3_0                    | NMSS-AY-2021-Contract-Provider-10017532-3_0 | 10017532      | Furth        | 04AHC           | 29863.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10017532-3_0  | NMSS-004        | 2076.00          | Payment         |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | 25383.00         | Payment         |
    | NMSS-AY-2021-10017532-3_0  | NMSS-008        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10017532-3_0  | NMSS-004        | FY-2021              | September              | 2020              | 2076.00                   |
    #
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | June                   | 2021              | 5330.00                   |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | April                  | 2021              | 3850.00                   |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | February               | 2021              | 2301.00                   |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | December               | 2020              | 4860.00                   |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | October                | 2020              | 3653.00                   |
    | NMSS-AY-2021-10017532-3_0  | NMSS-007        | FY-2021              | September              | 2020              | 5389.00                   |
    #
    | NMSS-AY-2021-10017532-3_0  | NMSS-008        | FY-2021              | December               | 2020              | 2404.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017532 | 10017532 Co Ltd  | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 39697.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017532 | 10017532 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 29863.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10017532-4_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NMSS-AY-2021-Contract-Provider-10017532-3_0       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Capture the [ReleaseGroup] parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017532 | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | AS-2021 | 1619                        | 39697.00    | [CofG_College] |
    | 10017532 | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | AY-2021 | NMSS                        | 29863.00    | [CofG_College] |

    # Check the state of a Release Group (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 69560.00        |





    # Capture Release Group name 

    # Change the date 
    Given the override date is '20/06/2021'
   
    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CofG_College]   |

    # Check the state of a Release Group (J129)  (The Status changes but count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 69560.00        |



    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017532' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017532 | 10017532 Co Ltd  | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released          | Released          | 39697.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017532 | 10017532 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2021     | Released          | Released          | 29863.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AS-2021-Contract-Provider-10017532-4_6       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | 1619-AS-2021-Contract-Provider-10017532-4_6       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2021-Contract-Provider-10017532-4_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | NMSS-AY-2021-Contract-Provider-10017532-3_0       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | NMSS-AY-2021-Contract-Provider-10017532-3_0       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | NMSS-AY-2021-Contract-Provider-10017532-3_0       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017532 | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | AS-2021 | 1619                        | 39697.00    | [CofG_College] |
    | 10017532 | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | AY-2021 | NMSS                        | 29863.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017532-4_6       | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2021-Contract-Provider-10017532-3_0       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017532 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017532 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017532 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 69560.00      | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017532 Co Ltd  | Active | Document Management Team  |
    | 10017532 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017532 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType        |
    | 10017532 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 69560.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation  |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 5735.00   | 0.00     | 0.00     | 5735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Residential Bursary Fund                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 8508.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2745.00  | 0.00     | 0.00     | 5763.00  | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 6272.00   | 0.00     | 0.00     | 3849.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2423.00  | Maintained Special SSF Bursary Support         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 19182.00  | 0.00     | 0.00     | 3758.00  | 0.00     | 3561.00  | 0.00     | 3091.00  | 0.00     | 4501.00  | 0.00     | 4271.00  | 0.00     | Alternative Completions - Creative Sector      |                          |
    #
    | [ContractNo]   | [AllocRef_16ED] | 49              | 2076.00   | 0.00     | 2076.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 25383.00  | 0.00     | 5389.00  | 3653.00  | 0.00     | 4860.00  | 0.00     | 2301.00  | 0.00     | 3850.00  | 0.00     | 5330.00  | 0.00     | Teachers Pension Scheme (NMSS)                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 2404.00   | 0.00     | 0.00     | 0.00     | 0.00     | 2404.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017532_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017532 Co Ltd UKPRN: 10017532
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    16 to 19 Education [AllocRef_16ED] £43,422 £26,138 £69,560
    Total Funding for this contract: £69,560
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017532 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    EDSK Version 3 (September 2020) Page 1
    
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017532 Co Ltd THE SECRETARY OF STATE FOR
    100 Harley Street EDUCATION ACTING THROUGH
    London THE EDUCATION AND SKILLS
    W1N 1AF FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    Company No: AA017532 CHEYLESMORE HOUSE
    QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (September 2020) Page 2
    EDSK Version 3 (September 2020) Page 78

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 3 College (June 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 3 College (June 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017532 Co Ltd UKPRN: 10017532
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Maintained Special SSF Bursary Support £6,272 £0.00 £0.00 £3,849.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,423.00
    Residential Bursary Fund £5,735 £0.00 £0.00 £5,735.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Pre-16 Universal Infant Free School Meals £2,076 £0.00 £2,076.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Creative Sector £19,182 £0.00 £0.00 £3,758.00 £0.00 £3,561.00 £0.00 £3,091.00 £0.00 £4,501.00 £0.00 £4,271.00 £0.00
    Teacher's Pension Scheme 1619 £8,508 £0.00 £0.00 £0.00 £0.00 £0.00 £2,745.00 £0.00 £0.00 £5,763.00 £0.00 £0.00 £0.00
    Teachers Pension Scheme (NMSS) £25,383 £0.00 £5,389.00 £3,653.00 £0.00 £4,860.00 £0.00 £2,301.00 £0.00 £3,850.00 £0.00 £5,330.00 £0.00
    Pupil Premium (NMSS) £2,404 £0.00 £0.00 £0.00 £0.00 £2,404.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £69,560 £0.00 £7,465.00 £16,995.00 £0.00 £10,825.00 £2,745.00 £5,392.00 £0.00 £14,114.00 £0.00 £9,601.00 £2,423.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2020) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2020) – Page 1
    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 2 (July 2020) – Page 1
    EDSK Schedule 6 Version 2 (July 2020) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2020) – Page 1
    EDSK Schedule 7 Version 2 (July 2020) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2020) – Page 1
    EDSK Schedule 8 Version 2 (July 2020) – Page 5
    SCHEDULE 9: COLLEGE GOVERNANCE
    EDSK Schedule 9 Version 2 (July 2020) – Page 1
    EDSK Schedule 9 Version 2 (July 2020) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017532_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A532.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017532 - 10017532 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017532 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017532 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017532 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017532 | 10017532 Co Ltd  | 1619-AS-2021-Contract-Provider-10017532-4_6       | 4_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Contract Approved | Contract Approved | 39697.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017532 | 10017532 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017532-3_0       | 3_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2021     | Contract Approved | Contract Approved | 29863.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 33              | 0                     | 5735.00      | 0             | 0        | Residential Bursary Fund                       | ?                           |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 8508.00      | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 18              | 0                     | 6272.00      | 0             | 0        | Maintained Special SSF Bursary Support         | ?                           |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 53              | 0                     | 19182.00     | 0             | 0        | Alternative Completions - Creative Sector      | ?                           |
    #
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 2076.00      | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 25383.00     | 0             | 0        | Teachers Pension Scheme (NMSS)                 | ?                           |
    | 10017532 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 2404.00      | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
@CFS
Scenario: A533 Import and release three CFS FA's (1619, NMSS and NLG) to create an EDSK2021 contract and an NLG2021 contract with full CFS code mapping. Check CRM, docs, contract details and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017533'
    And   there is no Funding Allocation data in CRM for UKPRN '10017533'
    And   there is no Contract, Task or Workflow data for UKPRN '10017533'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017533' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10017533' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017533' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017533 Co Ltd' with UKPRN '10017533' and OrgId 'ORG0017533' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017533' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017533 | 117533 | 10017533 Co Ltd | 0              | Active                | Yes           | AA017533      | ?             | 21 Priory Avenue       | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG4 7SE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017533 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017533 | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | 1619                        | AS-2021            | 59870.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017533-4_3  | 4_3                    | 1619-AS-2021-Contract-Provider-10017533-4_3 | 10017533      | Furth        | 18ISP           | 59870.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017533-4_3  | 1619-002        | 16292.00         | Payment         |
    | 1619-AS-2021-10017533-4_3  | 1619-003        | 14969.00         | Payment         |
    | 1619-AS-2021-10017533-4_3  | 1619-010        | 11887.00         | Payment         |
    | 1619-AS-2021-10017533-4_3  | 1619-020        | 16722.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017533-4_3  | 1619-002        | FY-2021              | May                    | 2021              | 5667.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-002        | FY-2021              | March                  | 2021              | 5454.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-002        | FY-2021              | November               | 2020              | 5171.00                   |
    #
    | 1619-AS-2021-10017533-4_3  | 1619-003        | FY-2021              | July                   | 2021              | 3224.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-003        | FY-2021              | February               | 2021              | 5030.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-003        | FY-2021              | December               | 2020              | 3448.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-003        | FY-2021              | September              | 2020              | 3267.00                   |
    #
    | 1619-AS-2021-10017533-4_3  | 1619-010        | FY-2021              | June                   | 2021              | 2431.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-010        | FY-2021              | December               | 2020              | 5775.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-010        | FY-2021              | September              | 2020              | 3681.00                   |
    #
    | 1619-AS-2021-10017533-4_3  | 1619-020        | FY-2021              | June                   | 2021              | 3232.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-020        | FY-2021              | April                  | 2021              | 3360.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-020        | FY-2021              | March                  | 2021              | 3318.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-020        | FY-2021              | December               | 2020              | 2623.00                   |
    | 1619-AS-2021-10017533-4_3  | 1619-020        | FY-2021              | September              | 2020              | 4189.00                   |





    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017533 | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | NMSS                        | AY-2021            | 55328.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10017533-2_6  | 2_6                    | NMSS-AY-2021-Contract-Provider-10017533-2_6 | 10017533      | Furth        | 18ISP           | 55328.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | 21114.00         | Payment         |
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | 17470.00         | Payment         |
    | NMSS-AY-2021-10017533-2_6  | NMSS-007        | 16744.00         | Payment         |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | July                   | 2021              | 5005.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | May                    | 2021              | 2500.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | March                  | 2021              | 2355.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | January                | 2021              | 4091.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | November               | 2020              | 4492.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-002        | FY-2021              | September              | 2020              | 2671.00                   |
    #
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | FY-2021              | June                   | 2021              | 2245.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | FY-2021              | May                    | 2021              | 5418.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | FY-2021              | March                  | 2021              | 2673.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | FY-2021              | January                | 2021              | 4921.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-003        | FY-2021              | October                | 2020              | 2213.00                   |
    #
    | NMSS-AY-2021-10017533-2_6  | NMSS-007        | FY-2021              | July                   | 2021              | 4576.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-007        | FY-2021              | April                  | 2021              | 4020.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-007        | FY-2021              | January                | 2021              | 3497.00                   |
    | NMSS-AY-2021-10017533-2_6  | NMSS-007        | FY-2021              | August                 | 2020              | 4651.00                   |





    # Funding Allocation (3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017533 | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | NLG                         | AS-2021            | 14265.00          |

    # Provider Funding Allocation (3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017533-1_4   | 1_4                    | NLG-AS-2021-Contract-Provider-10017533-1_4  | 10017533      | Furth        | 06SDC           | 14265.00                  |

    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017533-1_4   | NLG-001         | 11687.00         | Payment         |
    | NLG-AS-2021-10017533-1_4   | NLG-002         | 2578.00          | Payment         |

    # Funding Allocation Profile Period (3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017533-1_4   | NLG-001         | FY-2021              | July                   | 2021              | 2935.00                   |
    | NLG-AS-2021-10017533-1_4   | NLG-001         | FY-2021              | March                  | 2021              | 3678.00                   |
    | NLG-AS-2021-10017533-1_4   | NLG-001         | FY-2021              | November               | 2020              | 2096.00                   |
    | NLG-AS-2021-10017533-1_4   | NLG-001         | FY-2021              | August                 | 2020              | 2978.00                   |
    #
    | NLG-AS-2021-10017533-1_4   | NLG-002         | FY-2021              | April                  | 2021              | 2578.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017533 | 10017533 Co Ltd  | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 59870.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017533 | 10017533 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | NMSS                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 55328.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017533 | 10017533 Co Ltd  | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 14265.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10017533-4_3       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NMSS-AY-2021-Contract-Provider-10017533-2_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NLG-AS-2021-Contract-Provider-10017533-1_4        | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10017533 | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | AS-2021 | 1619                        | 59870.00    |
    | 10017533 | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | AY-2021 | NMSS                        | 55328.00    |
    | 10017533 | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | AS-2021 | NLG                         | 14265.00    |






    # Check Release Group stats then release the release Groups

    # Change the date 
    Given the override date is '20/06/2021'

    # Capture the Release Group names (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |
      
    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017533 | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | AS-2021 | 1619                        | 59870.00    | [CofG_SPI]     |
    | 10017533 | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | AY-2021 | NMSS                        | 55328.00    | [CofG_SPI]     |
    | 10017533 | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | AS-2021 | NLG                         | 14265.00    | [NLG]          |

    # Check the state of the EDSK Release Group (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 115198.00       |

    # Check the state of the NLG Release Group (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 14265.00        |





    # Check Release Group stats then release the release Groups

    # Change the date 
    Given the override date is '20/06/2021'

    # Release EDSK Funding Allocations from Contract Control (J128) 
     When  a request is triggered to release the following Release Groups together
     | ReleaseGroup     |
     | [CofG_SPI]       |
     | [NLG]            |

    # Check the state of the EDSK Release Group (J129)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 115198.00       |

    # Check the state of the NLG Release Group (J129)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 14265.00        |





    # EDSK contract

    # Retrieve parameters from CRM for EDSK
    When  I retrieve the latest contract details from CRM for provider '10017533' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017533 | 10017533 Co Ltd  | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2021     | Released          | Released          | 59870.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017533 | 10017533 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | NMSS                        | 16-19ED2021     | Released          | Released          | 55328.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data for EDSK
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AS-2021-Contract-Provider-10017533-4_3       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | 1619-AS-2021-Contract-Provider-10017533-4_3       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2021-Contract-Provider-10017533-4_3       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | NMSS-AY-2021-Contract-Provider-10017533-2_6       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | NMSS-AY-2021-Contract-Provider-10017533-2_6       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | NMSS-AY-2021-Contract-Provider-10017533-2_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017533 | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | AS-2021 | 1619                        | 59870.00    | [CofG_SPI]     |
    | 10017533 | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | AY-2021 | NMSS                        | 55328.00    | [CofG_SPI]     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017533-4_3       | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2021-Contract-Provider-10017533-2_6       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017533 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017533 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


#    # Check contract has been created correctly
#    Then  the draft contract header details for the latest version of the contract have been updated as follows
#    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
#    | 10017533 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 115198.00     | Conditions of Funding (Grant) (SPI)       | 2021   |
#
#    And   the draft contract allocations details for the latest version of the contract have been updated as follows
#    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
#    | 10017533 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 115198.00       |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                          | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017533 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 115198.00     | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017533 Co Ltd  | Active | Document Management Team  |
    | 10017533 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017533 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType        |
    | 10017533 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 115198.00       | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation  |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 16292.00  | 0.00     | 0.00     | 0.00     | 5171.00  | 0.00     | 0.00     | 0.00     | 5454.00  | 0.00     | 5667.00  | 0.00     | 0.00     | 16-19 Bursary Funds                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 14969.00  | 0.00     | 3267.00  | 0.00     | 0.00     | 3448.00  | 0.00     | 5030.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3224.00  | Residential Bursary Fund                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 11887.00  | 0.00     | 3681.00  | 0.00     | 0.00     | 5775.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2431.00  | 0.00     | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 16722.00  | 0.00     | 4189.00  | 0.00     | 0.00     | 2623.00  | 0.00     | 0.00     | 3318.00  | 3360.00  | 0.00     | 3232.00  | 0.00     | Alternative Completions - Sea Fishing          |                          |
    #
    | [ContractNo]   | [AllocRef_16ED] | 15              | 21114.00  | 0.00     | 2671.00  | 0.00     | 4492.00  | 0.00     | 4091.00  | 0.00     | 2355.00  | 0.00     | 2500.00  | 0.00     | 5005.00  | SSF High Needs Element 2                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 17470.00  | 0.00     | 0.00     | 2213.00  | 0.00     | 0.00     | 4921.00  | 0.00     | 2673.00  | 0.00     | 5418.00  | 2245.00  | 0.00     | SSF Bursary Funds                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 16744.00  | 4651.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3497.00  | 0.00     | 0.00     | 4020.00  | 0.00     | 0.00     | 4576.00  | Teachers Pension Scheme (NMSS)                 |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017533_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017533 Co Ltd UKPRN: 10017533
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    16 to 19 Education [AllocRef_16ED] £73,520 £41,678 £115,198
    Total Funding for this contract: £115,198
    Summary of Funding – Page 1
    
    Agreement Type Specialist Post-16 Institution
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017533 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement
    [MasterContractNo]
    Number
    ACCEPTANCE BY THE PROVIDER
    EDSK Version 2 (September 2020) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017533 Co Ltd THE SECRETARY OF STATE FOR
    21 Priory Avenue EDUCATION ACTING THROUGH
    Reading THE EDUCATION AND SKILLS
    Berkshire FUNDING AGENCY, AN
    RG4 7SE EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    Company No: AA017533 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (September 2020) Page 2
    EDSK Version 2 (September 2020) Page 70
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 2 SPI (September 2020) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 2 SPI (September 2020) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017533 Co Ltd UKPRN: 10017533
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 Bursary Funds £16,292 £0.00 £0.00 £0.00 £5,171.00 £0.00 £0.00 £0.00 £5,454.00 £0.00 £5,667.00 £0.00 £0.00
    SSF Bursary Funds £17,470 £0.00 £0.00 £2,213.00 £0.00 £0.00 £4,921.00 £0.00 £2,673.00 £0.00 £5,418.00 £2,245.00 £0.00
    SSF High Needs Element 2 £21,114 £0.00 £2,671.00 £0.00 £4,492.00 £0.00 £4,091.00 £0.00 £2,355.00 £0.00 £2,500.00 £0.00 £5,005.00
    Residential Bursary Fund £14,969 £0.00 £3,267.00 £0.00 £0.00 £3,448.00 £0.00 £5,030.00 £0.00 £0.00 £0.00 £0.00 £3,224.00
    Alternative Completions - Sea Fishing £16,722 £0.00 £4,189.00 £0.00 £0.00 £2,623.00 £0.00 £0.00 £3,318.00 £3,360.00 £0.00 £3,232.00 £0.00
    Teacher's Pension Scheme 1619 £11,887 £0.00 £3,681.00 £0.00 £0.00 £5,775.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,431.00 £0.00
    Teachers Pension Scheme (NMSS) £16,744 £4,651.00 £0.00 £0.00 £0.00 £0.00 £3,497.00 £0.00 £0.00 £4,020.00 £0.00 £0.00 £4,576.00
    Total Funding £115,198 £4,651.00 £13,808.00 £2,213.00 £9,663.00 £11,846.00 £12,509.00 £5,030.00 £13,800.00 £7,380.00 £13,585.00 £7,908.00 £12,805.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 1 (July 2020) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 1 (July 2020) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 1 (July 2020) – Page 1
    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 1 (July 2020) – Page 1
    EDSK Schedule 6 Version 1 (July 2020) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 1 (July 2020) – Page 1
    EDSK Schedule 7 Version 1 (July 2020) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 1 (July 2020) – Page 1
    EDSK Schedule 8 Version 1 (July 2020) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017533_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A533_EDSK.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017533 - 10017533 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017533 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the EDSK contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017533 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017533 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017533 | 10017533 Co Ltd  | 1619-AS-2021-Contract-Provider-10017533-4_3       | 4_3            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2021     | Contract Approved | Contract Approved | 59870.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017533 | 10017533 Co Ltd  | NMSS-AY-2021-Contract-Provider-10017533-2_6       | 2_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | NMSS                        | 16-19ED2021     | Contract Approved | Contract Approved | 55328.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 16292.00     | 0             | 0        | 16-19 Bursary Funds                            | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 33              | 0                     | 14969.00     | 0             | 0        | Residential Bursary Fund                       | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 11887.00     | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 16722.00     | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |
    #
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 21114.00     | 0             | 0        | SSF High Needs Element 2                       | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 17470.00     | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 16744.00     | 0             | 0        | Teachers Pension Scheme (NMSS)                 | ?                           |

    # End of EDSK contract





    # Non-learning Grant Contract (Released earlier)

    # Retrieve parameters from CRM for NLG
    And   I retrieve the latest contract details from CRM for provider '10017533' for FundingType 'NLG' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017533 | 10017533 Co Ltd  | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 14265.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data for NLG
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | NLG-AS-2021-Contract-Provider-10017533-1_4        | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | NLG-AS-2021-Contract-Provider-10017533-1_4        | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | NLG-AS-2021-Contract-Provider-10017533-1_4        | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       |
    | 10017533 | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | AS-2021 | NLG                         | 14265.00    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2021-Contract-Provider-10017533-1_4        | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017533 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017533 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


#    # Check contract has been created correctly
#    Then  the draft contract header details for the latest version of the contract have been updated as follows
#    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
#    | 10017533 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 14265.00      | Non-learning Grant                        | 2021   |
#
#    And   the draft contract allocations details for the latest version of the contract have been updated as follows
#    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
#    | 10017533 | [ContractNo]   | [AllocRef_NLG]  | NLG               | AY                      | 01/08/2020          | 31/07/2021        | 14265.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                    | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                          | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017533 | [ContractNo]       | Non-learning Grants            | Contract      | Draft          | Awaiting Documentation  | 14265.00      | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Non-learning Grant                    | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017533 Co Ltd  | Active | Document Management Team  |
    | 10017533 | [MasterContractNo] | Non-learning Grants            | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Non-learning Grant                    | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017533 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType        |
    | 10017533 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 14265.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | NLG           | NLG2021             | Contract Allocation  |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                   | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 11687.00  | 2978.00  | 0.00     | 0.00     | 2096.00  | 0.00     | 0.00     | 0.00     | 3678.00  | 0.00     | 0.00     | 0.00     | 2935.00  | Isles of Scilly: Boarding and Accommodation Grant |                          |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 2578.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2578.00  | 0.00     | 0.00     | 0.00     | Principals Reference Group (PRG)                  |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017533_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017533 Co Ltd UKPRN: 10017533
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Principals Reference Group (PRG) £2,578 £0 £0 £0 £0 £0 £0 £0 £0 £2,578 £0 £0 £0
    Isles of Scilly: Boarding and Accommodation Grant £11,687 £2,978 £0 £0 £2,096 £0 £0 £0 £3,678 £0 £0 £0 £2,935
    Total Funding £14,265 £2,978 £0 £0 £2,096 £0 £0 £0 £3,678 £2,578 £0 £0 £2,935
    20/21 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017533_[ContractNo]_v1.pdf' in 'NLG-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A533_NLG.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017533 - 10017533 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017533 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the NLG contract (32385)

    # Change the date 
    Given the override date is '24/06/2021'

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
    | 10017533 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017533 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017533 | 10017533 Co Ltd  | NLG-AS-2021-Contract-Provider-10017533-1_4        | 1_4            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Contract Approved | Contract Approved | 14265.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                   | DeliverableDescription      |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_NLG]   | 116             | 0                     | 11687.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant | ?                           |
    | 10017533 | [ContractNo]   | 1               | [AllocRef_NLG]   | 101             | 0                     | 2578.00      | 0             | 0        | Principals Reference Group (PRG)                  | ?                           |


    # Tidy Up
    And   the override date is reset

