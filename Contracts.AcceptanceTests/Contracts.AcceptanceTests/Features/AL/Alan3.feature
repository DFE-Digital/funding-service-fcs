Feature: Alan3


@AcceptanceTest @Manual
Scenario: L023  test data for 33286

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014023'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014923'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014823'
    And   there is no Funding Allocation data in CRM for UKPRN '10014023'
    And   there is no Funding Allocation data in CRM for UKPRN '10014923'
    And   there is no Funding Allocation data in CRM for UKPRN '10014823'
    And   there is no Contract, Task or Workflow data for UKPRN '10014023'
    And   there is no Contract, Task or Workflow data for UKPRN '10014923'
    And   there is no Contract, Task or Workflow data for UKPRN '10014823'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014023' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014923' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014823' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA           | AY2021        | DADA2021  | Contract for Services      |
    | NLG            | AY2021        | NLG2021  | Non-learning Grant      |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)      |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)      |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014023' 
    And there is no Organisation data for UKPRN '10014923' 
    And there is no Organisation data for UKPRN '10014823' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014023 Co Ltd' with UKPRN '10014023' and OrgId 'ORG0014023' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014923 Co Ltd' with UKPRN '10014923' and OrgId 'ORG0014923' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014823 Co Ltd' with UKPRN '10014823' and OrgId 'ORG0014823' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014023 | 114023 | 10014023 Co Ltd | 0              | Active                | Yes           | AA014023      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014923 | 114923 | 10014923 Co Ltd | 0              | Active                | Yes           | AA014923      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014823 | 114823 | 10014823 Co Ltd | 0              | Active                | Yes           | AA014823      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014023 |
    | 10014923 |
    | 10014823 |


#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | 1619-AS-2021-Contract-Provider-10014023-1_1     | 1_1            | 1619                        | AS-2021            | 35730.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014023-1_1  | 1_1                    | 1619-AS-2021-Contract-Provider-10014023-1_1     | 10014023      | Furth        | 07HEP           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014023-1_1  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014023-1_1  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | 1619-AS-2021-10014023-1_1   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
#
# 
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NLG-AS-2021-Contract-Provider-10014023-0_6      | 0_6            | NLG                         | AS-2021            | 35731.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014023-0_6   | 0_6                    | NLG-AS-2021-Contract-Provider-10014023-0_6      | 10014023      | Furth        | 04AHC           | 35731.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | 15473.00         | Payment         |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | 20258.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | September              | 2020              | 4089.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | NLG-AS-2021-10014023-0_6   | NLG-002         | FY-2021              | April                  | 2021              | 2755.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NMSS-AS-2021-Contract-Provider-10014023-1_2     | 1_2            | NMSS                        | AY-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014023-1_2  | 1_2                    | NMSS-AS-2021-Contract-Provider-10014023-1_2     | 10014023      | Schoo        | 21NMS           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014023-1_2  | NMSS-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014023-1_2   | NMSS-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NMSS-AS-2021-10014023-1_2   | NMSS-001         | FY-2021              | September              | 2020              | 2547.00                   |
#
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | DADA-AS-2021-Contract-Provider-10014023-2_4     | 2_4            | DADA                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014023-2_4  | 2_4                    | DADA-AS-2021-Contract-Provider-10014023-2_4     | 10014023      | Furth        | 06SDC           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014023-2_4  | DADA-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014023-2_4   | DADA-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | DADA-AS-2021-10014023-2_4   | DADA-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | DADA-AS-2021-10014023-2_4   | DADA-001         | FY-2021              | October              | 2020              | 2011.00                   |
#
    # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014023 | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-1_4      | 1_4            | NFF                         | AS-2021            | 36731.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014923-1_4   | 1_4                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-1_4      | 10014923      | Schoo        | 08SSF           | 35731.00                   |
    | NFF-AS-2021-10014823-1_4   | 1_4                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-1_4      | 10014823      | Schoo        | 08SSF           | 1000.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | 15473.00         | Payment         |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | 20258.00         | Payment         |
    | NFF-AS-2021-10014823-1_4   | NFF-002         | 1000.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | September              | 2020              | 4089.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | November               | 2020              | 914.00                    |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | December               | 2020              | 846.00                    |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | NFF-AS-2021-10014923-1_4   | NFF-002         | FY-2021              | April                  | 2021              | 2755.00                   |
    | NFF-AS-2021-10014823-1_4   | NFF-002         | FY-2021              | April                  | 2021              | 1000.00                   |


    # Change the date 
    Given the override date is '15/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

        
#    Then wait '10' seconds
#
#    ## Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    #When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    #| FundingId                                               | 
#    #| NLG-AS-2021-Contract-Provider-10014023-0_6              | 
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CoFG_LA                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_LA]         |
#    
#    Then wait '60' seconds
#
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 35731.00         |
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014023' for FundingType 'EDSK' and period '2021'
#
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#   # Execute a NON-FINANCIAL amendment on '[ContractNo]'
#
#    # Change the date
#    Given the override date is '16/06/2020'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2.
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
#
#        
#    Then wait '10' seconds
#
#
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NMSS-AS-2021-Contract-Provider-10014023-2_1     | 2_1            | NMSS                        | AY-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014023-2_1  | 2_1                    | NMSS-AS-2021-Contract-Provider-10014023-2_1     | 10014023      | Schoo        | 21NMS           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014023-2_1  | NMSS-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014023-2_1   | NMSS-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NMSS-AS-2021-10014023-2_1   | NMSS-001         | FY-2021              | September              | 2020              | 2547.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | DADA-AS-2021-Contract-Provider-10014023-3_1     | 3_1            | DADA                        | AS-2021            | 7799.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014023-3_1  | 3_1                    | DADA-AS-2021-Contract-Provider-10014023-3_1     | 10014023      | Furth        | 06SDC           | 7799.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014023-3_1  | DADA-001        | 7799.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId         | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014023-3_1 | DADA-001        | FY-2021              | August                 | 2020              | 1637.00                   |
#    | DADA-AS-2021-10014023-3_1 | DADA-001        | FY-2021              | September              | 2020              | 2547.00                   |
#    | DADA-AS-2021-10014023-3_1 | DADA-001        | FY-2021              | October                | 2020              | 2011.00                   |
#    | DADA-AS-2021-10014023-3_1 | DADA-001        | FY-2021              | November               | 2020              | 1604.00                   |
#
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | 1619-AS-2021-Contract-Provider-10014023-2_4     | 2_4            | 1619                        | AS-2021            | 35730.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014023-2_4  | 2_4                    | 1619-AS-2021-Contract-Provider-10014023-2_4     | 10014023      | Furth        | 07HEP           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014023-2_4  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014023-2_4  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | March                  | 2021              | 3552.00                   |
#    | 1619-AS-2021-10014023-2_4   | 1619-002         | FY-2021              | April                  | 2021              | 2755.00                   |
#
#
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-2_2      | 2_2            | NFF                         | AS-2021            | 35731.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014923-2_2   | 2_2                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-2_2      | 10014923      | Local        | 10LAU           | 35731.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | 15473.00         | Payment         |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | 20258.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | September              | 2020              | 4089.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | March                  | 2021              | 3552.00                   |
#    | NFF-AS-2021-10014923-2_2   | NFF-002         | FY-2021              | April                  | 2021              | 2756.00                   |
#
#
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NLG-AS-2021-Contract-Provider-10014023-2_2      | 2_2            | NLG                         | AS-2021            | 35731.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014023-2_2   | 2_2                    | NLG-AS-2021-Contract-Provider-10014023-2_2      | 10014023      | Furth        | 04AHC           | 35731.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | 15473.00         | Payment         |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | 20258.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | September              | 2020              | 4089.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | March                  | 2021              | 3552.00                   |
#    | NLG-AS-2021-10014023-2_2   | NLG-002         | FY-2021              | April                  | 2021              | 2756.00                   |
#
#
#    # Change the date 
#    Given the override date is '17/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#        
#    Then wait '10' seconds
#
    ## Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    #When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
    #| FundingId                                               | 
    #| DADA-AS-2021-Contract-Provider-10014023-2_4              | 
#
#        
#    Then wait '10' seconds
#
#
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | DADA            | AY2021        | DADA2021  | Contract for Services      | DaDA                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [DaDA]         |
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[DaDA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 7799.00         |
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014023' for FundingType 'EDSK' and period '2021'
#
#
#    ## Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    #Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#   # Execute a NON-FINANCIAL amendment on '[ContractNo]'
#
#    # Change the date
#    Given the override date is '18/06/2020'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2.
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
#
#
#
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-3_0      | 3_0            | NFF                         | AS-2021            | 35731.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014923-3_0   | 3_0                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014023-3_0      | 10014923      | Local        | 10LAU           | 35731.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | 15473.00         | Payment         |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | 20258.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | September              | 2020              | 4089.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | March                  | 2021              | 3550.00                   |
#    | NFF-AS-2021-10014923-3_0   | NFF-002         | FY-2021              | April                  | 2021              | 2758.00                   |
#
#
#
#
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NMSS-AS-2021-Contract-Provider-10014023-3_0     | 3_0            | NMSS                        | AY-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014023-3_0  | 3_0                    | NMSS-AS-2021-Contract-Provider-10014023-3_0     | 10014023      | Schoo        | 21NMS           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014023-3_0  | NMSS-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014023-3_0   | NMSS-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NMSS-AS-2021-10014023-3_0   | NMSS-001         | FY-2021              | September              | 2020              | 2547.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NMSS-AS-2021-Contract-Provider-10014023-3_3     | 3_3            | NMSS                        | AY-2021            | 7799.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014023-3_3  | 3_3                    | NMSS-AS-2021-Contract-Provider-10014023-3_3     | 10014023      | Schoo        | 21NMS           | 7799.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014023-3_3  | NMSS-001        | 7799.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014023-3_3   | NMSS-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NMSS-AS-2021-10014023-3_3   | NMSS-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NMSS-AS-2021-10014023-3_3   | NMSS-001         | FY-2021              | October                | 2020              | 2011.00                   |
#    | NMSS-AS-2021-10014023-3_3   | NMSS-001         | FY-2021              | November               | 2020              | 1604.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NMSS-AS-2021-Contract-Provider-10014023-4_0     | 4_0            | NMSS                        | AY-2021            | 10002.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014023-4_0  | 4_0                    | NMSS-AS-2021-Contract-Provider-10014023-4_0     | 10014023      | Schoo        | 21NMS           | 10002.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014023-4_0  | NMSS-001        | 10002.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014023-4_0   | NMSS-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NMSS-AS-2021-10014023-4_0   | NMSS-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NMSS-AS-2021-10014023-4_0   | NMSS-001         | FY-2021              | October              | 2020              | 2011.00                   |
#    | NMSS-AS-2021-10014023-4_0 | NMSS-001        | FY-2021              | November               | 2020              | 1604.00                   |
#    | NMSS-AS-2021-10014023-4_0   | NMSS-001         | FY-2021              | December              | 2020              | 2203.00                   |
#
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014023 | NLG-AS-2021-Contract-Provider-10014023-3_7      | 3_7            | NLG                         | AS-2021            | 35731.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014023-3_7   | 3_7                    | NLG-AS-2021-Contract-Provider-10014023-3_7      | 10014023      | Furth        | 04AHC           | 35731.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | 15473.00         | Payment         |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | 20258.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | September              | 2020              | 4089.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | NLG-AS-2021-10014023-3_7   | NLG-002         | FY-2021              | April                  | 2021              | 2755.00                   |
#
#
#    # Change the date 
#    Given the override date is '18/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#        
#    Then wait '10' seconds
#
#    # Change the date 
#    Given the override date is '19/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#    Then wait '10' seconds
#
#
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NMSS-AS-2021-Contract-Provider-10014023-4_0              | 
#
#
#    Then wait '10' seconds
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | DADA            | AY2021        | DADA2021  | Contract for Services      | DaDA                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [DaDA]         |
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[DaDA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 10002.00         |
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014023' for FundingType 'DADA' and period '2021'
#
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#
#    #Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)      | CoFG_Col                   |
#
#     #Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_Col]         |
#    
#     #Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_Col]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 34766.00         |
#
#
#    
#    When  I retrieve the latest contract details from CRM for provider '10014023' for FundingType 'EDSK' and period '2021'
#
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#
#    #Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | NLG            | AY2021        | NLG2021  | Non-learning Grant      | NonLG                   |
#
#     #Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [NonLG]         |
#    
#     #Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[NonLG]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 2               | 71534.00         |
#   
#    When  I retrieve the latest contract details from CRM for provider '10014023' for FundingType 'NLG' and period '2021'
#
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#        # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


   # Tidy Up
    Then   the override date is reset

@AcceptanceTest @Manual @CFS
Scenario: L024  test data for 33557

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014024'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014924'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014824'
    And   there is no Funding Allocation data in CRM for UKPRN '10014024'
    And   there is no Funding Allocation data in CRM for UKPRN '10014924'
    And   there is no Funding Allocation data in CRM for UKPRN '10014824'
    And   there is no Contract, Task or Workflow data for UKPRN '10014024'
    And   there is no Contract, Task or Workflow data for UKPRN '10014924'
    And   there is no Contract, Task or Workflow data for UKPRN '10014824'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014024' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014924' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014824' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-4024     |

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    #| DADA           | AY2021        | DADA2021  | Contract for Services      |
    #| NLG            | AY2021        | NLG2021  | Non-learning Grant      |
    #| EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)      |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)      |
    #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-4024     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-4024      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014019'

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014024' 
    And there is no Organisation data for UKPRN '10014924' 
    And there is no Organisation data for UKPRN '10014824' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014024 Co Ltd' with UKPRN '10014024' and OrgId 'ORG0014024' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014924 Co Ltd' with UKPRN '10014924' and OrgId 'ORG0014924' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014824 Co Ltd' with UKPRN '10014824' and OrgId 'ORG0014824' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014024 | 114024 | 10014024 Co Ltd | 0              | Active                | Yes           | AA014024      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014924 | 114924 | 10014924 Co Ltd | 0              | Active                | Yes           | AA014924      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014824 | 114824 | 10014824 Co Ltd | 0              | Active                | Yes           | AA014824      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014024 |
    | 10014924 |
    | 10014824 |


#
#    # Change the date
#    Given the override date is '04/06/2020'
#
#    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
#    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
#    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
#    #| DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
#    #| NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
#    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    #| NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    | NMSS                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#
#    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
#    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
#    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
#    #| DADA            | AY2021            | DEFAULT          | Contract for Services                     | 
#    #| NLG             | AY2021            | DEFAULT          | Non-learning Grant                        | 
#    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        | 
#    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   | 
#    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      | 
#
#    # Load FundingAllocation.ProviderTypeConfig (J143)
#    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
#    | ProviderType    | ProviderSubType   | ProviderCategory | 
#    #| Furth           | 01GFE             | College          | 
#    #| Furth           | 02IPP             | ITP              | 
#    | Furth           | 03SFC             | College          | 
#    | Furth           | 04AHC             | College          | 
#    | Furth           | 05ADC             | College          | 
#    | Furth           | 06SDC             | College          | 
#    | Furth           | 07HEP             | HEI              | 
#    | Furth           | 18ISP             | SPI              | 
#    #| Local           | 10LAU             | LA               | 
#    | Schoo           | 08SSF             | SSF              | 
#    #| Schoo           | 21NMS             | NMSS             | 
#
#    # Load FundingAllocation.AllocationLineConfig (J144)
#    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
#    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
#    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021 | 20              | 
#    #| 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021 | 19              | 
#    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 
#    | NMSS              | AS-2021    | NMSS-001        | DEFAULT          | 1619ED2021 | 39             | 
#    | NMSS              | AS-2021    | NMSS-002        | DEFAULT          | 1619ED2021 | 15              |  
#    #| DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
#    #| NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
#    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
#    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
#


    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
    | 10014024 | 10014024 Co Ltd      | ESFA-4024            | EDSK-4024      | 1                     | 01/08/2020        | 31/07/2021      | 17618.00      |                                       | Conditions of Funding (Grant) (NMSS)         | 2021   | New          | ORG0014024  |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10014024 | EDSK-4024      | ALLF-4024     | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 17618.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10014024 | EDSK-4024      | ALLF-4024     | 5               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4024      | 1                     | 0                        | 2021-06-01 09:12:35.000 |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NLG-AS-2021-Contract-Provider-10014024-1_0           | 1_0            | NLG                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014024-1_0  | 1_0                    | NLG-AS-2021-Contract-Provider-10014024-1_0           | 10014024      | Furth        | 01GFE           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014024-1_0  | NLG-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014024-1_0   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014024-1_0   | NLG-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NLG-AS-2021-10014024-1_0   | NLG-001         | FY-2021              | October                | 2020              | 2011.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | DADA-AS-2021-Contract-Provider-10014024-2_4           | 2_4            | DADA                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014024-2_4  | 2_4                    | DADA-AS-2021-Contract-Provider-10014024-2_4           | 10014024      | Furth        | 06SDC           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014024-2_4  | DADA-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014024-2_4   | DADA-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | DADA-AS-2021-10014024-2_4   | DADA-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | DADA-AS-2021-10014024-2_4   | DADA-001         | FY-2021              | October                | 2020              | 2011.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NFF-AS-2021-Contract-LocalAuthority-10014024-1_3     | 1_3            | NFF                        | AS-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014024-1_3  | 1_3                    | NFF-AS-2021-Contract-LocalAuthority-10014024-1_3     | 10014024      | Local        | 10LAU           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014024-1_3  | NFF-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014024-1_3   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NFF-AS-2021-10014024-1_3   | NFF-001         | FY-2021              | September              | 2020              | 2547.00                   |
#
#
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | 1619-AS-2021-Contract-LocalAuthority-10014024-1_1     | 1_1            | 1619                        | AS-2021            | 35730.00          |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014024-1_1  | 1_1                    | 1619-AS-2021-Contract-LocalAuthority-10014024-1_1     | 10014024      | Local        | 10LAU           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
#    | 1619-AS-2021-10014024-1_1  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014024-1_1  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | 1619-AS-2021-10014024-1_1   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
#
#     #   Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014924 | 1619-AS-2021-Contract-Provider-10014924-1_2     | 1_2            | 1619                        | AS-2021            | 5555.00           |
#
#     #Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014924-1_2  | 1_2                    | 1619-AS-2021-Contract-Provider-10014924-1_2     | 10014924      | Furth        | 01GFE           | 5555.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014924-1_2  | 1619-001        | 1234.00          | Payment         |
#    | 1619-AS-2021-10014924-1_2  | 1619-003        | 4321.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014924-1_2   | 1619-001         | FY-2021              | August                 | 2020              | 1234.00                   |
#    | 1619-AS-2021-10014924-1_2   | 1619-003         | FY-2021              | September              | 2020              | 4321.00                   |
#
      # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014024 | NMSS-AS-2021-Contract-Provider-10014024-0_7     | 0_7            | NMSS                        | AY-2021            | 123.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AS-2021-10014024-0_7  | 0_7                    | NMSS-AS-2021-Contract-Provider-10014024-0_7     | 10014024      | Schoo        | 21NMS           | 123.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AS-2021-10014024-0_7  | NMSS-001        | 123.00          | Payment         |
    #| NMSS-AS-2021-10014024-0_7  | NMSS-002        | 432.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AS-2021-10014024-0_7   | NMSS-001         | FY-2021              | August                 | 2020              | 123.00                   |
    #| NMSS-AS-2021-10014024-0_7   | NMSS-002         | FY-2021              | September              | 2020              | 432.00                   |

#      # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014824 | NMSS-AS-2021-Contract-Provider-10014824-1_3     | 1_3            | NMSS                        | AY-2021            | 555.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014824-1_3  | 1_3                    | NMSS-AS-2021-Contract-Provider-10014824-1_3     | 10014824      | Local        | 21NMS           | 555.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014824-1_3  | NMSS-001        | 123.00          | Payment         |
#    | NMSS-AS-2021-10014824-1_3  | NMSS-002        | 432.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014824-1_3   | NMSS-001         | FY-2021              | August                 | 2020              | 123.00                   |
#    | NMSS-AS-2021-10014824-1_3   | NMSS-002         | FY-2021              | September              | 2020              | 432.00                   |

    # Change the date 
    Given the override date is '05/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    Then wait '10' seconds

        

#    # Change the date
#    Given the override date is '06/06/2020'
#
#    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
#    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
#    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
#    #| DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
#    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
#    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    #| NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    | NMSS                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#
#    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
#    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
#    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
#    #| DADA            | AY2021            | DEFAULT          | Contract for Services                     | 
#    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        | 
#    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        | 
#    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   | 
#    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      | 
#
#    # Load FundingAllocation.ProviderTypeConfig (J143)
#    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
#    | ProviderType    | ProviderSubType   | ProviderCategory | 
#    #| Furth           | 01GFE             | College          | 
#    #| Furth           | 02IPP             | ITP              | 
#    | Furth           | 03SFC             | College          | 
#    | Furth           | 04AHC             | College          | 
#    | Furth           | 05ADC             | College          | 
#    | Furth           | 06SDC             | College          | 
#    | Furth           | 07HEP             | HEI              | 
#    | Furth           | 18ISP             | SPI              | 
#    #| Local           | 10LAU             | LA               | 
#    | Schoo           | 08SSF             | SSF              | 
#    #| Schoo           | 21NMS             | NMSS             | 
#
#    # Load FundingAllocation.AllocationLineConfig (J144)
#    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
#    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
#    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021 | 20              | 
#    #| 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021 | 19              | 
#    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 
#    | NMSS              | AS-2021    | NMSS-001        | DEFAULT          | 1619ED2021 | 39             | 
#    | NMSS              | AS-2021    | NMSS-002        | DEFAULT          | 1619ED2021 | 15              |  
#    #| DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
#    #| NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
#    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
#    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
#
#
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#    Then wait '60' seconds
#
#        
#
#    # Change the date
#    Given the override date is '07/06/2020'
#
#    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
#    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
#    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
#    #| DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
#    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
#    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    #| NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#    | NMSS                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#
#    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
#    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
#    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
#    #| DADA            | AY2021            | DEFAULT          | Contract for Services                     | 
#    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        | 
#    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        | 
#    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   | 
#    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      | 
#
#    # Load FundingAllocation.ProviderTypeConfig (J143)
#    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
#    | ProviderType    | ProviderSubType   | ProviderCategory | 
#    | Furth           | 01GFE             | College          | 
#    #| Furth           | 02IPP             | ITP              | 
#    | Furth           | 03SFC             | College          | 
#    | Furth           | 04AHC             | College          | 
#    | Furth           | 05ADC             | College          | 
#    | Furth           | 06SDC             | College          | 
#    | Furth           | 07HEP             | HEI              | 
#    | Furth           | 18ISP             | SPI              | 
#    #| Local           | 10LAU             | LA               | 
#    | Schoo           | 08SSF             | SSF              | 
#    #| Schoo           | 21NMS             | NMSS             | 
#
#    # Load FundingAllocation.AllocationLineConfig (J144)
#    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
#    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
#    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021 | 20              | 
#    #| 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021 | 19              | 
#    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 
#    | NMSS              | AS-2021    | NMSS-001        | DEFAULT          | 1619ED2021 | 39             | 
#    | NMSS              | AS-2021    | NMSS-002        | DEFAULT          | 1619ED2021 | 15              |  
#    #| DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
#    #| NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
#    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
#    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
#
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#
#    Then wait '60' seconds
#
#    # 5. Reset config to its true 'base' state 
#
#    # Change the date
#    Given the override date is '08/06/2021'
#
#    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
#    And   the current base CFS config has been loaded
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#
#
#    Then wait '60' seconds
#
#    ## Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    #When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    #| FundingId                                               | 
#    #| NLG-AS-2021-Contract-Provider-10014023-0_6              | 
#
    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK           | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)     | CoFG_NMSS                   |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CoFG_NMSS]         |
    
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 35730.00         |
#
#

    Then wait '60' seconds

    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'EDSK' and period '2021'

      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


#
#    Then wait '60' seconds
#
    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    When  I retrieve the latest contract details from CRM for provider '10014924' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
##    # Contract Withdrawal
##    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
##
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    When  I retrieve the latest contract details from CRM for provider '10014824' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
##    # Contract Withdrawal
##    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
##
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#   # Execute a NON-FINANCIAL amendment on '[ContractNo]'
#
#    # Change the date
#    Given the override date is '16/06/2020'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2.
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
#
#        
#    Then wait '30' seconds
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NMSS-AS-2021-Contract-Provider-10014024-0_7              | 
#
    Then wait '10' seconds

    # Change the date 
    Given the override date is '16/06/2020'

    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
    |  FundingId                                              |
    |  NMSS-AS-2021-Contract-Provider-10014024-0-7           |
#
#
#
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NLG-AS-2021-Contract-Provider-10014024-2_2           | 2_2            | NLG                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014024-2_2  | 2_2                    | NLG-AS-2021-Contract-Provider-10014024-2_2           | 10014024      | Furth        | 06SDC           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014024-2_2  | NLG-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014024-2_2   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014024-2_2   | NLG-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NLG-AS-2021-10014024-2_2   | NLG-001         | FY-2021              | October                | 2020              | 2011.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NFF-AS-2021-Contract-LocalAuthority-10014024-2_1     | 2_1            | NFF                        | AS-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014024-2_1  | 2_1                    | NFF-AS-2021-Contract-LocalAuthority-10014024-2_1     | 10014024      | Local        | 10LAU           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014024-2_1  | NFF-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014024-2_1   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NFF-AS-2021-10014024-2_1   | NFF-001         | FY-2021              | September              | 2020              | 2547.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | DADA-AS-2021-Contract-Provider-10014024-3_2     | 3_2            | DADA                        | AS-2021            | 7598.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014024-3_2  | 3_2                    | DADA-AS-2021-Contract-Provider-10014024-3_2     | 10014024      | Furth        | 06SDC           | 7598.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014024-3_2  | DADA-001        | 7598.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014024-3_2   | DADA-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | DADA-AS-2021-10014024-3_2   | DADA-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | DADA-AS-2021-10014024-3_2   | DADA-001         | FY-2021              | October                | 2020              | 2011.00                   |
#    | DADA-AS-2021-10014024-3_2   | DADA-001         | FY-2021              | November               | 2020              | 1403.00                   |
#
#
#
#       # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | 1619-AS-2021-Contract-LocalAuthority-10014024-2_5     | 2_5            | 1618                        | AS-2021            | 35730.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014024-2_5  | 2_5                    | 1619-AS-2021-Contract-LocalAuthority-10014024-2_5     | 10014024      | Local        | 10LAU           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
#    | 1619-AS-2021-10014024-2_5  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014024-2_5  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | 1619-AS-2021-10014024-2_5   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
#
#       # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014924 | 1619-AS-2021-Contract-Provider-10014924-2_0     | 2_0            | 1619                        | AS-2021            | 555.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014924-2_0  | 2_0                    | 1619-AS-2021-Contract-Provider-10014924-2_0     | 10014924      | Furth        | 01GFE           | 555.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014924-2_0  | 1619-001        | 234.00          | Payment         |
#    | 1619-AS-2021-10014924-2_0  | 1619-003        | 321.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014924-2_0   | 1619-001         | FY-2021              | August                 | 2020              | 234.00                   |
#    | 1619-AS-2021-10014924-2_0   | 1619-003         | FY-2021              | September              | 2020              | 321.00                   |
#
#      # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NMSS-AS-2021-Contract-Provider-10014024-2_3     | 2_3            | NMSS                        | AY-2021            | 550.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014024-2_3  | 2_3                    | NMSS-AS-2021-Contract-Provider-10014024-2_3     | 10014024      | Schoo        | 21NMS           | 550.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014024-2_3  | NMSS-001        | 120.00          | Payment         |
#    | NMSS-AS-2021-10014024-2_3  | NMSS-002        | 430.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014024-2_3   | NMSS-001         | FY-2021              | August                 | 2020              | 120.00                   |
#    | NMSS-AS-2021-10014024-2_3   | NMSS-002         | FY-2021              | September              | 2020              | 430.00                   |
#    
#    # Change the date 
# 
#    Given the override date is '16/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | DADA           | AY2021        | DADA2021  | Contract for Services     | CoS2                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoS2]         |
#    
#    Then wait '60' seconds
#
#    Then wait '30' seconds
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NMSS-AS-2021-Contract-Provider-10014024-0_7              | 
#
#    Then wait '10' seconds
#
#
#    # 5. Reset config to its true 'base' state 
#
#    # Change the date
#    Given the override date is '17/06/2021'
#
#    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
#    And   the current base CFS config has been loaded
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#
#
#        
#    Then wait '30' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'NLG' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#       
#    Then wait '10' seconds
#
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    Then wait '30' seconds
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NLG-AS-2021-Contract-Provider-10014024-2_2              | 
#
#    Then wait '30' seconds
#
#
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_HEI]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 35730.00         |
#
#    Then wait '4' seconds
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#        
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'EDSK' and period '2021'
#
#
#    # Modification Initiation setup
#    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
#    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
#    | 10014024 | [ContractNo]  | 1               | 0                  | 18/06/2021               | Inadequate Ofsted               | ?                                       |
#
#    # Use the SDK to submit a request for manager approval
#    And   the user forwards the initiate modification request for manager approval via SDK
#
#    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
#    Then  the following contract modification values are present in CRM
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
#    | 10014024 | [ContractNo]   | 1                     | 0                        | 18/11/2020               | 18/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |
#
#    # ... and the allocation data will have been saved in CRM too
#    And   the following allocation modification values are present in CRM
#    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
#    | 10014024 | [ContractNo]  | [AllocRef_ESF]   | 1                     | 0                        | 18/11/2020                   | 18/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |
#
#    # A Modification Approval Task should have been created
#    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10014024'
#    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
#    | Confirm Modification Approval              | 10014024 - 10014024 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10014024 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
#    | 10014024 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |
#
#    # Authorise Modification (30698)
#
#    # Change the date - CRM ignores this
#    Given the override date is '19/06/2021'
#
#    # Clear down CM feed
#    And   the Contract Management atom feed is empty
#
#    # Complete an existing open Task to Authorise the Modification
#    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10014024' is triggered by User 'FCS5 TEST'
#    | Task                                     | Owner                     |
#    | Confirm Modification Approval            | FCS1 TEST                 |
#
#     Then wait '30' seconds
#
#
#    # Termination Initiation (30634)
#
#    # Change the date - CRM ignores this
#    Given the override date is '20/06/2021'
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'NLG' and period '2021'
#
#    # Termination Initiation setup - contract
#    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
#    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
#    | [ContractNo]      | 1               | 0                  | 20/02/2021              | Deactivated UKPRN           | Acquisition in progress             |
#
#    # Termination Initiation setup - allocations
#    And   with the following allocation termination options
#    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
#    | [AllocRef_NLG]     | 23/05/2021                   | 30/05/2021                      |
#
#    # Use the SDK to submit a request for manager approval
#    And   the user forwards the initiate termination request for manager approval via SDK
#
#    # Approve Termination Initiation (30635)
#
#    # Change the date - CRM ignores this
#    Given the override date is '21/06/2021'
#
#    # Clear down CM feed
#    And   the Contract Management atom feed is empty
#
#    # Complete an existing open Task
#    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10014024' is triggered by User 'FCS5 TEST'
#    | Task                                     | Owner                     |
#    | Confirm Termination Initiation Approval  | FCS1 TEST                 |
#
#
#    Then wait '10' seconds
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'EDSK' and period '2021'
#
#    # Execute a NON-FINANCIAL amendment on '[ContractNo]'
#
#    # Change the date
#    Given the override date is '18/06/2021'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2.
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
#
#        
#    Then wait '30' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#        
#    Then wait '10' seconds
#
#   # Change the date 
#    Given the override date is '19/06/2021'
#    
#    Then wait '30' seconds
#
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)     | CoFG_C2                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_C2]         |
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_C]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 35730.00         |
#
#
#    Then wait '60' seconds
#
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NLG-AS-2021-Contract-Provider-10014024-3_2           | 3_2            | NLG                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014024-3_2  | 3_2                    | NLG-AS-2021-Contract-Provider-10014024-3_2           | 10014024      | Furth        | 06SDC           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014024-3_2  | NLG-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014024-3_2   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014024-3_2   | NLG-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NLG-AS-2021-10014024-3_2   | NLG-001         | FY-2021              | October                | 2020              | 2011.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NFF-AS-2021-Contract-LocalAuthority-10014024-3_0     | 3_0            | NFF                        | AS-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014024-3_0  | 3_0                    | NFF-AS-2021-Contract-LocalAuthority-10014024-3_0     | 10014024      | Local        | 10LAU           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014024-3_0  | NFF-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014024-3_0   | NFF-001         | FY-2021              | August                 | 2020              | 1548.00                   |
#    | NFF-AS-2021-10014024-3_0   | NFF-001         | FY-2021              | September              | 2020              | 2636.00                   |
#
#
#       # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | 1619-AS-2021-Contract-LocalAuthority-10014024-3_2     | 3_2            | 1619                        | AS-2021            | 35730.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014024-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthority-10014024-3_2     | 10014024      | Loca        | 10LAU           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014024-3_2  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014024-3_2  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | August                 | 2020              | 1638.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | September              | 2020              | 3088.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | 1619-AS-2021-10014024-3_2   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
#
#       # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | 1619-AS-2021-LocalAuthoritySsf-10014024-2_0     | 2_0            | 1619                        | AS-2021            | 555.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014924-2_0  | 2_0                    | 1619-AS-2021-LocalAuthoritySsf-10014024-2_0     | 10014924      | Schoo        | 08SSF           | 555.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014924-2_0  | 1619-001        | 234.00          | Payment         |
#    | 1619-AS-2021-10014924-2_0  | 1619-002        | 321.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014924-2_0   | 1619-001         | FY-2021              | August                 | 2020              | 234.00                   |
#    | 1619-AS-2021-10014924-2_0   | 1619-002         | FY-2021              | September              | 2020              | 321.00                   |
#
#      # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014824 | 1619-AS-2021-LocalAuthority-10014824-2_3     | 2_3            | 1619                        | AS-2021            | 550.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014824-2_3  | 2_3                    | 1619-AS-2021-LocalAuthority-10014824-2_3     | 10014824      | Local        | 10LAU           | 550.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014824-2_3  | 1619-001        | 120.00          | Payment         |
#    | 1619-AS-2021-10014824-2_3  | 1619-002        | 430.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014824-2_3   | 1619-001         | FY-2021              | August                 | 2020              | 120.00                   |
#    | 1619-AS-2021-10014824-2_3   | 1619-002         | FY-2021              | September              | 2020              | 430.00                   |
#
#    
#
#
#    # Change the date 
# 
#    Given the override date is '17/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | NLG           | AY2021        | NLG2021  | Non-learning Grant     | NonLG3                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [NonLG3]         |
#    
#        
#    Then wait '30' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014024' for FundingType 'NLG' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#
#    Then wait '30' seconds
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NLG-AS-2021-Contract-Provider-10014024-3_2              | 
#
#    Then wait '20' seconds
#
#    # Clear down the CFS stub and PaaS Funding Allocation tables
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NLG-AS-2021-Contract-Provider-10014024-4_0           | 4_0            | NLG                        | AS-2021            | 6195.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014024-4_0  | 4_0                    | NLG-AS-2021-Contract-Provider-10014024-4_0           | 10014024      | Furth        | 06SDC           | 6195.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014024-4_0  | NLG-001        | 6195.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014024-4_0   | NLG-001         | FY-2021              | August                 | 2020              | 1637.00                   |
#    | NLG-AS-2021-10014024-4_0   | NLG-001         | FY-2021              | September              | 2020              | 2547.00                   |
#    | NLG-AS-2021-10014024-4_0   | NLG-001         | FY-2021              | October                | 2020              | 2011.00                   |
#
#        # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | NFF-AS-2021-Contract-LocalAuthority-10014024-4_1     | 4_1            | NFF                        | AS-2021            | 4184.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014024-4_1  | 4_1                    | NFF-AS-2021-Contract-LocalAuthority-10014024-4_1     | 10014024      | Local        | 10LAU           | 4184.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014024-4_1  | NFF-001        | 4184.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014024-4_1   | NFF-001         | FY-2021              | August                 | 2020              | 1548.00                   |
#    | NFF-AS-2021-10014024-4_1   | NFF-001         | FY-2021              | September              | 2020              | 2636.00                   |
#
#       # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014024 | 1619-AS-2021-Contract-LocalAuthority-10014024-4_1     | 4_1            | 1619                        | AS-2021            | 35730.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014024-4_1  | 4_1                    | 1619-AS-2021-Contract-LocalAuthority-10014024-4_1     | 10014024      | Loca        | 10LAU           | 35730.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014024-4_1  | 1619-001        | 15473.00          | Payment         |
#    | 1619-AS-2021-10014024-4_1  | 1619-002        | 20257.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | August                 | 2020              | 1638.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | September              | 2020              | 3088.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
#    | 1619-AS-2021-10014024-4_1   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
#
#
 #   # Change the date 
 #
 #   Given the override date is '18/06/2021'
 #   
 #   # Read stub and process into CRM
 #   When  the feed-reading process is started and the CFS stub data is processed into CRM

        
   # Tidy Up
    Then   the override date is reset



@AcceptanceTest @Manual @CFS
Scenario: L025  test data for 33588+33589

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014025'
    And   there is no Funding Allocation data in CRM for UKPRN '10014025'
    And   there is no Contract, Task or Workflow data for UKPRN '10014025'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014025' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014025'

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014025' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014025 Co Ltd' with UKPRN '10014025' and OrgId 'ORG0014025' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014025 | 114025 | 10014025 Co Ltd | 0              | Active                | Yes           | AA014025      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014025 |


    # Change the date
    Given the override date is '04/06/2020'

    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     | 
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        | 
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        | 

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
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021 | 20              | 
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021 | 19              | 
#    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 



        # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1     | 1_1            | 1619                        | AS-2021            | 34730.00          |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014025-1_1  | 1_1                    | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1     | 10014025      | Local        | 10LAU           | 34730.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
    | 1619-AS-2021-10014025-1_1  | 1619-001        | 14473.00          | Payment         |
    | 1619-AS-2021-10014025-1_1  | 1619-002        | 20257.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | 1619-AS-2021-10014025-1_1   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |


    # Change the date 
 
    Given the override date is '05/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '10' seconds


#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1              | 
#
#
#        
#    Then wait '30' seconds
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should be 'AwaitingFundingAllocationConfig'
#    Then  the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
#    | 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1       | 1_1            | AS-2021 | 1619                        | 35730.00    | ?               | Parked            | AwaitingFundingAllocationConfig |

    ## Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    #When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
    #| FundingId                                               | 
    #| NLG-AS-2021-Contract-Provider-10014023-0_6              | 

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK           | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)     | CoFG_LA                   |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CoFG_LA]         |
    
    
    ## Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[CoFG_LA]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 35730.00         |

    Then wait '60' seconds

    When  I retrieve the latest contract details from CRM for provider '10014025' for FundingType 'EDSK' and period '2021'

      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

#
#    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014025 | [ContractNo]   | 1                     | 0                  |
#
#
#    Then wait '20' seconds
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1              | 
#
#
#    Then wait '30' seconds
#
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#
#    # Change the date 
#    Given the override date is '16/06/2020'
#
#    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
#    |  FundingId                                              |
#    |  1619-AS-2021-Contract-LocalAuthority-10014025-1_1           |
#




    # Clear down the CFS stub and PaaS Funding Allocation tables
    Given   there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables

#
#    #Then wait '60' seconds
#
#
#    # 5. Reset config to its true 'base' state 
#
#    # Change the date
#    Given the override date is '06/06/2021'
#
#    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
#    And   the current base CFS config has been loaded
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#
#
#    
       # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-2_5     | 2_5            | 1619                        | AS-2021            | 34731.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014025-2_5  | 2_5                    | 1619-AS-2021-Contract-LocalAuthority-10014025-2_5     | 10014025      | Local        | 10LAU           | 34731.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
    | 1619-AS-2021-10014025-2_5  | 1619-001        | 14473.00          | Payment         |
    | 1619-AS-2021-10014025-2_5  | 1619-002        | 20257.00          | Payment         |
    | 1619-AS-2021-10014025-2_5  | 1619-003        | 1.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |
    | 1619-AS-2021-10014025-2_5   | 1619-003         | FY-2021              | April                  | 2021              | 1.00                   |


    # Change the date 
 
    Given the override date is '08/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '20' seconds

 
    
    # Clear down the CFS stub and PaaS Funding Allocation tables
    Given   there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables


        # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-3_0     | 3_0            | 1619                        | AS-2021            | 35730.00          |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014025-3_0  | 3_0                    | 1619-AS-2021-Contract-LocalAuthority-10014025-3_0     | 10014025      | Local        | 10LAU           | 35730.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
    | 1619-AS-2021-10014025-3_0  | 1619-001        | 15473.00          | Payment         |
    | 1619-AS-2021-10014025-3_0  | 1619-002        | 20257.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | 1619-AS-2021-10014025-3_0   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |

#
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should be 'AwaitingFundingAllocationConfig' (2_5)
#    Then  the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
#    #| 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1       | 1_1            | AS-2021 | 1619                        | 35730.00    | ?               | Discarded         | Superseded                      |
#    | 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-2_5       | 2_5            | AS-2021 | 1619                        | 35731.00    | ?               | Parked            | AwaitingFundingLineConfig |
#
    Then wait '60' seconds

   Given the override date is '08/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '20' seconds
#
#    # 5. Reset config to its true 'base' state 
#
#    # Change the date
#    Given the override date is '09/06/2021'
#
#    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
#    And   the current base CFS config has been loaded
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#    ## Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    #When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    #| FundingId                                               | 
#    #| NLG-AS-2021-Contract-Provider-10014023-0_6              | 
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CoFG_LA                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_LA]         |
#    
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoFG_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 35730.00        |
#
#
#
#    Then wait '60' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014025' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    Then wait '10' seconds
#
#    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014025 | [ContractNo]   | 1                     | 0                  |
#
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1              | 
#
#    Then wait '10' seconds
#
#
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK           | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)     | CoFG_LA                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_LA]         |
    #
    #
    ## Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[CoFG_LA]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 35730.00         |
#
#    Then wait '30' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014025' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#
#    Then wait '30' seconds
#
#
#
#    # 5. Reset config to its true 'base' state 
#
#    # Change the date
#    Given the override date is '09/06/2021'
#
#    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
#    And   the current base CFS config has been loaded
#
#    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
#    When  the job to review parked Funding Allocations against the latest version of config is run 
#
#
#    Then wait '10' seconds
#
    ## Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should be 'AwaitingFundingAllocationConfig' (2_5)
    #Then  the following Funding Allocations data is present in PaaS
    #| UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    ##| 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-1_1       | 1_1            | AS-2021 | 1619                        | 35730.00    | ?               | Discarded         | Superseded                      |
    ##| 10014025 | 1619-AS-2021-Contract-LocalAuthority-10014025-2_5       | 2_5            | AS-2021 | 1619                        | 36730.00    | ?               | Parked            | AwaitingOutcome |

        
   # Tidy Up
    Then   the override date is reset


    @AcceptanceTest @Manual @CFS
Scenario: L026  test data for 33716

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014026'
    And   there is no Funding Allocation data in CRM for UKPRN '10014026'
    And   there is no Contract, Task or Workflow data for UKPRN '10014026'
    #And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014926'
    #And   there is no Funding Allocation data in CRM for UKPRN '10014926'
    #And   there is no Contract, Task or Workflow data for UKPRN '10014926'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014026' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub and PaaS Funding Allocation tables
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014026'

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014026' 
    #And there is no Organisation data for UKPRN '10014926' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014026 Co Ltd' with UKPRN '10014026' and OrgId 'ORG0014026' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014026 | 114026 | 10014026 Co Ltd | 0              | Active                | Yes           | AA014026      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014926 | 114926 | 10014926 Co Ltd | 0              | Active                | Yes           | AA014926      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014026 |
#    | 10014926 |

#        # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
#    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
#    | AllocationRef |
#    | ALLF-4026     |
#
#    # Clear down all subnominal data from PaaS for an FSP
#    And   there is no Subnominal data in PaaS for the following FSPs
#    | FSP               |
#    | ALLF2021          |
#
#    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
#    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
#    | EDSK-4026      | 1                     | 0                        |
#
#
#
#    # Change the date
#    Given the override date is '04/06/2020'
#
#    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
#    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
#    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
#    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
#    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
#    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
#
#    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
#    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
#    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
#    | DADA            | AY2021            | DEFAULT          | Contract for Services                     | 
#    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        | 
#    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        | 
#
#    # Load FundingAllocation.ProviderTypeConfig (J143)
#    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
#    | ProviderType    | ProviderSubType   | ProviderCategory | 
#    | Furth           | 01GFE             | College          | 
#    | Furth           | 02IPP             | ITP              | 
#    | Furth           | 03SFC             | College          | 
#    | Furth           | 04AHC             | College          | 
#    | Furth           | 05ADC             | College          | 
#    | Furth           | 06SDC             | College          | 
#    | Furth           | 07HEP             | HEI              | 
#    | Furth           | 18ISP             | SPI              | 
#    | Local           | 10LAU             | LA               | 
#    | Schoo           | 08SSF             | SSF              | 
#    | Schoo           | 21NMS             | NMSS             | 
#
#    # Load FundingAllocation.AllocationLineConfig (J144)
#    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
#    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
#    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
#    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
#    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
#    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
#    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021 | 20              | 
#    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021 | 19              | 
#    #| 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 
#
    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
    | 10014026 | 10014026 Co Ltd      | ESFA-4026            | EDSK-4026      | 1                     | 01/08/2020        | 31/07/2021      | 17618.00      |                                       | Conditions of Funding (Grant) (LA)         | 2021   | New          | ORG0014026  |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10014026 | EDSK-4026      | ALLF-4026     | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 17618.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10014026 | EDSK-4026      | ALLF-4026     | 5               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4026      | 1                     | 0                        | 2021-06-01 09:12:35.000 |



        # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014026 | 1619-AS-2021-Contract-Provider-10014026-1_1     | 1_1            | 1619                        | AS-2021            | 34730.00          |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014026-1_1  | 1_1                    | 1619-AS-2021-Contract-Provider-10014026-1_1     | 10014026      | Furth        | 01GFE           | 34730.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType  |
    | 1619-AS-2021-10014026-1_1  | 1619-001        | 14473.00          | Payment         |
    | 1619-AS-2021-10014026-1_1  | 1619-002        | 20257.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId           | FundingLineCode  | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | September              | 2020              | 3089.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | November               | 2020              | 914.00                    |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | December               | 2020              | 846.00                    |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | 1619-AS-2021-10014026-1_1   | 1619-002         | FY-2021              | April                  | 2021              | 2754.00                   |


    # Change the date 
 
    Given the override date is '09/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '10' seconds

#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK           | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College)     | CoFG_C                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_C]         |
#
#
#    Then wait '30' seconds


    When  I retrieve the latest contract details from CRM for provider '10014026' for FundingType 'EDSK' and period '2021'

    #Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#



       
   # Tidy Up
    Then   the override date is reset