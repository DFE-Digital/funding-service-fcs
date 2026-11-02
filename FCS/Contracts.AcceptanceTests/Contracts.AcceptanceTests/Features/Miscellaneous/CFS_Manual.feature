Feature: CFS_Manual

@AcceptanceTest @InProgress
@CFS
Scenario: A000 CFS test data - DADA
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010435'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10009213'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10038501'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017793'
    
    And   there is no Funding Allocation data in CRM for UKPRN '10010435'
    And   there is no Funding Allocation data in CRM for UKPRN '10009213'
    And   there is no Funding Allocation data in CRM for UKPRN '10038501'
    And   there is no Funding Allocation data in CRM for UKPRN '10017793'
    
    And   there is no Contract, Task or Workflow data for UKPRN '10010435'
    And   there is no Contract, Task or Workflow data for UKPRN '10009213'
    And   there is no Contract, Task or Workflow data for UKPRN '10038501'
    And   there is no Contract, Task or Workflow data for UKPRN '10017793'


    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10010435' 
    Given there is no Organisation data for UKPRN '10009213' 
    Given there is no Organisation data for UKPRN '10038501' 
    Given there is no Organisation data for UKPRN '10017793' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010435 Co Ltd' with UKPRN '10010435' and OrgId 'ORG0010435' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10009213 Co Ltd' with UKPRN '10009213' and OrgId 'ORG0009213' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10038501 Co Ltd' with UKPRN '10038501' and OrgId 'ORG0038501' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017793 Co Ltd' with UKPRN '10017793' and OrgId 'ORG0017793' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010435 | 010435 | 10010435 Co Ltd | 0              | Active                | Yes           | AA010435      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |
    | 10009213 | 009213 | 10009213 Co Ltd | 0              | Active                | Yes           | AA009213      | ?             | 28 Park Street         | ?                      | ?                      | ?                      | Birmingham             | West Midlands          | B5 5JH    |
    | 10038501 | 038501 | 10038501 Co Ltd | 0              | Locked Restructure    | Yes           | AA038501      | ?             | 2 Castle Yard          | Richmond               | Surrey                 | ?                      | ?                      | ?                      | TW10 6TF  |
    | 10017793 | 017793 | 10017793 Co Ltd | 0              | Active                | Yes           | AA017793      | ?             | 4 Barnhaven Close      | Wyke Road              | ?                      | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010435 |
    | 10009213 |
    | 10038501 |
    | 10017793 |




    # Populate the stub with DADA (01GFE) data

    # Change the date 
    Given the override date is '27/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010435 | DADA-AS-2021-Contract-Provider-10010435-2_7           | 2_7            | DADA                        | AS-2021            | 10122.00          |
    | Contracting    | 10009213 | DADA-AS-2021-Contract-Provider-10009213-1_7           | 1_7            | DADA                        | AS-2021            | 16003.00          |
    | Contracting    | 10038501 | DADA-AS-2021-Contract-Provider-10038501-3_0           | 3_0            | DADA                        | AS-2021            | 5752.00           |
    | Contracting    | 10017793 | DADA-AS-2021-Contract-Provider-10017793-2_2           | 2_2            | DADA                        | AS-2021            | 22862.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10010435-2_7  | 2_7                    | DADA-AS-2021-Contract-Provider-10010435-2_7           | 10010435      | Furth        | 01GFE           | 10122.00                  |
    | DADA-AS-2021-10009213-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10009213-1_7           | 10009213      | Furth        | 01GFE           | 16003.00                  |
    | DADA-AS-2021-10038501-3_0  | 3_0                    | DADA-AS-2021-Contract-Provider-10038501-3_0           | 10038501      | Furth        | 01GFE           | 5752.00                   |
    | DADA-AS-2021-10017793-2_2  | 2_2                    | DADA-AS-2021-Contract-Provider-10017793-2_2           | 10017793      | Furth        | 01GFE           | 22862.00                  |
    
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10010435-2_7  | DADA-001        | 10122.00         | Payment         |
    | DADA-AS-2021-10009213-1_7  | DADA-001        | 16003.00         | Payment         |
    | DADA-AS-2021-10038501-3_0  | DADA-001        | 5752.00          | Payment         |
    | DADA-AS-2021-10017793-2_2  | DADA-001        | 22862.00         | Payment         |
    
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10010435-2_7  | DADA-001        | FY-2021              | January                | 2021              | 4885.00                   |
    | DADA-AS-2021-10010435-2_7  | DADA-001        | FY-2021              | July                   | 2021              | 5237.00                   |
    #
    | DADA-AS-2021-10009213-1_7  | DADA-001        | FY-2021              | October                | 2020              | 5253.00                   |
    | DADA-AS-2021-10009213-1_7  | DADA-001        | FY-2021              | December               | 2020              | 3929.00                   |
    | DADA-AS-2021-10009213-1_7  | DADA-001        | FY-2021              | March                  | 2021              | 3902.00                   |
    | DADA-AS-2021-10009213-1_7  | DADA-001        | FY-2021              | May                    | 2021              | 2919.00                   |
    #
    | DADA-AS-2021-10038501-3_0  | DADA-001        | FY-2021              | January                | 2021              | 5752.00                   |
    #
    | DADA-AS-2021-10017793-2_2  | DADA-001        | FY-2021              | August                 | 2020              | 3208.00                   |
    | DADA-AS-2021-10017793-2_2  | DADA-001        | FY-2021              | November               | 2020              | 3694.00                   |
    | DADA-AS-2021-10017793-2_2  | DADA-001        | FY-2021              | March                  | 2021              | 5174.00                   |
    | DADA-AS-2021-10017793-2_2  | DADA-001        | FY-2021              | May                    | 2021              | 5799.00                   |
    | DADA-AS-2021-10017793-2_2  | DADA-001        | FY-2021              | July                   | 2021              | 4987.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '30/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM



    # Tidy Up
    Then  the override date is reset

@AcceptanceTest @InProgress
@CFS
Scenario: A000 CFS test data - NLG
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10062824'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10022070'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10046078'

    And   there is no Funding Allocation data in CRM for UKPRN '10062824'
    And   there is no Funding Allocation data in CRM for UKPRN '10022070'
    And   there is no Funding Allocation data in CRM for UKPRN '10046078'

    And   there is no Contract, Task or Workflow data for UKPRN '10062824'
    And   there is no Contract, Task or Workflow data for UKPRN '10022070'
    And   there is no Contract, Task or Workflow data for UKPRN '10046078'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10062824' 
    Given there is no Organisation data for UKPRN '10022070' 
    Given there is no Organisation data for UKPRN '10046078' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10062824 Co Ltd' with UKPRN '10062824' and OrgId 'ORG0062824' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10022070 Co Ltd' with UKPRN '10022070' and OrgId 'ORG0022070' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10046078 Co Ltd' with UKPRN '10046078' and OrgId 'ORG0046078' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10062824 | 062824 | 10062824 Co Ltd | 0              | Provider Under Change | Yes           | AA062824      | ?             | 116a High Street       | ?                      | ?                      | ?                      | Hoddesdon              | Hertfordshire          | EN11 8HD  |
    | 10022070 | 022070 | 10022070 Co Ltd | 0              | Active                | Yes           | AA022070      | ?             | 5 Riversdale Road      | Thames Ditton          | Surrey                 | ?                      | ?                      | ?                      | KT7 0QL   |
    | 10046078 | 046078 | 10046078 Co Ltd | 0              | Provider Under Change | Yes           | AA046078      | ?             | 39a Victoria Road      | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | KT6 4JL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10062824 |
    | 10022070 |
    | 10046078 |


    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '27/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10062824 | NLG-AS-2021-Contract-Provider-10062824-4_5            | 4_5            | NLG                         | AS-2021            | 32496.00          |
    | Contracting    | 10022070 | NLG-AS-2021-Contract-Provider-10022070-1_4            | 1_4            | NLG                         | AS-2021            | 30149.00          |
    | Contracting    | 10046078 | NLG-AS-2021-Contract-Provider-10046078-4_2            | 4_2            | NLG                         | AS-2021            | 38667.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10062824-4_5   | 4_5                    | NLG-AS-2021-Contract-Provider-10062824-4_5            | 10062824      | Furth        | 02IPP           | 32496.00                  |
    | NLG-AS-2021-10022070-1_4   | 1_4                    | NLG-AS-2021-Contract-Provider-10022070-1_4            | 10022070      | Furth        | 02IPP           | 30149.00                  |
    | NLG-AS-2021-10046078-4_2   | 4_2                    | NLG-AS-2021-Contract-Provider-10046078-4_2            | 10046078      | Furth        | 02IPP           | 38667.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | 14716.00         | Payment         |
    | NLG-AS-2021-10062824-4_5   | NLG-002         | 17780.00         | Payment         |
    #
    | NLG-AS-2021-10022070-1_4   | NLG-002         | 24812.00         | Payment         |
    | NLG-AS-2021-10022070-1_4   | NLG-003         | 5337.00          | Payment         |
    #
    | NLG-AS-2021-10046078-4_2   | NLG-002         | 21402.00         | Payment         |
    | NLG-AS-2021-10046078-4_2   | NLG-003         | 17265.00         | Payment         |


    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | FY-2021              | October                | 2020              | 2412.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | FY-2021              | January                | 2021              | 2183.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | FY-2021              | February               | 2021              | 3935.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | FY-2021              | April                  | 2021              | 2679.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-001         | FY-2021              | July                   | 2021              | 3507.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-002         | FY-2021              | August                 | 2020              | 5245.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-002         | FY-2021              | December               | 2020              | 3065.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-002         | FY-2021              | April                  | 2021              | 5603.00                   |
    | NLG-AS-2021-10062824-4_5   | NLG-002         | FY-2021              | June                   | 2021              | 3867.00                   |
    #
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | August                 | 2020              | 4120.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | November               | 2020              | 5668.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | December               | 2020              | 2084.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | February               | 2021              | 2709.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | April                  | 2021              | 5898.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-002         | FY-2021              | July                   | 2021              | 4333.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-003         | FY-2021              | January                | 2021              | 2305.00                   |
    | NLG-AS-2021-10022070-1_4   | NLG-003         | FY-2021              | February               | 2021              | 3032.00                   |
    #
    | NLG-AS-2021-10046078-4_2   | NLG-002         | FY-2021              | October                | 2020              | 3334.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-002         | FY-2021              | November               | 2020              | 4675.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-002         | FY-2021              | March                  | 2021              | 3590.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-002         | FY-2021              | April                  | 2021              | 3905.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-002         | FY-2021              | July                   | 2021              | 5898.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-003         | FY-2021              | September              | 2020              | 5654.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-003         | FY-2021              | January                | 2021              | 2449.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-003         | FY-2021              | April                  | 2021              | 4063.00                   |
    | NLG-AS-2021-10046078-4_2   | NLG-003         | FY-2021              | May                    | 2021              | 5099.00                   |
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '30/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    # Tidy Up
    Then  the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A080 Create a 2122 1619ED FA and release into CRM
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017080'
    And   there is no Funding Allocation data in CRM for UKPRN '10017080'
    And   there is no Contract, Task or Workflow data for UKPRN '10017080'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017080'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017080'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017080' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017080' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017080 Co Ltd' with UKPRN '10017080' and OrgId 'ORG0017080' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017080' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017080 | 117080 | 10017080 Co Ltd | 0              | Locked Restructure    | Yes           | AA017080      | ?             | 65 Moffats Lane        | Brookmans  Park        | ?                      | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017080 |






    # Populate the stub with 1619 (04AHC) data

    # Change the date 
    Given the override date is '16/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017080 | 1619-AS-2122-Contract-Provider-10017080-1_3           | 1_3            | 1619                        | AS-2122            | 21686.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017080-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10017080-1_3           | 10017080      | Furth        | 04AHC           | 21686.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | 21686.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | September              | 2021              | 5918.00                   |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | October                | 2021              | 3909.00                   |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | January                | 2022              | 2995.00                   |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | February               | 2022              | 2798.00                   |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | April                  | 2022              | 2328.00                   |
    | 1619-AS-2122-10017080-1_3  | 1619-013        | FY-2122              | June                   | 2022              | 3738.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '19/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM