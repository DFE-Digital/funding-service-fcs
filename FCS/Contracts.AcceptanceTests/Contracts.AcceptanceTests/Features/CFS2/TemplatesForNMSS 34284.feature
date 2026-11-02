Feature: TemplatesForNMSS 34284

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A507 Import and release 1619 NMSS FA and two updated FAs. Change template timestamp. Create contract and check docs

    # 1. Import and release NMSS FA1 > six doc parts for contract v1
    # 2. Import and release NMSS FA2 > two doc parts for contract v2
    # 3. Update timestamp on NMSS Sch1
    # 4. Import and release NMSS FA3 > three doc parts for contract v3

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017507'
    And   there is no Funding Allocation data in CRM for UKPRN '10017507'
    And   there is no Contract, Task or Workflow data for UKPRN '10017507'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017507'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017507'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017507' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (NMSS)    |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017507' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017507 Co Ltd' with UKPRN '10017507' and OrgId 'ORG0017507' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017507' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017507 | 117507 | 10017507 Co Ltd | 0              | Active                | Yes           | AA017507      | ?             | 25 Aycliffe Road       | ?                      | ?                      | ?                      | Borehamwood            | Hertfordshire          | WD6 4JP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017507 |


    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
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
    | EDSK2122_S1_1618TRNME_CFS_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1618TRNME_COFG_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
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
    | EDSK2122_S2_1619ED_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 





    #Part1: Import and release NMSS FA1 > six doc parts for contract v1
    
    # Populate the stub with NMSS (21NMS) data

    # Change the date 
    Given the override date is '29/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6  | 1_6            | NMSS                        | AY-2122            | 121766.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017507-1_6  | 1_6                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6  | 10017507      | Schoo        | 21NMS           | 121766.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017507-1_6  | NMSS-001        | 15505.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-002        | 10366.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | 19325.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | 21799.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-005        | 17136.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-006        | 3738.00          | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | 16663.00         | Payment         |
    | NMSS-AY-2122-10017507-1_6  | NMSS-008        | 17234.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017507-1_6  | NMSS-001        | FY-2122              | September              | 2021              | 5718.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-001        | FY-2122              | December               | 2021              | 2000.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-001        | FY-2122              | February               | 2022              | 2214.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-001        | FY-2122              | July                   | 2022              | 5573.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-002        | FY-2122              | October                | 2021              | 3584.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-002        | FY-2122              | February               | 2022              | 3968.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-002        | FY-2122              | July                   | 2022              | 2814.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | FY-2122              | August                 | 2021              | 2172.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | FY-2122              | November               | 2021              | 4746.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | FY-2122              | March                  | 2022              | 2086.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | FY-2122              | May                    | 2022              | 5003.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-003        | FY-2122              | July                   | 2022              | 5318.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | FY-2122              | September              | 2021              | 5751.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | FY-2122              | December               | 2021              | 5350.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | FY-2122              | February               | 2022              | 3614.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | FY-2122              | May                    | 2022              | 4821.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-004        | FY-2122              | June                   | 2022              | 2263.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-005        | FY-2122              | September              | 2021              | 5715.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-005        | FY-2122              | January                | 2022              | 3604.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-005        | FY-2122              | April                  | 2022              | 4058.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-005        | FY-2122              | May                    | 2022              | 3759.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-006        | FY-2122              | July                   | 2022              | 3738.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | FY-2122              | October                | 2021              | 2024.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | FY-2122              | November               | 2021              | 3637.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | FY-2122              | February               | 2022              | 4673.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | FY-2122              | April                  | 2022              | 3691.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-007        | FY-2122              | July                   | 2022              | 2638.00                   |
    #
    | NMSS-AY-2122-10017507-1_6  | NMSS-008        | FY-2122              | September              | 2021              | 3440.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-008        | FY-2122              | January                | 2022              | 4509.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-008        | FY-2122              | March                  | 2022              | 5305.00                   |
    | NMSS-AY-2122-10017507-1_6  | NMSS-008        | FY-2122              | July                   | 2022              | 3980.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '01/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 121766.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 121766.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | AY-2122 | NMSS                        | 121766.00   | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_NMSS]       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 121766.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Released          | Released          | 121766.00   | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | AY-2122 | NMSS                        | 121766.00   | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017507 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017507 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 121766.00     | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017507 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017507 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017507 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017507 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 121766.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15505.00  | 0.00     | 5718.00  | 0.00     | 0.00     | 2000.00  | 0.00     | 2214.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5573.00  | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 10366.00  | 0.00     | 0.00     | 3584.00  | 0.00     | 0.00     | 0.00     | 3968.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2814.00  | SSF High Needs Element 2                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 19325.00  | 2172.00  | 0.00     | 0.00     | 4746.00  | 0.00     | 0.00     | 0.00     | 2086.00  | 0.00     | 5003.00  | 0.00     | 5318.00  | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 21799.00  | 0.00     | 5751.00  | 0.00     | 0.00     | 5350.00  | 0.00     | 3614.00  | 0.00     | 0.00     | 4821.00  | 2263.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 17136.00  | 0.00     | 5715.00  | 0.00     | 0.00     | 0.00     | 3604.00  | 0.00     | 0.00     | 4058.00  | 3759.00  | 0.00     | 0.00     | Primary PE and Sport Premium (1)                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 3738.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3738.00  | Teachers Pay Grant (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 16663.00  | 0.00     | 0.00     | 2024.00  | 3637.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 3691.00  | 0.00     | 0.00     | 2638.00  | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 17234.00  | 0.00     | 3440.00  | 0.00     | 0.00     | 0.00     | 4509.00  | 0.00     | 5305.00  | 0.00     | 0.00     | 0.00     | 3980.00  | Pupil Premium (NMSS)                                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017507_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """   
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £74,110 £47,656 £121,766
    Total Funding for this contract: £121,766
    Summary of Funding – Page 1
    
    Agreement Type Non-Maintained Special Schools (NMSS)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017507 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE NMSS
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE NMSS REPRESENTS AND WARRANTS THAT THE NMSS HAS READ AND
    UNDERSTOOD THIS AGREEMENT, THE NMSS AGREES TO BE BOUND BY THIS
    AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT THIS
    AGREEMENT AND LEGALLY BIND THE NMSS.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK NMSS Version 2 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    NMSS on the Manage Your Education & Skills Funding Service between:
    10017507 Co Ltd THE SECRETARY OF STATE FOR
    25 Aycliffe Road EDUCATION
    Borehamwood DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    WD6 4JP LONDON
    SW1P 3BT
    Company No: AA017507
    Hereinafter called Hereinafter called
    the NMSS the Department
    EDSK NMSS Version 2 (April 2022) Page 2
    EDSK NMSS Version 2 (April 2022) Page 58
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 2 (November 2021) – Page 1
    EDSK Schedule 1 – NMSS Version 2 (November 2021) – Page 10
    
    Schedule 1 Annex 1
    NOT USED
    EDSK Schedule 1 – NMSS Annex 1 Version 2 (November 2021) – Page 1

    Schedule 1 Annex 2
    Pupil premium: conditions of grant 2021 to 2022 (Non-Maintained
    Special Schools)
    EDSK Schedule 1 – NMSS Annex 2 Version 2 (November 2021) – Page 1
    EDSK Schedule 1 – NMSS Annex 2 Version 2 (November 2021) – Page 6

    SCHEDULE 2: PAYMENT
    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
    EDSK Schedule 2 – NMSS Version 1 (August 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Bursary Funds £19,325 £2,172.00 £0.00 £0.00 £4,746.00 £0.00 £0.00 £0.00 £2,086.00 £0.00 £5,003.00 £0.00 £5,318.00
    SSF High Needs Element 2 £10,366 £0.00 £0.00 £3,584.00 £0.00 £0.00 £0.00 £3,968.00 £0.00 £0.00 £0.00 £0.00 £2,814.00
    NMF Pre-16 Funding (NMSS) £15,505 £0.00 £5,718.00 £0.00 £0.00 £2,000.00 £0.00 £2,214.00 £0.00 £0.00 £0.00 £0.00 £5,573.00
    Pre-16 Universal Infant Free School Meals £21,799 £0.00 £5,751.00 £0.00 £0.00 £5,350.00 £0.00 £3,614.00 £0.00 £0.00 £4,821.00 £2,263.00 £0.00
    Teachers Pay Grant (NMSS) £3,738 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,738.00
    Teachers Pension Scheme (NMSS) £16,663 £0.00 £0.00 £2,024.00 £3,637.00 £0.00 £0.00 £4,673.00 £0.00 £3,691.00 £0.00 £0.00 £2,638.00
    Pupil Premium (NMSS) £17,234 £0.00 £3,440.00 £0.00 £0.00 £0.00 £4,509.00 £0.00 £5,305.00 £0.00 £0.00 £0.00 £3,980.00
    Total Funding £121,766 £2,172.00 £20,624.00 £5,608.00 £8,383.00 £7,350.00 £8,113.00 £14,469.00 £7,391.00 £7,749.00 £13,583.00 £2,263.00 £24,061.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 - NMSS Version 1 (August 2021) – Page 1
    EDSK Schedule 9 – NMSS Version 1 (August 2021) – Page 5
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017507_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A507v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-08-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017507'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017507 - 10017507 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017507 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017507 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017507 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract

    # Change the date 
    Given the override date is '07/08/2021'

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
    | 10017507 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 121766.00   | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | 1_6            | AY-2122 | NMSS                        | 121766.00   | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-1_6    | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '8' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15505.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                      | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 10366.00     | 0             | 0        | SSF High Needs Element 2                       | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 19325.00     | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 21799.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 17136.00     | 0             | 0        | Primary PE and Sport Premium (1)                   | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 3738.00      | 0             | 0        | Teachers Pay Grant (NMSS)                      | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 16663.00     | 0             | 0        | Teachers Pension Scheme (NMSS)                 | ?                           |
    | 10017507 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 17234.00     | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |







    # Part 2: Import and release NMSS FA2 > two doc parts for contract v2

    # Populate the stub with NMSS (21NMS) data

    # Change the date 
    Given the override date is '20/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2  | 2_2            | NMSS                        | AY-2122            | 125000.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017507-2_2  | 2_2                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2  | 10017507      | Schoo        | 21NMS           | 125000.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017507-2_2  | NMSS-001        | 15505.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-002        | 10366.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | 19325.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | 21799.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-005        | 17136.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-006        | 3738.00          | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | 16663.00         | Payment         |
    | NMSS-AY-2122-10017507-2_2  | NMSS-008        | 17234.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017507-2_2  | NMSS-001        | FY-2122              | September              | 2021              | 5718.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-001        | FY-2122              | December               | 2021              | 2000.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-001        | FY-2122              | February               | 2022              | 2214.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-001        | FY-2122              | July                   | 2022              | 5573.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-002        | FY-2122              | October                | 2021              | 3584.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-002        | FY-2122              | February               | 2022              | 3968.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-002        | FY-2122              | July                   | 2022              | 2814.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | FY-2122              | August                 | 2021              | 2172.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | FY-2122              | November               | 2021              | 4746.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | FY-2122              | March                  | 2022              | 2086.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | FY-2122              | May                    | 2022              | 5003.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-003        | FY-2122              | July                   | 2022              | 5318.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | FY-2122              | September              | 2021              | 5751.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | FY-2122              | December               | 2021              | 5350.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | FY-2122              | February               | 2022              | 3614.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | FY-2122              | May                    | 2022              | 4821.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-004        | FY-2122              | June                   | 2022              | 2263.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-005        | FY-2122              | September              | 2021              | 5715.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-005        | FY-2122              | January                | 2022              | 3604.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-005        | FY-2122              | April                  | 2022              | 4058.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-005        | FY-2122              | May                    | 2022              | 3759.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-006        | FY-2122              | March                  | 2022              | 3234.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-006        | FY-2122              | July                   | 2022              | 3738.00                   |

    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | FY-2122              | October                | 2021              | 2024.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | FY-2122              | November               | 2021              | 3637.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | FY-2122              | February               | 2022              | 4673.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | FY-2122              | April                  | 2022              | 3691.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-007        | FY-2122              | July                   | 2022              | 2638.00                   |
    #
    | NMSS-AY-2122-10017507-2_2  | NMSS-008        | FY-2122              | September              | 2021              | 3440.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-008        | FY-2122              | January                | 2022              | 4509.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-008        | FY-2122              | March                  | 2022              | 5305.00                   |
    | NMSS-AY-2122-10017507-2_2  | NMSS-008        | FY-2122              | July                   | 2022              | 3980.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '21/10/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS2                |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2    | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 125000.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS2]      |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 125000.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2    | 2_2            | AY-2122 | NMSS                        | 125000.00   | [CofG_NMSS2]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '22/10/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_NMSS2]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS2 = [CofG_NMSS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_NMSS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 125000.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2    | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Released          | Released          | 125000.00   | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS2]    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2    | 2_2            | AY-2122 | NMSS                        | 125000.00   | [CofG_NMSS2]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-2_2    | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017507 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017507 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 125000.00     | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017507 Co Ltd  | Active | Document Management Team  | 3234.00                |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017507 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 125000.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 3234.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15505.00  | 0.00     | 5718.00  | 0.00     | 0.00     | 2000.00  | 0.00     | 2214.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5573.00  | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 10366.00  | 0.00     | 0.00     | 3584.00  | 0.00     | 0.00     | 0.00     | 3968.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2814.00  | SSF High Needs Element 2                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 19325.00  | 2172.00  | 0.00     | 0.00     | 4746.00  | 0.00     | 0.00     | 0.00     | 2086.00  | 0.00     | 5003.00  | 0.00     | 5318.00  | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 21799.00  | 0.00     | 5751.00  | 0.00     | 0.00     | 5350.00  | 0.00     | 3614.00  | 0.00     | 0.00     | 4821.00  | 2263.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 17136.00  | 0.00     | 5715.00  | 0.00     | 0.00     | 0.00     | 3604.00  | 0.00     | 0.00     | 4058.00  | 3759.00  | 0.00     | 0.00     | Primary PE and Sport Premium (1)                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 6972.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3234.00  | 0.00     | 0.00     | 0.00     | 3738.00  | Teachers Pay Grant (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 16663.00  | 0.00     | 0.00     | 2024.00  | 3637.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 3691.00  | 0.00     | 0.00     | 2638.00  | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 17234.00  | 0.00     | 3440.00  | 0.00     | 0.00     | 0.00     | 4509.00  | 0.00     | 5305.00  | 0.00     | 0.00     | 0.00     | 3980.00  | Pupil Premium (NMSS)                                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF & FA)
    And   the file named '10017507_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """   
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £77,344 £47,656 £125,000
    Total Funding for this contract: £125,000
    Summary of Funding – Page 1
   
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Bursary Funds £19,325 £2,172.00 £0.00 £0.00 £4,746.00 £0.00 £0.00 £0.00 £2,086.00 £0.00 £5,003.00 £0.00 £5,318.00
    SSF High Needs Element 2 £10,366 £0.00 £0.00 £3,584.00 £0.00 £0.00 £0.00 £3,968.00 £0.00 £0.00 £0.00 £0.00 £2,814.00
    NMF Pre-16 Funding (NMSS) £15,505 £0.00 £5,718.00 £0.00 £0.00 £2,000.00 £0.00 £2,214.00 £0.00 £0.00 £0.00 £0.00 £5,573.00
    Pre-16 Universal Infant Free School Meals £21,799 £0.00 £5,751.00 £0.00 £0.00 £5,350.00 £0.00 £3,614.00 £0.00 £0.00 £4,821.00 £2,263.00 £0.00
    Teachers Pay Grant (NMSS) £6,972 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,234.00 £0.00 £0.00 £0.00 £3,738.00
    Teachers Pension Scheme (NMSS) £16,663 £0.00 £0.00 £2,024.00 £3,637.00 £0.00 £0.00 £4,673.00 £0.00 £3,691.00 £0.00 £0.00 £2,638.00
    Pupil Premium (NMSS) £17,234 £0.00 £3,440.00 £0.00 £0.00 £0.00 £4,509.00 £0.00 £5,305.00 £0.00 £0.00 £0.00 £3,980.00
    Total Funding £125,000 £2,172.00 £20,624.00 £5,608.00 £8,383.00 £7,350.00 £8,113.00 £14,469.00 £10,625.00 £7,749.00 £13,583.00 £2,263.00 £24,061.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # The T&C doc has not been included
    And   the pdf file does not contain the following text
    """
    Agreement Type Non-Maintained Special Schools (NMSS)
    """
 
    # The Sch1 doc has not been included
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – NMSS Version 2 (November 2021) – Page 1
    """

    # The Sch2 doc has not been included
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # The Sch3 doc has not been included
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017507_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A507v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-10-22 09:12:35.000 |





    # Publish and approve the contract

    # Change the date 
    Given the override date is '23/10/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017507 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 3: Update timestamp on NMSS Sch1
    
    # Change the date
    Given the override date is '01/11/2021'
    
    # Update the timestamp on the NMSS S1 document template to a date after contract v2 was created (22/10/2021) (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-10-29 09:45:15.000 | 





    # Part 4: Import and release NMSS FA3 > three doc parts for contract v3

    # Populate the stub with NMSS (21NMS) data

    # Change the date 
    Given the override date is '03/11/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1  | 3_1            | NMSS                        | AY-2122            | 130000.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017507-3_1  | 3_1                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1  | 10017507      | Schoo        | 21NMS           | 130000.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017507-3_1  | NMSS-001        | 15505.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-002        | 10366.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | 19325.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | 21799.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-005        | 17136.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-006        | 3738.00          | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | 16663.00         | Payment         |
    | NMSS-AY-2122-10017507-3_1  | NMSS-008        | 17234.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017507-3_1  | NMSS-001        | FY-2122              | September              | 2021              | 5718.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-001        | FY-2122              | December               | 2021              | 2000.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-001        | FY-2122              | February               | 2022              | 2214.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-001        | FY-2122              | July                   | 2022              | 5573.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-002        | FY-2122              | October                | 2021              | 3584.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-002        | FY-2122              | February               | 2022              | 3968.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-002        | FY-2122              | July                   | 2022              | 2814.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | FY-2122              | August                 | 2021              | 7172.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | FY-2122              | November               | 2021              | 4746.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | FY-2122              | March                  | 2022              | 2086.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | FY-2122              | May                    | 2022              | 5003.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-003        | FY-2122              | July                   | 2022              | 5318.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | FY-2122              | September              | 2021              | 5751.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | FY-2122              | December               | 2021              | 5350.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | FY-2122              | February               | 2022              | 3614.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | FY-2122              | May                    | 2022              | 4821.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-004        | FY-2122              | June                   | 2022              | 2263.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-005        | FY-2122              | September              | 2021              | 5715.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-005        | FY-2122              | January                | 2022              | 3604.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-005        | FY-2122              | April                  | 2022              | 4058.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-005        | FY-2122              | May                    | 2022              | 3759.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-006        | FY-2122              | March                  | 2022              | 3234.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-006        | FY-2122              | July                   | 2022              | 3738.00                   |

    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | FY-2122              | October                | 2021              | 2024.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | FY-2122              | November               | 2021              | 3637.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | FY-2122              | February               | 2022              | 4673.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | FY-2122              | April                  | 2022              | 3691.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-007        | FY-2122              | July                   | 2022              | 2638.00                   |
    #
    | NMSS-AY-2122-10017507-3_1  | NMSS-008        | FY-2122              | September              | 2021              | 3440.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-008        | FY-2122              | January                | 2022              | 4509.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-008        | FY-2122              | March                  | 2022              | 5305.00                   |
    | NMSS-AY-2122-10017507-3_1  | NMSS-008        | FY-2122              | July                   | 2022              | 3980.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '04/11/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS3                |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1    | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 130000.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS3]      |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 130000.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1    | 3_1            | AY-2122 | NMSS                        | 130000.00   | [CofG_NMSS3]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS3]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_NMSS3]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS3 = [CofG_NMSS3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_NMSS3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 130000.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017507' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017507 | 10017507 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1    | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2122     | Released          | Released          | 130000.00   | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS3]    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017507 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1    | 3_1            | AY-2122 | NMSS                        | 130000.00   | [CofG_NMSS3]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017507-3_1    | [ContractNo] | 3               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS3]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017507 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                 | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017507 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 130000.00     | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017507 Co Ltd  | Active | Document Management Team  | 5000.00                |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017507 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 130000.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 5000.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15505.00  | 0.00     | 5718.00  | 0.00     | 0.00     | 2000.00  | 0.00     | 2214.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5573.00  | NMF Pre-16 Funding (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 10366.00  | 0.00     | 0.00     | 3584.00  | 0.00     | 0.00     | 0.00     | 3968.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2814.00  | SSF High Needs Element 2                                    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 24325.00  | 7172.00  | 0.00     | 0.00     | 4746.00  | 0.00     | 0.00     | 0.00     | 2086.00  | 0.00     | 5003.00  | 0.00     | 5318.00  | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED] | 49              | 21799.00  | 0.00     | 5751.00  | 0.00     | 0.00     | 5350.00  | 0.00     | 3614.00  | 0.00     | 0.00     | 4821.00  | 2263.00  | 0.00     | Pre-16 Universal Infant Free School Meals                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 17136.00  | 0.00     | 5715.00  | 0.00     | 0.00     | 0.00     | 3604.00  | 0.00     | 0.00     | 4058.00  | 3759.00  | 0.00     | 0.00     | Primary PE and Sport Premium (1)                                |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 6972.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3234.00  | 0.00     | 0.00     | 0.00     | 3738.00  | Teachers Pay Grant (NMSS)                                   |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 16663.00  | 0.00     | 0.00     | 2024.00  | 3637.00  | 0.00     | 0.00     | 4673.00  | 0.00     | 3691.00  | 0.00     | 0.00     | 2638.00  | Teachers Pension Scheme (NMSS)                              |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 17234.00  | 0.00     | 3440.00  | 0.00     | 0.00     | 0.00     | 4509.00  | 0.00     | 5305.00  | 0.00     | 0.00     | 0.00     | 3980.00  | Pupil Premium (NMSS)                                        |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices (SoF, Sch1 & FA)
    And   the file named '10017507_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """   
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £82,344 £47,656 £130,000
    Total Funding for this contract: £130,000
    Summary of Funding – Page 1

    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 2 (November 2021) – Page 1
    EDSK Schedule 1 – NMSS Version 2 (November 2021) – Page 10
    Schedule 1 Annex 1
    EDSK Schedule 1 – NMSS Annex 1 Version 2 (November 2021) – Page 1
    Schedule 1 Annex 2
    EDSK Schedule 1 – NMSS Annex 2 Version 2 (November 2021) – Page 1
    EDSK Schedule 1 – NMSS Annex 2 Version 2 (November 2021) – Page 6

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017507 Co Ltd UKPRN: 10017507
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Bursary Funds £24,325 £7,172.00 £0.00 £0.00 £4,746.00 £0.00 £0.00 £0.00 £2,086.00 £0.00 £5,003.00 £0.00 £5,318.00
    SSF High Needs Element 2 £10,366 £0.00 £0.00 £3,584.00 £0.00 £0.00 £0.00 £3,968.00 £0.00 £0.00 £0.00 £0.00 £2,814.00
    NMF Pre-16 Funding (NMSS) £15,505 £0.00 £5,718.00 £0.00 £0.00 £2,000.00 £0.00 £2,214.00 £0.00 £0.00 £0.00 £0.00 £5,573.00
    Pre-16 Universal Infant Free School Meals £21,799 £0.00 £5,751.00 £0.00 £0.00 £5,350.00 £0.00 £3,614.00 £0.00 £0.00 £4,821.00 £2,263.00 £0.00
    Teachers Pay Grant (NMSS) £6,972 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,234.00 £0.00 £0.00 £0.00 £3,738.00
    Teachers Pension Scheme (NMSS) £16,663 £0.00 £0.00 £2,024.00 £3,637.00 £0.00 £0.00 £4,673.00 £0.00 £3,691.00 £0.00 £0.00 £2,638.00
    Pupil Premium (NMSS) £17,234 £0.00 £3,440.00 £0.00 £0.00 £0.00 £4,509.00 £0.00 £5,305.00 £0.00 £0.00 £0.00 £3,980.00
    Total Funding £130,000 £7,172.00 £20,624.00 £5,608.00 £8,383.00 £7,350.00 £8,113.00 £14,469.00 £10,625.00 £7,749.00 £13,583.00 £2,263.00 £24,061.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """

    # The T&C doc has not been included
    And   the pdf file does not contain the following text
    """
    Agreement Type Non-Maintained Special Schools (NMSS)
    """
 
    # The Sch2 doc has not been included
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # The Sch3 doc has not been included
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017507_[ContractNo]_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A507v3.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2021-11-05 09:12:35.000 |





    # Publish and approve the contract

    # Change the date 
    Given the override date is '06/11/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017507 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017507 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017507 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    And   the override date is reset



