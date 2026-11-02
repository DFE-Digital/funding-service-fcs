Feature: ParkFA_MissingConfig 33588

@AcceptanceTest @Replaced
@CFS
Scenario: A120x Consume and consume a NLG FA with Allocation Funding Stream Code set to NLX. Fail: Park 'Awaiting Funding Allocation Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017120'
    And   there is no Funding Allocation data in CRM for UKPRN '10017120'
    And   there is no Contract, Task or Workflow data for UKPRN '10017120'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLX             | AY2021        | NLX2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017120' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017120 Co Ltd' with UKPRN '10017120' and OrgId 'ORG0017120' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017120' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017120 | 117120 | 10017120 Co Ltd | 0              | Active                | Yes           | AA017120      | ?             | 244 The Quardrant      | Aztec West             | Almondsbury            | Bristol                | ?                      | ?                      | BS32 4AQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017120 |






    # Populate the stub with NLX (02IPP) data

    # Change the date 
    Given the override date is '18/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017120 | NLX-AS-2021-Contract-Provider-10017120-4_5            | 4_5            | NLX                         | AS-2021            | 33465.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLX-AS-2021-10017120-4_5   | 4_5                    | NLX-AS-2021-Contract-Provider-10017120-4_5            | 10017120      | Furth        | 02IPP           | 33465.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLX-AS-2021-10017120-4_5   | NLX-001         | 5744.00          | Payment         |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | 27721.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLX-AS-2021-10017120-4_5   | NLX-001         | FY-2021              | October                | 2020              | 5744.00                   |
    #
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | September              | 2020              | 5693.00                   |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | November               | 2020              | 4710.00                   |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | January                | 2021              | 3658.00                   |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | March                  | 2021              | 5752.00                   |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | May                    | 2021              | 3471.00                   |
    | NLX-AS-2021-10017120-4_5   | NLX-002         | FY-2021              | June                   | 2021              | 4437.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '21/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                        |
    | 10017120 | NLX-AS-2021-Contract-Provider-10017120-4_5              | 4_5            | AS-2021 | NLX                         | 33465.00    | ?               | Parked            | AwaitingFundingAllocationConfig  |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Replaced
@CFS
Scenario: A121x Create and consume a 1619 FA with Provider Sub Type set to 09XYZ. Fail: 'Awaiting Contract Type Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017121'
    And   there is no Funding Allocation data in CRM for UKPRN '10017121'
    And   there is no Contract, Task or Workflow data for UKPRN '10017121'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017121' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017121 Co Ltd' with UKPRN '10017121' and OrgId 'ORG0017121' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017121' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017121 | 117121 | 10017121 Co Ltd | 0              | Locked Restructure    | Yes           | AA017121      | ?             | 10 Witcham Close       | Lower Early            | ?                      | ?                      | Reading                | Berkshire              | RG6 4H6   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017121 |





    # Populate the stub with 1619 (05XYZ) data

    # Change the date 
    Given the override date is '18/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-4_1           | 4_1            | 1619                        | AS-2021            | 4026.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017121-4_1  | 4_1                    | 1619-AS-2021-Contract-Provider-10017121-4_1           | 10017121      | Furth        | 05XYZ           | 4026.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017121-4_1  | 1619-004        | 4026.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017121-4_1  | 1619-004        | FY-2021              | May                    | 2021              | 4026.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '21/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                    |
    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-4_1             | 4_1            | AS-2021 | 1619                        | 4026.00     | ?               | Parked            | AwaitingContractTypeConfig   |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Replaced
@CFS
Scenario: A122x Create and consume a DADA FA with Allocation Funding Line code set to DADA-000. Fail: Park 'Awaiting Funding Line Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017122'
    And   there is no Funding Allocation data in CRM for UKPRN '10017122'
    And   there is no Contract, Task or Workflow data for UKPRN '10017122'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017122' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017122 Co Ltd' with UKPRN '10017122' and OrgId 'ORG0017122' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017122' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017122 | 117122 | 10017122 Co Ltd | 0              | Active                | Yes           | AA017122      | ?             | 5 Strand Court         | Bath Road              | ?                      | ?                      | Cheltenham             | Gloucestershire        | GL53 7LW  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017122 |





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '18/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017122 | DADA-AS-2021-Contract-Provider-10017122-2_7           | 2_7            | DADA                        | AS-2021            | 21247.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10017122-2_7  | 2_7                    | DADA-AS-2021-Contract-Provider-10017122-2_7           | 10017122      | Furth        | 07HEP           | 21247.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10017122-2_7  | DADA-000        | 21247.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10017122-2_7  | DADA-000        | FY-2021              | August                 | 2020              | 5026.00                   |
    | DADA-AS-2021-10017122-2_7  | DADA-000        | FY-2021              | January                | 2021              | 4727.00                   |
    | DADA-AS-2021-10017122-2_7  | DADA-000        | FY-2021              | April                  | 2021              | 5624.00                   |
    | DADA-AS-2021-10017122-2_7  | DADA-000        | FY-2021              | July                   | 2021              | 5870.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '21/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                 |
    | 10017122 | DADA-AS-2021-Contract-Provider-10017122-2_7             | 2_7            | AS-2021 | DADA                        | 21247.00    | ?               | Parked            | AwaitingFundingLineConfig |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Replaced
@CFS
Scenario: A120 Create and consume a NLG FA with an unrecognised AllocationFundingStreamCode. Fail: Park 'Awaiting Funding Allocation Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017120'
    And   there is no Funding Allocation data in CRM for UKPRN '10017120'
    And   there is no Contract, Task or Workflow data for UKPRN '10017120'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017120'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017120'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017120' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017120' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017120 Co Ltd' with UKPRN '10017120' and OrgId 'ORG0017120' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017120' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017120 | 117120 | 10017120 Co Ltd | 0              | In Administration     | Yes           | AA017120      | ?             | 108 Welsh Row          | ?                      | ?                      | ?                      | Nantwich               | Cheshire               | CW5 5EY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017120 |




    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
 #  | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
 #  | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

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
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
 #  | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
 #  | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
 #  | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '05/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017120 | NLG-AS-2021-Contract-Provider-10017120-2_1            | 2_1            | NLG                         | AS-2021            | 40661.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017120-2_1   | 2_1                    | NLG-AS-2021-Contract-Provider-10017120-2_1            | 10017120      | Furth        | 02IPP           | 40661.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | 21875.00         | Payment         |
    | NLG-AS-2021-10017120-2_1   | NLG-002         | 18786.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | September              | 2020              | 2763.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | November               | 2020              | 2704.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | January                | 2021              | 3943.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | March                  | 2021              | 4226.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | April                  | 2021              | 4440.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-001         | FY-2021              | June                   | 2021              | 3799.00                   |
    #
    | NLG-AS-2021-10017120-2_1   | NLG-002         | FY-2021              | August                 | 2020              | 5573.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-002         | FY-2021              | January                | 2021              | 2641.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-002         | FY-2021              | February               | 2021              | 3437.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-002         | FY-2021              | April                  | 2021              | 5050.00                   |
    | NLG-AS-2021-10017120-2_1   | NLG-002         | FY-2021              | June                   | 2021              | 2085.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '08/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    | 10017120 | NLG-AS-2021-Contract-Provider-10017120-2_1              | 2_1            | AS-2021 | NLG                         | 40661.00    | ?               | Parked            | AwaitingFundingAllocationConfig |





    # Populate the stub with a later version of the same NLG (02IPP) FA

    # Change the date 
    Given the override date is '09/06/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017120 | NLG-AS-2021-Contract-Provider-10017120-3_1            | 3_1            | NLG                         | AS-2021            | 21875.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017120-3_1   | 3_1                    | NLG-AS-2021-Contract-Provider-10017120-3_1            | 10017120      | Furth        | 02IPP           | 21875.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | 21875.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | September              | 2020              | 2763.00                   |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | November               | 2020              | 2704.00                   |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | January                | 2021              | 3943.00                   |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | March                  | 2021              | 4226.00                   |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | April                  | 2021              | 4440.00                   |
    | NLG-AS-2021-10017120-3_1   | NLG-001         | FY-2021              | June                   | 2021              | 3799.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '10/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                        |
    | 10017120 | NLG-AS-2021-Contract-Provider-10017120-3_1              | 3_1            | AS-2021 | NLG                         | 21875.00    | ?               | Parked            | AwaitingFundingAllocationConfig  |
    | 10017120 | NLG-AS-2021-Contract-Provider-10017120-2_1              | 2_1            | AS-2021 | NLG                         | 40661.00    | ?               | Discarded         | Superseded                       |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Replaced
@CFS
Scenario: A121 Create and consume a 1619 FA with an unrecognised ProviderType then ProviderSubType. Fail: 'Awaiting Contract Type Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017121'
    And   there is no Funding Allocation data in CRM for UKPRN '10017121'
    And   there is no Contract, Task or Workflow data for UKPRN '10017121'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017121'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017121'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017121' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017121' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017121 Co Ltd' with UKPRN '10017121' and OrgId 'ORG0017121' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017121' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017121 | 117121 | 10017121 Co Ltd | 0              | Locked Restructure    | Yes           | AA017121      | ?             | 3 St. Mary's Road      | Long Ditton            | Surrey                 | ?                      | ?                      | ?                      | KT6 5EU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017121 |


    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

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
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with 1619 (05ADC) data

    # Change the date 
    Given the override date is '05/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-4_7           | 4_7            | 1619                        | AS-2021            | 3447.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017121-4_7  | 4_7                    | 1619-AS-2021-Contract-Provider-10017121-4_7           | 10017121      | Xxxxx        | 05ADC           | 3447.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017121-4_7  | 1619-020        | 3447.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017121-4_7  | 1619-020        | FY-2021              | October                | 2020              | 3447.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '08/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-4_7             | 4_7            | AS-2021 | 1619                        | 3447.00     | ?               | Parked            | AwaitingContractTypeConfig        |




    # Populate the stub with the ProviderType on the FA changed from Xxxxx to Furth but with an unrecognised ProviderSubType

    # Change the date 
    Given the override date is '09/06/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-6_1           | 6_1            | 1619                        | AS-2021            | 3448.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017121-6_1  | 6_1                    | 1619-AS-2021-Contract-Provider-10017121-6_1           | 10017121      | Furth        | 99ADC           | 3448.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017121-6_1  | 1619-020        | 3448.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017121-6_1  | 1619-020        | FY-2021              | October                | 2020              | 3448.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '10/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                        |
    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-6_1             | 6_1            | AS-2021 | 1619                        | 3448.00     | ?               | Parked            | AwaitingContractTypeConfig       |
    | 10017121 | 1619-AS-2021-Contract-Provider-10017121-4_7             | 4_7            | AS-2021 | 1619                        | 3447.00     | ?               | Discarded         | Superseded                       |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Replaced
@CFS
Scenario: A122 Create and consume a DADA FA with an unrecognised AllocationFundingLineCode. Fail: Park 'Awaiting Funding Line Config'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017122'
    And   there is no Funding Allocation data in CRM for UKPRN '10017122'
    And   there is no Contract, Task or Workflow data for UKPRN '10017122'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017122'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017122'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017122' in the Sharepoint 'DADA-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017122' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017122 Co Ltd' with UKPRN '10017122' and OrgId 'ORG0017122' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017122' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017122 | 117122 | 10017122 Co Ltd | 0              | Provider Under Change | Yes           | AA017122      | ?             | 201 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017122 |


    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

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
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
 #  | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with DADA (01GFE) data

    # Change the date 
    Given the override date is '22/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017122 | DADA-AS-2021-Contract-Provider-10017122-4_0           | 4_0            | DADA                        | AS-2021            | 25053.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10017122-4_0  | 4_0                    | DADA-AS-2021-Contract-Provider-10017122-4_0           | 10017122      | Furth        | 01GFE           | 25053.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | 25053.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | August                 | 2020              | 4530.00                   |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | November               | 2020              | 5566.00                   |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | December               | 2020              | 3520.00                   |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | February               | 2021              | 3531.00                   |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | May                    | 2021              | 5625.00                   |
    | DADA-AS-2021-10017122-4_0  | DADA-001        | FY-2021              | July                   | 2021              | 2281.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '23/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017122 | DADA-AS-2021-Contract-Provider-10017122-4_0             | 4_0            | AS-2021 | DADA                        | 25053.00    | ?               | Parked            | AwaitingFundingLineConfig         |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A175 Create and consume a NLG FA with a mix of recognised and unrecognised AllocationFundingLineCodes. Fail: Park 'Awaiting Funding Line Config'
    
    # Replacement for A120-2

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017175'
    And   there is no Funding Allocation data in CRM for UKPRN '10017175'
    And   there is no Contract, Task or Workflow data for UKPRN '10017175'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017175'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017175'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017175' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017175' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017175 Co Ltd' with UKPRN '10017175' and OrgId 'ORG0017175' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017175' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017175 | 117175 | 10017175 Co Ltd | 0              | Active                | Yes           | AA017175      | ?             | 5 Chiswick High Road   | London                 | ?                      | ?                      | ?                      | ?                      | W4 5RG    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017175 |




    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

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
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
 #  | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '26/06/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017175 | NLG-AS-2021-Contract-Provider-10017175-1_6            | 1_6            | NLG                         | AS-2021            | 24991.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017175-1_6   | 1_6                    | NLG-AS-2021-Contract-Provider-10017175-1_6            | 10017175      | Furth        | 02IPP           | 24991.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017175-1_6   | NLG-001         | 3663.00          | Payment         |
    | NLG-AS-2021-10017175-1_6   | NLG-003         | 21328.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017175-1_6   | NLG-001         | FY-2021              | September              | 2020              | 3663.00                   |
    #
    | NLG-AS-2021-10017175-1_6   | NLG-003         | FY-2021              | August                 | 2020              | 4269.00                   |
    | NLG-AS-2021-10017175-1_6   | NLG-003         | FY-2021              | December               | 2020              | 5337.00                   |
    | NLG-AS-2021-10017175-1_6   | NLG-003         | FY-2021              | March                  | 2021              | 2132.00                   |
    | NLG-AS-2021-10017175-1_6   | NLG-003         | FY-2021              | May                    | 2021              | 4808.00                   |
    | NLG-AS-2021-10017175-1_6   | NLG-003         | FY-2021              | July                   | 2021              | 4782.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '29/06/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017175 | NLG-AS-2021-Contract-Provider-10017175-1_6              | 1_6            | AS-2021 | NLG                         | 24991.00    | ?               | Parked            | AwaitingFundingLineConfig         |


    # Tidy Up
    And   the override date is reset

