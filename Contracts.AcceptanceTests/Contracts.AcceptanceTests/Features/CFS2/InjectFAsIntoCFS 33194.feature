Feature: InjectFAsIntoCFS 33194

@AcceptanceTest @Manual
Scenario: A535 Import 3 CFS FAs for one UKPRN to create EDSK, NLG and DADA contract allocations. (To help with manual testing)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017535'
    And   there is no Funding Allocation data in CRM for UKPRN '10017535'
    And   there is no Contract, Task or Workflow data for UKPRN '10017535'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017535' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017535' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10017535' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017535' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017535 Co Ltd' with UKPRN '10017535' and OrgId 'ORG0017535' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017535' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017535 | 117535 | 10017535 Co Ltd | 0              | In Administration     | Yes           | AA017535      | ?             | 1 Friary               | Temple Quay            | Bristol                | ?                      | ?                      | ?                      | BS1 6EA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017535 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017535 | 1619-AS-2021-Contract-Provider-10017535-4_6           | 4_6            | 1619                        | AS-2021            | 87683.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017535-4_6  | 4_6                    | 1619-AS-2021-Contract-Provider-10017535-4_6           | 10017535      | Furth        | 07HEP           | 87683.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017535-4_6  | 1619-001        | 5407.00          | Payment         |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | 31092.00         | Payment         |
    | 1619-AS-2021-10017535-4_6  | 1619-005        | 12191.00         | Payment         |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | 27892.00         | Payment         |
    | 1619-AS-2021-10017535-4_6  | 1619-008        | 11101.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017535-4_6  | 1619-001        | FY-2021              | January                | 2021              | 5407.00                   |
    #
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | August                 | 2020              | 4043.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | October                | 2020              | 5796.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | January                | 2021              | 4540.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | March                  | 2021              | 5368.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | May                    | 2021              | 5822.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-002        | FY-2021              | July                   | 2021              | 5523.00                   |
    #
    | 1619-AS-2021-10017535-4_6  | 1619-005        | FY-2021              | October                | 2020              | 5150.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-005        | FY-2021              | January                | 2021              | 3344.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-005        | FY-2021              | April                  | 2021              | 3697.00                   |
    #
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | August                 | 2020              | 5677.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | November               | 2020              | 3770.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | December               | 2020              | 4427.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | March                  | 2021              | 5394.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | April                  | 2021              | 3556.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-006        | FY-2021              | June                   | 2021              | 5068.00                   |
    #
    | 1619-AS-2021-10017535-4_6  | 1619-008        | FY-2021              | November               | 2020              | 5478.00                   |
    | 1619-AS-2021-10017535-4_6  | 1619-008        | FY-2021              | May                    | 2021              | 5623.00                   |





    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017535 | DADA-AY-2021-Contract-Provider-10017535-1_3           | 1_3            | DADA                        | AY-2021            | 13267.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2021-10017535-1_3  | 1_3                    | DADA-AY-2021-Contract-Provider-10017535-1_3           | 10017535      | Furth        | 03SFC           | 13267.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2021-10017535-1_3  | DADA-001        | 13267.00         | Payment         |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2021-10017535-1_3  | DADA-001        | FY-2021              | October                | 2020              | 5439.00                   |
    | DADA-AY-2021-10017535-1_3  | DADA-001        | FY-2021              | December               | 2020              | 5551.00                   |
    | DADA-AY-2021-10017535-1_3  | DADA-001        | FY-2021              | June                   | 2021              | 2277.00                   |





    # Funding Allocation (3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017535 | NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-1_0   | 1_0            | NLG                         | AY-2021            | 28199.00          |

    # Provider Funding Allocation (3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AY-2021-10017535-1_0   | 1_0                    | NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-1_0   | 10017535      | Schoo        | 21NMS           | 28199.00                  |

    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | 23261.00         | Payment         |
    | NLG-AY-2021-10017535-1_0   | NLG-002         | 4938.00          | Payment         |

    # Funding Allocation Profile Period (3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | FY-2021              | September              | 2020              | 4526.00                   |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | FY-2021              | December               | 2020              | 3816.00                   |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | FY-2021              | March                  | 2021              | 4884.00                   |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | FY-2021              | May                    | 2021              | 5680.00                   |
    | NLG-AY-2021-10017535-1_0   | NLG-001         | FY-2021              | June                   | 2021              | 4355.00                   |
    #
    | NLG-AY-2021-10017535-1_0   | NLG-002         | FY-2021              | August                 | 2020              | 4938.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017535 | 10017535 Co Ltd  | DADA-AY-2021-Contract-Provider-10017535-1_3             | 1_3            | Dance and Drama Awards     | AY2021  | Contract for Services                    | DADA                        | DADA2021        | Scheduling        | Awaiting Release  | 13267.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017535 | 10017535 Co Ltd  | 1619-AS-2021-Contract-Provider-10017535-4_6             | 4_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 87683.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017535 | 10017535 Co Ltd  | NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-1_0     | 1_0            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 28199.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

#    # Check PaaS FundingAllocation.FundingAllocation 
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
#    | 10017535 | DADA-AY-2021-Contract-Provider-10017535-1_3             | 1_3            | AY-2021 | DADA                        | 13267.00    | [CfS]          |
#    | 10017535 | 1619-AS-2021-Contract-Provider-10017535-4_6             | 4_6            | AS-2021 | 1619                        | 87683.00    | [CofG_HEI]     |
#    | 10017535 | NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-1_0     | 1_0            | AY-2021 | NLG                         | 28199.00    | [NLG]          |


    # Tidy Up
    And   the override date is reset   
     