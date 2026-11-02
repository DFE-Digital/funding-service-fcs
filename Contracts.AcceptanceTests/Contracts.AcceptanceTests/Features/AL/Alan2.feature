Feature: Alan2




@AcceptanceTest @Manual
Scenario: L021a Create Contract, Import FAs and approve - initial test data for 33108

#     Contracting Org 10014432 - ALLF 
#     Delivery Org 1 10014532 - 1619    
#     Delivery Org 2 10014632 - 1619
   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014432'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014632'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014532'
    And   there is no Funding Allocation data in CRM for UKPRN '10014432'
    And   there is no Funding Allocation data in CRM for UKPRN '10014632'
    And   there is no Funding Allocation data in CRM for UKPRN '10014532'
    And   there is no Contract, Task or Workflow data for UKPRN '10014432'
    And   there is no Contract, Task or Workflow data for UKPRN '10014632'
    And   there is no Contract, Task or Workflow data for UKPRN '10014532'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014432' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-4432     |
    | ALLF-4432     |

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-4432     |
    | ALLF-4432     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2021          |
    | ALLF2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-4432      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014432'

    # Set the 'base' timestamp for each of the 39 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    # 
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 | 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014432' 
    And   there is no Organisation data for UKPRN '10014532' 
    And   there is no Organisation data for UKPRN '10014632' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014432 Co Ltd' with UKPRN '10014432' and OrgId 'ORG0014432' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014432 | 114432 | 10014432 Co Ltd | 0              | Active                | Yes           | AA014432      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014532 | 114532 | 10014532 Co Ltd | 0              | Active                | Yes           | AA014532      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014632 | 114632 | 10014632 Co Ltd | 0              | Active                | Yes           | AA014632      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014432 |
    | 10014532 |
    | 10014632 |

    # Change the date 
    Given the override date is '01/06/2021'


    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
    | 10014432 | 10014432 Co Ltd      | ESFA-4432            | EDSK-4432      | 1                     | 01/08/2020        | 31/07/2021      | 17618.00      |                                       | Conditions of Funding (Grant) (LA)         | 2021   | New          | ORG0014432  |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10014432 | EDSK-4432      | ALLF-4432     | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 17618.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10014432 | EDSK-4432      | ALLF-4432     | 5               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Bursary                                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4432      | 1                     | 0                        | 2021-06-01 09:12:35.000 |




    # 1st FAs (New)

    # Populate the stub

    # Change the date 
    Given the override date is '05/06/2021'


 
    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014432 | 1619-AS-2021-Contract-LocalAuthoritySsf-10014432-2_1  | 2_1            | 1619                        | AS-2021            | 54861.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014532-2_1  | 2_1                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014432-2_1  | 10014532      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2021-10014632-2_1  | 2_1                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014432-2_1  | 10014632      | Schoo        | 08SSF           | 31415.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014532-2_1  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2021-10014532-2_1  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2021-10014632-2_1  | 1619-001        | 7086.00          | Payment         |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | 22799.00         | Payment         |
    | 1619-AS-2021-10014632-2_1  | 1619-009        | 1530.00          | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014532-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 5801.00                   |
    | 1619-AS-2021-10014532-2_1  | 1619-001        | FY-2021              | September              | 2020              | 2030.00                   |
    | 1619-AS-2021-10014532-2_1  | 1619-001        | FY-2021              | November               | 2020              | 4620.00                   |
    | 1619-AS-2021-10014532-2_1  | 1619-001        | FY-2021              | January                | 2021              | 5091.00                   |
    | 1619-AS-2021-10014532-2_1  | 1619-002        | FY-2021              | April                  | 2021              | 2546.00                   |
    | 1619-AS-2021-10014532-2_1  | 1619-002        | FY-2021              | May                    | 2021              | 3358.00                   |
    #
    | 1619-AS-2021-10014632-2_1  | 1619-001        | FY-2021              | October                | 2020              | 2539.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-001        | FY-2021              | November               | 2020              | 4547.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | FY-2021              | December               | 2020              | 5773.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | FY-2021              | January                | 2021              | 4919.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | FY-2021              | February               | 2021              | 3081.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | FY-2021              | March                  | 2021              | 4219.00                   |
    | 1619-AS-2021-10014632-2_1  | 1619-002        | FY-2021              | April                  | 2021              | 4807.00                   |
    #
    | 1619-AS-2021-10014632-2_1  | 1619-009        | FY-2021              | October                | 2020              | 1530.00                   |




    # Change the date 
    Given the override date is '08/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM
        

    # Tidy Up
    Then   the override date is reset



@AcceptanceTest @Manual
Scenario: L021b Import FA, optional release, withdraw, delete - test data for 33108/33218

   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014440'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014441'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014442'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014443'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014444'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014445'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014446'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014447'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014448'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014449'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014450'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014437'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014438'
    And   there is no Funding Allocation data in CRM for UKPRN '10014440'
    And   there is no Funding Allocation data in CRM for UKPRN '10014441'
    And   there is no Funding Allocation data in CRM for UKPRN '10014442'
    And   there is no Funding Allocation data in CRM for UKPRN '10014443'
    And   there is no Funding Allocation data in CRM for UKPRN '10014444'
    And   there is no Funding Allocation data in CRM for UKPRN '10014445'
    And   there is no Funding Allocation data in CRM for UKPRN '10014446'
    And   there is no Funding Allocation data in CRM for UKPRN '10014447'
    And   there is no Funding Allocation data in CRM for UKPRN '10014448'
    And   there is no Funding Allocation data in CRM for UKPRN '10014449'
    And   there is no Funding Allocation data in CRM for UKPRN '10014450'
    And   there is no Funding Allocation data in CRM for UKPRN '10014437'
    And   there is no Funding Allocation data in CRM for UKPRN '10014438'
    And   there is no Contract, Task or Workflow data for UKPRN '10014440'
    And   there is no Contract, Task or Workflow data for UKPRN '10014441'
    And   there is no Contract, Task or Workflow data for UKPRN '10014442'
    And   there is no Contract, Task or Workflow data for UKPRN '10014443'
    And   there is no Contract, Task or Workflow data for UKPRN '10014444'
    And   there is no Contract, Task or Workflow data for UKPRN '10014445'
    And   there is no Contract, Task or Workflow data for UKPRN '10014446'
    And   there is no Contract, Task or Workflow data for UKPRN '10014447'
    And   there is no Contract, Task or Workflow data for UKPRN '10014448'
    And   there is no Contract, Task or Workflow data for UKPRN '10014449'
    And   there is no Contract, Task or Workflow data for UKPRN '10014450'
    And   there is no Contract, Task or Workflow data for UKPRN '10014437'
    And   there is no Contract, Task or Workflow data for UKPRN '10014438'
#
#    # Cleardown Sharepoint appendix docs
#    And   there are no files prefixed '10014430' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
#
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014440' 
    And   there is no Organisation data for UKPRN '10014441' 
    And   there is no Organisation data for UKPRN '10014442' 
    And   there is no Organisation data for UKPRN '10014443' 
    And   there is no Organisation data for UKPRN '10014444' 
    And   there is no Organisation data for UKPRN '10014445' 
    And   there is no Organisation data for UKPRN '10014446' 
    And   there is no Organisation data for UKPRN '10014447' 
    And   there is no Organisation data for UKPRN '10014448' 
    And   there is no Organisation data for UKPRN '10014449' 
    And   there is no Organisation data for UKPRN '10014450' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014440 Co Ltd' with UKPRN '10014440' and OrgId 'ORG0014440' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014441 Co Ltd' with UKPRN '10014441' and OrgId 'ORG0014441' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014442 Co Ltd' with UKPRN '10014442' and OrgId 'ORG0014442' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014443 Co Ltd' with UKPRN '10014443' and OrgId 'ORG0014443' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014444 Co Ltd' with UKPRN '10014444' and OrgId 'ORG0014444' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014445 Co Ltd' with UKPRN '10014445' and OrgId 'ORG0014445' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014446 Co Ltd' with UKPRN '10014446' and OrgId 'ORG0014446' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014447 Co Ltd' with UKPRN '10014447' and OrgId 'ORG0014447' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014448 Co Ltd' with UKPRN '10014448' and OrgId 'ORG0014448' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014449 Co Ltd' with UKPRN '10014449' and OrgId 'ORG0014449' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014450 Co Ltd' with UKPRN '10014450' and OrgId 'ORG0014450' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014440 | 114440 | 10014440 Co Ltd | 0              | Active                | Yes           | AA014440      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014441 | 114441 | 10014441 Co Ltd | 0              | Active                | Yes           | AA014441      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014442 | 114442 | 10014442 Co Ltd | 0              | Active                | Yes           | AA014442      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10014443 | 114443 | 10014443 Co Ltd | 0              | Active                | Yes           | AA014443      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014444 | 114444 | 10014444 Co Ltd | 0              | Active                | Yes           | AA014444      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10014445 | 114445 | 10014445 Co Ltd | 0              | Active                | Yes           | AA014445      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014446 | 114446 | 10014446 Co Ltd | 0              | Active                | Yes           | AA014446      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014447 | 114447 | 10014447 Co Ltd | 0              | Active                | Yes           | AA014447      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10014448 | 114448 | 10014448 Co Ltd | 0              | Active                | Yes           | AA014448      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014449 | 114449 | 10014449 Co Ltd | 0              | Active                | Yes           | AA014449      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10014450 | 114450 | 10014450 Co Ltd | 0              | Active                | Yes           | AA014450      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014440 |
    | 10014441 |
    | 10014442 |
    | 10014443 |
    | 10014444 |
    | 10014445 |
    | 10014446 |
    | 10014447 |
    | 10014448 |
    | 10014449 |
    | 10014450 |



#    # 1st FAs (New)
#
    # Populate the stub

    # Change the date 
    Given the override date is '05/06/2021'


# 
#    # Funding Allocation THREE (DO_1619))
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014435 | 1619-AS-2021-Contract-LocalAuthoritySsf-10014435-3_2  | 3_2            | 1619                        | AS-2021            | 46427.00          |
#
#    # Provider Funding Allocation (DO_1619)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014535-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014435-3_2  | 10014533      | Schoo        | 08SSF           | 17542.00                  |
#    | 1619-AS-2021-10014635-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014435-3_2  | 10014633      | Schoo        | 08SSF           | 28885.00                  |
#    #| 1619-AS-2021-10014731-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014435-3_2  | 10014731      | Schoo        | 08SSF           | 31085.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (DO_1619)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014535-3_2  | 1619-001        | 17542.00         | Payment         |
#    #| 1619-AS-2021-10014535-3_2  | 1619-002        | 5904.00          | Payment         |
#    #
#    | 1619-AS-2021-10014635-3_2  | 1619-001        | 6086.00          | Payment         |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | 22799.00         | Payment         |
#    #| 1619-AS-2021-10014635-3_2  | 1619-005        | 12107.00         | Payment         |
#    #| 1619-AS-2021-10014635-3_2  | 1619-009        | 4626.00          | Payment         |
#    ##
#    #| 1619-AS-2021-10014731-3_2  | 1619-001        | 7287.00          | Payment         |
#    #| 1619-AS-2021-10014731-3_2  | 1619-002        | 23798.00         | Payment         |
#
#    # Funding Allocation Profile Period (DO_1619)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014535-3_2  | 1619-001        | FY-2021              | August                 | 2020              | 5801.00                   |
#    | 1619-AS-2021-10014535-3_2  | 1619-001        | FY-2021              | September              | 2020              | 2030.00                   |
#    | 1619-AS-2021-10014535-3_2  | 1619-001        | FY-2021              | November               | 2020              | 4620.00                   |
#    | 1619-AS-2021-10014535-3_2  | 1619-001        | FY-2021              | January                | 2021              | 5091.00                   |
#    #| 1619-AS-2021-10014535-3_2  | 1619-002        | FY-2021              | April                  | 2021              | 2546.00                   |
#    #| 1619-AS-2021-10014535-3_2  | 1619-002        | FY-2021              | May                    | 2021              | 3358.00                   |
#    #
#    | 1619-AS-2021-10014635-3_2  | 1619-001        | FY-2021              | October                | 2020              | 2039.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-001        | FY-2021              | November               | 2020              | 4047.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | FY-2021              | December               | 2020              | 5773.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | FY-2021              | January                | 2021              | 4533.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | FY-2021              | February               | 2021              | 3081.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | FY-2021              | March                  | 2021              | 4219.00                   |
#    | 1619-AS-2021-10014635-3_2  | 1619-002        | FY-2021              | April                  | 2021              | 4807.00                   |
#    #| 1619-AS-2021-10014635-3_2  | 1619-005        | FY-2021              | February               | 2021              | 3081.00                   |
#    #| 1619-AS-2021-10014635-3_2  | 1619-005        | FY-2021              | March                  | 2021              | 4219.00                   |
#    #| 1619-AS-2021-10014635-3_2  | 1619-005        | FY-2021              | April                  | 2021              | 4807.00                   |
#    #| 1619-AS-2021-10014635-3_2  | 1619-009        | FY-2021              | January                | 2021              | 4199.00                   |
#    #| 1619-AS-2021-10014635-3_2  | 1619-009        | FY-2021              | July                   | 2021              | 427.00                    |
#    #
#    | 1619-AS-2021-10014731-3_2  | 1619-001        | FY-2021              | August                 | 2020              | 2639.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-001        | FY-2021              | October                | 2020              | 4648.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | September              | 2020              | 5773.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | November               | 2020              | 4533.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | January                | 2021              | 3081.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | March                  | 2021              | 4218.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | May                    | 2021              | 3345.00                   |
#    | 1619-AS-2021-10014731-3_2  | 1619-002        | FY-2021              | July                   | 2021              | 2462.00                   |
#
#
#    ## Funding Allocation FOUR (DO_NFF)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014435 | NFF-AS-2021-Contract-LocalAuthority-10014435-3_0   | 3_0            | NFF                         | AY-2021            | 21011.00          |
#
#    # Provider Funding Allocation (DO_NFF)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014435-3_0   | 3_0                    | NFF-AS-2021-Contract-LocalAuthority-10014435-3_0   | 10014435      | Local        | 10LAU           | 21011.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (DO_NFF)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014435-3_0   | NFF-005         | 2746.00          | Payment         |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | 18265.00         | Payment         |
#
#    # Funding Allocation Profile Period (DO_NFF)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014435-3_0   | NFF-005         | FY-2021              | April                  | 2021              | 1142.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-005         | FY-2021              | October                | 2020              | 1604.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | FY-2021              | November               | 2020              | 2637.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | FY-2021              | December               | 2020              | 3107.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | FY-2021              | February               | 2021              | 3304.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | FY-2021              | April                  | 2021              | 4218.00                   |
#    | NFF-AS-2021-10014435-3_0   | NFF-006         | FY-2021              | June                   | 2021              | 4999.00                   |
#
#
 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014440 | DADA-AS-2021-Contract-Provider-10014440-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014440-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014440-1_7 | 10014440      | Furth        | 02IPP           | 34611.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | 34611.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
    | DADA-AS-2021-10014440-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |

 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014441 | DADA-AS-2021-Contract-Provider-10014441-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014441-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014441-1_7 | 10014441      | Furth        | 02IPP           | 34611.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | 34611.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
    | DADA-AS-2021-10014441-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |

 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014442 | DADA-AS-2021-Contract-Provider-10014442-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014442-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014442-1_7 | 10014442      | Furth        | 02IPP           | 34611.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | 34611.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
    | DADA-AS-2021-10014442-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |

 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014443 | DADA-AS-2021-Contract-Provider-10014443-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014443-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014443-1_7 | 10014443      | Furth        | 02IPP           | 34611.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | 34611.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
    | DADA-AS-2021-10014443-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |

 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014444 | DADA-AS-2021-Contract-Provider-10014444-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014444-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014444-1_7 | 10014444      | Furth        | 02IPP           | 34611.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | 34611.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
    | DADA-AS-2021-10014444-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |

#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014445 | DADA-AS-2021-Contract-Provider-10014445-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014445-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014445-1_7 | 10014445      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014445-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
# 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014446 | DADA-AS-2021-Contract-Provider-10014446-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014446-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014446-1_7 | 10014446      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014446-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
# 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014447 | DADA-AS-2021-Contract-Provider-10014447-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014447-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014447-1_7 | 10014447      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014447-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
# 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014448 | DADA-AS-2021-Contract-Provider-10014448-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014448-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014448-1_7 | 10014448      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014448-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
# 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014449 | DADA-AS-2021-Contract-Provider-10014449-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014449-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014449-1_7 | 10014449      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014449-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
# 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014450 | DADA-AS-2021-Contract-Provider-10014450-1_7       | 1_7            | DADA                        | AS-2021            | 34611.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014450-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014450-1_7 | 10014450      | Furth        | 02IPP           | 34611.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | 34611.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | August                 | 2020              | 4321.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | September              | 2020              | 4322.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | October                | 2020              | 4323.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | January                | 2021              | 4326.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | February               | 2021              | 4327.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | March                  | 2021              | 4328.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | June                   | 2021              | 4331.00                   |
#    | DADA-AS-2021-10014450-1_7  | DADA-001        | AY-2021              | July                   | 2021              | 4333.00                   |
#
#
#
#    # Change the date 
#    Given the override date is '14/06/2021'
#
#    # Funding Allocation (Set 1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014435 | 1619-AS-2021-Contract-LocalAuthority-10014435-2_0       | 2_0            | 1619                        | AS-2021            | 67831.29          |
#
#
#
#    # Provider Funding Allocation (Set 1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014435-2_0  | 2_0                    | 1619-AS-2021-Contract-LocalAuthority-10014435-2_0 | 10014435      | Local        | 10LAU           | 67831.29                  |
#
#    # Funding Allocation Line (aka Deliverable) (Set 1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | 21852.29          | Payment         |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | 20515.00          | Payment         |
#    | 1619-AS-2021-10014435-2_0  | 1619-003        | 3849.00           | Payment         |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | 21515.00          | Payment         |
#
#    # Funding Allocation Profile Period (Set 1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | August                 | 2020              | 445.34                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | September              | 2020              | 4592.68                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | December               | 2020              | 1346.18                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | February               | 2021              | 1029.37                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | April                  | 2021              | 4817.08                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | June                   | 2021              | 4625.93                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-001        | FY-2021              | July                   | 2021              | 4995.71                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | FY-2021              | September              | 2020              | 5735.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | FY-2021              | January                | 2021              | 5763.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | FY-2021              | February               | 2021              | 2745.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | FY-2021              | May                    | 2021              | 2423.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-002        | FY-2021              | July                   | 2021              | 3849.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-003        | FY-2021              | July                   | 2021              | 3849.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | FY-2021              | September              | 2020              | 6235.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | FY-2021              | December               | 2020              | 5763.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | FY-2021              | February               | 2021              | 2745.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | FY-2021              | May                    | 2021              | 2923.00                   |
#    | 1619-AS-2021-10014435-2_0  | 1619-005        | FY-2021              | June                   | 2021              | 3849.00                   |
#
#
#

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014437 | NLG-AY-2021-Contract-Provider-10014437-1_7        | 1_7            | NLG                         | AS-2021            | 41366.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AY-2021-10014437-1_7   | 1_7                     | NLG-AY-2021-Contract-Provider-10014437-1_7 | 10014437      | Furth        | 01GFE           | 41366.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AY-2021-10014437-1_7   | NLG-001         | 12000.00         | Payment         |
    | NLG-AY-2021-10014437-1_7   | NLG-002         | 5366.00          | Payment         |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | 24000.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AY-2021-10014437-1_7   | NLG-001         | AY-2021              | October                | 2020              | 12000.00                  |
    | NLG-AY-2021-10014437-1_7   | NLG-002         | AY-2021              | August                 | 2020              | 2699.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-002         | AY-2021              | February               | 2021              | 2667.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | August                 | 2020              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | September              | 2020              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | October                | 2020              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | November               | 2020              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | December               | 2020              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | January                | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | February               | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | March                  | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | April                  | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | May                    | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | June                   | 2021              | 2000.00                   |
    | NLG-AY-2021-10014437-1_7   | NLG-003         | AY-2021              | July                   | 2021              | 2000.00                   |



    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014438 | NMSS-AY-2021-Contract-Provider-10014438-2_4       | 2_4            | NMSS                        | AY-2021            | 35710.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10014438-2_4  | 2_4                    | NMSS-AY-2021-Contract-Provider-10014438-2_4 | 10014438      | Schoo        | 21NMS           | 35710.00                  |

    # Funding Allocation Line
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | 3889.00          | Payment         |
    | NMSS-AY-2021-10014438-2_4  | NMSS-002        | 6821.00          | Payment         |
    | NMSS-AY-2021-10014438-2_4  | NMSS-003        | 24000.00         | Payment         |
    | NMSS-AY-2021-10014438-2_4  | NMSS-007        | 1000.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | August                 | 2020              | 1234.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | September              | 2020              | 1000.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | October                | 2020              | 1000.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | November               | 2020              | 321.00                    |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | December               | 2020              | 100.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | January                | 2021              | 100.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | February               | 2021              | 12.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | March                  | 2021              | 10.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | April                  | 2021              | 10.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | May                    | 2021              | 1.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | June                   | 2021              | 1.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-001        | FY-2021              | July                   | 2021              | 100.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-002        | FY-2021              | February               | 2021              | 2406.00                   |
    | NMSS-AY-2021-10014438-2_4  | NMSS-002        | FY-2021              | December               | 2020              | 4415.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | August                 | 2020              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | September              | 2020              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | October                | 2020              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | November               | 2020              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | December               | 2020              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | January                | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | February               | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | March                  | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | April                  | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | May                    | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | June                   | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-003         | FY-2021              | July                   | 2021              | 2000.00                   |
    | NMSS-AY-2021-10014438-2_4   | NMSS-007         | FY-2021              | July                   | 2021              | 1000.00                   |




    # Change the date 
    Given the override date is '02/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM
        
 
    Then wait '10' seconds


    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   | CforS                     |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CforS]           |
    
    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    | CofF_NMSS                 |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofF_NMSS]       |
 
 
    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NonLG                     |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NonLG]           |
 
 
 
    Then wait '10' seconds


 

    # Change the date 
    Given the override date is '03/06/2020'


    When  I retrieve the latest contract details from CRM for provider '10014440' for FundingType 'DADA' and period '2021'


      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'


     # Change the date 
    Given the override date is '04/06/2020'


    When  I retrieve the latest contract details from CRM for provider '10014441' for FundingType 'DADA' and period '2021'

    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

 
    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

    # Change the date 
    Given the override date is '05/06/2020'


    When  I retrieve the latest contract details from CRM for provider '10014442' for FundingType 'DADA' and period '2021'

    Given   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

     # Change the date 
    Given the override date is '06/06/2020'


    # Retrieve parameters from CRM 
    Given   I retrieve the latest contract details from CRM for provider '10014438' for FundingType 'EDSK' and period '2021'

    And the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

     # Change the date 
    Given the override date is '07/06/2020'


    When  I retrieve the latest contract details from CRM for provider '10014437' for FundingType 'NLG' and period '2021'

    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

    # Change the date 
    Given the override date is '08/06/2020'


#    When  I retrieve the latest contract details from CRM for provider '10014443' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014443 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '09/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014444' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014444 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '10/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014445' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014445 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '13/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014446' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014446 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '12/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014447' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014447 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '13/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014448' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014448 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '12/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014449' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014449 | [ContractNo]   | 1                     | 0                  |
#
#    # Change the date 
#    Given the override date is '13/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014450' for FundingType 'DADA' and period '2021'
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014450 | [ContractNo]   | 1                     | 0                  |
#
#

    # Tidy Up
    Then   the override date is reset



@AcceptanceTest @Manual
Scenario: L022 Import 150 FA into 1 RG

   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014800'    
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014801'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014802'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014803'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014804'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014805'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014806'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014807'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014808'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014809'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014810'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014811'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014812'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014813'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014814'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014815'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014816'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014817'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014818'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014819'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014820'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014821'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014822'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014823'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014824'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014825'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014826'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014827'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014828'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014829'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014830'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014831'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014832'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014833'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014834'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014835'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014836'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014837'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014838'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014839'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014840'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014841'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014842'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014843'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014844'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014845'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014846'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014847'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014848'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014849'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014850'    
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014851'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014852'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014853'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014854'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014855'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014856'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014857'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014858'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014859'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014860'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014861'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014862'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014863'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014864'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014865'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014866'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014867'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014868'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014869'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014870'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014871'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014872'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014873'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014874'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014875'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014876'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014877'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014878'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014879'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014880'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014881'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014882'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014883'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014884'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014885'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014886'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014887'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014888'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014889'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014890'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014891'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014892'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014893'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014894'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014895'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014896'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014897'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014898'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014899'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014900'    
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014901'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014902'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014903'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014904'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014905'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014906'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014907'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014908'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014909'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014910'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014911'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014912'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014913'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014914'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014915'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014916'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014917'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014918'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014919'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014920'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014921'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014922'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014923'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014924'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014925'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014926'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014927'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014928'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014929'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014930'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014931'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014932'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014933'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014934'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014935'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014936'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014937'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014938'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014939'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014940'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014941'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014942'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014943'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014944'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014945'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014946'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014947'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014948'
#    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014949'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014800'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014801'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014802'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014803'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014804'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014805'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014806'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014807'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014808'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014809'
#    And   there is no Funding Allocation data in CRM for UKPRN '10014810'
#    And there is no Funding Allocation data in CRM for UKPRN '10014811'
#    And there is no Funding Allocation data in CRM for UKPRN '10014812'
#    And there is no Funding Allocation data in CRM for UKPRN '10014813'
#    And there is no Funding Allocation data in CRM for UKPRN '10014814'
#    And there is no Funding Allocation data in CRM for UKPRN '10014815'
#    And there is no Funding Allocation data in CRM for UKPRN '10014816'
#    And there is no Funding Allocation data in CRM for UKPRN '10014817'
#    And there is no Funding Allocation data in CRM for UKPRN '10014818'
#    And there is no Funding Allocation data in CRM for UKPRN '10014819'
#    And there is no Funding Allocation data in CRM for UKPRN '10014820'
#    And there is no Funding Allocation data in CRM for UKPRN '10014821'
#    And there is no Funding Allocation data in CRM for UKPRN '10014822'
#    And there is no Funding Allocation data in CRM for UKPRN '10014823'
#    And there is no Funding Allocation data in CRM for UKPRN '10014824'
#    And there is no Funding Allocation data in CRM for UKPRN '10014825'
#    And there is no Funding Allocation data in CRM for UKPRN '10014826'
#    And there is no Funding Allocation data in CRM for UKPRN '10014827'
#    And there is no Funding Allocation data in CRM for UKPRN '10014828'
#    And there is no Funding Allocation data in CRM for UKPRN '10014829'
#    And there is no Funding Allocation data in CRM for UKPRN '10014830'
#    And there is no Funding Allocation data in CRM for UKPRN '10014831'
#    And there is no Funding Allocation data in CRM for UKPRN '10014832'
#    And there is no Funding Allocation data in CRM for UKPRN '10014833'
#    And there is no Funding Allocation data in CRM for UKPRN '10014834'
#    And there is no Funding Allocation data in CRM for UKPRN '10014835'
#    And there is no Funding Allocation data in CRM for UKPRN '10014836'
#    And there is no Funding Allocation data in CRM for UKPRN '10014837'
#    And there is no Funding Allocation data in CRM for UKPRN '10014838'
#    And there is no Funding Allocation data in CRM for UKPRN '10014839'
#    And there is no Funding Allocation data in CRM for UKPRN '10014840'
#    And there is no Funding Allocation data in CRM for UKPRN '10014841'
#    And there is no Funding Allocation data in CRM for UKPRN '10014842'
#    And there is no Funding Allocation data in CRM for UKPRN '10014843'
#    And there is no Funding Allocation data in CRM for UKPRN '10014844'
#    And there is no Funding Allocation data in CRM for UKPRN '10014845'
#    And there is no Funding Allocation data in CRM for UKPRN '10014846'
#    And there is no Funding Allocation data in CRM for UKPRN '10014847'
#    And there is no Funding Allocation data in CRM for UKPRN '10014848'
#    And there is no Funding Allocation data in CRM for UKPRN '10014849'
#    And there is no Funding Allocation data in CRM for UKPRN '10014850'    
#    And there is no Funding Allocation data in CRM for UKPRN '10014851'
#    And there is no Funding Allocation data in CRM for UKPRN '10014852'
#    And there is no Funding Allocation data in CRM for UKPRN '10014853'
#    And there is no Funding Allocation data in CRM for UKPRN '10014854'
#    And there is no Funding Allocation data in CRM for UKPRN '10014855'
#    And there is no Funding Allocation data in CRM for UKPRN '10014856'
#    And there is no Funding Allocation data in CRM for UKPRN '10014857'
#    And there is no Funding Allocation data in CRM for UKPRN '10014858'
#    And there is no Funding Allocation data in CRM for UKPRN '10014859'
#    And there is no Funding Allocation data in CRM for UKPRN '10014860'
#    And there is no Funding Allocation data in CRM for UKPRN '10014861'
#    And there is no Funding Allocation data in CRM for UKPRN '10014862'
#    And there is no Funding Allocation data in CRM for UKPRN '10014863'
#    And there is no Funding Allocation data in CRM for UKPRN '10014864'
#    And there is no Funding Allocation data in CRM for UKPRN '10014865'
#    And there is no Funding Allocation data in CRM for UKPRN '10014866'
#    And there is no Funding Allocation data in CRM for UKPRN '10014867'
#    And there is no Funding Allocation data in CRM for UKPRN '10014868'
#    And there is no Funding Allocation data in CRM for UKPRN '10014869'
#    And there is no Funding Allocation data in CRM for UKPRN '10014870'
#    And there is no Funding Allocation data in CRM for UKPRN '10014871'
#    And there is no Funding Allocation data in CRM for UKPRN '10014872'
#    And there is no Funding Allocation data in CRM for UKPRN '10014873'
#    And there is no Funding Allocation data in CRM for UKPRN '10014874'
#    And there is no Funding Allocation data in CRM for UKPRN '10014875'
#    And there is no Funding Allocation data in CRM for UKPRN '10014876'
#    And there is no Funding Allocation data in CRM for UKPRN '10014877'
#    And there is no Funding Allocation data in CRM for UKPRN '10014878'
#    And there is no Funding Allocation data in CRM for UKPRN '10014879'
#    And there is no Funding Allocation data in CRM for UKPRN '10014880'
#    And there is no Funding Allocation data in CRM for UKPRN '10014881'
#    And there is no Funding Allocation data in CRM for UKPRN '10014882'
#    And there is no Funding Allocation data in CRM for UKPRN '10014883'
#    And there is no Funding Allocation data in CRM for UKPRN '10014884'
#    And there is no Funding Allocation data in CRM for UKPRN '10014885'
#    And there is no Funding Allocation data in CRM for UKPRN '10014886'
#    And there is no Funding Allocation data in CRM for UKPRN '10014887'
#    And there is no Funding Allocation data in CRM for UKPRN '10014888'
#    And there is no Funding Allocation data in CRM for UKPRN '10014889'
#    And there is no Funding Allocation data in CRM for UKPRN '10014890'
#    And there is no Funding Allocation data in CRM for UKPRN '10014891'
#    And there is no Funding Allocation data in CRM for UKPRN '10014892'
#    And there is no Funding Allocation data in CRM for UKPRN '10014893'
#    And there is no Funding Allocation data in CRM for UKPRN '10014894'
#    And there is no Funding Allocation data in CRM for UKPRN '10014895'
#    And there is no Funding Allocation data in CRM for UKPRN '10014896'
#    And there is no Funding Allocation data in CRM for UKPRN '10014897'
#    And there is no Funding Allocation data in CRM for UKPRN '10014898'
#    And there is no Funding Allocation data in CRM for UKPRN '10014899'
#    And there is no Funding Allocation data in CRM for UKPRN '10014900'    
#    And there is no Funding Allocation data in CRM for UKPRN '10014901'
#    And there is no Funding Allocation data in CRM for UKPRN '10014902'
#    And there is no Funding Allocation data in CRM for UKPRN '10014903'
#    And there is no Funding Allocation data in CRM for UKPRN '10014904'
#    And there is no Funding Allocation data in CRM for UKPRN '10014905'
#    And there is no Funding Allocation data in CRM for UKPRN '10014906'
#    And there is no Funding Allocation data in CRM for UKPRN '10014907'
#    And there is no Funding Allocation data in CRM for UKPRN '10014908'
#    And there is no Funding Allocation data in CRM for UKPRN '10014909'
#    And there is no Funding Allocation data in CRM for UKPRN '10014910'
#    And there is no Funding Allocation data in CRM for UKPRN '10014911'
#    And there is no Funding Allocation data in CRM for UKPRN '10014912'
#    And there is no Funding Allocation data in CRM for UKPRN '10014913'
#    And there is no Funding Allocation data in CRM for UKPRN '10014914'
#    And there is no Funding Allocation data in CRM for UKPRN '10014915'
#    And there is no Funding Allocation data in CRM for UKPRN '10014916'
#    And there is no Funding Allocation data in CRM for UKPRN '10014917'
#    And there is no Funding Allocation data in CRM for UKPRN '10014918'
#    And there is no Funding Allocation data in CRM for UKPRN '10014919'
#    And there is no Funding Allocation data in CRM for UKPRN '10014920'
#    And there is no Funding Allocation data in CRM for UKPRN '10014921'
#    And there is no Funding Allocation data in CRM for UKPRN '10014922'
#    And there is no Funding Allocation data in CRM for UKPRN '10014923'
#    And there is no Funding Allocation data in CRM for UKPRN '10014924'
#    And there is no Funding Allocation data in CRM for UKPRN '10014925'
#    And there is no Funding Allocation data in CRM for UKPRN '10014926'
#    And there is no Funding Allocation data in CRM for UKPRN '10014927'
#    And there is no Funding Allocation data in CRM for UKPRN '10014928'
#    And there is no Funding Allocation data in CRM for UKPRN '10014929'
#    And there is no Funding Allocation data in CRM for UKPRN '10014930'
#    And there is no Funding Allocation data in CRM for UKPRN '10014931'
#    And there is no Funding Allocation data in CRM for UKPRN '10014932'
#    And there is no Funding Allocation data in CRM for UKPRN '10014933'
#    And there is no Funding Allocation data in CRM for UKPRN '10014934'
#    And there is no Funding Allocation data in CRM for UKPRN '10014935'
#    And there is no Funding Allocation data in CRM for UKPRN '10014936'
#    And there is no Funding Allocation data in CRM for UKPRN '10014937'
#    And there is no Funding Allocation data in CRM for UKPRN '10014938'
#    And there is no Funding Allocation data in CRM for UKPRN '10014939'
#    And there is no Funding Allocation data in CRM for UKPRN '10014940'
#    And there is no Funding Allocation data in CRM for UKPRN '10014941'
#    And there is no Funding Allocation data in CRM for UKPRN '10014942'
#    And there is no Funding Allocation data in CRM for UKPRN '10014943'
#    And there is no Funding Allocation data in CRM for UKPRN '10014944'
#    And there is no Funding Allocation data in CRM for UKPRN '10014945'
#    And there is no Funding Allocation data in CRM for UKPRN '10014946'
#    And there is no Funding Allocation data in CRM for UKPRN '10014947'
#    And there is no Funding Allocation data in CRM for UKPRN '10014948'
#    And there is no Funding Allocation data in CRM for UKPRN '10014949'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014800'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014801'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014802'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014803'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014804'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014805'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014806'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014807'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014808'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014809'
#    And   there is no Contract, Task or Workflow data for UKPRN '10014810'
#    And there is no Contract, Task or Workflow data for UKPRN '10014811'
#    And there is no Contract, Task or Workflow data for UKPRN '10014812'
#    And there is no Contract, Task or Workflow data for UKPRN '10014813'
#    And there is no Contract, Task or Workflow data for UKPRN '10014814'
#    And there is no Contract, Task or Workflow data for UKPRN '10014815'
#    And there is no Contract, Task or Workflow data for UKPRN '10014816'
#    And there is no Contract, Task or Workflow data for UKPRN '10014817'
#    And there is no Contract, Task or Workflow data for UKPRN '10014818'
#    And there is no Contract, Task or Workflow data for UKPRN '10014819'
#    And there is no Contract, Task or Workflow data for UKPRN '10014820'
#    And there is no Contract, Task or Workflow data for UKPRN '10014821'
#    And there is no Contract, Task or Workflow data for UKPRN '10014822'
#    And there is no Contract, Task or Workflow data for UKPRN '10014823'
#    And there is no Contract, Task or Workflow data for UKPRN '10014824'
#    And there is no Contract, Task or Workflow data for UKPRN '10014825'
#    And there is no Contract, Task or Workflow data for UKPRN '10014826'
#    And there is no Contract, Task or Workflow data for UKPRN '10014827'
#    And there is no Contract, Task or Workflow data for UKPRN '10014828'
#    And there is no Contract, Task or Workflow data for UKPRN '10014829'
#    And there is no Contract, Task or Workflow data for UKPRN '10014830'
#    And there is no Contract, Task or Workflow data for UKPRN '10014831'
#    And there is no Contract, Task or Workflow data for UKPRN '10014832'
#    And there is no Contract, Task or Workflow data for UKPRN '10014833'
#    And there is no Contract, Task or Workflow data for UKPRN '10014834'
#    And there is no Contract, Task or Workflow data for UKPRN '10014835'
#    And there is no Contract, Task or Workflow data for UKPRN '10014836'
#    And there is no Contract, Task or Workflow data for UKPRN '10014837'
#    And there is no Contract, Task or Workflow data for UKPRN '10014838'
#    And there is no Contract, Task or Workflow data for UKPRN '10014839'
#    And there is no Contract, Task or Workflow data for UKPRN '10014840'
#    And there is no Contract, Task or Workflow data for UKPRN '10014841'
#    And there is no Contract, Task or Workflow data for UKPRN '10014842'
#    And there is no Contract, Task or Workflow data for UKPRN '10014843'
#    And there is no Contract, Task or Workflow data for UKPRN '10014844'
#    And there is no Contract, Task or Workflow data for UKPRN '10014845'
#    And there is no Contract, Task or Workflow data for UKPRN '10014846'
#    And there is no Contract, Task or Workflow data for UKPRN '10014847'
#    And there is no Contract, Task or Workflow data for UKPRN '10014848'
#    And there is no Contract, Task or Workflow data for UKPRN '10014849'
#    And there is no Contract, Task or Workflow data for UKPRN '10014850'    
#    And there is no Contract, Task or Workflow data for UKPRN '10014851'
#    And there is no Contract, Task or Workflow data for UKPRN '10014852'
#    And there is no Contract, Task or Workflow data for UKPRN '10014853'
#    And there is no Contract, Task or Workflow data for UKPRN '10014854'
#    And there is no Contract, Task or Workflow data for UKPRN '10014855'
#    And there is no Contract, Task or Workflow data for UKPRN '10014856'
#    And there is no Contract, Task or Workflow data for UKPRN '10014857'
#    And there is no Contract, Task or Workflow data for UKPRN '10014858'
#    And there is no Contract, Task or Workflow data for UKPRN '10014859'
#    And there is no Contract, Task or Workflow data for UKPRN '10014860'
#    And there is no Contract, Task or Workflow data for UKPRN '10014861'
#    And there is no Contract, Task or Workflow data for UKPRN '10014862'
#    And there is no Contract, Task or Workflow data for UKPRN '10014863'
#    And there is no Contract, Task or Workflow data for UKPRN '10014864'
#    And there is no Contract, Task or Workflow data for UKPRN '10014865'
#    And there is no Contract, Task or Workflow data for UKPRN '10014866'
#    And there is no Contract, Task or Workflow data for UKPRN '10014867'
#    And there is no Contract, Task or Workflow data for UKPRN '10014868'
#    And there is no Contract, Task or Workflow data for UKPRN '10014869'
#    And there is no Contract, Task or Workflow data for UKPRN '10014870'
#    And there is no Contract, Task or Workflow data for UKPRN '10014871'
#    And there is no Contract, Task or Workflow data for UKPRN '10014872'
#    And there is no Contract, Task or Workflow data for UKPRN '10014873'
#    And there is no Contract, Task or Workflow data for UKPRN '10014874'
#    And there is no Contract, Task or Workflow data for UKPRN '10014875'
#    And there is no Contract, Task or Workflow data for UKPRN '10014876'
#    And there is no Contract, Task or Workflow data for UKPRN '10014877'
#    And there is no Contract, Task or Workflow data for UKPRN '10014878'
#    And there is no Contract, Task or Workflow data for UKPRN '10014879'
#    And there is no Contract, Task or Workflow data for UKPRN '10014880'
#    And there is no Contract, Task or Workflow data for UKPRN '10014881'
#    And there is no Contract, Task or Workflow data for UKPRN '10014882'
#    And there is no Contract, Task or Workflow data for UKPRN '10014883'
#    And there is no Contract, Task or Workflow data for UKPRN '10014884'
#    And there is no Contract, Task or Workflow data for UKPRN '10014885'
#    And there is no Contract, Task or Workflow data for UKPRN '10014886'
#    And there is no Contract, Task or Workflow data for UKPRN '10014887'
#    And there is no Contract, Task or Workflow data for UKPRN '10014888'
#    And there is no Contract, Task or Workflow data for UKPRN '10014889'
#    And there is no Contract, Task or Workflow data for UKPRN '10014890'
#    And there is no Contract, Task or Workflow data for UKPRN '10014891'
#    And there is no Contract, Task or Workflow data for UKPRN '10014892'
#    And there is no Contract, Task or Workflow data for UKPRN '10014893'
#    And there is no Contract, Task or Workflow data for UKPRN '10014894'
#    And there is no Contract, Task or Workflow data for UKPRN '10014895'
#    And there is no Contract, Task or Workflow data for UKPRN '10014896'
#    And there is no Contract, Task or Workflow data for UKPRN '10014897'
#    And there is no Contract, Task or Workflow data for UKPRN '10014898'
#    And there is no Contract, Task or Workflow data for UKPRN '10014899'
#    And there is no Contract, Task or Workflow data for UKPRN '10014900'    
#    And there is no Contract, Task or Workflow data for UKPRN '10014901'
#    And there is no Contract, Task or Workflow data for UKPRN '10014902'
#    And there is no Contract, Task or Workflow data for UKPRN '10014903'
#    And there is no Contract, Task or Workflow data for UKPRN '10014904'
#    And there is no Contract, Task or Workflow data for UKPRN '10014905'
#    And there is no Contract, Task or Workflow data for UKPRN '10014906'
#    And there is no Contract, Task or Workflow data for UKPRN '10014907'
#    And there is no Contract, Task or Workflow data for UKPRN '10014908'
#    And there is no Contract, Task or Workflow data for UKPRN '10014909'
#    And there is no Contract, Task or Workflow data for UKPRN '10014910'
#    And there is no Contract, Task or Workflow data for UKPRN '10014911'
#    And there is no Contract, Task or Workflow data for UKPRN '10014912'
#    And there is no Contract, Task or Workflow data for UKPRN '10014913'
#    And there is no Contract, Task or Workflow data for UKPRN '10014914'
#    And there is no Contract, Task or Workflow data for UKPRN '10014915'
#    And there is no Contract, Task or Workflow data for UKPRN '10014916'
#    And there is no Contract, Task or Workflow data for UKPRN '10014917'
#    And there is no Contract, Task or Workflow data for UKPRN '10014918'
#    And there is no Contract, Task or Workflow data for UKPRN '10014919'
#    And there is no Contract, Task or Workflow data for UKPRN '10014920'
#    And there is no Contract, Task or Workflow data for UKPRN '10014921'
#    And there is no Contract, Task or Workflow data for UKPRN '10014922'
#    And there is no Contract, Task or Workflow data for UKPRN '10014923'
#    And there is no Contract, Task or Workflow data for UKPRN '10014924'
#    And there is no Contract, Task or Workflow data for UKPRN '10014925'
#    And there is no Contract, Task or Workflow data for UKPRN '10014926'
#    And there is no Contract, Task or Workflow data for UKPRN '10014927'
#    And there is no Contract, Task or Workflow data for UKPRN '10014928'
#    And there is no Contract, Task or Workflow data for UKPRN '10014929'
#    And there is no Contract, Task or Workflow data for UKPRN '10014930'
#    And there is no Contract, Task or Workflow data for UKPRN '10014931'
#    And there is no Contract, Task or Workflow data for UKPRN '10014932'
#    And there is no Contract, Task or Workflow data for UKPRN '10014933'
#    And there is no Contract, Task or Workflow data for UKPRN '10014934'
#    And there is no Contract, Task or Workflow data for UKPRN '10014935'
#    And there is no Contract, Task or Workflow data for UKPRN '10014936'
#    And there is no Contract, Task or Workflow data for UKPRN '10014937'
#    And there is no Contract, Task or Workflow data for UKPRN '10014938'
#    And there is no Contract, Task or Workflow data for UKPRN '10014939'
#    And there is no Contract, Task or Workflow data for UKPRN '10014940'
#    And there is no Contract, Task or Workflow data for UKPRN '10014941'
#    And there is no Contract, Task or Workflow data for UKPRN '10014942'
#    And there is no Contract, Task or Workflow data for UKPRN '10014943'
#    And there is no Contract, Task or Workflow data for UKPRN '10014944'
#    And there is no Contract, Task or Workflow data for UKPRN '10014945'
#    And there is no Contract, Task or Workflow data for UKPRN '10014946'
#    And there is no Contract, Task or Workflow data for UKPRN '10014947'
#    And there is no Contract, Task or Workflow data for UKPRN '10014948'
#    And there is no Contract, Task or Workflow data for UKPRN '10014949'
#
    # Clear down the CFS stub and PaaS Funding Allocation tables
    And   there is no data in the CFS stub
#    And   there is no data in the Funding Allocation PaaS tables
#
#    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
#    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
#
# 
#    # Set organisation and advisors 
#    Given there is no Organisation data for UKPRN '10014800'
#    And   there is no Organisation data for UKPRN '10014801'
#    And   there is no Organisation data for UKPRN '10014802'
#    And   there is no Organisation data for UKPRN '10014803'
#    And   there is no Organisation data for UKPRN '10014804'
#    And   there is no Organisation data for UKPRN '10014805'
#    And   there is no Organisation data for UKPRN '10014806'
#    And   there is no Organisation data for UKPRN '10014807'
#    And   there is no Organisation data for UKPRN '10014808'
#    And   there is no Organisation data for UKPRN '10014809'
#    And   there is no Organisation data for UKPRN '10014810'
#    And there is no Organisation data for UKPRN '10014811'
#    And there is no Organisation data for UKPRN '10014812'
#    And there is no Organisation data for UKPRN '10014813'
#    And there is no Organisation data for UKPRN '10014814'
#    And there is no Organisation data for UKPRN '10014815'
#    And there is no Organisation data for UKPRN '10014816'
#    And there is no Organisation data for UKPRN '10014817'
#    And there is no Organisation data for UKPRN '10014818'
#    And there is no Organisation data for UKPRN '10014819'
#    And there is no Organisation data for UKPRN '10014820'
#    And there is no Organisation data for UKPRN '10014821'
#    And there is no Organisation data for UKPRN '10014822'
#    And there is no Organisation data for UKPRN '10014823'
#    And there is no Organisation data for UKPRN '10014824'
#    And there is no Organisation data for UKPRN '10014825'
#    And there is no Organisation data for UKPRN '10014826'
#    And there is no Organisation data for UKPRN '10014827'
#    And there is no Organisation data for UKPRN '10014828'
#    And there is no Organisation data for UKPRN '10014829'
#    And there is no Organisation data for UKPRN '10014830'
#    And there is no Organisation data for UKPRN '10014831'
#    And there is no Organisation data for UKPRN '10014832'
#    And there is no Organisation data for UKPRN '10014833'
#    And there is no Organisation data for UKPRN '10014834'
#    And there is no Organisation data for UKPRN '10014835'
#    And there is no Organisation data for UKPRN '10014836'
#    And there is no Organisation data for UKPRN '10014837'
#    And there is no Organisation data for UKPRN '10014838'
#    And there is no Organisation data for UKPRN '10014839'
#    And there is no Organisation data for UKPRN '10014840'
#    And there is no Organisation data for UKPRN '10014841'
#    And there is no Organisation data for UKPRN '10014842'
#    And there is no Organisation data for UKPRN '10014843'
#    And there is no Organisation data for UKPRN '10014844'
#    And there is no Organisation data for UKPRN '10014845'
#    And there is no Organisation data for UKPRN '10014846'
#    And there is no Organisation data for UKPRN '10014847'
#    And there is no Organisation data for UKPRN '10014848'
#    And there is no Organisation data for UKPRN '10014849'
#    And there is no Organisation data for UKPRN '10014850'    
#    And there is no Organisation data for UKPRN '10014851'
#    And there is no Organisation data for UKPRN '10014852'
#    And there is no Organisation data for UKPRN '10014853'
#    And there is no Organisation data for UKPRN '10014854'
#    And there is no Organisation data for UKPRN '10014855'
#    And there is no Organisation data for UKPRN '10014856'
#    And there is no Organisation data for UKPRN '10014857'
#    And there is no Organisation data for UKPRN '10014858'
#    And there is no Organisation data for UKPRN '10014859'
#    And there is no Organisation data for UKPRN '10014860'
#    And there is no Organisation data for UKPRN '10014861'
#    And there is no Organisation data for UKPRN '10014862'
#    And there is no Organisation data for UKPRN '10014863'
#    And there is no Organisation data for UKPRN '10014864'
#    And there is no Organisation data for UKPRN '10014865'
#    And there is no Organisation data for UKPRN '10014866'
#    And there is no Organisation data for UKPRN '10014867'
#    And there is no Organisation data for UKPRN '10014868'
#    And there is no Organisation data for UKPRN '10014869'
#    And there is no Organisation data for UKPRN '10014870'
#    And there is no Organisation data for UKPRN '10014871'
#    And there is no Organisation data for UKPRN '10014872'
#    And there is no Organisation data for UKPRN '10014873'
#    And there is no Organisation data for UKPRN '10014874'
#    And there is no Organisation data for UKPRN '10014875'
#    And there is no Organisation data for UKPRN '10014876'
#    And there is no Organisation data for UKPRN '10014877'
#    And there is no Organisation data for UKPRN '10014878'
#    And there is no Organisation data for UKPRN '10014879'
#    And there is no Organisation data for UKPRN '10014880'
#    And there is no Organisation data for UKPRN '10014881'
#    And there is no Organisation data for UKPRN '10014882'
#    And there is no Organisation data for UKPRN '10014883'
#    And there is no Organisation data for UKPRN '10014884'
#    And there is no Organisation data for UKPRN '10014885'
#    And there is no Organisation data for UKPRN '10014886'
#    And there is no Organisation data for UKPRN '10014887'
#    And there is no Organisation data for UKPRN '10014888'
#    And there is no Organisation data for UKPRN '10014889'
#    And there is no Organisation data for UKPRN '10014890'
#    And there is no Organisation data for UKPRN '10014891'
#    And there is no Organisation data for UKPRN '10014892'
#    And there is no Organisation data for UKPRN '10014893'
#    And there is no Organisation data for UKPRN '10014894'
#    And there is no Organisation data for UKPRN '10014895'
#    And there is no Organisation data for UKPRN '10014896'
#    And there is no Organisation data for UKPRN '10014897'
#    And there is no Organisation data for UKPRN '10014898'
#    And there is no Organisation data for UKPRN '10014899'
#    And there is no Organisation data for UKPRN '10014900'    
#    And there is no Organisation data for UKPRN '10014901'
#    And there is no Organisation data for UKPRN '10014902'
#    And there is no Organisation data for UKPRN '10014903'
#    And there is no Organisation data for UKPRN '10014904'
#    And there is no Organisation data for UKPRN '10014905'
#    And there is no Organisation data for UKPRN '10014906'
#    And there is no Organisation data for UKPRN '10014907'
#    And there is no Organisation data for UKPRN '10014908'
#    And there is no Organisation data for UKPRN '10014909'
#    And there is no Organisation data for UKPRN '10014910'
#    And there is no Organisation data for UKPRN '10014911'
#    And there is no Organisation data for UKPRN '10014912'
#    And there is no Organisation data for UKPRN '10014913'
#    And there is no Organisation data for UKPRN '10014914'
#    And there is no Organisation data for UKPRN '10014915'
#    And there is no Organisation data for UKPRN '10014916'
#    And there is no Organisation data for UKPRN '10014917'
#    And there is no Organisation data for UKPRN '10014918'
#    And there is no Organisation data for UKPRN '10014919'
#    And there is no Organisation data for UKPRN '10014920'
#    And there is no Organisation data for UKPRN '10014921'
#    And there is no Organisation data for UKPRN '10014922'
#    And there is no Organisation data for UKPRN '10014923'
#    And there is no Organisation data for UKPRN '10014924'
#    And there is no Organisation data for UKPRN '10014925'
#    And there is no Organisation data for UKPRN '10014926'
#    And there is no Organisation data for UKPRN '10014927'
#    And there is no Organisation data for UKPRN '10014928'
#    And there is no Organisation data for UKPRN '10014929'
#    And there is no Organisation data for UKPRN '10014930'
#    And there is no Organisation data for UKPRN '10014931'
#    And there is no Organisation data for UKPRN '10014932'
#    And there is no Organisation data for UKPRN '10014933'
#    And there is no Organisation data for UKPRN '10014934'
#    And there is no Organisation data for UKPRN '10014935'
#    And there is no Organisation data for UKPRN '10014936'
#    And there is no Organisation data for UKPRN '10014937'
#    And there is no Organisation data for UKPRN '10014938'
#    And there is no Organisation data for UKPRN '10014939'
#    And there is no Organisation data for UKPRN '10014940'
#    And there is no Organisation data for UKPRN '10014941'
#    And there is no Organisation data for UKPRN '10014942'
#    And there is no Organisation data for UKPRN '10014943'
#    And there is no Organisation data for UKPRN '10014944'
#    And there is no Organisation data for UKPRN '10014945'
#    And there is no Organisation data for UKPRN '10014946'
#    And there is no Organisation data for UKPRN '10014947'
#    And there is no Organisation data for UKPRN '10014948'
#    And there is no Organisation data for UKPRN '10014949'
#
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014800 Co Ltd' with UKPRN '10014800' and OrgId 'ORG0014800' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014801 Co Ltd' with UKPRN '10014801' and OrgId 'ORG0014801' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014802 Co Ltd' with UKPRN '10014802' and OrgId 'ORG0014802' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014803 Co Ltd' with UKPRN '10014803' and OrgId 'ORG0014803' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014804 Co Ltd' with UKPRN '10014804' and OrgId 'ORG0014804' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014805 Co Ltd' with UKPRN '10014805' and OrgId 'ORG0014805' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014806 Co Ltd' with UKPRN '10014806' and OrgId 'ORG0014806' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014807 Co Ltd' with UKPRN '10014807' and OrgId 'ORG0014807' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014808 Co Ltd' with UKPRN '10014808' and OrgId 'ORG0014808' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014809 Co Ltd' with UKPRN '10014809' and OrgId 'ORG0014809' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014810 Co Ltd' with UKPRN '10014810' and OrgId 'ORG0014810' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014811 Co Ltd' with UKPRN '10014811' and OrgId 'ORG0014811' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014812 Co Ltd' with UKPRN '10014812' and OrgId 'ORG0014812' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014813 Co Ltd' with UKPRN '10014813' and OrgId 'ORG0014813' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014814 Co Ltd' with UKPRN '10014814' and OrgId 'ORG0014814' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014815 Co Ltd' with UKPRN '10014815' and OrgId 'ORG0014815' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014816 Co Ltd' with UKPRN '10014816' and OrgId 'ORG0014816' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014817 Co Ltd' with UKPRN '10014817' and OrgId 'ORG0014817' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014818 Co Ltd' with UKPRN '10014818' and OrgId 'ORG0014818' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014819 Co Ltd' with UKPRN '10014819' and OrgId 'ORG0014819' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014820 Co Ltd' with UKPRN '10014820' and OrgId 'ORG0014820' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014821 Co Ltd' with UKPRN '10014821' and OrgId 'ORG0014821' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014822 Co Ltd' with UKPRN '10014822' and OrgId 'ORG0014822' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014823 Co Ltd' with UKPRN '10014823' and OrgId 'ORG0014823' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014824 Co Ltd' with UKPRN '10014824' and OrgId 'ORG0014824' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014825 Co Ltd' with UKPRN '10014825' and OrgId 'ORG0014825' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014826 Co Ltd' with UKPRN '10014826' and OrgId 'ORG0014826' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014827 Co Ltd' with UKPRN '10014827' and OrgId 'ORG0014827' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014828 Co Ltd' with UKPRN '10014828' and OrgId 'ORG0014828' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014829 Co Ltd' with UKPRN '10014829' and OrgId 'ORG0014829' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014830 Co Ltd' with UKPRN '10014830' and OrgId 'ORG0014830' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014831 Co Ltd' with UKPRN '10014831' and OrgId 'ORG0014831' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014832 Co Ltd' with UKPRN '10014832' and OrgId 'ORG0014832' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014833 Co Ltd' with UKPRN '10014833' and OrgId 'ORG0014833' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014834 Co Ltd' with UKPRN '10014834' and OrgId 'ORG0014834' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014835 Co Ltd' with UKPRN '10014835' and OrgId 'ORG0014835' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014836 Co Ltd' with UKPRN '10014836' and OrgId 'ORG0014836' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014837 Co Ltd' with UKPRN '10014837' and OrgId 'ORG0014837' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014838 Co Ltd' with UKPRN '10014838' and OrgId 'ORG0014838' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014839 Co Ltd' with UKPRN '10014839' and OrgId 'ORG0014839' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014840 Co Ltd' with UKPRN '10014840' and OrgId 'ORG0014840' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014841 Co Ltd' with UKPRN '10014841' and OrgId 'ORG0014841' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014842 Co Ltd' with UKPRN '10014842' and OrgId 'ORG0014842' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014843 Co Ltd' with UKPRN '10014843' and OrgId 'ORG0014843' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014844 Co Ltd' with UKPRN '10014844' and OrgId 'ORG0014844' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014845 Co Ltd' with UKPRN '10014845' and OrgId 'ORG0014845' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014846 Co Ltd' with UKPRN '10014846' and OrgId 'ORG0014846' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014847 Co Ltd' with UKPRN '10014847' and OrgId 'ORG0014847' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014848 Co Ltd' with UKPRN '10014848' and OrgId 'ORG0014848' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014849 Co Ltd' with UKPRN '10014849' and OrgId 'ORG0014849' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014850 Co Ltd' with UKPRN '10014850' and OrgId 'ORG0014850' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014851 Co Ltd' with UKPRN '10014851' and OrgId 'ORG0014851' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014852 Co Ltd' with UKPRN '10014852' and OrgId 'ORG0014852' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014853 Co Ltd' with UKPRN '10014853' and OrgId 'ORG0014853' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014854 Co Ltd' with UKPRN '10014854' and OrgId 'ORG0014854' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014855 Co Ltd' with UKPRN '10014855' and OrgId 'ORG0014855' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014856 Co Ltd' with UKPRN '10014856' and OrgId 'ORG0014856' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014857 Co Ltd' with UKPRN '10014857' and OrgId 'ORG0014857' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014858 Co Ltd' with UKPRN '10014858' and OrgId 'ORG0014858' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014859 Co Ltd' with UKPRN '10014859' and OrgId 'ORG0014859' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014860 Co Ltd' with UKPRN '10014860' and OrgId 'ORG0014860' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014861 Co Ltd' with UKPRN '10014861' and OrgId 'ORG0014861' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014862 Co Ltd' with UKPRN '10014862' and OrgId 'ORG0014862' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014863 Co Ltd' with UKPRN '10014863' and OrgId 'ORG0014863' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014864 Co Ltd' with UKPRN '10014864' and OrgId 'ORG0014864' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014865 Co Ltd' with UKPRN '10014865' and OrgId 'ORG0014865' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014866 Co Ltd' with UKPRN '10014866' and OrgId 'ORG0014866' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014867 Co Ltd' with UKPRN '10014867' and OrgId 'ORG0014867' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014868 Co Ltd' with UKPRN '10014868' and OrgId 'ORG0014868' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014869 Co Ltd' with UKPRN '10014869' and OrgId 'ORG0014869' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014870 Co Ltd' with UKPRN '10014870' and OrgId 'ORG0014870' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014871 Co Ltd' with UKPRN '10014871' and OrgId 'ORG0014871' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014872 Co Ltd' with UKPRN '10014872' and OrgId 'ORG0014872' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014873 Co Ltd' with UKPRN '10014873' and OrgId 'ORG0014873' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014874 Co Ltd' with UKPRN '10014874' and OrgId 'ORG0014874' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014875 Co Ltd' with UKPRN '10014875' and OrgId 'ORG0014875' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014876 Co Ltd' with UKPRN '10014876' and OrgId 'ORG0014876' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014877 Co Ltd' with UKPRN '10014877' and OrgId 'ORG0014877' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014878 Co Ltd' with UKPRN '10014878' and OrgId 'ORG0014878' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014879 Co Ltd' with UKPRN '10014879' and OrgId 'ORG0014879' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014880 Co Ltd' with UKPRN '10014880' and OrgId 'ORG0014880' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014881 Co Ltd' with UKPRN '10014881' and OrgId 'ORG0014881' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014882 Co Ltd' with UKPRN '10014882' and OrgId 'ORG0014882' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014883 Co Ltd' with UKPRN '10014883' and OrgId 'ORG0014883' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014884 Co Ltd' with UKPRN '10014884' and OrgId 'ORG0014884' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014885 Co Ltd' with UKPRN '10014885' and OrgId 'ORG0014885' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014886 Co Ltd' with UKPRN '10014886' and OrgId 'ORG0014886' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014887 Co Ltd' with UKPRN '10014887' and OrgId 'ORG0014887' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014888 Co Ltd' with UKPRN '10014888' and OrgId 'ORG0014888' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014889 Co Ltd' with UKPRN '10014889' and OrgId 'ORG0014889' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014890 Co Ltd' with UKPRN '10014890' and OrgId 'ORG0014890' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014891 Co Ltd' with UKPRN '10014891' and OrgId 'ORG0014891' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014892 Co Ltd' with UKPRN '10014892' and OrgId 'ORG0014892' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014893 Co Ltd' with UKPRN '10014893' and OrgId 'ORG0014893' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014894 Co Ltd' with UKPRN '10014894' and OrgId 'ORG0014894' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014895 Co Ltd' with UKPRN '10014895' and OrgId 'ORG0014895' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014896 Co Ltd' with UKPRN '10014896' and OrgId 'ORG0014896' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014897 Co Ltd' with UKPRN '10014897' and OrgId 'ORG0014897' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014898 Co Ltd' with UKPRN '10014898' and OrgId 'ORG0014898' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014899 Co Ltd' with UKPRN '10014899' and OrgId 'ORG0014899' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014900 Co Ltd' with UKPRN '10014900' and OrgId 'ORG0014900' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014901 Co Ltd' with UKPRN '10014901' and OrgId 'ORG0014901' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014902 Co Ltd' with UKPRN '10014902' and OrgId 'ORG0014902' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014903 Co Ltd' with UKPRN '10014903' and OrgId 'ORG0014903' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014904 Co Ltd' with UKPRN '10014904' and OrgId 'ORG0014904' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014905 Co Ltd' with UKPRN '10014905' and OrgId 'ORG0014905' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014906 Co Ltd' with UKPRN '10014906' and OrgId 'ORG0014906' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014907 Co Ltd' with UKPRN '10014907' and OrgId 'ORG0014907' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014908 Co Ltd' with UKPRN '10014908' and OrgId 'ORG0014908' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014909 Co Ltd' with UKPRN '10014909' and OrgId 'ORG0014909' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014910 Co Ltd' with UKPRN '10014910' and OrgId 'ORG0014910' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014911 Co Ltd' with UKPRN '10014911' and OrgId 'ORG0014911' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014912 Co Ltd' with UKPRN '10014912' and OrgId 'ORG0014912' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014913 Co Ltd' with UKPRN '10014913' and OrgId 'ORG0014913' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014914 Co Ltd' with UKPRN '10014914' and OrgId 'ORG0014914' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014915 Co Ltd' with UKPRN '10014915' and OrgId 'ORG0014915' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014916 Co Ltd' with UKPRN '10014916' and OrgId 'ORG0014916' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014917 Co Ltd' with UKPRN '10014917' and OrgId 'ORG0014917' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014918 Co Ltd' with UKPRN '10014918' and OrgId 'ORG0014918' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014919 Co Ltd' with UKPRN '10014919' and OrgId 'ORG0014919' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014920 Co Ltd' with UKPRN '10014920' and OrgId 'ORG0014920' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014921 Co Ltd' with UKPRN '10014921' and OrgId 'ORG0014921' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014922 Co Ltd' with UKPRN '10014922' and OrgId 'ORG0014922' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014923 Co Ltd' with UKPRN '10014923' and OrgId 'ORG0014923' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014924 Co Ltd' with UKPRN '10014924' and OrgId 'ORG0014924' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014925 Co Ltd' with UKPRN '10014925' and OrgId 'ORG0014925' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014926 Co Ltd' with UKPRN '10014926' and OrgId 'ORG0014926' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014927 Co Ltd' with UKPRN '10014927' and OrgId 'ORG0014927' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014928 Co Ltd' with UKPRN '10014928' and OrgId 'ORG0014928' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014929 Co Ltd' with UKPRN '10014929' and OrgId 'ORG0014929' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014930 Co Ltd' with UKPRN '10014930' and OrgId 'ORG0014930' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014931 Co Ltd' with UKPRN '10014931' and OrgId 'ORG0014931' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014932 Co Ltd' with UKPRN '10014932' and OrgId 'ORG0014932' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014933 Co Ltd' with UKPRN '10014933' and OrgId 'ORG0014933' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014934 Co Ltd' with UKPRN '10014934' and OrgId 'ORG0014934' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014935 Co Ltd' with UKPRN '10014935' and OrgId 'ORG0014935' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014936 Co Ltd' with UKPRN '10014936' and OrgId 'ORG0014936' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014937 Co Ltd' with UKPRN '10014937' and OrgId 'ORG0014937' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014938 Co Ltd' with UKPRN '10014938' and OrgId 'ORG0014938' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014939 Co Ltd' with UKPRN '10014939' and OrgId 'ORG0014939' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014940 Co Ltd' with UKPRN '10014940' and OrgId 'ORG0014940' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014941 Co Ltd' with UKPRN '10014941' and OrgId 'ORG0014941' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014942 Co Ltd' with UKPRN '10014942' and OrgId 'ORG0014942' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014943 Co Ltd' with UKPRN '10014943' and OrgId 'ORG0014943' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014944 Co Ltd' with UKPRN '10014944' and OrgId 'ORG0014944' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014945 Co Ltd' with UKPRN '10014945' and OrgId 'ORG0014945' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014946 Co Ltd' with UKPRN '10014946' and OrgId 'ORG0014946' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014947 Co Ltd' with UKPRN '10014947' and OrgId 'ORG0014947' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014948 Co Ltd' with UKPRN '10014948' and OrgId 'ORG0014948' and has 'FCS1 Test' as a manager 
#    And   caseload advisor 'FCS2 Test' is assigned to provider '10014949 Co Ltd' with UKPRN '10014949' and OrgId 'ORG0014949' and has 'FCS1 Test' as a manager 
#
#    #Put Provider data in the PaaS Organisation table (Organisation.Organisation)
#    And   the following Organisations exist in the FCT Organisation Service 
#    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#    | 10014800 | 114800 | 10014800 Co Ltd | 0              | Active                | Yes           | AA014800      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014801 | 114801 | 10014801 Co Ltd | 0              | Active                | Yes           | AA014801      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014802 | 114802 | 10014802 Co Ltd | 0              | Active                | Yes           | AA014802      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014803 | 114803 | 10014803 Co Ltd | 0              | Active                | Yes           | AA014803      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014804 | 114804 | 10014804 Co Ltd | 0              | Active                | Yes           | AA014804      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014805 | 114805 | 10014805 Co Ltd | 0              | Active                | Yes           | AA014805      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014806 | 114806 | 10014806 Co Ltd | 0              | Active                | Yes           | AA014806      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014807 | 114807 | 10014807 Co Ltd | 0              | Active                | Yes           | AA014807      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014808 | 114808 | 10014808 Co Ltd | 0              | Active                | Yes           | AA014808      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014809 | 114809 | 10014809 Co Ltd | 0              | Active                | Yes           | AA014809      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014810 | 114810 | 10014810 Co Ltd | 0              | Active                | Yes           | AA014810      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014811 | 114811 | 10014811 Co Ltd | 0              | Active                | Yes           | AA014811      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014812 | 114812 | 10014812 Co Ltd | 0              | Active                | Yes           | AA014812      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014813 | 114813 | 10014813 Co Ltd | 0              | Active                | Yes           | AA014813      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014814 | 114814 | 10014814 Co Ltd | 0              | Active                | Yes           | AA014814      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014815 | 114815 | 10014815 Co Ltd | 0              | Active                | Yes           | AA014815      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014816 | 114816 | 10014816 Co Ltd | 0              | Active                | Yes           | AA014816      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014817 | 114817 | 10014817 Co Ltd | 0              | Active                | Yes           | AA014817      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014818 | 114818 | 10014818 Co Ltd | 0              | Active                | Yes           | AA014818      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014819 | 114819 | 10014819 Co Ltd | 0              | Active                | Yes           | AA014819      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014820 | 114820 | 10014820 Co Ltd | 0              | Active                | Yes           | AA014820      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014821 | 114821 | 10014821 Co Ltd | 0              | Active                | Yes           | AA014821      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014822 | 114822 | 10014822 Co Ltd | 0              | Active                | Yes           | AA014822      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014823 | 114823 | 10014823 Co Ltd | 0              | Active                | Yes           | AA014823      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014824 | 114824 | 10014824 Co Ltd | 0              | Active                | Yes           | AA014824      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014825 | 114825 | 10014825 Co Ltd | 0              | Active                | Yes           | AA014825      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014826 | 114826 | 10014826 Co Ltd | 0              | Active                | Yes           | AA014826      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014827 | 114827 | 10014827 Co Ltd | 0              | Active                | Yes           | AA014827      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014828 | 114828 | 10014828 Co Ltd | 0              | Active                | Yes           | AA014828      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014829 | 114829 | 10014829 Co Ltd | 0              | Active                | Yes           | AA014829      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014830 | 114830 | 10014830 Co Ltd | 0              | Active                | Yes           | AA014830      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014831 | 114831 | 10014831 Co Ltd | 0              | Active                | Yes           | AA014831      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014832 | 114832 | 10014832 Co Ltd | 0              | Active                | Yes           | AA014832      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014833 | 114833 | 10014833 Co Ltd | 0              | Active                | Yes           | AA014833      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014834 | 114834 | 10014834 Co Ltd | 0              | Active                | Yes           | AA014834      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014835 | 114835 | 10014835 Co Ltd | 0              | Active                | Yes           | AA014835      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014836 | 114836 | 10014836 Co Ltd | 0              | Active                | Yes           | AA014836      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014837 | 114837 | 10014837 Co Ltd | 0              | Active                | Yes           | AA014837      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014838 | 114838 | 10014838 Co Ltd | 0              | Active                | Yes           | AA014838      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014839 | 114839 | 10014839 Co Ltd | 0              | Active                | Yes           | AA014839      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014840 | 114840 | 10014840 Co Ltd | 0              | Active                | Yes           | AA014840      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014841 | 114841 | 10014841 Co Ltd | 0              | Active                | Yes           | AA014841      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014842 | 114842 | 10014842 Co Ltd | 0              | Active                | Yes           | AA014842      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014843 | 114843 | 10014843 Co Ltd | 0              | Active                | Yes           | AA014843      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014844 | 114844 | 10014844 Co Ltd | 0              | Active                | Yes           | AA014844      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014845 | 114845 | 10014845 Co Ltd | 0              | Active                | Yes           | AA014845      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014846 | 114846 | 10014846 Co Ltd | 0              | Active                | Yes           | AA014846      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014847 | 114847 | 10014847 Co Ltd | 0              | Active                | Yes           | AA014847      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014848 | 114848 | 10014848 Co Ltd | 0              | Active                | Yes           | AA014848      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014849 | 114849 | 10014849 Co Ltd | 0              | Active                | Yes           | AA014849      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014850 | 114850 | 10014850 Co Ltd | 0              | Active                | Yes           | AA014850      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014851 | 114851 | 10014851 Co Ltd | 0              | Active                | Yes           | AA014851      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014852 | 114852 | 10014852 Co Ltd | 0              | Active                | Yes           | AA014852      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014853 | 114853 | 10014853 Co Ltd | 0              | Active                | Yes           | AA014853      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014854 | 114854 | 10014854 Co Ltd | 0              | Active                | Yes           | AA014854      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014855 | 114855 | 10014855 Co Ltd | 0              | Active                | Yes           | AA014855      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014856 | 114856 | 10014856 Co Ltd | 0              | Active                | Yes           | AA014856      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014857 | 114857 | 10014857 Co Ltd | 0              | Active                | Yes           | AA014857      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014858 | 114858 | 10014858 Co Ltd | 0              | Active                | Yes           | AA014858      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014859 | 114859 | 10014859 Co Ltd | 0              | Active                | Yes           | AA014859      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014860 | 114860 | 10014860 Co Ltd | 0              | Active                | Yes           | AA014860      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014861 | 114861 | 10014861 Co Ltd | 0              | Active                | Yes           | AA014861      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014862 | 114862 | 10014862 Co Ltd | 0              | Active                | Yes           | AA014862      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014863 | 114863 | 10014863 Co Ltd | 0              | Active                | Yes           | AA014863      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014864 | 114864 | 10014864 Co Ltd | 0              | Active                | Yes           | AA014864      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014865 | 114865 | 10014865 Co Ltd | 0              | Active                | Yes           | AA014865      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014866 | 114866 | 10014866 Co Ltd | 0              | Active                | Yes           | AA014866      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014867 | 114867 | 10014867 Co Ltd | 0              | Active                | Yes           | AA014867      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014868 | 114868 | 10014868 Co Ltd | 0              | Active                | Yes           | AA014868      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014869 | 114869 | 10014869 Co Ltd | 0              | Active                | Yes           | AA014869      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014870 | 114870 | 10014870 Co Ltd | 0              | Active                | Yes           | AA014870      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014871 | 114871 | 10014871 Co Ltd | 0              | Active                | Yes           | AA014871      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014872 | 114872 | 10014872 Co Ltd | 0              | Active                | Yes           | AA014872      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014873 | 114873 | 10014873 Co Ltd | 0              | Active                | Yes           | AA014873      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014874 | 114874 | 10014874 Co Ltd | 0              | Active                | Yes           | AA014874      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014875 | 114875 | 10014875 Co Ltd | 0              | Active                | Yes           | AA014875      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014876 | 114876 | 10014876 Co Ltd | 0              | Active                | Yes           | AA014876      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014877 | 114877 | 10014877 Co Ltd | 0              | Active                | Yes           | AA014877      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014878 | 114878 | 10014878 Co Ltd | 0              | Active                | Yes           | AA014878      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014879 | 114879 | 10014879 Co Ltd | 0              | Active                | Yes           | AA014879      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014880 | 114880 | 10014880 Co Ltd | 0              | Active                | Yes           | AA014880      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014881 | 114881 | 10014881 Co Ltd | 0              | Active                | Yes           | AA014881      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014882 | 114882 | 10014882 Co Ltd | 0              | Active                | Yes           | AA014882      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014883 | 114883 | 10014883 Co Ltd | 0              | Active                | Yes           | AA014883      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014884 | 114884 | 10014884 Co Ltd | 0              | Active                | Yes           | AA014884      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014885 | 114885 | 10014885 Co Ltd | 0              | Active                | Yes           | AA014885      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014886 | 114886 | 10014886 Co Ltd | 0              | Active                | Yes           | AA014886      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014887 | 114887 | 10014887 Co Ltd | 0              | Active                | Yes           | AA014887      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014888 | 114888 | 10014888 Co Ltd | 0              | Active                | Yes           | AA014888      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014889 | 114889 | 10014889 Co Ltd | 0              | Active                | Yes           | AA014889      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014890 | 114890 | 10014890 Co Ltd | 0              | Active                | Yes           | AA014890      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014891 | 114891 | 10014891 Co Ltd | 0              | Active                | Yes           | AA014891      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014892 | 114892 | 10014892 Co Ltd | 0              | Active                | Yes           | AA014892      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014893 | 114893 | 10014893 Co Ltd | 0              | Active                | Yes           | AA014893      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014894 | 114894 | 10014894 Co Ltd | 0              | Active                | Yes           | AA014894      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014895 | 114895 | 10014895 Co Ltd | 0              | Active                | Yes           | AA014895      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014896 | 114896 | 10014896 Co Ltd | 0              | Active                | Yes           | AA014896      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014897 | 114897 | 10014897 Co Ltd | 0              | Active                | Yes           | AA014897      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014898 | 114898 | 10014898 Co Ltd | 0              | Active                | Yes           | AA014898      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014899 | 114899 | 10014899 Co Ltd | 0              | Active                | Yes           | AA014899      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014900 | 114900 | 10014900 Co Ltd | 0              | Active                | Yes           | AA014900      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014901 | 114901 | 10014901 Co Ltd | 0              | Active                | Yes           | AA014901      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014902 | 114902 | 10014902 Co Ltd | 0              | Active                | Yes           | AA014902      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014903 | 114903 | 10014903 Co Ltd | 0              | Active                | Yes           | AA014903      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014904 | 114904 | 10014904 Co Ltd | 0              | Active                | Yes           | AA014904      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014905 | 114905 | 10014905 Co Ltd | 0              | Active                | Yes           | AA014905      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014906 | 114906 | 10014906 Co Ltd | 0              | Active                | Yes           | AA014906      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014907 | 114907 | 10014907 Co Ltd | 0              | Active                | Yes           | AA014907      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014908 | 114908 | 10014908 Co Ltd | 0              | Active                | Yes           | AA014908      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014909 | 114909 | 10014909 Co Ltd | 0              | Active                | Yes           | AA014909      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014910 | 114910 | 10014910 Co Ltd | 0              | Active                | Yes           | AA014910      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014911 | 114911 | 10014911 Co Ltd | 0              | Active                | Yes           | AA014911      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014912 | 114912 | 10014912 Co Ltd | 0              | Active                | Yes           | AA014912      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014913 | 114913 | 10014913 Co Ltd | 0              | Active                | Yes           | AA014913      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014914 | 114914 | 10014914 Co Ltd | 0              | Active                | Yes           | AA014914      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014915 | 114915 | 10014915 Co Ltd | 0              | Active                | Yes           | AA014915      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014916 | 114916 | 10014916 Co Ltd | 0              | Active                | Yes           | AA014916      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014917 | 114917 | 10014917 Co Ltd | 0              | Active                | Yes           | AA014917      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014918 | 114918 | 10014918 Co Ltd | 0              | Active                | Yes           | AA014918      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014919 | 114919 | 10014919 Co Ltd | 0              | Active                | Yes           | AA014919      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014920 | 114920 | 10014920 Co Ltd | 0              | Active                | Yes           | AA014920      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014921 | 114921 | 10014921 Co Ltd | 0              | Active                | Yes           | AA014921      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014922 | 114922 | 10014922 Co Ltd | 0              | Active                | Yes           | AA014922      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014923 | 114923 | 10014923 Co Ltd | 0              | Active                | Yes           | AA014923      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014924 | 114924 | 10014924 Co Ltd | 0              | Active                | Yes           | AA014924      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014925 | 114925 | 10014925 Co Ltd | 0              | Active                | Yes           | AA014925      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014926 | 114926 | 10014926 Co Ltd | 0              | Active                | Yes           | AA014926      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014927 | 114927 | 10014927 Co Ltd | 0              | Active                | Yes           | AA014927      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014928 | 114928 | 10014928 Co Ltd | 0              | Active                | Yes           | AA014928      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014929 | 114929 | 10014929 Co Ltd | 0              | Active                | Yes           | AA014929      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014930 | 114930 | 10014930 Co Ltd | 0              | Active                | Yes           | AA014930      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014931 | 114931 | 10014931 Co Ltd | 0              | Active                | Yes           | AA014931      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014932 | 114932 | 10014932 Co Ltd | 0              | Active                | Yes           | AA014932      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014933 | 114933 | 10014933 Co Ltd | 0              | Active                | Yes           | AA014933      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014934 | 114934 | 10014934 Co Ltd | 0              | Active                | Yes           | AA014934      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014935 | 114935 | 10014935 Co Ltd | 0              | Active                | Yes           | AA014935      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014936 | 114936 | 10014936 Co Ltd | 0              | Active                | Yes           | AA014936      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014937 | 114937 | 10014937 Co Ltd | 0              | Active                | Yes           | AA014937      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014938 | 114938 | 10014938 Co Ltd | 0              | Active                | Yes           | AA014938      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014939 | 114939 | 10014939 Co Ltd | 0              | Active                | Yes           | AA014939      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014940 | 114940 | 10014940 Co Ltd | 0              | Active                | Yes           | AA014940      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014941 | 114941 | 10014941 Co Ltd | 0              | Active                | Yes           | AA014941      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014942 | 114942 | 10014942 Co Ltd | 0              | Active                | Yes           | AA014942      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014943 | 114943 | 10014943 Co Ltd | 0              | Active                | Yes           | AA014943      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014944 | 114944 | 10014944 Co Ltd | 0              | Active                | Yes           | AA014944      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014945 | 114945 | 10014945 Co Ltd | 0              | Active                | Yes           | AA014945      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
#    | 10014946 | 114946 | 10014946 Co Ltd | 0              | Active                | Yes           | AA014946      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014947 | 114947 | 10014947 Co Ltd | 0              | Active                | Yes           | AA014947      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#    | 10014948 | 114948 | 10014948 Co Ltd | 0              | Active                | Yes           | AA014948      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
#    | 10014949 | 114949 | 10014949 Co Ltd | 0              | Active                | Yes           | AA014949      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
#
#     #Put the same Provider data in the CRM Organisation table 
#    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
#    | UKPRN    |
#    | 10014800 |
#    | 10014801 |
#    | 10014802 |
#    | 10014803 |
#    | 10014804 |
#    | 10014805 |
#    | 10014806 |
#    | 10014807 |
#    | 10014808 |
#    | 10014809 |
#    | 10014810 |
#    | 10014811 |
#    | 10014812 |
#    | 10014813 |
#    | 10014814 |
#    | 10014815 |
#    | 10014816 |
#    | 10014817 |
#    | 10014818 |
#    | 10014819 |
#    | 10014820 |
#    | 10014821 |
#    | 10014822 |
#    | 10014823 |
#    | 10014824 |
#    | 10014825 |
#    | 10014826 |
#    | 10014827 |
#    | 10014828 |
#    | 10014829 |
#    | 10014830 |
#    | 10014831 |
#    | 10014832 |
#    | 10014833 |
#    | 10014834 |
#    | 10014835 |
#    | 10014836 |
#    | 10014837 |
#    | 10014838 |
#    | 10014839 |
#    | 10014840 |
#    | 10014841 |
#    | 10014842 |
#    | 10014843 |
#    | 10014844 |
#    | 10014845 |
#    | 10014846 |
#    | 10014847 |
#    | 10014848 |
#    | 10014849 |
#    | 10014850 |
#    | 10014851 |
#    | 10014852 |
#    | 10014853 |
#    | 10014854 |
#    | 10014855 |
#    | 10014856 |
#    | 10014857 |
#    | 10014858 |
#    | 10014859 |
#    | 10014860 |
#    | 10014861 |
#    | 10014862 |
#    | 10014863 |
#    | 10014864 |
#    | 10014865 |
#    | 10014866 |
#    | 10014867 |
#    | 10014868 |
#    | 10014869 |
#    | 10014870 |
#    | 10014871 |
#    | 10014872 |
#    | 10014873 |
#    | 10014874 |
#    | 10014875 |
#    | 10014876 |
#    | 10014877 |
#    | 10014878 |
#    | 10014879 |
#    | 10014880 |
#    | 10014881 |
#    | 10014882 |
#    | 10014883 |
#    | 10014884 |
#    | 10014885 |
#    | 10014886 |
#    | 10014887 |
#    | 10014888 |
#    | 10014889 |
#    | 10014890 |
#    | 10014891 |
#    | 10014892 |
#    | 10014893 |
#    | 10014894 |
#    | 10014895 |
#    | 10014896 |
#    | 10014897 |
#    | 10014898 |
#    | 10014899 |
#    | 10014900 |
#    | 10014901 |
#    | 10014902 |
#    | 10014903 |
#    | 10014904 |
#    | 10014905 |
#    | 10014906 |
#    | 10014907 |
#    | 10014908 |
#    | 10014909 |
#    | 10014910 |
#    | 10014911 |
#    | 10014912 |
#    | 10014913 |
#    | 10014914 |
#    | 10014915 |
#    | 10014916 |
#    | 10014917 |
#    | 10014918 |
#    | 10014919 |
#    | 10014920 |
#    | 10014921 |
#    | 10014922 |
#    | 10014923 |
#    | 10014924 |
#    | 10014925 |
#    | 10014926 |
#    | 10014927 |
#    | 10014928 |
#    | 10014929 |
#    | 10014930 |
#    | 10014931 |
#    | 10014932 |
#    | 10014933 |
#    | 10014934 |
#    | 10014935 |
#    | 10014936 |
#    | 10014937 |
#    | 10014938 |
#    | 10014939 |
#    | 10014940 |
#    | 10014941 |
#    | 10014942 |
#    | 10014943 |
#    | 10014944 |
#    | 10014945 |
#    | 10014946 |
#    | 10014947 |
#    | 10014948 |
#    | 10014949 |
#

#       # Create contract 
#    And   the draft contract header details for the latest version of the contract are as follows 
#    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
#    | 10014804 | 10014804 Co Ltd      | ESFA-4804            | EDSK-4804      | 1                     | 01/08/2020        | 31/07/2021      | 17618.00      |                                       | Conditions of Funding (Grant) (NMSS)         | 2021   | New          | ORG0014804  |
#
#    And   the draft contract allocations details for the latest version of the contract are as follows
#    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
#    | 10014804 | EDSK-4804      | ALLF-4804     | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 17618.00        |                                         |            |                                                             | New          |             |
#
#    And   the draft contract deliverables details for the latest version of the contract are as follows
#    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
#    | 10014804 | EDSK-4804      | ALLF-4804     | 5               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                                 | New          |             | 
#
#    And   the contract exists in CRM
#    # Contract status is now at 'Awaiting Documentation'
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    And   the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | EDSK-4804      | 1                     | 0                        | 2020-06-01 09:12:35.000 |
#
    # Change the date 
    Given the override date is '05/06/2021'


 
    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014800 | 1619-AS-2021-Contract-Provider-10014800-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014801 | 1619-AS-2021-Contract-Provider-10014801-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014802 | 1619-AS-2021-Contract-Provider-10014802-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014803 | 1619-AS-2021-Contract-Provider-10014803-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014804 | 1619-AS-2021-Contract-Provider-10014804-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014805 | 1619-AS-2021-Contract-Provider-10014805-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014806 | 1619-AS-2021-Contract-Provider-10014806-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014807 | 1619-AS-2021-Contract-Provider-10014807-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014808 | 1619-AS-2021-Contract-Provider-10014808-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014809 | 1619-AS-2021-Contract-Provider-10014809-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014810 | 1619-AS-2021-Contract-Provider-10014810-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014811 | 1619-AS-2021-Contract-Provider-10014811-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014812 | 1619-AS-2021-Contract-Provider-10014812-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014813 | 1619-AS-2021-Contract-Provider-10014813-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014814 | 1619-AS-2021-Contract-Provider-10014814-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014815 | 1619-AS-2021-Contract-Provider-10014815-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014816 | 1619-AS-2021-Contract-Provider-10014816-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014817 | 1619-AS-2021-Contract-Provider-10014817-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014818 | 1619-AS-2021-Contract-Provider-10014818-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014819 | 1619-AS-2021-Contract-Provider-10014819-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014820 | 1619-AS-2021-Contract-Provider-10014820-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014821 | 1619-AS-2021-Contract-Provider-10014821-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014822 | 1619-AS-2021-Contract-Provider-10014822-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014823 | 1619-AS-2021-Contract-Provider-10014823-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014824 | 1619-AS-2021-Contract-Provider-10014824-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014825 | 1619-AS-2021-Contract-Provider-10014825-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014826 | 1619-AS-2021-Contract-Provider-10014826-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014827 | 1619-AS-2021-Contract-Provider-10014827-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014828 | 1619-AS-2021-Contract-Provider-10014828-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014829 | 1619-AS-2021-Contract-Provider-10014829-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014830 | 1619-AS-2021-Contract-Provider-10014830-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014831 | 1619-AS-2021-Contract-Provider-10014831-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014832 | 1619-AS-2021-Contract-Provider-10014832-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014833 | 1619-AS-2021-Contract-Provider-10014833-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014834 | 1619-AS-2021-Contract-Provider-10014834-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014835 | 1619-AS-2021-Contract-Provider-10014835-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014836 | 1619-AS-2021-Contract-Provider-10014836-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014837 | 1619-AS-2021-Contract-Provider-10014837-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014838 | 1619-AS-2021-Contract-Provider-10014838-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014839 | 1619-AS-2021-Contract-Provider-10014839-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014840 | 1619-AS-2021-Contract-Provider-10014840-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014841 | 1619-AS-2021-Contract-Provider-10014841-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014842 | 1619-AS-2021-Contract-Provider-10014842-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014843 | 1619-AS-2021-Contract-Provider-10014843-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014844 | 1619-AS-2021-Contract-Provider-10014844-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014845 | 1619-AS-2021-Contract-Provider-10014845-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014846 | 1619-AS-2021-Contract-Provider-10014846-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014847 | 1619-AS-2021-Contract-Provider-10014847-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014848 | 1619-AS-2021-Contract-Provider-10014848-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014849 | 1619-AS-2021-Contract-Provider-10014849-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014850 | 1619-AS-2021-Contract-Provider-10014850-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014851 | 1619-AS-2021-Contract-Provider-10014851-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014852 | 1619-AS-2021-Contract-Provider-10014852-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014853 | 1619-AS-2021-Contract-Provider-10014853-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014854 | 1619-AS-2021-Contract-Provider-10014854-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014855 | 1619-AS-2021-Contract-Provider-10014855-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014856 | 1619-AS-2021-Contract-Provider-10014856-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014857 | 1619-AS-2021-Contract-Provider-10014857-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014858 | 1619-AS-2021-Contract-Provider-10014858-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014859 | 1619-AS-2021-Contract-Provider-10014859-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014860 | 1619-AS-2021-Contract-Provider-10014860-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014861 | 1619-AS-2021-Contract-Provider-10014861-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014862 | 1619-AS-2021-Contract-Provider-10014862-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014863 | 1619-AS-2021-Contract-Provider-10014863-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014864 | 1619-AS-2021-Contract-Provider-10014864-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014865 | 1619-AS-2021-Contract-Provider-10014865-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014866 | 1619-AS-2021-Contract-Provider-10014866-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014867 | 1619-AS-2021-Contract-Provider-10014867-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014868 | 1619-AS-2021-Contract-Provider-10014868-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014869 | 1619-AS-2021-Contract-Provider-10014869-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014870 | 1619-AS-2021-Contract-Provider-10014870-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014871 | 1619-AS-2021-Contract-Provider-10014871-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014872 | 1619-AS-2021-Contract-Provider-10014872-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014873 | 1619-AS-2021-Contract-Provider-10014873-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014874 | 1619-AS-2021-Contract-Provider-10014874-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014875 | 1619-AS-2021-Contract-Provider-10014875-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014876 | 1619-AS-2021-Contract-Provider-10014876-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014877 | 1619-AS-2021-Contract-Provider-10014877-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014878 | 1619-AS-2021-Contract-Provider-10014878-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014879 | 1619-AS-2021-Contract-Provider-10014879-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014880 | 1619-AS-2021-Contract-Provider-10014880-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014881 | 1619-AS-2021-Contract-Provider-10014881-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014882 | 1619-AS-2021-Contract-Provider-10014882-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014883 | 1619-AS-2021-Contract-Provider-10014883-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014884 | 1619-AS-2021-Contract-Provider-10014884-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014885 | 1619-AS-2021-Contract-Provider-10014885-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014886 | 1619-AS-2021-Contract-Provider-10014886-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014887 | 1619-AS-2021-Contract-Provider-10014887-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014888 | 1619-AS-2021-Contract-Provider-10014888-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014889 | 1619-AS-2021-Contract-Provider-10014889-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014890 | 1619-AS-2021-Contract-Provider-10014890-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014891 | 1619-AS-2021-Contract-Provider-10014891-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014892 | 1619-AS-2021-Contract-Provider-10014892-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014893 | 1619-AS-2021-Contract-Provider-10014893-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014894 | 1619-AS-2021-Contract-Provider-10014894-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014895 | 1619-AS-2021-Contract-Provider-10014895-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014896 | 1619-AS-2021-Contract-Provider-10014896-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014897 | 1619-AS-2021-Contract-Provider-10014897-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014898 | 1619-AS-2021-Contract-Provider-10014898-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014899 | 1619-AS-2021-Contract-Provider-10014899-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014900 | 1619-AS-2021-Contract-Provider-10014900-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014901 | 1619-AS-2021-Contract-Provider-10014901-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014902 | 1619-AS-2021-Contract-Provider-10014902-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014903 | 1619-AS-2021-Contract-Provider-10014903-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014904 | 1619-AS-2021-Contract-Provider-10014904-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014905 | 1619-AS-2021-Contract-Provider-10014905-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014906 | 1619-AS-2021-Contract-Provider-10014906-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014907 | 1619-AS-2021-Contract-Provider-10014907-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014908 | 1619-AS-2021-Contract-Provider-10014908-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014909 | 1619-AS-2021-Contract-Provider-10014909-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014910 | 1619-AS-2021-Contract-Provider-10014910-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014911 | 1619-AS-2021-Contract-Provider-10014911-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014912 | 1619-AS-2021-Contract-Provider-10014912-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014913 | 1619-AS-2021-Contract-Provider-10014913-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014914 | 1619-AS-2021-Contract-Provider-10014914-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014915 | 1619-AS-2021-Contract-Provider-10014915-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014916 | 1619-AS-2021-Contract-Provider-10014916-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014917 | 1619-AS-2021-Contract-Provider-10014917-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014918 | 1619-AS-2021-Contract-Provider-10014918-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014919 | 1619-AS-2021-Contract-Provider-10014919-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014920 | 1619-AS-2021-Contract-Provider-10014920-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014921 | 1619-AS-2021-Contract-Provider-10014921-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014922 | 1619-AS-2021-Contract-Provider-10014922-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014923 | 1619-AS-2021-Contract-Provider-10014923-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014924 | 1619-AS-2021-Contract-Provider-10014924-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014925 | 1619-AS-2021-Contract-Provider-10014925-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014926 | 1619-AS-2021-Contract-Provider-10014926-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014927 | 1619-AS-2021-Contract-Provider-10014927-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014928 | 1619-AS-2021-Contract-Provider-10014928-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014929 | 1619-AS-2021-Contract-Provider-10014929-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014930 | 1619-AS-2021-Contract-Provider-10014930-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014931 | 1619-AS-2021-Contract-Provider-10014931-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014932 | 1619-AS-2021-Contract-Provider-10014932-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014933 | 1619-AS-2021-Contract-Provider-10014933-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014934 | 1619-AS-2021-Contract-Provider-10014934-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014935 | 1619-AS-2021-Contract-Provider-10014935-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014936 | 1619-AS-2021-Contract-Provider-10014936-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014937 | 1619-AS-2021-Contract-Provider-10014937-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014938 | 1619-AS-2021-Contract-Provider-10014938-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014939 | 1619-AS-2021-Contract-Provider-10014939-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014940 | 1619-AS-2021-Contract-Provider-10014940-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014941 | 1619-AS-2021-Contract-Provider-10014941-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014942 | 1619-AS-2021-Contract-Provider-10014942-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014943 | 1619-AS-2021-Contract-Provider-10014943-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014944 | 1619-AS-2021-Contract-Provider-10014944-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014945 | 1619-AS-2021-Contract-Provider-10014945-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014946 | 1619-AS-2021-Contract-Provider-10014946-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014947 | 1619-AS-2021-Contract-Provider-10014947-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014948 | 1619-AS-2021-Contract-Provider-10014948-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014949 | 1619-AS-2021-Contract-Provider-10014949-2_1           | 2_1            | 1619                        | AS-2021            | 1000.00           |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014800-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014800-2_1           | 10014800      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014801-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014801-2_1           | 10014801      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014802-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014802-2_1           | 10014802      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014803-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014803-2_1           | 10014803      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014804-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014804-2_1           | 10014804      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014805-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014805-2_1           | 10014805      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014806-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014806-2_1           | 10014806      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014807-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014807-2_1           | 10014807      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014808-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014808-2_1           | 10014808      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014809-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014809-2_1           | 10014809      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014810-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014810-2_1           | 10014810      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014811-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014811-2_1           | 10014811      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014812-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014812-2_1           | 10014812      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014813-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014813-2_1           | 10014813      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014814-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014814-2_1           | 10014814      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014815-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014815-2_1           | 10014815      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014816-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014816-2_1           | 10014816      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014817-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014817-2_1           | 10014817      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014818-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014818-2_1           | 10014818      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014819-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014819-2_1           | 10014819      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014820-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014820-2_1           | 10014820      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014821-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014821-2_1           | 10014821      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014822-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014822-2_1           | 10014822      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014823-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014823-2_1           | 10014823      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014824-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014824-2_1           | 10014824      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014825-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014825-2_1           | 10014825      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014826-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014826-2_1           | 10014826      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014827-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014827-2_1           | 10014827      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014828-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014828-2_1           | 10014828      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014829-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014829-2_1           | 10014829      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014830-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014830-2_1           | 10014830      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014831-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014831-2_1           | 10014831      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014832-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014832-2_1           | 10014832      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014833-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014833-2_1           | 10014833      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014834-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014834-2_1           | 10014834      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014835-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014835-2_1           | 10014835      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014836-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014836-2_1           | 10014836      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014837-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014837-2_1           | 10014837      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014838-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014838-2_1           | 10014838      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014839-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014839-2_1           | 10014839      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014840-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014840-2_1           | 10014840      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014841-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014841-2_1           | 10014841      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014842-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014842-2_1           | 10014842      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014843-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014843-2_1           | 10014843      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014844-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014844-2_1           | 10014844      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014845-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014845-2_1           | 10014845      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014846-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014846-2_1           | 10014846      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014847-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014847-2_1           | 10014847      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014848-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014848-2_1           | 10014848      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014849-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014849-2_1           | 10014849      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014850-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014850-2_1           | 10014850      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014851-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014851-2_1           | 10014851      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014852-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014852-2_1           | 10014852      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014853-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014853-2_1           | 10014853      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014854-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014854-2_1           | 10014854      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014855-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014855-2_1           | 10014855      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014856-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014856-2_1           | 10014856      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014857-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014857-2_1           | 10014857      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014858-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014858-2_1           | 10014858      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014859-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014859-2_1           | 10014859      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014860-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014860-2_1           | 10014860      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014861-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014861-2_1           | 10014861      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014862-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014862-2_1           | 10014862      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014863-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014863-2_1           | 10014863      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014864-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014864-2_1           | 10014864      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014865-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014865-2_1           | 10014865      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014866-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014866-2_1           | 10014866      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014867-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014867-2_1           | 10014867      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014868-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014868-2_1           | 10014868      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014869-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014869-2_1           | 10014869      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014870-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014870-2_1           | 10014870      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014871-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014871-2_1           | 10014871      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014872-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014872-2_1           | 10014872      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014873-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014873-2_1           | 10014873      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014874-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014874-2_1           | 10014874      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014875-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014875-2_1           | 10014875      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014876-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014876-2_1           | 10014876      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014877-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014877-2_1           | 10014877      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014878-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014878-2_1           | 10014878      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014879-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014879-2_1           | 10014879      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014880-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014880-2_1           | 10014880      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014881-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014881-2_1           | 10014881      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014882-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014882-2_1           | 10014882      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014883-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014883-2_1           | 10014883      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014884-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014884-2_1           | 10014884      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014885-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014885-2_1           | 10014885      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014886-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014886-2_1           | 10014886      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014887-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014887-2_1           | 10014887      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014888-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014888-2_1           | 10014888      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014889-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014889-2_1           | 10014889      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014890-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014890-2_1           | 10014890      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014891-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014891-2_1           | 10014891      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014892-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014892-2_1           | 10014892      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014893-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014893-2_1           | 10014893      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014894-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014894-2_1           | 10014894      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014895-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014895-2_1           | 10014895      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014896-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014896-2_1           | 10014896      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014897-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014897-2_1           | 10014897      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014898-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014898-2_1           | 10014898      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014899-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014899-2_1           | 10014899      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014900-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014900-2_1           | 10014900      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014901-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014901-2_1           | 10014901      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014902-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014902-2_1           | 10014902      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014903-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014903-2_1           | 10014903      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014904-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014904-2_1           | 10014904      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014905-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014905-2_1           | 10014905      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014906-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014906-2_1           | 10014906      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014907-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014907-2_1           | 10014907      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014908-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014908-2_1           | 10014908      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014909-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014909-2_1           | 10014909      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014910-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014910-2_1           | 10014910      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014911-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014911-2_1           | 10014911      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014912-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014912-2_1           | 10014912      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014913-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014913-2_1           | 10014913      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014914-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014914-2_1           | 10014914      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014915-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014915-2_1           | 10014915      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014916-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014916-2_1           | 10014916      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014917-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014917-2_1           | 10014917      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014918-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014918-2_1           | 10014918      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014919-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014919-2_1           | 10014919      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014920-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014920-2_1           | 10014920      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014921-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014921-2_1           | 10014921      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014922-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014922-2_1           | 10014922      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014923-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014923-2_1           | 10014923      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014924-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014924-2_1           | 10014924      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014925-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014925-2_1           | 10014925      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014926-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014926-2_1           | 10014926      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014927-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014927-2_1           | 10014927      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014928-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014928-2_1           | 10014928      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014929-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014929-2_1           | 10014929      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014930-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014930-2_1           | 10014930      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014931-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014931-2_1           | 10014931      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014932-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014932-2_1           | 10014932      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014933-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014933-2_1           | 10014933      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014934-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014934-2_1           | 10014934      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014935-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014935-2_1           | 10014935      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014936-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014936-2_1           | 10014936      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014937-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014937-2_1           | 10014937      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014938-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014938-2_1           | 10014938      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014939-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014939-2_1           | 10014939      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014940-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014940-2_1           | 10014940      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014941-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014941-2_1           | 10014941      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014942-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014942-2_1           | 10014942      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014943-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014943-2_1           | 10014943      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014944-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014944-2_1           | 10014944      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014945-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014945-2_1           | 10014945      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014946-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014946-2_1           | 10014946      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014947-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014947-2_1           | 10014947      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014948-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014948-2_1           | 10014948      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014949-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014949-2_1           | 10014949      | Furth        | 18ISP           | 1000.00                   |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014800-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014801-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014802-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014803-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014804-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014805-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014806-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014807-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014808-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014809-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014810-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014811-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014812-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014813-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014814-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014815-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014816-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014817-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014818-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014819-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014820-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014821-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014822-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014823-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014824-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014825-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014826-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014827-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014828-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014829-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014830-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014831-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014832-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014833-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014834-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014835-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014836-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014837-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014838-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014839-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014840-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014841-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014842-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014843-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014844-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014845-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014846-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014847-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014848-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014849-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014850-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014851-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014852-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014853-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014854-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014855-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014856-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014857-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014858-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014859-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014860-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014861-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014862-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014863-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014864-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014865-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014866-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014867-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014868-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014869-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014870-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014871-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014872-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014873-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014874-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014875-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014876-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014877-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014878-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014879-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014880-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014881-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014882-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014883-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014884-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014885-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014886-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014887-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014888-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014889-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014890-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014891-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014892-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014893-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014894-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014895-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014896-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014897-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014898-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014899-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014900-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014901-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014902-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014903-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014904-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014905-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014906-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014907-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014908-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014909-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014910-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014911-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014912-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014913-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014914-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014915-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014916-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014917-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014918-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014919-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014920-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014921-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014922-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014923-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014924-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014925-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014926-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014927-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014928-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014929-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014930-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014931-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014932-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014933-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014934-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014935-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014936-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014937-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014938-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014939-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014940-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014941-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014942-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014943-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014944-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014945-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014946-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014947-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014948-2_1  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014949-2_1  | 1619-001        | 1000.00          | Payment         |


    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014800-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014801-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014802-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014803-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014804-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014805-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014806-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014807-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014808-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014809-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014810-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014811-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014812-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014813-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014814-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014815-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014816-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014817-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014818-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014819-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014820-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014821-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014822-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014823-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014824-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014825-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014826-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014827-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014828-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014829-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014830-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014831-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014832-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014833-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014834-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014835-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014836-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014837-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014838-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014839-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014840-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014841-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014842-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014843-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014844-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014845-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014846-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014847-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014848-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014849-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014850-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014851-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014852-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014853-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014854-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014855-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014856-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014857-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014858-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014859-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014860-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014861-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014862-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014863-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014864-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014865-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014866-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014867-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014868-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014869-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014870-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014871-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014872-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014873-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014874-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014875-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014876-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014877-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014878-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014879-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014880-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014881-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014882-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014883-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014884-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014885-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014886-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014887-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014888-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014889-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014890-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014891-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014892-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014893-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014894-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014895-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014896-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014897-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014898-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014899-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014900-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014901-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014902-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014903-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014904-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014905-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014906-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014907-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014908-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014909-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014910-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014911-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014912-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014913-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014914-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014915-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014916-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014917-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014918-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014919-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014920-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014921-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014922-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014923-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014924-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014925-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014926-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014927-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014928-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014929-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014930-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014931-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014932-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014933-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014934-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014935-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014936-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014937-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014938-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014939-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014940-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014941-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014942-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014943-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014944-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014945-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014946-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014947-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014948-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014949-2_1  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |


    # Change the date
    Given the override date is '07/06/2020'

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
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)        |

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
    #| Furth           | 18ISP             | SPI              | 
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
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021 | 33              | 



    # Change the date 
    Given the override date is '08/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    Then wait '200' seconds
#
#    #Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)      | CoFG_SPI                   |
#
#     #Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_SPI]         |
#    
#    # #Check the state of a Release Group (J129)  (The count and value are unchanged)
#    #Then  Release Group '[CoFG_SPI]' has the following characteristics
#    #| ReleaseStatus     | AllocationCount | AllocationValue |
#    #| Released          | 150               | 150000.00         |
#
#    Then wait '300' seconds
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014816' for FundingType 'EDSK' and period '2021'
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
#
#    When  I retrieve the latest contract details from CRM for provider '10014916' for FundingType 'EDSK' and period '2021'
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

        # Change the date 
    Given the override date is '09/06/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables

 
    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014800 | 1619-AS-2021-Contract-Provider-10014800-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014801 | 1619-AS-2021-Contract-Provider-10014801-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014802 | 1619-AS-2021-Contract-Provider-10014802-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014803 | 1619-AS-2021-Contract-Provider-10014803-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014804 | 1619-AS-2021-Contract-Provider-10014804-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014805 | 1619-AS-2021-Contract-Provider-10014805-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014806 | 1619-AS-2021-Contract-Provider-10014806-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014807 | 1619-AS-2021-Contract-Provider-10014807-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014808 | 1619-AS-2021-Contract-Provider-10014808-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014809 | 1619-AS-2021-Contract-Provider-10014809-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014810 | 1619-AS-2021-Contract-Provider-10014810-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014811 | 1619-AS-2021-Contract-Provider-10014811-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014812 | 1619-AS-2021-Contract-Provider-10014812-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014813 | 1619-AS-2021-Contract-Provider-10014813-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014814 | 1619-AS-2021-Contract-Provider-10014814-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014815 | 1619-AS-2021-Contract-Provider-10014815-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014816 | 1619-AS-2021-Contract-Provider-10014816-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014817 | 1619-AS-2021-Contract-Provider-10014817-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014818 | 1619-AS-2021-Contract-Provider-10014818-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014819 | 1619-AS-2021-Contract-Provider-10014819-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014820 | 1619-AS-2021-Contract-Provider-10014820-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014821 | 1619-AS-2021-Contract-Provider-10014821-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014822 | 1619-AS-2021-Contract-Provider-10014822-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014823 | 1619-AS-2021-Contract-Provider-10014823-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014824 | 1619-AS-2021-Contract-Provider-10014824-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014825 | 1619-AS-2021-Contract-Provider-10014825-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014826 | 1619-AS-2021-Contract-Provider-10014826-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014827 | 1619-AS-2021-Contract-Provider-10014827-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014828 | 1619-AS-2021-Contract-Provider-10014828-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014829 | 1619-AS-2021-Contract-Provider-10014829-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014830 | 1619-AS-2021-Contract-Provider-10014830-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014831 | 1619-AS-2021-Contract-Provider-10014831-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014832 | 1619-AS-2021-Contract-Provider-10014832-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014833 | 1619-AS-2021-Contract-Provider-10014833-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014834 | 1619-AS-2021-Contract-Provider-10014834-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014835 | 1619-AS-2021-Contract-Provider-10014835-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014836 | 1619-AS-2021-Contract-Provider-10014836-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014837 | 1619-AS-2021-Contract-Provider-10014837-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014838 | 1619-AS-2021-Contract-Provider-10014838-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014839 | 1619-AS-2021-Contract-Provider-10014839-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014840 | 1619-AS-2021-Contract-Provider-10014840-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014841 | 1619-AS-2021-Contract-Provider-10014841-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014842 | 1619-AS-2021-Contract-Provider-10014842-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014843 | 1619-AS-2021-Contract-Provider-10014843-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014844 | 1619-AS-2021-Contract-Provider-10014844-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014845 | 1619-AS-2021-Contract-Provider-10014845-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014846 | 1619-AS-2021-Contract-Provider-10014846-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014847 | 1619-AS-2021-Contract-Provider-10014847-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014848 | 1619-AS-2021-Contract-Provider-10014848-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014849 | 1619-AS-2021-Contract-Provider-10014849-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014850 | 1619-AS-2021-Contract-Provider-10014850-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014851 | 1619-AS-2021-Contract-Provider-10014851-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014852 | 1619-AS-2021-Contract-Provider-10014852-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014853 | 1619-AS-2021-Contract-Provider-10014853-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014854 | 1619-AS-2021-Contract-Provider-10014854-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014855 | 1619-AS-2021-Contract-Provider-10014855-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014856 | 1619-AS-2021-Contract-Provider-10014856-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014857 | 1619-AS-2021-Contract-Provider-10014857-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014858 | 1619-AS-2021-Contract-Provider-10014858-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014859 | 1619-AS-2021-Contract-Provider-10014859-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014860 | 1619-AS-2021-Contract-Provider-10014860-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014861 | 1619-AS-2021-Contract-Provider-10014861-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014862 | 1619-AS-2021-Contract-Provider-10014862-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014863 | 1619-AS-2021-Contract-Provider-10014863-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014864 | 1619-AS-2021-Contract-Provider-10014864-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014865 | 1619-AS-2021-Contract-Provider-10014865-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014866 | 1619-AS-2021-Contract-Provider-10014866-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014867 | 1619-AS-2021-Contract-Provider-10014867-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014868 | 1619-AS-2021-Contract-Provider-10014868-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014869 | 1619-AS-2021-Contract-Provider-10014869-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014870 | 1619-AS-2021-Contract-Provider-10014870-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014871 | 1619-AS-2021-Contract-Provider-10014871-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014872 | 1619-AS-2021-Contract-Provider-10014872-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014873 | 1619-AS-2021-Contract-Provider-10014873-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014874 | 1619-AS-2021-Contract-Provider-10014874-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014875 | 1619-AS-2021-Contract-Provider-10014875-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014876 | 1619-AS-2021-Contract-Provider-10014876-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014877 | 1619-AS-2021-Contract-Provider-10014877-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014878 | 1619-AS-2021-Contract-Provider-10014878-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014879 | 1619-AS-2021-Contract-Provider-10014879-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014880 | 1619-AS-2021-Contract-Provider-10014880-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014881 | 1619-AS-2021-Contract-Provider-10014881-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014882 | 1619-AS-2021-Contract-Provider-10014882-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014883 | 1619-AS-2021-Contract-Provider-10014883-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014884 | 1619-AS-2021-Contract-Provider-10014884-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014885 | 1619-AS-2021-Contract-Provider-10014885-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014886 | 1619-AS-2021-Contract-Provider-10014886-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014887 | 1619-AS-2021-Contract-Provider-10014887-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014888 | 1619-AS-2021-Contract-Provider-10014888-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014889 | 1619-AS-2021-Contract-Provider-10014889-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014890 | 1619-AS-2021-Contract-Provider-10014890-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014891 | 1619-AS-2021-Contract-Provider-10014891-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014892 | 1619-AS-2021-Contract-Provider-10014892-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014893 | 1619-AS-2021-Contract-Provider-10014893-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014894 | 1619-AS-2021-Contract-Provider-10014894-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014895 | 1619-AS-2021-Contract-Provider-10014895-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014896 | 1619-AS-2021-Contract-Provider-10014896-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014897 | 1619-AS-2021-Contract-Provider-10014897-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014898 | 1619-AS-2021-Contract-Provider-10014898-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014899 | 1619-AS-2021-Contract-Provider-10014899-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014900 | 1619-AS-2021-Contract-Provider-10014900-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014901 | 1619-AS-2021-Contract-Provider-10014901-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014902 | 1619-AS-2021-Contract-Provider-10014902-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014903 | 1619-AS-2021-Contract-Provider-10014903-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014904 | 1619-AS-2021-Contract-Provider-10014904-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014905 | 1619-AS-2021-Contract-Provider-10014905-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014906 | 1619-AS-2021-Contract-Provider-10014906-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014907 | 1619-AS-2021-Contract-Provider-10014907-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014908 | 1619-AS-2021-Contract-Provider-10014908-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014909 | 1619-AS-2021-Contract-Provider-10014909-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014910 | 1619-AS-2021-Contract-Provider-10014910-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014911 | 1619-AS-2021-Contract-Provider-10014911-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014912 | 1619-AS-2021-Contract-Provider-10014912-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014913 | 1619-AS-2021-Contract-Provider-10014913-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014914 | 1619-AS-2021-Contract-Provider-10014914-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014915 | 1619-AS-2021-Contract-Provider-10014915-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014916 | 1619-AS-2021-Contract-Provider-10014916-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014917 | 1619-AS-2021-Contract-Provider-10014917-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014918 | 1619-AS-2021-Contract-Provider-10014918-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014919 | 1619-AS-2021-Contract-Provider-10014919-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014920 | 1619-AS-2021-Contract-Provider-10014920-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014921 | 1619-AS-2021-Contract-Provider-10014921-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014922 | 1619-AS-2021-Contract-Provider-10014922-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014923 | 1619-AS-2021-Contract-Provider-10014923-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014924 | 1619-AS-2021-Contract-Provider-10014924-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014925 | 1619-AS-2021-Contract-Provider-10014925-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014926 | 1619-AS-2021-Contract-Provider-10014926-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014927 | 1619-AS-2021-Contract-Provider-10014927-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014928 | 1619-AS-2021-Contract-Provider-10014928-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014929 | 1619-AS-2021-Contract-Provider-10014929-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014930 | 1619-AS-2021-Contract-Provider-10014930-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014931 | 1619-AS-2021-Contract-Provider-10014931-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014932 | 1619-AS-2021-Contract-Provider-10014932-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014933 | 1619-AS-2021-Contract-Provider-10014933-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014934 | 1619-AS-2021-Contract-Provider-10014934-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014935 | 1619-AS-2021-Contract-Provider-10014935-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014936 | 1619-AS-2021-Contract-Provider-10014936-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014937 | 1619-AS-2021-Contract-Provider-10014937-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014938 | 1619-AS-2021-Contract-Provider-10014938-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014939 | 1619-AS-2021-Contract-Provider-10014939-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014940 | 1619-AS-2021-Contract-Provider-10014940-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014941 | 1619-AS-2021-Contract-Provider-10014941-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014942 | 1619-AS-2021-Contract-Provider-10014942-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014943 | 1619-AS-2021-Contract-Provider-10014943-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
#    | Contracting    | 10014944 | 1619-AS-2021-Contract-Provider-10014944-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014945 | 1619-AS-2021-Contract-Provider-10014945-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014946 | 1619-AS-2021-Contract-Provider-10014946-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014947 | 1619-AS-2021-Contract-Provider-10014947-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014948 | 1619-AS-2021-Contract-Provider-10014948-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |
    | Contracting    | 10014949 | 1619-AS-2021-Contract-Provider-10014949-3_3           | 3_3            | 1619                        | AS-2021            | 1000.00           |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014800-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014800-3_3           | 10014800      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014801-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014801-3_3           | 10014801      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014802-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014802-3_3           | 10014802      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014803-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014803-3_3           | 10014803      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014804-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014804-3_3           | 10014804      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014805-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014805-3_3           | 10014805      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014806-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014806-3_3           | 10014806      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014807-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014807-3_3           | 10014807      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014808-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014808-3_3           | 10014808      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014809-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014809-3_3           | 10014809      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014810-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014810-3_3           | 10014810      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014811-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014811-3_3           | 10014811      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014812-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014812-3_3           | 10014812      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014813-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014813-3_3           | 10014813      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014814-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014814-3_3           | 10014814      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014815-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014815-3_3           | 10014815      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014816-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014816-3_3           | 10014816      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014817-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014817-3_3           | 10014817      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014818-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014818-3_3           | 10014818      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014819-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014819-3_3           | 10014819      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014820-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014820-3_3           | 10014820      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014821-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014821-3_3           | 10014821      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014822-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014822-3_3           | 10014822      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014823-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014823-3_3           | 10014823      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014824-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014824-3_3           | 10014824      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014825-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014825-3_3           | 10014825      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014826-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014826-3_3           | 10014826      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014827-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014827-3_3           | 10014827      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014828-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014828-3_3           | 10014828      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014829-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014829-3_3           | 10014829      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014830-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014830-3_3           | 10014830      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014831-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014831-3_3           | 10014831      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014832-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014832-3_3           | 10014832      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014833-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014833-3_3           | 10014833      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014834-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014834-3_3           | 10014834      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014835-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014835-3_3           | 10014835      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014836-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014836-3_3           | 10014836      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014837-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014837-3_3           | 10014837      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014838-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014838-3_3           | 10014838      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014839-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014839-3_3           | 10014839      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014840-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014840-3_3           | 10014840      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014841-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014841-3_3           | 10014841      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014842-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014842-3_3           | 10014842      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014843-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014843-3_3           | 10014843      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014844-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014844-3_3           | 10014844      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014845-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014845-3_3           | 10014845      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014846-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014846-3_3           | 10014846      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014847-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014847-3_3           | 10014847      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014848-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014848-3_3           | 10014848      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014849-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014849-3_3           | 10014849      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014850-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014850-3_3           | 10014850      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014851-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014851-3_3           | 10014851      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014852-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014852-3_3           | 10014852      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014853-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014853-3_3           | 10014853      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014854-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014854-3_3           | 10014854      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014855-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014855-3_3           | 10014855      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014856-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014856-3_3           | 10014856      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014857-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014857-3_3           | 10014857      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014858-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014858-3_3           | 10014858      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014859-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014859-3_3           | 10014859      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014860-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014860-3_3           | 10014860      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014861-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014861-3_3           | 10014861      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014862-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014862-3_3           | 10014862      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014863-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014863-3_3           | 10014863      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014864-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014864-3_3           | 10014864      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014865-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014865-3_3           | 10014865      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014866-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014866-3_3           | 10014866      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014867-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014867-3_3           | 10014867      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014868-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014868-3_3           | 10014868      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014869-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014869-3_3           | 10014869      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014870-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014870-3_3           | 10014870      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014871-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014871-3_3           | 10014871      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014872-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014872-3_3           | 10014872      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014873-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014873-3_3           | 10014873      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014874-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014874-3_3           | 10014874      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014875-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014875-3_3           | 10014875      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014876-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014876-3_3           | 10014876      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014877-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014877-3_3           | 10014877      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014878-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014878-3_3           | 10014878      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014879-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014879-3_3           | 10014879      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014880-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014880-3_3           | 10014880      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014881-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014881-3_3           | 10014881      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014882-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014882-3_3           | 10014882      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014883-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014883-3_3           | 10014883      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014884-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014884-3_3           | 10014884      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014885-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014885-3_3           | 10014885      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014886-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014886-3_3           | 10014886      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014887-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014887-3_3           | 10014887      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014888-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014888-3_3           | 10014888      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014889-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014889-3_3           | 10014889      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014890-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014890-3_3           | 10014890      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014891-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014891-3_3           | 10014891      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014892-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014892-3_3           | 10014892      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014893-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014893-3_3           | 10014893      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014894-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014894-3_3           | 10014894      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014895-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014895-3_3           | 10014895      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014896-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014896-3_3           | 10014896      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014897-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014897-3_3           | 10014897      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014898-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014898-3_3           | 10014898      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014899-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014899-3_3           | 10014899      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014900-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014900-3_3           | 10014900      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014901-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014901-3_3           | 10014901      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014902-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014902-3_3           | 10014902      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014903-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014903-3_3           | 10014903      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014904-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014904-3_3           | 10014904      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014905-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014905-3_3           | 10014905      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014906-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014906-3_3           | 10014906      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014907-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014907-3_3           | 10014907      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014908-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014908-3_3           | 10014908      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014909-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014909-3_3           | 10014909      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014910-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014910-3_3           | 10014910      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014911-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014911-3_3           | 10014911      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014912-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014912-3_3           | 10014912      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014913-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014913-3_3           | 10014913      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014914-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014914-3_3           | 10014914      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014915-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014915-3_3           | 10014915      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014916-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014916-3_3           | 10014916      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014917-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014917-3_3           | 10014917      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014918-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014918-3_3           | 10014918      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014919-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014919-3_3           | 10014919      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014920-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014920-3_3           | 10014920      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014921-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014921-3_3           | 10014921      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014922-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014922-3_3           | 10014922      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014923-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014923-3_3           | 10014923      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014924-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014924-3_3           | 10014924      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014925-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014925-3_3           | 10014925      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014926-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014926-3_3           | 10014926      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014927-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014927-3_3           | 10014927      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014928-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014928-3_3           | 10014928      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014929-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014929-3_3           | 10014929      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014930-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014930-3_3           | 10014930      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014931-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014931-3_3           | 10014931      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014932-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014932-3_3           | 10014932      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014933-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014933-3_3           | 10014933      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014934-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014934-3_3           | 10014934      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014935-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014935-3_3           | 10014935      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014936-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014936-3_3           | 10014936      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014937-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014937-3_3           | 10014937      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014938-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014938-3_3           | 10014938      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014939-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014939-3_3           | 10014939      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014940-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014940-3_3           | 10014940      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014941-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014941-3_3           | 10014941      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014942-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014942-3_3           | 10014942      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014943-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014943-3_3           | 10014943      | Furth        | 18ISP           | 1000.00                   |
#    | 1619-AS-2021-10014944-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014944-3_3           | 10014944      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014945-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014945-3_3           | 10014945      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014946-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014946-3_3           | 10014946      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014947-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014947-3_3           | 10014947      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014948-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014948-3_3           | 10014948      | Furth        | 18ISP           | 1000.00                   |
    | 1619-AS-2021-10014949-3_3  | 3_3                    | 1619-AS-2021-Contract-Provider-10014949-3_3           | 10014949      | Furth        | 18ISP           | 1000.00                   |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014800-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014801-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014802-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014803-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014804-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014805-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014806-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014807-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014808-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014809-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014810-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014811-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014812-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014813-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014814-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014815-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014816-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014817-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014818-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014819-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014820-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014821-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014822-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014823-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014824-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014825-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014826-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014827-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014828-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014829-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014830-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014831-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014832-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014833-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014834-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014835-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014836-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014837-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014838-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014839-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014840-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014841-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014842-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014843-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014844-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014845-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014846-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014847-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014848-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014849-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014850-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014851-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014852-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014853-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014854-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014855-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014856-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014857-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014858-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014859-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014860-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014861-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014862-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014863-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014864-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014865-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014866-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014867-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014868-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014869-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014870-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014871-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014872-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014873-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014874-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014875-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014876-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014877-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014878-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014879-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014880-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014881-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014882-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014883-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014884-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014885-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014886-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014887-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014888-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014889-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014890-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014891-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014892-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014893-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014894-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014895-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014896-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014897-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014898-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014899-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014900-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014901-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014902-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014903-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014904-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014905-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014906-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014907-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014908-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014909-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014910-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014911-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014912-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014913-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014914-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014915-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014916-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014917-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014918-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014919-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014920-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014921-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014922-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014923-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014924-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014925-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014926-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014927-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014928-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014929-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014930-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014931-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014932-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014933-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014934-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014935-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014936-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014937-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014938-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014939-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014940-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014941-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014942-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014943-3_3  | 1619-001        | 1000.00          | Payment         |
#    | 1619-AS-2021-10014944-3_3  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014945-3_3  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014946-3_3  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014947-3_3  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014948-3_3  | 1619-001        | 1000.00          | Payment         |
    | 1619-AS-2021-10014949-3_3  | 1619-001        | 1000.00          | Payment         |


    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014800-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014801-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014802-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014803-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014804-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014805-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014806-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014807-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014808-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014809-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014810-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014811-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014812-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014813-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014814-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014815-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014816-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014817-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014818-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014819-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014820-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014821-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014822-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014823-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014824-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014825-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014826-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014827-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014828-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014829-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014830-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014831-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014832-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014833-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014834-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014835-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014836-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014837-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014838-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014839-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014840-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014841-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014842-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014843-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014844-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014845-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014846-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014847-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014848-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014849-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014850-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014851-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014852-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014853-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014854-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014855-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014856-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014857-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014858-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014859-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014860-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014861-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014862-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014863-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014864-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014865-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014866-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014867-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014868-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014869-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014870-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014871-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014872-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014873-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014874-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014875-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014876-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014877-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014878-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014879-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014880-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014881-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014882-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014883-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014884-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014885-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014886-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014887-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014888-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014889-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014890-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014891-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014892-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014893-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014894-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014895-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014896-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014897-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014898-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014899-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014900-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014901-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014902-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014903-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014904-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014905-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014906-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014907-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014908-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014909-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014910-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014911-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014912-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014913-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014914-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014915-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014916-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014917-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014918-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014919-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014920-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014921-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014922-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014923-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014924-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014925-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014926-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014927-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014928-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014929-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014930-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014931-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014932-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014933-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014934-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014935-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014936-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014937-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014938-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014939-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014940-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014941-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014942-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014943-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
#    | 1619-AS-2021-10014944-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014945-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014946-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014947-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014948-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |
    | 1619-AS-2021-10014949-3_3  | 1619-001        | FY-2021              | August                 | 2020              | 1000.00                   |


    Then wait '10' seconds

#    When  I retrieve the latest contract details from CRM for provider '10014804' for FundingType 'EDSK' and period '2021'
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#       
#    Then wait '10' seconds
#
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     | CoFG_SPI                   |
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CoFG_SPI]         |
#       
#    Then wait '10' seconds
#    
#
#   # Change the date 
#    Given the override date is '08/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

       
    Then wait '20' seconds

    # Change the date
    Given the override date is '10/06/2021'

    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
    And   the current base CFS config has been loaded

    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 



#    Then wait '120' seconds

        

    # Tidy Up
    Then   the override date is reset
