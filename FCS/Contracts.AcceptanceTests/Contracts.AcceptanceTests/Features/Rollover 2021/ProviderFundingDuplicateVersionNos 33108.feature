Feature: ProviderFundingDuplicateVersionNos 33108

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A050 Create and release a 1619 Funding Allocation with 2 schools. Publish and approve contract. NFA. Import 1619 FA with 3 schools and unchanged versions
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017050'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001302'
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001396'

    And   there is no Funding Allocation data in CRM for UKPRN '10017050'
    And   there is no Funding Allocation data in CRM for UKPRN '10001302'
    And   there is no Funding Allocation data in CRM for UKPRN '10001396'

    And   there is no Contract, Task or Workflow data for UKPRN '10017050'
    And   there is no Contract, Task or Workflow data for UKPRN '10001302'
    And   there is no Contract, Task or Workflow data for UKPRN '10001396'

    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017050'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017050'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017050' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017050' 
    Given there is no Organisation data for UKPRN '10001302'
    Given there is no Organisation data for UKPRN '10001396' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017050 Co Ltd' with UKPRN '10017050' and OrgId 'ORG0017050' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001302 Co Ltd' with UKPRN '10001302' and OrgId 'ORG0017050' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001396 Co Ltd' with UKPRN '10001396' and OrgId 'ORG0017050' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                    | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017050 | 117050 | Trumpton County Council | 0              | Active   | Yes           | AA017050      | ?             | 28 Stainburn Avenue    | Moortown               | Leeds                  | ?                      | ?                      | ?                      | LS17 6PG  |
    | 10001302 | 101302 | Chace Community School  | 0              | Active   | Yes           | AA001302      | ?             | 58 Greystone Road      | Antrim                 | ?                      | ?                      | ?                      | ?                      | BT41 1JZ  |
    | 10001396 | 101396 | Chilwell School         | 0              | Active   | Yes           | AA001396      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017050 |
    | 10001302 |
    | 10001396 |


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





    # Populate the stub with 1619 (10LAU) funding data for the Local Authority

    # Change the date 
    Given the override date is '02/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017050 | 1619-AS-2021-Contract-LocalAuthority-10017050-1_7     | 1_7            | 1619                        | AS-2021            | 8581.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017050-1_7  | 1_7                    | 1619-AS-2021-Contract-LocalAuthority-10017050-1_7     | 10017050      | Local        | 10LAU           | 8581.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017050-1_7  | 1619-024        | 8581.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017050-1_7  | 1619-024        | FY-2021              | October                | 2020              | 3893.00                   |
    | 1619-AS-2021-10017050-1_7  | 1619-024        | FY-2021              | April                  | 2021              | 4688.00                   |
 
 
 
 
 
    # Populate the stub with 1619 (08SSF) funding data for two schools

    # Funding Allocation 
    Given the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017050 | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_1  | 2_1            | 1619                        | AS-2021            | 22191.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10001302-2_5  | 2_5                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_1  | 10001302      | Schoo        | 08SSF           | 14673.00                  |
    | 1619-AS-2021-10001396-2_6  | 2_6                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_1  | 10001396      | Schoo        | 08SSF           | 7518.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | 14673.00         | Payment         |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | 7518.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | October                | 2020              | 3867.00                   |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | February               | 2021              | 5860.00                   |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | July                   | 2021              | 4946.00                   |
    #
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | August                 | 2020              | 2577.00                   |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | March                  | 2021              | 2791.00                   |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | April                  | 2021              | 2150.00                   |

 



    # Populate the stub with 1619 (10LAU) funding data for the Local Authority once more - with updated FundingId version and updated ProviderFundingId version (and with different financials)

    # Funding Allocation 
    Given the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017050 | 1619-AS-2021-Contract-LocalAuthority-10017050-3_3     | 3_3            | 1619                        | AS-2021            | 9999.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017050-3_3  | 3_3                    | 1619-AS-2021-Contract-LocalAuthority-10017050-3_3     | 10017050      | Local        | 10LAU           | 9999.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017050-3_3  | 1619-024        | 9999.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017050-3_3  | 1619-024        | FY-2021              | October                | 2020              | 3893.00                   |
    | 1619-AS-2021-10017050-3_3  | 1619-024        | FY-2021              | April                  | 2021              | 4688.00                   |
    | 1619-AS-2021-10017050-3_3  | 1619-024        | FY-2021              | June                   | 2021              | 1418.00                   |

 
 
 
 
    # Populate the stub with 1619 (08SSF) funding data for the two schools once more - with updated FundingId version but the same ProviderFundingId versions

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017050 | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_2  | 2_2            | 1619                        | AS-2021            | 22191.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10001302-2_5  | 2_5                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_2  | 10001302      | Schoo        | 08SSF           | 14673.00                  |
    | 1619-AS-2021-10001396-2_6  | 2_6                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_2  | 10001396      | Schoo        | 08SSF           | 7518.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | 14673.00         | Payment         |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | 7518.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | October                | 2020              | 3867.00                   |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | February               | 2021              | 5860.00                   |
    | 1619-AS-2021-10001302-2_5  | 1619-004        | FY-2021              | July                   | 2021              | 4946.00                   |
    #
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | August                 | 2020              | 2577.00                   |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | March                  | 2021              | 2791.00                   |
    | 1619-AS-2021-10001396-2_6  | 1619-003        | FY-2021              | April                  | 2021              | 2150.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '04/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

#    # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup   |
#    | 10017050 | Trumpton County Council | 1619-AS-2021-Contract-LocalAuthority-10017050-3_3       | 3_3            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2021     | Scheduling         | Awaiting Release        | 9999.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]      |
#    | 10017050 | Trumpton County Council | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_1    | 2_1            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2021     | Scheduling         | Awaiting Release        | 22191.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]      |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CofG_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 2               | 30772.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    Then  the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status            | SubStatus                         |
#    | 10017050 | 1619-AS-2021-Contract-LocalAuthority-10017050-3_3       | 3_3            | AS-2021 | 1619                        | 8581.00     | [CofG_LA]      | ?                 | ?                                 |
#    | 10017050 | 1619-AS-2021-Contract-LocalAuthoritySsf-10017050-2_1    | 2_1            | AS-2021 | 1619                        | 22191.00    | [CofG_LA]      | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'






 #   # Tidy Up
 #   Given the override date is reset

