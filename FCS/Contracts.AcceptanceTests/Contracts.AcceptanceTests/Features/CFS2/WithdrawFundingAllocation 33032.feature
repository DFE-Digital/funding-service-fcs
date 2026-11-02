Feature: WithdrawFundingAllocation 33032

@AcceptanceTest @Withdrawn20211216
@CFS
Scenario: A947 Import then withdraw a 2122 DADA FA. Check CRM
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017947'
    And   there is no Funding Allocation data in CRM for UKPRN '10017947'
    And   there is no Contract, Task or Workflow data for UKPRN '10017947'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017947'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017947'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2021     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017947' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017947 Co Ltd' with UKPRN '10017947' and OrgId 'ORG0017947' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017947' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017947 | 117947 | 10017947 Co Ltd | 0              | Locked Restructure    | Yes           | AA017947      | ?             | 8 Temple Market        | Queens Road            | Weybridge              | ?                      | ?                      | Surrey                 | KT13 9DL  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017947 |





    # Populate the stub with DADA (01GFE) data

    # Change the date 
    Given the override date is '13/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017947 | DADA-AY-2122-Contract-Provider-10017947-4_1           | 4_1            | DADA                        | AY-2122            | 5832.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017947-4_1  | 4_1                    | DADA-AY-2122-Contract-Provider-10017947-4_1           | 10017947      | Furth        | 01GFE           | 5832.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017947-4_1  | DADA-001        | 5832.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017947-4_1  | DADA-001        | FY-2122              | November               | 2021              | 2382.00                   |
    | DADA-AY-2122-10017947-4_1  | DADA-001        | FY-2122              | July                   | 2022              | 3450.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '15/06/2020'

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
    | 10017947 | 10017947 Co Ltd  | DADA-AY-2122-Contract-Provider-10017947-4_1             | 4_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 5832.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017947-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |





    # Change the date 
    Given the override date is '16/06/2020'

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 5832.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017947 | DADA-AY-2122-Contract-Provider-10017947-4_1             | 4_1            | AY-2122 | DADA                        | 5832.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Withdraw a Funding Allocation (33032)
    
    # Change the date 
    Given the override date is '19/06/2020'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Contracting query'
    | FundingId                                               |
    | DADA-AY-2122-Contract-Provider-10017947-4_1             |

    # Check the CRM Funding Allocation Workflow History.   Two new entries
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment               |
    | DADA-AY-2122-Contract-Provider-10017947-4_1             | Withdrawn                       | CRM Integration   | Withdrawn          | Withdrawn                       | Scheduling     | Withdrawal in Progress          | Contracting query     |
    | DADA-AY-2122-Contract-Provider-10017947-4_1             | Withdrawal in Progress          | FCS8 TEST         | Scheduling         | Withdrawal in Progress          | Scheduling     | Awaiting Release                | Contracting query     |

    # Check the CRM Funding Allocations data.   Status and substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017947 | 10017947 Co Ltd  | DADA-AY-2122-Contract-Provider-10017947-4_1             | 4_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Withdrawn         | Withdrawn         | 5832.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the state of a Release Group in CRM (J129)   Count reduced by 1. Value reduced by value of FA.
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 0               | 0.00            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)   (Disassociate FA from RG)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup | Status     | SubStatus    |
    | 10017947 | DADA-AY-2122-Contract-Provider-10017947-4_1             | 4_1            | AY-2122 | DADA                        | 5832.00     | ?            | Withdrawn  | Withdrawn    |


    # Tidy Up
    And   the override date is reset
 
@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A980 Create and release a 1619 FA for a Contracting Org. Add an NMSS FA with a Delivery Org. Withdraw NMSS FA.
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017980'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025267'
    And   there is no Funding Allocation data in CRM for UKPRN '10017980'
    And   there is no Funding Allocation data in CRM for UKPRN '10025267'
    And   there is no Contract, Task or Workflow data for UKPRN '10017980'
    And   there is no Contract, Task or Workflow data for UKPRN '10025267'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017980'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017980'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017980' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017980' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017980 Co Ltd' with UKPRN '10017980' and OrgId 'ORG0017980' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017980' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017980 | 117980 | 10017980 Co Ltd | 0              | Active   | Yes           | AA017980      | ?             | 9 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Greater Manchester     | OL4 7DJ   |
    | 10025267 | 125267 | 10025267 Co Ltd | 0              | Active   | Yes           | AA025267      | ?             | 15 Wildgoose Road      | ?                      | ?                      | ?                      | Horsham                | Greater Manchester     | OL12 1TU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017980 |
    | 10025267 |





    # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '19/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017980 | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2     | 2_2            | 1619                        | AS-2122            | 22049.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017980-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2     | 10017980      | Local        | 10LAU           | 22049.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | 22049.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | FY-2122              | October                | 2021              | 5173.00                   |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | FY-2122              | December               | 2021              | 4873.00                   |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | FY-2122              | March                  | 2022              | 5771.00                   |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | FY-2122              | April                  | 2022              | 3078.00                   |
    | 1619-AS-2122-10017980-2_2  | 1619-001        | FY-2122              | July                   | 2022              | 3154.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017980 | 10017980 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 22049.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 22049.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status            | SubStatus                         |
    | 10017980 | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | AS-2122 | 1619                        | 22049.00    | [CofG_LA]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '25/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 22049.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017980' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017980' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017980 | 10017980 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 22049.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017980 | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | AS-2122 | 1619                        | 22049.00    | [CofG_LA]      |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017980 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017980 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017980 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 22049.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017980 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017980 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017980 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017980 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 22049.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 22049.00  | 0.00     | 0.00     | 5173.00  | 0.00     | 4873.00  | 0.00     | 0.00     | 5771.00  | 3078.00  | 0.00     | 0.00     | 3154.00  | 16-19 Programme Funding                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


 
 

    # Populate the stub with NMSS (08SSF) data

    # Change the date 
    Given the override date is '27/06/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017980 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1  | 1_1            | NMSS                        | AY-2122            | 17224.00      |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10025267-1_1  | 1_1                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1  | 10025267      | Schoo        | 08SSF           | 17224.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10025267-1_1  | NMSS-002        | 17224.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10025267-1_1  | NMSS-002        | FY-2122              | October                | 2021              | 5173.00                   |
    | NMSS-AY-2122-10025267-1_1  | NMSS-002        | FY-2122              | January                | 2022              | 4772.00                   |
    | NMSS-AY-2122-10025267-1_1  | NMSS-002        | FY-2122              | February               | 2022              | 3036.00                   |
    | NMSS-AY-2122-10025267-1_1  | NMSS-002        | FY-2122              | July                   | 2022              | 4243.00                   |
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '28/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017980 | 10017980 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 17224.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA2                  |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 17224.00        |

#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    Then  the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
#    | 10017980 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | 1_1            | AY-2122 | NMSS                        | 17224.00    | [CofG_LA2]     |

    # Write the value of the ReleaseGroupParameters to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA] CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017980 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | 1_1            | AY-2122 | NMSS                        | 17224.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017980 | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | AS-2122 | 1619                        | 22049.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Withdraw a Funding Allocation (33032)
    
    # Change the date 
    Given the override date is '29/06/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
    | FundingId                                               |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    |

    # Check the CRM Funding Allocation Workflow History data   (Two new entries)
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | Withdrawn                       | CRM Integration   | Withdrawn          | Withdrawn                       | Scheduling     | Withdrawal in Progress          | ?                             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | Withdrawal in Progress          | FCS8 TEST         | Scheduling         | Withdrawal in Progress          | Scheduling     | Awaiting Release                | ?                             |

    # Check the CRM Funding Allocations data   (Status and substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017980 | 10017980 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Withdrawn         | Withdrawn         | 17224.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the state of a Release Group in CRM (J129)   (Count reduced by 1. Value reduced by value of FA)
    And   Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 0               | 0.00            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus     |
    | 10017980 | 1619-AS-2122-Contract-LocalAuthority-10017980-2_2       | 2_2            | AS-2122 | 1619                        | 22049.00    | [CofG_LA]       | ?                 | ?             |
    | 10017980 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017980-1_1    | 1_1            | AY-2122 | NMSS                        | 17224.00    | ?               | Withdrawn         | Withdrawn     |

    # Tidy Up
    And   the override date is reset
