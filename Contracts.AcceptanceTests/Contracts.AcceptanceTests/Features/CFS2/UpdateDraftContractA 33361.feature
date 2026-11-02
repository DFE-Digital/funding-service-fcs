Feature: UpdateDraftContractA 33361

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A070 Import and release a 1619 FA (LA plus one Delivery Org). Import and release an NMSS FA (LA and one Delivery Org), ie Update Draft. Check CRM, PaaS and docs
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017070'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018070'
    And   there is no Funding Allocation data in CRM for UKPRN '10017070'
    And   there is no Funding Allocation data in CRM for UKPRN '10018070'
    And   there is no Contract, Task or Workflow data for UKPRN '10017070'
    And   there is no Contract, Task or Workflow data for UKPRN '10018070'
    
    And   there are no notifications of type 'Release Rejected'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017070' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10018070' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017070' 
    And   there is no Organisation data for UKPRN '10018070' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017070 Co Ltd' with UKPRN '10017070' and OrgId 'ORG0017070' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018070 Co Ltd' with UKPRN '10018070' and OrgId 'ORG0018070' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017070 | 117070 | 10017070 Co Ltd | 0              | Active                | Yes           | AA017070      | ?             | 33 Waldorf Heights     | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 9JH  |
    | 10018070 | 118070 | 10018070 Co Ltd | 0              | Active                | Yes           | AA018070      | ?             | 45 Vincenzo Close      | North Mymms            | ?                      | ?                      | ?                      | ?                      | AL9 7NH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017070 |
    | 10018070 |


    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 





    # Populate the stub with 1619 (10LAU) data for Contracting Org 10017070

    # Change the date 
    Given the override date is '24/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017070 | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6     | 1_6            | 1619                        | AS-2122            | 82367.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017070-1_6  | 1_6                    | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6     | 10017070      | Local        | 10LAU           | 82367.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | 14957.00         | Payment         |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | 26477.00         | Payment         |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | 27288.00         | Payment         |
    | 1619-AS-2122-10017070-1_6  | 1619-021        | 13645.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | FY-2122              | September              | 2021              | 2139.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | FY-2122              | January                | 2022              | 2080.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | FY-2122              | February               | 2022              | 3320.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | FY-2122              | April                  | 2022              | 3602.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-004        | FY-2122              | July                   | 2022              | 3816.00                   |
    #
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | August                 | 2021              | 3542.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | November               | 2021              | 5433.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | January                | 2022              | 4824.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | March                  | 2022              | 4525.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | April                  | 2022              | 5423.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-008        | FY-2122              | June                   | 2022              | 2730.00                   |
    #
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | September              | 2021              | 3865.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | November               | 2021              | 5414.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | January                | 2022              | 5831.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | March                  | 2022              | 2455.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | May                    | 2022              | 5644.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-013        | FY-2122              | June                   | 2022              | 4079.00                   |
    #
    | 1619-AS-2122-10017070-1_6  | 1619-021        | FY-2122              | September              | 2021              | 3436.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-021        | FY-2122              | January                | 2022              | 2010.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-021        | FY-2122              | February               | 2022              | 3351.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-021        | FY-2122              | April                  | 2022              | 2266.00                   |
    | 1619-AS-2122-10017070-1_6  | 1619-021        | FY-2122              | June                   | 2022              | 2582.00                   |
 
 
 
 
 
    # Populate the stub with 1619 (08SSF) data for Delivery Org 10018070

    # Funding Allocation 
    Given the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017070 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4  | 2_4            | 1619                        | AS-2122            | 123618.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10018070-2_4  | 2_4                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4  | 10018070      | Schoo        | 08SSF           | 123618.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10018070-2_4  | 1619-001        | 14869.00         | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-002        | 21531.00         | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-004        | 3449.00          | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | 22754.00         | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | 25347.00         | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | 26869.00         | Payment         |
    | 1619-AS-2122-10018070-2_4  | 1619-013        | 8799.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10018070-2_4  | 1619-001        | FY-2122              | October                | 2021              | 4527.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-001        | FY-2122              | December               | 2021              | 5115.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-001        | FY-2122              | April                  | 2022              | 5227.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-002        | FY-2122              | August                 | 2021              | 4309.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-002        | FY-2122              | November               | 2021              | 5378.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-002        | FY-2122              | March                  | 2022              | 2173.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-002        | FY-2122              | May                    | 2022              | 4849.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-002        | FY-2122              | June                   | 2022              | 4822.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-004        | FY-2122              | June                   | 2022              | 3449.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | August                 | 2021              | 2938.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | November               | 2021              | 4931.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | December               | 2021              | 2955.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | March                  | 2022              | 3820.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | May                    | 2022              | 3350.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-007        | FY-2122              | July                   | 2022              | 4760.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | September              | 2021              | 3873.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | October                | 2021              | 3814.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | December               | 2021              | 5053.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | March                  | 2022              | 4274.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | May                    | 2022              | 4487.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-010        | FY-2122              | July                   | 2022              | 3846.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | August                 | 2021              | 3973.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | October                | 2021              | 4459.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | December               | 2021              | 5938.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | February               | 2022              | 2562.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | April                  | 2022              | 5751.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-011        | FY-2122              | June                   | 2022              | 4186.00                   |
    #
    | 1619-AS-2122-10018070-2_4  | 1619-013        | FY-2122              | September              | 2021              | 3916.00                   |
    | 1619-AS-2122-10018070-2_4  | 1619-013        | FY-2122              | May                    | 2022              | 4883.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '27/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017070 | 10017070 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 82367.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10017070 | 10017070 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 123618.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 205985.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017070 | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | 1_6            | AS-2122 | 1619                        | 82367.00    | [CofG_LA]    |
    | 10017070 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | 2_4            | AS-2122 | 1619                        | 123618.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '30/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 205985.00       |

    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017070' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017070 | 10017070 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 82367.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017070 | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | 1_6            | AS-2122 | 1619                        | 82367.00    | [CofG_LA]    |
    | 10017070 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | 2_4            | AS-2122 | 1619                        | 123618.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017070-1_6       | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017070-2_4    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017070 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017070 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017070 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 205985.00     | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017070 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017070 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017070 Co Ltd  | Active | CRM Integration           | ?                      |

    
    # Contracting Org 10017070

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017070 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 82367.00        | 10017070      | 10017070 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 14957.00  | 0.00     | 2139.00  | 0.00     | 0.00     | 0.00     | 2080.00  | 3320.00  | 0.00     | 3602.00  | 0.00     | 0.00     | 3816.00  | Residential Support Scheme                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 26477.00  | 3542.00  | 0.00     | 0.00     | 5433.00  | 0.00     | 4824.00  | 0.00     | 4525.00  | 5423.00  | 0.00     | 2730.00  | 0.00     | 16-19 Advanced Maths Premium                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 27288.00  | 0.00     | 3865.00  | 0.00     | 5414.00  | 0.00     | 5831.00  | 0.00     | 2455.00  | 0.00     | 5644.00  | 4079.00  | 0.00     | Maintained Special SSF Bursary Support         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 13645.00  | 0.00     | 3436.00  | 0.00     | 0.00     | 0.00     | 2010.00  | 3351.00  | 0.00     | 2266.00  | 0.00     | 2582.00  | 0.00     | Alternative Completions - Creative Sector      |                          |

    

    # Delivery Org 10018070

    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10018070' 

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017070 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 123618.00       | 10018070      | 10018070 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 2               | 14869.00  | 0.00     | 0.00     | 4527.00  | 0.00     | 5115.00  | 0.00     | 0.00     | 0.00     | 5227.00  | 0.00     | 0.00     | 0.00     | SSF Programme Funding                          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 21531.00  | 4309.00  | 0.00     | 0.00     | 5378.00  | 0.00     | 0.00     | 0.00     | 2173.00  | 0.00     | 4849.00  | 4822.00  | 0.00     | SSF Bursary Funds                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 3449.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3449.00  | 0.00     | Residential Support Scheme                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 114             | 22754.00  | 2938.00  | 0.00     | 0.00     | 4931.00  | 2955.00  | 0.00     | 0.00     | 3820.00  | 0.00     | 3350.00  | 0.00     | 4760.00  | SSF Capacity and Delivery                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 25347.00  | 0.00     | 3873.00  | 3814.00  | 0.00     | 5053.00  | 0.00     | 0.00     | 4274.00  | 0.00     | 4487.00  | 0.00     | 3846.00  | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 26869.00  | 3973.00  | 0.00     | 4459.00  | 0.00     | 5938.00  | 0.00     | 2562.00  | 0.00     | 5751.00  | 0.00     | 4186.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 8799.00   | 0.00     | 3916.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4883.00  | 0.00     | 0.00     | Maintained Special SSF Bursary Support         |                          |



    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '132' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017070_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017070 Co Ltd UKPRN: 10017070
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    Total Funding for this contract: £205,985
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017070 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017070 Co Ltd THE SECRETARY OF STATE FOR
    33 Waldorf Heights
    EDUCATION
    Blackwater
    DEPARTMENT FOR EDUCATION
    Camberley
    20 GREAT SMITH STREET
    AND
    Surrey
    LONDON
    GU17 9JH
    SW1P 3BT
    Company No: AA017070
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017070 Co Ltd UKPRN: 10017070
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Advanced Maths Premium £26,477 £3,542.00 £0.00 £0.00 £5,433.00 £0.00 £4,824.00 £0.00 £4,525.00 £5,423.00 £0.00 £2,730.00 £0.00
    Maintained Special SSF Bursary Support £27,288 £0.00 £3,865.00 £0.00 £5,414.00 £0.00 £5,831.00 £0.00 £2,455.00 £0.00 £5,644.00 £4,079.00 £0.00
    Residential Support Scheme £14,957 £0.00 £2,139.00 £0.00 £0.00 £0.00 £2,080.00 £3,320.00 £0.00 £3,602.00 £0.00 £0.00 £3,816.00
    Alternative Completions - Creative Sector £13,645 £0.00 £3,436.00 £0.00 £0.00 £0.00 £2,010.00 £3,351.00 £0.00 £2,266.00 £0.00 £2,582.00 £0.00
    Total Funding £82,367 £3,542.00 £9,440.00 £0.00 £10,847.00 £0.00 £14,745.00 £6,671.00 £6,980.00 £11,291.00 £5,644.00 £9,391.00 £3,816.00
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10018070 Co Ltd UKPRN: 10018070
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £14,869 £0.00 £0.00 £4,527.00 £0.00 £5,115.00 £0.00 £0.00 £0.00 £5,227.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £21,531 £4,309.00 £0.00 £0.00 £5,378.00 £0.00 £0.00 £0.00 £2,173.00 £0.00 £4,849.00 £4,822.00 £0.00
    Maintained Special SSF Bursary Support £8,799 £0.00 £3,916.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,883.00 £0.00 £0.00
    SSF Capacity and Delivery £22,754 £2,938.00 £0.00 £0.00 £4,931.00 £2,955.00 £0.00 £0.00 £3,820.00 £0.00 £3,350.00 £0.00 £4,760.00
    Residential Support Scheme £3,449 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,449.00 £0.00
    Alternative Completions - Sporting Excellence £26,869 £3,973.00 £0.00 £4,459.00 £0.00 £5,938.00 £0.00 £2,562.00 £0.00 £5,751.00 £0.00 £4,186.00 £0.00
    Teacher's Pension Scheme 1619 £25,347 £0.00 £3,873.00 £3,814.00 £0.00 £5,053.00 £0.00 £0.00 £4,274.00 £0.00 £4,487.00 £0.00 £3,846.00
    Total Funding £123,618 £11,220.00 £7,789.00 £12,800.00 £10,309.00 £19,061.00 £0.00 £2,562.00 £10,267.00 £10,978.00 £17,569.00 £12,457.00 £8,606.00
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017070_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A070.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate              |
    | [ContractNo]   | 1                     | 0                        | 2021-06-30 09:12:35.000  |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017070'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017070 - 10017070 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Update the contract, adding NMSS deliverables to Contracting and Delivery Orgs

    # Populate the stub with NMSS (08SSF) data for Contracting Org 10017070

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017070 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0  | 2_0            | NMSS                        | AY-2122            | 132849.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017070-2_0  | 2_0                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0  | 10017070      | Schoo        | 08SSF           | 78402.00                  |
    | NMSS-AY-2122-10018070-2_0  | 2_0                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0  | 10018070      | Schoo        | 08SSF           | 54747.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017070-2_0  | NMSS-002        | 2113.00          | Payment         |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | 28566.00         | Payment         |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | 23768.00         | Payment         |
    | NMSS-AY-2122-10017070-2_0  | NMSS-005        | 18385.00         | Payment         |
    | NMSS-AY-2122-10017070-2_0  | NMSS-006        | 5570.00          | Payment         |
    #
    | NMSS-AY-2122-10018070-2_0  | NMSS-002        | 6581.00          | Payment         |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | 23830.00         | Payment         |
    | NMSS-AY-2122-10018070-2_0  | NMSS-005        | 2047.00          | Payment         |
    | NMSS-AY-2122-10018070-2_0  | NMSS-007        | 15763.00         | Payment         |
    | NMSS-AY-2122-10018070-2_0  | NMSS-008        | 6526.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017070-2_0  | NMSS-002        | FY-2122              | December               | 2021              | 2113.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | August                 | 2021              | 5834.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | November               | 2021              | 4851.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | December               | 2021              | 3799.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | March                  | 2022              | 5893.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | May                    | 2022              | 3611.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-003        | FY-2122              | June                   | 2022              | 4578.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | August                 | 2021              | 3226.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | November               | 2021              | 5117.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | January                | 2022              | 5571.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | February               | 2022              | 5272.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | May                    | 2022              | 2168.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-004        | FY-2122              | July                   | 2022              | 2414.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-005        | FY-2122              | September              | 2021              | 5805.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-005        | FY-2122              | November               | 2021              | 3353.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-005        | FY-2122              | March                  | 2022              | 4832.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-005        | FY-2122              | June                   | 2022              | 4395.00                   |
    | NMSS-AY-2122-10017070-2_0  | NMSS-006        | FY-2122              | September              | 2021              | 5570.00                   |
    #
    | NMSS-AY-2122-10018070-2_0  | NMSS-002        | FY-2122              | January                | 2022              | 2329.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-002        | FY-2122              | July                   | 2022              | 4252.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | August                 | 2021              | 3773.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | October                | 2021              | 5493.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | January                | 2022              | 5397.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | February               | 2022              | 3560.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | April                  | 2022              | 2133.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-004        | FY-2122              | June                   | 2022              | 3474.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-005        | FY-2122              | October                | 2021              | 2047.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-007        | FY-2122              | October                | 2021              | 4570.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-007        | FY-2122              | November               | 2021              | 2150.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-007        | FY-2122              | March                  | 2022              | 4345.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-007        | FY-2122              | July                   | 2022              | 4698.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-008        | FY-2122              | October                | 2021              | 4422.00                   |
    | NMSS-AY-2122-10018070-2_0  | NMSS-008        | FY-2122              | April                  | 2022              | 2104.00                   |

 
 


    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017070 | 10017070 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 132849.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 132849.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017070 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | 2_0            | AY-2122 | NMSS                        | 132849.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 132849.00       |

    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017070' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017070 | 10017070 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Released          | Released          | 132849.00   | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017070 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | 2_0            | AY-2122 | NMSS                        | 132849.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017070-2_0    | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017070 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017070 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017070 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 339134.00     | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017070 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017070 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017070 Co Ltd  | Active | CRM Integration           | ?                      |



    # Contracting Org 10017070

    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017070' 

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017070 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 160769.00       | 10017070      | 10017070 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 14957.00  | 0.00     | 2139.00  | 0.00     | 0.00     | 0.00     | 2080.00  | 3320.00  | 0.00     | 3602.00  | 0.00     | 0.00     | 3816.00  | Residential Support Scheme                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 26477.00  | 3542.00  | 0.00     | 0.00     | 5433.00  | 0.00     | 4824.00  | 0.00     | 4525.00  | 5423.00  | 0.00     | 2730.00  | 0.00     | 16-19 Advanced Maths Premium                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 27288.00  | 0.00     | 3865.00  | 0.00     | 5414.00  | 0.00     | 5831.00  | 0.00     | 2455.00  | 0.00     | 5644.00  | 4079.00  | 0.00     | Maintained Special SSF Bursary Support         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 13645.00  | 0.00     | 3436.00  | 0.00     | 0.00     | 0.00     | 2010.00  | 3351.00  | 0.00     | 2266.00  | 0.00     | 2582.00  | 0.00     | Alternative Completions - Creative Sector      |                          |
    #
    | [ContractNo]   | [AllocRef_16ED] | 15              | 2113.00   | 0.00     | 0.00     | 0.00     | 0.00     | 2113.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF High Needs Element 2                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 28566.00  | 5834.00  | 0.00     | 0.00     | 4851.00  | 3799.00  | 0.00     | 0.00     | 5893.00  | 0.00     | 3611.00  | 4578.00  | 0.00     | SSF Bursary Funds                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 23768.00  | 3226.00  | 0.00     | 0.00     | 5117.00  | 0.00     | 5571.00  | 5272.00  | 0.00     | 0.00     | 2168.00  | 0.00     | 2414.00  | Pre-16 Universal Infant Free School Meals      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 18385.00  | 0.00     | 5805.00  | 0.00     | 3353.00  | 0.00     | 0.00     | 0.00     | 4832.00  | 0.00     | 0.00     | 4395.00  | 0.00     | Primary PE and Sport Premium (1)                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 5570.00   | 0.00     | 5570.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                      |                          |

    

    # Delivery Org 10018070

    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017070' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10018070' 

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017070 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 178365.00       | 10018070      | 10018070 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 2               | 14869.00  | 0.00     | 0.00     | 4527.00  | 0.00     | 5115.00  | 0.00     | 0.00     | 0.00     | 5227.00  | 0.00     | 0.00     | 0.00     | SSF Programme Funding                          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 21531.00  | 4309.00  | 0.00     | 0.00     | 5378.00  | 0.00     | 0.00     | 0.00     | 2173.00  | 0.00     | 4849.00  | 4822.00  | 0.00     | SSF Bursary Funds                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 3449.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3449.00  | 0.00     | Residential Support Scheme                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 114             | 22754.00  | 2938.00  | 0.00     | 0.00     | 4931.00  | 2955.00  | 0.00     | 0.00     | 3820.00  | 0.00     | 3350.00  | 0.00     | 4760.00  | SSF Capacity and Delivery                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 25347.00  | 0.00     | 3873.00  | 3814.00  | 0.00     | 5053.00  | 0.00     | 0.00     | 4274.00  | 0.00     | 4487.00  | 0.00     | 3846.00  | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 26869.00  | 3973.00  | 0.00     | 4459.00  | 0.00     | 5938.00  | 0.00     | 2562.00  | 0.00     | 5751.00  | 0.00     | 4186.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 8799.00   | 0.00     | 3916.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4883.00  | 0.00     | 0.00     | Maintained Special SSF Bursary Support         |                          |
    #
    | [ContractNo]   | [AllocRef_16ED] | 15              | 6581.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2329.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4252.00  | SSF High Needs Element 2                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 23830.00  | 3773.00  | 0.00     | 5493.00  | 0.00     | 0.00     | 5397.00  | 3560.00  | 0.00     | 2133.00  | 0.00     | 3474.00  | 0.00     | Pre-16 Universal Infant Free School Meals      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 2047.00   | 0.00     | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Primary PE and Sport Premium (1)                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 15763.00  | 0.00     | 0.00     | 4570.00  | 2150.00  | 0.00     | 0.00     | 0.00     | 4345.00  | 0.00     | 0.00     | 0.00     | 4698.00  | Teachers Pension Scheme (NMSS)                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 6526.00   | 0.00     | 0.00     | 4422.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2104.00  | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '252' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017070_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017070_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A070.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate              |
    | [ContractNo]   | 1                     | 1                        | 2021-07-03 10:31:45.000  |

   # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017070'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017070 - 10017070 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017070 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A079 Import and release a 1619 FA. Update Draft to add NMSS FA with 2 Delivery Orgs then release FA. Check docs, CRM and PaaS
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017079'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025748'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10045159'
    And   there is no Funding Allocation data in CRM for UKPRN '10017079'
    And   there is no Funding Allocation data in CRM for UKPRN '10025748'
    And   there is no Funding Allocation data in CRM for UKPRN '10045159'
    And   there is no Contract, Task or Workflow data for UKPRN '10017079'
    And   there is no Contract, Task or Workflow data for UKPRN '10025748'
    And   there is no Contract, Task or Workflow data for UKPRN '10045159'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017079'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017079'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017079' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017079' 
    And   there is no Organisation data for UKPRN '10025748'
    And   there is no Organisation data for UKPRN '10045159' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017079 Co Ltd' with UKPRN '10017079' and OrgId 'ORG0017079' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10025748 Co Ltd' with UKPRN '10025748' and OrgId 'ORG0025748' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10045159 Co Ltd' with UKPRN '10045159' and OrgId 'ORG0045159' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017079 | 117079 | 10017079 Co Ltd | 0              | Active                | Yes           | AA017079      | ?             | 25 Aycliffe Road       | Gladsby                | ?                      | ?                      | Abbots Wood            | Hertfordshire          | WD6 4JP   |
    | 10025748 | 125748 | 10025748 Co Ltd | 0              | Active                | Yes           | AA025748      | ?             | 4 Denville Road        | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV32 5UW  |
    | 10045159 | 145159 | 10045159 Co Ltd | 0              | Active                | Yes           | AA045159      | ?             | 30 Silverdale Avenue   | Shadwell North         | ?                      | ?                      | ?                      | Hertfordshire          | WD6 9TT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017079 |
    | 10025748 |
    | 10045159 |

    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 





    # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '27/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017079 | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6     | 1_6            | 1619                        | AS-2122            | 53161.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017079-1_6  | 1_6                    | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6     | 10017079      | Local        | 10LAU           | 53161.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | 23451.00         | Payment         |
    | 1619-AS-2122-10017079-1_6  | 1619-006        | 23660.00         | Payment         |
    | 1619-AS-2122-10017079-1_6  | 1619-013        | 6050.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | FY-2122              | September              | 2021              | 5856.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | FY-2122              | November               | 2021              | 2651.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | FY-2122              | March                  | 2022              | 5327.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | FY-2122              | May                    | 2022              | 5300.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-001        | FY-2122              | June                   | 2022              | 4317.00                   |
    #
    | 1619-AS-2122-10017079-1_6  | 1619-006        | FY-2122              | September              | 2021              | 3689.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-006        | FY-2122              | January                | 2022              | 4005.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-006        | FY-2122              | March                  | 2022              | 5997.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-006        | FY-2122              | April                  | 2022              | 5083.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-006        | FY-2122              | June                   | 2022              | 4886.00                   |
    #
    | 1619-AS-2122-10017079-1_6  | 1619-013        | FY-2122              | October                | 2021              | 2576.00                   |
    | 1619-AS-2122-10017079-1_6  | 1619-013        | FY-2122              | June                   | 2022              | 3474.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '30/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017079 | 10017079 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 53161.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 53161.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017079 | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | 1_6            | AS-2122 | 1619                        | 53161.00    | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 53161.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017079 | 10017079 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 53161.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017079 | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | 1_6            | AS-2122 | 1619                        | 53161.00    | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017079-1_6       | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017079 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017079 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017079 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 53161.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017079 Co Ltd  | Active | Document Management Team  |
    | 10017079 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017079 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017079 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 53161.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 23451.00  | 0.00     | 5856.00  | 0.00     | 2651.00  | 0.00     | 0.00     | 0.00     | 5327.00  | 0.00     | 5300.00  | 4317.00  | 0.00     | 16-19 Programme Funding                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 23660.00  | 0.00     | 3689.00  | 0.00     | 0.00     | 0.00     | 4005.00  | 0.00     | 5997.00  | 5083.00  | 0.00     | 4886.00  | 0.00     | 16-19 High Needs Element 2                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 6050.00   | 0.00     | 0.00     | 2576.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3474.00  | 0.00     | Maintained Special SSF Bursary Support         |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts in the Appendices
    And   the file named '10017079_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £30,101 £23,060 £53,161
    Total Funding for this contract: £53,161
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12    

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £23,451 £0.00 £5,856.00 £0.00 £2,651.00 £0.00 £0.00 £0.00 £5,327.00 £0.00 £5,300.00 £4,317.00 £0.00
    16-19 High Needs Element 2 £23,660 £0.00 £3,689.00 £0.00 £0.00 £0.00 £4,005.00 £0.00 £5,997.00 £5,083.00 £0.00 £4,886.00 £0.00
    Maintained Special SSF Bursary Support £6,050 £0.00 £0.00 £2,576.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,474.00 £0.00
    Total Funding £53,161 £0.00 £9,545.00 £2,576.00 £2,651.00 £0.00 £4,005.00 £0.00 £11,324.00 £5,083.00 £5,300.00 £12,677.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017079_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A079_1.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-03 09:12:35.000 |





    # Populate the stub with NMSS (08SSF) data to add two Delivery Orgs (10025748 and 10045159)

    # Change the date 
    Given the override date is '16/07/2021'

    # Clear down the stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017079 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8  | 1_8            | NMSS                        | AY-2122            | 110766.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10025748-1_8  | 1_8                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8  | 10025748      | Schoo        | 08SSF           | 65377.00                  |
    | NMSS-AY-2122-10045159-1_8  | 1_8                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8  | 10045159      | Schoo        | 08SSF           | 45389.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10025748-1_8  | NMSS-001        | 12823.00         | Payment         |
    | NMSS-AY-2122-10025748-1_8  | NMSS-002        | 13554.00         | Payment         |
    | NMSS-AY-2122-10025748-1_8  | NMSS-006        | 12912.00         | Payment         |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | 18968.00         | Payment         |
    | NMSS-AY-2122-10025748-1_8  | NMSS-008        | 7120.00          | Payment         |
    #
    | NMSS-AY-2122-10045159-1_8  | NMSS-005        | 13593.00         | Payment         |
    | NMSS-AY-2122-10045159-1_8  | NMSS-007        | 14101.00         | Payment         |
    | NMSS-AY-2122-10045159-1_8  | NMSS-008        | 17695.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10025748-1_8  | NMSS-001        | FY-2122              | August                 | 2021              | 2208.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-001        | FY-2122              | January                | 2022              | 2561.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-001        | FY-2122              | April                  | 2022              | 3629.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-001        | FY-2122              | June                   | 2022              | 4425.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-002        | FY-2122              | August                 | 2021              | 2846.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-002        | FY-2122              | February               | 2022              | 4769.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-002        | FY-2122              | May                    | 2022              | 5939.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-006        | FY-2122              | November               | 2021              | 3337.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-006        | FY-2122              | January                | 2022              | 5501.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-006        | FY-2122              | May                    | 2022              | 4074.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | FY-2122              | August                 | 2021              | 2710.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | FY-2122              | November               | 2021              | 4190.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | FY-2122              | February               | 2022              | 3752.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | FY-2122              | April                  | 2022              | 2940.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-007        | FY-2122              | June                   | 2022              | 5376.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-008        | FY-2122              | August                 | 2021              | 5061.00                   |
    | NMSS-AY-2122-10025748-1_8  | NMSS-008        | FY-2122              | March                  | 2022              | 2059.00                   |
    #
    | NMSS-AY-2122-10045159-1_8  | NMSS-005        | FY-2122              | September              | 2021              | 4442.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-005        | FY-2122              | December               | 2021              | 5238.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-005        | FY-2122              | July                   | 2022              | 3913.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-007        | FY-2122              | November               | 2021              | 4442.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-007        | FY-2122              | January                | 2022              | 5543.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-007        | FY-2122              | May                    | 2022              | 4116.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-008        | FY-2122              | September              | 2021              | 4718.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-008        | FY-2122              | November               | 2021              | 5855.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-008        | FY-2122              | February               | 2022              | 3505.00                   |
    | NMSS-AY-2122-10045159-1_8  | NMSS-008        | FY-2122              | July                   | 2022              | 3617.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '18/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017079 | 10017079 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 110766.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 110766.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017079 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '20/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 110766.00       |


    # Retrieve parameters from CRM for Delivery Org 10025748
   #When  I retrieve the latest contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10025748'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017079 | 10017079 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Released          | Released          | 110766.00   | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017079 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017079-1_8    | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017079 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017079 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM for the contract 
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017079 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 163927.00     | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017079 Co Ltd  | Active | Document Management Team  |
    | 10017079 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017079 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10025748
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017079 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 65377.00        | 10025748      | 10025748 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10025748
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 15              | 0                     | 13554.00  | 2846.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4769.00  | 0.00     | 0.00     | 5939.00  | 0.00     | 0.00     | SSF High Needs Element 2                                    |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 39              | 0                     | 12823.00  | 2208.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2561.00  | 0.00     | 0.00     | 3629.00  | 0.00     | 4425.00  | 0.00     | NMF Pre-16 Funding (NMSS)                                   |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 118             | 0                     | 12912.00  | 0.00     | 0.00     | 0.00     | 3337.00  | 0.00     | 5501.00  | 0.00     | 0.00     | 0.00     | 4074.00  | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 18968.00  | 2710.00  | 0.00     | 0.00     | 4190.00  | 0.00     | 0.00     | 3752.00  | 0.00     | 2940.00  | 0.00     | 5376.00  | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 7120.00   | 5061.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2059.00  | 0.00     | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |



    # Retrieve parameters from CRM for Delivery Org 10045159
   #When  I retrieve the latest contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10045159'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10045159
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017079 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 45389.00        | 10045159      | 10045159 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10045159
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 43              | 0                     | 13593.00  | 0.00     | 4442.00  | 0.00     | 0.00     | 5238.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3913.00  | Primary PE and Sport Premium                                |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 14101.00  | 0.00     | 0.00     | 0.00     | 4442.00  | 0.00     | 5543.00  | 0.00     | 0.00     | 0.00     | 4116.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 17695.00  | 0.00     | 4718.00  | 0.00     | 5855.00  | 0.00     | 0.00     | 3505.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3617.00  | Pupil Premium (NMSS)                                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '132' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Retrieve parameters from CRM for Contracting Org 10017079
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017079'

    # Check the contents of the Appendices for the Contracting Org 10017079
    Then  the file named '10017079_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10017079 Co Ltd [AllocRef_16ED] £30,101 £23,060 £53,161
    Total Funding for this contract: £163,927
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017079 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017079 Co Ltd THE SECRETARY OF STATE FOR
    25 Aycliffe Road
    EDUCATION
    Gladsby
    DEPARTMENT FOR EDUCATION
    Abbots Wood
    20 GREAT SMITH STREET
    AND
    Hertfordshire
    LONDON
    WD6 4JP
    SW1P 3BT
    Company No: AA017079
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £23,451 £0.00 £5,856.00 £0.00 £2,651.00 £0.00 £0.00 £0.00 £5,327.00 £0.00 £5,300.00 £4,317.00 £0.00
    16-19 High Needs Element 2 £23,660 £0.00 £3,689.00 £0.00 £0.00 £0.00 £4,005.00 £0.00 £5,997.00 £5,083.00 £0.00 £4,886.00 £0.00
    Maintained Special SSF Bursary Support £6,050 £0.00 £0.00 £2,576.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,474.00 £0.00
    Total Funding £53,161 £0.00 £9,545.00 £2,576.00 £2,651.00 £0.00 £4,005.00 £0.00 £11,324.00 £5,083.00 £5,300.00 £12,677.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
      
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017079_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A079_2.pdf'

    
    
    
    
    # Retrieve parameters from CRM for Delivery Org 10025748
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10025748'

    # Check the contents of the Appendices for the Contracting Org 10017079
    Then  the file named '10017079_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10025748 Co Ltd [AllocRef_16ED] £38,994 £26,383 £65,377
    Total Funding for this contract: £163,927
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10025748 Co Ltd UKPRN: 10025748
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF High Needs Element 2 £13,554 £2,846.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,769.00 £0.00 £0.00 £5,939.00 £0.00 £0.00
    NMF Pre-16 Funding (NMSS) £12,823 £2,208.00 £0.00 £0.00 £0.00 £0.00 £2,561.00 £0.00 £0.00 £3,629.00 £0.00 £4,425.00 £0.00
    Teachers Pay Grant (NMSS) £12,912 £0.00 £0.00 £0.00 £3,337.00 £0.00 £5,501.00 £0.00 £0.00 £0.00 £4,074.00 £0.00 £0.00
    Teachers Pension Scheme (NMSS) £18,968 £2,710.00 £0.00 £0.00 £4,190.00 £0.00 £0.00 £3,752.00 £0.00 £2,940.00 £0.00 £5,376.00 £0.00
    Pupil Premium (NMSS) £7,120 £5,061.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,059.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £65,377 £12,825.00 £0.00 £0.00 £7,527.00 £0.00 £8,062.00 £8,521.00 £2,059.00 £6,569.00 £10,013.00 £9,801.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """    
    
    
    
    
    
    # Retrieve parameters from CRM for Delivery Org 10045159
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10045159'

    # Check the contents of the Appendices for the Contracting Org 10017079
    Then  the file named '10017079_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017079 Co Ltd UKPRN: 10017079
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10045159 Co Ltd [AllocRef_16ED] £33,743 £11,646 £45,389
    Total Funding for this contract: £163,927
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10045159 Co Ltd UKPRN: 10045159
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Primary PE and Sport Premium £13,593 £0.00 £4,442.00 £0.00 £0.00 £5,238.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,913.00
    Teachers Pension Scheme (NMSS) £14,101 £0.00 £0.00 £0.00 £4,442.00 £0.00 £5,543.00 £0.00 £0.00 £0.00 £4,116.00 £0.00 £0.00
    Pupil Premium (NMSS) £17,695 £0.00 £4,718.00 £0.00 £5,855.00 £0.00 £0.00 £3,505.00 £0.00 £0.00 £0.00 £0.00 £3,617.00
    Total Funding £45,389 £0.00 £9,160.00 £0.00 £10,297.00 £5,238.00 £5,543.00 £3,505.00 £0.00 £0.00 £4,116.00 £0.00 £7,530.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """
   
    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 1                        | 2021-07-20 11:05:18.000 |





    # Contracting Org should now include a DeliveryUKPRN and DeliveryProvider name
    
    # Retrieve parameters from CRM for Contracting Org 10017079
   #When  I retrieve the latest contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017079' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017079'

    # Check that Contract Allocation in CRM for Contracting Org 10017079
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017079 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 53161.00        | 10017079      | 10017079 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check the Contract Deliverables and Deliverable Periods in CRM for Contracting Org 10017079     
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 18              | 0                     | 6050.00   | 0.00     | 0.00     | 2576.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3474.00  | 0.00     | Maintained Special SSF Bursary Support                      |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 20              | 0                     | 23451.00  | 0.00     | 5856.00  | 0.00     | 2651.00  | 0.00     | 0.00     | 0.00     | 5327.00  | 0.00     | 5300.00  | 4317.00  | 0.00     | 16-19 Programme Funding                                     |                          |
    | 10017079 | [ContractNo]   | [AllocRef_16ED]    | 22              | 0                     | 23660.00  | 0.00     | 3689.00  | 0.00     | 0.00     | 0.00     | 4005.00  | 0.00     | 5997.00  | 5083.00  | 0.00     | 4886.00  | 0.00     | 16-19 High Needs Element 2                                  |                          |
                                

     # Tidy Up
     And   the override date is reset

