Feature: PutFundingAllocationOnHold 32922

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A707 Import three CFS FAs for different UKPRNs. Put one on hold then another. Release the Release Group. Check CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017707'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018005'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018012'

    And   there is no Funding Allocation data in CRM for UKPRN '10017707'
    And   there is no Funding Allocation data in CRM for UKPRN '10018005'
    And   there is no Funding Allocation data in CRM for UKPRN '10018012'

    And   there is no Contract, Task or Workflow data for UKPRN '10017707'
    And   there is no Contract, Task or Workflow data for UKPRN '10018005'
    And   there is no Contract, Task or Workflow data for UKPRN '10018012'

   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017707'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018005'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018012'


    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017707' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    And   there are no files prefixed '10018005' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    And   there are no files prefixed '10018012' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017707' 
    And   there is no Organisation data for UKPRN '10018005' 
    And   there is no Organisation data for UKPRN '10018012' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017707 Co Ltd' with UKPRN '10017707' and OrgId 'ORG0017707' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018005 Co Ltd' with UKPRN '10018005' and OrgId 'ORG0018005' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018012 Co Ltd' with UKPRN '10018012' and OrgId 'ORG0018012' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017707 | 117707 | 10017707 Co Ltd | 0              | Active                | Yes           | AA017707      | ?             | 1301 Stratford Road    | Hall Green             | ?                      | ?                      | Birmingham             | West Midlands          | B28 9HH   |
    | 10018005 | 118005 | 10018005 Co Ltd | 0              | Provider Under Change | Yes           | AA018005      | ?             | 3 Egremont Street      | ?                      | ?                      | ?                      | Ely                    | Cambridge              | CB6 1AE   |
    | 10018012 | 118012 | 10018012 Co Ltd | 0              | Locked Restructure    | Yes           | AA018012      | ?             | 6 Clyde Street         | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 1NA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017707 |
    | 10018005 |
    | 10018012 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017707 | NLG-AS-2122-Contract-Provider-10017707-3_5            | 3_5            | NLG                         | AS-2122            | 14802.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017707-3_5   | 3_5                    | NLG-AS-2122-Contract-Provider-10017707-3_5            | 10017707      | Furth        | 06SDC           | 14802.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017707-3_5   | NLG-001         | 14802.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017707-3_5   | NLG-001         | FY-2122              | October                | 2021              | 2738.00                   |
    | NLG-AS-2122-10017707-3_5   | NLG-001         | FY-2122              | January                | 2022              | 2577.00                   |
    | NLG-AS-2122-10017707-3_5   | NLG-001         | FY-2122              | April                  | 2022              | 5184.00                   |
    | NLG-AS-2122-10017707-3_5   | NLG-001         | FY-2122              | May                    | 2022              | 4303.00                   |





    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018005 | NLG-AS-2122-Contract-Provider-10018005-1_0            | 1_0            | NLG                         | AS-2122            | 12542.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10018005-1_0   | 1_0                    | NLG-AS-2122-Contract-Provider-10018005-1_0            | 10018005      | Furth        | 03SFC           | 12542.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10018005-1_0   | NLG-001         | 12542.00         | Payment         |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10018005-1_0   | NLG-001         | FY-2122              | August                 | 2021              | 4902.00                   |
    | NLG-AS-2122-10018005-1_0   | NLG-001         | FY-2122              | March                  | 2022              | 3064.00                   |
    | NLG-AS-2122-10018005-1_0   | NLG-001         | FY-2122              | April                  | 2022              | 4576.00                   |





    # Funding Allocation (3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018012 | NLG-AS-2122-Contract-Provider-10018012-1_1            | 1_1            | NLG                         | AS-2122            | 8276.00           |

    # Provider Funding Allocation (3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10018012-1_1   | 1_1                    | NLG-AS-2122-Contract-Provider-10018012-1_1            | 10018012      | Furth        | 02IPP           | 8276.00                   |

    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10018012-1_1   | NLG-001         | 8276.00          | Payment         |

    # Funding Allocation Profile Period (3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10018012-1_1   | NLG-001         | FY-2122              | December               | 2021              | 3313.00                   |
    | NLG-AS-2122-10018012-1_1   | NLG-001         | FY-2122              | July                   | 2022              | 4963.00                   |





    # Consume stub data
    
    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                | ReleaseGroup   |
    | 10017707 | 10017707 Co Ltd  | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 14802.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | [NLG]          |
    | 10018005 | 10018005 Co Ltd  | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 12542.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | [NLG]          |
    | 10018012 | 10018012 Co Ltd  | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 8276.00     | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | [NLG]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | NLG-AS-2122-Contract-Provider-10017707-3_5              | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NLG-AS-2122-Contract-Provider-10018005-1_0              | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NLG-AS-2122-Contract-Provider-10018012-1_1              | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check the state of a Release Group (J129)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 35620.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017707 | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | AS-2122 | NLG                         | 14802.00    | [NLG]        |
    | 10018005 | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | AS-2122 | NLG                         | 12542.00    | [NLG]        |
    | 10018012 | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | AS-2122 | NLG                         | 8276.00     | [NLG]        |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Put a Funding Allocation on hold (32922)

    # Change the date 
    Given the override date is '22/06/2021'

    # Invoke HOLD process (J130)
    When  User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                     | Comments                    |
    | NLG-AS-2122-Contract-Provider-10018005-1_0              | Under Investigation            | Suspected fraud             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                | ReleaseGroup   |
    | 10017707 | 10017707 Co Ltd  | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 14802.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | ?              |
    | 10018005 | 10018005 Co Ltd  | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held              | 12542.00    | ?             | ?                 | CRM Integration  | CRM Integration  | Under Investigation       | ?              |
    | 10018012 | 10018012 Co Ltd  | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 8276.00     | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | ?              |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment               |
    | NLG-AS-2122-Contract-Provider-10018005-1_0              | Hold                            | CRM Integration   | Scheduling         | Held                            | Scheduling     | Hold in Progress                | Suspected fraud       |
    | NLG-AS-2122-Contract-Provider-10018005-1_0              | Hold in Progress                | FCS8 TEST         | Scheduling         | Hold in Progress                | Scheduling     | Awaiting Release                | Suspected fraud       |
    | NLG-AS-2122-Contract-Provider-10018005-1_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                     |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 23078.00        |
    
    # Check PaaS FundingAllocation.FundingAllocation (J131) (Funding Allocation has been disassociated from the Release Group)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10018005 | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | AS-2122 | NLG                         | 12542.00    | ?            |




   
    # Put a second Funding Allocation on hold (32922)

    # Change the date 
    Given the override date is '23/06/2021'
    
    # Invoke HOLD process (J130)
    When  User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                     | Comments                    |
    | NLG-AS-2122-Contract-Provider-10018012-1_1              | Contracting Query              | ?                           |

    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus    | Comment                  |
    | NLG-AS-2122-Contract-Provider-10018012-1_1              | Hold                 | CRM Integration   | Scheduling         | Held                  | Scheduling     | Hold in Progress     | ?                        |
    | NLG-AS-2122-Contract-Provider-10018012-1_1              | Hold in Progress     | FCS8 TEST         | Scheduling         | Hold in Progress      | Scheduling     | Awaiting Release     | ?                        |
    | NLG-AS-2122-Contract-Provider-10018012-1_1              | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                    | ?                        |

    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                | ReleaseGroup    |
    | 10017707 | 10017707 Co Ltd  | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 14802.00    | ?             | ?                 | CRM Integration  | CRM Integration  | ?                         | ?               |
    | 10018005 | 10018005 Co Ltd  | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held              | 12542.00    | ?             | ?                 | CRM Integration  | CRM Integration  | Under Investigation       | ?               |
    | 10018012 | 10018012 Co Ltd  | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held              | 8276.00     | ?             | ?                 | CRM Integration  | CRM Integration  | Contracting Query         | ?               |

    # Check the state of a Release Group (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 14802.00        |
 
    # Check PaaS FundingAllocation.FundingAllocation (J131) (Funding Allocation has been disassociated from the Release Group)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10018012 | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | AS-2122 | NLG                         | 8276.00     | ?            |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '25/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 14802.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017707' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017707' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the three Funding Allocations in CRM
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                | ReleaseGroup    |
    | 10017707 | 10017707 Co Ltd  | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 14802.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  | ?                         | [NLG]           |
    | 10018005 | 10018005 Co Ltd  | NLG-AS-2122-Contract-Provider-10018005-1_0              | 1_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held              | 12542.00    | ?             | ?                 | CRM Integration  | CRM Integration  | Under Investigation       | ?               |
    | 10018012 | 10018012 Co Ltd  | NLG-AS-2122-Contract-Provider-10018012-1_1              | 1_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held              | 8276.00     | ?             | ?                 | CRM Integration  | CRM Integration  | Contracting Query         | ?               |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus    | Comment               |
    | NLG-AS-2122-Contract-Provider-10017707-3_5              | Release Successful   | CRM Integration   | Released           | Released              | Scheduling     | Awaiting Release     | ?                     |
#   | NLG-AS-2122-Contract-Provider-10017707-3_5              | Initiate Release     | CRM Integration   | In Release         | Release in Progress   | Scheduling     | Awaiting Release     | ?                     |
    | NLG-AS-2122-Contract-Provider-10017707-3_5              | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                    | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017707 | NLG-AS-2122-Contract-Provider-10017707-3_5              | 3_5            | AS-2122 | NLG                         | 14802.00    | [NLG]        |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017707-3_5              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'



    # Check Contract in CRM

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017707 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017707 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017707 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 14802.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017707 Co Ltd  | Active | Document Management Team  |
    | 10017707 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017707 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017707 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 14802.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                    | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 14802.00  | 0.00     | 0.00     | 2738.00  | 0.00     | 0.00     | 2577.00  | 0.00     | 0.00     | 5184.00  | 4303.00  | 0.00     | 0.00     | Isles of Scilly: Boarding and Accommodation Grant  |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Tidy Up
    And   the override date is reset
