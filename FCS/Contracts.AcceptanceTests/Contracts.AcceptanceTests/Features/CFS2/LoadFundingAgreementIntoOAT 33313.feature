Feature: LoadFundingAgreementIntoOAT 33313

@AcceptanceTest @Manual
@CFS
Scenario: A020 Create CFS Funding Allocations (To help with manual testing in OAT)

    # Because we don't cleardown the environment, need to changeall the UKPRN before each run 

    # Change the date 
    Given the override date is '04/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10046149 | 1619-AS-2021-Contract-Provider-10046149-1_6           | 1_6            | 1619                        | AS-2021            | 52589.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10046149-1_6  | 1_6                    | 1619-AS-2021-Contract-Provider-10046149-1_6           | 10046149      | Furth        | 03SFC           | 52589.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10046149-1_6  | 1619-005        | 18259.00         | Payment         |
    | 1619-AS-2021-10046149-1_6  | 1619-008        | 13315.00         | Payment         |
    | 1619-AS-2021-10046149-1_6  | 1619-010        | 18024.00         | Payment         |
    | 1619-AS-2021-10046149-1_6  | 1619-012        | 2991.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10046149-1_6  | 1619-005        | FY-2021              | October                | 2020              | 5637.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-005        | FY-2021              | December               | 2020              | 2432.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-005        | FY-2021              | March                  | 2021              | 5108.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-005        | FY-2021              | May                    | 2021              | 5082.00                   |
    #
    | 1619-AS-2021-10046149-1_6  | 1619-008        | FY-2021              | August                 | 2020              | 5569.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-008        | FY-2021              | January                | 2021              | 2022.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-008        | FY-2021              | July                   | 2021              | 5724.00                   |
    #
    | 1619-AS-2021-10046149-1_6  | 1619-010        | FY-2021              | October                | 2020              | 3458.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-010        | FY-2021              | January                | 2021              | 4799.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-010        | FY-2021              | March                  | 2021              | 3715.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-010        | FY-2021              | May                    | 2021              | 4030.00                   |
    | 1619-AS-2021-10046149-1_6  | 1619-010        | FY-2021              | July                   | 2021              | 2022.00                   |
    #
    | 1619-AS-2021-10046149-1_6  | 1619-012        | FY-2021              | January                | 2021              | 2991.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '07/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10046149 | 10046149 Co Ltd  | 1619-AS-2021-Contract-Provider-10046149-1_6             | 1_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 52589.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2021-Contract-Provider-10046149-1_6             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 52589.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10046149 | 1619-AS-2021-Contract-Provider-10046149-1_6             | 1_6            | AS-2021 | 1619                        | 52589.00    | [CofG_College]|

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Tidy Up
    And   the override date is reset

